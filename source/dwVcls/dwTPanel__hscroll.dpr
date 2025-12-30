library dwTPanel__hscroll;

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

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes       : Variant;
    sCode       : String;
begin
     //生成返回值数组
    joRes   := _Json('[]');


    //
    Result    := joRes;
end;



//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
    with TPanel(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
            //通过panel.caption传递数据
            if joData.v <> '0' then begin
                Caption := joData.v;
            end;

            //
            TPanel(ACtrl).OnClick(TPanel(ACtrl));
        end else if joData.e = 'onenter' then begin
            TPanel(ACtrl).OnEnter(TPanel(ACtrl));
        end else if joData.e = 'onexit' then begin
            TPanel(ACtrl).OnExit(TPanel(ACtrl));
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    joHint      : Variant;
    joRes       : Variant;
    sEnter      : String;
    sExit       : String;
    sClick      : string;
    sFull       : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    //
    with TPanel(ACtrl) do begin
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
        sCode   := '<div'
                +' id="'+sFull+'"'
                //+' class="hsmask"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')
                //+dwGetHintValue(joHint,'icon','icon','')
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'backgroundColor:'+sFull+'__col,'
                    //Font
                    +'color:'+sFull+'__fcl,'
                    +'''font-size'':'+sFull+'__fsz,'
                    +'''font-family'':'+sFull+'__ffm,'
                    +'''font-weight'':'+sFull+'__fwg,'
                    +'''font-style'':'+sFull+'__fsl,'
                    +'''text-decoration'':'+sFull+'__ftd,'

                    +'transform:''rotateZ({'+sFull+'__rtz}deg)'','
                    +'left:'+sFull+'__lef,top:'+sFull+'__top,width:'+sFull+'__wid,height:'+sFull+'__hei'
                +'}"'
                    //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                +' style="'
                    +'position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';'
                    +'overflow:hidden;'
                    +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +sClick
                +sEnter
                +sExit
                +'>'#13#10
                +'<div'
                    +' id="'+sFull+'__con"'
                    +' style="'
                        +'position: absolute;'
                        +'left: 0;'
                        +'top: 0;'
                        +'width: 100%;'
                        +'height: 100%;'
                        +'overflow-x: auto;'
                        +'white-space: nowrap;'
                        +'scrollbar-width: none;'
                    +'"'
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
    joRes       : Variant;
    joHint      : Variant;
    sCode       : String;
    sFull       : string;
    //
    iWidth      : Integer;  //滚动框总框长度，默认50
    iHeight     : Integer;  //高度，默认4
    sBack       : String;   //滚动框背景颜色，默认#ddd
    sFore       : String;   //前景颜色，默认red
begin
    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //取得配置
    iWidth  := dwGetInt(joHint,'width',50);
    iHeight := dwGetInt(joHint,'height',4);
    sBack   := dwGetStr(joHint,'backcolor','#ddd');
    sFore   := dwGetStr(joHint,'forecolor','red');

    //
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');

        //滚动条的总框
        sCode   :=
                '<div'
                    +' id="'+sFull+'__rai"'
                    +' style="'
                        +'width: '+IntToStr(iWidth)+'px;'
                        +'height: '+IntToStr(iHeight)+'px;'
                        +'overflow:hidden;'
                        +'background-color: '+sBack+';'
                        +'position: absolute;'
                        +'bottom: 5px;'
                        +'left: 50%;'
                        +'margin-left: -'+IntToStr(iWidth div 2)+'px;'
                        +'border-radius:'+IntToStr(iHeight div 2)+'px;'
                    +'"'
                +'>';
        joRes.Add(sCode);

        //滚动条的子滚动框
        sCode   :=
                '<div'
                    +' id="'+sFull+'__blk"'
                    +' style="'
                        +'height: 100%;'
                        +'background-color: '+sFore+';'
                        +'position: absolute;'
                        +'top: 0;'
                        +'left: 0;'
                    +'"'
                +' ></div>';
        joRes.Add(sCode);

        joRes.Add('</div>');    //滚动条的总框的尾部封闭
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
    sFull       : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(ACtrl) do begin
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
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add(sFull+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(sFull+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
            end;
            //
            joRes.Add(sFull+'__rtz:30,');
            //
            joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            //joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
            if Font.Name = '微软雅黑' then begin
                joRes.Add(sFull+'__ffm:"-apple-system, BlinkMacSystemFont, ''PingFang SC'', ''Hiragino Sans GB'', ''Microsoft Yahei'', ''微软雅黑'', sans-serif",');
            end else begin
                joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
            end;
            joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(ACtrl) do begin
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
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add('this.'+sFull+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+sFull+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
            end;
            //
            joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
            //joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
            if Font.Name = '微软雅黑' then begin
                joRes.Add('this.'+sFull+'__ffm="-apple-system, BlinkMacSystemFont, ''PingFang SC'', ''Hiragino Sans GB'', ''Microsoft Yahei'', ''微软雅黑'', sans-serif";');
            end else begin
                joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
            end;
            joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
        end;
        //
        Result    := (joRes);
    end;
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    //
    sCode   : string;
    sFull   : string;
    //
    iWidth      : Integer;  //滚动框总框长度，默认50
    iHeight     : Integer;  //高度，默认4
begin
    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes   := _Json('[]');


    //取得配置
    iWidth  := dwGetInt(joHint,'width',50);
    iHeight := dwGetInt(joHint,'height',4);

    sCode   :=
    'const mask = document.getElementById('''+sFull+''');'#13#10
    +'const container = document.getElementById('''+sFull+'__con'');'#13#10
    +'const containerWidth = mask.getBoundingClientRect().width;'#13#10
    +''#13#10

    +'const childNodes = container.childNodes;'#13#10
    +'let maxWidth = 0;'#13#10
    +'childNodes.forEach(node => {'#13#10

    //+'console.log(node);'#13#10
    +'if (node.nodeType === Node.ELEMENT_NODE) {'#13#10
    +'	      const rect = node.getBoundingClientRect();'#13#10
    +'	      const curWidth = rect.left + rect.width;'#13#10
    +'	      if (curWidth > maxWidth) {'#13#10
    +'	          maxWidth = curWidth;'#13#10
    +'	      }'#13#10
    +'	  }'#13#10
    +'});'#13#10

    //+'console.log(maxWidth);'#13#10
    //+'container.style.width = maxWidth+"px";'
    //+'container.style.width = "100%";'

    +'let rate = containerWidth / maxWidth;'#13#10
    //+'console.log(containerWidth , maxWidth)'#13#10
    +'const rail =  document.getElementById('''+sFull+'__rai'');'#13#10
    +'const block =  document.getElementById('''+sFull+'__blk'');'#13#10
    +'const railWidth = rail.getBoundingClientRect().width;'#13#10
    +'const blockWidth = railWidth * rate;'#13#10
    +'block.style.width = blockWidth + ''px'';'#13#10
    +''#13#10
    +'function move() {'#13#10
    +'	  const blockLeft = container.scrollLeft  * '+IntToStr(iWidth)+' / maxWidth;'#13#10
    +'	  block.style.left = blockLeft + ''px'';'#13#10
    //+'console.log(container.scrollLeft ,rate, blockLeft)'#13#10
    +'}'#13#10
    +''#13#10
    +'let animId;'#13#10
    +'container.addEventListener(''scroll'', () => {'#13#10
    +'	  animId = requestAnimationFrame(move);'#13#10
    +'});'#13#10
    +'window.onbeforeunload = () => cancelAnimationFrame(animId);';

    //
    joRes.Add(sCode);

    //
    Result    := joRes;
end;



exports
     //dwGetExtra,
     dwGetEvent,
     dwGetMounted,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
