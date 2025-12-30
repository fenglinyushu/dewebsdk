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
    BtVisible: TButton;
    dt1: TDateTimePicker;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtLTWHClick(Sender: TObject);
    procedure BtVisibleClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.BtLTWHClick(Sender: TObject);
begin
    DT1.DateTime    := Now;
end;

procedure TForm1.BtVisibleClick(Sender: TObject);
begin
    dwMessage(FormatDateTime('YYYY-MM-DD hh:mm:ss',Dt1.DateTime),'success',self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

end.
