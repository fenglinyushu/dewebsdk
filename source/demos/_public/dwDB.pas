unit dwDB;

{
DeWeb DataBase Unit
说明： 主要用于DeWeb的数据库操作
}

interface

uses
    dwBase,
    Vcl.DBGrids,ADODB,DB,
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
    SynCommons,
    Math,
    Types,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids;



//根据表名，生成多字段查询的WHERE字符串, 支持一次查询 多个关键词(多个关键词之间用空格分开)
//返回值 ： WHERE ( ((name like '%west%') or (memo like '%west%')) and ((name like '%wind%') or (memo like '%wind%')) )
function dwGetWhere(
        AFields     : string;           //字段列表  = '*'或'Name,Age,job,title'
        AKeyword    : String
        ):string;


//根据表名、字段名、条件，排序，拟读取的起始记录位置，拟读取的记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure dwGetData(
        AQuery:TFDQuery;       //对应的FDQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        AFirst:Integer;         //拟读取的记录位置,从1开始
        ACount:Integer          //拟读取的记录数
        );

//根据表名,字段名，将当前字段的信息生成到ComboBox中
function dwGetComboBoxItems(
        AQuery      : TFDQuery;
        ATable      : string;           //表名
        AField      : string;           //字段，例如：Name
        AEmpty      : Boolean;          //是否支持空值
        AComboBox   : TComboBox
        ):Integer;

//根据表名,字段名，将当前字段的信息生成到ComboBox中
function dwGetDISTINCTComboBoxItems(
        AQuery      : TFDQuery;
        ATable      : string;           //表名
        AField      : string;           //字段，例如：Name
        AComboBox   : TComboBox;
        const AOrder    : String = ''
        ):Integer;

//根据表名,字段名，将当前字段的信息生成到JSON数组中，形如["aaa","BBBB"]
function dwGetItemsJSON(
        AQuery      : TFDQuery;
        ATable      : string;           //表名
        AField      : string            //字段，例如：Name
        ):variant;


procedure dwDBGridAppend(ACtrl:TDBGrid;AValues:Array of String);

//根据数据表（关键字段为UniqueIdentifier类型）创建TreeView
function dwDBUniqueIdentifierToTreeView(ATV:TTreeView;AQuery:TFDQuery;ATable,AID,APID,AName:String):Integer;


implementation

//根据数据表（关键字段为UniqueIdentifier类型）创建TreeView
function dwDBUniqueIdentifierToTreeView(ATV:TTreeView;AQuery:TFDQuery;ATable,AID,APID,AName:String):Integer;
type
    PMyRc = ^TMyRc;
    TMyRc = Record
        id      : string;
    end;
var
    oParentNode : TTreeNode;
    iItem       : Integer;
    sParentID   : string;
    sID         : string;
    sName       : string;
    //
    p           : PMyRc;
begin
    Result  := 0;
    //
    try

        //
        ATV.Items.Clear;
        AQuery.Close;
        AQuery.SQL.Text  := 'SELECT ['+AId+'],['+APID+'],['+AName+'] FROM '+ATable;
        AQuery.Open;
        AQuery.First;
        //
        while not AQuery.Eof do  begin
            //
            sId         := AQuery.Fields[0].Asstring;
            sParentId   := AQuery.Fields[1].Asstring;
            sName       := AQuery.Fields[2].Asstring;

            //
            oParentNode := Nil;
            for iItem := ATV.Items.Count-1 downto 0 do begin
                if Pmyrc(ATV.Items[iItem].Data)^.id = sParentId then begin
                    oParentNode := ATV.Items[iItem];
                    break;
                end;
            end;
            if oParentNode = nil then begin
                sParentId   := '{00000000-0000-0000-0000-000000000000}';
            end;

            New(p);
            P.id    := sId;

            //
            AQuery.Next;
        end;
    except
        Result  := -1;
    end;
end;


procedure dwDBGridAppend(ACtrl:TDBGrid;AValues:Array of String);
var
    sJS         : string;
    I           : Integer;
begin
    //如果无DataSet，则退出
    if ( ACtrl.DataSource = nil ) or ( ACtrl.DataSource.DataSet = nil ) or ( ACtrl.DataSource.DataSet.Active = False ) then begin
        Exit;
    end;

    //生成JS代码中基础控制语句
    sJS     := 'this.'+dwFullName(ACtrl)+'__dvv=false;'
            +'this.'+dwFullName(ACtrl)+'__hov="0px";'
            +'this.'+dwFullName(ACtrl)+'__rnt="0px";'
            +'this.'+dwFullName(ACtrl)+'__sed=true;';

    //生成数据默认值
    for I := 0 to High(AValues) do begin
        sJS := sJS + 'this.'+dwFullName(ACtrl)+'__fd'+IntToStr(I)+'="'+String(AValues[I])+'";'
    end;
    for I := Length(AValues) to ACtrl.DataSource.DataSet.FieldCount-1 do begin
        sJS := sJS + 'this.'+dwFullName(ACtrl)+'__fd'+IntToStr(I)+'="";'
    end;

    //执行JS
    dwRunJS(sJS,TForm(ACtrl.Owner));
end;

//根据表名、字段名、条件，排序，拟读取的起始记录位置，拟读取的记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure dwGetData(
        AQuery:TFDQuery;       //对应的FDQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        AFirst:Integer;         //拟读取的记录位置,从1开始
        ACount:Integer          //每页显示的记录数
        );
var
    S0      : String;   //用于生成拟排除的ID查询
