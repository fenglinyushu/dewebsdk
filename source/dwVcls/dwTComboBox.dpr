library dwTComboBox;

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

     if joData.e = 'onchange' then begin
          //�����¼�
          TComboBox(ACtrl).OnExit    := TComboBox(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TComboBox(ACtrl).OnChange  := nil;
          //����ֵ
          TComboBox(ACtrl).Text    := dwUnescape(joData.v);
          //�ָ��¼�
          TComboBox(ACtrl).OnChange  := TComboBox(ACtrl).OnExit;

          //ִ���¼�
          if Assigned(TComboBox(ACtrl).OnChange) then begin
               TComboBox(ACtrl).OnChange(TComboBox(ACtrl));
          end;

          //���OnExit�¼�
          TComboBox(ACtrl).OnExit  := nil;
     end else if joData.e = 'ondropdown' then begin
          if joData.v = 'true' then begin
               if Assigned(TComboBox(ACtrl).OnDropDown) then begin
                    TComboBox(ACtrl).OnDropDown(TLabel(ACtrl));
               end;
          end else if joData.v = 'false' then begin
               if Assigned(TComboBox(ACtrl).OnCloseUp) then begin
                    TComboBox(ACtrl).OnCloseUp(TLabel(ACtrl));
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

     with TComboBox(ACtrl) do begin
          //
          joRes.Add('<el-select'
                    +' v-model="'+Name+'__txt"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'border:1px solid #DCDFF0;'
                    +'border-radius:2px;'
                    +'"' //style ���
                    +dwIIF(Assigned(OnDropDown) OR Assigned(OnCloseUp),
                         '@visible-change="dwevent($event,''ComboBox1'',$event,''ondropdown'','''')"',
                         '')
                    +Format(_DWEVENT,['change',Name,'this.'+Name+'__txt','onchange',''])
                    +'>');
          joRes.Add('    <el-option v-for="item in '+Name+'__its" :key="item.value" :label="item.value" :value="item.value"/>');

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
     joRes.Add('</el-select>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : string;
     iItem     : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TComboBox(ACtrl) do begin
          //���ѡ��
          sCode     := Name+'__its:[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{value:'''+Items[iItem]+'''},';
          end;
          if Items.Count>0 then begin
               Delete(sCode,Length(sCode),1);     //ɾ�����Ķ���
          end;
          sCode     := sCode + '],';
          joRes.Add(sCode);

          //
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          if dwGetProp(TControl(ACtrl),'height')='' then begin
               joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          end else begin
               joRes.Add(Name+'__hei:"'+dwGetProp(TControl(ACtrl),'height')+'px",');
          end;
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__txt:"'+Text+'",');
     end;
     //
     Result    := (joRes);
end;

//ȡ��Method
function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : string;
     iItem     : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TComboBox(ACtrl) do begin
          //���ѡ��
          sCode     := 'this.'+Name+'__its=[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{value:'''+Items[iItem]+'''},';
          end;
          if Items.Count>0 then begin
               Delete(sCode,Length(sCode),1);
          end;
          sCode     := sCode + '];';
          joRes.Add(sCode);
          //
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          if dwGetProp(TControl(ACtrl),'height')='' then begin
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          end else begin
               joRes.Add('this.'+Name+'__hei="'+dwGetProp(TControl(ACtrl),'height')+'px";');
          end;
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__txt="'+Text+'";');
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
 
