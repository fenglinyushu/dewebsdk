unit Account;

interface

uses
    //
    dwVars,
    dwBase,

    //
    SynCommons,

    //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.VCLUI.ConnEdit,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.MySQLDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef,
  FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
  FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.ADSDef,
  FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef,
  FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef,
  FireDAC.Phys.ASADef, FireDAC.Phys.ODBCDef, FireDAC.Phys.MongoDBDef,
  FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
  FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB,
  FireDAC.Phys.ODBC, FireDAC.Phys.ASA, FireDAC.Phys.TData, FireDAC.Phys.Infx,
  FireDAC.Phys.DB2, FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase,
  FireDAC.Phys.FB, FireDAC.Phys.ADS, FireDAC.Stan.StorageXML,
  FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin, FireDAC.Moni.RemoteClient,
  FireDAC.Moni.FlatFile, FireDAC.Moni.Base, FireDAC.Moni.Custom;

type
  TForm_Account = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Edit_Name: TEdit;
    Panel3: TPanel;
    Label3: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Panel5: TPanel;
    Label5: TLabel;
    Edit_Remark: TEdit;
    Panel6: TPanel;
    Button_OK: TButton;
    Button_Cancel: TButton;
    Memo_String: TMemo;
    Button_Test: TButton;
    FDConnection1: TFDConnection;
    FDMoniCustomClientLink1: TFDMoniCustomClientLink;
    FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink;
    FDMoniRemoteClientLink1: TFDMoniRemoteClientLink;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDPhysASADriverLink1: TFDPhysASADriverLink;
    FDPhysDB2DriverLink1: TFDPhysDB2DriverLink;
    FDPhysDSDriverLink1: TFDPhysDSDriverLink;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDPhysInfxDriverLink1: TFDPhysInfxDriverLink;
    FDPhysMongoDriverLink1: TFDPhysMongoDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDPhysTDataDriverLink1: TFDPhysTDataDriverLink;
    FDPhysTDBXDriverLink1: TFDPhysTDBXDriverLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageXMLLink1: TFDStanStorageXMLLink;
    Memo_Params: TMemo;
    Panel1: TPanel;
    Label1: TLabel;
    CheckBox_Secret: TCheckBox;
    Label6: TLabel;
    Panel7: TPanel;
    Label7: TLabel;
    CheckBox_Disable: TCheckBox;
    procedure Button_TestClick(Sender: TObject);
    procedure Button_CancelClick(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Account: TForm_Account;

implementation

{$R *.dfm}


procedure TForm_Account.Button_CancelClick(Sender: TObject);
begin
    Close;
end;

procedure TForm_Account.Button_OKClick(Sender: TObject);
var
    joDataBase  : Variant;
    joParams    : Variant;
    iParams     : Integer;
begin
    if Trim(Edit_Name.Text) = '' then begin
        ShowMessage('账套名称不能为空！');
        Exit;
    end;
    if Trim(Memo_String.Text) = '' then begin
        ShowMessage('账套连接字符串不能为空！');
        Exit;
    end;

    case Tag of
        0 : begin   //新增账套
            //保存当前账套信息
            joDataBase          := _json('{}');
            //连接名称
            joDataBase.name     := Trim(Edit_Name.Text);
            //是否加密和连接字符串
            if CheckBox_Secret.Checked then begin
                joDataBase.secret   := 1;
                joDataBase.string   := dwAESEncrypt(Trim(Memo_String.Text),'DeWeb@87114');
            end else begin
                joDataBase.secret   := 0;
                joDataBase.string   := Trim(Memo_String.Text);
            end;
            //是否停用
            if CheckBox_Disable.Checked then begin
                joDataBase.enabled  := 0;
            end else begin
                joDataBase.enabled  := 1;
            end;
            //备注
            joDataBase.remark   := Trim(Edit_Remark.Text);
            //参数
            joDataBase.params   := _json('[]');
            for iParams := 0 to Memo_Params.Lines.Count - 1 do begin
                joDataBase.params.Add(Memo_Params.Lines[iParams]);
            end;

            //保存到配置文件
            gjoConfig.database.Add(joDataBase);

            //保存JSON到文件
            dwSaveTOJson(gjoConfig,gsMainDir+'config.json',False);
        end;
    else    //编辑账套信息，tag为当前账套序号+1
        //保存当前账套信息
        joDataBase          := gjoConfig.database._(Tag-1);
        joDataBase.name     := Trim(Edit_Name.Text);
        if CheckBox_Secret.Checked then begin
            joDataBase.secret   := 1;
            joDataBase.string   := dwAESEncrypt(Trim(Memo_String.Text),'DeWeb@87114');
        end else begin
            joDataBase.secret   := 0;
            joDataBase.string   := Trim(Memo_String.Text);
        end;
        //是否停用
        if CheckBox_Disable.Checked then begin
            joDataBase.enabled  := 0;
        end else begin
            joDataBase.enabled  := 1;
        end;
        joDataBase.remark   := Trim(Edit_Remark.Text);
        joDataBase.params   := _json('[]');
        for iParams := 0 to Memo_Params.Lines.Count - 1 do begin
            joDataBase.params.Add(Memo_Params.Lines[iParams]);
        end;

        //保存JSON到文件
        dwSaveTOJson(gjoConfig,gsMainDir+'config.json',False);
    end;
end;

procedure TForm_Account.Button_TestClick(Sender: TObject);
var
    FDConnEditor    : TfrmFDGUIxFormsConnEdit;
begin
    FDConnEditor := TfrmFDGUIxFormsConnEdit.Create(Self);
    try
        if FDConnEditor.Execute(FDConnection1,'账套连接编辑',nil) then begin
            Memo_String.Text    := FDConnection1.ConnectionString;
        end;
    finally
        FDConnEditor.Free;
    end;

    //FDConnection1.ConnectionString  := Memo_String.Text;
    //if TfrmFDGUIxFormsConnEdit.Execute(FDConnection1, '账套连接编辑') then begin
    //    Memo_String.Text    := FDConnection1.ConnectionString;
    //end;

end;

end.
