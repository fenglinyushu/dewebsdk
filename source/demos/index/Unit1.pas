unit Unit1;

interface

uses
     //
     dwBase,

     //
     JsonDataObjects,
     CloneComponents,


     //
     Math,
     Windows, Messages, SysUtils, Variants, StdCtrls, Graphics, ExtCtrls,
     Controls, Forms, Dialogs, Classes, Menus, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  Vcl.ComCtrls ;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Panel_99_Foot: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel_03_Demos: TPanel;
    Panel_02_Main: TPanel;
    Panel_line3: TPanel;
    Panel_01_Menu: TPanel;
    Panel_Inner1: TPanel;
    Label_Download: TLabel;
    StaticText_FAQs: TStaticText;
    StaticText_Home: TStaticText;
    Label_ContactUs: TLabel;
    StaticText_ContactUs: TStaticText;
    Label_gitee: TLabel;
    StaticText_Gitee: TStaticText;
    Label_blog: TLabel;
    StaticText_Blog: TStaticText;
    Panel2: TPanel;
    Panel_Inner3: TPanel;
    Panel_Demo: TPanel;
    Image__Demo: TImage;
    StaticText6: TStaticText;
    PageControl_Carousel: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Panel_Inner2: TPanel;
    Label_WDWD: TLabel;
    Label_Introduce0: TLabel;
    Label_Introduce1: TLabel;
    Label_Introduce2: TLabel;
    Button_BuyNow: TButton;
    Button_Download: TButton;
    Image_Delphi: TImage;
    TabSheet3: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    StaticText1: TStaticText;
    Label2: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_DownloadClick(Sender: TObject);
    procedure Image__DemoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1     : TForm1;
     gjoDemos  : TJsonObject;
     gsMainDir : string;

implementation

{$R *.dfm}

procedure TForm1.Button_DownloadClick(Sender: TObject);
begin
     //dwOpenUrl(self,'/deweb.zip','_blank');
     dwOpenUrl(self,'https://gitee.com/xamh/dewebsdk','_blank');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     iDemo     : Integer;
     oPanel    : TPanel;
     sPicture  : String;
     joDemo    : TJsonObject;
