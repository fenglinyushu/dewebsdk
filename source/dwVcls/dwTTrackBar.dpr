library dwTTrackBar;

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

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TTrackBarʹ��ʱ��Ҫ�õ�
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


     if joData.event = 'onenter' then begin
          if Assigned(TTrackBar(ACtrl).OnEnter) then begin
               TTrackBar(ACtrl).OnEnter(TTrackBar(ACtrl));
          end;
     end else if joData.event = 'onchange' then begin
          //�����¼�
          oChange   := TTrackBar(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TTrackBar(ACtrl).OnChange  := nil;
          //����ֵ
          TTrackBar(ACtrl).Text    := dwUnescape(joData.value);
          //�ָ��¼�
          TTrackBar(ACtrl).OnChange  := oChange;

          //ִ���¼�
          if Assigned(TTrackBar(ACtrl).OnChange) then begin
               TTrackBar(ACtrl).OnChange(TTrackBar(ACtrl));
          end;
     end else if joData.event = 'onexit' then begin
          if Assigned(TTrackBar(ACtrl).OnExit) then begin
               TTrackBar(ACtrl).OnExit(TTrackBar(ACtrl));
          end;
     end else if joData.event = 'onmouseenter' then begin
          if Assigned(TTrackBar(ACtrl).OnMouseEnter) then begin
               TTrackBar(ACtrl).OnMouseEnter(TTrackBar(ACtrl));
          end;
     end else if joData.event = 'onmouseexit' then begin
          if Assigned(TTrackBar(ACtrl).OnMouseLeave) then begin
               TTrackBar(ACtrl).OnMouseLeave(TTrackBar(ACtrl));
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

     with TTrackBar(ACtrl) do begin
          //���
          sCode     := '<div'
                    +' :style="{left:'+Name+'__lef,top:'+Name+'__top,width:'+Name+'__wid,height:'+Name+'__hei}"'
                    +' style="position:absolute;'
                    +'"' //style ���
                    +'>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);

          //
          sCode     := '    <el-slider'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwIIF(Orientation=trVertical,' vertical :height='+Name+'__hei','')
                    +' v-model="'+Name+'"'
                    +' :show-tooltip="'+Name+'__swt"'
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
     joRes.Add('    </el-slider>');               //�˴���Ҫ��dwGetHead��Ӧ
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
     with TTrackBar(ACtrl) do begin
          //��������
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(not Enabled,'true,','false,'));


          //
          joRes.Add(Name+':'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
          //��ʾlegend
          //if (Max-Min)>0 then begin
          //     joRes.Add(Name+'__pct:'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
          //end else begin
          //     joRes.Add(Name+'__pct:'+IntToStr(Position)+',');
          //end;
          //��ʾ�ı�
          joRes.Add(Name+'__swt:'+dwIIF(ShowHint,'true,','false,'));
          //�߶�
          //joRes.Add(Name+'__stw:'+IntToStr(Height)+',');
          //������ʾ�ı�
          //joRes.Add(Name+'__tid:'+dwIIF(SmoothReverse,'true,','false,'));
          //Bar��ɫ
          //joRes.Add(Name+'__clr:"'+dwColor(BarColor)+'",');
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
     with TTrackBar(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(not Enabled,'true;','false;'));

          //
          joRes.Add('this.'+Name+'='+IntToStr(Round((Position-Min)*100/(Max-Min)))+';');
          //��ʾlegend
          //if (Max-Min)>0 then begin
          //     joRes.Add('this.'+Name+'__pct='+IntToStr(Round((Position-Min)*100/(Max-Min)))+';');
          //end else begin
          //     joRes.Add('this.'+Name+'__pct='+IntToStr(Position)+';');
          //end;
          //��ʾ�ı�
          joRes.Add('this.'+Name+'__swt='+dwIIF(ShowHint,'true;','false;'));
          //�߶�
          //joRes.Add('this.'+Name+'__stw='+IntToStr(Height)+';');
          //������ʾ�ı�
          //joRes.Add('this.'+Name+'__tid='+dwIIF(SmoothReverse,'true;','false;'));
          //Bar��ɫ
          //joRes.Add('this.'+Name+'__clr="'+dwColor(BarColor)+'";');
          //>------
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
 
