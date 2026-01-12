unit unit1;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    CloneComponents,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
    Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL;

type
  TForm1 = class(TForm)
    LaTitle: TLabel;
    EtValue: TEdit;
    FDQuery1: TFDQuery;
    Panel4: TPanel;
    BtPrev: TButton;
    BtNext: TButton;
    Label1: TLabel;
    FDConnection1: TFDConnection;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure FormShow(Sender: TObject);
    procedure BtPrevClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
  private
  public
  end;

var
    Form1 : TForm1;

implementation


{$R *.dfm}

procedure TForm1.BtNextClick(Sender: TObject);
begin
    //get the next value
    FDQuery1.Next;
    EtValue.Text        := FDQuery1.FieldByName('uname').AsString;
end;

procedure TForm1.BtPrevClick(Sender: TObject);
begin
    //get the prior value
    FDQuery1.Prior;
    EtValue.Text        := FDQuery1.FieldByName('uname').AsString;
end;

procedure TForm1.FormShow(Sender: TObject);
begin

    //get table field value
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM sys_user';
    FDQuery1.Open;
    EtValue.Text        := FDQuery1.FieldByName('uname').AsString;

end;

end.
