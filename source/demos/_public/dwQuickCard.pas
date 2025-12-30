unit dwQuickCard;
{
}

interface
uses
    //
    dwBase,

    //
    CloneComponents,

    //dwAccess,
    //
    SynCommons{用于解析JSON},
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
    Vcl.ButtonGroup,
    Math,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;

//一键生成Card模块
function  dwCard(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

procedure qaUpdate(AForm:TForm;AWhere:String);

//取QuickCard模块的 FDQuery 控件 未找到返回空值
function qaGetFDQuery(AForm:TForm):TFDQuery;

//取QuickCard模块的SQL语句 未找到返回空值
function qaGetSQL(AForm:TForm):String;

//取得控件的quickcard配置JSON
function qaGetConfigJson(AForm:TForm):Variant;

function qaAppend(
    AForm:TForm;        //控件所在窗体
    APrefix:String;     //控件名称的前缀，用于查找控件
    AQuery:TFDQuery;    //数据查询
    AFields:Variant
    ):Integer;

implementation

function _HaveList(AField:Variant;ACount:Integer):Boolean;
begin
    Result  := False;
    if AField <> unassigned then begin
        if AField.Exists('list') then begin
            if AField.list <> null then begin
                Result  := AField.list._Count >= ACount;
            end;
        end;
    end;
end;

function _GetConfig(AForm:TForm):String;
var
    oRC : TRttiContext;
    oRT : TRttiType;
    oRF : TRttiField;
begin
    //
    Result  := unassigned;
    //
    try
        oRC := TRttiContext.Create;
        oRT := oRC.GetType(AForm.ClassType);
        oRF := oRT.GetField('qaConfig');
        if oRF <> nil then begin
            Result  := oRF.GetValue(AForm).AsString;
        end;
    finally
        oRC.Free;
    end;
end;

function _GetFieldValue(AField:TField;AConfig:Variant):String;
begin
    Result  := '';
    if AConfig = unassigned then begin
        Exit;
    end;
    if AField.IsNull then begin
        Exit;
    end;
    if not AConfig.Exists('type') then begin
        AConfig.type    := 'string';
    end;

    //
    if AConfig.type = 'integer' then begin
        Result  := IntToStr(AField.AsInteger);
    end else if AConfig.type = 'boolean' then begin
        if AConfig.Exists('list') then begin
            if AConfig.list._Count>1 then begin
                if AField.AsBoolean then begin
                    Result  := AConfig.list._(1);
                end else begin
                    Result  := AConfig.list._(0);
                end;;
            end else begin
                Result  := AField.AsString;
            end;
        end else begin
            Result  := AField.AsString;
        end;
            Result  := AField.AsString;
    end else if AConfig.type = 'check' then begin
        Result  := '';
    end else if AConfig.type = 'date' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            if Trunc(AField.AsDateTime) = 0 then begin
                Result  := '';
            end else begin
                Result  := FormatDatetime('yyyy-MM-dd',AField.AsDateTime);
            end;
        end;
    end else if AConfig.type = 'time' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            Result  := FormatDatetime('hh:mm:ss',AField.AsDateTime);
        end;
    end else if AConfig.type = 'datetime' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            if Trunc(AField.AsDateTime) = 0 then begin
                Result  := '';
            end else begin
                Result  := FormatDatetime('yyyy-MM-dd hh:mm:ss',AField.AsDateTime);
            end;
        end;
    end else if AConfig.type = 'money' then begin
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsFloat]);
        end else begin
            Result  := Format('%n',[AField.AsFloat]);
        end;
    end else begin
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsString]);
        end else begin
            Result  := AField.AsString;
        end;
    end;
end;


