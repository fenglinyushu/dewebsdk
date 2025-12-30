unit dwQuickTree;
{
功能说明：
    主要用于快速生成基于单表的树形数据管理模块

## dwQuickTree的命名规则：
 - 下划线前的字母表示类型，
    B=Button, P=Panel, E=Edit,
    PC=PageControl, FP=FlowPanel,  CB=ComboBox,  SG=StringGrid，TB=TrackBar ,TV = TreeView
 - 下划后面:
   带E的表示是编辑/新增框内控件，
   带S表示为从表（Slave）,如B_SEdit
   带D表示删除（Delete）,如B_DOK,B_DCancel
 - 最后面的单词表示功能，如B_SNew,B_ECancel

更新说明：
--------------------------------------------------------------------------------
2024-04-12
    1、创建本文件
}

interface
uses
    //
    dwBase,
    dwDB,
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
    Math,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;

//一键生成Card模块
function  dwTree(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

procedure qtUpdateMain(AForm:TForm;AWhere:String);

//取QuickTree模块的 FDQuery 控件，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function qtGetQuickTreeFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;

//取QuickTree模块的 ListView 控件，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function qtGetQuickTreeListView(AForm:TForm;AIndex:Integer):TListView;

//取QuickTree模块的SQL语句，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function qtGetQuickTreeSQL(AForm:TForm;AIndex:Integer):String;

implementation

function qtAppend(
    AForm:TForm;        //控件所在窗体
    APrefix:String;     //控件名称的前缀，用于查找控件
    AQuery:TFDQuery;    //数据查询
    AFields:Variant;    //字段列表JSON
    AMasterValue:String;//主从表对应的主表字段值
    ASlaveName:String  //主从表对应的从表字段名称
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

            //处理主从表关联字段
            if joField.name = ASlaveName then begin
                if joField.type = 'integer' then begin
                    AQuery.Fields[iField].AsInteger  := StrToIntDef(AMasterValue,0);
                    oE          := TEdit(oComp);
                    oE.Text     := AQuery.Fields[iField].AsString;
                    oE.Enabled  := False;
                end else begin
                    AQuery.Fields[iField].AsString   := AMasterValue;
                    oE          := TEdit(oComp);
                    oE.Text     := AQuery.Fields[iField].AsString;
                    oE.Enabled  := False;
                end;
            end;
        end;
    except
    end;
end;



function qtGetQuickTreeFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;
begin
    if AIndex = 0 then begin
        Result  := TFDQuery(AForm.FindComponent('FQ_Main'));
    end else begin
        Result  := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(AIndex-1)));
    end;
end;
function qtGetQuickCrudListView(AForm:TForm;AIndex:Integer):TListView;
begin
    if AIndex = 0 then begin
        Result  := TListView(AForm.FindComponent('SG_Main'));
    end else begin
        Result  := TListView(AForm.FindComponent('SG_'+IntToStr(AIndex-1)));
    end;
end;



function qtGetQuickTreeListView(AForm:TForm;AIndex:Integer):TListView;
begin
    if AIndex = 0 then begin
        Result  := TListView(AForm.FindComponent('LV_Main'));
    end else begin
        Result  := TListView(AForm.FindComponent('LV_'+IntToStr(AIndex-1)));
    end;
end;

//通过rtti为form的 qtConfig 变量 赋值
function qtSetConfig(AForm:TForm;AConfig:String):Integer;
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
//通过rtti读form的 qtConfig 变量
function qtGetConfig(AForm:TForm):String;
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
        oRF := oRT.GetField('qtConfig');
        if oRF <> nil then begin
            Result  := oRF.GetValue(AForm).AsString;
        end;
    finally
        oRC.Free;
    end;
end;

function qtGetConfigJson(AForm:TForm):Variant;
var
    iField      : Integer;
    //
    joField     : Variant;
begin
    //取配置JSON : 读AForm的 qtConfig 变量值
    Result  := _json(qtGetConfig(AForm));
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
    if not Result.Exists('treewidth') then begin//默认数据行的行高
        Result.treewidth  := 300;
    end;
    if not Result.Exists('pagesize') then begin  //默认数据每页显示的行数
        Result.pagesize  := 5;
    end;
    if not Result.Exists('rowheight') then begin//默认数据行的行高
        Result.rowheight  := 45;
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
    if not Result.Exists('button') then begin   //默认显示按钮框（增加、删除、编辑、模式切换）
        Result.button  := 1;
    end;
    if not Result.Exists('print') then begin    //默认显示打印按钮
        Result.print  := 1;
    end;
    if not Result.Exists('switch') then begin    //默认显示查询模式切换按钮
        Result.switch   := 1;
    end;
    if not Result.Exists('query') then begin    //默认显示打印按钮
        Result.query  := 1;
    end;
    if not Result.Exists('fields') then begin    //显示的字段列表
        Result.fields  := _json('[]');
    end;
    if not Result.Exists('margin') then begin //默认边距
        Result.margin := 10;
    end;
    if not Result.Exists('radius') then begin //默认表名
        Result.radius := 5;
    end;
    if not Result.Exists('datawidth') then begin //数据编辑框的宽度
        Result.datawidth := 320;
    end;
    if not Result.Exists('editwidth') then begin //数据编辑框的宽度
        Result.editwidth := 360;
    end;
    if not Result.Exists('buttoncaption') then begin //按钮显示标题设置
        Result.buttoncaption    := 1;  //0:全不显示,1:全显示,2:左显右侧(隐藏/显示,模糊/精确,查询模式)不显
    end;
    if not Result.Exists('cardstyle') then begin //默认表名
        Result.cardstyle    := 'background: #f0f0f0;';
    end;
    if not Result.Exists('cardheight') then begin//默认数据行的行高
        Result.cardheight   := 140;
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
        if not joField.Exists('align') then begin       //对齐方式，默认为左对齐
            joField.align := 'left';
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


    //>
end;

function  qtGetQuickTreeSQL(AForm:TForm;AIndex:Integer):String;
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

Procedure EKwChange(Self: TObject; Sender: TObject);
var
    oEKw  : TEdit;
    oForm       : TForm;
    oTB_Main    : TTrackBar;
begin
    //取得各控件
    oEKw  := TEdit(Sender);
    oForm       := TForm(oEKw.Owner);
    oTB_Main    := TTrackBar(oForm.FindComponent('TB_Main'));

    //
    oTB_Main.Position   := 0;

    //
    qtUpdateMain(TForm(TEdit(Sender).Owner),'');
end;

