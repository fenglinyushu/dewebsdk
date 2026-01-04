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
    MainMenu1: TMainMenu;
    M1: TMenuItem;
    M0: TMenuItem;
    M10: TMenuItem;
    M00: TMenuItem;
    Shape1: TShape;
    M01: TMenuItem;
    M4: TMenuItem;
    M11: TMenuItem;
    M12: TMenuItem;
    Panel3: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Panel_0_Banner: TPanel;
    Label3: TLabel;
    Label_User: TLabel;
    Panel_Title: TPanel;
    Label_Title: TLabel;
    Button_Collapse: TButton;
    Button_Logout: TButton;
    Button_Register: TButton;
    Button_Login: TButton;
    M2: TMenuItem;
    M3: TMenuItem;
    M30: TMenuItem;
    procedure M10Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
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
    Shape1.ShowHint := not Shape1.ShowHint;
    if Shape1.ShowHint then begin
        Shape1.Width        := 48;
        Label_Title.Caption := '.W.';
    end else begin
        Shape1.Width        := 200;
        Label_Title.Caption := 'D.W.M.S';
    end;
    Panel_Title.Width   := Shape1.Width;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    Shape1.Visible := not Shape1.Visible;
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
    //背景色
    Shape1.Brush.Color  := Random($7f7f7f);
    //字体色
    Shape1.Pen.Color    := $7f7f7f + Random($7f7f7f);
    //激活状态字体色
    Shape1.Hint         := '{"activetextcolor":"'+dwColorAlpha(Random($8F8F8F))+'"}'

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
    //dwRunJS('this.shape1__opd=["1","1-2","4"];',self);
    M11.Click;
    //
    var sJS : String;
    sjS     := 'let menuElement = document.getElementById("shape1");'
            + 'let menu = menuElement.__vue__;'
            +'menu.setCurrentIndex("2");';

    sJS     := 'this.shape1__act ="1-1";';

    dwRunJS('this.'+dwFullName(Shape1)+'__act ="1-2";',self);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.M10Click(Sender: TObject);
begin
    //
end;

end.
