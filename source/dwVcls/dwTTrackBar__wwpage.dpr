library dwTTrackBar__wwpage;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     System.TypInfo,
     Math,
     ComCtrls,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms,

    Messages,  Variants,  Graphics,
         ExtCtrls;


function HasProperty(AComponent: TComponent; APropertyName: String): Boolean;
var
    PropInfo : PPropInfo;
begin
    PropInfo:=getpropinfo(AComponent.classinfo,APropertyName);
    Result:=PropInfo<>nil;
end;


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
        //用作分页控件--------------------------------------------------------------------------

        //
        joData    := _Json(AData);


        if joData.e = 'onchange' then begin
            //保存事件
            oChange   := TTrackBar(ACtrl).OnChange;
            //清空事件,以防止自动执行
            TTrackBar(ACtrl).OnChange  := nil;
            //更新值
            iTmp    := StrToIntDef(dwUnescape(joData.v),0);
            iTmp    := Math.Max(iTmp,1);
            iTmp    := Math.Min(iTmp,Ceil(Max/PageSize));
            TTrackBar(ACtrl).Position    := iTmp;//StrToIntDef(dwUnescape(joData.v),0);
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
    iMax,iMin   : Integer;
    iTotal      : Integer;
    iLeft       : Integer;
    iFontSize   : Integer;  //字体
    //
    bGoto       : Boolean;  //是否显示goto, 默认true
    bTotal      : Boolean;  //是否显示total,默认true
    bPageSize   : Boolean;  //是否显示每页条数，默认为true
    //
    sCode       : string;
    sType       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
    //
    oParent     : TWinControl;
    oChange     : Procedure(Sender:TObject) of Object;
