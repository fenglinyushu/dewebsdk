library  dwTListView__crud;
{！！！严禁直接修改代码！！！}

uses
    System.ShareMem,      //必须添加
    //
    dwCtrlBase,
    dwDB,
    //
    SynCommons,
    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.ADSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef, FireDAC.Phys.ASADef,
    FireDAC.Phys.MongoDBDef, FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
    FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB, FireDAC.Phys.ASA,
    FireDAC.Phys.TData, FireDAC.Phys.Infx, FireDAC.Phys.DB2, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
    FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.ADS,
    FireDAC.Phys.MySQL, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageBin,
    FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient,
    //
    Math,
    StrUtils,
    Generics.Collections,
    Messages,
    Graphics,
    ComCtrls,
    ExtCtrls,
    Data.DB,
    ADODB,
    Vcl.DBGrids,
    SysUtils,
    Variants,
    Classes,
    Dialogs,
    StdCtrls,
    Windows,
    Controls,
    Forms;
//function _PreprocessHint(var AHint:Variant):Integer; //预处理Hint, 填补不存在的默认项
function _PreprocessHint(var AHint:Variant):Integer;
begin
    //检查属性，如不存在，则赋默认值
    //数组
    dwSetDefaultObj(AHint,'merge',_json('[]'));
    dwSetDefaultObj(AHint,'summary',_json('[]'));
    dwSetDefaultObj(AHint,'__selection',_json('[]'));
    //颜色
    dwSetDefaultStr(AHint,'headbkcolor','#f8f8f8');
    dwSetDefaultStr(AHint,'hover','#f5f5f5');
    dwSetDefaultStr(AHint,'record','rgb(224,243,255)');   //当前记录位置颜色 
    //数值
    dwSetDefaultInt(AHint,'rowheight',40);
    dwSetDefaultInt(AHint,'headerheight',40);
    dwSetDefaultInt(AHint,'summaryheight',40);
    dwSetDefaultInt(AHint,'pagesize',10);
    //
    dwSetDefaultStr(AHint,'__sort','');
    dwSetDefaultStr(AHint,'__search','');
    //
    dwSetDefaultStr(AHint,'dataset','');
    dwSetDefaultStr(AHint,'topstyle','');
    dwSetDefaultStr(AHint,'datastyle','');
    //返回值
    Result  := 0;                             
end;

//function _GetFontWeight(AFont:TFont):String; //取字体粗体
function _GetFontWeight(AFont:TFont):String;
begin
    if fsBold in AFont.Style then begin
        Result    := 'bold';
    end else begin
        Result    := 'normal';
    end;
end;

//function _GetFontStyle(AFont:TFont):String; //取字体斜体
function _GetFontStyle(AFont:TFont):String;
begin
    if fsItalic in AFont.Style then begin
        Result    := 'italic';
    end else begin
        Result    := 'normal';
    end;
end;

//function _GetTextDecoration(AFont:TFont):String; //取字体下划线/删除线
function _GetTextDecoration(AFont:TFont):String;
begin
    if fsUnderline in AFont.Style then begin
        Result    :='underline';
        if fsStrikeout in AFont.Style then begin
            Result    := 'line-through';
        end;
    end else begin
        if fsStrikeout in AFont.Style then begin
            Result    := 'line-through';
        end else begin
            Result    := 'none';
        end;
    end;
end;

//function _GetModule(AHint:Variant;AIndex:Integer):Boolean; //模块是否显示设置，为：顶/增/删/改/查/分
//0:顶部框，1/2/3/4增删改查，5分页
function _GetModule(AHint:Variant;AIndex:Integer):Boolean;
begin
    Result  := True;
    //0,1,2,3,4,5 ： 顶/增/删/改/查/分页
    if AIndex in [0,1,2,3,4,5] then begin
        if AHint.Exists('module') then begin
            if AHint.module._Count>AIndex then begin
                Result  := AHint.module._(AIndex)<>0;
            end;
        end;
    end;
end;

//function _GetFields(AGrid:TListView):Variant; //取字段JSON对象数组
function _GetFields(AGrid:TListView):Variant;
var
    iCol    : Integer;
    iFullW  : Integer;  //DBGrid总宽度
    iSumW   : Integer;  //各列总和
    iL      : Integer;
    //W
    fRatio  : Double;   //缩放比例
    //
    sCapt   : string;
    //
    joField : Variant;
begin
    Result  := _json('[]');
    //先设置所有字段的宽度总和iSumW = 0.也即当前列的left
    iSumW   := 0;
    //取得各字段的属性，如果没有，则设置为默认值。并取得iSumW
    for iCol := 0 to AGrid.Columns.Count-1 do begin
        //根据caption生成JSON
        joField := _json(AGrid.Columns[iCol].Caption);
        //如果Caption不是JSON，则从字段信息中生成
        if joField = unassigned then begin
            //根据字段信息等生成字段JSON字象joField
            joField             := _json('{}');
            joField.type        := 'string';
            joField.fieldname   := '';
            joField.width       := AGrid.Columns[iCol].Width;
            joField.caption     := AGrid.Columns[iCol].Caption;
            joField.color       := dwColor(AGrid.Font.Color);
            joField.bkcolor     := 'transparent';
            joField.align       := dwGetAlignment(AGrid.Columns[iCol].alignment);
        end;
        //补齐默认项
        dwSetDefaultStr(joField,'type','string');
        dwSetDefaultInt(joField,'width',AGrid.Columns[iCol].Width);
        dwSetDefaultStr(joField,'fieldname','');
        dwSetDefaultStr(joField,'caption',joField.fieldname);
        dwSetDefaultStr(joField,'color',dwColor(AGrid.Font.Color));
        dwSetDefaultStr(joField,'bkcolor','transparent');
        dwSetDefaultStr(joField,'align',dwGetAlignment(AGrid.Columns[iCol].alignment));
        dwSetDefaultInt(joField,'sort',0);
        //dwSetDefaultInt(joField,'minvalue',0);
        //dwSetDefaultInt(joField,'maxvalue',100);
        dwSetDefaultObj(joField,'readonly',0);
        joField.left := iSumW;
        //计算字段宽度之和
        iSumW   := iSumW + joField.width;
        //默认viewwidth
        joField.viewwidth   := joField.width;
        //将当前字段添加到返回值JSON数组
        Result.Add(joField);
    end;
    //如果无有效字段信息，则退出
    if (Result._Count = 0) or ((Result._Count = 1) and ((Result._(0).fieldname = ''))) then begin
        Exit;
    end;
    //更新显示宽度viewwidth
    //取得Grid宽度iFullW备用
    iFullW  := AGrid.Width;
    //如果Grid宽度 > 各列宽度之和
    if iFullW>iSumW then begin
        if Result._(Result._Count-1).type = 'button' then begin
            //扩展倒数第2列宽度
            Result._(Result._Count-2).viewwidth := Result._(Result._Count-2).viewwidth + iFullW - iSumW - 9;
        end else begin
            //扩展倒数第1列宽度
            Result._(Result._Count-1).viewwidth := Result._(Result._Count-1).viewwidth + iFullW - iSumW - 9;
        end;
    end;
end;

//function _GetTitleCount(AHint:Variant):Integer;
//取汇总栏行数
function _GetTitleCount(AHint:Variant):Integer;
var
    iItem   : Integer;
    iCount  : Integer;
    
begin
    Result  := 1;
    for iItem := 0 to AHint.merge._Count - 1 do begin
        Result  := Max(Result,AHint.merge._(iItem)._(0));
    end;
end;

//function _GetSumCount(AHint:Variant):Integer;
//取汇总栏行数
function _GetSumCount(AHint:Variant):Integer;
var
    iSum    : Integer;
    iCount  : Integer;
    iItem   : Integer;
begin
    Result  := 0;
    for iSum := 1 to AHint.summary._Count - 1 do begin
        iCount  := 1;
        for iItem := 1 to iSum-1 do begin
            if AHint.summary._(iSum)._(0) = AHint.summary._(iItem)._(0) then begin
                iCount  := iCount + 1;
            end;
        end;
        Result := Max(Result,iCount);
    end;
end;

//function _GetTitleHtml(AGrid:TListView;AHint,AFields:Variant):string;
//创建表头HTML字符串
function _GetTitleHtml(AGrid:TListView;AHint,AFields:Variant):string;
var
    iL,iT   : Integer;
    iW,iH   : Integer;
    iCol    : Integer;
    iLevel  : Integer;  //表头的层次
    iStart  : Integer;  //表头合并的开始序号，从0开始 ，空间为[]
    iEnd    : Integer;  //表头合并的结束序号，从0开始
    iItem   : Integer;
    iCount  : Integer;  //表头中换行符的个数，用于计算TOp
    iTop    : Integer;
    iMax    : Integer;
    iHeadH  : Integer;
    //
    sCapt   : String;
    sFull   : string;
    //
    joField : Variant;
    joMerge : Variant;
    joCols  : Variant;
    joItem  : Variant;
const
    //标题换行后计算的top值
    _TOPS   : array[0..5] of Integer = (-4,-12,-24,-32,-42,-54);
