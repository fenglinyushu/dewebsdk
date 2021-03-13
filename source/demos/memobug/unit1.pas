unit unit1;
interface
uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;
type
  TForm1 = class(TForm)
    Label1: TLabel;
    Memo1: TMemo;
    Memo2: TMemo;
    Button1: TButton;
    Memo3: TMemo;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
var
     Form1             : TForm1;

implementation

{$R *.dfm}
procedure TForm1.Button1Click(Sender: TObject);
var
     str:string;
begin
     str:=memo1.Text;
     //上面str 取值就已经不完整了
     //str:=StringReplace (str, '"', '&quot?', [rfReplaceAll]);
     Memo2.Text     := (str);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     Edit3.Text     := Edit2.Text;
     Button2.Caption     := Button2.Caption + '1';
end;

end.
