unit unit1;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Panel1: TPanel;
    Label2: TLabel;
    Im: TImage;
    Memo1: TMemo;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    gsParams    : String;
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    sData   : string;
begin
    sData   := String(dwGetMethod('https://www.delphibbs.com/middle.dll?json=1',0));
    Memo1.Text  := sData;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置模式
    dwSetPCMode(Self);
end;

end.
