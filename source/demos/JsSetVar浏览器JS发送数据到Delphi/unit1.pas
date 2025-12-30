unit unit1;

interface

uses
  dwBase,
  CloneComponents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.WinXPanels;
type
    TForm1 = class(TForm)
    Label1: TLabel;
    Panel1: TPanel;
    Label2: TLabel;
    Im: TImage;
    procedure FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
  private
  public
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}


procedure TForm1.FormContextPopup(Sender: TObject; MousePos: TPoint; var Handled: Boolean);
begin
    dwMessage('onvar','success',self);
    //
    caption := dwGetProp(Self,'__var');
end;

end.
