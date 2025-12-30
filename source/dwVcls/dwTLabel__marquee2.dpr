library dwTLabel__marquee2;

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
    joHint  : Variant;
    sFull   : String;
    iSecond : Integer;
begin
    joRes   := _json('[]');
    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //得到秒数
    iSecond := dwGetInt(joHint,'second',5);

    //
    with TLabel(ACtrl) do begin
        if ParentBIDIMode then begin
            //从右向左滚动
            joRes.Add(
            '<style>'#13#10
                +'.marquee2 {'#13#10
                +'  overflow: hidden;'#13#10
                +'}'#13#10
                +''#13#10
                +'.marquee2 .marquee2-wrap {'#13#10
                +'  width: 100%;'#13#10
                +'  animation: marquee2-wrap '+IntToStr(iSecond)+'s infinite linear;'#13#10
                +'}'#13#10
                +''#13#10
                +'.marquee2 .marquee2-content {'#13#10
                +'  float: left;'#13#10
                +'  white-space: nowrap;'#13#10
                +'  min-width: 100%;'#13#10
                +'  animation: marquee2-content '+IntToStr(iSecond)+'s infinite linear;'#13#10
                +'}'#13#10
                +''#13#10
                +'@keyframes marquee2-wrap {'#13#10
                +'  0%,'#13#10
                +'  30% {'#13#10
                +'    transform: translateX(0);'#13#10
                +'  }'#13#10
                +'  70%,'#13#10
                +'  100% {'#13#10
                +'    transform: translateX(100%);'#13#10
                +'  }'#13#10
                +'}'#13#10
                +''#13#10
                +'@keyframes marquee2-content {'#13#10
                +'  0%,'#13#10
                +'  30% {'#13#10
                +'    transform: translateX(0);'#13#10
                +'  }'#13#10
                +'  70%,'#13#10
                +'  100% {'#13#10
                +'    transform: translateX(-100%);'#13#10
                +'  }'#13#10
                +'}'
            +'</style>');
        end else begin
            //从右向左滚动
            joRes.Add(
            '<style>'#13#10
                +'.marquee2 {'#13#10
                +'  overflow: hidden;'#13#10
                +'}'#13#10
                +''#13#10
                +'.marquee2 .marquee2-wrap {'#13#10
                +'  width: 100%;'#13#10
                +'  animation: marquee2-wrap '+IntToStr(iSecond)+'s infinite linear;'#13#10
                +'}'#13#10
                +''#13#10
                +'.marquee2 .marquee2-content {'#13#10
                +'  float: left;'#13#10
                +'  white-space: nowrap;'#13#10
                +'  min-width: 100%;'#13#10
                +'  animation: marquee2-content '+IntToStr(iSecond)+'s infinite linear;'#13#10
                +'}'#13#10
                +''#13#10
                +'@keyframes marquee2-wrap {'#13#10
                +'  0%,'#13#10
                +'  30% {'#13#10
                +'    transform: translateX(0);'#13#10
                +'  }'#13#10
                +'  70%,'#13#10
                +'  100% {'#13#10
                +'    transform: translateX(100%);'#13#10
                +'  }'#13#10
                +'}'#13#10
                +''#13#10
                +'@keyframes marquee2-content {'#13#10
                +'  0%,'#13#10
                +'  30% {'#13#10
                +'    transform: translateX(0);'#13#10
                +'  }'#13#10
                +'  70%,'#13#10
                +'  100% {'#13#10
                +'    transform: translateX(-100%);'#13#10
                +'  }'#13#10
                +'}'
            +'</style>');
        end;
    end;
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
    sCode   : string;
    sFull   : string;
    joHint  : Variant;
    joRes   : Variant;
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
        joRes   := _Json('[]');

        //取得HINT对象JSON
        joHint  := dwGetHintJson(TControl(ACtrl));

        //
        sFull   := dwFullName(ACtrl);

        with TLabel(ACtrl) do begin
            sCode   :=
                    '<div'
                    +' class="item marquee2"'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    //
                    +' :style="{'
                        +'backgroundColor:'+sFull+'__col,'
                        +'color:'+sFull+'__fcl,'
                        +'''font-size'':'+sFull+'__fsz,'
                        +'''font-family'':'+sFull+'__ffm,'
                        +'''font-weight'':'+sFull+'__fwg,'
                        +'''font-style'':'+sFull+'__fsl,'
                        +'''text-decoration'':'+sFull+'__ftd,'
                        +'''text-align'':'+sFull+'__fta,'
                        +'left:'+sFull+'__lef,'
                        +'top:'+sFull+'__top,'
                        +'width:'+sFull+'__wid,'
                        +'height:'+sFull+'__hei'
                    +'}"'
                    //
                    +' style="position:absolute;'
                        +'line-height: '+IntToStr(Height)+'px;'#13#10
                        +'overflow: hidden;'
                        +dwIIF(Assigned(OnClick),'cursor: pointer;','')
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
                    +'>'#13#10
                        +'<div class="marquee2-wrap">'
                            +'<div class="marquee2-content ">'
