unit unit1;

interface

uses
     //
     dwBase,
     cnDes,

     //
     JsonDataObjects,    //JSON������Ԫ
     CloneComponents,    //��¡�ؼ��ĵ�Ԫ

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
     gjoApps        : TJsonObject;           //�����ļ�


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
     //�õ������ؼ���
     sKeyword  := Trim(Edit_Search.Text);
     //ÿ��Ӧ����
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
               //ÿ��Ӧ����
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
     bMobile   : Boolean;     //�Ƿ�Ϊ�ֻ�
     bVert     : Boolean;     //�Ƿ�Ϊ����
     iWidth    : Integer;     //���
     iHeight   : Integer;     //�߶�
     iApp      : Integer;
     iRowCount : Integer;     //ÿ������
     iLeft     : Integer;     //��߾�
     joApp     : TJsonObject;
     oSpeed    : TSpeedButton;
begin
     //<ȡ�ÿͻ�������
     //�Ƿ��ֻ�
     bMobile   := (ssCtrl in Shift) or (ssLeft in Shift);

     //�Ƿ�Ϊ����
     bVert     := Button = mbLeft;

     //�õ���Ⱥ͸߶ȣ���Ϊiphone�Ŀ�Ȳ�������/����仯��
     iWidth    := X;
     iHeight   := Y;
     if  (ssLeft in Shift) and (not bVert) then begin
          iWidth    := Y;
          iHeight   := X;
     end;
     //>

     //�ֻ�/�����Զ���Ӧ
     //������ֻ���������������ã�
     //1 ���Panel�ޱ߿�
     //2 ����ɫΪ��ɫ

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


     //<����ͼ����ʾ
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
          dwShowMessage('һ�ʽ�������ȡ��',self);
     end else if Pos('ad2',sHint)>0 then begin
          dwShowMessage('���˵õ�DW�Ż�ȯ��',self);
     end else if Pos('ad3',sHint)>0 then begin
          dwShowMessage('��л֧��DeWeb!',self);
     end else if Pos('ad4',sHint)>0 then begin
          dwShowMessage('��õ��˹ٷ���Ǯ��',self);

     end;
end;

procedure TForm1.Panel_Image1Enter(Sender: TObject);
var
     iTag      : Integer;
begin
     //����ͣʱ��
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
     //����ʱ��
     Timer_Images.DesignInfo  := 1;

end;

procedure TForm1.SpeedButton_AppClick(Sender: TObject);
var
     iApp      : Integer;
begin
     if TSpeedButton(Sender).Caption = 'more' then begin
          dwShowMessage('�����У������ڴ�',self);
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
          //Ԥ��ȡ
          dwPreGetCookie(self,'dw_loginuser','');
          dwPreGetCookie(self,'dw_loginpassword','');
     end else if Timer_GetCookie.Tag < 30 then begin
          sUser     := dwGetCookie(self,'dw_loginuser');
          //
          if sUser <>'' then begin
               //ֹͣTimer
               Timer_GetCookie.DesignInfo        := 0;
          end;
     end else begin
          //ֹͣTimer
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
