library dwTButton__simple;
(*
    简化版的Button， 用于优化系统
    减少了大量可能不用的代码，比如字体，style等
*)

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
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                //静态style
                +' style="position:absolute;'
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
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




    end;

    //
    Result    := joRes;
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
 
