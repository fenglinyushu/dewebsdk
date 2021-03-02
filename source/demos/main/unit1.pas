unit unit1;

interface

uses
     //
     dwBase,
     cnDes,

     //
     JsonDataObjects,    //JSON解析单元
     CloneComponents,    //克隆控件的单元

     //
     HttpApp,Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Vcl.Imaging.pngimage, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Panel_Full: TPanel;
    Timer_GetCookie: TTimer;
    Panel_01_Images: TPanel;
    Image_slide: TImage;
    Panel_Image1: TPanel;
    Panel_Image2: TPanel;
    Panel_Image3: TPanel;
    Panel_Image4: TPanel;
    Timer_Images: TTimer;
    Panel_02_Search: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    Panel_03_Content: TPanel;
    SpeedButton_App: TSpeedButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer_GetCookieTimer(Sender: TObject);
    procedure Timer_ImagesTimer(Sender: TObject);
    procedure Panel_Image1Enter(Sender: TObject);
    procedure Panel_Image1Exit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpeedButton_AppClick(Sender: TObject);
    procedure Button_SearchClick(Sender: TObject);
    procedure Image_slideClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1          : TForm1;
     //
     gjoApps        : TJsonObject;           //配置文件


implementation

{$R *.dfm}




procedure TForm1.Button_SearchClick(Sender: TObject);
var
     iApp      : Integer;     //
     iNo       : Integer;
     iRowCount : Integer;
     //
     sKeyword  : string;
     //
     oSpeed    : TSpeedButton;
     //
     joApp     : TJsonObject;
begin
     //得到搜索关键字
     sKeyword  := Trim(Edit_Search.Text);
     //每行应用数
     iRowCount := Width div SpeedButton_App.Width;
     //
     iNo    := 0;
     //
     for iApp := 0 to gjoApps.A['items'].Count-1 do begin
          //get app jsonobject
          joApp         := gjoApps.A['items'].O[iApp];
          //
          oSpeed    := TSpeedButton(FindComponent('SpeedButton_App'+IntToStr(iApp+1)));
          if (sKeyword='')or(Pos(sKeyword,joApp.S['title'])>0) or (Pos(sKeyword,joApp.S['href'])>0) then begin
               oSpeed.Visible := True;
               //
               oSpeed.Top     := (iNo div iRowCount) * oSpeed.Height-1;
               oSpeed.Left    := -1+(iNo mod iRowCount) * oSpeed.Width;
               //
               Inc(iNo);
          end else begin
               oSpeed.Visible := False;
          end;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     iApp      : Integer;
     iRowCount : Integer;
     oSpeed    : TSpeedButton;
     joApp     : TJsonObject;
