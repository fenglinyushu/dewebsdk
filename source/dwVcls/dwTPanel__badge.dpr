library dwTPanel__badge;
{
    本模块用于解析DataV系统的dv-border-box-13
}


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



//=====================以上为辅助函数===============================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes: Variant;
begin
     //生成返回值数组
    joRes := _Json('[]');
    //
    //joRes.Add('<script src="dist/_datav/datav.min.vue.js"></script>');
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    iX,iY   : Integer;
begin
    with TPanel(Actrl) do begin

        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
             if Assigned(TPanel(ACtrl).OnClick) then begin
                  TPanel(ACtrl).OnClick(TPanel(ACtrl));
             end;
        end else if joData.e = 'onmousedown' then begin
            if Assigned(TPanel(ACtrl).OnMouseDown) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TPanel(ACtrl).OnMouseDown(TPanel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onmouseup' then begin
            if Assigned(TPanel(ACtrl).OnMouseup) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TPanel(ACtrl).OnMouseup(TPanel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onenter' then begin
             if Assigned(TPanel(ACtrl).OnMouseEnter) then begin
                  TPanel(ACtrl).OnMouseEnter(TPanel(ACtrl));
             end;
        end else if joData.e = 'onexit' then begin
             if Assigned(TPanel(ACtrl).OnMouseLeave) then begin
                  TPanel(ACtrl).OnMouseLeave(TPanel(ACtrl));
             end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    joHint  : Variant;
    joRes   : Variant;
    sId     : string;
begin
    with TPanel(Actrl) do begin


        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TPanel(ACtrl) do begin
            //
            sCode     := '<el-badge'
                    +' class="item"'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' :value="'+dwFullName(Actrl)+'__cap"'
                    +' :type="'+dwFullName(Actrl)+'__typ"'
                    +dwGetDWAttr(joHint)
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'"' // 封闭style
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
    joRes   : Variant;
    sId     : string;
begin
    with TPanel(Actrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-badge>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sType       : String;
begin
    with TPanel(Actrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TPanel(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            //
            joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
            //
            sType   := dwGetProp(TPanel(ACtrl),'type');
            if sType = '' then begin
                joRes.Add(dwFullName(Actrl)+'__typ:"'+'danger'+'",');
            end else begin
                joRes.Add(dwFullName(Actrl)+'__typ:"'+sType+'",');
            end
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sType       : string;
begin
    with TPanel(Actrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

        //生成返回值数组
        joRes    := _Json('[]');
            //
            with TPanel(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
            //
            sType   := dwGetProp(TPanel(ACtrl),'type');
            if sType = '' then begin
                joRes.Add('this.'+dwFullName(Actrl)+'__typ="danger";');
            end else begin
                joRes.Add('this.'+dwFullName(Actrl)+'__typ="'+sType+'";');
            end;
        end;
        //
        Result    := (joRes);
    end;
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

