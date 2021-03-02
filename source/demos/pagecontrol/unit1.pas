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
    Panel_02_Buttons: TPanel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Panel_03_Control: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    PageControl3: TPageControl;
    TabSheet22: TTabSheet;
    TabSheet23: TTabSheet;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    PageControl4: TPageControl;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    PageControl5: TPageControl;
    TabSheet8: TTabSheet;
    Label7: TLabel;
    TabSheet9: TTabSheet;
    Label8: TLabel;
    PageControl6: TPageControl;
    TabSheet10: TTabSheet;
    Label9: TLabel;
    TabSheet11: TTabSheet;
    Label10: TLabel;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure Button1Click(Sender: TObject);
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
     TabSheet2.TabVisible     := not TabSheet2.TabVisible;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     PageControl1.Visible  := not PageControl1.Visible;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     dwShowMessage('ActivePageIndex : '+ IntToStr(PageControl1.ActivePageIndex),Self);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     if PageControl1.ActivePageIndex < PageControl1.PageCount-1 then begin
          PageControl1.ActivePageIndex  := PageControl1.ActivePageIndex + 1;
     end else begin
          PageControl1.ActivePageIndex  := 0;
     end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     PageControl1.Width  := PageControl1.Width + 5;
     PageControl1.Height := PageControl1.Height + 5;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     PageControl1.Left   := PageControl1.Left + 5;
     PageControl1.Top    := PageControl1.Top  + 5;
end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
     if CheckBox1.Checked then begin
          dwShowMessage('OnChange! Index : '+ IntToStr(PageControl1.ActivePageIndex),Self);
     end;
end;

end.
