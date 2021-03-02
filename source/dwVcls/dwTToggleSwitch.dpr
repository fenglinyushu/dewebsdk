library dwTToggleSwitch;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Vcl.WinXCtrls,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     with TToggleSwitch(ACtrl) do begin
          if joData.event = 'onclick' then begin
               if joData.value = 'true' then begin
                    State     := tssON;
               end else begin
                    State     := tssOFF;
               end;
               if Assigned(OnClick) then begin
                    OnClick(TToggleSwitch(ACtrl));
               end;
          end else if joData.event = 'onenter' then begin
               if Assigned(OnEnter) then begin
                    OnEnter(TToggleSwitch(ACtrl));
               end;
          end else if joData.event = 'onexit' then begin
               if Assigned(OnExit) then begin
                    OnExit(TToggleSwitch(ACtrl));
               end;
          end;
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));
(*

<el-switch
  style="display: block"
  v-model="value2"
  active-color="#13ce66"
  inactive-color="#ff4949"
  active-text="���¸���"
  inactive-text="���긶��">
</el-switch>

*)
     with TToggleSwitch(ACtrl) do begin
          sCode     := '<el-switch'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+Name+'__sta"'
                    +' :width="'+Name+'__stw"'
                    +' :active-color="'+Name+'__acc"'
                    +' :inactive-color="'+Name+'__inc"'
                    +' :active-text="'+Name+'__act"'
                    +' :inactive-text="'+Name+'__int"'
                    //+dwGetHintValue(joHint,'type','type',' type="default"')         //sCheckBoxType
                    //+dwGetHintValue(joHint,'icon','icon','')         //CheckBoxIcon
                    //
                    +dwLTWH(TControl(ACtrl))
                    +'display: block;'
                    +'"' //style ���
                    +Format(_DWEVENT,['change',Name,'this.'+Name+'__sta','onclick',''])
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);
     end;
     //
     Result    := (joRes);
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</el-switch>');
     //
     Result    := (joRes);
end;

//ȡ��Data��Ϣ, ASeparatorΪ�ָ���, һ��Ϊ:��=
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TToggleSwitch(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));

          //
          joRes.Add(Name+'__stw:'+IntToStr(SwitchWidth)+',');
          joRes.Add(Name+'__sta:'+dwIIF(State = tssOn,'true,','false,'));
          joRes.Add(Name+'__acc:"'+dwColor(ThumbColor)+'",');
          joRes.Add(Name+'__inc:"'+dwColor(DisabledColor)+'",');
          //
          joRes.Add(Name+'__act:"'+StateCaptions.CaptionOn+'",');
          joRes.Add(Name+'__int:"'+StateCaptions.CaptionOff+'",');
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
     with TToggleSwitch(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          //
          joRes.Add('this.'+Name+'__stw='+IntToStr(SwitchWidth)+';');
          joRes.Add('this.'+Name+'__sta='+dwIIF(State = tssOn,'true;','false;'));
          joRes.Add('this.'+Name+'__acc="'+dwColor(ThumbColor)+'";');
          joRes.Add('this.'+Name+'__inc="'+dwColor(DisabledColor)+'";');
          //
          joRes.Add('this.'+Name+'__act="'+StateCaptions.CaptionOn+'";');
          joRes.Add('this.'+Name+'__int="'+StateCaptions.CaptionOff+'";');
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
 
