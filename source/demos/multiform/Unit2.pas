unit Unit2;

interface

uses
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB, Vcl.DBGrids;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    Button3: TButton;
    Button1: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses
    Unit1,Unit3;

procedure TForm2.Button1Click(Sender: TObject);
begin
    Timer1.DesignInfo   := 0;

end;

procedure TForm2.Button3Click(Sender: TObject);
begin
    Timer1.DesignInfo   := 1;

end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
    Label1.Caption  := FormatDateTime('MM-DD hh:mm:ss zzz',Now);
    Timer1.DesignInfo   := 0;
end;

end.
