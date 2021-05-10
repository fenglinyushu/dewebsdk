unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.Menus, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit_Name: TEdit;
    Edit_GetName: TEdit;
    Panel1: TPanel;
    Label1: TLabel;
    Edit_Value: TEdit;
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
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
begin
    dwSetCookie(self,Edit_Name.Text,Edit_Value.Text,24);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    dwShowMessage(dwGetCookie(self,Edit_GetName.Text),self);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    dwShowMessage(self.Hint,self);
end;

end.
