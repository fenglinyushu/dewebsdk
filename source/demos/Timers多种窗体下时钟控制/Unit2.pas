unit Unit2;

interface

uses
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB, Vcl.DBGrids;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Timer2: TTimer;
    Button2: TButton;
    procedure Timer2Timer(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses
    Unit1,Unit3,Unit4;

procedure TForm2.Button2Click(Sender: TObject);
begin
    Timer2.DesignInfo   := 1 - Timer2.DesignInfo;

end;

procedure TForm2.Timer2Timer(Sender: TObject);
begin
    Label1.Caption := 'Form2 - '+IntToStr(Timer2.DesignInfo)+' - '+FormatDateTime('mm:ss zzz',Now);
end;

end.
