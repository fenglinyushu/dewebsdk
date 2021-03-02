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
    ProgressBar1: TProgressBar;
    ProgressBar2: TProgressBar;
    ProgressBar3: TProgressBar;
    ProgressBar4: TProgressBar;
    ProgressBar5: TProgressBar;
    Timer1: TTimer;
    Button1: TButton;
    Button2: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
     if Timer1.DesignInfo = 1 then begin
          Timer1.DesignInfo   := 0;
     end else begin
          Timer1.DesignInfo   := 1;
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     ProgressBar1.Position    := 1;
     ProgressBar2.Position    := 1;
     ProgressBar3.Position    := 1;
     ProgressBar4.Position    := 1;
     ProgressBar5.Position    := 1;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
     ProgressBar1.Position    := ProgressBar1.Position + 1;
     ProgressBar2.Position    := ProgressBar2.Position + 1;
     ProgressBar3.Position    := ProgressBar3.Position + 1;
     ProgressBar4.Position    := ProgressBar4.Position + 1;
     ProgressBar5.Position    := ProgressBar5.Position + 1;
end;

end.
