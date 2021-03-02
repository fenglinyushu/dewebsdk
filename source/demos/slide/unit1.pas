unit unit1;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Image_MN: TImage;
    Button3: TButton;
    Button2: TButton;
    Button1: TButton;
    Timer_Slide: TTimer;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Timer_SlideTimer(Sender: TObject);
    procedure Button1Enter(Sender: TObject);
    procedure Button1Exit(Sender: TObject);
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

procedure TForm1.Button1Enter(Sender: TObject);
begin
     //Stop the slide timer
     Timer_Slide.DesignInfo   := 0;
     //set tag
     Timer_Slide.Tag          := StrToIntDef(TButton(Sender).Caption,1);
     //change the image src
     Image_MN.Hint  := '{"src":"/media/images/mn/'+IntToStr(Timer_Slide.Tag)+'.jpg"}';

end;

procedure TForm1.Button1Exit(Sender: TObject);
begin
     //start the slide timer
     Timer_Slide.DesignInfo   := 1;

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Top  := 10;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := X;
     Height    := Y;
end;

procedure TForm1.Timer_SlideTimer(Sender: TObject);
begin
     //set tag
     if Timer_Slide.Tag<3 then begin
          Timer_Slide.Tag     := Timer_Slide.Tag + 1;
     end else begin
          Timer_Slide.Tag     := 1;
     end;
     //change the image src
     Image_MN.Hint  := '{"src":"/media/images/mn/'+IntToStr(Timer_Slide.Tag)+'.jpg"}';
end;

end.
