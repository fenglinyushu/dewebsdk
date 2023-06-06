unit dwExportToXLSUnit;

interface

uses
  DB, Classes, Dialogs, ComObj, Variants, SysUtils,
  Graphics, Forms, Controls;

var
  arXlsBegin: array[0..5] of Word = ($809, 8, 0, $10, 0, 0);
  arXlsEnd: array[0..1] of Word = ($0A, 00);
  arXlsString: array[0..5] of Word = ($204, 0, 0, 0, 0, 0);
  arXlsNumber: array[0..4] of Word = ($203, 14, 0, 0, 0);
  arXlsInteger: array[0..4] of Word = ($27E, 10, 0, 0, 0);
  arXlsBlank: array[0..4] of Word = ($201, 6, 0, 0, $17);
  {
  ����Ϊ����EXCEL�ļ���ʽ�����������
  }
function dwExportToXLS( const FileName: string; ADataSet: TDataSet): Boolean;

implementation


function dwExportToXLS( const FileName: string; ADataSet: TDataSet): Boolean;
// �ļ���д�뷽ʽ����EXCEL
var
  i: integer;
  Col, row: word;
  ABookMark: TBookMark;
  aFileStream: TFileStream;
  TempFileName, ResultFileName: string;

  procedure incColRow; //�������к�
  begin
  if Col = ADataSet.FieldCount - 1 then   //�������ĩ��
    begin
      Inc(Row);    //�м�1
      Col :=0;     //��Ϊ0
    end
  else             //��δ��ĩ��
    Inc(Col);      //�м�1
  end;

  procedure WriteStringCell(AValue: ansistring);//д�ַ�������
  var
    L: Word;
  begin
    L := Length(AValue);     //ȡ�����ַ�������
    arXlsString[1] := 8 + L;     //arXlsString����Ԫ��1������������+8
    arXlsString[2] := Row;       //arXlsString����Ԫ��2������
    arXlsString[3] := Col;       //arXlsString����Ԫ��3������
    arXlsString[5] := L;         //arXlsString����Ԫ��5������������
    aFileStream.WriteBuffer(arXlsString, SizeOf(arXlsString));  //arXlsString����д���ļ���
    aFileStream.WriteBuffer(Pointer(AValue)^, L);    //������д���ļ���
    IncColRow;                                       //�������к�
  end;
  procedure WriteIntegerCell(AValue: integer);//д����
  var
    V: Integer;
  begin
    arXlsInteger[2] := Row;    //arXlsInteger����Ԫ��2������
    arXlsInteger[3] := Col;    //arXlsInteger����Ԫ��3������
    aFileStream.WriteBuffer(arXlsInteger, SizeOf(arXlsInteger));   //arXlsInteger����д���ļ���
    V := (AValue shl 2) or 2;       //���Ͳ�������2λ��Ȼ����2����or����������ֵ��������V
    aFileStream.WriteBuffer(V, 4);   //����Vд���ļ���������Ϊ4��
    IncColRow;                       //�������к�
  end;

  procedure WriteFloatCell(AValue: double);//д������
  begin
    arXlsNumber[2] := Row;     //arXlsNumber����Ԫ��2������
    arXlsNumber[3] := Col;     //arXlsNumber����Ԫ��3������
    aFileStream.WriteBuffer(arXlsNumber, SizeOf(arXlsNumber));  //arXlsNumber����д���ļ���
    aFileStream.WriteBuffer(AValue, 8);   //�������д���ļ���������Ϊ8
    IncColRow;                            //�������к�
  end;

begin
  ResultFileName := FileName; // ȷ���ļ���

  if FileExists(ResultFileName) then
  DeleteFile(PWideChar(WideString(ResultFileName))); //���ļ��Ѵ��ڣ���ɾ��
  aFileStream := TFileStream.Create(ResultFileName, fmCreate);   //�����趨�ļ�������һ���ļ�
  result := True;
  Try
    //д�ļ�ͷ
    aFileStream.WriteBuffer(arXlsBegin, SizeOf(arXlsBegin));
    //д��ͷ
    Col := 0; Row := 0;
    if True then    //�����ͷ����Ϊ��
    begin
      for i := 0 to aDataSet.FieldCount - 1 do        //��������
      WriteStringCell(ansistring(aDataSet.Fields[i].FieldName));  //�����б��ֶ���д�뵥Ԫ��
    end;
    //д���ݼ��е�����
    aDataSet.DisableControls;      //�Ͽ�����������޸Ĺ����У�
    ABookMark := aDataSet.GetBookmark;    //ȡ��ǰ��λ
    aDataSet.First;                //���׼�¼
    while not aDataSet.Eof do      //ѭ���������м�¼
    begin
      for i := 0 to aDataSet.FieldCount - 1 do     //ѭ�����������ֶ�
      case ADataSet.Fields[i].DataType of
        ftSmallint, ftInteger, ftWord, ftAutoInc, ftBytes:     //������ֵ����
        WriteIntegerCell(aDataSet.Fields[i].AsInteger);        //����д��������
        ftFloat, ftCurrency, ftBCD:                            //������ֵ����
        WriteFloatCell(aDataSet.Fields[i].AsFloat)             //����д����������
      else
        WriteStringCell(ansistring(aDataSet.Fields[i].AsString));          //����д�ַ�������
      end;
      aDataSet.Next;        //��һ��¼
    end;
    //д�ļ�β
    AFileStream.WriteBuffer(arXlsEnd, SizeOf(arXlsEnd));       //arXlsEnd����д���ļ���
    if ADataSet.BookmarkValid(ABookMark) then                  //���ԭ��¼��λ��Ч
    aDataSet.GotoBookmark(ABookMark);                          //�ص�ԭ��¼��λ
  finally
    AFileStream.Free;                                          //�ͷ��ļ���
    ADataSet.EnableControls;                                   //��������������޸���ϣ�
  end;
end;

end.
