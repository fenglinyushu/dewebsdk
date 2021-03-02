library dwTTrackBar;

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

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TTrackBar使用时需要用到
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


     if joData.event = 'onenter' then begin
          if Assigned(TTrackBar(ACtrl).OnEnter) then begin
               TTrackBar(ACtrl).OnEnter(TTrackBar(ACtrl));
          end;
     end else if joData.event = 'onchange' then begin
          //保存事件
          oChange   := TTrackBar(ACtrl).OnChange;
          //清空事件,以防止自动执行
          TTrackBar(ACtrl).OnChange  := nil;
          //更新值
          TTrackBar(ACtrl).Text    := dwUnescape(joData.value);
          //恢复事件
          TTrackBar(ACtrl).OnChange  := oChange;

          //执行事件
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

     with TTrackBar(ACtrl) do begin
          //外框
          sCode     := '<div'
                    +' :style="{left:'+Name+'__lef,top:'+Name+'__top,width:'+Name+'__wid,height:'+Name+'__hei}"'
                    +' style="position:absolute;'
                    +'"' //style 封闭
                    +'>';
          //添加到返回值数据
          joRes.Add(sCode);

          //
          sCode     := '    <el-slider'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwIIF(Orientation=trVertical,' vertical :height='+Name+'__hei','')
                    +' v-model="'+Name+'"'
                    +' :show-tooltip="'+Name+'__swt"'
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
     joRes.Add('    </el-slider>');               //此处需要和dwGetHead对应
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
     with TTrackBar(ACtrl) do begin
          //基本数据
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(not Enabled,'true,','false,'));


          //
          joRes.Add(Name+':'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
          //显示legend
          //if (Max-Min)>0 then begin
          //     joRes.Add(Name+'__pct:'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
          //end else begin
          //     joRes.Add(Name+'__pct:'+IntToStr(Position)+',');
          //end;
          //显示文本
          joRes.Add(Name+'__swt:'+dwIIF(ShowHint,'true,','false,'));
          //高度
          //joRes.Add(Name+'__stw:'+IntToStr(Height)+',');
          //在内显示文本
          //joRes.Add(Name+'__tid:'+dwIIF(SmoothReverse,'true,','false,'));
          //Bar颜色
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
     //生成返回值数组
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
          //显示legend
          //if (Max-Min)>0 then begin
          //     joRes.Add('this.'+Name+'__pct='+IntToStr(Round((Position-Min)*100/(Max-Min)))+';');
          //end else begin
          //     joRes.Add('this.'+Name+'__pct='+IntToStr(Position)+';');
          //end;
          //显示文本
          joRes.Add('this.'+Name+'__swt='+dwIIF(ShowHint,'true;','false;'));
          //高度
          //joRes.Add('this.'+Name+'__stw='+IntToStr(Height)+';');
          //在内显示文本
          //joRes.Add('this.'+Name+'__tid='+dwIIF(SmoothReverse,'true;','false;'));
          //Bar颜色
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
 
