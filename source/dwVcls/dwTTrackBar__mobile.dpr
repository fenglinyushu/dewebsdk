library dwTTrackBar__mobile;
(*
    移动端分页组件, 共9个按钮，类似“上一页 1 ... 9 10 11 ... 100 下一页”
    用LineSize标记当前选中的按钮位置，1--7，仅设计时使用。用户开发时不用
*)

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
    bChange : Boolean;
    oChange : Procedure(Sender:TObject) of Object;
    iTotal  : Integer;  //总页数
begin
    with TTrackBar(Actrl) do begin
        //用作分页控件--------------------------------------------------------------------------

        //
        joData    := _Json(AData);

        //取得总页数，备用
        iTotal  := Ceil(Max/PageSize);

        //
        bChange := False;
        if joData.e = 'onchange' then begin
            //保存事件
            oChange   := TTrackBar(ACtrl).OnChange;

            //清空事件,以防止自动执行
            TTrackBar(ACtrl).OnChange  := nil;

            //按钮序号值，0,1~7,8
            iTmp    := StrToIntDef(dwUnescape(joData.v),-1);

            //异常处理
            if iTmp = -1 then begin
                Exit;
            end;


            if iTotal < 8 then begin
                Position    := iTmp - 1;
                bChange     := True;
            end else begin

                //
                case iTmp of
                    0 : begin
                        if Position>0 then begin
                            Position    := Position -1;
                            bChange     := True;
                        end;
                    end;
                    1 : begin  //第一页
                        if Position <> 0 then begin
                            Position    := 0;
                            bChange     := True;
                        end;
                    end;
                    2 : begin
                        if Position = 0 then begin
                            Position    := 1;
                            bChange     := True;
                        end else if Position = 1 then begin
                        end else if Position = 2 then begin
                            Position    := 1;
                            bChange     := True;
                        end else if Position = iTotal - 1 then begin
                            Position    := iTotal - 6;
                            bChange     := True;
                        end else if Position = iTotal - 2 then begin
                            Position    := iTotal - 6;
                            bChange     := True;
                        end else if Position = iTotal - 3 then begin
                            Position    := iTotal - 6;
                            bChange     := True;
                        end else begin
                            Position    := Position - 2;
                            bChange     := True;
                        end;
                    end;
                    3 : begin
                        if Position in [0,1] then begin
                            Position    := 2;
                            bChange     := True;
                        end else if Position = 2 then begin
                        end else if Position = iTotal - 1 then begin
                            Position    := iTotal - 5;
                            bChange     := True;
                        end else if Position = iTotal - 2 then begin
                            Position    := iTotal - 5;
                            bChange     := True;
                        end else if Position = iTotal - 3 then begin
                            Position    := iTotal - 5;
                            bChange     := True;
                        end else begin
                            Position    := Position - 1;
                            bChange     := True;
                        end;
                    end;
                    4 : begin
                        if Position in [0,1,2] then begin
                            Position    := 3;
                            bChange     := True;
                        end else if Position = 3 then begin
                        end else if Position = iTotal - 1 then begin
                            Position    := iTotal - 4;
                            bChange     := True;
                        end else if Position = iTotal - 2 then begin
                            Position    := iTotal - 4;
                            bChange     := True;
                        end else if Position = iTotal - 3 then begin
                            Position    := iTotal - 4;
                            bChange     := True;
                        end else begin
                        end;
                    end;
                    5 : begin
                        if Position in [0,1,2,3] then begin
                            Position    := 4;
                            bChange     := True;
                        end else if Position = iTotal - 1 then begin
                            Position    := iTotal - 3;
                            bChange     := True;
                        end else if Position = iTotal - 2 then begin
                            Position    := iTotal - 3;
                            bChange     := True;
                        end else if Position = iTotal - 3 then begin
                        end else begin
                            Position    := Position + 1;
                            bChange     := True;
                        end;
                    end;
                    6 : begin
                        if Position in [0,1,2,3] then begin
                            Position    := 5;
                            bChange     := True;
                        end else if Position = iTotal - 1 then begin
                            Position    := iTotal - 2;
                            bChange     := True;
                        end else if Position = iTotal - 2 then begin
                        end else if Position = iTotal - 3 then begin
                            Position    := iTotal - 2;
                            bChange     := True;
                        end else begin
                            Position    := Position + 2;
                            bChange     := True;
                        end;
                    end;
                    7 : begin //最后一页
                        if Position <> iTotal - 1 then begin
                            Position    := iTotal - 1;
                            bChange     := True;
                        end;
                    end;
                    8 : begin
                        if Position < iTotal - 1 then begin
                            Position    := Position + 1;
                            bChange     := True;
                        end;
                    end;
                end;
            end;
        end;
        if bChange then begin
            //恢复事件
            TTrackBar(ACtrl).OnChange  := oChange;

            //执行事件
            if Assigned(TTrackBar(ACtrl).OnChange) then begin
                TTrackBar(ACtrl).OnChange(TTrackBar(ACtrl));
            end;
        end else begin
            //恢复事件
            TTrackBar(ACtrl).OnChange  := oChange;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    iItem       : Integer;
    iFontSize   : Integer;  //字体
    //
    sBack       : string;
    sColor      : string;
    sCode       : string;
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

        //背景色
        sBack   := 'transparent';
        if joHint.Exists('background') then begin
            sBack   := joHint.background;
        end;

        //字体色
        sColor  := '#969696';
        if joHint.Exists('color') then begin
            sColor  := joHint.color;
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

            //外框
            sCode     := '<div'
                    +' id="'+sFull+'"'
                    +' v-show="'+sFull+'__vis"'
                    +' :style="{'
                        +'left:'+sFull+'__lef,'
                        +'top:'+sFull+'__top,'
                        +'width:'+sFull+'__wid,'
                        +'height:'+sFull+'__hei}'
                    +'"'
                    +' style="'
                        +'position:absolute;'
                        +'background:'+sBack+';'
                        +'color:'+sColor+';'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);

            //prev按钮
            iItem   := 0;
            sCode   :=
                    '<el-button'
                        +' style="'
                            +'position:absolute;'
                            +'padding-left:0px;'
                            +'padding-right:0px;'
                            +'top:5px;'
                            +'width:30px;'
                            +'height:30px;'
                            +'border:0;'
                            +'font-size:'+IntToStr(iFontSize)+'px;'
                        +'"'
                        +' icon="el-icon-arrow-left"'
                        +' :style="{'
                            +'left:'+sFull+'__lf'+IntToStr(iItem)+','
                            +'color:'+sFull+'__cl'+IntToStr(iItem)+','
                            +'''background-color'':'+sFull+'__bk'+IntToStr(iItem)+','
                        +'}"'
                        +' @click="'+sFull+'__click('''+IntToStr(iItem)+''')"'
                        //+' @click=dwevent("","'+sFull+'","_prev","onchange",'+IntToStr(TForm(Owner).Handle)+');'
                    +'>'
                    +'</el-button>';
            joRes.Add(sCode);


            for iItem := 1 to 7 do begin
                sCode   :=
                        '<el-button'
                            +' v-show="'+sFull+'__vi'+IntToStr(iItem)+'"'
                            +' style="'
                                +'position:absolute;'
                                +'padding-left:0px;'
                                +'padding-right:0px;'
                                +'top:5px;'
                                +'width:30px;'
                                +'height:30px;'
                                +'border:0;'
                                +'font-size:'+IntToStr(iFontSize)+'px;'
                            +'"'
                            +' :style="{'
                                +'left:'+sFull+'__lf'+IntToStr(iItem)+','
                                +'color:'+sFull+'__cl'+IntToStr(iItem)+','
                                +'''background-color'':'+sFull+'__bk'+IntToStr(iItem)+','
                            +'}"'
                            +' @click="'+sFull+'__click('''+IntToStr(iItem)+''')"'
                            //+' @click=dwevent("","'+sFull+'","'+IntToStr(iItem)+'","onchange",'+IntToStr(TForm(Owner).Handle)+');'
                        +'>'
                        +'{{'+sFull+'__cp'+IntToStr(iItem)+'}}'
                        +'</el-button>';
                joRes.Add(sCode);
            end;

            //next按钮
            iItem   := 8;
            sCode   :=
                    '<el-button'
                        +' style="'
                            +'position:absolute;'
                            +'padding-left:0px;'
                            +'padding-right:0px;'
                            +'top:5px;'
                            +'width:30px;'
                            +'height:30px;'
                            +'border:0;'
                            +'font-size:'+IntToStr(iFontSize)+'px;'
                        +'"'
                        +' icon="el-icon-arrow-right"'
                        +' :style="{'
                            +'left:'+sFull+'__lf'+IntToStr(iItem)+','
                            +'color:'+sFull+'__cl'+IntToStr(iItem)+','
                            +'''background-color'':'+sFull+'__bk'+IntToStr(iItem)+','
                        +'}"'
                        +' @click="'+sFull+'__click('''+IntToStr(iItem)+''')"'
                        //+' @click=dwevent("","'+sFull+'","_next","onchange",'+IntToStr(TForm(Owner).Handle)+');'
                    +'>'
                    +'</el-button>';
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
        //joRes.Add('</div>');               //此处需要和dwGetHead对应
        //
        Result    := (joRes);
    end;
end;

function _dwGeneral(ACtrl:TComponent;AMode:string):string;StdCall;
var
    iItem       : Integer;
    iLeft       : Integer;
    fSpace      : Double;   //按钮间距
    iTotal      : Integer;  //总页数
    iPadding    : Integer;  //左右的空白，默认为5px
    //
    sCode       : string;
    sFull       : string;
    sMiddle     : string;
    sTail       : string;

    //
    joRes       : variant;
    joHint      : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);

    //
    iPadding    := 5;
    if joHint.Exists('padding') then begin
        iPadding    := joHint.padding;
    end;

    //
    if AMode = 'data' then begin
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sMiddle := '=';
        sTail   := ';';
        sFull   := 'this.'+sFull;
    end;


    //
    with TTrackBar(ACtrl) do begin
        //基本LTWH
        joRes.Add(sFull+'__lef'+sMiddle+'"'+IntToStr(Left)+'px"'+sTail);
        joRes.Add(sFull+'__top'+sMiddle+'"'+IntToStr(Top)+'px"'+sTail);
        joRes.Add(sFull+'__wid'+sMiddle+'"'+IntToStr(Width)+'px"'+sTail);
        joRes.Add(sFull+'__hei'+sMiddle+'"'+IntToStr(Height)+'px"'+sTail);

        //可见性和禁用
        joRes.Add(sFull+'__vis'+sMiddle+''+dwIIF(Visible,'true'+sTail,'false'+sTail));
        joRes.Add(sFull+'__dis'+sMiddle+''+dwIIF(Enabled,'false'+sTail,'true'+sTail));

        //分几种情况   所有情况下“上一页”“下一页”均可见，可用
        //1、仅1页，只显示按钮1（上一页为按钮0）
        //2、7页以内，全部显示所有页码，超出的不显示
        //3、7页以上，

        //设置每个按钮的left
        for iItem := 0 to 8 do begin
            fSpace  := (Width - 270-iPadding*2) / 8;
            iLeft   := iPadding+Round(iItem * (30+fSpace));
            joRes.Add(sFull+'__lf'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iLeft)+'px"'+sTail);
        end;

        //<-----设置两个固定的按钮颜色
        //prev按钮
        iItem   := 0;
        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
        //next按钮
        iItem   := 8;
        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
        //>

        //取到总页数
        iTotal      := Ceil(Max / Pagesize);  //从1开始
        Position    := Math.Min(iTotal-1,Position);  //强制Position不能大于总页数

        //根据总页数iTotal和当前页码Position分别设置visible,bk,color,caption
        case iTotal of
            1 : begin
                //可见性
                sCode   := sFull+'__vi1' + sMiddle + 'true' + sTail ;
                for iItem := 2 to 7 do begin
                    sCode   := sCode+#13#10+sFull+'__vi'+IntToStr(iItem)+ sMiddle + 'false' + sTail ;
                end;
                joRes.Add(sCode);

                //背景色和字体色
                for iItem := 1 to 7 do begin
                    if (iItem = Position+1)  then begin //当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#409eff"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#ffffff"'+sTail);
                    end else begin  //非当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
                    end;
                end;

                //标题
                iItem   := 1;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iItem)+'"'+sTail);
                //标题(此部分按不可见)
                for iItem := 2 to 7 do begin
                    joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iItem)+'"'+sTail);
                end;
            end;
            2..7 : begin
                //可见性
                for iItem := 1 to iTotal do begin
                    sCode   := sCode+#13#10+sFull+'__vi'+IntToStr(iItem)+ sMiddle + 'true' + sTail ;
                end;
                for iItem := iTotal + 1 to 7 do begin
                    sCode   := sCode+#13#10+sFull+'__vi'+IntToStr(iItem)+ sMiddle + 'false' + sTail ;
                end;
                joRes.Add(sCode);

                //背景色和字体色
                for iItem := 1 to 7 do begin
                    if (iItem = Position+1)  then begin //当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#409eff"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#ffffff"'+sTail);
                    end else begin  //非当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
                    end;
                end;

                //标题
                for iItem := 1 to 8 do begin
                    joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iItem)+'"'+sTail);
                end;
            end;
        else
            //可见性
            sCode   := sFull+'__vi1' + sMiddle + 'true' + sTail ;
            for iItem := 2 to 7 do begin
                sCode   := sCode+#13#10+sFull+'__vi'+IntToStr(iItem)+ sMiddle + 'true' + sTail ;
            end;
            joRes.Add(sCode);

            //背景色和字体色
            if Position in [0,1,2] then begin
                for iItem := 1 to 7 do begin
                    if (iItem = Position+1)  then begin //当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#409eff"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#ffffff"'+sTail);
                    end else begin  //非当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
                    end;
                end;
            end else if Position in  [iTotal-1,iTotal-2,iTotal-3] then  begin
                for iItem := 1 to 7 do begin
                    if (iItem  - 7 = Position + 1 - iTotal)  then begin //当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#409eff"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#ffffff"'+sTail);
                    end else begin  //非当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
                    end;
                end;
            end else begin
                for iItem := 1 to 7 do begin
                    if (iItem = 4 ) then begin //当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#409eff"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#ffffff"'+sTail);
                    end else begin  //非当前页
                        joRes.Add(sFull+'__bk'+IntToStr(iItem) + sMiddle + '"#f4f4f4"'+sTail);
                        joRes.Add(sFull+'__cl'+IntToStr(iItem) + sMiddle + '"#969696"'+sTail);
                    end;
                end;
            end;

            //按钮标题
            iItem   := 1;
            joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iItem)+'"'+sTail);
            if Position in [0,1,2] then begin
                for iItem := 2 to 5 do begin
                    joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iItem)+'"'+sTail);
                end;
                //
                iItem   := 6;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"..."'+sTail);
                //
                iItem   := 7;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iTotal)+'"'+sTail);
            end else if Position in [iTotal-1,iTotal-2,iTotal-3] then begin
                //
                iItem   := 2;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"..."'+sTail);
                //
                for iItem := 3 to 7 do begin
                    joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iTotal-7+iItem)+'"'+sTail);
                end;
            end else begin
                //
                iItem   := 2;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"..."'+sTail);
                //
                for iItem := 3 to 5 do begin
                    joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(Position-3+iItem)+'"'+sTail);
                end;
                //
                iItem   := 6;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"..."'+sTail);
                //
                iItem   := 7;
                joRes.Add(sFull+'__cp'+IntToStr(iItem) + sMiddle + '"'+IntToStr(iTotal)+'"'+sTail);
            end;
        end;


    end;
    //
    Result  := joRes;

end;



//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
begin
     Result    := _dwGeneral(ACtrl,'data');
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
begin
     Result    := _dwGeneral(ACtrl,'action');
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode   : string;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TTrackBar(ACtrl) do begin
        //函数头部
        sCode   := sFull+'__click(val) {'#13
                    //+ 'console.log(val);'
                    + 'this.dwevent("",'''+sFull+''',val,''onchange'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'},';

        //
        joRes.Add(sCode);
    end;

    //
    Result   := joRes;
end;



exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;
     
begin
end.
 
