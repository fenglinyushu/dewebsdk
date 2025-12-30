unit Unit_Phone;

interface

uses
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm_Phone = class(TForm)
    PTitle: TPanel;
    LTitle: TLabel;
    B0: TButton;
    LPhone: TLabel;
    FP0: TFlowPanel;
    P1: TPanel;
    P2: TPanel;
    P3: TPanel;
    P4: TPanel;
    P5: TPanel;
    P6: TPanel;
    P7: TPanel;
    P8: TPanel;
    P9: TPanel;
    PStar: TPanel;
    P0: TPanel;
    PPlus: TPanel;
    P11: TPanel;
    P12: TPanel;
    P13: TPanel;
    L2: TLabel;
    L1: TLabel;
    L3: TLabel;
    L4: TLabel;
    L5: TLabel;
    L6: TLabel;
    L7: TLabel;
    L8: TLabel;
    L9: TLabel;
    Label10: TLabel;
    L0: TLabel;
    Label12: TLabel;
    Image1: TImage;
    Image2: TImage;
    procedure L1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Phone: TForm_Phone;

implementation

{$R *.dfm}

procedure TForm_Phone.Image1Click(Sender: TObject);
begin
    if Length(LPhone.Caption) > 0 then begin
        dwRunJS('window.location.href="tel:'+LPhone.Caption+'";',self);
    end;
end;

procedure TForm_Phone.Image2Click(Sender: TObject);
begin
    if Length(LPhone.Caption) > 0 then begin
        LPhone.Caption  := Copy(LPhone.Caption,1,Length(LPhone.Caption)-1);
    end;
end;

procedure TForm_Phone.L1Click(Sender: TObject);
begin
    LPhone.Caption  := LPhone.Caption + TLabel(Sender).Caption;
end;

end.
