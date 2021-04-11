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
    MainMenu: TMainMenu;
    MenuItem_Add: TMenuItem;
    MenuItem_Edit: TMenuItem;
    MenuItem_Delete: TMenuItem;
    MenuItem_Save: TMenuItem;
    MenuItem_Cancel: TMenuItem;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    N1: TMenuItem;
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


procedure TForm1.FormCreate(Sender: TObject);
begin
     dwSetCompLTWH(MainMenu,0,0,600,50);
     dwSetCompLTWH(MainMenu1,0,60,150,500);
end;

end.
