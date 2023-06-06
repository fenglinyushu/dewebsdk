unit unit1;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, frxClass,
  frxExportBaseDialog, frxExportPDF, frxCross, Vcl.Grids;

type
  TForm1 = class(TForm)
    Button1: TButton;
    StringGrid1: TStringGrid;
    frxReport1: TfrxReport;
    frxCrossObject1: TfrxCrossObject;
    frxPDFExport1: TfrxPDFExport;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure frxReport1BeforePrint(Sender: TfrxReportComponent);
  private
    { Private declarations }
  public
    gsMainDir : String;
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    with frxPDFExport1 do begin
        DefaultPath := gsMainDir+'download\';
        FileName    := 'fastreport.pdf';
        ShowDialog  := False;
        ShowProgress:=False;
    end;

    //if frxReport1.LoadFromFile('D:\1.fr3') then
    if frxReport1.PrepareReport() then begin
        if frxReport1.Export(frxPDFExport1) then begin
            dwOpenUrl(self,'/pdf?file=/download/fastreport.pdf','_blank');
        end else begin
            dwMessage('Error when FastReport export to PDF','error',self);
        end;
    end;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
    //dwBase.dwSetMobileMode(self,414,736);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    i, j: Integer;
begin
    for i := 1 to 16 do begin
        for j := 1 to 16     do begin
            StringGrid1.Cells[i - 1, j - 1] := IntToStr(i * j);
        end;
    end;

end;

procedure TForm1.frxReport1BeforePrint(Sender: TfrxReportComponent);
var
  Cross: TfrxCrossView;
  i, j: Integer;
begin
  if Sender is TfrxCrossView then
  begin
    Cross := TfrxCrossView(Sender);
    for i := 1 to 16 do
      for j := 1 to 16 do
        Cross.AddValue([i], [j], [StringGrid1.Cells[i - 1, j - 1]]);
  end;
end;

end.
