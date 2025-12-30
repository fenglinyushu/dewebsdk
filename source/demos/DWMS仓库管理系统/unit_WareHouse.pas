unit unit_WareHouse;

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
  TForm_WareHouse = class(TForm)
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form_WareHouse             : TForm_WareHouse;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_WareHouse.FormShow(Sender: TObject);
begin
    cpInit(Panel1,TForm1(self.Owner).FDConnection1,False,'');
    //
    cpSetOneLine(Panel1);
    //Memo1.Lines.Text    := dpGetConfig(Panel1);
end;

end.
