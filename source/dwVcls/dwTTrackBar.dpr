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
    joData  : Variant;
    iTmp    : Integer;
    oChange : Procedure(Sender:TObject) of Object;
begin
    with TTrackBar(Actrl) do begin
        //用作TrackBar控件----------------------------------------------------------------------


        //
        joData    := _Json(AData);


        if joData.e = 'onchange' then begin
            //保存事件
            oChange   := TTrackBar(ACtrl).OnChange;
            //清空事件,以防止自动执行
            TTrackBar(ACtrl).OnChange  := nil;
            //更新值
            TTrackBar(ACtrl).Position    := StrToIntDef(dwUnescape(joData.v),0);
            //恢复事件
            TTrackBar(ACtrl).OnChange  := oChange;

            //执行事件
            if Assigned(TTrackBar(ACtrl).OnChange) then begin
                TTrackBar(ACtrl).OnChange(TTrackBar(ACtrl));
            end;
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
    with TTrackBar(Actrl) do begin
        //用作TrackBar控件----------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TTrackBar(ACtrl) do begin
            //外框
            sCode     := '<div'
                    +' :style="{left:'+dwFullName(Actrl)+'__lef,top:'+dwFullName(Actrl)+'__top,width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}"'
                    +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //
            sCode     := '    <el-slider'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwIIF(Orientation=trVertical,' vertical :height='+dwFullName(Actrl)+'__hei','')
                    +' :min="'+dwFullName(Actrl)+'__min"'
                    +' :max="'+dwFullName(Actrl)+'__max"'
                    +' v-model="'+dwFullName(Actrl)+'"'
                    +' :show-tooltip="'+dwFullName(Actrl)+'__swt"'
                    +dwGetDWAttr(joHint)
                    +dwIIF(Assigned(OnChange), Format(_DWEVENT,['change',Name,'(this.'+dwFullName(Actrl)+')','onchange',TForm(Owner).Handle]),'')
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);
        end;
        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sType     : string;
begin
    with TTrackBar(Actrl) do begin
        //用作TrackBar控件----------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        joRes.Add('    </el-slider>');               //此处需要和dwGetHead对应
        joRes.Add('</div>');               //此处需要和dwGetHead对应
        //
        Result    := (joRes);
    end;
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
    with TTrackBar(Actrl) do begin
        //用作TrackBar控件----------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TTrackBar(ACtrl) do begin
            //基本数据
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(not Enabled,'true,','false,'));


            //
            joRes.Add(dwFullName(Actrl)+':'+IntToStr(Position)+',');
            //显示legend
            //if (Max-Min)>0 then begin
            //     joRes.Add(dwFullName(Actrl)+'__pct:'+IntToStr(Round((Position-Min)*100/(Max-Min)))+',');
            //end else begin
            //     joRes.Add(dwFullName(Actrl)+'__pct:'+IntToStr(Position)+',');
            //end;
            //显示文本
            joRes.Add(dwFullName(Actrl)+'__swt:'+dwIIF(ShowHint,'true,','false,'));
            //高度
            //joRes.Add(dwFullName(Actrl)+'__stw:'+IntToStr(Height)+',');
            //在内显示文本
            //joRes.Add(dwFullName(Actrl)+'__tid:'+dwIIF(SmoothReverse,'true,','false,'));
            //Bar颜色
            //joRes.Add(dwFullName(Actrl)+'__clr:"'+dwColor(BarColor)+'",');
            //>------

            joRes.Add(dwFullName(Actrl)+'__min:'+IntToStr(Min)+',');
            joRes.Add(dwFullName(Actrl)+'__max:'+IntToStr(Max)+',');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     iSeries   : Integer;
     iX        : Integer;
     //
     joRes     : Variant;
     //
     sDat      : String;
     sGrid     : String;
begin
    with TTrackBar(Actrl) do begin
        //用作TrackBar控件----------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TTrackBar(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(not Enabled,'true;','false;'));

            //
            joRes.Add('this.'+dwFullName(Actrl)+'='+IntToStr(Position)+';');
            //显示legend
            //if (Max-Min)>0 then begin
            //     joRes.Add('this.'+dwFullName(Actrl)+'__pct='+IntToStr(Round((Position-Min)*100/(Max-Min)))+';');
            //end else begin
            //     joRes.Add('this.'+dwFullName(Actrl)+'__pct='+IntToStr(Position)+';');
            //end;
            //显示文本
            joRes.Add('this.'+dwFullName(Actrl)+'__swt='+dwIIF(ShowHint,'true;','false;'));
            //高度
            //joRes.Add('this.'+dwFullName(Actrl)+'__stw='+IntToStr(Height)+';');
            //在内显示文本
            //joRes.Add('this.'+dwFullName(Actrl)+'__tid='+dwIIF(SmoothReverse,'true;','false;'));
            //Bar颜色
            //joRes.Add('this.'+dwFullName(Actrl)+'__clr="'+dwColor(BarColor)+'";');
            //>------
            joRes.Add('this.'+dwFullName(Actrl)+'__min='+IntToStr(Min)+';');
            joRes.Add('this.'+dwFullName(Actrl)+'__max='+IntToStr(Max)+';');
        end;
        //
        Result    := (joRes);
    end;
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
