unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    var sParams := dwGetProp(Self,'params');
    sParams := dwUnescape(sParams);
    if Pos('file=',sParams)>0 then begin
        Delete(sParams,1,5);
        //{"src":"/dist/pdf/web/viewer.html?file=../../../media/doc/dwms/p1.pdf"}
        Panel1.Hint := '{"src":"/dist/pdf/web/viewer.html?file='+sParams+'"}';
    end;
end;

end.
