library dwTEdit__label;
{
    说明:
    主要用于多个输入情况下, 带标签的输入框
}

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     Math,
     SysUtils,
     Vcl.StdCtrls,
     Vcl.ExtCtrls,
     Classes,
     Dialogs,
     Windows,
     Controls,
     Forms, Messages, Variants,  Graphics,ComCtrls;


//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData     : Variant;
     oChange    : Procedure(Sender:TObject) of Object;
     iKey       : Word;
     cKey       : Char;
begin
    //
    joData    := _Json(AData);


    if joData.e = 'onenter' then begin
        if Assigned(TEdit(ACtrl).OnEnter) then begin
            TEdit(ACtrl).OnEnter(TEdit(ACtrl));
        end;
    end else if joData.e = 'onchange' then begin
        //保存事件
        oChange   := TEdit(ACtrl).OnChange;
        //清空事件,以防止自动执行
        TEdit(ACtrl).OnChange  := nil;
        //更新值
        TEdit(ACtrl).Text    := dwUnescape(dwUnescape(joData.v));
        //恢复事件
        TEdit(ACtrl).OnChange  := oChange;

        //执行事件
        if Assigned(TEdit(ACtrl).OnChange) then begin
            TEdit(ACtrl).OnChange(TEdit(ACtrl));
        end;
    end else if joData.e = 'onclear' then begin
        //保存事件
        oChange   := TEdit(ACtrl).OnChange;
        //清空事件,以防止自动执行
        TEdit(ACtrl).OnChange  := nil;
        //更新值
        TEdit(ACtrl).Text    := '';
        //恢复事件
        TEdit(ACtrl).OnChange  := oChange;

        //执行事件
        if Assigned(TEdit(ACtrl).OnChange) then begin
            TEdit(ACtrl).OnChange(TEdit(ACtrl));
        end;

    end else if joData.e = 'onexit' then begin
        if Assigned(TEdit(ACtrl).OnExit) then begin
            TEdit(ACtrl).OnExit(TEdit(ACtrl));
        end;
    end else if joData.e = 'onclick' then begin
        if Assigned(TEdit(ACtrl).Onclick) then begin
            TEdit(ACtrl).Onclick(TEdit(ACtrl));
        end;
    end else if joData.e = 'onkeydown' then begin
        if Assigned(TEdit(ACtrl).OnKeyDown) then begin
            iKey    := StrToIntDef(joData.v,0);
            TEdit(ACtrl).OnKeyDown(TEdit(ACtrl),iKey,[]);//Chr(StrToIntDef(joData.v,32)));
        end;
    end else if joData.e = 'onkeyup' then begin
        if Assigned(TEdit(ACtrl).OnKeyup) then begin
            iKey    := StrToIntDef(joData.v,0);
            TEdit(ACtrl).OnKeyup(TEdit(ACtrl),iKey,[]);//Chr(StrToIntDef(joData.v,32)));
        end;
    end else if joData.e = 'onkeypress' then begin
        if Assigned(TEdit(ACtrl).OnKeyPress) then begin
            cKey  := Chr(StrToIntDef(joData.v,0));
            TEdit(ACtrl).OnKeyPress(TEdit(ACtrl),cKey);//Chr(StrToIntDef(joData.v,32)));
        end;
    end else if joData.e = 'onmouseenter' then begin
        if Assigned(TEdit(ACtrl).OnMouseEnter) then begin
            TEdit(ACtrl).OnMouseEnter(TEdit(ACtrl));
        end;
    end else if joData.e = 'onmouseexit' then begin
        if Assigned(TEdit(ACtrl).OnMouseLeave) then begin
            TEdit(ACtrl).OnMouseLeave(TEdit(ACtrl));
        end;
    end;
end;

function _GetAlign(AHint:Variant):String;
var
    sAlign  : String;
begin
    sAlign  := dwGetStr(AHint,'align','left');
    if sAlign = 'right' then begin
        Result  := 'text-align: right;';
    end else begin
        Result  := ''
    end;
end;

