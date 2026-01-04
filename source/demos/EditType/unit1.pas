unit unit1;

interface

uses
    //
    dwBase,

    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
    Vcl.Menus, Vcl.Imaging.jpeg, Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Edit2: TEdit;
    Edit3: TEdit;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Edit7: TEdit;
    Edit8: TEdit;
    Label8: TLabel;
    P0_Header: TPanel;
    Label_Header: TLabel;
    procedure Edit2Change(Sender: TObject);
    procedure Edit3Change(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure Edit4Change(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit6Change(Sender: TObject);
    procedure Edit7Change(Sender: TObject);
    procedure Edit8Change(Sender: TObject);
  private
    { Private declarations }
  public
    gsMainDir   : string;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Edit1Change(Sender: TObject);
begin
    Label1.Caption  := Edit1.Text;

end;

procedure TForm1.Edit2Change(Sender: TObject);
begin
    Label2.Caption  := Edit2.Text;
end;

procedure TForm1.Edit3Change(Sender: TObject);
begin
    Label3.Caption  := Edit3.Text;

end;

procedure TForm1.Edit4Change(Sender: TObject);
begin
    Label4.Caption  := Edit4.Text;

end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
    Label5.Caption  := Edit5.Text;

end;

procedure TForm1.Edit6Change(Sender: TObject);
begin
    Label6.Caption  := Edit6.Text;

end;

procedure TForm1.Edit7Change(Sender: TObject);
begin
    Label7.Caption  := Edit7.Text;

end;

procedure TForm1.Edit8Change(Sender: TObject);
begin
    Label8.Caption  := Edit8.Text;
end;

end.
