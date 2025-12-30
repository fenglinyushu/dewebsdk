unit dwExcel;
{
功能: 导入excel单元

### 2025-09-11
1. 消除了重复导入501条记录的bug
2. 消除了找不到字段的bug. 在导入函数中打开表

}
interface

uses
    //
    Syncommons,

    //
    dwBase,

    //
    Excel4Delphi,Excel4Delphi.Stream,

    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.ADSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef, FireDAC.Phys.ASADef,
    FireDAC.Phys.MongoDBDef, FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
    FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB, FireDAC.Phys.ASA,
    FireDAC.Phys.TData, FireDAC.Phys.Infx, FireDAC.Phys.DB2, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
    FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.ADS,
    FireDAC.Phys.MySQL, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageBin,
    FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient,

    //
    Math,
    DB, Classes, Dialogs, ComObj, Variants, SysUtils,
    Graphics, Forms, Controls;

function exExportToFileWithTitle( const FileName: string; ADataSet: TDataSet;ATitle:String): Boolean;

//功能: 将excel导入到数据表中
//const FileName: string;       源excel文件
//ADataSet: TDataSet;           数据表控件, 一般为TFDQuery
//AConfig:Variant;              配置JSON对象, 格式见crudpanel文档
//const ASlaveField:String='';  可能的从表字段
//ASlaveFieldValue:String=''    可能的从表字段值
function exImportFromFile( const FileName: string; ADataSet: TDataSet;AConfig:Variant;const ASlaveField:String='';ASlaveFieldValue:String=''): Boolean;

implementation

const
    //整型类型集合
    cpstInteger : Set of TFieldType = [ftSmallint, ftInteger, ftWord, ftAutoInc,ftLargeint, ftLongWord, ftShortint, ftByte];
    //浮点型类型集合
    cpstFloat   : set of TFieldType = [ftFloat, ftCurrency, ftBCD, ftExtended, ftSingle];
    //日期时间类型集合
    cpstDateTime   : set of TFieldType = [ftDate, ftTime, ftDateTime, ftTimeStamp,ftOraTimeStamp,ftTimeStampOffset];



//列号转字符串A~Z, AA~AZ, ACol从0开始
function _ColToStr(ACol:Integer):String;
var
    iiFirst     : Integer;
    iiSecond    : Integer;
    sFirst      : String;
    sSecond     : String;
begin
    iiFirst     := ACol div 26;
    iiSecond    := ACol mod 26;

    //
    if iiFirst > 0 then begin
        sFirst  := Chr(Ord('A') + iiFirst - 1);
    end else begin
        sFirst  := '';
    end;
    sSecond     := Chr(Ord('A') + iiSecond);
    //
    Result  := sFirst + sSecond;
end;


function exImportFromFile( const FileName: string; ADataSet: TDataSet; AConfig:Variant; const ASlaveField:String=''; ASlaveFieldValue:String=''): Boolean;
var
    oWorkBook   : TZWorkBook;
    //
    iLastRow    : Integer;
    iRow,iCol   : Integer;
    iItem       : Integer;
    iKilo       : Integer;
    iStart      : Integer;
    dTemp       : Double;
    //
    sSQL        : String;
    sValue      : string;
    sFields     : string;
    //
    dtTemp      : TDateTime;
    ftField     : TFieldType;
    joField     : variant;
    joFields    : variant;  //需要导入的字段列表

    function _ExcelDateToDateTime(ExcelDate: Double): TDateTime;
    const
        ExcelBaseDate = 25569; // 1970-01-01 在 Excel 中的日期值
        UnixBaseDate = 25568;  // 1970-01-01 在 Delphi 中的日期值
    begin
        // 通过 1970-01-01 这个共同参考点进行转换
        Result := (ExcelDate - ExcelBaseDate) + UnixBaseDate;
    end;

