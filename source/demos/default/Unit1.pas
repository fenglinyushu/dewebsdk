unit Unit1;

interface

uses
     //
     dwBase,

     //
     Math,
     Windows, Messages, SysUtils, Variants, StdCtrls, Graphics, ExtCtrls,
     Controls, Forms, Dialogs, Classes, Menus, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg ;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Panel_00_Logo: TPanel;
    Panel_Line: TPanel;
    Img0: TImage;
    Panel1: TPanel;
    StaticText6: TStaticText;
    Edit1: TEdit;
    StaticText7: TStaticText;
    Label7: TLabel;
    StaticText8: TStaticText;
    Label8: TLabel;
    Panel_01_Imgs: TPanel;
    Image_0: TImage;
    Image_1: TImage;
    Image_2: TImage;
    Timer_Imgs: TTimer;
    Label1: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Panel_99_Foot: TPanel;
    Label14: TLabel;
    Label15: TLabel;
    Panel_TopLine: TPanel;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Timer_ImgsTimer(Sender: TObject);
    procedure Button1Enter(Sender: TObject);
    procedure Button1Exit(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button1Enter(Sender: TObject);
begin
     //
     Timer_Imgs.DesignInfo    := 0;
     case StrToIntDef(TButton(Sender).Caption,0) of
          1 : begin
               Image_0.Visible     := True;
               Image_1.Visible     := False;
               Image_2.Visible     := False;
          end;
          2 : begin
               Image_0.Visible     := False;
               Image_1.Visible     := True;
               Image_2.Visible     := False;
          end;
          3 : begin
               Image_0.Visible     := False;
               Image_1.Visible     := False;
               Image_2.Visible     := True;
          end;
     end;

end;

procedure TForm1.Button1Exit(Sender: TObject);
begin
     Timer_Imgs.DesignInfo    := 1;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     dwOpenUrl(self,'/hello.dw','_blank');
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

procedure TForm1.Timer_ImgsTimer(Sender: TObject);
begin
     if Image_0.Visible then begin
          Image_0.Visible     := False;
          Image_1.Visible     := True;
          Image_2.Visible     := False;
     end else if Image_1.Visible then begin
          Image_0.Visible     := False;
          Image_1.Visible     := False;
          Image_2.Visible     := True;
     end else if Image_2.Visible then begin
          Image_0.Visible     := True;
          Image_1.Visible     := False;
          Image_2.Visible     := False;
     end;
end;

end.
