library dwTMemo__dvflyline;

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


function _GetConfig(ACtrl:TComponent):string;
var
    iRow    : Integer;
begin
    with TMemo(ACtrl) do begin
        Result  := Lines.Text;
    end;

end;


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes: Variant;
begin
     //生成返回值数组
    joRes := _Json('[]');
    //
    joRes.Add('<script src="dist/_datav/datav.min.vue.js"></script>');
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
     sText     : string;
begin
{
    with TMemo(ACtrl) do begin
        //
        joData    := _Json(AData);


        if joData.e = 'onenter' then begin
            if Assigned(TMemo(ACtrl).OnEnter) then begin
                TMemo(ACtrl).OnEnter(TMemo(ACtrl));
            end;
        end else if joData.e = 'onchange' then begin
            //保存事件
            oChange   := TMemo(ACtrl).OnChange;
            //清空事件,以防止自动执行
            TMemo(ACtrl).OnChange  := nil;
            TMemo(ACtrl).Text    := dwWebToText(joData.v);

            //恢复事件
            TMemo(ACtrl).OnChange  := oChange;

            //执行事件
            if Assigned(TMemo(ACtrl).OnChange) then begin
               TMemo(ACtrl).OnChange(TMemo(ACtrl));
            end;
        end else if joData.e = 'onexit' then begin
            if Assigned(TMemo(ACtrl).OnExit) then begin
                TMemo(ACtrl).OnExit(TMemo(ACtrl));
            end;
        end else if joData.e = 'onmouseenter' then begin
            if Assigned(TMemo(ACtrl).OnMouseEnter) then begin
                TMemo(ACtrl).OnMouseEnter(TMemo(ACtrl));
            end;
        end else if joData.e = 'onmouseexit' then begin
            if Assigned(TMemo(ACtrl).OnMouseLeave) then begin
                TMemo(ACtrl).OnMouseLeave(TMemo(ACtrl));
            end;
        end;
    end;
}
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode     : string;
    joHint    : Variant;
    joRes     : Variant;
    sScroll   : string;
begin
    with TMemo(ACtrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TMemo(ACtrl) do begin
            sCode     := '<dv-flyline-chart-enhanced'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' :config="'+dwFullName(Actrl)+'__cfg"'    //config
                    +dwVisible(TControl(ACtrl))                 //是否可见
                    +dwGetDWAttr(joHint)                        //dwAttr
                    +' :style="{'
                        +'left:'+dwFullName(Actrl)+'__lef,'
                        +'top:'+dwFullName(Actrl)+'__top,'
                        +'width:'+dwFullName(Actrl)+'__wid,'
                        +'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    //
                    +' style="position:absolute;'
                        +dwGetDWStyle(joHint)
                    +'"'
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
    with TMemo(ACtrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</dv-flyline-chart-enhanced>');
        //
        Result    := (joRes);
    end;
end;




//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    iSeries : Integer;
    iX      : Integer;
    //
    joRes   : Variant;
    //
    sDat    : String;
    sGrid   : String;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TMemo(ACtrl) do begin
        //基本数据
        joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
        //
        //
        joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));

        //
        joRes.Add(dwFullName(Actrl)+'__cfg :'+_GetConfig(ACtrl)+',');
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    //
    iRow,iCol : Integer;
    sCode     : String;
begin
    //
    with TMemo(ACtrl) do begin
        //TMemo 用作幸运大抽奖

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));

            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cfg ='+_GetConfig(ACtrl)+';');
        end;

        //
        Result    := (joRes);
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
 
