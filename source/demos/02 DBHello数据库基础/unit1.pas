unit unit1;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Edit1: TEdit;
    Panel4: TPanel;
    B_Prev: TButton;
    B_Next: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure B_PrevClick(Sender: TObject);
    procedure B_NextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.B_NextClick(Sender: TObject);
begin
    FDQuery1.Next;
    Edit1.Text  := FDQuery1.FieldByName('AName').AsString;
end;

procedure TForm1.B_PrevClick(Sender: TObject);
begin
    FDQuery1.Prior;
    Edit1.Text  := FDQuery1.FieldByName('AName').AsString;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetMobileMode(self,360,740);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM dw_Member';
    FDQuery1.Open;
    Edit1.Text  := FDQuery1.FieldByName('AName').AsString;
end;

end.
