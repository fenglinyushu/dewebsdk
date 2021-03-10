unit unit1;

interface

uses

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Panel2: TPanel;
    Button9: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    procedure Button7Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button8Click(Sender: TObject);
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
begin
     if Label2.Alignment = taCenter then begin
          Label2.Alignment    := taRightJustify;
     end else if Label2.Alignment = taRightJustify then begin
          Label2.Alignment    := taLeftJustify;
     end else begin
          Label2.Alignment    := taCenter;
     end;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     if fsStrikeOut in Label2.Font.Style then begin
          Label2.Font.Style   := [];
     end else begin
          Label2.Font.Style   := [fsStrikeOut];
     end;

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     if fsUnderLine in Label2.Font.Style then begin
          Label2.Font.Style   := [];
     end else begin
          Label2.Font.Style   := [fsUnderLine];
     end;

end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     if fsItalic in Label2.Font.Style then begin
          Label2.Font.Style   := [];
     end else begin
          Label2.Font.Style   := [fsItalic];
     end;

end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     if fsBold in Label2.Font.Style then begin
          Label2.Font.Style   := [];
     end else begin
          Label2.Font.Style   := [fsBold];
     end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     Label2.Font.Size   := 8+Random(20);
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
     Randomize;
     Label2.Font.Color   := Random($FFFFFF);
end;

procedure TForm1.Button8Click(Sender: TObject);
begin
     if Label2.Font.Name = 'Arial' then begin
          Label2.Font.Name    := 'Georgia';
     end else begin
          Label2.Font.Name    := 'Arial';
     end;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := Min(360,X);
     Height    := Y;
end;

end.
