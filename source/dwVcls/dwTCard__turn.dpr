library dwTCard__turn;

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
     StdCtrls, Windows,Vcl.WinXPanels;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    joHint  : Variant;
    joRes   : Variant;
    iCtrl   : Integer;
    oMemo   : TMemo;
    iLine   : Integer;
    sFull   : string;
begin
    sFull   := dwFullName(Actrl);
    //
    with TCard(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwGetDWAttr(joHint)
                +dwVisible(TControl(ACtrl))
                +' :style="{'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei,'
                    +'backgroundColor:'+sFull+'__col'
                +'}"'
                +' style="'
                    //+'left:0;'
                    //+'top:0;'
                    //+'width:100%;'
                    //+'height:100;'
                    +dwGetDWStyle(joHint)
                +'"'
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    with TCard(Actrl) do begin
        //用作时间线控件---------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sKeyword    : String;
    oControl    : TControl;
    iCtrl       : Integer;
    sFull       : string;
begin
    sFull   := dwFullName(Actrl);
    //用作时间线控件--------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TCard(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(0)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(0)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(CardVisible,'true,','false,'));
        //joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add(sFull+'__col:"rgba(0,0,0,0)",');
        end else begin
            joRes.Add(sFull+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
        end;
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sKeyword  : String;
    oControl    : TControl;
    iCtrl       : Integer;
    sFull       : string;
begin
    sFull   := dwFullName(Actrl);
    //用作时间线控件--------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TCard(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(CardVisible,'true;','false;'));
        //joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add('this.'+sFull+'__col="rgba(0,0,0,0)";');
        end else begin
            joRes.Add('this.'+sFull+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
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

