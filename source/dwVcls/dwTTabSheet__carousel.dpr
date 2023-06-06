library dwTTabSheet;

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
begin
     with TPageControl(TTabSheet(Actrl).PageControl) do begin
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
begin
    with TPageControl(TTabSheet(Actrl).PageControl) do begin
        //用作走马灯控件------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TTabSheet(ACtrl) do begin
                sCode     := '<el-carousel-item'
                          +' id="'+dwFullName(Actrl)+'"'
                          //+' :style="{left:'+dwFullName(Actrl)+'__lef,'
                          //      +'top:'+dwFullName(Actrl)+'__top,'
                          //      +'width:'+dwFullName(Actrl)+'__wid,'
                          //      +'height:'+dwFullName(Actrl)+'__hei}"'
                          //+' style="position:absolute;overflow:hidden;'
                          //+'"' //style 封闭
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
    with TPageControl(TTabSheet(Actrl).PageControl) do begin
        //用作走马灯控件---------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-carousel-item>');
        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sKeyword  : String;
begin
    //用作走马灯控件--------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        //joRes.Add(dwFullName(Actrl)+'__lef:"0px",');
        //joRes.Add(dwFullName(Actrl)+'__top:"0px",');
        //joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(TPageControl(Parent).Width)+'px",');
        //joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(TPageControl(Parent).Height)+'px",');
        //
        //joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        //joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
        //joRes.Add(dwFullName(Actrl)+'__ttp:"4px",');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sKeyword  : String;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        //joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        //joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        //joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(TabVisible,'true;','false;'));
        //joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
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