function _GetFilter(AForm:TForm):String;
var
    oPFi        : TPanel;
    oCFi        : TCardPanel;
    oCF         : TCard;
    oFF         : TFlowpanel;
    oBF         : TButton;
    //
    iItem       : Integer;
    iCtrl       : Integer;
    iField      : Integer;
    iList       : Integer;
    sName       : String;
    sCFFilter   : String;   //
    sCaption    : string;
    bFound      : Boolean;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    Result      := '';

    //取得筛选总面板
    oPFi        := TPanel(AForm.FindComponent('PFi'));

    //如果未筛选，则退出
    if oPFi  = nil then begin
        Exit;
    end;

    if oPFi.Tag = 0 then begin
        Exit;
    end;

    //取得Config的JSON
    joConfig    := qaGetConfigJson(AForm);

    //
    oCFi        := TCardPanel(AForm.FindComponent('CFi'));

    //置所有选项未选中状态
    for iItem := 0 to OCFi.CardCount - 1 do begin
        //得到当前card
        oCF     := oCFi.Cards[iItem];

        //从Name中取得字段序号
        sName   := oCF.Name;
        iField  := StrToIntDef(Copy(sName,3,3),-1);

        //异常处理
        if iField = -1 then begin
            Continue;
        end;

        //取得字段JSON
        joField := joConfig.fields._(iField);

        //字段名称
        sName   := joField.name;

        //默认当前字段的筛选
        sCFFilter   := '';
        //取得筛选项的容器FlowPanel
        oFF     := TFlowPanel(oCF.Controls[0]);
        for iCtrl := 0 to oFF.ControlCount - 1 do begin
            //取得筛选项 BFx - button filter
            oBF := TButton(oFF.Controls[iCtrl]);

            //如果当前筛选项选中，则添加到where字符串
            if oBF.Tag = 1 then begin
                if joField.type = 'boolean' then begin
                    //先检查是否有合法的list： 有且Count>=2
                    bFound  := _HaveList(joField,2);

                    //根据是否有合法的list，分别处理
                    if bFound then begin
                        if oBF.Caption = joField.list._(0) then begin
                            sCFFilter   := sCFFilter+'('+sName+'=0)or';
                        end else if oBF.Caption = joField.list._(1) then begin
                            sCFFilter   := sCFFilter+'('+sName+'=1)or';
                        end;
                    end else begin
                        sCaption    := lowercase(oBF.Caption);
                        if (sCaption = 'false') or (sCaption = 'f') or (sCaption = 'n') then begin
                            sCFFilter   := sCFFilter+'('+sName+'=0)or';
                        end else if (sCaption = 'true') or (sCaption = 't') or (sCaption = 'y') then begin
                            sCFFilter   := sCFFilter+'('+sName+'=1)or';
                        end;
                    end;
                end else begin
                    sCFFilter   := sCFFilter+'('+sName+'='''+oBF.Caption+''')or';
                end;
            end;
        end;

        //处理最后的'or'
        if Length(sCFFilter) > 1 then begin
            Delete(sCFFilter,Length(sCFFilter)-1,2);
            Result  := Result + '('+sCFFilter+')and';
        end;
    end;
    //处理最后的'and'
    if Length(Result) > 1 then begin
        Delete(Result,Length(Result)-2,3);
    end;

end;



//从TImage的Hint中取得文件名，不包括目录
function  _GetImageValue(AImage:TImage):String;
var
    joHint  : Variant;
begin
    Result  := '';
    joHint  := _json(AImage.Hint);
    if joHint <> unassigned then begin
        Result  := joHint.src;
        while Pos('/',Result)>0 do begin
            Delete(Result,1,Pos('/',Result));
        end;
        while Pos('\',Result)>0 do begin
            Delete(Result,1,Pos('\',Result));
        end;
    end;
end;



//根据表名、字段名，生成选项JSON数组
function _GetItems(
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

function _GetOrder(AForm:TForm):String;
var
    joConfig    : Variant;
    joField     : Variant;
    iField      : Integer;
    oCSo        : TCombobox;    //combobox sort
    sCaption    : String;       //排序的标题
    sName       : string;       //排序标题对应的字段名
    sOrder      : String;       //正序或反序
begin
    Result      := '';

    //
    joConfig    := qaGetConfigJson(AForm);

    //取得控件
    oCSo        := TComboBox(AForm.FindComponent('CSo'));

    //
    if oCSo <> nil then begin
        if oCSo.ItemIndex > 0 then begin
            sCaption    := oCSo.Text;
            sOrder      := Copy(sCaption,Length(sCaption),1);
            sCaption    := Copy(sCaption,1,Length(sCaption)-2);
            //
            sName   := '';
            for iField := 0 to joConfig.fields._Count - 1 do begin
                joField := joConfig.fields._(iField);
                if sCaption = String(joField.caption) then begin
                    sName   := joField.name;
                    break;
                end;
            end;

            //
            if sName <> '' then begin
                Result  := ' ORDER BY '+sName;
                if sOrder = '↓' then begin
                    Result  := Result + ' DESC';
                end;
            end;
        end;
    end;

end;

//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure _GetPageData(
        AQuery:TFDQuery;       //对应的ADOQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        APage:Integer;          //当前页码,从1开始
        ACount:Integer;         //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );
var
    S0  : String;
    iError  : Integer;
begin
    try
        iError      := 0;   //用于检查错误

        //----求总数------------------------------------------------------------------------------------
        AQuery.FetchOptions.RecsSkip    := 0;
        AQuery.FetchOptions.RecsMax     := -1;

        AQuery.Close;
        AQuery.SQL.Text := 'SELECT Count(*) FROM '+ATable+' '+AWhere;
        AQuery.Open;

        iError      := 1;   //用于检查错误

        //记录总数
        ARecordCount    := AQuery.Fields[0].AsInteger;

        //如果超出最大页数,则为最大页数
        if APage > Ceil(ARecordCount / ACount) then begin
            APage   := Ceil(ARecordCount / ACount);
        end;

        //强制APage 从0开始
        APage   := Max(0,APage);

        //----更新当前页--------------------------------------------------------------------------------

        iError      := 2;   //用于检查错误

        AQuery.Close;

        //<2023-04-13 改成的FireDAC的机制
        AQuery.SQL.Text := 'SELECT '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
        AQuery.FetchOptions.RecsSkip    := APage * ACount;
        AQuery.FetchOptions.RecsMax     := ACount;
        //>

        //
        AQuery.Open;
        iError      := 3;   //用于检查错误

    except
        ShowMessage('Error when _GetPageData at '+IntToStr(iError));
    end;
end;

function _GetWhere(
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

//检查字段是否有足够数据量的list

//通过rtti为form的 qaConfig 变量 赋值
function _SetConfig(AForm:TForm;AConfig:String):Integer;
var
    oRC : TRttiContext;
    oRT : TRttiType;
    oRF : TRttiField;
begin
    //
    Result  := 0;
    //
    try
        oRC := TRttiContext.Create;
        oRT := oRC.GetType(AForm.ClassType);
        oRF := oRT.GetField('qaConfig');
        if oRF <> nil then begin
            oRF.SetValue(AForm,AConfig);
        end else begin
            Result  := -1;
        end;
    finally
        oRC.Free;
    end;
end;


//设置控件的Left/width/Right和Top/height/bottom
function _SetLwrThb(AControl:TControl;AField:Variant;AOldLeft,AOldTop,AOldHeight:Integer):Integer;
var
    bL,bW,bR    : boolean;
    bT,bH,bB    : Boolean;
begin
    Result  := 0;

    //
    bL  := AField.Exists('left');
    bW  := AField.Exists('width');
    bR  := AField.Exists('right');
    bT  := AField.Exists('top');
    bH  := AField.Exists('height');
    bB  := AField.Exists('bottom');

    //
    try
        //处理left/width/right
        if bL then begin
            AControl.Left   := AField.left;
            if bR then begin
                AControl.Anchors    := [akleft,akRight];
                AControl.Width      := TPanel(AControl.Parent).Width - AField.left - AField.right;
            end else if bW then begin
                AControl.Width      := AField.width;
            end else begin
                AControl.Width      := 200; //默认值
            end;
        end else begin
            if bR then begin
                if bW then begin
                    AControl.Anchors:= [akRight];
                    AControl.Width  := AField.width;
                    AControl.Left   := TPanel(AControl.Parent).Width - AControl.Width - AField.right;
                end else begin
                    AControl.Anchors:= [akLeft,akRight];
                    AControl.Left   := AOldLeft;  //默认值
                    AControl.Width  := TPanel(AControl.Parent).Width - AControl.Left - AField.right;
                end;
            end else if bW then begin
                AControl.Left       := AOldLeft;  //默认值
                AControl.Width      := AField.width;
            end else begin
                AControl.Left       := AOldLeft;  //默认值
                AControl.Width      := 200; //默认值
            end;
        end;

        //处理top/width/right
        if bT then begin
            AControl.Top    := AField.top;
            if bB then begin
                AControl.Anchors    := AControl.Anchors + [aktop,akbottom];
                AControl.height     := TPanel(AControl.Parent).height - AField.top - AField.bottom;
            end else if bH then begin
                AControl.height     := AField.height;
            end else begin
                AControl.height     := Round((TLabel(AControl).Font.Size+3)*1.5); //默认值
            end;
        end else begin
            if bB then begin
                if bH then begin
                    AControl.Anchors:= AControl.Anchors + [akbottom];
                    AControl.height := AField.height;
                end else begin
                    AControl.Anchors:= AControl.Anchors + [akTop,akbottom];
                    AControl.height := Round((TLabel(AControl).Font.Size+3)*1.5); //默认值
                end;
                AControl.top   := TPanel(AControl.Parent).height - AControl.height - AField.bottom;
            end else if bH then begin
                AControl.top        := AOldTop + AOldHeight;  //默认值
                AControl.height     := AField.height;
            end else begin
                AControl.top        := AOldTop + AOldHeight;  //默认值
                AControl.height     := Round((TLabel(AControl).Font.Size+3)*1.5); //默认值
            end;
        end;
    except
        Result  := -1;
    end;
end;
//删除按钮事件 BDx - button delete index
procedure BDxClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oButton     : TButton;
    oPDQ        : TPanel;   //panel delete query
    oLabel      : TLabel;
    oFQu        : TFDQuery;
    //
    iRecNo      : Integer;
    iField      : Integer;
    sName       : string;
    sInfo       : string;
begin
    //主表的删除事件。
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPDQ    := TPanel(oForm.FindComponent('PDQ'));
    oFQu    := TFDQuery(oForm.FindComponent('FQu'));

    //从按钮名称中取得数据表的记录号
    sName   := oButton.Name;    //如；BD1,BD2,.. 从1开始
    iRecNo  := StrToIntDef(Copy(sName,3,3),-1);

    //异常处理
    if iRecNo <= 0 then begin
        dwMessage('except when BDxClick','',TForm(TEdit(Sender).Owner));
        Exit;
    end;


    //取得当前拟删除记录信息
    oFQu.RecNo  := iRecNo;
    sInfo   := '';
    for iField := 0 to Min(2,oFQu.FieldCount-1) do begin
        sInfo   := sInfo + ''+oFQu.Fields[iField].AsString+' | ';
    end;
    sInfo   := Copy(sInfo,1,Length(sInfo)-3);

    //
    oPDQ.Caption    := '确定要删除当前数据记录 “'+sInfo+'” 吗?';
    oPDQ.Visible    := True;
end;


procedure BECClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPEd        : TPanel;
    //
    iSlave      : Integer;
begin
    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));
    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEd        := TPanel(oForm.FindComponent('PEd'));

    //用 P_Editor 的tag来标记当前状态，
    oQuery  := TFDQuery(oForm.FindComponent('FQu'));
    oQuery.Cancel;
    //
    oPEd.Visible    := False;

    //更新显示（仅tag=999时，此时表示已批量增加）
    if oButton.Tag = 999 then begin
        oButton.Tag := 0;
        //用 P_Editor 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oPEd.Tag of
            0,100 : begin
                qaUpdate(oForm,'');
            end;
        end;
    end;
end;


procedure BEOClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oQueryTmp   : TFDQuery;
    oSQuery     : TFDQuery;
    oB_ECancel  : TButton;
    oP_Editor   : TPanel;
    oI_Field    : TImage;
    oE_Field    : TEdit;
    oDT_Field   : TDateTimePicker;
    oComp       : TComponent;
    oCB_Field   : TComboBox;
    oCB         : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    oCK_EBatch  : TCheckBox;
    //
    iField      : Integer;
    iItem       : Integer;
    //
    bAccept     : Boolean;
    //
    sMValue     : string;   //主表的关键字段值
    sOldValue   : string;   //编辑前字段值，用于防重
    //
    joConfig    : variant;
    joField     : Variant;
begin


    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));
    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Editor   := TPanel(oForm.FindComponent('PEd'));
    oB_ECancel  := TButton(oForm.FindComponent('B_ECancel'));   //取消按钮，用于记录是否批量新增过
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CBa'));

    //取得Query备用
    oQueryTmp   := TFDQuery(oForm.FindComponent('FDQueryTmp'));

    //<保存前激活Form的OnDragDrop事件
    if Assigned(oForm.OnDragDrop) then begin
        oForm.OnDragDrop(oForm,nil,oP_Editor.Tag,0)
    end;
    //>


    //取得配置JSON对象
    joConfig    := _json(_GetConfig(oForm));
    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oP_Editor.Tag of
        0 : begin   //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQu'));
            //更新数值
            oQuery.Edit;
            for iField := 0 to joConfig.fields._Count -1 do begin

                //得到字段JSON对象
                joField := joConfig.fields._(ifield);

                //保存当前字段值，以用于防重
                sOldValue   := oQuery.Fields[iField].AsString;

                //
                oComp   := oForm.FindComponent('Fi'+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'boolean' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsBoolean := (oCB_Field.ItemIndex = 1);
                end else if joField.type = 'check' then begin
                    Continue;
                end else if joField.type = 'combo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'dbcombo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'image' then begin
                    oI_Field    := TImage(oComp);
                    oQuery.Fields[iField].AsString := _GetImageValue(oI_Field);
                end else if joField.type = 'integer' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
                end else if joField.type = 'date' then begin
                    oDT_Field   := TDateTimePicker(oComp);
                    oQuery.Fields[iField].AsDateTime    := oDT_Field.Date;
                end else if joField.type = 'time' then begin
                    oDT_Field   := TDateTimePicker(oComp);
                    oQuery.Fields[iField].AsDateTime    := oDT_Field.Time;
                end else if joField.type = 'datetime' then begin
                    oDT_Field   := TDateTimePicker(oComp);
                    oQuery.Fields[iField].AsDateTime    := oDT_Field.DateTime;
                end else if joField.type = 'money' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToFloatDef(oE_Field.text,0);
                end else begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsString := oE_Field.text;
                end;
                //检查是否为必填字段
                if joField.Exists('must') then begin
                    if joField.must = 1 then begin
                        if oQuery.Fields[iField].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;
                end;

                //检查防重
                if joField.Exists('unique') then begin
                    if joField.unique = 1 then begin
                        oQueryTmp.Close;
                        if oQuery.Fields[iField].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                            ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                        then begin
                            oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                    +' WHERE '+joField.name+'='+oQuery.Fields[iField].AsString;
                        end else begin
                            oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                    +' WHERE '+joField.name+'='''+oQuery.Fields[iField].AsString+'''';
                        end;
                        oQueryTmp.Open;

                        //根据当前字段是否更改分别处理
                        if sOldValue = oQuery.Fields[iField].AsString then begin
                            if oQueryTmp.Fields[0].AsInteger > 1 then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                oQuery.Cancel;
                                Exit;
                            end;
                        end else begin
                            if oQueryTmp.Fields[0].AsInteger > 0 then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                oQuery.Cancel;
                                Exit;
                            end;
                        end;
                    end;
                end;
            end;
            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;
            //关闭伪窗体
            oP_Editor.Visible  := False;
        end;
        100 : begin   //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQu'));
            //更新数值
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);
                //
                oComp   := oForm.FindComponent('Fi'+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'boolean' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsBoolean := (oCB_Field.ItemIndex = 1);
                end else if joField.type = 'check' then begin
                    Continue;
                end else if joField.type = 'combo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'dbcombo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'image' then begin
                    oI_Field    := TImage(oComp);
                    oQuery.Fields[iField].AsString := _GetImageValue(oI_Field);
                end else if joField.type = 'integer' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
                end else if joField.type = 'date' then begin
                    oDT_Field   := TDateTimePicker(oComp);
                    oQuery.Fields[iField].AsDateTime    := oDT_Field.Date;
                end else if joField.type = 'time' then begin
                    oDT_Field   := TDateTimePicker(oComp);
                    oQuery.Fields[iField].AsDateTime    := oDT_Field.Time;
                end else if joField.type = 'datetime' then begin
                    oDT_Field   := TDateTimePicker(oComp);
                    oQuery.Fields[iField].AsDateTime    := oDT_Field.DateTime;
                end else if joField.type = 'money' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToFloatDef(oE_Field.text,0);
                end else begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsString := oE_Field.text;
                end;

                //检查是否为必填字段
                if joField.Exists('must') then begin
                    if joField.must = 1 then begin
                        if oQuery.Fields[iField].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;
                end;

                //检查防重
                if joField.Exists('unique') then begin
                    if joField.unique = 1 then begin
                        oQueryTmp.Close;
                        if oQuery.Fields[iField].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                            ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                        then begin
                            oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                    +' WHERE '+joField.name+'='+oQuery.Fields[iField].AsString;
                        end else begin
                            oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                    +' WHERE '+joField.name+'='''+oQuery.Fields[iField].AsString+'''';
                        end;
                        oQueryTmp.Open;
                        if oQueryTmp.Fields[0].AsInteger > 0 then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                            Exit;
                        end;
                    end;
                end;
            end;
            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;

            //如果选中的“批量录入”，则重新append, 否则关闭退出
            if oCK_EBatch.Checked then begin
                //做标记
                oB_ECancel.Tag  := 999;

                //自动新增
                qaAppend(oForm,
                    'Fi'+'0',
                    oQuery,
                    joConfig.fields
                    );
            end else begin
                //关闭伪窗体
                oP_Editor.Visible  := False;
            end;
        end;
    end;
    //更新显示（仅关闭编辑/新增面板时）
    if not oP_Editor.Visible then begin
        //用 P_Editor 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oP_Editor.Tag of
            0,100 : begin
                qaUpdate(oForm,'');
            end;
        end;
    end;

    //<保存后激活Form的OnDragOver事件
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,oP_Editor.Tag,0,TDragState(0),bAccept)
    end;
    //>
end;

//编辑按钮事件 BEx - Button Edit index
procedure BExClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oBEx        : TButton;      //编辑按钮
    oPEd        : TPanel;       //编辑总面板
    oBET        : TButton;      //编辑面板的标题；编辑/新增
    oFQu        : TFDQuery;     //数据表
    oComp       : TComponent;
    oE          : TEdit;
    oI          : TImage;
    oDT         : TDateTimePicker;
    oCB         : TComboBox;
    oCBa        : TCheckBox;    //批量输入
    //
    iItem       : Integer;
    iRecNo      : Integer;
    sType       : String;
    sValue      : String;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //取得各控件
    oBEx        := TButton(Sender);
    oForm       := TForm(oBEx.Owner);
    oPEd        := TPanel(oForm.FindComponent('PEd'));
    oBET        := TButton(oForm.FindComponent('BET'));
    oFQu        := TFDQuery(oForm.FindComponent('FQu'));
    oCBa        := TCheckBox(oForm.FindComponent('CBa'));

    //编辑状态下隐藏’批量输入‘
    oCBa.Visible    := False;

    //设置当前为”编辑“状态
    oBET.Caption    := '编  辑';

    //用 oPEd 的tag来标记当前状态，0   表示编辑,  100表示新增
    oPEd.Tag    := 0;

    //取得joConfig
    joConfig    := qaGetConfigJson(oForm);

    //从按钮名称中取得数据记录号
    iRecNo      := StrToIntDef(Copy(oBEx.Name,3,3),-1);

    //异常处理
    if iRecNo = -1 then begin
        dwMessage('except when BExClick!','',TForm(TEdit(Sender).Owner));
        Exit;
    end;

    //更新字段值
    oFQu.RecNo  := iRecno;
    for iItem := 0 to oFQu.FieldCount-1 do begin
        joField := joConfig.fields._(iItem);
        oComp   := oForm.FindComponent('Fi'+IntToStr(iItem));
        //异常处理
        if oComp = nil then begin
            Continue;
        end;

        //取字段的AsString，并清除其中的特殊字符串（如换行），备用
        sValue  := oFQu.Fields[iItem].AsString;
        sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
        sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

        //
        sType   := joField.type;
        if sType = 'boolean' then begin
            if joField.Exists('list') then begin
                oCB         := TComboBox(oComp);
                if oFQu.Fields[iItem].AsBoolean then begin
                    oCB.Text    := joField.list._(1);
                end else begin
                    oCB.Text    := joField.list._(0);
                end;
            end else begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end;
        end else if sType = 'check' then begin
            Continue;
        end else if sType = 'combo' then begin
            oCB         := TComboBox(oComp);
            oCB.Text    := sValue;
        end else if sType = 'dbcombo' then begin
            oCB         := TComboBox(oComp);
            oCB.Text    := sValue;
        end else if sType = 'image' then begin
            oI          := TImage(oComp);
            if joField.Exists('imgdir') then begin
                sValue  := joField.imgdir + sValue;
            end;
            oI.Hint     := '{"dwstyle":"border-radius:3px;","src":"'+sValue+'"}';
        end else if sType = 'integer' then begin
            oE          := TEdit(oComp);
            oE.Text     := sValue;
        end else if sType = 'date' then begin
            oDT         := TDateTimePicker(oComp);
            oDT.Kind    := dtkDate;
            if oFQu.Fields[iItem].IsNull then begin
                oDT.Date    := StrToDate('1899-12-30');
            end else begin
                oDT.Date    := oFQu.Fields[iItem].AsDateTime;
            end;
        end else if sType = 'time' then begin
            oDT         := TDateTimePicker(oComp);
            oDT.Kind    := dtkTime;
            if oFQu.Fields[iItem].IsNull then begin
                oDT.Time    := StrToTime('00:00:00');
            end else begin
                oDT.Time    := oFQu.Fields[iItem].AsDateTime;
            end;
        end else if sType = 'datetime' then begin
            oDT         := TDateTimePicker(oComp);
            if oFQu.Fields[iItem].IsNull then begin
                oDT.Date    := StrToDate('1899-12-30');
            end else begin
                oDT.Date    := oFQu.Fields[iItem].AsDateTime;
            end;
        end else if sType = 'money' then begin
            oE          := TEdit(oComp);
            oE.Text     := oFQu.Fields[iItem].AsString;
        end else begin
            oE          := TEdit(oComp);
            oE.Text     := oFQu.Fields[iItem].AsString;
        end;

        //设置只读（编辑时只读，新增时如有默认值则只读，否则可编辑）
        if sType <> 'auto' then begin
            if joField.readonly = 1 then begin
                if joField.Exists('default') then begin
                    TEdit(oComp).Enabled    := False;
                end else begin
                    TEdit(oComp).Enabled    := True;
                end;
            end;
        end;
    end;

    //
    oPEd.Visible    := True;
end;

procedure BFiClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oBFi        : TButton;
    oPFi        : TPanel;
    oBET        : TButton;
    oPES        : TPanel;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oCB         : TComboBox;
    oCBa        : TCheckBox;
    oDT         : TDateTimePicker;
    //
    iItem       : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin

    //主表新增事件
    //dwMessage('B_NewClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oBFi        := TButton(Sender);
    oForm       := TForm(oBFi.Owner);
    oPFi        := TPanel(oForm.FindComponent('PFi'));
    oQuery      := TFDQuery(oForm.FindComponent('FQu'));
    //
    oPFi.Visible  := True;
end;



//筛选重置事件
procedure BFRClick(Self: TObject; Sender: TObject);     //button filter reset
var
    oButton     : TButton;
    oForm       : TForm;
    oPFi        : TPanel;
    oTBa        : TTrackBar;
    oCFi        : TCardPanel;
    oCF         : TCard;
    oFF         : TFlowpanel;
    oBF         : TButton;
    iItem       : Integer;
    iCtrl       : Integer;
begin
    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    //
    oPFi        := TPanel(oForm.FindComponent('PFi'));
    oCFi        := TCardPanel(oForm.FindComponent('CFi'));
    oTBa        := TTrackBar(oForm.FindComponent('TBa'));

    //置所有选项未选中状态
    for iItem := 0 to OCFi.CardCount - 1 do begin
        oCF     := oCFi.Cards[iItem];
        oFF     := TFlowPanel(oCF.Controls[0]);
        for iCtrl := 0 to oFF.ControlCount - 1 do begin
            oBF := TButton(oFF.Controls[iCtrl]);
            //
            oBF.Tag := 0;
            dwSetCtrlColor(oBF,clBlack);
            dwSetCtrlBKColor(oBF,$F6F6F6);
            dwSetCtrlBorder(oBF,'0');
        end;
    end;

    //
    oPFi.Visible    := False;
    oPFi.Tag        := 0;

    //
    oTBa.Position   := 0;
    qaUpdate(oForm,'');
end;


//筛选确定事件
procedure BFOClick(Self: TObject; Sender: TObject);     //button filter OK
var
    oButton     : TButton;
    oForm       : TForm;
    oPFi        : TPanel;
    oTBa        : TTrackBar;
begin
    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    //
    oPFi        := TPanel(oForm.FindComponent('PFi'));
    oTBa        := TTrackBar(oForm.FindComponent('TBa'));

    //
    oPFi.Visible    := False;
    oPFi.Tag        := 1;

    //
    oTBa.Position   := 0;
    qaUpdate(oForm,'');
end;

procedure BFxClick(Self: TObject; Sender: TObject);
var
    oBFx        : TButton;
    sFull       : String;
begin
    oBFx        := TButton(Sender);
    sFull       := dwFullName(oBFx);
    //
    if oBFx.Tag = 0 then begin
        oBFx.Tag    := 1;   //标志选中
        dwSetCtrlColor(oBFx,clRed);
        dwSetCtrlBKColor(oBFx,$E8EBFF);
        dwSetCtrlBorder(oBFx,'solid 1px #f00');
    end else begin
        oBFx.Tag    := 0;   //标志未选中
        dwSetCtrlColor(oBFx,clBlack);
        dwSetCtrlBKColor(oBFx,$F6F6F6);
        dwSetCtrlBorder(oBFx,'0');
    end;
end;



//点击筛选界面中的左侧字段按钮  ButtonGroup Filter
procedure BGFButtonClicked(Self: TObject; Sender: TObject; Index: Integer);
var
    oBGF        : TButtonGroup;
    oForm       : TForm;
    oCFi        : TCardpanel;
    //
    sName       : String;
begin
    //取得各对象
    oBGF        := TButtonGroup(Sender);
    oForm       := TForm(oBGF.Owner);
    oCFi        := TCardPanel(oForm.FindComponent('CFi'));

    oCFi.ActiveCardIndex    := Index;
end;






procedure BNeClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oBNe        : TButton;
    oPEd        : TPanel;
    oBET        : TButton;
    oPES        : TPanel;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oCB         : TComboBox;
    oCBa        : TCheckBox;
    oDT         : TDateTimePicker;
    //
    iItem       : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin

    //主表新增事件
    //dwMessage('B_NewClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oBNe        := TButton(Sender);
    oForm       := TForm(oBNe.Owner);
    oPEd        := TPanel(oForm.FindComponent('PEd'));
    oBET        := TButton(oForm.FindComponent('BET'));
    oQuery      := TFDQuery(oForm.FindComponent('FQu'));
    oCBa        := TCheckBox(oForm.FindComponent('CBa'));
    //
    oCBa.Visible    := True;

    //
    oBET.Caption   := '新  增';

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPEd.Tag  := 100;

    //
    joConfig    := _json(_GetConfig(oForm));

    //更新字段值
    qaAppend(oForm,
            'Fi',
            oQuery,
            joConfig.fields
            );
    //
    oPEd.Visible  := True;
end;

Procedure BUpClick(Self: TObject; Sender: TObject); //"图片上传"按钮 BUp - Button upload
var
    oButton     : TButton;
    oForm       : TForm;
    joHint      : Variant;
    iItem       : Integer;
    sImgDir     : String;
    sAccept     : String;
    sName       : String;
begin
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);

    joHint      := _json(oButton.Hint);

    if joHint = unassigned then begin
        dwMessage('error json when BUpClick','',oForm);
        Exit;
    end;

    if not joHint.Exists('imgdir') then begin
        dwMessage('error imgdir when BUpClick','',oForm);
        Exit;
    end;

    if not joHint.Exists('imgtype') then begin
        dwMessage('error imgtype when BUpClick','',oForm);
        Exit;
    end;

    //取得按钮名称，如：'FB'+ASuffix ，以保存当前id，用于上传完成后更新相关控件值
    sName   := oButton.Name;
    Delete(sName,1,2);
    dwSetProp(oForm,'__uploadid',sName);

    //取得图片目录
    sImgDir := joHint.imgdir;

    //取得图片类型 accept
    sAccept := '';
    for iItem := 0 to joHint.imgtype._Count - 1 do begin
        sAccept := sAccept + '.'+joHint.imgtype._(iItem)+',';
    end;
    if Length(sAccept)>0 then begin
        Delete(sAccept,Length(sAccept),1);
    end;

    //
    dwUpload(oForm, sAccept, sImgDir);
end;

procedure CSoChange(Self: TObject; Sender: TObject);
begin
    qaUpdate(TForm(TEdit(Sender).Owner),'');
end;

//Ekw - Edit keyword
procedure EKwChange(Self: TObject; Sender: TObject);
var
    oEKw        : TEdit;
    oForm       : TForm;
    oTBa        : TTrackBar;
begin
    //取得各控件
    oEKw    := TEdit(Sender);
    oForm   := TForm(oEKw.Owner);
    oTBa    := TTrackBar(oForm.FindComponent('TBa'));

    //
    oTBa.Position   := 0;

    //
    qaUpdate(TForm(TEdit(Sender).Owner),'');
end;

//上传图片成功事件
procedure FormEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    oForm       : TForm;
    oButton     : TButton;
    oImage      : TImage;
    oQuery      : TFDQuery;
    sID         : string;
    sFile       : String;
    sSource     : String;
    //
    joHint      : Variant;
    joConfig    : Variant;
    joField     : Variant;
begin
    //取得当前Form
    oForm   := TForm(Sender);

    //取得当前配置json
    joConfig    := qaGetConfigJson(oForm);

    //
    sFile   := dwGetProp(oForm,'__upload');

    //取得上传时设定的uploadid，主要是区分是哪个字段上传的图片，一般为字段序号
    sId     := dwGetProp(oForm,'__uploadid');

    //根据__uploadid取得上传按钮控件
    oButton     := TButton(oForm.FindComponent('FB'+sID));
    joHint      := _json(oButton.Hint);

    //如果设置，则自动生成缩略图
    try
        joField     := joConfig.fields._(StrToIntDef(sID,0));

        //
        if joField.type = 'image' then begin
            if dwGetInt(joField,'thumbnail',0)=1 then begin

            end;
        end;
    except

    end;

    //找到该图片显示的Timage
    oImage      := TImage(oForm.FindComponent('Fi'+sID));
    oImage.Hint := '{"src":"'+joHint.imgdir+sFile+'"}';
end;


//panel delete Cancel
procedure PDCClick(Self: TObject; Sender: TObject);
var
    oButton : TButton;
    oForm   : TForm;
    oPanel  : TPanel;
begin
    //dwMessage('B_DCancelClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('PDQ'));
    //关闭面板
    oPanel.Visible  := False;
end;

//panel delete OK
procedure PDOClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPanel      : TPanel;
    //
    joConfig    : variant;
begin
    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('PDQ'));

    oQuery  := TFDQuery(oForm.FindComponent('FQu'));
    oQuery.Delete;

    //
    qaUpdate(oForm,'');
    //
    oPanel.Visible  := False;
end;



function qaAppend(
    AForm:TForm;        //控件所在窗体
    APrefix:String;     //控件名称的前缀，用于查找控件
    AQuery:TFDQuery;    //数据查询
    AFields:Variant
    ):Integer;
var
    iField      : Integer;
    //
    joField     : Variant;
    //
    oComp       : TComponent;
    oCB         : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
begin
    try
        //新增
        AQuery.Append;

        //循环处理各字段
        for iField := 0 to AQuery.FieldCount-1 do begin
            //异常检查
            if iField >= AFields._Count then begin
                break;
            end;

            //取得字段的JSON
            joField := AFields._(iField);

            //取得对应控件
            oComp   := AForm.FindComponent(APrefix + IntToStr(iField));

            //根据当前字段JSON信息进行处理
            if joField.type = 'auto' then begin
                oE      := TEdit(oComp);
                oE.Text := AQuery.Fields[iField].AsString;
                TEdit(oComp).Enabled    := False;
            end else if joField.type = 'check' then begin
                continue;
            end else if joField.type = 'combo' then begin
                oCB := TComboBox(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsString   := joField.default;
                end else begin
                    AQuery.Fields[iField].AsString   := '';
                end;
                oCB.Text    := AQuery.Fields[iField].AsString;
            end else if joField.type = 'dbcombo' then begin
                oCB := TComboBox(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsString   := joField.default;
                end else begin
                    AQuery.Fields[iField].AsString   := '';
                end;
                oCB.Text:= AQuery.Fields[iField].AsString;
            end else if joField.type = 'integer' then begin
                oE  := TEdit(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsInteger  := joField.default;
                end else begin
                    AQuery.Fields[iField].AsInteger  := 0;
                end;
                oE.Text := AQuery.Fields[iField].AsString;
            end else if joField.type = 'date' then begin
                oDT := TDateTimePicker(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsDateTime := StrToDateDef(joField.default,Now);
                end else begin
                    AQuery.Fields[iField].AsDateTime := Now;
                end;
                oDT.Kind    := dtkDate;
                oDT.Date    := AQuery.Fields[iField].AsDateTime;
            end else if joField.type = 'time' then begin
                oDT := TDateTimePicker(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsDateTime := StrToTimeDef(joField.default,Now);
                end else begin
                    AQuery.Fields[iField].AsDateTime := Now;
                end;
                oDT.Kind    := dtkTime;
                oDT.Time    := AQuery.Fields[iField].AsDateTime;
            end else if joField.type = 'datetime' then begin
                oDT := TDateTimePicker(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsDateTime := StrToDateTimeDef(String(joField.default),Now);
                end else begin
                    AQuery.Fields[iField].AsDateTime := Now;
                end;
                oDT.DateTime    := AQuery.Fields[iField].AsDateTime;
            end else if joField.type = 'money' then begin
                oE  := TEdit(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsFloat   := joField.default;
                end else begin
                    AQuery.Fields[iField].AsFloat   := 0;
                end;
                oE.Text := AQuery.Fields[iField].AsString;
            end else begin
                oE  := TEdit(oComp);
                if joField.Exists('default') then begin
                    AQuery.Fields[iField].AsString   := joField.default;
                end else begin
                    AQuery.Fields[iField].AsString   := '';
                end;
                oE.Text := AQuery.Fields[iField].AsString;
            end;

            //设置只读（编辑时只读，新增时可编辑）
            if joField.type <> 'auto' then begin
                if joField.readonly = 1 then begin
                    if joField.Exists('default') then begin
                        TEdit(oComp).Enabled    := False;
                    end else begin
                        TEdit(oComp).Enabled    := True;
                    end;
                end;
            end;

        end;
    except
    end;
end;

procedure qaCreateEditorField(AForm:TForm;AWidth:Integer;ASuffix:String;AConfig,AField:Variant;AP_Content:TPanel);
var
    ooP         : TPanel;
    ooL         : TLabel;
    ooE         : TEdit;
    ooI         : TImage;
    ooB         : TButton;
    ooDT        : TDateTimePicker;
    ooCB        : TComboBox;
    oQueryTmp   : TFDQuery;
    //
    iItem       : Integer;
    //
    joList      : Variant;
    joItems     : Variant;
    //
    tM          : TMethod;
begin
    //标题默认为field.name
    if not AField.Exists('caption') then begin
        AField.caption  := String(AField.name);
    end;


    //取得Query备用
    oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

    //字段容器Panel
    ooP     := TPanel.Create(AForm);
    with ooP do begin
        Name        := 'PF'+ASuffix;
        Parent      := AP_Content;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alTop;
        AutoSize    := False;
        Height      := 50;
        Top         := 999;
        Width       := AWidth;
        Color       := clNone;
        Font.Size   := 11;
        //
        //Hint        := '{"dwstyle":"border-bottom:solid 1px #f0f0f0;"}';
    end;

    //字段的标签 在容器左边
    ooL     := TLabel.Create(AForm);
    with ooL do begin
        Name            := 'LF'+ASuffix;
        Parent          := ooP;
        AutoSize        := False;
        Align           := alLeft;
        Alignment       := taRightJustify;
        Width           := 80;
        AlignWithMargins:= True;
        Margins.Top     := 15;
        Margins.Left    := 0;
        Margins.Right   := 15;
        Layout          := tlCenter;
        Caption         := AField.caption;
        //
        Hint        := '{"dwstyle":"display:block;"}';
        if AField.Exists('must') then begin
            if AField.must = 1 then begin
                Caption := '<font color="#f00">*</font>&nbsp;' + Caption ;
            end;
        end;
    end;


    //各字段编辑控件
    if AField.type = 'boolean' then begin //自带选项的类型，选项在list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"dwstyle":""}';
            //
            if AField.Exists('list') then begin
                joList  := AField.list;
                //添加选项
                for iItem := 0 to Min(1,joList._Count-1) do begin
                    Items.Add(joList._(iItem));
                end;
            end else begin
                Items.Add('False');
                Items.Add('True');
            end;
        end;
    end else if AField.type = 'check' then begin //check
    end else if AField.type = 'combo' then begin //自带选项的类型，选项在list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"dwstyle":""}';
            //
            if AField.Exists('list') then begin
                joList  := AField.list;
                //默认添加一个空值
                if joList._Count > 0 then begin
                    if joList._(0) <> '' then begin
                        Items.Add('');
                    end;
                end;
                //添加选项
                for iItem := 0 to joList._Count-1 do begin
                    Items.Add(joList._(iItem));
                end;
            end else begin
                Items.Add('');
            end;
        end;
    end else if AField.type = 'dbcombo' then begin  //从数据库内读数据的选项类型，由joConfig.table表中joField.name取值
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"dwstyle":""}';
            //
            Items.Add('');
            //添加数据库内的值
            joItems := _GetItems(oQueryTmp,AConfig.table,AField.name);
            for iItem := 0 to joItems._Count-1 do begin
                Items.Add(joItems._(iItem));
            end;
        end;
    end else if AField.type = 'image' then begin  //图片
        //先显示一个图片
        ooI := TImage.Create(AForm);
        with ooI do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alLeft;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 8;
            Margins.Top     := 8;
            Width           := 45;
            Stretch         := True;
            Proportional    := True;
            Left            := 999;
            Hint            := '{"dwstyle":"border:solid 1px #ddd;border-radius:3px;"}';
        end;

        //添加一个上传按钮
        ooB := TButton.Create(AForm);
        with ooB do begin
            Name            := 'FB'+ASuffix;
            Parent          := ooP;
            Align           := alRight;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 8;
            Margins.Top     := 8;
            Width           := 34;
            Cancel          := True;
            Caption         := '';
            Hint            := '{"icon":"el-icon-upload2"'
                    +',"imgdir":"'+dwGetStr(AField,'imgdir','')+'"'
                    +',"imgtype":'+dwGetStr(AField,'imgtype','')
                    +'}';
            //
            tM.Code         := @BUpClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
    end else if AField.type = 'integer' then begin  //整型
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '0.00';
            Color           := clNone;
            //
            if AField.Exists('min') then begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end else begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end;
            end else begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end else begin

                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end;
            end;
        end;
    end else if AField.type = 'date' then begin //日期型
        ooDT    := TDateTimePicker.Create(AForm);
        with ooDT do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;

    end else if AField.type = 'time' then begin
        ooDT    := TDateTimePicker.Create(AForm);
        with ooDT do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            Kind            := dtkTime;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;
    end else if AField.type = 'datetime' then begin
        ooDT    := TDateTimePicker.Create(AForm);
        with ooDT do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            DoubleBuffered  := True;    //标识为：日期+时间型
            Kind            := dtkTime;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;
    end else if AField.type = 'money' then begin
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '0.00';
            Color           := clNone;
            //
            if AField.Exists('min') then begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end else begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end;
            end else begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end else begin

                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end;
            end;
        end;
    end else begin
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'Fi'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 10;
            Margins.Top     := 10;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":""}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;
    end;

end;


procedure qaCreateEditorPanel(AForm:TForm);
var
    oPEd        : TPanel;       //panel editor 编辑/新增 总Panel
    oPET        : TPanel;       //panel editor title 顶部Panel, 用于放置：标题、最大化、关闭
    oBET        : TButton;      //button editor title 标题
    oBEC        : TButton;      //button editor close 关闭
    oPEB        : TPanel;       //panel editor buttons 底部按钮Panel, 放置：取消，确定
    oBEO        : TButton;      //button editor OK 确定按钮
    oBEA        : TButton;      //button editor cAncel取消按钮
    oPES        : TPanel;       //paenl editor scroll滚动框，以放置更多字段编辑信息
    oCBa        : TCheckBox;    //checkbox Batch 批量新增checkbox
    //
    iField      : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    iEditColCnt : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
    joList      : Variant;
    joItems     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //取得配置JSON
    joConfig    := qaGetConfigJson(AForm);

    //检查editwidth编辑面板宽度是否存在，默认为340
    joConfig.editwidth  := AForm.Width;

    //编辑/新增的总面板
    oPEd    := TPanel.Create(AForm);
    with oPEd do begin
        Name            := 'PEd';
        Parent          := AForm;
        HelpKeyword     := 'modal';
        Visible         := False;
        BevelOuter      := bvNone;
        BorderStyle     := bsNone;
        Anchors         := [akBottom,akTop,akleft,akRight];
        Font.Size       := 14;
        Top             := 50;
        Height          := AForm.Height - 52;
        Hint            := '{"radius":"15px"}';
        Font.Color      := $606060;
        Color           := clWhite;
        Width           := AForm.width-4;
    end;

    //标题 Panel
    oPET    := TPanel.Create(AForm);
    with oPET do begin
        Name            := 'PET';
        Parent          := oPEd;
        Align           := alTop;
        Height          := 50;
        Font.Size       := 17;
        Color           := clWhite;
        //
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //标题 Button
    oBET  := TButton.Create(AForm);
    with oBET do begin
        Name            := 'BET';
        Parent          := oPET;
        Align           := alLeft;
        Width           := 60;
        Caption         := '新  增';
        Font.Size       := 15;
        Hint            := '{"dwstyle":"background:#fff;text-align:left;border:0;"}';
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
    end;


    //关闭 Button
    oBEC  := TButton.Create(AForm);     //BEC - Button Editor Close
    with oBEC do begin
        Name            := 'BEC';
        Parent          := oPET;
        Align           := alRight;
        Width           := 30;
        Caption         := '';
        Cancel          := True;
        Hint            := '{"type":"text","icon":"el-icon-close"}';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        //
        tM.Code         := @BECClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //用于放置 OK/Cancel 的Panel
    oPEB    := TPanel.Create(AForm);
    with oPEB do begin
        Name            := 'PEB';
        Parent          := oPEd;
        BevelOuter      := bvNone;
        BorderStyle     := bsNone;
        Align           := alBottom;
        Height          := 50;
        Color           := clNone;
    end;

    //
    oBEO  := TButton.Create(AForm);
    with oBEO do begin
        Name            := 'BEO';
        Parent          := oPEB;
        Align           := alClient;
        Width           := 80;
        Top             := 0;
        Left            := 0;
        Height          := 60;
        Font.Size       := 13;
        Caption         := '确定';
        Hint            := '{"type":"primary","dwstyle":"border:0;border-radius:0;"}';
        //
        tM.Code         := @BEOClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //批量新增 checkbox
    oCBa    := TCheckBox.Create(AForm);
    with oCBa do begin
        Name            := 'CBa';
        Parent          := oPEd;
        Align           := alBottom;
        Height          := 28;
        Caption         := '批量处理';
        AlignWithMargins:= True;
        Margins.Left    := 20;
        Color           := clBtnFace;
    end;

    //主表编辑的ScrollBox
    oPES := TPanel.Create(AForm);
    with oPES do begin
        Name            := 'PES';
        Parent          := oPEd;
        Align           := alClient;
    end;

    //创建主表各字段的编辑框
    for iField := 0 to joConfig.fields._Count-1 do begin
        //取得主表字段的JSON对象
        joField := joConfig.fields._(iField);

        //创建控件
        qaCreateEditorField(
                AForm,
                AForm.Width-20,
                IntToStr(iField),   //后缀名，用于区分多个控件
                joConfig,
                joField,    //字段的JSON对象
                oPES        //父panel
                );
    end;


end;


procedure qaCreateFilterPanel(AForm:TForm;AFilter:Variant);
type
    TdwButtonClicked = procedure (Sender: TObject; AIndex: Integer) of object;
var
    oPFi        : TPanel;       //panel filter 总Panel
    oBGF        : TButtonGroup; //buttongroup filter 左侧分字段栏
    oCFi        : TCardPanel;   //cardpanel filter
    oCF         : TCard;        //
    oFF         : TFlowPanel;   //flowpanel filter , 用于容纳筛选项
    oBF         : TButton;      //button filter    筛选项
    oFFB        : TFlowPanel;   //Flowpanel filter buttons  重置/确定按钮的外面板
    oBFR        : TButton;      //button filter reset  重置
    oBFO        : TButton;      //button filter ok  确定
    oCBa        : TCheckBox;    //checkbox Batch 批量新增checkbox
    //
    iField      : Integer;
    iList       : Integer;
    iItem       : Integer;
    //
    joConfig    : Variant;
    joFilter    : Variant;
    joList      : Variant;
    joItems     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //取得配置JSON
    joConfig    := qaGetConfigJson(AForm);

    //筛选总面板
    oPFi    := TPanel.Create(AForm);
    with oPFi do begin
        Name            := 'PFi';
        Parent          := AForm;
        HelpKeyword     := 'popup';
        Visible         := False;
        BevelOuter      := bvNone;
        BorderStyle     := bsNone;
        Anchors         := [akBottom,akTop,akleft,akRight];
        Font.Size       := 9;
        Top             := 95;
        Height          := AForm.Height - 150;
        Hint            := '{"radius":"0 0 10px 10px","dwstyle":"border-bottom: solid 1px #aaa;"}';
        //Font.Color      := $606060;
        Color           := clWhite;
        Width           := AForm.width;
    end;

    //字段分栏
    oBGF    := TButtonGroup.Create(AForm);
    with oBGF do begin
        Name            := 'BGF';
        Parent          := oPFi;
        Align           := alLeft;
        Width           := 100;
        ButtonHeight    := 50;
        HelpKeyword     := 'category';
        Hint            := '{"hot":"#f00","activecolor":"#f00","normalcolor":"#888"}';
        //
        tM.Code         := @BGFButtonClicked;
        tM.Data         := Pointer(325); // 随便取的数
        OnButtonClicked := TdwButtonClicked(tM);
        //
        for iItem := 0 to AFilter._Count - 1 do begin
            with Items.Add do begin
                Name    := 'BG'+IntToStr(iItem);
                Caption := AFilter._(iItem).caption;
            end;
        end;
    end;

    //字段分栏面板容器
    oCFi  := TCardPanel.Create(AForm);
    with oCFi do begin
        Name            := 'CFi';
        Parent          := oPFi;
        Align           := alClient;
        Width           := 60;
        BevelOuter      := bvNone;
        //
        for iItem := 0 to AFilter._Count - 1 do begin
            //
            joFilter    := AFilter._(iItem);

            //
            oCF := CreateNewCard;
            with oCF do begin
                Name        := 'CF'+IntToStr(joFilter.index);
                Color       := clWhite;
                BevelOuter  := bvNone;
                Caption     := joFilter.name;   //将字段名称保存到caption中，以便后面获取筛选WHERE

                //
                oFF := TFlowPanel.Create(AForm);
                with oFF do begin
                    Parent      := oCF;
                    Name        := 'FF'+IntToStr(joFilter.index);
                    Color       := clWhite;
                    BevelOuter  := bvNone;
                    Align       := alClient;
                    HelpKeyword := 'auto';

                    HelpContext := 10003;
                end;

                //
                for iList := 0 to joFilter.list._Count - 1 do begin
                    oBF := TButton.Create(AForm);
                    with oBF do begin
                        Parent          := oFF;
                        Name            := 'BF'+IntToStr(joFilter.index)+'_'+IntToStr(iList);
                        Caption         := String(joFilter.list._(iList));
                        Hint            := '{"style":"round","dwstyle":"background:#F6F6F6;border:0;"}';
                        Width           := 60;
                        Height          := 28;
                        AlignWithMargins:= True;
                        Margins.Top     := 10;
                        Margins.Bottom  := 10;
                        Margins.Left    := 10;
                        Margins.Right   := 10;


                        //
                        tM.Code         := @BFxClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;
                end;
            end;
        end;

        //
        ActiveCardindex := 0;
    end;

    //用于放置 OK/Cancel 的Panel
    oFFB    := TFlowPanel.Create(AForm);
    with oFFB do begin
        Name            := 'PFB';
        Parent          := oPFi;
        Helpkeyword     := 'auto';
        HelpContext     := 10002;
        BevelOuter      := bvNone;
        BorderStyle     := bsNone;
        Align           := alBottom;
        Height          := 50;
        Color           := clWhite;
    end;

    //
    oBFR  := TButton.Create(AForm);
    with oBFR do begin
        Name            := 'BFR';
        Parent          := oFFB;
        Align           := alLeft;
        //Width           := oFFB.Width div 2;
        Top             := 0;
        Left            := 0;
        Height          := 30;
        Caption         := '重置';
        Hint            := '{"style":"round","dwstyle":"background:transparent;border:solid 1px #f00;"}';
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 10;
        Margins.Left    := 30;
        Margins.Right   := 20;

        //
        tM.Code         := @BFRClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oBFO  := TButton.Create(AForm);
    with oBFO do begin
        Name            := 'BFO';
        Parent          := oFFB;
        //Align           := alClient;
        Width           := 80;
        Top             := 0;
        Left            := 0;
        Height          := 30;
        Caption         := '确定';
        Hint            := '{"style":"round","type":"danger","dwstyle":"background:#f00;border:0;"}';
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 10;
        Margins.Left    := 20;
        Margins.Right   := 30;
        //
        tM.Code         := @BFOClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;


end;


//通过rtti读form的 qaConfig 变量
function qaGetConfigJson(AForm:TForm):Variant;
var
    iField      : Integer;
    //
    joField     : Variant;
begin
    //取配置JSON : 读AForm的 qaConfig 变量值
    Result  := _json(_GetConfig(AForm));
    //如果不是JSON格式，则退出
    if Result = unassigned then begin
        Exit;
    end;
    //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
    if not Result.Exists('table') then begin //默认表名
        Result.table := 'dw_member';
    end;
    if not Result.Exists('where') then begin
        Result.where := '';
    end;
    if not Result.Exists('pagesize') then begin  //默认数据每页显示的行数
        Result.pagesize  := 10;
    end;
    if not Result.Exists('button') then begin   //默认显示按钮框（增加、删除、编辑、模式切换）
        Result.button  := 1;
    end;
    if not Result.Exists('edit') then begin     //默认显示编辑按钮
        Result.edit  := 1;
    end;
    if not Result.Exists('new') then begin      //默认显示新增按钮
        Result.new  := 1;
    end;
    if not Result.Exists('delete') then begin   //默认显示删除按钮
        Result.delete  := 1;
    end;
    if not Result.Exists('export') then begin   //默认导出按钮
        Result.export  := 1;
    end;
    if not Result.Exists('query') then begin    //默认显示打印按钮
        Result.query  := 1;
    end;
    if not Result.Exists('fields') then begin    //显示的字段列表
        Result.fields  := _json('[]');
    end;
    if not Result.Exists('sortwidth') then begin //数据编辑框的宽度
        Result.sortwidth := 100;
    end;
    if not Result.Exists('datawidth') then begin //数据编辑框的宽度
        Result.datawidth := 320;
    end;
    if not Result.Exists('editwidth') then begin //数据编辑框的宽度
        Result.editwidth := 360;
    end;
    if not Result.Exists('cardstyle') then begin //样式
        Result.cardstyle    := '';
    end;
    if not Result.Exists('cardattr') then begin //属性
        Result.cardattr    := '';
    end;
    if not Result.Exists('cardheight') then begin//默认数据行的行高
        Result.cardheight   := 150;
    end;
    if not Result.Exists('cardmargins') then begin//默认数据卡片的边距
        Result.cardmargins  := _json('[0,0,0,10]');
    end;

    //更新主表字段的默认值
    for iField := 0 to Result.fields._Count - 1 do begin
        joField := Result.fields._(iField);
        //
        if not joField.Exists('name') then begin
            joField.name    := 'id';
        end;
        //
        if not joField.Exists('caption') then begin
            joField.caption := String(joField.name);
        end;

        //
        if not joField.Exists('type') then begin
            joField.type := 'string';
        end;
        if not joField.Exists('align') then begin       //对齐方式，默认为左对齐
            joField.align := 'left';
        end;
        if not joField.Exists('sort') then begin        //默认不排序
            joField.sort    := 0;
        end;
        if not joField.Exists('dwstyle') then begin     //样式
            joField.dwstyle := '';
        end;
        if not joField.Exists('dwattr') then begin     //属性
            joField.dwattr := '';
        end;
    end;


    //>
end;



function qaGetFDQuery(AForm:TForm):TFDQuery;
begin
    Result  := TFDQuery(AForm.FindComponent('FQu'));
end;


function  qaGetSQL(AForm:TForm):String;
var
    oFDQuery    : TFDQuery;
begin
    Result  := '';
    oFDQuery    := TFDQuery(AForm.FindComponent('FQu'));
    if oFDQuery<>nil then begin
        Result  := oFDQuery.SQL.Text;
    end;
end;





procedure qaUpdate(AForm:TForm;AWhere:String);
var
    oEvent      : procedure(Sender:TObject) of Object;
    //
    iField      : Integer;
    iItem       : Integer;
    iError      : Integer;
    iRow        : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sOrder      : string;
    sValue      : String;
    sFilter     : string;
    //
    joConfig    : variant;
    joField     : Variant;
    //
    oFDQuery    : TFDQuery;
    oTBa        : TTrackBar;
    oEKw        : TEdit;
    oPCa        : TPanel;       //panel card        单条记录面板
    oImg        : TImage;       //以下为显示的元素
    oLbl        : TLabel;
    oEdt        : TEdit;
    oBtn        : TButton;
begin
    try
        iError      := 0;   //用于检查错误

        //取得配置JSON
        joConfig    := qaGetConfigJson(AForm);

        //取得字段名称列表，备用，返回值为sFields, 如：id,Name,age
        sFields := joConfig.fields._(0).name;
        for iField := 1 to joConfig.fields._Count-1 do begin
            joField := joConfig.fields._(iField);
            //
            sFields := sFields+','+joField.name
        end;

        iError      := 1;   //用于检查错误

        //取得各控件备用
        oFDQuery    := TFDQuery(AForm.FindComponent('FQu'));    //主表数据库
        oEKw        := TEdit(AForm.FindComponent('EKw'));       //查询关键字
        oTBa        := TTrackBar(AForm.FindComponent('TBa'));   //主表分页

        try
            //保存事件，并清空，以防止循环处理
            oEvent          := oTBa.OnChange;
            oTBa.OnChange   := nil;

            iError      := 2;   //用于检查错误

            //数据库类型
            if not joConfig.Exists('database') then begin
                joConfig.database   := lowerCase(oFDQuery.Connection.DriverName); //'access';
                _SetConfig(AForm,joConfig);
            end;

            iError      := 3;   //用于检查错误

            //取得WHERE, “智能模糊查询”
            //从智能模糊查询框的关键字中生成查询字符串
            //返回值为 ' WHERE (1=1) ' 或
            //         ' WHERE ((....) oR (...))'
            sWhere  := _GetWhere(sFields, oEKw.Text);

            //添加固定的where
            if joConfig.where <> '' then begin
                Delete(sWhere,1,Length(' WHERE'));
                sWhere  := ' WHERE ('+joConfig.where+') and ' + sWhere;
            end;

            iError      := 4;   //用于检查错误

            //取得筛选条件
            sFilter := _GetFilter(AForm);
            if sFilter <> '' then begin
                sWhere  := sWhere + ' AND '+sFilter;
            end;

            //AWhere 额外的 WHERE 条件
            if AWhere <> '' then begin
                sWhere  := sWhere + ' AND '+AWhere;
            end;

            //取得记录总数
            oFDQuery.Close;
            oFDQuery.FetchOptions.RecsSkip    := 0;
            oFDQuery.SQL.Text := 'SELECT Count(*) FROM '+String(joConfig.table)+' '+sWhere;
            oFDQuery.Open;

            //
            oTBa.Max    := Max(1,oFDQuery.Fields[0].AsInteger);

            iError      := 5;   //用于检查错误

            //显示本页数据---------------------------------------------
            sOrder  := '';
            oFDQuery.Close;
            oFDQuery.SQL.Text := 'SELECT '+ sFields+' FROM '+String(joConfig.table)+' '+sWhere+' '+_GetOrder(AForm);
            oFDQuery.FetchOptions.RecsSkip    := oTBa.Position * Integer(joConfig.pagesize);
            oFDQuery.FetchOptions.RecsMax     := Integer(joConfig.pagesize);


            //
            oFDQuery.Open;


            //先隐藏所有card
            for iItem := 0 to joConfig.pagesize -1 do begin
                oPCa    := TPanel(AForm.FindComponent('PC'+IntToStr(iItem+1)));
                if oPCa <> nil then begin
                    oPCa.Tag        := oPCa.Top;
                    oPCa.Visible    := false;
                end;
            end;
            //显示数据记录
            if not oFDQuery.IsEmpty then begin
                for iRow := 0 to oFDQuery.RecordCount-1 do begin
                    //
                    oPCa    := TPanel(AForm.FindComponent('PC'+IntToStr(iRow+1)));
                    if oPCa = nil then begin
                        Continue;
                    end else begin
                        oPCa.Visible    := True;
                    end;
                    //
                    for iField := 0 to joConfig.fields._Count - 1 do begin
                        joField := joConfig.fields._(iField);
                        //
                        sValue  := oFDQuery.FieldByName(String(joField.name)).AsString;
                        sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);
                        sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);

                        //
                        if joField.type = 'boolean' then begin
                            if _HaveList(joField,2) then begin
                                if oFDQuery.FieldByName(String(joField.name)).AsBoolean then begin
                                    sValue  := joField.list._(1);
                                end else begin
                                    sValue  := joField.list._(0);
                                end;
                            end;
                            //取得控件
                            oLbl    := TLabel(AForm.FindComponent('C'+IntToStr(iField)+'_'+IntToStr(iRow+1)));

                            //异常处理
                            if oLbl = nil then begin
                                Continue;
                            end;

                            //更新值
                            with oLbl do begin
                                Caption := sValue;
                            end;
                        end else if joField.type = 'image' then begin
                            //取得控件
                            oImg    := Timage(AForm.FindComponent('C'+IntToStr(iField)+'_'+IntToStr(iRow+1)));

                            //异常处理
                            if oImg = nil then begin
                                Continue;
                            end;

                            //更新值
                            with oImg do begin
                                Hint    :=
                                '{'
                                    +'"dwattr":"'+String(joField.dwattr)+'",'
                                    +'"dwstyle":"'+String(joField.dwstyle)+'",'
                                    +'"src":"'+joField.imgdir+sValue+'"'
                                +'}';
                            end;
                        end else if joField.type = 'rate' then begin
                            //取得控件
                            oEdt    := TEdit(AForm.FindComponent('C'+IntToStr(iField)+'_'+IntToStr(iRow+1)));

                            //异常处理
                            if oEdt = nil then begin
                                Continue;
                            end;

                            //更新值
                            with oEdt do begin
                                Text    := sValue;
                            end;
                        end else begin
                            //取得控件
                            oLbl    := TLabel(AForm.FindComponent('C'+IntToStr(iField)+'_'+IntToStr(iRow+1)));

                            //异常处理
                            if oLbl = nil then begin
                                Continue;
                            end;

                            //更新值
                            with oLbl do begin
                                Caption := sValue;
                            end;
                        end;
                    end;

                    //
                    oFDQuery.Next;

                    //如果已达末尾，则退出
                    if oFDQuery.Eof then begin
                        break;
                    end;
                end;
            end;



            //调整所有card的top
            for iItem := joConfig.pagesize -1 downto 0 do begin
                oPCa    := TPanel(AForm.FindComponent('PC'+IntToStr(iItem+1)));
                if oPCa <> nil then begin
                    oPCa.Top        := oPCa.Tag;
                end;
            end;

            iError      := 6;   //用于检查错误

        finally
            //恢复事件
            oTBa.OnChange  := oEvent;
        end;
    except
        ShowMessage('Error when qaUpdate at '+IntToStr(iError));
    end;
end;

procedure TBaChange(Self: TObject; Sender: TObject);
begin
    qaUpdate(TForm(TEdit(Sender).Owner),'');
end;

function dwCard(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwEndDock      = procedure (Sender, Target: TObject; X, Y: Integer) of object;
    TdwEndDrag = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var

    //控件------------------------------------------------
    oPQa        : TPanel;       //panel quick card  总面板
    //
    oPQS        : TPanel;       //panel query smart 查询面板
    oEKW        : TEdit;        //Edit keyword      关键字编辑框
    //
    oPBS        : TPanel;       //panel buttons     按钮组面板
    oCSo        : TComboBox;    //combobox sort     排序
    oBNe        : TButton;      //button new        新增
    oBEx        : TButton;      //button edit       编辑
    oBDx        : TButton;      //button delete     删除
    oBFi        : TButton;      //button filter     筛选
    //
    oPDa        : TPanel;       //panel data        数据面板
    oPCaDemo    : TPanel;       //panel card demo   用于clone用的单条记录母面板
    oPCa        : TPanel;       //panel card        单条记录面板
    //
    oImg        : TImage;       //用于显示图片
    oLbl        : TLabel;       //用于显示文本标签
    oEdt        : TEdit;        //用于显示rate
    oBtn        : TButton;      //用于显示按钮
    //
    oTBa        : TTrackbar;    //trackbar          分页栏
    oMargins    : TMargins;     //边距
    //
    oPDQ        : TPanel;       //panel delete query
    //
    oQueryTmp   : TFDQuery;
    oQuery      : TFDQuery;

    //JSON对象--------------------------------------------
    joConfig    : variant;
    joField     : Variant;
    joSort      : Variant;      //排序字段，如：["名称","编号"]
    joFilter    : Variant;      //筛选字段，如：[{"name":"品牌","filter":["华为","迈华"]},....]
    joFi        : Variant;

    //临时变量--------------------------------------------
    iError      : integer;      //用于记录异常的变量
    iField      : Integer;
    iItem       : Integer;
    iOldLeft    : Integer;      //上一控件的left/top/height
    iOldTop     : Integer;
    iOldHeight  : Integer;
    sSort       : string;
    tM          : TMethod;

    //设置标题
    procedure _SetCaption(ALabel:TLabel);
    begin
        with ALabel do begin
            //如果是必填字段，则增加*
            if joField.must = 1 then begin
                Caption     := '* '+joField.caption;
            end else begin
                Caption     := joField.caption;
            end;
            //设置对齐方式
            if joField.type <> 'group' then begin
                if joConfig.align = 'right' then begin
                    Alignment   := taRightJustify;
                end else if joConfig.align = 'center' then begin
                    Alignment   := taCenter;
                end;
            end;
        end;
    end;
begin
    try
        //默认返回值
        Result  := 0;

        //异常时调试使用
        iError  := 0;

        //防止重复创建
        if AForm.FindComponent('PQa') <> nil then begin
            Exit;
        end;

        //取配置JSON : 读AForm的 qaConfig 变量值
        joConfig    := qaGetConfigJson(AForm);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //为窗体赋OnEndDock事件，以解决上传图片问题
        with AForm do begin
            //
            tM.Code         := @FormEndDock;
            tM.Data         := Pointer(325); // 随便取的数
            OnEndDock       := TdwEndDock(tM);
        end;

        //生成一个临时查询，以生成Combo的列表
        oQueryTmp               := TFDQuery.Create(AForm);
        oQueryTmp.Name          := 'FDQueryTmp';
        oQueryTmp.Connection    := AConnection;

        //总面板========================================================================================================
        oPQa    := TPanel.Create(AForm);
        with oPQa do begin
            Parent          := AForm;
            Name            := 'PQa';
            BevelOuter      := bvNone;
            Align           := alClient;
            Color           := clNone;
            Font.Size       := 9;
            //
            Font.Color      := $00606060;
        end;


        //智能查询面板 P_QuerySmart ====================================================================================
        if joConfig.query = 1 then begin
            oPQS := TPanel.Create(AForm);
            with oPQS do begin
                Parent          := oPQa;
                Name            := 'PQS';
                Align           := alTop;
                BevelOuter      := bvNone;
                Height          := 50;
                Top             := 1100;
                Color           := clNone;
            end;

            //智能查询EKw
            oEKw  := TEdit.Create(AForm);
            with oEKw do begin
                Parent          := oPQS;
                Name            := 'EKw';
                Align           := alClient;
                Color           := clWhite;//$f0f0f0;
                Text            := '';
                //
                AlignWithMargins:= True;
                Margins.Bottom  := 10;
                Margins.Left    := 20;
                Margins.Right   := 20;
                Margins.Top     := 10;
                Hint            := '{'
                        +'"placeholder":"请输入查询关键字",'
                        +'"prefix-icon":"el-icon-search",'
                        +'"dwstyle":"border-radius: 15px;"}';
                //
                tM.Code         := @EKwChange;
                tM.Data         := Pointer(325); // 随便取的数
                OnChange        := TNotifyEvent(tM);
            end;
        end;

        //功能按钮面板 ： PBs ============================================
        if joConfig.button = 1 then begin
            oPBs  := TPanel.Create(AForm);
            with oPBs do begin
                Parent          := oPQa;
                Name            := 'PBs';
                Align           := alTop;
                Height          := 45;
                Top             := 50;
                Font.Size       := 9;
                //
                Color           := clNone;
                AlignWithMargins:= True;
                Margins.Top     := 0;
                Margins.Bottom  := 0;
                Margins.Left    := 15;
                Margins.Right   := 12;
                //
                Visible         := joConfig.button = 1;
            end;

            //设置一个统一的边距
            oMargins        := TMargins.Create(AForm);
            oMargins.Top    := 5;
            oMargins.Bottom := 10;
            oMargins.Left   := 0;
            oMargins.Right  := 0;

            //sort ↑↓
            //先查找是否有需要排序的字段
            joSort  := _json('[]');
            for iField := 0 to joConfig.fields._Count - 1 do begin
                joField := joConfig.fields._(iField);
                if joField.sort = 1 then begin
                    joSort.add(joField.caption);
                end;
            end;
            if joSort._Count > 0 then begin
                oCSo    := TCombobox.Create(AForm);
                with oCSo do begin
                    Parent          := oPBs;
                    Name            := 'CSo';
                    Align           := alLeft;
                    width           := joConfig.sortwidth;
                    style           := csDropdownlist;
                    Color           := clNone;
                    //
                    Items.Add('默认排序');
                    for iField := 0 to joSort._Count - 1 do begin
                        Items.Add(String(joSort._(iField))+' ↑');
                        Items.Add(String(joSort._(iField))+' ↓');
                    end;
                    ItemIndex   := 0;
                    //
                    AlignWithMargins:= True;
                    Margins         := oMargins;
                    Hint            := '{"dwstyle":"border:0;caret-color: transparent;font-size:12px;"}';
                    //
                    tM.Code         := @CSoChange;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnChange        := TNotifyEvent(tM);
                end;
            end;

            //筛选
            //先查找是否有需要筛选的字段
            joFilter    := _json('[]');
            for iField := 0 to joConfig.fields._Count - 1 do begin
                joField := joConfig.fields._(iField);
                if joField.Exists('filter') then begin
                    joFi            := _json('{}');
                    joFi.index      := iField;
                    joFi.name       := string(joField.name);
                    joFi.caption    := string(joField.caption);
                    joFi.list       := joField.filter;
                    joFilter.add(joFi);
                end;
            end;
            if joFilter._Count > 0 then begin
                oBFi    := TButton.Create(AForm);
                with oBFi do begin
                    Parent          := oPBs;
                    Name            := 'BFi';
                    Align           := alRight;
                    Width           := 60;
                    Caption         := '筛选 ';
                    Font.Size       := 11;
                    //
                    AlignWithMargins:= True;
                    Margins         := oMargins;
                    Hint            := '{"dwstyle":"z-index:3;","type":"text","style":"plain","righticon":"el-icon-circle-check"}';
                    //
                    tM.Code         := @BFiClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                end ;
                //
                //创建确定面板P_Confirm
                qaCreateFilterPanel(AForm,joFilter);

            end;
            //新增
            if joConfig.new = 1 then begin
                oBNe    := TButton.Create(AForm);
                with oBNe do begin
                    Parent          := oPBs;
                    Name            := 'BNe';
                    Align           := alRight;
                    Width           := 60;
                    Caption         := '新增 ';
                    Font.Size       := 11;
                    //
                    AlignWithMargins:= True;
                    Margins         := oMargins;
                    Hint            := '{"dwstyle":"z-index:3;","type":"text","style":"plain","righticon":"el-icon-circle-plus-outline"}';
                    //
                    tM.Code         := @BNeClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                end ;
            end;
        end;


        //异常时调试使用
        iError  := 1;

        //数据面板------------------------------------------------------------------------------------------------------
        oPDa    := TPanel.Create(AForm);
        with oPDa do begin
            Parent          := oPQa;
            Name            := 'PDa';
            BevelOuter      := bvNone;
            Align           := alClient;
            Color           := clNone;
            Hint            := '{"dwstyle":"overflow-y:auto;"}';
        end;

        //记录面板
        oMargins.Left   := joConfig.cardmargins._(0);
        oMargins.Top    := joConfig.cardmargins._(1);
        oMargins.Right  := joConfig.cardmargins._(2);
        oMargins.Bottom := joConfig.cardmargins._(3);

        //先创建一个数据record面板， 用于后面clone ---------------------------------------------------------------------
        oPCaDemo    := TPanel.Create(AForm);
        with oPCaDemo do begin
            Parent          := oPDa;
            Name            := 'PC';
            BevelOuter      := bvNone;
            Height          := joConfig.cardheight;
            Top             := joConfig.cardheight * iItem;
            Align           := alTop;
            Color           := dwGetColorFromJson(joConfig.cardcolor,clWhite);
            AlignWithMargins:= True;
            Margins         := oMargins;
            Hint            := '{"dwattr":"'+String(joConfig.cardattr)+'","dwstyle":"'+String(joConfig.cardstyle)+'"}'
        end;
        //配置各列参数
        iOldLeft    := 10;
        iOldTop     := 10;
        iOldHeight  := 0;
        for iField := 0 to joConfig.fields._count - 1 do begin
            //得到字段对象
            joField := joConfig.fields._(iField);

            //生成各字段控件
            if joField.type = 'image' then begin
                oImg    := TImage.Create(AForm);
                with oImg do begin
                    Parent      := oPCaDemo;
                    Name        := 'C'+IntToStr(iField)+'_';
                    Stretch     := True;
                    Proportional:= True;
                    Hint        := '{"dwattr":"'+String(joField.dwattr)+'","dwstyle":"'+String(joField.dwstyle)+'"}';
                    //设置left/width/right, Top/height/bottom
                    _SetLwrThb(oImg,joField,iOldLeft,iOldTop,iOldHeight);
                    //保存当前位置
                    iOldLeft    := Left;
                    iOldTop     := Top;
                    iOldHeight  := Height;
                end;
            end else if joField.type = 'rate' then begin
                oEdt    := TEdit.Create(AForm);
                with oEdt do begin
                    Parent      := oPCaDemo;
                    Name        := 'C'+IntToStr(iField)+'_';
                    HelpKeyword := 'rate';
                    Color       := clNone;
                    Enabled     := False;
                    Hint        := '{"showscore":1,"dwattr":"'+String(joField.dwattr)+'","dwstyle":"'+String(joField.dwstyle)+'"}';

                    //设置left/width/right, Top/height/bottom
                    _SetLwrThb(oEdt,joField,iOldLeft,iOldTop,iOldHeight);

                    //保存当前位置
                    iOldLeft    := Left;
                    iOldTop     := Top;
                    iOldHeight  := Height;
                end;
            end else begin  //普通标签 Label
                //创建控件
                oLbl    := TLabel.Create(AForm);

                //设置属性
                with oLbl do begin
                    Parent      := oPCaDemo;
                    Name        := 'C'+IntToStr(iField)+'_';
                    Autosize    := false;
                    //字体
                    if dwGetStr(joField,'fontname','') <> '' then begin
                        Font.Name   := dwGetStr(joField,'fontname','');
                    end;
                    //字体大小
                    if joField.Exists('fontsize') then begin
                        Font.Size   := joField.fontsize;
                    end;
                    //字色
                    if joField.Exists('fontcolor') then begin
                        Font.Color  := dwGetColorFromJson(joField.fontcolor,clBlack);
                    end;
                    //粗体
                    if dwGetInt(joField,'fontbold',0) = 1 then begin
                        Font.Style  := Font.Style + [fsBold];
                    end;
                    //斜体
                    if dwGetInt(joField,'fontitalic',0) = 1 then begin
                        Font.Style  := Font.Style + [fsItalic];
                    end;
                    //下划线
                    if dwGetInt(joField,'fontunderline',0) = 1 then begin
                        Font.Style  := Font.Style + [fsUnderline];
                    end;
                    //删除线
                    if dwGetInt(joField,'fontstrikeout',0) = 1 then begin
                        Font.Style  := Font.Style + [fsStrikeout];
                    end;

                    Hint        := '{"dwattr":"'+String(joField.dwattr)+'","dwstyle":"'+String(joField.dwstyle)+'"}';

                    //设置left/width/right, Top/height/bottom
                    _SetLwrThb(oLbl,joField,iOldLeft,iOldTop,iOldHeight);

                    //保存当前位置
                    iOldLeft    := Left;
                    iOldTop     := Top;
                    iOldHeight  := Height;
                end;
            end;

        end;
        //如果有“删除”功能，则在右上角添加一个删除按钮
        if joConfig.delete = 1 then begin
            oBDx    := TButton.Create(AForm);
            with oBDx do begin
                Parent          := oPCaDemo;
                Name            := 'BD';
                Width           := 30;
                Height          := 30;
                Top             := 10;
                Font.Size       := 17;
                Font.Color      := $b0b0b0;
                Left            := oPCaDemo.Width - 40;
                Anchors         := [akTop,akRight];
                Caption         := '';
                Cancel          := True;
                //
                Hint            := '{"type":"text","style":"circle","icon":"el-icon-remove-outline"}';
            end;
        end;
        //编辑
        if joConfig.edit = 1 then begin
            oBEx    := TButton.Create(AForm);
            with oBEx do begin
                Parent          := oPCaDemo;
                Name            := 'BE';
                Width           := 30;
                Height          := 30;
                Top             := dwIIFi(oBDx = nil,10,40);
                Font.Size       := 17;
                Font.Color      := $b0b0b0;
                Left            := oPCaDemo.Width - 40;
                Anchors         := [akTop,akRight];
                Caption         := '';
                Cancel          := True;
                //
                Hint            := '{"type":"text","style":"circle","icon":"el-icon-edit-outline"}';
            end;
        end;

        //克隆源面板
        for iItem := 0 to joConfig.pagesize - 1 do begin
            CloneComponent(oPCaDemo);
            //
            with TButton(AForm.FindComponent('BD'+IntToStr(iItem+1))) do begin
                //
                tM.Code         := @BDxClick;
                tM.Data         := Pointer(325);
                OnClick         := TNotifyEvent(tM);
            end;
            //
            with TButton(AForm.FindComponent('BE'+IntToStr(iItem+1))) do begin
                //
                tM.Code         := @BExClick;
                tM.Data         := Pointer(325);
                OnClick         := TNotifyEvent(tM);
            end;
        end;

        //释放源面板
        oPCaDemo.Destroy;


        //异常时调试使用
        iError  := 2;

        //分页----------------------------------------------------------------------------------------------------------
        oTBa    := TTrackBar.Create(AForm);
        with oTBa do begin
            Parent          := oPQa;
            Name            := 'TBa';
            Align           := alBottom;
            HelpKeyword     := 'mobile';
            Height          := 40;
            PageSize        := Integer(joConfig.pagesize);
            Hint            := '{"dwattr":":pager-count=''5'' background layout=''prev, pager,next''"}';
            //
            AlignWithMargins:= True;
            //
            tM.Code         := @TBaChange;
            tM.Data         := Pointer(325); // 随便取的数
            OnChange        := TNotifyEvent(tM);
        end;


        //异常时调试使用
        iError  := 3;

        //--------------------------------------------------------------------------------------------------------------
        //配置 oFQu 的连接
        oQuery              := TFDQuery.Create(AForm);
        oQuery.Name         := 'FQu';
        oQuery.Connection   := AConnection;

        //更新数据
        qaUpdate(AForm,'');

        //异常时调试使用
        iError  := 6;

        //创建删除确定面板PDQ
        oPDQ    := TPanel.Create(AForm);
        with oPDQ do begin
            Parent          := oPQa;
            Name            := 'PDQ';
            Helpkeyword     := 'ok';
            BevelOuter      := bvNone;
            Height          := 180;
            Width           := 320;
            Top             := 200;
            Color           := clWhite;
            Visible         := False;

            //
            tM.Code         := @PDOClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnEnter         := TNotifyEvent(tM);
            //
            tM.Code         := @PDCClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnExit          := TNotifyEvent(tM);

        end;

        //异常时调试使用
        iError  := 7;


        //异常时调试使用
        iError  := 8;

        //创建编辑面板P_Editor
        qaCreateEditorPanel(AForm);


        //异常时调试使用
        iError  := 9;


    except
        //下面的ShowMessage代码仅在程序调试时使用
        ShowMessage('error at '+IntToStr(iError));
    end;
end;

end.
