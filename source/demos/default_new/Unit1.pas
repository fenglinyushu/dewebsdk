unit Unit1;

interface

uses
     //
     dwBase,

     //
     Math,
     Windows, Messages, SysUtils, Variants, StdCtrls, Graphics, ExtCtrls,
     Controls, Forms, Dialogs, Classes, Menus, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  Vcl.ComCtrls ;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Panel_00_Logo: TPanel;
    Panel_Line: TPanel;
    Panel1: TPanel;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    Label7: TLabel;
    StaticText8: TStaticText;
    Label8: TLabel;
    Label1: TLabel;
    Panel_99_Foot: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel_Logo: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Panel_02_Introduce: TPanel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label9: TLabel;
    Panel_01_Advise: TPanel;
    Label3: TLabel;
    Label10: TLabel;
    Panel_03_Base: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Button1: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button4Click(Sender: TObject);
begin
     dwOpenUrl(self,'/pagecontrol.dw','_blank');
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     dwOpenUrl(self,'/demos.dw','_blank');

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     dwOpenUrl(self,'/dfw.dw','_blank');

end;

procedure TForm1.Button7Click(Sender: TObject);
begin
     dwOpenUrl(self,'/driver.dw','_blank');

end;

procedure TForm1.Button8Click(Sender: TObject);
begin
     dwOpenUrl(self,'/mediaplayer.dw','_blank');

end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Top  := 0;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     dwSetHeight(Self,1200);
end;

end.