begin
    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //取得控件全名备用
        sFull   := dwFullName(Actrl);

        //是否显示goto, 默认true
        bGoto   := True;
        if joHint.Exists('goto') then begin
            bGoto   := joHint.goto = 1;
        end;

        //是否显示PageSize, 默认true
        bPageSize   := True;
        if joHint.Exists('pagesize') then begin
            bPageSize   := joHint.pagesize = 1;
        end;

        //是否显示total, 默认true
        bTotal  := True;
        if joHint.Exists('total') then begin
            bTotal  := joHint.total = 1;
        end;

        //
        oParent := Parent;
        if HasProperty(oParent,'Font') then begin
            iFontSize   := TPanel(oParent).Font.Size+3;
        end else begin
            iFontSize   := 14;
        end;

        //
        with TTrackBar(ACtrl) do begin
            //如果position = 0 , 则改为1。为了防止改的过程中激活事件，所以需要下面处理
            if Position = 0 then begin
                oChange     := OnChange;
                OnChange    := nil;
                Position    := 1;
                OnChange    := oChange;
                oChange     := nil;
            end;

            //外框
            sCode     := '<div'
                    +' v-show="'+sFull+'__vis"'
                    +' :style="{'
                        +'left:'+sFull+'__lef,'
                        +'top:'+sFull+'__top,'
                        +'width:'+sFull+'__wid,'
                        +'height:'+sFull+'__hei}'
                    +'"'
                    +' style="'
                        +'position:absolute;'
                        +'color:#969696;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //prev按钮
            sCode     := '    <el-button v-for="(item,i) in '+sFull+'__lst" '
                    //+' id="'+sFull+'__pr"'
                    +' style="position:absolute;top:5px;width:30px;height:30px;border:0;font-size:'+IntToStr(iFontSize)+'px;"'
                    +' :icon="item.icon"' //el-icon-arrow-left"'
                    //+' type="primary"'
                    +' :key="i"'
                    //+' :plain="item.plain"'

                    +' :style="{left:item.left,color:item.color,''background-color'':item.bkcolor}"'
                    +' @click=dwevent("","'+sFull+'",item.dest,"onchange",'+IntToStr(TForm(Owner).Handle)+');'
                    +'>'
                    +'{{item.caption}}'
                    +'</el-button>';
            joRes.Add(sCode);

            //求当前按钮的最小值和最大值
            iTotal  := Ceil(Max/PageSize);
            if Position <= 3 then begin
                iMin    := 1;
                iMax    := Math.Min(iTotal,iMin+4);
            end else if Position >= iTotal-2 then begin
                iMax    := iTotal;
                iMin    := Math.Max(1,iTotal-4);
            end else begin
                iMin    := Position - 2;
                iMax    := iMin + 4;
            end;

            //<---跳转------------------------------------------------------------------------------
            //外框
            sCode     := '<div'
                    +' v-show="'+sFull+'__gtv"'
                    +' :style="{'
                        +'left:'+sFull+'__gtl'
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        +'color:#969696;'
                        +'top:0,'
                        +'width:300,'
                        +'height:100%;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //
            sCode     := '    <div'
                    //+' id="'+sFull+'__pr"'
                    +' style="position:absolute;'
                        +'left:0px;'
                        +'top:5px;'
                        +'width:50px;'
                        +'line-height:30px;'
                        +'height:30px;'
                        +'text-align:right;'
                        +'font-size:'+IntToStr(iFontSize)+'px;'
                    +'"'
                    +'>前往'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //页码按钮
            sCode     := '    <el-input'
                    +' v-model='+sFull+'__cpg'
                    +' style="position:absolute;'
                        +'left:50px;'
                        +'top:5px;'
                        +'width:50px;'
                        +'line-height:30px;'
                        +'height:30px;'
                        +'text-align:center;'
                        +'font-size:'+IntToStr(iFontSize)+'px;'
                    +'"'
                    +' @change=function(val){dwevent("","'+sFull+'",val,"onchange",'+IntToStr(TForm(Owner).Handle)+');}'
                    +'>'
                    +'</el-input>';
            //添加到返回值数据
            joRes.Add(sCode);

            //按钮
            sCode     := '    <div'
                    +' style="position:absolute;left:100px;top:5px;width:50px;line-height:30px;height:30px;text-align:left;"'
                    +'>页'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //goto外框封闭
            joRes.Add('</div>');
            //>----

            //<---显示"每页XX条"--------------------------------------------------------------------
            //外框
            sCode     := '<div'
                    +' v-show="'+sFull+'__psv"'
                    +' :style="{'
                        +'left:'+sFull+'__psl'
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        +'color:#969696;'
                        +'top:0,'
                        +'width:300,'
                        +'height:100%;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //
            sCode     := '    <div'
                    //+' id="'+sFull+'__pr"'
                    +' style="position:absolute;'
                        +'left:0px;'
                        +'top:5px;'
                        +'width:50px;'
                        +'line-height:30px;'
                        +'height:30px;'
                        +'text-align:right;'
                        +'font-size:'+IntToStr(iFontSize)+'px;'
                    +'"'
                    +'>每页'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //页码按钮
            sCode     := '    <div'
                    +' style="position:absolute;'
                        +'left:50px;'
                        +'top:5px;'
                        +'width:50px;'
                        +'line-height:30px;'
                        +'height:30px;'
                        +'text-align:center;'
                        +'font-size:'+IntToStr(iFontSize)+'px;'
                    +'"'
                    +' @change=function(val){dwevent("","'+sFull+'",val,"onchange",'+IntToStr(TForm(Owner).Handle)+');}'
                    +'>'
                    +'{{'+sFull+'__pgs}}'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //按钮
            sCode     := '    <div'
                    +' style="position:absolute;left:100px;top:5px;width:50px;line-height:30px;height:30px;text-align:left;"'
                    +'>条'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //pagesize外框封闭
            joRes.Add('</div>');
            //>----

            //<---总页数----------------------------------------------------------------------------
            //外框
            sCode     := '<div'
                    +' v-show="'+sFull+'__ttv"'
                    +' :style="{'
                        +'left:'+sFull+'__ttl'
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        +'color:#969696;'
                        +'top:0,'
                        +'width:300,'
                        +'height:100%;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //
            sCode     := '    <div'
                    +' style="position:absolute;left:0;top:5px;width:50px;line-height:30px;height:30px;text-align:right"'
                    +'>总'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //next按钮
            sCode     := '    <div'
                    +' value="1"'
                    +' style="position:absolute;left:50px;top:5px;width:50px;line-height:30px;height:30px;text-align:center"'
                    +'>{{'+sFull+'__tot}}'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //next按钮
            sCode     := '    <div'
                    +' style="position:absolute;left:100px;top:5px;width:50px;line-height:30px;height:30px;text-align:left;"'
                    +'>条'
                    +'</div>';
            //添加到返回值数据
            joRes.Add(sCode);

            //外框封闭
            joRes.Add('</div>');
            //>----
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
        //用作分页控件--------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        //joRes.Add('    </el-pagination>');               //此处需要和dwGetHead对应
        joRes.Add('</div>');               //此处需要和dwGetHead对应
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    iSeries     : Integer;
    iItem       : Integer;
    iMax,iMin   : Integer;
    iLeft       : Integer;
    iTotal      : Integer;
    //
    sCode       : String;
    sGrid       : String;
    sFull       : string;
    //
    bGoto       : Boolean;  //是否显示goto, 默认true
    bTotal      : Boolean;  //是否显示total,默认true
    bPageSize   : Boolean;  //是否显示每页条数，默认为true

    //
    joRes       : Variant;
    joList      : Variant;
    joItem      : Variant;
    joHint      : Variant;