begin
     //
     try
          if FileExists('dwmain.json') then begin
               //每行应用数
               iRowCount := Width div SpeedButton_App.Width;
               //
               gjoApps   := TJsonObject.Create;
               gjoApps.LoadFromFile('dwmain.json');
               //
               for iApp := 0 to gjoApps.A['items'].Count-1 do begin
                    //get app jsonobject
                    joApp         := gjoApps.A['items'].O[iApp];
                    //
                    if not joApp.Contains('title') then begin
                         joApp.S['title'] := joApp.S['href'];
                    end;
                    if not joApp.Contains('picture') then begin
                         joApp.S['picture'] := joApp.S['href'];
                    end;
                    if not FileExists('media\images\'+joApp.S['picture']+'.png') then begin
                         joApp.S['picture'] := 'app48';
                    end;

                    //
                    oSpeed         := TSpeedButton(CloneComponent(SpeedButton_App));
                    oSpeed.Parent  := SpeedButton_App.Parent;
                    oSpeed.Tag     := iApp;  //
                    //
                    oSpeed.Visible := True;
                    oSpeed.Top     := (iApp div iRowCount) * oSpeed.Height-1;
                    oSpeed.Left    := -1+(iApp mod iRowCount) * oSpeed.Width;

                    //
                    oSpeed.Caption := joApp.S['title'];
                    oSpeed.Hint    := '{"src":"media/images/'+joApp.S['picture']+'.png"}';
               end;
          end;
     except

     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     bMobile   : Boolean;     //是否为手机
     bVert     : Boolean;     //是否为竖屏
     iWidth    : Integer;     //宽度
     iHeight   : Integer;     //高度
     iApp      : Integer;
     iRowCount : Integer;     //每行数量
     iLeft     : Integer;     //左边距
     joApp     : TJsonObject;
     oSpeed    : TSpeedButton;
begin
     //<取得客户端属性
     //是否手机
     bMobile   := (ssCtrl in Shift) or (ssLeft in Shift);

     //是否为竖屏
     bVert     := Button = mbLeft;

     //得到宽度和高度（因为iphone的宽度不随纵向/横向变化）
     iWidth    := X;
     iHeight   := Y;
     if  (ssLeft in Shift) and (not bVert) then begin
          iWidth    := Y;
          iHeight   := X;
     end;
     //>

     //手机/电脑自动适应
     //如果是手机，则进行如下设置：
     //1 外框Panel无边框
     //2 背景色为白色

     Width     := Min(1000,iWidth);
     if bMobile then begin
          //
          Panel_Full.BorderStyle   := bsNone;
          TransparentColorValue    := clWhite;
     end else begin
          //
          Panel_Full.BorderStyle   := bsSingle;
          TransparentColorValue    := clBtnFace;
     end;


     //<更新图标显示
     iRowCount := Width div SpeedButton_App.Width;
     iLeft     := -1;//(Width - iRowCount * SpeedButton_App.Width) div 2;
     //
     for iApp := 0 to gjoApps.A['items'].Count-1 do begin
          //get app jsonobject
          joApp         := gjoApps.A['items'].O[iApp];
          //
          oSpeed    := TSpeedButton(FindComponent('SpeedButton_App'+IntToStr(iApp+1)));
          //
          oSpeed.Left    := iLeft + (iApp mod iRowCount) * SpeedButton_App.Width;
          oSpeed.Top     := -1    + (iApp div iRowCount) * SpeedButton_App.Height;
     end;
     //>


end;

procedure TForm1.FormShow(Sender: TObject);
begin
     Timer_Images.OnTimer(self);
end;

procedure TForm1.Image_slideClick(Sender: TObject);
var
     sHint     : String;
begin
     sHint     := Image_Slide.Hint;
     //
     if Pos('ad1',sHint)>0 then begin
          dwShowMessage('一笔奖励已领取！',self);
     end else if Pos('ad2',sHint)>0 then begin
          dwShowMessage('幸运得到DW优惠券！',self);
     end else if Pos('ad3',sHint)>0 then begin
          dwShowMessage('感谢支持DeWeb!',self);
     end else if Pos('ad4',sHint)>0 then begin
          dwShowMessage('你得到了官方收钱码',self);

     end;
end;

procedure TForm1.Panel_Image1Enter(Sender: TObject);
var
     iTag      : Integer;
begin
     //先暂停时钟
     Timer_Images.DesignInfo  := 0;

     //
     iTag := TPanel(Sender).Tag;

     //
     Panel_Image1.Color  := clBtnFace;
     Panel_Image2.Color  := Panel_Image1.Color;
     Panel_Image3.Color  := Panel_Image1.Color;
     Panel_Image4.Color  := Panel_Image1.Color;


     Image_Slide.Hint    := '{"src":"media/images/ad'+IntToStr(iTag)+'.jpg"}';
     //
     TPanel(FindComponent('Panel_Image'+IntToStr(iTag))).Color  := clMedGray;
end;

procedure TForm1.Panel_Image1Exit(Sender: TObject);
begin
     //启动时钟
     Timer_Images.DesignInfo  := 1;

end;

procedure TForm1.SpeedButton_AppClick(Sender: TObject);
var
     iApp      : Integer;
begin
     if TSpeedButton(Sender).Caption = 'more' then begin
          dwShowMessage('建设中，敬请期待',self);
     end else begin
          //
          iApp      := TSpeedButton(Sender).Tag;
          //
          dwOpenUrl(self,'/'+gjoApps.A['items'].O[iApp].S['href']+'.dw','_self');
     end;
end;

procedure TForm1.Timer_GetCookieTimer(Sender: TObject);
var
     sUser     : string;
begin
     //
     if Timer_GetCookie.Tag=0 then begin
          //预读取
          dwPreGetCookie(self,'dw_loginuser','');
          dwPreGetCookie(self,'dw_loginpassword','');
     end else if Timer_GetCookie.Tag < 30 then begin
          sUser     := dwGetCookie(self,'dw_loginuser');
          //
          if sUser <>'' then begin
               //停止Timer
               Timer_GetCookie.DesignInfo        := 0;
          end;
     end else begin
          //停止Timer
          Timer_GetCookie.DesignInfo   := 0;
     end;

     //
     Timer_GetCookie.Tag := Timer_GetCookie.Tag +1;

end;

procedure TForm1.Timer_ImagesTimer(Sender: TObject);
begin
     //
     Panel_Image1.Color  := clBtnFace;
     Panel_Image2.Color  := Panel_Image1.Color;
     Panel_Image3.Color  := Panel_Image1.Color;
     Panel_Image4.Color  := Panel_Image1.Color;


     Image_Slide.Hint    := '{"src":"media/images/ad'+IntToStr(Timer_Images.Tag+1)+'.jpg"}';
     //
     TPanel(FindComponent('Panel_Image'+IntToStr(Timer_Images.Tag+1))).Color  := clMedGray;

     //
     Timer_Images.Tag    := Timer_Images.Tag + 1;
     if Timer_Images.Tag > 3 then begin
          Timer_Images.Tag    := 0;
     end;
end;

end.
