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
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iCtrl     : Integer;
     oMemo     : TMemo;
     iLine     : Integer;
begin
    with TPageControl(TTabSheet(Actrl).PageControl) do begin
        //用作时间线控件-------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        joRes.Add('<el-timeline-item '
                +' id="'+dwFullName(Actrl)+'"'
                +' v-show="'+dwFullName(Actrl)+'__vis"'
                +dwIIF(TTabSheet(Actrl).ImageIndex>0,'icon="'+dwIcons[Max(1,TTabSheet(Actrl).ImageIndex)]+'"','')
                //+dwGetHintValue(joHint,'type','type','')
                +dwGetHintValue(joHint,'color','color','')
                +' timestamp="'+IntToStr(TTabSheet(Actrl).Tag)+'" placement="top">');

        //是否带框
        if ParentBiDiMode = True then begin
            joRes.Add('<el-card>');
        end;

        //
        joRes.Add('<h4>'+TTabSheet(Actrl).Caption+'</h4>');
        //
        for iCtrl := 0 to TWinControl(Actrl).ControlCount-1 do begin
            if TWinControl(Actrl).Controls[iCtrl].ClassName = 'TLabel' then begin
                //joRes.Add('<p>'+TLabel(TWinControl(Actrl).Controls[iCtrl]).Caption+'</p>');
                joRes.Add('<p>{{'+TLabel(TWinControl(Actrl).Controls[iCtrl]).Name+'__cap}}</p>');
            end else if TWinControl(Actrl).Controls[iCtrl].ClassName = 'TMemo' then begin
                oMemo     := TMemo(TWinControl(Actrl).Controls[iCtrl]);
                for iLine := 0 to oMemo.Lines.Count-1 do begin
                    joRes.Add('<p>'+oMemo.Lines[iLine]+'</p>');
                end;
            end;
        end;

        //
        if ParentBiDiMode = True then begin
            joRes.Add('</el-card>');
        end;
        joRes.Add('</el-timeline-item>');

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
        //用作时间线控件---------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
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
begin
    //用作时间线控件--------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(0)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(0)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(TabVisible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
        //
        for iCtrl := 0 to TWinControl(Actrl).ControlCount-1 do begin
            oControl    := TWinControl(Actrl).Controls[iCtrl];
            if oControl.ClassName = 'TLabel' then begin
                joRes.Add(dwFullName(oControl)+'__cap:"'+dwProcessCaption(TLabel(oControl).Caption)+'",');
            end;
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
begin
    //用作时间线控件--------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(TabVisible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        for iCtrl := 0 to TWinControl(Actrl).ControlCount-1 do begin
            oControl    := TWinControl(Actrl).Controls[iCtrl];
            if oControl.ClassName = 'TLabel' then begin
                joRes.Add('this.'+dwFullName(oControl)+'__cap="'+dwProcessCaption(TLabel(oControl).Caption)+'";');
            end;
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

