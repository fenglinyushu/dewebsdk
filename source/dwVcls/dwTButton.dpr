﻿library dwTButton;

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


//--------------------------------------------------------------------------------------------------

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

function  dwButtonFontStyle(ACtrl:TControl):String;
begin
    with ACtrl do begin
        Result    := //'color:'+dwFullName(Actrl)+'__fcl,'+         //颜色
            '''font-size'':'+dwFullName(Actrl)+'__fsz,'         //size
            +'''font-family'':'+dwFullName(Actrl)+'__ffm,'       //字体
            +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'       //bold
            +'''font-style'':'+dwFullName(Actrl)+'__fsl,'        //italic
            +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'   //下划线或贯穿线，只能选一种
    end;
end;


//--------------------------------------------------------------------------------------------------

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
     joData    : Variant;
begin

     //
     joData    := _Json(AData);

     if joData.e = 'onclick' then begin
          if Assigned(TButton(ACtrl).OnClick) then begin
               TButton(ACtrl).OnClick(TButton(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
          if Assigned(TButton(ACtrl).OnEnter) then begin
               TButton(ACtrl).OnEnter(TButton(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TButton(ACtrl).OnExit) then begin
               TButton(ACtrl).OnExit(TButton(ACtrl));
          end;
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sRIcon  : string;
    sFull   : string;

    //
    joHint  : Variant;
    joRes   : Variant;
    sEnter  : String;
    sExit   : String;
    sClick  : string;
begin

    //生成返回值数组
    joRes    := _Json('[]');
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));
    //
    sFull   := dwFullName(ACtrl);

    //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%d'')"';
    //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,句柄


    //
    with TButton(ACtrl) do begin

        //进入事件代码----------------------------------------------------------------------------
        sEnter  := '';
        if joHint.Exists('onenter') then begin
            sEnter  := 'dwexecute('''+String(joHint.onenter)+''');';    //取得OnEnter的JS代码
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


        //退出事件代码----------------------------------------------------------------------------
        sExit  := '';
        if joHint.Exists('onexit') then begin
            sExit  := 'dwexecute('''+String(joHint.onexit)+''');';
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

        //单击事件的JS代码------------------------------------------------------------------------
        sClick    := '';
        if joHint.Exists('onclick') then begin
            sClick := 'dwexecute('''+dwProcQuotation(String(joHint.onclick))+''');';
        end;

        //防多次点击设置(点击时同时设置不可用)
        if ElevationRequired = True then begin
            sClick  := sClick + dwFullName(Actrl)+'__dis=true;'
        end;

        //
        if sClick='' then begin
            if Assigned(OnClick) then begin
                 //sClick    := Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]);
                 sClick := ' @click="'
                    +'dwevent($event,'''+Name+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                    //+dwFullName(Actrl)+'__dis=false;'
                    +'"';
            end else begin

            end;
        end else begin
            if Assigned(OnClick) then begin
                //同时执行js和delphi
                sClick    := Format(_DWEVENTPlus,['click',sClick,Name,'0','onclick',TForm(Owner).Handle])
            end else begin
                sClick    := ' @click="'+sClick+'"';
            end;
        end;

        //<把事件写入到单独的methods中 2023-02-15
        sClick  := '';
        if joHint.Exists('onclick') or Assigned(OnClick) then begin
            sClick  := ' @click="'+sFull+'__click()"';
        end;
        //>



        //右侧图标字符串
        sRIcon    := '';
        if joHint.Exists('righticon') then begin
            sRIcon  := '<i :class="'+sFull+'__rin"></i>'
        end else if ( HotImageIndex >= 1 ) and (HotImageIndex <= 280) then begin
            sRIcon  := '<i :class="'+sFull+'__rin"></i>'
        end else begin
            sRIcon  := '';
        end;



        //
        sCode   := '<el-button'
                +' id="'+sFull+'"'
                //+sSize
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                +' :type="'+sFull+'__typ"'
                +' :icon="'+sFull+'__icn"'                                              //dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                +dwGetHintValue(joHint,'style','','')             //样式，空（默认）/plain/round/circle
                +dwGetDWAttr(joHint)
                //动态Style
                +' :style="{'
                    +dwIIF(joHint.Exists('type') and (joHint.type <>'text'),dwButtonFontStyle(TControl(ACtrl)),dwFontStyle(TControl(ACtrl)))
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                //静态style
                +' style="position:absolute;'
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetHintStyle(joHint,'backgroundcolor','background-color','')       //自定义背景色
                    //+_GetFont(Font)                   //字体
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭

                +sClick
                //+sEnter
                //+sExit
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>'
                //以下当 (Cancel=True)and(Caption='') 不使用标题，以用于图标居中
                +dwIIF((Cancel=True)and(Caption=''),'','{{'+sFull+'__cap}}')
                //增加右侧图标
                +sRIcon
                ;

    end;
    joRes.Add(sCode);
    Result    := (joRes);
    //
    //@mouseenter.native=“enter”
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin

     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-button>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    sFull   : String;
    joRes   : Variant;
    joHint  : Variant;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TButton(ACtrl) do begin
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
        joRes.Add(sFull+'__typ:"'+dwGetProp(TButton(ACtrl),'type')+'",');
        //图标
        if joHint.Exists('icon') then begin
            joRes.Add(sFull+'__icn:"'+String(joHint.icon)+'",');
        end else if ( ImageIndex >= 1 ) and (ImageIndex <= 280) then begin
            joRes.Add(sFull+'__icn:"'+dwIcons[ImageIndex]+'",');
        end else begin
            joRes.Add(sFull+'__icn:"",');
        end;
        if joHint.Exists('righticon') then begin
            joRes.Add(sFull+'__rin:"'+String(joHint.righticon)+'",');
        end else if ( HotImageIndex >= 1 ) and (HotImageIndex <= 280) then begin
            joRes.Add(sFull+'__rin:"'+dwIcons[HotImageIndex]+'",');
        end else begin
            joRes.Add(sFull+'__rin:"",');
        end;
        //字体
        joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
        joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
        joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
        joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
        joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
        joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');

    end;
    //
    Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sRes    : String;
    sFull   : string;
    pRes    : PWideChar;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');


    //
    sFull   := dwFullName(ACtrl);

    //
    with TButton(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height+2)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
        //
        joRes.Add('this.'+sFull+'__typ="'+dwGetProp(TButton(ACtrl),'type')+'";');



        //图标
        if joHint.Exists('icon') then begin
            joRes.Add('this.'+sFull+'__icn="'+String(joHint.icon)+'";');
        end else if ( ImageIndex >= 1 ) and (ImageIndex <= 280) then begin
            joRes.Add(sFull+'__icn="'+dwIcons[ImageIndex]+'";');
        end else begin
            joRes.Add('this.'+sFull+'__icn="";');
        end;

        if joHint.Exists('righticon') then begin
            joRes.Add('this.'+sFull+'__rin="'+String(joHint.righticon)+'";');
        end else if ( HotImageIndex >= 1 ) and (HotImageIndex <= 280) then begin
            joRes.Add(sFull+'__rin="'+dwIcons[HotImageIndex]+'";');
        end else begin
            joRes.Add('this.'+sFull+'__rin="";');
        end;



        //字体
        joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
        joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
        joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
        joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
        joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
        joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');

    end;

    //
    Result    := joRes;
{
            Result := '["this.Button1__lef=\"8px\";","this.Button1__top=\"8px\";","this.Button1__wid=\"104px\";",'
                +'"this.Button1__hei=\"35px\";","this.Button1__vis=true;","this.Button1__dis=false;",'
                +'"this.Button1__cap=\"刷新\";","this.Button1__typ=\"primary\";","this.Button1__icn=\"\";",'
                +'"this.Button1__rin=\"\";","this.Button1__fcl=\"#FFFFFF\";","this.Button1__fsz=\"11px\";",'
                +'"this.Button1__ffm=\"Tahoma\";","this.Button1__fwg=\"normal\";","this.Button1__fsl=\"normal\";",'
                +'"this.Button1__ftd=\"none\";"]';
}
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode   : string;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TButton(ACtrl) do begin
        //函数头部
        sCode   := sFull+'__click(event) {'#13;
        //
        if joHint.Exists('onclick') then begin
            sCode   := sCode +joHint.onclick+#13;
        end;

        //
        sCode   := sCode + 'this.dwevent("",'''+Name+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'},';

        //
        joRes.Add(sCode);
    end;

    //
    Result   := joRes;
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;

begin
end.
 
