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
     Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls, Vcl.Grids;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    Panel_Buttons: TPanel;
    Button3: TButton;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Panel_Full: TPanel;
    Label_Name: TLabel;
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
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


procedure TForm1.Button1Click(Sender: TObject);
begin
     MediaPlayer1.EnabledButtons   := [btPause];

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if MediaPlayer1.FileName  = 'media/audio/night.mp3' then begin
          MediaPlayer1.FileName    := 'media/audio/spring.mp3';
          Label_Name.Caption       := '����ʮ��';
     end else begin
          MediaPlayer1.FileName    := 'media/audio/night.mp3';
          Label_Name.Caption       := 'ҹ�ĸ�����';
     end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     MediaPlayer1.EnabledButtons   := [btPlay];

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     MediaPlayer1.AutoRewind := not MediaPlayer1.AutoRewind;
     if MediaPlayer1.AutoRewind then begin
          Button4.Caption     := 'Looped';
     end else begin
          Button4.Caption     := 'Loop';
     end;

end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     MediaPlayer1.HelpContext := 16;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     bMobile   : Boolean;     //�Ƿ�Ϊ�ֻ�
     bVert     : Boolean;     //�Ƿ�Ϊ����
     iWidth    : Integer;     //���
     iHeight   : Integer;     //�߶�
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

     if bMobile then begin
          //����ʱΪ�ȿ��������ƿ��Ϊ���360
          if bVert then begin
               Width     := iWidth;
          end else begin
               Width     := Min(480,iWidth);
          end;
          //
          Panel_Full.BorderStyle   := bsNone;
          TransparentColorValue    := clWhite;
     end else begin
          //
          Width     := Min(360,iWidth);

          //
          Panel_Full.BorderStyle   := bsSingle;
          TransparentColorValue    := clBtnFace;
     end;
end;

end.
