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
    N10: TMenuItem;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N14: TMenuItem;
    Button4: TButton;
    Button5: TButton;
    AAA1: TMenuItem;
    AAA2: TMenuItem;
    CCCC1: TMenuItem;
    CCCC2: TMenuItem;
    FF1: TMenuItem;
    FF2: TMenuItem;
    GG1: TMenuItem;
    GG2: TMenuItem;
    HH1: TMenuItem;
    HH2: TMenuItem;
    B1: TMenuItem;
    B2: TMenuItem;
    Button6: TButton;
    N15: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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
          dwSetCompLTWH(MainMenu1,0,60,46,500);
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

procedure TForm1.Button4Click(Sender: TObject);
var
    oMenuItem   : TMenuItem;
begin
    oMenuItem   := TMenuItem.Create(self);
    oMenuItem.Name      := 'N'+IntToStr(GetTickCount);
    oMenuItem.Caption   := 'M_'+IntToStr(GetTickCount mod 1000);
    oMenuItem.ImageIndex:= 56+MainMenu1.Items.Count;
    MainMenu1.Items.Add(oMenuItem);

    //以下代码用于刷新界面
    DockSite  := True;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
    if MainMenu1.Items.Count>1 then begin
        MainMenu1.Items.Delete(MainMenu1.Items.Count-1);

        //以下代码用于刷新界面
        DockSite  := True;
    end;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
    if MainMenu1.Items.Count>0 then begin
        MainMenu1.Items[0].Hint  := '{"backgroundcolor":"'+dwColorAlpha(Random($8F8F8F))+'"}'
    end;
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
    dwRunJS('this.mainmenu1__opd=["1","1-2","4"];',self);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    dwSetCompLTWH(MainMenu,0,0,600,50);
    dwSetCompLTWH(MainMenu1,0,60,150,500);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
    //
end;

end.
