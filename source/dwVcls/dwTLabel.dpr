library dwTLabel;

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
     case TLabel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     else
               Result    := 'left';
     end;
end;




function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TLabel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    iX,iY   : Integer;
begin
    with TLabel(Actrl) do begin
        //用作可控Label控件----------------------------------------------


        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
             if Assigned(TLabel(ACtrl).OnClick) then begin
                  TLabel(ACtrl).OnClick(TLabel(ACtrl));
             end;
        end else if joData.e = 'onmousedown' then begin
            if Assigned(TLabel(ACtrl).OnMouseDown) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TLabel(ACtrl).OnMouseDown(TLabel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onmouseup' then begin
            if Assigned(TLabel(ACtrl).OnMouseup) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TLabel(ACtrl).OnMouseup(TLabel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onenter' then begin
             if Assigned(TLabel(ACtrl).OnMouseEnter) then begin
                  TLabel(ACtrl).OnMouseEnter(TLabel(ACtrl));
             end;
        end else if joData.e = 'onexit' then begin
             if Assigned(TLabel(ACtrl).OnMouseLeave) then begin
                  TLabel(ACtrl).OnMouseLeave(TLabel(ACtrl));
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
begin
    with TLabel(Actrl) do begin
        //用作可控Label控件----------------------------------------------
        //控制：粗体/颜色/字号/字体


        //<处理PageControl做时间线的问题
        if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
            if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                joRes    := _Json('[]');
                //
                Result    := joRes;
                //
                Exit;
            end;
        end;
        //>


        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TLabel(ACtrl) do begin
            sCode     := '<div '
                    +' class="dwdisselect"'
                    +' id="'+dwFullName(Actrl)+'"'
                    //+dwIIF((Layout=tlCenter)and(WordWrap=True),'',
                    +' v-html="'+dwFullName(Actrl)+'__cap"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    //
                    +' :style="{'
                        +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                        +'color:'+dwFullName(Actrl)+'__fcl,'
                        +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                        +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                        +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                        +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                        +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'
                        +'''text-align'':'+dwFullName(Actrl)+'__fta,'
                        //+dwIIF((Layout=tlCenter)and(WordWrap=False),'''line-height'':'+dwFullName(Actrl)+'__hei,','')
                        //+dwIIF(Layout=tlCenter,'''line-height'':'+dwFullName(Actrl)+'__hei,','')
                        +'left:'+dwFullName(Actrl)+'__lef,'
                        +'top:'+dwFullName(Actrl)+'__top,'
                        +'width:'+dwFullName(Actrl)+'__wid,'
                        +'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    //
                    +' style="position:absolute;'
                    +dwIIF(Layout=tlCenter,'justify-content: center;flex-direction: column;display: flex;','')
                    +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                    //+_GetFont(Font)
                    //style
                    +_GetAlignment(TControl(ACtrl))
                    +dwGetHintStyle(joHint,'radius','border-radius','')
                    +dwGetDWStyle(joHint)
                    +'"'
                    //style 封闭

                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>'
                    //+'{{'+dwFullName(Actrl)+'__cap}}'
                    //以下是标题
                    //+dwIIF(ParentBidiMode,'{{'+dwFullName(Actrl)+'__cap}}','')
                    //+dwIIF(ParentBidiMode,'{{'+dwFullName(Actrl)+'__cap}}','')
                    ;
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
     with TLabel(Actrl) do begin
           //用作可控Label控件----------------------------------------------


           //<处理PageControl做时间线的问题
           if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
                if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                     joRes    := _Json('[]');
                     //
                     Result    := joRes;
                     //
                     Exit;
                end;
           end;
           //>

           //生成返回值数组
           joRes    := _Json('[]');
           //生成返回值数组
           joRes.Add('</div>');
           //
           Result    := (joRes);
     end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TLabel(Actrl) do begin
           //用作可控Label控件----------------------------------------------


           //<处理PageControl做时间线的问题
           if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
                if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                     joRes    := _Json('[]');
                     //
                     Result    := joRes;
                     //
                     Exit;
                end;
           end;
           //>
           //生成返回值数组
           joRes    := _Json('[]');
           //
           with TLabel(ACtrl) do begin
                joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
                joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
                joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
                joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
                //
                joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
                joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
                //
                joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
                //
                if TLabel(ACtrl).Transparent then begin
                    joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
                end else begin
                    joRes.Add(dwFullName(Actrl)+'__col:"'+dwColor(TLabel(ACtrl).Color)+'",');
                end;
                //
                joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
                joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
                joRes.Add(dwFullName(Actrl)+'__ffm:"'+Font.Name+'",');
                joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
                joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
                joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');
                joRes.Add(dwFullName(Actrl)+'__fta:"'+_GetTextAlignment(TLabel(ACtrl))+'",');
           end;
           //
           Result    := (joRes);
     end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TLabel(Actrl) do begin
           //用作可控Label控件----------------------------------------------


           //<处理PageControl做时间线的问题
           if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
                if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                     joRes    := _Json('[]');
                     //
                     Result    := joRes;
                     //
                     Exit;
                end;
           end;
           //>

           //生成返回值数组
           joRes    := _Json('[]');
           //
           with TLabel(ACtrl) do begin
                joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
                //
                joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
                joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
                //
                joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
                //
                if TLabel(ACtrl).Transparent then begin
                    joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
                end else begin
                    joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwColor(TLabel(ACtrl).Color)+'";');
                end;
                //
                joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+dwColor(Font.Color)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fsz="'+IntToStr(Font.size+3)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__ffm="'+Font.Name+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fwg="'+_GetFontWeight(Font)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fsl="'+_GetFontStyle(Font)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__ftd="'+_GetTextDecoration(Font)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fta="'+_GetTextAlignment(TLabel(ACtrl))+'";');
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

