library dwTLabel__cool;

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
var
    joRes   : Variant;
begin
    joRes   := _json('[]');
    //
    joRes.Add('<style>'
            +'.dwcool0{'
                +'-webkit-text-stroke: 1px black;'
                +'-webkit-text-fill-color : transparent;'
            +'}'
            +'.dwcool1{'
                +'text-shadow: 1px 1px black, -1px -1px black, 1px -1px black, -1px 1px black;'
            +'}'
            +'.dwcool2{'
                +'text-shadow:  0 0 2px hsl(40, 28.57% , 28.82%),0 0 2px hsl(40, 28.57% , 28.82%), 0 0 2px hsl(40, 28.57% , 28.82%);'
            +'}'
            +'.dwcool3{'
                +'text-shadow:0px 1px 0px #c0c0c0,'
                +'0px 2px 0px #b0b0b0,'
                +'0px 3px 0px #a0a0a0,'
                +'0px 4px 0px #909090,'
                +'0px 5px 10px rgba(0, 0, 0, .9);'
            +'}'
            +'.dwcool4{'
                +'font-size: 30px;'
                +'color: #fefefe;'
                +'text-shadow: 0 0 0.5em #0ae642, 0 0 0.2em #5c5c5c;'
            +'}'
            +'.dwcool5{'
                +'background: linear-gradient(to right, red, blue);'
                +'-webkit-background-clip: text;'
                +'color: transparent;'
            +'}'
            +'.dwcool6{'
                +'text-shadow: 0 0 0.5em #0ae642, 0 0 0.2em #5c5c5c;'
                +'animation: change 3s linear 0s infinite;'
            +'}'
            +'@keyframes change {'
                +'0% {color: #FF0000;}'
                +'35%{color: #00FF00;}'
                +'70% {color: #0000FF;}'
                +'100% {color: #000000;}'
            +'}'
            +'.dwcool7{'
                +'text-shadow: 0px 0px #992400, 1px 1px rgba(152, 36, 1, 0.98), '
                +'2px 2px rgba(151, 37, 2, 0.96), 3px 3px rgba(151, 37, 2, 0.94), '
                +'4px 4px rgba(150, 37, 3, 0.92), 5px 5px rgba(149, 38, 4, 0.9), '
                +'6px 6px rgba(148, 38, 5, 0.88), 7px 7px rgba(148, 39, 5, 0.86), '
                +'8px 8px rgba(147, 39, 6, 0.84), 9px 9px rgba(146, 39, 7, 0.82), '
                +'10px 10px rgba(145, 40, 8, 0.8), 11px 11px rgba(145, 40, 8, 0.78), '
                +'12px 12px rgba(144, 41, 9, 0.76), 13px 13px rgba(143, 41, 10, 0.74), '
                +'14px 14px rgba(142, 41, 11, 0.72), 15px 15px rgba(142, 42, 11, 0.7), '
                +'16px 16px rgba(141, 42, 12, 0.68), 17px 17px rgba(140, 43, 13, 0.66), '
                +'18px 18px rgba(139, 43, 14, 0.64), 19px 19px rgba(138, 43, 15, 0.62), '
                +'20px 20px rgba(138, 44, 15, 0.6), 21px 21px rgba(137, 44, 16, 0.58), '
                +'22px 22px rgba(136, 45, 17, 0.56), 23px 23px rgba(135, 45, 18, 0.54), '
                +'24px 24px rgba(135, 45, 18, 0.52), 25px 25px rgba(134, 46, 19, 0.5);'
            +'}'

            +'.dwcool8{'
                +'text-shadow:'
                    +'0 0 10px #0ebeff,'
                    +'0 0 20px #0ebeff,'
                    +'0 0 50px #0ebeff,'
                    +'0 0 100px #0ebeff,'
                    +'0 0 200px #0ebeff'
            +'}'
            +'.dwcool9{'
                +'position: relative;'
                +'color: transparent;'
                +'background-color: #E8A95B;'
                +'background-clip: text;'
            +'}'
            +'dwcool9::after {'
                +'content: attr(data-text);'
                +'background-image: linear-gradient(120deg, transparent 0%, transparent 6rem, white 11rem, '
                    +'transparent 11.15rem, transparent 15rem, rgba(255, 255, 255, 0.3) 20rem, '
                    +'transparent 25rem, transparent 27rem, rgba(255, 255, 255, 0.6) 32rem, white 33rem, '
                    +'rgba(255, 255, 255, 0.3) 33.15rem, transparent 38rem, transparent 40rem, '
                    +'rgba(255, 255, 255, 0.3) 45rem, transparent 50rem, transparent 100%);'
                +'background-clip: text;'
                +'background-size: 150% 100%;'
                +'background-repeat: no-repeat;'
                +'animation: shine 5s infinite linear;'
            +'}'
            +'@keyframes shine {'
                +'0% {background-position: 50% 0;}'
                +'100% {background-position: -190% 0;}'
            +'}'

            +'</style>');
    //
    Result    := joRes;
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
                    +' class="dwcool'+IntToStr(HelpContext)+'"'
                    +' id="'+dwFullName(Actrl)+'"'
                    //+dwIIF((Layout=tlCenter)and(WordWrap=True),'',
                    +' v-html="'+dwFullName(Actrl)+'__cap"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    //
                    +' :style="{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'

                    +dwIIF(HelpContext<>5,'color:'+dwFullName(Actrl)+'__fcl,','')
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
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;

begin
end.

