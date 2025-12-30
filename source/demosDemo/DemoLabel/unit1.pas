unit unit1;

interface

uses
  dwBase,
  System.Rtti,
  CloneComponents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.WinXPanels, Vcl.Menus, Data.DB, Vcl.Mask;
type
    TForm1 = class(TForm)
    Pn1: TPanel;
    Label2: TLabel;
    Pn2: TPanel;
    BtLTWH: TButton;
    BtFont: TButton;
    BtVisible: TButton;
    BtColor: TButton;
    BtRadius: TButton;
    BtdwStyle: TButton;
    Label11: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label1: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    BtText: TButton;
    Label6: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    procedure BtLTWHClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtVisibleClick(Sender: TObject);
    procedure BtFontClick(Sender: TObject);
    procedure BtColorClick(Sender: TObject);
    procedure BtRadiusClick(Sender: TObject);
    procedure BtdwStyleClick(Sender: TObject);
    procedure Pn2Click(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
    procedure BtTextClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.BtColorClick(Sender: TObject);
begin
    Label1.Color    := random($FFFFFF);
end;

procedure TForm1.BtdwStyleClick(Sender: TObject);
begin
    dwSetProp(Label1,'dwstyle','background-color: '+dwColorAlpha(random($FFFFFF))+';');
end;

procedure TForm1.BtFontClick(Sender: TObject);
begin
    Label1.Font.Size    := 10 + random(20);
    Label1.Font.Color   := random($FFFFFF);
end;

procedure TForm1.BtLTWHClick(Sender: TObject);
begin
    Label1.Left     := 100+ random(100);
    Label1.Top      := 100+ random(100);
    Label1.Width    := 200+ random(100);
    Label1.Height   := 200+ random(100);

end;

procedure TForm1.BtRadiusClick(Sender: TObject);
begin
    Label1.Hint := '{"radius":"'+IntToStr(random(20))+'px"}';

end;

procedure TForm1.BtTextClick(Sender: TObject);
begin
    Label1.Caption  := 'บบ-'+IntToStr(GetTickCount);
end;

procedure TForm1.BtVisibleClick(Sender: TObject);
begin
    Label1.Visible  := not Label1.Visible;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.Label11Click(Sender: TObject);
begin
    Label1.Color    := clBlue;
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
    Label1.Color    := clLime;

end;

procedure TForm1.Pn2Click(Sender: TObject);
begin
    Label1.Color    := clRed;
end;

end.
