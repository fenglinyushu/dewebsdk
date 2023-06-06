unit dwQuickCrud;

interface

uses

    //
    dwBase,
    dwAccess,

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
    Math,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;


//一键生成CRUD模块
function  dwCrud(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
procedure _UpdateMain(AForm:TForm);
procedure _UpdateSlaves(AForm:TForm);

//取QuickCrud模块的 FDQuery 控件，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function dwGetQuickCrudFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;

//取QuickCrud模块的 StringGrid 控件，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function dwGetQuickCrudStringGrid(AForm:TForm;AIndex:Integer):TStringGrid;

//取QuickCrud模块的SQL语句，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function  dwGetQuickCrudSQL(AForm:TForm;AIndex:Integer):String;

implementation

function dwGetQuickCrudFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;
begin
    if AIndex = 0 then begin
        Result  := TFDQuery(AForm.FindComponent('FQ_Main'));
    end else begin
        Result  := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(AIndex-1)));
    end;
end;

function dwGetQuickCrudStringGrid(AForm:TForm;AIndex:Integer):TStringGrid;
begin
    if AIndex = 0 then begin
        Result  := TStringGrid(AForm.FindComponent('SG_Main'));
    end else begin
        Result  := TStringGrid(AForm.FindComponent('SG_'+IntToStr(AIndex-1)));
    end;
end;


//通过rtti为form的 qcConfig 变量 赋值
function dwSetConfig(AForm:TForm;AConfig:String):Integer;
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

//通过rtti读form的 qcConfig 变量
function dwGetConfig(AForm:TForm):String;
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

function dwGetConfigJson(AForm:TForm):Variant;
begin
    //取配置JSON : 读AForm的 qcConfig 变量值
    Result  := _json(dwGetConfig(AForm));

    //如果不是JSON格式，则退出
    if Result = unassigned then begin
        Exit;
    end;

    //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
    if not Result.Exists('table') then begin //默认表名
        Result.table := 'dw_member';
    end;
    if not Result.Exists('pagesize') then begin  //默认数据每页显示的行数
        Result.pagesize  := 5;
    end;
    if not Result.Exists('rowheight') then begin //默认数据行的行高
        Result.rowheight  := 45;
    end;
    if not Result.Exists('edit') then begin      //默认显示编辑按钮
        Result.edit  := 1;
    end;
    if not Result.Exists('new') then begin       //默认显示新增按钮
        Result.new  := 1;
    end;
    if not Result.Exists('delete') then begin    //默认显示删除按钮
        Result.delete  := 1;
    end;
    if not Result.Exists('print') then begin     //默认显示打印按钮
        Result.print  := 1;
    end;
    if not Result.Exists('fields') then begin    //显示的字段列表
        Result.fields  := _json('[]');
    end;
    if not Result.Exists('margin') then begin //默认表名
        Result.margin := 10;
    end;
    if not Result.Exists('radius') then begin //默认表名
        Result.radius := 5;
    end;
    //>
end;


function  dwGetQuickCrudSQL(AForm:TForm;AIndex:Integer):String;
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

