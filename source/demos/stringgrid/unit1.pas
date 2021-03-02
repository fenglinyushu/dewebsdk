unit unit1;

interface

uses
     //
     dwBase,
     dwSGUnit,      //StringGrid控制单元

     
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
               StringGrid1.Cells[iC,iR] := Format('位%d,%d',[iR,iC]);
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
          Cells[0,0]   := '日期';
          Cells[1,0]   := '姓名';
          Cells[2,0]   := '省份';
          Cells[3,0]   := '城市';
          Cells[4,0]   := '详细地址';
          //
          Cells[0,1]   := '2000-01-01';
          Cells[1,1]   := '张云政';
          Cells[2,1]   := '湖北';
          Cells[3,1]   := '襄阳';
          Cells[4,1]   := '电力局办公室01001号';
          //
          Cells[0,2]   := '2001-07-01';
          Cells[1,2]   := '李景学';
          Cells[2,2]   := '北京';
          Cells[3,2]   := '朝阳区';
          Cells[4,2]   := '烟草公司驻外楼2901室';
          //
          Cells[0,3]   := '2002-12-01';
          Cells[1,3]   := '周子琴';
          Cells[2,3]   := '上海';
          Cells[3,3]   := '淞沪区';
          Cells[4,3]   := '外滩管理事务局管理处';
          //
          Cells[0,4]   := '2006-03-01';
          Cells[1,4]   := '谢玲芳';
          Cells[2,4]   := '辽宁';
          Cells[3,4]   := '沈阳';
          Cells[4,4]   := '民航管理中心监察室9901';
          //
          Cells[0,5]   := '2007-03-01';
          Cells[1,5]   := '张曼玉';
          Cells[2,5]   := '香港';
          Cells[3,5]   := '九龙';
          Cells[4,5]   := '无线集团';
          //
          Cells[0,6]   := '2008-03-01';
          Cells[1,6]   := '刘德华';
          Cells[2,6]   := '甘肃';
          Cells[3,6]   := '兰州';
          Cells[4,6]   := '房地产公司驻外楼1212室';
          //
          Cells[0,7]   := '2009-03-01';
          Cells[1,7]   := '梁朝伟';
          Cells[2,7]   := '山东';
          Cells[3,7]   := '济南';
          Cells[4,7]   := '数据中心';
          //
          Cells[0,8]   := '2010-03-01';
          Cells[1,8]   := '张益';
          Cells[2,8]   := '辽宁';
          Cells[3,8]   := '大连';
          Cells[4,8]   := '金融管理大队';
          //
          Cells[0,9]   := '2011-03-01';
          Cells[1,9]   := '贾玲';
          Cells[2,9]   := '湖北';
          Cells[3,9]   := '宜城';
          Cells[4,9]   := '综合演艺管理中心';
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
