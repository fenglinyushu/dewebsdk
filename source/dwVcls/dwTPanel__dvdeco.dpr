library dwTPanel__dvdeco;
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


//=====================以上为辅助函数===============================================================

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
            sCode     := '<div'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'"' // 封闭style
                    +'>';
            joRes.Add(sCode);

            //得到区分多种效果的值，保存在HelpContext
            case HelpContext of
                1..12 : begin
                    sID := IntToStr(abs(HelpContext));
                end;
                -12..-1 : begin
                    sID := IntToStr(abs(HelpContext));
                end;
            else
                sID := '1';
            end;

            //
            sCode     := '    <dv-decoration-'+sID
                    +dwIIF(HelpContext<0,' :reverse="true"','')
                    //+' class="dwdisselect"'
                    +' id="'+dwFullName(Actrl)+'"'
                    //+dwIIF((Layout=tlCenter)and(WordWrap=True),'',
                    //+' v-html="'+dwFullName(Actrl)+'__cap"'
                    +' :color="['+dwFullName(Actrl)+'__cr1, '+dwFullName(Actrl)+'__cr2]"'
                    +dwGetDWAttr(joHint)
                    +dwIIF(HelpContext in [7,9,11],
                        ' :style="{'
                            //+'backgroundColor:'+dwFullName(Actrl)+'__col,'
                            +'color:'+dwFullName(Actrl)+'__fcl,'
                            +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                            +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                            +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                            +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                            +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'
                            +'''text-align'':'+dwFullName(Actrl)+'__fta,'
                        +'}"',
                        '')
                    //
                    +' style="position:absolute;'
                        +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                        //+'justify-content: center;flex-direction: column;display: flex;'
                        //+'text-align:center;'
                        //+'left:0;'
                        //+'top:0;'
                        //+'width:100%;'
                        //+'height:100%;'
                        //+_GetFont(Font)
                        //style
                        +dwGetDWStyle(joHint)
                    +'"'
                    //style 封闭
(*

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

*)
                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>'
                    //仅效果7，9，11有标题
                    +dwIIF(HelpContext in [7,9,11],'{{'+dwFullName(Actrl)+'__cap}}','')
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
    joRes   : Variant;
    sId     : string;
begin
    with TPanel(Actrl) do begin
        //得到区分多种效果的值，保存在HelpContext
        case HelpContext of
            1..12 : begin
                sID := IntToStr(HelpContext);
            end;
        else
            sID := '1';
        end;

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('    </dv-decoration-'+sID+'>');
        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
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
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
            //
            joRes.Add(dwFullName(Actrl)+'__cr1:"'+dwColor(TPanel(ACtrl).Color)+'",');
            joRes.Add(dwFullName(Actrl)+'__cr2:"'+dwColor(TPanel(ACtrl).Font.Color)+'",');
            //
            if HelpContext in [7,9,11] then begin
                //
                joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
                joRes.Add(dwFullName(Actrl)+'__ffm:"'+Font.Name+'",');
                joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
                joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
                joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');
                joRes.Add(dwFullName(Actrl)+'__fta:"'+_GetTextAlignment(TPanel(ACtrl))+'",');

                if joHint.Exists('fontcolor') then begin
                    joRes.Add(dwFullName(Actrl)+'__fcl:"'+joHint.fontcolor+'",');
                end else begin
                    joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
                end;
            end
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
    joHint      : Variant;
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
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cr1="'+dwColor(TPanel(ACtrl).Color)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__cr2="'+dwColor(TPanel(ACtrl).Font.Color)+'";');
            //
            if HelpContext in [7,9,11] then begin
                //
                joRes.Add('this.'+dwFullName(Actrl)+'__fsz="'+IntToStr(Font.size+3)+'px";');
                joRes.Add('this.'+dwFullName(Actrl)+'__ffm="'+Font.Name+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fwg="'+_GetFontWeight(Font)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fsl="'+_GetFontStyle(Font)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__ftd="'+_GetTextDecoration(Font)+'";');
                joRes.Add('this.'+dwFullName(Actrl)+'__fta="'+_GetTextAlignment(TLabel(ACtrl))+'";');
                if joHint.Exists('fontcolor') then begin
                    joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+joHint.fontcolor+'";');
                end else begin
                    joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+dwColor(Font.Color)+'";');
                end;
            end;
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

