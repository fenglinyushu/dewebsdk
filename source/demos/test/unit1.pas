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
    SG1: TStringGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
     SG1.Cells[0,0] := '0';
     SG1.Cells[1,0] := '1';
     SG1.Cells[0,1] := 'A';
     SG1.Cells[1,1] := 'B';
     SG1.Cells[0,2] := 'AA';
     SG1.Cells[1,2] := 'BB';

end;

end.