Procedure FP_QueryResize(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oFP_Query   : TFlowPanel;
    oPBs  : TPanel;
    oLV_Main    : TListView;
    oP_TBMain   : TPanel;
    oChange     : Procedure(Sender:TObject) of Object;
    oP_SButtons : TPanel;
begin
    //取得各控件
    oFP_Query   := TFlowPanel(Sender);
    oForm       := TForm(oFP_Query.Owner);
    oPBs  := TPanel(oForm.FindComponent('PBs'));
    oLV_Main    := TListView(oForm.FindComponent('LV_Main'));
    oP_TBMain   := TPanel(oForm.FindComponent('P_TBMain'));
    oP_SButtons := TPanel(oForm.FindComponent('P_SButtons'));
    //控制各控件大小位置信息
    if oP_TBMain <> nil then begin
        //
        oChange     := oFP_Query.OnResize;
        oFP_Query.OnResize  := nil;
        oFP_Query.AutoSize  := True;
        oFP_Query.AutoSize  := False;
        //
        oPBs.Top      := oFP_Query.top + oFP_Query.Height + 10;
        oLV_Main.Top        := oPBs.Top + oPBs.Height;
        //
        oLV_Main.Height := oP_TBMain.Top - oLV_Main.Top;
        //
        oFP_Query.OnResize  := oChange;
    end;
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
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-c-scale-to-original"}';
        oButton.Caption := '精确';
    end else begin
        //模糊
        oButton.Tag     := 0;
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-open"}';
        oButton.Caption := '模糊';
    end;
end;

Procedure B_QueryClick(Self: TObject; Sender: TObject);
var
    oB_Query    : TButton;
    oForm       : TForm;
    oTB_Main    : TTrackBar;
begin
    //dwMessage('B_QueryClick','',TForm(TEdit(Sender).Owner));

    //
    oB_Query    := TButton(Sender);
    oForm       := TForm(oB_Query.Owner);
    oTB_Main    := TTrackBar(oForm.FindComponent('TB_Main'));

    //置标志，表示已查询，即当前查询条件有效
    TButton(Sender).Tag := 1;

    //
    oTB_Main.Position   := 0;

    //更新主表
    qtUpdateMain(TForm(TEdit(Sender).Owner),'');
end;

Procedure B_QCloseClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oP_Query    : TPanel;
begin
    //dwMessage('B_QCloseClick','',TForm(TEdit(Sender).Owner));

    //
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Query    := TPanel(oForm.FindComponent('P_Query'));

    //关闭查询窗体
    oP_Query.Visible    := False;
end;

Procedure B_QMaxClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oForm1      : TForm;
    oP_Query    : TPanel;
    oQuery      : TFDQuery;
    oFP_Content : TFlowPanel;
    //
    iItem       : Integer;
    //
    joConfig    : variant;

begin
    //dwMessage('B_QMaxClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Query    := TPanel(oForm.FindComponent('P_Query'));

    //
    if oForm.Owner <> nil then begin
        oForm1  := TForm(oForm.Owner);
    end else begin
        oForm1  := oForm;
    end;

    //
    joConfig    := qtGetConfigJson(oForm);

    //
    if oForm1.Width < 500 then begin
        if oP_Query.Width = Min(oForm1.width-20,joConfig.editwidth) then begin
            //标志当前最大化
            oButton.Tag := 9;
            //最大化
            oP_Query.Width      := oForm1.Width - 20;
            oP_Query.Top        := 10;
            oP_Query.Height     := oForm1.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oP_Query.Width     := Min(oForm1.width-20,joConfig.editwidth);
            oP_Query.Top       := 10;
            oP_Query.Height    := oForm1.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end;
    end else begin
        //标志当前正常大小
        oButton.Tag := 0;

        //正常界面
        if oP_Query.Width = Min(oForm1.width-100,joConfig.editwidth) then begin
            oP_Query.Width     := oForm1.width-100;
            oP_Query.Top       := 50;
            oP_Query.Height    := oForm1.Height - 100;
            oButton.Hint       := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oP_Query.Width      := Min(oForm1.Width - 100,joConfig.editwidth);
            oP_Query.Top        := 50;
            oP_Query.Height     := oForm.Height - 100;
            oButton.Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        end;
    end;

end;

Procedure B_QOKClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oP_Query    : TPanel;
    oSB_Q       : TScrollBox;
    oFP_Content : TFlowPanel;
    oP_QueryFld : TPanel;
    oCtrl       : TComponent;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oE_Query    : TEdit;
    oCB_Query   : TComboBox;
    oB_Fuzzy    : TButton;

    //
    iField      : Integer;
    iItem       : Integer;
    //
    sWhere      : string;   //主表的关键字段值
    sType       : string;
    sStart,sEnd : String;
    //
    joConfig    : variant;
    joField     : Variant;
    joTemp      : Variant;
begin
    //=====
    //说明：将查询条件写入对应的ScrollBox中，如："where":((ID<10) AND (name like '%west%'))
    //=====

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Query    := TPanel(oForm.FindComponent('P_Query'));
    oB_Fuzzy    := TButton(oForm.FindComponent('B_Fuzzy'));

    //
    joConfig    := qtGetConfigJson(oForm);


    //
    oP_Query.Visible    := False;
end;

Procedure B_QResetClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oP_Query    : TPanel;
    oFP_Content : TFlowPanel;
    oSB_Q       : TScrollBox;
    oP_QueryFld : TPanel;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oE_Query    : TEdit;
    oCB_Query   : TComboBox;
    oB_Fuzzy    : TButton;

    //
    iItem       : Integer;
    iField      : Integer;
    //
    sType       : string;
    sStart,sEnd : String;

    //
    joConfig    : variant;
    joField     : Variant;
    joTemp      : Variant;
begin
    //=====
    //说明：清空ScrollBox中的查询条件
    //=====

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oP_Query    := TPanel(oForm.FindComponent('P_Query'));

    //
    joConfig    := qtGetConfigJson(oForm);

end;

Procedure B_ResetClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oB_Query    : TButton;
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
    oB_Query    := TButton(oForm.FindComponent('B_Query'));


    //置标志，表示未处于查询状态，即当前查询条件无效
    oB_Query.Tag    := 1;

    //取得配置JSON对象
    joConfig    := _json(qtGetConfig(oForm));
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
                oDT_End.Date    := StrToDateDef('2500-12-31',Now);;
            end;
        end else if joField.type = 'datetime' then begin
            //取得起始结束日期控件
            oDT_Start   := TDateTimePicker(TPanel(oP_QueryFld.Controls[1]));
            //
            if oDT_Start.HelpContext = 1 then begin
                if joField.Exists('min') then begin
                    oDT_Start.Date  := StrToDateTimeDef(String(joField.min),Now);
                end else begin
                    oDT_Start.Date  := StrToDateTimeDef('1900-01-01 00:00:00',Now);;
                end;
            end;
            //
            if oDT_Start.HelpContext = -1 then begin
                if joField.Exists('max') then begin
                    oDT_Start.Date  := StrToDateTimeDef(String(joField.max),Now);
                end else begin
                    oDT_Start.Date  := StrToDateTimeDef('2500-12-31 23:59:59',Now);;
                end;
            end;
        end else if (joField.type = 'combo') OR (joField.type = 'dbcombo') then begin
            oCB_Query   := TComboBox(oP_QueryFld.Controls[1]);
            oCB_Query.ItemIndex := 0;
        end else begin
            oE_Query        := TEdit(oP_QueryFld.Controls[1]);
            oE_Query.Text   := '';
        end;
    end;

    qtUpdateMain(TForm(TEdit(Sender).Owner),'');
end;

Procedure CB_PageSizeChange(Self: TObject; Sender: TObject);
var
    oCB_PageSize: TComboBox;
    oForm       : TForm;
    oLV_Main    : TListView;
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
    oLV_Main    := TListView(oForm.FindComponent('LV_Main'));
    //取得当前配置
    joConfig            := qtGetConfigJson(oForm);
    //更新配置,保存PageSize
    iOldPageSz          := joConfig.pagesize;
    iNewPageSz          := StrToIntDef(oCB_PageSize.Text,iOldPageSz);
    joConfig.pagesize   := iNewPageSz;
    qtSetConfig(oForm,joConfig);
    //
    if iNewPageSz > iOldPageSz then begin
        for iItem := iOldPageSz to iNewPageSz -1 do begin
            //dwSGAddRow(oLV_Main);
        end;
        ////oLV_Main.RowCount   := 1 + iNewPageSz;
        //更新数据
        qtUpdateMain(TForm(TEdit(Sender).Owner),'');
    end;
    //
    if iNewPageSz < iOldPageSz then begin
        for iItem := iOldPageSz-1 downto iNewPageSz do begin
            //dwSGDelRow(oLV_Main);
        end;
        ////oLV_Main.RowCount   := 1 + iNewPageSz;
        //更新数据
        qtUpdateMain(TForm(TEdit(Sender).Owner),'');
    end;
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
    sMValue     : string;   //主表的关键字段值
    //
    joConfig    : variant;
begin
    //dwMessage('B_DOKClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('P_Delete'));


    //oTB_Main    := TTrackBar(oForm.FindComponent('TB_Main'));
    //默认到第1页
    //oTB_Main.Position   := 0;

    //取得配置JSON对象
    joConfig    := _json(qtGetConfig(oForm));
    //根据 oPanel.Tag 区分当前删除的是主表，还是从表
    //0：表示主表，其他表示从表，1：从表0
        oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

        //
        oQuery.Delete;
        //
        qtUpdateMain(oForm,'');
    //
    oPanel.Visible  := False;
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
    oQueryTmp   : TFDQuery;
    oSQuery     : TFDQuery;
    oB_ECancel  : TButton;
    oP_Editor   : TPanel;
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
    oP_Editor   := TPanel(oForm.FindComponent('P_Editor'));
    oB_ECancel  := TButton(oForm.FindComponent('B_ECancel'));   //取消按钮，用于记录是否批量新增过
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CK_EBatch'));

    //取得Query备用
    oQueryTmp   := TFDQuery(oForm.FindComponent('FDQueryTmp'));

    //<保存前激活Form的OnDragDrop事件
    if Assigned(oForm.OnDragDrop) then begin
        oForm.OnDragDrop(oForm,nil,oP_Editor.Tag,0)
    end;
    //>


    //取得配置JSON对象
    joConfig    := _json(qtGetConfig(oForm));
    //用 P_Editor 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oP_Editor.Tag of
        0 : begin   //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            //更新数值
            oQuery.Edit;
            for iField := 0 to joConfig.fields._Count -1 do begin

                //得到字段JSON对象
                joField := joConfig.fields._(ifield);

                //保存当前字段值，以用于防重
                sOldValue   := oQuery.Fields[iField].AsString;

                //
                oComp   := oForm.FindComponent('Field0'+IntToStr(iField));
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
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            //更新数值
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);
                //
                oComp   := oForm.FindComponent('Field0'+IntToStr(iField));
                if joField.type = 'auto' then begin
                    Continue;
                end else if joField.type = 'check' then begin
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
                qtAppend(oForm,
                    'Field'+'0',
                    oQuery,
                    joConfig.fields,
                    '',
                    '');
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
                qtUpdateMain(oForm,'');
            end;
        end;
    end;

    //<保存后激活Form的OnDragOver事件
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,oP_Editor.Tag,0,TDragState(0),bAccept)
    end;
    //>
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
        100 : begin     //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
    end;
    //
    oP_Editor.Visible  := False;

    //更新显示（仅tag=999时，此时表示已批量增加）
    if oButton.Tag = 999 then begin
        oButton.Tag := 0;
        //用 P_Editor 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oP_Editor.Tag of
            0,100 : begin
                qtUpdateMain(oForm,'');
            end;
        end;
    end;
