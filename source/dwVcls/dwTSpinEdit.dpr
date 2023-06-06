library dwTSpinEdit;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Spin,
     StdCtrls, Windows;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     joData    := _json(AData);


     //保存事件
     TSpinEdit(ACtrl).OnExit    := TSpinEdit(ACtrl).OnChange;
     //清空事件,以防止自动执行
     TSpinEdit(ACtrl).OnChange  := nil;
     //更新值
     TSpinEdit(ACtrl).Value        := (joData.v);
     //恢复事件
     TSpinEdit(ACtrl).OnChange  := TSpinEdit(ACtrl).OnExit;

     //执行事件
     if Assigned(TSpinEdit(ACtrl).OnChange) then begin
          TSpinEdit(ACtrl).OnChange(TSpinEdit(ACtrl));
     end;

     //清空OnExit事件
     TSpinEdit(ACtrl).OnExit  := nil;
end;

//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode     : string;
    joHint    : Variant;
    joRes     : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TSpinEdit(ACtrl) do begin
        if ( maxvalue =  0 ) and  ( maxvalue =  0 ) then begin
            joRes.Add('<el-input-number'
                        +' id="'+dwFullName(Actrl)+'"'
                        +' v-model="'+dwFullName(Actrl)+'__val"'
                        +dwIIF(not Ctl3D,'',' controls-position="right"')
                        +' :step="'+dwFullName(Actrl)+'__stp"'
                        +dwVisible(TControl(ACtrl))
                        +dwDisable(TControl(ACtrl))
                        +dwGetDWAttr(joHint)
                        +' :style="{'
                            +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                            +'left:'+dwFullName(Actrl)+'__lef,'
                            +'top:'+dwFullName(Actrl)+'__top,'
                            +'width:'+dwFullName(Actrl)+'__wid,'
                            +'height:'+dwFullName(Actrl)+'__hei'
                        +'}"'
                        +' style="position:absolute;'
                            +dwGetDWStyle(joHint)
                        +'"' //style 封闭
                        +Format(_DWEVENT,['change',Name,'(this.'+dwFullName(Actrl)+'__val)','onchange',TForm(Owner).Handle])
                        +'>');
        end else begin
            joRes.Add('<el-input-number'
                +' id="'+dwFullName(Actrl)+'"'
                +' v-model="'+dwFullName(Actrl)+'__val"'
                +' :min="'+dwFullName(Actrl)+'__min"'
                +' :max="'+dwFullName(Actrl)+'__max"'
                +' :step="'+dwFullName(Actrl)+'__stp"'
                +dwIIF(not Ctl3D,'',' controls-position="right"')
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                //
                +' :style="{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                    +'left:'+dwFullName(Actrl)+'__lef,'
                    +'top:'+dwFullName(Actrl)+'__top,'
                    +'width:'+dwFullName(Actrl)+'__wid,'
                    +'height:'+dwFullName(Actrl)+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                //
                +Format(_DWEVENT,['change',Name,'(this.'+dwFullName(Actrl)+'__val)','onchange',TForm(Owner).Handle])
                +'>');
        end;
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
     joRes.Add('</el-input-number>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TSpinEdit(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(dwFullName(Actrl)+'__val:'+IntToStr(Value)+',');
        joRes.Add(dwFullName(Actrl)+'__min:'+IntToStr(MinValue)+',');
        joRes.Add(dwFullName(Actrl)+'__max:'+IntToStr(MaxValue)+',');
        joRes.Add(dwFullName(Actrl)+'__stp:'+IntToStr(Increment)+',');
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

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint      : Variant;  //__eventcomponent
    sEventComp  : String;
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
    with TSpinEdit(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));

        //如果当前是事件源控件，则不处理
        if (sEventComp <> dwFullName(Actrl)) or (TControl(ACtrl).ParentCustomHint=False) then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__val='+IntToStr(Value)+';');
        end else begin
            joRes.Add('');
        end;

        //
        joRes.Add('this.'+dwFullName(Actrl)+'__min='+IntToStr(MinValue)+';');
        joRes.Add('this.'+dwFullName(Actrl)+'__max='+IntToStr(MaxValue)+';');
        joRes.Add('this.'+dwFullName(Actrl)+'__stp='+IntToStr(Increment)+';');
        //
        if Color = clNone then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
        end;
    end;
    //
    Result    := (joRes);
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
