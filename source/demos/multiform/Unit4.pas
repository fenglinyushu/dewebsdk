unit Unit4;

interface

uses
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm4 = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    procedure Edit1KeyPress(Sender: TObject; var Key: Char);
    procedure Edit2KeyPress(Sender: TObject; var Key: Char);
    procedure Edit3KeyPress(Sender: TObject; var Key: Char);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

procedure TForm4.Edit1KeyPress(Sender: TObject; var Key: Char);
begin
    if Key=#13 then begin
        dwsetfocus(Edit2);
    end;

end;

procedure TForm4.Edit2KeyPress(Sender: TObject; var Key: Char);
begin
    if Key=#13 then begin
        dwsetfocus(Edit3);
    end;

end;

procedure TForm4.Edit3KeyPress(Sender: TObject; var Key: Char);
begin
    if Key=#13 then begin
        dwsetfocus(Edit1);
    end;

end;

end.
