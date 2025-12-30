unit dwExportToXLSUnit;

interface

uses
    SynCommons,

    //
    Math,
    DB, Classes, Dialogs, ComObj, Variants, SysUtils,
    Graphics, Forms, Controls;

var
    arXlsBegin  : array[0..5] of Word = ($809, 8, 0, $10, 0, 0);
    arXlsEnd    : array[0..1] of Word = ($0A, 00);
    arXlsString : array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
    arXlsNumber : array[0..4] of Word = ($203, 14, 0, 0, 0);
    arXlsInteger: array[0..4] of Word = ($27E, 10, 0, 0, 0);
    arXlsBlank  : array[0..4] of Word = ($201, 6, 0, 0, $17);
    //==============以上为导出EXCEL文件格式所需数组常量=======================//

function dwExportToXLS( const FileName: string; ADataSet: TDataSet): Boolean;

function dwExportToTitledXLS( const FileName: string; ADataSet: TDataSet;ATitle:String): Boolean;
//ATitle格式为：["序号","名称","型号","数量"]
//注意: 方括号,双引号,逗号 都必须为半角

implementation


function dwExportToXLS( const FileName: string; ADataSet: TDataSet): Boolean;
// 文件流写入方式导出EXCEL
var
  i: integer;
  Col, row: word;
  ABookMark: TBookMark;
  aFileStream: TFileStream;
  ResultFileName: string;

  procedure incColRow; //增加行列号
  begin
  if Col = ADataSet.FieldCount - 1 then   //如果到达末列
    begin
      Inc(Row);    //行加1
      Col :=0;     //列为0
    end
  else             //如未到末列
    Inc(Col);      //列加1
  end;

  procedure WriteStringCell(AValue: ansistring);//写字符串数据
  var
    L: Word;
  begin
    L := Length(AValue);     //取参数字符串长度
    arXlsString[1] := 8 + L;     //arXlsString数组元素1：参数串长度+8
    arXlsString[2] := Row;       //arXlsString数组元素2：行数
    arXlsString[3] := Col;       //arXlsString数组元素3：列数
    arXlsString[5] := L;         //arXlsString数组元素5：参数串长度
    aFileStream.WriteBuffer(arXlsString, SizeOf(arXlsString));  //arXlsString数组写入文件流
    aFileStream.WriteBuffer(Pointer(AValue)^, L);    //参数串写入文件流
    IncColRow;                                       //增加行列号
  end;
  procedure WriteIntegerCell(AValue: integer);//写整数
  var
    V: Integer;
  begin
    arXlsInteger[2] := Row;    //arXlsInteger数组元素2：行数
    arXlsInteger[3] := Col;    //arXlsInteger数组元素3：列数
    aFileStream.WriteBuffer(arXlsInteger, SizeOf(arXlsInteger));   //arXlsInteger数组写入文件流
    V := (AValue shl 2) or 2;       //整型参数左移2位，然后与2进行or操作，所得值赋给变量V
    aFileStream.WriteBuffer(V, 4);   //变量V写入文件流（长度为4）
    IncColRow;                       //增加行列号
  end;

  procedure WriteFloatCell(AValue: double);//写浮点数
  begin
    arXlsNumber[2] := Row;     //arXlsNumber数组元素2：行数
    arXlsNumber[3] := Col;     //arXlsNumber数组元素3：列数
    aFileStream.WriteBuffer(arXlsNumber, SizeOf(arXlsNumber));  //arXlsNumber数组写入文件流
    aFileStream.WriteBuffer(AValue, 8);   //浮点参数写入文件流，长度为8
    IncColRow;                            //增加行列号
  end;

begin
  ResultFileName := FileName; // 确定文件名

  if FileExists(ResultFileName) then
  DeleteFile(PWideChar(WideString(ResultFileName))); //如文件已存在，先删除
  aFileStream := TFileStream.Create(ResultFileName, fmCreate);   //按照设定文件名创建一个文件
  result := True;
  Try
    //写文件头
    aFileStream.WriteBuffer(arXlsBegin, SizeOf(arXlsBegin));
    //写列头
    Col := 0; Row := 0;
    if True then    //如果列头参数为真
    begin
      for i := 0 to aDataSet.FieldCount - 1 do        //遍历各列
      WriteStringCell(ansistring(aDataSet.Fields[i].FieldName));  //数据列表字段名写入单元格
    end;
    //写数据集中的数据
    aDataSet.DisableControls;      //断开数据组件（修改过程中）
    ABookMark := aDataSet.GetBookmark;    //取当前定位
    aDataSet.First;                //到首记录
    while not aDataSet.Eof do      //循环遍历所有记录
    begin
      for i := 0 to aDataSet.FieldCount - 1 do     //循环遍历所有字段
      case ADataSet.Fields[i].DataType of
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:     //整型数值类型
        WriteIntegerCell(aDataSet.Fields[i].AsInteger);        //调用写整数过程
        ftFloat, ftCurrency, ftBCD:                            //浮点数值类型
        WriteFloatCell(aDataSet.Fields[i].AsFloat)             //调用写浮点数过程
      else
        WriteStringCell(ansistring(aDataSet.Fields[i].AsString));          //调用写字符串过程
      end;
      aDataSet.Next;        //下一记录
    end;
    //写文件尾
    AFileStream.WriteBuffer(arXlsEnd, SizeOf(arXlsEnd));       //arXlsEnd数组写入文件流
    if ADataSet.BookmarkValid(ABookMark) then                  //如果原记录定位有效
    aDataSet.GotoBookmark(ABookMark);                          //回到原记录定位
  finally
    AFileStream.Free;                                          //释放文件流
    ADataSet.EnableControls;                                   //连接数据组件（修改完毕）
  end;
