unit unit1;

interface

uses
    //
    dwBase,
    dwAccess,

    //
    SynCommons,


    //
    Math,Variants,
    Graphics,strutils,
    ComObj,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Data.Win.ADODB, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCDef,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.ODBC, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL;

type
  TForm1 = class(TForm)
    ListView1: TListView;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure FormShow(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    if (X>600)and(Y>600) then begin
        dwSetPCMode(self);
    end else begin
        dwSetMobileMode(self,360,740);
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM dw_Member WHERE (1=1) ORDER BY ID';
    FDQuery1.Open;
end;


end.
