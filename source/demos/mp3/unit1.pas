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
     Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls, Vcl.Grids, Vcl.FileCtrl;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    Panel_Full: TPanel;
    Label_Name: TLabel;
    ScrollBox1: TScrollBox;
    Panel_Buttons: TPanel;
    Button_Audio: TButton;
    FileListBox_Audio: TFileListBox;
    BitBtn_Upload: TBitBtn;
    procedure Button3Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_AudioClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BitBtn_UploadEndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    gsMainDir   : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button_AudioClick(Sender: TObject);
begin
    //
    MediaPlayer1.FileName   := 'media/audio/'+TButton(Sender).Caption;
    //
    Label_Name.Caption      := TButton(Sender).Caption;

    //
    for var I := 0 to Panel_Buttons.ControlCount-1 do begin
        TButton(Panel_Buttons.Controls[I]).Hint := '{"type":"primary"}';
    end;
    //
    TButton(Sender).Hint := '{"type":"success"}';
end;

procedure TForm1.BitBtn_UploadEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFile   : String;
begin
    //取得上传的文件名
    sFile   := dwGetProp(self,'__upload');

    //移动文件到系统的文档目录
    MoveFile(PWideChar(gsMainDir+'upload\'+sFile),PWideChar(gsMainDir+'media\audio\'+sFile));

    //自动切换到当前文件
    MediaPlayer1.FileName   := 'media/audio/'+sFile;

    //显示文件名
    Label_Name.Caption      := sFile;

    //刷新窗体
    Self.DockSite         := True;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    //播放
    MediaPlayer1.EnabledButtons   := [btPlay];

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置为移动模式
    dwSetMobileMode(Self,360,720);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //从URL中得到文件名并播放

    var sParams := dwGetProp(Self,'params');
    sParams := dwUnescape(sParams);
    if Pos('file=',sParams)>0 then begin
        //得到名称
        Delete(sParams,1,5);
        MediaPlayer1.FileName    := sParams;
        //
        var sName := sParams;
        while Pos('/',sName)>0 do begin
            Delete(sName,1,Pos('/',sName));
        end;
        Label_Name.Caption       := ExtractFileName(sName);
    end;

    //
    var sDir    := GetCurrentDir;
    FileListBox_Audio.Directory := sDir+'\media\audio\';
    //
    for var I := 0 to FileListBox_Audio.Count-1 do begin
        with TButton(CloneComponent(Button_Audio)) do begin
            Caption := FileListBox_Audio.Items[I];
        end;
    end;
    //
    Button_Audio.Destroy;
end;

end.