Procedure FP_QueryResize(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oFP_Query   : TFlowPanel;
    oP_Buttons  : TPanel;
    oSG_Main    : TStringGrid;
    oP_TBMain   : TPanel;
    oPC_Slave   : TPageControl;
    oChange     : Procedure(Sender:TObject) of Object;
    oP_SButtons : TPanel;
begin
    //取得各控件
    oFP_Query   := TFlowPanel(Sender);
    oForm       := TForm(oFP_Query.Owner);
    oP_Buttons  := TPanel(oForm.FindComponent('P_Buttons'));
    oSG_Main    := TStringGrid(oForm.FindComponent('SG_Main'));
    oP_TBMain   := TPanel(oForm.FindComponent('P_TBMain'));
    oPC_Slave   := TPageControl(oForm.FindComponent('PC_Slave'));
    oP_SButtons := TPanel(oForm.FindComponent('P_SButtons'));

    //控制各控件大小位置信息
    if oP_TBMain <> nil then begin
        //
        oChange     := oFP_Query.OnResize;
        oFP_Query.OnResize  := nil;

        oFP_Query.AutoSize  := True;
        oFP_Query.AutoSize  := False;
        //
        oP_Buttons.Top      := oFP_Query.top + oFP_Query.Height + 10;
        oSG_Main.Top        := oP_Buttons.Top + oP_Buttons.Height;
        //
        if oPC_Slave.Visible then begin
            oPC_Slave.Top   := oP_TBMain.Top + oP_TBMain.Height + 10;
            oPC_Slave.Height:= oForm.Height - oPC_Slave.Top - 10;
            oP_SButtons.Top := oPC_Slave.top + 1;
            oP_TBMain.Top   := oSG_Main.Top + oSG_Main.Height;

        end else begin
            oSG_Main.Height := oP_TBMain.Top - oSG_Main.Top;
        end;
        //
        oFP_Query.OnResize  := oChange;
    end;
end;



Procedure E_KeywordChange(Self: TObject; Sender: TObject);
begin
    _UpdateMain(TForm(TEdit(Sender).Owner));
    _UpdateSlaves(TForm(TEdit(Sender).Owner));
end;



Procedure B_DOKClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oSQuery     : TFDQuery;
    oPanel      : TPanel;
    oTB_Main    : TTrackBar;
    //
    iSlave      : Integer;
    //
    sMValue     : string;   //主表的关键字段值
    //
    joConfig    : variant;
    joSlave     : variant;
begin
    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('P_Delete'));
    oTB_Main    := TTrackBar(oForm.FindComponent('TB_Main'));

    //默认到第1页
    oTB_Main.Position   := 0;


    //取得配置JSON对象
    joConfig    := _json(dwGetConfig(oForm));

    //根据 oPanel.Tag 区分当前删除的是主表，还是从表
    //0：表示主表，其他表示从表，1：从表0
    if oPanel.Tag = 0 then begin
        oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

        //先删除关联的从表记录
        if joConfig.Exists('slave') then begin
            oSQuery    := TFDQuery.Create(oForm);
            oSQuery.Connection := oQuery.Connection;
            for iSlave := 0 to joConfig.slave._Count-1 do begin
                joSlave := joConfig.slave._(iSlave);
                //取得关联值
                sMValue := oQuery.FieldByName(joSlave.masterfield).AsString;
                //执行删除
                oSQuery.Close;
                if oQuery.FieldByName(joSlave.masterfield).DataType in
                    [ftSmallint, ftInteger, ftWord, ftAutoInc]
                then begin
                    oSQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                            +' WHERE '+joSlave.slavefield+'='+sMValue;
                end else begin
                    oSQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                            +' WHERE '+joSlave.slavefield+'='''+sMValue+'''';
                end;
                oSQuery.ExecSQL;
            end;
            oSQuery.Destroy;
        end;


        //
        oQuery.Delete;
    end else begin
        iSlave  := oPanel.Tag - 1;
        oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
        //
        oQuery.Delete;
    end;

    //
    _UpdateMain(oForm);
    _UpdateSlaves(oForm);

    //
    oPanel.Visible  := False;
end;

Procedure B_QueryModeClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oFP_Query   : TFlowPanel;
    oP_QuerySmt : TPanel;
    oB_Fuzzy    : TButton;
begin
    //dwMessage('B_QueryModeClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oFP_Query   := TFlowPanel(oForm.FindComponent('FP_Query'));
    oP_QuerySmt := TPanel(oForm.FindComponent('P_QuerySmart'));
    oB_Fuzzy    := TButton(oForm.FindComponent('B_Fuzzy'));

    //
    oButton.Tag := oButton.Tag - 1;
    if not(oButton.Tag in [0,1,2]) then begin
        oButton.Tag := 2;
    end;

    if oFP_Query = nil then begin
        //切换查询模式： 分字段查询 / 智能模糊查询
        case oButton.Tag of
            0 : begin
                //切换到 无查询
                oP_QuerySmt.Visible := False;

                //该模式下支持2种匹配方式：模糊/精确
                oB_Fuzzy.Visible    := False;

            end;
            1,2 : begin
                //切换到 智能模糊查询
                oP_QuerySmt.Visible := True;
                oP_QuerySmt.Top     := 0;

                //该模式下仅支持模糊查询
                oB_Fuzzy.Visible    := False;

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
                oFP_Query.Top       := oP_QuerySmt.Top;
                oP_QuerySmt.Visible := False;
                oFP_Query.Visible   := False;

                //该模式下支持2种匹配方式：模糊/精确
                oB_Fuzzy.Visible    := False;

            end;
            1 : begin
                //切换到 智能模糊查询
                oP_QuerySmt.Top     := oFP_Query.Top;
                oFP_Query.Visible   := False;
                oP_QuerySmt.Visible := True;

                //该模式下仅支持模糊查询
                oB_Fuzzy.Visible    := False;
            end;
            2 : begin
                //切换到 分字段查询
                oFP_Query.Top       := oP_QuerySmt.Top;
                oP_QuerySmt.Visible := False;
                oFP_Query.Visible   := True;

                //该模式下支持2种匹配方式：模糊/精确
                oB_Fuzzy.Visible    := True;

            end;
        else
        end;
    end;
end;

Procedure B_FuzzyClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
begin
    //dwMessage('B_QueryModeClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    if oButton.Tag = 0 then begin
        //精确
        oButton.Tag     := 1;
        oButton.Hint    := '{"icon":"el-icon-c-scale-to-original"}';
    end else begin
        //模糊
        oButton.Tag     := 0;
        oButton.Hint    := '{"icon":"el-icon-open"}';
    end;
end;

Procedure B_QueryClick(Self: TObject; Sender: TObject);
begin
    //dwMessage('B_QueryModeClick','',TForm(TEdit(Sender).Owner));

    _UpdateMain(TForm(TEdit(Sender).Owner));
    _UpdateSlaves(TForm(TEdit(Sender).Owner));
end;
Procedure B_ResetClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oP_Query    : TPanel;
    oP_QueryFld : TPanel;
    oFP_Query   : TFlowPanel;
    oE_Query    : TEdit;
    oTB_Main    : TTrackBar;
    oCB_Query   : TComboBox;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    //
    iItem       : Integer;
    iField      : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //dwMessage('B_ResetClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Query    := TPanel(oForm.FindComponent('P_Query'));
    oFP_Query   := TFlowPanel(oForm.FindComponent('FP_Query'));
    oTB_Main    := TTrackBar(oForm.FindComponent('TB_Main'));

    //取得配置JSON对象
    joConfig    := _json(dwGetConfig(oForm));

    //默认主表分页为第1页
    oTB_Main.Position   := 0;

    //
    for iItem := 0 to oFP_Query.ControlCount-1 do begin
        //得到每个字段的面板
        oP_QueryFld := TPanel(oFP_Query.Controls[iItem]);

        //取得字段序号
        iField      := oP_QueryFld.Tag;

        //如果 <0, 则表示为按钮组，跳出
        if iField < 0 then begin
            break
        end;

        //取得当前字段对象
        joField     := joConfig.fields._(iField);

        //根据字段类型分类处理
        if joField.type = 'date' then begin
            //取得起始结束日期控件
            oDT_Start   := TDateTimePicker(TPanel(oP_QueryFld.Controls[1]).Controls[1]);
            oDT_End     := TDateTimePicker(TPanel(oP_QueryFld.Controls[1]).Controls[2]);

            //
            if joField.Exists('min') then begin
                oDT_Start.Date  := StrToDateDef(joField.min,Now);
            end else begin
                oDT_Start.Date  := StrToDateDef('1900-01-01',Now);;
            end;

            //
            if joField.Exists('max') then begin
                oDT_End.Date    := StrToDateDef(joField.max,Now);
            end else begin
                oDT_End.Date    := StrToDateDef('2050-12-31',Now);;
            end;
        end else if (joField.type = 'combo') OR (joField.type = 'dbcombo') then begin
            oCB_Query   := TComboBox(oP_QueryFld.Controls[1]);
            oCB_Query.ItemIndex := 0;
        end else begin
            oE_Query        := TEdit(oP_QueryFld.Controls[1]);
            oE_Query.Text   := '';
        end;
    end;


    _UpdateMain(TForm(TEdit(Sender).Owner));
    _UpdateSlaves(TForm(TEdit(Sender).Owner));
end;

Procedure CB_PageSizeChange(Self: TObject; Sender: TObject);
var
    oCB_PageSize: TComboBox;
    oForm       : TForm;
    oSG_Main    : TStringGrid;
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
    oSG_Main    := TStringGrid(oForm.FindComponent('SG_Main'));

    //取得当前配置
    joConfig            := _json(dwGetConfig(oForm));

    //更新配置,保存PageSize
    iOldPageSz          := joConfig.pagesize;
    iNewPageSz          := StrToIntDef(oCB_PageSize.Text,iOldPageSz);
    joConfig.pagesize   := iNewPageSz;
    dwSetConfig(oForm,joConfig);

    //
    if iNewPageSz > iOldPageSz then begin
        for iItem := iOldPageSz to iNewPageSz -1 do begin
            //dwSGAddRow(oSG_Main);
        end;
        oSG_Main.RowCount   := 1 + iNewPageSz;

        //更新数据
        _UpdateMain(TForm(TEdit(Sender).Owner));
        _UpdateSlaves(TForm(TEdit(Sender).Owner));
    end;
    //
    if iNewPageSz < iOldPageSz then begin
        for iItem := iOldPageSz-1 downto iNewPageSz do begin
            //dwSGDelRow(oSG_Main);
        end;
        oSG_Main.RowCount   := 1 + iNewPageSz;

        //更新数据
        _UpdateMain(TForm(TEdit(Sender).Owner));
        _UpdateSlaves(TForm(TEdit(Sender).Owner));
    end;
end;

Procedure B_DCancelClick(Self: TObject; Sender: TObject);
var
    oButton : TButton;
    oForm   : TForm;
    oPanel  : TPanel;
begin
    //dwMessage('B_DCancelClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('P_Delete'));

    //关闭面板
    oPanel.Visible  := False;
end;


Procedure B_EOKClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oSQuery     : TFDQuery;
    oP_Editor   : TPanel;
    oE_Field    : TEdit;
    oComp       : TComponent;
    oCB_Field   : TComboBox;
    oCK_EBatch   : TCheckBox;
    //
    iSlave      : Integer;
    iField      : Integer;
    iItem       : Integer;
    //
    sMValue     : string;   //主表的关键字段值
    //
    joConfig    : variant;
    joSlave     : variant;
    joField     : Variant;
begin
    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Editor   := TPanel(oForm.FindComponent('P_Editor'));
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CK_EBatch'));

    //取得配置JSON对象
    joConfig    := _json(dwGetConfig(oForm));

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oP_Editor.Tag of
        0 : begin   //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

            //更新数值
            oQuery.Edit;
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);

                //
                oComp   := oForm.FindComponent('Field0'+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'combo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'dbcombo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'integer' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
                end else if joField.type = 'date' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToDateDef(oE_Field.text,Now);
                end else if joField.type = 'time' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat   := StrToFloatDef(oE_Field.text,0);
                end else if joField.type = 'datetime' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToFloatDef(oE_Field.text,0);
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
                            dwMessage('保存失败！字段 "'+joField.name+'" 为必填字段！','error',oForm);
                            Exit;
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
        //从表编辑
        1..99 : begin
            iSlave  := oP_Editor.Tag - 1;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

            //更新数值
            oQuery.Edit;
            for iField := 0 to joConfig.slave._(iSlave).fields._Count - 1 do begin
                joField := joConfig.slave._(iSlave).fields._(ifield);

                //
                oComp   := oForm.FindComponent('Field'+IntToStr(iSlave+1)+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'combo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'dbcombo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'integer' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
                end else if joField.type = 'date' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToDateDef(oE_Field.text,0);
                end else if joField.type = 'time' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat   := StrToTimeDef(oE_Field.text,0);
                end else if joField.type = 'datetime' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToDateTimeDef(oE_Field.text,0);
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
                            dwMessage('保存失败！字段 "'+joField.name+'" 为必填字段！','error',oForm);
                            Exit;
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
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

            //更新数值
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);

                //
                oComp   := oForm.FindComponent('Field0'+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'combo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'dbcombo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'integer' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
                end else if joField.type = 'date' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat   := StrToDateDef(oE_Field.text,0);
                end else if joField.type = 'time' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat   := StrToFloatDef(oE_Field.text,0);
                end else if joField.type = 'datetime' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToFloatDef(oE_Field.text,0);
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
                            dwMessage('保存失败！字段 "'+joField.name+'" 为必填字段！','error',oForm);
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
                //更新字段值
                oQuery.Append;
                for iItem := 0 to oQuery.FieldCount-1 do begin
                    joField := joConfig.fields._(iItem);
                    oComp   := oForm.FindComponent('Field'+'0'+IntToStr(iItem));
                    if joField.type = 'combo' then begin
                        oCB_Field       := TComboBox(oComp);
                        oCB_Field.Text  := oQuery.Fields[iItem].AsString;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field       := TComboBox(oComp);
                        oCB_Field.Text  := oQuery.Fields[iItem].AsString;
                    end else if joField.type = 'integer' then begin
                        oE_Field        := TEdit(oComp);
                        oE_Field.Text   := oQuery.Fields[iItem].AsString;
                    end else if joField.type = 'date' then begin
                        oE_Field        := TEdit(oComp);
                        oE_Field.Text   := oQuery.Fields[iItem].AsString;
                    end else if joField.type = 'time' then begin
                        oE_Field        := TEdit(oComp);
                        oE_Field.Text   := oQuery.Fields[iItem].AsString;
                    end else if joField.type = 'datetime' then begin
                        oE_Field        := TEdit(oComp);
                        oE_Field.Text   := oQuery.Fields[iItem].AsString;
                    end else if joField.type = 'money' then begin
                        oE_Field        := TEdit(oComp);
                        oE_Field.Text   := oQuery.Fields[iItem].AsString;
                    end else begin
                        oE_Field        := TEdit(oComp);
                        oE_Field.Text   := oQuery.Fields[iItem].AsString;
                    end;
                end;
            end else begin
                //关闭伪窗体
                oP_Editor.Visible  := False;
            end;
        end;
        //从表新增
        101..199 : begin
            iSlave  := oP_Editor.Tag - 101;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

            //更新数值
            oQuery.Edit;
            for iField := 0 to joConfig.slave._(iSlave).fields._Count - 1 do begin
                joField := joConfig.slave._(iSlave).fields._(ifield);

                //
                oComp   := oForm.FindComponent('Field'+IntToStr(iSlave+1)+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'combo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'dbcombo' then begin
                    oCB_Field   := TComboBox(oComp);
                    oQuery.Fields[iField].AsString  := oCB_Field.text;
                end else if joField.type = 'integer' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
                end else if joField.type = 'date' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToDateDef(oE_Field.text,0);
                end else if joField.type = 'time' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat   := StrToTimeDef(oE_Field.text,0);
                end else if joField.type = 'datetime' then begin
                    oE_Field := TEdit(oComp);
                    oQuery.Fields[iField].AsFloat := StrToDateTimeDef(oE_Field.text,0);
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
                            dwMessage('保存失败！字段 "'+joField.name+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;
        end;
    end;

    //更新显示（仅关闭编辑/新增面板时）
    if not oP_Editor.Visible then begin
        _UpdateMain(oForm);
        _UpdateSlaves(oForm);
    end;

end;

Procedure B_ECancelClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oP_Editor   : TPanel;
    //
    iSlave      : Integer;
begin
    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Editor   := TPanel(oForm.FindComponent('P_Editor'));

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oP_Editor.Tag of
        0 : begin       //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
        1..99 : begin   //从表编辑
            iSlave  := oP_Editor.Tag - 1;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
            oQuery.Cancel;
        end;
        100 : begin     //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
        101..199 : begin//从表新增
            iSlave  := oP_Editor.Tag - 101;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
            oQuery.Cancel;
        end;
    end;

    //
    oP_Editor.Visible  := False;
end;


Procedure PC_SlaveChange(Self: TObject; Sender: TObject);
var
    iSlave      : Integer;
    joConfig    : variant;
    joSlave     : Variant;
    //
    oPC         : TPageControl;
    oForm       : TForm;
    oB_SEdit    : TButton;
    oB_SNew     : TButton;
    oB_SDelete  : TButton;
    oB_SPrint   : TButton;
begin
    //
    oPC         := TPageControl(Sender);
    oForm       := TForm(oPC.Owner);
    oB_SEdit    := TButton(oForm.FindComponent('B_SEdit'));
    oB_SNew     := TButton(oForm.FindComponent('B_SNew'));
    oB_SDelete  := TButton(oForm.FindComponent('B_SDelete'));
    oB_SPrint   := TButton(oForm.FindComponent('B_SPrint'));

    //
    joConfig    := _json(dwGetConfig(oForm));

    //根据当前从表的设置，动态显示/隐藏各功能按钮（Edit/New/Delete/Print）
    iSlave  := oPC.ActivePageIndex;
    joSlave := joConfig.slave._(iSlave);
    //
    oB_SEdit.Visible    := (joSlave.edit = 1);
    oB_SNew.Visible     := (joSlave.new = 1);
    oB_SDelete.Visible  := (joSlave.delete = 1);
    oB_SPrint.Visible   := (joSlave.print = 1);
end;

Procedure B_EditClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oB_Edit     : TButton;
    oP_Editor   : TPanel;
    oL_ETitle   : TLabel;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oCB         : TComboBox;
    oCK_EBatch  : TCheckBox;
    //
    iItem   : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //主表编辑事件
    //dwMessage('B_EditClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oB_Edit     := TButton(Sender);
    oForm       := TForm(oB_Edit.Owner);
    oP_Editor   := TPanel(oForm.FindComponent('P_Editor'));
    oL_ETitle   := TLabel(oForm.FindComponent('L_ETitle'));
    oQuery      := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CK_EBatch'));

    //
    oCK_EBatch.Visible  := False;

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oP_Editor.Tag   := 0;

    //隐藏P_Editor中其他所有ScrollBox
    TScrollBox(oForm.FindComponent('SB_0')).Visible  := True;
    for iItem := 1 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB_'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;

    joConfig    := dwGetConfigJson(oForm);

    //更新字段值
    for iItem := 0 to oQuery.FieldCount-1 do begin
        joField := joConfig.fields._(iItem);
        oComp   := oForm.FindComponent('Field'+'0'+IntToStr(iItem));
        if joField.type = 'combo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'dbcombo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'integer' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'date' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'time' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'datetime' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'money' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end;
    end;

    //
    oP_Editor.Visible   := True;
end;
Procedure B_NewClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oB_New      : TButton;
    oP_Editor   : TPanel;
    oL_ETitle   : TLabel;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oCB         : TComboBox;
    oCK_EBatch  : TCheckBox;
    //
    iItem       : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //主表新增事件
    //dwMessage('B_NewClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oB_New      := TButton(Sender);
    oForm       := TForm(oB_New.Owner);
    oP_Editor   := TPanel(oForm.FindComponent('P_Editor'));
    oL_ETitle   := TLabel(oForm.FindComponent('L_ETitle'));
    oQuery      := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CK_EBatch'));

    //
    oCK_EBatch.Visible  := True;

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oP_Editor.Tag  := 100;

    //隐藏P_Editor中其他所有ScrollBox
    TScrollBox(oForm.FindComponent('SB_0')).Visible := True;
    for iItem := 1 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB_'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;

    joConfig    := _json(dwGetConfig(oForm));

    //更新字段值
    oQuery.Append;
    for iItem := 0 to oQuery.FieldCount-1 do begin
        joField := joConfig.fields._(iItem);
        oComp   := oForm.FindComponent('Field'+'0'+IntToStr(iItem));
        if joField.type = 'combo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'dbcombo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'integer' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'date' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'time' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'datetime' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'money' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end;
    end;

    //
    oP_Editor.Visible  := True;
end;
Procedure B_DeleteClick(Self: TObject; Sender: TObject);
var
    oForm   : TForm;
    oButton : TButton;
    oPanel  : TPanel;
    oLabel  : TLabel;
    oQuery  : TFDQuery;
    //
    iField  : Integer;
    sInfo   : string;
begin
    //dwMessage('B_DeleteClick','',TForm(TEdit(Sender).Owner));
    //主表的删除事件。
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('P_Delete'));
    oLabel  := TLabel(oForm.FindComponent('L_Confirm'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

    //标志当前的从表
    oPanel.Tag  := 0;

    //
    sInfo   := '';
    for iField := 0 to oQuery.FieldCount-1 do begin
        sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
    end;
    //
    oLabel.Caption  := '确定要删除当前记录以及关联从表记录吗？'#13#13+sInfo;
    oPanel.Visible  := True;
end;
Procedure B_PrintClick(Self: TObject; Sender: TObject);
var
    oForm   : TForm;
    oButton : TButton;
    oSG     : TPanel;
begin
    //dwMessage('B_PrintClick','',TForm(TEdit(Sender).Owner));

    //主表的打印事件。
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oSG     := TPanel(oForm.FindComponent('SG_Main'));
    //
    dwPrint(oSG);
end;

Procedure B_SEditClick(Self: TObject; Sender: TObject);
var
    oForm   : TForm;
    oButton : TButton;
    oPanel  : TPanel;
    oLabel  : TLabel;
    oSB     : TScrollBox;
    oPC     : TPageControl;
    oQuery  : TFDQuery;
    oComp   : TComponent;
    oE      : TEdit;
    oCB     : TComboBox;
    //
    iItem   : Integer;
    iSlave  : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //从表编辑事件
    //dwMessage('B_SEditClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('P_Editor'));
    oLabel  := TLabel(oForm.FindComponent('L_ETitle'));
    oPC     := TPageControl(oForm.FindComponent('PC_Slave'));

    //隐藏P_Editor中其他所有ScrollBox
    iSlave  := oPC.ActivePageIndex;
    for iItem := 0 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB_'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := (iItem = iSlave+1);
        end;
    end;

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPanel.Tag  := iSlave + 101;

    //
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //
    joConfig    := _json(dwGetConfig(oForm));

    //更新字段值
    for iItem := 0 to oQuery.FieldCount-1 do begin
        joField := joConfig.slave._(iSlave).fields._(iItem);
        oComp   := oForm.FindComponent('Field'+IntToStr(iSlave+1)+IntToStr(iItem));
        if joField.type = 'combo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'dbcombo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'integer' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'date' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'time' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'datetime' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'money' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end;
    end;

    //
    oPanel.Visible  := True;
end;

Procedure B_SNewClick(Self: TObject; Sender: TObject);
var
    oForm   : TForm;
    oButton : TButton;
    oPanel  : TPanel;
    oPC     : TPageControl;
    oSB     : TScrollBox;
    oQuery  : TFDQuery;
    oComp   : TComponent;
    oE      : TEdit;
    oCB     : TComboBox;
    //
    iSlave      : Integer;
    iItem       : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //主表新增事件
    //dwMessage('B_SNewClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('P_Editor'));
    oPC     := TPageControl(oForm.FindComponent('PC_Slave'));

    //隐藏P_Editor中其他所有ScrollBox
    iSlave  := oPC.ActivePageIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPanel.Tag  := 101+iSlave;

    //隐藏P_Editor中其他所有ScrollBox
    for iItem := 0 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB_'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := (iItem = iSlave+1);
        end;
    end;

    joConfig    := _json(dwGetConfig(oForm));

    //更新字段值
    oQuery.Append;
    for iItem := 0 to oQuery.FieldCount-1 do begin
        joField := joConfig.fields._(iItem);
        oComp   := oForm.FindComponent('Field'+IntToStr(iSlave+1)+IntToStr(iItem));
        if joField.type = 'combo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'dbcombo' then begin
            oCB := TComboBox(oComp);
            oCB.Text:= oQuery.Fields[iItem].AsString;
        end else if joField.type = 'integer' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'date' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'time' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'datetime' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'money' then begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end else begin
            oE  := TEdit(oComp);
            oE.Text := oQuery.Fields[iItem].AsString;
        end;
    end;

    //
    oPanel.Visible  := True;
end;
Procedure B_SDeleteClick(Self: TObject; Sender: TObject);
var
    oForm   : TForm;
    oButton : TButton;
    oPanel  : TPanel;
    oLabel  : TLabel;
    oQuery  : TFDQuery;
    oPC     : TPageControl;
    //
    iField  : Integer;
    iSlave  : Integer;
    sInfo   : string;
begin
    //dwMessage('B_DeleteClick','',TForm(TEdit(Sender).Owner));
    //从表的删除事件。

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('P_Delete'));
    oLabel  := TLabel(oForm.FindComponent('L_Confirm'));
    oPC     := TPageControl(oForm.FindComponent('PC_Slave'));
    iSlave  := oPC.ActivePageIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //标志当前的从表
    oPanel.Tag  := iSlave + 1;

    //取得当前记录信息
    sInfo   := '';
    for iField := 0 to oQuery.FieldCount-1 do begin
        sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
    end;

    //显示删除确认框
    oLabel.Caption  := '确定要删除吗？'#13#13+sInfo;
    oPanel.Visible  := True;
end;

Procedure B_SPrintClick(Self: TObject; Sender: TObject);
var
    oForm   : TForm;
    oButton : TButton;
    oSG     : TStringGrid;
    oPC     : TPageControl;
    //
    iSlave  : Integer;
begin
    //从表打印事件
    //dwMessage('B_sPrintClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPC     := TPageControl(oForm.FindComponent('PC_Slave'));
    iSlave  := oPC.ActivePageIndex;
    oSG     := TStringGrid(oForm.FindComponent('SG_'+IntToStr(iSlave)));
    //
    dwPrint(oSG);

end;


Procedure SG_MainClick(Self: TObject; Sender: TObject);
var
    iRow    : Integer;
    oForm   : TForm;
    oSG     : TStringGrid;
    oQuery  : TFDQuery;
    oClick  : Procedure(Sender: TObject) of Object;
begin
    //dwMessage('SG_MainClick','',TForm(TEdit(Sender).Owner));
    //主表的单击事件。功能：
    //1 如果主表未满行，点击空行后，自动切到最末行
    //2 根据当前主表的记录位置，自动更新从表

    //取得各控件
    oSG     := TStringGrid(Sender);
    oForm   := TForm(oSG.Owner);
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

    //得到当前行
    iRow    := oSG.Row;

    //检查是否空行。如果是空行，则切到最末行
    if iRow > oQuery.RecordCount then begin
        iRow    := oQuery.RecordCount;
        //
        oClick      := oSG.OnClick;
        oSG.OnClick := nil;
        oSG.Row     := iRow;
        oSG.OnClick := oClick;
    end;

    //更新数据表记录
    oQuery.RecNo  := iRow;

    //更新从表
    _UpdateSlaves(oForm);

    //激活窗体的OnDockDrop事件，其中：X 为 0，表示为主表，iRow为记录号
    if Assigned(oForm.OnDockDrop) then begin
        oForm.OnDockDrop(oSG,nil,0,iRow);
    end;
end;
Procedure SG_MainGetEditMask(Self: TObject; Sender: TObject; ACol, ARow: Integer; var Value: string);
var
    oForm   : TForm;
    oSG     : TStringGrid;
    oQuery  : TFDQuery;
begin
    //dwMessage('SG_MainGetEditMask','',TForm(TEdit(Sender).Owner));
    //主表点击排序
    //当设置了显示排序按钮时，当点击排序按钮时，StringGrid会自动激活OnGetEditMask事件。其中参数：
    //ACol : Integer ; 为所在列序号（从0开始）；
    //ARow : Integer;  为排序方向，1为升序，0为降序；
    //Value : string; 为标识，固定为字符串'sort'

    //取得各控件
    oSG     := TStringGrid(Sender);
    oForm   := TForm(oSG.Owner);
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

    //
    oSG.StyleName   := 'ORDER BY '+oQuery.Fields[ACol].FieldName;
    if ARow = 0 then begin
        oSG.StyleName   := oSG.StyleName +' DESC';
    end;

    //
    _UpdateMain(oForm);
    _UpdateSlaves(oForm);

end;

Procedure SG_SlaveClick(Self: TObject; Sender: TObject);
var
    iSlave  : Integer;
    iRow    : Integer;
    oForm   : TForm;
    oSG     : TStringGrid;
    oQuery  : TFDQuery;
    oClick  : Procedure(Sender: TObject) of Object;

begin
    //dwMessage('SG_MainClick','',TForm(TEdit(Sender).Owner));
    oSG     := TStringGrid(Sender);
    oForm   := TForm(oSG.Owner);
    iSlave  := TTabSheet(oSG.Parent).PageIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //
    iRow    := oSG.Row;
    //
    if iRow > oQuery.RecordCount then begin
        iRow    := oQuery.RecordCount;
        //
        oClick      := oSG.OnClick;
        oSG.OnClick := nil;
        oSG.Row     := iRow;
        oSG.OnClick := oClick;

    end;

    //
    oQuery.RecNo  := iRow;

    //激活窗体的OnDockDrop事件，其中：X 为 1 + iSlave，表示为主表，iRow为记录号
    if Assigned(oForm.OnDockDrop) then begin
        oForm.OnDockDrop(oSG,nil,1 + iSlave,iRow);
    end;
end;
Procedure SG_SlaveGetEditMask(Self: TObject; Sender: TObject; ACol, ARow: Integer; var Value: string);
var
    iSlave  : Integer;
    oForm   : TForm;
    oSG     : TStringGrid;
    oQuery  : TFDQuery;
begin
    //dwMessage('SG_MainGetEditMask','',TForm(TEdit(Sender).Owner));
    //主表点击排序
    //当设置了显示排序按钮时，当点击排序按钮时，StringGrid会自动激活OnGetEditMask事件。其中参数：
    //ACol : Integer ; 为所在列序号（从0开始）；
    //ARow : Integer;  为排序方向，1为升序，0为降序；
    //Value : string; 为标识，固定为字符串'sort'

    //取得各控件
    oSG     := TStringGrid(Sender);
    oForm   := TForm(oSG.Owner);
    iSlave  := TTabSheet(oSG.parent).TabIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //
    oSG.StyleName   := 'ORDER BY '+oQuery.Fields[ACol].FieldName;
    if ARow = 0 then begin
        oSG.StyleName   := oSG.StyleName +' DESC';
    end;

    //
    _UpdateSlaves(oForm);
end;

Procedure TB_MainChange(Self: TObject; Sender: TObject);
begin
    _UpdateMain(TForm(TEdit(Sender).Owner));
    _UpdateSlaves(TForm(TEdit(Sender).Owner));
end;

Procedure TB_SlaveChange(Self: TObject; Sender: TObject);
begin
    _UpdateMain(TForm(TEdit(Sender).Owner));
    _UpdateSlaves(TForm(TEdit(Sender).Owner));
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


procedure _UpdateMain(AForm:TForm);
var
    iField      : Integer;
    iItem       : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    //
    joConfig    : variant;
    joField     : Variant;
    //
    oFDQuery    : TFDQuery;
    oTB_Main    : TTrackBar;
    oSG_Main    : TStringGrid;
    oE_Keyword  : TEdit;
    oFP_Query   : TFlowPanel;
    oP_QueryFld : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCB_Query   : TComboBox;
    oB_Fuzzy    : TButton;
begin
    //
    joConfig    := dwGetConfigJson(AForm);

    //取得字段名称列表，备用，如：id,Name,age
    sFields := joConfig.fields._(0).name;
    for iField := 1 to joConfig.fields._Count-1 do begin
        joField := joConfig.fields._(iField);
        //
        sFields := sFields+','+joField.name
    end;

    //取得各控件备用
    oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));   //主表数据库
    oE_Keyword  := TEdit(AForm.FindComponent('E_Keyword'));     //查询关键字
    oSG_Main    := TStringGrid(AForm.FindComponent('SG_Main')); //主表显示StringGrid
    oTB_Main    := TTrackBar(AForm.FindComponent('TB_Main'));   //主表分页
    oB_Fuzzy    := TButton(AForm.FindComponent('B_Fuzzy'));     //模糊/精确匹配 切换按钮
    oFP_Query   := TFlowPanel(AForm.FindComponent('FP_Query'));     //分字段查询字段的流式布局容器面板

    //数据库类型
    if not joConfig.Exists('database') then begin
        joConfig.database   := lowerCase(oFDQuery.Connection.DriverName); //'access';
        dwSetConfig(AForm,joConfig);
    end;

    //取得WHERE, 区分“智能模糊查询”和“分字段查询”2种情况
    //结果类似:  WHERE ((model like '%ljt%') and (name like '%west%'))
    if oFP_Query.Visible then begin
        //初始化查询 WHERE 字符串
        sWhere  := 'WHERE ((1=1) AND ';

        //逐个字段处理
        for iItem := 0 to oFP_Query.ControlCount-1 do begin
            //得到每个字段的面板
            oP_QueryFld := TPanel(oFP_Query.Controls[iItem]);

            //取得字段序号
            iField      := oP_QueryFld.Tag;

            //如果 <0, 则表示为按钮组，跳出
            if iField < 0 then begin
                break
            end;

            //取得当前字段对象
            joField     := joConfig.fields._(iField);

            //根据字段类型分类处理
            if joField.type = 'date' then begin
                //取得起始结束日期控件
                oDT_Start   := TDateTimePicker(TPanel(oP_QueryFld.Controls[1]).Controls[1]);
                oDT_End     := TDateTimePicker(TPanel(oP_QueryFld.Controls[1]).Controls[2]);

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
            end else if (joField.type = 'combo') OR (joField.type = 'dbcombo') then begin
                oCB_Query   := TComboBox(oP_QueryFld.Controls[1]);
                if Trim(oCB_Query.Text) <> '' then begin
                    //
                    if oB_Fuzzy.Tag = 0 then begin
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCB_Query.Text)+'%'' ) AND ';
                    end else begin
                        sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCB_Query.Text)+''' ) AND ';
                    end;
                end;
            end else begin  //
                oE_Query    := TEdit(oP_QueryFld.Controls[1]);
                if Trim(oE_Query.Text) <> '' then begin
                    //
                    if oB_Fuzzy.Tag = 0 then begin
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end else begin
                        sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                    end;
                end;
            end


        end;
        //删除最后的 ' AND '
        sWhere  := Copy(sWhere,1,Length(sWhere)-4);
        //
        sWhere  := sWhere + ')';
    end else begin
        sWhere  := dwGetWhere(sFields, oE_Keyword.Text);
    end;

    //
    dwaGetDataToGrid(
            oFDQuery,           //AQuery:TFDQuery;
            joConfig.table,     //ATable,
            sFields,            //AFields,
            sWhere,             //AWhere,
            oSG_Main.StyleName, //AOrder:String; 保存在表格的stylename属性中
            oTB_Main.Position,  //APage,
            joConfig.pagesize,  //ACount:Integer;
            oSG_Main,           //ASG:TStringGrid;
            oTB_Main            //ATrackBar:TTrackBar
            );
    oFDQuery.First;

    //
    oSG_Main.Row    := 1;
    dwRunJS('this.$refs.'+dwFullName(oSG_Main)+'.bodyWrapper.scrollTop = 0;',AForm);
    //UpdateSlaves;