begin
    iMax    := _GetTitleCount(AHint);
    iHeadH  := dwGetInt(AHint,'headerheight',40);
    //计算各字段表头的高度（楼层）,保存在joFields.max
    for iCol := 0 to AFields._Count - 1 do begin
        //默认为最大楼层高
        //取得当前字段JSON对象
        joField     := AFields._(iCol);
        //默认为最大楼层高
        joField.max := iMax;
        for iItem := 0 to AHint.merge._Count - 1 do begin
            //取当前表头合并信息
            iLevel  := AHint.merge._(iItem)._(0)-1;  //楼层
            iStart  := AHint.merge._(iItem)._(1);  //起始序号
            iEnd    := AHint.merge._(iItem)._(2);  //结束序号
            //如果当前列在合并范围之中，则降低楼层
            if (iCol>=iStart) and (iCol<=iEnd) then begin
                AFields._(iCol).max := Min(AFields._(iCol).max,iLevel);
            end;
        end;
    end;
    //根据max计算各字段表头的T/H，输出：joField.top/height
    for iCol := 0 to AFields._Count - 1 do begin
        joField := AFields._(iCol);
        //
        joField.top     := ( iMax - joField.max ) * iHeadH;
        joField.height  := joField.max * iHeadH;
    end;
    //生成HTML
    //生成标题栏外框(首部) dg__tit
    sFull   := dwFullName(AGrid);
    Result  := Concat('<div',
            ' id="'+sFull+'__tit"',
            ' :style="{',
                'left:'+sFull+'__ttl',       //ttl : title left
            '}"',
            ' style="',
                'position:absolute;',
                'top:-1px;',
                //'color: #606266;',
                'color:'+dwColor(AGrid.Font.Color),
                'background: linear-gradient(#f4f5f8,#f1f3f6);',
                'z-index:9;',
                'height:'+IntToStr(iMax*iHeadH)+'px;',
            '"',
            '>');
    //生成合并字段merge标题的HTML
    for iItem := 0 to AHint.merge._Count - 1 do begin
        //取得Top/CAPTION备用
        joMerge := AHint.merge._(iItem);
        //
        iT      := iHeadH * (iMax-joMerge._(0));
        sCapt   := joMerge._(3);
        Result  := Result + Format(#13'                <div class="'+sFull+'dwdbgridtitle"'
                + ' :style="{'
                    +'left:'+sFull+'__ml%d,'
                    +'width:'+sFull+'__mw%d'
                +'}"'
                +' style="'
                   +'position:absolute;top:%dpx;height:%dpx;'
                +'"'
                +'>'
                +'<span style="display:inline-block;">'
                    +'%s'
                +'</span>'
                +'</div>',
                [iItem,iItem,iT,iHeadH-1,sCapt]);
    end;
    //生成各字段标题的HTML
    for iCol := 0 to AFields._Count - 1 do begin
        //取得LTWH/CAPTION备用
        joField := AFields._(iCol);
        //
        iL      := joField.left;
        iT      := joField.top;
        iW      := joField.viewwidth;
        iH      := joField.height;
        sCapt   := joField.caption;
        
        if joField.type = 'check' then begin
            Result  := Result + Format(
                    #13'<el-checkbox'
                    +' v-model="'+sFull+'__cb'+IntToStr(iCol)+'"'
                    +' class="'+sFull+'dwdbgridtitle"'
                    +' :style="{'
                        +'left:'+sFull+'__fl%d,'
                        +'width:'+sFull+'__fw%d'
                    +'}"'
                    +' style="'
                       +'position:absolute;'
                       +'top:%dpx;'
                       +'height:%dpx;'
                       +'line-height:%dpx;'
                    +'"'
                    +' @change='''+sFull+'__cc'+IntToStr(iCol)+''''
                    +'>'
                    +'</el-checkbox>',
                    [iCol,iCol,iT,iH,iH,iCol]);
        end else begin
            Result  := Result + Format(#13'                '
                    +'<div class="'+sFull+'dwdbgridtitle"'
                	+ ' :style="{'
                		+'left:'+sFull+'__fl%d,'
                		+'width:'+sFull+'__fw%d'
                	+'}"'
                	+' style="'
                		+'position:absolute;top:%dpx;height:%dpx;'
                	+'">'
                		+'<div>'
                		+'<span style="display:inline-block;">'
                			+'%s'
                		+'</span>',
                		[iCol,iCol,iT,iH,sCapt]);
            if joField.sort=1 then begin
                //得到标题的换行个数
                iCount  := dwSubStrCount(sCapt,'<br/>');
                //计算Top，以显示排序按钮
                if iCount <= 5 then begin
                    iTop    := _Tops[iCount];
                end else begin
                    iTop    := -42-10*(iCount-4);
                end;
                Result  := Result
                        + '<span class="caret-wrapper"'
                            +' style="'
                                +'display: inline-flex;'
                                +'flex-direction: column;'
                                +'top: '+IntToStr(iTop)+'px;'     //根据标题中<br/>的个数控制top
                                +'position: relative;'
                            +'"'
                        +'>'
                        +'<i class="el-icon-caret-top"'
                            //+' @click=''dwevent('
                            //        +'"",'
                            //        +'"'+sFull+'",'
                            //        +'"'+IntToStr(iCol)+'",'
                            //        +'"onsortasc",'
                            //        +IntToStr(TForm(AGrid.Owner).Handle)
                            //+');'''
                            +' @click="'+sFull+'__sortasc($event,'+IntToStr(iCol)+')"'            
                        +'></i>'
                        +'<i class="el-icon-caret-bottom"'
                            //+' @click=''dwevent('
                            //        +'"",'
                            //        +'"'+sFull+'",'
                            //        +'"'+IntToStr(iCol)+'",'
                            //        +'"onsortdesc",'
                            //        +IntToStr(TForm(AGrid.Owner).Handle)
                            //+');'''
                            +' @click="'+sFull+'__sortdesc($event,'+IntToStr(iCol)+')"'            
                        +'>'
                        +'</i>'
                        +'</span>';
            end;
            Result  := Result + '</div></div>';
        end;
    end;
    //生成标题栏外框(尾部) dg__tit
    Result  := Result + '</div>';
end;

//function _GetSQL(ACtrl:TComponent;var AOldSQL:String):Boolean;
function _GetSQL(ACtrl:TComponent;var AOldSQL:String):Boolean;
var
    iPos        : Integer;
    iSelect     : Integer;   //Select 位置
    iFrom       : Integer;   //from  位置
    iWhere      : Integer;   //where 位置
    iGroup      : Integer;   //group 位置
    iGroupBy    : Integer;   //group 后的 by 位置
    iOrder      : Integer;   //order 位置
    iOrderBy    : Integer;   //order 后的 by 位置
    iStart      : Integer;
    iEnd        : Integer;
    //
    sSQL        : string;
    sTmp        : string;
    //
    oDataSet    : TDataSet;
    //
    joHint      : Variant;
    
begin
    //默认值
    AOldSQL     := '';  //去除字段列表中的as
    Result  := False;
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));
    if joHint.Exists('__oldsql') then begin
        //从HINT的JSON对象中直接取SQL关键信息
        AOldSQL     := joHint.__oldsql;
        //
        Result  := True;
        Exit;
    end else begin
        with TListView(ACtrl) do begin
            oDataSet    := nil;
            if ( joHint.dataset<> '' ) then begin
                //取DataSet
                oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
            end;
            //如oDataSet = nil， 则退出
            if oDataSet = nil then begin
                Exit;
            end;
            if oDataSet.ClassName <> 'TFDQuery' then begin
                Exit;
            end;
            AOldSQL := LowerCase(Trim(TFDQuery(oDataSet).SQL.Text));
            //将结果保存到Hint中
            joHint.__oldsql     := AOldSQL;
            Hint                := joHint;
            
            //
            Result  := True;
        end;
    end;
end;

//function _UpdateQuery(ACtrl:TComponent):Integer; //取分页数据，返回记录数
function _UpdateQuery(ACtrl:TComponent):Integer;
var
    iPos        : Integer;
    iPageSize   : Integer;
    iOldRecNo   : Integer;
    //
    sSQL        : string;
    sOldSQL     : string;
    s0          : string;   //用于分页时的中间SQL字符串
    //
    sField      : string;   //SQL的字段列表
    sTable      : string;   //SQL的表名
    sWhere      : string;   //SQL的WHERE（原始）   前面无 WHERE
    sGroup      : string;   //SQL的GROUP           前面无 GROUP BY
    sOrder      : string;   //SQL的ORDER（原始）   前面无 ORDER BY
    sSort       : string;   //用户点击的排序字符， 前面无 ORDER BY
    sSearch     : String;   //用户输入关键字生成的WHERE， 形如WHERE (...)
    sPrimaryKey : string;   //辅助排序用的字段，默认为id
    sDB         : string;   //数据库类型，默认为通用，可选项有mssql, mysql, sqlite, oracle等
    //
    oDataSet    : TDataSet;
    //
    joHint      : Variant;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
begin
    //默认值 :  0
    Result  := 0;
    _GetSQL(ACtrl,sOldSQL);
    //预处理，取得配置参数
    //取得HINT对象joHint,并预处理
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    //取pagesize
    iPageSize   := dwGetInt(joHint,'pagesize',10);
    with TListView(ACtrl) do begin
        //取 oDataSet,并检测。如不存在或非TFDQuery,则退出
        oDataSet    := nil;
        if ( joHint.dataset<> '' ) then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Exit;
        end;
        if oDataSet.ClassName <> 'TFDQuery' then begin
            Exit;
        end;
        iOldRecNo   := oDataSet.RecNo;
        //根据是否append状态,分别处理
        if Cursor = crCross then begin
            //append状态
            joHint.__recordcount := oDataSet.RecordCount;
            Hint    := joHint;
            Result  := oDataSet.RecordCount;
        end else begin
            //正常更新数据
            //取主键字段名，用于辅助select top,默认为id.可以Hint中写primarykey
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;
            //取得关键参数 sSort/sSearch
            sSort   := dwGetStr(joHint,'__sort','');
            sSearch := dwGetStr(joHint,'__search','');
            sWhere  := sSearch;
            //合并sSort/sOrder 到 sOrder, 此时sOrder不以'ORDER BY'开始
            if sSort <> '' then begin
                sOrder := sSort;
            end;
            //为非空sGroup增加group by
            if sGroup <> '' then begin
                sGroup  := ' GROUP BY ' + sGroup;
            end;
            //重新查询，取得RecordCount,保存到joHint.__recordcount
            with TFDQuery(oDataSet) do begin
                DisableControls;
                
                //保存原事件函数
                oAfter  := AfterScroll;
                oBefore := BeforeScroll;
                //清空事件
                AfterScroll    := nil;
                BeforeScroll   := nil;
                //执行SQL
                Close;
                S0          := Format('SELECT %s FROM %s %s %s',[sField,sTable,sWhere,sGroup]);
                SQL.Text    := Format('SELECT count(*) FROM (%s) A %s',[sOldSQL,sWhere]);
                FetchOptions.RecsSkip   := 0;
                FetchOptions.RecsMax    := -1;
                Open;
                joHint.__recordcount := Fields[0].AsInteger; 
                Hint    := joHint;
                Result  := Fields[0].AsInteger; 
                EnableControls;
                //恢复原事件函数
                AfterScroll    := oAfter;
                BeforeScroll   := oBefore;
            end;
            //重新查询，取得数据集,返回
            with TFDQuery(oDataSet) do begin
                if sOrder <> '' then begin
                    sOrder := ' ORDER BY ' + sOrder;
                end else begin
                    sOrder := ' ORDER BY ' + sPrimaryKey;
                end;
                //是否分页,然后查询
                if iPageSize = 9999 then begin
                    //9999
                    Close;
                    SQL.Text    := Format('SELECT %s FROM %s %s %s %s',[sField,sTable,sWhere,sGroup,sOrder]);
                    Open;
                end else begin
                    Close;
                    SQL.Text    := Format('SELECT * FROM (%s) A %s %s',[sOldSQL,sWhere,sOrder]);
                    FetchOptions.RecsSkip   := iPageSize * HelpContext;
                    FetchOptions.RecsMax    := iPageSize;
                    Open;
                end;
                //恢复原来位置
                if (oDataSet.RecordCount>=iOldRecNo)and(iOldRecNo>0) then begin
                    oDataSet.RecNo  := iOldRecNo;
                end;
            end;
        end;
    end;
end;

//---------------------以上为辅助函数---------------------------------------------------------------
function dwGetExtra(ACtrl: TComponent): string; stdcall;
var
    joRes       : Variant;
    joHint      : Variant;
    //
    sCode           : string;
    sFull           : string;
    sHeaderBKColor  : string;
    sEvenBKColor    : string;   //偶数行背景色

    //
    iRowH           : Integer;
    iColW           : Integer;
    iRowHeight      : Integer;
    iHeaderHeight   : Integer;
begin
    joRes    := _Json('[]');
    joHint  := dwGetHintJson(TListView(Actrl));
    //得到行高
    iRowHeight  := dwGetInt(joHint,'rowheight',40);
    
    //得到标题栏行高
    iHeaderHeight   := dwGetInt(joHint,'rowheight',40);
    
    //得到标题栏背景色
    sHeaderBKColor  := dwGetStr(JoHint,'headerbkcolor','#f8f9fe');
    
    //奇数行颜色
    sEvenBkColor    := dwGetStr(JoHint,'evenbkcolor','#f8f9fe');
    
    //
    sFull           := dwFullName(ACtrl);
    with TListView(ACtrl) do begin
        sCode   := '<style>'
        		+' .'+sFull+'dwdbgridtitle{'
                    +'position:absolute;'
        			+dwIIF(BorderStyle=bsSingle,'text-align:center;','text-align:left;')
        			//+'text-align:left;'
        			+dwIIF(BorderStyle=bsSingle,'','padding-left:5px;')
        			+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ebeef5;','border-top:solid 1px #dcdfe6;border-bottom:solid 1px #ebeef5;')
        			+'font-weight:bold;'
                    +'overflow:hidden;'
                    //+'background-color:#fafafa;'//+sHeaderBKColor+';'            
                    //+'background: linear-gradient(rgb(244, 245, 248), rgb(241, 243, 246));'
        			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
        			//+'line-height:'+IntToStr(iHeaderHeight)+'px;'
                    +'justify-content: center;'
                    +'flex-direction: column;'
                    +'display: flex;'
        		+'}'
        		+' .'+sFull+'dwdbgrid0{'
                    +'position:absolute;'
        			//+'text-align:center;'
                    +'padding-left:5px;padding-right:5px;'
        			+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ebeef5;','border-top:solid 1px #ebeef5;border-bottom:solid 1px #ebeef5;')
                    +'outline:none;'
        			+'overflow:hidden;'
        			//+'border:solid 1px #ececec;'
        			+'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'color:'+dwColor(Font.Color)+';'
        			+'height:'+IntToStr(iRowHeight-1)+'px;'
        			+'line-height:'+IntToStr(iRowHeight-1)+'px;'
                    +'white-space: nowrap;'     //不折行
        		+'}'
                +'</style>';
        //引入对应的库
        joRes.Add(sCode);
        
        //
        sCode   := '<style>'
                +'.dwscroll_bottom::-webkit-scrollbar {/*滚动条整体样式*/'
                    +'width:5px;/*高宽分别对应横竖滚动条的尺寸*/'
                    +'height:5px;'
                +'}'
                +'.dwscroll_bottom::-webkit-scrollbar-thumb {/*滚动条里面小方块*/'
                    +'border-radius:5px;'
                    +'-webkit-box-shadow: inset005pxrgba(0,0,0,0.2);'
                    +'background:rgba(0,0,0,0.2);'
                +'}'
                +'.dwscroll_bottom::-webkit-scrollbar-track {/*滚动条里面轨道*/'
                    +'-webkit-box-shadow: inset005pxrgba(0,0,0,0.2)'
                    +'border-radius:0;'
                    +'background:rgba(0,0,0,0.1);'
        		+'}'
                +'</style>';
        
        //引入对应的库
        joRes.Add(sCode);
        
        
        //
        Result    := joRes;
    end;
