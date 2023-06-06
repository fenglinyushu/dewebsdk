unit Unit_Show;

interface

uses
    //
    dwBase,

    //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm_Show = class(TForm)
    Edit1: TEdit;
    Panel1: TPanel;
    Button1: TButton;
    Button2: TButton;
    CheckBox1: TCheckBox;
    Memo1: TMemo;
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TForm_Show.Button1Click(Sender: TObject);
begin
    dwRunJS('this.'+Self.Name+'__vis = false;',self);

end;

procedure TForm_Show.Button2Click(Sender: TObject);
begin
    dwRunJS('this.'+Self.Name+'__vis = false;',self);
end;

end.
