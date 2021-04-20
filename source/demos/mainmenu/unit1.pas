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
    Button1: TButton;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N9: TMenuItem;
    Button2: TButton;
    Button3: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
     MainMenu1.AutoMerge := not MainMenu1.AutoMerge;
     if MainMenu1.AutoMerge then begin
          dwSetCompLTWH(MainMenu1,0,60,60,500);
     end else begin
          dwSetCompLTWH(MainMenu1,0,60,150,500);
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if MainMenu1.AutoMerge then begin
          dwSetCompLTWH(MainMenu1,0,60,60,500);
     end else begin
          dwSetCompLTWH(MainMenu1,0,60,150,500);
     end;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     dwSetCompLTWH(MainMenu1,4000,60,150,500);

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     dwSetCompLTWH(MainMenu,0,0,600,50);
     dwSetCompLTWH(MainMenu1,0,60,150,500);
end;

end.
