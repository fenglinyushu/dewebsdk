library dwTEdit__rate;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Math,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    fValue  : Double;
    oChange : Procedure(Sender:TObject) of Object;
begin
    joData    := _json(AData);


    //保存事件
    oChange     := TEdit(ACtrl).OnChange;
    //清空事件,以防止自动执行
    TEdit(ACtrl).OnChange  := nil;
    //更新值
    TEdit(ACtrl).Text      := (joData.v);
    //
    fValue := StrToFloatDef(TEdit(ACtrl).Text,0);
    fValue := Max(0,Min(5,fValue));
    TEdit(ACtrl).Text      := Format('%.1f',[fValue]);

    //恢复事件
    TEdit(ACtrl).OnChange  := oChange;

    //执行事件
    if Assigned(TEdit(ACtrl).OnChange) then begin
        TEdit(ACtrl).OnChange(TEdit(ACtrl));
    end;

    //清空OnExit事件
    TEdit(ACtrl).OnExit  := nil;
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

    with TEdit(ACtrl) do begin

        joRes.Add('<el-rate'
                +' id="'+dwFullName(Actrl)+'"'
                +' v-model="'+dwFullName(Actrl)+'__val"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwIIF(dwGetInt(joHint,'showscore',0)=1,' show-score text-color="'+dwColor(Font.Color)+'"','')
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
     joRes.Add('</el-rate>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    fValue  : Double;
    oChange : Procedure(Sender:TObject) of Object;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TEdit(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        fValue  := StrToFloatDef(Text,0);
        fValue  := Max(0,Min(5,fValue));
        joRes.Add(dwFullName(Actrl)+'__val:'+System.SysUtils.Format('%.1f',[fValue])+',');

        //更新值
        oChange     := OnChange;
        OnChange    := nil;
        Text        := Format('%.1f',[fValue]);
        OnChange    := oChange;

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
    joRes   : Variant;
    fValue  : Double;
    oChange : Procedure(Sender:TObject) of Object;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TEdit(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        fValue  := StrToFloatDef(Text,0);
        fValue  := Max(0,Min(5,fValue));
        joRes.Add('this.'+dwFullName(Actrl)+'__val='+System.SysUtils.Format('%.1f',[fValue])+';');

        //更新值
        oChange     := OnChange;
        OnChange    := nil;
        Text        := Format('%.1f',[fValue]);
        OnChange    := oChange;

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
 