end;


Procedure B_EditClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oB_Edit     : TButton;
    oP_Editor   : TPanel;
    oB_ETitle   : TButton;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oDT         : TDateTimePicker;
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
    oB_ETitle   := TButton(oForm.FindComponent('B_ETitle'));
    oQuery      := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CK_EBatch'));
    //
    oCK_EBatch.Visible  := False;

    //
    oB_ETitle.Caption   := '编  辑';

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
    joConfig    := qtGetConfigJson(oForm);
    //更新字段值
    for iItem := 0 to oQuery.FieldCount-1 do begin
        joField := joConfig.fields._(iItem);
        oComp   := oForm.FindComponent('Field'+'0'+IntToStr(iItem));
        if joField.type = 'boolean' then begin
            if joField.Exists('list') then begin
                oCB         := TComboBox(oComp);
                if oQuery.Fields[iItem].AsBoolean then begin
                    oCB.Text    := joField.list._(1);
                end else begin
                    oCB.Text    := joField.list._(0);
                end;
            end else begin
                oE          := TEdit(oComp);
                oE.Text     := oQuery.Fields[iItem].AsString;
            end;
        end else if joField.type = 'check' then begin
            Continue;
        end else if joField.type = 'combo' then begin
            oCB         := TComboBox(oComp);
            oCB.Text    := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'dbcombo' then begin
            oCB         := TComboBox(oComp);
            oCB.Text    := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'integer' then begin
            oE          := TEdit(oComp);
            oE.Text     := oQuery.Fields[iItem].AsString;
        end else if joField.type = 'date' then begin
            oDT         := TDateTimePicker(oComp);
            oDT.Kind    := dtkDate;
            oDT.Date    := oQuery.Fields[iItem].AsDateTime;
        end else if joField.type = 'time' then begin
            oDT         := TDateTimePicker(oComp);
            oDT.Kind    := dtkTime;
            oDT.Time    := oQuery.Fields[iItem].AsDateTime;
        end else if joField.type = 'datetime' then begin
            oDT         := TDateTimePicker(oComp);
            oDT.DateTime:= oQuery.Fields[iItem].AsDateTime;
        end else if joField.type = 'money' then begin
            oE          := TEdit(oComp);
            oE.Text     := oQuery.Fields[iItem].AsString;
        end else begin
            oE          := TEdit(oComp);
            oE.Text     := oQuery.Fields[iItem].AsString;
        end;

        //设置只读（编辑时只读，新增时可编辑）
        if joField.type <> 'auto' then begin
            if joField.readonly = 1 then begin
                TEdit(oComp).Enabled    := False;
            end;
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
    oB_ETitle   : TButton;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oCB         : TComboBox;
    oCK_EBatch  : TCheckBox;
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
    oB_New      := TButton(Sender);
    oForm       := TForm(oB_New.Owner);
    oP_Editor   := TPanel(oForm.FindComponent('P_Editor'));
    oB_ETitle   := TButton(oForm.FindComponent('B_ETitle'));
    oQuery      := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCK_EBatch  := TCheckBox(oForm.FindComponent('CK_EBatch'));
    //
    oCK_EBatch.Visible  := True;

    //
    oB_ETitle.Caption   := '新  增';

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
    joConfig    := _json(qtGetConfig(oForm));

    //更新字段值
    qtAppend(oForm,
            'Field'+'0',
            oQuery,
            joConfig.fields,
            '',
            '');
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
    for iField := 0 to Min(2,oQuery.FieldCount-1) do begin
        sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
    end;
    sInfo   := Copy(sInfo,1,Length(sInfo)-3);
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
    oSG     := TPanel(oForm.FindComponent('LV_Main'));
    //
    dwPrint(oSG);
