unit Unit3;

interface

uses
    //
    dwBase,

    //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB,
  Data.Win.ADODB, Vcl.DBGrids, Vcl.Buttons, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCDef,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, FireDAC.Phys.ODBC, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Vcl.ComCtrls,
  Vcl.MPlayer;

type
  TForm3 = class(TForm)
    Label1: TLabel;
    Button3: TButton;
    Timer3: TTimer;
    procedure Timer3Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm3.Button3Click(Sender: TObject);
begin
    Timer3.DesignInfo   := 1 - Timer3.DesignInfo;

end;

procedure TForm3.Timer3Timer(Sender: TObject);
begin
    Label1.Caption := 'Form3 - '+IntToStr(Timer3.DesignInfo)+' - '+FormatDateTime('mm:ss zzz',Now);
end;

end.
