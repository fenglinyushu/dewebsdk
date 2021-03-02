unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
  Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Shape1: TShape;
    Label1: TLabel;
    Button2: TButton;
    Panel_01_Tile: TPanel;
    Image1: TImage;
    Label3: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
    procedure Shape1EndDock(Sender, Target: TObject; X, Y: Integer);
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

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
     //
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     //dwShowMessage('Hello,Deweb!',self);
     //BitBtn1.OnClick(BitBtn1);
     Label1.Caption := 'Started!';
     dwSetZXing(Shape1,0);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if (lowercase(Copy(Label1.Caption,1,7))='http://') or (lowercase(Copy(Label1.Caption,1,8))='https://') then begin
          dwOpenUrl(Self,Label1.Caption,'_self');
     end else begin
          dwShowMessage('not a website!',self);
     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //
     Width     := Min(X,400);
     Height    := Y;
end;

procedure TForm1.Shape1DragDrop(Sender, Source: TObject; X, Y: Integer);
begin
     dwShowMessage(Shape1.HelpKeyword,self);
end;

procedure TForm1.Shape1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
     Label1.Caption      := dwISO8859ToChinese(dwUnEscape(Shape1.HelpKeyword));
     //
     //Button2.Enabled     := (lowercase(Copy(Label1.Caption,1,7))='http://') or (lowercase(Copy(Label1.Caption,1,8))='https://');
end;

end.
