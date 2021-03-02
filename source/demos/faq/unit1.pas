unit unit1;

interface

uses
     dwBase,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_00_Title: TPanel;
    Label_Title: TLabel;
    Image1: TImage;
    Panel_01_Line: TPanel;
    Panel_02_Content: TPanel;
    PageControl: TPageControl;
    TabSheet1: TTabSheet;
    Label2: TLabel;
    Label3: TLabel;
    Label5: TLabel;
    TabSheet2: TTabSheet;
    Label6: TLabel;
    Label7: TLabel;
    TabSheet3: TTabSheet;
    Label4: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label10: TLabel;
    TabSheet4: TTabSheet;
    Label1: TLabel;
    TabSheet5: TTabSheet;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    procedure FormShow(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
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
     Exit;

     Width     := Min(X,800);
     if Width < 500 then begin
          Label_Title.Caption := 'FAQs';
     end else begin
          Label_Title.Caption := 'Frequently Asked Questions';
     end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
     Panel_02_Content.Height  := dwGetTimeLineHeight(PageControl);
     //dwSetHeight(self,);
end;

end.
