unit unit_dbhello;

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
  FireDAC.Comp.Client, Vcl.DBCtrls;

type
  TForm_dbhello = class(TForm)
    Label2: TLabel;
    Edit1: TEdit;
    Panel4: TPanel;
    B_Prev: TButton;
    B_Next: TButton;
    FDQuery1: TFDQuery;
    DBText1: TDBText;
    DataSource1: TDataSource;
    PTitle: TPanel;
    LTitle: TLabel;
    B0: TButton;
    procedure B_PrevClick(Sender: TObject);
    procedure B_NextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form_dbhello             : TForm_dbhello;


implementation


{$R *.dfm}

uses
    Unit1;

procedure TForm_dbhello.B_NextClick(Sender: TObject);
begin
    FDQuery1.Next;
    Edit1.Text  := FDQuery1.FieldByName('mName').AsString;
end;

procedure TForm_dbhello.B_PrevClick(Sender: TObject);
begin
    FDQuery1.Prior;
    Edit1.Text  := FDQuery1.FieldByName('mName').AsString;
end;

procedure TForm_dbhello.FormCreate(Sender: TObject);
begin
    //
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;

end;

procedure TForm_dbhello.FormShow(Sender: TObject);
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM dmMember';
    FDQuery1.Open;
    Edit1.Text  := FDQuery1.FieldByName('mName').AsString;
end;

end.
