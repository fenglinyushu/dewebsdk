unit unit1;

interface

uses
    dwBase,
    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
    P0: TPanel;
    L0: TLabel;
    B0: TButton;
    B1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure B0Click(Sender: TObject);
  private
  public
 end;

var
    Form1   : TForm1;


implementation


{$R *.dfm}

procedure TForm1.B0Click(Sender: TObject);
begin
    dwRunJS('window.history.go(-1);',self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    dwSetMobileMode(Self,360,740);
    //
    Label2.Caption  := '网址参数为：' + dwGetProp(Self,'params');
    //
    Label3.Caption  := 'cookie中mytest值：' + dwGetCookie(Self,'mytest');
end;

end.
