library dwTProgressBar;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     Math,
     ComCtrls,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TProgressBarʹ��ʱ��Ҫ�õ�
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //��Ҫ�������Ĵ���
     //joRes.Add('<script src="dist/_vcharts/echarts.min.js"></script>');
     //joRes.Add('<script src="dist/_vcharts/lib/index.min.js"></script>');
     //joRes.Add('<link rel="stylesheet" href="dist/_vcharts/lib/style.min.css">');


     //
     Result    := joRes;
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
begin
{     //
     joData    := _Json(AData);


     if joData.e = 'onenter' then begin
          if Assigned(TProgressBar(ACtrl).OnEnter) then begin
               TProgressBar(ACtrl).OnEnter(TProgressBar(ACtrl));
          end;
     end else if joData.e = 'onchange' then begin
          //�����¼�
          oChange   := TProgressBar(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TProgressBar(ACtrl).OnChange  := nil;
          //����ֵ
          TProgressBar(ACtrl).Text    := dwUnescape(joData.v);
          //�ָ��¼�
          TProgressBar(ACtrl).OnChange  := oChange;

          //ִ���¼�
          if Assigned(TProgressBar(ACtrl).OnChange) then begin
               TProgressBar(ACtrl).OnChange(TProgressBar(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TProgressBar(ACtrl).OnExit) then begin
               TProgressBar(ACtrl).OnExit(TProgressBar(ACtrl));
          end;
     end else if joData.e = 'onmouseenter' then begin
          if Assigned(TProgressBar(ACtrl).OnMouseEnter) then begin
               TProgressBar(ACtrl).OnMouseEnter(TProgressBar(ACtrl));
          end;
     end else if joData.e = 'onmouseexit' then begin
          if Assigned(TProgressBar(ACtrl).OnMouseLeave) then begin
               TProgressBar(ACtrl).OnMouseLeave(TProgressBar(ACtrl));
          end;
     end;
}
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sType     : string;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     with TProgressBar(ACtrl) do begin
          //���
          sCode     := '<div'
                    +' :style="{left:'+dwPrefix(Actrl)+Name+'__lef,top:'+dwPrefix(Actrl)+Name+'__top,width:'+dwPrefix(Actrl)+Name+'__wid,height:'+dwPrefix(Actrl)+Name+'__hei}"'
                    +' style="position:absolute;'
                    +'"' //style ���
                    +'>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);

          //
          sCode     := '    <el-progress'
                    +' :percentage="'+dwPrefix(Actrl)+Name+'__pct"';    //�ٷֱȣ����
          //type   ����������	string	line/circle/dashboard
          if State = pbsNormal then begin
               sCode     := sCode +' type="line"'
                    +' :stroke-width="'+dwPrefix(Actrl)+Name+'__stw"'  //�������Ŀ�ȣ���λ px	number	��	6
                    +' :text-inside="'+dwPrefix(Actrl)+Name+'__tid"'   //��������ʾ���������ڽ������ڣ�ֻ�� type=line ʱ���ã�
          end else if State = pbsError then begin
               sCode     := sCode +' type="circle"';
          end else begin
               sCode     := sCode +' type="dashboard"';
          end;

          sCode     := sCode
                    //+' :status="'+dwPrefix(Actrl)+Name+'__stt"'
                    +' :color="'+dwPrefix(Actrl)+Name+'__clr"'
                    +' :show-text="'+dwPrefix(Actrl)+Name+'__swt"'
                    //+' :stroke-linecap="'+dwPrefix(Actrl)+Name+'__slc"'
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
     sType     : string;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //���ɷ���ֵ����
     joRes.Add('    </el-progress>');               //�˴���Ҫ��dwGetHead��Ӧ
     joRes.Add('</div>');               //�˴���Ҫ��dwGetHead��Ӧ
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     iSeries   : Integer;
     iX        : Integer;
     //
     joRes     : Variant;
     //
     sDat      : String;
     sGrid     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TProgressBar(ACtrl) do begin
          //��������
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));

          //��ʾlegend
          if (Max-Min)>0 then begin
               joRes.Add(dwPrefix(Actrl)+Name+'__pct:'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
          end else begin
               joRes.Add(dwPrefix(Actrl)+Name+'__pct:'+IntToStr(Position)+',');
          end;
          //��ʾ�ı�
          joRes.Add(dwPrefix(Actrl)+Name+'__swt:'+dwIIF(ShowHint,'true,','false,'));
          //�߶�
          joRes.Add(dwPrefix(Actrl)+Name+'__stw:'+IntToStr(Height)+',');
          //������ʾ�ı�
          joRes.Add(dwPrefix(Actrl)+Name+'__tid:'+dwIIF(SmoothReverse,'true,','false,'));
          //Bar��ɫ
          joRes.Add(dwPrefix(Actrl)+Name+'__clr:"'+dwColor(BarColor)+'",');
          //>------
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     iSeries   : Integer;
     iX        : Integer;
     //
     joRes     : Variant;
     //
     sDat      : String;
     sGrid     : String;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TProgressBar(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));

          //��ʾlegend
          if (Max-Min)>0 then begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__pct='+IntToStr(Round((Position-Min)*100/(Max-Min)))+';');
          end else begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__pct='+IntToStr(Position)+';');
          end;
          //��ʾ�ı�
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__swt='+dwIIF(ShowHint,'true;','false;'));
          //�߶�
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__stw='+IntToStr(Height)+';');
          //������ʾ�ı�
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tid='+dwIIF(SmoothReverse,'true;','false;'));
          //Bar��ɫ
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__clr="'+dwColor(BarColor)+'";');
          //>------
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
 
