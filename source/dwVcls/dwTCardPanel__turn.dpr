library dwTCardPanel__turn;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows, Vcl.WinXPanels;

//--------------一些自用函数------------------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    sCode   : String;
    joRes   : Variant;
begin
     //生成返回值数组
    joRes   := _Json('[]');

    //
    sCode   := '<script src="dist/_jquery/jquery.min.js"></script>';
    joRes.Add(sCode);

    //
    sCode   := '<script src="dist/_turn/turn.min.js"></script>';
    joRes.Add(sCode);

    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
    with TPageControl(Actrl) do begin
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sEdit       : string;   //增减TTabSheet的处理代码
    joHint      : Variant;
    joRes       : Variant;
    joTabHint   : Variant;
    iTab        : Integer;
    sFull       : String;
begin
    //
    sFull       := dwFullName(Actrl);

    //
    with TCardPanel(Actrl) do begin
       //用作翻书效果控件-------------------------------------------------
       (*
        <div id="flipbook">
            <div class="hard"> Turn.js </div>
            <div class="hard"></div>
            <div> Page 1 </div>
            <div> Page 2 </div>
            <div> Page 3 </div>
            <div> Page 4 </div>
            <div class="hard"></div>
            <div class="hard"></div>
        </div>
        <script type="text/javascript">
            $("#flipbook").turn({
                width: 400,
                height: 300,
                autoCenter: true
            });
        </script>
       *)

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TCardPanel(ACtrl) do begin
            //为其TabSheet赋值HelpKeyword,以保持一致性
            for iTab := 0 to CardCount-1 do begin
                Cards[iTab].HelpKeyword := HelpKeyword;
            end;

            //外框
            joRes.Add('<div'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style 封闭
                    +' style="'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>');

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
    with TCardPanel(Actrl) do begin
        //用作翻书效果控件-------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //body框
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sFull       : String;
begin
    //
    sFull       := dwFullName(Actrl);

    //
    with TCardPanel(Actrl) do begin
        //用作翻书效果控件-------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //joRes.Add(sFull+'__apg:"'+LowerCase(dwPrefix(Actrl)+ActivePage.Name)+'",');
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : String;
    sCode       : string;
begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    with TCardPanel(Actrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));

        //
        sCode   :=
                '$("#'+sFull+'").turn({'
                    +'width: '+IntToStr(Width)+','
                    +'height: '+IntToStr(Height)+','
                    +'acceleration: '+dwGet01Bool(joHint,'acceleration','true')+','
                    +'autoCenter: '+dwGet01Bool(joHint,'autocenter','false')+','
                    +'direction: "'+dwGetStr(joHint,'direction','ltr')+'",'
                    +'display: "'+dwGetStr(joHint,'display','double')+'",'
                    +'gradients: '+dwGet01Bool(joHint,'gradients','true')+','
                    +'pages: '+IntToStr(CardCount)+','
                    +'disable: '+dwGet01Bool(joHint,'disable','false')
                +'});'
                ;
        //joRes.Add(sCode);
        //
        Result    := joRes;
    end;
end;

function dwGetMounted(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    joRes       : Variant;
    joHint      : Variant;
begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    //此处应修改为最新的token
    with TCardPanel(ACtrl) do begin
        sCode   :=
                '$("#'+sFull+'").turn({'
                    +'width: '+IntToStr(Width)+','
                    +'height: '+IntToStr(Height)+','
                    +'acceleration: '+dwGet01Bool(joHint,'acceleration','true')+','
                    +'autoCenter: '+dwGet01Bool(joHint,'autocenter','false')+','
                    +'direction: "'+dwGetStr(joHint,'direction','ltr')+'",'
                    +'display: "'+dwGetStr(joHint,'display','double')+'",'
                    +'gradients: '+dwGet01Bool(joHint,'gradients','true')+','
                    +'pages: '+IntToStr(CardCount)+','
                    +'disable: '+dwGet01Bool(joHint,'disable','false')
                +'});'
                ;
        //joRes.Add(sCode);
    end;
    //
    Result   := joRes;
end;



exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetMounted,
    dwGetData;
     
begin
end.
 
