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
var
     joData    : Variant;
begin
    with TTabSheet(Actrl) do begin
        //
        joData    := _Json(AData);

        //
        if joData = unassigned then begin
            Exit;
        end;
        if not joData.Exists('e') then begin
            Exit;
        end;

        if joData.e = 'onclick' then begin
            //
            if Assigned(OnEnter) then begin
                OnEnter(TTabSheet(Actrl));
            end;
        end;
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
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TTabSheet(ACtrl) do begin
            sCode   := '<el-main'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' v-show="'+LowerCase(dwPrefix(Actrl)+PageControl.Name)+'__apg=='''+dwFullName(Actrl)+'''"'
                    +dwDisable(TControl(ACtrl))
                    +dwGetHintValue(joHint,'icon','icon','')
                    +dwGetDWAttr(joHint)
                    +' :style="{'
                            +'left:'+dwFullName(Actrl)+'__lef,'
                            +'top:'+dwFullName(Actrl)+'__ttp,'
                            +'width:'+dwFullName(Actrl)+'__wid,'
                            +'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        //+'height:100%;'
                        //禁止选择
                        +'user-select: none;'
                        +'overflow:hidden;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['tab-click',Name,'0','onclick',TForm(Owner).Handle]),'')
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
    joRes     : Variant;
    sKeyword  : String;
begin
    //用作Tabs控件----------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        if PageControl.TabPosition = tpLeft then begin
            joRes.Add(dwFullName(Actrl)+'__lef:"0px",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        end;
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
        joRes.Add(dwFullName(Actrl)+'__ttp:"4px",');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sKeyword  : String;
begin
    //用作Tabs控件----------------------------------------------------------------------------

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TTabSheet(ACtrl) do begin
        if PageControl.TabPosition = tpLeft then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="0px";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
        end;
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
        //修正可能存在的高度过大问题
        if Height > PageControl.Height - 40 then begin
            Height  := PageControl.Height - 40;
        end;
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(TabVisible,'true;','false;'));
        joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
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