end;





procedure _UpdateSlaves(AForm:TForm);
var
    iField      : Integer;
    iSlave      : Integer;
    //
    sFields     : string;
    sMValue     : string;
    sWhere      : string;
    //
    joConfig    : variant;
    joField     : Variant;
    joSlave     : Variant;
    //
    oFD_Main    : TFDQuery;
    oFDQuery    : TFDQuery;
    oTB         : TTrackBar;
    oSG         : TStringGrid;
begin
    //
    joConfig    := dwGetConfigJson(AForm);

    //如果没有slave,则退出
    if not joConfig.Exists('slave') then begin
        Exit;
    end;

    //
    oFD_Main    := TFDQuery(AForm.FindComponent('FQ_Main'));

    //逐个更新slave
    for iSlave := 0 to joConfig.slave._Count-1 do begin
        //得到从表JSON
        joSlave := joConfig.slave._(iSlave);

        //主表关联字段值
        sMValue := oFD_Main.FieldByName(joSlave.masterfield).AsString;

        //关联字段需要是整数型，如果非整数，则跳过
        if StrToIntDef(sMValue,-9876) = -9876 then begin
            Continue;
        end;

        //取得字段名称列表，备用
        sFields := joSlave.fields._(0).name;
        for iField := 1 to joSlave.fields._Count-1 do begin
            joField := joSlave.fields._(iField);
            //
            sFields := sFields+','+joField.name
        end;

        //得到查询控件
        oFDQuery   := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(iSlave)));

        //得到分页组件
        oTB := TTrackBar(AForm.FindComponent('TB_'+IntToStr(iSlave)));

        //
        oSG := TStringGrid(AForm.FindComponent('SG_'+IntToStr(iSlave)));

        //
        sWhere      := 'WHERE '+joSlave.slavefield+'='+sMValue;  //'WHERE id>10'

        dwaGetDataToGrid(
                oFDQuery,           //AQuery:TFDQuery;
                joSlave.table,      //ATable,
                sFields,            //AFields,
                sWhere,             //AWhere,
                oSG.StyleName,      //AOrder:String; 保存在SG的stylename中
                oTB.Position,       //Page,
                joConfig.slavepagesize,    //ACount:Integer;
                oSG,                //ASG:TStringGrid;
                oTB                 //ATrackBar:TTrackBar
                );
    end;

