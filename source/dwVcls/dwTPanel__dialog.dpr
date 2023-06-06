library dwTPanel__dialog;

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
     with TPanel(ACtrl) do begin
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sEnter    : String;
     sExit     : String;
     sClick    : string;
begin
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        sCode     := '<el-dialog :title="'+dwFullName(Actrl)+'__cap" :visible.sync="'+dwFullName(Actrl)+'_vis" >';

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
    sCode     : String;
begin
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        sCode     := '</el-dialog>';

        //添加到返回值数据
        joRes.Add(sCode);
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint    : Variant;
begin
    with TPanel(ACtrl) do begin
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
   joRes   : Variant;
   joHint  : Variant;
begin
    with TPanel(ACtrl) do begin
    end;
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
 