end;

//function dwGetEvent(ACtrl: TComponent; AData: string): string; stdcall;
function dwGetEvent(ACtrl: TComponent; AData: string): string; stdcall;
var
    //
    iCol        : Integer;
    iItem       : Integer;
    iColId      : Integer;
    iOldRecNo   : Integer;
    iRecNo      : Integer;
    iPageSize   : Integer;
    //
    bFound      : Boolean;
    //
    sValue      : String;
    sField      : string;
    sOldSQL     : string;
    sTable      : string;
    sWhere      : String;
    sGroup      : string;
    sOrder      : string;
    sSort       : string; //用于记录排序信息的__sort
    sSearch     : string; //用于记录搜索信息的__search
    sDBFields   : string;
    sNewWhere   : String;
    sJS         : string;
    sFull       : string;
    sPrimaryKey : string;  //数据表主键，用于辅助select top，默认为id,或joHint.primarykey
    //
    oDataSet    : TDataSet;
    //
    joData      : Variant;
    joHint      : Variant;
    joValue     : Variant;
    joFields    : Variant;
    joField     : Variant;
    joSelection : variant;
begin
    //取joData,joHint,sFull
    joData  := _Json(AData);
    joHint  := dwGetHintJson(TControl(ACtrl));
    _PreProcessHint(joHint);
    sFull   := dwFullName(Actrl);
    if joData = unassigned then begin
        Exit;
    end;
    with TListView(ACtrl) do begin
        //取DataSet. 为nil则退出
        oDataSet    := nil;
        if ( joHint.dataset<> '' ) then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        if oDataSet = nil then begin
            Exit;
        end;
        joFields    := _GetFields(TListView(ACtrl));
        oDataSet.DisableControls;
        //根据事件名称，分别处理
        if joData.e = 'oncompclick' then begin
            //joData.e = 'oncompclick'
        end else if joData.e = 'onappend' then begin
            oDataSet.Append;
            for iCol := 0 to joFields._Count-1 do begin
                joField    := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    if joField.Exists('default') then begin
                        oDataSet.FieldByName(joField.fieldname).AsVariant   := joField.default;
                    end else begin
                        if oDataSet.FieldByName(joField.fieldname).DataType in [ftString, ftMemo, ftFmtMemo,ftWideString, ftFixedWideChar, ftWideMemo ] then begin
                            oDataSet.FieldByName(joField.fieldname).AsString   := '';
                        end;
                    end;
                end;
            end;
            oDataSet.Post;
            oDataSet.Refresh;
            //设置Cursor 为 crCross 标识当前为新增，以 不更新数据
            Cursor  := crCross;
            //生成新记录的值(如果不加这一段，会显示上次的记录值)
            sJS := '';
            for iCol := 0 to joFields._Count-1 do begin
                joField    := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    if (joField.type='integer') or (joField.type='rate') then begin
                        sJS := sJS + 'this.'+sFull+'__di'+IntToStr(iCol)+'=0;'
                    end else begin
                        if joField.Exists('default') then begin
                            sJS := sJS + 'this.'+sFull+'__di'+IntToStr(iCol)+'="'+joField.default+'";'
                        end else begin
                            sJS := sJS + 'this.'+sFull+'__di'+IntToStr(iCol)+'="";'
                        end;
                    end;
                end;
            end;
        end else if joData.e = 'onappendcancel' then begin
            oDataSet.Delete;
            //设置Cursor 为 crDefault 标识当前非为新增，以更新数据
            Cursor  := crDefault;
        end else if joData.e = 'oneditsave' then begin
            //得到数据字符串，JSON数组格式,0始
            sValue  := dwUnescape(joData.v);
            joValue := _json(sValue);
            //设置Cursor 为 crDefault 标识当前非为新增，以更新数据
            Cursor  := crDefault;
            oDataSet.Edit;
            for iCol := 0 to joFields._Count-1 do begin
                joField    := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    if oDataSet.FieldByName(joField.fieldname).DataType <> ftAutoInc then begin
                        oDataSet.FieldByName(joField.fieldname).AsString   := joValue._(iCol);
                    end;
                end;
            end;
            oDataSet.Post;
            oDataSet.Refresh;
        end else if joData.e = 'onclick' then begin
            //得到记录位置和列序号
            iCol    := joData.v mod 100;
            iRecNo  := joData.v div 100;
            //移动数据表位置
            oDataSet.RecNo := iRecNo;
        end else if joData.e = 'onquery' then begin
            //v为搜索关键字（可能多个） sValue
            sValue  := Trim(dwUnescape(joData.v));
            //置当前为第1页，即HelpContext := 0;
            HelpContext := 0;
            //生成当前各列的字段名列表 sDBFields，如：name,model,age,memo
            sDBFields   := '';
            for iCol := 0 to joFields._Count-1 do begin
                joField     := joFields._(iCol);
                if joField.fieldname <> '' then begin
                    sDBFields   := sDBFields + '['+joField.fieldname + '],';
                end;
            end;
            Delete(sDBFields,Length(sDBFields),1);
            //生成关键字的WHERE,并写__search
            sNewWhere   := dwGetWhere(sDBFields,sValue);
            joHint.__search := sNewWhere;
            Hint    := joHint;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onsortasc' then begin
            //从v取行序号iColId
            iColId  := StrToIntDef(joData.v,0);
            //iColId超范围，则退出
            if (iColId<0)or(iColId>joFields._Count-1) then begin
                Exit;
            end;
            //iColId字段无fieldname，则退出
            if joFields._(iColId).fieldname='' then begin
                Exit;
            end;
            //取原SQL的关键要素
            _GetSQL(ACtrl,sOldSQL);
            //
            sSort    := joHint.__sort;
            sSearch  := joHint.__search;
            //取主键字段名，用于辅助select top,默认为id.可以Hint中写primarykey
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;
            if sSearch = '' then begin
                if sWhere = '' then begin
                    sWhere  := 'WHERE (1=1)';
                end else begin
                    sWhere  := 'WHERE ('+sWhere+')';
                end;
            end else begin
                if sWhere = '' then begin
                    sWhere  := sSearch;
                end else begin
                    sWhere  := sSearch + ' And ('+sWhere+')';
                end;
            end;
            sOrder  := 'ORDER BY ['+joFields._(iColId).fieldname+'],'+sPrimaryKey;
            joHint.__sort := '['+joFields._(iColId).fieldname+'],'+sPrimaryKey;
            Hint    := joHint;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onsortdesc' then begin
            //从v取行序号iColId
            iColId  := StrToIntDef(joData.v,0);
            //iColId超范围，则退出
            if (iColId<0)or(iColId>joFields._Count-1) then begin
                Exit;
            end;
            //iColId字段无fieldname，则退出
            if joFields._(iColId).fieldname='' then begin
                Exit;
            end;
            //取原SQL的关键要素
            _GetSQL(ACtrl,sOldSQL);
            //
            sSort    := joHint.__sort;
            sSearch  := joHint.__search;
            //取主键字段名，用于辅助select top,默认为id.可以Hint中写primarykey
            sPrimaryKey := 'id';
            if joHint.Exists('primarykey') then begin
                sPrimaryKey := joHint.primarykey;
            end;
            if sSearch = '' then begin
                if sWhere = '' then begin
                    sWhere  := 'WHERE (1=1)';
                end else begin
                    sWhere  := 'WHERE ('+sWhere+')';
                end;
            end else begin
                if sWhere = '' then begin
                    sWhere  := sSearch;
                end else begin
                    sWhere  := sSearch + ' And ('+sWhere+')';
                end;
            end;
            //生成__sort
            sOrder  := 'ORDER BY ['+joFields._(iColId).fieldname+'] DESC,'+sPrimaryKey;
            joHint.__sort := '['+joFields._(iColId).fieldname+'] DESC,'+sPrimaryKey;
            Hint    := joHint;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onpagechange' then begin
            //从v取页码 HelpContext
            HelpContext  := StrToIntDef(joData.v,1)-1;
            _UpdateQuery(ACtrl);
        end else if joData.e = 'onfullcheck' then begin
            if joData.v='true' then begin
                //全部选中
                //__selection 写入[-1]表示全部选中
                joHint.__selection  := _json('[]');
                for iItem := 1 to oDataSet.RecordCount do begin
                    joHint.__selection.Add(iItem);
                end;
                //__selection 写入Hint
                Hint    := joHint;
            end else begin
                //全部取消
                //__selection 写入[]表示全部不选中
                joHint.__selection  := _json('[]');
                Hint    := joHint;
            end;
            //执行OnEndDock事件
            if Assigned(OnEndDock) then begin
                if joData.v='true' then begin
                    //全部选中
                    OnEndDock(TListView(ACtrl),nil,3,-1);
                end else begin
                    //全部取消
                    OnEndDock(TListView(ACtrl),nil,3,0);
                end;
            end;
        end else if joData.e = 'onsinglecheck' then begin
            iRecNo  := joData.v div 100;
            joSelection := joHint.__selection;
            //清除全选标志 -1
            for iItem := joSelection._Count-1 downto 0 do begin
                if joSelection._(iItem) = -1 then begin
                    joSelection.Delete(iItem);
                    break;
                end;
            end;
            if joData.v mod 2 = 1 then begin
                //选中
                bFound  := False;
                for iItem := joSelection._Count-1 downto 0 do begin
                    if joSelection._(iItem) = iRecNo then begin
                        bFound  := True;
                        break;
                    end;
                end;
                if not bFound then begin
                    joSelection.Add(iRecNo);
                end;
            end else begin
                //取消
                for iItem := joSelection._Count-1 downto 0 do begin
                    if joSelection._(iItem) = iRecNo then begin
                        joSelection.Delete(iItem);
                        break;
                    end;
                end;
            end;
            Hint    := joHint;
            //执行OnEndDock事件
            if Assigned(OnEndDock) then begin
                OnEndDock(TListView(ACtrl),nil,3,joData.v div 100);
            end;
        end else if joData.e = 'ondeleteclick' then begin
            joSelection := joHint.__selection;
            //根据joSelection（记录号数组）分别处理
            if joSelection._Count = 0 then begin
                //未选中，则删除当前
                oDataSet.Delete;
            //全选
            end else if joSelection._(0) = -1 then begin
                while not oDataSet.Eof do begin
                    oDataSet.Delete;
                end;
            end else begin
                //部分选择
                for iItem := joSelection._Count-1 downto 0 do begin
                    oDataSet.RecNo  := joSelection._(iItem);
                    oDataSet.Delete;
                end;
            end;
            joHint.__selection  := _Json('[]');
            Hint    := joHint;
            //执行OnEndDock事件
            if Assigned(OnEndDock) then begin
                if joData.v='true' then begin
                    //全部选中
                    OnEndDock(TListView(ACtrl),nil,3,-1);
                end else begin
                    //全部取消
                    OnEndDock(TListView(ACtrl),nil,3,0);
                end;
            end;
        end;
        oDataSet.EnableControls;
    end;
end;