end;

Procedure LV_MainClick(Self: TObject; Sender: TObject);
var
    iRow    : Integer;
    oForm   : TForm;
    oLV     : TListView;
    oQuery  : TFDQuery;
    oClick  : Procedure(Sender: TObject) of Object;
begin
    //dwMessage('LV_MainClick','',TForm(TEdit(Sender).Owner));
    //主表的单击事件。功能：
    //1 如果主表未满行，点击空行后，自动切到最末行
    //2 根据当前主表的记录位置，自动更新从表
    //取得各控件
    oLV     := TListView(Sender);
    oForm   := TForm(oLV.Owner);
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    //得到当前行
    iRow    := oLV.ItemIndex;
    //检查是否空行。如果是空行，则切到最末行
    if iRow > oQuery.RecordCount then begin
        iRow    := oQuery.RecordCount;
        //
        oClick          := oLV.OnClick;
        oLV.OnClick     := nil;
        oLV.ItemIndex   := iRow;
        oLV.OnClick     := oClick;
    end;
    //更新数据表记录
    oQuery.RecNo    := iRow;
    oQuery.Tag      := iRow;    //保存位置备用
    //激活窗体的OnDockDrop事件，其中：X 为 0，表示为主表，iRow为记录号
    if Assigned(oForm.OnDockDrop) then begin
        oForm.OnDockDrop(oLV,nil,0,iRow);
    end;
end;

Procedure LV_MainEndDrag(Self: TObject;Sender, Target: TObject; X, Y: Integer);
var
    oForm   : TForm;
    oLV     : TListView;
    oQuery  : TFDQuery;
begin
    //dwMessage('LV_MainDockDrop','',TForm(TEdit(Sender).Owner));

    //主表卡片
    //2个参数：第一个为列序号（0始，-1表示点击面板），第二个为记录序号（0始）

    //取得各控件
    oLV     := TListView(Sender);
    oForm   := TForm(oLV.Owner);
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

    //
    oQuery.RecNo    := Y+1;
    //oLV.StyleName   := 'ORDER BY '+oQuery.Fields[ACol].FieldName;
    //if ARow = 0 then begin
    //    oLV.StyleName   := oLV.StyleName +' DESC';
    //end;
    //
    //qaUpdateMain(oForm);
end;
Procedure TB_MainChange(Self: TObject; Sender: TObject);
begin
    qtUpdateMain(TForm(TEdit(Sender).Owner),'');
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

//统一的新增函数
//
function _GetDataToView(
        AQuery : TFDQuery;
        ALV : TListView;
        ATrackBar : TTrackBar;
        AConfig : Variant   //包括以下信息：ATable,AFields,AWhere,AOrder:String;APage,ACount:Integer;
        ):Integer;
var
    oEvent          : Procedure(Sender:TObject) of Object;
    oScroll         : Procedure(Sender:TObject) of Object;

    iRecordCount    : Integer;
    iRow,iCol       : Integer;
    iField          : Integer;
    iOldRecNo       : Integer;
    iItem           : Integer;
    iError          : Integer;
    //
    sTable          : String;   //数据表名
    sFields         : string;   //字段列表，如：id,name,age,remark
    sWhere          : string;   //过滤条件
    sOrder          : string;   //排序条件
    iPageNo         : Integer;  //页数,从0开始
    iPageSize       : Integer;  //每页条数
    //
    joField         : Variant;
begin
    try
        iError      := 0;   //用于检查错误

        if AConfig = unassigned then begin
            Result  := -1;
            Exit;
        end;

        iError      := 1;   //用于检查错误

        //取得对应的参数设置
        sTable      := AConfig.table;       //表名
        sWhere      := AConfig.where;       //过滤条件
        sOrder      := AConfig.order;       //排序
        iPageNo     := AConfig.pageno;      //页码，从0始
        iPageSize   := AConfig.pagesize;    //每页行数
        sFields     := '';                  //字段列表
        for iItem := 0 to AConfig.fields._Count - 1 do begin
            if AConfig.fields._(iItem).type <> 'check' then begin
                sFields := sFields + AConfig.fields._(iItem).name + ',';
            end;
        end;
        if sFields = '' then begin
            Result  := -1;
            Exit;
        end else begin
            //删除最后的逗号
            Delete(sFields,Length(sFields),1);
        end;

        iError      := 2;   //用于检查错误

        //保存事件，并清空，以防止循环处理
        oEvent  := ATrackBar.OnChange;
        ATrackBar.OnChange  := nil;

        iError      := 3;   //用于检查错误

        //保存原Recno
        iOldRecNo   := AQuery.RecNo;
        AQuery.DisableControls;

        iError      := 4;   //用于检查错误

        //根据条件, 得出数据
        _GetPageData(
            AQuery,
            sTable,
            sFields,
            sWhere,
            sOrder,
            iPageNo,
            iPageSize,
            iRecordCount);

        iError      := 5;   //用于检查错误

        //设置分页控件值
        ATrackBar.Max       := iRecordCount;
        ATrackBar.PageSize  := iPageSize;

        iError      := 6;   //用于检查错误

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
            for iRow := 0 to AQuery.RecordCount-1 do begin
                with ALV.Items.Add do begin
                    joField := AConfig.fields._(0);
                    if joField.type = 'check' then begin
                        Caption := 'false';
                        iField  := 0;
                    end else begin
                        iField  := 1;
                        Caption := _GetFieldValue(AQuery.Fields[0],AConfig.fields._(0));
                    end;
                    //
                    for iCol := 1 to AConfig.fields._Count-1 do begin
                        joField := AConfig.fields._(iCol);
                        if joField.type = 'check' then begin
                            Subitems.Add('false');
                        end else begin
                            SubItems.Add(_GetFieldValue(AQuery.Fields[iField],AConfig.fields._(iCol)));
                            Inc(iField);
                        end;
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

        iError      := 7;   //用于检查错误

        //默认指定第一条记录
        AQuery.First;

        //恢复事件
        ATrackBar.Position  := iPageNo;
        ATrackBar.OnChange  := oEvent;
        //FreeAndNil(oEvent);

        iError      := 8;   //用于检查错误

        //恢复原Recno
        AQuery.RecNo    := iOldRecNo;
        AQuery.EnableControls;
    except
        ShowMessage('Error when _GetDataToView at '+IntToStr(iError));
    end;

