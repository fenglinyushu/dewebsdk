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
    Panel1: TPanel;
    Label1: TLabel;
    Pn1: TPanel;
    Label2: TLabel;
    Pn2: TPanel;
    BtLTWH: TButton;
    BtFont: TButton;
    BtVisible: TButton;
    BtColor: TButton;
    BtRadius: TButton;
    BtdwStyle: TButton;
    procedure BtLTWHClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtVisibleClick(Sender: TObject);
    procedure BtFontClick(Sender: TObject);
    procedure BtColorClick(Sender: TObject);
    procedure BtRadiusClick(Sender: TObject);
    procedure BtdwStyleClick(Sender: TObject);
    procedure Pn2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.BtColorClick(Sender: TObject);
begin
    Panel1.Color    := random($FFFFFF);
end;

procedure TForm1.BtdwStyleClick(Sender: TObject);
begin
    dwSetProp(Panel1,'dwstyle','background-color: '+dwColorAlpha(random($FFFFFF))+';');
end;

procedure TForm1.BtFontClick(Sender: TObject);
begin
    Panel1.Font.Size    := 10 + random(20);
    Panel1.Font.Color   := random($FFFFFF);
end;

procedure TForm1.BtLTWHClick(Sender: TObject);
begin
    Panel1.Left     := 100+ random(100);
    Panel1.Top      := 100+ random(100);
    Panel1.Width    := 200+ random(100);
    Panel1.Height   := 100+ random(100);

end;

procedure TForm1.BtRadiusClick(Sender: TObject);
begin
    Panel1.Hint := '{"radius":"'+IntToStr(random(20))+'px"}';

end;

procedure TForm1.BtVisibleClick(Sender: TObject);
begin
    Panel1.Visible  := not Panel1.Visible;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
    Panel1.Color    := clBlue;
end;

procedure TForm1.Pn2Click(Sender: TObject);
begin
    Panel1.Color    := clRed;
end;

end.