end;

procedure CreateConfirmPanel(AForm:TForm);
var
    oP_Delete   : TPanel;
    oL_Confirm  : TLabel;
    oB_DOK      : TButton;
    oB_DCancel  : TButton;
    //用于指定事件
    tM          : TMethod;
begin
    oP_Delete   := TPanel.Create(AForm);
    with oP_Delete do begin
        Name        := 'P_Delete';
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
    oL_Confirm  := TLabel.Create(AForm);
    with oL_Confirm do begin
        Name        := 'L_Confirm';
        Parent      := oP_Delete;
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
    oB_DOK  := TButton.Create(AForm);
    with oB_DOK do begin
        Name        := 'B_DOK';
        Parent      := oP_Delete;
        Top         := 140;
        Left        := 0;
        Width       := 170;
        Height      := 60;
        Caption     := '确定';
        Font.Size   := 14;
        Hint        := '{"dwstyle":"background:#fff;border-top:solid 1px #dcdfd6;border-right:0px;","radius":"0px"}';
        //
        tM.Code         := @B_DOKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oB_DCancel  := TButton.Create(AForm);
    with oB_DCancel do begin
        Name        := 'B_DCancel';
        Parent      := oP_Delete;
        Top         := 140;
        Left        := 170;
        Width       := 170;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '取消';
        Hint        := '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":"0px"}';
        //
        tM.Code         := @B_DCancelClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

end;

procedure CreateEditorPanel(AForm:TForm);
var
    oP_Editor   : TPanel;
    oB_ETitle   : TButton;
    oP_EButtons : TPanel;
    oB_EOK      : TButton;
    oB_ECancel  : TButton;
    oSB         : TScrollBox;
    oP_Content  : TPanel;
    oCK_Batch   : TCheckBox;

    //
    iSlave      : Integer;
    iField      : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    iEditColCnt : Integer;

    //
    joConfig    : Variant;
    joSlave     : Variant;
    joField     : Variant;
    joList      : Variant;
    joItems     : Variant;

    //用于指定事件
    tM          : TMethod;
    procedure CreateField(ALeft,ATop,AWidth:Integer;ASuffix:String;AField:Variant;AP_Content:TPanel);
    var
        ooP         : TPanel;
        ooL         : TLabel;
        ooE         : TEdit;
        ooCB        : TComboBox;
        oQueryTmp   : TFDQuery;
        //
        iItem   : Integer;
    begin
        oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

        //字段容器Panel
        ooP     := TPanel.Create(AForm);
        with ooP do begin
            Name        := 'P_Field'+ASuffix;
            Parent      := AP_Content;
            BevelOuter  := bvNone;
            BorderStyle := bsNone;
            //Align       := alTop;
            AutoSize    := False;
            Height      := 40;
            Left        := ALeft;
            Top         := ATop;
            Width       := AWidth;
            Color       := clNone;
            Font.Size   := 11;
            //
            Hint        := '{"dwstyle":"border-bottom:solid 1px #f0f0f0;"}';
        end;

        //
        ooL     := TLabel.Create(AForm);
        with ooL do begin
            Name            := 'L_Field'+ASuffix;
            Parent          := ooP;
            AutoSize        := False;
            Align           := alLeft;
            Width           := 80;
            AlignWithMargins:= True;
            Margins.Left    := 15;
            Layout          := tlCenter;
            Caption         := joField.caption;
            if joField.Exists('must') then begin
                if joField.must = 1 then begin
                    Caption := '*' + Caption ;
                end;
            end;
        end;

        if AField.type = 'combo' then begin
            ooCB := TComboBox.Create(AForm);
            with ooCB do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '';
                Color           := clNone;
                //
                Hint        := '{"dwstyle":"border:none;text-align:right;"}';
                //
                if AField.Exists('list') then begin
                    joList  := AField.list;
                    for iItem := 0 to joList._Count-1 do begin
                        Items.Add(joList._(iItem));
                    end;
                end else begin
                    Items.Add('');
                end;
            end;
        end else if AField.type = 'dbcombo' then begin
            ooCB := TComboBox.Create(AForm);
            with ooCB do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '';
                Color           := clNone;
                //
                Hint        := '{"dwstyle":"border:none;text-align:right;"}';
                //
                Items.Add('');

                //添加数据库内的值
                joItems := dwaGetItems(oQueryTmp,joConfig.table,joField.name);
                for iItem := 0 to joItems._Count-1 do begin
                    Items.Add(joItems._(iItem));
                end;
            end;
        end else if AField.type = 'integer' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"number\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'date' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"date\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'time' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"time\" step=\"1\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'datetime' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"datetime-local\" step=\"1\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'money' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"number\" step=\"0.01\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                Alignment       := taRightJustify;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '华为电器';
                Color           := clNone;
                //
                Hint            := '{"dwstyle":"border:none;"}';

                //
                if AField.type = 'auto' then begin
                    Enabled     := False;
                end;
            end;
        end;
    end;

