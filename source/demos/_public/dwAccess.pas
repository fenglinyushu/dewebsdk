unit dwAccess;

interface

uses
    //
    SynCommons,

    //
    Math,
    Types,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client,
    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids;

//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新StringGrid和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure dwaGetDataToGrid(
        AQuery:TFDQuery;
        ATable,AFields,AWhere,AOrder:String;
        APage,ACount:Integer;
        ASG:TStringGrid;
        ATrackBar:TTrackBar);


//根据表名，生成多字段查询的WHERE字符串,结果类似 ' Where (1=1) and (...)
function dwaGetWhere(
        AQuery:TFDQuery;
        ATable,AKeyword:String
        ):string;

//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure dwaGetPageData(
        AQuery:TFDQuery;       //对应的TFDQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        APage:Integer;          //当前页码,从1开始
        ACount:Integer;         //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );

//根据表名、字段名，生成选项JSON数组
function dwaGetItems(
        AQuery:TFDQuery;       //对应的TFDQuery控件
        ATable:string;          //表名
        AField:string
        ):Variant;


implementation


//根据表名、字段名，生成选项JSON数组
function dwaGetItems(
        AQuery:TFDQuery;       //对应的TFDQuery控件
        ATable:string;          //表名
        AField:string
        ):Variant;
begin
    Result  := _json('[]');
    //
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := 999;
    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Distinct('+AField+') FROM '+ATable;
    AQuery.Open;

    //
    while not AQuery.Eof do begin
        if Trim(AQuery.Fields[0].AsString)<>'' then begin
            Result.Add(AQuery.Fields[0].AsString);
        end;
        //
        AQuery.Next;
    end;
end;


//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure dwaGetPageData(
        AQuery:TFDQuery;       //对应的ADOQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        APage:Integer;          //当前页码,从1开始
        ACount:Integer;         //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );
begin

    //----求总数------------------------------------------------------------------------------------
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := -1;

    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Count(id) FROM '+ATable+' '+AWhere;
    AQuery.Open;

    //记录总数
    ARecordCount    := AQuery.Fields[0].AsInteger;

    //如果超出最大页数,则为最大页数
    if APage > Ceil(ARecordCount / ACount) then begin
        APage   := Ceil(ARecordCount / ACount);
    end;

    //强制APage 从1开始
    APage   := Max(1,APage);

    //----更新当前页--------------------------------------------------------------------------------

    AQuery.Close;
{
    //原来采用top机制取分页数据，2023-04-13 后改成FireDAC的机制
    if APage = 1 then begin
        AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    end else begin
        S0 := 'SELECT TOP '+((APage-1)*ACount).ToString+' id FROM '+ATable+' '+AWhere+' '+AOrder;
        if Trim(AWhere) = '' then begin
            AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' '+AFields+' FROM '+ATable+' WHERE (id NOT IN ('+S0+')) '+AOrder;
        end else begin
            AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' '+AFields+' FROM '+ATable+' '+AWhere+' AND (id NOT IN ('+S0+')) '+AOrder;
        end;
    end;
}

    //<2023-04-13 改成的FireDAC的机制
    AQuery.SQL.Text := 'SELECT '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    AQuery.FetchOptions.RecsSkip    := (APage - 1) * ACount;
    AQuery.FetchOptions.RecsMax     := ACount;
    //>

    //
    AQuery.Open;

end;



function dwaGetWhere(
        AQuery:TFDQuery;
        ATable,AKeyword:String
        ):string;
var
    SS      : TStringDynArray;
    iPos    : Integer;
    iKey    : Integer;
    iField  : Integer;
begin
    if Trim(AKeyword)='' then begin
        Result  := ' WHERE (1=1) ';
    end else begin
        //拆分出多个关键字。 如查询 ”delphi 控件开发“
        AKeyword    := Trim(AKeyword);
        while AKeyword<>'' do begin
            iPos := Pos(' ',AKeyword);
            if iPos>0 then begin
                SetLength(SS,Length(SS)+1);
                SS[High(SS)]    := Trim(Copy(AKeyword,1,iPos-1));
                //
                Delete(AKeyword,1,iPos);
                AKeyword    := Trim(AKeyword);
            end else begin
                SetLength(SS,Length(SS)+1);
                SS[High(SS)]    := AKeyword;
                //
                break;
            end;
        end;

        //得到字段名
        AQuery.Close;
        AQuery.SQL.Text := 'SELECT * FROM '+ATable+' WHERE (1=1)';
        AQuery.Open;
        Result  := 'WHERE ';
        for iKey := 0 to High(SS) do begin
            Result  := Result +'(';
            for iField := 0 to AQuery.FieldCount-1 do begin
                //不查询iD字段
                if lowerCase(AQuery.Fields[iField].FieldName)='id' then begin
                    Continue;
                end;
                //
                Result  := Result + AQuery.Fields[iField].FieldName +' like ''%'+SS[iKey]+'%'' OR '
            end;
            Delete(Result,Length(Result)-3,4);
            Result  := Result +') AND ';
        end;
        Delete(Result,Length(Result)-3,4);
    end;

end;

procedure dwaGetDataToGrid(
        AQuery:TFDQuery;
        ATable,AFields,AWhere,AOrder:String;
        APage,ACount:Integer;
        ASG:TStringGrid;
        ATrackBar:TTrackBar);
var
    oEvent          : Procedure(Sender:TObject) of Object;

    iRecordCount    : Integer;
    iRow,iCol       : Integer;
    iOldRecNo       : Integer;
begin
    //保存事件，并清空，以防止循环处理
    oEvent  := ATrackBar.OnChange;
    ATrackBar.OnChange  := nil;

    //保存原Recno
    iOldRecNo   := AQuery.RecNo;
    AQuery.DisableControls;

    //根据条件, 得出数据
    dwaGetPageData(
        AQuery,
        ATable,
        AFields,
        AWhere,
        AOrder,
        APage,
        ACount,
        iRecordCount);

    //设置分页控件值
    ATrackBar.Max       := iRecordCount;
    ATrackBar.PageSize  := ACount;

    //清空原StringGrid数据记录(主要防止数据记录未写满页面显示错误)
    for iRow := 1 to ASG.RowCount-1 do begin
        for iCol := 0 to ASG.ColCount-1 do begin
            ASG.Cells[iCol,iRow]    := '';
        end;
    end;
    ASG.Row := 1;

    //如果超出最大页数,则为最大页数
    if APage>Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize)) then begin
        APage   := Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize));
    end;

    //强制APage 从1开始
    APage   := Max(1,APage);

    //显示数据记录
    if not AQuery.IsEmpty then begin
        for iRow := 1 to ASG.RowCount-1 do begin
            for iCol := 0 to Min(AQuery.FieldCount-1,ASG.ColCount-1) do begin
                ASG.Cells[iCol,iRow]    := AQuery.Fields[iCol].AsString;
            end;
            //
            AQuery.Next;

            //如果已达末尾，则退出
            if AQuery.Eof then begin
                break;
            end;
        end;
    end;

    //默认指定第一条记录
    AQuery.First;

    //恢复事件
    ATrackBar.Position  := APage;
    ATrackBar.OnChange  := oEvent;
    //FreeAndNil(oEvent);

    //恢复原Recno
    AQuery.RecNo    := iOldRecNo;
    AQuery.EnableControls;


end;

end.