end;


procedure qtUpdateMain(AForm:TForm;AWhere:String);
var
    iField      : Integer;
    iItem       : Integer;
    iError      : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    //
    oFDQuery    : TFDQuery;
    oTB_Main    : TTrackBar;
    oLV_Main    : TListView;
    oEKw  : TEdit;
    oFP_Query   : TFlowPanel;
    oP_QueryFld : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCB_Query   : TComboBox;
    oB_Fuzzy    : TButton;
    oB_Query    : TButton;
begin
    try
        iError      := 0;   //用于检查错误

        //取得配置JSON
        joConfig    := qtGetConfigJson(AForm);

        //取得字段名称列表，备用，返回值为sFields, 如：id,Name,age
        sFields := joConfig.fields._(0).name;
        for iField := 1 to joConfig.fields._Count-1 do begin
            joField := joConfig.fields._(iField);
            //
            sFields := sFields+','+joField.name
        end;

        iError      := 1;   //用于检查错误

        //取得各控件备用
        oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));    //主表数据库
        oEKw  := TEdit(AForm.FindComponent('EKw'));     //查询关键字
        oLV_Main    := TListView(AForm.FindComponent('LV_Main')); //主表显示ListView
        oTB_Main    := TTrackBar(AForm.FindComponent('TB_Main'));   //主表分页
        oB_Fuzzy    := TButton(AForm.FindComponent('B_Fuzzy'));     //模糊/精确匹配 切换按钮
        oB_Query    := TButton(AForm.FindComponent('B_Query'));     //查询按钮
        oFP_Query   := TFlowPanel(AForm.FindComponent('FP_Query')); //分字段查询字段的流式布局容器面板

        iError      := 2;   //用于检查错误

        //数据库类型
        if not joConfig.Exists('database') then begin
            joConfig.database   := lowerCase(oFDQuery.Connection.DriverName); //'access';
            qtSetConfig(AForm,joConfig);
        end;

        iError      := 3;   //用于检查错误

        //取得WHERE, 区分“智能模糊查询”和“分字段查询”2种情况
        //结果类似:  WHERE ((model like '%ljt%') and (name like '%west%'))
        if ( oFP_Query <> nil ) and (oFP_Query.Visible) then begin
            //初始化查询 WHERE 字符串
            if joConfig.where = '' then begin
                sWhere  := 'WHERE ((1=1) AND ';
            end else begin
                sWhere  := 'WHERE (('+joConfig.where+') AND ';
            end;

            //逐个字段处理
            if oFP_Query.Visible AND (oB_Query.Tag = 1) then begin
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
                    if joField.Exists('type') then begin
                        sType   := joField.type;
                    end else begin
                        sType   := 'string';
                    end;
                    //根据字段类型分类处理
                    if sType = 'date' then begin
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
                    end else if (sType = 'datetime') then begin
                        oDT_Start   := TDateTimePicker(TPanel(oP_QueryFld.Controls[1]));
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
                    end else if (sType = 'combo') OR (sType = 'dbcombo') then begin
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
            end;
            //删除最后的 ' AND '
            sWhere  := Copy(sWhere,1,Length(sWhere)-4);
            //
            sWhere  := sWhere + ')';
        end else begin
            //从智能模糊查询框的关键字中生成查询字符串
            //返回值为 ' WHERE (1=1) ' 或
            //         ' WHERE ((....) oR (...))'
            sWhere  := _GetWhere(sFields, oEKw.Text);

            //添加固定的where
            if joConfig.where <> '' then begin
                Delete(sWhere,1,Length(' WHERE'));
                sWhere  := ' WHERE ('+joConfig.where+') and ' + sWhere;
            end;
        end;

        iError      := 4;   //用于检查错误

        //AWhere 额外的 WHERE 条件
        if AWhere <> '' then begin
            sWhere  := sWhere + ' AND '+AWhere;
        end;

        //生成配置信息
        joDBConfig  := _json('{}');
        joDBConfig.table        := joConfig.table;
        joDBConfig.where        := sWhere;
        joDBConfig.order        := oLV_Main.StyleName;
        joDBConfig.pageno       := oTB_Main.Position;
        joDBConfig.pagesize     := joConfig.pagesize;
        joDBConfig.fields       := _json(joConfig.fields);

        iError      := 5;   //用于检查错误

        //
        _GetDataToView(
                oFDQuery,           //AQuery:TFDQuery;
                oLV_Main,           //ALV:TListView;
                oTB_Main,           //ATrackBar:TTrackBar
                joDBConfig
                );

        iError      := 6;   //用于检查错误

    except
        ShowMessage('Error when qtUpdateMain at '+IntToStr(iError));
    end;
end;




procedure qtCreateConfirmPanel(AForm:TForm);
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
        Left        := 170;
        Width       := 170;
        Height      := 60;
        Caption     := '确定';
        Font.Size   := 14;
        Hint        := '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border-right:0px;","radius":"0px"}';
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
        Left        := 0;
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

procedure qtCreateField(AForm:TForm;AWidth:Integer;ASuffix:String;AConfig,AField:Variant;AP_Content:TFlowPanel);
var
    ooP         : TPanel;
    ooL         : TLabel;
    ooE         : TEdit;
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
        Name        := 'P_Field'+ASuffix;
        Parent      := AP_Content;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        //Align       := alTop;
        AutoSize    := False;
        Height      := 40;
        //Left        := ALeft;
        //Top         := ATop;
        Width       := AWidth;
        Color       := clNone;
        Font.Size   := 11;
        //
        //Hint        := '{"dwstyle":"border-bottom:solid 1px #f0f0f0;"}';
    end;

    //字段的标签 在容器左边
    ooL     := TLabel.Create(AForm);
    with ooL do begin
        Name            := 'L_Field'+ASuffix;
        Parent          := ooP;
        AutoSize        := False;
        Align           := alLeft;
        Alignment       := taRightJustify;
        Width           := 80;
        AlignWithMargins:= True;
        Margins.Top     := 8;
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
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
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
    end else if AField.type = 'integer' then begin  //整型
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
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
            Name            := 'Field'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '华为电器';
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

