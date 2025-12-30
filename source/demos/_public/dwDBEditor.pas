unit dwDBEditor;
(*
功能说明：
------------------------------------------------------------------------------------------------------------------------
用于通过一个panel完成数据表的字段编辑模块


##更新说明：
------------------------------------------------------------------------------------------------------------------------

2025-06-29
    1. 开始本模块
*)

//{$DEFINE TIME}


interface

uses
    //
    dwBase,

    //导出XLS
    //dwExportToXLSUnit,
    dwExcel,

    //
    Excel4Delphi,Excel4Delphi.Stream,

    //
    SynCommons{用于解析JSON},

    //
    System.RegularExpressions,//正则表达式函数

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
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    ComObj,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;

const
    deInited            = 10;       //初始化完成事件
    dePageNo            = 12;       //点击页码事件		Y 为当前页码，0开始
    deMode              = 13;       //切换查询模式事件	Y 为切换后的查询模式，0/1/2

    //
    deNew               = 20;       //新增按钮点击事件
    deDelete            = 21;       //编辑按钮事件		Y 为当前行号，对应RecNo
    deEdit              = 22;       //编辑按钮事件		Y 为当前行号，对应RecNo
    deQuery             = 23;       //查询按钮事件
    deReset             = 24;       //重置查询按钮事件
    deChange            = 25;       //字段onChange事件
    deEnter             = 26;       //字段onEnter事件
    deExit              = 27;       //字段onExit事件

    //通用事件
    deDataScroll      	= 60;       //数据表当前记录发生改变的事件。包括重新查询和点击记录
    deAppendBefore      = 61;       //FDQuery.append前事件
    deAppendAfter       = 62;       //FDQuery.append后事件
    deAppendPostBefore  = 63;       //新增时FDQuery.post前事件
    deAppendPostAfter   = 64;       //新增FDQuery.post后事件
    deCancelBefore      = 65;       //FDQuery.cancel前事件
    deCancelAfter       = 66;       //FDQuery.cancel后事件
    deDeleteBefore      = 67;       //FDQuery.cancel前事件	Y 为oQuery.RecNo
    deDeleteAfter       = 68;       //FDQuery.cancel后事件  Y 为oQuery.RecNo
    deEditPostBefore    = 69;       //编辑时的FDQuery.post前事件
    deEditPostAfter     = 70;       //编辑时FDQuery.post后事件
    //
    deEditOK            = 80;       //编辑后按OK按钮事件(点击后即触发 )
    deEditOKFinished    = 81;       //编辑后按OK按钮事件(事件执行完成后触发 )
    deQueryHide         = 82;       //多字段查询的隐藏
    //
	deUpdateEnter       = 90;       //cpUpdate开始事件
	deUpdateAfter       = 91;       //cpUpdate结束事件

//一键生成CRUD模块
function  deInit(APanel:TPanel;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

//取当前配置，可能与原来的hint有所区别，主要是增加了默认值和自动生成的配置
function  deGetConfig(APanel:TPanel):Variant;

//销毁dwCrud，以便二次创建
function  deDestroy(APanel:TPanel):Integer;

//更新数据
procedure deUpdate(APanel:TPanel;const AWhere:String = '';const AInited:Boolean=True);
//更新字段显示
procedure deUpdateView(APanel:TPanel);

//取DBEditor模块的 FDQuery 控件。 未找到返回空值
function  deGetFDQuery(APanel:TPanel):TFDQuery;
function  deGetFDQueryTemp(APanel:TPanel):TFDQuery;

//取DBEditor模块的 StringGrid 控件
function  deGetStringGrid(APanel:TPanel):TStringGrid;

//取得对应序号的编辑控件, 一般为TEdit/TComboBox/TDateTimePicker
function  deGetEditComponent(APanel:TPanel;AIndex:Integer):TComponent;

//取DBEditor模块的SQL语句
function  deGetSQL(APanel:TPanel):String;

//取DBEditor模块的SQL语句中的where(返回值不包含where)
function  deGetSQLWhere(APanel:TPanel):String;

//在DBEditor的按钮栏中插入控件(一般用于插入自定义的按钮)
function  deAddInButtons(APanel:TPanel;ACtrl:TWinControl):Integer;

//在DBEditor的智能查询栏中插入控件
function  deAddInSmart(APanel:TPanel;ACtrl:TWinControl):Integer;

//设置额外的where, AWhere 类似 'Id>20' , 保存在PQm面板(也就是EKw的容器面板)中
function  deSetExtraWhere(APanel:TPanel;AWhere:String):Integer;
//取上述值
function  deGetExtraWhere(APanel:TPanel):String;

//设置为移动端模式，调整相关控件
function  deSetMobile(APanel:TPanel):Integer;

//设置"增删改查导入导出"等的Enabled , AName分别为new,delete,edit,query,import,export
function  deSetControlEnabled(APanel:TPanel;AName:string;AEnabled:Boolean):Integer;

//设置简洁模式，智能模糊查询模式下，将按钮和查询放到一排
function  deSetOneLine(APanel:TPanel;const AMargin:Integer=10):Integer;

//控制编辑时各编辑控件的值, 其中: AName 为字段json的name
function  deSetEditFieldValue(APanel:TPanel;AName,AValue:String):Integer;               //设置值
function  deGetEditFieldValue(APanel:TPanel;AName:String;var AValue:String):Integer;    //取编辑控件值
function  deSetEditFieldReadonly(APanel:TPanel;AName:String;AReadOnly:Boolean):Integer; //设置编辑控件只读



//树形表转JSON对象
//ATable为表名
//ACode 为编码字符串，子项编码应大于并包含父类编码
//ADataField 保存在数据表的内容字段名
//AViewField 显示在表格和查询中的内容字段名
//ALink为多级之间的连接字符
//ACount为最多读取的记录数量，默认50
function deDbToTreeListJson(AQuery:TFDQuery;ATable,AData,AView,ALink:String;ACount:Integer):Variant;

//将函数cpDbToTreeListJson生成的JSON转化为TreeView
function deTreeListJsonToTV(AList:Variant;ATV:TTreeView):Integer;

//删除当前表的一部分记录
function deDeleteRecords(APanel:TPanel;AWhere:String):Integer;

const
    //整型类型集合
    destInteger : Set of TFieldType = [ftSmallint, ftInteger, ftWord, ftAutoInc,ftLargeint, ftLongWord, ftShortint, ftByte];
    //浮点型类型集合
    destFloat   : set of TFieldType = [ftFloat, ftCurrency, ftBCD, ftExtended, ftSingle];
    //日期时间类型集合
    destDateTime   : set of TFieldType = [ftDate, ftTime, ftDateTime, ftTimeStamp,ftOraTimeStamp,ftTimeStampOffset];

implementation


//删除当前表的一部分记录. 主要可以递归删除从表中的记录
function deDeleteRecords(APanel:TPanel;AWhere:String):Integer;
var
    oForm       : TForm;
    oPanelSlave : TPanel;
    oFDTemp     : TFDQuery;
    //
    sPrefix     : String;
    //
    joConfig    : Variant;
    joSlave     : Variant;
    joConfigS   : Variant;
    //
    iSlave      : Integer;
begin
    Result      := 0;

    try
        //
        oForm       := TForm(APanel.Owner);
        Dec(Result);

        //取得JSON配置
        joConfig    := deGetConfig(APanel);
        Dec(Result);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');
        Dec(Result);

        //<先删除可能存在的从表记录
        if joConfig.Exists('slave') then begin
            //逐个slave从表删除
            for iSlave := 0 to joConfig.slave._Count - 1 do begin
                //取得从表 json
                joSlave := joConfig.slave._(iSlave);
                //取得从表 panel
                oPanelSlave := TPanel(oForm.FindComponent(dwGetStr(joSlave,'panel','nil')));

                //
                if oPanelSlave <> nil then begin
                    //取得从表配置 json
                    joConfigS   := deGetConfig(oPanelSlave);

                    //递归删除记录
                    deDeleteRecords(oPanelSlave, joSlave.slavefield+' in (SELECT '+joSlave.masterfield+' FROM '+joConfig.table+' WHERE '+AWhere+')');

                end;
            end;
        end;

        //
        oFDTemp := deGetFDQueryTemp(APanel);
        oFDTemp.Connection.ExecSQL('DELETE FROM '+joConfig.table+' WHERE '+AWhere);

    except
        dwMessage('except when deDeleteRecords : '+IntTostr(Result),'error',oForm);
        Exit;
    end;
end;




function  deSetEditFieldValue(APanel:TPanel;AName,AValue:String):Integer;
var
    oForm       : TForm;
    oComp       : TComponent;
    //
    sPrefix     : String;
    sType       : String;
    dtValue     : TDateTime;
    iValue      : Integer;
    fValue      : Double;
    //
    joConfig    : Variant;
    joField     : Variant;
    //
    iItem       : Integer;
    iField      : Integer;  //取得field的序号
begin
    Result      := 0;

    try
        //
        oForm       := TForm(APanel.Owner);
        Dec(Result);

        //取得JSON配置
        joConfig    := deGetConfig(APanel);
        Dec(Result);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');
        Dec(Result);

        //
        iField      := -1;
        for iItem := 0 to joConfig.fields._Count - 1 do begin
            if LowerCase(joConfig.fields._(iItem).name) = LowerCase(AName) then begin
                iField  := iItem;
                break;
            end;
        end;
        Dec(Result);

        if iField = -1 then begin
            //dwMessage('error when deSetEditFieldValue','error',oForm);
            Exit;
        end;
        Dec(Result);

        oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iField));
        Dec(Result);

        //
        if oComp = nil then begin
            //dwMessage('error when deSetEditFieldValue','error',oForm);
            Exit;
        end;
        Dec(Result);

        //
        joField     := joConfig.fields._(iField);
        sType       := dwGetStr(joField,'type','string');
        if sType = 'auto' then begin                 //----- 1 -----
            //暂空
        end else if sType = 'boolean' then begin     //----- 2 -----
            TComboBox(oComp).ItemIndex  := dwIIFi(LowerCase(AValue)='true',1,0);
        end else if sType = 'button' then begin      //----- 3 -----
            //暂空
        end else if sType = 'combo' then begin       //----- 4 -----
            TComboBox(oComp).Text   := AValue;
        end else if sType = 'combopair' then begin   //----- 5 -----
            TComboBox(oComp).Text   := AValue;
        end else if sType = 'date' then begin        //----- 6 -----
            if TryStrToDate(AValue, dtValue) then begin
                TDateTimePicker(oComp).Date := dtValue;
            end else begin
                dwMessage('except when deSetEditFieldValue! not date format : '+AValue,'error',oForm);
                Exit;
            end;
        end else if sType = 'datetime' then begin    //----- 7 -----
            if TryStrToDateTime(AValue, dtValue) then begin
                TDateTimePicker(oComp).DateTime := dtValue;
            end else begin
                dwMessage('except when deSetEditFieldValue! not datetime format : '+AValue,'error',oForm);
                Exit;
            end;
        end else if sType = 'dbcombo' then begin     //----- 8 -----
            TComboBox(oComp).Text   := AValue;
        end else if sType = 'dbcombopair' then begin //----- 9 -----
            TComboBox(oComp).Text   := AValue;
        end else if sType = 'dbtree' then begin      //----- 10 -----
            TEdit(oComp).Text   := AValue;
        end else if sType = 'dbtreepair' then begin  //----- 11 -----
            TEdit(oComp).Text   := AValue;
        end else if sType = 'float' then begin       //----- 12 -----
            if TryStrToFloat(AValue, fValue) then begin
                TEdit(oComp).Text   := FloatToStr(fValue);
            end else begin
                dwMessage('except when deSetEditFieldValue! not float format : '+AValue,'error',oForm);
                Exit;
            end;
        end else if sType = 'image' then begin       //----- 13 -----
            //根据字段中是否保存路径信息("pathindata":1)分别处理
            if dwGetInt(joField,'pathindata',0) = 1 then begin
                TImage(oComp).Hint  := '{"src":"'+AValue+'"}';
            end else begin
                TImage(oComp).Hint  := '{"src":"'+dwGetStr(joField,'imgdir','')+AValue+'"}';
            end;
        end else if sType = 'index' then begin       //----- 13A -----
            //序号列
        end else if sType = 'integer' then begin     //----- 14 -----
            if TryStrToInt(AValue, iValue) then begin
                TEdit(oComp).Text   := IntToStr(iValue);
            end else begin
                dwMessage('except when deSetEditFieldValue! not integer format : '+AValue,'error',oForm);
                Exit;
            end;
        end else if sType = 'memo' then begin       //----- 15 -----
            TMemo(oComp).Text   := AValue;
        end else if sType = 'money' then begin       //----- 16 -----
            if TryStrToFloat(AValue, fValue) then begin
                TEdit(oComp).Text   := FloatToStr(fValue);
            end else begin
                dwMessage('except when deSetEditFieldValue! not meney format : '+AValue,'error',oForm);
                Exit;
            end;
        end else if sType = 'string' then begin      //----- 17 -----
            TEdit(oComp).Text   := AValue;
        end else if sType = 'time' then begin        //----- 18 -----
            if TryStrToTime(AValue, dtValue) then begin
                TDateTimePicker(oComp).Time := dtValue;
            end else begin
                dwMessage('except when deSetEditFieldValue! not time format : '+AValue,'error',oForm);
                Exit;
            end;
        end else if sType = 'tree' then begin        //----- 19 -----
            TEdit(oComp).Text   := AValue;
        end else if sType = 'treepair' then begin    //----- 20 -----
            TEdit(oComp).Text   := AValue;
        end else begin
            TEdit(oComp).Text   := AValue;
        end;
        Dec(Result);
    except
        dwMessage('except when deSetEditFieldValue : '+IntTostr(Result),'error',oForm);
        Exit;
    end;
end;

function  deSetEditFieldReadonly(APanel:TPanel;AName:String;AReadOnly:Boolean):Integer;
var
    oForm       : TForm;
    oComp       : TComponent;
    //
    sPrefix     : String;
    sType       : String;
    //
    joConfig    : Variant;
    joField     : Variant;
    //
    iItem       : Integer;
    iField      : Integer;  //取得field的序号
begin
    Result      := 0;

    try
        //找到窗体
        oForm       := TForm(APanel.Owner);
        Dec(Result);

        //取得JSON配置
        joConfig    := deGetConfig(APanel);
        Dec(Result);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');
        Dec(Result);

        //取得字段序号
        iField      := -1;
        for iItem := 0 to joConfig.fields._Count - 1 do begin
            if LowerCase(joConfig.fields._(iItem).name) = LowerCase(AName) then begin
                iField  := iItem;
                break;
            end;
        end;
        Dec(Result);

        //处理字段序号异常
        if iField = -1 then begin
            //dwMessage('error when deSetEditFieldValue','error',oForm);
            Exit;
        end;
        Dec(Result);

        //找到控件
        oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iField));
        Dec(Result);

        //
        if oComp = nil then begin
            //dwMessage('error when deSetEditFieldValue','error',oForm);
            Exit;
        end;
        Dec(Result);

        //
        joField     := joConfig.fields._(iField);
        sType       := dwGetStr(joField,'type','string');
        if sType = 'auto' then begin                 //----- 1 -----
            //暂空
        end else if sType = 'boolean' then begin     //----- 2 -----
            TComboBox(oComp).Enabled    := AReadonly;
        end else if sType = 'button' then begin      //----- 3 -----
            //暂空
        end else if sType = 'combo' then begin       //----- 4 -----
            TComboBox(oComp).Enabled    := AReadonly;
        end else if sType = 'combopair' then begin   //----- 5 -----
            TComboBox(oComp).Enabled    := AReadonly;
        end else if sType = 'date' then begin        //----- 6 -----
            TDateTimePicker(oComp).Enabled  := AReadonly;
        end else if sType = 'datetime' then begin    //----- 7 -----
            TDateTimePicker(oComp).Enabled  := AReadonly;
        end else if sType = 'dbcombo' then begin     //----- 8 -----
            TComboBox(oComp).Enabled    := AReadonly;
        end else if sType = 'dbcombopair' then begin //----- 9 -----
            TComboBox(oComp).Enabled    := AReadonly;
        end else if sType = 'dbtree' then begin      //----- 10 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'dbtreepair' then begin  //----- 11 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'float' then begin       //----- 12 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'image' then begin       //----- 13 -----
            //暂空
        end else if sType = 'index' then begin       //----- 13A -----
            //序号列
            //暂空
        end else if sType = 'integer' then begin     //----- 14 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'memo' then begin       //----- 15 -----
            TMemo(oComp).Enabled        := AReadonly;
        end else if sType = 'money' then begin       //----- 16 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'string' then begin      //----- 17 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'time' then begin        //----- 18 -----
            TDateTimePicker(oComp).Enabled  := AReadonly;
        end else if sType = 'tree' then begin        //----- 19 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else if sType = 'treepair' then begin    //----- 20 -----
            TEdit(oComp).Enabled        := AReadonly;
        end else begin
            TEdit(oComp).Enabled        := AReadonly;
        end;
        Dec(Result);
    except
        dwMessage('except when deSetEditFieldReadonly : '+IntTostr(Result),'error',oForm);
        Exit;
    end;
end;

function  deGetEditFieldValue(APanel:TPanel;AName:String;var AValue:String):Integer;
var
    oForm       : TForm;
    oComp       : TComponent;
    //
    sPrefix     : String;
    sType       : String;
    //
    joConfig    : Variant;
    joField     : Variant;
    joHint      : Variant;
    //
    iItem       : Integer;
    iField      : Integer;  //取得field的序号
begin
    Result      := 0;
    AValue      := '';

    try
        //
        oForm       := TForm(APanel.Owner);
        Dec(Result);

        //取得JSON配置
        joConfig    := deGetConfig(APanel);
        Dec(Result);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');
        Dec(Result);

        //
        iField      := -1;
        for iItem := 0 to joConfig.fields._Count - 1 do begin
            joField := joConfig.fields._(iItem);
            if LowerCase(joField.name) = LowerCase(AName) then begin
                iField  := iItem;
                break;
            end;
        end;
        Dec(Result);

        if iField = -1 then begin
            //dwMessage('error when deGetEditFieldValue','error',oForm);
            Exit;
        end;
        Dec(Result);

        oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iField));
        Dec(Result);

        //
        if oComp = nil then begin
            //dwMessage('error when deGetEditFieldValue','error',oForm);
            Exit;
        end;
        Dec(Result);

        //
        joField     := joConfig.fields._(iField);
        sType       := dwGetStr(joField,'type','string');
        if sType = 'auto' then begin                 //----- 1 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'boolean' then begin     //----- 2 -----
            AValue  := TComboBox(oComp).Text;
        end else if sType = 'button' then begin      //----- 3 -----
            //暂空
        end else if sType = 'combo' then begin       //----- 4 -----
            AValue  := TComboBox(oComp).Text;
        end else if sType = 'combopair' then begin   //----- 5 -----
            AValue  := TComboBox(oComp).Text;
        end else if sType = 'date' then begin        //----- 6 -----
            AValue  := FormatDateTime('YYYY-MM-DD',TDateTimePicker(oComp).Date);
        end else if sType = 'datetime' then begin    //----- 7 -----
            AValue  := FormatDateTime('YYYY-MM-DD hh:mm:ss',TDateTimePicker(oComp).DateTime);
        end else if sType = 'dbcombo' then begin     //----- 8 -----
            AValue  := TComboBox(oComp).Text;
        end else if sType = 'dbcombopair' then begin //----- 9 -----
            AValue  := TComboBox(oComp).Text;
        end else if sType = 'dbtree' then begin      //----- 10 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'dbtreepair' then begin  //----- 11 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'float' then begin       //----- 12 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'image' then begin       //----- 13 -----
            //根据字段中是否保存路径信息("pathindata":1)分别处理
            joHint  := dwJson(TImage(oComp).Hint);
            if joHint.Exists('src') then begin
                if dwGetInt(joField,'pathindata',0) = 1 then begin
                    AValue  := dwGetStr(joField,'src','');
                end else begin
                    AValue  := dwGetStr(joField,'src','');
                    AValue  := StringReplace(AValue,dwGetStr(joField,'imgdir',''),'',[]);
                end;
            end;
        end else if sType = 'index' then begin       //----- 13A -----
            //序号列
        end else if sType = 'integer' then begin     //----- 14 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'memo' then begin       //----- 15 -----
            AValue  := TMemo(oComp).Text;
        end else if sType = 'money' then begin       //----- 16 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'string' then begin      //----- 17 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'time' then begin        //----- 18 -----
            AValue  := FormatDateTime('hh:mm:ss',TDateTimePicker(oComp).Time);
        end else if sType = 'tree' then begin        //----- 19 -----
            AValue  := TEdit(oComp).Text;
        end else if sType = 'treepair' then begin    //----- 20 -----
            AValue  := TEdit(oComp).Text;
        end else begin
            AValue  := TEdit(oComp).Text;
        end;
        Dec(Result);
    except
        dwMessage('except when deGetEditFieldValue : '+IntTostr(Result),'error',oForm);
        Exit;
    end;
end;

function deGetMainForm(APanel:TPanel):TForm;    //取得主窗体. 而不是当前窗体
begin
    //取得主Form
    Result  := TForm(APanel.Owner);
    if Result.Owner <> nil then begin
        Result  := TForm(Result.Owner);
    end;
end;

//设置当前查询模式. 0:无查询, 1:搜索框智能模糊查询 2:多字段精准/模糊查询
function deSetQueryMode(APanel:TPanel;AMode:Integer;AInited:Boolean):Integer;
var
    oForm       : TForm;
    oFQy        : TFlowPanel;   //Flowpanel Query
    oPQSmt      : TPanel;       //panel query smart
    oBFz        : TButton;      //button fuzzy
    oBQm        : TButton;      //button query mode
    //
    sPrefix     : String;
    joConfig    : Variant;
	bAccept		: boolean;
begin
    //dwMessage('cpSetQueryMode','',TForm(APanel.Owner));

    //
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(APanel.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));
    oPQSmt      := TPanel(oForm.FindComponent(sPrefix+'PQm'));
    oBFz        := TButton(oForm.FindComponent(sPrefix+'BFz'));
    oBQm        := TButton(oForm.FindComponent(sPrefix+'BQm'));

    //
    if not(AMode in [0,1,2]) then begin
        AMode   := 0;
    end;

    // deMode 事件
    if AInited then begin
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,deMode,AMode,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;
    end;

    //切换查询模式： 分字段查询 / 智能模糊查询
    case AMode of
        0 : begin
            //切换到 无查询
            if oFQy <> nil then begin
                oFQY.Visible    := False;
            end;
            if oPQSmt <> nil then begin
                oPQSmt.Visible := False;
            end;
            //该模式下支持2种匹配方式：模糊/精确
            if oBFz <> nil then begin
                oBFz.Visible    := False;
            end;
        end;
        1 : begin
            //切换到 智能模糊查询
            if oFQy <> nil then begin
                oFQY.Visible    := False;
            end;
            if oPQSmt <> nil then begin
                oPQSmt.Visible := True;
            end;
            //该模式下仅支持1种匹配方式：模糊
            if oBFz <> nil then begin
                oBFz.Visible    := False;
            end;
        end;
        2 : begin
            //切换到 多字段查询
            if oFQy <> nil then begin
                oFQY.Visible    := True;
                oFQy.OnResize(oFQy);
                oFQy.Top    := -1;
            end;
            if oPQSmt <> nil then begin
                oPQSmt.Visible := False;
            end;
            //该模式下支持2种匹配方式：模糊/精确
            if oBFz <> nil then begin
                if dwGetInt(joConfig,'fuzzy',1) = 1 then begin
                    oBFz.Visible    := True;
                end;
            end;
        end;
    else
    end;

    //将当前状态保存在BQm的tag中
    if oBQm <> nil then begin
        oBQm.Tag    := AMode;
    end;

end;

function dwGetDWStyle(AHint:Variant):String;
begin
     Result    := '';
     if AHint <> unassigned then begin
          if AHint.Exists('dwstyle') then begin
               Result    := (AHint.dwstyle);
          end;
     end;
end;

function dwGetDWAttr(AHint:Variant):String;
begin
     Result    := '';
     if AHint<>null then begin
          if AHint.Exists('dwattr') then begin
               Result    := ' '+(AHint.dwattr);
          end;
     end;
end;


//将函数cpDbToTreeListJson生成的JSON转化为TreeView
//结构类似[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
//只是结构类似,但 上述是javascript对象， 参数应该JSON
function deTreeListJsonToTV(AList:Variant;ATV:TTreeView):Integer;
    procedure _Add(AParentNode:TTreeNode;AJson:Variant);
    var
        iiItem  : Integer;
        ttNode  : TTreeNode;
        jjNode  : Variant;
    begin
        for iiItem := 0 to AJson.children._Count-1 do begin
            jjNode  := AJson.children._(iiItem);
            ttNode  := ATV.Items.AddChild(AParentNode,String(jjNode.label));
            _Add(ttNode,jjNode);
        end;
    end;
begin
    ATV.Items.Clear;
    ATV.Items.Add(nil,AList._(0).label);
    //
    _Add(ATV.Items[0],AList._(0));
end;


//树形表转JSON对象
//ATable为表名
//ACode 为编码字符串，子项编码应大于并包含父类编码
//ADataField 保存在数据表的内容字段名
//AViewField 显示在表格和查询中的内容字段名
//ALink为多级之间的连接字符
//ACount为最多读取的记录数量，默认50
function deDbToTreeListJson(AQuery:TFDQuery;ATable,AData,AView,ALink:String;ACount:Integer):Variant;
var
    iItem       : Integer;
    iIndex      : Integer;
    sCurrData   : String;
    sCurrView   : String;
    sParView    : String;   //父节点的view


    //
    joNode      : variant;
    joIndexs    : Variant;
    //
    vNodes      : array of variant;
    procedure FindParent(AData:string;AJson:Variant);
    var
        iiItem  : Integer;
        jjNode  : Variant;
    begin
        for iiItem := 0 to AJson._Count - 1 do begin
            jjNode  := AJson._(iiItem);
            if (Pos(String(jjNode.id),AData) = 1) and (AData <> String(jjNode.id)) then begin
                sParView    := jjNode.label;
                joIndexs.Add(iiItem);
            end;
            //
            FindParent(AData,jjNode.children);
        end;
    end;
begin
    try
        Result  := _json('[]');

        //根据已知条件打开查询
        AQuery.Disconnect();
        AQuery.Close;
        AQuery.SQL.Text := 'SELECT '+AData+', '+AView+' AS AV' +' FROM '+ATable+' ORDER BY ' + AData;
        //
        AQuery.FetchOptions.RecsSkip    := 0;
        AQuery.FetchOptions.RecsMax     := ACount;  //只读若干条记录，默认为50
        AQuery.Open;

        //先写入第一条记录
        sCurrData   := AQuery.Fields[0].AsString;
        sCurrView   := AQuery.Fields[1].AsString;

        //生成当前节点数据
        joNode          := _json('{}');
        joNode.id       := sCurrData;
        joNode.label    := sCurrView;
        jonode.children := _json('[]');

        //
        Result.Add(joNode);

        //
        AQuery.Next;

        //循环处理所有数据
        while not AQuery.Eof do begin
            sCurrData   := AQuery.Fields[0].AsString;
            sCurrView   := AQuery.Fields[1].AsString;

            //生成当前节点数据
            joNode          := _json('{}');
            joNode.id       := sCurrData;
            joNode.label    := sCurrView;
            jonode.children := _json('[]');


            //查找其父节点
            joIndexs    := _json('[]');
            sParView    := '';
            FindParent(sCurrData,Result);

            //
            SetLength(vNodes,Integer(joIndexs._Count)+1);
            vNodes[0]   := Result ;
            for iItem := 0 to joIndexs._Count-1 do begin
                iIndex          := joIndexs._(iItem);
                vNodes[iItem+1] := vNodes[iItem]._(iIndex).children;
            end;
            //
            if ALink <> '' then begin
                if sParView = '' then begin
                    joNode.label    := sCurrView;
                end else begin
                    joNode.label    := sParView + ALink + sCurrView;
                end;
            end;
            //
            vNodes[Integer(joIndexs._Count)].Add(joNode);

            //
            Result  := vNodes[0];

            //
            AQuery.Next;
        end;

    except

    end;

end;

//树形表转字符串，如[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
//ATable为表名
//ACode 为编码字符串，子项编码应大于并包含父类编码
//ADataField 保存在数据表的内容字段名
//AViewField 显示在表格和查询中的内容字段名
//ALink为多级之间的连接字符
function deDbToTreeList(AQuery:TFDQuery;ATable,AData,AView,ALink:String;ACount:Integer):String;
var
    //
    joRes       : Variant;
