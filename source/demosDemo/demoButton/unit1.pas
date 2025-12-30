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
    BtEnabled: TButton;
    BtRadius: TButton;
    BtdwStyle: TButton;
    BtText: TButton;
    Button1: TButton;
    BtType: TButton;
    BtStyle: TButton;
    BtIcon: TButton;
    BtRIcon: TButton;
    procedure BtLTWHClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtVisibleClick(Sender: TObject);
    procedure BtFontClick(Sender: TObject);
    procedure BtRadiusClick(Sender: TObject);
    procedure BtdwStyleClick(Sender: TObject);
    procedure BtTextClick(Sender: TObject);
    procedure BtEnabledClick(Sender: TObject);
    procedure BtTypeClick(Sender: TObject);
    procedure BtStyleClick(Sender: TObject);
    procedure BtIconClick(Sender: TObject);
    procedure BtRIconClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.BtdwStyleClick(Sender: TObject);
begin
    dwSetProp(Button1,'dwstyle','background-color: '+dwColorAlpha(random($FFFFFF))+';');
end;

procedure TForm1.BtEnabledClick(Sender: TObject);
begin
    Button1.Enabled := not Button1.Enabled;
end;

procedure TForm1.BtFontClick(Sender: TObject);
begin
    Button1.Font.Size    := 10 + random(20);
    Button1.Font.Color   := random($FFFFFF);
end;

procedure TForm1.BtIconClick(Sender: TObject);
begin
    if Button1.Hint = '{"icon":"el-icon-edit"}' then begin
        Button1.Hint    := '{"icon":"el-icon-delete"}';
    end else begin
        Button1.Hint    := '{"icon":"el-icon-edit"}';
    end;
end;

procedure TForm1.BtLTWHClick(Sender: TObject);
begin
    Button1.Left     := 100+ random(100);
    Button1.Top      := 100+ random(100);
    Button1.Width    := 200+ random(100);
    Button1.Height   := 200+ random(100);
end;

procedure TForm1.BtRadiusClick(Sender: TObject);
begin
    Button1.Hint := '{"radius":"'+IntToStr(random(20))+'px"}';

end;

procedure TForm1.BtRIconClick(Sender: TObject);
begin
    if Button1.Hint = '{"righticon":"el-icon-edit"}' then begin
        Button1.Hint    := '{"righticon":"el-icon-delete"}';
    end else begin
        Button1.Hint    := '{"righticon":"el-icon-edit"}';
    end;

end;

procedure TForm1.BtStyleClick(Sender: TObject);
begin
    if Button1.Hint = '{"style":"plain"}' then begin
        Button1.Hint    := '{"style":"circle"}';
    end else begin
        Button1.Hint    := '{"style":"plain"}';
    end;

end;

procedure TForm1.BtTextClick(Sender: TObject);
begin
    Button1.Caption  := 'บบ-<br>'+IntToStr(GetTickCount);
end;

procedure TForm1.BtTypeClick(Sender: TObject);
begin
    if Button1.Hint = '{"type":"danger"}' then begin
        Button1.Hint    := '{"type":"primary"}';
    end else begin
        Button1.Hint    := '{"type":"danger"}';
    end;
end;

procedure TForm1.BtVisibleClick(Sender: TObject);
begin
    Button1.Visible  := not Button1.Visible;
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    Docksite    := True;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;


end.
