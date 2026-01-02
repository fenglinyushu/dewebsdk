library dwTCard__page;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Math,Vcl.WinXPanels, Vcl.WinXCtrls,
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
begin
    with TCardPanel(TCard(Actrl).CardPanel) do begin
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iCtrl     : Integer;
     oMemo     : TMemo;
     iLine     : Integer;
     sFull      : String;
begin
    sFull       := dwFullName(ACtrl);
    with TCardPanel(TCard(Actrl).CardPanel) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TCard(ACtrl) do begin
            sCode   := '<el-main'
                    +' id="'+sFull+'"'
                    +' v-show="'+LowerCase(dwPrefix(Actrl)+CardPanel.Name)+'__apg=='''+sFull+'''"'
                    +dwDisable(TControl(ACtrl))
                    +dwGetHintValue(joHint,'icon','icon','')
                    +dwGetDWAttr(joHint)
                    +' :style="{'
                            +'backgroundColor:'+sFull+'__col,'
                            +'left:'+sFull+'__lef,'
                            +'top:'+sFull+'__top,'
                            +'width:'+sFull+'__wid,'
                            +'height:'+sFull+'__hei'
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        //+'height:100%;'
                        +'overflow:hidden;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    //+dwIIF(Assigned(OnShow),Format(_DWEVENT,['tab-click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);
        end;
        //
        Result    := (joRes);
    end;

end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
    with TCardPanel(TCard(Actrl).CardPanel) do begin
        //用作Tabs控件-----------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-main>');
        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sKeyword    : String;
    sFull       : String;
begin
    //用作Tabs控件----------------------------------------------------------------------------
    sFull       := dwFullName(ACtrl);
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TCard(ACtrl) do begin
        joRes.Add(sFull+'__lef:"0px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top-40)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add(sFull+'__col:"rgba(0,0,0,0)",');
        end else begin
            joRes.Add(sFull+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
        end;
        //
        joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sKeyword    : String;
    sFull       : String;
begin
    sFull       := dwFullName(ACtrl);
    //用作Tabs控件----------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TCard(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top-40)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(CardVisible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add('this.'+sFull+'__col="rgba(0,0,0,0)";');
        end else begin
            joRes.Add('this.'+sFull+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
        end;
        //
        joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
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

