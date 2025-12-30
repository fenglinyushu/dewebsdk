unit unit_wechatqr;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TForm_wechatqr = class(TForm)
    B1: TButton;
    L2: TLabel;
    M1: TMemo;
    P0: TPanel;
    L0: TLabel;
    B0: TButton;
    procedure B1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure B0Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
     Form_wechatqr             : TForm_wechatqr;


implementation


{$R *.dfm}
uses
    Unit1;

procedure TForm_wechatqr.B0Click(Sender: TObject);
begin
    //通过浏览器发送一个返回消息（需要前面显示该模块/界面时使用dwHistoryPush）
    dwhistoryBack(TForm1(self.Owner));
end;

procedure TForm_wechatqr.B1Click(Sender: TObject);
begin
    dwOpenUrl(Self,'https://www.delphibbs.com/scan?redirect_uri=https://www.delphibbs.com/qrtest','_self')
end;

procedure TForm_wechatqr.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetMobileMode(Self,400,900);
end;

procedure TForm_wechatqr.FormShow(Sender: TObject);
var
    sParams : string;
begin
    //
    sParams := dwGetProp(Self,'params');
    //
    if sParams ='' then begin
        M1.Lines.Text   := '.........';
    end else begin
        M1.Lines.Text   := sParams;
    end;
end;

end.
