library dwTProgressBar;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

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

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TProgressBar使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //需要额外引的代码
     //joRes.Add('<script src="dist/_vcharts/echarts.min.js"></script>');
     //joRes.Add('<script src="dist/_vcharts/lib/index.min.js"></script>');
     //joRes.Add('<link rel="stylesheet" href="dist/_vcharts/lib/style.min.css">');


     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
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
          //保存事件
          oChange   := TProgressBar(ACtrl).OnChange;
          //清空事件,以防止自动执行
          TProgressBar(ACtrl).OnChange  := nil;
          //更新值
          TProgressBar(ACtrl).Text    := dwUnescape(joData.v);
          //恢复事件
          TProgressBar(ACtrl).OnChange  := oChange;

          //执行事件
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

     with TProgressBar(ACtrl) do begin
          //外框
          sCode     := '<div'
                    +' :style="{left:'+dwPrefix(Actrl)+Name+'__lef,top:'+dwPrefix(Actrl)+Name+'__top,width:'+dwPrefix(Actrl)+Name+'__wid,height:'+dwPrefix(Actrl)+Name+'__hei}"'
                    +' style="position:absolute;'
                    +'"' //style 封闭
                    +'>';
          //添加到返回值数据
          joRes.Add(sCode);

          //
          sCode     := '    <el-progress'
                    +' :percentage="'+dwPrefix(Actrl)+Name+'__pct"';    //百分比（必填）
          //type   进度条类型	string	line/circle/dashboard
          if State = pbsNormal then begin
               sCode     := sCode +' type="line"'
                    +' :stroke-width="'+dwPrefix(Actrl)+Name+'__stw"'  //进度条的宽度，单位 px	number	—	6
                    +' :text-inside="'+dwPrefix(Actrl)+Name+'__tid"'   //进度条显示文字内置在进度条内（只在 type=line 时可用）
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

     //生成返回值数组
     joRes.Add('    </el-progress>');               //此处需要和dwGetHead对应
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
     with TProgressBar(ACtrl) do begin
          //基本数据
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));

          //显示legend
          if (Max-Min)>0 then begin
               joRes.Add(dwPrefix(Actrl)+Name+'__pct:'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
          end else begin
               joRes.Add(dwPrefix(Actrl)+Name+'__pct:'+IntToStr(Position)+',');
          end;
          //显示文本
          joRes.Add(dwPrefix(Actrl)+Name+'__swt:'+dwIIF(ShowHint,'true,','false,'));
          //高度
          joRes.Add(dwPrefix(Actrl)+Name+'__stw:'+IntToStr(Height)+',');
          //在内显示文本
          joRes.Add(dwPrefix(Actrl)+Name+'__tid:'+dwIIF(SmoothReverse,'true,','false,'));
          //Bar颜色
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
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TProgressBar(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));

          //显示legend
          if (Max-Min)>0 then begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__pct='+IntToStr(Round((Position-Min)*100/(Max-Min)))+';');
          end else begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__pct='+IntToStr(Position)+';');
          end;
          //显示文本
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__swt='+dwIIF(ShowHint,'true;','false;'));
          //高度
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__stw='+IntToStr(Height)+';');
          //在内显示文本
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tid='+dwIIF(SmoothReverse,'true;','false;'));
          //Bar颜色
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
 