//function dwGetHead(ACtrl: TComponent): string; stdcall;
function dwGetHead(ACtrl: TComponent): string; stdcall;
var
    iItem       : Integer;
    iBtn        : Integer;
    iCol        : Integer;
    iMax        : Integer;
    iTotal      : Integer;      //总宽度，用于宽度补齐
    iRowH       : Integer;      //行高
    iTopH       : Integer;      //顶部工具按钮栏高度
    iPageH      : Integer;      //分页栏高度
    iTitleColW  : Integer;      //纵向显示时的列宽
    iHeaderH    : Integer;      //表头的行高
    iTitleCount : Integer;
    iRecCount   : Integer;      //记录总数
    iSumCount   : Integer;      //
    iSumCol     : Integer;      //汇总列序号
    iSum        : Integer;
    iCount      : Integer;
    iL,iT,iW,iH : Integer;
    iTop        : Integer;
    iList       : Integer;
    iPageSize   : Integer;      //分页时每页的记录数据，默认10，如为9999，则不分页
    //
    sFull       : string;
    sHover      : string;
    sRecord     : string;
    sCols       : String;
    sCode       : string;
    sHeaderBKC  : string;
    sChange     : string;   //生成激活编辑框OnChange事件的代码
    sTopBack    : string;
    sCaption    : string;

    joHint      : Variant;  //HINT
    joRes       : Variant;  //返回结果
    joFields    : Variant;  //字段数组
    joField     : Variant;  //字段
    joButton    : Variant;  //操作按钮
    joSummary   : Variant;  //汇总配置
    joSum       : variant;  //单项汇总项
const
    _ICONS  : array[1..3] of string = ('el-icon-plus','el-icon-minus','el-icon-edit');
    _TEXTS  : array[1..3] of string = ('增加','删除','编辑');
    
