unit unit1;

interface

uses
     //
     dwBase,
     dwSGUnit,      //StringGrid���Ƶ�Ԫ

     
     //

     //
     Math,
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, jpeg, ExtCtrls,  Vcl.Grids,
     Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Label_Demo: TLabel;
    Panel_Logo: TPanel;
    Image1: TImage;
    Label6: TLabel;
    Panel2: TPanel;
    Button_Position: TButton;
    Button_Size: TButton;
    Button_Visible: TButton;
    Panel_All: TPanel;
    Panel_StringGrid: TPanel;
    StringGrid1: TStringGrid;
    Panel1: TPanel;
    Button_Get: TButton;
    Button_Set: TButton;
    Button_Clear: TButton;
    Button_SetCells: TButton;
    Button_GetRow: TButton;
    Button_SetRow: TButton;
    Button_AddRow: TButton;
    Button_DelRow: TButton;
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure Button_PositionClick(Sender: TObject);
    procedure Button_SizeClick(Sender: TObject);
    procedure Button_VisibleClick(Sender: TObject);
    procedure Button_EnabledClick(Sender: TObject);
    procedure Button_GetClick(Sender: TObject);
    procedure Button_SetClick(Sender: TObject);
    procedure Button_ClearClick(Sender: TObject);
    procedure Button_SetCellsClick(Sender: TObject);
    procedure Button_SetRowClick(Sender: TObject);
    procedure Button_GetRowClick(Sender: TObject);
    procedure Button_AddRowClick(Sender: TObject);
    procedure Button_DelRowClick(Sender: TObject);
  private
  public

  end;

var
     Form1     : TForm1;


implementation


{$R *.dfm}




procedure TForm1.Button_AddRowClick(Sender: TObject);
begin
     dwSGAddRow(StringGrid1);
     //dwRunJS('var list = {};this.'+StringGrid1.Name+'__ces.push(list);',self);
end;

procedure TForm1.Button_ClearClick(Sender: TObject);
var
     iR,iC     : Integer;
begin
     for iR := 1 to StringGrid1.RowCount-1 do begin
          for iC := 0 to StringGrid1.ColCount-1 do begin
               StringGrid1.Cells[iC,iR] := '';
          end;
     end;

end;

procedure TForm1.Button_DelRowClick(Sender: TObject);
begin
     dwSGDelRow(StringGrid1);
     //dwRunJS('this.'+StringGrid1.Name+'__ces.splice(3, 1);',self);
end;

procedure TForm1.Button_EnabledClick(Sender: TObject);
begin
     with StringGrid1 do begin
          Enabled   := not Enabled;
     end;

end;

procedure TForm1.Button_GetClick(Sender: TObject);
begin
     dwShowMessage(StringGrid1.Cells[2,2],self);
end;

procedure TForm1.Button_GetRowClick(Sender: TObject);
begin
     dwShowMessage('Row : '+IntToStr(StringGrid1.Row),self);

end;

procedure TForm1.Button_PositionClick(Sender: TObject);
begin
     With StringGrid1 do begin
          Left := Left + 5;
          Top  := Top + 5;
     end;
end;

procedure TForm1.Button_SetCellsClick(Sender: TObject);
var
     iR,iC     : Integer;
begin
     //
     for iR := 1 to StringGrid1.RowCount-1 do begin
          for iC := 0 to StringGrid1.ColCount-1 do begin
               StringGrid1.Cells[iC,iR] := Format('λ%d,%d',[iR,iC]);
          end;
     end;

end;

procedure TForm1.Button_SetClick(Sender: TObject);
begin
     StringGrid1.Cells[2,2]   := IntToStr(GetTickCount);
end;

procedure TForm1.Button_SetRowClick(Sender: TObject);
begin
     with StringGrid1 do begin
          if Row<RowCount-1 then begin
               Row     := Row + 1;
          end else begin
               Row  := 1;
          end;
     end;
end;

procedure TForm1.Button_SizeClick(Sender: TObject);
begin
     With StringGrid1 do begin
          Width     := Width + 5;
          Height    := Height + 5;
     end;

end;

procedure TForm1.Button_VisibleClick(Sender: TObject);
begin
     with StringGrid1 do begin
          Visible   := not Visible;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     iR,iC     : Integer;
begin

     //
     Top  := 0;
     //
     with StringGrid1 do begin
          Cells[0,0]   := '����';
          Cells[1,0]   := '����';
          Cells[2,0]   := 'ʡ��';
          Cells[3,0]   := '����';
          Cells[4,0]   := '��ϸ��ַ';
          //
          Cells[0,1]   := '2000-01-01';
          Cells[1,1]   := '������';
          Cells[2,1]   := '����';
          Cells[3,1]   := '����';
          Cells[4,1]   := '�����ְ칫��01001��';
          //
          Cells[0,2]   := '2001-07-01';
          Cells[1,2]   := '�ѧ';
          Cells[2,2]   := '����';
          Cells[3,2]   := '������';
          Cells[4,2]   := '�̲ݹ�˾פ��¥2901��';
          //
          Cells[0,3]   := '2002-12-01';
          Cells[1,3]   := '������';
          Cells[2,3]   := '�Ϻ�';
          Cells[3,3]   := '������';
          Cells[4,3]   := '��̲��������ֹ���';
          //
          Cells[0,4]   := '2006-03-01';
          Cells[1,4]   := 'л�᷼';
          Cells[2,4]   := '����';
          Cells[3,4]   := '����';
          Cells[4,4]   := '�񺽹������ļ����9901';
          //
          Cells[0,5]   := '2007-03-01';
          Cells[1,5]   := '������';
          Cells[2,5]   := '���';
          Cells[3,5]   := '����';
          Cells[4,5]   := '���߼���';
          //
          Cells[0,6]   := '2008-03-01';
          Cells[1,6]   := '���»�';
          Cells[2,6]   := '����';
          Cells[3,6]   := '����';
          Cells[4,6]   := '���ز���˾פ��¥1212��';
          //
          Cells[0,7]   := '2009-03-01';
          Cells[1,7]   := '����ΰ';
          Cells[2,7]   := 'ɽ��';
          Cells[3,7]   := '����';
          Cells[4,7]   := '��������';
          //
          Cells[0,8]   := '2010-03-01';
          Cells[1,8]   := '����';
          Cells[2,8]   := '����';
          Cells[3,8]   := '����';
          Cells[4,8]   := '���ڹ�����';
          //
          Cells[0,9]   := '2011-03-01';
          Cells[1,9]   := '����';
          Cells[2,9]   := '����';
          Cells[3,9]   := '�˳�';
          Cells[4,9]   := '�ۺ����չ�������';
          //
          ColWidths[0]   := 100;
          ColWidths[1]   := 120;
          ColWidths[2]   := 120;
          ColWidths[3]   := 120;
          ColWidths[4]   := 240;
     end;

     //

     //
     dwSetHeight(Self,1200);
end;



procedure TForm1.StringGrid1Click(Sender: TObject);
var
     iRow      : Integer;
begin
     iRow      := StringGrid1.Row;
     if iRow < StringGrid1.RowCount then begin
     end else begin
     end;
end;

end.
