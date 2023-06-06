unit unit1;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.ButtonGroup, System.ImageList, Vcl.ImgList;

type
  TForm1 = class(TForm)
    BG: TButtonGroup;
    ImageList_dw: TImageList;
    Button1: TButton;
    procedure BGItems7Click(Sender: TObject);
    procedure BGItems0Click(Sender: TObject);
    procedure BGItems1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.BGItems0Click(Sender: TObject);
begin
    dwMessage('Home','',self);

end;

procedure TForm1.BGItems1Click(Sender: TObject);
begin
    dwMessage('Inventory','',self);

end;

procedure TForm1.BGItems7Click(Sender: TObject);
begin
    dwMessage('Info','',self);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
    BG.Width    := dwIIFi(BG.Width>60, 46, 200);
end;

end.
