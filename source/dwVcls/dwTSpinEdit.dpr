library dwTSpinEdit;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Spin,
     StdCtrls, Windows;

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
     joData    := _json(AData);


     //�����¼�
     TSpinEdit(ACtrl).OnExit    := TSpinEdit(ACtrl).OnChange;
     //����¼�,�Է�ֹ�Զ�ִ��
     TSpinEdit(ACtrl).OnChange  := nil;
     //����ֵ
     TSpinEdit(ACtrl).Value        := (joData.v);
     //�ָ��¼�
     TSpinEdit(ACtrl).OnChange  := TSpinEdit(ACtrl).OnExit;

     //ִ���¼�
     if Assigned(TSpinEdit(ACtrl).OnChange) then begin
          TSpinEdit(ACtrl).OnChange(TSpinEdit(ACtrl));
     end;

     //���OnExit�¼�
     TSpinEdit(ACtrl).OnExit  := nil;
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

     with TSpinEdit(ACtrl) do begin
          if ( maxvalue =  0 ) and  ( maxvalue =  0 ) then begin
               joRes.Add('<el-input-number'
                         +' id="'+dwPrefix(Actrl)+Name+'"'
                         +' v-model="'+dwPrefix(Actrl)+Name+'__val"'
                         +dwIIF(Ctl3D,'',' controls-position="right"')
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style ���
                         +Format(_DWEVENT,['change',Name,'(this.'+dwPrefix(Actrl)+Name+'__val)','onchange',TForm(Owner).Handle])
                         +'>');
          end else begin
               joRes.Add('<el-input-number'
                         +' id="'+dwPrefix(Actrl)+Name+'"'
                         +' v-model="'+dwPrefix(Actrl)+Name+'__val"'
                         +' :min="'+dwPrefix(Actrl)+Name+'__min" :max="'+dwPrefix(Actrl)+Name+'__max"'
                         +dwIIF(Ctl3D,'',' controls-position="right"')
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style ���
                         +Format(_DWEVENT,['change',Name,'(this.'+dwPrefix(Actrl)+Name+'__val)','onchange',TForm(Owner).Handle])
                         +'>');
          end;
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
     joRes.Add('</el-input-number>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TSpinEdit(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__val:"'+IntToStr(Value)+'",');
          joRes.Add(dwPrefix(Actrl)+Name+'__min:"'+IntToStr(MinValue)+'",');
          joRes.Add(dwPrefix(Actrl)+Name+'__max:"'+IntToStr(MaxValue)+'",');
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
     with TSpinEdit(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__val="'+IntToStr(Value)+'";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__min="'+IntToStr(MinValue)+'";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__max="'+IntToStr(MaxValue)+'";');
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
 
