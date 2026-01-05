unit unit1;

interface

uses
    //
    dwBase,

    //
    dwDBCard,

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
    FireDAC.Phys.SQLite, FireDAC.Phys.MySQL, FireDAC.Phys.PGDef, FireDAC.Phys.PG;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    Panel1: TPanel;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    //dwLoad中的参数AParams, 保存有数据账套信息
    gsParams    : String;

    //
    gjoConfig   : Variant;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetMobileMode(Self,400,900);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //
    dcInit(Panel1,FDConnection1);
end;

end.
