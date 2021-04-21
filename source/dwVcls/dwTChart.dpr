library dwTChart;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

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

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //需要额外引的代码
     joRes.Add('<script src="dist/_vcharts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/_vcharts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/_vcharts/lib/style.min.css">');


     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
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
          //保存事件
          oChange   := TChart(ACtrl).OnChange;
          //清空事件,以防止自动执行
          TChart(ACtrl).OnChange  := nil;
          //更新值
          TChart(ACtrl).Text    := dwUnescape(joData.v);
          //恢复事件
          TChart(ACtrl).OnChange  := oChange;

          //执行事件
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


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sType     : string;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     with TChart(ACtrl) do begin
          //得到chart 类型
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
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +'"' // 封闭style
                    +'>';

          //添加到返回值数据
          joRes.Add(sCode);

          //
          sCode     := '    <'+sType
                    +' :legend="'+dwPrefix(Actrl)+Name+'__lgd"'
                    +' :legend-visible="'+dwPrefix(Actrl)+Name+'__lgv"'
                    +' :tooltip-visible="'+dwPrefix(Actrl)+Name+'__sht"'
                    //+' :extend="'+dwPrefix(Actrl)+Name+'__ext"'
                    +' :settings="'+dwPrefix(Actrl)+Name+'__set"'
                    +' :grid="'+dwPrefix(Actrl)+Name+'__grd"'
                    //+' :title='''+dwPrefix(Actrl)+Name+'__tit'''  //没引入
                    +' :height="'+dwPrefix(Actrl)+Name+'__hei"'
                    +' :judge-width="true"'
                    +' :data="'+dwPrefix(Actrl)+Name+'__dat"'
                    +'>';
          //添加到返回值数据
          joRes.Add(sCode);
     end;
     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sType     : string;
begin
     //生成返回值数组
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

     //生成返回值数组
     joRes.Add('    </'+sType+'>');       //此处需要和dwGetHead对应
     joRes.Add('</div>');               //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
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
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TChart(ACtrl) do begin
          //基本数据
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));

          //显示legend
          joRes.Add(dwPrefix(Actrl)+Name+'__lgv:'+dwIIF(Legend.Visible,'true,','false,'));
          //显示hint
          joRes.Add(dwPrefix(Actrl)+Name+'__sht:'+dwIIF(ShowHint,'true,','false,'));
          //显示Title
          //joRes.Add(dwPrefix(Actrl)+Name+'__tit:"'+Title.ToString+'",');
          //背景色和边距
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

          //更新Title，以方便后面处理
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
               //添加rows
               sDat := sDat +'rows: []}';
          end else begin
               //Area面积堆叠效果
               if Series[0].ClassName = 'TAreaSeries' then begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__set:{area:true},');
               end else if Series[0].ClassName = 'TPieSeries' then begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__set:{radius:'+IntToStr(Min(Width,Height) div 4)+'},');
               end else begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__set:{},');
               end;

               if Series[0].ClassName = 'TPieSeries' then begin
                    sDat      := '{columns: [''X'',''Value''],'#13;
                    //添加rows
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
                    //添加columns
                    for iSeries := 0 to SeriesList.Count-1 do begin
                         //
                         sDat := sDat +','''+Series[iSeries].Title+'''';
                    end;
                    sDat := sDat +'],'#13;
                    //添加rows
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
               //文字方向
               if Legend.Inverted then begin
                    sDat := sDat + 'orient: ''vertical'','
               end else begin
                    sDat := sDat + 'orient: ''horizontal'','
               end;
               //位置
               if Legend.Alignment = laLeft then begin
                    sDat := sDat + 'x:''left'',y:''center'',';
               end else if Legend.Alignment = laRight then begin
                    sDat := sDat + 'x:''right'',y:''center'',';
               end else if Legend.Alignment = laTop then begin
                    sDat := sDat + 'x:''center'',y:''top'',';
               end else if Legend.Alignment = laBottom then begin
                    sDat := sDat + 'x:''center'',y:''bottom'',';
               end;
               //字色
               sDat := sDat + 'textStyle:{color:"'+dwColor(Legend.Font.Color)+'"}';
               //结束
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
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TChart(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));

          //显示legend
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lgv='+dwIIF(Legend.Visible,'true;','false;'));
          //显示hint
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__sht='+dwIIF(ShowHint,'true;','false;'));
          //显示Title
          //joRes.Add(Name+'__tit:"'+Title.ToString+'",');
          //背景色和边距
          if Legend.Visible then begin
               sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:40,y2:10}';
          end else begin
               sGrid     := '{show:true, backgroundColor: "%s",  borderColor: "%s",x:10,x2:10,y:10,y2:10}';
          end;
          sGrid     := Format(sGrid,[dwColor(Color),dwColor(BackWall.Pen.Color)]);
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__grd='+sGrid+';');

          //更新Title，以方便后面处理
          for iSeries := 0 to SeriesList.Count-1 do begin
               if Trim(Series[iSeries].Title) = '' then begin
                    Series[iSeries].Title    := Series[iSeries].Name;
               end;
          end;

          if SeriesList.Count = 0 then begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={};');
               //
               sDat      := '{columns: [''X'',''Value''],'#13;
               //添加rows
               sDat := sDat +'rows: []}';
          end else begin
               //Area面积堆叠效果
               if Series[0].ClassName = 'TAreaSeries' then begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={area:true};');
               end else if Series[0].ClassName = 'TPieSeries' then begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={radius:'+IntToStr(Min(Width,Height) div 3)+'};');
               end else begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__set={};');
               end;

               //<------Data
               if Series[0].ClassName = 'TPieSeries' then begin
                    //添加columns
                    sDat      := '{columns: [''X'',''Value''],'#13;
                    //添加rows
                    sDat := sDat +'rows: [';

                    for iX := 0 to Series[0].XValues.Count-1 do begin
                         //
                         sDat := sDat +'{''X'':'''+TPieSeries(Series[0]).XLabel[iX]+''','
                                   +'''Value'':'''+FloatToStr(TPieSeries(Series[0]).YValue[iX])+'''},'#13;
                    end;
                    Delete(sDat,Length(sDat)-1,2);
                    sDat := sDat +']}';
               end else begin
                    //添加columns
                    sDat      := '{columns: [';
                    sDat := sDat +'''X''';
                    for iSeries := 0 to SeriesList.Count-1 do begin
                         //
                         sDat := sDat +','''+Series[iSeries].Title+'''';
                    end;
                    sDat := sDat +'],'#13;
                    //添加rows
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

