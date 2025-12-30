(*
更新：
### 2025-08-16
1. 增加了对OnDblClick事件的响应

### 2024-07-31
1. 在column中加入了"wrap":1来控制自动换行，默认不换行

Button/Check/Combo/Date/DateTime/Edit/Image/Label/Memo/Progress/Spin/Switch/Time/
calc
*)
library dwTStringGrid__multi;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,
     Variants,
     Classes,
     Dialogs,
     Math,Grids,
     StdCtrls,ComCtrls,
     Windows,
     Controls,
     Forms;

//从列标题JSON对象中得到排序
function _GetColSortFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if dwGetInt(AJSON,'sort',0)=1 then begin
        Result    := ' sortable="custom"';
    end;
end;

//从列标题JSON对象中得到标题
function _GetColCaptionFromJson(AJSON:Variant):String;
begin
    Result    := 'noname';
    if AJSON.Exists('caption') then begin
        Result    := AJSON.caption;
    end;
end;

//从列标题JSON对象中得到Filter
function _GetColFilterFromJson(AJSON:Variant;AName:String;ACol:Integer;Owner:TObject):String;
begin
    Result    := '';
    if AJSON.Exists('filter') then begin
        Result    := ' :filters="'+AName+'__flt'+ACol.ToString+'"';   //:filters="StringGrid1__flt1"
                //+' :filter-method=r(value, row, column){dwevent(null,'''+AName+''',''"''+value+''/''+row+''/''+column+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');}'
    end;
end;


function _GetStringGridStr(ASG:TStringGrid):String;
var
    iRow        : Integer;
    iCol        : Integer;
    iVisibleCol : Integer;  //控制编辑控件显隐的列序号
    iId         : Integer;
    iGroup      : Integer;
    iHour, iMin : Word;
    iSec, iMSec : Word;
    iDecimal    : Integer;  //calc类型时的最终显示小数位数
    iColItem    : Integer;  //calc类型计算时的FOR循环变量
    iC          : Integer;
    fK          : Double;
    fValue      : Double;
    fTmp        : Double;
    //
    bError      : Boolean;
    //
    sType       : String;
    sMode       : String;   //calc类型时的计算模式，有*和+
    sCol        : string;
    sFormat     : String;
    sValue      : String;
    sVisible    : String;
    sCell       : String;
    //
    dtCell      : TDateTime;
    //
    joHint      : Variant;
    joColumn    : Variant;
    joCell      : Variant;
