unit unit1;

interface

uses
     dwBase,


     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Menus;

type
  TForm1 = class(TForm)
    Panel_Full: TPanel;
    Panel_1: TPanel;
    Panel_0: TPanel;
    Panel_0_0: TPanel;
    Label1: TLabel;
    Panel_1_L: TPanel;
    Panel_1_C: TPanel;
    Panel_Head: TPanel;
    Image_logo: TImage;
    Button1: TButton;
    Image_Head: TImage;
    Label_Name: TLabel;
    Label_Title: TLabel;
    Panel_Comp: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    MainMenu_Left: TMainMenu;
    N1: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    N4: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Edit1: TMenuItem;
    Label2: TMenuItem;
    CheckBox1: TMenuItem;
    Panel_Menu: TPanel;
    Edit_Search: TEdit;
    Panel1: TPanel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button2: TButton;
    Panel2: TPanel;
    Label6: TLabel;
    Label10: TLabel;
    Button3: TButton;
    Panel3: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Panel4: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
     dwSetCompLTWH(MainMenu_Left,3,Panel_Menu.Top+Panel_0.Height,Panel_Menu.Width-3,Panel_Menu.Height);
end;

end.
