unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
var
     oButton   : TButton;
begin
     oButton   := TButton.Create(self);
     oButton.Parent := self;
     Randomize;
     oButton.Width  := 100;
     oButton.Left   := Random(Width-oButton.Width);
     oButton.Top    := Random(Height-150)+100;
     oButton.Name   := 'B_'+IntToStr(GetTickCount mod 1000000);
     case GetTickCount mod 6 of
          0 : oButton.Hint   := '{"type":"success"}';
          1 : oButton.Hint   := '{"type":"primary"}';
          2 : oButton.Hint   := '{"type":"info"}';
          3 : oButton.Hint   := '{"type":"warning"}';
          4 : oButton.Hint   := '{"type":"danger"}';
     end;
     //
     oBUtton.OnClick     := Button1.OnClick;
     //
     Self.ParentFont     := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if (Self.Controls[Self.ControlCount-1] <> Button1) and (Self.Controls[Self.ControlCount-1] <> Button2) then begin
          Self.Controls[Self.ControlCount-1].Destroy;
     end;
     //
     Self.ParentFont     := True;
end;

end.
