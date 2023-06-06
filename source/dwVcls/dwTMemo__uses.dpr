library dwTMemo__uses;
{
功能说明：
    该控件仅用于增加引用的JS/css，类似在生成的HTML中的增加以下引用：
    <script src="dist/axios.min.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="dist/theme-chalk/index.css" />
    <script src="dist/_easyplayer/EasyPlayer-element.min.js"></script>

用法：
    在设计阶段把需要引用的代码文件按以上格式写入到Memo的Lines中

}
uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,


     //
     SysUtils,
     Classes,
     Dialogs,
     Windows,
     Controls,
     Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Forms;

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes       : Variant;
    I           : Integer;
begin
    with TMemo(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');


        //需要额外引的代码
        for I := 0 to Lines.Count-1 do begin
            joRes.Add(Lines[I]);//'<script src="dist/_yimen/jsbridge-mini.js"></script>');
        end;
        //
        Result    := joRes;

    end;
end;

function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
begin
end;

function dwGetHead(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

function dwGetTail(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

function dwGetData(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

function dwGetAction(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;

begin
end.
 
