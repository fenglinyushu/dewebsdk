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

     if joData.e = 'onenddock' then begin
          if Assigned(TBitBtn(ACtrl).OnEndDock) then begin
               TBitBtn(ACtrl).OnEndDock(TBitBtn(ACtrl),nil,0,0);
          end;
     end else if joData.e = 'onenter' then begin
          if Assigned(TBitBtn(ACtrl).OnEnter) then begin
               TBitBtn(ACtrl).OnEnter(TBitBtn(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TBitBtn(ACtrl).OnExit) then begin
               TBitBtn(ACtrl).OnExit(TBitBtn(ACtrl));
          end;
     end else if joData.e = 'getfilename' then begin
          TBitBtn(ACtrl).Caption   := dwUnescape(joData.v);
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
                    +' id="'+dwPrefix(Actrl)+Name+'__frm"'
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
		joRes.Add('<input id="'+dwPrefix(Actrl)+Name+'__inp" type="FILE" name="file"'
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
                    +' id="'+dwPrefix(Actrl)+Name+'__btn"'
                    +sSize
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    //+dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                    +' :type="'+dwPrefix(Actrl)+Name+'__typ"'
                    +dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                    +dwGetHintValue(joHint,'style','','')             //��ʽ���գ�Ĭ�ϣ�/plain/round/circle

                    +' style="width:100%;height:100%;"'
                    //Ĭ��ѡ���ļ�
                    +' @click="dwInputClick('''+dwPrefix(Actrl)+Name+'__inp'');"'

                    //�����¼�
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
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
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__typ:"'+dwGetProp(TBitBtn(ACtrl),'type')+'",');
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
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__typ="'+dwGetProp(TBitBtn(ACtrl),'type')+'";');
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

