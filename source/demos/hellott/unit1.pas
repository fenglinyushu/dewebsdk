unit unit1;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Panel_00_Logo: TPanel;
    Label1: TLabel;
    Label9: TLabel;
    Panel_Line: TPanel;
    Panel1: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    StaticText6: TStaticText;
    StaticText7: TStaticText;
    StaticText8: TStaticText;
    Panel_Logo: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Panel_99_Foot: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel_01_Advise: TPanel;
    Label10: TLabel;
    Panel_03_Base: TPanel;
    Label11: TLabel;
    Button1: TButton;
    Panel4: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label12: TLabel;
    Memo1: TMemo;
    TabSheet5: TTabSheet;
    Label13: TLabel;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Label16: TLabel;
    Label17: TLabel;
    procedure Button1Click(Sender: TObject);
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

procedure TForm1.Button1Click(Sender: TObject);
begin
     dwOpenUrl(self,'/hello.dw','_blank');

end;

procedure TForm1.FormShow(Sender: TObject);
begin
     dwSetHeight(Self,1200);

end;

end.
