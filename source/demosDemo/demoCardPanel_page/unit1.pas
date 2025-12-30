unit unit1;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, Vcl.WinXPanels;

type
  TForm1 = class(TForm)
    CP1: TCardPanel;
    Cd1: TCard;
    Cd2: TCard;
    Cd3: TCard;
    procedure CP1CardChange(Sender: TObject; PrevCard, NextCard: TCard);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.CP1CardChange(Sender: TObject; PrevCard, NextCard: TCard);
begin
    if Visible then begin
        //ShowMessage(NextCard.Name);
        dwMessage(NextCard.Name,'',self);
    end;
end;

end.
