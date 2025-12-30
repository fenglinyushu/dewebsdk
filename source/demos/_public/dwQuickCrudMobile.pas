unit dwQuickCrudMobile;
{
更新说明：
--------------------------------------------------------------------------------
2024-09-27
    1、在原dwQuickCrud.pas上的基础上创建该文件

}

interface
uses
    //
    dwBase,
    //dwAccess,

    //导出XLS
    dwExportToXLSUnit,


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
    Math,System.DateUtils,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;

//一键生成CRUD模块
function  qmCrud(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

//销毁dwCrud，以便二次创建
function  qmCrudDestroy(AForm:TForm):Integer;

//更新数据
procedure qmUpdateMain(AForm:TForm;AWhere:String);

//取QuickCrud模块的 FDQuery 控件，AIndex : 0 为主表，-1表示临时表，1~n为从表。 未找到返回空值
function  qmGetFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;

//取QuickCrud模块的 ListView 控件
function  qmGeTListView(AForm:TForm):TListView;

//取QuickCrud模块的SQL语句，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function  qmGetSQL(AForm:TForm;AIndex:Integer):String;

//取QuickCrud模块的SQL语句中的where(返回值不包含where)，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function  qmGetWhere(AForm:TForm;AIndex:Integer):String;

//树形表转js对象
function  qmDbToOptions(AQuery:TFDQuery;AField:Variant;AMode:Integer):String;

//在quickcrud的按钮栏中插入控件
function  qmAdd(AForm:TForm;ACtrl:TWinControl):Integer;

const
    //整型类型集合
    qmstInteger : Set of TFieldType = [ftSmallint, ftInteger, ftWord, ftAutoInc,ftLargeint, ftLongWord, ftShortint, ftByte];
    //浮点型类型集合
    qmstFloat   : set of TFieldType = [ftFloat, ftCurrency, ftBCD, ftExtended, ftSingle];

implementation

//从JSON对象fields中取得字符串形式的字段列表，以用于sql语句
//AOnlyVisbile:Boolean 是否仅显示可见字段
//返回值形如：id,fieldname,filetime,size
function _GetFields(AFields:Variant;AOnlyVisbile:Boolean):String;
var
    iField      : Integer;
    joField     : variant;
begin
    try
        Result  := '';
        //拼接字段字符串
        for iField := 0 to AFields._Count-1 do begin
            //取得当前字段JSON对象
            joField := AFields._(iField);

            //控制可视化
            if AOnlyVisbile and (joField.view<>0) then begin
                Continue;
            end;

            //
            if joField.Exists('name') then begin
                if joField.name <> '__SELECT__'  then begin
                    Result := Result + AFields._(iField).name + ','
                end;
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

//得到主表的字段caption列表,如：["姓名","性别","年龄","地址"]
function _GetCaptions(AFields:Variant;AOnlyVisbile:Boolean):String;
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
            if AOnlyVisbile and (joField.view<>0) then begin
                Continue;
            end;

            //
            if joField.name <> '__SELECT__'  then begin
                joRes.Add(AFields._(iField).caption);
            end;
        end;
        //
        Result  := joRes;
    except
        Result  := 'ErrorWhen_GetCaptions';
    end;
end;

//从字符串型的默认查询值中取得查询开始日期
function _GetQueryStartDate(AValue:String):TDateTime;
begin
    if AValue = 'none' then begin               //无
        Result  := StrToDateDef('9999-09-09',Now);
    end else if AValue = 'today' then begin     //当天
        Result  := Trunc(Now);
    end else if AValue = 'week' then begin      //本周
        Result  := Trunc(StartOfTheWeek(Now));
    end else if AValue = 'month' then begin     //当月
        Result  := Trunc(StartOfTheMonth(Now));
    end else if AValue = 'year' then begin      //当年
        Result  := Trunc(StartOfTheYear(Now));
    end else if AValue = '3 days' then begin    //3天内
        Result  := Trunc(Now-2);
    end else if AValue = '7 days' then begin    //7天内
        Result  := Trunc(Now-6);
    end else if AValue = '15 days' then begin   //15天内
        Result  := Trunc(Now-14);
    end else if AValue = '1 month' then begin   //1月内
        Result  := Trunc(IncMonth(Today, -1)+1);
    end else if AValue = '3 months' then begin   //1月内
        Result  := Trunc(IncMonth(Today, -3)+1);
    end else if AValue = '6 months' then begin   //1月内
        Result  := Trunc(IncMonth(Today, -6)+1);
    end else if AValue = '1 year' then begin    //1年内
        Result  := Trunc(IncYear(Today, -1)+1);
    end else if AValue = '3 years' then begin    //3年内
        Result  := Trunc(IncYear(Today, -3)+1);
    end else if AValue = '10 years' then begin    //1年内
        Result  := Trunc(IncYear(Today, -10)+1);
    end else if AValue = 'all' then begin       //全部
        Result  := StrToDatedef('1900-01-01',Trunc(Now+1));
    end else begin
        Result  := StrToDateDef('9999-09-09',Now);;
    end;
end;

//从字符串型的默认查询值中取得查询结束日期
function _GetQueryEndDate(AValue:String):TDateTime;
begin
    if AValue = 'none' then begin               //无
        Result  := StrToDateDef('9999-09-09',Now);
    end else if AValue = 'today' then begin     //当天
        Result  := Trunc(Now+1);
    end else if AValue = 'week' then begin      //本周
        Result  := Trunc(EndOfTheWeek(Now));
    end else if AValue = 'month' then begin     //当月
        Result  := Trunc(EndOfTheMonth(Now));
    end else if AValue = 'year' then begin      //当年
        Result  := Trunc(EndOfTheYear(Now));
    end else if AValue = '3 days' then begin    //3天内
        Result  := Trunc(Now+1);
    end else if AValue = '7 days' then begin    //7天内
        Result  := Trunc(Now+1);
    end else if AValue = '15 days' then begin   //15天内
        Result  := Trunc(Now+1);
    end else if AValue = '1 month' then begin   //1月内
        Result  := Trunc(Now+1);
    end else if AValue = '3 months' then begin   //1月内
        Result  := Trunc(Now+1);
    end else if AValue = '6 months' then begin   //1月内
        Result  := Trunc(Now+1);
    end else if AValue = '1 year' then begin    //1年内
        Result  := Trunc(Now+1);
    end else if AValue = '10 years' then begin   //10年内
        Result  := Trunc(Now+1);
    end else if AValue = 'all' then begin       //全部
        Result  := StrToDatedef('2050-01-01',Trunc(Now+1));
    end else begin
        Result  := Trunc(Now+1);
    end;
end;


//根据列号，求JSON字段序号
function _GetFieldIndexFromCol(AFields:Variant;ACol:Integer):Integer;
var
    iField  : Integer;
    iCurCol : Integer;
    //
    joField : Variant;
begin
    try
        Result  := 0;
        //
        iCurCol := -1;
        for iField := 0 to AFields._Count - 1 do begin
            joField := AFields._(iField);

            //
            if joField.view = 0 then begin
                Inc(iCurCol);
            end;

            //找到结果
            if iCurCol = ACol then begin
                Result  := iField;
                break;
            end;
        end;

    except
        Result  := -1;
    end;

end;

//在quickcrud的按钮栏中插入控件
function qmAdd(AForm:TForm;ACtrl:TWinControl):Integer;
var
    oPBs  : TPanel;
    oBNw      : TButton;
begin
    //取得按钮面板
    oPBs      := TPanel(AForm.FindComponent('PBs'));
    //取得“新增”按钮，以设置新控件的Margins
    oBNw          := TButton(AForm.FindComponent('BNw'));
    //嵌入
    ACtrl.Parent    := oPBs;
    ACtrl.Align     := alLeft;
    //设置Margins
    ACtrl.Margins   := oBNw.Margins;
    ACtrl.AlignWithMargins  := True;
end;

//树形表转js对象
function qmDbToOptions(AQuery:TFDQuery;AField:Variant;AMode:Integer):String;
var
    I           : Integer;
    sPrevMC     : String;
    sPrevBH     : String;
    sCurrMC     : String;
    sCurrBH     : String;
begin
    case AMode of
        1 : begin
            Result  := '[';
            AQuery.Close;
            AQuery.SQL.Text := 'SELECT '+AField.id+','+AField.pid+','+AField.field
                    +' FROM '+AField.table
                    +' ORDER BY ' +AField.id+','+AField.pid;
            AQuery.FetchOptions.RecsSkip    := 0;
            AQuery.FetchOptions.RecsMax     := -1;
            AQuery.Open;
            //
            sPrevMC     := AQuery.FieldByName(AField.field).AsString;
            sPrevBH     := AQuery.FieldByName(AField.id).AsString;
            Result      := Result + '{id:'''+sPrevMC+''',label:'''+sPrevMC+''',children:[';
            //
            AQuery.Next;
            //
            while not AQuery.Eof do begin
                sCurrMC     := AQuery.FieldByName(AField.field).AsString;
                sCurrBH     := AQuery.FieldByName(AField.id).AsString;

                //如果当前记录是上一记录的子记录
                if (sPrevBH <> sCurrBH) and (Pos(sPrevBH,sCurrBH)>0) then begin    //当前是上一节点的子节点
                    Result  := Result + '{id:'''+sCurrMC+''',label:'''+sCurrMC+''',children:[';
                end else begin  //当前节点是上一节点叔/小爷节点
                    for I := (Length(sPrevBH)-Length(sCurrBH)) div 2  downto 0 do begin
                        Result  := Result + ']},';
                    end;
                    Result  := Result + '{id:'''+sCurrMC+''',label:'''+sCurrMC+''',children:[';
                end;
                sPrevMC     := sCurrMC;
                sPrevBH     := sCurrBH;
                //
                AQuery.Next;
            end;
            //
            for I := (Length(sCurrBH) div 2) - 1 downto 0 do begin
                Result  := Result + ']},';
            end;
            Result  := Result + ']';

            //删除空children
            Result  := StringReplace(Result,',children:[]','',[rfReplaceAll]);
            Result  := StringReplace(Result,',]',']',[rfReplaceAll]);


        end;
    end;
end;

//通过rtti读form的 qmConfig 变量
function qmGetConfig(AForm:TForm):String;
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
        oRF := oRT.GetField('qcConfig');
        if oRF <> nil then begin
            Result  := oRF.GetValue(AForm).AsString;
        end;
    finally
        oRC.Free;
    end;
end;


function qmGetConfigJson(AForm:TForm):Variant;
var
    iField      : Integer;
    //
    joField     : Variant;
begin
    try
        //取配置JSON : 读AForm的 qmConfig 变量值
        Result  := _json(qmGetConfig(AForm));

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
            Result.pagesize  := 5;
        end;
        if not Result.Exists('cardheight') then begin//默认数据行的行高
            Result.cardheight  := 45;
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
        if not Result.Exists('query') then begin    //默认显示查询
            Result.query  := 1;
        end;
        if not Result.Exists('export') then begin    //默认显示导出按钮
            Result.export := 1;
        end;
        if not Result.Exists('fields') then begin    //显示的字段列表
            Result.fields  := _json('[]');
        end;
        if not Result.Exists('margin') then begin   //默认边距
            Result.margin := 10;
        end;
        if not Result.Exists('radius') then begin   //默认表名
            Result.radius := 5;
        end;
        if not Result.Exists('defaulteditmax') then begin //是否默认最大化
            Result.defaulteditmax := 0;
        end;
        if not Result.Exists('editwidth') then begin //数据编辑框的宽度
            Result.editwidth := 360;
        end;
        if not Result.Exists('teminate') then begin  //
            Result.teminate  := 'terminate by user';
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
            if not joField.Exists('width') then begin
                joField.width := 120;
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
        //>
    except

    end;
end;


function qmAppend(
    AForm:TForm;        //控件所在窗体
    APrefix:Integer;    //控件名称的前缀，用于查找控件
    AQuery:TFDQuery;    //数据查询
    AFields:Variant     //字段列表JSON
    ):Integer;
var
    iField      : Integer;
    //
    joField     : Variant;
    joConfig    : Variant;
    //
    oComp       : TComponent;
    oCB         : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    //
    bAccept     : Boolean;
    iDec        : Integer;
begin
    try
        //新增
        AQuery.Append;

        //取得参数配置JSON对象，以便后续处理
        joConfig    := qmGetConfigJson(AForm);

        //append后事件
        bAccept := True;
        if Assigned(AForm.OnDragOver) then begin
            AForm.OnDragOver(AForm,nil,APrefix,2,dsDragEnter,bAccept);
            if not bAccept then begin
                dwMessage(joConfig.teminate,'error',AForm);
                Exit;
            end;
        end;


        //循环处理各字段
        iDec    := 0;
        //AFields := joConfig.fields;
        for iField := 0 to AFields._Count -1 do begin
            //取得字段的JSON
            joField := AFields._(iField);

            //避免多选列问题
            if joField.name = '__SELECT__' then begin
                iDec    := -1;
                continue;
            end;

            //取得对应控件
            oComp   := AForm.FindComponent('F'+IntToStr(APrefix) + IntToStr(iField));

            //如果找到了控件（有可能因为view<>0的原因找不到）
            if oComp <> nil then begin

                //根据当前字段JSON信息进行处理
                if joField.type = 'auto' then begin
                    oE      := TEdit(oComp);
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
                    TEdit(oComp).Enabled    := False;
                end else if joField.type = 'combo' then begin
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oCB.Text    := AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'combopair' then begin
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oCB.Text    := AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'dbcombo' then begin
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oCB.Text:= AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'integer' then begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsInteger  := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsInteger = null then begin
                            AQuery.Fields[iField+iDec].AsInteger   := 0;
                        end;
                    end;
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'date' then begin
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsDateTime := StrToDateDef(joField.default,Now);
                    end else begin
                        if AQuery.Fields[iField+iDec].IsNull then begin
                            AQuery.Fields[iField+iDec].AsDateTime := Now;
                        end;
                    end;
                    oDT.Kind    := dtkDate;
                    oDT.Date    := AQuery.Fields[iField+iDec].AsDateTime;
                end else if joField.type = 'time' then begin
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsDateTime := StrToTimeDef(joField.default,Now);
                    end else begin
                        if AQuery.Fields[iField+iDec].IsNull then begin
                            AQuery.Fields[iField+iDec].AsDateTime := Now;
                        end;
                    end;
                    oDT.Kind    := dtkTime;
                    oDT.Time    := AQuery.Fields[iField+iDec].AsDateTime;
                end else if joField.type = 'datetime' then begin
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsDateTime := StrToDateTimeDef(String(joField.default),Now);
                    end else begin
                        if AQuery.Fields[iField+iDec].IsNull then begin
                            AQuery.Fields[iField+iDec].AsDateTime := Now;
                        end;
                    end;
                    oDT.DateTime    := AQuery.Fields[iField+iDec].AsDateTime;
                end else if joField.type = 'money' then begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsFloat   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsFloat = null then begin
                            AQuery.Fields[iField+iDec].AsFloat   := 0;
                        end;
                    end;
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
                end else begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
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
        end;
    except
    end;
end;



function qmGetFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;
begin
    if AIndex = 0 then begin
        Result  := TFDQuery(AForm.FindComponent('FQ_Main'));
    end else if AIndex = -1 then begin
        Result  := TFDQuery(AForm.FindComponent('FDQueryTmp'));
    end else begin
        Result  := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(AIndex-1)));
    end;
end;
function qmGetListView(AForm:TForm):TListView;
begin
    Result  := TListView(AForm.FindComponent('LVM'));
end;

//通过rtti为form的 qmConfig 变量 赋值
function qmSetConfig(AForm:TForm;AConfig:String):Integer;
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
        oRF := oRT.GetField('qcConfig');
        if oRF <> nil then begin
            oRF.SetValue(AForm,AConfig);
        end else begin
            Result  := -1;
        end;
    finally
        oRC.Free;
    end;
end;

function  qmGetSQL(AForm:TForm;AIndex:Integer):String;
var
    oFDQuery    : TFDQuery;
begin
    Result  := '';
    case AIndex of
        0 : begin
            oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));
        end
    else
            oFDQuery    := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(AIndex-1)));
    end;
    if oFDQuery<>nil then begin
        Result  := oFDQuery.SQL.Text;
    end;
end;


function  qmGetWhere(AForm:TForm;AIndex:Integer):String;
var
    Regex       : TRegEx;
    Match       : TMatch;
begin
    Result  := qmGetSQL(AForm,AIndex);

    // 正则表达式匹配 WHERE 子句
    Regex   := TRegEx.Create('(?i)\bWHERE\b\s*(.*?)(?=\bORDER BY\b|\bGROUP BY\b|$)', [roIgnoreCase]);
    Match   := Regex.Match(Result);

    if Match.Success then begin
        Result := Match.Groups[1].Value.Trim; // 返回 WHERE 子句内容
    end else begin
        Result := ''; // 如果没有找到，返回空字符串
    end;

end;

//智能查询关键字输入框EKw (Edit keyword) 输入事件
Procedure EKwChange(Self: TObject; Sender: TObject);
var
    oEKw    : TEdit;
    oForm   : TForm;
    oTMa    : TTrackBar;
begin
    //dwMessage('EKwChange','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oEKw    := TEdit(Sender);
    oForm   := TForm(oEKw.Owner);
    oTMa    := TTrackBar(oForm.FindComponent('TMa'));

    //
    oTMa.Position   := 0;

    //更新主表数据
    qmUpdateMain(TForm(TEdit(Sender).Owner),'');
end;

Procedure FQyResize(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oFQy        : TFlowPanel;
    oPBs        : TPanel;
    oLVM        : TListView;
    oPTM        : TPanel;
    oPCS        : TPageControl;
    oChange     : Procedure(Sender:TObject) of Object;
    oPSB        : TPanel;
begin
    //取得各控件
    oFQy        := TFlowPanel(Sender);
    oForm       := TForm(oFQy.Owner);
    oPBs        := TPanel(oForm.FindComponent('PBs'));
    oLVM        := TListView(oForm.FindComponent('LVM'));
    oPTM        := TPanel(oForm.FindComponent('PTM'));
    oPCS        := TPageControl(oForm.FindComponent('PCS'));
    oPSB        := TPanel(oForm.FindComponent('PSB'));
    //控制各控件大小位置信息
    if oPTM <> nil then begin
        //
        oChange         := oFQy.OnResize;
        oFQy.OnResize   := nil;
        oFQy.AutoSize   := True;
        oFQy.AutoSize   := False;
        //
        oPBs.Top        := oFQy.top + oFQy.Height + 10;
        oLVM.Top        := oPBs.Top + oPBs.Height;
        //
        if ( oPCS <> nil ) and oPCS.Visible then begin
            oPCS.Top    := oPTM.Top + oPTM.Height + 10;
            oPCS.Height := oForm.Height - oPCS.Top - 10;
            oPSB.Top    := oPCS.top + 1;
            oPTM.Top    := oLVM.Top + oLVM.Height;
        end else begin
            oLVM.Height := oPTM.Top - oLVM.Top;
        end;
        //
        oFQy.OnResize   := oChange;
    end;
end;

Procedure BQmClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oFQy        : TFlowPanel;
    oPQSmt      : TPanel;
    oBFz    : TButton;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent('FQy'));
    oPQSmt      := TPanel(oForm.FindComponent('PQm'));
    oBFz        := TButton(oForm.FindComponent('BFz'));
    //
    oButton.Tag := oButton.Tag - 1;
    if not(oButton.Tag in [0,1,2]) then begin
        oButton.Tag := 2;
    end;
    if oFQy = nil then begin
        //切换查询模式： 分字段查询 / 智能模糊查询
        case oButton.Tag of
            0 : begin
                //切换到 无查询
                oPQSmt.Visible := False;
                //该模式下支持2种匹配方式：模糊/精确
                oBFz.Visible    := False;
            end;
            1,2 : begin
                //切换到 智能模糊查询
                oPQSmt.Visible := True;
                oPQSmt.Top     := 0;
                //该模式下仅支持模糊查询
                oBFz.Visible    := False;
                //
                oButton.Tag := 1;
            end;
        else
        end;
    end else begin
        //切换查询模式： 分字段查询 / 智能模糊查询
        case oButton.Tag of
            0 : begin
                //切换到 无查询
                oFQy.Top       := oPQSmt.Top;
                oPQSmt.Visible := False;
                oFQy.Visible   := False;
                //该模式下支持2种匹配方式：模糊/精确
                oBFz.Visible    := False;
            end;
            1 : begin
                //切换到 智能模糊查询
                oPQSmt.Top     := oFQy.Top;
                oFQy.Visible   := False;
                oPQSmt.Visible := True;
                //该模式下仅支持模糊查询
                oBFz.Visible    := False;
            end;
            2 : begin
                //切换到 分字段查询
                oFQy.Top       := oPQSmt.Top;
                oPQSmt.Visible := False;
                oFQy.Visible   := True;
                //该模式下支持2种匹配方式：模糊/精确
                oBFz.Visible    := True;
            end;
        else
        end;
    end;
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
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-c-scale-to-original"}';
        oButton.Caption := '精确';
    end else begin
        //模糊
        oButton.Tag     := 0;
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-open"}';
        oButton.Caption := '模糊';
    end;
end;

Procedure BQyClick(Self: TObject; Sender: TObject); //"查询"按钮 BQy - Button Query
var
    oButton     : TButton;
    oForm       : TForm;
    oTMa    : TTrackBar;
begin
    //dwMessage('BQyClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oTMa        := TTrackBar(oForm.FindComponent('TMa'));

    //设置为第1页
    oTMa.Position   := 0;

    //置标志，表示已查询，即当前查询条件有效
    TButton(Sender).Tag := 1;

    //更新主表
    qmUpdateMain(TForm(TEdit(Sender).Owner),'');
end;

Procedure BQCClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oPQy    : TPanel;
begin
    //dwMessage('BQCClick','',TForm(TEdit(Sender).Owner));

    //
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPQy        := TPanel(oForm.FindComponent('PQy'));

    //关闭查询窗体
    oPQy.Visible    := False;
end;

Procedure BQXClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oForm1      : TForm;
    oPQy    : TPanel;
    oPCS   : TPageControl;
    oFC : TFlowPanel;
    //
    iItem       : Integer;
    //
    joConfig    : variant;

begin
    //dwMessage('BQXClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPQy    := TPanel(oForm.FindComponent('PQy'));
    oPCS   := TPageControl(oForm.FindComponent('PCS'));

    //
    if oForm.Owner <> nil then begin
        oForm1  := TForm(oForm.Owner);
    end else begin
        oForm1  := oForm;
    end;

    //先设置非AutoSize
    for iItem := 1 to oPCS.PageCount do begin
        oFC := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iItem)));
        oFC.AutoSize    := False;
    end;

    //
    joConfig    := qmGetConfigJson(oForm);

    //
    if oForm1.Width < 500 then begin
        if oPQy.Width = Min(oForm1.width-20,joConfig.editwidth) then begin
            //标志当前最大化
            oButton.Tag := 9;
            //最大化
            oPQy.Width      := oForm1.Width - 20;
            oPQy.Top        := 10;
            oPQy.Height     := oForm1.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPQy.Width     := Min(oForm1.width-20,joConfig.editwidth);
            oPQy.Top       := 10;
            oPQy.Height    := oForm1.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end;
    end else begin
        //标志当前正常大小
        oButton.Tag := 0;

        //正常界面
        if oPQy.Width = Min(oForm1.width-100,joConfig.editwidth) then begin
            oPQy.Width     := oForm1.width-100;
            oPQy.Top       := 50;
            oPQy.Height    := oForm1.Height - 100;
            oButton.Hint       := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPQy.Width      := Min(oForm1.Width - 100,joConfig.editwidth);
            oPQy.Top        := 50;
            oPQy.Height     := oForm.Height - 100;
            oButton.Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        end;
    end;

    //设置AutoSize,以配合ScrollBox滚动
    for iItem := 1 to oPCS.PageCount do begin
        oFC := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iItem)));
        oFC.AutoSize    := True;
    end;
end;




Procedure CB_PageSizeChange(Self: TObject; Sender: TObject);
var
    oCB_PageSize: TComboBox;
    oForm       : TForm;
    oLVM    : TListView;
    //
    joConfig    : Variant;
    iOldPageSz  : Integer;
    iNewPageSz  : Integer;
    iItem       : Integer;
begin
    //dwMessage('CB_PageSizeChange','',TForm(TComboBox(Sender).Owner));
    //取得各控件
    oCB_PageSize:= TComboBox(Sender);
    oForm       := TForm(oCB_PageSize.Owner);
    oLVM    := TListView(oForm.FindComponent('LVM'));
    //取得当前配置
    joConfig            := qmGetConfigJson(oForm);
    //更新配置,保存PageSize
    iOldPageSz          := joConfig.pagesize;
    iNewPageSz          := StrToIntDef(oCB_PageSize.Text,iOldPageSz);
    joConfig.pagesize   := iNewPageSz;
    qmSetConfig(oForm,joConfig);
    //
    if iNewPageSz > iOldPageSz then begin
        for iItem := iOldPageSz to iNewPageSz -1 do begin
            //dwSGAddRow(oLVM);
        end;
        //oLVM.Items.Add   := 1 + iNewPageSz;
        //更新数据
        qmUpdateMain(TForm(TEdit(Sender).Owner),'');
    end;
    //
    if iNewPageSz < iOldPageSz then begin
        for iItem := iOldPageSz-1 downto iNewPageSz do begin
            //dwSGDelRow(oLVM);
        end;
        //oLVM.RowCount   := 1 + iNewPageSz;
        //更新数据
        qmUpdateMain(TForm(TEdit(Sender).Owner),'');
    end;
end;

Procedure BDOClick(Self: TObject; Sender: TObject); //Button Delete OK
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oSQuery     : TFDQuery;
    oPanel      : TPanel;
    //
    iSelect     : Integer;
    iRow        : Integer;
    //
    sMValue     : string;   //主表的关键字段值
    sSelect     : string;   //用于取得当前多选列的选择信息，如["1","5","6"]
    //
    joConfig    : variant;
    joSelect    : Variant;
begin
    //删除时的确定按钮事件
    //dwMessage('BDOClick','',TForm(TEdit(Sender).Owner));


    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('PDe'));


    //oTMa    := TTrackBar(oForm.FindComponent('TMa'));
    //默认到第1页
    //oTMa.Position   := 0;

    //取得配置JSON对象
    joConfig    := _json(qmGetConfig(oForm));

    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));


    //
    oQuery.Delete;
    //
    qmUpdateMain(oForm,'');
    //
    qmUpdateMain(oForm,'');

    //
    oPanel.Visible  := False;
end;

Procedure BDCClick(Self: TObject; Sender: TObject);
var
    oButton : TButton;
    oForm   : TForm;
    oPanel  : TPanel;
begin
    //dwMessage('BDCClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('PDe'));
    //关闭面板
    oPanel.Visible  := False;
end;

Procedure BEKClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oQueryTmp   : TFDQuery;
    oBEA        : TButton;
    oPEr        : TPanel;
    oE_Field    : TEdit;
    oDT_Field   : TDateTimePicker;
    oComp       : TComponent;
    oCB_Field   : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    oCKB        : TCheckBox;
    //
    iField      : Integer;
    iItem       : Integer;
    iTemp       : Integer;
    iDec        : Integer;
    //
    bAccept     : Boolean;
    //
    sMValue     : string;   //主表的关键字段值
    sOldValue   : string;   //编辑前字段值，用于防重
    //
    joConfig    : variant;
    joField     : Variant;
begin
    //编辑/新增面板的确定按钮事件
    //dwMessage('BDOClick','',TForm(TEdit(Sender).Owner));


    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEr        := TPanel(oForm.FindComponent('PEr'));
    oBEA        := TButton(oForm.FindComponent('BEA'));   //取消按钮，用于记录是否批量新增过
    oCKB        := TCheckBox(oForm.FindComponent('CKB'));

    //用于表示因多选列造成的序号偏差
    iDec        := 0;

    //取得Query备用
    oQueryTmp   := TFDQuery(oForm.FindComponent('FDQueryTmp'));

    //取得配置JSON对象
    joConfig    := _json(qmGetConfig(oForm));
    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oPEr.Tag of
        0 : begin   //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            //更新数值
            oQuery.Edit;
            iDec    := 0;
            for iField := 0 to joConfig.fields._Count -1 do begin

                //得到字段JSON对象
                joField := joConfig.fields._(ifield);

                //避免多选列问题
                if joField.name = '__SELECT__' then begin
                    iDec    := -1;
                    continue;
                end;

                //保存当前字段值，以用于防重
                sOldValue   := oQuery.Fields[iField+iDec].AsString;

                //
                oComp   := oForm.FindComponent('F0'+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    if joField.type = 'auto' then begin
                        Continue;
                    end else if joField.type = 'boolean' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);
                    end else if joField.type = 'combo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'combopair' then begin   //根据字符串对进行保存
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := '';
                        if oCB_Field.Text <> '' then begin
                            for iTemp := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iTemp)._(0) = oCB_Field.text then begin
                                    oQuery.Fields[iField+iDec].AsString  := joField.list._(iTemp)._(1);
                                    break;
                                end;
                            end;
                        end;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'integer' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsInteger := StrToIntDef(oE_Field.text,0);
                    end else if joField.type = 'date' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Date;
                    end else if joField.type = 'time' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Time;
                    end else if joField.type = 'datetime' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.DateTime;
                    end else if joField.type = 'money' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsFloat := StrToFloatDef(oE_Field.text,0);
                    end else begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsString := oE_Field.text;
                    end;
                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iField+iDec].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oQueryTmp.Close;
                            if oQuery.Fields[iField+iDec].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iField+iDec].AsString;
                            end else begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iField+iDec].AsString+'''';
                            end;
                            oQueryTmp.Open;

                            //根据当前字段是否更改分别处理
                            if sOldValue = oQuery.Fields[iField+iDec].AsString then begin
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
            end;

            //Post前事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,3,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;
            //关闭伪窗体
            oPEr.Visible  := False;

            //Post后事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,4,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;
        end;
        100 : begin   //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            //更新数值
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);

                //避免多选列问题
                if joField.name = '__SELECT__' then begin
                    iDec    := -1;
                    continue;
                end;
                //
                oComp   := oForm.FindComponent('F0'+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    if joField.type = 'auto' then begin
                        Continue;
                    end else if joField.type = 'select' then begin
                        Continue;
                    end else if joField.type = 'combo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'combopair' then begin   //根据预设的二维数组list进行比对保存
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := '';
                        if oCB_Field.Text <> '' then begin
                            for iTemp := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iTemp)._(0) = oCB_Field.text then begin
                                    oQuery.Fields[iField+iDec].AsString  := joField.list._(iTemp)._(1);
                                    break;
                                end;
                            end;
                        end;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'integer' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsInteger := StrToIntDef(oE_Field.text,0);
                    end else if joField.type = 'date' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Date;
                    end else if joField.type = 'time' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Time;
                    end else if joField.type = 'datetime' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.DateTime;
                    end else if joField.type = 'money' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsFloat := StrToFloatDef(oE_Field.text,0);
                    end else begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsString := oE_Field.text;
                    end;

                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iField+iDec].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oQueryTmp.Close;
                            if oQuery.Fields[iField+iDec].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iField+iDec].AsString;
                            end else begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iField+iDec].AsString+'''';
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
            end;

            //Post前事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,3,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;


            //Post后事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,4,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //如果选中的“批量录入”，则重新append, 否则关闭退出
            if oCKB.Checked then begin
                //做标记
                oBEA.Tag  := 999;

                //自动新增
                qmAppend(oForm,
                    0,
                    oQuery,
                    joConfig.fields
                    );
            end else begin
                //关闭伪窗体
                oPEr.Visible  := False;
            end;
        end;
    end;
    //更新显示（仅关闭编辑/新增面板时）
    if not oPEr.Visible then begin
        //用 PEr 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oPEr.Tag of
            0,100 : begin
                qmUpdateMain(oForm,'');
            end;
        end;
    end;
end;

Procedure BEAClick(Self: TObject; Sender: TObject);  //BEA - Button Edit cAncel
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPEr        : TPanel;
begin
    //dwMessage('BDOClick','',TForm(TEdit(Sender).Owner));
    //取得各对象
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPEr    := TPanel(oForm.FindComponent('PEr'));
    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oPEr.Tag of
        0 : begin       //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
        100 : begin     //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
    end;
    //
    oPEr.Visible  := False;

    //更新显示（仅tag=999时，此时表示已批量增加）
    if oButton.Tag = 999 then begin
        oButton.Tag := 0;
        //用 PEr 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oPEr.Tag of
            0,100 : begin
                qmUpdateMain(oForm,'');
            end;
        end;
    end;
end;

Procedure BEMClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oPCS        : TPageControl;
    oPEr        : TPanel;
    oFC         : TFlowPanel;
    //
    iItem       : Integer;
    //
    joConfig    : variant;
begin
    //dwMessage('BEMClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEr   := TPanel(oForm.FindComponent('PEr'));
    oPCS   := TPageControl(oForm.FindComponent('PCS'));

    //先设置非AutoSize
    oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(0)));
    oFC.AutoSize    := False;
    if oPCS <> nil then begin
        for iItem := 1 to oPCS.PageCount do begin
            oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(iItem)));
            oFC.AutoSize    := False;
        end;
    end;

    //
    joConfig    := qmGetConfigJson(oForm);

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
    oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(0)));
    oFC.AutoSize    := True;
    if oPCS <> nil then begin
        for iItem := 1 to oPCS.PageCount do begin
            oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(iItem)));
            oFC.AutoSize    := True;
        end;
    end;
end;


Procedure BEtClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oBEt        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oBEM        : TButton;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oM          : TMemo;
    oDT         : TDateTimePicker;
    oCB         : TComboBox;
    oCKB        : TCheckBox;
    //
    iItem       : Integer;
    iTemp       : Integer;
    iDec        : Integer;
    //用于取字段值，并清除其中的换行
    sValue      : String;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //主表编辑事件
    //dwMessage('BEtClick','',TForm(TEdit(Sender).Owner));


    //取得各控件
    oBEt    := TButton(Sender); //Et : Edit
    oForm   := TForm(oBEt.Owner);
    oPEr    := TPanel(oForm.FindComponent('PEr'));
    oBEL    := TButton(oForm.FindComponent('BEL'));
    oBEM    := TButton(oForm.FindComponent('BEM'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCKB    := TCheckBox(oForm.FindComponent('CKB'));
    //
    oCKB.Visible  := False;

    //EL Edit Label
    oBEL.Caption   := '编  辑';

    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPEr.Tag   := 0;
    //隐藏PEr中其他所有ScrollBox
    TScrollBox(oForm.FindComponent('SB0')).Visible  := True;
    for iItem := 1 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;

    //得到配置JSON
    joConfig    := qmGetConfigJson(oForm);

    //更新字段值
    iDec    := 0;   //用于iItem与oQuery.Fields的差值
    for iItem := 0 to joConfig.fields._Count-1 do begin  //此处需要避免多选列问题
        //得到字段JSON
        joField := joConfig.fields._(iItem);

        //避免多选列问题
        if joField.name = '__SELECT__' then begin
            iDec    := -1;
            continue;
        end;

        //查找字段对应的编辑控件
        oComp   := oForm.FindComponent('F'+'0'+IntToStr(iItem));

        //如果找到了控件（有可能因为view<>0的原因找不到）
        if oComp <> nil then begin
            //取字段的AsString，并清除其中的特殊字符串（如换行），备用
            sValue  := oQuery.Fields[iItem+iDec].AsString;
            sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
            sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

            //更新显示
            if joField.type = 'boolean' then begin
                oCB         := TComboBox(oComp);
                if LowerCase(sValue)='true' then begin
                    oCB.ItemIndex   := 1;
                end else begin
                    oCB.ItemIndex   := 0;
                end;
            end else if joField.type = 'combo' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;
            end else if joField.type = 'combopair' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if sValue <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(1) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(0);
                            break;
                        end;
                    end;
                end;
            end else if joField.type = 'dbcombo' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;
            end else if joField.type = 'integer' then begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end else if joField.type = 'date' then begin
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkDate;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'time' then begin
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkTime;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Time    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'datetime' then begin
                oDT         := TDateTimePicker(oComp);
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'memo' then begin
                oM          := TMemo(oComp);
                oM.Text     := oQuery.Fields[iItem+iDec].AsString;
            end else if joField.type = 'money' then begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
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

    //
    oPEr.Visible   := True;
end;

Procedure BNwClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oBNw        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oBEM        : TButton;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oCKB        : TCheckBox;
    //
    iItem       : Integer;
    //
    joConfig    : Variant;
    //
    bAccept     : Boolean;
begin
    //主表新增事件
    //dwMessage('BNwClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oBNw    := TButton(Sender);
    oForm   := TForm(oBNw.Owner);
    oPEr    := TPanel(oForm.FindComponent('PEr'));
    oBEL    := TButton(oForm.FindComponent('BEL'));
    oBEM    := TButton(oForm.FindComponent('BEM'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCKB    := TCheckBox(oForm.FindComponent('CKB'));

    //append前事件
    bAccept := True;
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,0,1,dsDragEnter,bAccept);
        if not bAccept then begin
            dwMessage(joConfig.teminate,'error',oForm);
            Exit;
        end;
    end;

    //批量处理
    oCKB.Visible  := True;

    //
    oBEL.Caption   := '新  增';

    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPEr.Tag  := 100;

    //隐藏PEr中其他所有ScrollBox，用于只显示主表的字段编辑框，隐藏所有从表的字段编辑框
    TScrollBox(oForm.FindComponent('SB0')).Visible := True;
    for iItem := 1 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;

    //取得参数配置JSON对象，以便后续处理
    joConfig    := qmGetConfigJson(oForm);

    //更新字段值
    qmAppend(oForm,
            0,
            oQuery,
            joConfig.fields
            );

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //
    oPEr.Visible  := True;
end;

Procedure BDeClick(Self: TObject; Sender: TObject);
var
    //
    bFound      : Boolean;
    //
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oLabel      : TLabel;
    oQuery      : TFDQuery;
    oLVM        : TListView;
    //
    iField      : Integer;
    iRow        : Integer;
    sInfo       : string;
    //
    joConfig    : Variant;
    joHint      : variant;
    joSelect    : variant;
begin
    //主表的删除事件。
    //dwMessage('BDeClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('PDe'));
    oLabel  := TLabel(oForm.FindComponent('LCF'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    oLVM    := TListView(oForm.FindComponent('LVM'));

    //得到配置JSON
    joConfig    := qmGetConfigJson(oForm);

    //得到主表表格的Hint字符串
    bFound  := False;   //用来表示是否已选择


    //标志当前是主表，用面板的tag
    oPanel.Tag  := 0;

    //根据是否多选，分别处理。如果没多选，则删除当前行；否则， 删除多选行
    if not bFound then begin
        sInfo   := '';
        for iField := 0 to Min(2,oQuery.FieldCount-1) do begin
            sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
        end;
        sInfo   := Copy(sInfo,1,Length(sInfo)-3);
    end;

    //
    oLabel.Caption  := '确定要删除当前记录以及关联从表记录吗？'#13#13+sInfo;
    oPanel.Visible  := True;
end;

Procedure BExClick(Self: TObject; Sender: TObject);     //BEx - Button Export
var
    //
    oForm       : TForm;
    oButton     : TButton;
    oQuery      : TFDQuery;
    //
    sFields     : string;   //主表字段列表
    sWhere      : String;   //主表WHERE
    sDir        : string;
    sFileName   : String;
    sTitles     : string;
    //
    joConfig    : Variant;
begin
    //主表的导出事件。
    //dwMessage('BExClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oQuery  := qmGetFDQuery(oForm,-1);  //取得临时查询

    //得到配置JSON
    joConfig    := qmGetConfigJson(oForm);

    //得到主表的字段名称列表
    sFields     := _GetFields(joConfig.Fields,False);

    //得到主表的字段caption列表,如：["姓名","性别","年龄","地址"]
    sTitles     := _GetCaptions(joConfig.Fields,False);

    //得到主表的WHERE
    sWhere      := qmGetWhere(oForm,0);

    //打开数据表
    oQuery.Close;
    oQuery.SQL.Text := 'SELECT '+sFields+' FROM '+joConfig.table +' WHERE '+sWhere;
    oQuery.Open;

    //
    sDir    := ExtractFilePath(Application.ExeName)+'/download/';
    sFileName   := 'QuickCrudData'+ FormatDateTime('_YYYYMMDD_hhmmss_zzz',Now)+'.xls';

    //导出到文件
    dwExportToTitledXLS(sDir + sFileName, oQuery, sTitles);

    //
    dwOpenURL(oForm,'download/'+sFileName,'_blank');

end;

//主表隐藏/显示按钮
Procedure BHdClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oButton     : TButton;
    oBNw        : TButton;
    oBEt        : TButton;
    oBDe        : TButton;
    oBEx        : TButton;
    oBQm        : TButton;
    oBFz        : TButton;
    oBHd        : TButton;
    oFQy        : TFlowPanel;
    oPQm        : TPanel;
    oPQC        : TPanel;
    oPMn        : TPanel;
    oPMd        : TPanel;
    oPBs        : TPanel;
    oPTM        : TPanel;
    oPSv        : TPanel;
    oLVM        : TListView;
    //
    sLayout     : String;
    //
    joTemp      : Variant;
    joConfig    : Variant;
begin
    //dwMessage('BHdClick','',TForm(TEdit(Sender).Owner));
    //主表的打印事件。

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPQC    := TPanel(oForm.FindComponent('PQC'));
    oPMn    := TPanel(oForm.FindComponent('PMn'));
    oPMd    := TPanel(oForm.FindComponent('PMd'));
    oPBs    := TPanel(oForm.FindComponent('PBs'));
    oPTM    := TPanel(oForm.FindComponent('PTM'));
    oLVM    := TListView(oForm.FindComponent('LVM'));
    oPSv    := TPanel(oForm.FindComponent('PSv'));
    //
    oBNw    := TButton(oForm.FindComponent('BNw'));
    oBEt    := TButton(oForm.FindComponent('BEt'));
    oBDe    := TButton(oForm.FindComponent('BDe'));
    oBEx    := TButton(oForm.FindComponent('BEx'));
    oBQm    := TButton(oForm.FindComponent('BQm'));
    oBFz    := TButton(oForm.FindComponent('BFz'));
    oBHd    := TButton(oForm.FindComponent('BHd'));
    oPQm    := TPanel(oForm.FindComponent('PQm'));
    oFQy    := TFlowPanel(oForm.FindComponent('FQy'));

    //取配置JSON : 读AForm的 qmConfig 变量值
    joConfig    := qmGetConfigJson(oForm);

    //取得总布局样式
    joTemp      := _json(oPQC.Hint);
    sLayout     := 'main';
    if joTemp <> unassigned then begin
        sLayout := joTemp.layout;
    end;

    //垂直排列时
    if sLayout = 'vert' then begin
        if oPMd.Height = 90 + joConfig.cardheight * ( 1 + joConfig.pagesize )+1 then begin  //点击后，仅显示从表，隐藏主表
            oButton.Caption         := '最大';

            //主表
            oPMd.AutoSize    := False;
            oPMd.Height      := oPBs.Height+3;
            oPMd.Align       := alTop;
            oPTM.Visible       := False;
            oPMn.Align           := alTop;
            oPMn.AutoSize        := True;

            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end else if oPMd.Height = oPBs.Height+3 then begin  //点击后，仅显示主表，隐藏从表
            //
            oButton.Caption         := '显示';

            //主表
            oPMn.Align           := alclient;
            oPMd.Align       := alClient;
            oLVM.Align          := alClient;
            oPTM.Visible       := True;

            //从表
            oPSv.Visible        := False;
        end else begin      //此时正常显示主从表
            //
            oButton.Caption         := '隐藏';

            //主表
            oPMd.Align      := alTop;
            oPMd.AutoSize   := False;
            oPMd.Height     := 90 + joConfig.cardheight * ( 1 + joConfig.pagesize )+1;  //高度
            oPTM.Visible    := True;
            oPMn.Align      := alTop;
            oPMn.AutoSize   := True;

            //从表
            oPSv.Visible    := True;
            oPSv.Align      := alClient;
        end;
    end;

    //水平排列时
    if sLayout = 'horz' then begin
        if oPMn.Width = joConfig.mainwidth then begin  //点击后，仅显示从表，隐藏主表
            oButton.Caption     := '最大';

            //主表
            oPMn.Align          := alLeft;
            oPMn.Width          := oButton.Width+32;
            oBHd.Align          := alLeft;
            oBNw.Visible        := False;
            oBEt.Visible        := False;
            oBDe.Visible        := False;
            oBQm.Visible        := False;
            oBFz.Visible        := False;
            oLVM.Visible        := False;
            oPTM.Visible        := False;
            //切换到无查询模式
            oBQm.Tag            := 0;
            oFQy.Visible        := False;
            oPQm.Visible        := False;


            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end else if oPMn.Width = oButton.Width+32 then begin  //使"最大" 点击后，仅显示主表，隐藏从表
            //
            oButton.Caption     := '显示';

            //主表
            oPMn.Align          := alclient;
            oBDe.Visible        := joConfig.delete = 1;
            oBNw.Visible        := joConfig.new = 1;
            oBEt.Visible        := joConfig.edit = 1;
            oBEx.Visible        := joConfig.export = 1;
            oBQm.Visible        := True;
            oLVM.Visible        := True;
            oPTM.Visible        := True;
            oBHd.Align          := alRight;
            oBHd.Left           := 9999;
            //
            oButton.Left        := 1000;

            //从表
            oPSv.Visible        := False;
        end else begin      //此时正常显示主从表
            //
            oButton.Caption     := '隐藏';

            //主表
            oPMn.Align          := alLeft;
            oPMn.Width          := joConfig.mainwidth;
            oBDe.Visible        := joConfig.delete = 1;
            oBNw.Visible        := joConfig.new = 1;
            oBEt.Visible        := joConfig.edit = 1;
            oBEx.Visible        := joConfig.export = 1;
            oBQm.Visible        := True;
            oLVM.Visible        := True;
            oPTM.Visible        := True;
            oBHd.Align          := alRight;
            oBHd.Left           := 9999;
            //
            oButton.Left        := 1000;

            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end;
    end;
end;


Procedure LVMClick(Self: TObject; Sender: TObject);
var
    iRow    : Integer;
    oForm   : TForm;
    oLV     : TListView;
    oQuery  : TFDQuery;
    oClick  : Procedure(Sender: TObject) of Object;
begin
    //dwMessage('LVMClick','',TForm(TEdit(Sender).Owner));
    //主表的单击事件。功能：
    //1 如果主表未满行，点击空行后，自动切到最末行
    //2 根据当前主表的记录位置，自动更新从表
    //取得各控件
    oLV     := TListView(Sender);
    oForm   := TForm(oLV.Owner);
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    //得到当前行
    iRow    := oLV.ItemFocused.Index;
    //更新数据表记录
    oQuery.RecNo    := iRow;
    oQuery.Tag      := iRow;    //保存位置备用
    //激活窗体的OnDockDrop事件，其中：X 为 0，表示为主表，iRow为记录号
    if Assigned(oForm.OnDockDrop) then begin
        oForm.OnDockDrop(oLV,nil,0,iRow);
    end;
end;



Procedure TMaChange(Self: TObject; Sender: TObject);
begin
    qmUpdateMain(TForm(TEdit(Sender).Owner),'');
end;

//取数据字段的值
function _GetFieldValue(AField:TField;AConfig:Variant):String;
var
    iTemp   : Integer;
    joField : Variant;
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

    //指定默认QuickCrud字段类型
    if not AConfig.Exists('type') then begin
        AConfig.type    := 'string';
    end;

    //
    if AConfig.type = 'integer' then begin
        Result  := IntToStr(AField.AsInteger);

    end else if AConfig.type = 'boolean' then begin   //布尔型
        //默认返回值
        Result  := AField.AsString;
        //
        if AConfig.Exists('list')  then begin
            if AConfig.list <> null then begin
                if AConfig.list._Count > 1 then begin
                    Result  := dwIIF(AField.AsBoolean,AConfig.list._(1),AConfig.list._(0));
                end;
            end;
        end;

    end else if AConfig.type = 'combopair' then begin   //“键-值”对
        joField := AConfig;
        Result  := AField.AsString;
        if AField.AsString <> '' then begin
            for iTemp := 0 to joField.list._Count - 1 do begin
                if joField.list._(iTemp)._(1) = AField.AsString then begin
                    Result  := joField.list._(iTemp)._(0);
                    break;
                end;
            end;
        end;

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
    end else if AConfig.type = 'time' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            Result  := FormatDatetime('hh:mm:ss',AField.AsDateTime);
        end;
    end else begin
        if AConfig.Exists('format') then begin
            if AConfig.format <> '' then begin
                Result  := Format(AConfig.format,[AField.AsString]);
            end else begin
                Result  := AField.AsString;
            end;
        end else begin
            Result  := AField.AsString;
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

//计算字段列表中在表格中显示的数量
function _GetViewFieldCount(AFields:Variant):Integer;
var
    iItem   : Integer;
begin
    Result  := 0;
    //
    for iItem := 0 to AFields._Count - 1 do begin
        if dwGetInt(AFields._(iItem),'view',0) = 0 then begin
            Inc(Result);
        end;
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

//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure _GetPageData(
        AQuery:TFDQuery;        //对应的ADOQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        APage:Integer;          //当前页码,从1开始
        ACount:Integer;         //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );
var
    bAccept     : Boolean;  //用于触发事件中的一个变量，此处无意义
    oForm       : TForm;
    iTable      : Integer;
begin

    //----求总数------------------------------------------------------------------------------------
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := -1;

    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Count(*) FROM '+ATable+' '+AWhere;
    AQuery.Open;

    //<触发事件
    oForm   := TForm(AQuery.Owner);     //取得主窗体
    bAccept := True;    //无意义的必须变量
    //取表序号，0表示主表，1~n依次表示各从表
    if AQuery.Name = 'FQ_Main' then begin
        iTable  := 0;
    end else begin
        iTable  := StrToIntDef(Copy(AQuery.Name,4,1),-1);
    end;
    if iTable <> -1 then begin
        if Assigned(oForm.OnDragOver) then begin
            oForm.OnDragOver(oForm,nil,iTable,5,dsDragEnter,bAccept);
        end;
    end;
    //>

    //记录总数
    ARecordCount    := AQuery.Fields[0].AsInteger;

    //如果超出最大页数,则为最大页数
    if APage > Ceil(ARecordCount / ACount) then begin
        APage   := Ceil(ARecordCount / ACount);
    end;

    //强制APage 从0开始
    APage   := Max(0,APage);

    //----更新当前页--------------------------------------------------------------------------------

    AQuery.Close;

    //<2023-04-13 改成的FireDAC的机制
    AQuery.SQL.Text := 'SELECT '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    AQuery.FetchOptions.RecsSkip    := APage * ACount;
    AQuery.FetchOptions.RecsMax     := ACount;
    //>

    //
    AQuery.Open;

end;

//从数据表中取数据，置入ListView中
function _GetDataToListView(
        AQuery      : TFDQuery;
        ALV         : TListView;
        ATrackBar   : TTrackBar;
        AConfig     : Variant       //包括以下信息：ATable,AFields,AWhere,AOrder:String;APage,ACount:Integer;
        ):Integer;
var
    oEvent          : Procedure(Sender:TObject) of Object;

    iRecordCount    : Integer;
    iRow,iCol       : Integer;
    iOldRecNo       : Integer;
    iItem           : Integer;
    iDec            : Integer;  //用于表示因为多选列生成的JSON字段和FDQuery字段序号之间的偏差
    iColDec         : Integer;  //用于控制ListView列序号和FDQuery字段序号之间的偏差
    //
    sTable          : String;   //数据表名
    sFields         : string;   //字段列表，如：id,name,age,remark
    sWhere          : string;   //过滤条件
    sOrder          : string;   //排序条件
    iPageNo         : Integer;  //页数,从0开始
    iPageSize       : Integer;  //每页条数
    iMode           : Byte;
    //
    oListItem       : TListItem;
begin
    if AConfig = unassigned then begin
        Result  := -1;
        Exit;
    end;

    //取得对应的参数设置
    sTable      := AConfig.table;       //表名
    sWhere      := AConfig.where;       //过滤条件
    sOrder      := AConfig.order;       //排序
    iPageNo     := AConfig.pageno;      //页码，从0始
    iPageSize   := AConfig.pagesize;    //每页行数
    sFields     := _GetFields(AConfig.fields,False);  //得到字段字符串列表

    //保存事件，并清空，以防止循环处理
    oEvent  := ATrackBar.OnChange;
    ATrackBar.OnChange  := nil;

    //保存原Recno
    iOldRecNo   := AQuery.RecNo;
    AQuery.DisableControls;

    //根据条件, 得出数据. 即根据条件，OPEN对应的FDQuery
    //完成两项；1 求出总记录条数；2 打开对应的FDQuery表
    _GetPageData(
        AQuery,
        sTable,
        sFields,
        sWhere,
        sOrder,
        iPageNo,
        iPageSize,
        iRecordCount);

    //设置分页控件值
    ATrackBar.Max       := iRecordCount;
    ATrackBar.PageSize  := iPageSize;

    //清空原ListView数据记录(主要防止数据记录未写满页面显示错误)
    ALV.Items.Clear;

    //如果超出最大页数,则为最大页数
    if iPageNo > Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize)) then begin
        iPageNo := Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize));
    end;

    //强制iPageNo 从0开始
    iPageNo := Max(0,iPageNo);

    //显示数据记录
    if not AQuery.IsEmpty then begin
        for iRow := 1 to AQuery.RecordCount do begin
            oListItem   := ALV.Items.Add;
            //
            iDec    := 0;
            iColDec := 0;
            for iItem := 0 to AConfig.fields._Count - 1 do begin
                //跳过多选列
                if AConfig.fields._(iItem).name =  '__SELECT__' then begin
                    iDec    := -1;
                    continue;
                end;

                //根据是否显示（view属性）进行处理
                iMode   := dwGetInt(AConfig.fields._(iItem),'view',0);
                case iMode of
                    0 : begin
                        if iItem+iColDec = 0 then begin
                            oListItem.Caption   := _GetFieldValue(AQuery.Fields[iItem+iDec],AConfig.fields._(iItem));
                        end else begin
                            oListItem.SubItems.Add(_GetFieldValue(AQuery.Fields[iItem+iDec],AConfig.fields._(iItem)));
                        end;
                    end;
                else
                    //每发现一个不在主表格中显示的字段，减1
                    Dec(iColDec);
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

    //恢复原Recno
    AQuery.RecNo    := iOldRecNo;
    AQuery.EnableControls;


end;


procedure qmUpdateMain(AForm:TForm;AWhere:String);
var
    iField      : Integer;
    iItem       : Integer;
    iList       : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    sText       : String;
    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    joStyleName : Variant;
    //
    oFDQuery    : TFDQuery;
    oTMa        : TTrackBar;
    oLVM        : TListView;
    oEKw        : TEdit;
    oFQy        : TFlowPanel;
    oPQF        : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCBQy       : TComboBox;
    oBFz        : TButton;
    oBQy        : TButton;
begin
    //取得配置JSON
    joConfig    := qmGetConfigJson(AForm);

    //取得字段名称列表，备用，返回值为sFields, 如：id,Name,age
    sFields     := _GetFields(joConfig.fields,False);

    //取得各控件备用
    oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));    //主表数据库
    oEKw        := TEdit(AForm.FindComponent('EKw'));           //查询关键字
    oLVM        := TListView(AForm.FindComponent('LVM'));     //主表显示ListView
    oTMa        := TTrackBar(AForm.FindComponent('TMa'));       //主表分页
    oBFz        := TButton(AForm.FindComponent('BFz'));         //模糊/精确匹配 切换按钮
    oBQy        := TButton(AForm.FindComponent('BQy'));         //查询按钮
    oFQy        := TFlowPanel(AForm.FindComponent('FQy'));      //分字段查询字段的流式布局容器面板

    //数据库类型
    if not joConfig.Exists('database') then begin
        joConfig.database   := lowerCase(oFDQuery.Connection.DriverName); //'access';
        qmSetConfig(AForm,joConfig);
    end;


    //从智能模糊查询框的关键字中生成查询字符串
    //返回值为 ' WHERE (1=1) ' 或
    //         ' WHERE ((....) oR (...))'
    sWhere  := _GetWhere(sFields, oEKw.Text);

    //添加固定的where
    if joConfig.where <> '' then begin
        Delete(sWhere,1,Length(' WHERE'));
        sWhere  := ' WHERE (('+joConfig.where+') and ' + sWhere+')';
    end;

    //AWhere 额外的 WHERE 条件(从外部调用dwUpdateMain函数)
    if AWhere <> '' then begin
        sWhere  := sWhere + ' and '+AWhere;
    end;

    //
    joStyleName := _json(oLVM.StyleName);

    //表格筛选中的条件
    if dwGetStr(joStyleName,'filter','') <> '' then begin
        sWhere  := sWhere + ' and '+joStyleName.filter;
    end;

    //生成配置信息
    joDBConfig  := _json('{}');
    joDBConfig.table        := joConfig.table;
    joDBConfig.where        := sWhere;
    joDBConfig.order        := dwGetStr(joStyleName,'sort','');
    joDBConfig.pageno       := oTMa.Position;
    joDBConfig.pagesize     := joConfig.pagesize;
    joDBConfig.fields       := _json(joConfig.fields);

    //从数据表中取数据，置入ListView
    _GetDataToListView(
            oFDQuery,           //AQuery:TFDQuery;
            oLVM,               //oLVM:TListView;
            oTMa,               //ATrackBar:TTrackBar
            joDBConfig
            );

    //
    oTMa.Visible    := (oTMa.Max / oTMa.PageSize) > 1;

    //
    //oLVM.Row    := oFDQuery.RecNo;
    //dwRunJS('this.$refs.'+dwFullName(oLVM)+'.bodyWrapper.scrollTop = 0;',AForm);
end;




procedure qmCreateConfirmPanel(AForm:TForm);
var
    oPDe   : TPanel;
    oLCF  : TLabel;
    oBDO      : TButton;
    oBDC  : TButton;
    //用于指定事件
    tM          : TMethod;
begin
    oPDe   := TPanel.Create(AForm);
    with oPDe do begin
        Name        := 'PDe';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        //BorderStyle := bsSingle;
        Top         := 150;
        Width       := 340;
        Height      := 200;
        Hint        := '{"radius":"10px"}';
        Font.Color  := $323232;
    end;
    //
    oLCF  := TLabel.Create(AForm);
    with oLCF do begin
        Name        := 'LCF';
        Parent      := oPDe;
        AutoSize    := False;
        Alignment   := taCenter;
        Top         := 10;
        Left        := 10;
        Width       := 320;
        Height      := 130;
        Caption     := 'Are you sure ?';
        Layout      := tlCenter;
    end;
    //
    oBDO  := TButton.Create(AForm);
    with oBDO do begin
        Name        := 'BDO';
        Parent      := oPDe;
        Top         := 140;
        Left        := 170;
        Width       := 170;
        Height      := 60;
        Caption     := '确定';
        Font.Size   := 14;
        Hint        := '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border-right:0px;","radius":"0px"}';
        //
        tM.Code         := @BDOClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //
    oBDC  := TButton.Create(AForm);
    with oBDC do begin
        Name        := 'BDC';
        Parent      := oPDe;
        Top         := 140;
        Left        := 0;
        Width       := 170;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '取消';
        Hint        := '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":"0px"}';
        //
        tM.Code         := @BDCClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
end;

procedure qmCreateField(AForm:TForm;AWidth:Integer;ASuffix:String;AConfig,AField:Variant;AP_Content:TFlowPanel);
var
    ooP         : TPanel;
    ooL         : TLabel;
    ooE         : TEdit;
    ooM         : TMemo;
    ooDT        : TDateTimePicker;
    ooCB        : TComboBox;
    oQueryTmp   : TFDQuery;
    //
    iItem       : Integer;
    //
    joList      : Variant;
    joItems     : Variant;
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
        //Align       := alTop;
        AutoSize    := False;
        Height      := 46;
        //Left        := ALeft;
        //Top         := ATop;
        Width       := AWidth;
        Color       := clNone;
        Font.Size   := 11;
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
        Margins.Top     := 0;
        Margins.Left    := 10;
        Margins.Right   := 15;
        Layout          := tlCenter;
        if dwGetInt(AField,'must',0) = 1 then begin
            Caption     := '*&nbsp;'+StringReplace(AField.caption,'\n','',[rfReplaceAll]);
            //Font.Color  := clRed;
        end else begin
            Caption     := StringReplace(AField.caption,'\n','',[rfReplaceAll]);
        end;
    end;

    //各字段编辑控件
    if AField.type = 'boolean' then begin //自带选项的类型，选项在list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            if AField.Exists('list') then begin
                if AField.list <> null then begin
                    joList  := AField.list;
                    //添加选项
                    for iItem := 0 to Min(1,joList._Count-1) do begin
                        Items.Add(joList._(iItem));
                    end;
                end;
            end else begin
                Items.Add('False');
                Items.Add('True');
            end;
        end;
    end else if AField.type = 'combo' then begin //自带选项的类型，选项在list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            if AField.Exists('list') then begin
                if AField.list <> null then begin
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
            end else begin
                Items.Add('');
            end;
        end;
    end else if AField.type = 'combopair' then begin //自带选项pair的类型，选项在二维数组list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            if AField.Exists('list') then begin
                if AField.list <> null then begin
                    joList  := AField.list;
                    //默认添加一个空值
                    if joList._Count > 0 then begin
                        if joList._(0)._(0) <> '' then begin
                            Items.Add('');
                        end;
                    end;
                    //添加选项
                    for iItem := 0 to joList._Count-1 do begin
                        Items.Add(joList._(iItem)._(0));
                    end;
                end else begin
                    Items.Add('');
                end;
            end else begin
                Items.Add('');
            end;
        end;
    end else if AField.type = 'dbcombo' then begin  //从数据库内读数据的选项类型，由joConfig.table表中joField.name取值
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            Items.Add('');

            //指定table
            if not AField.Exists('table') then begin
                AField.table    := AConfig.table;
            end;

            //指定字段field
            if not AField.Exists('field') then begin
                AField.field    := AField.name;
            end;

            //添加数据库内的值
            joItems := _GetItems(oQueryTmp,AField.table,AField.field);
            for iItem := 0 to joItems._Count-1 do begin
                Items.Add(joItems._(iItem));
            end;
        end;
    end else if AField.type = 'integer' then begin  //整型
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
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
            Name            := 'F'+ASuffix;
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
            Name            := 'F'+ASuffix;
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
            Name            := 'F'+ASuffix;
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
            Name            := 'F'+ASuffix;
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
    end else if AField.type = 'memo' then begin
        ooM := TMemo.Create(AForm);
        with ooM do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":""}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;

            //设置高度(仅memo类型)
            if AField.Exists('height') then begin
                ooP.Height  := AField.height;
            end;
        end;
    end else if AField.type = 'tree' then begin
        //
        ooP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"","options":"'+AField.options+'"}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;
    end else if AField.type = 'dbtree' then begin
        //
        ooP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"","options":"'+qmDbToOptions(oQueryTmp,AField,dwGetInt(AField,'treemode',0))+'"}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;
    end else begin
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
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

function  qmCreateFieldQuery(AForm:TForm;AField:Variant;AIndex:Integer;ASuffix:String;AFlowPanel:TFlowPanel):Integer;
var
    oPQF        : TPanel;
    oL_Query    : TLabel;
    oCBQy       : TComboBox;
    oP_DateSE   : TPanel;
    oDT_Start   : TDateTimePicker;
    oL_Space    : TLabel;
    oDT_End     : TDateTimePicker;
    oE_Query    : TEdit;
    //
    oQueryTmp   : TFDQuery;
    //
    iItem       : Integer;
    //
    joItems     : Variant;
    joConfig    : Variant;
    //
    sTable      : String;
    sTemp       : String;
begin
    //取得配置JSON对象
    joConfig    := qmGetConfigJson(AForm);

    //取到临时查询
    oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

    //创建一个单字段查询面板
    oPQF := TPanel.Create(AForm);
    with oPQF do begin
        Name            := 'PQ'+ASuffix;
        Parent          := AFlowPanel;
        Color           := clNone;
        Width           := joConfig.editwidth - 15 ;
        Height          := 45;
        Tag             := AIndex;
    end;

    //创建查询字段标签
    oL_Query    := TLabel.Create(AForm);
    with oL_Query do begin
        Name            := 'LF'+ASuffix;
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
        Margins.Bottom  := 7;
    end;

    //
    if AField.type = 'boolean' then begin
        //创建查询字段combo
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            Style           := csDropDownList;
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

            //默认添加一个空值
            Items.Add('');
            Items.Add('false');
            Items.Add('true');

            //
            if AField.Exists('list') then begin
                if AField.list<> null then begin
                    if AField.list._Count > 1 then begin
                        Items.Clear;
                        Items.Add('');
                        for iItem := 0 to 1 do begin
                            Items.Add(AField.list._(iItem));
                        end;
                    end;
                end;
            end;

            //设置默认查询值
            ItemIndex   := Items.IndexOf(dwGetStr(AField,'defaultqv',''));
        end;
    end else if AField.type = 'combo' then begin
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            //Style           := csDropDownList;
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

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

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end else if AField.type = 'combopair' then begin
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            //Style           := csDropDownList;
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

            //默认添加一个空值
            if AField.list._Count > 0 then begin
                if AField.list._(0)._(0) <> '' then begin
                    Items.Add('');
                end;
            end;
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(0));
            end;

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end else if AField.type = 'dbcombo' then begin
        //创建数据库查询ComboBox
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            //Style           := csDropDownList;
            Text            := '';
            Align           := alClient;
            //
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            //先添加一个空值
            oCBQy.Items.Add('');
            //添加数据库内的值
            joItems := _GetItems(oQueryTmp,joConfig.table,AField.name);
            for iItem := 0 to joItems._Count-1 do begin
                oCBQy.Items.Add(joItems._(iItem));
            end;

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end else if AField.type = 'date' then begin
        //创建面板存放起始结束日期
        oP_DateSE := TPanel.Create(AForm);
        with oP_DateSE do begin
            Name            := 'PDE'+ASuffix;
            Parent          := oPQF;
            Color           := clNone;
            Align           := alClient;
            Tag             := AIndex;
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
            //
            AlignWithMargins:= True;
            Margins.Top     := 4;
            Margins.Bottom  := 8;
            Margins.Right   := 0;
        end;

        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(AForm);
        with oDT_Start do begin
            Name        := 'DS'+ASuffix;
            Parent      := oP_DateSE;
            Align       := alLeft;
            Align       := alNone;
            Left        := -25;
            Tag         := AIndex;
            Top         := 1;
            Width       := 135;
            Height      := 28;
            DoubleBuffered  := True;
            if AField.Exists('min') then begin
                Date    := StrToDateDef(AField.min,Now);
            end else begin
                Date    := _GetQueryStartDate(dwGetStr(AField,'defaultqv',''));
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

        //起止日期间分隔符
        oL_Space    := TLabel.Create(AForm);
        with oL_Space do begin
            Name        := 'LS'+ASuffix;
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
            Hint        := '{"dwstyle":"z-index: 1;"}'
        end;

        //创建查询结束日期
        oDT_End   := TDateTimePicker.Create(AForm);
        with oDT_End do begin
            Parent      := oP_DateSE;
            Name        := 'DE'+ASuffix;
            Tag         := AIndex;
            Left        := 80;
            Top         := 1;
            Width       := 135;
            Height      := 28;
            DoubleBuffered  := True;
            if AField.Exists('max') then begin
                Date    := StrToDateDef(AField.max,Now);
            end else begin
                Date    := _GetQueryEndDate(dwGetStr(AField,'defaultqv',''));
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

    end else if AField.type = 'datetime' then begin    //=======================

        //<-----创建起始日期时间
        //设置默认值
        if not AField.Exists('min') then begin
            AField.min := '2000-01-01 00:00:00'
        end;
        //更新标签
        oL_Query.Caption    := AField.caption + '>=';
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(AForm);
        with oDT_Start do begin
            Name            := 'DS'+ASuffix;
            Parent          := oPQF;
            Align           := alClient;
            DoubleBuffered  := True;    //用作：日期+时间型
            Kind            := dtkTime;
            Format          := 'yyyy-MM-dd HH:mm:ss';
            Tag             := AIndex;
            Height          := 28;
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
        oPQF := TPanel.Create(AForm);
        with oPQF do begin
            Name            := 'PDT'+ASuffix;
            Parent          := AFlowPanel;
            Color           := clNone;
            Width           := 335;
            Height          := 40;
            Tag             := AIndex;
        end;
        //创建查询字段标签
        oL_Query    := TLabel.Create(AForm);
        with oL_Query do begin
            Name                := 'LQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alLeft;
            Layout              := tlCenter;
            Caption             := AField.caption + '<=';
            Alignment           := taRightJustify;
            Width               := 80;
            //
            AlignWithMargins    := True;
            Margins.Left        := 10;
        end;
        //

        //创建查询结束日期
        oDT_End := TDateTimePicker.Create(AForm);
        with oDT_End do begin
            Name                := 'DE'+ASuffix;
            Parent              := oPQF;
            Align               := alClient;
            DoubleBuffered      := True;    //用作：日期+时间型
            Kind                := dtkTime;
            Format              := 'yyyy-MM-dd HH:mm:ss';
            Tag                 := AIndex;
            Height              := 28;
            HelpContext         := -1;  //标记为结束时间
            Date                := StrToDateDef(Copy(AField.max,1,10),Now);
            Time                := StrToTimeDef(Copy(AField.max,12,8),Now);
            Hint                := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;
        //----->
    end else begin
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(AForm);
        with oE_Query do begin
            Name                := 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end;

end;


procedure qmCreateEditorPanel(AForm:TForm);
var
    oPEr        : TPanel;       //编辑/新增 总Panel
    oPET        : TPanel;       //顶部Panel, 用于放置：标题、最大化、关闭
    oBEL        : TButton;      //标题
    oBEM        : TButton;      //最大化
    oBEC        : TButton;      //关闭
    oPES        : TPanel;       //底部按钮Panel, 放置：取消，确定
    oBEK        : TButton;      //确定按钮
    oBEA        : TButton;      //取消按钮
    oSB         : TScrollBox;   //滚动框，以放置更多字段编辑信息
    oFC         : TFlowPanel;   //多字段编辑信息的容器
    oCK_Batch   : TCheckBox;    //批量新增checkbox
    //
    iField      : Integer;
    iMode       : Byte;
    //
    joConfig    : Variant;
    joField     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //取得配置JSON
    joConfig    := qmGetConfigJson(AForm);
    //检查editwidth编辑面板宽度是否存在，默认为340
    if not joConfig.Exists('editwidth') then begin
        joConfig.editwidth  := 340;
    end;

    //检查editcolcount编辑面板中列数是否存在，默认为1
    if not joConfig.Exists('editcolcount') then begin
        joConfig.editcolcount  := 1;
    end;

    //编辑/新增的总面板
    oPEr   := TPanel.Create(AForm);
    with oPEr do begin
        Name        := 'PEr';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Anchors     := [akBottom,akTop];
        Font.Size   := 14;
        Top         := 100;
        Height      := AForm.Height - 200;
        Hint        := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
        Font.Color  := $323232;
        Color       := clWhite;
        Width       := Min(AForm.width-20,joConfig.editwidth);
    end;

    //标题 Panel
    oPET  := TPanel.Create(AForm);
    with oPET do begin
        Name        := 'PET';
        Parent      := oPEr;
        Align       := alTop;
        Height      := 50;
        Font.Size   := 17;
        Color       := clWhite;
        //
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //标题 Button
    oBEL  := TButton.Create(AForm);
    with oBEL do begin
        Name        := 'BEL';
        Parent      := oPET;
        Align       := alLeft;
        Width       := 60;
        Caption     := '新  增';
        Font.Size   := 15;
        Hint        := '{"dwstyle":"background:#fff;text-align:left;border:0;"}';
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
    end;

    //最大化 Button
    oBEM  := TButton.Create(AForm);
    with oBEM do begin
        Name        := 'BEM';
        Parent      := oPET;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        //
        AlignWithMargins:= True;
        Margins.Right   := 0;
        //
        tM.Code         := @BEMClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);

        //
        if joConfig.defaulteditmax = 1 then begin
            Tag := 9;
        end;
    end;

    //关闭 Button
    oBEC  := TButton.Create(AForm);
    with oBEC do begin
        Name        := 'BEC';
        Parent      := oPET;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-close"}';
        //
        AlignWithMargins:= True;
        Margins.Right    := 10;
        //
        tM.Code         := @BEAClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //用于放置 OK/Cancel 的Panel
    oPES   := TPanel.Create(AForm);
    with oPES do begin
        Name        := 'PES';
        Parent      := oPEr;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alBottom;
        Height      := 50;
        Color       := clNone;
    end;

    //
    oBEK  := TButton.Create(AForm);
    with oBEK do begin
        Name        := 'BEK';
        Parent      := oPES;
        Align       := alRight;
        Width       := 80;
        Top         := 0;
        Left        := 0;
        Height      := 60;
        Font.Size   := 13;
        Caption     := '确定';
        Hint        := '{"type":"primary"}';
        //
        AlignWithMargins:= True;
        Margins.right   := 20;
        Margins.Bottom  := 19;
        //
        tM.Code         := @BEKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oBEA  := TButton.Create(AForm);
    with oBEA do begin
        Name        := 'BEA';
        Parent      := oPES;
        Align       := alRight;
        Top         := 0;
        Left        := 0;
        Width       := oBEK.Width;

        Height      := 60;
        Font.Size   := 13;
        Caption     := '取消';
        Hint        := '';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        Margins.Bottom  := 19;
        //
        tM.Code         := @BEAClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //批量新增 checkbox
    oCK_Batch   := TCheckBox.Create(AForm);
    with oCK_Batch do begin
        Name        := 'CKB';
        Parent      := oPEr;
        Align       := alBottom;
        Height      := 30;
        Caption     := '批量处理';
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //主表编辑的ScrollBox
    oSB := TScrollBox.Create(AForm);
    with oSB do begin
        Name        := 'SB0';
        Parent      := oPEr;
        Align       := alClient;
    end;

    //主表ScrollBox的内容Panel
    oFC   := TFlowPanel.Create(AForm);
    with oFC do begin
        Name        := 'FC0';
        Parent      := oSB;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alTop;
        Color       := clWhite;
        Hint        := '{"dwstyle":"overflow:visible;"}';   //设置以显示Edit__tree下拉框
    end;

    //创建主表各字段的编辑框
    for iField := 0 to joConfig.fields._Count-1 do begin

        //取得主表字段的JSON对象
        joField := joConfig.fields._(iField);

        //不显示多选列字段
        if joField.name = '__SELECT__' then begin
            Continue;
        end;

        //创建控件
        iMode   := dwGetInt(joField,'view',0);  //显示模式，0：全部显示，1：仅新增/编辑时显示，2：全不显示
        case iMode of
            0,1 : begin
                qmCreateField(
                        AForm,
                        joConfig.editwidth,//(oPEr.Width div iEditColCnt)-20,   //width
                        '0'+IntToStr(iField),   //后缀名，用于区分多个控件
                        joConfig,
                        joField,    //字段的JSON对象
                        oFC  //父panel
                        );
            end;
        end;
    end;
    oFC.AutoSize := True;

end;


//quickcrud布局函数
function qmCrud(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwGetEditMask = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
var
    joConfig    : variant;
    //
    sFields     : String;
    //
    oPDL        : TPanel;       //panel download  用于下载的控件
    //
    oPQC        : TPanel;
    oPMn        : TPanel;
    oPSv        : TPanel;
    oPQy        : TPanel;       //分字段查询面板 : PQy
    oFQy        : TFlowPanel;   //用于多字段查询的流式布局面板
    oPQF        : TPanel;       //单独字段查询面板 : PQ0, PQ1,...
    oPQm        : TPanel;       //智能模糊查询面板 : PQm
    oPMd        : TPanel;
    oPBs        : TPanel;       //功能按钮面板 : PBs
    oBQm        : TButton;      //切换查询模式的按钮 ： BQm
    oBFz        : TButton;      //切换查询模式的按钮 ： BFz 模糊/精确
    oBQy        : TButton;      //查询按钮
    oBQR        : TButton;      //重置按钮
    //
    oBNw        : TButton;      //主表新增
    oBEt        : TButton;      //主表编辑
    oBDe        : TButton;      //主表删除
    oBHd        : TButton;      //主表隐藏
    oBEx        : TButton;      //导出到Excel按钮
    //
    oEKw        : TEdit;
    oPTM        : TPanel;       //TMa外部加一个面板，以放置 每页行数 框
    oTMa        : TTrackBar;

    //从表增删改查
    oPSB        : TPanel;
    oBSN        : TButton;
    oBSD        : TButton;
    oBSE        : TButton;
    oBSQ        : TButton;

    //
    oFQ_Main    : TFDQuery;
    //
    oPEr        : TPanel;
    oPES        : TPanel;
    oB_Cancel   : TButton;
    oB_OK       : TButton;
    oSBDemo     : TScrollBox;
    oP_Content  : TPanel;
    //
    oP_string   : TPanel;
    oL_String   : TLabel;
    oE_String   : TEdit;
    //
    oP_combo    : TPanel;
    oL_Combo    : TLabel;
    oCB_Combo   : TComboBox;
    //
    oP_Integer  : TPanel;
    oL_Integer  : TLabel;
    oSE_Integer : TSpinEdit;
    //
    oP_Date     : TPanel;
    oL_Date     : TLabel;
    oDT_Date    : TDateTimePicker;
    //
    oP_Boolean  : TPanel;
    oL_Boolean  : TLabel;
    oTS_Boolean : TToggleSwitch;
    //
    oP_Group    : TPanel;
    oL_Group    : TLabel;
    //
    oPET        : TPanel;
    oL_ETitle   : TLabel;
    //
    oLVM        : TListView;    //显示表
    //
    tM          : TMethod;      //用于指定事件
    //
    joField     : variant;
    joHint      : variant;
    joCell      : variant;
    joItems     : Variant;      //用于生成combo的items
    //
    iField      : Integer;
    iCount      : Integer;
    iTop        : Integer;
    iCol        : Integer;
    iLeft       : Integer;
    iItem       : Integer;
    iDec        : Integer;
    iMode       : Byte;         //字段的模式，0：正常（默认），1：表格中不显示，新增/编辑时显示；2：仅FDQuery读取， 表格/新增/编辑均不显示
    //
    oTab        : TTabSheet;
    oFDQuery    : TFDQuery;
    oTB         : TTrackBar;
    oLV         : TListView;
    oSB         : TScrollBox;
    oP          : TPanel;
    oQueryTmp   : TFDQuery;     //用于生成combo的临时性FDQuery
    //
    oL_Query    : TLabel;   //查询用标签
    oE_Query    : TEdit;    //查询用Edit
    oCBQy       : TComboBox;//查询
    oP_DateSE   : TPanel;               //存放起始结束日期框
    oDT_Start   : TDateTimePicker;      //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;      //结束日期，DateTimePicker_End
    oL_Space    : TLabel;   //起止日期间 分隔符
    //
    oPanel      : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;

    procedure _SetCaption(ALabel:TLabel);
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

    try
        //先检查PQC是否存在，防止重复创建
        if AForm.FindComponent('PQC') <> nil then begin
            Result  := -200;
            dwMessage('Error when quickcrud : '+IntToStr(Result),'error',AForm);
            Exit;
        end;

        //取配置JSON : 读AForm的 qmConfig 变量值
        joConfig    := qmGetConfigJson(AForm);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Result  := -201;
            dwMessage('Error when quickcrud : '+IntToStr(Result),'error',AForm);
            Exit;
        end;

        //得到字段名列表
        sFields := _GetFields(joConfig.fields,False);

        //打开表
        oQueryTmp       := TFDQuery(AForm.FindComponent('FDQueryTmp'));

        //生成一个临时查询
        if oQueryTmp = nil then begin
            oQueryTmp               := TFDQuery.Create(AForm);
            oQueryTmp.Name          := 'FDQueryTmp';
            oQueryTmp.Connection    := AConnection;
        end;

        oQueryTmp.Close;
        oQueryTmp.SQL.Text  := 'SELECT ' + sFields + ' FROM ' + joConfig.table + ' WHERE 1=0'; // 打开一个空查询
        oQueryTmp.Open;

        //设置每个字段的DataType
        iDec    := 0;
        for iField := 0 to joConfig.fields._Count - 1 do begin
            joField := joConfig.fields._(iField);
            if joField.name = '__SELECT__' then begin
                iDec    := -1;
                Continue;
            end;

            //
            joField.datatype := oQueryTmp.Fields[iField+iDec].DataType;
        end;

        //反写回Form1.qcConfig变量
        qmSetConfig(AForm,joConfig);

        //几个主要面板：主面板，主表面板和从表面板  ====================================================
        //总面板
        oPQC    := TPanel.Create(AForm);
        with oPQC do begin
            Parent          := AForm;
            Name            := 'PQC';
            BevelOuter      := bvNone;
            Align           := alClient;
            Color           := clNone;
            Hint            := '{"dwstyle":"overflow-y:auto;"}'
        end;
        //主表面板
        oPMn    := TPanel.Create(AForm);
        with oPMn do begin
            Parent          := oPQC;
            Name            := 'PMn';
            BevelOuter      := bvNone;
            Color           := clNone;
            Align           := alClient;
        end;

        //智能查询面板 PQm ====================================================================
        oPQm := TPanel.Create(AForm);
        with oPQm do begin
            Parent          := oPMn;
            Name            := 'PQm';
            Align           := alTop;
            Height          := 50;
            Color           := clWhite;
            //
            Visible         := iCount = 0;
        end;

        //智能查询EKw
        oEKw  := TEdit.Create(AForm);
        with oEKw do begin
            Parent          := oPQm;
            Name            := 'EKw';
            Align           := alClient;
            Color           := clBtnFace;
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Bottom  := 10;
            Margins.Left    := 17;
            Margins.Right   := 27;
            Margins.Top     := 6;
            Hint            := '{"placeholder":"请输入查询关键字","suffix-icon":"el-icon-search",'
                    +'"dwstyle":"padding-left:10px;border-radius:15px;border:0;"}';
            //
            tM.Code         := @EKwChange;
            tM.Data         := Pointer(325); // 随便取的数
            OnChange        := TNotifyEvent(tM);
        end;

        //主数据面板 PMd - Panel Main Data
        oPMd  := TPanel.Create(AForm);
        with oPMd do begin
            Parent          := oPMn;
            Name            := 'PMd';
            Font.Size       := 11;
            //
            Align           := alClient;
            Top             := 2000;
            Height          := 45 + joConfig.cardheight * ( 1 + joConfig.pagesize )+1 + 45;  //高度
            //
            Color           := clWhite;
        end;

    except
        //异常时调试使用
        Result  := -1;
    end;

    if Result = 0 then begin
        try

            //主显示               =====================================================================================
            oLVM    := TListView.Create(AForm);
            with oLVM do begin
                Parent      := oPMd;
                Name        := 'LVM';
                HelpKeyword := 'card';

                //
                Hint        := '{"cardstyle":"'+joConfig.cardstyle+'"}';

                //默认排序
                if joConfig.Exists('defaultorder') then begin
                    StyleName   := joConfig.defaultorder;
                end;

                //
                Color           := clWhite;
                //
                Align           := alClient;
                Height          := joConfig.cardheight * ( 1 + joConfig.pagesize )+1;  //高度
                HelpContext     := joConfig.cardheight;  //将当前高度保存在helpcontext中

                //
                //Font.Color      := $00969696;

                //////
                //tM.Code         := @LVMClick;
                //tM.Data         := Pointer(325); // 随便取的数
                //OnClick         := TNotifyEvent(tM);
                //
                //
                //tM.Code         := @LVMGetEditMask;
                //tM.Data         := Pointer(325); // 随便取的数
                //OnGetEditMask   := TdwGetEditMask(tM);
            end;

            //主表分页(外框) ===============================================================================
            oPTM    := TPanel.Create(AForm);
            with oPTM do begin
                Parent          := oPMd;
                Name            := 'PTM';
                Color           := clWhite;
                //
                Align           := alBottom;
                Height          := 40;  //高度
                //
                AlignWithMargins:= False;
                Margins.Top     := 0;
                Margins.Bottom  := 10;
                Margins.Left    := 10;
                Margins.Right   := 10;
            end;

            //主表分页
            oTMa    := TTrackBar.Create(AForm);
            with oTMa do begin
                Parent          := oPTM;
                Name            := 'TMa';
                Align           := alClient;
                HelpKeyword     := 'page';
                Max             := 0;
                PageSize        := 10;
                if Width >= 480 then begin
                    Hint            := '{"dwattr":"background"}';
                end else begin
                    Hint            := '{"dwattr":"background layout=\"prev, pager, next, ->, total\""}';
                end;
                //
                AlignWithMargins:= True;
                //
                tM.Code         := @TMaChange;
                tM.Data         := Pointer(325); // 随便取的数
                OnChange        := TNotifyEvent(tM);
            end;
        except
            //异常时调试使用
            Result  := -2;
        end;
    end;


    if Result = 0 then begin
        try

            //----------------------------------------------------------------------------------------------
            //配置 oFQ_Main 的连接
            oFQ_Main            := TFDQuery.Create(AForm);
            oFQ_Main.Name       := 'FQ_Main';
            oFQ_Main.Connection := AConnection;

            //<得到Hint的JSON对象（以更新cardheight、dataset）
            joHint  := _json(oLVM.Hint);
            if joHint = unassigned then begin
                joHint  := _json('{}');
            end;
            //行高
            joHint.cardheight    := joConfig.cardheight;
            //
            joHint.dataset      := 'FQ_Main';
            //返写到Hint中
            oLVM.Hint := joHint;
            //>
            //<-----根据配置信息更新LVM
            //oLVM.RowCount        := joConfig.pagesize + 1;  //行数
            //oLVM.Defaultcardheight:= joConfig.cardheight;     //行高
            //oLVM.ColCount        := _GetViewFieldCount(joConfig.fields); //列数
            //oLVM.FixedCols       := 0;                       //固定列数

            //配置各列参数
            iCol    := 0;
            for iField := 0 to joConfig.fields._count - 1 do begin
                //得到字段对象
                joField := joConfig.fields._(iField);

                //字段显示模式，0；全显，1：仅新增/编辑显，2：全不显
                iMode   := dwGetInt(joField,'view',0);
                case iMode of
                    0 : begin
                        //生成各列参数配置的JSON字符串
                        joCell              := _json(VariantSaveJson(joField));

                        //粗体
                        if dwGetInt(joCell,'bold',0) = 1 then begin
                            joCell.fontbold := 'bold';
                        end else begin
                            joCell.fontbold := 'normal';
                        end;
                        //斜体
                        if dwGetInt(joCell,'italic',0) = 1 then begin
                            joCell.fontitalic := 'italic';
                        end else begin
                            joCell.fontitalic := '';
                        end;

                        //fontdecoration
                        if dwGetInt(joCell,'underline',0) = 1 then begin
                            joCell.fontdecoration   :='underline';
                            //删除线
                            if dwGetInt(joCell,'strike',0) = 1 then begin
                                joCell.fontdecoration   := 'line-through double';
                            end;
                        end else begin
                            //删除线
                            if dwGetInt(joCell,'strike',0) = 1 then begin
                                joCell.fontdecoration   := 'line-through';
                            end else begin
                                joCell.fontdecoration   := 'none';
                            end;
                        end;


                        //


                        //将列配置赋给ListView, 具体根据配置转化为相关显示表格在dwTListView.dpr中实现
                        with oLVM.Columns.Add do begin
                            Caption     := joCell;
                            //对齐
                            if joField.align = 'right' then begin
                                Alignment   := taRightJustify;
                            end else if joField.align = 'center' then begin
                                Alignment   := taCenter;
                            end else begin
                                Alignment   := taLeftJustify;
                            end;
                        end;

                        //
                        Inc(iCol);
                    end;
                end;
            end;
            //>

            //更新页码
            oTMa.Position    := 0;
        except

            //异常时调试使用
            Result  := -4;
        end;
    end;


    if Result = 0 then begin
        try
            //更新数据
            qmUpdateMain(AForm,'');
        except

            //异常时调试使用
            Result  := -6;
        end;
    end;

    if Result = 0 then begin
        try
            //创建确定面板P_Confirm
            qmCreateConfirmPanel(AForm);

        except

            //异常时调试使用
            Result  := -8;
        end;
    end;

    if Result = 0 then begin
        try
            //创建编辑面板PEr
            qmCreateEditorPanel(AForm);

        except

            //异常时调试使用
            Result  := -9;
        end;
    end;

    //
    if Result <> 0 then begin
        dwMessage('Error when quickcrud : '+IntToStr(Result),'error',AForm);
    end;
end;

//销毁dwCrud，以便二次创建
function  qmCrudDestroy(AForm:TForm):Integer;
var
    joConfig    : Variant;
    oPanel      : TPanel;
    oFDQuery    : TFDQuery;
begin
    try
        //取配置JSON : 读AForm的 qmConfig 变量值
        joConfig    := qmGetConfigJson(AForm);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //销毁编辑面板
        oPanel  := TPanel(AForm.FindComponent('PEr'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁删除面板
        oPanel  := TPanel(AForm.FindComponent('PDe'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁Query面板
        oPanel  := TPanel(AForm.FindComponent('PQy'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁主表板
        oPanel  := TPanel(AForm.FindComponent('PQC'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁临时表
        oFDQuery    := TFDQuery(AForm.FindComponent('FDQueryTmp'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

        //销毁主表
        oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

    except

    end;
end;


end.