function  qtCreateFieldQuery(AForm:TForm;AField:Variant;AIndex:Integer;ASuffix:String;AFlowPanel:TFlowPanel):Integer;
var
    oP_QueryFld : TPanel;
    oL_Query    : TLabel;
    oCB_Query   : TComboBox;
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
    //
    joConfig    := qtGetConfigJson(AForm);

    //
    oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

    //创建一个单字段查询面板
    oP_QueryFld := TPanel.Create(AForm);
    with oP_QueryFld do begin
        Name            := 'P_Query'+ASuffix;
        Parent          := AFlowPanel;
        Color           := clNone;
        Width           := 335;
        Height          := 40;
        Tag             := AIndex;
    end;
    //创建查询字段标签
    oL_Query    := TLabel.Create(AForm);
    with oL_Query do begin
        Name            := 'L_Query'+ASuffix;
        Parent          := oP_QueryFld;
        Tag             := AIndex;
        Align           := alLeft;
        Layout          := tlCenter;
        Caption         := AField.caption ;
        Alignment       := taRightJustify;
        Width           := 80;
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
    end;

    //
    if AField.type = 'combo' then begin
        //创建查询字段EDIT
        oCB_Query   := TComboBox.Create(AForm);
        with oCB_Query do begin
            Name            := 'E_Query'+ASuffix;
            Parent          := oP_QueryFld;
            Tag             := AIndex;
            Align           := alClient;
            Style           := csDropDownList;
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 6;

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
    end else if AField.type = 'dbcombo' then begin
        //创建数据库查询ComboBox
        oCB_Query   := TComboBox.Create(AForm);
        with oCB_Query do begin
            Name            := 'E_Query'+ASuffix;
            Parent          := oP_QueryFld;
            Tag             := AIndex;
            Style           := csDropDownList;
            Text            := '';
            Align           := alClient;
            //
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 5;
            //先添加一个空值
            oCB_Query.Items.Add('');
            //添加数据库内的值
            joItems := _GetItems(oQueryTmp,joConfig.table,AField.name);
            for iItem := 0 to joItems._Count-1 do begin
                oCB_Query.Items.Add(joItems._(iItem));
            end;
        end;
    end else if AField.type = 'date' then begin
        //创建面板存放起始结束日期
        oP_DateSE := TPanel.Create(AForm);
        with oP_DateSE do begin
            Name            := 'P_DateSE'+ASuffix;
            Parent          := oP_QueryFld;
            Color           := clNone;
            Align           := alClient;
            Tag             := AIndex;
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
            //
            AlignWithMargins:= True;
            Margins.Top     := 4;
            Margins.Bottom  := 4;
            Margins.Right   := 0;
        end;
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(AForm);
        with oDT_Start do begin
            Name        := 'DT_Start'+ASuffix;
            Parent      := oP_DateSE;
            Align       := alLeft;
            Tag         := AIndex;
            Width       := 135;
            Height      := 28;
            if AField.Exists('min') then begin
                Date        := StrToDateDef(AField.min,Now);
            end else begin
                Date        := StrToDateDef('1900-01-01',Now);;
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;
        //起止日期间分隔符
        oL_Space    := TLabel.Create(AForm);
        with oL_Space do begin
            Name        := 'L_Space'+ASuffix;
            Parent      := oP_DateSE;
            Tag         := AIndex;
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
            Name        := 'DT_End'+ASuffix;
            Tag         := AIndex;
            Left        := 120;
            Top         := 1;
            Width       := 135;
            Height      := 28;
            if AField.Exists('max') then begin
                Date    := StrToDateDef(AField.max,Now);
            end else begin
                Date    := StrToDateDef('2500-12-31',Now);;
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

    end else if AField.type = 'datetime' then begin    //=======================
        if AField.Exists('min') then begin
            //更新标签
            oL_Query.Caption    := AField.caption + '>=';
            //创建查询起始日期
            oDT_Start   := TDateTimePicker.Create(AForm);
            with oDT_Start do begin
                Name            := 'DT_Start'+ASuffix;
                Parent          := oP_QueryFld;
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
                Margins.Bottom  := 5;
            end;
        end;
        if AField.Exists('max') then begin
            if AField.Exists('min') then begin
                //创建一个单字段查询面板
                oP_QueryFld := TPanel.Create(AForm);
                with oP_QueryFld do begin
                    Name            := 'P_QueryDT'+ASuffix;
                    Parent          := AFlowPanel;
                    Color           := clNone;
                    Width           := 335;
                    Height          := 40;
                    Tag             := AIndex;
                end;
                //创建查询字段标签
                oL_Query    := TLabel.Create(AForm);
                with oL_Query do begin
                    Name        := 'L_QueryDT'+ASuffix;
                    Parent      := oP_QueryFld;
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
            end;

            //创建查询起始日期
            oDT_End := TDateTimePicker.Create(AForm);
            with oDT_End do begin
                Name            := 'DT_End'+ASuffix;
                Parent          := oP_QueryFld;
                Align           := alClient;
                DoubleBuffered  := True;    //用作：日期+时间型
                Kind            := dtkTime;
                Format          := 'yyyy-MM-dd HH:mm:ss';
                Tag             := AIndex;
                Height          := 28;
                HelpContext     := -1;  //标记为结束时间
                Date            := StrToDateDef(Copy(AField.max,1,10),Now);
                Time            := StrToTimeDef(Copy(AField.max,12,8),Now);
                Hint            := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
                                //+',"dwattr":"format=\"yyyy-MM-dd HH:mm:ss\" :type=\"datetime\""}';
                AlignWithMargins    := True;
                Margins.Top         := 5;
                Margins.Bottom      := 5;
            end;
        end;
    end else begin
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(AForm);
        with oE_Query do begin
            Name        := 'E_Query'+ASuffix;
            Parent      := oP_QueryFld;
            Tag         := AIndex;
            Text        := '';
            Align       := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 5;
        end;
    end;

end;


