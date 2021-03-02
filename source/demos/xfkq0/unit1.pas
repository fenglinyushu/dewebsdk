unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Panel_User: TPanel;
    Image_Logo: TImage;
    Label_User: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel_line0: TPanel;
    Panel_UserInfo: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Panel1: TPanel;
    Image2: TImage;
    Label4: TLabel;
    Panel2: TPanel;
    Image3: TImage;
    Label5: TLabel;
    Panel3: TPanel;
    Image4: TImage;
    Label6: TLabel;
    Panel4: TPanel;
    Image5: TImage;
    Label7: TLabel;
    Panel5: TPanel;
    Image6: TImage;
    Label8: TLabel;
    Panel6: TPanel;
    Image7: TImage;
    Label9: TLabel;
    Panel7: TPanel;
    Image8: TImage;
    Label10: TLabel;
    Panel8: TPanel;
    Image9: TImage;
    Label11: TLabel;
    Panel9: TPanel;
    Image10: TImage;
    Label12: TLabel;
    Image11: TImage;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image11Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := Min(400,X);
     Height    := Y-100;
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
     dwOpenUrl(self,'/xfkq.dw','_self');
end;

end.
