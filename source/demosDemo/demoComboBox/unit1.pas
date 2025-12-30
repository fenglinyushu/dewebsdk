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
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    Edit1: TEdit;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtLTWHClick(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.BtLTWHClick(Sender: TObject);
var
    iItem       : Integer;
    sItem       : String;
begin
    sItem   := '';
    for iItem := 1 to strToint(Edit1.Text) do begin
        sItem   := sItem + IntToStr(iItem mod 10);
    end;
    ComboBox1.Items.Add(sItem);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

end.
