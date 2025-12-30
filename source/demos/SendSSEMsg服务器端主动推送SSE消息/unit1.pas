unit unit1;

interface

uses
  dwBase,
  System.Rtti,
  CloneComponents,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
  Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
  Vcl.WinXPanels, Vcl.Menus;
type
    TForm1 = class(TForm)
    Edit1: TEdit;
    Button1: TButton;
    P0: TPanel;
    L0: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);
begin
    //主动推送SSE消息
    dwSendSSEMsg(Self,Edit1.Text);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //OnMouseUp为浏览器屏幕变化事件

    //设置为移动端模式，如果不是移动端，则设置分辨率为400x900
    dwSetMobileMode(Self,400,900);
end;

end.