begin
    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------

        //取得控件全名备用
        sFull   := dwFullName(Actrl);

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //是否显示goto, 默认true
        bGoto   := True;
        if joHint.Exists('goto') then begin
            bGoto   := joHint.goto = 1;
        end;

        //是否显示PageSize, 默认true
        bPageSize   := True;
        if joHint.Exists('pagesize') then begin
            bPageSize   := joHint.pagesize = 1;
        end;

        //是否显示total, 默认true
        bTotal  := True;
        if joHint.Exists('total') then begin
            bTotal  := joHint.total = 1;
        end;

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TTrackBar(ACtrl) do begin
            //基本数据
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(sFull+'__dis:'+dwIIF(not Enabled,'true,','false,'));


            //
            joRes.Add(sFull+'__pgs:'+IntToStr(Math.Max(1,PageSize))+',');
            joRes.Add(sFull+'__cpg:'+IntToStr(Math.Max(1,Position))+',');
            joRes.Add(sFull+'__tot:'+IntToStr(Max)+',');


            //求当前按钮的最小值和最大值
            iTotal  := Ceil(Max/PageSize);
            if Position <= 3 then begin
                iMin    := 1;
                iMax    := Math.Min(iTotal,iMin+4);
            end else if Position >= iTotal-2 then begin
                iMax    := iTotal;
                iMin    := Math.Max(1,iTotal-4);
            end else begin
                iMin    := Position - 2;
                iMax    := iMin + 4;
            end;

            //得到页面占用left
            iLeft   := 10+40+(iMax-iMin+1)*40+40; //左边距10， 每个按钮40


            //goto
            joRes.Add(sFull+'__gtl:"'+IntToStr(iLeft)+'px",');      //goto left
            joRes.Add(sFull+'__gtv:'+dwIIF(bGoto and (Width>iLeft+150),'true,','false,'));     //goto left
            if bGoto then begin
                iLeft   := iLeft + 150;
            end;

            //PageSize
            joRes.Add(sFull+'__psl:"'+IntToStr(iLeft)+'px",');      //goto left
            joRes.Add(sFull+'__psv:'+dwIIF(bPageSize and (Width>iLeft+150),'true,','false,'));     //goto left
            if bPageSize then begin
                iLeft   := iLeft + 150;
            end;

            //Total
            joRes.Add(sFull+'__ttl:"'+IntToStr(Width-150)+'px",');      //goto left
            joRes.Add(sFull+'__ttv:'+dwIIF(bTotal and (Width>iLeft+150),'true,','false,'));     //goto left

            //
            joList  := _json('[]');
            //前一页
            iLeft           := 10;
            joItem          := _json('{}');
            joItem.left     := IntToStr(iLeft)+'px';    //left
            joItem.icon     := 'el-icon-arrow-left';    //icon
            joItem.caption  := '';
            joItem.dest     := Math.Max(1,Position-1);
            joItem.color    := '#303030';
            joItem.bkcolor  := '#f4f4f4';
            joList.Add(joItem);
            iLeft           := iLeft+40;
            for iItem := iMin to iMax do begin
                joItem          := _json('{}');
                joItem.left     := IntToStr(iLeft)+'px';
                joItem.icon     := '';
                joItem.caption  := IntToStr(iItem);
                joItem.dest     := iItem;
                if iItem = Position then begin
                    joItem.bkcolor  := '#409eff';
                    joItem.color    := '#ffffff';
                end else begin
                    joItem.color    := '#969696';
                    joItem.bkcolor  := '#f4f4f4';
                end;
                joList.Add(joItem);
                iLeft           := iLeft+40;
            end;
            //后一页
            joItem          := _json('{}');
            joItem.left     := IntToStr(iLeft)+'px';
            joItem.icon     := 'el-icon-arrow-right';
            joItem.caption  := '';
            joItem.dest     := Math.Min(iTotal,Position+1);
            joItem.color    := '#303030';
            joItem.bkcolor  := '#f4f4f4';
            joList.Add(joItem);
            //
            sCode   := VariantSaveJSON(joList);
            joRes.Add(sFull+'__lst:'+sCode+',');

        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    iSeries     : Integer;
    iItem       : Integer;
    iMax,iMin   : Integer;
    iLeft       : Integer;
    iTotal      : Integer;
    //
    joRes       : Variant;
    //
    sCode       : String;
    sGrid       : String;
    sFull       : string;
    //
    bGoto       : Boolean;  //是否显示goto, 默认true
    bTotal      : Boolean;  //是否显示total,默认true
    bPageSize   : Boolean;  //是否显示每页条数，默认为true

    joList      : Variant;
    joItem      : Variant;
    joHint      : Variant;
