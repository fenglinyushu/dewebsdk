library dwTEdit;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     SysUtils,
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
     oChange   : Procedure(Sender:TObject) of Object;
begin
     //
     joData    := _Json(AData);


     if joData.e = 'onenter' then begin
          if Assigned(TEdit(ACtrl).OnEnter) then begin
               TEdit(ACtrl).OnEnter(TEdit(ACtrl));
          end;
     end else if joData.e = 'onchange' then begin
          //�����¼�
          oChange   := TEdit(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TEdit(ACtrl).OnChange  := nil;
          //����ֵ
          TEdit(ACtrl).Text    := dwUnescape(joData.v);
          //�ָ��¼�
          TEdit(ACtrl).OnChange  := oChange;

          //ִ���¼�
          if Assigned(TEdit(ACtrl).OnChange) then begin
               TEdit(ACtrl).OnChange(TEdit(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TEdit(ACtrl).OnExit) then begin
               TEdit(ACtrl).OnExit(TEdit(ACtrl));
          end;
     end else if joData.e = 'onmouseenter' then begin
          if Assigned(TEdit(ACtrl).OnMouseEnter) then begin
               TEdit(ACtrl).OnMouseEnter(TEdit(ACtrl));
          end;
     end else if joData.e = 'onmouseexit' then begin
          if Assigned(TEdit(ACtrl).OnMouseLeave) then begin
               TEdit(ACtrl).OnMouseLeave(TEdit(ACtrl));
          end;
     end;
{
     if joData.e = 'onchange' then begin
          //�����¼�
          TEdit(ACtrl).OnExit    := TEdit(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TEdit(ACtrl).OnChange  := nil;
          //����ֵ
          TEdit(ACtrl).Text    := dwUnescape(joData.v);
          //�ָ��¼�
          TEdit(ACtrl).OnChange  := TEdit(ACtrl).OnExit;

          //ִ���¼�
          if Assigned(TEdit(ACtrl).OnChange) then begin
               TEdit(ACtrl).OnChange(TEdit(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
          //�����¼�
          TEdit(ACtrl).OnExit    := TEdit(ACtrl).OnEnter;
          //����¼�,�Է�ֹ�Զ�ִ��
          TEdit(ACtrl).OnEnter  := nil;
          //����ֵ
          TEdit(ACtrl).Text    := dwUnescape(joData.v);
          //�ָ��¼�
          TEdit(ACtrl).OnEnter  := TEdit(ACtrl).OnExit;

          //ִ���¼�
          if Assigned(TEdit(ACtrl).OnEnter) then begin
               TEdit(ACtrl).OnEnter(TEdit(ACtrl));
          end;
     end;
     //���OnExit�¼�
     TEdit(ACtrl).OnExit  := nil;
}
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
     with TEdit(ACtrl) do begin
          sCode     := '<el-input'
                    +dwVisible(TControl(ACtrl))                            //���ڿ��ƿɼ���Visible
                    +dwDisable(TControl(ACtrl))                            //���ڿ��ƿ�����Enabled(���ֿؼ���֧��)
                    +dwIIF(PasswordChar=#0,'',' show-password')            //�Ƿ�Ϊ����
                    +' v-model="'+Name+'__txt"'                            //ǰ��
                    +dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,��ʾ��
                    +dwGetHintValue(joHint,'prefix-icon','prefix-icon','') //ǰ��Icon
                    +dwGetHintValue(joHint,'suffix-icon','suffix-icon','') //����Icon
                    //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +' :style="{left:'+Name+'__lef,top:'+Name+'__top,width:'+Name+'__wid,height:'+Name+'__hei}" style="position:absolute;'
                    +dwGetHintStyle(joHint,'borderradius','border-radius','border-radius:4px;')   //border-radius
                    +dwGetHintStyle(joHint,'border','border','border:1px solid #DCDFE6;')   //border-radius
                    +'overflow: hidden;'
                    +'"' // ���style
                    +Format(_DWEVENT,['input',Name,'(this.'+Name+'__txt)','onchange','']) //���¼�
                    //+dwIIF(Assigned(OnChange),    Format(_DWEVENT,['input',Name,'(this.'+Name+'__txt)','onchange','']),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter','']),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit','']),'')
                    +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',Name,'0','onexit','']),'')
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
     joRes.Add('</el-input>');          //�˴���Ҫ��dwGetHead��Ӧ
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
     with TEdit(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__txt:"'+(Text)+'",');
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
     with TEdit(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__txt="'+(Text)+'";');
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
 