end;

function dwExportToTitledXLS( const FileName: string; ADataSet: TDataSet;ATitle:String): Boolean;
// 文件流写入方式导出EXCEL
//ATitle格式为：["序号","名称","型号","数量"]
//注意: 方括号,双引号,逗号 都必须为半角
var
    i             : integer;
    Col, row      : word;
    ABookMark     : TBookMark;
    aFileStream   : TFileStream;
    ResultFileName: string;
    sTitle        : string;
    joTitle       : Variant;

    procedure incColRow; //增加行列号
    begin
        if Col = ADataSet.FieldCount - 1 then   //如果到达末列
        begin
            Inc(Row);    //行加1
            Col :=0;     //列为0
        end else             //如未到末列
            Inc(Col);      //列加1
    end;

    procedure WriteStringCell(AValue: ansistring);//写字符串数据
    var
        L   : Word;
    begin
        L   := Length(AValue);     //取参数字符串长度
        arXlsString[1]  := 8 + L;     //arXlsString数组元素1：参数串长度+8
        arXlsString[2]  := Row;       //arXlsString数组元素2：行数
        arXlsString[3]  := Col;       //arXlsString数组元素3：列数
        arXlsString[5]  := L;         //arXlsString数组元素5：参数串长度
        aFileStream.WriteBuffer(arXlsString, SizeOf(arXlsString));  //arXlsString数组写入文件流
        aFileStream.WriteBuffer(Pointer(AValue)^, L);    //参数串写入文件流
        IncColRow;                                       //增加行列号
    end;
    procedure WriteIntegerCell(AValue: integer);//写整数
    var
        V: Integer;
    begin
        arXlsInteger[2] := Row;    //arXlsInteger数组元素2：行数
        arXlsInteger[3] := Col;    //arXlsInteger数组元素3：列数
        aFileStream.WriteBuffer(arXlsInteger, SizeOf(arXlsInteger));   //arXlsInteger数组写入文件流
        V := (AValue shl 2) or 2;       //整型参数左移2位，然后与2进行or操作，所得值赋给变量V
        aFileStream.WriteBuffer(V, 4);   //变量V写入文件流（长度为4）
        IncColRow;                       //增加行列号
    end;

    procedure WriteFloatCell(AValue: double);//写浮点数
    begin
        arXlsNumber[2] := Row;     //arXlsNumber数组元素2：行数
        arXlsNumber[3] := Col;     //arXlsNumber数组元素3：列数
        aFileStream.WriteBuffer(arXlsNumber, SizeOf(arXlsNumber));  //arXlsNumber数组写入文件流
        aFileStream.WriteBuffer(AValue, 8);   //浮点参数写入文件流，长度为8
        IncColRow;                            //增加行列号
    end;

begin
    ResultFileName := FileName; // 确定文件名

    if FileExists(ResultFileName) then begin
        DeleteFile(PWideChar(WideString(ResultFileName))); //如文件已存在，先删除
    end;
    aFileStream := TFileStream.Create(ResultFileName, fmCreate);   //按照设定文件名创建一个文件

    Result := True;
    Try
        //写文件头
        aFileStream.WriteBuffer(arXlsBegin, SizeOf(arXlsBegin));

        //写列头
        Col := 0; Row := 0;
        joTitle := _json(ATitle);

        if joTitle = unassigned then begin
            for i := 0 to aDataSet.FieldCount - 1 do begin       //遍历各列
                WriteStringCell(ansistring(aDataSet.Fields[i].FieldName));  //数据列表字段名写入单元格
            end;
        end else begin
            for i := 0 to Min(joTitle._Count, ADataSet.FieldCount) - 1 do begin       //遍历各列
                sTitle  := joTitle._(I);
                WriteStringCell(AnsiString(sTitle));  //数据列表字段名写入单元格
            end;
        end;

        //写数据集中的数据
        aDataSet.DisableControls;      //断开数据组件（修改过程中）
        ABookMark   := aDataSet.GetBookmark;    //取当前定位
        aDataSet.First;                //到首记录
        while not aDataSet.Eof do begin     //循环遍历所有记录
            for i := 0 to aDataSet.FieldCount - 1 do     //循环遍历所有字段
                case ADataSet.Fields[i].DataType of
                    ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:     //整型数值类型
                        WriteIntegerCell(aDataSet.Fields[i].AsInteger);        //调用写整数过程
                    ftFloat, ftCurrency, ftBCD:                            //浮点数值类型
                        WriteFloatCell(aDataSet.Fields[i].AsFloat)             //调用写浮点数过程
                else
                    //调用写字符串过程
                    WriteStringCell(ansistring(Trim(ADataSet.Fields[i].AsString)));
                end;
            aDataSet.Next;        //下一记录
        end;

        //写文件尾
        AFileStream.WriteBuffer(arXlsEnd, SizeOf(arXlsEnd));       //arXlsEnd数组写入文件流
        if ADataSet.BookmarkValid(ABookMark) then begin                  //如果原记录定位有效
            aDataSet.GotoBookmark(ABookMark);                          //回到原记录定位
        end;
    finally
        AFileStream.Free;                                          //释放文件流
        ADataSet.EnableControls;                                   //连接数据组件（修改完毕）
    end;
end;


end.
