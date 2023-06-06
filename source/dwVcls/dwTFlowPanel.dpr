library dwTFlowPanel;

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

function _GetFont(AFont:TFont):string;
begin

    Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size+3)+'px;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;

function _GetFontWeight(AFont:TFont):String;
begin
     if fsBold in AFont.Style then begin
          Result    := 'bold';
     end else begin
          Result    := 'normal';
     end;

end;
function _GetFontStyle(AFont:TFont):String;
begin
     if fsItalic in AFont.Style then begin
          Result    := 'italic';
     end else begin
          Result    := 'normal';
     end;
end;
function _GetTextDecoration(AFont:TFont):String;
begin
     if fsUnderline in AFont.Style then begin
          Result    :='underline';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end else begin
               Result    := 'none';
          end;
     end;
end;
function _GetTextAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TFlowPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     end;
end;




function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TFlowPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;

//==================================================================================================

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
    with TFlowPanel(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
            TFlowPanel(ACtrl).OnClick(TFlowPanel(ACtrl));
        end else if joData.e = 'onenter' then begin
            TFlowPanel(ACtrl).OnEnter(TFlowPanel(ACtrl));
        end else if joData.e = 'onexit' then begin
            TFlowPanel(ACtrl).OnExit(TFlowPanel(ACtrl));
        end;
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
    with TFlowPanel(ACtrl) do begin
        //===============================================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //进入事件代码--------------------------------------------------------
        sEnter  := '';
        if joHint.Exists('onenter') then begin
            sEnter  := String(joHint.onenter);
        end;
        if sEnter='' then begin
            if Assigned(OnEnter) then begin
                 sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnEnter) then begin
                 sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',TForm(Owner).Handle])
            end else begin
                 sEnter    := ' @mouseenter.native="'+sEnter+'"';
            end;
        end;


        //退出事件代码--------------------------------------------------------
        sExit  := '';
        if joHint.Exists('onexit') then begin
            sExit  := String(joHint.onexit);
        end;
        if sExit='' then begin
            if Assigned(OnExit) then begin
                 sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnExit) then begin
                 sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',TForm(Owner).Handle])
            end else begin
                 sExit    := ' @mouseleave.native="'+sExit+'"';
            end;
        end;

        //单击事件代码--------------------------------------------------------
        sClick    := '';
        if joHint.Exists('onclick') then begin
            sClick := String(joHint.onclick);
        end;
        //
        if sClick='' then begin
            if Assigned(OnClick) then begin
                 sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnClick) then begin
                 sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',TForm(Owner).Handle])
            end else begin
                 sClick    := ' @click.native="'+sClick+'"';
            end;
        end;


        //
        sCode   := '<el-main'
                +' id="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')
                //+dwGetHintValue(joHint,'icon','icon','')
                +' :style="{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                    //Font
                    +'color:'+dwFullName(Actrl)+'__fcl,'
                    +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                    +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                    +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                    +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                    +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'

                    +'transform:''rotateZ({'+dwFullName(Actrl)+'__rtz}deg)'','
                    +'left:'+dwFullName(Actrl)+'__lef,top:'+dwFullName(Actrl)+'__top,width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}"'
                    //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                    +' style="position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';overflow:hidden;'
                    +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +sClick
                +sEnter
                +sExit
                +'>';
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
    with TFlowPanel(ACtrl) do begin
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
    with TFlowPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TFlowPanel(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            if TFlowPanel(ACtrl).Color = clNone then begin
                joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(dwFullName(Actrl)+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
            end;
            //
            joRes.Add(dwFullName(Actrl)+'__rtz:30,');
            //
            joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(dwFullName(Actrl)+'__ffm:"'+Font.Name+'",');
            joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
begin
    with TFlowPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TFlowPanel(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            if TFlowPanel(ACtrl).Color = clNone then begin
                joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
            end;
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fsz="'+IntToStr(Font.size+3)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__ffm="'+Font.Name+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__ftd="'+_GetTextDecoration(Font)+'";');
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
 
