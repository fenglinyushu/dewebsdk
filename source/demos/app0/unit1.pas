unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_00_Title: TPanel;
    Image_logo: TImage;
    Panel_Footer: TPanel;
    Label4: TLabel;
    Image_Camera: TImage;
    Edit_Search: TEdit;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Image1: TImage;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Panel1: TPanel;
    Image2: TImage;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    Panel2: TPanel;
    Image3: TImage;
    StaticText5: TStaticText;
    StaticText6: TStaticText;
    Panel3: TPanel;
    Image4: TImage;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    Panel4: TPanel;
    Image5: TImage;
    StaticText9: TStaticText;
    StaticText10: TStaticText;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     iTrueH    : Integer;
     iInnerH   : Integer;
     iTrueW    : Integer;
     iInnerW   : Integer;
begin
     //
     Width     := Min(480,X);

     //
     iTrueW    := StrToIntDef(dwGetProp(Self,'truewidth'),X);
     iTrueH    := StrToIntDef(dwGetProp(Self,'trueheight'),Y);
     iInnerW   := StrToIntDef(dwGetProp(Self,'innerwidth'),X);
     iInnerH   := StrToIntDef(dwGetProp(Self,'innerheight'),Y);

     //得到实现可用高度
     Height    := Ceil(iInnerH*Y/iTrueH*iTrueW/iInnerW);


     //
     Panel_Footer.Top    := Height - Panel_Footer.Height;
     Panel_Footer.Left   := 0;
     Panel_Footer.Width  := Width;
end;

end.
