library dwTTabSheet__timeline;

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
    joHint      : Variant;
    joRes       : Variant;
    oTab        : TTabsheet;
    sFull       : string;
    sType       : string;
    sSize       : String;
begin
    //
    sFull   := dwFullName(Actrl);

    //
    with TPageControl(TTabSheet(Actrl).PageControl) do begin

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //取得当前tab
        oTab    := TTabSheet(ACtrl);

        //
        sType   := '';
        if joHint.Exists('type') then begin
            sType   := ' type="'+dwGetStr(joHint,'type')+'"';
        end;

        //
        sSize   := '';
        if joHint.Exists('size') then begin
            sSize   := ' size="'+dwGetStr(joHint,'size')+'"';
        end;

        //
        joRes.Add('<el-timeline-item '
                +' id="'+sFull+'"'
                +' v-show="'+sFull+'__vis"'
                +dwIIF(oTab.ImageIndex>0,'icon="'+dwIcons[Max(1,oTab.ImageIndex)]+'"','')
                +sType
                +sSize
                +dwGetHintValue(joHint,'color','color','')
                +' timestamp="'+oTab.Caption+'"'
                +' placement="top"'
                //+' style="'
                //    +'height:'+IntToStr(dwGetInt(joHint,'height',100))+'px;'
                //+'"'
                +'>');

        //是否带框
        if ParentBiDiMode = True then begin
            joRes.Add('<el-card style="overflow:hidden;height:'+IntToStr(dwGetInt(joHint,'height',100))+'px;width:95%;">');
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

        //生成返回值数组
        joRes    := _Json('[]');
        //
        if ParentBiDiMode = True then begin
            joRes.Add('</el-card>');
        end;
        joRes.Add('</el-timeline-item>');

        //
        Result    := (joRes);
    end;
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    //生成返回值数组
    joRes       := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(0)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(0)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(TabVisible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(TabVisible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
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

