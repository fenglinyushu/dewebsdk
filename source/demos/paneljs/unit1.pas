unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls, Vcl.Grids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, Datasnap.Provider,
  Data.Win.ADODB;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel4: TPanel;
    Button1: TButton;
    procedure Panel3Enter(Sender: TObject);
    procedure Panel3Exit(Sender: TObject);
    procedure Panel2Enter(Sender: TObject);
    procedure Panel2Exit(Sender: TObject);
    procedure Panel4Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  goConnection:TFDConnection;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
     Panel2.Color   := Random($CCCCCC);

end;

procedure TForm1.Panel2Enter(Sender: TObject);
begin
     Panel2.Color   := $CCCCCC;
end;

procedure TForm1.Panel2Exit(Sender: TObject);
begin
     Panel2.Color   := $eeeeee;

end;

procedure TForm1.Panel3Enter(Sender: TObject);
begin
     //
     Label4.Caption := 'Enter '+IntToStr(GetTickCount);

end;

procedure TForm1.Panel3Exit(Sender: TObject);
begin
     //
     Label4.Caption := 'Exit '+IntToStr(GetTickCount);

end;

procedure TForm1.Panel4Click(Sender: TObject);
begin
     Panel4.Color   := Random($FFFFFF);
end;

end.
