unit Unit2;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Label2: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Edit3: TEdit;
    Label4: TLabel;
    Label1: TLabel;
    ComboBox1: TComboBox;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

uses
     Unit1;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
     if (Edit1.Text = 'admin')and(Edit2.Text='12345') then begin
          Form1.Button1.Caption    := 'User Checked';
          dwRunJS('this.'+TForm(Button1.Owner).Name+'__vis=false;',self);
          //dwCloseForm(Form1,
     end else begin
          dwShowMessage('User/Password invalid! admin/12345',self);
     end;
end;

end.
