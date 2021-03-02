library dwTTimer;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,ExtCtrls,
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
begin
     //
     if Assigned(TTimer(ACtrl).OnTimer) then  begin
          TTimer(ACtrl).OnTimer(TTimer(ACtrl));
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     Result    := (joRes);
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     with TTimer(ACtrl) do begin
          if DesignInfo = 1 then begin   //������ʱ��
               sCode     := Name+'__tmr = window.setInterval(function() {'
                    +'axios.get(''{"mode":"event","cid":''+this.clientid+'',"component":"'+Name+'"}'')'
                    +'.then(resp =>{this.procResp(resp.data);  })'
                    +'}, '+IntToStr(Interval)+');';

          end else begin                     //�����ʱ��
               sCOde     := 'clearInterval('+Name+'__tmr);';
          end;
          joRes.Add(sCode);
     end;

     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     with TTimer(ACtrl) do begin
          if DesignInfo = 1 then begin   //������ʱ��
               sCode     := 'me=this;'+Name+'__tmr = window.setInterval(function() {'
                    +'axios.get(''{"mode":"event","cid":'+IntToStr(TForm(Owner).Handle)+',"component":"'+Name+'"}'')'
                    +'.then(resp =>{me.procResp(resp.data);  })'
                    +'},'+IntToStr(Interval)+');';

          end else begin                     //�����ʱ��
               sCode     := 'clearInterval('+Name+'__tmr);';
          end;
          joRes.Add(sCode);
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
 
