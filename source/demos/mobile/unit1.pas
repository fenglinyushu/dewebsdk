unit unit1;

interface

uses
     //
     dwBase,
     CloneComponents,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_Header: TPanel;
    Label_Header: TLabel;
    Panel_Footer: TPanel;
    Panel_FooterTopLine: TPanel;
    Button_Return: TButton;
    Button_Menu: TButton;
    ScrollBox_Content: TScrollBox;
    Panel_Content: TPanel;
    Image_bottom0: TImage;
    Image_bottom1: TImage;
    Image_bottom2: TImage;
    Image_bottom3: TImage;
    Image_bottom4: TImage;
    Panel1: TPanel;
    Panel_dm2: TPanel;
    Image_DM2: TImage;
    Panel_dm2c: TPanel;
    Image2: TImage;
    StaticText6: TStaticText;
    StaticText5: TStaticText;
    Panel2: TPanel;
    Label1: TLabel;
    StaticText_DM2_Price: TStaticText;
    StaticText_DM2_Heart: TStaticText;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Panel_dm2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
var
     I,J       : Integer;
     oPanel    : TPanel;
begin
     //
     for I := 0 to 19 do begin

          //<添加礼物页
          oPanel    := TPanel(CloneComponent(Panel_DM2));
          //
          oPanel.Top     := 9999;
          oPanel.Visible := True;
          //
          TImage(FindComponent('Image_dm2'+IntToStr(I+1))).Hint   := '{"radius":"10px","src":"/media/images/app0/20'+IntToStr(I mod 3)+'.jpg"}';
          TStaticText(FindComponent('StaticText_DM2_Price'+IntToStr(I+1))).Caption   := '¥'+Format('%.1f',[20+Random(5000)/10]);
          TStaticText(FindComponent('StaticText_DM2_Heart'+IntToStr(I+1))).Caption   := Format('%d',[20+Random(500)]);
          //>



     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     //
     Width     := Min(480,X);

     //得到移动端实际可用高度
     Height    := dwGetMobileAvailHeight(Self);

     //
     Panel_Footer.Top    := Height - Panel_Footer.Height;
     Panel_Footer.Left   := 0;
     Panel_Footer.Width  := Width;

     //
     ScrollBox_Content.Height := Panel_Footer.Top - ScrollBox_Content.Top;
end;

procedure TForm1.Panel_dm2Click(Sender: TObject);
begin
     dwShowMessage('OnClick',self);
end;

end.
