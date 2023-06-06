library dwTPanel__Hint;
(*
功能说明：
    该控件用于控制显示悬浮提示Hint
用法：
    1 在界面放置TPanel，设置 HelpKeyword 为 hint.
      修改 高度，推荐 25
      修改 背景色，推荐 $383838
      修改 字体色，推荐 clWhite
      修改 字体大小，推荐 9
    2 需要显示Hint的控件的Hint中增加类似{"dwattr":"hint='this is my hint' dw-hint"}
    3 如果需要修改Hint样式，需要修改本dpr, 并重新build
*)

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;





//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sCode       : string;
begin
    //返回值数组
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    with TPanel(ACtrl) do begin
        sCode   :=
                '<style>'#13+
                '[dw-hint]{'#13+
                    'position: absolute;'#13+
                '}'#13+
                '[dw-hint]:after{'#13+
                    'content: attr(dw-hint);'#13+
                    'position: absolute;'#13+
                    'left: 50%;'#13+
                    'bottom: 100%;'#13+
                    'height:'+IntToStr(Height)+'px;'#13+
                    'line-height:'+IntToStr(Height)+'px;'#13+
                    'transform: translate(-50%,0);'#13+
                    'color: '+dwColor(Font.Color)+';'#13+
                    'text-shadow: 0 -1px 0px black;'#13+
                    'box-shadow: 4px 4px 8px rgba(0, 0, 0, 0.3);'#13+
                    'background: '+dwColor(Color)+';'#13+
                    'border-radius: 2px;'#13+
                    'padding: 3px 10px;'#13+
                    'font-size: '+IntToStr(Font.Size+3)+'px;'#13+
                    'white-space: nowrap;'#13+
                    'transition:all .3s;'#13+
                    'opacity: 0;'#13+
                    'visibility: hidden;'#13+
                '}'#13+
                '[dw-hint]:hover:after{'#13+
                    'transition-delay: 100ms;'#13+
                    'visibility: visible;'#13+
                    'transform: translate(-50%,-6px);'#13+
                    'opacity: 1;'#13+
                '}'#13+
                '</style>';
    end;

    joRes.Add(sCode);

    //
    Result  := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
    with TBalloonHint(ACtrl) do begin
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
begin
    Result    := '[]';
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
begin
    Result    := '[]';
end;




//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
begin
    Result    := '[]';
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
begin
    Result    := '[]';
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    //
    sCode   : string;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');


    sCode   :=
            'function dwHint(){'#13+
                'var dw_hints = document.querySelectorAll("[dw-hint]");'#13+
                'for (var i = 0; i < dw_hints.length; i++){'#13+
                    'dw_hints[i].setAttribute("dw-hint",dw_hints[i].getAttribute("hint"));'#13+
                    'dw_hints[i].removeAttribute("hint");'#13+
                '}'#13+
            '};'#13+
            'dwHint();';
    joRes.Add(sCode);

    //
    Result    := joRes;
end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetMounted,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
