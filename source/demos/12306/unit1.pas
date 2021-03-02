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
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image_12306: TImage;
    Label2: TLabel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Label3: TLabel;
    Edit_Start: TEdit;
    Label4: TLabel;
    Edit_Dest: TEdit;
    Label5: TLabel;
    DateTimePicker1: TDateTimePicker;
    Panel_Citys: TPanel;
    Panel2: TPanel;
    Label6: TLabel;
    Button1: TButton;
    PageControl2: TPageControl;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    Button_City: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button2: TButton;
    Button34: TButton;
    Button35: TButton;
    Button36: TButton;
    Button37: TButton;
    Button68: TButton;
    Button69: TButton;
    Button70: TButton;
    Button71: TButton;
    Button72: TButton;
    Button73: TButton;
    Button74: TButton;
    Button75: TButton;
    Button76: TButton;
    Button103: TButton;
    Button104: TButton;
    Button105: TButton;
    Button106: TButton;
    Button107: TButton;
    Button108: TButton;
    Button109: TButton;
    Button110: TButton;
    Button111: TButton;
    Button112: TButton;
    Button113: TButton;
    Button114: TButton;
    Button139: TButton;
    Button140: TButton;
    Button141: TButton;
    Button142: TButton;
    Button143: TButton;
    Button144: TButton;
    Button175: TButton;
    Button176: TButton;
    Button177: TButton;
    Button178: TButton;
    Button179: TButton;
    Button180: TButton;
    Edit_Search: TEdit;
    Button_Search: TButton;
    procedure Edit_StartEnter(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Edit_DestEnter(Sender: TObject);
    procedure Button_CityClick(Sender: TObject);
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
     Panel_Citys.Visible := False;

end;

procedure TForm1.Button_CityClick(Sender: TObject);
begin
     if Panel_Citys.Tag = 1 then begin
          Edit_Start.Text     := TButton(Sender).Caption;
     end;
     if Panel_Citys.Tag = 2 then begin
          Edit_Dest.Text      := TButton(Sender).Caption;
     end;
     Panel_Citys.Visible := False;
end;

procedure TForm1.Edit_DestEnter(Sender: TObject);
begin
     Panel_Citys.Left    := Edit_Dest.Left;
     Panel_Citys.Top     := Edit_Dest.Top + Edit_Dest.Height + 10;
     Panel_Citys.Visible := True;
     //
     Panel_Citys.Tag     := 2;

end;

procedure TForm1.Edit_StartEnter(Sender: TObject);
begin
     Panel_Citys.Left    := Edit_Start.Left;
     Panel_Citys.Top     := Edit_Start.Top + Edit_Start.Height + 10;
     Panel_Citys.Visible := True;
     //
     Panel_Citys.Tag     := 1;
end;

end.
