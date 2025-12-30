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
    Panel4: TPanel;
    Splitter2: TSplitter;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Splitter3: TSplitter;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Splitter4: TSplitter;
    Panel11: TPanel;
    Panel12: TPanel;
    Panel1: TPanel;
    Splitter1: TSplitter;
    Panel2: TPanel;
    Panel3: TPanel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

end.
