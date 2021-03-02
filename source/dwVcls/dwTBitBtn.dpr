library dwTBitBtn;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Buttons,
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

     if joData.event = 'onenddock' then begin
          if Assigned(TBitBtn(ACtrl).OnEndDock) then begin
               TBitBtn(ACtrl).OnEndDock(TBitBtn(ACtrl),nil,0,0);
          end;
     end else if joData.event = 'onenter' then begin
          if Assigned(TBitBtn(ACtrl).OnEnter) then begin
               TBitBtn(ACtrl).OnEnter(TBitBtn(ACtrl));
          end;
     end else if joData.event = 'onexit' then begin
          if Assigned(TBitBtn(ACtrl).OnExit) then begin
               TBitBtn(ACtrl).OnExit(TBitBtn(ACtrl));
          end;
     end else if joData.event = 'getfilename' then begin
          TBitBtn(ACtrl).Caption   := dwUnescape(joData.value);
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
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
     //��������Ϊ: JS�¼�����, �ؼ�����,�ؼ�ֵ,Delphi�¼�����,����


     //
     with TBitBtn(ACtrl) do begin
          //���Form
          joRes.Add('<form'
                    +' id="'+Name+'__frm"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style ���
                    +' action="/dwupload"'
                    +' method="POST"'
                    +' enctype="multipart/form-data"'
                    +' target="upload_iframe"'
                    +'>');

          //���Input
		joRes.Add('<input id="'+Name+'__inp" type="FILE" name="file"'
                    +' style="display:none"'
                    +dwGetHintValue(joHint,'accept','accept','')
                    +dwGetHintValue(joHint,'capture','capture','')
                    +' @change=dwInputChange('''+Name+''');>');

          //���Button
          //�õ���С��large/medium/small/mini
          if Height>50 then begin
               sSize     := ' size=large';
          end else if Height>35 then begin
               sSize     := ' size=medium';
          end else if Height>20 then begin
               sSize     := ' size=small';
          end else begin
               sSize     := ' size=mini';
          end;

          //
          sCode     := '<el-button'
                    +' id="'+Name+'__btn"'
                    +sSize
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    //+dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                    +' :type="'+Name+'__typ"'
                    +dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                    +dwGetHintValue(joHint,'style','','')             //��ʽ���գ�Ĭ�ϣ�/plain/round/circle

                    +' style="width:100%;height:100%;"'
                    //Ĭ��ѡ���ļ�
                    +' @click="dwInputClick('''+Name+'__inp'');"'

                    //�����¼�
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>{{'+Name+'__cap}}';
          //
          joRes.Add(sCode);

     end;

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
     joRes.Add('</form>');
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
     with TBitBtn(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          joRes.Add(Name+'__typ:"'+dwGetProp(TBitBtn(ACtrl),'type')+'",');
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
     with TBitBtn(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+Name+'__typ="'+dwGetProp(TBitBtn(ACtrl),'type')+'";');
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

