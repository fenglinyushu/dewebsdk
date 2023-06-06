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
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label_Captcha: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
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
    Timer1.DesignInfo   := 1;
    Exit;

    if Timer1.DesignInfo = 1 then begin
        Button1.Caption     := 'Start';
        Timer1.DesignInfo   := 0;
    end else begin
        Timer1.DesignInfo   := 1;
        Button1.Caption     := 'Pause';
    end;
end;


procedure TForm1.Button3Click(Sender: TObject);
begin
    Timer1.DesignInfo   := 0;
    Label1.Caption      := 'pause';
    Exit;

end;
procedure TForm1.Button4Click(Sender: TObject);
begin
    Timer1.Interval := 200;
    DockSite    := True;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    Timer1.Enabled  := False;
    Timer1.DesignInfo   := 0;
    //
    Self.DockSite := True;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     Label1.Caption := FormatDateTime('YYYY-MM-DD hh:mm:ss',Now);
end;

end.