function _AlignmentToStr(AAlign:TAlignment):String;
begin
    //计算alignment
    case AAlign of
        taCenter : begin
            Result  := 'text-align: center;'
        end;
        taRightJustify : begin
            Result  := 'text-align: right;'
        end;
    else
            Result  := 'text-align: left;'
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sPosition   : string;   //above/left, 后期可扩展支持below和right
    sType       : String;   //主要用于输入多种类型, 默认string
    //
    joHint      : Variant;
    joRes       : Variant;
    //
    iLabelW     : Integer;  //position为left时的宽度, 默认为80;否则为当前width, 可以通过"labelwidth":100设置
    iLabelH     : Integer;  //position为above时的度度, 默认为height/2;否则为当前height, "labelheight":20设置
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //取得全名备用
    sFull   := dwFullName(Actrl);


    //
    with TEdit(ACtrl) do begin

        //根据位置取得类型和w/h
        sType   := dwGetStr(joHint,'position','left');
        if sType = 'above' then begin
            iLabelW := Width;
            iLabelH := dwGetInt(joHint,'labelheight',height div 2);
        end else begin
            iLabelW := dwGetInt(joHint,'labelwidth',80);
            iLabelH := Height;
        end;

        //添加标签Label的代码-------------------------------------------------------------------------------------------
        sCode   :=
        '<div '
            +dwVisible(TControl(ACtrl))
            +' v-html="'+sFull+'__cap"'
            //
            +' :style="{'
                +'left:'+sFull+'__llf,'
                +'top:'+sFull+'__ltp,'
                +'width:'+sFull+'__lwd,'
                +'height:'+sFull+'__lhi'
            +'}"'

            //
            +' style="'
                +'position:absolute;'
                +'caret-color: transparent;'    //隐藏光标
                +'justify-content: center;flex-direction: column;display: flex;'
                +_GetAlign(joHint)
            +'"'

            //
            +'>'
        +'</div>';


        //添加编辑框Edit的代码------------------------------------------------------------------------------------------

        //
        sCode     := sCode +
        '<el-input'
            +' id="'+sFull+'"'
            +dwVisible(TControl(ACtrl))
            +dwDisable(TControl(ACtrl))
            +' :readonly="'+sFull+'__rdo"'
            +dwIIF(PasswordChar=#0,'',' show-password')            //是否为密码
            +dwIIF(dwGetInt(joHint,'clear',0)=1, ' clearable','')
            +' v-model="'+sFull+'__txt"'                            //前置
            +dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,提示语
            +dwGetHintValue(joHint,'prefix-icon','prefix-icon','') //前置Icon
            +dwGetHintValue(joHint,'suffix-icon','suffix-icon','') //后置Icon
            +dwGetDWAttr(joHint)
            //                            //Left/Top/Width/Height
            +' :style="{'
                //
                +'left:'+sFull+'__elf,'
                +'top:'+sFull+'__etp,'
                +'width:'+sFull+'__ewd,'
                +'height:'+sFull+'__ehi'
            +'}"'
            +' style="position:absolute;'
                +'border:1px solid #DCDFE6;'
                +'border-radius:2px;'
                +_AlignmentToStr(Alignment)
                +'overflow: hidden;'
                +dwGetDWStyle(joHint)
            +'"' // 封闭style
            //+' onclick="this.dwevent('''','''+Name+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''')"'
            +dwIIF(Assigned(OnClick),     Format(_DWEVENT,['click.native',     Name,'0','onclick', TForm(Owner).Handle]),'')
            +dwIIF(Assigned(OnKeyDown),   Format(_DWEVENT,['keydown.native',   Name,'event.keyCode','onkeydown', TForm(Owner).Handle]),'')
            +dwIIF(Assigned(OnKeyUp),     Format(_DWEVENT,['keyup.native',     Name,'event.keyCode','onkeyup',   TForm(Owner).Handle]),'')
            +dwIIF(Assigned(OnKeyPress),  Format(_DWEVENT,['keypress.native',  Name,'event.keyCode','onkeypress',TForm(Owner).Handle]),'')
            +Format(_DWEVENT,['input',Name,'escape(this.'+sFull+'__txt)','onchange',TForm(Owner).Handle]) //绑定事件
            +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter',TForm(Owner).Handle]),'')
            +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit',TForm(Owner).Handle]),'')
            +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',            Name,'0','onenter',TForm(Owner).Handle]),'')
            +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',             Name,'0','onexit',TForm(Owner).Handle]),'')
            //
            +dwIIF(dwGetInt(joHint,'clear',0)=1, Format(_DWEVENT,['clear', Name,'0','onclear',TForm(Owner).Handle]),'')
            +'>'
        +'</el-input>';


        //添加到返回值数据
        joRes.Add(sCode);
    end;
    //
    Result    := (joRes);
end;


//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    //
    sFull       : string;
    sType       : String;   //主要用于输入多种类型, 默认string
    //
    iLabelW     : Integer;  //position为left时的宽度, 默认为80;否则为当前width, 可以通过"labelwidth":100设置
    iLabelH     : Integer;  //position为above时的度度, 默认为height/2;否则为当前height, "labelheight":20设置
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得全名备用
    sFull   := dwFullName(ACtrl);
    //
    with TEdit(ACtrl) do begin

        //根据位置取得类型和w/h
        sType   := dwGetStr(joHint,'position','left');
        if sType = 'above' then begin
            iLabelW := Width;
            iLabelH := dwGetInt(joHint,'labelheight',height div 2);
            //
            joRes.Add(sFull+'__elf:"'+IntToStr(Left+5)+'px",');
            joRes.Add(sFull+'__etp:"'+IntToStr(Top+iLabelH)+'px",');
            joRes.Add(sFull+'__ewd:"'+IntToStr(Width-10)+'px",');
            joRes.Add(sFull+'__ehi:"'+IntToStr(Height-iLabelH)+'px",');
            //
            joRes.Add(sFull+'__llf:"'+IntToStr(Left+5)+'px",');
            joRes.Add(sFull+'__ltp:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__lwd:"'+IntToStr(iLabelW-10)+'px",');
            joRes.Add(sFull+'__lhi:"'+IntToStr(iLabelH)+'px",');
        end else begin
            iLabelW := dwGetInt(joHint,'labelwidth',80);
            iLabelH := Height;
            //
            joRes.Add(sFull+'__elf:"'+IntToStr(Left+iLabelW)+'px",');
            joRes.Add(sFull+'__etp:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__ewd:"'+IntToStr(Width-iLabelW)+'px",');
            joRes.Add(sFull+'__ehi:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__llf:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__ltp:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__lwd:"'+IntToStr(iLabelW)+'px",');
            joRes.Add(sFull+'__lhi:"'+IntToStr(iLabelH)+'px",');
        end;

        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(sFull+'__rdo:'+dwIIF(ReadOnly,'true,','false,'));
        //
        joRes.Add(sFull+'__cap:"'+dwProcessCaption(TextHint)+'",');
        joRes.Add(sFull+'__txt:"'+dwChangeChar(Text)+'",');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;  //__eventcomponent
    sEventComp  : String;
    sFull       : string;
    sType       : String;   //主要用于输入多种类型, 默认string
    //
    iLabelW     : Integer;  //position为left时的宽度, 默认为80;否则为当前width, 可以通过"labelwidth":100设置
    iLabelH     : Integer;  //position为above时的度度, 默认为height/2;否则为当前height, "labelheight":20设置
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得全名备用
    sFull   := dwFullName(ACtrl);

    //得到事件源控件
    joHint  := dwGetHintJson(TControl(ACtrl));
    sEventComp  := '';
    if joHint.Exists('__eventcomponent') then begin
        sEventComp  := LowerCase(joHint.__eventcomponent);
    end;

    //
    with TEdit(ACtrl) do begin

        //根据位置取得类型和w/h
        sType   := dwGetStr(joHint,'position','left');
        if sType = 'above' then begin
            iLabelW := Width;
            iLabelH := dwGetInt(joHint,'labelheight',height div 2);
            //
            joRes.Add('this.'+sFull+'__elf="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__etp="'+IntToStr(Top+iLabelH)+'px";');
            joRes.Add('this.'+sFull+'__ewd="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__ehi="'+IntToStr(Height-iLabelH)+'px";');
            //
            joRes.Add('this.'+sFull+'__llf="'+IntToStr(Left+5)+'px";');
            joRes.Add('this.'+sFull+'__ltp="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__lwd="'+IntToStr(iLabelW-10)+'px";');
            joRes.Add('this.'+sFull+'__lhi="'+IntToStr(iLabelH)+'px";');
        end else begin
            iLabelW := dwGetInt(joHint,'labelwidth',80);
            iLabelH := Height;
            //
            joRes.Add('this.'+sFull+'__elf="'+IntToStr(Left+iLabelW)+'px";');
            joRes.Add('this.'+sFull+'__etp="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__ewd="'+IntToStr(Width-iLabelW)+'px";');
            joRes.Add('this.'+sFull+'__ehi="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__llf="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__ltp="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__lwd="'+IntToStr(iLabelW)+'px";');
            joRes.Add('this.'+sFull+'__lhi="'+IntToStr(iLabelH)+'px";');
        end;

        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__rdo='+dwIIF(ReadOnly,'true;','false;'));
        //
        joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(TextHint)+'";');

        //如果当前是事件源控件，则不处理
        if (sEventComp <> sFull) or (TEdit(ACtrl).DoubleBuffered = True) then begin
            joRes.Add('this.'+sFull+'__txt="'+dwChangeChar(Text)+'";');
        end else begin
            joRes.Add('');
        end;
    end;
    //
    Result    := (joRes);
end;


exports
     dwGetEvent,
     dwGetHead,
     dwGetAction,
     dwGetData;
     
begin
end.
 
