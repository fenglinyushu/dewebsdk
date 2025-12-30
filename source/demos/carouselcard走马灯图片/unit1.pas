unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Menus, Vcl.Imaging.pngimage, Vcl.WinXPanels;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    CardPanel1: TCardPanel;
    Card1: TCard;
    Image1: TImage;
    Card2: TCard;
    Card3: TCard;
    Card4: TCard;
    Card5: TCard;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetMobileMode(Self,360,740);
end;

end.
