library dwTTrackBar__page;

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
    bTmp    : Boolean;
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
            TTrackBar(ACtrl).Position    := Math.Max(0,iTmp-1);//StrToIntDef(dwUnescape(joData.v),0);
            //恢复事件
            TTrackBar(ACtrl).OnChange  := oChange;

            //执行事件
            if Assigned(TTrackBar(ACtrl).OnChange) then begin
                TTrackBar(ACtrl).OnChange(TTrackBar(ACtrl));
            end;
        end else if joData.e = 'onsizechange' then begin

            //执行事件
            if Assigned(TTrackBar(ACtrl).OnDragOver) then begin
                //更新值
                iTmp    := StrToIntDef(dwUnescape(joData.v),0);
                TTrackBar(ACtrl).OnDragOver(TTrackBar(ACtrl),nil,iTmp,0,dsDragEnter,bTmp);
            end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sType   : string;
    sFull   : string;
    sPages  : string;
    //
    joHint  : Variant;
    joRes   : Variant;
begin
    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------

        //生成返回值数组
        joRes       := _Json('[]');

        //
        sFull       := dwFullName(ACtrl);

        //取得HINT对象JSON
        joHint      := dwGetHintJson(TControl(ACtrl));

        //取得每页行数列表
        sPages      := '';
        if joHint.Exists('pagesizes') then begin
            sPages  := ' :page-sizes ="'+joHint.pagesizes+'"';
        end;

        with TTrackBar(ACtrl) do begin
            //外框
            sCode     := '<div'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' :style="{left:'+sFull+'__lef,top:'+sFull+'__top,width:'+sFull+'__wid,height:'+sFull+'__hei}"'
                    +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //
            sCode     := '<el-pagination'
                    //+' id="'+sFull+'"'
                    //+dwVisible(TControl(ACtrl))
                    //+dwDisable(TControl(ACtrl))
                    //+dwIIF(Orientation=trVertical,' vertical :height='+sFull+'__hei','')
                    +' :total="'+sFull+'__tot"'
                    +' :page-size="'+sFull+'__pgs"'
                    +' :current-page="'+sFull+'__cpg"'
                    +sPages
                    +dwGetDWAttr(joHint)
                    //currentPage 改变时会触发
                    +dwIIF(Assigned(OnChange), ' @current-change="'+sFull+'__currentchange"','')
                    //pageSize 改变时会触发
                    +dwIIF(Assigned(OnDragOver), ' @size-change="'+sFull+'__sizechange"','')
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
        //用作分页控件--------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        joRes.Add('</el-pagination>');               //此处需要和dwGetHead对应
        joRes.Add('</div>');               //此处需要和dwGetHead对应
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    iSeries : Integer;
    iX      : Integer;
    //
    joRes   : Variant;
    //
    sDat    : String;
    sGrid   : String;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------

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
            //joRes.Add(sFull+':'+IntToStr(Position)+',');
            //
            joRes.Add(sFull+'__pgs:'+IntToStr(Math.Max(1,PageSize))+',');
            joRes.Add(sFull+'__cpg:'+IntToStr(Position+1)+',');
            joRes.Add(sFull+'__tot:'+IntToStr(Max)+',');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    iSeries : Integer;
    iX      : Integer;
    //
    joRes   : Variant;
    //
    sDat    : String;
    sGrid   : String;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------


        //生成返回值数组
        joRes    := _Json('[]');

        //
        with TTrackBar(ACtrl) do begin
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+sFull+'__dis='+dwIIF(not Enabled,'true;','false;'));

            //
            //joRes.Add('this.'+sFull+'='+IntToStr(Position)+';');
            //
            joRes.Add('this.'+sFull+'__pgs='+IntToStr(Math.Max(1,PageSize))+';');
            joRes.Add('this.'+sFull+'__cpg='+IntToStr(Position+1)+';');
            joRes.Add('this.'+sFull+'__tot='+IntToStr(Max)+';');
        end;

        //
        Result    := (joRes);
    end;
end;

//function(val){dwevent(this.$event,'''+Name+''',val,''onchange'','''+IntToStr(TForm(Owner).Handle)+''')}"','')
function dwGetMethods(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sFull   : string;
    sName   : string;
    sOnPage : string;   //页面切换时执行的额外事件
    //
    joRes   : variant;
    joHint  : variant;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);
    sName   := ACtrl.Name;


    with TTrackBar(ACtrl) do begin
        //页面切换时执行的额外JS代码, 通过Hint中的onpage设置
        sOnPage := dwGetStr(joHint,'onpage');

        //currentPage 改变时会触发
        if Assigned(OnChange) then begin
            sCode   := sFull + '__currentchange(e){'
                        //
                        +sOnPage
                        +'this.dwevent(e,"'+sName+'",e,''onchange'','''+IntToStr(TForm(Owner).Handle)+''');'
                    +'},';
            joRes.Add(sCode);
        end;

        //pageSize 改变时会触发
        if Assigned(OnDragover) then begin
            sCode   := sFull + '__sizechange(e){'
                        //
                        +sOnPage
                        //+'console.log(e);'
                        +'this.dwevent(e,"'+sName+'",e,''onsizechange'','''+IntToStr(TForm(Owner).Handle)+''');'
                    +'},';
            joRes.Add(sCode);
        end;
    end;

    //
    Result  := joRes;
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethods,
     dwGetAction,
     dwGetData;
     
begin
end.
 