begin
    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------

        //取得控件全名备用
        sFull   := dwFullName(Actrl);

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //是否显示goto, 默认true
        bGoto   := True;
        if joHint.Exists('goto') then begin
            bGoto   := joHint.goto = 1;
        end;

        //是否显示PageSize, 默认true
        bPageSize   := True;
        if joHint.Exists('pagesize') then begin
            bPageSize   := joHint.pagesize = 1;
        end;

        //是否显示total, 默认true
        bTotal  := True;
        if joHint.Exists('total') then begin
            bTotal  := joHint.total = 1;
        end;
        //
        with TTrackBar(ACtrl) do begin
            //基本数据
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+sFull+'__dis='+dwIIF(not Enabled,'true;','false;'));


            //
            //joRes.Add(sFull+':'+IntToStr(Position)+',');
            //
            joRes.Add('this.'+sFull+'__pgs='+IntToStr(Math.Max(1,PageSize))+';');
            joRes.Add('this.'+sFull+'__cpg='+IntToStr(Math.Max(1,Position))+';');
            joRes.Add('this.'+sFull+'__tot='+IntToStr(Max)+';');


            //求当前按钮的最小值和最大值
            iTotal  := Ceil(Max/PageSize);
            if Position <= 3 then begin
                iMin    := 1;
                iMax    := Math.Min(iTotal,iMin+4);
            end else if Position >= iTotal-2 then begin
                iMax    := iTotal;
                iMin    := Math.Max(1,iTotal-4);
            end else begin
                iMin    := Position - 2;
                iMax    := iMin + 4;
            end;

            //用于Goto的几个Left值
            iLeft   := 10+40+(iMax-iMin+1)*40+40;

            //goto
            joRes.Add('this.'+sFull+'__gtl="'+IntToStr(iLeft)+'px";');      //goto left
            joRes.Add('this.'+sFull+'__gtv='+dwIIF(bGoto and (Width>iLeft+150),'true;','false;'));     //goto left
            if bGoto then begin
                iLeft   := iLeft + 150;
            end;

            //PageSize
            joRes.Add('this.'+sFull+'__psl="'+IntToStr(iLeft)+'px";');      //goto left
            joRes.Add('this.'+sFull+'__psv='+dwIIF(bPageSize and (Width>iLeft+150),'true;','false;'));     //goto left
            if bPageSize then begin
                iLeft   := iLeft + 150;
            end;

            //Total
            joRes.Add('this.'+sFull+'__ttl="'+IntToStr(Width-150)+'px";');      //goto left
            joRes.Add('this.'+sFull+'__ttv='+dwIIF(bTotal and (Width>iLeft+150),'true;','false;'));     //goto left



            joList  := _json('[]');
            //前一页
            iLeft           := 10;
            joItem          := _json('{}');
            joItem.left     := IntToStr(iLeft)+'px';    //left
            joItem.icon     := 'el-icon-arrow-left';    //icon
            joItem.caption  := '';
            joItem.dest     := Math.Max(1,Position-1);
            joItem.color    := '#303030';
            joItem.bkcolor  := '#f4f4f4';
            joList.Add(joItem);
            iLeft           := iLeft+40;
            for iItem := iMin to iMax do begin
                joItem          := _json('{}');
                joItem.left     := IntToStr(iLeft)+'px';
                joItem.icon     := '';
                joItem.caption  := IntToStr(iItem);
                joItem.dest     := iItem;
                if iItem = Position then begin
                    joItem.bkcolor  := '#409eff';
                    joItem.color    := '#ffffff';
                end else begin
                    joItem.color    := '#969696';
                    joItem.bkcolor  := '#f4f4f4';
                end;
                joList.Add(joItem);
                iLeft           := iLeft+40;
            end;
            //后一页
            joItem          := _json('{}');
            joItem.left     := IntToStr(iLeft)+'px';
            joItem.icon     := 'el-icon-arrow-right';
            joItem.caption  := '';
            joItem.dest     := Math.Min(iTotal,Position+1);
            joItem.color    := '#303030';
            joItem.bkcolor  := '#f4f4f4';
            joList.Add(joItem);
            //
            sCode   := VariantSaveJSON(joList);
            joRes.Add('this.'+sFull+'__lst='+sCode+';');

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
 
