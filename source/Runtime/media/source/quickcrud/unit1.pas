unit unit1;

interface

uses
    //
    dwBase,
    dwQuickCrud,

    //
    SynCommons,


    //
    Math,Variants,
    Graphics,strutils,
    ComObj,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  Vcl.Imaging.pngimage, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle,
  FireDAC.Phys.SQLite, FireDAC.Phys.MySQL;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    //QuickCrud 必须的变量
    qcConfig : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //取得QuickCrud的配置，赋给qcConfig变量
    qcConfig    := StyleName;

    //自动创建CRUD模块
    dwCrud(self,FDConnection1,False,'');
end;

end.