begin
     //Get current dir
     gsMainDir := ExtractFilePath(Application.ExeName);

     //set top
     Top  := 0;

     //Get Demos information from json file
     gjoDemos  := TJsonObject.Create;
     gjoDemos.LoadFromFile('home.json');

     //create demos
     Panel_03_Demos.Height    := Ceil(gjoDemos.A['items'].Count / 5) * 140;
     Panel_Inner3.Height      := Panel_03_Demos.Height;
     for iDemo := 0 to gjoDemos.A['items'].Count-1 do begin
          //get demo jsonobject
          joDemo         := gjoDemos.A['items'].O[iDemo];
          //
          if not joDemo.Contains('picture') then begin
               joDemo.S['picture'] := joDemo.S['href'];
          end;
          if not joDemo.Contains('title') then begin
               joDemo.S['title'] := joDemo.S['href'];
          end;

          //clone the demo panel include image and href(TStaticText)
          oPanel         := TPanel(CloneComponent(Panel_Demo));
          oPanel.Visible := True;
          oPanel.Name    := 'Panel_Demo_'+IntToStr(iDemo);
          oPanel.Top     := (iDemo div 5) *140;
          oPanel.Left    := 50 + (iDemo mod 5)* 180;
          oPanel.Parent  := Panel_Inner3;

          //set image src
          with TImage(oPanel.Controls[0]) do begin
               //set image name
               Name      := 'Image_id_'+IntToStr(iDemo);
               //
               if FileExists(gsMainDir+'media\images\'+joDemo.S['picture']+'.png') then begin
                    Hint      := Format('{"src":"/media/images/%s.png"}',[joDemo.S['picture']]);
               end else begin
                    Hint      := '{"src":"/media/images/demo.png"}';
               end;
          end;

          //set caption / href TStaticText
          with TStaticText(oPanel.Controls[1]) do begin
               Caption   := joDemo.S['title'];
               //
               if Pos('://',joDemo.S['href'])>0 then begin
                    //如果是绝对URL，则直接赋值
                    Hint      := Format('{"href":"%s","target":"_blank"}',[joDemo.S['href']]);
               end else begin
                    //如果是简称，则补全
                    Hint      := Format('{"href":"/%s.dw","target":"_blank"}',[joDemo.S['href']]);
               end;
          end;
     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     iInnerW   : Integer;
     iRowCount : Integer;
     iDemo     : Integer;
     //
     oPanel    : TPanel;
begin
     //Shift：ssShift, ssAlt, ssCtrl,ssLeft, ssRight,
     //分别对应0:未知/1:PC/2:Android/3:iPhone/4:Tablet

     if  (ssShift in Shift) or (ssAlt in Shift) then begin
          Width     := X-30;
          iInnerW   := StrToIntDef(dwGetProp(Self,'innerwidth'),-1);
          //
          if iInnerW = -1 then begin
               Exit;
          end;

          //
          Width     := iInnerW;

     end else begin
          if Y>X then begin
               //
               Width     := X;

               //
               Panel_All.Width     := X;

               //
               Panel_Inner2.Width  := X;
               Panel_Inner2.Left   := 0;
               Panel_Inner3.Width  := X;
               Panel_Inner3.Left   := 0;

               //Label_FAQs.Visible            := False;
               //StaticText_FAQs.Visible       := False;
               Label_ContactUs.Visible       := False;
               StaticText_ContactUs.Visible  := False;

               //label : web develop with delphi
               Label_WDWD.Width              := X;
               Label_WDWD.Font.Size          := 18;
               Label_WDWD.Caption            := 'Web develop with Delphi';
               Label_WDWD.Left               := 0;

               //introduce labels
               Label_Introduce0.Left         := 8;
               Label_Introduce1.Left         := 8;
               Label_Introduce1.Caption      := '无需学习HTML/JavaScript/Java/PHP等新知识';
               Label_Introduce2.Left         := 8;

               //buttons
               Button_Download.Left          := 10;
               Button_Download.Width         := (X-30) div 2;
               Button_Download.Caption       := 'Download';
               Button_BuyNow.Left            := Button_Download.Left + 10 + Button_Download.Width;
               Button_BuyNow.Width           := Button_Download.Width;

               //demos
               iRowCount := X div 180;
               Panel_03_Demos.Height    := Ceil(gjoDemos.A['items'].Count / iRowCount)*140;
               Panel_Inner3.Height      := Panel_03_Demos.Height;
               for iDemo := 0 to gjoDemos.A['items'].Count-1 do begin
                    //get the demo panel include image and href(TStaticText)
                    oPanel         := TPanel(FindComponent('Panel_Demo_'+IntToStr(iDemo)));
                    oPanel.Top     := (iDemo div iRowCount) *140;
                    oPanel.Left    := (iDemo mod iRowCount)* 180;

               end;

          end;
     end;
     //set total height
     Panel_All.Height    := Panel_99_Foot.Top + Panel_99_Foot.Height;
     dwSetHeight(self,Panel_All.Height);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     //set total height
     Panel_All.Height    := Panel_99_Foot.Top + Panel_99_Foot.Height;
     dwSetHeight(self,Panel_All.Height);
end;

procedure TForm1.Image__DemoClick(Sender: TObject);
var
     sUrl      : String;
     iDemo     : Integer;
begin
     sUrl := TImage(Sender).Name;
     //
     Delete(sUrl,1,9);
     iDemo     := StrToIntDef(sUrl,0);
     //
     sUrl := gjoDemos.A['items'].O[iDemo].S['href'];
     //
     if Pos('://',sUrl)<=0 then begin
          //如果是简称，则补会
          sUrl      := '/'+sUrl+'.dw';
     end;

     //open the url
     dwOpenUrl(self,sUrl,'_blank');
               //
end;

end.
