unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Menus;

type
  TForm1 = class(TForm)
    cbb: TComboBox;
    Button1: TButton;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
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
var
     s,c  : String;
begin
     s    := '字符串';
     cbb.Items.Add(s);
     s    := '转char';
     cbb.Items.Add(pchar(s));
     c    := 'char';
     cbb.Items.Add(c);
     c    := 'char2';
     cbb.Items.Add(c);
     cbb.Items.Add('23111111');
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     dwShowMessage(cbb.Text,self);
end;

end.
