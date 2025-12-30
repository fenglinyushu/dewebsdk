unit unit0;

interface

uses
    //自编单元
    dwBase,
    dwDB,
    dwAccess,

    //第三方单元
    SynCommons,
    CloneComponents,

    //系统单元
    Math,
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
    FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB,
    Vcl.ComCtrls, Data.Win.ADODB, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
  FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Vcl.WinXCtrls, Vcl.Samples.Spin;

type
  TForm_Item = class(TForm)
    P_Banner: TPanel;
    B_New: TButton;
    E_Keyword: TEdit;
    B_Print: TButton;
    PC_Slave: TPageControl;
    TabSheet1: TTabSheet;
    P_TrackBar: TPanel;
    TB_Main: TTrackBar;
    P_SlaveButtons: TPanel;
    B_SlaveNew: TButton;
    B_SlaveDelete: TButton;
    B_SlaveEdit: TButton;
    B_Edit: TButton;
    B_Delete: TButton;
    B_SlavePrint: TButton;
    FDQuery1: TFDQuery;
    P_Editor: TPanel;
    P_EditorButtons: TPanel;
    Button_Cancel: TButton;
    Button_OK: TButton;
    SB_Demo: TScrollBox;
    Panel_Content: TPanel;
    Panel_string: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Panel_combo: TPanel;
    Label2: TLabel;
    ComboBox1: TComboBox;
    Panel_integer: TPanel;
    Label3: TLabel;
    SpinEdit1: TSpinEdit;
    Panel_date: TPanel;
    Label4: TLabel;
    DateTimePicker1: TDateTimePicker;
    Panel_Boolean: TPanel;
    Label5: TLabel;
    ToggleSwitch1: TToggleSwitch;
    Panel_Group: TPanel;
    Label6: TLabel;
    P_EditorTitle: TPanel;
    Label7: TLabel;
    SG_Main: TStringGrid;
    SG_Slave: TStringGrid;
    procedure FormShow(Sender: TObject);
    procedure TB_MainChange(Sender: TObject);
    procedure E_KeywordChange(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure B_NewClick(Sender: TObject);
    procedure B_PrintClick(Sender: TObject);
    procedure ADOQueryAfterScroll(DataSet: TDataSet);
    procedure B_EditClick(Sender: TObject);
    procedure B_DeleteClick(Sender: TObject);
    procedure B_SlavePrintClick(Sender: TObject);
    procedure B_SlaveEditClick(Sender: TObject);
    procedure B_SlaveNewClick(Sender: TObject);
    procedure B_SlaveDeleteClick(Sender: TObject);
    procedure PC_SlaveChange(Sender: TObject);
    procedure TrackBar_SlaveChange(Sender: TObject);
    procedure SG_MainGetEditMask(Sender: TObject; ACol, ARow: Integer; var Value: string);
    procedure SG_MainClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure SG_SlaveClick(Sender: TObject);
  private
        gbConfigError   : Boolean;
  public
        gsOrder     : string;   //主表排序字符串 'ORDER BY name DESC'
        gsConfig    : string;   //配置字符串
        gjoConfig   : variant;  //配置JSON对象
        gsOrders    : array of String;  //用于保存从表的Order,数组类型

        //更新数据函数
        procedure UpdateDatas;
        procedure UpdateSlaves;
  end;


implementation

{$R *.dfm}

uses
    Unit1;

procedure TForm_Item.ADOQueryAfterScroll(DataSet: TDataSet);
begin
    UpdateSlaves;
end;

procedure TForm_Item.Button_CancelClick(Sender: TObject);
begin
    P_Editor.Visible    := False;
end;

procedure TForm_Item.Button_OKClick(Sender: TObject);
var
    sCaption    : string;
    sAction     : string;
    sName       : string;
    //
    iTable      : Integer;
    iField      : Integer;
    iRow        : Integer;
    iSlave      : Integer;
    //
    oPN         : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;
    oFDQuery    : TFDQuery;
    oSG         : TStringGrid;

    //
    joEditor    : Variant;
    joField     : Variant;
    joEdit      : Variant;
    joSlave     : variant;
begin
    //取得 P_Editor.Caption，以取得
    sCaption    := Trim(P_Editor.Caption);
    //
    if sCaption = '' then begin
        Exit;
    end;
    //取得操作（E:Edit/N:New）和表序号
    sAction     := UpperCase(sCaption[1]);
    iTable      := StrToIntDef(Copy(sCaption,2,10),-1);
    //异常处理
    if (iTable < 0) then begin
        Exit;
    end;
    if (iTable > 0) then begin
        if gjoConfig.Exists('slave') then begin
            if (iTable > gjoConfig.slave._Count) then begin
                Exit;
            end;
        end;
    end;

    //进行处理
    if sAction = 'E' then begin //Edit =============================================================
        if iTable = 0 then begin    //主表
            //
            oPN := TPanel(FindComponent('P_Main'));

            //依次创建保存各字段
            FDQuery1.Edit;
            iRow    := SG_Main.Row;
            for iField := 0 to gjoConfig.fields._count - 1 do begin
                //得到字段对象
                joField := gjoConfig.fields._(iField);

                //
                if joField.Exists('readonly') then begin
                    if joField.readonly = 1 then begin
                        Continue;
                    end;
                end;

                if (joField.type = 'string') and (joField.Exists('list')) then begin
                    oComboBox   := TComboBox(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsString := oComboBox.Text;
                end else if (joField.type = 'integer')  then begin
                    oSpinEdit       := TSpinEdit(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsInteger    := oSpinEdit.Value ;
                end else if (joField.type = 'date')  then begin
                    oDTPicker   := TDateTimePicker(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsDateTime   := oDTPicker.Date ;
                end else if (joField.type = 'boolean')  then begin
                    oSwitch     := TToggleSwitch(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsBoolean    := oSwitch.State = tssOn ;
                end else if (joField.type = 'group')  then begin
                end else begin
                    oEdit       := TEdit(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsString := oEdit.Text;
                end;
                SG_Main.Cells[iField,iRow]  := FDQuery1.FieldByName(joField.name).AsString;

                //检查是否为必填字段
                if joField.Exists('must') then begin
                    if joField.must = 1 then begin
                        if SG_Main.Cells[iField,iRow] = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.name+'" 为必填字段！','error',self);
                            Exit;
                        end;
                    end;
                end;
            end;

            //保存
            try
                FDQuery1.Post;
                //
                dwMessage('保存成功！','success',self);
            except
                //
                dwMessage('保存失败！请检查配置','error',self);
            end;



            //隐藏编辑框
            P_Editor.Visible    := False;

        end else begin              //从表 ---------------------------------------------------------
            //
            iSlave  := PC_Slave.ActivePageIndex;
            joSlave := gjoConfig.slave._(iSlave);
            //
            oFDQuery    := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));
            oSG         := TStringGrid(FindComponent('SGSlave'+IntToStr(iSlave)));

            //依次创建保存各字段
            oFDQuery.Edit;
            iRow    := oSG.Row;
            for iField := 0 to joSlave.fields._count - 1 do begin
                //得到字段对象
                joField := joSlave.fields._(iField);

                //
                if joField.Exists('readonly') then begin
                    if joField.readonly = 1 then begin
                        Continue;
                    end;
                end;

                sName   := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                if (joField.type = 'string') and (joField.Exists('list')) then begin
                    oComboBox   := TComboBox(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsString := oComboBox.Text;
                end else if (joField.type = 'integer')  then begin
                    oSpinEdit       := TSpinEdit(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsInteger    := oSpinEdit.Value ;
                end else if (joField.type = 'date')  then begin
                    oDTPicker   := TDateTimePicker(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsDateTime   := oDTPicker.Date ;
                end else if (joField.type = 'boolean')  then begin
                    oSwitch     := TToggleSwitch(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsBoolean    := oSwitch.State = tssOn ;
                end else if (joField.type = 'group')  then begin
                end else begin
                    oEdit       := TEdit(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsString := oEdit.Text;
                end;
                oSG.Cells[iField,iRow]  := oFDQuery.FieldByName(joField.name).AsString;

                //检查是否为必填字段
                if joField.Exists('must') then begin
                    if joField.must = 1 then begin
                        if SG_Main.Cells[iField,iRow] = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.name+'" 为必填字段！','error',self);
                            Exit;
                        end;
                    end;
                end;
            end;

            //保存
            try
                oFDQuery.Post;
                //
                dwMessage('保存成功！','success',self);
            except
                //
                dwMessage('保存失败！请检查配置','error',self);
            end;



            //隐藏编辑框
            P_Editor.Visible    := False;

        end;
    end else if sAction = 'N' then begin    //New ==================================================
        if iTable = 0 then begin    //主表
            //依次创建保存各字段
            FDQuery1.Append;
            iRow    := SG_Main.Row;
            for iField := 0 to gjoConfig.fields._count - 1 do begin
                //得到字段对象
                joField := gjoConfig.fields._(iField);

                //
                if joField.Exists('readonly') then begin
                    if joField.readonly = 1 then begin
                        Continue;
                    end;
                end;

                //
                oPN := TPanel(FindComponent('P_Editor'+IntToStr(iField)));

                if (joField.type = 'string') and (joField.Exists('list')) then begin
                    oComboBox   := TComboBox(oPN.Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsString := oComboBox.Text;
                end else if (joField.type = 'integer')  then begin
                    oSpinEdit       := TSpinEdit(oPN.Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsInteger    := oSpinEdit.Value ;
                end else if (joField.type = 'date')  then begin
                    oDTPicker   := TDateTimePicker(oPN.Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsDateTime   := oDTPicker.Date ;
                end else if (joField.type = 'boolean')  then begin
                    oSwitch     := TToggleSwitch(oPN.Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsBoolean    := oSwitch.State = tssOn ;
                end else if (joField.type = 'group')  then begin
                end else begin
                    oEdit       := TEdit(oPN.Controls[1]);
                    FDQuery1.FieldByName(joField.name).AsString := oEdit.Text;
                end;
            end;

            //保存
            try
                FDQuery1.Post;
                //
                UpdateDatas;
                //
                dwMessage('新增成功！','success',self);
            except
                //
                dwMessage('新增失败！请检查配置','error',self);
            end;



            //隐藏编辑框
            P_Editor.Visible    := False;

        end else begin              //从表 ---------------------------------------------------------
            //
            iSlave  := PC_Slave.ActivePageIndex;
            joSlave := gjoConfig.slave._(iSlave);
            //
            oFDQuery    := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));
            oSG         := TStringGrid(FindComponent('SGSlave'+IntToStr(iSlave)));

            //依次创建保存各字段
            oFDQuery.Append;

            //设置关联字段
            oFDQuery.FieldByName(joSlave.slavefield).Value  := FDQuery1.FieldByName(joSlave.masterfield).AsVariant;

            iRow    := oSG.Row;
            for iField := 0 to joSlave.fields._count - 1 do begin
                //得到字段对象
                joField := joSlave.fields._(iField);

                //
                if joField.Exists('readonly') then begin
                    if joField.readonly = 1 then begin
                        Continue;
                    end;
                end;

                sName   := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                if (joField.type = 'string') and (joField.Exists('list')) then begin
                    oComboBox   := TComboBox(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsString := oComboBox.Text;
                end else if (joField.type = 'integer')  then begin
                    oSpinEdit       := TSpinEdit(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsInteger    := oSpinEdit.Value ;
                end else if (joField.type = 'date')  then begin
                    oDTPicker   := TDateTimePicker(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsDateTime   := oDTPicker.Date ;
                end else if (joField.type = 'boolean')  then begin
                    oSwitch     := TToggleSwitch(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsBoolean    := oSwitch.State = tssOn ;
                end else if (joField.type = 'group')  then begin
                end else begin
                    oEdit       := TEdit(TPanel(FindComponent(sName)).Controls[1]);
                    oFDQuery.FieldByName(joField.name).AsString := oEdit.Text;
                end;
            end;

            //保存
            try
                oFDQuery.Post;
                UpdateSlaves;
                //
                dwMessage('新增成功！','success',self);
            except
                //
                dwMessage('新增失败！请检查配置','error',self);
            end;



            //隐藏编辑框
            P_Editor.Visible    := False;

        end;
    end
end;

procedure TForm_Item.B_DeleteClick(Sender: TObject);
var
    iField      : Integer;
    iSlave      : Integer;
    iRow        : Integer;
    //
    sInfo       : string;
    //
    joSlave     : Variant;
    //
    oFDQuery    : TFDQuery;
    oSG         : TStringgrid;
begin
    oSG         := TStringGrid(FindComponent('SG_Main'));
    iRow        := oSG.Row;

    //隐藏编辑
    sInfo  := '['+oSG.cells[0,iRow];
    for iField := 1 to oSG.ColCount-1 do begin
        sInfo  := sInfo+', '+oSG.Cells[iField,iRow];
    end;
    sInfo  := sInfo+'] ';

    //删除提示
    if gjoConfig.Exists('slave') then begin
        dwMessageDlg('确定要删除记录 '+sInfo+' 及对应关联表数据吗？',
                'confirm',
                'OK',
                'Cancel',
                'query_delete',
                self);
    end else begin
        dwMessageDlg('确定要删除记录 '+sInfo+' 吗？',
                'confirm',
                'OK',
                'Cancel',
                'query_delete',
                self);
    end;

end;

procedure TForm_Item.B_EditClick(Sender: TObject);
var
    iField      : Integer;
    iSlave      : Integer;
    //
    oSB         : TScrollBox;
    oPN         : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;

    //
    joEditor    : Variant;
    joField     : Variant;
    joEdit      : Variant;
begin
    //
    oPN := TPanel(FindComponent('P_Main'));

    //依次创建编辑字段对象
    for iField := 0 to gjoConfig.fields._count - 1 do begin
        //得到字段对象
        joField := gjoConfig.fields._(iField);

        if (joField.type = 'string') and (joField.Exists('list')) then begin
            oComboBox   := TComboBox(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
            oComboBox.Text  := FDQuery1.FieldByName(joField.name).AsString;
        end else if (joField.type = 'integer')  then begin
            oSpinEdit       := TSpinEdit(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
            oSpinEdit.Value := FDQuery1.FieldByName(joField.name).AsInteger;
        end else if (joField.type = 'date')  then begin
            oDTPicker   := TDateTimePicker(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
            oDTPicker.Date  := FDQuery1.FieldByName(joField.name).AsDateTime;
        end else if (joField.type = 'boolean')  then begin
            oSwitch := TToggleSwitch(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
            oDTPicker.Date  := FDQuery1.FieldByName(joField.name).AsDateTime;
        end else if (joField.type = 'group')  then begin
        end else begin
            oEdit       := TEdit(TPanel(FindComponent('P_Editor'+IntToStr(iField))).Controls[1]);
            oEdit.Text  := FDQuery1.FieldByName(joField.name).AsString;
        end;
    end;

    //标记
    P_Editor.Caption    := 'E0';    //E表示Edit,还有N，表示New; 0表示主表,1~n表示从表

    //显示编辑面板
    P_Editor.Visible    := True;

    //隐藏面板中的sB
    for iSlave := 0 to 99 do begin
        oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(iSlave)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;
    oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(0)));
    oSB.Visible := True;

end;

procedure TForm_Item.B_NewClick(Sender: TObject);
var
    iField      : Integer;
    iSlave      : Integer;
    iItem       : Integer;
    //
    oSB         : TScrollBox;
    oPN         : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;

    //
    joEditor    : Variant;
    joField     : Variant;
    joEdit      : Variant;
begin
    //

    //依次创建新增数据字段对象
    for iField := 0 to gjoConfig.fields._count - 1 do begin
        //得到字段对象
        joField := gjoConfig.fields._(iField);

        oPN := TPanel(FindComponent('P_Editor'+IntToStr(iField)));
        if (joField.type = 'string') and (joField.Exists('list')) then begin
            oComboBox   := TComboBox(oPN.Controls[1]);
            if joField.Exists('default') then begin
                oComboBox.Text  := joField.default;
            end else begin
                oComboBox.Text  := '';
            end;
        end else if (joField.type = 'integer')  then begin
            oSpinEdit       := TSpinEdit(oPN.Controls[1]);
            if joField.Exists('default') then begin
                oSpinEdit.Value := joField.default;
            end else begin
                oSpinEdit.Value := 0;
            end;
        end else if (joField.type = 'date')  then begin
            oDTPicker   := TDateTimePicker(oPN.Controls[1]);
            if joField.Exists('default') then begin
                oDTPicker.Date  := StrToDateDef(joField.default,Now);
            end else begin
                oDTPicker.Date  := Now;
            end;
        end else if (joField.type = 'boolean')  then begin
            oSwitch := TToggleSwitch(oPN.Controls[1]);
            if joField.Exists('default') then begin
                oSwitch.State := joField.default;
            end else begin
                oSwitch.State := tssOff;
            end;
        end else if (joField.type = 'group')  then begin
        end else begin
            oEdit       := TEdit(oPN.Controls[1]);
            if joField.Exists('default') then begin
                oEdit.Text  := joField.default;
            end else begin
                oEdit.Text  := '';
            end;
        end;
    end;

    //标记
    P_Editor.Caption    := 'N0';    //E表示Edit,还有N，表示New; 0表示主表,1~n表示从表

    //显示编辑面板
    P_Editor.Visible    := True;

    //隐藏面板中的sB
    for iItem := 0 to 99 do begin
        oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;
    oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(0)));
    oSB.Visible := True;

end;

procedure TForm_Item.B_PrintClick(Sender: TObject);
begin
    dwPrint(SG_Main);
end;

procedure TForm_Item.B_SlaveDeleteClick(Sender: TObject);
var
    iField      : Integer;
    iSlave      : Integer;
    iRow        : Integer;
    //
    sInfo       : string;
    //
    joSlave     : Variant;
    //
    oFDQuery    : TFDQuery;
    oSG         : TStringgrid;
begin
    //
    iSlave      := PC_Slave.ActivePageIndex;
    joSlave     := gjoConfig.slave._(iSlave);
    oFDQuery    := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));
    if (oFDQuery = nil) then begin
        Exit;
    end;
    oSG         := TStringGrid(FindComponent('SGSlave'+IntToStr(iSlave)));
    iRow        := oSG.Row;

    //隐藏编辑
    sInfo  := '['+oSG.cells[0,iRow];
    for iField := 1 to oSG.ColCount-1 do begin
        sInfo  := sInfo+', '+oSG.Cells[iField,iRow];
    end;
    sInfo  := sInfo+']';

    //删除提示
    dwMessageDlg('确定要删除记录 '+sInfo+' 吗？',
            'confirm',
            'OK',
            'Cancel',
            'query_delete'+IntToStr(iSlave),
            self);

end;

procedure TForm_Item.B_SlaveEditClick(Sender: TObject);
var
    iSlave      : Integer;
    iField      : Integer;
    iItem       : Integer;
    //
    sName       : string;
    //
    oSB         : TScrollBox;
    oPN         : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;
    oFDQuery    : TFDQuery;

    //
    joEditor    : Variant;
    joField     : Variant;
    joEdit      : Variant;
    joSlave     : Variant;
begin
    //
    iSlave      := PC_Slave.ActivePageIndex;
    joSlave     := gjoConfig.slave._(iSlave);
    oFDQuery    := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));

    //依次创建编辑字段对象
    for iField := 0 to joSlave.fields._count - 1 do begin
        //得到字段对象
        joField := joSlave.fields._(iField);

        //
        sName   := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
        if (joField.type = 'string') and (joField.Exists('list')) then begin
            oComboBox   := TComboBox(TPanel(FindComponent(sName)).Controls[1]);
            oComboBox.Text  := oFDQuery.FieldByName(joField.name).AsString;
        end else if (joField.type = 'integer')  then begin
            oSpinEdit       := TSpinEdit(TPanel(FindComponent(sName)).Controls[1]);
            oSpinEdit.Value := oFDQuery.FieldByName(joField.name).AsInteger;
        end else if (joField.type = 'date')  then begin
            oDTPicker   := TDateTimePicker(TPanel(FindComponent(sName)).Controls[1]);
            oDTPicker.Date  := oFDQuery.FieldByName(joField.name).AsDateTime;
        end else if (joField.type = 'boolean')  then begin
            oSwitch := TToggleSwitch(TPanel(FindComponent(sName)).Controls[1]);
            oDTPicker.Date  := oFDQuery.FieldByName(joField.name).AsDateTime;
        end else if (joField.type = 'group')  then begin
        end else begin
            oEdit       := TEdit(TPanel(FindComponent(sName)).Controls[1]);
            oEdit.Text  := oFDQuery.FieldByName(joField.name).AsString;
        end;
    end;

    //标记
    P_Editor.Caption    := 'E'+IntToStr(iSlave+1);    //E表示Edit,还有N，表示New; 0表示主表,1~n表示从表

    //显示编辑面板
    P_Editor.Visible    := True;

    //隐藏面板中的sB
    for iItem := 0 to 99 do begin
        oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;
    oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(iSlave+1)));
    oSB.Visible := True;
end;

procedure TForm_Item.B_SlaveNewClick(Sender: TObject);
var
    iField      : Integer;
    iSlave      : Integer;
    iItem       : Integer;
    //
    oSB         : TScrollBox;
    oPN         : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;

    //
    joEditor    : Variant;
    joField     : Variant;
    joEdit      : Variant;
    joSlave     : Variant;
begin
    //
    iSlave  := PC_Slave.ActivePageIndex;
    joSlave := gjoConfig.slave._(iSlave);


    //依次创建新增数据字段对象
    for iField := 0 to joSlave.fields._count - 1 do begin
        //得到字段对象
        joField := joSlave.fields._(iField);

        oPN := TPanel(FindComponent('P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField)));
        if (joField.type = 'string') and (joField.Exists('list')) then begin
            oComboBox   := TComboBox(oPN.Controls[1]);
            if joField.name = joSlave.slavefield then begin
                oComboBox.Text      := FDQuery1.FieldByName(joSlave.masterfield).AsString;
                oComboBox.Enabled   := False;
            end else begin
                oComboBox.Enabled   := True;
                if joField.Exists('default') then begin
                    oComboBox.Text  := joField.default;
                end else begin
                    oComboBox.Text  := '';
                end;
            end;
        end else if (joField.type = 'integer')  then begin
            oSpinEdit       := TSpinEdit(oPN.Controls[1]);
            if joField.name = joSlave.slavefield then begin
                oSpinEdit.Value := FDQuery1.FieldByName(joSlave.masterfield).AsInteger;
                oSpinEdit.Enabled   := False;
            end else begin
                oSpinEdit.Enabled   := True;
                if joField.Exists('default') then begin
                    oSpinEdit.Value := joField.default;
                end else begin
                    oSpinEdit.Value := 0;
                end;
            end;
        end else if (joField.type = 'date')  then begin
            oDTPicker   := TDateTimePicker(oPN.Controls[1]);
            if joField.name = joSlave.slavefield then begin
                oDTPicker.Date      := FDQuery1.FieldByName(joSlave.masterfield).AsDateTime;
                oDTPicker.Enabled   := False;
            end else begin
                oDTPicker.Enabled   := True;
                if joField.Exists('default') then begin
                    oDTPicker.Date  := StrToDateDef(joField.default,Now);
                end else begin
                    oDTPicker.Date  := Now;
                end;
            end;
        end else if (joField.type = 'boolean')  then begin
            oSwitch := TToggleSwitch(oPN.Controls[1]);
            if joField.name = joSlave.slavefield then begin
                oSwitch.State   := TToggleSwitchState(FDQuery1.FieldByName(joSlave.masterfield).AsBoolean);
                oSwitch.Enabled := False;
            end else begin
                oSwitch.Enabled := True;
                if joField.Exists('default') then begin
                    oSwitch.State := joField.default;
                end else begin
                    oSwitch.State := tssOff;
                end;
            end;
        end else if (joField.type = 'group')  then begin
        end else begin
            oEdit       := TEdit(oPN.Controls[1]);
            if joField.name = joSlave.slavefield then begin
                oEdit.Text      := FDQuery1.FieldByName(joSlave.masterfield).AsString;
                oEdit.Enabled   := False;
            end else begin
                oEdit.Enabled   := True;
                if joField.Exists('default') then begin
                    oEdit.Text  := joField.default;
                end else begin
                    oEdit.Text  := '';
                end;
            end;
        end;
    end;

    //标记
    P_Editor.Caption    := 'N'+IntToStr(iSlave+1);    //E表示Edit,还有N，表示New; 0表示主表,1~n表示从表

    //显示编辑面板
    P_Editor.Visible    := True;

    //隐藏面板中的sB
    for iItem := 0 to 99 do begin
        oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;
    oSB := TScrollBox(FindComponent('SB_Editor'+IntTostr(iSlave+1)));
    oSB.Visible := True;
end;

procedure TForm_Item.B_SlavePrintClick(Sender: TObject);
var
    iSlave  : Integer;
begin
    //
    iSlave  := PC_Slave.ActivePageIndex;
    if FindComponent('SGSlave'+IntToStr(iSlave))<> nil then begin
        dwPrint(TStringGrid(FindComponent('SGSlave'+IntToStr(iSlave))));
    end;
end;



procedure TForm_Item.E_KeywordChange(Sender: TObject);
begin
    //更新页码
    TB_Main.Position  := 1;

    //更新数据
    UpdateDatas;

end;

procedure TForm_Item.FormShow(Sender: TObject);
const
    //配置
    _Config    =
        '{'
            +'"table":"dwf_goods",'          //对应数据表名称
            +'"pagesize":5,'                   //每页显示记录数，默认10
            +'"rowheight":35,'                  //行高，默认35
            //+'"delete":0,'
            +'"fields":['                       //字段集
                //name必须有，caption默认为name,width默认为100,sort默认为0，即不排序
                //align:默认居中，left/center/right
                //list：为选项
                +'{"name":"id","caption":"id","width":40,"readonly":1},'
                +'{"name":"goodsname","caption":"货品名称","width":180,"align":"left","sort":1},'
                +'{"name":"goodscode","caption":"编码","width":120,"sort":1},'
                +'{"name":"provider","caption":"供应商","align":"left","width":180},'
                +'{"name":"spec","caption":"规格","width":150},'
                +'{"name":"unit","caption":"单位","width":60,"list":["","个","台","部","支","付"]},'
                +'{"name":"inprice","caption":"进价","width":80,"align":"right","sort":1,"format":"%n","type":"integer"},'
                +'{"name":"price","caption":"售价","width":80,"align":"right","sort":1,"format":"%n","type":"integer"},'
                +'{"name":"description","caption":"备注","width":150}'
            +'],'
            //
            +'"slavepagesize":5,'                   //每页显示记录数，默认10
            +'"slaverowheight":30,'                 //行高，默认35
            +'"slave":['                            //字段集
                +'{'
                    +'"caption":"详细参数",'        //模块标题
                    +'"table":"dwf_goodsex",'       //对应数据表名称
                    +'"imageindex":51,'             //图标序号，默认56
                    +'"masterfield":"id",'
                    +'"slavefield":"gid",'
                    //+'"edit":1,'                        //是否可编辑
                    //+'"new":1,'                         //是否可以新增
                    //+'"delete":1,'                      //是否可删除
                    //+'"print":0,'                       //是否可打印
                    +'"fields":['                   //字段集
                        +'{"name":"id","caption":"id","width":40,"readonly":1},'
                        +'{"name":"gid","caption":"货品ID","width":120},'
                        +'{"name":"title","caption":"属性名称","width":220,"sort":1},'
                        +'{"name":"value","caption":"属性值","width":180}'
                    +']'
                +'},'
                +'{'
                    +'"caption":"进货记录",'            //模块标题
                    +'"table":"dwf_inport",'            //对应数据表名称
                    +'"imageindex":50,'                 //图标序号，默认56
                    +'"masterfield":"id",'              //关联关系之主表字段
                    +'"slavefield":"gid",'              //关系关系之从表字段
                    +'"edit":1,'                        //是否可编辑
                    +'"new":0,'                         //是否可以新增
                    +'"delete":0,'                      //是否可删除
                    +'"print":1,'                       //是否可打印
                    +'"fields":['                       //字段集
                        +'{"name":"id","caption":"id","width":40,"readonly":1},'
                        +'{"name":"gid","caption":"货品ID","width":80},'
                        +'{"name":"provider","caption":"供应商","width":220},'
                        +'{"name":"unit","caption":"单位","width":50},'
                        +'{"name":"price","caption":"单价","width":80,"align":"right"},'
                        +'{"name":"num","caption":"数量","width":80,"align":"right"},'
                        +'{"name":"amount","caption":"金额","width":120,"align":"right"},'
                        +'{"name":"ware","caption":"仓库","width":160},'
                        +'{"name":"operator","caption":"操作员","width":90},'
                        +'{"name":"date","caption":"日期","width":120,"type":"date"},'
                        +'{"name":"memo","caption":"备注","width":100}'
                    +']'
                +'},'
                +'{'
                    +'"caption":"销售记录",'            //模块标题
                    +'"table":"dwf_outport",'           //对应数据表名称
                    +'"imageindex":49,'                 //图标序号，默认56
                    +'"masterfield":"id",'              //关联关系之主表字段
                    +'"slavefield":"gid",'              //关系关系之从表字段
                    +'"edit":0,'                        //是否可编辑
                    +'"new":1,'                         //是否可以新增
                    +'"delete":0,'                      //是否可删除
                    +'"print":1,'                       //是否可打印
                    +'"fields":['                       //字段集
                        +'{"name":"id","caption":"id","width":40,"readonly":1},'
                        +'{"name":"gid","caption":"货品ID","width":80},'
                        +'{"name":"unit","caption":"单位","width":120},'
                        +'{"name":"price","caption":"单价","width":120,"align":"right"},'
                        +'{"name":"num","caption":"数量","width":120,"align":"right"},'
                        +'{"name":"amount","caption":"金额","width":120,"align":"right","sort":1},'
                        +'{"name":"operator","caption":"经办人","width":100},'
                        +'{"name":"date","caption":"日期","width":120},'
                        +'{"name":"memo","caption":"备注","width":100}'
                    +']'
                +'}'
            +']'
        +'}';

var
    iItem       : Integer;
    iField      : Integer;
    iSlave      : Integer;
    iList       : Integer;
    //
    joField     : Variant;
    joCell      : Variant;
    joHint      : Variant;
    joSlave     : Variant;
    //
    oTab        : TTabSheet;
    oFDQuery    : TFDQuery;
    oTB         : TTrackBar;
    oSG         : TStringGrid;
    oSB         : TScrollBox;
    oP          : TPanel;
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
                if gjoConfig.align = 'right' then begin
                    Alignment   := taRightJustify;
                end else if gjoConfig.align = 'center' then begin
                    Alignment   := taCenter;
                end;
            end;
            //width   := gjoConfig.captionwidth - 20;
        end;
    end;
begin
    //配置FDQuery1的连接
    FDQuery1.Connection    := TForm1(self.Owner).FDConnection1;

    //
    gbConfigError   := False;

    //检查配置文件的有效性，并补齐一些默认属性
    try
        gjoConfig   := _Json(_Config);

        //将配置字符串转换为配置JSON对象，如果不成功，则标记配置字符串错误
        if gjoConfig = unassigned then begin
            gbConfigError   := True;
            Exit;
        end;

        //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        if not gjoConfig.Exists('table') then begin //默认表名
            gjoConfig.table := 'dwf_provider';
        end;
        if not gjoConfig.Exists('pagesize') then begin  //默认数据每页显示的行数
            gjoConfig.pagesize  := 5;
        end;
        if not gjoConfig.Exists('rowheight') then begin //默认数据行的行高
            gjoConfig.rowheight  := 45;
        end;
        if not gjoConfig.Exists('edit') then begin      //默认显示编辑按钮
            gjoConfig.edit  := 1;
        end;
        if not gjoConfig.Exists('new') then begin       //默认显示新增按钮
            gjoConfig.new  := 1;
        end;
        if not gjoConfig.Exists('delete') then begin    //默认显示删除按钮
            gjoConfig.delete  := 1;
        end;
        if not gjoConfig.Exists('print') then begin     //默认显示打印按钮
            gjoConfig.print  := 1;
        end;
        if not gjoConfig.Exists('fields') then begin    //显示的字段列表
            gjoConfig.fields  := _json('[]');
        end;
        //>

        //检查 显示字段列表fields
        for iField := 0 to gjoConfig.fields._Count-1 do begin
            joField := gjoConfig.fields._(iField);
            //如果字段没有name，则标记为配置错误
            if not joField.Exists('name') then begin
                gbConfigError   := True;
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
            if not joField.Exists('align') then begin       //默认居中显示
                joField.align   := 'center';
            end;
        end;

    except
        gbConfigError   := True;
    end;

    //显示/隐藏 增删改印按钮
    B_New.Visible      := gjoConfig.new = 1;
    B_Edit.Visible     := gjoConfig.edit = 1;
    B_Print.Visible    := gjoConfig.print = 1;
    B_Delete.Visible   := gjoConfig.delete = 1;

    //<得到Hint的JSON对象（以更新rowheight、dataset）
    joHint  := _json(SG_Main.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    //行高
    joHint.rowheight    := gjoConfig.rowheight;
    joHint.headerheight := gjoConfig.rowheight;
    //
    joHint.dataset      := 'FDQuery1';

    //返写到Hint中
    SG_Main.Hint := joHint;
    //>

    //<-----根据配置信息更新SG_Main
    SG_Main.Height          := gjoConfig.rowheight * ( 1 + gjoConfig.pagesize )+1;  //高度
    SG_Main.RowCount        := gjoConfig.pagesize + 1;  //行数
    SG_Main.DefaultRowHeight:= gjoConfig.rowheight;     //行高
    SG_Main.ColCount        := gjoConfig.fields._count; //列数
    SG_Main.FixedCols       := 0;                       //固定列数

    //配置各列参数
    for iField := 0 to gjoConfig.fields._count - 1 do begin
        //得到字段对象
        joField := gjoConfig.fields._(iField);

        //生成各列参数配置的JSON字符串
        joCell          := _json('{}');         //列参数写在每列的第一行中，JSON格式
        joCell.caption  := joField.caption;     //显示标题
        joCell.sort     := joField.sort = 1;    //是否显示排序按钮
        joCell.align    := joField.align;       //对齐方式，left/center/right. 默认center

        //Cells[1,0] := '{"caption":"名称","sort":true,"filter":["净水管道","暖气片","电视机","空调","热水器","LG笔记本"]}';
        SG_Main.Cells[iField,0]   := joCell;

        //列宽
        SG_Main.ColWidths[iField] := joField.width;
    end;

    //>

    //更新页码
    TB_Main.Position    := 0;

    //更新从表
    if not gjoConfig.Exists('slave') then begin
        PC_Slave.Visible   := False;
        P_SlaveButtons.Visible  := False;
    end else begin
        //先删除原有的TabSheet
        for iSlave := PC_Slave.PageCount-1 downto 0 do begin
            PC_Slave.Pages[iSlave].Destroy;
        end;
        //创建从表 以及从表的Order
        SetLength(gsOrders,Integer(gjoConfig.slave._Count));
        for iSlave := 0 to gjoConfig.slave._Count-1 do begin
            //添加从表的Order
            gsOrders[iSlave]    := '';

            //
            joSlave := gjoConfig.slave._(iSlave);

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
            oTab                := TTabSheet.Create(self);
            oTab.Name           := 'TS'+IntToStr(iSlave);
            oTab.PageControl    := PC_Slave;
            oTab.Caption        := joSlave.caption;
            oTab.ImageIndex     := joSlave.imageindex;

            //创建FDQuery
            oFDQuery                := TFDQuery.Create(self);
            oFDQuery.Name           := 'FDQuerySlave'+IntToStr(iSlave);
            oFDQuery.Connection     := TForm1(self.Owner).FDConnection1;

            //创建
            oSG             := TStringGrid.Create(self);
            oSG.Parent      := oTab;
            oSG.BorderStyle := bsNone;
            oSG.Name        := 'SGSlave'+IntToStr(iSlave);
            oSG.Align       := alClient;
            oSG.Hint        := '{"dwattr":"border stripe","dataset":"'+oFDQuery.Name+'","rowheight":35,"headerheight":35}';

            //
            oSG.Height              := gjoConfig.rowheight * ( 1 + gjoConfig.slavepagesize )+1;  //高度
            oSG.RowCount            := gjoConfig.slavepagesize + 1;  //行数
            oSG.DefaultRowHeight    := gjoConfig.rowheight;     //行高
            oSG.ColCount            := joSlave.fields._count; //列数
            oSG.FixedCols           := 0;                       //固定列数
            oSG.OnGetEditMask       := SG_MainGetEditMask;
            oSG.OnClick             := SG_SlaveClick;

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
            oTB             := TTrackBar.Create(self);
            oTB.Name        := 'TBSlave'+IntToStr(iSlave);
            oTB.Parent      := oTab;
            oTB.Align       := alBottom;
            oTB.Hint        := '{"dwattr":"background"}';
            oTB.Height      := 35;
            oTB.PageSize    := gjoConfig.slavepagesize;
            oTB.HelpKeyword := 'page';
            oTB.Position    := 1;
            oTB.OnChange    := TrackBar_SlaveChange;
            oTB.AlignWithMargins    := True;
            oTB.Margins.Top := 5;

        end;
        PC_Slave.ActivePageIndex   := 0;

        //更新从表功能按钮的位置
        P_SlaveButtons.Top  := PC_Slave.Top+7;
    end;

    //更新数据
    UpdateDatas;

    //切换从表PageControl,以显示数据
    if gjoConfig.Exists('slave') then begin
        PC_Slave.OnChange(PC_Slave);
    end;

    //<-----创建编辑面板
    //创建ScrollBox，以容纳更多控件
    oSB                 := TScrollBox(CloneComponent(SB_Demo));
    oSB.Parent          := P_Editor;
    oSB.Name            := 'SB_Editor0';
    oSB.Visible         := True;

    //清空ScrollBox中的控件
    oP  := TPanel(oSB.Controls[0]);
    oP.Name := 'P_Main';
    for iItem := oP.ControlCount-1 downto 0 do begin
        oP.Controls[iItem].Destroy;
    end;
    //根据Fields创建编辑框
    for iField := 0 to gjoConfig.fields._count - 1 do begin
        //得到字段对象
        joField := gjoConfig.fields._(iField);

        //
        if (joField.type = 'string') and (joField.Exists('list')) then begin
            oPanel  := TPanel(CloneComponent(Panel_combo));
            with oPanel do begin
                Parent      := oP;
                Name        := 'P_Editor'+IntToStr(iField);
                Visible     := True;
                Top         := iField * 1000;
            end;

            //
            _SetCaption(TLabel(oPanel.Controls[0]));

            //
            oComboBox   := TComboBox(oPanel.Controls[1]);
            oComboBox.Items.Clear;
            for iList := 0 to joField.list._Count-1 do begin
                oComboBox.Items.Add(joField.list._(iList));
            end;
            //
            if joField.Exists('default') then begin
                oComboBox.Text  := joField.default;
            end;
        end else if (joField.type = 'integer')  then begin
            oPanel  := TPanel(CloneComponent(Panel_integer));
            with oPanel do begin
                Parent      := oP;
                Name        := 'P_Editor'+IntToStr(iField);
                Visible     := True;
                Top         := iField * 1000;
            end;

            //
            _SetCaption(TLabel(oPanel.Controls[0]));

            //
            oSpinEdit   := TSpinEdit(oPanel.Controls[1]);
            //
            if joField.Exists('default') then begin
                oSpinEdit.Value := StrToIntDef(joField.default,0);
            end;
        end else if (joField.type = 'date')  then begin
            oPanel  := TPanel(CloneComponent(Panel_date));
            with oPanel do begin
                Parent      := oP;
                Name        := 'P_Editor'+IntToStr(iField);
                Visible     := True;
                Top         := iField * 1000;
            end;

            //
            _SetCaption(TLabel(oPanel.Controls[0]));

            //
            oDTPicker   := TDateTimePicker(oPanel.Controls[1]);
            //
            if joField.Exists('default') then begin
                oDTPicker.Date  := StrToDateDef(joField.default,Now);
            end;
        end else if (joField.type = 'boolean')  then begin
            oPanel  := TPanel(CloneComponent(Panel_Boolean));
            with oPanel do begin
                Name        := 'P_Editor'+IntToStr(iField);
                Parent      := oP;
                Visible     := True;
                Top         := iField * 1000;
            end;

            //
            _SetCaption(TLabel(oPanel.Controls[0]));

            //
            oSwitch     := TToggleSwitch(oPanel.Controls[1]);
            //
            if joField.Exists('default') then begin
                if lowercase(joField.default) = 'true' then begin
                    oSwitch.State   := tssOn;
                end;
            end;
        end else if (joField.type = 'group')  then begin
            oPanel  := TPanel(CloneComponent(Panel_Group));
            with oPanel do begin
                Name        := 'P_Editor'+IntToStr(iField);
                Parent      := oP;
                Visible     := True;
                Top         := iField * 1000;
            end;

            //
            _SetCaption(TLabel(oPanel.Controls[0]));

        end else begin
            oPanel  := TPanel(CloneComponent(Panel_string));
            with oPanel do begin
                Parent      := oP;
                Name        := 'P_Editor'+IntToStr(iField);
                Visible     := True;
                Top         := iField * 1000;
            end;

            //
            _SetCaption(TLabel(oPanel.Controls[0]));

            //
            oEdit   := TEdit(oPanel.Controls[1]);
            //
            if joField.Exists('default') then begin
                oEdit.Text  := joField.default;
            end;
        end;

        //跳过只读字段
        if joField.Exists('readonly') then begin
            if joField.readonly = 1 then begin
                oPanel.Hint := '{"dwstyle":"pointer-events: none;"}';
            end;
        end;
    end;
    oP.AutoSize := False;
    oP.AutoSize := True;
    //>

    //<-----创建从表的编辑面板
    if gjoConfig.Exists('slave') then begin
        for iSlave := 0 to gjoConfig.slave._Count-1 do begin
            //
            joSlave := gjoConfig.slave._(iSlave);

            //创建ScrollBox，以容纳更多控件
            oSB                 := TScrollBox(CloneComponent(SB_Demo));
            oSB.Parent          := P_Editor;
            oSB.Name            := 'SB_Editor'+IntToStr(iSlave+1);
            oSB.Visible         := True;

            //清空ScrollBox中的控件
            oP  := TPanel(oSB.Controls[0]);
            oP.Name := 'P_Content'+IntToStr(iSlave+1);
            for iItem := oP.ControlCount-1 downto 0 do begin
                oP.Controls[iItem].Destroy;
            end;
            //根据Fields创建编辑框
            for iField := 0 to joSlave.fields._count - 1 do begin
                //得到字段对象
                joField := joSlave.fields._(iField);

                //
                if (joField.type = 'string') and (joField.Exists('list')) then begin
                    oPanel  := TPanel(CloneComponent(Panel_combo));
                    with oPanel do begin
                        Parent      := oP;
                        Name        := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                        Visible     := True;
                        Top         := iField * 1000;
                    end;

                    //
                    _SetCaption(TLabel(oPanel.Controls[0]));

                    //
                    oComboBox   := TComboBox(oPanel.Controls[1]);
                    oComboBox.Items.Clear;
                    for iList := 0 to joField.list._Count-1 do begin
                        oComboBox.Items.Add(joField.list._(iList));
                    end;
                    //
                    if joField.Exists('default') then begin
                        oComboBox.Text  := joField.default;
                    end;
                end else if (joField.type = 'integer')  then begin
                    oPanel  := TPanel(CloneComponent(Panel_integer));
                    with oPanel do begin
                        Parent      := oP;
                        Name        := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                        Visible     := True;
                        Top         := iField * 1000;
                    end;

                    //
                    _SetCaption(TLabel(oPanel.Controls[0]));

                    //
                    oSpinEdit   := TSpinEdit(oPanel.Controls[1]);
                    //
                    if joField.Exists('default') then begin
                        oSpinEdit.Value := StrToIntDef(joField.default,0);
                    end;
                end else if (joField.type = 'date')  then begin
                    oPanel  := TPanel(CloneComponent(Panel_date));
                    with oPanel do begin
                        Parent      := oP;
                        Name        := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                        Visible     := True;
                        Top         := iField * 1000;
                    end;

                    //
                    _SetCaption(TLabel(oPanel.Controls[0]));

                    //
                    oDTPicker   := TDateTimePicker(oPanel.Controls[1]);
                    //
                    if joField.Exists('default') then begin
                        oDTPicker.Date  := StrToDateDef(joField.default,Now);
                    end;
                end else if (joField.type = 'boolean')  then begin
                    oPanel  := TPanel(CloneComponent(Panel_Boolean));
                    with oPanel do begin
                        Name        := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                        Parent      := oP;
                        Visible     := True;
                        Top         := iField * 1000;
                    end;

                    //
                    _SetCaption(TLabel(oPanel.Controls[0]));

                    //
                    oSwitch     := TToggleSwitch(oPanel.Controls[1]);
                    //
                    if joField.Exists('default') then begin
                        if lowercase(joField.default) = 'true' then begin
                            oSwitch.State   := tssOn;
                        end;
                    end;
                end else if (joField.type = 'group')  then begin
                    oPanel  := TPanel(CloneComponent(Panel_Group));
                    with oPanel do begin
                        Name        := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                        Parent      := oP;
                        Visible     := True;
                        Top         := iField * 1000;
                    end;

                    //
                    _SetCaption(TLabel(oPanel.Controls[0]));

                end else begin
                    oPanel  := TPanel(CloneComponent(Panel_string));
                    with oPanel do begin
                        Parent      := oP;
                        Name        := 'P_SEditor'+IntToStr(iSlave)+'_'+IntToStr(iField);
                        Visible     := True;
                        Top         := iField * 1000;
                    end;

                    //
                    _SetCaption(TLabel(oPanel.Controls[0]));

                    //
                    oEdit   := TEdit(oPanel.Controls[1]);
                    //
                    if joField.Exists('default') then begin
                        oEdit.Text  := joField.default;
                    end;
                end;

                //跳过只读字段
                if joField.Exists('readonly') then begin
                    if joField.readonly = 1 then begin
                        oPanel.Hint := '{"dwstyle":"pointer-events: none;"}';
                    end;
                end;
            end;
            oP.AutoSize := False;
            oP.AutoSize := True;
        end;
    end;

end;

procedure TForm_Item.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod     : string;
    sAction     : string;
    sMValue     : string;   //主从关联关系中主表的关键字段值
    //
    iSlave      : Integer;
    //
    joSlave     : Variant;

    oFDQuery    : TFDQuery;
begin
    //事件标志
    sMethod := dwGetProp(Self,'interactionmethod');
    //通过类似以下得到返回的结果，为'1'时表示为"确定"，否则为"取消"
    sAction := dwGetProp(Self,'interactionvalue');

    if sMethod = 'query_delete' then begin
        if sAction = '1' then begin
            //先删除从表数据
            if gjoConfig.Exists('slave') then begin
                oFDQuery    := TFDQuery.Create(self);
                oFDQuery.Connection := FDQuery1.Connection;
                for iSlave := 0 to gjoConfig.slave._Count-1 do begin
                    joSlave := gjoConfig.slave._(iSlave);
                    //取得关联值
                    sMValue := FDQuery1.FieldByName(joSlave.masterfield).AsString;
                    //执行删除
                    oFDQuery.Close;
                    if FDQuery1.FieldByName(joSlave.masterfield).DataType in
                        [ftSmallint, ftInteger, ftWord, ftAutoInc]
                    then begin
                        oFDQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                                +' WHERE '+joSlave.slavefield+'='+sMValue;
                    end else begin
                        oFDQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                                +' WHERE '+joSlave.slavefield+'='''+sMValue+'''';
                    end;
                    oFDQuery.ExecSQL;
                end;
                oFDQuery.Destroy;
            end;

            //删除主表数据
            FDQuery1.Delete;

            //更新显示
            UpdateDatas;
            UpdateSlaves;

            //提示删除成功
            dwMessage('删除完成！','success',self);
        end;
    end else if Pos('query_delete',sMethod)>0 then begin
        //取得iSlave
        Delete(sMethod,1,12);
        iSlave  := StrToIntDef(sMethod,-1);
        //
        if iSlave <> -1 then begin
            oFDQuery    := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));
            if oFDQuery <> nil then begin
                if sAction = '1' then begin
                    oFDQuery.Delete;
                    UpdateSlaves;
                    dwMessage('删除完成！','success',self);
                end;
            end;
        end;
    end;
end;

procedure TForm_Item.PC_SlaveChange(Sender: TObject);
var
    iSlave      : Integer;
    joSlave     : Variant;
begin
    //根据当前从表的设置，动态显示/隐藏各功能按钮（Edit/New/Delete/Print）
    iSlave  := PC_Slave.ActivePageIndex;
    joSlave := gjoConfig.slave._(iSlave);
    //
    B_SlaveEdit.Visible    := joSlave.edit = 1;
    B_SlaveNew.Visible     := joSlave.New = 1;
    B_SlaveDelete.Visible  := joSlave.Delete = 1;
    B_SlavePrint.Visible   := joSlave.Print = 1;
end;

procedure TForm_Item.SG_MainClick(Sender: TObject);
var
    iRow    : Integer;
begin
    //
    iRow    := SG_Main.Row;
    //
    if iRow > FDQuery1.RecordCount then begin
        iRow    := FDQuery1.RecordCount;
        //
        SG_Main.OnClick := nil;
        SG_Main.Row     := iRow;
        SG_Main.OnClick := SG_MainClick;
    end;

    //
    FDQuery1.RecNo  := iRow;
    //
    UpdateSlaves;
end;

procedure TForm_Item.SG_MainGetEditMask(Sender: TObject; ACol, ARow: Integer; var Value: string);
var
    iSlave  : Integer;
    //
    oSG     : TStringGrid;
begin
    //对应StringGrid的排序事件，    其中参数：
    //ACol : Integer ; 为所在列序号（从0开始）；
    //ARow : Integer;  为排序方向，1为升序，0为降序；
    //Value : string; 为标识，固定为字符串'sort'

    //取得当前控件
    oSG := TStringGrid(Sender);

    if oSG = SG_Main then begin //主表的排序事件
        //设置主表的排序字符串 'ORDER BY name DESC'
        gsOrder    := 'ORDER BY '+gjoConfig.fields._(ACol).name;
        if ARow = 0 then begin
            gsOrder := gsOrder + ' DESC';
        end;

        //刷新显示
        TB_Main.Position    := 0;
        UpdateDatas;
    end else begin  //从表的排序
        //取得从表序号
        iSlave  := StrToIntDef(Copy(oSG.Name,8,10),-1);

        //如果名称不正确，则退出， 就为SGSlave0,SGSlave1,SGSlave2,...
        if iSlave = -1 then begin
            Exit;
        end;

        //如果配置中无从表，则退出
        if not gjoConfig.Exists('slave') then begin
            Exit;
        end;

        //如果从表序号超界，则退出
        if (iSlave >= gjoConfig.slave._Count) or (iSlave < 0) then begin
            Exit;
        end;

        //设置Order字符串
        gsOrders[iSlave]    := 'ORDER BY '+gjoConfig.slave._(iSlave).fields._(ACol).name;
        if ARow = 0 then begin
            gsOrders[iSlave]:= gsOrders[iSlave] + ' DESC';
        end;

        //更新从表
        UpdateSlaves;
    end
end;

procedure TForm_Item.SG_SlaveClick(Sender: TObject);
var
    iRow        : Integer;
    iSlave      : Integer;
    oSG         : TStringGrid;
    oFDQuery    : TFDQuery;
begin
    //
    iSlave      := PC_Slave.ActivePageIndex;
    oSG         := TStringGrid(Sender);
    iRow        := oSG.Row;
    oFDQuery    := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));

    //
    if iRow > oFDQuery.RecordCount then begin
        iRow    := oFDQuery.RecordCount;
        //
        oSG.OnClick := nil;
        oSG.Row     := iRow;
        oSG.OnClick := SG_SlaveClick;
    end;

    //
    oFDQuery.RecNo  := iRow;
end;

procedure TForm_Item.TB_MainChange(Sender: TObject);
begin
    //更新数据
    UpdateDatas;
end;

procedure TForm_Item.TrackBar_SlaveChange(Sender: TObject);
begin
    UpdateSlaves;
end;

procedure TForm_Item.UpdateDatas;
var
    iField      : Integer;
    iSlave      : Integer;
    //
    sFields     : string;
    sMValue     : string;
    sWhere      : string;
    //
    joField     : Variant;
    joSlave     : Variant;
    //
    oFDQuery    : TFDQuery;
    oTrackBar   : TTrackBar;
begin
    //异常检查
    if gbConfigError then begin
        dwMessage('Config is invalid!','error',self);
        Exit;
    end;

    //取得字段名称列表，备用
    sFields := gjoConfig.fields._(0).name;
    for iField := 1 to gjoConfig.fields._Count-1 do begin
        joField := gjoConfig.fields._(iField);
        //
        sFields := sFields+','+joField.name
    end;

    //
    sWhere  := dwGetWhere(sFields,  E_Keyword.Text);

    //
    dwaGetDataToGrid(
            FDQuery1,           //AQuery:TFDQuery;
            gjoConfig.table,    //ATable,
            sFields,            //AFields,
            sWhere,             //AWhere,
            gsOrder,            //AOrder:String;
            TB_Main.Position,   //APage,
            gjoConfig.pagesize, //ACount:Integer;
            SG_Main,            //ASG:TStringGrid;
            TB_Main             //ATrackBar:TTrackBar
            );
    FDQuery1.First;

    //
    UpdateSlaves;
end;


procedure TForm_Item.UpdateSlaves;
var
    iField      : Integer;
    iSlave      : Integer;
    //
    sFields     : string;
    sMValue     : string;
    sWhere      : string;
    //
    joField     : Variant;
    joSlave     : Variant;
    //
    oFDQuery    : TFDQuery;
    oTrackBar   : TTrackBar;
    oStringGrid : TStringGrid;
begin
    //如果没有slave,则退出
    if not gjoConfig.Exists('slave') then begin
        Exit;
    end;

    //逐个更新slave
    for iSlave := 0 to gjoConfig.slave._Count-1 do begin
        //得到从表JSON
        joSlave := gjoConfig.slave._(iSlave);

        //主表关联字段值
        sMValue := FDQuery1.FieldByName(joSlave.masterfield).AsString;

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
        oFDQuery   := TFDQuery(FindComponent('FDQuerySlave'+IntToStr(iSlave)));


        //得到分页组件
        oTrackBar   := TTrackBar(FindComponent('TBSlave'+IntToStr(iSlave)));

        //
        oStringGrid := TStringGrid(FindComponent('SGSlave'+IntToStr(iSlave)));

        //
        sWhere      := 'WHERE '+joSlave.slavefield+'='+sMValue;  //'WHERE id>10'

        dwaGetDataToGrid(
                oFDQuery,           //AQuery:TFDQuery;
                joSlave.table,      //ATable,
                sFields,            //AFields,
                sWhere,             //AWhere,
                gsOrders[iSlave],   //AOrder:String;
                oTrackBar.Position, //Page,
                gjoConfig.slavepagesize,    //ACount:Integer;
                oStringGrid,        //ASG:TStringGrid;
                oTrackBar           //ATrackBar:TTrackBar
                );
    end;

end;

end.