//创建查询用的Panel
procedure qtCreateQueryPanel(AForm:TForm);
var
    oP_Query    : TPanel;       //编辑/新增 总Panel
    oP_QTitle   : TPanel;       //顶部Panel, 用于放置：标题、最大化、关闭
    oB_QTitle   : TButton;      //标题
    oB_QMax     : TButton;      //最大化
    oB_QClose   : TButton;      //关闭
    oP_QButtons : TPanel;       //底部按钮Panel, 放置：取消，确定
    oB_QOK      : TButton;      //确定按钮
    oB_QReset   : TButton;      //重置按钮
    oSB         : TScrollBox;   //滚动框，以放置更多字段编辑信息
    oFP_Content : TFlowPanel;   //多字段编辑信息的容器
    oCK_Batch   : TCheckBox;    //批量新增checkbox
    //
    iSlave      : Integer;
    iField      : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    iEditColCnt : Integer;
    iCount      : Integer;
    //
    joConfig    : Variant;
    joSlave     : Variant;
    joField     : Variant;
    joList      : Variant;
    joItems     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //取得配置JSON
    joConfig    := qtGetConfigJson(AForm);

    //编辑/新增的总面板
    oP_Query   := TPanel.Create(AForm);
    with oP_Query do begin
        Name        := 'P_Query';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Anchors     := [akBottom,akTop];
        Font.Size   := 11;
        Top         := 50;
        Width       := joConfig.editwidth;
        Height      := 400;     //应为自动
        Hint        := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
        Font.Color  := $323232;
        Color       := clWhite;
    end;

    //标题 Panel
    oP_QTitle  := TPanel.Create(AForm);
    with oP_QTitle do begin
        Name        := 'P_QTitle';
        Parent      := oP_Query;
        Align       := alTop;
        Height      := 50;
        Font.Size   := 17;
        Color       := clWhite;
        //
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //标题 Button
    oB_QTitle  := TButton.Create(AForm);
    with oB_QTitle do begin
        Name        := 'B_QTitle';
        Parent      := oP_QTitle;
        Align       := alLeft;
        Width       := 60;
        Caption     := '查询条件 ';
        Font.Size   := 15;
        Hint        := '{"dwstyle":"background:#fff;text-align:left;border:0;"}';
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
    end;

    //最大化 Button
    oB_QMax  := TButton.Create(AForm);
    with oB_QMax do begin
        Name        := 'B_QMax';
        Parent      := oP_QTitle;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        //
        AlignWithMargins:= True;
        Margins.Right   := 0;
        //
        tM.Code         := @B_QMaxClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
        //
        if joConfig.defaulteditmax = 1 then begin
            Tag := 9;
        end;
    end;

    //关闭 Button
    oB_QClose  := TButton.Create(AForm);
    with oB_QClose do begin
        Name        := 'B_QClose';
        Parent      := oP_QTitle;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-close"}';
        //
        AlignWithMargins:= True;
        Margins.Right    := 10;
        //
        tM.Code         := @B_QCloseClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //用于放置 OK/Cancel 的Panel
    oP_QButtons   := TPanel.Create(AForm);
    with oP_QButtons do begin
        Name        := 'P_QButtons';
        Parent      := oP_Query;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alBottom;
        Height      := 50;
        Color       := clNone;
    end;

    //
    oB_QOK  := TButton.Create(AForm);
    with oB_QOK do begin
        Name        := 'B_QOK';
        Parent      := oP_QButtons;
        Align       := alRight;
        Width       := 80;
        Top         := 0;
        Left        := 0;
        Height      := 60;
        Font.Size   := 13;
        Caption     := '查询';
        Hint        := '{"type":"primary"}';
        //
        AlignWithMargins:= True;
        Margins.right   := 20;
        Margins.Bottom  := 19;
        //
        tM.Code         := @B_QOKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oB_QReset  := TButton.Create(AForm);
    with oB_QReset do begin
        Name        := 'B_QReset';
        Parent      := oP_QButtons;
        Align       := alRight;
        Top         := 0;
        Left        := 0;
        Width       := oB_QOK.Width;

        Height      := 60;
        Font.Size   := 13;
        Caption     := '重置';
        Hint        := '';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        Margins.Bottom  := 19;
        //
        tM.Code         := @B_QResetClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;



end;


procedure qtCreateEditorPanel(AForm:TForm);
var
    oP_Editor   : TPanel;       //编辑/新增 总Panel
    oP_ETitle   : TPanel;       //顶部Panel, 用于放置：标题、最大化、关闭
    oB_ETitle   : TButton;      //标题
    oB_EClose   : TButton;      //关闭
    oP_EButtons : TPanel;       //底部按钮Panel, 放置：取消，确定
    oB_EOK      : TButton;      //确定按钮
    oB_ECancel  : TButton;      //取消按钮
    oSB         : TScrollBox;   //滚动框，以放置更多字段编辑信息
    oFP_Content : TFlowPanel;   //多字段编辑信息的容器
    oCK_Batch   : TCheckBox;    //批量新增checkbox
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
    joConfig    := qtGetConfigJson(AForm);
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
        Top         := 100;
        Height      := AForm.Height - 200;
        Hint        := '{"radius":"5px"}';
        Font.Color  := $323232;
        Color       := clWhite;
        Width       := Min(AForm.width-20,joConfig.editwidth);
    end;

    //标题 Panel
    oP_ETitle  := TPanel.Create(AForm);
    with oP_ETitle do begin
        Name        := 'P_ETitle';
        Parent      := oP_Editor;
        Align       := alTop;
        Height      := 50;
        Font.Size   := 17;
        Color       := clWhite;
        //
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //标题 Button
    oB_ETitle  := TButton.Create(AForm);
    with oB_ETitle do begin
        Name        := 'B_ETitle';
        Parent      := oP_ETitle;
        Align       := alLeft;
        Width       := 60;
        Caption     := '新  增';
        Font.Size   := 15;
        Hint        := '{"dwstyle":"background:#fff;text-align:left;border:0;"}';
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
    end;


    //关闭 Button
    oB_EClose  := TButton.Create(AForm);
    with oB_EClose do begin
        Name        := 'B_EClose';
        Parent      := oP_ETitle;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-close"}';
        //
        AlignWithMargins:= True;
        Margins.Right    := 10;
        //
        tM.Code         := @B_ECancelClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
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
        tM.Code         := @B_EOKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oB_ECancel  := TButton.Create(AForm);
    with oB_ECancel do begin
        Name        := 'B_ECancel';
        Parent      := oP_EButtons;
        Align       := alRight;
        Top         := 0;
        Left        := 0;
        Width       := oB_EOK.Width;

        Height      := 60;
        Font.Size   := 13;
        Caption     := '取消';
        Hint        := '';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        Margins.Bottom  := 19;
        //
        tM.Code         := @B_ECancelClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //批量新增 checkbox
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
    oFP_Content   := TFlowPanel.Create(AForm);
    with oFP_Content do begin
        Name        := 'FP_Content0';
        Parent      := oSB;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alTop;
        Color       := clWhite;
    end;
    //编辑时各字段排列的列数，默认为1
    iEditColCnt   := 1;
    if joConfig.Exists('editcolcount') then begin
        iEditColCnt   := joConfig.editcolcount;
    end;

    //创建主表各字段的编辑框
    for iField := 0 to joConfig.fields._Count-1 do begin
        //取得主表字段的JSON对象
        joField := joConfig.fields._(iField);

        //计算left/top
        iLeft   := (iField mod iEditColCnt) * (joConfig.editwidth div joConfig.editcolcount)+10;
        iTop    := (iField div iEditColCnt) * 40;

        //创建控件
        qtCreateField(
                AForm,
                joConfig.datawidth,//(oP_Editor.Width div iEditColCnt)-20,   //width
                '0'+IntToStr(iField),   //后缀名，用于区分多个控件
                joConfig,
                joField,    //字段的JSON对象
                oFP_Content  //父panel
                );
    end;
    oFP_Content.AutoSize := True;