begin
    try
        //先生成JSON
        joRes   := deDbToTreeListJSON(AQuery,ATable,AData,AView,ALink,ACount);

        //取得JSON格式 字符串
        Result  := joRes;

        //
        Result  := StringReplace(Result,'"id":','id:',[rfReplaceAll]);
        Result  := StringReplace(Result,'"label":','label:',[rfReplaceAll]);
        Result  := StringReplace(Result,',"children":[]','',[rfReplaceAll]);
        Result  := StringReplace(Result,'"children":','children:',[rfReplaceAll]);
        Result  := StringReplace(Result,'"','''',[rfReplaceAll]);

    except

    end;

end;

//DBEditor内的任意子孙控件查找源crud Panel
function deGetDBEditor(ACtrl:TControl):TPanel;
var
    oCtrl   : TControl;
begin
    /////////////////////////
    ///原理是查找当前控件的父控件，如果是TPanel且HelpContext为31027，则停止
    /////////////////////////

    Result  := nil;
    if (ACtrl <> nil) and (ACtrl.Parent<>nil) then begin
        if (ACtrl.ClassType = TPanel) and (ACtrl.HelpContext = 250629) then begin
            Result  := TPanel(ACtrl);
        end else begin
            oCtrl   := ACtrl;
            while True do begin
                oCtrl   := oCtrl.Parent;
                if oCtrl = nil then begin
                    break;
                end;
                if (oCtrl.ClassType = TPanel) and (oCtrl.HelpContext = 250629) then begin
                    Result  := TPanel(oCtrl);
                    break;
                end;
            end;
        end;
    end;
end;

function deGetConfig(APanel:TPanel):Variant;
var
    iField      : Integer;
    //
    joField     : Variant;
begin
    try
        //取配置JSON : 读AForm的 deConfig 变量值
        Result  := _json(APanel.Hint);

        //如果不是JSON格式，则退出
        if Result = unassigned then begin
            Exit;
        end;

        //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        if not Result.Exists('border') then begin    //默认表格显示竖线
            Result.border   := 1;
        end;
        //radius与原panel的radius冲突，所以不能用
        if not Result.Exists('borderradius') then begin     //角半径
            Result.borderradius := 0;
        end;
        if not Result.Exists('buttoncaption') then begin    //按钮显示标题设置
            Result.buttoncaption    := 1;  //0:全不显示,1:全显示,2:左显右侧(隐藏/显示,模糊/精确,查询模式)不显
        end;
        if not Result.Exists('buttons') then begin          //PBs
            Result.buttons    := 1;
        end;
        if not Result.Exists('cancel') then begin         //默认取消
            Result.cancel   := 1;
        end;
        if not Result.Exists('delete') then begin       //默认显示删除按钮
            Result.delete  := 0;
        end;
        if not Result.Exists('defaultquerymode') then begin //默认查询
            Result.defaultquerymode  := 0;
        end;
        if not Result.Exists('editwidth') then begin    //数据编辑框的宽度
            Result.editwidth := 360;
        end;
        if not Result.Exists('export') then begin       //默认显示导出按钮
            Result.export   := 1;
        end;
        if not Result.Exists('import') then begin       //默认不显示导入按钮
            Result.import   := 0;
        end;
        if not Result.Exists('exportonlyvisible') then begin  //默认显示导出按钮
            Result.exportonlyvisible  := 1;
        end;
        if not Result.Exists('fields') then begin       //显示的字段列表
            Result.fields  := _json('[]');
        end;
        if not Result.Exists('margin') then begin       //默认边距
            Result.margin := 10;
        end;
        if not Result.Exists('new') then begin          //默认显示新增按钮
            Result.new  := 0;
        end;
        if not Result.Exists('query') then begin        //默认显示查询
            Result.query  := 1;
        end;
        if not Result.Exists('save') then begin         //默认保存
            Result.save   := 1;
        end;
        if not Result.Exists('page') then begin         //是否显示分页
            Result.page   := 0;
        end;
        if not Result.Exists('switch') then begin       //默认显示切换搜索模式按钮
            Result.switch   := 0;
        end;
        if not Result.Exists('table') then begin        //默认表名
            Result.table := 'dw_member';
        end;
        if not Result.Exists('where') then begin        //默认where
            Result.where := '';
        end;

        //如果设置了只读,可一次性禁止new/edit/delete/import
        if dwGetInt(Result,'readonly') = 1 then begin
            Result.new      := 0;
            Result.edit     := 0;
            Result.delete   := 0;
            Result.import   := 0;
        end;

        //确保存在fields子对象数组
        if not Result.Exists('fields') then begin
            Result.fields := _json('[]')
        end else begin
            if Result.fields = null then begin
            Result.fields := _json('[]')
            end;
        end;


        //更新各字段的默认值
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
            if not joField.Exists('sort') then begin        //默认不排序
                joField.sort    := 0;
            end;
            if not joField.Exists('fuzzy') then begin       //默认模糊查询
                joField.fuzzy    := 1;
            end;
            if not joField.Exists('query') then begin       //默认不查询
                joField.query   := 0;
            end;
            if not joField.Exists('align') then begin       //默认居中显示
                joField.align   := 'left';
            end;

        end;

    except

    end;
end;


Procedure deLinkageChange(Sender: TObject);    //带Linkage属性的联动事件
var
    oCombo      : TComboBox;
    oComboLink  : TComboBox;    //被控的字段
    oDBEditor  : TPanel;
    oForm       : TForm;
    oFQTemp     : TFDQuery;
    //
    sPrefix     : String;
    sName       : string;
    sValue      : string;       //当前字段对应的数据表值
    sSQL        : String;
    iField      : Integer;
    iItem       : Integer;
    iIndex      : Integer;
    iList       : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
    joTarget    : Variant;
    joPair      : Variant;
    joList      : Variant;
begin
    //dwMessage('LinkageChange','',TForm(TCombo(Sender)).Owner));

    //取得各控件
    oCombo      := TComboBox(Sender);   //sPrefix + 'F' + ASuffix = inttostr(ifield)
    oForm       := TForm(oCombo.Owner);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //取得当前配置
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix');

    //取得当前控件的index
    sName       := oCombo.Name;
    Delete(sName,1,Length(sPrefix)+1);
    iField      := StrToIntDef(sName,-1);
    if iField < 0 then begin
        Exit;
    end;
    if iField > joConfig.fields._Count  then begin
        Exit;
    end;
    joField := joConfig.fields._(iField);

    //异常处理
    if not joField.Exists('linkages') then begin
        Exit;
    end;

    //取得当前combo对应的数据表值. 主要是因为如果是combopair/dbcombopair类型时, 不能直接用text
    sValue  := oCombo.Text;
    if (joField.type = 'combopair') or (joField.type = 'dbcombopair') then begin
        for iItem := 0 to joField.list._Count - 1 do begin
            if joField.list._(iItem)._(1) = sValue then begin
                sValue  := joField.list._(iItem)._(0);
                break;
            end;
        end;
    end;

    //取得目标 comboBox
    oFQTemp     := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQTemp'));

    //
    for iItem := 0 to joField.linkages._Count - 1 do begin
        //取得目标字段的index
        iIndex  := dwGetInt(joField.linkages._(iItem),'index',-1);

        if iIndex < 0 then begin
            Continue;
        end;

        //取得目标控件
        oComboLink  := TComboBox(oForm.FindComponent(sPrefix+'F'+IntToStr(iIndex)));

        //
        if oComboLink.ClassName <> 'TComboBox' then begin
            Exit;
        end;

        //取得目标字段json
        joTarget    := joConfig.fields._(iIndex);

        //取得SQL语句
        sSQL    := dwGetStr(joField.linkages._(iItem),'sql');
        if sSQL = '' then begin
            Continue;
        end;
        if Pos('{aaa}',sSQL) <= 0 then begin
            Continue;
        end;

        //替换{aaa}
        if TFieldType(joField.datatype) in destInteger then begin
            sSQL    := StringReplace(sSQL,'{aaa}',sValue,[]);
        end else begin
            sSQL    := StringReplace(sSQL,'{aaa}',''''+sValue+'''',[]);
        end;

        //
        oFQTemp.Open(sSQL);

        //更新目标字段list  更新显示 comboBox
        joTarget.linkagelist	:= _json('[]');

        if oFQTemp.FieldCount > 1 then begin
            //:::如果有多个字段, 则生成为pair. 读前2个字段


            while not oFQTemp.Eof do begin
                joPair  := _json('[]');
                joPair.Add(oFQTemp.Fields[0].AsString);

                joPair.Add(oFQTemp.Fields[1].AsString);
                //
                joTarget.linkagelist.Add(joPair);
                //
                oFQTemp.Next;
            end;

            //默认添加一个空值
            with oCombolink do begin
                Text    := '';
                Items.Clear;
                joList  := joTarget.linkagelist;
                //
                Items.Add('');
                //添加选项
                for iList := 0 to joList._Count-1 do begin
                    Items.Add(joList._(iList)._(1));
                end;

                //默认为第1个选项
                if Items.Count > 1 then begin
                    ItemIndex   := 1;
                end;
            end;
        end else begin
            //:::如果只有一个字段, 则直接生成combo模式, 没有pair映射

            while not oFQTemp.Eof do begin
                //
                joTarget.linkagelist.Add(oFQTemp.Fields[0].AsString);
                //
                oFQTemp.Next;
            end;

            //默认添加一个空值
            with oCombolink do begin
                Text    := '';
                Items.Clear;
                Items.Add('');

                //添加选项
                for iList := 0 to joList._Count-1 do begin
                    Items.Add(joList._(iList));
                end;

                //默认为第1个选项
                if Items.Count > 1 then begin
                    ItemIndex   := 1;
                end;
            end;
        end;
    end;

    //将joconfig反写回Hint
    oDBEditor.Hint := joConfig;

end;



Procedure deFieldChange(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
    bAccept     : boolean;
    //
    sPrefix     : String;
    sName       : string;
    iField      : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));


    //取得当前配置
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix');

    //根据名称, 取得当前控件的在fields中的index
    sName       := TControl(Sender).Name;
    Delete(sName,1,Length(sPrefix)+1);
    iField      := StrToIntDef(sName,-1);
    if iField < 0 then begin
        Exit;
    end;
    if iField > joConfig.fields._Count  then begin
        Exit;
    end;

    // deChange 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,Sender,deChange,iField,dsDragEnter,bAccept);
    end;

    //控制linkage
    joField := joConfig.fields._(iField);
    if joField.Exists('linkages') then begin
        deLinkageChange(Sender);
    end;

end;

Procedure deFieldEnter(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
	bAccept		: boolean;
begin
    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    // deEnter 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,Sender,deEnter,0,dsDragEnter,bAccept);
    end;
end;
Procedure deFieldExit(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
	bAccept		: boolean;
begin
    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    // deExit 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,Sender,deExit,0,dsDragEnter,bAccept);
    end;
end;


//根据列号，求JSON序号
function  deGetJsonIdFromColId(AConfig:Variant;ACol:Integer):Integer;
var
    iItem       : Integer;
    iCurCol     : Integer;
    joField     : Variant;
begin
    try
        Result  := -1;

        //如果有选择列，则加1
        iCurCol := -1;
        if dwGetInt(AConfig,'select',0)>0 then begin
            iCurCol := 0;
        end;

        //
        if ACol = iCurCol then begin
            Result  := -1;
            Exit;
        end;

        //
        for iItem := 0 to AConfig.fields._Count - 1 do begin
            joField := AConfig.fields._(iItem);
            if dwGetInt(joField,'view',0) in [0,3] then begin
                Inc(iCurCol);
            end;
            //
            if ACol = iCurCol then begin
                Result  := iItem;
                Exit;
            end;
        end;
    except
        Result  := -1;
    end;

end;

function deGetCaptions(AFields:Variant;AVisbileOnly:Boolean):String;
var
    iField      : Integer;
    joField     : variant;
    joRes       : Variant;
begin
    try
        joRes   := _json('[]');
        //拼接字段字符串
        for iField := 0 to AFields._Count-1 do begin
            //取得当前字段JSON对象
            joField := AFields._(iField);

            //控制可视化
            if AVisbileOnly and (not (dwGetInt(joField,'view',0) in [0,3])) then begin
                Continue;
            end;

            //
            if joField.type <> 'check'  then begin
                joRes.Add(dwGetStr(AFields._(iField),'caption',''));
            end;
        end;
        //
        Result  := joRes;
    except
        Result  := 'ErrorWhen_GetCaptions';
    end;
end;

//返回指定条件的index集合, 返回类似[1,3,6,7,8]
function deGetIndexs(AFields:Variant;AVisbileOnly:Boolean):String;
var
    iField      : Integer;
    joField     : variant;
    joRes       : Variant;
begin
    try
        joRes   := _json('[]');
        //拼接字段字符串
        for iField := 0 to AFields._Count-1 do begin
            //取得当前字段JSON对象
            joField := AFields._(iField);

            //控制可视化
            if AVisbileOnly and (not (dwGetInt(joField,'view',0) in [0,3])) then begin
                Continue;
            end;

            //
            if joField.type <> 'check'  then begin
                joRes.Add(iField);
            end;
        end;
        //
        Result  := joRes;
    except
        Result  := 'ErrorWhen_cpGetIndexs';
    end;
end;


//从JSON对象fields中取得字符串形式的字段列表，以用于sql语句
//返回值形如：id,fieldname,filetime,size
//同时把当前字段JSON对应的数据表字段以fieldid写入json中
function deGetFields(AFields:Variant;AVisibleOnly:Boolean):String;
var
    iField      : Integer;
    joField     : variant;
    iFieldId    : Integer;  //数据表字段序号, 用于后面准确定位数据表字段
begin
    try
        Result  := '';

        //拼接字段字符串
        iFieldId    := 0;
        for iField := 0 to AFields._Count-1 do begin
            joField := AFields._(iField);

            //是否仅处理可视字段
            if AVisibleOnly then begin
                if not (dwGetInt(joField,'view',0) in [0,3]) then begin
                    Continue;
                end;
            end;

            //
            if joField.type = 'index' then begin
                joField.fieldid := -1;
                Continue;
            end;

            //
            if joField.type = 'button' then begin
                joField.fieldid := -2;
                Continue;
            end;

            //
            if joField.Exists('name') then begin
                Result := Result + AFields._(iField).name + ',';

                //当前字段JSON对应的数据表字段以fieldid写入json中
                joField.fieldid := iFieldId;
                Inc(iFieldId);
            end;
        end;

        //删除最后的逗号
        if Length(Result)>1 then begin
            Delete(Result,Length(Result),1);
        end;
    except
        Result  := 'ErrorWhen_GetFields';
    end;
end;

//取得当前表格是否多选
//输入值：AForm为当前窗本
//返回值：为字符串，如果没有，则为"[]",否则为类似"["3","5","6"]"
//        异常返回 NoStringGridIn_GetSelection / ErrorWhen_GetSelection
function deGetSelection(APanel:TPanel):String;
var
    sPrefix     : String;
    oForm       : TForm;
    oSG         : TStringGrid;
    joConfig     : variant;
    joHint      : variant;
begin

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

	//取得Form备用
	oForm       := TForm(APanel.Owner);

    try
        //默认返回值
        Result  := '[]';

        //查找控件
        oSG     := TStringGrid(oForm.FindComponent(sPrefix+'SgD'));

        //异常检查
        if oSG = nil then begin
            Result  := 'error!NoStringGridIn_GetSelection';
            Exit;
        end;

        //读SG的hint取得返回值
        joHint  := _json(oSG.Hint);
        if joHint.Exists('__selection') then begin
            Result    := joHint.__selection;
        end;

    except
        Result  := 'error!When_GetSelection';
    end;
end;



//将类似字符转为JSON
//[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
function deGetTreeListJson(AList:String):Variant;
begin
    AList   := stringReplace(AList,'''','"',[rfReplaceAll]);
    AList   := stringReplace(AList,'id:','"id":',[rfReplaceAll]);
    AList   := stringReplace(AList,'label:','"label":',[rfReplaceAll]);
    AList   := stringReplace(AList,',children:',',"children":',[rfReplaceAll]);
    Result  := _json(AList);
end;

//根据当前数据表记录的存储值，以及树形列表，找出对应的显示值
function deGetTreeListView(AList:Variant;AData:String):String;
var
    iItem   : Integer;
begin
    Result  := '';
    //
    if AList._Count >0 then begin
        for iItem := 0 to AList._Count - 1 do begin
            if AList._(iItem).id = AData then begin
                Result  := AList._(iItem).label;
                break;
            end else begin
                if AList._(iItem).Exists('children') then begin
                    Result  := deGetTreeListView(AList._(iItem).children,AData);
                    if Result <> '' then begin
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

//根据当前数据表记录的显示值，以及树形列表，找出对应的存储值
function deGetTreeListData(AList:Variant;AView:String):String;
var
    iItem   : Integer;
begin
    Result  := '';
    //
    if AList._Count >0 then begin
        for iItem := 0 to AList._Count - 1 do begin
            if AList._(iItem).label = AView then begin
                Result  := AList._(iItem).id;
                break;
            end else begin
                if AList._(iItem).Exists('children') then begin
                    Result  := deGetTreeListData(AList._(iItem).children,AView);
                    if Result <> '' then begin
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

function deAppend(
    APanel:TPanel;      //控件所在窗体
    AQuery:TFDQuery;    //数据查询
    AFields:Variant;    //字段列表JSON
    AKeep:Boolean       //是否保持上一次的值
    ):Integer;
var
    iField      : Integer;
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    iItem       : Integer;
    //
    joField     : Variant;
    joConfig    : Variant;
    joInfo      : Variant;
    //
    oForm       : TForm;
    oPEr        : TPanel;       //panel Editor
    oComp       : TComponent;
    oCB         : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    oM          : TMemo;
    oI          : TImage;
    oField      : TField;       //字段变量，用于简化代码
    //
    sPrefix     : String;
    sFields     : string;
    bAccept     : Boolean;
begin
    try
        //取得Form备用
        oForm   := TForm(APanel.Owner);

        //取得参数配置JSON对象，以便后续处理
        joConfig    := deGetConfig(APanel);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        // deAppendBefore 事件
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,deAppendBefore,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //-----
        //2024-11-15 使用达梦数据库时发现，当FDQuery1.FetchOptions.RecsMax 不为-1，
        //且数据表中有自增字段时， post时报错！！！
        //所以采用了一个复杂的机制：
        //1 新增前把Aquery的关键信息（RecsMax，RecsSkip,SQL.text）保存在PEr(编辑/新增的总面板)的caption中
        //2 关闭AQuery
        //3 设置RecsMax=-1，RecsSkip=0
        //4 重新open AQuery,其中 where (1=0)
        //5 AQuery.append
        //6 在post或cancel时， 根据以前保存的关键信息 （RecsMax，RecsSkip,SQL.text） 重新打开AQuery
        //-----

        //<先添加上述机制中的1/2/3/4
        //1 新增前把Aquery的关键信息（RecsMax，RecsSkip,SQL.text）保存在PEr(编辑/新增的总面板)的caption中
        joInfo          := _json('{}');
        joInfo.recsmax  := AQuery.FetchOptions.RecsMax;
        joInfo.recsskip := AQuery.FetchOptions.RecsSkip;
        joInfo.sqltext  := AQuery.SQL.Text;
        oPEr            := TPanel(oForm.FindComponent(sPrefix+'PEr'));
        oPEr.Caption    := String(joInfo);

        //2 关闭AQuery
        AQuery.Close;

        //3 设置RecsMax=-1，RecsSkip=0
        AQuery.FetchOptions.RecsMax     := -1;
        AQuery.FetchOptions.RecsSkip    := 0;

        //4 重新open AQuery,其中 where (1=0)
        sFields     := deGetFields(joConfig.Fields,False);
        AQuery.SQL.Text := 'SELECT '+sFields+' FROM '+String(+joConfig.table )+' WHERE (1=0)';
        AQuery.Open;
        //>

        //新增
        AQuery.Append;

        // deAppendAfter 事件
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,deAppendAfter,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //如果定义的批量添加时保持上一次的值, 则不更新
        if not AKeep then begin
            //循环处理各字段
            for iField := 0 to AFields._Count -1 do begin
                //取得字段的JSON
                joField := AFields._(iField);

                //取得当前JSON字段对应的数据表字段index
                iFieldId    := dwGetInt(joField,'fieldid',-1);

                //不处理序号列,不处理按钮列
                if iFieldId < 0 then begin
                    Continue;
                end;

                //取得对应控件
                oComp   := oForm.FindComponent(sPrefix + 'F' + IntToStr(iField));

                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin

                    //取得字段变量，以简化代码
                    oField  := AQuery.Fields[iFieldId];

                    //根据当前字段JSON信息进行处理
                    //------------------------ 1 append --------------------------------------------------------------------
                    if joField.type = 'auto' then begin                 //----- 1 -----
                        oE          := TEdit(oComp);
                        oE.Text     := oField.AsString;
                        TEdit(oComp).Enabled    := False;

                    end else if joField.type = 'boolean' then begin     //----- 2 -----
                        oCB := TComboBox(oComp);
                        if joField.Exists('default') then begin
                            if joField.Exists('list') then begin
                                oField.AsBoolean    := False;
                                if joField.list._Count > 1 then begin
                                    if joField.list._(1) = dwGetStr(joField,'default') then begin
                                        oField.AsBoolean    := True;
                                    end;
                                end;
                            end else begin
                                oField.AsBoolean    := dwGetInt(joField,'default',0)=1;
                            end;
                        end else begin
                            oField.AsBoolean    := False;
                        end;
                        oCB.ItemIndex   := dwIIFi(oField.AsBoolean,1,0);
                    end else if joField.type = 'button' then begin      //----- 3 -----
                        //暂空

                    end else if joField.type = 'combo' then begin       //----- 4 -----
                        oCB := TComboBox(oComp);
                        if joField.Exists('default') then begin
                            oField.AsString   := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsString   := '';
                            end;
                        end;
                        oCB.Text    := oField.AsString;

                    end else if joField.type = 'combopair' then begin   //----- 5 -----
                        oCB := TComboBox(oComp);
                        if joField.Exists('default') then begin
                            if joField.Exists('list') then begin
                                for iItem := 0 to joField.list._Count - 1 do begin
                                    if joField.list._(iItem)._(1) = joField.default then begin
                                        oField.AsString     := joField.list._(iItem)._(0);
                                        oCB.Text            := joField.default;
                                        break;
                                    end;
                                end;
                            end;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsString   := '';
                            end;
                            oCB.Text    := oField.AsString;
                        end;

                    end else if joField.type = 'date' then begin        //----- 6 -----
                        oDT := TDateTimePicker(oComp);
                        if joField.Exists('default') then begin
                            oField.AsDateTime := StrToDateDef(joField.default,Now);
                        end else begin
                            if oField.IsNull then begin
                                oField.AsDateTime := Now;
                            end;
                        end;
                        oDT.Kind    := dtkDate;
                        oDT.Date    := oField.AsDateTime;

                    end else if joField.type = 'datetime' then begin    //----- 7 -----
                        oDT := TDateTimePicker(oComp);
                        if joField.Exists('default') then begin
                            oField.AsDateTime := StrToDateTimeDef(String(joField.default),Now);
                        end else begin
                            if oField.IsNull then begin
                                oField.AsDateTime := Now;
                            end;
                        end;
                        oDT.DateTime    := oField.AsDateTime;

                    end else if joField.type = 'dbcombo' then begin     //----- 8 -----
                        oCB := TComboBox(oComp);
                        if joField.Exists('default') then begin
                            oField.AsString   := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsString   := '';
                            end;
                        end;
                        oCB.Text:= oField.AsString;

                    end else if joField.type = 'dbcombopair' then begin //----- 9 -----
                        oCB := TComboBox(oComp);
                        if joField.Exists('default') then begin
                            if joField.Exists('list') then begin
                                for iItem := 0 to joField.list._Count - 1 do begin
                                    if joField.list._(iItem)._(1) = joField.default then begin
                                        oField.AsString     := joField.list._(iItem)._(0);
                                        oCB.Text            := joField.default;
                                        break;
                                    end;
                                end;
                            end;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsString   := '';
                            end;
                            oCB.Text:= oField.AsString;
                        end;

                    end else if joField.type = 'dbtree' then begin      //----- 10 -----
                        oE          := TEdit(oComp);
                        oE.Text     := oField.AsString;
                        //TEdit(oComp).Enabled    := False;

                    end else if joField.type = 'dbtreepair' then begin  //----- 11 -----
                        oE          := TEdit(oComp);
                        oE.Text     := oField.AsString;
                        //TEdit(oComp).Enabled    := False;

                    end else if joField.type = 'float' then begin       //----- 12 -----
                        oE  := TEdit(oComp);
                        if joField.Exists('default') then begin
                            oField.AsFloat  := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsFloat   := 0;
                            end;
                        end;
                        oE.Text := oField.AsString;

                    end else if joField.type = 'image' then begin       //----- 13 -----
                        oI  := TImage(oComp);
                        if joField.Exists('default') then begin
                            oField.AsString := joField.default;
                        end;
                        //根据字段中是否保存路径信息("pathindata":1)分别处理
                        if dwGetInt(joField,'pathindata',0) = 1 then begin
                            oI.Hint := '{"src":"'+oField.AsString+'"}';
                        end else begin
                            oI.Hint := '{"src":"'+dwGetStr(joField,'imgdir','')+oField.AsString+'"}';
                        end;

                    end else if joField.type = 'index' then begin       //----- 13A -----
                        //序号列
                    end else if joField.type = 'integer' then begin     //----- 14 -----
                        oE  := TEdit(oComp);
                        if joField.Exists('default') then begin
                            oField.AsInteger  := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsInteger   := 0;
                            end;
                        end;
                        oE.Text := oField.AsString;

                    end else if joField.type = 'memo' then begin       //----- 15 -----
                        oM  := TMemo(oComp);
                        if joField.Exists('default') then begin
                            oField.AsString   := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsString   := '';
                            end;
                        end;
                        oM.Text := oField.AsString;

                    end else if joField.type = 'money' then begin       //----- 16 -----
                        oE  := TEdit(oComp);
                        if joField.Exists('default') then begin
                            oField.AsFloat   := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsFloat   := 0;
                            end;
                        end;
                        oE.Text := oField.AsString;

                    end else if joField.type = 'string' then begin      //----- 17 -----
                        oE  := TEdit(oComp);
                        if joField.Exists('default') then begin
                            oField.AsString   := joField.default;
                        end;
                        oE.Text := oField.AsString;

                    end else if joField.type = 'time' then begin        //----- 18 -----
                        oDT := TDateTimePicker(oComp);
                        if joField.Exists('default') then begin
                            oField.AsDateTime := StrToTimeDef(joField.default,Now);
                        end else begin
                            if oField.IsNull then begin
                                oField.AsDateTime := Now;
                            end;
                        end;
                        oDT.Kind    := dtkTime;
                        oDT.Time    := oField.AsDateTime;

                    end else if joField.type = 'tree' then begin        //----- 19 -----
                        oE          := TEdit(oComp);
                        oE.Text     := oField.AsString;
                        TEdit(oComp).Enabled    := False;

                    end else if joField.type = 'treepair' then begin    //----- 20 -----
                        oE          := TEdit(oComp);
                        oE.Text     := oField.AsString;
                        TEdit(oComp).Enabled    := False;

                    end else begin
                        oE  := TEdit(oComp);
                        if joField.Exists('default') then begin
                            oField.AsString   := joField.default;
                        end else begin
                            if oField.AsVariant = null then begin
                                oField.AsString   := '';
                            end;
                        end;
                        oE.Text := oField.AsString;
                    end;

                    //设置只读（编辑时只读，新增时可编辑）
                    //if joField.type <> 'auto' then begin
                    //    if joField.readonly = 1 then begin
                    //        if joField.Exists('default') then begin
                    //            TEdit(oComp).Enabled    := False;
                    //        end else begin
                    //            TEdit(oComp).Enabled    := True;
                    //        end;
                    //    end;
                    //end;

                end;
            end;
        end;
    except
    end;
end;


//取数据字段的值
function deGetFieldValue(AField:TField;AConfig:Variant):String;
var
    iTemp       : Integer;
    sTemp       : string;
    joField     : Variant;
    joList      : Variant;
begin
    //默认为空
    Result  := '';

    //异常退出
    if AConfig = unassigned then begin
        Exit;
    end;
    if AField.IsNull then begin
        Exit;
    end;

    //指定默认DBEditor字段类型
    if not AConfig.Exists('type') then begin
        AConfig.type    := 'string';
    end;

    //默认值
    Result  := AField.AsString;

    //根据当前类型重新赋值
    if AConfig.type = 'auto' then begin                     //----- 1 -----

    end else if AConfig.type = 'boolean' then begin         //----- 2 -----
        if AConfig.Exists('list')  then begin
            if AConfig.list._Count > 1 then begin
                Result  := dwIIF(AField.AsBoolean,AConfig.list._(1),AConfig.list._(0));
            end;
        end;
    end else if AConfig.type = 'button' then begin          //----- 3 -----

    end else if (AConfig.type = 'combo') then begin         //----- 4 -----
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if (AConfig.type = 'combopair') then begin     //----- 5 -----
        //根据 viewdefault 设置默认值
        if AConfig.Exists('viewdefault') then begin
            Result  := dwGetStr(AConfig,'viewdefault');
        end;

        //从列表中查找对应值
        if AField.AsString <> '' then begin
            for iTemp := 0 to AConfig.list._Count - 1 do begin
                if AConfig.list._(iTemp)._(0) = AField.AsString then begin
                    Result  := AConfig.list._(iTemp)._(1);
                    break;
                end;
            end;
        end;
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'date' then begin            //----- 6 -----
        if AField.IsNull OR (AField.AsDateTime < EncodeDate(1900, 1, 2) ) then begin
            Result  := '';
        end else begin
            if AConfig.Exists('format') then begin
                Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
            end else begin
                if Trunc(AField.AsDateTime) = 0 then begin
                    Result  := '';
                end else begin
                    Result  := FormatDatetime('yyyy-MM-dd',AField.AsDateTime);
                end;
            end;
        end;

    end else if AConfig.type = 'datetime' then begin        //----- 7 -----
        if AField.IsNull OR (AField.AsDateTime < EncodeDate(1900, 1, 2) ) then begin
            Result  := '';
        end else begin
            if AConfig.Exists('format') then begin
                Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
            end else begin
                if Trunc(AField.AsDateTime) = 0 then begin
                    Result  := '';
                end else begin
                    Result  := FormatDatetime('yyyy-MM-dd hh:mm:ss',AField.AsDateTime);
                end;
            end;
        end;

    end else if (AConfig.type = 'dbcombo') then begin       //----- 8 -----
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if (AConfig.type = 'dbcombopair') then begin   //----- 9 -----
        //根据 viewdefault 设置默认值
        if AConfig.Exists('viewdefault') then begin
            Result  := dwGetStr(AConfig,'viewdefault');
        end;

        //从列表中查找对应值
        if AField.AsString <> '' then begin
            for iTemp := 0 to AConfig.list._Count - 1 do begin
                if AConfig.list._(iTemp)._(0) = AField.AsString then begin
                    Result  := AConfig.list._(iTemp)._(1);
                    break;
                end;
            end;
        end;
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'dbtree' then begin          //----- 10 -----
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsString]);
        end else begin
            Result  := AField.AsString;
        end;

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;
    end else if AConfig.type = 'dbtreepair' then begin      //----- 11 -----
        if AField.AsString <> '' then begin
            //将tree的list转化为JSON
            joList  := deGetTreeListJson(AConfig.list);
            //查找对应的显示值
            Result  := deGetTreeListView(joList,AField.AsString);
        end;

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;
    end else if AConfig.type = 'float' then begin           //----- 12 -----
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else if Pos('f',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[AField.AsFloat]);
            end else if Pos('d',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[Round(AField.AsFloat)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'image' then begin           //----- 13 -----
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsString]);
        end else begin
            Result  := AField.AsString;
        end;

    end else if AConfig.type = 'index' then begin           //----- 13A -----
        //序号列 等于start值+记录号
        Result  := IntToStr(dwGetInt(AConfig,'start',1)-1+AField.DataSet.RecNo);
    end else if AConfig.type = 'integer' then begin         //----- 14 -----
        Result  := IntToStr(AField.AsInteger);

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;
    end else if AConfig.type = 'link' then begin            //----------
        //取得url字段名
        sTemp   := dwGetStr(AConfig,'urlfield',AConfig.name);
        if AField.DataSet.FieldByName(sTemp) <> nil then begin
            sTemp   := AField.DataSet.FieldByName(sTemp).AsString;
            Result  := '<a%s style="%s" href="%s" target="%s">%s</a>';
            Result  := Format(Result,[dwGetDWAttr(AConfig),dwGetDWStyle(AConfig),sTemp,dwGetStr(AConfig,'target','_blank'),AField.AsString]);
        end;

    end else if (AConfig.type = 'linkage') then begin       //----------
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if (AConfig.type = 'linkagepair') then begin   //----------
        //根据 viewdefault 设置默认值
        if AConfig.Exists('viewdefault') then begin
            Result  := dwGetStr(AConfig,'viewdefault');
        end;

        //从列表中查找对应值
        if AField.AsString <> '' then begin
            for iTemp := 0 to AConfig.list._Count - 1 do begin
                if AConfig.list._(iTemp)._(0) = AField.AsString then begin
                    Result  := AConfig.list._(iTemp)._(1);
                    break;
                end;
            end;
        end;
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'memo' then begin            //----- 15 -----

    end else if AConfig.type = 'money' then begin           //----- 16 -----
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsFloat]);
        end else begin
            Result  := Format('%n',[AField.AsFloat]);
        end;

    end else if AConfig.type = 'string' then begin          //----- 17 -----

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'time' then begin            //----- 18 -----
        if AField.IsNull OR (AField.AsDateTime = EncodeDate(1900, 1, 1) + EncodeTime(0, 0, 0, 0)) then begin
            Result  := '';
        end else begin
            if AConfig.Exists('format') then begin
                Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
            end else begin
                Result  := FormatDatetime('hh:mm:ss',AField.AsDateTime);
            end;
        end;

    end else if AConfig.type = 'tree' then begin            //----- 19 -----

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'treepair' then begin        //----- 20 -----
        if AField.AsString <> '' then begin
            //将tree的list转化为JSON
            joList  := deGetTreeListJson(AConfig.list);
            //查找对应的显示值
            Result  := deGetTreeListView(joList,AField.AsString);
        end;

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else begin

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end;

    //替换其中的{{xxx}}字段数据
    if (Pos('{{',Result)>0) and (Pos('}}',Result)>0) then begin
        with TFDQuery(AField.Dataset) do begin
            for iTemp := 0 to FieldCount - 1 do begin
                Result  := StringReplace(Result,'{{'+Fields[iTemp].FieldName+'}}',Fields[iTemp].AsString,[rfReplaceAll]);
            end;
        end;
    end;

    //删除结果中的特殊字符
    Result  := StringReplace(Result,#10,'',[rfReplaceAll]);
    Result  := StringReplace(Result,#13,'',[rfReplaceAll]);

end;

//根据表名、字段名，生成选项JSON数组
function deGetItems(
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

//计算字段列表中在表格中显示的数量
function deGetViewFieldCount(AFields:Variant):Integer;
var
    iItem   : Integer;
begin
    Result  := 0;
    //
    for iItem := 0 to AFields._Count - 1 do begin
        if dwGetInt(AFields._(iItem),'view',0) in [0,3] then begin
            Inc(Result);
        end;
    end;
end;

//群友"顺其自然"写的带关联查询的函数
function deGetWhereJoin(AFields:Variant;AKeyWord:string):string;
var
    iField      : Integer;
    iList       : Integer;
    joField     : variant;
    sType       : string;
    sTmp        : string;
    joTmp       : variant;
    function _GetWhereFromTree(AJson:Variant;AKeyWord:string):string;
    var
        sTmp1   : string;
        sTmp2   : string;
    begin
        Result:='';
        for var i:Integer:= 0 to AJson._Count - 1 do begin
            sTmp1   := AJson._(i).label;
            if Pos(AKeyWord,sTmp1)>0 then begin
                Result:=dwIIF(Result='','',Result+' or ')+'('+joField.name+' like '''+AJson._(i).id+'%'')';
            end;
            if AJson._(i).exists('children') then begin
                sTmp2:=_GetWhereFromTree(AJson._(i).children,AKeyWord);
                if sTmp2<>'' then begin
                    Result:=dwIIF(Result='','',Result+' or ')+_GetWhereFromTree(AJson._(i).children,AKeyWord);
                end;
            end;
        end;
    end;
begin
    Result  := '';
    if (AFields<>Unassigned) and (AFields._count>0) then begin
        for iField := 0 to AFields._count-1 do begin
            //取得当前字段对象
            joField:= AFields._(iField);
            sType:=dwIIF(joField.Exists('type') ,joField.type,'string');
            if (sType = 'dbcombopair') then begin
                if joField.Exists('name') and joField.Exists('table') and joField.Exists('datafield') and joField.Exists('viewfield') then begin
                    Result:=dwIIF(Result='','',Result+' or ')+'('+joField.name+' IN (SELECT '+joField.datafield+' FROM '+joField.table+' where '+joField.viewfield+' like ''%'+AKeyWord+'%''))';
                end;
            end else if (sType = 'dbtreepair') then begin
                if joField.Exists('name') and joField.Exists('table') and joField.Exists('datafield') and joField.Exists('viewfield') then begin
                    Result:=dwIIF(Result='','',Result+' or ')+'('+joField.name+' IN '
                    +'(SELECT DISTINCT '+joField.datafield+' FROM '+joField.table+' d WHERE EXISTS (SELECT 1 FROM '+joField.table+' b WHERE b.'+joField.viewfield+' LIKE ''%'+AKeyWord+'%'' AND d.'+joField.datafield+' LIKE b.'+joField.datafield+' + ''%'' AND (LEN(d.'+joField.datafield+') - LEN(b.'+joField.datafield+')) % 2 = 0)));';
                end;
            end else if (sType = 'combopair') then begin     //----- 5 -----
                //"""list"":[[""A"",""卓越""],[""B"",""优质""],[""C"",""良好""],[""D"",""合格""],[""E"
                if joField.Exists('name') and joField.Exists('list') and (joField.list._count>0) then begin
                    for iList := 0 to joField.list._count-1 do begin
                        sTmp:=joField.list._(iList)._(1);
                        if Pos(AKeyWord,sTmp)>0 then begin
                            Result:=dwIIF(Result='','',Result+' or ')+'('+joField.name+' like '''+joField.list._(iList)._(0)+''')';
                        end;
                    end;
                end;
            end else if (sType = 'treepair') then begin     //----- 5 -----
                //"list":"[{id:'a',label:'优秀', children : [{id:'aa',label:'优一'}, {id:'ab',label:'优二'}]}, {id:'b',label:'良好'}]
                if joField.Exists('name') and joField.Exists('list') then begin
                    sTmp    := joField.list;
                    sTmp    := StringReplace(sTmp,'id:','"id":',[rfReplaceAll]);
                    sTmp    := StringReplace(sTmp,'label:','"label":',[rfReplaceAll]);
                    sTmp    := StringReplace(sTmp,'children:','"children":',[rfReplaceAll]);
                    sTmp    := StringReplace(sTmp,'''','"',[rfReplaceAll]);
                    joTmp   := _json(sTmp);
                    if joTmp._count>0 then begin
                        Result:=dwIIF(Result='','',Result+' or ')+_GetWhereFromTree(joTmp,AKeyWord);
                    end;
                end;
            end;
        end;
        Result:='('+Result+')';
    end;

end;

//群友"顺其自然"写的支持不查询数字字段和支持关联字符查询的函数, 待验证
function deGetWhereDebug(
        AFields     : string;          //字段列表  = '*'或'Name,Age,job,title'
        AKeyword    : String;
        AJOFields   : variant
        ):string;
var
    sKeywords   : TStringDynArray;  //关键字列表，以空格隔开
    sFields     : TStringDynArray;  //字段名列表，以逗号隔开
    iPos        : Integer;
    iKey        : Integer;
    iField      : Integer;
    iTmp        : Integer;
    sTmp        : string;
    sNotString  : TStringList;
    I           : Integer;
const
    sNotStringArr:array of string =['auto','boolean','date','datatime','float','image','integer','money','time','cobopair','dbcombopair','dbtreepair','treepair'];

    //根据name, 取type
    function _GetTypeByName(AJson:Variant;AName:string):string;
    var
        s1,s2       : string;
        II          : Integer;
    begin
        Result:='';
        for II := 0 to AJson._Count - 1 do begin
            s1  := AJson._(II);
            s2  := AJson._(II).name;
            if (LowerCase(AJson._(II).name)=LowerCase(AName)) and (AJson._(II).exists('type')) then begin
                Result  := AJson._(II).type;
                break;
            end;
        end;
    end;
    //------------------------328
begin
    if Trim(AKeyword)='' then begin
        Result  := ' WHERE (1=1) ';
    end else begin
        //将用户输入的查询字符串,根据空格, 拆分出多个关键字。 如查询 ”delphi 控件开发“
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
        //拆分出多个字段名。 如”Name,Age,Addr“. 将字符串转换为字符串数组
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
        //-----------------------------328b
        sNotString  := TStringList.Create;
        for I := 0 to Length(sNotStringArr)-1 do begin
            sNotString.add(sNotStringArr[I]);
        end;
        //-----------------------------328e
        //得到字段名
        Result  := ' WHERE (';
        for iKey := 0 to High(sKeywords) do begin
            Result  := Result +'(';
            for iField := 0 to High(sFields) do begin
                //不查询iD字段
                if lowerCase(sFields[iField])='id' then begin
                    Continue;
                end;
                //-------------------------------------328b
                //如果关键字不为数值
                if not TryStrToInt(sKeywords[iKey],iTmp) then begin
                    //如果字段类型不为auto,boolean,,date,datatime,float,image,integer,money,time,cobopair,dbcombopair,dbtreepair,treepair
                    if sNotString.IndexOf(_GetTypeByName(AjoFields,lowerCase(sFields[iField]))) = -1 then begin
                        Result  := Result + sFields[iField] +' like ''%'+sKeywords[iKey]+'%'' OR ';
                    end;
                end else begin
                    Result  := Result + sFields[iField] +' like ''%'+sKeywords[iKey]+'%'' OR ';
                end;

                //-------------------------------------328e
                //
                //Result  := Result + sFields[iField] +' like ''%'+sKeywords[iKey]+'%'' OR ';
            end;
            //-------------------------------------328b
            Delete(Result,Length(Result)-3,4);
            sTmp    := deGetWhereJoin(AjoFields,sKeywords[iKey]);
            if sTmp<>'' then begin
                Result:=Result+dwiif(Result='','',' or ')+sTmp;
            end;
              //Result:=Result+dwiif(Result='','(',' or (')+sTmp+')';
            Result  := Result +') AND ';
            //-------------------------------------328e
        end;
        //-------------------------------------328b
        sNotString.Free;
        //-------------------------------------328e
        Delete(Result,Length(Result)-3,4);
        //
        Result  := Result + ')';
    end;
end;

function deGetWhere(
        AFields     : Variant;          //字段的JSON数组,  原为:字段列表  = '*'或'Name,Age,job,title'
        AKeyword    : String
        ):string;
var
    sKeywords   : TStringDynArray;  //关键字列表，以空格隔开
    iPos        : Integer;
    iKey        : Integer;
    iField      : Integer;
    iList       : Integer;
    //
    sKey        : String;
    sField      : String;
    //
    joField     : Variant;
    joList      : Variant;  //主要用于combopair/dbcombopair的list,  "list": [	["A","卓越"],["B","优质"],["C","良好"]	]
begin
    if Trim(AKeyword)='' then begin
        Result  := ' WHERE (1=1) ';
    end else begin
        //将输出的关键字字符串, 根据空格, 拆分出多个关键字。
        //如查询 "delphi 控件开发", 拆分成 "delphi" 和 "控件开发" 两个关键字
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

{
        //::: 原来的直接根据字段查询的代码, 在查询boolean/combopair/dbcombopair等时有问题


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
                //不查询带' as '的字段
                if Pos(' as ',LowerCase(sFields[iField]))>0 then begin
                    Continue;
                end;

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

        //网友顺其自然的代码, 主要用于解决关联表查询问题
        //sTmp1    := '';
        //for iKey := 0 to high(sKeywords) do begin
        //    sTmp    := deGetWhereJoin(AFields,sKeywords[iKey]);
        //    sTmp1   := sTmp + dwIIF(sTmp='', '(', ' and (')+sTmp+')';
        //end;
        //if sTmp <> '' then begin
        //    Result  := Result + ' or ('+sTmp1+')';
        //end;
}
        //::: 2025-06-13 更新, 支持查询boolean/combopair/dbcombopair
        //原来的直接根据字段查询的代码, 在查询boolean/combopair/dbcombopair等时有问题

        //
        //得到字段名
        Result  := ' WHERE (';

        //逐个关键字生成
        for iKey := 0 to High(sKeywords) do begin
            Result  := Result +'(';

            //取得当前关键字
            sKey    := sKeywords[iKey];

            //逐个字段生成
            for iField := 0 to AFields._Count - 1  do begin
                joField := AFields._(iField);

                //取得字段名称
                sField  := joField.name;

                //不查询带' as '的字段
                if Pos(' as ',LowerCase(sField))>0 then begin
                    Continue;
                end;

                //
                if joField.type = 'boolean' then begin
                    if sKey = joField.list._(1) then begin
                        Result  := Result + sField +' = 1 OR '
                    end else if sKey = joField.list._(0) then begin
                        Result  := Result + sField +' = 0 OR '
                    end;
                end else if joField.type = 'combopair' then begin
                    for iList := 0 to joField.list._Count - 1 do begin
                        joList  := joField.list._(iList);   //如: ["A","卓越"],
                        if Pos(sKey,joList._(1))>0 then begin
                            Result  := Result + sField +' = '''+joList._(0)+''' OR '
                        end;
                    end;
                end else if joField.type = 'dbcombopair' then begin
                    for iList := 0 to joField.list._Count - 1 do begin
                        joList  := joField.list._(iList);   //如: ["A","卓越"],
                        if Pos(sKey,joList._(1))>0 then begin
                            Result  := Result + sField +' = '''+joList._(0)+''' OR '
                        end;
                    end;
                end else begin
                    //
                    Result  := Result + sField +' like ''%'+sKey+'%'' OR '
                end;
            end;
            Delete(Result,Length(Result)-3,4);
            Result  := Result +') AND ';
        end;
        Delete(Result,Length(Result)-3,4);
        //
        Result  := Result + ')';


    end;
end;


//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure deGetPageData(
        APanel:TPanel;
        AQuery:TFDQuery;        //对应的ADOQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        var APageNo:Integer;    //当前页码,从1开始
        APageSize:Integer;      //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );
begin

    //----求总数------------------------------------------------------------------------------------
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := -1;

    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Count(*) AS AA FROM '+ATable+' '+AWhere;
    AQuery.Open;

    //记录总数
    ARecordCount    := AQuery.Fields[0].AsInteger;

    //如果超出最大页数,则为最大页数
    if APageNo > Ceil(ARecordCount / APageSize) then begin
        APageNo   := Ceil(ARecordCount / APageSize);
    end;

    //强制APage 从0开始
    APageNo := Max(0,APageNo);

    //取当前页数据
    AQuery.Close;
    AQuery.SQL.Text := 'SELECT '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    AQuery.FetchOptions.RecsSkip    := APageNo * APageSize;
    AQuery.FetchOptions.RecsMax     := APageSize;
    AQuery.Open;

    //如果当前页码不为0, 且数据为空,则自动跳转到上一页
    if AQuery.IsEmpty and (APageNo > 0) then begin
        Dec(APageNo);
        //重新取当前页数据
        AQuery.Close;
        AQuery.SQL.Text := 'SELECT '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
        AQuery.FetchOptions.RecsSkip    := APageNo * APageSize;
        AQuery.FetchOptions.RecsMax     := APageSize;
        AQuery.Open;
    end;

end;

//从数据表中取数据，置入StringGrid中
function deGetDataToGrid(
        AQuery : TFDQuery;
        ASG : TStringGrid;
        ATrackBar : TTrackBar;
        AConfig : Variant   //包括以下信息：ATable,AFields,AWhere,AOrder:String;APage,ACount:Integer;
        ):Integer;
var
    oEvent      : Procedure(Sender:TObject) of Object;
    oClick      : Procedure(Sender:TObject) of Object;
    oDBEditor  : TPanel;

    iRecCount   : Integer;
    iRow        : Integer;
    iCol        : Integer;
    iOldRecNo   : Integer;
    iPageNo     : Integer;  //页数,从0开始
    iPageSize   : Integer;  //每页条数
    iMode       : Byte;
    iValue      : Integer;  //用于处理index序号列的值
    iJsonId     : integer;  //JSON对象index
    iFieldId    : Integer;  //数据表字段index
    //
    sTable      : String;   //数据表名
    sFields     : string;   //字段列表，如：id,name,age,remark
    sWhere      : string;   //过滤条件
    sOrder      : string;   //排序条件
    //
    joField     : Variant;
begin
    //默认返回值
    Result      := 0;

    //输入参数检查
    if AConfig = unassigned then begin
        Result  := -1;
        Exit;
    end;

    //保存表格的click事件
    oClick      := ASG.OnClick;
    ASG.OnClick := nil;

    //取得对应的参数设置
    sTable      := AConfig.table;       //表名
    sWhere      := AConfig.where;       //过滤条件
    sOrder      := AConfig.order;       //排序
    iPageNo     := AConfig.pageno;      //页码，从0始
    iPageSize   := AConfig.pagesize;    //每页行数
    sFields     := deGetFields(AConfig.fields,False);  //得到字段字符串列表

    //保存事件，并清空，以防止循环处理
    oEvent  := ATrackBar.OnChange;
    ATrackBar.OnChange  := nil;

    //保存原Recno
    iOldRecNo   := AQuery.RecNo;
    AQuery.DisableControls;

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(ASG));

    //根据条件, 得出数据. 即根据条件，OPEN对应的FDQuery
    //完成两项；1 求出总记录条数；2 打开对应的FDQuery表
    deGetPageData(
        oDBEditor,
        AQuery,
        sTable,
        sFields,
        sWhere,
        sOrder,
        iPageNo,
        iPageSize,
        iRecCount);

    //设置分页控件值
    ATrackBar.Max       := iRecCount;   //所有页的记录之和
    ATrackBar.PageSize  := iPageSize;   //每页显示

    //清空原StringGrid数据记录(主要防止数据记录未写满页面显示错误)
    for iRow := 1 to ASG.RowCount-1 do begin
        for iCol := 0 to ASG.ColCount-1 do begin
            ASG.Cells[iCol,iRow]    := '';
        end;
    end;
    ASG.Row := 1;

    //如果超出最大页数,则为最大页数
    if iPageNo > Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize)) then begin
        iPageNo := Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize));
    end;

    //强制iPageNo 从0开始
    iPageNo := Max(0,iPageNo);

    //显示数据记录
    if AQuery.IsEmpty then begin
        //标记为空表
        ASG.DoubleBuffered  := True;
    end else begin
        //标记为非空表
        ASG.DoubleBuffered  := False;
        //
        for iRow := 1 to ASG.RowCount-1 do begin
            for iCol := 0 to ASG.ColCount - 1 do begin
                //取得当前列对应的JSON对象index
                iJsonID := deGetJsonIdFromColId(AConfig,iCol);

                //异常检测
                if (iJsonId < 0) or (iJsonId >= AConfig.fields._Count) then begin
                    Continue;
                end;

                //取得当前字段JSON对象
                joField := AConfig.fields._(iJsonId);

                //取得当前数据表字段index
                iFieldId    := dwGetInt(joField,'fieldid',-1);

                //异常检测
                if (iFieldId < -1) or (iFieldId >= AQuery.Fields.Count) then begin
                    Continue;
                end;

                //根据是否显示（view属性）进行处理
                iMode   := dwGetInt(joField,'view',0);
                case iMode of
                    0,3 : begin
                        if (joField.type = 'index') then begin
                            if (dwGetInt(joField,'full',1)=1) then begin
                                //对序号进行所有页统一编号

                                //先取得当前页序号
                                iValue  := iRow + dwGetInt(joField,'start',1)-1;

                                //增加页码的值
                                iValue  := iValue + iPageNo * iPageSize;

                                //写入数据表格
                                ASG.Cells[iCol,iRow]    := IntToStr(iValue);
                            end else begin
                                //对序号进行每页单独编号

                                //先取得当前页序号
                                iValue  := iRow + dwGetInt(joField,'start',1)-1;

                                //写入数据表格
                                ASG.Cells[iCol,iRow]    := IntToStr(iValue);

                            end;
                        end else begin
                            ASG.Cells[iCol,iRow]        := deGetFieldValue(AQuery.Fields[Max(0,iFieldId)],joField);
                        end;
                    end;
                else
                end;
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
    ATrackBar.Position  := iPageNo;
    ATrackBar.OnChange  := oEvent;
    //FreeAndNil(oEvent);

    //恢复原Recno
    AQuery.RecNo    := iOldRecNo;
    AQuery.EnableControls;


    //恢复表格的click事件
    ASG.Row := 1;
    ASG.OnClick := oClick;

end;

//设置额外的where, AWhere 类似 'Id>20' , 保存在PQm面板(也就是EKw的容器面板)中
function  deSetExtraWhere(APanel:TPanel;AWhere:String):Integer;
var
    sPrefix     : String;
    oForm       : TForm;
    oPQm        : TPanel;
    joConfig    : Variant;
    joHint      : Variant;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));

    //
    if (oPQm = nil) then begin
        Exit;
    end else begin
        joHint              := dwJson(oPQm.Hint);
        joHint.extrawhere   := AWhere;
        oPQm.Hint           := joHint;
    end;
end;

//取保存的 ExtraWhere
function  deGetExtraWhere(APanel:TPanel):String;
var
    sPrefix     : String;
    oForm       : TForm;
    oPQm        : TPanel;
    joConfig    : Variant;
    joHint      : Variant;
begin
    //默认返回值
    Result      := '';

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));

    //
    if (oPQm = nil) then begin
        Exit;
    end else begin
        joHint  := dwJson(oPQm.Hint);
        Result  := dwGetStr(joHint,'extrawhere','');
    end;
end;
//
function  deSetMobile(APanel:TPanel):Integer;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
begin
    Result  := 0;

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //设置分页栏使用移动版
    with TTrackBar(oForm.FindComponent(sPrefix+'TbP')) do begin
        HelpKeyword     := 'mobile';
        Margins.Top     := 0;
    end;
    with TStringGrid(oForm.FindComponent(sPrefix+'SgD')) do begin
        Margins.Left    := 0;
        Margins.Right   := 0;
    end;
    with TPanel(oForm.FindComponent(sPrefix+'PQm')) do begin
        BorderStyle     := bsNone;
        Margins.Left    := 0;
        Margins.Right   := 0;
        Hint            := '';
    end;
    with TEdit(oForm.FindComponent(sPrefix+'EKw')) do begin
        Align           := alClient;
        Margins.Left    := 20;
        Margins.Right   := 20;
        Color           := clBtnFace;
        Hint            := '{"placeholder":"搜索","prefix-icon":"el-icon-search","dwstyle":"padding-left:5px;border:solid 0px;","radius":"15px"}';
    end;
end;


//设置"增删改查导入导出"等的Enabled, AName 分别为new,delete,edit,query,import,export
function  deSetControlEnabled(APanel:TPanel;AName:string;AEnabled:Boolean):Integer;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
    oButton     : TButton;
    oEdit       : TEdit;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    AName   := LowerCase(AName);
    if AName = 'new' then begin
        oButton := TButton(oForm.FindComponent(sPrefix+'BNw'));
        if oButton <> nil then begin
            oButton.Enabled := AEnabled;
        end;
    end else if AName = 'delete' then begin
        oButton := TButton(oForm.FindComponent(sPrefix+'BDe'));
        if oButton <> nil then begin
            oButton.Enabled := AEnabled;
        end;
    end else if AName = 'edit' then begin
        oButton := TButton(oForm.FindComponent(sPrefix+'BEt'));
        if oButton <> nil then begin
            oButton.Enabled := AEnabled;
        end;
    end else if AName = 'import' then begin
        oButton := TButton(oForm.FindComponent(sPrefix+'BIm'));
        if oButton <> nil then begin
            oButton.Enabled := AEnabled;
        end;
    end else if AName = 'export' then begin
        oButton := TButton(oForm.FindComponent(sPrefix+'BEx'));
        if oButton <> nil then begin
            oButton.Enabled := AEnabled;
        end;
    end else if AName = 'query' then begin
        oEdit   := TEdit(oForm.FindComponent(sPrefix+'EKw'));
        if oEdit <> nil then begin
            oEdit.Enabled := AEnabled;
        end;
    end;
end;


//设置简洁模式，智能模糊查询模式下，将按钮和查询放到一排
function  deSetOneLine(APanel:TPanel;const AMargin:Integer=10):Integer;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
    oPBs        : TPanel;
    oPQm        : TPanel;
    oBEt        : TButton;
    oBEx        : TButton;
    oBIm        : TButton;
    oBNw        : TButton;
    oBDe        : TButton;
    oBFz        : TButton;
    oBQm        : TButton;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));
    oPBs    := TPanel(oForm.FindComponent(sPrefix+'PBs'));
    oBEt    := TButton(oForm.FindComponent(sPrefix+'BEt'));
    oBNw    := TButton(oForm.FindComponent(sPrefix+'BNw'));
    oBDe    := TButton(oForm.FindComponent(sPrefix+'BDe'));
    oBFz    := TButton(oForm.FindComponent(sPrefix+'BFz'));
    oBQm    := TButton(oForm.FindComponent(sPrefix+'BQm'));
    oBEx    := TButton(oForm.FindComponent(sPrefix+'BEx'));
    oBIm    := TButton(oForm.FindComponent(sPrefix+'BIm'));

    //

    //
    if (oPQm = nil) or (oPBs = nil) then begin
        Exit;
    end;

    if (oBIm <> nil) then begin
        oBIm.Align  := alRight;
        oBIm.Margins.Top    := 8;
        oBIm.Margins.Bottom := 0;
        oBIm.Margins.Left   := AMargin;
    end;
    if (oBEx <> nil) then begin
        oBEx.Align  := alRight;
        oBEx.Margins.Top    := 8;
        oBEx.Margins.Bottom := 0;
        oBEx.Margins.Left   := AMargin;
    end;
    if (oBDe <> nil) then begin
        oBDe.Align  := alRight;
        oBDe.Margins.Top    := 8;
        oBDe.Margins.Bottom := 0;
        oBDe.Margins.Left   := AMargin;
    end;
    if (oBEt <> nil) then begin
        oBEt.Align  := alRight;
        oBEt.Margins.Top    := 8;
        oBEt.Margins.Bottom := 0;
        oBEt.Margins.Left   := AMargin;
    end;
    if (oBNw <> nil) then begin
        oBNw.Align  := alRight;
        oBNw.Margins.Top    := 8;
        oBNw.Margins.Bottom := 0;
        oBNw.Margins.Left   := AMargin;
    end;
    if (oBFz <> nil) then begin
        oBFz.Visible        := False;
    end;
    if (oBQm <> nil) then begin
        oBQm.Visible    := False;
    end;

    //
    oPBs.Parent         := oPQm;
    oPBs.Align          := alRight;
    oPBs.AutoSize       := True;
    oPBs.Update;
    oPBs.AutoSize       := False;
    oPBs.Margins.Top    := 0;
    oPBs.Margins.Bottom := 0;
    oPBs.Margins.Right  := 0;
    oPBs.Margins.Left   := 0;

end;

//根据显示的值, 取得数据表存储的值
function deGetPairData(AField:Variant;AValue:String):String;
var
    iItem   : Integer;
    joList  : Variant;
begin
    if (AField.type = 'combopair') or (AField.type = 'dbcombopair') then begin
        //"list":[
        //    ["029","西安"],
        //    ["0271","纽约"],
        //    ["0971","新奥尔良"]

        Result  := '';
        for iItem := 0 to AField.list._Count - 1 do begin
            if AField.list._(iItem)._(1) = AValue then begin
                Result  := AField.list._(iItem)._(0);
                break;
            end;
        end;
    end else if (AField.type = 'treepair') or (AField.type = 'dbtreepair') then begin
        //"list":"[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]"

        //
        joList  := deGetTreeListJson(AField.list);

        //
        Result  := deGetTreeListData(joList,AValue);

    end;
end;

function deGetFDQuery(APanel:TPanel):TFDQuery;
var
    sPrefix     : String;
    joConfig    : Variant;
begin
    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //求当前模块的 FDQuery
    Result  := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
end;

function deGetFDQueryTemp(APanel:TPanel):TFDQuery;
var
    sPrefix     : String;
    joConfig    : Variant;
begin
    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //求当前模块的 FQTemp
    Result  := TFDQuery(APanel.FindComponent(sPrefix+'FQTemp'));
end;

function deGetStringGrid(APanel:TPanel):TStringGrid;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    Result  := TStringGrid(oForm.FindComponent(sPrefix+'SgD'));
end;


function deGetEditComponent(APanel:TPanel;AIndex:Integer):TComponent;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
begin
	//取得Form备用
	oForm       := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取控件
    Result      := oForm.FindComponent(sPrefix+'F'+IntToStr(AIndex));
end;


function  deGetSQL(APanel:TPanel):String;
var
    sPrefix     : String;
    joConfig    : Variant;
    oFDQuery    : TFDQuery;
begin
    Result  := '';

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
    if oFDQuery<>nil then begin
        Result  := oFDQuery.SQL.Text;
    end;
end;


//取DBEditor模块的SQL语句中的where(返回值不包含where)
function  deGetSQLWhere(APanel:TPanel):String;
var
    sPrefix     : String;
    joConfig    : Variant;
    Regex       : TRegEx;
    Match       : TMatch;
begin

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    Result      := deGetSQL(APanel);

    // 正则表达式匹配 WHERE 子句
    Regex   := TRegEx.Create('(?i)\bWHERE\b\s*(.*?)(?=\bORDER BY\b|\bGROUP BY\b|$)', [roIgnoreCase]);
    Match   := Regex.Match(Result);

    if Match.Success then begin
        Result := Match.Groups[1].Value.Trim; // 返回 WHERE 子句内容
    end else begin
        Result := ''; // 如果没有找到，返回空字符串
    end;

end;

Procedure BExClick(Self: TObject; Sender: TObject);
var
    //
    oForm       : TForm;
    oButton     : TButton;
    oFQTemp     : TFDQuery;
    oDBEditor  : TPanel;
    //
    sPrefix     : string;   //前缀
    sFields     : string;   //主表字段列表
    sWhere      : String;   //主表WHERE
    sDir        : string;
    sFileName   : String;
    sTitles     : string;
    sIndexs     : string;
    sType       : String;
    //
    joConfig    : Variant;
    joTitle     : Variant;
    joField     : Variant;
    joIndex     : Variant;
    //
    I           : integer;
    //
    ABookMark   : TBookMark;
    oWorkBook   : TZWorkBook;

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

begin
    try
        //导出事件。
        //dwMessage('BExClick','',TForm(TEdit(Sender).Owner));

        //取得各控件
        oButton := TButton(Sender);
        oForm   := TForm(oButton.Owner);

        //取得源crud panel
        oDBEditor  := deGetDBEditor(TControl(Sender));

        //
        joConfig    := deGetConfig(oDBEditor);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得Query备用
        oFQTemp     := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQTemp'));

        //得到主表的字段名称列表
        sFields     := deGetFields(joConfig.Fields,joConfig.exportonlyvisible=1);

        //得到主表的字段caption列表,如：["姓名","性别","年龄","地址"]
        sTitles     := deGetCaptions(joConfig.Fields,joConfig.exportonlyvisible=1);

        //得到主表的字段index列表,如：[1,3,5,6]
        sIndexs     := deGetIndexs(joConfig.Fields,joConfig.exportonlyvisible=1);
        joIndex     := _json(sIndexs);

        //得到主表的WHERE
        sWhere      := deGetSQLWhere(oDBEditor);

        //打开数据表
        oFQTemp.Close;
        oFQTemp.SQL.Text := 'SELECT '+sFields+' FROM '+joConfig.table +' WHERE '+sWhere;
        oFQTemp.FetchOptions.RecsSkip   := 0;
        oFQTemp.FetchOptions.RecsMax    := -1;
        oFQTemp.Open;
        //oFQTemp.RecordCount

        //取得当前目录
        sDir    := ExtractFilePath(Application.ExeName);

        //如果无download目录，则创建
        ChDir(sDir);
        if not DirectoryExists('download') then begin
            MkDir('download');
        end;
        sDir    := sDir +'download/';
        //
        sFileName   := 'DeWebDBEditor'+ FormatDateTime('_YYYYMMDD_hhmmss_zzz',Now)+'.xlsx';

        //导出到文件
        //dwExportToTitledXLS(sDir + sFileName, oFQTemp, sTitles);
        //exExportToFileWithTitle(sDir + sFileName, oFQTemp, sTitles);

        //==============================================================================================================
        //删除可能存在的文件
        if FileExists(sDir +sFileName) then begin
            DeleteFile(PWideChar(WideString(sDir +sFileName))); //如文件已存在，先删除
        end;

        //生成标题对应JSON
        joTitle     := _json(sTitles);
        if joTitle = unassigned then begin
            joTitle := _json('[]');
            for I := 0 to oFQTemp.FieldCount - 1 do begin
                joTitle.Add(oFQTemp.Fields[I].FieldName);
            end;
        end;

        //创建一个book
        oWorkBook   := TZWorkBook.Create(nil);
        try
            oWorkBook.Sheets.Add('DeWeb Sheet');
            oWorkBook.Sheets[0].ColCount := Max(oFQTemp.FieldCount,joTitle._Count);
            oWorkBook.Sheets[0].RowCount := oFQTemp.RecordCount + 1;
            //设置行高
            for I := 0 to oFQTemp.RecordCount do begin
                oWorkBook.Sheets[0].RowHeights[I]   := dwGetInt(joConfig,'rowheight',45) / 2 ;
            end;

            //需要设置列宽
            for I := 0 to joIndex._Count - 1 do begin
                oWorkBook.Sheets[0].ColWidths[I]    := dwGetInt(joConfig.fields._(joIndex._(I)),'width',100) *0.7 ;
            end;

            //写标题行
            for I := 0 to joTitle._Count - 1 do begin
                oWorkBook.Sheets[0].CellRef[_ColToStr(I), 0].AsString := joTitle._(I);
            end;

            //写数据集中的数据
            oFQTemp.DisableControls;      //断开数据组件（修改过程中）
            ABookMark   := oFQTemp.GetBookmark;    //取当前定位
            oFQTemp.First;                //到首记录
            try
                while not oFQTemp.Eof do begin     //循环遍历所有记录
                    for I := 0 to oFQTemp.FieldCount - 1 do  begin   //循环遍历所有字段
                        //
                        joField := joConfig.fields._(joIndex._(I));
                        //取得类型
                        sType   := dwGetStr(joField,'type');

                        //值
                        oWorkBook.Sheets[0].CellRef[_ColToStr(I), oFQTemp.RecNo].AsString := deGetFieldValue(oFQTemp.Fields[i],joField);

                    end;
                    oFQTemp.Next;        //下一记录
                end;
            except
                dwMessage('RecNo:'+IntToStr(oFQTemp.RecNo)+',  Field:'+IntToStr(I),'error',oForm);
            end;
            //
            oWorkBook.SaveToFile(sDir +sFileName);
        finally
            oFQTemp.EnableControls;
            oWorkBook.Free();
        end;
        //==============================================================================================================

        //下载文件
        dwOpenURL(oForm,'download/'+sFileName,'_blank');
    except
        dwRunJS('console.log("error when BExClick");',oForm);
    end;
end;

Procedure BHdClick(Self: TObject; Sender: TObject);     //多字段查询时的"隐藏", 相比较模式切换, 保留了现在的查询条件
var
    //
    oForm       : TForm;
    oButton     : TButton;
    oDBEditor  : TPanel;
    oFQy        : TFlowPanel;
    //
    joConfig    : Variant;
    //
    sPrefix     : String;
    bAccept     : Boolean;
    //
    oChange     : Procedure(Sender:TObject) of Object;
begin

    //取得控件,当前应为 BHd - Button Hide
    oButton := TButton(Sender);

    //
    oForm   := TForm(oButton.Owner);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    // deReset 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deQueryHide,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));
    //
    oChange         := oFQy.OnResize;
    //
    oFQy.OnResize   := nil;
    oFQy.AutoSize   := False;
    oFQy.Height     := 0;
    //
    oFQy.OnResize   := oChange;

    //需要设置当前overflow:hidden, 原overflow:visible, 以显示tree选项
    dwRunJS('$("#'+dwFullName(oFQy)+'").css("overflow", "hidden");',oForm)

end;




Procedure BImClick(Self: TObject; Sender: TObject);
var
    //
    oForm       : TForm;
    oButton     : TButton;
begin

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);

    //上传前将upload上传事件转移到当前控件中
    dwSetUploadTarget(oForm,oButton);

    //上传文件
    dwUpload(oForm,'application/vnd.ms-excel, application/vnd.openxmlformats-officedocument.spreadsheetml.sheet','');
end;


//上传完成事件
procedure BImEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oQuery      : TFDQuery;
    //
    sFile       : String;
    sSource     : String;
    sPrefix     : string;
    //
    joConfig    : Variant;
begin
    try
        //取得源crud panel
        oDBEditor  := deGetDBEditor(TControl(Sender));

        //取得配置JSON备用
        joConfig    := deGetConfig(oDBEditor);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得各控件
        oButton := TButton(Sender);
        oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));

        //取得上传完成后的文件名和源文件名
        sFile   := dwGetProp(oButton,'__upload');       //上传后的文件名
        sSource := dwGetProp(oButton,'__uploadsource'); //原始文件名

        //取得将上传完成的完整文件名
        sFile   := ExtractFilePath(Application.ExeName)+'upload/'+sfile;

        //以下开始将excel导入到数据表中, 注; 只导入可见部分字段 --------------------------------------------------------
        exImportFromFile(sFile, oQuery, joConfig);

        //
        deUpdate(oDBEditor,'');

        //
        dwMessage('import success!','success',TForm(oButton.Owner));
    except
        dwMessage('error when BImEndDock','',TForm(oButton.Owner));
    end;
end;



Procedure BQmClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    //
    sPrefix     : String;
    joConfig    : Variant;
    oDBEditor  : TPanel;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oButton.Tag := oButton.Tag - 1;
    if not(oButton.Tag in [0,1,2]) then begin
        oButton.Tag := 2;
    end;

    //
    deSetQueryMode(oDBEditor,oButton.Tag,True);
end;

Procedure BFzClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    if oButton.Tag = 0 then begin
        //精确
        oButton.Tag     := 1;
        oButton.Hint    := '{"type":"info","icon":"el-icon-c-scale-to-original"}';
        oButton.Caption := '精确';
    end else begin
        //模糊
        oButton.Tag     := 0;
        oButton.Hint    := '{"type":"info","icon":"el-icon-open"}';
        oButton.Caption := '模糊';
    end;
end;

Procedure BDOClick(Self: TObject; Sender: TObject); //Button Delete OK
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPanel      : TPanel;
    oPanelSlave : TPanel;
    oSGD        : TStringGrid;
    //
    iSelect     : Integer;
    iSlave      : Integer;
    iRow        : Integer;
    bAccept     : Boolean;
    //
    joConfig    : variant;
    joSelect    : Variant;  //用于取得当前多选列的选择信息，如["1","5","6"]
    joSlave     : Variant;
    joConfigS   : variant;
    //
    sPrefix     : String;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //取得配置JSON
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent(sPrefix+'PDe'));
    oQuery      := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));
    oSGD        := TStringGrid(oForm.FindComponent(sPrefix+'SGD'));

    // deDeleteBefore 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        if oQuery.IsEmpty then begin
            oDBEditor.OnDragOver(oDBEditor,nil,deDeleteBefore,-1,dsDragEnter,bAccept);
        end else begin
            oDBEditor.OnDragOver(oDBEditor,nil,deDeleteBefore,oQuery.RecNo,dsDragEnter,bAccept);
        end;
        if not bAccept then begin
            Exit;
        end;
    end;

    //得到当前表格的选择信息
    joSelect    := _json('[]');
    if dwGetInt(joConfig,'select',0)>0 then begin
        for iRow := 1 to oSGD.RowCount - 1 do begin
            if oSGD.Cells[0,iRow] = 'true' then begin
                joSelect.Add(iRow);
            end;
        end;
    end;


    //递归删除当前表的一部分记录. 主要可以递归删除从表中的记录==========================================================
    //function deDeleteRecords(APanel:TPanel;AWhere:String):Integer;
    //分2步: 1 生成 WHERE ; 2 调用 deDeleteRecords 删除记录

    //<----- 1 生成 WHERE ;
    //根据是否已通过checkbox选择情况分别处理
    if joSelect._Count = 0 then begin

    end;
    //----->

    //2 调用 deDeleteRecords 删除记录
    //==================================================================================================================

    //根据是否已通过checkbox选择情况分别处理
    if joSelect._Count = 0 then begin
        //:::删除当前行记录

        //<先删除可能存在的从表记录
        if joConfig.Exists('slave') then begin
            //逐个slave从表删除
            for iSlave := 0 to joConfig.slave._Count - 1 do begin
                //取得从表 json
                joSlave := joConfig.slave._(iSlave);

                //取得从表 panel
                oPanelSlave := TPanel(oForm.FindComponent(dwGetStr(joSlave,'panel','nil')));

                //
                if oPanelSlave <> nil then begin
                    //取得从表配置 json
                    joConfigS   := deGetConfig(oPanelSlave);

                    //删除从表中相关记录
                    deDeleteRecords(oPanelSlave,joSlave.slavefield+' = '+IntToStr(oQuery.FieldByName(joSlave.masterfield).AsInteger));
                end;
            end;
        end;
        //>

        //删除当前记录
        oQuery.Delete;

        //更新显示
        deUpdate(oDBEditor,'');
    end else begin
        //删除多记录

        //
        for iSelect := joSelect._Count - 1 downto 0 do begin //反向
            //取得多选的项，为当前行号
            iRow    := joSelect._(iSelect);

            //异常检查
            if (iRow <1 ) or ( iRow > oQuery.RecordCount) then begin
                Continue;
            end;

            //跳转到相关记录处
            oQuery.RecNo    := iRow;

            //<先删除可能存在的从表记录
            if joConfig.Exists('slave') then begin
                //逐个slave从表删除
                for iSlave := 0 to joConfig.slave._Count - 1 do begin

                    //取得从表 json
                    joSlave := joConfig.slave._(iSlave);

                    //取得从表 panel
                    oPanelSlave := TPanel(oForm.FindComponent(dwGetStr(joSlave,'panel','nil')));

                    //
                    if oPanelSlave <> nil then begin
                        deDeleteRecords(oPanelSlave,joSlave.slavefield+' = '+IntToStr(oQuery.FieldByName(joSlave.masterfield).AsInteger));
                    end;
                end;
            end;

            //删除记录
            oQuery.Delete;
        end;


        //更新表格显示
        deUpdate(oDBEditor,'');
    end;

    // deDeleteAfter 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        if oQuery.IsEmpty then begin
            oDBEditor.OnDragOver(oDBEditor,nil,deDeleteAfter,-1,dsDragEnter,bAccept);
        end else begin
            oDBEditor.OnDragOver(oDBEditor,nil,deDeleteAfter,oQuery.RecNo,dsDragEnter,bAccept);
        end;
        if not bAccept then begin
            Exit;
        end;
    end;

    //隐藏当前删除确认面板
    oPanel.Visible  := False;
end;

Procedure BDCClick(Self: TObject; Sender: TObject);
var
    oButton : TButton;
    oForm   : TForm;
    oPanel  : TPanel;
    //
    sPrefix     : String;
    joConfig    : Variant;
    oDBEditor  : TPanel;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
    //关闭面板
    oPanel.Visible  := False;
end;

Procedure ButtonCancelClick(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oFFd        : TFlowPanel;
    //
    sPrefix     : String;
	bAccept		: boolean;
    //
    joConfig    : Variant;
    joInfo      : Variant;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各对象
    oForm       := TForm(oButton.Owner);

    // deCancelBefore 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deCancelBefore,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //用 PEr 的tag来标记当前状态，
    oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));
    oQuery.Cancel;

    // deCancelAfter 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deCancelAfter,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新显示
    deUpdateView(oDBEditor);
end;

Procedure BEMClick(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oPEr        : TPanel;
    oFC         : TFlowPanel;
    //
    joConfig    : variant;
    //
    sPrefix     : String;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');


    //取得各对象
    oForm       := TForm(oButton.Owner);
    oPEr        := TPanel(oForm.FindComponent(sPrefix+'PEr'));

    //先设置非AutoSize
    oFC := TFlowPanel(oForm.FindComponent(sPrefix+'FC'));
    oFC.AutoSize    := False;

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //取得JSON配置
    joConfig    := deGetConfig(oDBEditor);

    //
    if oPEr.Width = Min(oForm.width-20,joConfig.editwidth) then begin
        //标志当前最大化
        oButton.Tag := 9;
        //最大化
        if oForm.Width < 500 then begin
            oPEr.Width     := oForm.Width - 20;
            oPEr.Top       := 10;
            oPEr.Height    := oForm.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPEr.Width     := oForm.Width - 100;
            oPEr.Top       := 50;
            oPEr.Height    := oForm.Height - 100;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end;
    end else begin
        //标志当前正常大小
        oButton.Tag := 0;

        //正常界面
        if oForm.Width < 500 then begin
            oPEr.Width     := oForm.Width - 20;
            oPEr.Top       := 10;
            oPEr.Height    := oForm.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPEr.Width     := Min(oForm.width-20,joConfig.editwidth);
            oPEr.Top       := 100;
            oPEr.Height    := oForm.Height - 200;
            oButton.Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        end;
    end;

    //设置AutoSize,以配合ScrollBox滚动
    oFC.AutoSize    := True;
end;

Procedure BEtClick(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
    oForm       : TForm;
    oBSa        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oBEM        : TButton;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oI          : TImage;
    oM          : TMemo;
    oDT         : TDateTimePicker;
    oCB         : TComboBox;
    oCKB        : TCheckBox;
    oSgD        : TStringGrid;
    //
    iItem       : Integer;
    iTemp       : Integer;
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    //用于取字段值，并清除其中的换行
    sValue      : String;
    //
    joConfig    : Variant;
    joField     : Variant;
    joList      : Variant;
    //
    sPrefix     : String;
	bAccept		: boolean;
    bVisible    : Boolean;
begin
    //::: 编辑按钮点击事件

    //取得当前控件
    oBSa        := TButton(Sender); //Et : Edit

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oBSa.Owner);
    oPEr    := TPanel(oForm.FindComponent(sPrefix+'PEr'));
    oBEL    := TButton(oForm.FindComponent(sPrefix+'BEL'));
    oBEM    := TButton(oForm.FindComponent(sPrefix+'BEM'));
    oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));
    oCKB    := TCheckBox(oForm.FindComponent(sPrefix+'CKB'));
    oSgD    := TStringGrid(oForm.FindComponent(sPrefix+'SgD'));

    //空表检测
    if oQuery.IsEmpty then begin
        Exit;
    end;

    // deEdit 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deEdit,oSgD.Row,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //编辑时隐藏"批量处理"
    bVisible        := oCKB.Visible;
    oCKB.Visible    := False;

    //EL Edit Label
    oBEL.Caption   := '编  辑';

    //用 PEr 的tag来标记当前状态   0表示编辑 100表示新增
    oPEr.Tag   := 0;

    //更新字段值
    for iItem := 0 to joConfig.fields._Count-1 do begin  //此处需要避免多选列问题
        //得到字段JSON
        joField := joConfig.fields._(iItem);

        //取得当前JSON字段对应的数据表字段index
        iFieldId    := dwGetInt(joField,'fieldid',-1);

        //跳过非数据表列
        if iFieldId < 0 then begin
            continue;
        end;

        //查找字段对应的编辑控件
        oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iItem));

        //如果找到了控件（有可能因为view<>0的原因找不到）
        if oComp <> nil then begin
            //取字段的AsString，并清除其中的特殊字符串（如换行），备用
            sValue  := oQuery.Fields[iFieldId].AsString;
            sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
            sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

            //根据字段类型分类处理
            //------------------------ 4 BEt - Button Edit -------------------------------------------------------------
            if joField.type = 'auto' then begin                     //----- 1 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'boolean' then begin         //----- 2 -----
                oCB         := TComboBox(oComp);
                if LowerCase(sValue)='true' then begin
                    oCB.ItemIndex   := 1;
                end else begin
                    oCB.ItemIndex   := 0;
                end;

            end else if joField.type = 'button' then begin          //----- 3 -----

            end else if (joField.type = 'combo') then begin         //----- 4 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;

            end else if (joField.type = 'combopair') then begin     //----- 5 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if sValue <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(0) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(1);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'date' then begin            //----- 6 -----
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkDate;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iFieldId].AsDateTime;
                end;

            end else if joField.type = 'datetime' then begin        //----- 7 -----
                oDT         := TDateTimePicker(oComp);
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Date    := oQuery.Fields[iFieldId].AsDateTime;
                    oDT.Time    := oQuery.Fields[iFieldId].AsDateTime;
                end;

            end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;

            end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if sValue <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(0) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(1);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'dbtree' then begin          //----- 10 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
                oE          := TEdit(oComp);
                //joList      := deGetTreeListJson(joField.list);
                //oE.Text     := deGetTreeListView(joList,sValue);
                oE.Text     := sValue;
            end else if joField.type = 'float' then begin           //----- 12 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'image' then begin           //----- 13 -----
                oI          := TImage(oComp);
                if joField.Exists('imgdir') then begin
                    sValue  := String(joField.imgdir) + sValue;
                end;
                oI.Hint     := '{"dwstyle":"border-radius:3px;","src":"'+sValue+'"}';

            end else if joField.type = 'index' then begin           //----- 13A -----
                //序号列, 不应该显示在编辑面板中

            end else if joField.type = 'integer' then begin         //----- 14 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'memo' then begin            //----- 15 -----
                oM          := TMemo(oComp);
                oM.Text     := sValue;

            end else if joField.type = 'money' then begin           //----- 16 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'string' then begin          //----- 17 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'time' then begin            //----- 18 -----
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkTime;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Time    := oQuery.Fields[iFieldId].AsDateTime;
                end;

            end else if joField.type = 'tree' then begin            //----- 19 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end else if joField.type = 'treepair' then begin        //----- 20 -----
                oE          := TEdit(oComp);
                joList      := deGetTreeListJson(joField.list);
                oE.Text     := deGetTreeListView(joList,sValue);
            end else begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end;

            //设置只读（编辑时只读，新增时可编辑）
            if joField.type <> 'auto' then begin
                if joField.readonly = 1 then begin
                    TEdit(oComp).Enabled    := False;
                end;
            end;
        end;
    end;

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //恢复"批量处理"显示
    oCKB.Visible    := bVisible;

    //::: 如果字段中有linkages, 则自动执行该change事件
    //::: 即当前字段会导致其他字段的选项改变(选择了某合同, 后面产品名称只能选择该合同内的),
    for iItem := 0 to joConfig.fields._Count-1 do begin  //此处需要避免多选列问题
        //得到字段JSON
        joField := joConfig.fields._(iItem);

        //跳过无 linkages 字段
        if not joField.Exists('linkages') then begin
            continue;
        end;

        //查找字段对应的编辑控件
        oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iItem));

        //如果找到了控件（有可能因为view<>0的原因找不到）
        if oComp <> nil then begin
            if oComp.ClassName = 'TComboBox' then begin
                if Assigned(TComboBox(oComp).OnChange) then begin
                    TComboBox(oComp).OnChange(oComp);
                end;
            end else if oComp.ClassName = 'TEdit' then begin
                if Assigned(TEdit(oComp).OnChange) then begin
                    TEdit(oComp).OnChange(oComp);
                end;
            end;
        end;
    end;

    //显示编辑面板oPEr - Panel Editor
    oPEr.Visible   := True;
end;

Procedure ButtonSaveClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oDBEditor  : TPanel;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oFQTemp     : TFDQuery;
    oBEA        : TButton;
    oFFd        : TFlowPanel;
    oE_Field    : TEdit;
    oM_Field    : TMemo;
    oDT_Field   : TDateTimePicker;
    oComp       : TComponent;
    oCB_Field   : TComboBox;
    oCKB        : TCheckBox;
    oMasterPanel: TPanel;
    oFDQuery    : TFDQuery;
    //
    iField      : Integer;
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    iOldRow     : Integer;  //用于编辑后恢复原来的指定行
    //
    bAccept     : Boolean;
    //
    sOldValue   : string;   //编辑前字段值，用于防重
    //
    joConfig    : variant;
    joField     : Variant;
    joMaster    : Variant;
    joInfo      : Variant;
    //
    sPrefix     : String;

    //
    procedure deSaveData;
    var
        iiTmp   : integer;
    begin
        try
            //根据字段类型分类处理
            //------------------------ 3 BEK - Button Edit OK  ---------------------------------------------------------
            if joField.type = 'auto' then begin                     //----- 1 -----
                //Continue;

            end else if joField.type = 'boolean' then begin         //----- 2 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);

            end else if joField.type = 'button' then begin          //----- 3 -----
                //暂不支持

            end else if (joField.type = 'combo') then begin         //----- 4 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := oCB_Field.text;

            end else if (joField.type = 'combopair') then begin     //----- 5 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := '';
                if oCB_Field.Text <> '' then begin
                    for iiTmp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iiTmp)._(1) = oCB_Field.text then begin
                            oQuery.Fields[iFieldId].AsString  := joField.list._(iiTmp)._(0);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'date' then begin            //----- 6 -----
                oDT_Field   := TDateTimePicker(oComp);
                oQuery.Fields[iFieldId].AsDateTime    := oDT_Field.Date;

            end else if joField.type = 'datetime' then begin        //----- 7 -----
                oDT_Field   := TDateTimePicker(oComp);
                oQuery.Fields[iFieldId].AsDateTime    := oDT_Field.DateTime;

            end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := oCB_Field.text;

            end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := '';
                if oCB_Field.Text <> '' then begin
                    for iiTmp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iiTmp)._(1) = oCB_Field.text then begin
                            oQuery.Fields[iFieldId].AsString  := joField.list._(iiTmp)._(0);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'dbtree' then begin          //----- 10 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else if joField.type = 'float' then begin           //----- 12 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsFloat := StrToFloatDef(oE_Field.text,0);

            end else if joField.type = 'image' then begin           //----- 13 -----

            end else if joField.type = 'index' then begin           //----- 13A -----

            end else if joField.type = 'integer' then begin         //----- 14 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsInteger := StrToIntDef(oE_Field.text,0);

            end else if (joField.type = 'linkage') then begin         //----------
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := oCB_Field.text;

            end else if (joField.type = 'linkagepair') then begin     //----------
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := '';
                if oCB_Field.Text <> '' then begin
                    for iiTmp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iiTmp)._(1) = oCB_Field.text then begin
                            oQuery.Fields[iFieldId].AsString  := joField.list._(iiTmp)._(0);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'memo' then begin            //----- 15 -----
                oM_Field := TMemo(oComp);
                oQuery.Fields[iFieldId].AsString := oM_Field.text;

            end else if joField.type = 'money' then begin           //----- 16 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsFloat := StrToFloatDef(oE_Field.text,0);

            end else if joField.type = 'string' then begin          //----- 17 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;

            end else if joField.type = 'time' then begin            //----- 18 -----
                oDT_Field   := TDateTimePicker(oComp);
                oQuery.Fields[iFieldId].AsDateTime    := oDT_Field.Time;

            end else if joField.type = 'tree' then begin            //----- 19 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else if joField.type = 'treepair' then begin        //----- 20 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else begin
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end;
        except

        end;
    end;
begin
    //编辑/新增面板的确定按钮事件

    try
        //取得源crud panel
        oDBEditor  := deGetDBEditor(TControl(Sender));

        //进入 deBEOClick 事件
        bAccept := True;
        if Assigned(oDBEditor.OnDragOver) then begin
            oDBEditor.OnDragOver(oDBEditor,nil,deEditOK,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //取得配置备用
        joConfig    := deGetConfig(oDBEditor);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得各对象
        oButton     := TButton(Sender);
        oForm       := TForm(oButton.Owner);
        oFFd        := TFlowPanel(oForm.FindComponent(sPrefix+'FFd'));
        oBEA        := TButton(oForm.FindComponent(sPrefix+'BEA'));   //取消按钮，用于记录是否批量新增过
        oCKB        := TCheckBox(oForm.FindComponent(sPrefix+'CKB'));

        //取得Query备用
        oFQTemp     := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQTemp'));

        //用 PEr 的tag来标记当前状态 0表示编辑，100表示新增
        case oFFd.Tag of
            0 : begin   //编辑
                oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));


                //更新数值
                oQuery.Edit;
                for iField := 0 to joConfig.fields._Count -1 do begin

                    //得到字段JSON对象
                    joField := joConfig.fields._(ifield);
                    //取得当前JSON字段对应的数据表字段index
                    iFieldId    := dwGetInt(joField,'fieldid',-1);

                    //跳过非数据表列
                    if iFieldId < 0 then begin
                        continue;
                    end;

                    //保存当前字段值，以用于防重
                    sOldValue   := oQuery.Fields[iFieldId].AsString;

                    //
                    oComp   := oForm.FindComponent(sPrefix+'EF'+IntToStr(iField));

                    //如果找到了控件（有可能因为view<>0的原因找不到）
                    if oComp <> nil then begin
                        //将编辑框内的数据保存到数据表
                        deSaveData;

                        //检查是否为必填字段
                        if dwGetInt(joField,'must',0) = 1 then begin
                            if oQuery.Fields[iFieldId].AsString = '' then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                                Exit;
                            end;
                        end;

                        //检查防重
                        if joField.Exists('unique') then begin
                            if joField.unique = 1 then begin
                                oFQTemp.Close;
                                if oQuery.Fields[iFieldId].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                    ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                                then begin
                                    oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                            +' WHERE '+joField.name+'='+oQuery.Fields[iFieldId].AsString;
                                end else begin
                                    oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                            +' WHERE '+joField.name+'='''+oQuery.Fields[iFieldId].AsString+'''';
                                end;
                                oFQTemp.Open;

                                //根据当前字段是否更改分别处理
                                if sOldValue = oQuery.Fields[iFieldId].AsString then begin
                                    if oFQTemp.Fields[0].AsInteger > 1 then begin
                                        //
                                        if dwGetStr(joField,'uniquehint')  = '' then begin
                                            dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                        end else begin
                                            dwMessage(dwGetStr(joField,'uniquehint'),'error',oForm);
                                        end;
                                        oQuery.Cancel;
                                        Exit;
                                    end;
                                end else begin
                                    if oFQTemp.Fields[0].AsInteger > 0 then begin
                                        //
                                        if dwGetStr(joField,'uniquehint')  = '' then begin
                                            dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                        end else begin
                                            dwMessage(dwGetStr(joField,'uniquehint'),'error',oForm);
                                        end;
                                        oQuery.Cancel;
                                        Exit;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;

                // dePostBefore 事件
                bAccept := True;
                if Assigned(oDBEditor.OnDragOver) then begin
                    oDBEditor.OnDragOver(oDBEditor,nil,deEditPostBefore,0,dsDragEnter,bAccept);
                    if not bAccept then begin
                        Exit;
                    end;
                end;

                //
                oQuery.FetchOptions.RecsSkip  := -1;
                oQuery.Post;

                // dePostAfter 事件
                bAccept := True;
                if Assigned(oDBEditor.OnDragOver) then begin
                    oDBEditor.OnDragOver(oDBEditor,nil,deEditPostAfter,0,dsDragEnter,bAccept);
                    if not bAccept then begin
                        Exit;
                    end;
                end;

            end;
            100 : begin   //新增
                oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));
                //更新数值
                for iField := 0 to joConfig.fields._Count -1 do begin
                    joField := joConfig.fields._(ifield);

                    //取得当前JSON字段对应的数据表字段index
                    iFieldId    := dwGetInt(joField,'fieldid',-1);

                    //跳过非数据表列
                    if iFieldId < 0 then begin
                        continue;
                    end;

                    //跳过 非编辑列
                    if dwGetInt(joField,'view') in [2,3] then begin
                        continue;
                    end;

                    //
                    oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iField));
                    //如果找到了控件（有可能因为view<>0的原因找不到）
                    if oComp <> nil then begin
                        //将编辑框内的数据保存到数据表
                        deSaveData;

                        //检查是否为必填字段
                        if dwGetInt(joField,'must',0) = 1 then begin
                            if oQuery.Fields[iFieldId].AsString = '' then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                                Exit;
                            end;
                        end;

                        //检查防重
                        if joField.Exists('unique') then begin
                            if joField.unique = 1 then begin
                                oFQTemp.Close;
                                if oQuery.Fields[iFieldId].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                    ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                                then begin
                                    oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                            +' WHERE '+joField.name+'='+oQuery.Fields[iFieldId].AsString;
                                end else begin
                                    oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                            +' WHERE '+joField.name+'='''+oQuery.Fields[iFieldId].AsString+'''';
                                end;
                                oFQTemp.Open;
                                if oFQTemp.Fields[0].AsInteger > 0 then begin
                                    //
                                    if dwGetStr(joField,'uniquehint')  = '' then begin
                                        dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                    end else begin
                                        dwMessage(dwGetStr(joField,'uniquehint'),'error',oForm);
                                    end;
                                    Exit;
                                end;
                            end;
                        end;
                    end;
                end;

                //如果有主表，则根据主表写入当前与主表关联的字段
                if joConfig.Exists('master') then begin
                    joMaster    := joConfig.master;
                    if joMaster.Exists('panel') and joMaster.Exists('masterfield') and joMaster.Exists('slavefield') then begin
                        //取得从表panel
                        oMasterPanel := TPanel(oForm.FindComponent(joMaster.panel));

                        //更新从表
                        if oMasterPanel <> nil then begin
                            //取得主表查询
                            oFDQuery    := deGetFDQuery(oMasterPanel);

                            //根据主表更新从表
                            oQuery.FieldByName(String(joMaster.slavefield)).AsVariant
                                    := oFDQuery.FieldByName(String(joMaster.masterfield)).AsVariant;
                        end;
                    end;
                end;

                // deNewBeforePost 事件
                bAccept := True;
                if Assigned(oDBEditor.OnDragOver) then begin
                    oDBEditor.OnDragOver(oDBEditor,nil,deAppendPostBefore,0,dsDragEnter,bAccept);
                    if not bAccept then begin
                        Exit;
                    end;
                end;

                //
                oQuery.FetchOptions.RecsSkip  := -1;
                oQuery.Post;

                // deNewAfterPost 事件
                bAccept := True;
                if Assigned(oDBEditor.OnDragOver) then begin
                    oDBEditor.OnDragOver(oDBEditor,nil,deAppendPostAfter,0,dsDragEnter,bAccept);
                    if not bAccept then begin
                        Exit;
                    end;
                end;
            end;
        end;


        // deBEOClick 事件完成
        bAccept := True;
        if Assigned(oDBEditor.OnDragOver) then begin
            oDBEditor.OnDragOver(oDBEditor,nil,deEditOKFinished,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;
    except
        dwMessage('error when BEOClick finished!','',oForm);

    end;
end;

Procedure BNwClick(Self: TObject; Sender: TObject);
var
    oDBEditor  : TPanel;
    oForm       : TForm;
    oBNw        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oBEM        : TButton;
    oQuery      : TFDQuery;
    //
    joConfig    : Variant;
    //
    bAccept     : Boolean;
    //
    sPrefix     : String;
begin
    //主表新增事件

    //取得各控件
    oBNw    := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    // deNew 事件  新增按钮点击事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deNew,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //取得配置JSON
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oBNw.Owner);
    oPEr    := TPanel(oForm.FindComponent(sPrefix+'PEr'));
    oBEL    := TButton(oForm.FindComponent(sPrefix+'BEL'));
    oBEM    := TButton(oForm.FindComponent(sPrefix+'BEM'));
    oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));

    //
    oBEL.Caption   := '新  增';

    //用 PEr 的tag来标记当前状态，0表示编辑，,100表示新增
    oPEr.Tag  := 100;

    //append前事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oForm,nil,0,1,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新字段值
    deAppend(oDBEditor, oQuery, joConfig.fields,False);

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //
    oPEr.Visible  := True;
end;

Procedure BDeClick(Self: TObject; Sender: TObject);     //button delete
var
    //
    bFound      : Boolean;
    bAccept     : Boolean;
    //
    oDBEditor  : TPanel;
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oQuery      : TFDQuery;
    oSgD        : TStringGrid;
    //
    iRow,iCol   : Integer;
    iItem       : Integer;
    sInfo       : string;
    //
    joConfig    : Variant;
    //
    sPrefix     : String;
begin
    //:::删除事件。


    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //取得配置json备用
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
    oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));
    oSgD    := TStringGrid(oForm.FindComponent(sPrefix+'SgD'));

    //空表检测
    if oQuery.IsEmpty then begin
        Exit;
    end;

    // deDelete 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deDelete,oSgD.Row,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;


    //用来表示是否已选择
    bFound  := False;
    if dwGetInt(joConfig,'select',0)>0 then begin
        for iRow := 1 to oSgD.RowCount - 1 do begin
            if oSgD.Cells[0,iRow] = 'true' then begin
                bFound  := True;
                break;
            end;
        end;
    end;

    //标志当前是主表，用面板的tag
    oPanel.Tag  := 0;

    //根据是否多选，分别处理。如果没多选，则删除当前行；否则， 删除多选行
    if not bFound then begin
        //删除前提示当前行的信息
        sInfo   := '【';

        //取得列序号
        iRow    := oSGD.Row;

        //删除提示信息改从StringGrid中取
        if joConfig.Exists('deletecols') then begin
            //::: 从自定义的deletecols中取, 作为删除前确认标题

            for iItem := 0 to Min(oSGD.ColCount-1, joConfig.deletecols._Count-1) do begin
                //取得当前列序号
                iCol    := joConfig.deletecols._(iItem);
                if iCol < oSGD.ColCount then begin
                    sInfo   := sInfo + oSGD.Cells[iCol,iRow]+' | ';
                end;
            end;
        end else begin
            //::: 从前3列中取, 作为删除前确认标题
            if dwGetInt(joConfig,'select',0) > 0 then begin
                for iCol := 1 to Min(3,oSGD.ColCount-1) do begin
                    sInfo   := sInfo + oSGD.Cells[iCol,iRow]+' | ';
                end;
            end else begin
                for iCol := 0 to Min(2,oSGD.ColCount-1) do begin
                    sInfo   := sInfo + oSGD.Cells[iCol,iRow]+' | ';
                end;
            end;
        end;

        //删除后面的分隔符' | '
        sInfo   := Copy(sInfo,1,Length(sInfo)-3)+'】';
    end else begin
        //删除前提示多行的第一列信息
        sInfo   := '【';
        for iRow := 1 to oSgD.RowCount - 1 do begin
            if oSgD.Cells[0,iRow] = 'true' then begin
                if joConfig.Exists('deletecols') then begin
                    //::: 从自定义的deletecols中取, 作为删除前确认标题

                    //取得当前列序号
                    iCol    := joConfig.deletecols._(0);
                    if iCol < oSGD.ColCount then begin
                        sInfo   := sInfo + oSGD.Cells[iCol,iRow]+' | ';
                    end;
                end else begin
                    sInfo   := sInfo + ''+oSgD.Cells[1,iRow]+' | ';
                end;
            end;
        end;
        sInfo   := Copy(sInfo,1,Length(sInfo)-3)+'】';
    end;


    //删除主表删除弹框前事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oForm,nil,0,10,dsDragEnter,bAccept);
        if not bAccept then begin
            //dwMessage(joConfig.teminate,'error',oForm);
            Exit;
        end;
    end;

    //弹出删除确认框
    oPanel.Caption  := '确定要删除当前记录吗？<br><br>'+sInfo;
    oPanel.Visible  := True;
end;

Procedure BQyClick(Self: TObject; Sender: TObject); //"查询"按钮
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oTbP        : TTrackBar;
    //
    sPrefix     : String;
    joConfig    : Variant;
	bAccept		: boolean;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    // deQuery 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deQuery,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //取得配置JSON备用
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(oButton.Owner);
    oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));

    //设置为第1页
    oTbP.Position   := 0;

    //置标志，表示已查询，即当前查询条件有效
    TButton(Sender).Tag := 1;

    //更新数据
    deUpdate(oDBEditor,'');
end;

Procedure BRsClick(Self: TObject; Sender: TObject);     //button reset
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oBQy        : TButton;
    oForm       : TForm;
    oPQF        : TPanel;
    oFQy        : TFlowPanel;
    oEQy        : TEdit;
    oMQy        : TMemo;
    oTbP        : TTrackBar;
    oCBQy       : TComboBox;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    //
    iItem       : Integer;
    iField      : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
    //
    sPrefix     : String;
	bAccept		: boolean;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));

    //取得控件,当前应为 BRs - Button Reset
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    // deReset 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deReset,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');


    //取得各控件
    oForm       := TForm(oButton.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));
    oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));
    oBQy        := TButton(oForm.FindComponent(sPrefix+'BQy'));


    //置标志，表示未处于查询状态，即当前查询条件无效
    oBQy.Tag    := 1;


    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //取得JSON配置
    joConfig    := deGetConfig(oDBEditor);

    //默认分页为第1页
    oTbP.Position   := 0;

    //
    for iItem := 0 to oFQy.ControlCount-1 do begin
        //得到每个字段的面板
        oPQF := TPanel(oFQy.Controls[iItem]);

        //取得字段序号
        iField      := oPQF.Tag;

        //如果 <0, 则表示为按钮组，跳出
        if iField < 0 then begin
            break
        end;

        //取得当前字段对象
        joField     := joConfig.fields._(iField);

        //根据字段类型分类处理
        //-------------------------------- 2 Button Reset --------------------------------------------------------------
        if joField.type = 'auto' then begin                     //----- 1 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'boolean' then begin         //----- 2 -----
            oCBQy       := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if joField.type = 'button' then begin          //----- 3 -----
            //不支持按钮查询

        end else if (joField.type = 'combo') then begin         //----- 4 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if (joField.type = 'combopair') then begin     //----- 5 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if joField.type = 'date' then begin            //----- 6 -----
            //取得起始结束日期控件
            oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
            oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);
            //
            if joField.Exists('min') then begin
                oDT_Start.Date  := StrToDateDef(joField.min,Now);
            end else begin
                oDT_Start.Date  := StrToDateDef('1900-01-01',Now);  //空值
            end;
            //
            if joField.Exists('max') then begin
                oDT_End.Date    := StrToDateDef(joField.max,Now);
            end else begin
                oDT_End.Date    := StrToDateDef('2500-12-31',Now);  //空值
            end;

        end else if joField.type = 'datetime' then begin        //----- 7 -----
            //暂不支持

        end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if joField.type = 'dbtree' then begin          //----- 10 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'float' then begin           //----- 12 -----
            //暂不支持

        end else if joField.type = 'image' then begin           //----- 13 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'index' then begin           //----- 13A -----
            //暂不支持

        end else if joField.type = 'integer' then begin         //----- 14 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'memo' then begin            //----- 15 -----
            oMQy        := TMemo(oPQF.Controls[1]);
            oMQy.Text   := '';

        end else if joField.type = 'money' then begin           //----- 16 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'string' then begin          //----- 17 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'time' then begin            //----- 18 -----
            //暂不支持

        end else if joField.type = 'tree' then begin            //----- 19 -----
            //暂不支持

        end else if joField.type = 'treepair' then begin        //----- 20 -----
            //暂不支持

        end else begin
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';
        end;
    end;

    deUpdate(oDBEditor,'');
end;


Procedure BUpClick(Self: TObject; Sender: TObject); //"图片上传"按钮 BUp - Button upload
var
    oButton     : TButton;
    oForm       : TForm;
    joHint      : Variant;
    iItem       : Integer;
    sImgDir     : String;
    sAccept     : String;
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

    //取得图片目录
    sImgDir := joHint.imgdir;

    //取得上传文件类型 accept
    sAccept := '';
    for iItem := 0 to joHint.imgtype._Count - 1 do begin
        sAccept := sAccept + '.'+joHint.imgtype._(iItem)+',';
    end;
    if Length(sAccept)>0 then begin
        Delete(sAccept,Length(sAccept),1);
    end;

    //上传前将upload上传事件转移到当前控件中
    dwSetUploadTarget(oForm,TButton(Sender));

    //开始上传
    dwUpload(oForm, sAccept, sImgDir);
end;

//上传完成事件
procedure BUpEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    oDBEditor  : TPanel;
    oButton     : TButton;
    oImage      : TImage;
    oQuery      : TFDQuery;
    sFile       : String;
    sDir        : String;
    sPrefix     : string;
    //
    joConfig    : Variant;
    joHint      : Variant;
begin
    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oButton := TButton(Sender);
    oQuery  := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));

    //取得上传完成后的文件名和源文件名
    sFile   := dwGetProp(oButton,'__upload');

    //取得当前按钮的JSON
    joHint  := _json(oButton.Hint);

    //将上传完成的文件改重命名为源文件名
    sDir        := ExtractFilePath(Application.ExeName)+String(joHint.imgdir);

    //显示
    oImage      := TImage(oButton.Parent.Controls[0]);
    oImage.Hint := '{"src":"'+joHint.imgdir+sFile+'"}';

    //保存数据
    oQuery.Edit;
    oQuery.FieldByName(joHint.name).AsString    := sFile;
end;


Procedure EKwChange(Self: TObject; Sender: TObject);    //EKw : Edit Keyword
var
    oEKw        : TEdit;
    oDBEditor  : TPanel;
    oForm       : TForm;
    oTbP        : TTrackBar;
    //
    sPrefix     : String;
    joConfig    : Variant;
	bAccept		: boolean;
begin
    //dwMessage('B_ResetClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oEKw        := TEdit(Sender);
    oForm       := TForm(oEKw.Owner);

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));

    //
    oTbP.Position   := 0;

    // deQuery 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,deQuery,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新数据
    deUpdate(oDBEditor,'');
end;

Procedure FQyResize(Self: TObject; Sender: TObject);
var
    oFQy        : TFlowPanel;
    oChange     : Procedure(Sender:TObject) of Object;
begin
    //取得各控件
    oFQy        := TFlowPanel(Sender);
    //
    oChange         := oFQy.OnResize;
    oFQy.OnResize   := nil;
    oFQy.AutoSize   := True;
    oFQy.AutoSize   := False;
    //
    oFQy.OnResize   := oChange;

    //需要设置当前overflow:visible, 以显示tree选项
    dwRunJS('$("#'+dwFullName(oFQy)+'").css("overflow", "visible");',TForm(oFQy.Owner));
end;

//数据表点击
Procedure SGDClick(Self: TObject; Sender: TObject); //Sgd - StringGrid data
var
    iRow        : Integer;
    iSlave      : Integer;
    //
    oForm       : TForm;
    oSG         : TStringGrid;
    oFDQuery    : TFDQuery;
    oDBEditor  : TPanel;
    oSlavePanel : TPanel;
    oPQm        : TPanel;
    oClick      : Procedure(Sender: TObject) of Object;
    //
    sPrefix     : String;
    sWhere      : String;
	bAccept		: boolean;
    //
    joConfig    : Variant;
    joSConfig   : Variant;
    joSlave     : variant;
begin

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //主表的单击事件。功能：
    //1 如果主表未满行，点击空行后，自动切到最末行
    //2 根据当前主表的记录位置，自动更新
    //取得各控件
    oSG         := TStringGrid(Sender);
    oForm       := TForm(oSG.Owner);
    oFDQuery    := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));

    //数据为空时跳过
    if oFDQuery.IsEmpty then begin
        Exit;
    end;

    //跳过表格中的新增按钮触发的事件
    if oFDQuery.State = dsInsert then begin
        Exit;
    end;

    //得到当前行
    iRow    := oSG.Row;
    //检查是否空行。如果是空行，则切到最末行
    if iRow > oFDQuery.RecordCount then begin
        iRow    := oFDQuery.RecordCount;
        //
        oClick      := oSG.OnClick;
        oSG.OnClick := nil;
        oSG.Row     := iRow;
        oSG.OnClick := oClick;
    end;

    //更新数据表记录
    oFDQuery.RecNo    := iRow;
    oFDQuery.Tag      := iRow;    //保存位置备用

    // deDataScroll 事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        if oFDQuery.IsEmpty then begin
            oDBEditor.OnDragOver(oDBEditor,nil,deDataScroll,-1,dsDragEnter,bAccept);
        end else begin
            oDBEditor.OnDragOver(oDBEditor,nil,deDataScroll,oFDQuery.RecNo,dsDragEnter,bAccept);
        end;
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新可能存在的从表
    if joConfig.Exists('slave') then begin
        for iSlave := 0 to joConfig.slave._Count - 1 do begin
            joSlave := joConfig.slave._(iSlave);
            if joSlave.Exists('panel') and joSlave.Exists('masterfield') and joSlave.Exists('slavefield') then begin
                //取得从表panel
                oSlavePanel := TPanel(oForm.FindComponent(joSlave.panel));

                //更新从表
                if oSlavePanel <> nil then begin
                    //如果从表是DBCard, 则用DBCard的外置更新方法更新数据
                    if oSlavePanel.HelpContext = 31028 then begin
                        //取从表的配置JSON
                        joSConfig   := _json(oSlavePanel.Hint);
                        //取从表的前缀
                        sPrefix     := dwGetStr(joSConfig,'prefix');
                        //取从表的PQm : panel query smart
                        oPQm        := TPanel(oForm.FindComponent(sPrefix+'PQm'));
                        //
                        if oPQm <> nil then begin
                            //设置 where , 通过 pqm 的caption
                            if oFDQuery.IsEmpty then begin
                                sWhere  := '1=0';
                            end else begin
                                //根据是否为整型分别生成where字符串
                                if (oFDQuery.FieldByName(String(joSlave.masterfield)).DataType in destInteger) then begin
                                    sWhere  := String(joSlave.slavefield)+'='+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString;
                                end else begin
                                    sWhere  := String(joSlave.slavefield)+'="'+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString+'"';
                                end;
                            end;

                            //将条件保存到 PQm - panel query smart
                            oPQm.Caption    := sWhere;

                            //用DBCard的外置更新方法更新数据
                            oPQm.OnUnDock(oPQm,nil,nil,bAccept);
                        end;
                    end else begin
                        if oFDQuery.IsEmpty then begin
                            deUpdate(oSlavePanel,'1=0');
                        end else begin
                            //根据是否为整型分别生成where字符串
                            if (oFDQuery.FieldByName(String(joSlave.masterfield)).DataType in destInteger) then begin
                                deUpdate(oSlavePanel,String(joSlave.slavefield)+'='+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString);
                            end else begin
                                deUpdate(oSlavePanel,String(joSlave.slavefield)+'="'+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString+'"');
                            end;
                        end;
                    end;
                end;

            end;
        end;
    end;

end;

Procedure SGDEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    iCol,iRow   : Integer;
    iButtonID   : Integer;
    iFieldId    : Integer;
    //
    oForm       : TForm;
    oSGD        : TStringGrid;
    oQuery      : TFDQuery;
    oDBEditor  : TPanel;
    oButton     : TButton;

    //
    sPrefix     : String;
    sMethod     : string;
	bAccept		: boolean;
    //
    joConfig    : Variant;
    joField     : Variant;
    joButton    : Variant;
begin
    //该事件为dwTStringGrid__mulit数据表中的change事件.
    //此处主要处理按钮列的事件

    //取得列、行和按钮序号
    iCol        := X mod 1000;
    iRow        := Y;
    iButtonID   := X div 1000;
    //
    //dwMessage(Format('SGDEndDock Col=%d,Row=%d,BtnId=%d',[iCol,iRow,iButtonId]),'success',TForm(TStringGrid(Sender).Owner));

    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oSGD        := TStringGrid(Sender);
    oForm       := TForm(oSGD.Owner);

    //
    oQuery      := TFDQuery(oDBEditor.FindComponent(sPrefix+'FQMain'));

    //取得字段序号
    iFieldId    := deGetJsonIdFromColId(joConfig,iCol);

    //异常检查. 目前主要针对选择列的结果为-1
    if (iFieldId < 0) or (iFieldId>=joConfig.fields._Count) then begin
        Exit;
    end;

    //取得列JSON对象
    joField     := joConfig.fields._(iFieldId);

    //仅处理按钮列
    if joField.type = 'button' then begin
        //取得按钮JSON对象
        joButton    := joField.list._(iButtonId);

        //取得对象的事件, 默认为自定义
        sMethod     := LowerCase(dwGetStr(joButton,'method','custom'));

        //如果是增删改事件，则直接调用；否则触发
        if sMethod = 'new' then begin
            //此处不能和delete/edit一样切换记录,否则会影响 oQuery.state
            oButton := TButton(oForm.FindComponent(sPrefix+'BNw'));
            oButton.OnClick(oButton);
        end else if sMethod = 'delete' then begin
            //先切换到当前记录
            oQuery.RecNo:= Min(oQuery.RecordCount,iRow);
            oSGD.Row    := oQuery.RecNo;
            //
            oButton := TButton(oForm.FindComponent(sPrefix+'BDe'));
            oButton.OnClick(oButton);
        end else if sMethod = 'edit' then begin
            //先切换到当前记录
            oQuery.RecNo:= Min(oQuery.RecordCount,iRow);
            oSGD.Row    := oQuery.RecNo;
            //
            oButton := TButton(oForm.FindComponent(sPrefix+'BEt'));
            oButton.OnClick(oButton);
            //

        end else if sMethod = 'custom' then begin
            // 列中按钮的自定义事件 OnDragOver中，X-1000为列序号，Y mod 1000为行序号，Y div 1000为按钮序号
            bAccept := True;
            if Assigned(oDBEditor.OnDragOver) then begin
                oDBEditor.OnDragOver(oDBEditor,nil,1000+iCol,iRow + iButtonId * 1000,dsDragEnter,bAccept);
                if not bAccept then begin
                    Exit;
                end;
            end;
        end;
    end else if joField.type = 'link' then begin
        oQuery.RecNo:= Min(oQuery.RecordCount,iRow);
        oSGD.Row    := oQuery.RecNo;
        // 列中按钮的自定义事件 OnDragOver中，X-1000为列序号，Y mod 1000为行序号，Y div 1000为按钮序号
        bAccept := True;
        if Assigned(oDBEditor.OnDragOver) then begin
            oDBEditor.OnDragOver(oDBEditor,nil,iCol,iRow ,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;
    end else begin
        oQuery.RecNo:= Min(oQuery.RecordCount,iRow);
        oSGD.Row    := oQuery.RecNo;
    end;
end;


Procedure SGDGetEditMask(Self: TObject; Sender: TObject; ACol, ARow: Integer; var Value: string);
var
    iField      : Integer;
    iFieldId    : Integer;  //根据列号取得字段序号，以用于排序。 原使用字段名排序时，多同名字段时会报错
    iItem       : Integer;
    sPrefix     : String;
    sFilter     : string;
    sData       : string;
    //
    oDBEditor  : TPanel;
    oSGD        : TStringGrid;
    oForm       : TForm;
    oTbP        : TTrackBar;
    oChange     : Procedure(Sender:TObject) of Object;
    //
    joConfig    : Variant;
    joValue     : Variant;
    joField     : Variant;
    joStyleName : Variant;
    joFilter    : Variant;
begin
    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //
    joConfig    := deGetConfig(oDBEditor);

    //先转化为JSON对象
    joValue     := _json(Value);

    //异常检查
    if joValue = unassigned then begin
        dwMessage('error Value when SgDGetEditMask','',TForm(TEdit(Sender).Owner));
        Exit;
    end;
    if not joValue.Exists('type') then begin
        dwMessage('error Value.type when SgDGetEditMask','',TForm(TEdit(Sender).Owner));
        Exit;
    end;

    //
    if joValue.type = 'sort' then begin
        //主表点击排序
        //当设置了显示排序按钮时，当点击排序按钮时，StringGrid会自动激活OnGetEditMask事件。其中参数：
        //ACol : Integer ; 为所在列序号（从0开始）；
        //ARow : Integer;  为排序方向，1为升序，0为降序,9为不排序；
        //Value : string; 为标识，固定为字符串'sort'
        //取得各控件
        oSGD        := TStringGrid(Sender);

        //取得窗体备用
        oForm       := TForm(oSGD.Owner);

        //取得分页控件, 置为第1页
        oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));
        oChange     := oTbP.OnChange;
        oTbP.OnChange   := nil;
        //设置为第1页
        oTbP.Position   := 0;
        oTbP.OnChange   := oChange;

        //得到当前列信息
        joField     := joConfig.fields._(deGetJsonIdFromColId(joConfig,ACol));

        //取得字段序号
        iFieldId    := dwGetInt(joField,'fieldid',0);

        //取得stylename的JSON
        joStyleName := _json(oSGD.StyleName);
        if joStyleName = unassigned then begin
            joStyleName := _json('{}');
        end;

        //对排序的处理
        case ARow of
            0 : begin    //为降序,
                joStyleName.order := 'ORDER BY ' + IntToStr(iFieldId+1) + ' DESC';
            end;
            1 : begin   //为升序，
                joStyleName.order := 'ORDER BY ' + IntToStr(iFieldId+1) ;
            end;
            9 : begin   //为不排序；
                joStyleName.order := '';
            end;
        end;

        //回写到SG的stylename(包括多列排序数据和筛选数据)
        oSGD.StyleName   := joStyleName;

        //更新数据
        deUpdate(oDBEditor,'');

    end else if joValue.type = 'filter' then begin
        //筛选事件
        //形如：{"type":"filter","col":3,"data":["襄阳","朝阳区"]}

        //取得各控件
        oSGD    := TStringGrid(Sender);

        //取得配置JSON
        joConfig    := deGetConfig(oDBEditor);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得窗体备用
        oForm       := TForm(oSGD.Owner);

        //取得分页控件, 置为第1页
        oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));
        oChange     := oTbP.OnChange;
        oTbP.OnChange   := nil;
        //设置为第1页
        oTbP.Position   := 0;
        oTbP.OnChange   := oChange;

        //得到当前列信息
        joField     := joConfig.fields._(deGetJsonIdFromColId(joConfig,ACol));

        //根据列序号，取得JSON字段序号
        iField  := deGetJsonIdFromColId(joConfig,joValue.col);

        //取得stylename的JSON
        joStyleName := _json(oSGD.StyleName);
        if joStyleName = unassigned then begin
            joStyleName := _json('{}');
        end;

        //设置空值(筛选时点重置或未选择)
        if joValue.data._Count = 0 then begin
            //-----重置 操作------

            //从filter的JSON数组中 清除
            if joStyleName.Exists('filter') then begin
                //清除原来可能存在的当前列筛选
                for iItem := 0 to joStyleName.filter._Count - 1 do begin
                    if joStyleName.filter._(iItem).fieldno = iField then begin
                        joStyleName.filter.Delete(iItem);
                        break;
                    end;
                end;
            end else begin
                joStyleName.filter := _json('[]');
            end;
        end else begin
            //-----筛选 操作------

            //得到字段JSON对象
            joField := joConfig.fields._(iField);

            //跳到第一页.筛选后从第1页开始
            TTrackBar(oForm.FindComponent(sPrefix+'TBP')).Position  := 0;

            //生成筛选字符串, 如： (city="西安") or (city="上海")
            sFilter := '';
            for iItem := 0 to joValue.data._Count - 1 do begin

                //如果是pair系列,则取得存储值
                if          joField.type = 'boolean'        then begin  //----- 2 -----
                    if joValue.data._(iItem) = joField.list._(1) then begin
                        sData   := 'true';
                    end else begin
                        sData   := 'false';
                    end;
                end else if joField.type = 'combopair'      then begin  //----- 5 -----
                    sData   := deGetPairData(joField,joValue.data._(iItem));
                end else if joField.type = 'dbcombopair'    then begin  //----- 9 -----
                    sData   := deGetPairData(joField,joValue.data._(iItem));
                end else if joField.type = 'dbtreepair'     then begin  //----- 11 -----
                    sData   := deGetPairData(joField,joValue.data._(iItem));
                end else if joField.type = 'treepair'       then begin  //----- 20 -----
                    sData   := deGetPairData(joField,joValue.data._(iItem));
                end else begin
                    sData   := joValue.data._(iItem);
                end;

                //根据字段类型处理
                if joField.Exists('datatype') then begin
                    //根据字段类型分别处理，主要分整型、浮点型和其他（按字符串型处理）
                    if TFieldType(joField.datatype) in destInteger then begin
                        sFilter := sFilter  +' or ('+joField.name+'='+sData+')';
                    end else if TFieldType(joField.datatype) in destFloat then begin
                        sFilter := sFilter  +' or ('+joField.name+'='+sData+')';
                    end else begin
                        //如果是pair系列,则需要转为
                        sFilter := sFilter  +' or ('+joField.name+'='''+sData+''')';
                    end;
                end else begin
                    //无字段类型的 按字符串型处理
                    sFilter := sFilter  +' or ('+joField.name+'='''+sData+''')';
                end;
            end;
            Delete(sFilter,1,4);
            sFilter := '(' + sFilter + ')';

            //生成筛选JSON对象
            joFilter    := _json('{}');
            joFilter.fieldno    := iField;
            joFilter.where      := sFilter; //将筛选字符串以 WHERE 内容字符串的形式保存在stylename中

            //添加到filter的JSON数组中
            if joStyleName.Exists('filter') then begin
                //先清除原来可能存在的当前列筛选
                for iItem := 0 to joStyleName.filter._Count - 1 do begin
                    if joStyleName.filter._(iItem).fieldno = iField then begin
                        joStyleName.filter.Delete(iItem);
                        break;
                    end;
                end;
                joStyleName.filter.Add(joFilter);
            end else begin
                joStyleName.filter := _json('[]');
                joStyleName.filter.Add(joFilter);
            end;
        end;

        //回写到SG的stylename(包括多列排序数据和筛选数据)
        oSGD.StyleName   := joStyleName;

        //更新数据
        deUpdate(oDBEditor,'');

    end;
end;



Procedure TrackbarPageChange(Self: TObject; Sender: TObject);    //TbP TrackBar page
var
	bAccept		: boolean;
    sPrefix     : String;
    //
    oDBEditor   : TPanel;
    oTbP        : TTrackBar;
    oFDQuery    : TFDQuery;
    //
    joConfig    : Variant;
begin
    //取得源crud panel
    oDBEditor  := deGetDBEditor(TControl(Sender));

    //取得JSON配置
    joConfig    := deGetConfig(oDBEditor);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oTbP        := TTrackBar(sender);

    //append事件
    bAccept := True;
    if Assigned(oDBEditor.OnDragOver) then begin
        oDBEditor.OnDragOver(oDBEditor,nil,dePageNo,oTbP.Position,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    oFDQuery    := deGetFDQuery(oDBEditor);
    oFDQuery.RecNo  := oTbP.Position + 1;

    //更新数据
    deUpdateView(deGetDBEditor(TControl(Sender)));
end;


procedure deCreateConfirmPanel(APanel:TPanel);
var
    oForm       : TForm;
    oPDe        : TPanel;
    //用于指定事件
    tM          : TMethod;
    sPrefix     : String;
    joConfig    : Variant;
begin
    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    oPDe   := TPanel.Create(oForm);
    with oPDe do begin
        Name        := sPrefix + 'PDe';
        Parent      := APanel;
        HelpKeyword := 'ok';
        Visible     := False;
        BorderStyle := bsNone;
        Top         := 150;
        Width       := 340;
        Height      := 200;
        Hint        := '{"ok":"确定","cancel":"取消","radius":"10px"}';
        Font.Color  := $323232;
        Caption     := 'Are you sure ?';

        //确定事件
        tM.Code         := @BDOClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnEnter         := TNotifyEvent(tM);

        //取消事件
        tM.Code         := @BDCClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnExit          := TNotifyEvent(tM);
    end;
end;


function  deCreateFieldQuery(APanel:TPanel;AConfig:Variant;AField:Variant;AIndex:Integer;ASuffix:String;AFlowPanel:TFlowPanel):Integer;
var
    oForm       : TForm;
    oPQF        : TPanel;
    oL_Query    : TLabel;
    oCBQy       : TComboBox;
    oP_DateSE   : TPanel;
    oDT_Start   : TDateTimePicker;
    oL_Space    : TLabel;
    oDT_End     : TDateTimePicker;
    oE_Query    : TEdit;
    //
    iItem       : Integer;
    //
    sTable      : String;
    sTemp       : String;
    sPrefix     : String;
begin
	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(AConfig,'prefix','');

	//取得Form备用
	oForm       := TForm(APanel.Owner);

    //创建一个单字段查询面板
    oPQF := TPanel.Create(oForm);
    with oPQF do begin
        Name            := sPrefix + 'PQ'+ASuffix;
        Parent          := AFlowPanel;
        Color           := clNone;
        Width           := AConfig.editwidth - 15 ;
        Height          := 45;
        Tag             := AIndex;
        Hint            := '{"dwstyle":"overflow:visible;"}';
    end;
    //创建查询字段标签
    oL_Query    := TLabel.Create(oForm);
    with oL_Query do begin
        Name            := sPrefix + 'LQ'+ASuffix;
        Parent          := oPQF;
        Tag             := AIndex;
        Align           := alLeft;
        Layout          := tlCenter;
        if AField.Exists('caption') then begin
            Caption         := AField.caption ;
        end else begin
            Caption         := AField.name ;
        end;
        Alignment       := taRightJustify;
        Width           := 80;
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
        Margins.Bottom  := 10;
    end;
    //------------------ 6  deCreateFieldQuery --------------------------------------------------------------------------
    if AField.type = 'auto' then begin                     //----- 1 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'boolean' then begin         //----- 2 -----
        //创建查询字段控件
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alClient;
            Style               := csDropDownList;
            Text                := '';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 10;

            //默认添加一个空值
            if AField.list._Count > 0 then begin
                if AField.list._(0) <> '' then begin
                    Items.Add('');
                end;
            end;
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;


    end else if AField.type = 'button' then begin          //----- 3 -----

    end else if (AField.type = 'combo') then begin         //----- 4 -----
        //创建查询字段控件
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alClient;
            Style               := csDropDownList;
            Text                := '';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 10;

            //默认添加一个空值
            if AField.list._Count > 0 then begin
                if AField.list._(0) <> '' then begin
                    Items.Add('');
                end;
            end;
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;

    end else if (AField.type = 'combopair') then begin     //----- 5 -----
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alClient;
            Style               := csDropDownList;
            Text                := '';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 10;

            //默认添加一个空值
            Items.Add('');
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(1));
            end;
        end;

    end else if AField.type = 'date' then begin            //----- 6 -----
        //创建面板存放起始结束日期
        oP_DateSE := TPanel.Create(oForm);
        with oP_DateSE do begin
            Name            := sPrefix + 'PDE'+ASuffix;
            Parent          := oPQF;
            Color           := clNone;
            Align           := alClient;
            Tag             := AIndex;
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;overflow:hidden;"}';
            //
            AlignWithMargins:= True;
            Margins.Top     := 4;
            Margins.Bottom  := 8;
            Margins.Right   := 0;
        end;
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(oForm);
        with oDT_Start do begin
            Name        := sPrefix + 'DS'+ASuffix;
            Parent      := oP_DateSE;
            Align       := alNone;
            Left        := -25;
            Tag         := AIndex;
            Top         := 1;
            Width       := 135;
            Height      := 28;

            Kind        := dtkDate;

            //检查min如果非数字, 则转化为日期; 否则按当前日期算差值
            if AField.Exists('min') then begin
                if StrToIntDef(AField.min,-999) = -999 then begin
                    Date        := StrToDateDef(AField.min,Now);
                end else begin
                    Date        := Now + StrToInt(AField.min);
                end;
            end else begin
                Date        := StrToDateDef('1900-01-01',Now);;
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;
        //起止日期间分隔符
        oL_Space    := TLabel.Create(oForm);
        with oL_Space do begin
            Name        := sPrefix + 'LS'+ASuffix;
            Parent      := oP_DateSE;
            Tag         := AIndex;
            AutoSize    := False;
            Alignment   := taCenter;
            Left        := 78;
            Top         := 5;
            Caption     := '—';
            Width       := 30;
            Transparent := False;
            Color       := clWhite;
            Hint        := '{"dwstyle":"z-index: 1;"}';
        end;
        //创建查询结束日期
        oDT_End   := TDateTimePicker.Create(oForm);
        with oDT_End do begin
            Parent      := oP_DateSE;
            Name        := sPrefix + 'DE'+ASuffix;
            Tag         := AIndex;
            Left        := 80;
            Top         := 1;
            Width       := 135;
            Height      := 28;

            Kind        := dtkDate;

            if AField.Exists('max') then begin
                if StrToIntDef(AField.max,-999) = -999 then begin
                    Date        := StrToDateDef(AField.max,Now);
                end else begin
                    Date        := Now + StrToInt(AField.max);
                end;
            end else begin
                Date    := StrToDateDef('2500-12-31',Now);;
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

    end else if AField.type = 'datetime' then begin        //----- 7 -----
        //<-----创建起始日期时间
        //设置默认值
        if not AField.Exists('min') then begin
            AField.min := '2000-01-01 00:00:00'
        end;
        //更新标签
        oL_Query.Caption    := AField.caption + '>=';
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(oForm);
        with oDT_Start do begin
            Name            := sPrefix + 'DS'+ASuffix;
            Parent          := oPQF;
            Align           := alClient;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            Format          := 'yyyy-MM-dd HH:mm:ss';
            Tag             := AIndex;
            Height          := 32;
            HelpContext     := 1;  //标记为起始时间
            Date            := StrToDateDef(Copy(AField.min,1,10),Now);
            Time            := StrToTimeDef(Copy(AField.min,12,8),Now);
            Hint            := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
                            //+',"dwattr":"format=\"yyyy-MM-dd HH:mm:ss\" :type=\"datetime\""}';
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
        end;
        //----->

        //<-----创建结束日期时间
        //默认值
        if not AField.Exists('max') then begin
            AField.max := '2050-01-01 00:00:00';
        end;
        //创建一个单字段查询面板
        oPQF := TPanel.Create(oForm);
        with oPQF do begin
            Name            := sPrefix + 'PDT'+ASuffix;
            Parent          := AFlowPanel;
            Color           := clNone;
            Width           := AConfig.editwidth - 15 ;
            Height          := 45;
            Tag             := AIndex;
        end;
        //创建查询字段标签
        oL_Query    := TLabel.Create(oForm);
        with oL_Query do begin
            Name        := sPrefix + 'LQE'+ASuffix;
            Parent      := oPQF;
            Tag         := AIndex;
            Align       := alLeft;
            Layout      := tlCenter;
            Caption     := AField.caption + '<=';
            Alignment   := taRightJustify;
            Width       := 80;
            //
            AlignWithMargins    := True;
            Margins.Left        := 10;
        end;
        //

        //创建查询结束日期
        oDT_End := TDateTimePicker.Create(oForm);
        with oDT_End do begin
            Name            := sPrefix + 'DE'+ASuffix;
            Parent          := oPQF;
            Align           := alClient;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            Format          := 'yyyy-MM-dd HH:mm:ss';
            Tag             := AIndex;
            Height          := 32;
            HelpContext     := -1;  //标记为结束时间
            Date            := StrToDateDef(Copy(AField.max,1,10),Now);
            Time            := StrToTimeDef(Copy(AField.max,12,8),Now);
            Hint            := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
                            //+',"dwattr":"format=\"yyyy-MM-dd HH:mm:ss\" :type=\"datetime\""}';
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;
        //----->

    end else if (AField.type = 'dbcombo') then begin       //----- 8 -----
        //创建数据库查询ComboBox
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Style           := csDropDownList;
            Text            := '';
            Align           := alClient;
            //
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;

            //默认添加一个空值
            Items.Add('');
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;

    end else if (AField.type = 'dbcombopair') then begin   //----- 9 -----
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            Style           := csDropDownList;
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

            //默认添加一个空值
            Items.Add('');

            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(1));
            end;
        end;

    end else if AField.type = 'dbtree' then begin          //----- 10 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oPQF;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

        end;
    end else if AField.type = 'dbtreepair' then begin      //----- 11 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oPQF;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

        end;

    end else if AField.type = 'float' then begin           //----- 12 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'image' then begin           //----- 13 -----
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'index' then begin           //----- 13A -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'integer' then begin         //----- 14 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'memo' then begin            //----- 15 -----
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'money' then begin           //----- 16 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'string' then begin          //----- 17 -----
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'time' then begin            //----- 18 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'tree' then begin            //----- 19 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

            Parent          := oPQF;
        end;


    end else if AField.type = 'treepair' then begin        //----- 20 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

            Parent          := oPQF;
        end;
    end else begin
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
            Parent              := oPQF;
        end;

    end;

end;


//在DBEditor的按钮栏中插入控件(一般用于插入自定义的按钮)
function deAddInButtons(APanel:TPanel;ACtrl:TWinControl):Integer;
var
    oPBs        : TPanel;
    oBNw        : TButton;
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
begin

    result  := 0;

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');
    try
        //取得按钮面板
        oPBs            := TPanel(oForm.FindComponent(sPrefix+'PBs'));
        //取得“新增”按钮，以设置新控件的Margins
        oBNw            := TButton(oForm.FindComponent(sPrefix+'BNw'));
        //嵌入
        ACtrl.Parent    := oPBs;
        ACtrl.Align     := alLeft;
        //设置Margins
        ACtrl.Margins   := oBNw.Margins;
        ACtrl.AlignWithMargins  := True;
        //
        oPBs.Width      := 9999;
        oPBs.AutoSize   := True;
        oPBs.AutoSize   := False;
    except
        Result  := -1;
    end;
end;

function deAddInSmart(APanel:TPanel;ACtrl:TWinControl):Integer;
var
    oPQm        : TPanel;
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
begin

    result  := 0;

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := deGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');
    try
        //取得按钮面板
        oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));
        //嵌入
        with ACtrl do begin
            Parent      := oPQm;
            Align       := alRight;
            //设置Margins
            AlignWithMargins    := True;
            Margins.Top         := 7;
            Margins.Bottom      := 4;
            Margins.Left        := 0;
            Margins.Right       := 10;
        end;
    except
        Result  := -1;
    end;
end;

//更新字段显示
procedure deUpdateView(APanel:TPanel);
var
    iField      : Integer;
    iFieldId    : Integer;
    iItem       : Integer;
    iList       : Integer;
    iSlave      : Integer;
    iTemp       : Integer;

    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    sText       : String;
    sTmp        : String;
    sValue      : String;

    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    joMaster    : variant;
    joStyleName : Variant;
    joList      : Variant;
    joSlave     : Variant;
    joSConfig   : variant;
    //
    oForm       : TForm;
    oFDQuery    : TFDQuery;
    oTbP        : TTrackBar;
    oEKw        : TEdit;
    oFQy        : TFlowPanel;
    oPQF        : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCBQy       : TComboBox;
    oBFz        : TButton;
    oBQy        : TButton;
    oMasterPanel: TPanel;
    oFQMaster   : TFDQuery;
    oSlavePanel : TPanel;
    oPQm        : TPanel;
    oComp       : TComponent;
    oEFx        : TEdit;
    oMFx        : TMemo;
    oIFx        : TImage;
    oBFx        : TButton;
    oDFx        : TDateTimePicker;
    oCFx        : TComboBox;
    oPIn        : TPanel;
    //
    sPrefix     : String;
	bAccept		: boolean;
    oClick      : Procedure(Sender:TObject) of Object;
begin
    try
        //
        oForm       := TForm(APanel.Owner);

        //
        oFDQuery    := deGetFDQuery(APanel);

        //
        joConfig    := deGetConfig(APanel);

        //更新编辑框显示-------------------------
        for iItem := 0 to joConfig.fields._Count-1 do begin
            //得到字段JSON
            joField := joConfig.fields._(iItem);

            //取得当前JSON字段对应的数据表字段index
            iFieldId    := dwGetInt(joField,'fieldid',-1);

            //跳过非数据表列
            if iFieldId < 0 then begin
                continue;
            end;

            //查找字段对应的编辑控件
            oComp   := oForm.FindComponent(sPrefix+'EF'+IntToStr(iItem));

            //如果找到了控件（有可能因为view<>0的原因找不到）
            if oComp <> nil then begin
                //取字段的AsString，并清除其中的特殊字符串（如换行），备用
                sValue  := oFDQuery.Fields[iFieldId].AsString;
                sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
                sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

                //根据字段类型分类处理
                //------------------------ 4 BEt - Button Edit -------------------------------------------------------------
                if joField.type = 'auto' then begin                     //----- 1 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end else if joField.type = 'boolean' then begin         //----- 2 -----
                    oCFx        := TComboBox(oComp);
                    if LowerCase(sValue)='true' then begin
                        oCFx.ItemIndex  := 1;
                    end else begin
                        oCFx.ItemIndex  := 0;
                    end;

                end else if joField.type = 'button' then begin          //----- 3 -----

                end else if (joField.type = 'combo') then begin         //----- 4 -----
                    oCFx        := TComboBox(oComp);
                    oCFx.Itemindex  := -1;
                    if oCFx.Style = csDropDown then begin
                        oCFx.Text   := sValue;
                    end else begin
                        oCFx.ItemIndex  := oCFx.Items.IndexOf(sValue);
                    end;

                end else if (joField.type = 'combopair') then begin     //----- 5 -----
                    oCFx        := TComboBox(oComp);
                    oCFx.Itemindex  := -1;
                    oCFx.Text   := '';
                    if sValue <> '' then begin
                        for iTemp := 0 to joField.list._Count - 1 do begin
                            if joField.list._(iTemp)._(0) = sValue then begin
                                oCFx.Text   := joField.list._(iTemp)._(1);
                                break;
                            end;
                        end;
                    end;

                end else if joField.type = 'date' then begin            //----- 6 -----
                    oDFx        := TDateTimePicker(oComp);
                    oDFx.Kind   := dtkDate;
                    if oFDQuery.Fields[iItem].IsNull then begin
                        oDFx.Date   := StrToDate('1899-12-30');
                    end else begin
                        oDFx.Date   := oFDQuery.Fields[iFieldId].AsDateTime;
                    end;

                end else if joField.type = 'datetime' then begin        //----- 7 -----
                    oDFx         := TDateTimePicker(oComp);
                    oDFx.ShowCheckbox   := True;
                    if oFDQuery.Fields[iFieldId].IsNull then begin
                        oDFx.Date    := StrToDate('1899-12-30');
                        oDFx.Time    := StrToTime('00:00:00');
                    end else begin
                        oDFx.Date    := oFDQuery.Fields[iFieldId].AsDateTime;
                        oDFx.Time    := oFDQuery.Fields[iFieldId].AsDateTime;
                    end;

                end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
                    oCFx         := TComboBox(oComp);
                    oCFx.Itemindex  := -1;
                    oCFx.Text   := '';
                    if oCFx.Style = csDropDown then begin
                        oCFx.Text   := sValue;
                    end else begin
                        oCFx.ItemIndex  := oCFx.Items.IndexOf(sValue);
                    end;

                end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
                    oCFx        := TComboBox(oComp);
                    oCFx.Itemindex  := -1;
                    oCFx.Text   := '';
                    if sValue <> '' then begin
                        for iTemp := 0 to joField.list._Count - 1 do begin
                            if joField.list._(iTemp)._(0) = sValue then begin
                                oCFx.Text   := joField.list._(iTemp)._(1);
                                break;
                            end;
                        end;
                    end;

                end else if joField.type = 'dbtree' then begin          //----- 10 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
                    oEFx        := TEdit(oComp);
                    //joList      := deGetTreeListJson(joField.list);
                    //oE.Text     := deGetTreeListView(joList,sValue);
                    oEFx.Text   := sValue;
                end else if joField.type = 'float' then begin           //----- 12 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end else if joField.type = 'image' then begin           //----- 13 -----
                    oIFx        := TImage(oComp);
                    if joField.Exists('imgdir') then begin
                        sValue  := String(joField.imgdir) + sValue;
                    end;
                    oIFx.Hint   := '{"dwstyle":"border-radius:3px;","src":"'+sValue+'"}';

                end else if joField.type = 'index' then begin           //----- 13A -----
                    //序号列, 不应该显示在编辑面板中

                end else if joField.type = 'integer' then begin         //----- 14 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end else if joField.type = 'memo' then begin            //----- 15 -----
                    oMFx        := TMemo(oComp);
                    oMFx.Text   := sValue;

                end else if joField.type = 'money' then begin           //----- 16 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end else if joField.type = 'string' then begin          //----- 17 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end else if joField.type = 'time' then begin            //----- 18 -----
                    oDFx         := TDateTimePicker(oComp);
                    oDFx.Kind    := dtkTime;
                    if oFDQuery.Fields[iFieldId].IsNull then begin
                        oDFx.Time    := StrToTime('00:00:00');
                    end else begin
                        oDFx.Time    := oFDQuery.Fields[iFieldId].AsDateTime;
                    end;

                end else if joField.type = 'tree' then begin            //----- 19 -----
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;
                end else if joField.type = 'treepair' then begin        //----- 20 -----
                    oEFx        := TEdit(oComp);
                    joList      := deGetTreeListJson(joField.list);
                    oEFx.Text   := deGetTreeListView(joList,sValue);
                end else begin
                    oEFx        := TEdit(oComp);
                    oEFx.Text   := sValue;

                end;

                //设置只读（编辑时只读，新增时可编辑）
                if joField.type <> 'auto' then begin
                    if joField.readonly = 1 then begin
                        TEdit(oComp).Enabled    := False;
                    end;
                end;
            end;
        end;
    except
        dwRunJS('console.log("error when deUpdateView");',TForm(APanel.Owner));
    end;
end;

procedure deUpdate(APanel:TPanel;const AWhere:String = '';const AInited:Boolean=True);
var
    iField      : Integer;
    iFieldId    : Integer;
    iItem       : Integer;
    iList       : Integer;
    iSlave      : Integer;
    iTemp       : Integer;

    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    sText       : String;
    sTmp        : String;
    sValue      : String;

    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    joMaster    : variant;
    joStyleName : Variant;
    joList      : Variant;
    joSlave     : Variant;
    joSConfig   : variant;
    //
    oForm       : TForm;
    oFDQuery    : TFDQuery;
    oTbP        : TTrackBar;
    oEKw        : TEdit;
    oFQy        : TFlowPanel;
    oPQF        : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCBQy       : TComboBox;
    oBFz        : TButton;
    oBQy        : TButton;
    oMasterPanel: TPanel;
    oFQMaster   : TFDQuery;
    oSlavePanel : TPanel;
    oPQm        : TPanel;
    oComp       : TComponent;
    oEFx        : TEdit;
    oMFx        : TMemo;
    oIFx        : TImage;
    oBFx        : TButton;
    oDFx        : TDateTimePicker;
    oCFx        : TComboBox;
    oPIn        : TPanel;
    //
    sPrefix     : String;
	bAccept		: boolean;
    oClick      : Procedure(Sender:TObject) of Object;

begin
    try
        //取得JSON配置
        joConfig    := deGetConfig(APanel);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得Form备用
        oForm       := TForm(APanel.Owner);

        //取得字段名称列表，备用，返回值为sFields, 如：id,Name,age
        sFields     := deGetFields(joConfig.fields,False);

        //取得各控件备用
        oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));    //主表数据库
        oEKw        := TEdit(oForm.FindComponent(sPrefix+'EKw'));           //查询关键字
        oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));       //主表分页
        oBFz        := TButton(oForm.FindComponent(sPrefix+'BFz'));         //模糊/精确匹配 切换按钮
        oBQy        := TButton(oForm.FindComponent(sPrefix+'BQy'));         //查询按钮
        oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));      //分字段查询字段的流式布局容器面板

        // deUpdateEnter 事件
        if AInited then begin
            bAccept := True;
            if Assigned(APanel.OnDragOver) then begin
                if oFDQuery.IsEmpty then begin
                    APanel.OnDragOver(APanel,nil,deUpdateEnter,-1,dsDragEnter,bAccept);
                end else begin
                    APanel.OnDragOver(APanel,nil,deUpdateEnter,oFDQuery.RecNo,dsDragEnter,bAccept);
                end;
                if not bAccept then begin
                    Exit;
                end;
            end;
        end;


        //数据库类型
        if not joConfig.Exists('database') then begin
            joConfig.database   := lowerCase(oFDQuery.Connection.DriverName); //'access';
            APanel.Hint	        := joConfig;
        end;

        //取得WHERE, 区分“智能模糊查询”和“分字段查询”2种情况
        //结果类似:  WHERE ((model like '%ljt%') and (name like '%west%'))
        if ( oFQy <> nil ) and (oFQy.Visible) then begin    //oFQy为多字段查询框的容器FlowPanel Query
            //初始化查询 WHERE 字符串
            if joConfig.where = '' then begin
                sWhere  := 'WHERE ((1=1) AND ';
            end else begin
                sWhere  := 'WHERE (('+joConfig.where+') AND ';
            end;

            //逐个字段处理
            if oFQy.Visible AND (oBQy.Tag = 1) then begin
                for iItem := 0 to oFQy.ControlCount-1 do begin
                    //得到每个字段的面板 PQF - panel query field
                    oPQF := TPanel(oFQy.Controls[iItem]);

                    //取得字段序号
                    iField      := oPQF.Tag;

                    //如果 <0, 则表示为按钮组，跳出
                    if iField < 0 then begin
                        break
                    end;

                    //取得当前字段对象
                    joField     := joConfig.fields._(iField);
                    if joField.Exists('type') then begin
                        sType   := joField.type;
                    end else begin
                        sType   := 'string';
                    end;

                    //根据字段类型分类处理
                    //------------------ 7  deUpdate -----------------------------------------------------------------------
                    if sType = 'auto' then begin                     //----- 1 -----
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊生成不同的WHERE
                            if oBFz.Tag = 0 then begin
                                //模糊查询
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                //精确查询
                                if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'boolean' then begin         //----- 2 -----
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            //
                            if oCBQy.Text = joField.list._(0) then begin
                                sWhere  := sWhere + '('+joField.name +' = 0 ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = 1  ) AND ';
                            end;
                        end;

                    end else if sType = 'button' then begin          //----- 3 -----

                    end else if (sType = 'combo') then begin         //----- 4 -----
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCBQy.Text)+''' ) AND ';
                        end;

                    end else if (sType = 'combopair') then begin     //----- 5 -----
                        //得到字段控件
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            //根据字段的list取到对应的值
                            sText   := '';
                            for iList := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iList)._(1) = oCBQy.Text then begin
                                    sText   := joField.list._(iList)._(0);
                                    break;
                                end;
                            end;

                            //
                            if sText <> '' then begin
                                if TFieldType(joField.datatype) in destInteger then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(sText,0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in destFloat then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(sText,0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+sText+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'date' then begin            //----- 6 -----
                        //取得起始结束日期控件
                        oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
                        oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);
                        //转为字符串以方便后面生成WHERE
                        sStart  := FormatDateTime('YYYY-MM-DD',oDT_Start.Date);
                        sEnd    := FormatDateTime('YYYY-MM-DD',oDT_End.Date+1);  //+1 以避免查询不到当天的bug
                        //根据不同数据库，生成不同的SQL
                        if lowercase(joConfig.database) = 'msacc' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' >= #'+sStart+'# )'+
                                        ' AND '+
                                        '('+joField.name +' < #'+sEnd+'# )'+
                                    ') AND ';
                        end else if lowercase(joConfig.database) = 'oracle' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '(to_char('+joField.name +',''YYYY-MM-DD'') >= '''+sStart+''' )'+
                                        ' AND '+
                                        '(to_char('+joField.name +',''YYYY-MM-DD'') < '''+sEnd+''' )'+
                                    ') AND ';
                        end else begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' >= '''+sStart+''' )'+
                                        ' AND '+
                                        '('+joField.name +' < '''+sEnd+''' )'+
                                    ') AND ';
                        end;

                    end else if sType = 'datetime' then begin        //----- 7 -----
                        oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]));
                        if oDT_Start.HelpContext = 1 then begin //起始时间
                            sStart  := FormatDateTime('YYYY-MM-DD hh:mm:ss',oDT_Start.DateTime);
                            if lowercase(joConfig.database) = 'msacc' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' >= #'+sStart+'# )'+
                                        ') AND ';
                            end else if lowercase(joConfig.database) = 'oracle' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '(to_char('+joField.name +',''YYYY-MM-DD hh:mm:ss'') >= '''+sStart+''' )'+
                                        ') AND ';
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' >= '''+sStart+''' )'+
                                        ') AND ';
                            end;
                        end;
                        if oDT_Start.HelpContext = -1 then begin //结束时间
                            sEnd    := FormatDateTime('YYYY-MM-DD hh:mm:ss',oDT_Start.DateTime);
                            if lowercase(joConfig.database) = 'msacc' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' <= #'+sEnd+'# )'+
                                        ') AND ';
                            end else if lowercase(joConfig.database) = 'oracle' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '(to_char('+joField.name +',''YYYY-MM-DD hh:mm:ss'') <= '''+sEnd+''' )'+
                                        ') AND ';
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' <= '''+sEnd+''' )'+
                                        ') AND ';
                            end;
                        end;

                    end else if (sType = 'dbcombo') then begin       //----- 8 -----
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            //
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCBQy.Text)+'%'' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCBQy.Text)+''' ) AND ';
                            end;
                        end;

                    end else if (sType = 'dbcombopair') then begin   //----- 9 -----
                        //得到字段控件
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            //根据字段的list取到对应的值
                            sText   := '';
                            for iList := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iList)._(1) = oCBQy.Text then begin
                                    sText   := joField.list._(iList)._(0);
                                    break;
                                end;
                            end;

                            //
                            if sText <> '' then begin
                                if TFieldType(joField.datatype) in destInteger then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(sText,0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in destFloat then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(sText,0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+sText+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'dbtree' then begin          //----- 10 -----
                        //取得当前查询框的值
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        //仅非空时查询
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊分别查询
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                            end;
                        end;

                    end else if sType = 'dbtreepair' then begin      //----- 11 -----
                        //取得当前查询框的值
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        //仅非空时查询
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊分别查询
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                            end;
                        end;

                    end else if sType = 'float' then begin           //----- 12 -----

                    end else if sType = 'image' then begin           //----- 13 -----
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        if Trim(oE_Query.Text) <> '' then begin
                            //
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'index' then begin           //----- 13A -----

                    end else if sType = 'integer' then begin         //----- 14 -----
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊生成不同的WHERE
                            if oBFz.Tag = 0 then begin
                                //模糊查询
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                //精确查询
                                if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if (sType = 'linkage') then begin       //-----------
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            //
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCBQy.Text)+'%'' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCBQy.Text)+''' ) AND ';
                            end;
                        end;

                    end else if (sType = 'linkagepair') then begin   //-----------
                        //得到字段控件
                        oCBQy   := TComboBox(oPQF.Controls[1]);
                        if Trim(oCBQy.Text) <> '' then begin
                            //根据字段的list取到对应的值
                            sText   := '';
                            for iList := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iList)._(1) = oCBQy.Text then begin
                                    sText   := joField.list._(iList)._(0);
                                    break;
                                end;
                            end;

                            //
                            if sText <> '' then begin
                                if TFieldType(joField.datatype) in destInteger then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(sText,0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in destFloat then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(sText,0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+sText+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'memo' then begin            //----- 15 -----
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊生成不同的WHERE
                            if oBFz.Tag = 0 then begin
                                //模糊查询
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                //精确查询
                                if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'money' then begin           //----- 16 -----

                    end else if sType = 'string' then begin          //----- 17 -----
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊生成不同的WHERE
                            if oBFz.Tag = 0 then begin
                                //模糊查询
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                //精确查询
                                if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                                end;
                            end;
                        end;

                    end else if sType = 'time' then begin            //----- 18 -----

                    end else if sType = 'tree' then begin            //----- 19 -----
                        //取得当前查询框的值
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        //仅非空时查询
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊分别查询
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                            end;
                        end;
                    end else if sType = 'treepair' then begin        //----- 20 -----
                        //取得当前查询框的值
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        //仅非空时查询
                        if Trim(oE_Query.Text) <> '' then begin
                            //根据是否模糊分别查询
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                            end;
                        end;

                    end else begin
                        oE_Query    := TEdit(oPQF.Controls[1]);
                        if Trim(oE_Query.Text) <> '' then begin
                            //
                            if oBFz.Tag = 0 then begin
                                sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                            end else begin
                                if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                    sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) AND ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                                end;
                            end;
                        end;

                    end;
                end;
            end;
            //删除最后的 ' AND '
            sWhere  := Copy(sWhere,1,Length(sWhere)-4);

            //
            sWhere  := sWhere + ')';
        end else begin
            //从智能模糊查询框的关键字中生成查询字符串
            //返回值为 ' WHERE (1=1) ' 或
            //         ' WHERE ((....) oR (...))'
            sWhere  := deGetWhere(joConfig.fields, oEKw.Text);

            //添加原配置JSON中自带的where
            if joConfig.where <> '' then begin
                Delete(sWhere,1,Length(' WHERE'));
                sWhere  := ' WHERE (('+joConfig.where+') and ' + sWhere+')';
            end;
        end;

        //AWhere 额外的 WHERE 条件(从外部调用dwUpdateMain函数)
        if AWhere <> '' then begin
            sWhere  := sWhere + ' AND ('+AWhere+')';
        end;

        //如果当前表有它的主表，则增加当前表与主表关联的字段的where部分
        if joConfig.Exists('master') then begin
            joMaster    := joConfig.master;
            if joMaster.Exists('panel') and joMaster.Exists('masterfield') and joMaster.Exists('slavefield') then begin
                //取得从表panel
                oMasterPanel := TPanel(oForm.FindComponent(joMaster.panel));

                //更新从表
                if oMasterPanel <> nil then begin
                    //取得主表查询
                    oFQMaster   := deGetFDQuery(oMasterPanel);

                    //
                    if oFQMaster <> nil then begin
                        if oFQMaster.IsEmpty then begin
                            sWhere  := sWhere + ' AND (1=0)';
                        end else begin
                            //根据主表更新从表
                            if (oFQMaster.FieldByName(String(joMaster.masterfield)).DataType in destInteger) then begin
                                sWhere  := sWhere + ' AND ('+String(joMaster.slavefield)+'='
                                        +IntToStr(oFQMaster.FieldByName(String(joMaster.masterfield)).AsInteger)+')';
                            end else begin
                                sWhere  := sWhere + ' AND ('+String(joMaster.slavefield)+'="'
                                        +oFQMaster.FieldByName(String(joMaster.masterfield)).AsString+'")';
                            end;
                        end;
                    end;
                end;
            end;
        end;


        //增加处理额外的where信息, 保存在PQm的hint中
        sTmp    := Trim(deGetExtraWhere(APanel));
        if sTmp <> '' then begin
            sWhere  := sWhere + ' and ('+sTmp+')';
        end;


        //取当前页数据
        oFDQuery.Close;
        if dwGetStr(joConfig,'defaultorder') = '' then begin
            oFDQuery.SQL.Text := 'SELECT '+ sFields+' FROM '+joConfig.table+' '+sWhere;
        end else begin
            oFDQuery.SQL.Text := 'SELECT '+ sFields+' FROM '+joConfig.table+' '+sWhere+' ORDER BY '+joConfig.defaultorder;
        end;
        oFDQuery.FetchOptions.RecsSkip    := 0;
        oFDQuery.FetchOptions.RecsMax     := -1;
        oFDQuery.Open;

        //更新分页
        if oTbP <> nil then begin
            oTbP.Max        := oFDQuery.RecordCount;
            oTbP.Position   := 0;
        end;

        //
        deUpdateView(APanel);

        // deDataScroll 事件
        if AInited then begin
            bAccept := True;
            if Assigned(APanel.OnDragOver) then begin
                if oFDQuery.IsEmpty then begin
                    APanel.OnDragOver(APanel,nil,deDataScroll,-1,dsDragEnter,bAccept);
                end else begin
                    APanel.OnDragOver(APanel,nil,deDataScroll,oFDQuery.RecNo,dsDragEnter,bAccept);
                end;
                if not bAccept then begin
                    Exit;
                end;
            end;
        end;

        //更新可能存在的从表
        if joConfig.Exists('slave') then begin
            for iSlave := 0 to joConfig.slave._Count - 1 do begin
                joSlave := joConfig.slave._(iSlave);
                if joSlave.Exists('panel') and joSlave.Exists('masterfield') and joSlave.Exists('slavefield') then begin
                    //取得从表panel
                    oSlavePanel := TPanel(oForm.FindComponent(joSlave.panel));

                    //更新从表
                    if oSlavePanel <> nil then begin
                        //如果从表是DBCard, 则用DBCard的外置更新方法更新数据
                        if oSlavePanel.HelpContext = 31028 then begin
                            //取从表的配置JSON
                            joSConfig   := _json(oSlavePanel.Hint);
                            //取从表的前缀
                            sPrefix     := dwGetStr(joSConfig,'prefix');
                            //取从表的PQm : panel query smart
                            oPQm        := TPanel(oForm.FindComponent(sPrefix+'PQm'));
                            //
                            if oPQm <> nil then begin
                                //设置 where , 通过 pqm 的caption
                                if oFDQuery.IsEmpty then begin
                                    sWhere  := '1=0';
                                end else begin
                                    //根据是否为整型分别生成where字符串
                                    if (oFDQuery.FieldByName(String(joSlave.masterfield)).DataType in destInteger) then begin
                                        sWhere  := String(joSlave.slavefield)+'='+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString;
                                    end else begin
                                        sWhere  := String(joSlave.slavefield)+'="'+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString+'"';
                                    end;
                                end;

                                //用DBCard的外置更新方法更新数据
                                oPQm.Caption    := sWhere;
                                oPQm.OnUnDock(oPQm,nil,nil,bAccept);
                            end;
                        end else begin
                            if oFDQuery.IsEmpty then begin
                                deUpdate(oSlavePanel,'1=0');
                            end else begin
                                //根据是否为整型分别生成where字符串
                                if (oFDQuery.FieldByName(String(joSlave.masterfield)).DataType in destInteger) then begin
                                    deUpdate(oSlavePanel,String(joSlave.slavefield)+'='+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString);
                                end else begin
                                    deUpdate(oSlavePanel,String(joSlave.slavefield)+'="'+oFDQuery.FieldByName(String(joSlave.masterfield)).AsString+'"');
                                end;
                            end;
                        end;
                    end;

                end;
            end;
        end;
    except

    end;

    // deUpdateAfter 事件
    if AInited then begin
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            if oFDQuery.IsEmpty then begin
                APanel.OnDragOver(APanel,nil,deUpdateAfter,-1,dsDragEnter,bAccept);
            end else begin
                APanel.OnDragOver(APanel,nil,deUpdateAfter,oFDQuery.RecNo,dsDragEnter,bAccept);
            end;
            if not bAccept then begin
                Exit;
            end;
        end;
    end;
end;


function deInit(APanel:TPanel;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwGetEditMask  = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
    TdwEndDock      = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    joConfig    : variant;
    //
    sFields     : String;
    sPrefix     : String;
    sText       : string;
    sValue      : String;
    //
    oForm       : TForm;
    oBtnMargins : TMargins;
    oPQy        : TPanel;       //分字段查询面板 : PQy
    oFQy        : TFlowPanel;   //用于多字段查询的流式布局面板
    oPQF        : TPanel;       //单独字段查询面板 : PQ0, PQ1,...
    oPQm        : TPanel;       //智能模糊查询面板 : PQm
    oPBs        : TPanel;       //功能按钮面板 : PBs
    oBQm        : TButton;      //切换查询模式的按钮 ： BQm
    oBFz        : TButton;      //切换查询模式的按钮 ： BFz 模糊/精确
    oBQy        : TButton;      //查询按钮
    oBQR        : TButton;      //重置按钮
    oBHd        : TButton;      //隐藏按钮
    //
    oBNw        : TButton;      //new
    oBDe        : TButton;      //delete
    oBSa        : TButton;      //save
    oBCc        : TButton;      //cancel
    //
    oEKw        : TEdit;
    oTbP        : TTrackBar;

    //
    oFFd        : TFlowPanel;
    oPFd        : TPanel;
    oLFx        : TLabel;
    oEFx        : TEdit;
    oMFx        : TMemo;
    oIFx        : TImage;
    oBFx        : TButton;
    oDFx        : TDateTimePicker;
    oCFx        : TComboBox;
    oPIn        : TPanel;


    //
    oFQMain     : TFDQuery;     //主查询表
    oFQTemp     : TFDQuery;     //用于生成combo的临时性FDQuery
    oFieldType  : TFieldType;

    //
    iDec        : Integer;
    iField      : Integer;
    iCount      : Integer;
    iCol        : Integer;
    iList       : Integer;
    iMode       : Byte;         //字段的模式，0：正常（默认），1：表格中不显示，新增/编辑时显示；2：仅FDQuery读取， 表格/新增/编辑均不显示
    iFieldId    : Integer;      //每个字段JSON对应的数据表字段index
    iItem       : Integer;
    //
    joField     : variant;
    joHint      : variant;
    joCell      : variant;
    joPair      : Variant;
    joList      : Variant;
    joSGHint    : Variant;
    //可能存在的通过AReserved传递的权限字符串, '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
    //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用;
    //3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
    joRights    : Variant;
    //
    tM,tM1,tM2  : TMethod;      //用于指定事件
	bAccept		: boolean;
    bVisibleOld : boolean;      //用于记录当前panel的可见性. 因为中间需要临时隐藏, 以提高创建控件速度

    {$IFDEF TIME}
        //测试时间的变量
        t0,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10,t11 : Integer;
        t40,t41,t42,t43,t44,t45,t46,t47,t48,t49 : Integer;
    {$ENDIF}


    procedure deSetCaption(ALabel:TLabel);
    begin
        with ALabel do begin
            if joField.must = 1 then begin
                Caption     := '* '+joField.caption;
            end else begin
                Caption     := joField.caption;
            end;
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


    //默认返回值
    Result  := 0;

    {$IFDEF TIME}
        t0  := GetTickCount;
    {$ENDIF}



    try
        bVisibleOld     := APanel.Visible;
        APanel.Visible  := False;

        try
            //为当前Panel赋一个特殊的数值，以方便各控件查找到该panel控件
            APanel.HelpContext  := 250629;

            //取得form备用
            oForm   := TForm(APanel.Owner);

            //先检查，防止重复创建
            oFQMain       := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
            if oFQMain <> nil then begin
                Result  := -200;
                dwMessage('Error when DBEditor : '+IntToStr(Result),'error',oForm);
                Exit;
            end;

            //取得配置json
            joConfig    := deGetConfig(APanel);

            //如果AReserved中有通过gsRights传递的权限字符串, 则自动设置
            //通过AReserved传递的权限字符串, 形如:["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1],为JSON数组的字符串,
            //0元素为字符串型,模块名称; 1~5个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
            joRights    := _json(AReserved);
            if joRights <> unassigned then begin
                if joRights._kind = 2 then begin
                    if joRights._Count > 7 then begin
                        if joConfig.new = 1 then begin
                            joConfig.new    := Integer(joRights._(3));  //增加
                        end;
                        if joConfig.delete = 1 then begin
                            joConfig.delete := Integer(joRights._(4));  //删除
                        end;
                        if joConfig.edit = 1 then begin
                            joConfig.edit   := Integer(joRights._(5));  //编辑
                        end;
                        if joRights._(6) <> 1 then begin            //查询
                            joConfig.defaultquerymode   := 0;
                            joConfig.switch             := 0;
                        end;
                        joConfig.export := Integer(joRights._(7));  //导出
                        joConfig.import := Integer(joRights._(8));  //导入

                        //回写到Hint中, 以下次读取时也有效
                        APanel.Hint := joConfig;
                    end;
                end;
            end;

            //取得前缀备用,默认为空
            sPrefix     := dwGetStr(joConfig,'prefix','');

            //如果不是JSON格式，则退出
            if joConfig = unassigned then begin
                Result  := -201;
                dwMessage('Error when DBEditor : '+IntToStr(Result),'error',oForm);
                Exit;
            end;

            //生成一个主查询
            oFQMain             := TFDQuery.Create(APanel);
            oFQMain.Name        := sPrefix + 'FQMain';
            oFQMain.Connection  := AConnection;
            oFQMain.FetchOptions.Mode   := fmAll;

            //得到字段名列表
            sFields := deGetFields(joConfig.fields,False);

            //打开表
            oFQTemp       := TFDQuery(APanel.FindComponent(sPrefix+'FQTemp'));

            //生成一个临时查询
            if oFQTemp = nil then begin
                oFQTemp               := TFDQuery.Create(APanel);
                oFQTemp.Name          := sPrefix+'FQTemp';
                oFQTemp.Connection    := AConnection;
                oFQTemp.FetchOptions.Mode   := fmAll;
            end;

            //<如果没有定义字段，则自动生成全部字段
            if sFields = '' then begin
                //
                oFQTemp.Disconnect;
                oFQTemp.Close;
                oFQTemp.SQL.Text  := 'SELECT * FROM ' + joConfig.table + ' WHERE 1=0'; // 打开一个空查询
                oFQTemp.Open;

                //先清空原字段数组
                joConfig.fields := _json('[]');

                //根据每个字段的DataType自动进行配置
                for iField := 0 to oFQTemp.Fields.Count - 1 do begin
                    //取得
                    oFieldType  := oFQTemp.Fields[iField].DataType;

                    joField := _json('{}');

                    //字段名
                    joField.name := oFQTemp.Fields[iField].FieldName;

                    //8排序
                    joField.sort        := 1;

                    if oFieldType in [ftAutoInc] then begin     //自增类型
                        //宽度
                        joField.width       := '80';

                        //3类型
                        joField.type        := 'auto';

                        //11对齐
                        joField.align       := 'center';

                    end else if (oFieldType in [ftBoolean]) then begin  //布尔型
                        //宽度
                        joField.width       := '120';

                        //3类型
                        joField.type        := 'boolean';

                        //11对齐
                        joField.align       := 'center';

                        //自动筛选
                        joField.dbfilter    := 1;

                    end else if (oFieldType in destInteger) or (oFieldType in destFloat) then begin
                        //宽度
                        joField.width       := '120';

                        //3类型
                        joField.type        := 'integer';

                        //11对齐
                        joField.align       := 'right';

                    end else if (oFieldType in [ftDate, ftTime, ftDateTime,ftTimeStamp,ftOraTimeStamp,ftTimeStampOffset])  then begin
                        //宽度
                        joField.width       := '120';

                        //3类型
                        joField.type        := 'date';

                        //11对齐
                        joField.align       := 'center';
                    end else begin
                        //宽度
                        joField.width       := '150';

                        //3类型
                        joField.type        := 'string';

                        //8排序
                        joField.query       := 1;

                        //自动筛选
                        joField.dbfilter    := 1;
                    end;

                    //
                    joConfig.fields.Add(joField);
                end;


                //反写回
                APanel.Hint := joConfig;

                //重新读取，取得配置json
                joConfig    := deGetConfig(APanel);

                //重新得到字段名列表
                sFields := deGetFields(joConfig.fields,False);
            end;
            //>
        except
            //异常时调试使用
            Result  := -1;
        end;

        {$IFDEF TIME}
            t1  := GetTickCount;
        {$ENDIF}

        // 打开一个空查询, 为各字段赋 datatype
        if Result = 0 then begin
            try

                oFQTemp.Close;
                oFQTemp.SQL.Text  := 'SELECT ' + sFields + ' FROM ' + joConfig.table + ' WHERE 1=0';

                oFQTemp.Open;
            except
                //异常时调试使用
                Result  := -2;
            end;
        end;

        {$IFDEF TIME}
            t2  := GetTickCount;
        {$ENDIF}


        if Result = 0 then begin
            try

                //设置每个字段的DataType
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    joField := joConfig.fields._(iField);

                    //取得当前JSON字段对应的数据表字段index
                    iFieldId    := dwGetInt(joField,'fieldid',-1);

                    //跳过非数据表列
                    if iFieldId < 0 then begin
                        joField.datatype := ftString;
                        continue;
                    end;

                    //
                    joField.datatype := oFQTemp.Fields[iFieldId].DataType;
                end;
            except
                //异常时调试使用
                Result  := -3;
            end;
        end;

        {$IFDEF TIME}
            t3  := GetTickCount;
        {$ENDIF}


        if Result = 0 then begin
            try

                //添加dbxxxx类型和boolean的list
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    joField := joConfig.fields._(iField);

                    //
                    if joField.type = 'boolean' then begin              //--------------------
                        //
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                            joField.list.Add('false');
                            joField.list.Add('true');
                        end;

                    end else if joField.type = 'dbcombo' then begin     //--------------------
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                        end;
                        //
                        if not joField.Exists('table') then begin
                            joField.table := joConfig.table	;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            joField.datafield := joField.name;
                        end;
                        //
                        oFQTemp.FetchOptions.RecsSkip    := 0;
                        oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'listcount',50);
                        oFQTemp.Close;
                        if dwGetStr(joField,'listorder','')='' then begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+' FROM '+joField.table;
                        end else begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+' FROM '+joField.table+' ORDER By '+joField.listorder;
                        end;
                        oFQTemp.Open;

                        //
                        while not oFQTemp.Eof do begin
                            //
                            joField.list.Add(oFQTemp.Fields[0].AsString);
                            //
                            oFQTemp.Next;
                        end;

                    end else if joField.type = 'dbcombopair' then begin //--------------------
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                        end;
                        //
                        if not joField.Exists('table') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('viewfield') then begin
                            continue;
                        end;
                        //
                        oFQTemp.FetchOptions.RecsSkip    := 0;
                        oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'listcount',50);
                        oFQTemp.Close;
                        if dwGetStr(joField,'listorder','')='' then begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+','+joField.viewfield+' FROM '+joField.table;
                        end else begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+','+joField.viewfield+' FROM '+joField.table+' ORDER By '+joField.listorder;
                        end;
                        oFQTemp.Open;

                        //
                        while not oFQTemp.Eof do begin
                            joPair  := _json('[]');
                            joPair.Add(oFQTemp.Fields[0].AsString);
                            joPair.Add(oFQTemp.Fields[1].AsString);
                            //
                            joField.list.Add(joPair);
                            //
                            oFQTemp.Next;
                        end;
                    end else if joField.type = 'dbtree' then begin      //--------------------
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                        end;

                        //
                        if not joField.Exists('table') then begin
                            joField.table := joConfig.table;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;

                        //创建树形字段的选项，参数分别为：查询控件、表名、数据存储字段、数据显示字段
                        joField.list    := deDBToTreeList(
                                oFQTemp,
                                joField.table,
                                joField.datafield,
                                joField.datafield,
                                dwGetStr(joField,'listlink',' - '),
                                dwGetInt(joField,'listcount',50));

                        joField.treelist    := deDBToTreeList(
                                oFQTemp,
                                joField.table,
                                joField.datafield,
                                joField.datafield,
                                '',
                                dwGetInt(joField,'listcount',50));
                    end else if joField.type = 'dbtreepair' then begin      //--------------------
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                        end;

                        //
                        if not joField.Exists('table') then begin
                            joField.table := joConfig.table;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('viewfield') then begin
                            continue;
                        end;

                        //创建树形字段的选项，参数分别为：查询控件、表名、数据存储字段、数据显示字段
                        joField.list    := deDBToTreeList(oFQTemp,joField.table,joField.datafield,joField.viewfield,
                                dwGetStr(joField,'listlink',' - '),    //连接字符串
                                dwGetInt(joField,'listcount',50));
                        joField.treelist    := deDBToTreeList(oFQTemp,joField.table,joField.datafield,joField.viewfield,
                                '',    //连接字符串,专门设置为空
                                dwGetInt(joField,'listcount',50));


                    end else if joField.type = 'linkage' then begin     //--------------------
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                        end;
                        //
                        if not joField.Exists('table') then begin
                            joField.table := joConfig.table	;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            joField.datafield := joField.name;
                        end;
                        //
                        oFQTemp.FetchOptions.RecsSkip    := 0;
                        oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'listcount',50);
                        oFQTemp.Close;
                        if dwGetStr(joField,'listorder','')='' then begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+' FROM '+joField.table;
                        end else begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+' FROM '+joField.table+' ORDER By '+joField.listorder;
                        end;
                        oFQTemp.Open;

                        //
                        while not oFQTemp.Eof do begin
                            //
                            joField.list.Add(oFQTemp.Fields[0].AsString);
                            //
                            oFQTemp.Next;
                        end;

                    end else if joField.type = 'linkagepair' then begin //--------------------
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                        end;
                        //
                        if not joField.Exists('table') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('viewfield') then begin
                            continue;
                        end;
                        //
                        oFQTemp.FetchOptions.RecsSkip    := 0;
                        oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'listcount',50);
                        oFQTemp.Close;
                        if dwGetStr(joField,'listorder','')='' then begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+','+joField.viewfield+' FROM '+joField.table;
                        end else begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+','+joField.viewfield+' FROM '+joField.table+' ORDER By '+joField.listorder;
                        end;
                        oFQTemp.Open;

                        //
                        while not oFQTemp.Eof do begin
                            joPair  := _json('[]');
                            joPair.Add(oFQTemp.Fields[0].AsString);
                            joPair.Add(oFQTemp.Fields[1].AsString);
                            //
                            joField.list.Add(joPair);
                            //
                            oFQTemp.Next;
                        end;
                    end;

                    //如果设置了数据表自动筛选
                    if dwGetInt(joField,'dbfilter',0)=1 then begin
                        //排除一些不能自动筛选的类型
                        if TFieldType(joField.datatype) in [ftMemo] then begin
                            joField.dbfilter := 0;
                        end else begin
                            //
                            oFQTemp.FetchOptions.RecsSkip    := 0;
                            oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'filtercount',50);
                            oFQTemp.Close;
                            if dwGetStr(joConfig,'where','')='' then begin
                                oFQTemp.SQL.Text := 'SELECT Distinct '+joField.name+' FROM '+joConfig.table;
                            end else begin
                                oFQTemp.SQL.Text := 'SELECT Distinct '+joField.name+' FROM '+joConfig.table+' WHERE '+dwGetStr(joConfig,'where');
                            end;
                            oFQTemp.Open;

                            //
                            joField.filterlist  := _json('[]');

                            //根据类型设置筛选项,分xxxpair和非pair
                            if          joField.type = 'boolean'      then begin    //----- 2 -----
                                //list类似如下:
                                //"list":["女","男"]

                                //取得list的JSON对象
                                joList  := _json(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    joField.filterlist.Add(joList._(iList));
                                end;

                            end else if joField.type = 'combopair'      then begin  //----- 5 -----
                                //list类似如下:
                                //"list":[
                                //    ["029","西安"],
                                //    ["0271","纽约"],
                                //    ["0971","新奥尔良"]

                                //取得list的JSON对象
                                joList  := _json(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    joField.filterlist.Add(joList._(iList)._(1));
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //默认为字段的值
                                        sText   := '';

                                        //在pair中查找对应值
                                        for iList := 0 to joList._Count -1 do begin
                                            if joList._(iList)._(0) = oFQTemp.Fields[0].AsString then begin
                                                sText   := joList._(iList)._(1);
                                                break;
                                            end;
                                        end;
                                        //
                                        if sText = '' then begin
                                            joField.filterlist.Add(oFQTemp.Fields[0].AsString);
                                        end;
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else if joField.type = 'dbcombopair'    then begin  //----- 9 -----
                                //list类似如下:
                                //"list":[
                                //    ["029","西安"],
                                //    ["0271","纽约"],
                                //    ["0971","新奥尔良"]

                                //取得list的JSON对象
                                joList  := _json(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    joField.filterlist.Add(joList._(iList)._(1));
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //默认为字段的值
                                        sText   := '';

                                        //在pair中查找对应值
                                        for iList := 0 to joList._Count -1 do begin
                                            if joList._(iList)._(0) = oFQTemp.Fields[0].AsString then begin
                                                sText   := joList._(iList)._(1);
                                                break;
                                            end;
                                        end;
                                        //
                                        if sText = '' then begin
                                            joField.filterlist.Add(oFQTemp.Fields[0].AsString);
                                        end;
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else if joField.type = 'dbtreepair'     then begin  //----- 11 -----
                                //list类似如下: [{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]

                                //取得list的JSON对象
                                joList  := deGetTreeListJson(joField.list);

                                //先添加在pair中的值
                                sText   := joField.list;
                                while Pos('label:''',sText) > 0 do begin
                                    Delete(sText,1,Pos('label:''',sText)+6);
                                    sValue  := Copy(sText,1,Pos('''',sText)-1);
                                    joField.filterlist.Add(sValue);
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;

                            end else if joField.type = 'treepair'       then begin  //----- 20 -----
                                //list类似如下: [{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]

                                //取得list的JSON对象
                                joList  := deGetTreeListJson(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    sText   := joField.list;
                                    while Pos('label:''',sText) > 0 do begin
                                        Delete(sText,1,Pos('label:''',sText)+7);
                                        sValue  := Copy(sText,1,Pos('''',sText)-1);
                                        joField.filterlist.Add(sValue);
                                    end;
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else begin
                                while not oFQTemp.Eof do begin
                                    //
                                    joField.filterlist.Add(oFQTemp.Fields[0].AsString);
                                    //
                                    oFQTemp.Next;
                                end;
                            end;
                        end
                    end;

                end;
            except
                //异常时调试使用
                Result  := -4;
            end;
        end;


        {$IFDEF TIME}
            t4  := GetTickCount;
        {$ENDIF}


        if Result = 0 then begin
            try

                {$IFDEF TIME}
                    t40  := GetTickCount;
                {$ENDIF}

                //反写回
                APanel.Hint := joConfig;

                //创建分字段查询的查询列表
                iCount  := 0;
                for iField := 0 to joConfig.fields._Count-1 do begin
                    //取得当前字段JSON对象
                    joField := joConfig.fields._(iField);
                    //如果字段加入分字段查询
                    if joField.query = 1 then begin
                        Inc(iCount);
                    end;
                end;

                {$IFDEF TIME}
                    t41  := GetTickCount;
                {$ENDIF}


                //当默认查询模式不是分段查询, 且禁止模式切换时, 不创建分段查询面板, 以加快速度
                if (dwGetInt(joConfig,'defaultquerymode') <> 2) and (dwGetInt(joConfig,'switch') = 0) then begin
                    iCount  := 0;
                end;

                //分字段查询面板 FQy ===========================================================================================
                if iCount > 0 then begin
                    oFQy   := TFlowPanel.Create(oForm);
                    with oFQy do begin
                        Parent          := APanel;
                        Name            := sPrefix + 'FQy';
                        Align           := alTop;
                        Color           := clNone;
                        AutoSize        := True;
                        AutoWrap        := True;
                        //BorderStyle     := bsSingle;
                        Top             := 1000;
                        Font.Size       := 11;
                        Font.Color      := $646464;
                        Hint            := '{"dwstyle":"overflow:visible;"}';   //显示超出边界的对象，以适应tree系统类型
                        //
                        AlignWithMargins:= True;
                        Margins.Top     := joConfig.margin;
                        Margins.Bottom  := 0;
                        Margins.Left    := joConfig.margin;
                        Margins.Right   := joConfig.margin;
                        //
                        tM.Code         := @FQyResize;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnResize        := TNotifyEvent(tM);
                    end;

                    //创建分字段查询的查询列表
                    iCount  := 0;
                    for iField := 0 to joConfig.fields._Count-1 do begin
                        //取得当前字段JSON对象
                        joField := joConfig.fields._(iField);
                        //如果字段加入分字段查询
                        if joField.query = 1 then begin
                            //
                            deCreateFieldQuery(APanel,joConfig,joField,iField,IntToStr(iCount),oFQy);
                            Inc(iCount);
                        end;
                    end;

                    //创建一个额外的查询面板，用于存放“查询”和“重置”按钮
                    oPQF := TPanel.Create(oForm);
                    with oPQF do begin
                        Parent          := oFQy;
                        Name            := sPrefix + 'PQ'+IntToStr(iCount);
                        Color           := clNone;
                        Width           := 250;
                        Height          := 44;
                        Tag             := -1;
                    end;

                    //添加“查询”和“重置”按钮
                    oBQy  := TButton.Create(oForm);
                    with oBQy do begin
                        Parent          := oPQF;
                        Name            := sPrefix + 'BQy';
                        Align           := alLeft;
                        width           := 70;
                        Height          := 30;
                        Caption         := '查询';
                        Hint            := '{"type":"primary","icon":"el-icon-search"}';
                        //
                        AlignWithMargins:= True;
                        Margins.Top     := 5;
                        Margins.Bottom  := 7;
                        Margins.Left    := 20;
                        Margins.Right   := 5;
                        //
                        tM.Code         := @BQyClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;
                    oBQR  := TButton.Create(oForm);
                    with oBQR do begin
                        Parent          := oPQF;
                        Name            := sPrefix + 'BQR';
                        Align           := alLeft;
                        width           := 70;
                        Height          := 30;
                        Left            := 100;
                        Caption         := '重置';
                        Hint            := '{"icon":"el-icon-refresh"}';
                        //
                        AlignWithMargins:= True;
                        Margins         := oBQy.Margins;
                        Margins.Left    := 0;
                        //
                        tM.Code         := @BRsClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;
                    oBHd  := TButton.Create(oForm);
                    with oBHd do begin
                        Parent          := oPQF;
                        Name            := sPrefix + 'BHd';
                        Align           := alLeft;
                        width           := 70;
                        Height          := 30;
                        Left            := 200;
                        Caption         := '隐藏';
                        Hint            := '{"icon":"el-icon-upload2"}';
                        //
                        AlignWithMargins:= True;
                        Margins         := oBQy.Margins;
                        Margins.Left    := 0;
                        //
                        tM.Code         := @BHdClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;
                    //刷新 FQy 高度
                    oFQy.AutoSize  := True;
                    oFQy.AutoSize  := False;
                end;

                {$IFDEF TIME}
                    t42  := GetTickCount;
                {$ENDIF}


                //智能查询面板 PQm =============================================================================================

                //智能模糊查询框的容器 panel : panel query smart
                oPQm := TPanel.Create(oForm);
                with oPQm do begin
                    Parent          := APanel;
                    Name            := sPrefix + 'PQm';
                    Align           := alTop;
                    Height          := 40;
                    Top             := 0;
                    Color           := clNone;
                    AlignWithMargins:= True;
                    Margins.Top     := joConfig.margin;
                    Margins.Bottom  := 0;
                    Margins.Left    := joConfig.margin;
                    Margins.Right   := joConfig.margin;
                end;

                //智能模糊查询框 EKw : Edit keyword
                oEKw  := TEdit.Create(oForm);
                with oEKw do begin
                    Parent          := oPQm;
                    Name            := sPrefix + 'EKw';
                    Align           := alLeft;
                    width           := 224;     //用于和3个按钮对齐
                    Text            := '';
                    //
                    AlignWithMargins:= True;
                    Margins.Bottom  := 5;
                    Margins.Left    := 0;
                    Margins.Right   := 5;
                    Margins.Top     := 3;
                    Hint            := '{'
                        +'"placeholder":"'+dwGetStr(joConfig,'placeholder','搜索')+'",'
                        +'"dwattr":"clearable",'
                        +'"suffix-icon":"el-icon-search",'
                        +'"dwstyle":"padding-left:10px;'
                    +'"}';
                    //
                    tM.Code         := @EKwChange;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnChange        := TNotifyEvent(tM);
                end;

                {$IFDEF TIME}
                    t43  := GetTickCount;
                {$ENDIF}


                //功能按钮面板 ： PBs : panel buttons ===========================================================================
                oPBs  := TPanel.Create(oForm);
                with oPBs do begin
                    Parent          := APanel;
                    Name            := sPrefix + 'PBs';
                    if dwGetInt(joConfig,'buttonattop') = 1 then begin
                        Align       := alTop;
                    end else begin
                        Align       := alBottom;
                    end;
                    Height          := 45;
                    Top             := 200;
                    Font.Size       := 11;
                    //
                    Color           := clNone;
                    AlignWithMargins:= true;
                    Margins.Top     := 0;
                    Margins.Bottom  := 0;
                    Margins.Left    := 0;
                    Margins.Right   := 0;
                    //
                    Visible         := dwGetInt(joConfig,'buttons',1)<>0;
                end;

                //创建一个通用的TMargins
                oBtnMargins := TMargins.Create(oForm);
                oBtnMargins.Top     := 7;
                oBtnMargins.Bottom  := 6;
                oBtnMargins.Left    := 10;
                oBtnMargins.Right   := 3;


                //保存 BSa : Button save
                oBSa  := TButton.Create(oForm);
                with oBSa do begin
                    Parent          := oPBs;
                    Name            := sPrefix + 'BSa';
                    Align           := alLeft;
                    if joConfig.buttoncaption = 0 then begin
                        Caption     := '';
                        Cancel      := True;
                        width       := 30;
                    end else begin
                        Caption     := '保存';
                        width       := 70;
                    end;
                    //
                    AlignWithMargins:= True;
                    Margins         := oBtnMargins;
                    Hint            := '{"type":"primary","icon":"el-icon-circle-check"}';
                    //
                    tM.Code         := @ButtonSaveClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                    //
                    Visible         := dwGetInt(joConfig,'edit',1) = 1;
                end;

                //取消 BCc : Button cancel
                oBCc  := TButton.Create(oForm);
                with oBCc do begin
                    Parent          := oPBs;
                    Name            := sPrefix + 'BCc';
                    Align           := alLeft;
                    if joConfig.buttoncaption = 0 then begin
                        Caption     := '';
                        Cancel      := True;
                        width       := 30;
                    end else begin
                        Caption     := '取消';
                        width       := 70;
                    end;
                    //
                    AlignWithMargins:= True;
                    Margins         := oBtnMargins;
                    Hint            := '{"type":"info","icon":"el-icon-refresh-left"}';
                    //
                    tM.Code         := @ButtonCancelClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                    //
                    Visible         := dwGetInt(joConfig,'export',1) = 1;
                end;

                //新增 BNw : Button New
                oBNw  := TButton.Create(oForm);
                with oBNw do begin
                    Parent          := oPBs;
                    Name            := sPrefix + 'BNw';
                    Align           := alLeft;
                    if joConfig.buttoncaption = 0 then begin
                        Caption     := '';
                        Cancel      := True;
                        width       := 30;
                    end else begin
                        Caption     := '新增';
                        width       := 70;
                    end;
                    //
                    AlignWithMargins:= True;
                    Margins         := oBtnMargins;
                    Hint            := '{"type":"success","icon":"el-icon-circle-plus-outline"}';
                    //
                    tM.Code         := @BNwClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                    //
                    Visible         := dwGetInt(joConfig,'new',1) = 1;
                end ;

                //删除 BDe : Button delete
                oBDe  := TButton.Create(oForm);
                with oBDe do begin
                    Parent          := oPBs;
                    Name            := sPrefix + 'BDe';
                    Align           := alLeft;
                    if joConfig.buttoncaption = 0 then begin
                        Caption     := '';
                        Cancel      := True;
                        width       := 30;
                    end else begin
                        Caption     := '删除';
                        width       := 70;
                    end;
                    //
                    AlignWithMargins:= True;
                    Margins         := oBtnMargins;
                    Hint            := '{"type":"danger","icon":"el-icon-delete"}';
                    //
                    tM.Code         := @BDeClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                    //
                    Visible         := dwGetInt(joConfig,'delete',1) = 1;
                end;

                //查询模式：智能模糊 / 多字段
                oBQm  := TButton.Create(oForm);
                with oBQm do begin
                    Parent          := oPBs;
                    Name            := sPrefix + 'BQm';
                    Anchors         := [akRight,akTop];
                    if joConfig.buttoncaption = 1 then begin
                        Caption     := '模式';
                        width       := 70;
                    end else begin
                        Caption     := '';
                        Cancel      := True;
                        width       := 30;
                    end;

                    Font.Size       := 11;
                    Font.Color      := $A0A0A0;
                    Hint            := '{"type":"info","icon":"el-icon-sort"}';
                    Align           := alRight;
                    //
                    AlignWithMargins:= True;
                    Margins         := oBtnMargins;
                    //
                    tM.Code         := @BQmClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                    //
                    Visible         := dwGetInt(joConfig,'switch',1) = 1;
                end;


                {$IFDEF TIME}
                    t44  := GetTickCount;
                {$ENDIF}

                //
                oBtnMargins.Free;

                //设置显示默认查询模式 defaultquerymode
                deSetQueryMode(APanel, dwGetInt(joConfig,'defaultquerymode',1),False);

                {$IFDEF TIME}
                    t45  := GetTickCount;
                {$ENDIF}


            except
                //异常时调试使用
                Result  := -5;
            end;
        end;

        {$IFDEF TIME}
            t5  := GetTickCount;
        {$ENDIF}


        if Result = 0 then begin
            try


                //分页       ===============================================================================================
                if joConfig.page > 0 then begin
                    oTbP    := TTrackBar.Create(oForm);
                    with oTbP do begin
                        Parent          := oPBs;
                        Name            := sPrefix + 'TbP';
                        Align           := alRight;
                        HelpKeyword     := 'page';
                        PageSize        := 1;
                        Width           := dwIIFi(joConfig.page=1,200,420);

                        //Hint            := '{"dwattr":"background hide-on-single-page layout=\"prev, pager, next, ->, total\""}';
                        //2025-03-19 (1) 增加了totalfirst设置支持 (2)采用了小图标, 以支持移动端
                        if dwGetInt(joConfig,'totalfirst',0)=1 then begin
                            if joConfig.page = 1 then begin
                                Hint            := '{"dwattr":" :pager-count=5 background layout=\"total, ->, prev, pager, next\""}';
                            end else begin
                                Hint            := '{"dwattr":" background layout=\"total, ->, prev, next\""}';
                            end;
                        end else begin
                            if joConfig.page = 1 then begin
                                Hint            := '{"dwattr":" background layout=\"prev, next, ->, total\""}';
                            end else begin
                                Hint            := '{"dwattr":" :pager-count=5 background layout=\"prev, pager, next, ->, total\""}';
                            end;
                        end;

                        //
                        AlignWithMargins:= True;
                        Margins.Top     := 5;
                        Margins.Bottom  := 0;
                        Margins.Left    := 0;
                        Margins.Right   := 10;
                        //
                        tM.Code         := @TrackbarPageChange;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnChange        := TNotifyEvent(tM);
                    end;
                    //更新页码
                    oTbP.Position    := 0;
                end;
            except
                //异常时调试使用
                Result  := -6;
            end;
        end;

        {$IFDEF TIME}
            t6  := GetTickCount;
        {$ENDIF}


        if Result = 0 then begin
            try

                //显示/隐藏 增删改印按钮
                if (dwGetInt(joConfig,'buttons',1)<>0) and (dwGetInt(joConfig,'new',1)=1) then begin
                    oBNw.Visible    := joConfig.new = 1;
                end;
                if (dwGetInt(joConfig,'buttons',1)<>0) and (dwGetInt(joConfig,'delete',1)=1) then begin
                    oBDe.Visible    := joConfig.delete = 1;
                end;
                if (dwGetInt(joConfig,'buttons',1)<>0) and (dwGetInt(joConfig,'buttons',1)=1) then begin
                    oPBs.Visible    := joConfig.buttons = 1;
                end;

                //
                oFFd        := TFlowPanel.Create(oForm);
                with oFFd do begin
                    Parent      := APanel;
                    Align       := alClient;
                    Name        := sPrefix + 'FFd';
                    //
                    Color       := clNone;
                end;

                //
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    //取得当前字段JSON
                    joField := joConfig.fields._(iField);

                    //跳过其他view
                    if dwGetInt(joField,'view') > 0 then begin
                        Continue;
                    end;

                    //标题默认为field.name
                    if not joField.Exists('caption') then begin
                        joField.caption  := String(joField.name);
                    end;

                    //字段容器Panel
                    oPFd      := TPanel.Create(oForm);
                    with oPFd do begin
                        Name        := sPrefix + 'PFd'+IntToStr(iField);
                        BevelOuter  := bvNone;
                        BorderStyle := bsNone;
                        AutoSize    := False;

                        //
                        if joField.Exists('fullheight') then begin
                            Height      := dwGetInt(joField,'fullheight',42);
                        end else begin
                            Height      := 42;
                        end;
                        //
                        if joField.Exists('fullwidth') then begin
                            Width       := dwGetInt(joField,'fullwidth',360);
                        end else begin
                            Width       := dwGetInt(joConfig,'editwidth',360);
                        end;

                        Color       := clNone;
                        Parent      := oFFd;
                    end;

                    //字段的标签 在容器左边
                    oLFx     := TLabel.Create(oForm);
                    with oLFx do begin
                        Name            := sPrefix + 'LF'+IntToStr(iField);
                        AutoSize        := False;
                        Align           := alLeft;
                        Alignment       := taRightJustify;
                        Width           := dwGetInt(joConfig,'labelwidth',80);
                        AlignWithMargins:= True;
                        Margins.Top     := 4;
                        Margins.Left    := 10;
                        Margins.Right   := 15;
                        Layout          := tlCenter;
                        if dwGetInt(joField,'must',0) = 1 then begin
                            Caption         := '<p><span style="font-size: 20px;position: relative; color: red;top: 6px;">*&nbsp;</span>'+StringReplace(joField.caption,'\n','',[rfReplaceAll])+'</p>';
                        end else begin
                            Caption         := StringReplace(joField.caption,'\n','',[rfReplaceAll]);
                        end;
                        Parent          := oPFd;
                    end;

                    //各字段编辑控件
                    //根据字段类型分类处理
                    //------------------------ 5 deCreateField ---------------------------------------------------------
                    if joField.type = 'auto' then begin                     //----- 1 -----
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Left    := 5;
                            Margins.Right   := 5;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := False;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'boolean' then begin         //----- 2 -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            Style           := csDropDownList;

                            //
                            Hint            := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                            //
                            if joField.Exists('list') then begin
                                joList  := joField.list;
                                //添加选项
                                for iItem := 0 to Min(1,joList._Count-1) do begin
                                    Items.Add(joList._(iItem));
                                end;
                            end else begin
                                Items.Add('False');
                                Items.Add('True');
                            end;
                        end;

                    end else if joField.type = 'button' then begin          //----- 3 -----

                    end else if (joField.type = 'combo') then begin         //----- 4 -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);       //ASuffix = IntToStr(iField)
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //是否只能选择
                            if dwGetInt(joField,'onlylist') = 1 then begin
                                Style       := csDropDownList;
                            end;
                            //
                            Hint        := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                            //
                            if joField.Exists('list') then begin
                                joList  := joField.list;
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

                    end else if (joField.type = 'combopair') then begin     //----- 5 -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //是否只能选择
                            if dwGetInt(joField,'onlylist') = 1 then begin
                                Style       := csDropDownList;
                            end;
                            //
                            Hint            := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                            //
                            //
                            Items.Add('');

                            //添加数据库内的值
                            for iItem := 0 to joField.list._Count-1 do begin
                                Items.Add(joField.list._(iItem)._(1));
                            end;
                        end;

                    end else if joField.type = 'date' then begin            //----- 6 -----
                        oDFx    := TDateTimePicker.Create(oForm);
                        with oDFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'datetime' then begin        //----- 7 -----
                        oDFx    := TDateTimePicker.Create(oForm);
                        with oDFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;

                            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
                            {$IFDEF VER340}
                                ShowHint    := True;
                            {$ELSE}
                                Kind        := dtkDateTime;
                            {$ENDIF}
                            //
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Parent          := oPFd;
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
                            Width           := dwGetInt(joField,'width',100);
                        end;

                    end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Parent          := oPFd;
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //是否只能选择
                            if dwGetInt(joField,'onlylist') = 1 then begin
                                Style       := csDropDownList;
                            end;
                            //
                            Hint            := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            //
                            Items.Add('');

                            //添加数据库内的值
                            for iItem := 0 to joField.list._Count-1 do begin
                                Items.Add(joField.list._(iItem));
                            end;
                        end;

                    end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Parent          := oPFd;
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //是否只能选择
                            if dwGetInt(joField,'onlylist') = 1 then begin
                                Style       := csDropDownList;
                            end;
                            //
                            Hint            := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            //
                            Items.Add('');

                            //添加数据库内的值
                            for iItem := 0 to joField.list._Count-1 do begin
                                Items.Add(joField.list._(iItem)._(1));
                            end;
                        end;

                    end else if joField.type = 'dbtree' then begin          //----- 10 -----
                        //
                        oPFd.Hint    := '{"dwstyle":"overflow:visible;"}';
                        //
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'F'+IntToStr(iField);
                            HelpKeyword     := 'tree';
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 18;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{'
                                +'"options":"'+dwGetStr(joField,'treelist','')+'"'
                                +',"disablebranchnodes":'+IntToStr(dwGetInt(joField,'disablebranchnodes',0))
                                +'}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
                        //
                        oPFd.Hint    := '{"dwstyle":"overflow:visible;"}';
                        //
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            HelpKeyword     := 'tree';
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 18;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{'
                                +'"options":"'+dwGetStr(joField,'treelist','')+'"'
                                +',"disablebranchnodes":'+IntToStr(dwGetInt(joField,'disablebranchnodes',0))
                                +'}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'float' then begin           //----- 12 -----
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '0.00';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            if joField.Exists('min') then begin
                                if joField.Exists('max') then begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        ' min=\"'+IntToStr(joField.min)+'\"'+
                                                        ' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';
                                end else begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        ' min=\"'+IntToStr(joField.min)+'\"'+
                                                        //' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';

                                end;
                            end else begin
                                if joField.Exists('max') then begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        //' min=\"'+IntToStr(joField.min)+'\"'+
                                                        ' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';

                                end else begin

                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        //' min=\"'+IntToStr(joField.min)+'\"'+
                                                        //' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';
                                end;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'image' then begin           //----- 13 -----
                        oPIn    := TPanel.Create(oForm);
                        with oPIn do begin
                            Name            := sPrefix + 'PI'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            BevelOuter      := bvNone;
                            BorderStyle     := bsNone;
                            AutoSize        := False;
                            Color           := clNone;
                            Hint            := '{"dwstyle":"border:solid 1px rgb(220, 223, 230);border-radius:3px;"}';
                            AlignWithMargins:= True;
                            Margins.Right   := 18;
                            Margins.Bottom  := 5;
                            Margins.Top     := 5;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;
                        //先显示一个图片
                        oIFx := TImage.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF' + IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.left    := 1;
                            Margins.Right   := 1;
                            Margins.Bottom  := 3;
                            Margins.Top     := 1;
                            Width           := 34;
                            //Stretch         := True;
                            //Proportional    := True;
                            Hint            := '{"dwstyle":"border-radius:3px;"}';
                            Parent          := oPIn;
                        end;

                        //添加一个上传按钮
                        oBFx := TButton.Create(oForm);
                        with oBFx do begin
                            Name            := sPrefix + 'FB' + IntToStr(iField);
                            Align           := alRight;
                            AlignWithMargins:= True;
                            Margins.Right   := 3;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Width           := 34;
                            Cancel          := True;
                            Font.Color      := rgb(192, 196, 204);
                            Caption         := '';
                            Hint            := '{'
                                    +'"icon":"el-icon-upload2"'
                                    +',"type":"text"'
                                    +',"name":"'+joField.name+'"'
                                    +',"imgdir":"'+dwGetStr(joField,'imgdir','media/images/temp/')+'"'
                                    +',"imgtype":'+dwGetStr(joField,'imgtype','["jpg","png","bmp","gif"]')
                                    +'}';
                            //
                            tM.Code         := @BUpClick;
                            tM.Data         := Pointer(325); // 随便取的数
                            OnClick         := TNotifyEvent(tM);
                            //
                            tM1.Code        := @BUpEndDock;
                            tM1.Data        := Pointer(325); // 随便取的数
                            OnEndDock       := TdwEndDock(tM1);
                            //
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            Parent          := oPIn;
                        end;

                    end else if joField.type = 'index' then begin           //----- 13A -----
                        //序号列

                    end else if joField.type = 'integer' then begin         //----- 14 -----
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '0.00';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            if joField.Exists('min') then begin
                                if joField.Exists('max') then begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' min=\"'+IntToStr(joField.min)+'\"'+
                                                        ' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';
                                end else begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' min=\"'+IntToStr(joField.min)+'\"'+
                                                        //' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';

                                end;
                            end else begin
                                if joField.Exists('max') then begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        //' min=\"'+IntToStr(joField.min)+'\"'+
                                                        ' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';

                                end else begin

                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        //' min=\"'+IntToStr(joField.min)+'\"'+
                                                        //' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';
                                end;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if (joField.type = 'linkage') then begin         //-----  -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //是否只能选择
                            if dwGetInt(joField,'onlylist') = 1 then begin
                                Style       := csDropDownList;
                            end;
                            //
                            Hint        := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                            //
                            Items.Add('');
                        end;

                    end else if (joField.type = 'linkagepair') then begin         //-----  -----
                        oCFx := TComboBox.Create(oForm);
                        with oCFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //是否只能选择
                            if dwGetInt(joField,'onlylist') = 1 then begin
                                Style       := csDropDownList;
                            end;
                            //
                            Hint            := '{"height":30}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                            //
                            Items.Add('');
                        end;


                    end else if joField.type = 'memo' then begin            //----- 15 -----
                        oMFx := TMemo.Create(oForm);
                        with oMFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{"dwstyle":""}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;

                            //设置高度(仅memo类型)
                            if joField.Exists('height') then begin
                                oPFd.Height   := joField.height;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'money' then begin           //----- 16 -----
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '0.00';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            if joField.Exists('min') then begin
                                if joField.Exists('max') then begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        ' min=\"'+IntToStr(joField.min)+'\"'+
                                                        ' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';
                                end else begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        ' min=\"'+IntToStr(joField.min)+'\"'+
                                                        //' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';

                                end;
                            end else begin
                                if joField.Exists('max') then begin
                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        //' min=\"'+IntToStr(joField.min)+'\"'+
                                                        ' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';

                                end else begin

                                    Hint        := '{'+
                                                    '"dwattr":"'+
                                                        'type=\"number\"'+
                                                        ' step=\"0.01\"'+
                                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                                        //' min=\"'+IntToStr(joField.min)+'\"'+
                                                        //' max=\"'+IntToStr(joField.max)+'\"'+
                                                    '",'+
                                                    ' "dwstyle":""'+
                                                    '}';
                                end;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'string' then begin          //----- 17 -----
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{"dwstyle":""}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'time' then begin            //----- 18 -----
                        oDFx    := TDateTimePicker.Create(oForm);
                        with oDFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            Kind            := dtkTime;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'tree' then begin            //----- 19 -----
                        //
                        oPFd.Hint    := '{"dwstyle":"overflow:visible;"}';
                        //
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            HelpKeyword     := 'tree';
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 18;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{'
                                +'"options":"'+dwGetStr(joField,'list','')+'"'
                                +',"disablebranchnodes":'+IntToStr(dwGetInt(joField,'disablebranchnodes',0))
                                +'}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else if joField.type = 'treepair' then begin        //----- 20 -----
                        //
                        oPFd.Hint    := '{"dwstyle":"overflow:visible;"}';
                        //
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            HelpKeyword     := 'tree';
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 18;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{'
                                +'"options":"'+dwGetStr(joField,'list','')+'"'
                                +',"disablebranchnodes":'+IntToStr(dwGetInt(joField,'disablebranchnodes',0))
                                +'}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end else begin
                        oEFx := TEdit.Create(oForm);
                        with oEFx do begin
                            Name            := sPrefix + 'EF'+IntToStr(iField);
                            if joField.Exists('width') then begin
                                Align           := alLeft;
                            end else begin
                                Align           := alClient;
                            end;
                            //Alignment       := taRightJustify;
                            AlignWithMargins:= True;
                            Margins.Right   := 20;
                            Margins.Bottom  := 6;
                            Margins.Top     := 6;
                            Text            := '';
                            Color           := clNone;
                            Enabled         := dwGetInt(joField,'readonly',0) <> 1;
                            //
                            Hint            := '{"dwstyle":""}';

                            //如果是自增字段，则只读
                            if joField.type = 'auto' then begin
                                Enabled     := False;
                            end;
                            Width           := dwGetInt(joField,'width',100);
                            Parent          := oPFd;
                        end;

                    end;

                    //
                    if Pos(','+joField.type+',',',boolean,combo,combopair,date,datetime,dbcombo,dbcombopair,dbtree,dbtreepair,integer,memo,money,string,time,tree,treepair,')>0 then begin
                        tM.Code         := @deFieldChange;
                        tM.Data         := APanel.Owner; // 随便取的数
                        tM1.Code        := @deFieldEnter;
                        tM1.Data        := APanel.Owner; // 随便取的数
                        tM2.Code        := @deFieldExit;
                        tM2.Data        := APanel.Owner; // 随便取的数
                        if oEFx<>nil then begin
                            oEFx.OnChange     := TNotifyEvent(tM);
                            oEFx.OnEnter      := TNotifyEvent(tM1);
                            oEFx.OnExit       := TNotifyEvent(tM2);
                        end;
                        if oMFx<>nil then begin
                            oMFx.OnChange     := TNotifyEvent(tM);
                            oMFx.OnEnter      := TNotifyEvent(tM1);
                            oMFx.OnExit       := TNotifyEvent(tM2);
                        end;
                        if oDFx<>nil then begin
                            oDFx.OnChange    := TNotifyEvent(tM);
                            oDFx.OnEnter     := TNotifyEvent(tM1);
                            oDFx.OnExit      := TNotifyEvent(tM2);
                        end;
                        if oCFx<>nil then begin
                            oCFx.OnChange    := TNotifyEvent(tM);
                            oCFx.OnEnter     := TNotifyEvent(tM1);
                            oCFx.OnExit      := TNotifyEvent(tM2);
                        end;
                    end;
                end;

            except

                //异常时调试使用
                Result  := -7;
            end;
        end;

        {$IFDEF TIME}
            t7  := GetTickCount;
        {$ENDIF}


        if Result = 0 then begin
            try

                //更新数据
                if dwGetInt(joConfig,'defaultempty',0) <> 1 then begin
                    deUpdate(APanel,'',False);
                end else begin
                    deUpdate(APanel,'1=0',False);
                end;
            except

                //异常时调试使用
                Result  := -8;
            end;
        end;

        {$IFDEF TIME}
            t8  := GetTickCount;
        {$ENDIF}



        if Result = 0 then begin
            try
                //创建确定面板P_Confirm
                deCreateConfirmPanel(APanel);
            except

                //异常时调试使用
                Result  := -9;
            end;
        end;

        {$IFDEF TIME}
            t9  := GetTickCount;
        {$ENDIF}


        // deInited 事件
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,deInited,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //
        if Result <> 0 then begin
            dwMessage('Error when DBEditor at '+IntToStr(Result)+', getlasterror = '+ IntToStr(GetLastError),'error',oForm);
        end;

        {$IFDEF TIME}
            t11 := GetTickCount;
            dwRunJS('console.log("'
                +Format('T1=%d,T2=%d,T3=%d,T4=%d,T5=%d,T6=%d,T7=%d,T8=%d,T9=%d,T10=%d,T11=%d',[t1-t0,t2-t1,t3-t2,t4-t3,t5-t4,t6-t5,t7-t6,t8-t7,t9-t8,t10-t9,t11-t10])+'");',oForm);
            dwRunJS('console.log("'
                +Format('T41=%d,T42=%d,T43=%d,T44=%d,T45=%d',[t41-t40,t42-t41,t43-t42,t44-t43,t45-t44])+'");',oForm);
        {$ENDIF}


    finally
        APanel.Visible  := bVisibleOld;
    end;
end;

//销毁dwCrud，以便二次创建
function  deDestroy(APanel:TPanel):Integer;
var
    sPrefix     : String;
    joConfig    : Variant;
    oForm       : TForm;
    oPanel      : TPanel;
    oFDQuery    : TFDQuery;
begin
    try
        //取得form备用
        oForm   := TForm(APanel.Owner);

        //
        joConfig    := deGetConfig(APanel);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //销毁编辑面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PEr'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁删除面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁Query面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PQy'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁主表板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PQC'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁临时表
        oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQTemp'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

        //销毁主表
        oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

    except

    end;
end;


end.