begin
    AQuery.Close;
    if AFirst <= 1 then begin
        AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    end else begin
        //先取得AFirst记录位置以前的记录的查询语句
        S0 := 'SELECT TOP '+IntToStr(AFirst-1)+' id FROM '+ATable+' '+AWhere+' '+AOrder;
        if Trim(AWhere) = '' then begin
            AQuery.SQL.Text   := 'SELECT TOP '+IntToStr(ACount)+' '+AFields+' FROM '+ATable+' WHERE (id NOT IN ('+S0+')) '+AOrder;
        end else begin
            AQuery.SQL.Text   := 'SELECT TOP '+IntToStr(ACount)+' '+AFields+' FROM '+ATable+' '+AWhere+' AND (id NOT IN ('+S0+')) '+AOrder;
        end;
    end;
    AQuery.Open;

end;



function dwGetWhere(
        AFields     : string;          //字段列表  = '*'或'Name,Age,job,title'
        AKeyword    : String
        ):string;
var
    sKeywords   : TStringDynArray;  //关键字列表，以空格隔开
    sFields     : TStringDynArray;  //字段名列表，以逗号隔开
    iPos        : Integer;
    iKey        : Integer;
    iField      : Integer;
begin
    if Trim(AKeyword)='' then begin
        Result  := ' WHERE (1=1) ';
    end else begin
        //拆分出多个关键字。 如查询 ”delphi 控件开发“
        SetLength(sKeywords,0);
        AKeyword    := Trim(AKeyword);
        while AKeyword<>'' do begin
            iPos := Pos(' ',AKeyword);
            if iPos>0 then begin
                SetLength(sKeywords,Length(sKeywords)+1);
                sKeywords[High(sKeywords)]    := Trim(Copy(AKeyword,1,iPos-1));
                //
                Delete(AKeyword,1,iPos);
                AKeyword    := Trim(AKeyword);
            end else begin
                SetLength(sKeywords,Length(sKeywords)+1);
                sKeywords[High(sKeywords)]    := AKeyword;
                //
                break;
            end;
        end;

        //拆分出多个字段名。 如”Name,Age,Addr“
        SetLength(sFields,0);
        AFields    := Trim(AFields);
        while AFields<>'' do begin
            iPos := Pos(',',AFields);
            if iPos>0 then begin
                SetLength(sFields,Length(sFields)+1);
                sFields[High(sFields)]    := Trim(Copy(AFields,1,iPos-1));
                //
                Delete(AFields,1,iPos);
                AFields    := Trim(AFields);
            end else begin
                SetLength(sFields,Length(sFields)+1);
                sFields[High(sFields)]    := AFields;
                //
                break;
            end;
        end;

        //得到字段名
        Result  := ' WHERE (';
        for iKey := 0 to High(sKeywords) do begin
            Result  := Result +'(';
            for iField := 0 to High(sFields) do begin
                //不查询iD字段
                if lowerCase(sFields[iField])='id' then begin
                    Continue;
                end;
                //
                Result  := Result + sFields[iField] +' like ''%'+sKeywords[iKey]+'%'' OR '
            end;
            Delete(Result,Length(Result)-3,4);
            Result  := Result +') AND ';
        end;
        Delete(Result,Length(Result)-3,4);
        //
        Result  := Result + ')';
    end;

end;


function dwGetComboBoxItems(
        AQuery      : TFDQuery;
        ATable      : string;           //表名
        AField      : string;           //字段，例如：Name
        AEmpty      : Boolean;          //是否支持空值
        AComboBox   : TComboBox
        ):Integer;
var
    iRec    : Integer;
begin
    //得到字段名
    AQuery.Close;
    AQuery.SQL.Text := 'SELECT '+AField+' FROM '+ATable;
    AQuery.Open;
    AComboBox.Items.Clear;
    if AEmpty then begin
        AComboBox.Items.Add('');
    end;
    for iRec := 0 to AQuery.RecordCount-1 do begin
        AComboBox.Items.Add(AQuery.Fields[0].AsString);
        //
        Aquery.Next;
    end;
    if AComboBox.Items.Count>0 then begin
        AComboBox.ItemIndex := 0;
    end;
    //
    Result  := 0;
end;

function dwGetDISTINCTComboBoxItems(
        AQuery      : TFDQuery;
        ATable      : string;           //表名
        AField      : string;           //字段，例如：Name
        AComboBox   : TComboBox;
        const AOrder    : String = ''
        ):Integer;
var
    iRec    : Integer;
begin
    //得到字段名
    AQuery.Close;
    if AOrder = '' then begin
        AQuery.SQL.Text := 'SELECT DISTINCT '+AField+' FROM '+ATable;
    end else begin
        //此处后续还需要继续完善! 以支持多字段及DESC
        AQuery.SQL.Text := 'SELECT DISTINCT '+AField+','+AOrder+' FROM '+ATable+' ORDER By '+AOrder;
    end;
    AQuery.Open;
    AComboBox.Items.Clear;
    for iRec := 0 to AQuery.RecordCount-1 do begin
        AComboBox.Items.Add(AQuery.Fields[0].AsString);
        //
        Aquery.Next;
    end;
    if AComboBox.Items.Count>0 then begin
        AComboBox.ItemIndex := 0;
    end;
    //
    Result  := 0;
end;


//根据表名,字段名，将当前字段的信息生成到JSON数组中，形如["aaa","BBBB"]
function dwGetItemsJSON(
        AQuery      : TFDQuery;
        ATable      : string;           //表名
        AField      : string            //字段，例如：Name
        ):variant;
var
    iRec    : Integer;
begin
    //得到字段名
    AQuery.Close;
    AQuery.SQL.Text := 'SELECT DISTINCT '+AField+' FROM '+ATable;
    AQuery.Open;

    Result  := _Json('[]');
    for iRec := 0 to AQuery.RecordCount-1 do begin
        Result.Add(AQuery.Fields[0].AsString);
        //
        Aquery.Next;
    end;
end;


end.