end;



function dwTree(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwEndDrag = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    joConfig    : variant;
    oPQT        : TPanel;
    oTVQ        : TTreeView;
    oPDA        : TPanel;
    oFDA        : TFlowPanel;   //浮动数据面板
    oPBT        : TPanel;
    oBSV        : TButton;      //保存按钮
    oBCA        : TButton;      //取消按钮

    oP_Query    : TPanel;       //分字段查询面板 : P_Query
    oP_SpaceFB  : TPanel;       //空面板，以用于空出“精确/模糊”和“切换（多字段查询/智能模糊查询）”按钮的空间
    oP_QueryClt : TPanel;       //空面板，以用于存放FlowPanel
    oFP_Query   : TFlowPanel;   //用于多字段查询的流式布局面板
    oP_QueryFld : TPanel;       //单独字段查询面板 : P_Query0, P_Query1,...
    oP_QuerySmt : TPanel;       //智能模糊查询面板 : P_QuerySmart
    oP_MainData : TPanel;
    oPBs  : TPanel;       //功能按钮面板 : PBs
    oB_QueryMd  : TButton;      //切换查询模式的按钮 ： B_QueryMode
    oB_Fuzzy    : TButton;      //切换查询模式的按钮 ： B_Fuzzy 模糊/精确
    oB_Query    : TButton;      //查询按钮
    oB_Reset    : TButton;      //重置按钮
    //
    oB_New      : TButton;
    oB_Edit     : TButton;
    oB_Delete   : TButton;
    //
    oEKw  : TEdit;
    oTabSheet1  : TTabSheet;
    oP_TBMain   : TPanel;       //TB_Main外部加一个面板，以放置 每页行数 框
    oTB_Main    : TTrackBar;
    oCB_PageSize: TComboBox;    //每页显示数量


    //
    oFQ_Main    : TFDQuery;
    //
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
    oLV_Main    : TListView;
    oLV_Slave   : TListView;
    //用于指定事件
    tM          : TMethod;
    //
    joField     : variant;
    joHint      : variant;
    joCell      : variant;
    joSlave     : variant;
    joItems     : Variant;      //用于生成combo的items
    //
    iField      : Integer;
    iCol        : Integer;
    iCount      : Integer;
    iTop        : Integer;
    iLeft       : Integer;
    iItem       : Integer;
    iError      : Integer;      //用于检查异常
    //
    sCardStyle  : string;
    //
    oTab        : TTabSheet;
    oFQY        : TFDQuery;
    oTB         : TTrackBar;
    oLV         : TListView;
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
        if AForm.FindComponent('PQT') <> nil then begin
            Exit;
        end;

        //取配置JSON : 读AForm的 qtConfig 变量值
        joConfig    := qtGetConfigJson(AForm);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //生成一个临时查询，以生成Combo的列表
        oQueryTmp               := TFDQuery.Create(AForm);
        oQueryTmp.Name          := 'FDQueryTmp';
        oQueryTmp.Connection    := AConnection;

        //总面板========================================================================================================
        oPQT    := TPanel.Create(AForm);
        with oPQT do begin
            Parent          := AForm;
            Name            := 'PQT';
            BevelOuter      := bvNone;
            Align           := alClient;
            Color           := clNone;
            //
            Font.Size       := 11;
            Font.Color      := $646464;
        end;

        //树形框 Treeview ==============================================================================================
        oTVQ    := TTreeView.Create(AForm);
        with oTVQ do begin
            Parent          := oPQT;
            Name            := 'TVQ';
            Align           := alLeft;
            Color           := clWhite;
            Width           := joConfig.treewidth;
            //
            //AlignWithMargins:= True;
            Margins.Top     := 10;
            Margins.Bottom  := 10;
            Margins.Left    := 10;
            Margins.Right   := 0;
            Hint            := '{"dwstyle":"border-right:solid 1px #ddd;"}';
            //
            tM.Code         := @FP_QueryResize;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;

        //右侧数据面板==================================================================================================
        oPDA    := TPanel.Create(AForm);
        with oPDA do begin
            Parent          := oPQT;
            Name            := 'PDA';
            BevelOuter      := bvNone;
            Align           := alClient;
            Color           := clNone;
        end;


        //创建一个查询面板，用于存放“保存”和“取消”按钮
        oPBT    := TPanel.Create(AForm);
        with oPBT do begin
            Parent          := oPDA;
            Name            := 'PBT';
            Align           := alBottom;
            Color           := clNone;
            Height          := 40;
            Tag             := -1;
            Hint            := '{"dwstyle":"border-top:solid 1px #ddd;"}';
        end;

        //添加“查询”和“重置”按钮
        oBSV  := TButton.Create(AForm);
        with oBSV do begin
            Parent          := oPBT;
            Name            := 'BSV';
            Align           := alLeft;
            width           := 70;
            Height          := 30;
            Caption         := '保存';
            Hint            := '{"type":"primary","icon":"el-icon-save"}';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 6;
            Margins.Left    := 20;
            Margins.Right   := 5;
            //
            tM.Code         := @B_QueryClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        oBCA  := TButton.Create(AForm);
        with oBCA do begin
            Parent          := oPBT;
            Name            := 'BCA';
            Align           := alLeft;
            width           := 70;
            Height          := 30;
            Left            := 100;
            Caption         := '取消';
            Hint            := '{"icon":"el-icon-refresh"}';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 6;
            Margins.Left    := 5;
            Margins.Right   := 5;
            //
            tM.Code         := @B_ResetClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;

        //配置 oFQ_Main 的连接
        oFQY            := TFDQuery.Create(AForm);
        oFQY.Name       := 'FQY';
        oFQY.Connection := AConnection;

        //创建树
        dwDBUniqueIdentifierToTreeView(
            oTVQ,
            oFQY,
            'M_DepartmentType','DepartmentTypeID','ParentDepartmentTypeID','DepartmentType'
        );
        oTVQ.FullExpand;


    except
        //下面的ShowMessage代码仅在程序调试时使用
        //ShowMessage('error at '+IntToStr(iError));
    end;
end;

end.
