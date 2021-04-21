library dwTChart;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     VclTee.TeeGDIPlus, VCLTee.Series, VCLTee.TeEngine, Vcl.ExtCtrls, VCLTee.TeeProcs, VCLTee.Chart,
     Math,
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

     //��Ҫ�������Ĵ���
     joRes.Add('<script src="dist/_vcharts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/_vcharts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/_vcharts/lib/style.min.css">');


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
          if Assigned(TChart(ACtrl).OnEnter) then begin
               TChart(ACtrl).OnEnter(TChart(ACtrl));
          end;
     end else if joData.e = 'onchange' then begin
          {
          //�����¼�
          oChange   := TChart(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TChart(ACtrl).OnChange  := nil;
          //����ֵ
          TChart(ACtrl).Text    := dwUnescape(joData.v);
          //�ָ��¼�
          TChart(ACtrl).OnChange  := oChange;

          //ִ���¼�
          if Assigned(TChart(ACtrl).OnChange) then begin
               TChart(ACtrl).OnChange(TChart(ACtrl));
          end;
          }
     end else if joData.e = 'onexit' then begin
          if Assigned(TChart(ACtrl).OnExit) then begin
               TChart(ACtrl).OnExit(TChart(ACtrl));
          end;
     end else if joData.e = 'onmouseenter' then begin
          if Assigned(TChart(ACtrl).OnMouseEnter) then begin
               TChart(ACtrl).OnMouseEnter(TChart(ACtrl));
          end;
     end else if joData.e = 'onmouseexit' then begin
          if Assigned(TChart(ACtrl).OnMouseLeave) then begin
               TChart(ACtrl).OnMouseLeave(TChart(ACtrl));
          end;
     end;
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

     with TChart(ACtrl) do begin
          //�õ�chart ����
          sType     := 've-line';
          if SeriesList.Count>0 then begin
               if Series[0].ClassName = 'TBarSeries' then begin
                    sType     := 've-histogram';
               end else if Series[0].ClassName = 'THorizBarSeries' then begin
                    sType     := 've-bar';
               end else if Series[0].ClassName = 'TPieSeries' then begin
                    sType     := 've-pie';
               end;
          end;



          //
          sCode     := '<div'
                    +' id="'+dwPrefix(Actrl)+Name+'"'
                    +dwVisible(TControl(ACtrl))                            //���ڿ��ƿɼ���Visible
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'"' // ���style
                    +'>';

          //��ӵ�����ֵ����
          joRes.Add(sCode);

          //
          sCode     := '    <'+sType
                    +' :legend="'+dwPrefix(Actrl)+Name+'__lgd"'
                    +' :legend-visible="'+dwPrefix(Actrl)+Name+'__lgv"'
                    +' :tooltip-visible="'+dwPrefix(Actrl)+Name+'__sht"'
                    //+' :extend="'+dwPrefix(Actrl)+Name+'__ext"'
                    +' :settings="'+dwPrefix(Actrl)+Name+'__set"'
                    +' :grid="'+dwPrefix(Actrl)+Name+'__grd"'
                    //+' :title='''+dwPrefix(Actrl)+Name+'__tit'''  //û����
                    +' :height="'+dwPrefix(Actrl)+Name+'__hei"'
                    +' :judge-width="true"'
                    +' :data="'+dwPrefix(Actrl)+Name+'__dat"'
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

     with TChart(ACtrl) do begin
          //
          sType     := 've-line';
          if SeriesList.Count>0 then begin
               if Series[0].ClassName = 'TBarSeries' then begin
                    sType     := 've-histogram';
               end else if Series[0].ClassName = 'THorizBarSeries' then begin
                    sType     := 've-bar';
               end else if Series[0].ClassName = 'TPieSeries' then begin
                    sType     := 've-pie';
               end;
          end;
     end;

     //���ɷ���ֵ����
     joRes.Add('    </'+sType+'>');       //�˴���Ҫ��dwGetHead��Ӧ
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
     with TChart(ACtrl) do begin
          //��������
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));

          //��ʾlegend
          joRes.Add(dwPrefix(Actrl)+Name+'__lgv:'+dwIIF(Legend.Visible,'true,','false,'));
          //��ʾhint
          joRes.Add(dwPrefix(Actrl)+Name+'__sht:'+dwIIF(ShowHint,'true,','false,'));
          //��ʾTitle
          //joRes.Add(dwPrefix(Actrl)+Name+'__tit:"'+Title.ToString+'",');
          //����ɫ�ͱ߾�
          if Legend.Visible then begin
               if Legend.Alignment = laLeft then begin
                    sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:'+IntToStr(Legend.ColorWidth)+',x2:10,y:10,y2:10}';
               end else if Legend.Alignment = laRight then begin
                    sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:'+IntToStr(Legend.ColorWidth)+',y:10,y2:10}';
               end else if Legend.Alignment = laTop then begin
                    sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:40,y2:10}';
               end else if Legend.Alignment = laBottom then begin
                    sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:10,y2:40}';
               end;
          end else begin
               sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:10,y2:10}';
          end;
          sGrid     := Format(sGrid,[dwColor(Color),dwColor(BackWall.Pen.Color)]);
          joRes.Add(dwPrefix(Actrl)+Name+'__grd:'+sGrid+',');

          //����Title���Է�����洦��
          for iSeries := 0 to SeriesList.Count-1 do begin
               if Trim(Series[iSeries].Title) = '' then begin
                    Series[iSeries].Title    := Series[iSeries].Name;
               end;
          end;


          //<------Data

          //
          if SeriesList.Count = 0 then begin
               joRes.Add(dwPrefix(Actrl)+Name+'__set:{},');
               //
               sDat      := '{columns: [''X'',''Value''],'#13;
               //���rows
               sDat := sDat +'rows: []}';
          end else begin
               //Area����ѵ�Ч��
               if Series[0].ClassName = 'TAreaSeries' then begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__set:{area:true},');
               end else if Series[0].ClassName = 'TPieSeries' then begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__set:{radius:'+IntToStr(Min(Width,Height) div 4)+'},');
               end else begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__set:{},');
               end;

               if Series[0].ClassName = 'TPieSeries' then begin
                    sDat      := '{columns: [''X'',''Value''],'#13;
                    //���rows
                    sDat := sDat +'rows: [';

                    for iX := 0 to Series[0].XValues.Count-1 do begin
                         //
                         sDat := sDat +'{''X'':'''+TPieSeries(Series[0]).XLabel[iX]+''','
                                   +'''Value'':'''+FloatToStr(TPieSeries(Series[0]).YValue[iX])+'''},'#13;
                    end;
                    Delete(sDat,Length(sDat)-1,2);
                    sDat := sDat +']}';
               end else begin
                    sDat      := '{columns: [';
                    sDat := sDat +'''X''';
                    //���columns
                    for iSeries := 0 to SeriesList.Count-1 do begin
                         //
                         sDat := sDat +','''+Series[iSeries].Title+'''';
                    end;
                    sDat := sDat +'],'#13;
                    //���rows
                    sDat := sDat +'rows: [';
                    if Series[0].Labels.Count  = Series[0].XValues.Count then begin
                         for iX := 0 to Series[0].Labels.Count-1 do begin
                              //
                              sDat := sDat +'{''X'':'''+Series[0].Labels[iX]+'''';
                              for iSeries := 0 to SeriesList.Count-1 do begin
                                   sDat := sDat +','''+Series[iSeries].Title+''':'''+FloatToStr(Series[iSeries].YValues[iX])+'''';
                              end;
                              sDat := sDat +'},'#13;
                         end;
                    end else begin
                         for iX := 0 to Series[0].XValues.Count-1 do begin
                              //
                              sDat := sDat +'{''X'':'''+FloatToStr(Series[0].XValues[iX])+'''';
                              for iSeries := 0 to SeriesList.Count-1 do begin
                                   sDat := sDat +','''+Series[iSeries].Title+''':'''+FloatToStr(Series[iSeries].YValues[iX])+'''';
                              end;
                              sDat := sDat +'},'#13;
                         end;
                    end;
                    Delete(sDat,Length(sDat)-1,2);
                    sDat := sDat +']}';
               end;
          end;
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__dat:'+sDat+',');
          //>------

          //<------Legend
          if SeriesList.Count = 0 then begin
               joRes.Add(dwPrefix(Actrl)+Name+'__lgd:{},');
          end else begin
               sDat      := '{';
               //���ַ���
               if Legend.Inverted then begin
                    sDat := sDat + 'orient: ''vertical'','
               end else begin
                    sDat := sDat + 'orient: ''horizontal'','
               end;
               //λ��
               if Legend.Alignment = laLeft then begin
                    sDat := sDat + 'x:''left'',y:''center'',';
               end else if Legend.Alignment = laRight then begin
                    sDat := sDat + 'x:''right'',y:''center'',';
               end else if Legend.Alignment = laTop then begin
                    sDat := sDat + 'x:''center'',y:''top'',';
               end else if Legend.Alignment = laBottom then begin
                    sDat := sDat + 'x:''center'',y:''bottom'',';
               end;
               //��ɫ
               sDat := sDat + 'textStyle:{color:"'+dwColor(Legend.Font.Color)+'"}';
               //����
               sDat := sDat + '}';
          end;
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__lgd:'+sDat+',');
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
     with TChart(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));

          //��ʾlegend
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lgv='+dwIIF(Legend.Visible,'true;','false;'));
          //��ʾhint
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__sht='+dwIIF(ShowHint,'true;','false;'));
          //��ʾTitle
          //joRes.Add(Name+'__tit:"'+Title.ToString+'",');
          //����ɫ�ͱ߾�
          if Legend.Visible then begin
               sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:40,y2:10}';
          end else begin
               sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:10,y2:10}';
          end;
          sGrid     := Format(sGrid,[dwColor(Color),dwColor(BackWall.Pen.Color)]);
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__grd='+sGrid+';');

          //����Title���Է�����洦��
          for iSeries := 0 to SeriesList.Count-1 do begin
               if Trim(Series[iSeries].Title) = '' then begin
                    Series[iSeries].Title    := Series[iSeries].Name;
               end;
          end;

          if SeriesList.Count = 0 then begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={};');
               //
               sDat      := '{columns: [''X'',''Value''],'#13;
               //���rows
               sDat := sDat +'rows: []}';
          end else begin
               //Area����ѵ�Ч��
               if Series[0].ClassName = 'TAreaSeries' then begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={area:true};');
               end else if Series[0].ClassName = 'TPieSeries' then begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={radius:'+IntToStr(Min(Width,Height) div 3)+'};');
               end else begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={};');
               end;

               //<------Data
               if Series[0].ClassName = 'TPieSeries' then begin
                    //���columns
                    sDat      := '{columns: [''X'',''Value''],'#13;
                    //���rows
                    sDat := sDat +'rows: [';

                    for iX := 0 to Series[0].XValues.Count-1 do begin
                         //
                         sDat := sDat +'{''X'':'''+TPieSeries(Series[0]).XLabel[iX]+''','
                                   +'''Value'':'''+FloatToStr(TPieSeries(Series[0]).YValue[iX])+'''},'#13;
                    end;
                    Delete(sDat,Length(sDat)-1,2);
                    sDat := sDat +']}';
               end else begin
                    //���columns
                    sDat      := '{columns: [';
                    sDat := sDat +'''X''';
                    for iSeries := 0 to SeriesList.Count-1 do begin
                         //
                         sDat := sDat +','''+Series[iSeries].Title+'''';
                    end;
                    sDat := sDat +'],'#13;
                    //���rows
                    sDat := sDat +'rows: [';

                    //
                    if Series[0].Labels.Count  = Series[0].XValues.Count then begin
                         for iX := 0 to Series[0].Labels.Count-1 do begin
                              //
                              sDat := sDat +'{''X'':'''+(Series[0].Labels[iX])+'''';
                              for iSeries := 0 to SeriesList.Count-1 do begin
                                   sDat := sDat +','''+Series[iSeries].Title+''':'''+FloatToStr(Series[iSeries].YValues[iX])+'''';
                              end;
                              sDat := sDat +'},'#13;
                         end;
                    end else begin
                         for iX := 0 to Series[0].XValues.Count-1 do begin
                              //
                              sDat := sDat +'{''X'':'''+FloatToStr(Series[0].XValues[iX])+'''';
                              for iSeries := 0 to SeriesList.Count-1 do begin

                                   sDat := sDat +','''+Series[iSeries].Title+''':'''+FloatToStr(Series[iSeries].YValues[iX])+'''';
                              end;
                              sDat := sDat +'},'#13;
                         end;
                    end;
                    Delete(sDat,Length(sDat)-1,2);
                    sDat := sDat +']}';
               end;
          end;
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dat='+sDat+';');
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

