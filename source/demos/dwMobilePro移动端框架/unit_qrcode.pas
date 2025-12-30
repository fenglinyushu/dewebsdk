unit unit_qrcode;

interface

uses
     //
     dwBase,

     //
     Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
    Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.pngimage;

type
  TForm_qrcode = class(TForm)
    Button_Start: TButton;
    Shape1: TShape;
    Button_Stop: TButton;
    Memo1: TMemo;
    P0: TPanel;
    L0: TLabel;
    B0: TButton;
    procedure Button_StartClick(Sender: TObject);
    procedure Shape1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_StopClick(Sender: TObject);
    procedure B0Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_qrcode: TForm_qrcode;

implementation

{$R *.dfm}

uses
    Unit1;

procedure TForm_qrcode.B0Click(Sender: TObject);
begin
    //通过浏览器发送一个返回消息（需要前面显示该模块/界面时使用dwHistoryPush）
    dwhistoryBack(TForm1(self.Owner));

end;

procedure TForm_qrcode.Button_StartClick(Sender: TObject);
begin
    Memo1.Text  := 'Started!';
    dwSetZXing(Shape1,0);
end;

procedure TForm_qrcode.Button_StopClick(Sender: TObject);
begin
    //
    dwStopZXing(Shape1,0);
end;

procedure TForm_qrcode.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
    dwBase.dwSetMobileMode(self,414,736);
end;

procedure TForm_qrcode.Shape1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    Memo1.Text  := dwISO8859ToChinese(dwUnEscape(Shape1.HelpKeyword));
    Shape1.HelpKeyword  := '';  //需要加上这一句
end;

end.
