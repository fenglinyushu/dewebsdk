unit unit1;

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
  TForm1 = class(TForm)
    Button_Start: TButton;
    Shape1: TShape;
    Button_Stop: TButton;
    Memo1: TMemo;
    procedure Button_StartClick(Sender: TObject);
    procedure Shape1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_StopClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button_StartClick(Sender: TObject);
begin
    Memo1.Text  := 'Started!';
    dwSetZXing(Shape1,0);
end;

procedure TForm1.Button_StopClick(Sender: TObject);
begin
    //
    dwStopZXing(Shape1,0);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
    dwBase.dwSetMobileMode(self,414,736);
end;

procedure TForm1.Shape1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    Memo1.Text  := dwISO8859ToChinese(dwUnEscape(Shape1.HelpKeyword));
    Shape1.HelpKeyword  := '';  //需要加上这一句
end;

end.