begin
    //默认返回值
    joRes := _Json('[]');
    //预处理，取得配置参数
    //取得HINT对象joHint,并预处理
    //取得HINT对象joHint
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    sFull       := dwFullName(Actrl);
    //取配置默认值
    iTopH       := dwGetInt(joHint,'topheight',40);
    iRowH       := dwGetInt(joHint,'rowheight',40);
    iPageH      := dwGetInt(joHint,'pageheight',40);
    iPageSize   := dwGetInt(joHint,'pagesize',10);
    //
    sTopBack    := dwGetStr(joHint,'topbackground','transparent');
    sHover      := dwGetStr(joHint,'hover','rgb(245,247,250)');
    sRecord     := dwGetStr(joHint,'record','rgb(224,243,255)');
    //如果不分页，则设置分页高度为0
    if (not _GetModule(joHint,5)) OR ( iPageSize = 9999 ) then begin
        iPageH := 0;
    end;
    //取得各计算值
    iTitleCount := _GetTitleCount(joHint);
    iSumCount   := _GetSumCount(joHint);
    joFields    := _GetFields(TListView(ACtrl));
    //核心模块 =====================
    with TListView(ACtrl) do begin
        //总外框 dg （首部）
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    //+'border: 1px solid #dcdfe6;'
                    +dwGetDWStyle(joHint)
                    //字体
                    +'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +'font-family:'+Font.Name+';'
                    +'font-weight:'+_GetFontWeight(Font)+';'
                    +'font-style:'+_GetFontStyle(Font)+';'
                    +'text-decoration:'+_GetTextDecoration(Font)+';'
                    +'background-color:'+dwColor(Color)+';'
                    //+'overflow:hidden;'
                +'"' //style 封闭
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);
        //顶部框 dg__top （增删改查。。。）
        if _GetModule(joHint,0) then begin
            //首部
            sCode   := '<div'
                    +' id="'+sFull+'__top"'
                    +' :style="{'
                        +'background:'+sFull+'__tpb,'
                        +'height:'+sFull+'__tph'
                    +'}"'
                    +' style="position:absolute;'
                        +'left:0px;'
                        +'top:0px;'
                        +'width:100%;'
                        +joHint.topstyle
                    +'"'
                    +'>';
            joRes.Add(sCode);
            //查询框
            if _GetModule(joHint,4) then begin
                sCode   := concat(
                        '<el-input',
                            ' v-model="'+sFull+'__key"',     //keyword
                            ' suffix-icon="el-icon-search"',
                            ' placeholder="search"',
                            ' style="',
                                'position:absolute;',
                                'top:17%;',
                                'bottom:17%;',
                                'height:66%;',
                                'left:3px;',
                                'width:200px;',
                                //'border: solid 1px #ececec;',
                                'border-radius: 3px;',
                                'background:rgb(242,242,242);',
                            '"',
                            ' @input="'+sFull+'__query($event,'+sFull+'__key)"',
                        '></el-input>');
                joRes.Add(sCode);
            end;
            //增删改（按钮）
            for iBtn :=3 downto 1 do begin
                if _GetModule(joHint,iBtn) then begin
                    sCode   := concat(
                            '<el-button',
                                ' id="'+sFull+'__bt'+IntToStr(iBtn)+'"',
                                ' icon="'+_ICONS[iBtn]+'"',
                                ' type="primary"',
                                ' style="',
                                    'position:relative;',
                                    'float: right;',
                                    'top: calc(50% - 15px);',
                                    'height:28px;',
                                    'border-radius: 3px;',
                                    'margin-right:3px;',
                                    'width:70px;',
                                '"',
                                ' @click="'+sFull+'__buttonclick($event,'+IntToStr(iBtn)+')"',
                            '>',
                            _TEXTS[iBtn],
                            '</el-button>');
                    joRes.Add(sCode);
                end;
            end;
            //尾部
            joRes.Add('</div>');
        end;
        //数据框 dg__dat（含表头和汇总）
        //首部 dg__dat
        sCode   := '<div'
                +' id="'+sFull+'__dat"'
                +' :style="{'
                    +'top:'+sFull+'__dtt,'
                    +'height:'+sFull+'__dth'
                +'}"'
                +' style="position:absolute;'
        			+dwIIF(BorderStyle=bsSingle,'border:solid 1px #ebeef5;','border-top:solid 1px #ebeef5;border-bottom:solid 1px #ebeef5;')
                    //+'border: 1px solid #dcdfe6;'
                    +'overflow:hidden;'
                    +'left:0px;'
                    +'width: calc(100% - 2px);'
                    +joHint.datastyle
                +'"'
                +'>';
        joRes.Add(sCode);
        //表头 dg__tit
        sCode   := _GetTitleHtml(TListView(ACtrl),joHint,joFields);
        joRes.Add(sCode);
        //数显 dg__dav : data view
        joRes.Add('<div'
                +' id="'+sFull+'__dav"' //dav: data view
                +' class="dwscroll_bottom"'
                //+' v-show="'+sFull+'__dvv"'     //dvv: data view visible
                +' :style="{'
                   +'top:'+sFull+'__dvt,'       //aph : Append Height
                   +'height:'+sFull+'__dvh'       //aph : Append Height
                +'}"'
                +' style="'
                       +'position:absolute;'
                       +'overflow:auto;'
                       //+'background-color:#fcf;'
                       //+'z-index:9;'
                       +'left:0;'
                       +'top:0;'
                       +'width: calc(100% - 0px);'
                       //+'height:200px;'
                +'"' //style 封闭
                +' @scroll="'+sFull+'__scroll($event)" '
                +' @mouseover=''function(e){'
                    +'var iRecNo=parseInt((Math.abs(e.offsetY)+e.target.offsetTop)/'+IntToStr(iRowH)+');'//转化为记录No,从0开始
                    +'if (iRecNo<'+IntToStr(iPageSize)+'){'                           //避免超记录
                         //+'this.console.log(iRecNo);'
                         //+'this.console.log(e);'
                         +sFull+'__hov=parseInt(iRecNo*'+IntToStr(iRowH)+')+"px";'   //更新记录指示框位置
                    +'}else{'
                        +sFull+'__hov="-500px";'   //更新记录指示框位置
                    +'};'      
                +'}'''
                +' @mouseleave=''function(e){'
                    //+'this.console.log(e);'
                    +sFull+'__hov="-500px";'   //更新记录指示框位置
                +'}'''
                +' @click=''function(e){'
                    //+'this.alert("pause");'
                    //+'this.console.log(e);'
                    +'var iRecNo=parseInt((e.offsetY+e.target.offsetTop)/'+IntToStr(iRowH)+');'//转化为记录No,从0开始
                    //+'this.console.log(iRecNo);'
                    //+'this.console.log('+sFull+'__rcc);'
                    +'if (iRecNo<'+IntToStr(iPageSize)+'){'                           //避免超记录
                         +sFull+'__rnt=parseInt(iRecNo*'+IntToStr(iRowH)+')+"px";'   //更新记录指示框位置
                         +'dwevent("","'+sFull+'",(iRecNo+1)*100+99,"onclick",'+IntToStr(TForm(Owner).Handle)+');'
                    +'};'      
                +'}'''
                + ' @dblclick='''
                   //+'this.console.log(''dblclick'');'
                   +'dwevent("","'+sFull+'","0","ondblclick",'+IntToStr(TForm(Owner).Handle)+');'
               +''''
                +'>');
        //Hove栏 dg__hov
        joRes.Add('        <div'
               + ' id="'+sFull+'__hov"'
               + ' :style="{'
                   +'width:'+sFull+'__how,'
                   +'top:'+sFull+'__hov'
               +'}"'
               + ' style="'
                   +'position:absolute;'
                   +'background:'+sHover+';'
                   //+'z-index:-2;'
                   +'left:0;'
                   //+'width:100%;'
                   +'height:'+IntToStr(iRowH)+'px;'
               +'"' //style 封闭
               + '></div>');
        //记录栏 dg__row
        joRes.Add('        <div'
                + ' id="'+sFull+'__row"'
                + ' :style="{'
                    +'width:'+sFull+'__how,'
                    +'top:'+sFull+'__rnt'
                +'}"'
                + ' style="'
                    +'position:absolute;'
                    +'background:'+sRecord+';'
                    //+'z-index:-1;'
                    +'left:0;'
                    //+'width:100%;'
                    +'height:'+IntToStr(iRowH)+'px;'
                +'"' //style 封闭
                + '></div>');
        //添加各字段数据
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            //根据type分别处理
            if joField.type = 'check' then begin
                //Check字段
                sCode   := '<el-checkbox class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+sFull+'__cd'+IntToStr(iCol)+'"'  //cd:ColumnData
                		+' :row="item.r"'
                		+' :key="index"'
                		+' v-model="item.c"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;"'
                		+' @change=''function(val){'
                		     +'dwevent("","'+sFull+'",Number(item.r)*100+Number(val),"onsinglecheck",'+IntToStr(TForm(Owner).Handle)+');'
                		+'}'''
                		+'></el-checkbox>';
            //image字段
            end else if joField.type = 'image' then begin
                sCode   := '<div class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                		+' :row="item.r"'
                		//+' :key="index"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;text-align:center;'
                		+'"'
                		//+' @mouseenter=''DBGrid1__hov=item.t'''
                		//+' @mouseleave=''DBGrid1__hov="-500px"'''
                		//+' @click=''DBGrid1__rnt=item.t;'
                		//        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                		+' >';
                		//添加image
                		sCode   := sCode + '<img :src="item.c" style="vertical-align:middle;' + dwGetDWStyle(joField)+ '"></img>';
                		//
                		sCode   := sCode+'</div>';
            //progress字段
            end else if joField.type = 'progress' then begin
                sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		+' :row="item.r"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;text-align:center;'
                		+'"'
                		+' >';
                //添加
                sCode   := sCode + '<el-progress'
                		+' :text-inside="true"'
                		+' color="#ccc"'    //此处为进度条的前景色，需要的修改这里
                		+' style="'
                			+'top:8px;'
                            +'height: calc(100% - 10px);'
                		+'"'
                		+' :stroke-width="'+IntToStr(dwGetInt(joHint,'rowheight',40)-16)+'"'
                		//+' :percentage="item.c"'
                		+' :percentage="item.c > 100 ? 100 : item.c"'
                		+' :format="'+sFull+'__format(item.c)"'
                		+'>'
                		+'</el-progress>';
                //
                sCode   := sCode+'</div>';
            //button字段
            end else if joField.type = 'button' then begin
                sCode   := '        <div class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                		+' :row="item.r"'
                		//+' :key="index"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align}"'
                		+' style="position:absolute;text-align:center;'
                		+'"'
                		+' >';
                if joField.Exists('list') then begin
                    for iItem := 0 to joField.list._Count -1 do begin
                        joButton    := joField.list._(iItem);
                        sCode   := sCode + '<el-button'
                        		+' type="'+joButton._(1)+'"'
                        		+' style="vertical-align:middle;margin:2px;"'
                        		+' @click=''function(e){'
                        				+'dwevent("","'+sFull+'",item.r*10000+'+IntToStr(iCol*100+iItem)+',"onbuttonclick",'+IntToStr(TForm(Owner).Handle)+');'
                        				+'e.stopPropagation();'//阻止冒泡
                        		+'}'''
                        		+'>'+joButton._(0)+'</el-button>';
                    end;
                end;
                sCode   := sCode+'</div>';
            end else begin
                //普通字段
                sCode   := '<div'
                		+' class="'+sFull+'dwdbgrid0"'
                		+' v-for="(item,index) in '+lowerCase(sFull)+'__cd'+IntToStr(iCol)+'"' //cd:ColumnData
                		//+' :class="{''dwdbgrid1'':index%2 === 1}"'
                		+' :row="item.r"'
                		+' tabIndex=0'
                		//+' :key="index"'
                		+' :style="{top:item.t,left:item.l,width:item.w,''text-align'':item.align,color:item.color,''background-color'':item.bkcolor}"'
                		+' style="position:absolute;"'
                		//+' @mouseenter=''DBGrid1__hov=item.t'''
                		//+' @mouseleave=''DBGrid1__hov="-500px"'''
                		//+' @click=''DBGrid1__rnt=item.t;'
                		//        +'dwevent("","'+sFull+'",item.r*100+'+IntToStr(iCol)+',"onclick",'+IntToStr(TForm(Owner).Handle)+');'''
                		+' >{{item.c}}</div>';
            end;
            joRes.Add(sCode);
        end;
        //纯数据框尾部 dg_dav
        joRes.Add('</div>');
        //汇总 dg__sum
        if joHint.summary._count>0 then begin
            //首部 <div>
            joRes.Add('<div'
                    +' id="'+sFull+'__sum"'
                    +' :style="{'
                        +'width: '+sFull+'__fuw,'  
                        +'left:'+sFull+'__ttl,'       
                        +'height:'+sFull+'__smh'       //smh : summary Height
                    +'}"'
                    +' style="'
                        +'position:absolute;'
                        +'overflow:hidden;'
                        //+'border: 1px solid #dcdfe6;'
                        +'background: linear-gradient(#f4f5f8,#f1f3f6);'
                        +'left:0;'
                        +'bottom:0;'
                    +'"' //style 封闭
                    +'>');
            joSummary     := joHint.summary;
            //标题 显示“汇总”标题
            joRes.Add('        <div'
                    + ' style="'
                            +'position:absolute;'
                            +'overflow:hidden;'
                            +'left:10px;'
                            +'top:0;'
                            +'width:200px;'
                            +'font-size:'+IntToStr(Font.Size+3)+'px;color:'+dwColor(Font.Color)+';'
                            +'height:'+IntToStr(iSumCount*iRowH)+'px;'
                            +'line-height:'+IntToStr(iSumCount*iRowH)+'px;'
                    +'"' //style 封闭
                    + '>'
                    +joSummary._(0)
                    +'</div>');
            //内容 iItem := 1 to joSummary._Count -1
            for iItem := 1 to joSummary._Count -1 do begin
                joSum   := joSummary._(iItem);
                iSumCol := joSum._(0);
                //iSumCol 超出范围，则跳过
                if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                    continue;
                end;
                iL  := joFields._(iSumCol).left;
                //计算当前的Top
                iT  := -2;
                for iCol := 1 to iItem -1 do begin
                    if joSummary._(iCol)._(0) = iSumCol then begin
                        iT  := iT + iRowH;
                    end;
                end;
                iW  := joFields._(iSumCol).width-1;
                iH  := iRowH-1;
                //显示“汇总”数值
                joRes.Add('        <div'
                        +' :style="{'
                            +'left:'+sFull+'__fl'+IntToStr(iSumCol)+','   //sum left
                            //+'top:'+sFull+'__st'+IntToStr(iItem)+','    //sum top
                            +'width:'+sFull+'__fw'+IntToStr(iSumCol)      //sum width
                        +'}"'
                        + ' style="'
                                +'position:absolute;'
                                +'overflow:hidden;'
                                //+'left:'+IntToStr(iL)+'px;'
                                +'top:'+IntToStr(iT)+'px;'
                                //+'width:'+IntToStr(iW)+'px;'
                                +'height:'+IntToStr(iH)+'px;'
                                +'line-height:'+IntToStr(iH)+'px;'
                                +'border:solid 1px #ececec;'
                                +'text-align:center;'
                                +'font-size:'+IntToStr(Font.Size+3)+'px;color:'+dwColor(Font.Color)+';'
                        +'"' //style 封闭
                        + '>'
                        +'{{'+sFull+'__sm'+IntToStr(iItem-1)+'}}'
                        +'</div>');
                //为当前列显示一个通天地的框，以美观
                joRes.Add('        <div'
                        +' :style="{'
                            +'left:'+sFull+'__fl'+IntToStr(iSumCol)+','   //sum left
                            +'width:'+sFull+'__fw'+IntToStr(iSumCol)      //sum width
                        +'}"'
                        + ' style="'
                                +'position:absolute;'
                                //+'left:'+IntToStr(iL)+'px;'
                                +'top:-2px;'
                                //+'width:'+IntToStr(iW)+'px;'
                                +'height:100%;'
                                +'border:solid 1px #ececec;'
                        +'"' //style 封闭
                        + '>'
                        +'</div>');
            end;
            //尾部 </div>
            joRes.Add('</div>');
        end;
        //尾部 dg__dat
        joRes.Add('</div>');
        //分页框 dg__pag
        if _GetModule(joHint,5) and (iPageSize<>9999) then begin
            //首部
            sCode   := concat(
                    '<el-pagination',
                    ' background',
                    ' :pager-count="5"',
                    ' :page-size="'+IntToStr(iPageSize)+'"',
                    ' layout="prev, pager, next, jumper, ->, total"',
                    ' :total="'+sFull+'__drc"',
                    ' style="',
                         'position:absolute;',
                         //'height:'+IntToStr(iRowH)+'px;',
                         //'bottom:'+IntToStr(30-iRowH)+'px;',
                         'height:30px;',
                         'width:100%;',
                         'bottom:0px;',
                         'color:'+dwColor(Font.Color)+';',
                    '"',
                    '@current-change="'+sFull+'__pagechange"',
                    '>');
            joRes.Add(sCode);
            //尾部
            joRes.Add('</el-pagination>');
        end;
        //删除框 dg__cfm : confirm form mask 删除确认框
        //遮罩层 dg__cfm 首部 confirm mask
        sCode   := Concat('<div id="'+sFull+'__cfm"',   //cfm:confirm mask
        		' v-show="'+sFull+'__cfv"',         //confirm visible
        		' style="',
        			'position:fixed;',
        			'left:0;',
        			'top:0;',
        			'right:0;',
        			'bottom:0;',
        			'background: rgba(0,0,0,0.5);',
        			'z-index:9;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //窗体层 dg__cff 首部 confirm form
        sCode   := Concat('<div id="'+sFull+'__cff"',   //cff:confirm form
        		' style="',
        			'position:absolute;',
        			'left: calc(50% - 160px);',
        			'top:200px;',
        			'width:320px;',
        			'height:130px;',
        			'border-radius:15px;',
        			'background-color:#fff;',
        			'opacity: 1;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //标题层 dg__cft 全部 confirm title
        sCode   := Concat('<div id="'+sFull+'__cft"',   
        		' style="',
        			'position:absolute;',
        			'top:0px;',
        			'width:100%;',
        			'height:80px;',
        			'line-height:80px;',
        			'text-align:center;',
        			'border-bottom:solid 1px #ccc;',
        		'"',
        		'>',
        		'确认删除？',
        		'</div>');
        joRes.Add(sCode);
        //取消钮 dg__cfc 全部 confirm cancel
        sCode   := Concat('<div id="'+sFull+'__cfc"',   //confirm cancel
        		' style="',
        			'position:absolute;',
        			'left:0px;',
        			'bottom:0px;',
        			'width:50%;',
        			'height:50px;',
        			'line-height:50px;',
        			'text-align:center;',
        			'border-right:solid 1px #ccc;',
        		'"',
        		' @click="function(event){',
        			''+sFull+'__cfv=false;',
        		'}" ',
        		'>',
        		'取消',
        		'</div>');
        joRes.Add(sCode);
        //删除钮 dg__cfd 全部 confirm delete
        sCode   := Concat('<div id="'+sFull+'__cfd"',   //confirm delete
        		' style="',
        			'position:absolute;',
        			'right:0;',
        			'bottom:0px;',
        			'width:50%;',
        			'height:50px;',
        			'line-height:50px;',
        			'text-align:center;',
        			'color:red;',
        		'"',
                ' @click="'+sFull+'__deleteconfirm($event)"',
        		'>',
        		'删除',
        		'</div>');
        joRes.Add(sCode);
        //窗体层 dg__cff 尾部
        joRes.Add('</div>');
        //遮罩层 dg__cfm 尾部
        joRes.Add('</div>');
        //编辑框 dg__edm
        //遮罩层 dg__edm 首部 edit mask
        sCode   := Concat('<div id="'+sFull+'__edm"',   //edit/append mask
        		' v-show="'+sFull+'__edv"',         //confirm visible
        		' style="',
        			'position:fixed;',
        			'left:0;',
        			'top:0;',
        			'right:0;',
        			'bottom:0;',
        			'background: rgba(0,0,0,0.5);',
        			'z-index:9;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //窗体层 dg__edf 首部 edit form
        sCode   := Concat('<div id="'+sFull+'__edf"',   //cff:confirm form
                //动态值
                ' :style="{',
                    'height:'+sFull+'__efh',       //edit form height
                '}"',
        		' style="',
        			'position:absolute;',
        			'left: calc(50% - 160px);',
        			'top:25px;',
        			'width:320px;',
        			'max-height:calc(100% - 50px);',
        			'border-radius:15px;',
        			'background-color:#fff;',
        			'opacity: 1;',
        		'"',
        		'>');
        joRes.Add(sCode);
        //标题栏 dg__edt 全部 edit title
        sCode   := Concat('<div id="'+sFull+'__edt"',   //edit/append title
                ' style="',
                    'position:absolute;',
                    'top:0px;',
                    'width:100%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-bottom:solid 1px #ccc;',
                '"',
                '>',
                'Data',
                '</div>');
        joRes.Add(sCode);
        //滚动框 首部
        sCode   := concat('<el-scrollbar',
                ' ref="'+sFull+'__dts"',    //data scroll
                //动态值
                //' :style="{',
                //    'height:'+sFull+'__dsh',       //data scroll height
                //'}"',
                ' style="',
                    'position:absolute;',
                    'top:50px;',
                    'width:100%;',
                    'bottom:50px;',
                    'height: calc(100% - 100px);',
                '"',
                '>');
        joRes.Add(sCode);
        //内容框 首部
        sCode   := concat('<el-main',
                ' id="'+sFull+'__dtc"',     //data content
                //动态值
                ' :style="{',
                    'height:'+sFull+'__dch',       //data content height
                '}"',
                //静态值
                ' style="',
                    'position:relative;',
                    'color:'+dwColor(Font.Color)+';',
                    'left:0;',
                    'top:0;',
                    'width:100%;', 
                    'overflow:hidden;',
                '"',
                '>');
        joRes.Add(sCode);
        //编辑框 多个
        iTop    := 25;
        //添加各字段数据
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.fieldname = '' then begin
                continue;
            end;
            if joField.type = 'autoinc' then begin
                continue;
            end;
            if joField.readonly = 1 then begin
                continue;
            end;
            //字段 caption
            sCaption    := joField.caption;
            sCaption    := StringReplace(sCaption,'<br>','',[rfReplaceAll]); 
            sCaption    := StringReplace(sCaption,'<br/>','',[rfReplaceAll]); 
            sCode   := Concat('<div',
                    ' style="',
                        'position:absolute;',
                        'top:'+IntToStr(iTop)+'px;',
                        'left:25px;',
                        'right:25px;',
                        'height:20px;',
                        'line-height:20px;',
                        'background:transparent;',
                        'padding-left:5px;',
                    '"',
                    '>',
                    sCaption,
                    '</div>');
            joRes.Add(sCode);
            //根据type分别处理 字段编辑框
            if joField.type = 'boolean' then begin
                //boolean 字段
                //外框 首部（无边框，仅用于界定范围）
                sCode   := Concat('<div',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:27px;',
                            'width: calc(100% - 50px);',
                            'padding:0 0 0 5px;',
                            'margin-top:5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                //选项 list
                sCode   := concat('<el-radio',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' label="True">',
                        joField.list._(0),
                        '</el-radio>');
                joRes.Add(sCode);
                
                sCode   := concat('<el-radio',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' label="False">',
                        joField.list._(1),
                        '</el-radio>');
                joRes.Add(sCode);
                //外框 尾部
                joRes.Add('</div>');
            //combo   字段
            end else if joField.type = 'combo' then begin
                //外框 首部（无边框，仅用于界定范围）
                sCode   := Concat('<div',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:27px;',
                            'width: calc(100% - 50px);',
                            'padding:0 0 0 5px;',
                            'margin-top:5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                //选项 添加select
                sCode   := concat('<select',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' style="',
                            'appearance:none;',
                            '-moz-appearance:none;',
                            '-webkit-appearance:none;',
                            'background:url(''media/images/dwarrow.png'') no-repeat scroll right center transparent;',
                            'padding:0 14px 0 5px;',
                            'position:absolute;',
                            'top:0px;',
                            'left:0px;',
                            'height:100%;',
                            'width:100%;',
                            'outline:none;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                        '"',
                        //' @change="'+sFull+'__change'+IntToStr(iCol)+'($event)"',
                        '>');
                joRes.Add(sCode);
                for iList := 0 to joField.list._count-1 do begin
                    sCode   := '<option value="'+joField.list._(iList)+'">'+joField.list._(iList)+'</option>';
                    joRes.Add(sCode);
                end;
                joRes.Add('</select>');
                //添加input
                sCode   := concat('<input',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        //' type="text"',
                        //' name="format"',
                        //' value=""',
                        ' style="',
                            'position:absolute;',
                            'top:1px;',
                            'color:inherit;',
                            'left:6px;',
                            'right:20px;',
                            'bottom:1px;',
                            'border:0;',
                            'outline:none;',
                        '"',
                        ' />');
                joRes.Add(sCode);
                //外框 尾部
                joRes.Add('</div>');
            //date    字段
            end else if joField.type = 'date' then begin
                sCode   := Concat('<el-date-picker',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' value-format="yyyy-MM-dd"',
                        ' type="date"',
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'width: calc(100% - 50px);',
                            'height:32px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                
                
                //尾部封闭
                joRes.Add('</el-date-picker>');
            //integer 字段
            end else if joField.type = 'integer' then begin
                sCode   := Concat('<el-input-number',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' type="date"',
                        dwIIF(joField.Exists('minvalue'),' :min="'+sFull+'__min'+IntToStr(iCol)+'"',''),
                        dwIIF(joField.Exists('maxvalue'),' :max="'+sFull+'__max'+IntToStr(iCol)+'"',''),
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'height:34px;',
                            'border:solid 1px #ccc;',
                            'border-radius:3px;',
                            'width: calc(100% - 50px);',
                            'padding:0 0 0 5px;',
                        '"',
                        '>');
                joRes.Add(sCode);
                
                
                //尾部封闭
                joRes.Add('</el-input-number>');
            end else begin
                //普通    字段
                sCode   := Concat('<input',
                        ' v-model="'+sFull+'__di'+IntToStr(iCol)+'"',     //data input
                        ' style="',
                            'position:absolute;',
                            'top:'+IntToStr(iTop+20+3)+'px;',
                            'left:25px;',
                            'width: calc(100% - 50px);',
                            'right:25px;',
                            'height:32px;',
                            'line-height:32px;',
                            'border-radius:4px;',
                            'outline-style: none;',
                            'border: 1px solid #ccc;',
                            'color:#808080;',
                            'padding:0px 0px 0px 5px;',
                        '"',
                        '>',
                        '</input>');
                joRes.Add(sCode);
            end;
            iTop    := iTop + 70;
        end;
        //内容框 尾部
        joRes.Add('</el-main>');
        //滚动框 尾部
        joRes.Add('</el-scrollbar>');
        //按钮组 取消/保存
        //编辑窗体的“取消”按钮
        sCode   := Concat('<div id="'+sFull+'__edc"',   //edit/append cancel
                ' style="',
                    'position:absolute;',
                    'left:0px;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-right:solid 1px #ccc;',
                    'border-top:solid 1px #ccc;',
                '"',
                ' @click="'+sFull+'__editcancel($event)"',
                '>',
                '取消',
                '</div>');
        joRes.Add(sCode);
        
        //编辑窗体的“保存“按钮
        sCode   := Concat('<div id="'+sFull+'__eds"',   //edit/append save
                ' style="',
                    'position:absolute;',
                    'right:0;',
                    'bottom:0px;',
                    'width:50%;',
                    'height:50px;',
                    'line-height:50px;',
                    'text-align:center;',
                    'border-top:solid 1px #ccc;',
                    'color:red;',
                '"',
                ' @click="'+sFull+'__editsave($event)"',
                '>',
                '保存',
                '</div>');
        joRes.Add(sCode);
        //窗体层 dg__edf 尾部
        joRes.Add('</div>');
        //遮罩层 dg__edm 尾部
        joRes.Add('</div>');
        //总外框 dg （尾部）
        joRes.Add('</div>');
    end;
    Result := joRes;
end;

//function dwGetTail(ACtrl: TComponent): string; stdcall;
function dwGetTail(ACtrl: TComponent): string; stdcall;
var
    joRes: Variant;
begin
    joRes := _Json('[]');
    
    Result := (joRes);
end;

//function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
var
    iRow, iCol  : Integer;
    iItem       : Integer;
    iSum        : Integer;
    iSumW       : Integer;      //所有字段的宽度之和，用于更新倒1/2字段viewwidth                           
    iSumCol     : Integer;
    iSumCount   : Integer;      //
    iTitleCount : Integer;
    iCount      : Integer;
    iTotal      : Integer;
    iMax        : Integer;
    iRecCount   : Integer;
    iHeadH      : Integer;
    iRowH       : Integer;
    iL,iT,iW,iH : Integer;
    iLevel      : Integer;
    iStart      : Integer;
    iEnd        : Integer;
    iTopH       : Integer;
    iPageH      : Integer;
    iDch        : Integer;
    //
    sCode       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sFull       : string;
    sMiddle     : string;
    sTail       : string;
    sTopBack    : string;
    //解析SQL
    sField      : string;
    sOldSQL     : string;
    sTable      : string;
    sWhere      : String;
    sGroup      : string;
    sOrder      : string;
    sSQL        : string; //SQL
    iPageSize   : Integer;
    //
    fValues     : array of Double;
    //
    joHint      : Variant;
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joColDatas  : array of Variant;
    joValue     : Variant;
    joSummary   : variant;
    joSum       : variant;
    joSItem     : variant;
    joItem      : variant;
    joItems     : variant;
    joMerge     : Variant;
    //
    oDataSet    : TDataSet;
    oBookMark   : TBookMark;
    oAfter      : Procedure(DataSet: TDataSet) of Object;
    oBefore     : Procedure(DataSet: TDataSet) of Object;
begin
    //默认返回值
    joRes := _Json('[]');
    
    //预处理，取得配置参数
    //取得HINT对象joHint,并预处理
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    //取配置默认值
    iTopH       := dwGetInt(joHint,'topheight',50);
    iPageH      := dwGetInt(joHint,'pageheight',40);
    iHeadH      := dwGetInt(joHint,'headerheight',40);
    iRowH       := dwGetInt(joHint,'rowheight',40);
    iPageSize   := dwGetInt(joHint,'pagesize',10);
    sTopBack    := dwGetStr(joHint,'topbackground','transparent');
    //是否显示分页栏
    if not _GetModule(joHint,5) then begin
        iPageH  := 0;
    end;
    //取得各计算值
    iTitleCount := _GetTitleCount(joHint);
    iSumCount   := _GetSumCount(joHint);
    joFields    := _GetFields(TListView(ACtrl));
    joSummary   := joHint.summary;
    //区分是否GetData，以确定使用 ;/,
    if LowerCase(AMode) = 'data' then begin
        sFull   := dwFullName(Actrl);
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sFull   := 'this.'+dwFullName(Actrl);
        sMiddle := '=';
        sTail   := ';';
    end;
    //with TListView(ACtrl) ======================
    with TListView(ACtrl) do begin
        //基本LTWH/VD/recordcount
        joRes.Add(sFull + '__lef'+sMiddle+'"' + IntToStr(Left) + 'px"'+sTail);
        joRes.Add(sFull + '__top'+sMiddle+'"' + IntToStr(Top) + 'px"'+sTail);
        joRes.Add(sFull + '__wid'+sMiddle+'"' + IntToStr(Width-2) + 'px"'+sTail); //-2是因为border增加了
        joRes.Add(sFull + '__hei'+sMiddle+'"' + IntToStr(Height-2) + 'px"'+sTail);
        
        //visible/enabled
        joRes.Add(sFull + '__vis'+sMiddle+'' + dwIIF(Visible, 'true', 'false')+sTail);
        joRes.Add(sFull + '__dis'+sMiddle+'' + dwIIF(Enabled, 'false', 'true')+sTail);
        
        //顶框 dg__top
        joRes.Add(sFull + '__tph'+sMiddle+'"' + IntToStr(iTopH) + 'px"'+sTail);
        joRes.Add(sFull + '__tpb'+sMiddle+'"' + sTopBack + '"'+sTail);
        //数据 dg__dat
        joRes.Add(sFull + '__dtt'+sMiddle+'"' + IntToStr(iTopH) + 'px"'+sTail);
        joRes.Add(sFull + '__dth'+sMiddle+'"' + IntToStr(Height - iTopH - iPageH) + 'px"'+sTail);
        //数显 dg__dav : __dvt/__dvh
        joRes.Add(sFull + '__dvt'+sMiddle+'"' + IntToStr(iTitleCount *iHeadH ) + 'px"'+sTail);
        joRes.Add(sFull + '__dvh'+sMiddle+'"' + IntToStr(Height - iTopH - iTitleCount *iHeadH - iSumCount * iHeadH - iPageH) + 'px"'+sTail);
        //汇总 dg__sum : __smh
        joRes.Add(sFull + '__smh'+sMiddle+'"' + IntToStr(iSumCount *iHeadH-1) + 'px"'+sTail);
        //取得数据集，备用 oDataSet
        oDataSet    := nil;
        if ( joHint.dataset<> '' ) then begin
            oDataSet    := TDataSet(Owner.FindComponent(joHint.dataset));
        end;
        //重新生成分页数据
        iRecCount   := _UpdateQuery(ACtrl);
        joRes.Add(sFull + '__drc'+sMiddle+'' + IntToStr(iRecCount) + ''+sTail);
        if oDataSet <> nil then begin
            //记录 __rnt
            joRes.Add(sFull + '__rnt'+sMiddle+'"'+IntToStr((oDataSet.RecNo-1)*iRowH)+'px"'+sTail);      //默认
        end else begin
            //记录 __rnt
            joRes.Add(sFull + '__rnt'+sMiddle+'"'+IntToStr(0*iRowH)+'px"'+sTail);      //默认
        end;
        //更新字段的viewwidth, 主要是倒数第1/2字段
        iSumW   := 0;
        //计算所有字段总width之和 : iSumW
        for iCol := 0 to joFields._Count-1 do begin
            iSumW   := iSumW + joFields._(iCol).width;
        end;
        //如果Grid宽度 > 各列宽度之和,则扩展倒1或2列
        if Width > iSumW then begin
            if joFields._(joFields._Count-1).type = 'button' then begin
                //扩展倒数第2列宽度
                joFields._(joFields._Count-2).viewwidth := joFields._(joFields._Count-2).width + Width - iSumW - 1;
            end else begin
                //扩展倒数第1列宽度
                joFields._(joFields._Count-1).viewwidth := joFields._(joFields._Count-1).width + Width - iSumW - 1;
            end;
        end;
        //更新字段的left, 主要是倒数第1/2字段viewwidth可能有更新
        iSumW   := -1;
        //更新各字段left
        for iCol := 0 to joFields._Count-1 do begin
            joFields._(iCol).left   := iSumW;
            iSumW   := iSumW + joFields._(iCol).viewwidth;
        end;
        //生成各汇总字段的总宽度iSumW -> dg__fuw ,dg__how
        joRes.Add(sFull + '__fuw'+sMiddle+'"'+IntToStr(iSumW)+'px"'+sTail);
        joRes.Add(sFull + '__how'+sMiddle+'"'+IntToStr(iSumW-8)+'px"'+sTail);
        //生成各列的left/width: __fl/__fw
        for iCol := 0 to joFields._Count-1 do begin
            if iCol < joFields._Count-1 then begin
                joField := joFields._(iCol);
                
                //fl:field left
                joRes.Add(sFull + '__fl'+IntToStr(iCol)+''+sMiddle+'"'+IntToStr(joField.left) + 'px"'+sTail);
                
                //fw:field width
                joRes.Add(sFull + '__fw'+IntToStr(iCol)+''+sMiddle+'"'+IntToStr(joField.viewwidth-1) + 'px"'+sTail);
            end else begin
                joField := joFields._(iCol);
                
                //fl:field left
                joRes.Add(sFull + '__fl'+IntToStr(iCol)+''+sMiddle+'"'+IntToStr(joField.left) + 'px"'+sTail);
                
                //fw:field width
                joRes.Add(sFull + '__fw'+IntToStr(iCol)+''+sMiddle+' "'+IntToStr(iSumW-joField.left) + 'px"'+sTail);
            end;
        end;
        //生成各merge的left/width : __ml/__mw
        for iItem := 0 to joHint.merge._Count-1 do begin
            joMerge := joHint.merge._(iItem);
            iL  := joFields._(joMerge._(1)).left;
            iW  := 0;
            for iCol := joMerge._(1) to joMerge._(2) do begin
                iW  := iW + joFields._(iCol).viewwidth;
            end;
            joRes.Add(sFull + '__ml'+IntToStr(iItem)+''+sMiddle+'"'+IntToStr(iL) + 'px"'+sTail);
            joRes.Add(sFull + '__mw'+IntToStr(iItem)+''+sMiddle+'"'+IntToStr(iW-1) + 'px"'+sTail);
        end;
        if oDataSet <> nil then begin
            //生成数据
            //根据分页信息等更新SQL，并重新打开数据
            if _GetModule(joHint,5) and ( iPageSize <> 9999 ) then begin
                //取原SQL的关键要素
                _GetSQL(ACtrl,sOldSQL);
                if HelpContext = 0 then begin
                    sSQL    := 'SELECT TOP '+IntToStr(iPageSize)+' '+ sField+' FROM '+sTable+' WHERE '+sWhere+' ORDER BY'+sOrder;
                end;
            end;
            //保存当前记录位置，屏蔽原事件
            oBookMark := oDataSet.GetBookmark;
            
            oDataSet.DisableControls;
            
            //保存原事件函数
            oAfter  := oDataSet.AfterScroll;
            oBefore := oDataSet.BeforeScroll;
            //清空事件
            oDataSet.AfterScroll    := nil;
            oDataSet.BeforeScroll   := nil;
            SetLength(joColDatas,Integer(joFields._Count));
            //给joColDatas赋空的初值
            for iCol := 0 to joFields._Count-1 do begin
                joColDatas[iCol]    := _json('[]');
            end;
            if joSummary._count > 1 then begin
                SetLength(fValues,Integer(joSummary._Count)-1);
            end else begin
                SetLength(fValues,0);
            end;
            oDataSet.First;
            iRow := 0;
            while not oDataSet.Eof do begin
                for iCol := 0 to joFields._Count-1 do begin
                    joField := joFields._(iCol);
                    joValue         := _json('{}');
                    joValue.l       := IntToStr(joField.left)+'px';
                    joValue.h       := IntToStr(iRowH)+'px';        //暂时没用
                    joValue.t       := IntToStr(oDataSet.RecNo * iRowH - iRowH)+'px';
                    joValue.w       := IntToStr(joField.viewwidth-10-1)+'px';  //-10是因为padding:5px
                    joValue.align   := joField.align;
                    joValue.color   := joField.color;
                    joValue.bkcolor := joField.bkcolor;
                    joValue.r       := oDataSet.RecNo;
                    //更新最后一列的宽度，避免无故出现横向滚动条
                    if iCol = joFields._Count-1 then begin
                        joValue.w       := IntToStr(joField.viewwidth-10-1-8)+'px';  //-10是因为padding:5px
                    end;
                    //根据字段type分别得到joValue.c
                    if joField.type = 'check' then begin
                        //joField.type = 'check'
                        joValue.c   := false;
                    end else if joField.type = 'index' then begin
                        joValue.c   := IntToStr(oDataSet.RecNo);
                    end else if joField.type = 'boolean' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            if joField.Exists('list') then begin
                                if oDataSet.FieldByName(joField.fieldname).AsBoolean then begin
                                    joValue.c   := joField.list._(0);
                                end else begin
                                    joValue.c   := joField.list._(1);
                                end;
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end;
                    end else if joField.type = 'date' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := FormatDateTime(joField.format,0);
                        end else begin
                            if joField.Exists('format') then begin
                                joValue.c   := FormatDateTime(joField.format,oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end else begin
                                joValue.c   := FormatDateTime('yyyy-MM-dd',oDataSet.FieldByName(joField.fieldname).AsDateTime);
                            end;
                        end;
                    end else if joField.type = 'image' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                        end;
                    end else if joField.type = 'progress' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := 0;
                        end else begin
                            joValue.c   := Round(100*oDataSet.FieldByName(joField.fieldname).AsFloat / joField.total);
                        end;
                    end else if joField.type = 'button' then begin
                        joValue.c   := '';
                    end else if joField.type = 'float' then begin
                        if joField.fieldname = '' then begin
                            joValue.c   := 0;
                        end else begin
                            if joField.Exists('format') then begin
                                joValue.c   := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsFloat]);
                            end else begin
                                joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                            end;
                        end;
                    end else begin
                        if joField.fieldname = '' then begin
                            joValue.c   := '';
                        end else begin
                            joValue.c   := oDataSet.FieldByName(joField.fieldname).AsString;
                        end;
                    end;
                    joColDatas[iCol].Add(joValue);
                end;
                //计算汇总
                for iSum := 1 to joSummary._Count-1 do begin
                    //得到汇总子对象
                    joSItem := joSummary._(iSum);
                    //汇总数据列 iSumCol
                    iSumCol := joSItem._(0);
                    //防止列号超范围
                    if (iSumCol<0) or (iSumCol>=joFields._Count) then begin
                        continue;
                    end;
                    //得到汇总列字段名称 sField
                    sField  := joFields._(iSumCol).fieldname;
                    if (joSItem._(1) = 'avg') or (joSItem._(1) = 'sum') then begin
                        //avg / sum
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := oDataSet.FieldByName(sField).AsFloat;
                        end else begin
                            fValues[iSum-1] := fValues[iSum-1] + oDataSet.FieldByName(sField).AsFloat;
                        end;
                    //min
                    end else if joSItem._(1) = 'min' then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := oDataSet.FieldByName(sField).AsFloat;
                        end else begin
                            fValues[iSum-1] := Min(fValues[iSum-1], oDataSet.FieldByName(sField).AsFloat);
                        end;
                    end else if joSItem._(1) = 'max' then begin
                        if oDataSet.Bof then begin
                            fValues[iSum-1] := oDataSet.FieldByName(sField).AsFloat;
                        end else begin
                            fValues[iSum-1] := Max(fValues[iSum-1], oDataSet.FieldByName(sField).AsFloat);
                        end;
                    end;
                end;
                oDataSet.Next;
                Inc(iRow);
            end;
            for iCol := 0 to joFields._Count-1 do begin
                sCode := sFull + '__cd'+IntToStr(iCol)+sMiddle+VariantSaveJSON(joColDatas[iCol]) + ''+sTail ;
                joRes.Add(sCode);
            end;
            //重新定位记录指针回到原来的位置,恢复事件
            oDataSet.GotoBookmark(oBookMark);
            oDataSet.EnableControls;
            //删除书签BookMark标志
            oDataSet.FreeBookmark(oBookMark);
            //恢复原事件函数
            oDataSet.AfterScroll    := oAfter;
            oDataSet.BeforeScroll   := oBefore;
            //汇总数据 dg__sm_
            for iSum := 1 to joSummary._Count-1 do begin
                //得到汇总子对象 joSItem
                joSItem := joSummary._(iSum);
                //得到汇总列序号 iSumCol
                iSumCol := joSItem._(0);
                //处理平均值
                if joSItem._(1) = 'avg' then begin
                    if iRecCount = 0 then begin
                        fValues[iSum-1] := 0;
                    end else begin
                        fValues[iSum-1] := fValues[iSum-1] / iRecCount;
                    end;
                end;
                //生成各汇总字段的数据 dg__sm_
                sCode := sFull + '__sm'+IntToStr(iSum-1)+sMiddle+'"'+Format(joSItem._(2),[fValues[iSum-1]])+'"'+sTail;
                joRes.Add(sCode);
            end;
        end else begin
            //生成无DataSet状态下的数据
            SetLength(joColDatas,Integer(joFields._Count));
            //给joColDatas赋空的初值
            for iCol := 0 to joFields._Count-1 do begin
                joColDatas[iCol]    := _json('[]');
            end;
            if joSummary._count > 1 then begin
                SetLength(fValues,Integer(joSummary._Count)-1);
            end else begin
                SetLength(fValues,0);
            end;
            for iCol := 0 to joFields._Count-1 do begin
                sCode := sFull + '__cd'+IntToStr(iCol)+sMiddle+VariantSaveJSON(joColDatas[iCol]) + ''+sTail ;
                joRes.Add(sCode);
            end;
            //汇总数据 dg__sm_
            for iSum := 1 to joSummary._Count-1 do begin
                //得到汇总子对象 joSItem
                joSItem := joSummary._(iSum);
                //得到汇总列序号 iSumCol
                iSumCol := joSItem._(0);
                //生成各汇总字段的数据 dg__sm_
                sCode := sFull + '__sm'+IntToStr(iSum-1)+sMiddle+'"'+Format(joSItem._(2),[fValues[iSum-1]])+'"'+sTail;
                joRes.Add(sCode);
            end;
        end;
    end;
    //dg__dch/dg__di_ 编辑时编辑区的高度/编辑值
    idch    := 25;
    for iCol := 0 to joFields._Count -1 do begin
        joField := joFields._(iCol);
        if joField.fieldname = '' then begin
            continue;
        end;
        if joField.type = 'autoinc' then begin
            continue;
        end else if joField.type = 'integer' then begin
            if joField.Exists('minvalue') then begin
                joRes.Add(sFull + '__min'+IntToStr(iCol) + sMiddle + IntToStr(joField.minvalue) + sTail);
            end;
            if joField.Exists('maxvalue') then begin
                joRes.Add(sFull + '__max'+IntToStr(iCol) + sMiddle + IntToStr(joField.maxvalue) + sTail);
            end;
        end;
        if oDataSet <> nil then begin
            if joField.type = 'integer' then begin
                //integer
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+IntToStr(oDataSet.FieldByName(joField.fieldname).AsInteger)+sTail;
            end else begin
                sCode   := oDataSet.FieldByName(joField.fieldname).AsString;
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+'"'+sCode+'"'+sTail;
            end;
        end else begin
            if joField.type = 'integer' then begin
                //integer
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+IntToStr(0)+sTail;
            end else begin
                sCode   := sFull+'__di'+IntToStr(iCol)+sMiddle+'""'+sTail;
            end;
        end;
        joRes.Add(sCode);
        idch    := idch + 70;
    end;
    joRes.Add(sFull+'__dch'+sMiddle+'"'+IntToStr(idch)+'px"'+sTail); //data content height
    joRes.Add(sFull+'__efh'+sMiddle+'"'+IntToStr(idch+120)+'px"'+sTail);
    Result := joRes;
end;

//function dwGetData(ACtrl: TControl): string; stdcall;
function dwGetData(ACtrl: TControl): string; stdcall;
var 
    //
    joRes     : Variant;
    joHint    : variant;
    joFields  : Variant;
    joField   : Variant;
    //
    iCol      : Integer;
    //
    sFull     : string;
    sMiddle   : string;
    sTail     : string;
begin
    //预处理，取得配置参数
    //取得HINT对象joHint,并预处理
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    sFull       := dwFullName(Actrl);
    //取配置默认值,joFields
    joFields    := _GetFields(TListView(ACtrl));
    joRes   := _dwGeneral(ACtrl,'data');
    sFull   := dwFullName(Actrl);
    sMiddle := ':';
    sTail   := ',';
    //GetData特有
    joRes.Add(sFull + '__key:"",');
    joRes.Add(sFull + '__ttl:"0px",');      //title top
    joRes.Add(sFull + '__hov:"-500px",');   //默认不显示hover条
    //删除确认框默认不可见
    joRes.Add(sFull+'__cfv'+sMiddle+'false'+sTail);  //cfv:conform visible
    joRes.Add(sFull+'__edv'+sMiddle+'false'+sTail);  //edv:edit visible
    joRes.Add(sFull+'__eds'+sMiddle+'""'+sTail);     //eds:edit state ， 用于区分edit/append
    joRes.Add(sFull+'__btm'+sMiddle+'0'+sTail);     //btm : button mode . 0：编辑，1：新增
    //添加所有check列清空代码
    for iCol := 0 to joFields._Count -1 do begin
        joField := joFields._(iCol);
        if joField.type = 'check' then begin
            //更新标题栏的check
            joRes.Add(sFull+'__cb'+IntToStr(iCol)+sMiddle+'false'+sTail);  
        end;
    end;
    Result := (joRes);
end;

//function dwGetAction(ACtrl: TControl): string; stdcall;
function dwGetAction(ACtrl: TControl): string; stdcall;
var 
    joRes   : Variant;
    sFull   : string;
begin
    joRes   := _dwGeneral(ACtrl,'action');
    Result := (joRes);
end;

//function dwGetMethods(ACtrl:TControl):String;stdCall;
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iCol        : Integer;  //列
    iItem       : Integer;  //
    iSum        : Integer;  //汇总
    iSumCount   : Integer;  //汇总的最大行数
    iCount      : Integer;
    iRowH       : Integer;      //数据行高
    iTopH       : Integer;      //顶部工具按钮栏高度
    iPageH      : Integer;      //分页栏高度
    iRecCount   : Integer;  //数据的总记录数
    iTitleH     : Integer;  //标题区的高度
    iHeaderH    : Integer;
    iMaxTitle   : Integer;
    //
    sCode       : string;
    sFull       : string;
    sPrimaryKey : String;       //数据表主键
    slKeys      : TStringList;
    sTopBack    : string;
    //
    oDataSet    : TDataSet;
    //
    joRes       : Variant;
    joFields    : Variant;
    joField     : Variant;
    joSels      : Variant;  //用于保存
    joHint      : Variant;
    joSummary   : Variant;
    joSum       : Variant;
begin
    joRes := _Json('[]');
    //预处理，取得配置参数
    //取得HINT对象joHint,并预处理
    joHint := dwGetHintJson(TControl(ACtrl));
    _PreprocessHint(joHint);
    sFull       := dwFullName(Actrl);
    //取配置默认值,joFields
    iTopH       := dwGetInt(joHint,'topheight',40);
    iPageH      := dwGetInt(joHint,'pageheight',40);
    sTopBack    := dwGetStr(joHint,'topbackground','transparent');
    //
    joFields    := _GetFields(TListView(ACtrl));
    //如果不分页，则设置分页高度为0
    if not _GetModule(joHint,5) then begin
        iPageH := 0;
    end;
    with TListView(ACtrl) do begin
        
        //表头全选/全不选事件
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.type = 'check' then begin
                sCode   := sFull+'__cc'+IntToStr(iCol)+'(val) {'
                			//更新所有记录的CheckBox
                			+'this.'+sFull+'__cd'+IntToStr(iCol)+'.forEach((item,index)=>{'
                				+'Vue.set(item,''c'',val);'
                			+'});'
                			+'this.dwevent("","'+sFull+'",val,"onfullcheck",'+IntToStr(TForm(Owner).Handle)+');'
                		+'},';
                joRes.Add(sCode);
            end;
        end;
        
        //__save 编辑后save事件
        sCode   := sFull+'__save(e) '
                +'{'
                    //更新所有记录的CheckBox
                    +'var fds = [];'
                    +'for (var i=0;i<'+IntToStr(joFields._Count)+';i++) {'
                        +'var v = ''this.'+sFull+'__fd'' + i;'
                        +'fds.push(eval(v).toString());'
                    +'};'
                    //+'console.log(fds);'
                    +'var stmp = "''"+JSON.stringify(fds).toString()+"''";'
                    //+'console.log(stmp);'
                    +'if (this.'+sFull+'__dvv == true){'
                        +'this.dwevent("","'+sFull+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}else{'
                        +'this.dwevent("","'+sFull+'",stmp,"onappend",'+IntToStr(TForm(Owner).Handle)+');'
                    +'};'
                    //隐藏数据编辑框
                    //+'this.'+sFull+'__sed=false;'
                    //显示数据显示区
                    +'this.'+sFull+'__dvv=true;'
                    +'e.stopPropagation();'//阻止冒泡
                +'},';
        joRes.Add(sCode);
        
        //__canel 编辑后cancel事件
        sCode   := sFull+'__cancel(e) '
                +'{'
                    //根据"编辑"/"append"分别 处理
                    +'if (this.'+sFull+'__dvv == true){'
                        //+'this.dwevent("","'+sFull+'",stmp,"onsave",'+IntToStr(TForm(Owner).Handle)+');'
                    +'}else{'
                        //显示数据显示区
                        +'this.'+sFull+'__edt=false;'
                    +'};'
                    //显示数据显示区
                    +'this.'+sFull+'__dvv=true;'
                    //隐藏编辑框
                    //+'this.'+sFull+'__sed=false;'   //sed:show editor
                    //
                    +'this.dwevent("","'+sFull+'","","oncancel",'+IntToStr(TForm(Owner).Handle)+');'
                    +'e.stopPropagation();'//阻止冒泡
                +'},';
        joRes.Add(sCode);
        //__scroll 滚动条滚动事件，主要处理横向滚动后
        sCode   := sFull+'__scroll(e) '
                +'{'
                    +'this.'+sFull+'__ttl = -e.target.scrollLeft+"px";'
                +'},';
        joRes.Add(sCode);
        //__format 用于进度条显示超过100%的数值
        joRes.Add(sFull+'__format(value) {return () => { return value + ''%'' }},');
        //__query 搜索关键字input的键入事件
        sCode   := concat(
                sFull+'__query(e,skeyword) {',
                    'this.dwevent(e,'''+sFull+''',''this.'+sFull+'__key'',''onquery'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);
        //__pagechange 分页控件切换页码事件
        sCode   := concat(
                sFull+'__pagechange(pageno) {',
                    'this.dwevent('''','''+sFull+''',pageno,''onpagechange'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);
        //__sortasc  正向排序事件
        sCode   := concat(
                sFull+'__sortasc(e,icol) {',
                    'this.dwevent(e,'''+sFull+''',icol,''onsortasc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);
        //__sortdesc 正向排序事件
        sCode   := concat(
                sFull+'__sortdesc(e,icol) {',
                    'this.dwevent(e,'''+sFull+''',icol,''onsortdesc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);
        //__buttonclick 增删改（1/2/3）按钮事件
        sCode   := concat(
                sFull+'__buttonclick(e,id) {'#13,
                    'switch(id) {'#13,
                         'case 1: //增'#13,
                            'this.'+sFull+'__btm = 1;'#13,
                            'this.dwevent(e,'''+sFull+''','''',''onappend'','''+IntToStr(TForm(Owner).Handle)+''');',
                            'this.'+sFull+'__edv = true;'#13,
                            'break;'#13,
                         'case 2: //删'#13,
                            'this.'+sFull+'__cfv = true;'#13,
                            'break;'#13,
                         'case 3: //改'#13,
                            'this.'+sFull+'__btm = 3;'#13,
                            'this.'+sFull+'__edv = true;'#13,
                            'break;'#13,
                         'default: //'#13,
                            ''#13,
                    '};', 
                    //'this.dwevent(e,'''+sFull+''',id,''onsortdesc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);
        //__editcancel 编辑/新增的cancel事件
        sCode   := concat(
                sFull+'__editcancel(e) {'#13,
                    //'console.log(this.'+sFull+'__btm);',
                    'if(1 == this.'+sFull+'__btm) {'#13,
                        'this.dwevent(e,'''+sFull+''','''',''onappendcancel'','''+IntToStr(TForm(Owner).Handle)+''');',
                    '};', 
                    'this.'+sFull+'__edv = false;'#13,
                    //'this.dwevent(e,'''+sFull+''',id,''onsortdesc'','''+IntToStr(TForm(Owner).Handle)+''');',
                    //'e.stopPropagation();',//阻止冒泡
                '},');
        joRes.Add(sCode);
        //__editsave   编辑/新增的save事件
        
        sCode   := concat(
        		sFull+'__editsave(e) ',
        		'{',
        			//更新所有记录的CheckBox
        			'var fds = [];',
        			//'fds.push(recordno);',
        			'for (var i=0;i<'+IntToStr(joFields._Count)+';i++) {',
        				'var v = ''this.'+sFull+'__di'' + i;',
        				'if (eval(v)==null){',
        					'fds.push("");',
        				'}else{',
        					'fds.push(eval(v));',
        				'};',
        			'};',
        			//+'console.log(fds);'
        			'var stmp = "''"+JSON.stringify(fds).toString()+"''";',
        			//+'console.log(stmp);'
        			'this.dwevent("","'+sFull+'",stmp,"oneditsave",'+IntToStr(TForm(Owner).Handle)+');',
        			'this.'+sFull+'__edv=false;',
        			//隐藏数据编辑框
        			//+'this.'+dwFullName(Actrl)+'__sed=false;'
        			'e.stopPropagation();',//阻止冒泡
        		'},');
        joRes.Add(sCode);
        
        //__deleteconfirm 删除确认事件
        //__deleteconfirm 删除确认事件
        sCode   := concat(
                sFull+'__deleteconfirm(e) {'#13,
        			'this.'+sFull+'__cfv=false;',
        			'this.dwevent(e,'''+sFull+''','''',''ondeleteclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                    );
        //添加所有check列清空代码
        for iCol := 0 to joFields._Count -1 do begin
            joField := joFields._(iCol);
            if joField.type = 'check' then begin
                //sCode   := Concat(sCode,
                sCode   := Concat(sCode,
                			'this.'+sFull+'__cd'+IntToStr(iCol)+'.forEach((item,index)=>{',
                				'Vue.set(item,''c'',0);',
                			'});');
                //更新标题栏的check
                sCode   := Concat(sCode,
                			//更新所有记录的CheckBox
                			'this.'+sFull+'__cb'+IntToStr(iCol)+'=false;');
            end;
        end;
        joRes.Add(sCode+'},');
    end;
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