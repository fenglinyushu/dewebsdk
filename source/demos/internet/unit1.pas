﻿unit unit1;

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
    MainMenu: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    N2: TMenuItem;
    N4: TMenuItem;
    Panel1: TPanel;
    N1: TMenuItem;
    N3: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    Image1: TImage;
    Label1: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel4: TPanel;
    Label2: TLabel;
    Edit1: TEdit;
    Label3: TLabel;
    Edit2: TEdit;
    Label4: TLabel;
    Label5: TLabel;
    Edit4: TEdit;
    ComboBox1: TComboBox;
    Button1: TButton;
    StringGrid1: TStringGrid;
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
var
     iRow : Integer;
begin
     dwSetCompLTWH(MainMenu,0,60,250,500);
     //
     with StringGrid1 do begin
          Cells[0,0]     := '序号';
          Cells[1,0]     := '公司名称';
          Cells[2,0]     := '工号';
          Cells[3,0]     := '人员姓名';
          Cells[4,0]     := '身份证号';
          //
          ColWidths[0]   := 60;
          ColWidths[1]   := 230;
          ColWidths[2]   := 140;
          ColWidths[3]   := 80;
          ColWidths[4]   := 215;
          //
          for iRow := 1 to 10 do begin
               Cells[0,iRow]  := '  '+IntToStr(iRow);
               if iRow mod 2 =1 then begin
                    Cells[1,iRow]     := '西安迈华信息科技有限公司';
                    Cells[2,iRow]     := 'MH001';
                    Cells[3,iRow]     := '江远';
                    Cells[4,iRow]     := '420621200001011234';
               end else begin
                    //
                    Cells[1,iRow]     := '微软（中国）有限公司';
                    Cells[2,iRow]     := 'MS3345003';
                    Cells[3,iRow]     := '张比尔';
                    Cells[4,iRow]     := '610111200001011234';
               end;
          end;
     end;
end;

end.