begin
    //取得HINT对象JSON
    joHint  := dwGetHintJson(ASg);

    //控件控制列序号，当该列有值时，所有控件显示，否则不显示
    iVisibleCol := dwGetInt(joHint,'visiblecol',-1);

    //默认返回值
    Result  := '[';

    with ASG do begin
        for iRow := 1 to RowCount -1 do begin
            Result  := Result + '{id:'+IntToStr(iRow);

            //添加列
            for iCol := 0 to ColCount - 1 do begin
                //
                sCol    := IntToStr(iCol);

                //得到列的JSON对象
                joColumn    := _JSON(Cells[iCol,0]);


                //得到列的JSON对象
                joColumn    := _JSON(Cells[iCol,0]);


                //取得各属性
                sType       := dwGetStr(joColumn,'type','label');

                //取得Format属性
                sFormat     := dwGetStr(joColumn,'format','');

                //取得值
                sCell       := Cells[iCol,iRow];

                //生成显隐显示变量
                if ( iCol = iVisibleCol ) and (iVisibleCol > -1) then begin
                    if sCell = '' then begin
                        Result  := Result + ',v'+sCol+':false';
                    end else begin
                        Result  := Result + ',v'+sCol+':true';
                    end;
                end else begin
                    Result  := Result + ',v'+sCol+':true';
                end;

                //
                if sType ='button' then begin
                    //将cells[x,y]转化为JSON, 以控制按钮的Enabled和visible
                    joCell  := _json(sCell);
                    //
                    if joCell = unassigned then begin
                        sValue  := ',c'+sCol+':'''+sCell+''',e'+sCol+':1,i'+sCol+':1';  //e-eanbled, i-visible
                    end else begin
                        sValue  := ',c'+sCol+':'''+dwGetStr(joCell,'data')+''''
                                +',e'+sCol+':'+IntToStr(dwGetInt(joCell,'eanbled',1))   //e-eanbled
                                +',i'+sCol+':'+IntToStr(dwGetInt(joCell,'visible',1));  //i-visible
                    end;
                end else if sType = 'calc' then begin   //计算类型
                    if joColumn.Exists('column') then begin
                        if joColumn.column._Count>0 then begin
                            //默认不报错
                            bError      := False;
                            //取得计算模式： */+
                            sMode       := dwGetStr(joColumn,'mode','*');
                            //取得小数位数
                            iDecimal    := dwGetInt(joColumn,'decimal',2);

                            //先计算 *
                            if sMode = '*' then begin
                                fValue  := 1;
                                for iColItem := 0 to joColumn.column._Count -1 do begin
                                    //得到参与计算的列的序号
                                    iC      := joColumn.column._(iColItem);
                                    //得到参与计算的列的缩放系数
                                    fK      := joColumn.k._(iColItem);
                                    //取得当前列的值
                                    fTmp    := StrToFloatDef(Cells[iC,iRow],NAN);
                                    //根据是否出错
                                    if IsNan(fTmp) then begin
                                        bError  := True;
                                    end else begin
                                        fValue  := fValue * fk * fTmp;
                                    end;
                                end;
                                //
                                if bError then  begin
                                    sValue  := ',c'+sCol+':""';
                                end else begin
                                    if iDecimal = -1 then begin
                                        sValue  := ',c'+sCol+':'''+SysUtils.Format('%n',[fValue])+'''';
                                    end else begin
                                        sValue  := ',c'+sCol+':'''+SysUtils.Format('%.'+IntToStr(iDecimal)+'f',[fValue])+'''';
                                    end;
                                end;
                            end else begin
                                sValue  := ',c'+sCol+':""';
                            end;
                        end else begin
                            sValue  := ',c'+sCol+':""';
                        end;
                    end else begin
                        sValue  := ',c'+sCol+':""';
                    end;
                end else if sType = 'check' then begin
                    if LowerCase(Cells[iCol,iRow]) = 'true' then begin
                        sValue  := ',c'+sCol+':true';
                    end else begin
                        sValue  := ',c'+sCol+':false';
                    end;
                end else if sType ='edit' then begin
                    sValue  := ',c'+sCol+':'''+Cells[iCol,iRow]+'''';
                end else if sType = 'process' then begin
                    sValue  := ',c'+sCol+':'+IntToStr(StrToIntDef(Cells[iCol,iRow],0))+'';
                end else if sType = 'spin' then begin
                    if Cells[iCol,iRow]='' then begin
                        sValue  := ',c'+sCol+':'''+''+'''';
                    end else begin
                        sValue  := ',c'+sCol+':'+IntToStr(StrToIntDef(Cells[iCol,iRow],0))+'';
                    end;
                end else if sType = 'switch' then begin
                    if LowerCase(Cells[iCol,iRow]) = 'true' then begin
                        sValue  := ',c'+sCol+':true';
                    end else begin
                        sValue  := ',c'+sCol+':false';
                    end;
                end else if sType = 'time' then begin
                    //得到当前时间
                    dtCell  := StrToTimeDef(Cells[iCol,iRow],0);
                    //拆解时分各
                    DecodeTime(dtCell,iHour, iMin, iSec, iMSec);
                    //
                    sValue  := ',c'+sCol+': new Date(1900, 1, 1, '+IntToStr(iHour)+', '+IntToStr(iMin)+', '+IntToStr(iSec)+')';
                end else begin
(*
                    //默认为label
                    if sFormat = '' then begin
                        sValue  := ',c'+sCol+':'''+Cells[iCol,iRow]+'''';
                    end else if Pos('%n',sFormat) > 0  then begin
                        if Cells[iCol,iRow]='' then begin
                            sValue  := ',c'+sCol+':'''+''+'''';
                        end else begin
                            sValue  := ',c'+sCol+':'''+Format(sFormat,[StrToFloatDef(Cells[iCol,iRow],0)])+'''';
                        end;
                    end else begin
                        if (Cells[iCol,iRow]='') and (sType = 'image') then begin
                            sValue  := ',c'+sCol+':''''';
                        end else begin
                            sValue  := ',c'+sCol+':'''+Format(sFormat,[Cells[iCol,iRow]])+'''';
                        end;
                    end;
*)
                    //默认为label

                    //先取得值
                    if sFormat = '' then begin
                        sValue  := Cells[iCol,iRow];
                    end else if Pos('%n',sFormat) > 0  then begin
                        if Cells[iCol,iRow]='' then begin
                            sValue  := '';
                        end else begin
                            sValue  := Format(sFormat,[StrToFloatDef(Cells[iCol,iRow],0)]);
                        end;
                    end else begin
                        if (Cells[iCol,iRow]='') and (sType = 'image') then begin
                            sValue  := '';
                        end else begin
                            sValue  := Format(sFormat,[Cells[iCol,iRow]]);
                        end;
                    end;

                    //转义
                    sValue  := StringReplace(sValue,'''','\''',[rfReplaceAll]);

                    //增加前面对应对象名称
                    sValue  := ',c'+sCol+':'''+sValue+'''';

                end;
                //
                Result  := Result + sValue
            end;

            //
            Result  := Result + '},'
        end;
        //
        if Length(Result)>2 then begin
            Delete(Result,Length(Result),1);
        end;
        //
        Result  := Result + ']'
   end;
end;


//==================================================================================================


//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sCode   : String;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    {
    //以下是TChart时的代码,供参考
    joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
    joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
    joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
    }

    joHint  := dwGetHintJson(TControl(ACtrl));


    //
    Result  := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    iItem       : Integer;
    iSel,iHalf  : Integer;
    iCol        : integer;
    iRow        : Integer;
    iNewW       : Integer;
    iOldW       : Integer;
    iGroup      : Integer;
    iOrder      : Integer;
    iP0,iP1     : Integer;
    sFilter     : string;
    sValue      : String;
    sCol        : String;
    sType       : String;
    sKeyword    : string;

    joData      : Variant;
    joValue     : Variant;
    joSel       : Variant;
    joHalf      : Variant;
    joHint      : Variant;
    joCol       : Variant;
    joText      : Variant;

    //OnMouseDown,OnMouseUp
    mButton     : TMouseButton;
    mShift      : TShiftState;
    mX, mY      : Integer;
begin
    //
    joData      := _Json(AData);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    with TStringGrid(ACtrl) do begin
        if joData.e = 'onclick' then begin
             //保存事件
             TStringGrid(ACtrl).OnExit    := TStringGrid(ACtrl).OnClick;
             //清空事件,以防止自动执行
             TStringGrid(ACtrl).OnClick  := nil;
             //更新值
             TStringGrid(ACtrl).Row   := StrToIntDef(joData.v,1);
             //恢复事件
             TStringGrid(ACtrl).OnClick  := TStringGrid(ACtrl).OnExit;

             //执行事件
             if Assigned(TStringGrid(ACtrl).OnClick) then begin
                  TStringGrid(ACtrl).OnClick(TStringGrid(ACtrl));
             end;
        end else if joData.e = 'change' then begin
            //应为一个没有方括号的3维的数组，分别为行号，列号和值
            sValue  := dwUnescape(joData.v);

            //转化为JSON对象
            joValue := _json('['+sValue+']');

            //如果非JSON，则退出
            if joValue = unassigned then begin
                Exit;
            end;

            //取得值
            iRow    := joValue._(0);    //行
            iCol    := joValue._(1);    //列

            //取得列JSON
            joCol   := _json(Cells[iCol,0]);

            //如果非JSON，则退出
            if joCol = unassigned then begin
                Exit;
            end;

            //取得类型
            sType   := dwGetStr(joCol,'type','label');

            //根据类型判断
            if sType = 'button' then begin
                iCol    := StrToIntDef(joValue._(2),0)*1000+iCol;
            end;

            //修改前激活事件
            if Assigned(OnEndDrag) then begin
                OnEndDrag(TStringGrid(ACtrl),nil,iCol,iRow);
            end;

            //更新值
            if sType <> 'html' then begin
                Cells[iCol,iRow]    := joValue._(2);
            end;

            //修改后激活事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TStringGrid(ACtrl),nil,iCol,iRow);
            end;
        end else if joData.e = 'changecolwidth' then begin
            //应为一个没有方括号的3维的数组，分别为newWidth, oldWidth, column
            sValue  := dwUnescape(joData.v);

            //转化为JSON对象
            joValue := _json('['+sValue+']');

            //如果非JSON，则退出
            if joValue = unassigned then begin
                Exit;
            end;

            //取得值
            iNewW   := joValue._(0);    //新列宽
            iOldW   := joValue._(1);    //老列宽
            sCol    := joValue._(2);
            Delete(sCol,1,1);
            iCol    := StrToIntDef(sCol,0); //列序号

            //更新列宽
            ColWidths[iCol] := iNewW;

            //修改后激活事件
            if Assigned(OnColumnMoved) then begin
                OnColumnMoved(TStringGrid(ACtrl),iCol,iNewW);
            end;

        end else if joData.e = 'ondblclick' then begin
             //保存事件
             TStringGrid(ACtrl).OnExit    := TStringGrid(ACtrl).ondblclick;
             //清空事件,以防止自动执行
             TStringGrid(ACtrl).ondblclick  := nil;
             //更新值
             TStringGrid(ACtrl).Row   := StrToIntDef(joData.v,1);
             //恢复事件
             TStringGrid(ACtrl).ondblclick  := TStringGrid(ACtrl).OnExit;

             //执行事件
             if Assigned(TStringGrid(ACtrl).OnDblClick) then begin
                  TStringGrid(ACtrl).OnDblClick(TStringGrid(ACtrl));
             end;

        end else if joData.e = 'onfilter' then begin  //过滤事件
            //返回一个JSON字符串到 OnGetEditMask 的参数中
            //形如：{"type":"filter","col":3,"data":["襄阳","朝阳区"]}
            //其中，type为类型，主要区分排序、选择、过滤等，
            //col 为列序号，从0开始
            //data 为过滤值，如果为空则为清除当前列筛选

            //得到转过来的字符
            sValue  := joData.v;
            //先进行转义
            sValue  := StringReplace(sValue,'%25','%',[rfReplaceAll]);
            //通过unescape解码
            sValue  := dwUnescape(sValue);  //'{"el-table_1_column_NaN__c5":["陕西","广东"]}'

            //

            //得到列号
            sCol    := sValue;
            Delete(sCol,1,Pos('__c',sCol)+2);
            sCOl    := Copy(sCol,1,Pos('"',sCol)-1);
            iCol    := StrToIntDef(sCol,0);

            //得到filter
            iP0 := Pos('["',sValue);
            iP1 := Pos('"]',sValue);
            sFilter := Copy(sValue,iP0,iP1-iP0+2);
            //sFilter := '"filter":'+sFilter;     //filter:["襄阳","朝阳区"]
            if iCol >= 0 then begin
                //执行事件
                if Assigned(TStringGrid(ACtrl).OnGetEditMask) then begin
                    //生成返回值字符串
                    joData          := _json('{}');
                    joData.type     := 'filter';
                    joData.col      := iCol;
                    joData.data     := _json(sFilter);
                    if joData.data = unassigned then begin
                        joData.data     := _json('[]');
                    end;


                    sKeyword        := joData;
                    //执行事件
                    TStringGrid(ACtrl).OnGetEditMask(TStringGrid(ACtrl),iCol,-999,sKeyword);
                end;
            end;

        end else if joData.e = 'onmousedown' then begin
            //得到转过来的字符  X/Y/左中右:012/ctrl/alt/shift, 全部为整数
            sValue  := joData.v;
            //异常检测
            if Pos('/',sValue)<=0 then begin
                Exit;
            end;
            //将/转换为逗号以便于JSON处理
            sValue  := StringReplace(sValue,'/',',',[rfReplaceAll]);

            //将当前选中情况保存到Hint中，{"__selection":["1","3","8"]}
            joValue := _json('['+sValue+']');

            //将传过来的值转换为鼠标事件参数
            case joValue._(2) of
                0 : begin
                    mButton := mbLeft;
                end;
                1 : begin
                    mButton := mbMiddle;
                end;
                2 : begin
                    mButton := mbRight;
                end;
            end;
            mShift  := [];
            if joValue._(3)=1 then begin
                mShift  := mShift + [ssCtrl];
            end;
            if joValue._(4)=1 then begin
                mShift  := mShift + [ssAlt];
            end;
            if joValue._(5)=1 then begin
                mShift  := mShift + [ssShift];
            end;
            mX  := joValue._(0);
            mY  := joValue._(1);


            //执行事件
            if Assigned(OnMouseDown) then begin
                OnMouseDown(TStringGrid(ACtrl),mButton,mShift,mX,mY);
            end;
        end else if joData.e = 'onmouseup' then begin
            //得到转过来的字符  X/Y/左中右:012/ctrl/alt/shift, 全部为整数
            sValue  := joData.v;
            //异常检测
            if Pos('/',sValue)<=0 then begin
                Exit;
            end;
            //将/转换为逗号以便于JSON处理
            sValue  := StringReplace(sValue,'/',',',[rfReplaceAll]);

            //将当前选中情况保存到Hint中，{"__selection":["1","3","8"]}
            joValue := _json('['+sValue+']');

            //将传过来的值转换为鼠标事件参数
            case joValue._(2) of
                0 : begin
                    mButton := mbLeft;
                end;
                1 : begin
                    mButton := mbMiddle;
                end;
                2 : begin
                    mButton := mbRight;
                end;
            end;
            mShift  := [];
            if joValue._(3)=1 then begin
                mShift  := mShift + [ssCtrl];
            end;
            if joValue._(4)=1 then begin
                mShift  := mShift + [ssAlt];
            end;
            if joValue._(5)=1 then begin
                mShift  := mShift + [ssShift];
            end;
            mX  := joValue._(0);
            mY  := joValue._(1);


            //执行事件
            if Assigned(OnMouseUp) then begin
                OnMouseUp(TStringGrid(ACtrl),mButton,mShift,mX,mY);
            end;

        end else if joData.e = 'onselect' then begin  //选择列的选择事件
            iCol    := dwGetInt(joData,'v');
            for iRow := 1 to RowCount - 1 do begin
                if LowerCase(Cells[iCol,iRow]) = 'true' then begin
                    Cells[iCol,iRow]    := 'false';
                end else begin
                    Cells[iCol,iRow]    := 'true';
                end;
            end;

        end else if joData.e = 'onselection' then begin  //选择事件
            //返回一个JSON字符串到 OnGetEditMask 的参数中
            //形如：{"type":"selection","data":["1","3","8"]}   //data数据未直接采用数字，主要是为了和前端方便
            //其中，type为类型，主要区分排序、选择、过滤等，
            //data 为当前选择的行序号，从0开始

            //得到转过来的字符
            sValue  := joData.v;
            if sValue = 'undefined' then begin
                sValue := '';
            end;
            //先进行转义
            sValue  := StringReplace(sValue,'%25','%',[rfReplaceAll]);
            //通过unescape解码
            sValue  := dwUnescape(sValue);  //'["1","3","8"]'

            //将当前选中情况保存到Hint中，{"__selection":["1","3","8"]}
            joHint  := _json(Hint);
            if joHint = unassigned then begin
                joHint  := _json('{}');
            end;
            if joHint.Exists('__selection') then begin
                joHint.Delete('__selection');
            end;
            joHint.__selection  := _Json(sValue);
            Hint    := joHint;

            //
            joValue         := _json('{}');
            joValue.type    := 'selection';
            joValue.data    :=  _json(sValue);

            //激活事件
            sFilter     := VariantSaveJSON(joValue);

            //执行事件
            if Assigned(OnGetEditMask) then begin
                OnGetEditMask(TStringGrid(ACtrl),iCol,0,sFilter);
            end;

        end else if joData.e = 'onsort' then begin  //排序事件
            //返回一个JSON字符串到 OnGetEditMask 的参数中
            //形如：{"type":"sort","col":3,"order":"0"}
            //其中，type为类型，主要与选择、过滤等分开，
            //col 为列序号，从0开始
            //order 为顺序，1为升序，0为降序


            //
            sValue  := joData.v;
            //得到排序方向:1升序,0降序
            if Pos('/ascending',sValue)>0 then begin
                iOrder  := 1;
            end else if Pos('/desc',sValue)>0 then begin
                iOrder  := 0;
            end else begin
                iOrder  := 9;
            end;

            //得到列号
            sValue  := Copy(sValue,1,Pos('/',sValue)-1);
            Delete(sValue,1,1);
            iCol    := StrToIntDef(sValue,-1);

            if iCol >= 0 then begin
                //执行事件
                if Assigned(TStringGrid(ACtrl).OnGetEditMask) then begin
                    //生成返回值字符串
                    joData          := _json('{}');
                    joData.type     := 'sort';
                    joData.col      := iCol;
                    joData.order    := iOrder;

                    sKeyword        := joData;
                    //执行事件
                    TStringGrid(ACtrl).OnGetEditMask(TStringGrid(ACtrl),iCol,iOrder,sKeyword);
                end;
            end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : String;
    sType       : String;   //列类型
    sCaption    : String;   //列标题
    sAlign      : string;   //列对齐
    sCol        : string;
    sVisible    : String;   //控件可见性
    sIcon       : string;   //主要用于按钮列的按钮图标
    sWidth      : string;   //用于控制列宽
    //
    iWidth      : Integer;  //列宽
    iCol        : Integer;
    iCount      : Integer;
    iGroup      : Integer;
    iLeft       : Integer;
    iFixedLeft  : Integer;  //左侧固定列
    iFixedRight : Integer;  //右侧固定列

    //
    joRes       : Variant;
    joHint      : Variant;
    joColumn    : Variant;
    joButton    : Variant;
    //设置固定列
    function _GetFixed(AACol,AACount:Integer):String;
    begin
        Result  := '';
        if AACol < iFixedLeft then begin
            Result  := ' fixed';
        end else if AACol >= AACount - iFixedRight then begin
            Result  := ' fixed="right"';
        end;
    end;
begin
    //
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //控件控制列序号，当该列有值时，所有控件显示，否则不显示
    //主要防止无数据时表格内有许多可编辑控件的问题
    //当visiblecol有值时，才显示控件
    iCol    := dwGetInt(joHint,'visiblecol',-1);

    //生成控制显示变量，备用
    sVisible    := '';
    if iCol >= 0  then begin
        sVisible    := ' v-if="scope.row.v'+IntToStr(iCol)+'"';
    end;


    //
    with TStringGrid(ACtrl) do begin

        //取左右侧的固定列数
        iFixedLeft  := FixedCols;
        iFixedRight := 0;
        if joHint.Exists('fixed') then begin
            if joHint.fixed._kind = 2 then begin    //只处理数组
                if joHint.fixed._Count > 0 then begin
                    iFixedLeft  := joHint.fixed._(0);
                    if joHint.fixed._Count > 1 then begin
                        iFixedRight := joHint.fixed._(1);
                    end;
                end;
            end;
        end;

        //
        joRes.Add('<el-table'
                +' ref="'+sFull+'"'
                +' id="'+sFull+'"'
                +' height='''+IntToStr(Height)+''''
                +dwVisible(TControl(ACtrl))                             //用于控制可见性Visible
                //+dwDisable(TControl(ACtrl))                           //用于控制可用性Enabled(部分控件不支持)
                +dwIIF(goVertLine in Options,' border','')
                +' :data="'+sFull+'__dat"'
                +' highlight-current-row'                               //当前行高亮
                +' row-key="id"'
                +' :row-style="{height:'''+IntToStr(RowHeights[0])+'px''}"'
                +' :header-cell-style="{'
                    +'background:''#FAFAFA'','
                    //+'textAlign: ''center'','
                    +'height: '''+IntToStr(DefaultRowHeight)+'px'''
                +'}"'
                //+' height='''+IntToStr(Height)+'px'''
                +dwGetDWAttr(joHint)
                //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                +' :style="{'
                    +'pointerEvents:'+sFull+'__pte,'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'height:'+sFull+'__hei,'
                    +'width:'+sFull+'__wid'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                    +'background-color:'+dwColor(Color)+';'
                    +'overflow:auto;'
                +'"' // 封闭style

                //排序
                +' @sort-change="'+sFull+'__sortchange($event)"'

                //筛选
                +' @filter-change="'+sFull+'__filterchange($event)"'

                //单击行
                +' @row-click="'+sFull+'__rowclick"'        //单击行

                //双击行
                +' @row-dblclick="'+sFull+'__rowdblclick"'   //双击行

                //拖动列宽事件
                +' @header-dragend="'+sFull+'__changecolwidth"'
                +'>');

        //添加列
        for iCol := 0 to ColCount - 1 do begin
            //
            sCol    := IntToStr(iCol);

            //得到列的JSON对象
            joColumn    := _JSON(Cells[iCol,0]);

            //异常处理
            if joColumn = unassigned then begin
                joColumn    := _json('{}');
            end;


            //取得各属性
            sType       := dwGetStr(joColumn,'type','label');
            sCaption    := dwGetStr(joColumn,'caption','');
            iWidth      := dwGetInt(joColumn,'width',ColWidths[iCol]);
            sAlign      := dwGetStr(joColumn,'align','left');

            //计算宽度
            if iCol <> ColCount - 1 - iFixedRight then begin
                sWidth  := ' width="'+IntToStr(iWidth)+'px"'
            end else begin
                sWidth  := ' min-width="'+IntToStr(iWidth)+'px"';
            end;

            //根据类型添加代码
            //Button/ButtonGroup/Check/Combo/Date/DateTime/Edit/html/Image/Label/Memo/Progress/Spin/Switch/Time/
            if sType = 'button' then begin  //--------------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +' style="background-color:#0f0;"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13;
                iLeft   := 5;
                for iGroup := 0 to joColumn.items._Count - 1 do begin
                    //取得按钮JSON对象
                    joButton    := joColumn.items._(iGroup);

                    //图标字符串
                    sIcon   := dwGetStr(joButton,'image','');
                    if sIcon <>'' then begin
                        sIcon   := ' icon="'+sIcon+'"';
                    end;

                    //
                    scode   := scode
                            +'<el-button'
                                +dwGetDWAttr(joButton)
                                +' type="'+dwGetStr(joButton,'type','default')+'"'
                                //+' v-show="scope.row.i"'
                                //+' :disabled="scope.row.e"'
                                +sIcon
                                +' style="'
                                    +'position:absolute;'
                                    +'top:15%;'
                                    +'height:70%;'
                                    +'left:'+IntToStr(iLeft)+'px;'
                                    +'width:'+IntToStr(dwGetInt(joButton,'width',80))+'px;'
                                    +dwGetDWStyle(joButton)
                                +'"'
                                +sVisible
                                +' @click="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', '+IntToStr(iGroup)+')"'
                            +'>'
                                +dwGetStr(joButton,'caption','')
                            +'</el-button>'#13;
                    //更新左边距
                    iLeft   := iLeft + 5 + dwGetInt(joButton,'width',80);
                end;
                scode   := scode
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'check' then begin //-------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            //+' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            //+' :render-header="'+sFull+'__renderheader"'        //添加render函数，渲染el-checkbox，绑定chang事件
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-checkbox'
                                    +dwGetDWAttr(joColumn)
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                    +' style="'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                +'>'
                                +'</el-checkbox>'#13
                            +'</template>'#13

                            +'<template #header="{ column }">'
                                +'<span >'
                                    +'<el-checkbox'
                                        +' @change="'+sFull+'__selectbox('''+sCol+''')"'
                                    +'>'
                                    +sCaption
                                    +'</el-checkbox>'#13
                                +'</span>'
                            +'</template>'
                        +'</el-table-column>';

            end else if sType = 'combo' then begin //-------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-select'
                                    +dwGetDWAttr(joColumn)
                                    +' filterable'
                                    +' allow-create'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                    +' style="'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +'>'
                                    +'<el-option'
                                        +' v-for="item in '+sFull+'__opt'+sCol+'"'
                                        +' :key="item.value"'
                                        +' :label="item.value"'
                                        +' :value="item.value">'
                                    +'</el-option>'
                                +'</el-select>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'date' then begin //--------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +dwIIF(iCol<ColCount - 1,' width="'+IntToStr(iWidth)+'px"',' min-width="'+IntToStr(iWidth)+'px"')
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-date-picker'
                                    +' style="'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                    +dwGetDWAttr(joColumn)
                                +'>'
                                +'</el-date-picker>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'datetime' then begin       //----------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +dwIIF(iCol<ColCount - 1,' width="'+IntToStr(iWidth)+'px"',' min-width="'+IntToStr(iWidth)+'px"')
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-date-picker'
                                    +' type="datetime"'
                                    +' style="'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                    +dwGetDWAttr(joColumn)
                                +'>'
                                +'</el-date-picker>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'edit' then begin  //-------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-input'
                                    +' style="'
                                        +'height: '+IntTostr(RowHeights[0]-10)+'px; '
                                        +'border-radius: 3px; '
                                        +'border:solid 1px #dcdfe6!important;'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                    +dwGetDWAttr(joColumn)
                                +'>'
                                +'</el-input>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'html' then begin  //-------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<div'
                                    +' style="'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @click="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', '''')"'
                                    +' v-html="scope.row.c'+sCol+'"'
                                    +sVisible
                                    +dwGetDWAttr(joColumn)
                                +'>'
                                +'</div>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'process' then begin //-----------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-progress'
                                    +' :text-inside="true"'
                                    +' :stroke-width="'+IntTostr(RowHeights[0]-14)+'"'
                                    +' :percentage="scope.row.c'+sCol+'"'
                                    +dwGetDWAttr(joColumn)
                                  +' style="'
                                        //+'height: '+IntTostr(RowHeights[0]-10)+'px; '
                                        //+'width: '+IntTostr(ColWidths[iCol]-6)+'px; '
                                        //+'border-radius: 3px; '
                                        //+'border:solid 1px #dcdfe6!important;'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    //+' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                +'>'
                                +'</el-progress>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'spin' then begin //--------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-input-number'
                                    +dwIIF(dwGetInt(joColumn,'min', 99999)= 99999,      '', ' :min="'+IntToStr(dwGetInt(joColumn,'min', 99999))+'"')   //最小值
                                    +dwIIF(dwGetInt(joColumn,'max',-99999)=-99999,      '', ' :max="'+IntToStr(dwGetInt(joColumn,'max',-99999))+'"')   //最大值
                                    +dwIIF(dwGetInt(joColumn,'decimal',-99999)=-99999,  '', ' :precision="'+IntToStr(dwGetInt(joColumn,'decimal',-99999))+'"')   //最大值
                                    +dwIIF(dwGetDouble(joColumn,'step',-99999)=-99999,  '', ' :step="'+FloatToStr(dwGetDouble(joColumn,'step',-99999))+'"')   //最大值
                                    +' controls-position="right"'
                                    +dwGetDWAttr(joColumn)
                                    +' style="'
                                        +'height: '+IntTostr(RowHeights[0]-10)+'px; '
                                        +'width: 100%; '
                                        +'border-radius: 3px; '
                                        +'border:solid 1px #dcdfe6!important;'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                +'>'
                                +'</el-input-number>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'switch' then begin //------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-switch'
                                    +dwGetDWAttr(joColumn)
                                    +' style="'
                                    //+'height: '+IntTostr(RowHeights[0]-10)+'px; '
                                    //+'width: 100%; '
                                    //+'border-radius: 3px; '
                                    //+'border:solid 1px #dcdfe6!important;'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                +'>'
                                +'</el-switch>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'time' then begin //--------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            +'>'#13
                            +'<template slot-scope="scope">'#13
                                +'<el-time-picker'
                                    +' arrow-control'
                                    +' :picker-options="{selectableRange: ''00:00:00 - 23:59:59''}"'
                                    +dwGetDWAttr(joColumn)
                                    +' style="'
                                    //+'height: '+IntTostr(RowHeights[0]-10)+'px; '
                                    //+'border-radius: 3px; '
                                    //+'border:solid 1px #dcdfe6!important;'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' @change="'+sFull+'__change('''+sType+''',scope.row.id, '+sCol+', scope.row.c'+sCol+')"'
                                    +' v-model="scope.row.c'+sCol+'"'
                                    +sVisible
                                +'>'
                                +'</el-time-picker>'#13
                            +'</template>'#13
                        +'</el-table-column>';
            end else if sType = 'image' then begin //--------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' label="'+sCaption+'"'
                            +sWidth

                            +' prop="c'+sCol+'"'
                            +' align="'+sAlign+'"'
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +'>'#13
                            +' <template slot-scope="scope"> '#13
                                +dwIIF(dwGetInt(joColumn,'preview',1)=1,'<el-popover'
                                    +' placement="right"'
                                    //+' :title="'+sCaption+'"'
                                    +' trigger="hover"'
                                +'>','') //dwIIF

                                +'<el-image'
                                    +' slot="reference"'
                                    +dwGetDWAttr(joColumn)
                                    +' style="'
                                        +'width:'+IntToStr(dwGetInt(joColumn,'imgwidth',iWidth-12))+'px;'
                                        +'height:'+IntToStr(dwGetInt(joColumn,'imgheight',DefaultRowHeight-12))+'px;'
                                        +dwGetDWStyle(joColumn)
                                    +'"'
                                    +' :src="scope.row.c'+sCol+'"'
                                    //+' :alt="scope.row.c'+sCol+'"'
                                +'>'
                                +'</el-image>  '#13

                                +dwIIF(dwGetInt(joColumn,'preview',1)=1,'<el-image'
                                    +' :src="scope.row.c'+sCol+'"'
                                +'>'
                                +'</el-image>'#13

                                +'</el-popover>'#13,'') //dwIIF
                            +'</template> '#13
                        +'</el-table-column>';
            end else begin  //------------------------------------------------------------------------------------------
                sCode   :=
                        '<el-table-column'
                            +' align="'+sAlign+'"'
                            +' prop="c'+sCol+'"'
                            +' label="'+sCaption+'"'
                            +sWidth
                            +dwGetDWAttr(joColumn)
                            +_GetFixed(iCol,ColCount)                           //设置固定列
                            +_GetColSortFromJson(joColumn)                      //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColumn,sFull,iCol,Owner)   //根据文本,确定是否过滤
                            //通过"wrap":1控制可换行
                            +dwIIF(dwGetInt(joColumn,'wrap',0)=0,' show-overflow-tooltip','')
                            +' style="'
                                +dwGetDWStyle(joColumn)
                            +'"'
                            //+' :cell-style="{ ''white-space'': ''normal'' }"'  //=================
                            +'>'#13
                        +'</el-table-column>';
            end;
            //添加到返回值数据
            joRes.Add(sCode);
        end;
    end;
    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-table>');          //此处需要和dwGetHead对应
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joColumn    : Variant;
    joTmp       : Variant;
    sCode       : String;
    sCol        : String;
    sFull       : String;
    sType       : String;
    iCol        : Integer;
    iList       : Integer;
    //
    iRow        : Integer;
    iTmp        : Integer;

begin
    //
    sFull   := dwFullName(ACtrl);
    //生成返回值数组
    joRes   := _Json('[]');


    //
    with TStringGrid(ACtrl) do begin
        //
        //
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__pte:'+dwIIF(Enabled,'"auto",','"none",'));
        //
        //joRes.Add(sFull+'__dat:eval('''+_GeTStringGridData(TStringGrid(ACtrl))+'''),');
        joRes.Add(sFull+'__dat:'+_GetStringGridStr(TStringGrid(ACtrl))+',');
        //joRes.Add(sFull+'__dek:'+_GetTreeDefaultExpandedKeys(TStringGrid(ACtrl))+',');
        //添加列
        for iCol := 0 to ColCount - 1 do begin
            //
            sCol    := IntToStr(iCol);
            //得到列的JSON对象
            joColumn    := _JSON(Cells[iCol,0]);


            //取得各属性
            sType       := dwGetStr(joColumn,'type','label');

            //根据类型添加代码
            //Button/ButtonGroup/Check/Combo/Date/DateTime/Edit/Image/Label/Memo/Progress/Spin/Switch/Time/
            if sType = 'combo' then begin
                sCode   := '[';
                for iList := 0 to joColumn.list._Count -1 do begin
                    sCode   := sCode +'{value:'''+joColumn.list._(iList)+'''},';
                end;
                if Length(sCode)>2 then begin
                    Delete(sCode,Length(sCode),1);
                end;
                sCode   := sCode + ']';
                //
                joRes.Add(sFull+'__opt'+sCol+':'+sCode+',');
            end;

        end;

        //添加可能的filter数据
        //Result    := ' :filters="'+AName+'__flt'+ACol.ToString+'"';   //:filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]"
        for iCol := 0 to ColCount-1 do begin
            if dwStrIsJson(Cells[iCol,0]) then begin
                jotmp := _json(Cells[iCol,0]);
                if jotmp.Exists('filter') then begin
                    //头部
                    sCode   := sFull+'__flt'+IntToStr(iCol)+':[';
                    //添加数据主体
                    for itmp := 0 to jotmp.filter._Count-1 do begin
                        sCode   := sCode+Format('{ text: ''%s'', value: ''%s'' },',[jotmp.filter._(itmp),jotmp.filter._(itmp)]);
                    end;
                    //删除多余的逗号
                    if jotmp.filter._Count>0 then begin
                        Delete(sCode,Length(sCode),1);
                    end;
                    //添加]
                    sCode   := sCode + '],';
                    //添加到返回数组中
                    joRes.Add(sCode);
                end;
            end;
        end;
    end;
    //
    Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    sFull   : String;
    sCode   : String;
    tnItem  : TTreeNode;
    iItem   : Integer;
begin
    //
    sFull   := dwFullName(ACtrl);


    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TStringGrid(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__pte='+dwIIF(Enabled,'"auto";','"none";'));
        //
        //joRes.Add('this.'+sFull+'__dat=eval('''+_GeTStringGridData(TStringGrid(ACtrl))+''');');
        joRes.Add('this.'+sFull+'__dat='+_GeTStringGridStr(TStringGrid(ACtrl))+';');

        //
        //joRes.Add('this.'+sFull+'__dek='+_GetTreeDefaultExpandedKeys(TStringGrid(ACtrl))+';');

        //高亮当前行
        //joRes.Add('/*real*/ '+'const rowToSelect = this.'+sFull+'__dat['+IntToStr(Row-1)+'];this.$refs.'+sFull+'.setCurrentRow(rowToSelect, true);');
        if DoubleBuffered then begin
            joRes.Add('/*real*/ '+'this.$refs.'+sFull+'.setCurrentRow();');
        end else begin
            joRes.Add('/*real*/ '+'this.$refs.'+sFull+'.setCurrentRow(this.'+sFull+'__dat['+IntToStr(Row-1)+']);');
        end;

        //动态控制行数
        //joRes.Add('dwSetTableRowCount('''+sFull+''','+IntToStr(RowCount-1)+');');
        //dwRunJS(sTmp,oForm);
    end;
    //
    Result    := (joRes);
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    iHandle     : THandle;

    //
    joRes       : Variant;  //返回结果
    joHint      : Variant;  //HINT
begin
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));

    //取得名称 备用
    sFull   := dwFullName(ACtrl);

    //取得句柄备用
    iHandle := TForm(ACtrl.Owner).Handle;

    //
    with TStringGrid(ACtrl) do begin

        //展开函数
        sCode   :=
                sFull+'__change(stype,row,col,value){'+
                    //'console.log(stype,row,col,value);'+
                    'if (stype == "date"){'+
                        'var year = value.getFullYear();'+
                        'var month = (value.getMonth() + 1).toString().padStart(2, ''0'');'+
                        'var day = value.getDate().toString().padStart(2, ''0'');'+
                        'value = `${year}-${month}-${day}`;'+
                        //'console.log(value);'+
                    '} else if (stype == "datetime"){'+
                        'var year = value.getFullYear();'+
                        'var month = (value.getMonth() + 1).toString().padStart(2, ''0'');'+
                        'var day = value.getDate().toString().padStart(2, ''0'');'+
                        'var hours = value.getHours().toString().padStart(2, ''0'');'+
                        'var minutes = value.getMinutes().toString().padStart(2, ''0'');'+
                        'var seconds = value.getSeconds().toString().padStart(2, ''0'');'+
                        'value = `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;'+
                        //'console.log(value);'+
                    '} else if (stype == "time"){'+
                        'var hours = value.getHours().toString().padStart(2, ''0'');'+
                        'var minutes = value.getMinutes().toString().padStart(2, ''0'');'+
                        'var seconds = value.getSeconds().toString().padStart(2, ''0'');'+
                        'value = `${hours}:${minutes}:${seconds}`;'+
                        //'console.log(value);'+
                    '} else {'+
                        'value = ''"''+value+''"'';'+
                    '}'+
                    'var jo={};'+
                    'jo.m="event";'+
                    'jo.c="'+sFull+'";'+
                    'jo.i='+IntToStr(iHandle)+';'+
                    'jo.v = row+'',''+col+'',''+value;'+
                    'jo.e="change";'+
                    'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'+
                    '.then(resp =>{this.procResp(resp.data)});'+
                '},';
        joRes.Add(sCode);


        //选择区切换事件
        sCode   := sFull+'__selectionchange(val) {'
                //+'console.log(JSON.stringify(val));'
                //+'console.log(JSON.stringify(val));'
                +'var ssi=[];'
                +'Array.prototype.forEach.call(val,function(item){ssi.push(parseInt(item.d0))});'
                //+'console.log(JSON.stringify(ssi));'
                +'this.multipleSelection = val;'
                //+'console.log(ssi);'
                +'ssi.sort(function(a,b){return a>b?1:-1});'      //将序号数组从小到大正向排序
                //+'console.log(ssi);'
                +'snew=''"''+escape(JSON.stringify(ssi))+''"'';'
                //+'console.log(snew);'
                +'this.dwevent(null,"'+sFull+'",snew,"onselection",'+IntToStr(TForm(Owner).Handle)+');'
                +'},';
        joRes.Add(sCode);
(*
        //渲染列表头事件
        sCode   := ''
                +sFull+'__renderheader(h, data) {'
                    +'return h("span", ['
                        +'h("el-checkbox", {'
                            +'on: {'
                                +'change: this.'+sFull+'__selectbox'
                            +'},'
                            +'props: {'
                                +'value: this.isCheck,'
                                +'indeterminate: this.indeterminate'
                            +'}'
                        +'})'
                    +']);'
                +'},';
        joRes.Add(sCode);
*)
        //选择列表头的点击事件
        sCode   := sFull+'__selectbox(column) {'
                //+'console.log(column);'
                +'this.dwevent(null,'''+sFull+''',''"''+column+''"'',''onselect'','+IntToStr(TForm(Owner).Handle)+');'
                +'},';
        joRes.Add(sCode);

        //排序事件
        sCode   := sFull+'__sortchange(column) {'
                //+'console.log(column);'
                +'this.dwevent(null,'''+sFull+''',''"''+column.prop+''/''+column.order+''"'',''onsort'','+IntToStr(TForm(Owner).Handle)+');'
                +'},';
        joRes.Add(sCode);

        //筛选事件
        //function(filters){dwevent(null,'''+sFull+''',''"''+this.escape(JSON.stringify(filters))+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');}'//this.alert(JSON.stringify(filters))}
        sCode   := sFull+'__filterchange(filters) {'
                //+'console.log(''筛选信息发生变化:'', filters);'
                +'_this = this;'
                +'this.dwevent(null,'''+sFull+''',''"''+escape(JSON.stringify(filters))+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');'
                +'},';
        joRes.Add(sCode);

        //拖动列宽函数
        sCode   :=
                sFull+'__changecolwidth(neww, oldw, col, event){'+  //newWidth, oldWidth, column, event
                    //'console.log(col);'+
                    'var jo={};'+
                    'jo.m="event";'+
                    'jo.c="'+sFull+'";'+
                    'jo.i='+IntToStr(iHandle)+';'+
                    'jo.v = neww+'',''+oldw+'',"''+col.property+''"'';'+
                    'jo.e="changecolwidth";'+
                    'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'+
                    '.then(resp =>{this.procResp(resp.data)});'+
                '},';
        joRes.Add(sCode);


        //单击事件
        sCode   :=
                sFull+'__rowclick(row) {'
                    //+'console.log(row);'
                    +'var jo={};'
                    +'jo.m = "event";'
                    +'jo.c = "'+sFull+'";'
                    +'jo.i = '+IntToStr(iHandle)+';'
                    +'jo.v = ''''+row.id+'''';'
                    +'jo.e = "onclick";'
                    //+'console.log(jo);'
                    +'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'
                    +'.then(resp =>{this.procResp(resp.data)});'
                +'},';
        joRes.Add(sCode);

        //双击事件
        sCode   :=
                sFull+'__rowdblclick(row) {'
                    //+'console.log(row);'
                    +'var jo={};'
                    +'jo.m = "event";'
                    +'jo.c = "'+sFull+'";'
                    +'jo.i = '+IntToStr(iHandle)+';'
                    +'jo.v = ''''+row.id+'''';'
                    +'jo.e = "ondblclick";'
                    //+'console.log(jo);'
                    +'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'
                    +'.then(resp =>{this.procResp(resp.data)});'
                +'},';
        joRes.Add(sCode);
    end;
    //

    //
    Result := (joRes);
end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetMethods,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
