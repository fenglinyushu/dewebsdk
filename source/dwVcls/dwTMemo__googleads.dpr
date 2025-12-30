library dwTMemo__googleads;

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
    joHint  : Variant;
    joRes   : Variant;
begin
    joRes   := _json('[]');

    //取得HINT对象JSON
    //<script async src="https://pagead2.googlesyndication.com/pagead/js/adsbygoogle.js?client=ca-pub-8698255600561309"    crossorigin="anonymous"></script>
    joHint    := dwGetHintJson(TControl(ACtrl));
    if joHint.Exists('uses') then begin
        joRes.Add(joHint.uses);
    end;
    Result  := joRes;
end;



//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
    with TMemo(ACtrl) do begin
        //
        joData    := _Json(AData);

    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    joHint      : Variant;
    joRes       : Variant;
    iItem       : Integer;
begin
    with TMemo(ACtrl) do begin
        //===============================================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));



        //
        sCode   := '<el-main'
                +' id="'+dwFullName(Actrl)+'"'
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'left:'+dwFullName(Actrl)+'__lef,top:'+dwFullName(Actrl)+'__top,width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei'
                +'}"'
                +' style="'
                    +'position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';'
                    +'overflow:hidden;'
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>';
        //添加到返回值数据
        joRes.Add(sCode);

        //添加内容ins
        for iItem := 0 to Lines.Count-1 do begin
            joRes.Add(Lines[iItem]);
        end;

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
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-main>');
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
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        Result    := (joRes);
    end;
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joHint    : Variant;
    joRes     : Variant;
begin
    try
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        // (adsbygoogle = window.adsbygoogle || []).push({});
        if joHint.Exists('push') then begin
            joRes.Add(joHint.push);
        end;
        //
        Result    := (joRes);
    except

    end;
end;



exports
     dwGetMounted,
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
