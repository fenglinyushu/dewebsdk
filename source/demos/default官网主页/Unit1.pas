unit Unit1;

interface

uses
     //
     dwBase,



     //
     Math,
     Windows, Messages, SysUtils, Variants, StdCtrls, Graphics, ExtCtrls,
     Controls, Forms, Dialogs, Classes, Menus, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg,
  Vcl.ComCtrls, Vcl.Imaging.GIFImg ;

type
  TForm1 = class(TForm)
    P0: TPanel;
    PS99: TPanel;
    Label15: TLabel;
    L_Title: TLabel;
    Panel2: TPanel;
    ST_BeiAn: TStaticText;
    P01: TPanel;
    ST_Demo: TStaticText;
    ST_Download: TStaticText;
    ST_Doc: TStaticText;
    Image1: TImage;
    PS01: TPanel;
    PS0: TPanel;
    L_platform: TLabel;
    L_Detail: TLabel;
    PS02: TPanel;
    PS021: TPanel;
    PS0210: TPanel;
    Label4: TLabel;
    Panel1: TPanel;
    Label5: TLabel;
    Panel3: TPanel;
    Panel4: TPanel;
    Label6: TLabel;
    Panel5: TPanel;
    PS03: TPanel;
    L_Char: TLabel;
    PS04: TPanel;
    PS041: TPanel;
    Label8: TLabel;
    Label9: TLabel;
    PS042: TPanel;
    Label10: TLabel;
    Label11: TLabel;
    PS044: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Button_Single: TButton;
    Button_Forever: TButton;
    Button_TrialFree: TButton;
    Label18: TLabel;
    StaticText1: TStaticText;
    Panel_Quick: TPanel;
    Button_DOC: TButton;
    Button_Demo: TButton;
    ST_BBS: TStaticText;
    procedure FormCreate(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_DownloadClick(Sender: TObject);
    procedure Button_DOCClick(Sender: TObject);
    procedure Button_SingleClick(Sender: TObject);
    procedure Button_ForeverClick(Sender: TObject);
    procedure Button_DemoClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1     : TForm1;
     gsMainDir : string;

implementation

{$R *.dfm}

procedure TForm1.Button_DemoClick(Sender: TObject);
begin
    dwOpenUrl(self,'https://www.delphibbs.com/mall','_blank');
end;

procedure TForm1.Button_DOCClick(Sender: TObject);
begin
    dwOpenUrl(self,'https://www.delphibbs.com/doc','_blank');
end;

procedure TForm1.Button_SingleClick(Sender: TObject);
begin
    dwOpenUrl(self,'https://item.taobao.com/item.htm?ft=t&id=851898123133','_blank');

end;

procedure TForm1.Button_ForeverClick(Sender: TObject);
begin
    dwOpenUrl(self,'https://item.taobao.com/item.htm?ft=t&id=836250091461','_blank');
end;

procedure TForm1.Button_DownloadClick(Sender: TObject);
begin
    //
    dwOpenUrl(self,'点击链接加入群聊【DelphiBBS大富翁论坛】：http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=UOIrmMweCaJwmjVFhwUvnz8IacRwG5TU&authKey=IqBC2b6F0KISD0daHlb9r%2B9PkVEuF%2BNkMtAatelsljw1qqcZdBPuMaRufEr%2F2aln&noverify=0&group_code=120283369','_blank');
end;


procedure TForm1.FormCreate(Sender: TObject);
begin
     //Get current dir
     gsMainDir := ExtractFilePath(Application.ExeName);

     //set top
     Top  := 0;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    if  (X > 500) and (Y > 500) then begin
        dwSetPCMode(self);
        //
        dwAlignByColCount(PS02,3);
        dwAlignByColCount(PS04,3);

        //
        AutoSize    := True;

    end else begin
        dwSetMobileMode(self,360,740);
        //第1格
        L_Title.Margins.Left    := 20;
        L_Title.Font.Size       := 27;
        P01.Margins.Right       := 0;
        //第2格
        L_Platform.Caption      := 'Delphi快速web开发';
        L_Platform.Top          := 20;
        L_Platform.Font.Size    := 27;
        L_Detail.Left           := 20;
        L_Detail.Top            := 120;
        L_Detail.Width          := Width-40;
        Panel_Quick.Top         := 320;
        //第3格
        PS021.Height    := 250;
        PS02.Height     := (PS021.Height + PS021.Margins.Top + PS021.Margins.Bottom) * 3;
        dwAlignByColCount(PS02,1);
        //第4格
        L_Char.Left         := 20;
        L_Char.Width        := Width-40;
        PS03.Height         := 740;
        //第5格
        PS041.Height        := 280;
        PS04.Margins.Left   := 0;
        PS04.Margins.Right  := 0;
        PS041.Margins.Left  := 0;
        PS041.Margins.Right := 0;
        PS04.Height         := (PS041.Height + PS041.Margins.Top + PS041.Margins.Bottom) *4;
        dwAlignByColCount(PS04,1);
        Button_TrialFree.Top    := 230;
        Button_Single.Top       := Button_TrialFree.Top;
        Button_Forever.Top      := Button_TrialFree.Top;
        //
        //AutoSize    := True;
        //Height  := P0.
    end;
end;

end.
