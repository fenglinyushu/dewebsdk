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
               +'font-size:'+IntToStr(AFont.size)+'pt;';

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
     joData    : Variant;
begin
     with TLabel(Actrl) do begin
          if HelpKeyword = 'rich' then begin
               //用作可控Label控件----------------------------------------------


               //
               joData    := _Json(AData);

               if joData.e = 'onclick' then begin
                    if Assigned(TLabel(ACtrl).OnClick) then begin
                         TLabel(ACtrl).OnClick(TLabel(ACtrl));
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
          end else begin
               //用作普通Label控件----------------------------------------------

               //
               joData    := _Json(AData);

               if joData.e = 'onclick' then begin
                    if Assigned(TLabel(ACtrl).OnClick) then begin
                         TLabel(ACtrl).OnClick(TLabel(ACtrl));
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
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     with TLabel(Actrl) do begin
          if HelpKeyword = 'rich' then begin
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
                              +' v-html="'+dwPrefix(Actrl)+Name+'__cap"'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              //
                              +' :style="{'
                                   +'color:'+dwPrefix(Actrl)+Name+'__fcl,'
                                   +'''font-size'':'+dwPrefix(Actrl)+Name+'__fsz,'
                                   +'''font-family'':'+dwPrefix(Actrl)+Name+'__ffm,'
                                   +'''font-weight'':'+dwPrefix(Actrl)+Name+'__fwg,'
                                   +'''font-style'':'+dwPrefix(Actrl)+Name+'__fsl,'
                                   +'''text-decoration'':'+dwPrefix(Actrl)+Name+'__ftd,'
                                   +'''text-align'':'+dwPrefix(Actrl)+Name+'__fta,'
                                   +'left:'+dwPrefix(Actrl)+Name+'__lef,'
                                   +'top:'+dwPrefix(Actrl)+Name+'__top,'
                                   +'width:'+dwPrefix(Actrl)+Name+'__wid,'
                                   +'height:'+dwPrefix(Actrl)+Name+'__hei'
                                   +'}"'
                              //
                              +'style="position:absolute;'
                              //+_GetFont(Font)
                              //style
                              +_GetAlignment(TControl(ACtrl))
                              +dwIIF(Layout=tlCenter,'line-height:'+IntToStr(Height)+'px;','')
                              +'"'
                              //style 封闭

                              +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                              +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                              +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                              +'>{{'+dwPrefix(Actrl)+Name+'__cap}}';
                    //添加到返回值数据
                    joRes.Add(sCode);
               end;
               //
               Result    := (joRes);
          end else begin
               //用作普通Label控件----------------------------------------------

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
                              +' v-html="'+dwPrefix(Actrl)+Name+'__cap"'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +dwLTWH(TControl(ACtrl))
                              +_GetFont(Font)
                              //style
                              +_GetAlignment(TControl(ACtrl))
                              +dwIIF(Layout=tlCenter,'line-height:'+IntToStr(Height)+'px;','')
                              +'"'
                              //style 封闭

                              +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                              +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                              +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                              +'>{{'+dwPrefix(Actrl)+Name+'__cap}}';
                    //添加到返回值数据
                    joRes.Add(sCode);
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TLabel(Actrl) do begin
          if HelpKeyword = 'rich' then begin
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
          end else begin
               //用作普通Label控件----------------------------------------------

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
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TLabel(Actrl) do begin
          if HelpKeyword = 'rich' then begin
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
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__fcl:"'+dwColor(Font.Color)+'",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__fsz:"'+IntToStr(Font.size)+'pt",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__ffm:"'+Font.Name+'",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__fwg:"'+_GetFontWeight(Font)+'",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__fsl:"'+_GetFontStyle(Font)+'",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__ftd:"'+_GetTextDecoration(Font)+'",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__fta:"'+_GetTextAlignment(TLabel(ACtrl))+'",');
               end;
               //
               Result    := (joRes);
          end else begin
               //用作普通Label控件----------------------------------------------

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
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TLabel(Actrl) do begin
          if HelpKeyword = 'rich' then begin
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
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__fcl="'+dwColor(Font.Color)+'";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__fsz="'+IntToStr(Font.size)+'pt";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__ffm="'+Font.Name+'";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__fwg="'+_GetFontWeight(Font)+'";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__fsl="'+_GetFontStyle(Font)+'";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__ftd="'+_GetTextDecoration(Font)+'";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__fta="'+_GetTextAlignment(TLabel(ACtrl))+'";');
               end;
               //
               Result    := (joRes);
          end else begin
               //用作普通Label控件----------------------------------------------

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
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;
     
begin
end.
 
