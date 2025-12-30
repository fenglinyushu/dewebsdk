unit unit_oth_db;

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
  TForm_oth_db = class(TForm)
    Label2: TLabel;
    Edit1: TEdit;
    Panel4: TPanel;
    B_Prev: TButton;
    B_Next: TButton;
    FDQuery1: TFDQuery;
    procedure B_PrevClick(Sender: TObject);
    procedure B_NextClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form_oth_db             : TForm_oth_db;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_oth_db.B_NextClick(Sender: TObject);
begin
    FDQuery1.Next;
    Edit1.Text  := FDQuery1.FieldByName('uName').AsString;
end;

procedure TForm_oth_db.B_PrevClick(Sender: TObject);
begin
    FDQuery1.Prior;
    Edit1.Text  := FDQuery1.FieldByName('uName').AsString;
end;

procedure TForm_oth_db.FormShow(Sender: TObject);
begin
    //
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;
    //
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM sys_User';
    FDQuery1.Open;
    Edit1.Text  := FDQuery1.FieldByName('uName').AsString;
end;

end.
