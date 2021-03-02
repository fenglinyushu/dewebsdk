library dwTListBox;

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

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     sValue    : String;
     iItem     : Integer;
     joData    : Variant;
begin
     joData    := _json(AData);

     //�����¼�
     TListBox(ACtrl).OnExit    := TListBox(ACtrl).OnClick;
     //����¼�,�Է�ֹ�Զ�ִ��
     TListBox(ACtrl).OnClick  := nil;
     //����ֵ
     sValue    := dwUnescape(joData.value);
     sValue    := ','+sValue+',';
     for iItem := 0 to TListBox(ACtrl).Items.Count-1 do begin
          TListBox(ACtrl).Selected[iItem]    := Pos(','+IntToStr(iItem)+',',sValue)>0;
     end;
     //�ָ��¼�
     TListBox(ACtrl).OnClick  := TListBox(ACtrl).OnExit;

     //ִ���¼�
     if Assigned(TListBox(ACtrl).OnClick) then begin
          TListBox(ACtrl).OnClick(TListBox(ACtrl));
     end;

     //���OnExit�¼�
     TListBox(ACtrl).OnExit  := nil;
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

     with TListBox(ACtrl) do begin
          //
          joRes.Add('<select class="dwselect" size=2'
                    +dwIIF(MultiSelect,' multiple','')
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+Name+'__val"'
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style ���
                    +Format(_DWEVENT,['change',Name,'String(this.'+Name+'__val)','onchange',''])
                    +'>');
          joRes.Add('    <option class="dwoption" v-for=''(item,index) in '+Name+'__its''  :value=item.value :key=''index''>{{ item.text }}</option>');

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
     joRes.Add('</select>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TListBox(ACtrl) do begin
          //
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //���ѡ��
          sCode     := Name+'__its:[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{text:'''+Items[iItem]+''',value:'''+IntToStr(iItem)+'''},';
          end;
          Delete(sCode,Length(sCode),1);
          sCode     := sCode + '],';
          joRes.Add(sCode);
          //
          sCode     := '';
          for iItem := 0 to Items.Count-1 do begin
               if Selected[iItem] then begin
                    sCode     := sCode + IntToStr(iItem)+',';
               end
          end;
          if sCode<>'' then begin
               Delete(sCode,Length(sCode),1);
          end;
          joRes.Add(Name+'__val:['+sCode+'],');
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TListBox(ACtrl) do begin
          //
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //���ѡ��
          sCode     := 'this.'+Name+'__its=[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{text:'''+Items[iItem]+''',value:'''+IntToStr(iItem)+'''},';
          end;
          Delete(sCode,Length(sCode),1);
          sCode     := sCode + '];';
          joRes.Add(sCode);
          //
          sCode     := '';
          for iItem := 0 to Items.Count-1 do begin
               if Selected[iItem] then begin
                    sCode     := sCode + IntToStr(iItem)+',';
               end
          end;
          if sCode<>'' then begin
               Delete(sCode,Length(sCode),1);
          end;
          joRes.Add('this.'+Name+'__val=['+sCode+'];');
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
 
