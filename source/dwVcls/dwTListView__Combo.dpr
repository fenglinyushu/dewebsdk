library dwTListView__Combo;

uses
  ShareMem,
  dwCtrlBase,
  SynCommons,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  StdCtrls,
  Windows;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    sValue  : String;
    I       : Integer;
    oChange : Procedure(Sender: TObject; Item: TListItem; Change: TItemChange) of Object;
begin
    //
    joData    := _Json(AData);

    with TListView(ACtrl) do begin
        if joData.e = 'onchange' then begin

            //保存事件
            oChange := TListView(ACtrl).OnChange;
            //清空事件,以防止自动执行
            OnChange  := nil;

            //更新值
            sValue    := dwUnescape(joData.v);
                for I := 0 to TListView(ACtrl).Items.Count-1 do begin
                    if sValue = TListView(ACtrl).Items[I].Caption then begin
                        TListView(ACtrl).ItemIndex  := I;
                        break;
                    end;
                end;
            //恢复事件
            OnChange  := oChange;

            //执行事件
            if Assigned(OnChange) then begin
                OnChange(TListView(ACtrl),Items[ItemIndex],ctText);
            end;

        end else if joData.e = 'onblur' then begin
{
            //更新值
            sValue    := dwUnescape(joData.v);
            if sValue <> '' then begin
                //保存事件
                oChange := OnChange;
                //清空事件,以防止自动执行
                OnChange  := nil;

                //保证空字符的传递
                if (sValue = '[!empty!]') or (sValue = '__empty__') or (sValue = 'undefined') then begin
                    sValue  := 'Text';
                end;


                    for I := 0 to Items.Count-1 do begin
                        if sValue = Items[I].Caption then begin
                            TListView(ACtrl).ItemIndex  := I;
                            break;
                        end;
                    end;
                //恢复事件
                OnChange  := oChange;

                //执行事件
                if Assigned(OnChange) then begin
                    OnChange(TListView(ACtrl),nil,ctText);
                end;

            end;
}
        end else if joData.e = 'ondropdown' then begin
            if joData.v = 'true' then begin
            end else if joData.v = 'false' then begin
            end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    iCol    : Integer;
    sCode   : string;
    sBlur   : String;
    sFull   : String;
    joHint  : Variant;
    joRes   : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TListView(ACtrl) do begin
        //得到名称备用
        sFull   := dwFullName(Actrl);

        //生成blur时的代码， 主要用于解决可输入可选择功能
        sBlur   := ' @blur = "'+sFull+'__blur"';
        sBlur   := sBlur + ' @keydown.enter.native = "'+sFull+'__blur"';

        //
        joRes.Add('<el-select'
                +' id="'+sFull+'"'
                +' ref="'+sFull+'"'
                +' v-model="'+sFull+'__txt"'
                //+dwIIF(Style=csDropDown,' filterable','')
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'backgroundColor:'+sFull+'__col,'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +'border:1px solid #DCDFF0;'
                    +'border-radius:3px;'
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetHintStyle(joHint,'backgroundcolor','background-color','')       //自定义背景色
                    +dwGetHintStyle(joHint,'color','color','')             //自定义字体色
                    +dwGetHintStyle(joHint,'fontsize','font-size','')      //自定义字体大小
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                //+dwIIF(Style=csDropDown,sBlur,'')
                +sBlur
                //+dwIIF(Assigned(OnDropDown) OR Assigned(OnCloseUp),'@visible-change="dwevent($event,'''+sFull+''',$event,''ondropdown'','''')"','')
                +Format(_DWEVENT,['change',sFull,'this.'+sFull+'__txt','onchange',TForm(Owner).Handle])
                +'>');
        joRes.Add('<el-option v-for="item in '+sFull+'__its" :key="item.value" :label="item.value" :value="item.value">');
        //
        joRes.Add('<span style="display : inline-block; width:'+IntToStr(Columns[0].Width)+'px;">{{ item.value }}</span>');
        for iCol := 1 to Columns.Count-1 do begin
            joRes.Add('<span style="display : inline-block;width:'+IntToStr(Columns[iCol].Width)+'px;">{{ item.col'+IntToStr(iCol)+' }}</span>');
        end;
        //
        joRes.Add('</el-option>');
    end;

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-select>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : string;
     iItem     : Integer;
     iCol      : Integer;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TListView(ACtrl) do begin
        //添加选项
        sCode     := dwFullName(Actrl)+'__its:[';
        for iItem := 0 to Items.Count-1 do begin
             sCode     := sCode + '{value:'''+Items[iItem].Caption+'''';
             for iCol := 1 to Columns.Count-1 do begin
                sCode     := sCode + ',col'+IntToStr(iCol)+':'''+Items[iItem].SubItems[iCol-1]+'''';
             end;
             sCode     := sCode + '},';
        end;
        if Items.Count>0 then begin
             Delete(sCode,Length(sCode),1);     //删除最后的逗号
        end;
        sCode     := sCode + '],';
        joRes.Add(sCode);

        //
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        if dwGetProp(TControl(ACtrl),'height')='' then begin
             joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        end else begin
             joRes.Add(dwFullName(Actrl)+'__hei:"'+dwGetProp(TControl(ACtrl),'height')+'px",');
        end;
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        if ItemIndex < 0 then begin
            joRes.Add(dwFullName(Actrl)+'__txt:"'+''+'",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__txt:"'+Items[ItemIndex].Caption+'",');
        end;
        //
        if Color = clNone then begin
            joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
        end;
    end;
    //
    Result    := (joRes);
end;

//取得Method
function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sCode       : string;
    sEventComp  : string;       //用于读取事件发起控件名称
    iItem       : Integer;
    iCol        : Integer;
    joHint      : Variant;  //__eventcomponent
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //得到事件源控件
    joHint  := dwGetHintJson(TControl(ACtrl.Owner));
    sEventComp  := '';
    if joHint.Exists('__eventcomponent') then begin
        sEventComp  := LowerCase(joHint.__eventcomponent);
    end;

    //
    with TListView(ACtrl) do begin
        //添加选项
        sCode     := 'this.'+dwFullName(Actrl)+'__its=[';
        for iItem := 0 to Items.Count-1 do begin
             sCode     := sCode + '{value:'''+Items[iItem].Caption+'''';
             for iCol := 1 to Columns.Count-1 do begin
                sCode     := sCode + ',col'+IntToStr(iCol)+':'''+Items[iItem].SubItems[iCol-1]+'''';
             end;
             sCode     := sCode + '},';
        end;
        if Items.Count>0 then begin
             Delete(sCode,Length(sCode),1);     //删除最后的逗号
        end;
        sCode     := sCode + '];';
        joRes.Add(sCode);
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        if dwGetProp(TControl(ACtrl),'height')='' then begin
             joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        end else begin
             joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+dwGetProp(TControl(ACtrl),'height')+'px";');
        end;
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //如果当前是事件源控件，则不处理
        //if (sEventComp <> dwFullName(Actrl)) or (TControl(ACtrl).ParentCustomHint=False) then begin
            //joRes.Add('this.'+dwFullName(Actrl)+'__txt="'+Text+'";');
        //end else begin
        //    joRes.Add('');
        //end;

        //
        if ItemIndex < 0 then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__txt="'+''+'";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__txt="'+Items[ItemIndex].Caption+'";');
        end;
        //
        if Color = clNone then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
        end;
    //
    end;
    Result    := (joRes);
end;

function dwGetMethods(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sFull   : string;
    //
    joRes   : variant;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    with TListView(ACtrl) do begin
        sCode   := sFull + '__blur(e){'
                    //+'console.log("onblur");'
                    +'this.'+sFull+'__txt = e.target.value;'
                    +'this.$forceUpdate();'
                    +'__empty__ = "__empty__";'
                    +'if(e.target.value == ""){'
                        +'this.dwevent(null,"'+sFull+'","__empty__",''onblur'','''+IntToStr(TForm(Owner).Handle)+''');'
                    +'}else{'
                        +'this.dwevent(null,"'+sFull+'",''this.'+sFull+'__txt'',''onblur'','''+IntToStr(TForm(Owner).Handle)+''');'
                    +'};'
                    //+'this.$refs.'+sFull+'.visible = false;' //隐藏下拉框
                +'},';
        joRes.Add(sCode);
    end;

    //
    Result  := joRes;
end;

exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;
     
begin
end.
 
