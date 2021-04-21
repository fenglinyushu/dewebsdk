library dwTDateTimePicker;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TChartʹ��ʱ��Ҫ�õ�
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     {
     //������TChartʱ�Ĵ���,���ο�
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }

     //
     Result    := joRes;
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     iYear     : Word;
     iMonth    : Word;
     iDay      : Word;
     //
     sDate     : string;
     //
     dtTmp     : TDateTime;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onchange' then begin
          //�����¼�
          TDateTimePicker(ACtrl).OnExit    := TDateTimePicker(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TDateTimePicker(ACtrl).OnChange  := nil;
          //����ֵ
          if TDateTimePicker(ACtrl).Kind = dtkDate then begin
               sDate     := joData.v;
               iYear     := StrToIntDef(Copy(sDate,1,4),1990);
               iMonth    := StrToIntDef(Copy(sDate,6,2),1);
               iDay      := StrToIntDef(Copy(sDate,9,2),1);

               TDateTimePicker(ACtrl).Date    :=  EncodeDate(iYear,iMonth,iDay);//StrToDateDef(joData.v,Now);
          end else begin
               TDateTimePicker(ACtrl).Time    := StrToTimeDef(StringReplace(joData.v,'%3A',':',[rfReplaceAll])+':00',Now);
          end;
          //�ָ��¼�
          TDateTimePicker(ACtrl).OnChange  := TDateTimePicker(ACtrl).OnExit;

          //ִ���¼�
          if Assigned(TDateTimePicker(ACtrl).OnChange) then begin
               TDateTimePicker(ACtrl).OnChange(TDateTimePicker(ACtrl));
          end;

          //���OnExit�¼�
          TDateTimePicker(ACtrl).OnExit  := nil;
     end else if joData.e = 'onenter' then begin
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
     with TDateTimePicker(ACtrl) do begin
          //�����ַ���
          if kind =  dtkDate then begin
               //����  <el-date-picker v-model="value1"  type="date" placeholder="ѡ������"></el-date-picker>
               sCode     := '<el-date-picker type="date" format="yyyy-MM-dd" value-format="yyyy-MM-dd"'
                         +' id="'+dwPrefix(Actrl)+Name+'"'
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +' v-model="'+dwPrefix(Actrl)+Name+'__val"'
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style ���
                         +SysUtils.Format(_DWEVENT,['change',Name,'this.'+Name+'__val','onchange',TForm(Owner).Handle])
                         +'>';
          end else begin
               sCode     := '<el-time-select :picker-options="{start: ''00:00'', step: ''00:01'', end: ''23:59''}" format="HH:mm" value-format="HH:mm"'
                         +' id="'+dwPrefix(Actrl)+Name+'"'
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +' v-model="'+dwPrefix(Actrl)+Name+'__val"'
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style ���
                         +SysUtils.Format(_DWEVENT,['change',Name,'this.'+Name+'__val','onchange',TForm(Owner).Handle])
                         +'>';
          end;
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
     if TDateTimePicker(ACtrl).Kind =  dtkDate then begin
          joRes.Add('</el-date-picker>');          //�˴���Ҫ��dwGetHead��Ӧ
     end else begin
          joRes.Add('</el-time-select>');          //�˴���Ҫ��dwGetHead��Ӧ
     end;

     //
     Result    := (joRes);
end;

//ȡ��Data��Ϣ
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TDateTimePicker(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          if kind = dtkDate then begin
               joRes.Add(dwPrefix(Actrl)+Name+'__val:"'+FormatDateTime('yyyy-mm-dd',Date)+'",');
          end else begin
               joRes.Add(dwPrefix(Actrl)+Name+'__val:"'+FormatDateTime('hh:MM:ss',Time)+'",');
          end;
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TDateTimePicker(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          if kind =  dtkDate then begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__val="'+FormatDateTime('yyyy-mm-dd',Date)+'";');
          end else begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__val="'+FormatDateTime('hh:MM:ss',Time)+'";');
          end;
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

