unit unit1;

interface

uses
     //
     dwBase,
     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    Button1: TButton;
    Label1: TLabel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Label2: TLabel;
    procedure ScrollBox1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     iTrueH    : Integer;
     iInnerH   : Integer;
     iTrueW    : Integer;
     iInnerW   : Integer;
begin
     //
     Width     := Min(480,X);

     //
     iTrueW    := StrToIntDef(dwGetProp(Self,'truewidth'),X);
     iTrueH    := StrToIntDef(dwGetProp(Self,'trueheight'),Y);
     iInnerW   := StrToIntDef(dwGetProp(Self,'innerwidth'),X);
     iInnerH   := StrToIntDef(dwGetProp(Self,'innerheight'),Y);

     //
     Height    := Ceil(iInnerH*Y/iTrueH*iTrueW/iInnerW);

end;

procedure TForm1.ScrollBox1EndDock(Sender, Target: TObject; X, Y: Integer);
var
     iPos      : Integer;
     iMod      : Integer;
     iRound    : Integer;
begin
     Label1.Caption := Format('X:%d,Y:%d',[X,Y]);
     Panel1.Height  := 1000 + X;
     //
     iPos      := Panel1.Height;
     iMod      := Floor(X / 1000)*1000;
     iRound    := Round(X / 1000)*1000;
     //
     Button1.Top    := iRound + 10;
     Button2.Top    := iRound + 260;
     Button3.Top    := iMod + 510;
     Button4.Top    := iMod + 760;

     //
     if (X Mod 1000) >500 then begin
          //Button1.Top    := Button1.Top + 1000;
          //Button2.Top    := Button2.Top + 1000;
     end;

end;

end.
