library dwTShape__canvas;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,
     Buttons,
     ExtCtrls,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes   : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
begin

     //
     result    := '[]';
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;

begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(Actrl);

    //
    with TShape(ACtrl) do begin
        //
        sCode   := '<canvas'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +dwLTWH(TControl(ACtrl))
                +'position:absolute;'
                +dwGetDWStyle(joHint)
                +'"'
                +'>';
    end;
    joRes.Add(sCode);

    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</canvas>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
begin

    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');
     //
     with TShape(ACtrl) do begin
          joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
     end;
     //
     Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sFull   : string;
begin

    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes   := _Json('[]');
    //
    with TShape(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        //joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        //joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('document.getElementById("'+sFull+'").width = '+IntToStr(Width)+';');
        joRes.Add('document.getElementById("'+sFull+'").height = '+IntToStr(Height)+';');

        //joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        //joRes.Add('this.'+dwFullName(Actrl)+'__typ="'+dwGetProp(TShape(ACtrl),'type')+'";');
    end;
    //
    Result    := (joRes);
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    sCode   : string;
    sFull   : string;
begin

    //
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes   := _Json('[]');
    //
    with TShape(ACtrl) do begin
        sCode   :=
        sFull+'__c = document.getElementById("'+sFull+'");'#13#10
        +sFull+'__ctx = '+sFull+'__c.getContext("2d");'#13#10;
        //
        joRes.Add(sCode);
    end;
    //
    Result    := joRes;
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
 
