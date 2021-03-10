unit unit1;

interface

uses
     //
     dwBase,

     //克隆控件单元
     CloneComponents,

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
    Panel_99_Footer: TPanel;
    Label4: TLabel;
    Image_Camera: TImage;
    Edit_Search: TEdit;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    Panel_02_Pages: TPanel;
    Panel_01_Category: TPanel;
    Label_Cate5: TLabel;
    Label_Cate4: TLabel;
    Label_Cate3: TLabel;
    Label_Cate2: TLabel;
    Label_Cate1: TLabel;
    Label_Cate0: TLabel;
    ScrollBox1: TScrollBox;
    Panel_Scroll1: TPanel;
    Panel_Demo: TPanel;
    Image_Demo: TImage;
    StaticText3: TStaticText;
    StaticText4: TStaticText;
    StaticText1: TStaticText;
    StaticText2: TStaticText;
    Image1: TImage;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label_Cate0Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
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
          oPanel    := TPanel(CloneComponent(Panel_Demo));
          //
          oPanel.Visible := True;
          if I mod 2 = 0 then begin
               oPanel.Left    := 15;
               oPanel.Top     := 190 + (I div 2) * 170;
          end else begin
               oPanel.Left    := Width - 154-15;
               oPanel.Top     := 190 + (I div 2) * 170;
               oPanel.Anchors := [akTop,akRight];
          end;
          //
          TImage(FindComponent('Image_Demo'+IntToStr(I+1))).Hint   := '{"radius":"10px","src":"/media/images/app0/'+IntToStr(I mod 6)+'.jpg"}';
     end;
     //
     Panel_Scroll1.Height     := 10 * 170 + 220;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     iTrueH    : Integer;
     iInnerH   : Integer;
     iTrueW    : Integer;
     iInnerW   : Integer;
     //
     iCate     : Integer;
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
     Panel_99_Footer.Top    := Height - Panel_99_Footer.Height;
     Panel_99_Footer.Left   := 0;
     Panel_99_Footer.Width  := Width;

     //
     Panel_02_Pages.Height    := Panel_99_Footer.Top - Panel_02_Pages.Top;
     //
     for iCate := 0 to 5 do begin
          TLabel(FindComponent('Label_Cate'+IntToStr(iCate))).Width   := Floor(X/6)-8;
     end;
end;

procedure TForm1.Label_Cate0Click(Sender: TObject);
var
     iCate     : Integer;
begin
     //
     for iCate := 0 to 5 do begin
          TLabel(FindComponent('Label_Cate'+IntToStr(iCate))).Font.Color := $00C8C8C8;
     end;
     //
     TLabel(Sender).Font.Color     := clBlack;
     //
     PageControl.ActivePageIndex   := TLabel(Sender).Tag;
end;

end.
