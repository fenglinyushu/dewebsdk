unit Unit_QuickCard;

interface

uses
    //
    dwBase,
    dwQuickCard,

    //
    SynCommons,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm_QuickCard = class(TForm)
    P0: TPanel;
    L0: TLabel;
    B0: TButton;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    //QuickCard 必须的变量
    qaConfig : string;
  end;

var
  Form_QuickCard: TForm_QuickCard;

implementation

{$R *.dfm}

uses
    Unit1;

procedure TForm_QuickCard.FormShow(Sender: TObject);
begin
    qaConfig    := StyleName;
    dwCard(self,TForm1(self.Owner).FDConnection1,False,'');

end;

end.
