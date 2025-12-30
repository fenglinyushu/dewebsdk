library dwTStringGrid;

uses
    ShareMem,

    //
    dwCtrlBase,    //一些基础函数

    //
    SynCommons,    //mormot用于解析JSON的单元

    //
    SysUtils,DateUtils,ComCtrls, ExtCtrls,
    Classes,Grids,
    Variants,
    Dialogs,
    StdCtrls,
    Windows,
    Controls,
    Forms;

//处理cells,以防止出错
function _ProcessCell(ACell:String):String;
begin
    Result  := ACell;
    Result  := StringReplace(Result,'\','\\',[rfReplaceAll]);
    Result  := StringReplace(Result,'''','\''',[rfReplaceAll]);
    Result  := StringReplace(Result,'"','\"',[rfReplaceAll]);
    Result  := StringReplace(Result,#13,'',[rfReplaceAll]);     //去除换行
    Result  := StringReplace(Result,#10,'',[rfReplaceAll]);     //去除换行
end;


//从复合的标题（如：[center]籍贯） 得到标题
function _GetColCaption(AText:String):String;
var
    joCol   : Variant;
begin
    Result    := AText;
    if dwStrIsJson(AText) then begin
        joCol := _Json(AText);
        if joCol.Exists('caption') then begin
            Result  := joCol.caption;
        end else begin
            Result  := 'noname';
        end;
    end else begin
        Result  := _ProcessCell(Result);
        Result  := StringReplace(Result,'[*left*]','',[]);
        Result  := StringReplace(Result,'[*center*]','',[]);
        Result  := StringReplace(Result,'[*right*]','',[]);
    end;
end;

//从复合的标题（如:籍贯[*center*]） 得到标题
function _GetColAlign(AText:String):String;
begin
     Result    := '';
     if Pos('[*center*]',AText)>0 then begin
          Result    := ' align="center"';
     end else if Pos('[*right*]',AText)>0 then begin
          Result    := ' align="right"';
     end;
end;

//从列标题JSON对象中得到标题 对齐
function _GetColAlignFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if AJSON.Exists('align') then begin
        if AJSON.align='center' then begin
            Result    := ' align="center"';
        end else if AJSON.align='right' then begin
            Result    := ' align="right"';
        end;
    end;
end;

//从列标题JSON对象中得到selection
function _GetColTypeFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if AJSON.Exists('type') then begin
        //if AJSON.sort=True then begin
            Result    := ' type="'+AJSON.type+'"';
        //end;
    end;
end;



//从列标题JSON对象中得到排序
function _GetColSortFromJson(AJSON:Variant):String;
begin
    Result    := '';
    if AJSON.Exists('sort') then begin
        if AJSON.sort=True then begin
            Result    := ' sortable="custom"';
        end;
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

function _GetTableData(ACtrl:TControl):string;
var
     S         : string;
     iRow,iCol : Integer;
begin
     with TStringGrid(ACtrl) do begin
          S    := '[';
          for iRow := 1 to RowCount-1 do begin
               S := S + '{';
               for iCol := 0 to ColCount-1 do begin
                    S := S + '"col'+IntToStr(iCol)+'":'''+_ProcessCell(Cells[iCol,iRow])+''',';
               end;
               Delete(S,Length(S),1);
               S := S + '},'#13;
          end;
          Delete(S,Length(S)-1,2);
          S := S + ']';
     end;
     //
     Result    := S;
end;


//--------------------以上为辅助函数----------------------------------------------------------------


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    joRes   : Variant;
begin
    //
    with TStringGrid(ACtrl) do begin
        //Element table -----------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        {
        //以下是TChart时的代码,供参考
        joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
        joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
        joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
        }
        //标题行颜色<el-table :header-cell-style="{background:'#eef1f6',color:'#606266'}">

        //
        joRes.Add('<script src="dist/ex/dwStringGrid.js"></script>');

    end;
    //
    Result   := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;stdCall;
var
    joData  : Variant;
    joValue : Variant;
    joHint  : Variant;
    //
    iCol    : Integer;
    iNewW   : Integer;
    iOldW   : Integer;
    iOrder  : Integer;
    iP0,iP1 : Integer;
    sValue  : string;
    sCol    : string;
    sFilter : String;
    sKeyword: string;

    //OnMouseDown,OnMouseUp
    mButton : TMouseButton;
    mShift  : TShiftState;
    mX, mY  : Integer;
begin

    //
    with TStringGrid(ACtrl) do begin
        //Element table -------------------------------------------------

        //
        joData    := _Json(AData);
        if joData.e = 'onclick' then begin
             //保存事件
             TStringGrid(ACtrl).OnExit    := TStringGrid(ACtrl).OnClick;
             //清空事件,以防止自动执行
             TStringGrid(ACtrl).OnClick  := nil;
             //更新值
             TStringGrid(ACtrl).Row   := joData.v;
             //恢复事件
             TStringGrid(ACtrl).OnClick  := TStringGrid(ACtrl).OnExit;

             //执行事件
             if Assigned(TStringGrid(ACtrl).OnClick) then begin
                  TStringGrid(ACtrl).OnClick(TStringGrid(ACtrl));
             end;
        end else if joData.e = 'ondblclick' then begin
             //保存事件
             TStringGrid(ACtrl).OnExit    := TStringGrid(ACtrl).ondblclick;
             //清空事件,以防止自动执行
             TStringGrid(ACtrl).ondblclick  := nil;
             //更新值
             TStringGrid(ACtrl).Row   := joData.v;
             //恢复事件
             TStringGrid(ACtrl).ondblclick  := TStringGrid(ACtrl).OnExit;

             //执行事件
             if Assigned(TStringGrid(ACtrl).OnDblClick) then begin
                  TStringGrid(ACtrl).OnDblClick(TStringGrid(ACtrl));
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
            iCol    := StrToIntDef(sValue,-1)-1;

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
            sValue  := dwUnescape(sValue);  //'{"el-table_1_column_4":["襄阳","朝阳区"]}'

            //

            //得到列号
            sCol    := sValue;
            Delete(sCol,1,Pos('__d',sCol)+2);
            sCOl    := Copy(sCol,1,Pos('"',sCol)-1);
            iCol    := StrToIntDef(sCol,0);
            iCol    := iCol-1;

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
(*


            //得到列号（只允许第0列为选择）
            iCol    := 0;

            //得到选择的JSON
            joValue := _json(sValue);

            with TStringGrid(ACtrl) do begin
                //先设置所有列的选择列为0
                for iRow := 1 to RowCount-1 do begin
                    Cells[iCol,iRow]    := '0';
                end;

                //
                for iP0 := 0 to joValue._Count-1 do begin
                    iRow    := joValue._(iP0);
                    Cells[iCol,iRow]    := '1';
                end;

                if iCol >= 0 then begin
                    sFilter := 'selection__'+sValue;
                    //执行事件
                    if Assigned(OnGetEditMask) then begin
                        OnGetEditMask(TStringGrid(ACtrl),iCol,0,sFilter);
                    end;
                end;
            end;
*)
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

            //
            //
            with TStringGrid(ACtrl) do begin
                //更新列宽
                ColWidths[iCol-1] := iNewW;

                //修改后激活事件
                if Assigned(OnColumnMoved) then begin
                    OnColumnMoved(TStringGrid(ACtrl),iCol-1,iNewW);
                end;
            end;
        end;

    end;

end;



//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;stdCall;
var
    //
    iItem       : Integer;
    iColID      : Integer;
    //
    bColed      : Boolean;     //已添加表头信息
    //
    sRowStyle   : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
    joCols      : Variant;
    joCol       : Variant;
    joColInfo   : Variant;
    procedure _AddChildCol(ACol:Variant;var AColID:Integer;ASG:TStringGrid);
    var
        iiItem    : Integer;
        sSort     : String;      //排序
        sAlign    : String;      //对齐
        sFilter   : String;      //过滤
    begin
        if ACol.Exists('items') then begin
             joRes.Add('<el-table-column label="'+ACol.Caption+'">');
             for iiItem := 0 to ACol.items._Count-1 do begin
                  _AddChildCol(ACol.items._(iiItem),AColID,ASG);
             end;
             joRes.Add('</el-table-column>');
        end else begin
             //取得排序
             sSort     := '';
             if ACol.Exists('sort') then begin
                  if ACol.sort = 1 then begin
                       sSort     := ' sortable :sort-by="[''d'+IntToStr(AColID+1)+''']"';
                  end;
             end;

             //取得对齐
             sAlign    := '';
             if ACol.Exists('align') then begin
                  sAlign    :=  ' align="'+ACol.align+'"';
             end;

             //取得过滤   //:filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]"
             sFilter   := '';
             if ACol.Exists('filters') then begin
                  sFilter    := '[';
                  for iiItem := 0 to ACol.filters._Count-1 do begin
                       sFilter   := sFilter + Format('{ text:''%s'',value:''%s''},',[ACol.filters._(iiItem),ACol.filters._(iiItem)]);
                  end;
                  //删除最后的逗号
                  if Length(sFilter)>2 then begin
                       Delete(sFilter,Length(sFilter),1);
                  end;
                  sFilter    := ' :filters="'+sFilter+']" :filter-method="filterHandler"';
             end;


             //组成列字符串
             joRes.Add('<el-table-column'
                       +dwIIF(AColID<ASG.FixedCols,' fixed="left"','')
                       +dwIIF(ASG.DefaultDrawing,' show-overflow-tooltip','')

                       +' prop="d'+IntToStr(AColID+1)+'"'
                       +sSort    //排序  sortable
                       +sAlign   //对齐，align="right"'
                       +sFilter  //过滤  :filters="[{ text: '家', value: '家' }, { text: '公司', value: '公司' }]
                       +' :label="'+sFull+'__col'+IntToStr(AColID)+'"'
                       +dwIIF(AColID<ASG.ColCount-1, ' :width="'+sFull+'__cws'+IntToStr(AColID)+'"','')
                       //+' width="'+IntToStr(ASG.ColWidths[AColID])+'"'
                       +'></el-table-column>');
             //
             Inc(AColID);
        end;
    end;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TStringGrid(ACtrl) do begin
        //Element table ------------------------------------------------------------------------


        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

         //
        with TStringGrid(ACtrl) do begin
            //行高
            sRowStyle := ' :row-style="{height:'''+IntToStr(DefaultRowHeight)+'px''}"'
                    +' :header-row-style="{height:'''+IntToStr(DefaultRowHeight)+'px''}"';


            //标题行背景色
            if joHint.Exists('headerbackground') then begin
                sRowStyle := sRowStyle + ' :header-cell-style="{background:'''+String(joHint.headerbackground)+'''}"'; //背景色
            end;

            //添加外框
            joRes.Add('<div'
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style 封闭
                    +dwIIF(Assigned(OnMouseDown) or Assigned(OnMouseUp),' oncontextmenu="return false"','') //如果定义了事件，则屏幕系统的右键菜单
                    +'>');

            //添加主体
            joRes.Add('    <el-table'
                    +' id="'+sFull+'"'
                    +' :data="'+sFull+'__ces"'                      //行内数据
                    +' highlight-current-row'                       //当前行高亮
                    +sRowStyle                                      //行高和标题行背景色
                    +' ref="'+sFull+'"'                             //参考名?
                    +dwGetDWAttr(joHint)
                    +dwVisible(TControl(ACtrl))                     //是否可见
                    +dwDisable(TControl(ACtrl))                     //是否可用
                    +' :height="'+sFull+'__hei"'                    //高度, 有此值则显示滚动条，改到dwattr中

                    //2021-05-08屏蔽了以下行，主要是因为此行会导致苹果设备不能正确演示
                    //造成的损失是不能显示滚动条了
                    //+' :height="'+sFull+'__hei"' //高度, 有此值则显示滚动条

                    +' style="'
                        +'width:100%;'                              //宽度
                        +dwGetDWStyle(joHint)
                    +'"'                                                                        //
                    //+' @selection-change=function(selection){this.alert(JSON.stringify(selection))}'
                    //+' @selection-change=function(selection){dwexecute(''console.log(JSON.stringify(this.$refs.'+sFull+'.selection))'')}'
(*
                    +' @selection-change=function(selection){'
                        //+'let sel=this.escape(JSON.stringify(selection));this.console.log(this.sel);'
                        //+'dwevent(null,"'+sFull+'",this.sel,"onselection",'+IntToStr(TForm(Owner).Handle)+');'
                        +'this.console.log(selection);'
                        +'dwexecute('''
                            +'_this=this;this.ssi=[];'
                            +'Array.prototype.forEach.call(this.$refs.'+sFull+'.selection,function(item){'
                                +'_this.ssi.push(item.d0)'
                            +'});'
                            //+'alert(this.ssi);'
                            +'_this.dwevent(null,"'+sFull+'",escape(this.ssi),"onselection",'+IntToStr(TForm(Owner).Handle)+');'
                            //+'dwevent(null,\'\''','''',''onselection'',123);'
                        +''')'
                    +'}'
*)
                    +' @selection-change="'+sFull+'__selectionchange"'
                    //+' selectable=function(row,index){console.log(row)});'  //dwexecute(''console.log(this.$refs.'+sFull+'.selection)'')}'

//测试版===
                    ////以下2行
                    +' @sort-change="'+sFull+'__sortchange($event)"'//function(column){dwevent(null,'''+sFull+''',''"''+column.prop+''/''+column.order+''"'',''onsort'','+IntToStr(TForm(Owner).Handle)+');}'
                    +' @filter-change="'+sFull+'__filterchange($event)"'//function(filters){dwevent(null,'''+sFull+''',''"''+this.escape(JSON.stringify(filters))+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');}'//this.alert(JSON.stringify(filters))}

(*原版===
                    +' @sort-change=function(column){dwevent(null,'''+sFull+''',''"''+column.prop+''/''+column.order+''"'',''onsort'','+IntToStr(TForm(Owner).Handle)+');}'
                    +' @filter-change=function(filters){dwevent(null,'''+sFull+''',''"''+this.escape(JSON.stringify(filters))+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');}'//this.alert(JSON.stringify(filters))}
*)
                    //+' @filter-change=function(filters){this.alert(JSON.stringify(filters))}'
                    //+#13' @filter-change=function(filters){console.log((filters))}'

                    +dwIIF(Assigned(OnMouseDown), Format(_DWEVENT,['mousedown.native', sFull,'event.offsetX.toString()+\''/\''+event.offsetY.toString()+\''/\''+event.button.toString()+\''/\''+Number(event.ctrlKey).toString()+\''/\''+Number(event.altKey).toString()+\''/\''+Number(event.shiftKey).toString()','onmousedown',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseUp),   Format(_DWEVENT,['mouseup.native',   sFull,'event.offsetX.toString()+\''/\''+event.offsetY.toString()+\''/\''+event.button.toString()+\''/\''+Number(event.ctrlKey).toString()+\''/\''+Number(event.altKey).toString()+\''/\''+Number(event.shiftKey).toString()','onmouseup',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter',sFull,'0','onenter',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave',sFull,'0','onexit',TForm(Owner).Handle]),'')

                    +Format(_DWEVENT,['row-click',Name,'val.d0','onclick',TForm(Owner).Handle])        //单击行
                    +Format(_DWEVENT,['row-dblclick',Name,'val.d0','ondblclick',TForm(Owner).Handle])  //双击行
                    +' @header-dragend="'+sFull+'__changecolwidth"'   //拖动列宽事件
                    +' >');

            //以下为生成各列信息 -----

            //添加另外加的行号列, 用于表示行号,此行不显示，为隐藏状态
            joRes.Add('        <el-table-column'
                    +dwIIF(DefaultDrawing,' show-overflow-tooltip','')
                    +' fixed'
                    +' v-if=false'
                    +' prop="d0"'
                    +' label="rowno"'
                    +' width="10"'
                    +'></el-table-column>');

            //添加各列
            bColed    := False; //是否通过StringGrid的Hint中设置列参数
            if (not dwIsNull(joHint)) then begin
                if  joHint.Exists('columns') then begin
                    //===以下为多表头的情况

                    //标记已生成column数据
                    bColed    := True;

                    joCols    := joHint.columns;
                    iColiD    := 0;
                    for iItem := 0 to joCols._Count-1 do begin
                        joCol     := joCols._(iItem);
                        _AddChildCol(joCol,iColID,TStringGrid(ACtrl));
                    end;
                end;
            end;

            //如果没有通过StringGrid的Hint中设置列参数,则按正常情况创建列
            if not bColed then begin
                //===以下为正常表头的情况
                for iItem := 0 to ColCount-1 do begin
                    //::根据列标题是否JSON字符串进行处理
                    //-----

                    //
                    if dwStrIsJson(Cells[iItem,0]) then begin
                        //::如果列标题是JSON字符串
                        //-----

                        joColInfo := _Json(Cells[iItem,0]);
                        joRes.Add('        <el-table-column'
                            //+' id="'+sFull+'_cl'+IntToStr(iItem)+'"'
                            +dwIIF(iItem<FixedCols,' fixed="left"','')                  //固定列
                            +' v-if="'+sFull+'__clv'+IntToStr(iItem)+'"'                //可见性,用于隐藏列
                            +dwIIF(DefaultDrawing,' show-overflow-tooltip','')          //是否显示提示
                            +' prop="d'+IntToStr(iItem+1)+'"'                           //设置prop名称,以备后面使用
                            +_GetColTypeFromJson(joColInfo)                             //根据文本,确定列样式："type":"index" index/selection/expand
                            +_GetColAlignFromJson(joColInfo)                            //根据文本,确定对齐方式 "align":"right"
                            +_GetColSortFromJson(joColInfo)                             //根据文本,确定是否排序
                            +_GetColFilterFromJson(joColInfo,sFull,iItem,Owner)         //根据文本,确定是否过滤
                            +' :label="'+sFull+'__col'+IntToStr(iItem)+'"'   //
                            +dwIIF(iItem < ColCount-1,' :width="'+sFull+'__cws'+IntToStr(iItem)+'"','')
                            //+dwIIF((iItem=0)and(joColInfo.type='selection'),' @selection-change="'+sFull+'SelectionChange"','')
                            +'></el-table-column>');

                    end else begin
                        //列标题不是JSON的情况



                        joRes.Add('        <el-table-column'
                            +dwIIF(iItem<FixedCols,' fixed="left"','')   //固定列
                            +' v-if="'+sFull+'__clv'+IntToStr(iItem)+'"'
                            +dwIIF(DefaultDrawing,' show-overflow-tooltip','')
                            +' prop="d'+IntToStr(iItem+1)+'"'
                            +_GetColAlign(Cells[iItem,0])      //根据文本,确定对齐方式
                            +' :label="'+sFull+'__col'+IntToStr(iItem)+'"'
                            +dwIIF(iItem < ColCount-1,' :width="'+sFull+'__cws'+IntToStr(iItem)+'"','')
                            +'></el-table-column>');
                    end;
                end;
            end;
        end;

    end;
    //
    Result   := joRes;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;stdCall;
var
    joRes     : Variant;
begin
    //
    with TStringGrid(ACtrl) do begin
        //Element table ------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //生成返回值数组
        joRes.Add('    </el-table>');
        joRes.Add('</div>');

    end;
    //
    Result   := joRes;
end;



//取得Data
function dwGetData(ACtrl:TControl):String;stdCall;
var
    joRes   : Variant;
    joTmp   : Variant;
    //
    iRow    : Integer;
    iCol    : Integer;
    iTmp    : Integer;
    sCode   : String;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    //
    with TStringGrid(ACtrl) do begin
        //Element table ------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TStringGrid(ACtrl) do begin

            //
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //列标题
            for iCol := 0 to ColCount-1 do begin
                 joRes.Add(sFull+'__col'+IntToStr(iCol)+':"'+_GetColCaption(Cells[iCol,0])+'",');
            end;
            //列宽
            for iCol := 0 to ColCount-1 do begin
                 joRes.Add(sFull+'__cws'+IntToStr(iCol)+':"'+IntToStr(ColWidths[iCol])+'",');
            end;
            //列显隐
            for iCol := 0 to ColCount-1 do begin
                 joRes.Add(sFull+'__clv'+IntToStr(iCol)+':'+dwIIF(ColWidths[iCol]>0,'true','false')+',');
            end;


            //内容 cells
            sCode     := sFull+'__ces:[';
            for iRow := 1 to RowCount-1 do begin
                 sCode     := sCode + '{d0:'''+IntToStr(iRow)+''',';
                 for iCol := 0 to ColCount-1 do begin
                      sCode     := sCode + 'd'+IntToStr(iCol+1)+':'''+_ProcessCell(Cells[iCol,iRow])+''',';
                 end;
                 Delete(sCode,Length(sCode),1);
                 sCode     := sCode + '},';
            end;
            if RowCount>1 then begin
                 Delete(sCode,Length(sCode),1);
            end;
            sCode     := sCode + '],';
            joRes.Add(sCode);
(*
            joRes.Add(sFull+'__ces:[{');
            for iRow := 1 to RowCount-1 do begin
                 joRes.Add('d0: '''+IntToStr(iRow)+''',');
                 for iCol := 0 to ColCount-1 do begin
                      if iCol < ColCount-1 then begin
                           joRes.Add('d'+IntToStr(iCol+1)+': '''+Cells[iCol,iRow]+''',');
                      end else begin
                           joRes.Add('d'+IntToStr(iCol+1)+': '''+Cells[iCol,iRow]+'''');
                      end;
                 end;
                 if iRow<RowCount-1 then begin
                      joRes.Add('},{');
                 end else begin
                      joRes.Add('}],');
                 end;
            end;
*)

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
    end;
    //
    Result   := joRes;
    //Result  := StrAlloc(Length(sCode)+1);
    //StrPCopy(Result,sCode);
end;



//取得Method
function dwGetAction(ACtrl:TControl):String;stdCall;
var
    joRes       : Variant;
    //
    iRow,iCol   : Integer;
    sCode       : String;
    sFull       : string;
begin
    //
    sFull   := dwFullName(ACtrl);
    //
    with TStringGrid(ACtrl) do begin
        //Element table -------------------------------------------------

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
             joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));

             //列标题
             for iCol := 0 to ColCount-1 do begin
                  joRes.Add('this.'+sFull+'__col'+IntToStr(iCol)+'="'+_GetColCaption(Cells[iCol,0])+'";');
             end;
             //列宽
             for iCol := 0 to ColCount-1 do begin
                  joRes.Add('this.'+sFull+'__cws'+IntToStr(iCol)+'="'+IntToStr(ColWidths[iCol])+'";');
             end;
             //列显隐
             for iCol := 0 to ColCount-1 do begin
                  joRes.Add('this.'+sFull+'__clv'+IntToStr(iCol)+'='+dwIIF(ColWidths[iCol]>0,'true','false')+';');
             end;

            //内容 cells
            sCode     := 'this.'+sFull+'__ces=[';
            for iRow := 1 to RowCount-1 do begin
                 sCode     := sCode + '{d0:'''+IntToStr(iRow)+''',';
                 for iCol := 0 to ColCount-1 do begin
                      sCode     := sCode + 'd'+IntToStr(iCol+1)+':'''+_ProcessCell(Cells[iCol,iRow])+''',';
                 end;
                 Delete(sCode,Length(sCode),1);
                 sCode     := sCode + '},';
            end;
            if RowCount>1 then begin
                 Delete(sCode,Length(sCode),1);
            end;
            sCode     := sCode + '];';
            joRes.Add(sCode);

            //行号(一直显示行号)
            //joRes.Add('/*real*/ this.$refs.'+sFull+'.setCurrentRow(this.$refs.'+sFull+'.data['+IntToStr(Row-1)+']);');
        end;
    end;
    //
    Result   := joRes;
    //Result  := StrAlloc(Length(sCode)+1);
    //StrPCopy(Result,sCode);
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode   : string;
    iHandle : Integer;
    //
    joRes   : Variant;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);
    //
    joRes   := _json('[]');


    //取得句柄备用
    iHandle := TForm(ACtrl.Owner).Handle;

    with TStringGrid(ACtrl) do begin
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

        //排序事件
        sCode   := sFull+'__sortchange(column) {'
                //+'console.log(column);'
                +'this.dwevent(null,'''+sFull+''',''"''+column.prop+''/''+column.order+''"'',''onsort'','+IntToStr(TForm(Owner).Handle)+');'
                +'},';
        joRes.Add(sCode);

        //筛选事件
        //function(filters){dwevent(null,'''+sFull+''',''"''+this.escape(JSON.stringify(filters))+''"'',''onfilter'','+IntToStr(TForm(Owner).Handle)+');}'//this.alert(JSON.stringify(filters))}
        sCode   := sFull+'__filterchange(filters) {'
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
    end;

    //
    Result   := joRes;
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;

begin
end.


