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
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    ToggleSwitch2: TToggleSwitch;
    Label1: TLabel;
    procedure SBClick(Sender: TObject);
    procedure ToggleSwitch2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.SBClick(Sender: TObject);
var
     sMsg      : string;
begin
     sMsg      := IntToStr(GetTickCount);
     //
     dwShowMessage(sMsg + ' - '+TSpeedButton(Sender).Caption,self);
end;

procedure TForm1.ToggleSwitch2Click(Sender: TObject);
begin
     if ToggleSwitch2.State = tssON then begin
          Label1.Caption := 'ON';
     end else begin
          Label1.Caption := 'Off';
     end;
end;

end.
