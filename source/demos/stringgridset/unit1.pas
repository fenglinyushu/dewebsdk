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
    Panel_All: TPanel;
    Panel_StringGrid: TPanel;
    StringGrid1: TStringGrid;
    Edit_JS: TEdit;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
  private
  public

  end;

var
     Form1     : TForm1;


implementation


{$R *.dfm}




procedure TForm1.Button1Click(Sender: TObject);
begin
     dwRunJS(Edit_JS.Text,self);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     dwSGSetCellStyle(StringGrid1,0,0,clGreen,'����',20,True,False,clWhite);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     dwSGSetCellStyle(StringGrid1,4,1,clAqua,'����',20,False,False,clBlue);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     dwSGSetRow(StringGrid1,0,clLime,clRed);
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     dwSGSetCol(StringGrid1,3,clGray,clBlue);
     //dwSGSetCol(StringGrid1,0,clGray,clBlue);

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
          ColWidths[1]   := 220;
          ColWidths[2]   := 220;
          ColWidths[3]   := 220;
          ColWidths[4]   := 240;
     end;

end;



end.
