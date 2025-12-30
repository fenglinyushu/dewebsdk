unit unit_InQuery;

interface

uses
     dwBase,
     dwCrudPanel,
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
  TForm_InQuery = class(TForm)
    PnM: TPanel;
    PnS: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
    Form_InQuery  : TForm_InQuery;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_InQuery.FormShow(Sender: TObject);
begin
    cpInit(PnM,TForm1(self.Owner).FDConnection1,False,'');
    cpSetOneLine(PnM);
    //
    cpInit(PnS,TForm1(self.Owner).FDConnection1,False,'');
    cpSetOneLine(PnS);
    //
    TEdit(FindComponent('_sEKw')).Width := 180;
end;

end.
