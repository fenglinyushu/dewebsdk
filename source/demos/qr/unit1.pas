unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
  Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Shape1: TShape;
    procedure Button1Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
     //
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     //Label1.Caption := 'Started!';
     //dwSetZXing(Shape1,0);
end;

end.