(*
                            +'<div '
                            +' id="'+sFull+'"'
                            //+' class="marquee2-container"'
                            //+dwIIF((Layout=tlCenter)and(WordWrap=True),'',
                            +dwVisible(TControl(ACtrl))
                            +dwDisable(TControl(ACtrl))
                            +dwGetDWAttr(joHint)
                            //
                            +' :style="{'
                                +'backgroundColor:'+sFull+'__col,'
                                +'color:'+sFull+'__fcl,'
                                +'''font-size'':'+sFull+'__fsz,'
                                +'''font-family'':'+sFull+'__ffm,'
                                +'''font-weight'':'+sFull+'__fwg,'
                                +'''font-style'':'+sFull+'__fsl,'
                                +'''text-decoration'':'+sFull+'__ftd,'
                                +'''text-align'':'+sFull+'__fta,'
                                +'left:'+sFull+'__lef,'
                                +'top:'+sFull+'__top,'
                                +'width:'+sFull+'__wid,'
                                +'height:'+sFull+'__hei'
                            +'}"'
                            //
                            +' style="position:absolute;'
                                +'overflow: hidden;'
                                //+dwIIF(Layout=tlCenter,'justify-content: center;flex-direction: column;display: flex;','')
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
                            +'>'#13#10
                                +'<span>'#13#10
*)
                                    +'{{'+sFull+'__cap}}'#13#10
(*                                +'</span>'#13#10
                                //以下是标题
                                //+dwIIF(ParentBidiMode,'{{'+sFull+'__cap}}','')
                                //+dwIIF(ParentBidiMode,'{{'+sFull+'__cap}}','')
                            +'</div>'
*)
                            +'</div>'
                        +'</div>'
                    +'</div>'
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
    joRes  : Variant;
    sFull  : String;
begin
    //
    sFull   := dwFullName(ACtrl);
    with TLabel(Actrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        //joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes  : Variant;
    sFull  : String;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TLabel(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TLabel(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
            //
            if TLabel(ACtrl).Transparent then begin
                joRes.Add(sFull+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(sFull+'__col:"'+dwColor(TLabel(ACtrl).Color)+'",');
            end;
            //
            joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
            joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');
            joRes.Add(sFull+'__fta:"'+_GetTextAlignment(TLabel(ACtrl))+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes  : Variant;
     sFull  : String;
begin
    //
    sFull   := dwFullName(ACtrl);
    with TLabel(Actrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TLabel(ACtrl) do begin
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
            //
            if TLabel(ACtrl).Transparent then begin
                joRes.Add('this.'+sFull+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+sFull+'__col="'+dwColor(TLabel(ACtrl).Color)+'";');
            end;
            //
            joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
            joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
            joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
            joRes.Add('this.'+sFull+'__fta="'+_GetTextAlignment(TLabel(ACtrl))+'";');
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

