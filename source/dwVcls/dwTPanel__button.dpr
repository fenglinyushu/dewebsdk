library dwTPanel__button;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     Buttons,
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

const
     _K   = 3;

//当前控件需要引入的第三方JS/CSS ,一般为不做改动
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     {
     //以下是TChart时的代码,供参考
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }
    joRes.Add('<style>'
	    +'.imgunselectable {'
        +'-moz-user-select: -moz-none;'
        +'-khtml-user-select: none;'
        +'-webkit-user-select: none;'
        +'-o-user-select: none;'
        +'user-select: none;'
        +'}'
        +'<style>'
        );

     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onclick' then begin
          //
          if Assigned(TPanel(ACtrl).OnClick) then begin
               TPanel(ACtrl).OnClick(TPanel(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
          //
          if Assigned(TPanel(ACtrl).OnMouseEnter) then begin
               TPanel(ACtrl).OnMouseEnter(TPanel(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          //
          if Assigned(TPanel(ACtrl).OnMouseLeave) then begin
               TPanel(ACtrl).OnMouseLeave(TPanel(ACtrl));
          end;
     end;

end;

function _ImageLTWH(ACtrl:TControl):String;  //可以更新位置的用法
begin
     //
     with ACtrl do begin
          Result    := ' :style="{left:0,top:0,'
                    +'height:'+dwFullName(Actrl)+'__imh}" style="position:absolute;width:100%;';
     end;
end;
function _LabelLTWH(ACtrl:TControl):String;  //可以更新位置的用法
begin
     //
     with ACtrl do begin
          Result    := ' :style="{left:0,top:'+dwFullName(Actrl)+'__lbt,'
                    +'height:'+dwFullName(Actrl)+'__lbh}" style="position:absolute;width:100%;';
     end;
end;



//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sSize       : string;
    sName       : string;
    sEnter      : String;
    sExit       : String;
    sClick      : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

    with TPanel(ACtrl) do begin
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


        //如果有href，则直接对应链接
        if joHint.Exists('href') then begin
            joRes.Add('<a href="'+String(joHint.href)+'" target="_blank">');
        end else if joHint.Exists('hrefself') then begin
            joRes.Add('<a href="'+String(joHint.hrefself)+'">');
        end;

        //添加外框
        sCode   := '<el-main'
                +' id="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')
                //+dwGetHintValue(joHint,'icon','icon','')
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'

                    +'transform:''rotateZ({'+dwFullName(Actrl)+'__rtz}deg)'','
                    +'left:'+dwFullName(Actrl)+'__lef,top:'+dwFullName(Actrl)+'__top,width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}'
                +'"'
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
        joRes.Add(sCode);



          //文本
          joRes.Add('<div'
               +' v-html="'+dwFullName(Actrl)+'__cap"'
               +' class="dwdisselect"'      //禁止选中
               //+_LabelLTWH(TControl(ACtrl))
               //style
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
                    +'left:0,'
                    +'bottom:0,'//+dwFullName(Actrl)+'__lbt,'
                    +'height:'+dwFullName(Actrl)+'__lbh'
                +'}"'
                    //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                +' style="'
                    +'position:absolute;'
                    +'overflow:hidden;'
                    +'width:100%;'
                    //+dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                    //+dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    //+dwGetDWStyle(joHint)
                   +'text-align:center;'
                   +'line-height:'+IntToStr(Round((Font.Size+3) * _K))+'px;'
                   +'cursor: pointer;'   //图片鼠标样式
               +'"'
               //style 封闭
               +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
               +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
               +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
               +'>{{'+dwFullName(Actrl)+'__cap}}</div>');

          //图标
          joRes.Add('<el-image'
               +' :src="'+dwFullName(Actrl)+'__src"'
               +' class="imgunselectable"'
               +' fit="none"'
               +_ImageLTWH(TControl(ACtrl))
               +'cursor: pointer;'   //图片鼠标样式
               +'"'
               +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
               +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
               +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
               +'></el-image>');
     end;

     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint      : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //生成返回值数组
    joRes.Add('</el-main>');          //此处需要和dwGetHead对应

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    //
    if joHint.Exists('href') then begin
        joRes.Add('</a>');
    end;
    //
    Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
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
        joRes.Add(dwFullName(Actrl)+'__imh:"'+IntToStr(Height-Round((Font.Size+3)*2))+'px",'); //-Round(Font.Size*2)
        joRes.Add(dwFullName(Actrl)+'__lbt:"'+IntToStr(Height-Round((Font.Size+3)*_K))+'px",');
        joRes.Add(dwFullName(Actrl)+'__lbh:"'+IntToStr(Round((Font.Size+3)*_K))+'px",');
        //
        //joRes.Add(dwFullName(Actrl)+'__tri:'+dwIIF(Layout = blGlyphRight,'true,','false,'));
        //joRes.Add(dwFullName(Actrl)+'__bdg:'+dwIIF(Layout = blGlyphTop,'true,','false,'));
        //joRes.Add(dwFullName(Actrl)+'__idt:'+dwIIF(Layout = blGlyphBottom,'true,','false,'));
        //joRes.Add(dwFullName(Actrl)+'__spc:'+IntToStr(Spacing)+',');
        //joRes.Add(dwFullName(Actrl)+'__max:'+IntToStr(Margin)+',');
        //
        joRes.Add(dwFullName(Actrl)+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
        //
        joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
        //
        //joRes.Add(dwFullName(Actrl)+'__typ:"'+dwGetProp(TButton(ACtrl),'type')+'",');
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
        end;
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

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
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
        joRes.Add('this.'+dwFullName(Actrl)+'__imh="'+IntToStr(Height-Round((Font.Size+3)*2))+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__lbt="'+IntToStr(Height-Round((Font.Size+3)*_K))+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__lbh="'+IntToStr(Round((Font.Size+3)*_K))+'px";');
        //
        //joRes.Add('this.'+dwFullName(Actrl)+'__tri='+dwIIF(Layout = blGlyphRight,'true;','false;'));
        //joRes.Add('this.'+dwFullName(Actrl)+'__bdg='+dwIIF(Layout = blGlyphTop,'true;','false;'));
        //joRes.Add('this.'+dwFullName(Actrl)+'__idt='+dwIIF(Layout = blGlyphBottom,'true;','false;'));
        //joRes.Add('this.'+dwFullName(Actrl)+'__spc='+IntToStr(Spacing)+';');
        //joRes.Add('this.'+dwFullName(Actrl)+'__max='+IntToStr(Margin)+';');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
        //
        joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
        end;
        //joRes.Add('this.'+dwFullName(Actrl)+'__typ="'+dwGetProp(TButton(ACtrl),'type')+'";');
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


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
