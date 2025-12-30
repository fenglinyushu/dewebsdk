unit unit1;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer;

type
  TForm1 = class(TForm)
    MediaPlayer1: TMediaPlayer;
    Panel1: TPanel;
    Button3: TButton;
    Button1: TButton;
    Button4: TButton;
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure MediaPlayer1Enter(Sender: TObject);
    procedure MediaPlayer1Exit(Sender: TObject);
    procedure MediaPlayer1Notify(Sender: TObject);
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
     if MediaPlayer1.FileName  = '/media/video/small.mp4' then begin
          MediaPlayer1.FileName    := '/media/video/ocean.mp4';
     end else begin
          MediaPlayer1.FileName    := '/media/video/small.mp4';
     end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     MediaPlayer1.EnabledButtons   := [btPlay];
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     MediaPlayer1.AutoRewind := not MediaPlayer1.AutoRewind;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     MediaPlayer1.HelpContext := 6;
end;

procedure TForm1.MediaPlayer1Enter(Sender: TObject);
begin
    dwMessage('play - OnEnter','',self);
end;

procedure TForm1.MediaPlayer1Exit(Sender: TObject);
begin
    dwMessage('ended - OnExit','',self);

end;

procedure TForm1.MediaPlayer1Notify(Sender: TObject);
begin
    dwMessage('pause - OnNotify','',self);
end;

end.
