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
    Button1: TButton;
    Edit1: TEdit;
    Panel_00_Title: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Label3: TLabel;
    Panel_Footer: TPanel;
    Label4: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
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

     dwRunJS(Edit1.Text,self);      //

end;

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

     //
     Height    := Ceil(iInnerH*Y/iTrueH*iTrueW/iInnerW);
     //
     Panel_Footer.Top    := Height - Panel_Footer.Height;
     Panel_Footer.Left   := 0;
     Panel_Footer.Width  := Width;
end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
     sDat      : string;
begin
     sDat := dwGetProp(Self,'interactionmethod')+'  ---  '+ dwGetProp(Self,'interactionvalue');
     dwShowMessage(sDat,Self);
end;

end.
