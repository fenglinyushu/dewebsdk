library dwTPanel__dvbox;
{
    本模块用于解析DataV系统的dv-border-box-10
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
     case TPanel(ACtrl).Alignment of
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
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
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
    {
    //以下是TChart时的代码,供参考
    joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
    joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
    joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
    }
    //joRes.Add('<script src="dist/_datav/vue"></script>');
    joRes.Add('<script src="dist/_datav/datav.min.vue.js"></script>');
    joRes.Add('<style>.border-box-content{display:flex;justify-content: center;align-items: center;}</style>');
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
    sCode       : string;
    joHint      : Variant;
    joRes       : Variant;
    sFull       : string;
begin
    //取得全名备用
    sFull       := dwFullName(ACtrl);

    //
    with TPanel(Actrl) do begin
        //
        if HelpContext = 0 then begin
            HelpContext := 1;
        end;

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TPanel(ACtrl) do begin
            //
            sCode     := '<div'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'"' // 封闭style
                    +'>';
            joRes.Add(sCode);

            //
            if HelpContext = 20 then begin
                sCode     := '<dv-water-level-pond'

                        //+' v-html="'+sFull+'__cap"'
                        +dwVisible(TControl(ACtrl))
                        +dwDisable(TControl(ACtrl))
                        +dwGetDWAttr(joHint)
                        //
                        +' :style="{'
                            +'width:'+sFull+'__wid,'
                            +'height:'+sFull+'__hei,'
                            +'backgroundColor:'+sFull+'__col,'
                            +'color:'+sFull+'__fcl,'
                        +'}"'
                        //
                        +' style="position:absolute;'
                            +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                            +dwGetDWStyle(joHint)
                        +'"'
                        //style 封闭

                        +':config="{ data: [56,33,20], shape: ''round''}"'

                        +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter',Name,'0','onenter',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave',Name,'0','onexit',TForm(Owner).Handle]),'')
                        +'>'
                        //+dwIIF(HelpContext=11,'','{{'+sFull+'__cap}}')
                        ;
            end else begin
                sCode     := '<dv-border-box-'+IntToStr(abs(HelpContext))
                        +dwIIF(HelpContext<0,' :reverse="true"','')
                        //+' class="dwdisselect"'
                        //+' id="'+sFull+'"'
                        //+' name="'+sFull+'"'
                        +dwIIF(HelpContext in [11,14],' :title="'+sFull+'__cap"','')

                        //样式11/14标题宽度
                        +dwIIF(dwGetInt(joHint,'titlewidth')>0,' :title-width="'+ IntToStr(dwGetInt(joHint,'titlewidth'))+'"','')

                        //样式11/14隐藏左右小方块
                        +dwIIF(dwGetBoolean(joHint,'hidden')=True,' :hidden="true"','')

                        //样式14隐藏边框
                        +dwIIF(dwGetBoolean(joHint,'borderhidden')=True,' :borderhidden="true"','')

                        //样式14标题栏背景
                        +dwIIF(dwGetStr(joHint,'background')<>'',' background="'+dwGetStr(joHint,'background')+'"','')

                        //+' v-html="'+sFull+'__cap"'
                        +dwVisible(TControl(ACtrl))
                        +dwDisable(TControl(ACtrl))
                        +dwGetDWAttr(joHint)
                        //
                        +' :style="{'
                            +'width:'+sFull+'__wid,'
                            +'height:'+sFull+'__hei,'
                            +'backgroundColor:'+sFull+'__col,'
                            +'color:'+sFull+'__fcl,'
                            +'''font-size'':'+sFull+'__fsz,'
                            +'''font-family'':'+sFull+'__ffm,'
                            +'''font-weight'':'+sFull+'__fwg,'
                            +'''font-style'':'+sFull+'__fsl,'
                            +'''text-decoration'':'+sFull+'__ftd,'
                            //+dwIIF((Layout=tlCenter)and(WordWrap=False),'''line-height'':'+sFull+'__hei,','')
                            //+dwIIF(Layout=tlCenter,'''line-height'':'+sFull+'__hei,','')
                            //+'left:'+sFull+'__lef,'
                            //+'top:'+sFull+'__top,'
                        +'}"'
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

                        +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseDown),Format(_DWEVENT,['mousedown',Name,'event.offsetX*100000+event.offsetY','onmousedown',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseUp),Format(_DWEVENT,['mouseup',Name,'event.offsetX*100000+event.offsetY','onmouseup',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter',Name,'0','onenter',TForm(Owner).Handle]),'')
                        +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave',Name,'0','onexit',TForm(Owner).Handle]),'')
                        +'>'
                        //+dwIIF(HelpContext in [11,14],'','{{'+sFull+'__cap}}')
                        //+'{{'+sFull+'__cap}}'
                        //以下是标题
                        //+dwIIF(ParentBidiMode,'{{'+sFull+'__cap}}','')
                        //+dwIIF(ParentBidiMode,'{{'+sFull+'__cap}}','')
                        ;
            end;
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
    with TPanel(Actrl) do begin

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        if HelpContext = 20 then begin
            joRes.Add('</dv-water-level-pond>');
        end else begin
            joRes.Add('</dv-border-box-'+IntToStr(abs(HelpContext))+'>');
        end;

        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := joRes;
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sFull       : string;
begin
    //取得全名备用
    sFull       := dwFullName(ACtrl);

     with TPanel(Actrl) do begin
           //生成返回值数组
           joRes    := _Json('[]');
           //
           with TPanel(ACtrl) do begin
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

                joRes.Add(sFull+'__col:"'+dwColor(TPanel(ACtrl).Color)+'",');
                //
                joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
                joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
                joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
                joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
                joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
                joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');
                joRes.Add(sFull+'__fta:"'+_GetTextAlignment(TPanel(ACtrl))+'",');
           end;
           //
           Result    := (joRes);
     end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sFull       : string;
begin
    //取得全名备用
    sFull       := dwFullName(ACtrl);

     with TPanel(Actrl) do begin

           //生成返回值数组
           joRes    := _Json('[]');
           //
           with TPanel(ACtrl) do begin
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
                joRes.Add('this.'+sFull+'__col="'+dwColor(TPanel(ACtrl).Color)+'";');
                //
                joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
                joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
                joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
                joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
                joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
                joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
                joRes.Add('this.'+sFull+'__fta="'+_GetTextAlignment(TPanel(ACtrl))+'";');
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

