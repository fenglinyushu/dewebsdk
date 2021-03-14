unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls, Vcl.Grids, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteDef, FireDAC.Phys, FireDAC.Phys.SQLite, FireDAC.UI.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.VCLUI.Wait, Datasnap.Provider,
  Data.Win.ADODB;

type
  TForm1 = class(TForm)
    LabeledEdit1: TLabeledEdit;
    LabeledEdit2: TLabeledEdit;
    LabeledEdit3: TLabeledEdit;
    LabeledEdit4: TLabeledEdit;
    Panel_02_Buttons: TPanel;
    Button2: TButton;
    Button5: TButton;
    Button6: TButton;
    Label_Event: TLabel;
    Button1: TButton;
    Button3: TButton;
    Button4: TButton;
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure LabeledEdit4Change(Sender: TObject);
    procedure LabeledEdit4MouseEnter(Sender: TObject);
    procedure LabeledEdit4MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  goConnection:TFDConnection;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
     with LabeledEdit4 do begin
          Enabled   := not  Enabled;
     end;

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     with LabeledEdit4 do begin
          Visible   := not  Visible;
     end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     dwShowMessage(LabeledEdit4.Text,self);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     LabeledEdit4.Text   := '"<'+IntToStr(GetTickCount)+'''>';
     LabeledEdit4.EditLabel.Caption     := 'DW'+IntToStr(GetTickCount mod 100);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     with LabeledEdit4 do begin
          Width     := Width + 5;
          Height    := Height + 5;
     end;

end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     with LabeledEdit4 do begin
          Left := Left + 5;
          Top  := Top + 5;
     end;
end;

procedure TForm1.LabeledEdit4Change(Sender: TObject);
begin
     Label_Event.Caption := 'OnChange';
end;

procedure TForm1.LabeledEdit4MouseEnter(Sender: TObject);
begin
     Label_Event.Caption := 'OnMouseEnter';

end;

procedure TForm1.LabeledEdit4MouseLeave(Sender: TObject);
begin
     Label_Event.Caption := 'OnMouseLeave';

end;

end.