begin
    //取得配置JSON
    joConfig    := dwGetConfigJson(AForm);

    //检查editwidth编辑面板宽度是否存在，默认为340
    if not joConfig.Exists('editwidth') then begin
        joConfig.editwidth  := 340;
    end;
    //检查editcolcount编辑面板中列数是否存在，默认为1
    if not joConfig.Exists('editcolcount') then begin
        joConfig.editcolcount  := 1;
    end;


    //编辑/新增的总面板
    oP_Editor   := TPanel.Create(AForm);
    with oP_Editor do begin
        Name        := 'P_Editor';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Anchors     := [akBottom,akTop];
        Font.Size   := 14;
        Top         := 50;
        Width       := joConfig.editwidth;
        Height      := AForm.Height - 100;
        Hint        := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
        Font.Color  := $323232;
        Color       := clWhite;
    end;

    //标题Button
    oB_ETitle  := TButton.Create(AForm);
    with oB_ETitle do begin
        Name        := 'B_ETitle';
        Parent      := oP_Editor;
        Align       := alTop;
        Height      := 50;
        Caption     := 'Data';
        Hint        := '{"dwstyle":"background:#f0f0f0;"}';
    end;

    //用于放置 OK/Cancel 的Panel
    oP_EButtons   := TPanel.Create(AForm);
    with oP_EButtons do begin
        Name        := 'P_EButtons';
        Parent      := oP_Editor;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alBottom;
        Height      := 50;
        Color       := clNone;
    end;

    //
    oB_EOK  := TButton.Create(AForm);
    with oB_EOK do begin
        Name        := 'B_EOK';
        Parent      := oP_EButtons;
        Align       := alRight;
        Width       := TPanel(Parent).Width div 2;
        Top         := 0;
        Left        := 0;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '确定';
        Hint        := '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border-left:0px;","radius":"0px"}';
        //
        tM.Code         := @B_EOKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oB_ECancel  := TButton.Create(AForm);
    with oB_ECancel do begin
        Name        := 'B_ECancel';
        Parent      := oP_EButtons;
        Align       := alClient;
        Top         := 0;
        Left        := TPanel(Parent).Width div 2;
        Width       := TPanel(Parent).Width div 2;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '取消';
        Hint        := '{"dwstyle":"background:#f0f0f0;border:solid 1px #dcdfd6;","radius":"0px"}';
        //
        tM.Code         := @B_ECancelClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //批量新增
    oCK_Batch   := TCheckBox.Create(AForm);
    with oCK_Batch do begin
        Name        := 'CK_EBatch';
        Parent      := oP_Editor;
        Align       := alBottom;
        Height      := 30;
        Caption     := '批量处理';
        AlignWithMargins:= True;
        Margins.Left    := 20;

    end;

    //主表编辑的ScrollBox
    oSB := TScrollBox.Create(AForm);
    with oSB do begin
        Name        := 'SB_0';
        Parent      := oP_Editor;
        Align       := alClient;
    end;

    //主表ScrollBox的内容Panel
    oP_Content   := TPanel.Create(AForm);
    with oP_Content do begin
        Name        := 'P_Content0';
        Parent      := oSB;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alTop;
        Color       := clWhite;
    end;

    //
    iEditColCnt   := 1;
    if joConfig.Exists('editcolcount') then begin
        iEditColCnt   := joConfig.editcolcount;
    end;

    //主表字段
    for iField := 0 to joConfig.fields._Count-1 do begin
        joField := joConfig.fields._(iField);
        //
        iLeft   := (iField mod iEditColCnt) * (joConfig.editwidth div joConfig.editcolcount)+10;
        iTop    := (iField div iEditColCnt) * 40;
        CreateField(iLeft,
                iTop,
                (oP_Editor.Width div iEditColCnt)-20,
                '0'+IntToStr(iField),joField,oP_Content);
    end;
    oP_Content.AutoSize := True;

    //
    if joConfig.Exists('slave') then begin
        for iSlave := 0 to joConfig.slave._Count-1 do begin
            //
            joSlave := joConfig.slave._(iSlave);

            //从表编辑的ScrollBox
            oSB := TScrollBox.Create(AForm);
            with oSB do begin
                Name        := 'SB_'+IntToStr(iSlave+1);
                Parent      := oP_Editor;
                Align       := alClient;
            end;

            //从表ScrollBox的内容Panel
            oP_Content   := TPanel.Create(AForm);
            with oP_Content do begin
                Name        := 'P_Content'+IntToStr(iSlave+1);
                Parent      := oSB;
                BevelOuter  := bvNone;
                BorderStyle := bsNone;
                Align       := alTop;
                Color       := clWhite;
            end;

            //从表字段
            for iField := 0 to joSlave.fields._Count-1 do begin
                joField := joSlave.fields._(iField);
                //
                iLeft   := (iField mod iEditColCnt) * (joConfig.editwidth div joConfig.editcolcount);
                iTop    := (iField div iEditColCnt) * 40;
                CreateField(iLeft, iTop, oP_Editor.Width div iEditColCnt,IntToStr(iSlave+1)+IntToStr(iField),joField,oP_Content);
            end;
            oP_Content.AutoSize := True;
        end;
    end;


end;


procedure CreateEditorPanelOld(AForm:TForm);
var
    oP_Editor   : TPanel;
    oB_ETitle   : TButton;
    oP_EButtons : TPanel;
    oB_EOK      : TButton;
    oB_ECancel  : TButton;
    oSB         : TScrollBox;
    oP_Content  : TPanel;

    //
    iSlave      : Integer;
    iField      : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    iEditColCnt : Integer;

    //
    joConfig    : Variant;
    joSlave     : Variant;
    joField     : Variant;
    joList      : Variant;
    joItems     : Variant;

    //用于指定事件
    tM          : TMethod;
    procedure CreateField(ALeft,ATop,AWidth:Integer;ASuffix:String;AField:Variant;AP_Content:TPanel);
    var
        ooP         : TPanel;
        ooL         : TLabel;
        ooE         : TEdit;
        ooCB        : TComboBox;
        oQueryTmp   : TFDQuery;
        //
        iItem   : Integer;
    begin
        oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

        //字段容器Panel
        ooP     := TPanel.Create(AForm);
        with ooP do begin
            Name        := 'P_Field'+ASuffix;
            Parent      := AP_Content;
            BevelOuter  := bvNone;
            BorderStyle := bsNone;
            //Align       := alTop;
            AutoSize    := False;
            Height      := 40;
            Left        := ALeft;
            Top         := ATop;
            Width       := AWidth;
            Color       := clNone;
            Font.Size   := 11;
            //
            Hint        := '{"dwstyle":"border-bottom:solid 1px #f0f0f0;"}';
        end;

        //
        ooL     := TLabel.Create(AForm);
        with ooL do begin
            Name            := 'L_Field'+ASuffix;
            Parent          := ooP;
            AutoSize        := False;
            Align           := alLeft;
            Width           := 80;
            AlignWithMargins:= True;
            Margins.Left    := 15;
            Layout          := tlCenter;
            Caption         := joField.caption;
            if joField.Exists('must') then begin
                if joField.must = 1 then begin
                    Caption := '*' + Caption ;
                end;
            end;
        end;

        if AField.type = 'combo' then begin
            ooCB := TComboBox.Create(AForm);
            with ooCB do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '';
                Color           := clNone;
                //
                Hint        := '{"dwstyle":"border:none;text-align:right;"}';
                //
                if AField.Exists('list') then begin
                    joList  := AField.list;
                    for iItem := 0 to joList._Count-1 do begin
                        Items.Add(joList._(iItem));
                    end;
                end else begin
                    Items.Add('');
                end;
            end;
        end else if AField.type = 'dbcombo' then begin
            ooCB := TComboBox.Create(AForm);
            with ooCB do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '';
                Color           := clNone;
                //
                Hint        := '{"dwstyle":"border:none;text-align:right;"}';
                //
                Items.Add('');

                //添加数据库内的值
                joItems := dwaGetItems(oQueryTmp,joConfig.table,joField.name);
                for iItem := 0 to joItems._Count-1 do begin
                    Items.Add(joItems._(iItem));
                end;
            end;
        end else if AField.type = 'integer' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"number\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'date' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"date\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'time' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"time\" step=\"1\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'datetime' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"datetime-local\" step=\"1\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else if AField.type = 'money' then begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '0.00';
                Color           := clNone;
                //
                Hint        := '{"dwattr":"type=\"number\" step=\"0.01\"","dwstyle":"border:none;text-align:right;"}';
            end;
        end else begin
            ooE := TEdit.Create(AForm);
            with ooE do begin
                Name            := 'Field'+ASuffix;
                Parent          := ooP;
                Align           := alClient;
                Alignment       := taRightJustify;
                AlignWithMargins:= True;
                Margins.Right   := 20;
                Text            := '华为电器';
                Color           := clNone;
                //
                Hint            := '{"dwstyle":"border:none;"}';

                //
                if AField.type = 'auto' then begin
                    Enabled     := False;
                end;
            end;
        end;
    end;

begin
    //取得配置JSON
    joConfig    := dwGetConfigJson(AForm);

    //检查editwidth编辑面板宽度是否存在，默认为340
    if not joConfig.Exists('editwidth') then begin
        joConfig.editwidth  := 340;
    end;
    //检查editcolcount编辑面板中列数是否存在，默认为1
    if not joConfig.Exists('editcolcount') then begin
        joConfig.editcolcount  := 1;
    end;


    //编辑/新增的总面板
    oP_Editor   := TPanel.Create(AForm);
    with oP_Editor do begin
        Name        := 'P_Editor';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Anchors     := [akBottom,akTop];
        Font.Size   := 14;
        Top         := 50;
        Width       := joConfig.editwidth;
        Height      := AForm.Height - 100;
        Hint        := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
        Font.Color  := $323232;
        Color       := clWhite;
    end;

    //标题Button
    oB_ETitle  := TButton.Create(AForm);
    with oB_ETitle do begin
        Name        := 'B_ETitle';
        Parent      := oP_Editor;
        Align       := alTop;
        Height      := 50;
        Caption     := 'Data';
        Hint        := '{"dwstyle":"background:#f0f0f0;"}';
    end;

    //用于放置 OK/Cancel 的Panel
    oP_EButtons   := TPanel.Create(AForm);
    with oP_EButtons do begin
        Name        := 'P_EButtons';
        Parent      := oP_Editor;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alBottom;
        Height      := 50;
        Color       := clNone;
    end;

    //
    oB_EOK  := TButton.Create(AForm);
    with oB_EOK do begin
        Name        := 'B_EOK';
        Parent      := oP_EButtons;
        Align       := alLeft;
        Width       := TPanel(Parent).Width div 2;
        Top         := 0;
        Left        := 0;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '确定';
        Hint        := '{"dwstyle":"background:#f0f0f0;border-top:solid 1px #dcdfd6;border-right:0px;","radius":"0px"}';
        //
        tM.Code         := @B_EOKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oB_ECancel  := TButton.Create(AForm);
    with oB_ECancel do begin
        Name        := 'B_ECancel';
        Parent      := oP_EButtons;
        Align       := alClient;
        Top         := 0;
        Left        := TPanel(Parent).Width div 2;
        Width       := TPanel(Parent).Width div 2;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '取消';
        Hint        := '{"dwstyle":"background:#f0f0f0;border:solid 1px #dcdfd6;","radius":"0px"}';
        //
        tM.Code         := @B_ECancelClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //主表编辑的ScrollBox
    oSB := TScrollBox.Create(AForm);
    with oSB do begin
        Name        := 'SB_0';
        Parent      := oP_Editor;
        Align       := alClient;
    end;

    //主表ScrollBox的内容Panel
    oP_Content   := TPanel.Create(AForm);
    with oP_Content do begin
        Name        := 'P_Content0';
        Parent      := oSB;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alTop;
        Color       := clWhite;
    end;

    //
    iEditColCnt   := 1;
    if joConfig.Exists('editcolcount') then begin
        iEditColCnt   := joConfig.editcolcount;
    end;

    //主表字段
    for iField := 0 to joConfig.fields._Count-1 do begin
        joField := joConfig.fields._(iField);
        //
        iLeft   := (iField mod iEditColCnt) * (joConfig.editwidth div joConfig.editcolcount)+10;
        iTop    := (iField div iEditColCnt) * 40;
        CreateField(iLeft,
                iTop,
                (oP_Editor.Width div iEditColCnt)-20,
                '0'+IntToStr(iField),joField,oP_Content);
    end;
    oP_Content.AutoSize := True;

    //
    if joConfig.Exists('slave') then begin
        for iSlave := 0 to joConfig.slave._Count-1 do begin
            //
            joSlave := joConfig.slave._(iSlave);

            //从表编辑的ScrollBox
            oSB := TScrollBox.Create(AForm);
            with oSB do begin
                Name        := 'SB_'+IntToStr(iSlave+1);
                Parent      := oP_Editor;
                Align       := alClient;
            end;

            //从表ScrollBox的内容Panel
            oP_Content   := TPanel.Create(AForm);
            with oP_Content do begin
                Name        := 'P_Content'+IntToStr(iSlave+1);
                Parent      := oSB;
                BevelOuter  := bvNone;
                BorderStyle := bsNone;
                Align       := alTop;
                Color       := clWhite;
            end;

            //从表字段
            for iField := 0 to joSlave.fields._Count-1 do begin
                joField := joSlave.fields._(iField);
                //
                iLeft   := (iField mod iEditColCnt) * (joConfig.editwidth div joConfig.editcolcount);
                iTop    := (iField div iEditColCnt) * 40;
                CreateField(iLeft, iTop, oP_Editor.Width div iEditColCnt,IntToStr(iSlave+1)+IntToStr(iField),joField,oP_Content);
            end;
            oP_Content.AutoSize := True;
        end;
    end;


