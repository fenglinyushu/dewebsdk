unit unit_CheckIn;

interface

uses
  dwBase,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP;
type
    TForm_CheckIn = class(TForm)
    Panel2: TPanel;
    Label2: TLabel;
    Button2: TButton;
    Panel3: TPanel;
    Button3: TButton;
    Label3: TLabel;
    Panel4: TPanel;
    Label4: TLabel;
    Button4: TButton;
    Panel5: TPanel;
    Label5: TLabel;
    Button5: TButton;
    Panel6: TPanel;
    Label6: TLabel;
    Button6: TButton;
    FlowPanel1: TFlowPanel;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    PTitle: TPanel;
    LTitle: TLabel;
    B0: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
  public
  end;

var
  Form_CheckIn: TForm_CheckIn;
implementation

{$R *.dfm}


procedure TForm_CheckIn.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetMobileMode(Self,400,900);
end;

end.
