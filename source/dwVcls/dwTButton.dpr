library dwTButton;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

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
     sCode     : String;
     sSize     : String;

     //
     joHint    : Variant;
     joRes     : Variant;
     sEnter    : String;
     sExit     : String;
     sClick    : string;
begin

     //生成返回值数组
     joRes    := _Json('[]');
     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%d'')"';
     //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,句柄


     //
     with TButton(ACtrl) do begin
          //得到大小：large/medium/small/mini
          if Height>=50 then begin
               sSize     := ' size=large';
          end else if Height>=35 then begin
               sSize     := ' size=medium';
          end else if Height>=20 then begin
               sSize     := ' size=small';
          end else begin
               sSize     := ' size=mini';
          end;

          //进入事件代码--------------------------------------------------------
          sEnter  := '';
          if joHint.Exists('onenter') then begin
               sEnter  := joHint.onenter;    //取得OnEnter的JS代码
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
               sExit  := joHint.onexit;
          end;
          if sExit='' then begin
               if Assigned(OnExit) then begin
                    sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']);
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
               sClick := joHint.onclick;
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
          sCode     := '<el-button'
                    +sSize
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                    +' :type="'+dwPrefix(Actrl)+Name+'__typ"'
                    +dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                    +dwGetHintValue(joHint,'style','','')             //样式，空（默认）/plain/round/circle
                    +dwLTWH(TControl(ACtrl))
                    +dwGetHintStyle(joHint,'borderradius','border-radius','')   //border-radius
                    +'"' //style 封闭
                    +sClick
                    +sEnter
                    +sExit
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>{{'+dwPrefix(Actrl)+Name+'__cap}}';

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
     joRes     : Variant;
begin

     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TButton(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:'''+IntToStr(Left)+'px'',');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:'''+IntToStr(Top)+'px'',');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:'''+IntToStr(Width)+'px'',');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:'''+IntToStr(Height)+'px'',');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__cap:'''+dwProcessCaption(Caption)+''',');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__typ:'''+dwGetProp(TButton(ACtrl),'type')+''',');
     end;
     //
     Result    := (joRes);
end;

//取得事件
function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin


     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TButton(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height+2)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__typ="'+dwGetProp(TButton(ACtrl),'type')+'";');
     end;
     //
     Result    := (joRes);
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
 