end;


function dwCrud(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwGetEditMask = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
var
    joConfig    : variant;
    oP_QuickCrud: TPanel;
    oP_Main     : TPanel;
    oP_Slave    : TPanel;
    oP_Query    : TPanel;       //分字段查询面板 : P_Query
    oP_SpaceFB  : TPanel;       //空面板，以用于空出“精确/模糊”和“切换（多字段查询/智能模糊查询）”按钮的空间
    oP_QueryClt : TPanel;       //空面板，以用于存放FlowPanel
    oFP_Query   : TFlowPanel;   //用于多字段查询的流式布局面板
    oP_QueryFld : TPanel;       //单独字段查询面板 : P_Query0, P_Query1,...
    oP_QuerySmt : TPanel;       //智能模糊查询面板 : P_QuerySmart
    oP_MainData : TPanel;
    oP_Buttons  : TPanel;       //功能按钮面板 : P_Buttons
    oB_QueryMd  : TButton;      //切换查询模式的按钮 ： B_QueryMode
    oB_Fuzzy    : TButton;      //切换查询模式的按钮 ： B_Fuzzy 模糊/精确
    oB_Query    : TButton;      //查询按钮
    oB_Reset    : TButton;      //重置按钮
    oB_New      : TButton;
    oE_Keyword  : TEdit;
    oB_Print    : TButton;
    oPC_Slave   : TPageControl;
    oTabSheet1  : TTabSheet;
    oP_TBMain   : TPanel;       //TB_Main外部加一个面板，以放置 每页行数 框
    oTB_Main    : TTrackBar;
    oP_SButtons : TPanel;
    oB_SNew     : TButton;
    oB_SDelete  : TButton;
    oB_SEdit    : TButton;
    oB_Edit     : TButton;
    oCB_PageSize: TComboBox;    //每页显示数量
    oB_Delete   : TButton;
    oB_SPrint   : TButton;
    oFQ_Main    : TFDQuery;
    oP_Editor   : TPanel;
    oP_EButtons : TPanel;
    oB_Cancel   : TButton;
    oB_OK       : TButton;
    oSB_Demo    : TScrollBox;
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
    oP_ETitle   : TPanel;
    oL_ETitle   : TLabel;
    //
    oSG_Main    : TStringGrid;
    oSG_Slave   : TStringGrid;
    //用于指定事件
    tM          : TMethod;
    //
    joField     : variant;
    joHint      : variant;
    joCell      : variant;
    joSlave     : variant;
    joItems     : Variant;      //用于生成combo的items
    //
    iSlave      : Integer;
    iField      : Integer;
    iCount      : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    iItem       : Integer;
    //
    oTab        : TTabSheet;
    oFDQuery    : TFDQuery;
    oTB         : TTrackBar;
    oSG         : TStringGrid;
    oSB         : TScrollBox;
    oP          : TPanel;
    oQueryTmp   : TFDQuery;     //用于生成combo的临时性FDQuery
    //
    oL_Query    : TLabel;   //查询用标签
    oE_Query    : TEdit;    //查询用Edit
    oCB_Query   : TComboBox;//查询
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

    //防止重复创建
    if AForm.FindComponent('P_QuickCrud') <> nil then begin
        Exit;
    end;

    //取配置JSON : 读AForm的 qcConfig 变量值
    joConfig    := dwGetConfigJson(AForm);

    //如果不是JSON格式，则退出
    if joConfig = unassigned then begin
        Exit;
    end;

    //检查配置文件中每个字段的有效性，并补齐一些默认属性
    try
        //检查 显示字段列表fields
        for iField := 0 to joConfig.fields._Count-1 do begin
            joField := joConfig.fields._(iField);
            //如果字段没有name，则标记为配置错误
            if not joField.Exists('name') then begin
                Result  := -1;
                Exit;
            end;
            if not joField.Exists('caption') then begin     //默认显示标题为name
                joField.caption := String(joField.name);
            end;
            if not joField.Exists('type') then begin        //默认显示类型为string
                joField.type    := 'string';
            end;
            if not joField.Exists('width') then begin       //默认显示宽度
                joField.width   := 100;
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
                joField.align   := 'center';
            end;
        end;

    except
        Result  := -99;
    end;

    //生成一个临时查询，以生成Combo的列表
    oQueryTmp               := TFDQuery.Create(AForm);
    oQueryTmp.Name          := 'FDQueryTmp';
    oQueryTmp.Connection    := AConnection;


    //几个主要面板：主面板，主表面板和从表面板  ====================================================
    //总面板
    oP_QuickCRUD    := TPanel.Create(AForm);
    with oP_QuickCRUD do begin
        Parent          := AForm;
        Name            := 'P_QuickCrud';
        BevelOuter      := bvNone;
        Align           := alClient;
        Color           := clNone;
    end;
    //主表面板
    oP_Main := TPanel.Create(AForm);
    with oP_Main do begin
        Parent          := oP_QuickCRUD;
        Name            := 'P_Main';
        BevelOuter      := bvNone;
        Color           := clNone;
        //根据是否有 mainwidth 判断是水平排列还是垂直排列
        if joConfig.Exists('mainwidth') then begin
            Align       := alLeft;
            Width       := joConfig.mainwidth;
        end else begin
            if joConfig.Exists('slave') then begin
                Align       := alTop;
                AutoSize    := True;
            end else begin
                Align       := alClient;
            end;
        end;
    end;

    //从表面板
    if joConfig.Exists('slave') then begin
        oP_Slave := TPanel.Create(AForm);
        with oP_Slave do begin
            Parent          := oP_QuickCRUD;
            Name            := 'P_Slave';
            BevelOuter      := bvNone;
            Color           := clNone;
            Align           := alClient;
        end;
    end;


    //分字段查询面板 FP_Query ======================================================================
    oFP_Query   := TFlowPanel.Create(AForm);
    with oFP_Query do begin
        Parent          := oP_Main;
        Name            := 'FP_Query';
        Align           := alTop;
        Color           := clWhite;
        AutoSize        := True;
        AutoWrap        := True;
        BorderStyle     := bsSingle;
        Top             := 1000;
        Font.Size       := 11;
        Font.Color      := $646464;
        //
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 0;
        Margins.Left    := 10;
        Margins.Right   := 10;
        Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px","dwstyle":"border:solid 1px #DCDFE6;"}';
        //
        tM.Code         := @FP_QueryResize;
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
            //创建一个单字段查询面板
            oP_QueryFld := TPanel.Create(AForm);
            with oP_QueryFld do begin
                Parent          := oFP_Query;
                Name            := 'P_Query'+IntToStr(iCount);
                Color           := clNone;
                Width           := 335;
                Height          := 40;
                Tag             := iField;
            end;

            //创建查询字段标签
            oL_Query    := TLabel.Create(AForm);
            with oL_Query do begin
                Parent      := oP_QueryFld;
                Name        := 'L_Query'+IntToStr(iCount);
                Tag         := iField;
                Align       := alLeft;
                Layout      := tlCenter;
                Caption     := joField.caption + ':';
                Width       := 80;
                //
                AlignWithMargins    := True;
                Margins.Left        := 10;
            end;

            if joField.type = 'combo' then begin
                //创建查询字段EDIT
                oCB_Query   := TComboBox.Create(AForm);
                with oCB_Query do begin
                    Parent      := oP_QueryFld;
                    Name        := 'E_Query'+IntToStr(iCount);
                    Tag         := iField;
                    Align       := alClient;
                    Style       := csDropDownList;
                    Text        := '';
                    //
                    AlignWithMargins    := True;
                    Margins.Top         := 6;
                    Margins.Bottom      := 6;
                    //
                    Items.Add('');
                    for iItem := 0 to joField.list._Count-1 do begin
                        Items.Add(joField.list._(iItem));
                    end;
                end;
            end else if joField.type = 'dbcombo' then begin
                //创建数据库查询ComboBox
                oCB_Query   := TComboBox.Create(AForm);
                with oCB_Query do begin
                    Parent      := oP_QueryFld;
                    Name        := 'E_Query'+IntToStr(iCount);
                    Tag         := iField;
                    Style       := csDropDownList;
                    Text        := '';
                    Align       := alClient;
                    //
                    AlignWithMargins    := True;
                    Margins.Top         := 5;
                    Margins.Bottom      := 5;

                    //先添加一个空值
                    oCB_Query.Items.Add('');

                    //添加数据库内的值
                    joItems := dwaGetItems(oQueryTmp,joConfig.table,joField.name);
                    for iItem := 0 to joItems._Count-1 do begin
                        oCB_Query.Items.Add(joItems._(iItem));
                    end;
                end;

            //end else if joField.type = 'integer' then begin
            //    oE_Field := TEdit(oComp);
            //    oQuery.Fields[iField].AsInteger := StrToIntDef(oE_Field.text,0);
            end else if joField.type = 'date' then begin
                //创建面板存放起始结束日期
                oP_DateSE := TPanel.Create(AForm);
                with oP_DateSE do begin
                    Parent          := oP_QueryFld;
                    Name            := 'P_DateSE'+IntToStr(iCount);
                    Color           := clNone;
                    Align           := alClient;
                    Tag             := iField;
                    Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
                    //
                    AlignWithMargins    := True;
                    Margins.Top         := 4;
                    Margins.Bottom      := 4;
                    Margins.Right       := 0;
                end;

                //创建查询起始日期
                oDT_Start   := TDateTimePicker.Create(AForm);
                with oDT_Start do begin
                    Parent      := oP_DateSE;
                    Name        := 'DT_Start'+IntToStr(iCount);
                    Align       := alLeft;
                    Tag         := iField;
                    Width       := 135;
                    Height      := 28;
                    if joField.Exists('min') then begin
                        Date        := StrToDateDef(joField.min,Now);
                    end else begin
                        Date        := StrToDateDef('1900-01-01',Now);;
                    end;
                    Hint        := '{"dwattr":":clearable=\"false\""}';
                end;

                //起止日期间分隔符
                oL_Space    := TLabel.Create(AForm);
                with oL_Space do begin
                    Parent      := oP_DateSE;
                    Name        := 'L_Space'+IntToStr(iCount);
                    Tag         := iField;
                    AutoSize    := False;
                    Alignment   := taCenter;
                    Left        := 105;
                    Top         := 5;
                    Caption     := '—';
                    Width       := 20;
                end;
                //创建查询结束日期
                oDT_End   := TDateTimePicker.Create(AForm);
                with oDT_End do begin
                    Parent      := oP_DateSE;
                    Name        := 'DT_End'+IntToStr(iCount);
                    Tag         := iField;
                    Left        := 120;
                    Top         := 1;
                    Width       := 135;
                    Height      := 28;
                    if joField.Exists('max') then begin
                        Date        := StrToDateDef(joField.max,Now);
                    end else begin
                        Date        := StrToDateDef('2050-12-31',Now);;
                    end;
                    Hint        := '{"dwattr":":clearable=\"false\""}';
                end;
            end else begin
                //创建查询字段EDIT
                oE_Query    := TEdit.Create(AForm);
                with oE_Query do begin
                    Parent      := oP_QueryFld;
                    Name        := 'E_Query'+IntToStr(iCount);
                    Tag         := iField;
                    Text        := '';
                    Align       := alClient;
                    AlignWithMargins    := True;
                    Margins.Top         := 5;
                    Margins.Bottom      := 5;
                end;
            end;

            //
            Inc(iCount);
        end;
    end;

    //创建一个额外的单字段查询面板，用于存放“查询”和“重置”按钮
    oP_QueryFld := TPanel.Create(AForm);
    with oP_QueryFld do begin
        Parent          := oFP_Query;
        Name            := 'P_Query'+IntToStr(iCount);
        Color           := clNone;
        Width           := 175;
        Height          := 40;
        Tag             := -1;
    end;

    //添加“查询”和“重置”按钮
    oB_Query  := TButton.Create(AForm);
    with oB_Query do begin
        Parent          := oP_QueryFld;
        Name            := 'B_Query';
        Align           := alLeft;
        width           := 70;
        Height          := 30;
        Caption         := '查询';
        Hint            := '{"type":"primary","icon":"el-icon-search"}';
        //
        AlignWithMargins    := True;
        Margins.Top         := 6;
        Margins.Bottom      := 6;
        Margins.Left        := 10;
        Margins.Right       := 5;
        //
        tM.Code         := @B_QueryClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    oB_Reset  := TButton.Create(AForm);
    with oB_Reset do begin
        Parent          := oP_QueryFld;
        Name            := 'B_Reset';
        Align           := alLeft;
        width           := 70;
        Height          := 30;
        Left            := 100;
        Caption         := '重置';
        Hint            := '{"icon":"el-icon-refresh"}';
        //
        AlignWithMargins    := True;
        Margins         := oB_Query.Margins;
        //
        tM.Code         := @B_ResetClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //刷新 FP_Query 高度
    oFP_Query.AutoSize  := True;
    oFP_Query.AutoSize  := False;

    //如果未定义多字段查询，则销毁FP_Query
    if iCount = 0 then begin
        oFP_Query.Destroy;
    end;


    //智能查询面板 P_QuerySmart ====================================================================
    oP_QuerySmt := TPanel.Create(AForm);
    with oP_QuerySmt do begin
        Parent          := oP_Main;
        Name            := 'P_QuerySmart';
        Align           := alTop;
        BorderStyle     := bsSingle;
        Height          := 46;
        Top             := 1100;
        Color           := clWhite;
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 0;
        Margins.Left    := 10;
        Margins.Right   := 10;
        Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px","dwstyle":"border:solid 1px #DCDFE6;"}';
        //
        Visible         := iCount = 0;
    end;

    //智能查询E_Keyword
    oE_Keyword  := TEdit.Create(AForm);
    with oE_keyword do begin
        Parent          := oP_QuerySmt;
        Name            := 'E_keyword';
        Align           := alLeft;
        width           := 200;
        Text            := '';
        //
        AlignWithMargins:= True;
        Margins.Bottom  := 6;
        Margins.Left    := 10;
        Margins.Right   := 10;
        Margins.Top     := 6;
        Hint            := '{"placeholder":"请输入查询关键字","suffix-icon":"el-icon-search","dwstyle":"padding-left:10px;"}';
        //
        tM.Code         := @E_KeywordChange;
        tM.Data         := Pointer(325); // 随便取的数
        OnChange        := TNotifyEvent(tM);
    end;

    oP_MainData  := TPanel.Create(AForm);
    with oP_MainData do begin
        Parent          := oP_Main;
        Name            := 'P_MainData';
        Font.Size       := 11;
        BorderStyle     := bsSingle;
        //
        if joConfig.Exists('mainwidth') then begin
            Align           := alClient;
        end else begin
            Align           := alTop;
            Top             := 2000;
            Height          := 45 + joConfig.rowheight * ( 1 + joConfig.pagesize )+1 + 40;  //高度
        end;
        //
        Color           := clWhite;
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 10;
        Margins.Left    := 10;
        Margins.Right   := 10;
        Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px","dwstyle":"border:solid 1px #DCDFE6;"}';
    end;

    //功能按钮面板 ： P_Buttons ====================================================================
    oP_Buttons  := TPanel.Create(AForm);
    with oP_Buttons do begin
        Parent          := oP_MainData;
        Name            := 'P_Buttons';
        Align           := alTop;
        Height          := 45;
        Top             := 0;
        Font.Size       := 11;
        //
        Color           := clWhite;
        AlignWithMargins:= False;
        Margins.Top     := 10;
        Margins.Bottom  := 0;
        Margins.Left    := 10;
        Margins.Right   := 10;
    end;

    //主表打印
    oB_Print  := TButton.Create(AForm);
    with oB_Print do begin
        Parent          := oP_Buttons;
        Name            := 'B_Print';
        Align           := alLeft;
        width           := 70;
        Caption         := '打印';
        //
        AlignWithMargins:= True;
        Margins.Top     := 8;
        Margins.Bottom  := 7;
        Margins.Left    := 10;
        Margins.Right   := 0;
        Hint            := '{"type":"info","style":"plain","icon":"el-icon-printer"}';
        //
        tM.Code         := @B_PrintClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //主表删除
    oB_Delete  := TButton.Create(AForm);
    with oB_Delete do begin
        Parent          := oP_Buttons;
        Name            := 'B_Delete';
        Align           := alLeft;
        width           := 70;
        Caption         := '删除';
        //
        AlignWithMargins:= True;
        Margins         := oB_Print.Margins;
        Hint            := '{"type":"danger","style":"plain","icon":"el-icon-delete"}';
        //
        tM.Code         := @B_DeleteClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //主表新增
    oB_New  := TButton.Create(AForm);
    with oB_New do begin
        Parent          := oP_Buttons;
        Name            := 'B_New';
        Align           := alLeft;
        width           := 70;
        Caption         := '新增';
        //
        AlignWithMargins:= True;
        Margins         := oB_Print.Margins;
        Hint            := '{"type":"success","style":"plain","icon":"el-icon-circle-plus-outline"}';
        //
        tM.Code         := @B_NewClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end ;
    //主表编辑
    oB_Edit  := TButton.Create(AForm);
    with oB_Edit do begin
        Parent          := oP_Buttons;
        Name            := 'B_Edit';
        Align           := alLeft;
        width           := 70;
        Caption         := '编辑';
        //
        AlignWithMargins:= True;
        Margins         := oB_Print.Margins;
        Hint            := '{"type":"primary","style":"plain","icon":"el-icon-edit-outline"}';
        //
        tM.Code         := @B_EditClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //查询模式：智能模糊 / 多字段
    oB_QueryMd  := TButton.Create(AForm);
    with oB_QueryMd do begin
        Parent          := oP_Buttons;
        Name            := 'B_QueryMode';
        Anchors         := [akRight,akTop];
        width           := 30;
        Font.Size       := 11;
        Font.Color      := $A0A0A0;
        Caption         := '';
        Cancel          := True;
        Hint            := '{"style":"plain","icon":"el-icon-sort"}';
        Align           := alRight;
        //
        AlignWithMargins:= True;
        Margins.Top     := 8;
        Margins.Bottom  := 7;
        Margins.Left    := 3;
        Margins.Right   := 10;
        //
        tM.Code         := @B_QueryModeClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //模糊 / 精确
    oB_Fuzzy  := TButton.Create(AForm);
    with oB_Fuzzy do begin
        Parent          := oP_Buttons;
        Name            := 'B_Fuzzy';
        Anchors         := [akRight,akTop];
        width           := 30;
        Font.Size       := 11;
        Font.Color      := $A0A0A0;
        Caption         := '';
        Cancel          := True;
        Hint            := '{"style":"plain","icon":"el-icon-open"}';
        Align           := alRight;
        //
        AlignWithMargins:= True;
        Margins.Top     := 8;
        Margins.Bottom  := 7;
        Margins.Left    := 0;
        Margins.Right   := 0;
        //
        tM.Code         := @B_FuzzyClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
        //
        Visible         := iCount > 0;
    end;

    //设置显示默认查询模式 defaultquerymode
    if joConfig.Exists('defaultquerymode') then begin
        oB_QueryMd.Tag  := joConfig.defaultquerymode + 1;
    end else begin
        if iCount > 0 then begin
            oB_QueryMd.Tag  := 0;   //-1=2, 即多字段模式
        end else begin
            oB_QueryMd.Tag  := 2;   //-1=1，即智能模糊模式
        end;
    end;
    oB_QueryMd.OnClick(oB_QueryMd);

    //主表表格 =====================================================================================
    oSG_Main  := TStringGrid.Create(AForm);
    with oSG_Main do begin
        Parent          := oP_MainData;
        Name            := 'SG_Main';
        Top             := 3000;
        Hint            := '{"dwattr":"stripe border","dwstyle":"border-radius:0;"}';
        //
        Color           := clWhite;
        AlignWithMargins:= False;
        Margins.Top     := 0;
        Margins.Bottom  := 0;
        Margins.Left    := 3;
        Margins.Right   := 2;
        //
        if joConfig.Exists('mainwidth') then begin
            Align           := alClient;
        end else begin
            Align           := alTop;
            Height          := joConfig.rowheight * ( 1 + joConfig.pagesize )+1;  //高度
        end;
        RowCount        := joConfig.pagesize + 1;  //行数
        DefaultRowHeight:= joConfig.rowheight;     //行高
        ColCount        := joConfig.fields._count; //列数
        FixedCols       := 0;                       //固定列数
        //
        Font.Color      := $00969696;
        //
        AlignWithMargins:= True;
        //
        tM.Code         := @SG_MainClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
        //
        //
        tM.Code         := @SG_MainGetEditMask;
        tM.Data         := Pointer(325); // 随便取的数
        OnGetEditMask   := TdwGetEditMask(tM);
    end;


    //主表分页(外框) ===============================================================================
    oP_TBMain    := TPanel.Create(AForm);
    with oP_TBMain do begin
        Parent          := oP_MainData;
        Name            := 'P_TBMain';
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
    oTB_Main    := TTrackBar.Create(AForm);
    with oTB_Main do begin
        Parent          := oP_TBMain;
        Name            := 'TB_Main';
        Align           := alClient;
        HelpKeyword     := 'page';
        Hint            := '{"dwattr":"background"}';
        //
        AlignWithMargins:= True;
        //
        tM.Code         := @TB_MainChange;
        tM.Data         := Pointer(325); // 随便取的数
        OnChange        := TNotifyEvent(tM);
    end;

    //每页行数
    if joConfig.Exists('pagesizelist') then begin
        oCB_PageSize    := TComboBox.Create(AForm);
        with oCB_PageSize do begin
            Parent          := oP_TBMain;
            Name            := 'CB_PageSize';
            Anchors         := [akRight,akTop];
            width           := 70;
            Top             := 5;
            Style           := csDropDownList;
            Left            := oP_TBMain.Width - 20 - 100 - 70;


            //添加每页行数的选项
            for iItem := 0 to joConfig.pagesizelist._Count-1 do begin
                Items.Add(IntToStr(joConfig.pagesizelist._(iItem)));
            end;
            //
            ItemIndex   := Items.IndexOf(IntToStr(joConfig.pagesize));

            //
            tM.Code         := @CB_PageSizeChange;
            tM.Data         := Pointer(325); // 随便取的数
            OnChange       := TNotifyEvent(tM);
        end;
    end;

    //从表PageControl ==============================================================================
    oPC_Slave  := TPageControl.Create(AForm);
    with oPC_Slave do begin
        Parent          := oP_Slave;
        Name            := 'PC_Slave';
        Align           := alClient;
        Hint            := '{"dwstyle":"border-top:solid 1px #dcdfe6;border-radius:'+IntToStr(joConfig.radius)+'px;overflow:hidden;"}';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        Margins.Bottom  := 12;
        //根据是否水平排列
        if joConfig.Exists('mainwidth') then begin
            Margins.Top     := 10;
            Margins.Left    := 0;
        end else begin
            Margins.Left    := 10;
            Margins.Top     := 0;
        end;
        //
        tM.Code         := @PC_SlaveChange;
        tM.Data         := Pointer(325); // 随便取的数
        OnChange        := TNotifyEvent(tM);
    end;

    //创建从表的增删改打按钮------------------------------------------------------------------------
    //panel容器
    oP_SButtons := TPanel.Create(AForm);
    with oP_SButtons do begin
        Parent          := oP_Slave;
        Name            := 'P_SButtons';
        Anchors         := [akTop,akRight];
        Font.Size       := 11;
        //BevelOuter      := bvNone;
        //BevelKind       := bkFlat;
        Color           := clNone;
        Left            := oP_Slave.Width - 415;
        Top             := oPC_Slave.Top + 1;
        Height          := 38;
        Width           := 400;
    end;
    //
    oB_SPrint  := TButton.Create(AForm);
    with oB_SPrint do begin
        Parent          := oP_SButtons;
        Name            := 'B_SPrint';
        Align           := alRight;
        width           := 70;
        Caption         := '打印';
            //Caption     := '';
            //Width       := 32;
            //Cancel      := True;
        //
        AlignWithMargins:= True;
        Margins.Top     := 6;
        Margins.Bottom  := 4;
        Hint            := '{"type":"info","style":"plain","icon":"el-icon-printer"}';
        Visible         := False;
        //
        tM.Code         := @B_SPrintClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //
    oB_SDelete  := TButton.Create(AForm);
    with oB_SDelete do begin
        Parent          := oP_SButtons;
        Name            := 'B_SDelete';
        Align           := alRight;
        width           := 70;
        Caption         := '删除';
        Visible         := False;
            //Caption     := '';
            //Width       := 32;
            //Cancel      := True;
        //
        AlignWithMargins:= True;
        Margins.Top     := 6;
        Margins.Bottom  := 4;
        Hint            := '{"type":"danger","style":"plain","icon":"el-icon-delete"}';
        //
        tM.Code         := @B_SDeleteClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //
    oB_SNew  := TButton.Create(AForm);
    with oB_SNew do begin
        Parent          := oP_SButtons;
        Name            := 'B_SNew';
        Align           := alRight;
        width           := 70;
        Caption         := '新增';
        Visible         := False;
            //Caption     := '';
            //Width       := 32;
            //Cancel      := True;
        //
        AlignWithMargins:= True;
        Margins.Top     := 6;
        Margins.Bottom  := 4;
        Hint            := '{"type":"success","style":"plain","icon":"el-icon-circle-plus-outline"}';
        //
        tM.Code         := @B_SNewClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end ;
    //
    oB_SEdit  := TButton.Create(AForm);
    with oB_SEdit do begin
        Parent          := oP_SButtons;
        Name            := 'B_SEdit';
        Align           := alRight;
        width           := 70;
        Caption         := '编辑';
        Visible         := False;
            //Caption     := '';
            //Width       := 32;
            //Cancel      := True;
        //
        AlignWithMargins:= True;
        Margins.Top     := 6;
        Margins.Bottom  := 4;
        Hint            := '{"type":"primary","style":"plain","icon":"el-icon-edit-outline"}';
        //
        tM.Code         := @B_SEditClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;


    //----------------------------------------------------------------------------------------------
    //配置 oFQ_Main 的连接
    oFQ_Main            := TFDQuery.Create(AForm);
    oFQ_Main.Name       := 'FQ_Main';
    oFQ_Main.Connection := AConnection;


    //显示/隐藏 增删改印按钮
    oB_New.Visible      := joConfig.new = 1;
    oB_Edit.Visible     := joConfig.edit = 1;
    oB_Print.Visible    := joConfig.print = 1;
    oB_Delete.Visible   := joConfig.delete = 1;

    //<得到Hint的JSON对象（以更新rowheight、dataset）
    joHint  := _json(oSG_Main.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    //行高
    joHint.rowheight    := joConfig.rowheight;
    joHint.headerheight := joConfig.rowheight;
    //
    joHint.dataset      := 'FQ_Main';

    //返写到Hint中
    oSG_Main.Hint := joHint;
    //>

    //<-----根据配置信息更新SG_Main
    oSG_Main.Height          := joConfig.rowheight * ( 1 + joConfig.pagesize )+1;  //高度
    oSG_Main.RowCount        := joConfig.pagesize + 1;  //行数
    oSG_Main.DefaultRowHeight:= joConfig.rowheight;     //行高
    oSG_Main.ColCount        := joConfig.fields._count; //列数
    oSG_Main.FixedCols       := 0;                       //固定列数

    //配置各列参数
    for iField := 0 to joConfig.fields._count - 1 do begin
        //得到字段对象
        joField := joConfig.fields._(iField);

        //生成各列参数配置的JSON字符串
        joCell          := _json('{}');         //列参数写在每列的第一行中，JSON格式
        joCell.caption  := joField.caption;     //显示标题
        joCell.sort     := joField.sort = 1;    //是否显示排序按钮
        joCell.align    := joField.align;       //对齐方式，left/center/right. 默认center

        //Cells[1,0] := '{"caption":"名称","sort":true,"filter":["净水管道","暖气片","电视机","空调","热水器","LG笔记本"]}';
        oSG_Main.Cells[iField,0]   := joCell;

        //列宽
        oSG_Main.ColWidths[iField] := joField.width;
    end;

    //>

    //更新页码
    oTB_Main.Position    := 0;

    //更新从表
    if not joConfig.Exists('slave') then begin
        oPC_Slave.Visible   := False;   //不显示从表的PageControl
        oP_SButtons.Visible := False;   //不显示从表的按钮组
        //更新主表元素对齐方式
        oSG_Main.Align      := alClient;
        oP_TBMain.Align      := alBottom;
    end else begin
        //先删除原有的TabSheet
        for iSlave := oPC_Slave.PageCount-1 downto 0 do begin
            oPC_Slave.Pages[iSlave].Destroy;
        end;
        //创建从表 以及从表的Order
        for iSlave := 0 to joConfig.slave._Count-1 do begin
            //
            joSlave := joConfig.slave._(iSlave);

            //检查补齐编辑、新增、删除、打印按钮的可用性
            if not joSlave.Exists('edit') then begin
                joSlave.edit    := 1;
            end;
            if not joSlave.Exists('new') then begin
                joSlave.new    := 1;
            end;
            if not joSlave.Exists('delete') then begin
                joSlave.delete    := 1;
            end;
            if not joSlave.Exists('print') then begin
                joSlave.print    := 1;
            end;

            //创建TabSheet
            oTab                := TTabSheet.Create(AForm);
            with oTab do begin
                Name            := 'TS_'+IntToStr(iSlave);
                PageControl     := oPC_Slave;
                Caption         := joSlave.caption;
                ImageIndex      := joSlave.imageindex;
                ImageName       := ''; //从表的Order
            end;

            //创建FDQuery
            oFDQuery                := TFDQuery.Create(AForm);
            oFDQuery.Name           := 'FQ_'+IntToStr(iSlave);
            oFDQuery.Connection     := AConnection;

            //创建
            oSG             := TStringGrid.Create(AForm);
            with oSG do begin
                Parent          := oTab;
                BorderStyle     := bsNone;
                Name            := 'SG_'+IntToStr(iSlave);
                Align           := alClient;
                Hint            := '{"dwattr":"border stripe","dataset":"'+oFDQuery.Name+'","rowheight":35,"headerheight":35}';


                Height          := joConfig.rowheight * ( 1 + joConfig.slavepagesize )+1;  //高度
                RowCount        := joConfig.slavepagesize + 1;  //行数
                DefaultRowHeight:= joConfig.rowheight;     //行高
                ColCount        := joSlave.fields._count; //列数
                FixedCols       := 0;                       //固定列数
                //
                tM.Code         := @SG_SlaveClick;
                tM.Data         := Pointer(325); // 随便取的数
                OnClick         := TNotifyEvent(tM);
                //
                //
                tM.Code         := @SG_SlaveGetEditMask;
                tM.Data         := Pointer(325); // 随便取的数
                OnGetEditMask   := TdwGetEditMask(tM);
            end;
            //oSG.OnGetEditMask       := SG_MainGetEditMask;
            //oSG.OnClick             := SG_SlaveClick;

            //配置各列参数
            for iField := 0 to joSlave.fields._count - 1 do begin
                //得到字段对象
                joField := joSlave.fields._(iField);
                //
                if not joField.Exists('caption') then begin     //默认显示标题为name
                    joField.caption := String(joField.name);
                end;
                if not joField.Exists('type') then begin        //默认显示类型为string
                    joField.type    := 'string';
                end;
                if not joField.Exists('width') then begin       //默认显示宽度
                    joField.width   := 100;
                end;
                if not joField.Exists('sort') then begin        //默认不排序
                    joField.sort    := 0;
                end;
                if not joField.Exists('align') then begin       //默认居中显示
                    joField.align   := 'center';
                end;

                //生成各列参数配置的JSON字符串
                joCell          := _json('{}');         //列参数写在每列的第一行中，JSON格式
                joCell.caption  := joField.caption;     //显示标题
                joCell.sort     := joField.sort = 1;    //是否显示排序按钮
                joCell.align    := joField.align;       //对齐方式，left/center/right. 默认center

                //Cells[1,0] := '{"caption":"名称","sort":true,"filter":["净水管道","暖气片","电视机","空调","热水器","LG笔记本"]}';
                oSG.Cells[iField,0]   := joCell;

                //列宽
                oSG.ColWidths[iField] := joField.width;
            end;

            //创建分页
            oTB             := TTrackBar.Create(AForm);
            with oTB do begin
                Name            := 'TB_'+IntToStr(iSlave);
                Parent          := oTab;
                Align           := alBottom;
                Hint            := '{"dwattr":"background"}';
                Height          := 40;
                PageSize        := joConfig.slavepagesize;
                HelpKeyword     := 'page';
                Position        := 0;
                AlignWithMargins:= True;
                Margins.Top     := 5;
                Margins.Bottom  := 5;
                //
                tM.Code         := @TB_SlaveChange;
                tM.Data         := Pointer(325); // 随便取的数
                OnChange        := TNotifyEvent(tM);
            end;

        end;
        oPC_Slave.ActivePageIndex   := 0;

        //更新从表功能按钮的位置
        //oP_SButtons.Top  := oPC_Slave.Top+7;
    end;

    //更新数据
    _UpdateMain(AForm);
    _UpdateSlaves(AForm);


    //切换从表PageControl,以显示数据
    if joConfig.Exists('slave') then begin
        oPC_Slave.OnChange(oPC_Slave);
    end;

    //创建确定面板P_Confirm
    CreateConfirmPanel(AForm);

    //创建编辑面板P_Editor
    CreateEditorPanel(AForm);

end;


end.
