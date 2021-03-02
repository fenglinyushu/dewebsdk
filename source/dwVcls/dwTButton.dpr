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

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
     joData    : Variant;
begin

     //
     joData    := _Json(AData);

     if joData.event = 'onclick' then begin
          if Assigned(TButton(ACtrl).OnClick) then begin
               TButton(ACtrl).OnClick(TButton(ACtrl));
          end;
     end else if joData.event = 'onenter' then begin
          if Assigned(TButton(ACtrl).OnEnter) then begin
               TButton(ACtrl).OnEnter(TButton(ACtrl));
          end;
     end else if joData.event = 'onexit' then begin
          if Assigned(TButton(ACtrl).OnExit) then begin
               TButton(ACtrl).OnExit(TButton(ACtrl));
          end;
     end;
end;


//ȡ��HTMLͷ����Ϣ
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

     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
     //��������Ϊ: JS�¼�����, �ؼ�����,�ؼ�ֵ,Delphi�¼�����,����


     //
     with TButton(ACtrl) do begin
          //�õ���С��large/medium/small/mini
          if Height>=50 then begin
               sSize     := ' size=large';
          end else if Height>=35 then begin
               sSize     := ' size=medium';
          end else if Height>=20 then begin
               sSize     := ' size=small';
          end else begin
               sSize     := ' size=mini';
          end;

          //�����¼�����--------------------------------------------------------
          sEnter  := '';
          if joHint.Exists('onenter') then begin
               sEnter  := joHint.onenter;
          end;
          if sEnter='' then begin
               if Assigned(OnEnter) then begin
                    sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']);
               end else begin

               end;
          end else begin
               if Assigned(OnEnter) then begin
                    sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',''])
               end else begin
                    sEnter    := ' @mouseenter.native="'+sEnter+'"';
               end;
          end;


          //�˳��¼�����--------------------------------------------------------
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
                    sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',''])
               end else begin
                    sExit    := ' @mouseleave.native="'+sExit+'"';
               end;
          end;

          //�����¼�����--------------------------------------------------------
          sClick    := '';
          if joHint.Exists('onclick') then begin
               sClick := joHint.onclick;
          end;
          //
          if sClick='' then begin
               if Assigned(OnClick) then begin
                    sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick','']);
               end else begin

               end;
          end else begin
               if Assigned(OnClick) then begin
                    sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',''])
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
                    +' :type="'+Name+'__typ"'
                    +dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                    +dwGetHintValue(joHint,'style','','')             //��ʽ���գ�Ĭ�ϣ�/plain/round/circle
                    +dwLTWH(TControl(ACtrl))
                    +dwGetHintStyle(joHint,'borderradius','border-radius','')   //border-radius
                    +'"' //style ���
                    +sClick
                    +sEnter
                    +sExit
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>{{'+Name+'__cap}}';

     end;
     joRes.Add(sCode);
     Result    := (joRes);
     //
     //@mouseenter.native=��enter��
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin

     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</el-button>');
     //
     Result    := (joRes);
end;

//ȡ��Data��Ϣ
function dwGetData(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin

     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TButton(ACtrl) do begin
          joRes.Add(Name+'__lef:'''+IntToStr(Left)+'px'',');
          joRes.Add(Name+'__top:'''+IntToStr(Top)+'px'',');
          joRes.Add(Name+'__wid:'''+IntToStr(Width)+'px'',');
          joRes.Add(Name+'__hei:'''+IntToStr(Height)+'px'',');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__cap:'''+dwProcessCaption(Caption)+''',');
          //
          joRes.Add(Name+'__typ:'''+dwGetProp(TButton(ACtrl),'type')+''',');
     end;
     //
     Result    := (joRes);
end;

//ȡ���¼�
function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin


     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TButton(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height+2)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+Name+'__typ="'+dwGetProp(TButton(ACtrl),'type')+'";');
     end;
     //
     Result    := (joRes);
end;

exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;
     
begin
end.
 