begin
    try
        //读取源excel文件
        oWorkBook   := TZWorkBook.Create(nil);
        oWorkBook.LoadFromFile(FileName);

        //加入表格中显示的字段, view 为0,3, 且 type 不是 auto
        joFields    := _json('[]');
        sFields     := '';
        for iItem := 0 to AConfig.fields._Count - 1 do begin
            //取得字段json对象
            joField := AConfig.fields._(iItem);

            //只导入在表格中显示且类型不是auto的字段
            if (dwGetInt(joField,'view') in [0,3]) and (dwGetStr(joField,'type')<>'auto') then begin
                //取得字段列表的字符串, 以逗号分隔
                sFields := sFields + joField.name +',';

                //创建json数组
                joFields.Add(String(joField.name));
            end;
        end;

        //无字段异常检测
        if joFields._Count = 0 then begin
            //dwMessage('error when BImEndDock: fields is empty!','',oForm);
            Exit;
        end else begin
            //加入当前表作为从表和主表对应的字段
            if ASlaveField <> '' then begin
                sFields := sFields + ASlaveField ;
            end else begin
                // 删除字段列表的字符串中最后的逗号
                Delete(sFields,Length(sFields),1);
            end;
        end;

        //打开数据表, 以后面检查字段的类型
        TFDQuery(ADataSet).Open('SELECT '+sFields+' FROM '+AConfig.table+' WHERE 1=0');

        // 获取 Excel 中的行列数
        iLastRow    := oWorkBook.Sheets[0].RowCount - 1;//oWorksheet.Cells(oWorksheet.Rows.Count, 'A').End(-4162).Row;  // xlUp

        //
        for iKilo := 0 to Ceil(iLastRow/500) - 1 do begin
            //生成插入SQL的字段部分
            sSQL        := 'INSERT INTO ' + AConfig.table + ' (' + sFields + ') VALUES ';

            // 遍历 Excel 数据并插入数据库
            iStart  := iKilo*500 + 1;
            for iRow := iStart to Min(iStart+500-1,iLastRow - 1) do begin  // 从第二行开始，假设第一行是标题
                sSQL    := sSQL + '( ';

                //加入EXCEL表的数据
                for iCol := 0 to joFields._Count - 1 do begin

                    // 获取字段值
                    sValue  := '';
                    if iCol < oWorkBook.Sheets[0].ColCount then begin
                        sValue  := oWorkBook.Sheets[0].Cell[iCol, iRow].AsString;
                    end;


                    //根据数据库字段类型, 分别插入
                    ftField := ADataSet.Fields[iCol].DataType;
                    //
                    if ftField in cpstInteger then begin    //整型
                        sSQL    := sSQL + IntToStr(StrToIntDef(sValue,0)) + ',';
                    end else if ftField in cpstFloat then begin //浮点型
                        sSQL    := sSQL + FloatToStr(StrToFloatDef(sValue,0)) + ',';
                    end else if ftField in cpstDateTime then begin  //日期时间型
                        //很多excel的日期实际保存为数字型, 需要先处理
                        dTemp   := StrToFloatDef(sValue,-1);
                        if dTemp = -1 then begin
                            sSQL    := sSQL + '''' + dwIIF(TryStrToDateTime(sValue, dtTemp),sValue,'') + ''',';
                        end else begin
                            if ftField = ftDate then begin
                                sValue  := FormatDateTime('YYYY-MM-DD',_ExcelDateToDateTime(dTemp));
                            end else if ftField = ftTime then begin
                                sValue  := FormatDateTime('hh:mm:ss',_ExcelDateToDateTime(dTemp));
                            end else begin
                                sValue  := FormatDateTime('YYYY-MM-DD hh:mm:ss',_ExcelDateToDateTime(dTemp));
                            end ;
                            sSQL    := sSQL + '''' + sValue + ''',';
                        end;
                    end else begin
                        sSQL    := sSQL + '''' + StringReplace(sValue,'''','''''',[rfReplaceAll]) + ''',';
                    end;
                end;

                //加入当前表作为从表和主表对应的字段
                if ASlaveField <> '' then begin
                    sSQL    := sSQL + ASlaveFieldValue +',';
                end;

                //删除最后的逗号
                Delete(sSQL, Length(sSQL), 1);

                //添加values段
                sSQL    := sSQL + '),';
            end;
            //删除最后的逗号
            Delete(sSQL, Length(sSQL), 1);

            // 执行插入操作
            TFDQuery(ADataSet).Connection.ExecSQL(sSQL);
        end;
    finally
        oWorkBook.Free();
    end;
end;

function exExportToFileWithTitle( const FileName: string; ADataSet: TDataSet;ATitle:String): Boolean;
// 文件流写入方式导出EXCEL
//ATitle格式为：["序号","名称","型号","数量"], 注意: 方括号,双引号,逗号 都必须为半角
var
    I           : integer;
    ABookMark   : TBookMark;
    joTitle     : Variant;
    oWorkBook   : TZWorkBook;
begin
    //删除可能存在的文件
    if FileExists(FileName) then begin
        DeleteFile(PWideChar(WideString(FileName))); //如文件已存在，先删除
    end;

    //生成标题对应JSON
    joTitle     := _json(ATitle);
    if joTitle = unassigned then begin
        joTitle := _json('[]');
        for I := 0 to aDataSet.FieldCount - 1 do begin
            joTitle.Add(ADataSet.Fields[I].FieldName);
        end;
    end;

    oWorkBook   := TZWorkBook.Create(nil);
    try
        oWorkBook.Sheets.Add('DeWeb Sheet');
        oWorkBook.Sheets[0].ColCount := Max(ADataSet.FieldCount,joTitle._Count);
        oWorkBook.Sheets[0].RowCount := ADataSet.RecordCount + 1;

        //写标题行
        for I := 0 to joTitle._Count - 1 do begin
            oWorkBook.Sheets[0].CellRef[_ColToStr(I), 0].AsString := joTitle._(I);
        end;

        //写数据集中的数据
        aDataSet.DisableControls;      //断开数据组件（修改过程中）
        ABookMark   := aDataSet.GetBookmark;    //取当前定位
        aDataSet.First;                //到首记录
        try
            while not aDataSet.Eof do begin     //循环遍历所有记录
                for I := 0 to aDataSet.FieldCount - 1 do  begin   //循环遍历所有字段
                    oWorkBook.Sheets[0].CellRef[_ColToStr(I), ADataSet.RecNo].AsString := ADataSet.Fields[i].AsString;
                end;
                aDataSet.Next;        //下一记录
            end;
        except
            ShowMessage('RecNo:'+IntToStr(ADataSet.RecNo)+',  Field:'+IntToStr(I));
        end;
        //
        oWorkBook.SaveToFile(FileName);
    finally
        ADataSet.EnableControls;
        oWorkBook.Free();
    end;
end;

end.
