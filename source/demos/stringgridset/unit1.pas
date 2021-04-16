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
     dwSGSetCellStyle(StringGrid1,0,0,clGreen,'宋体',20,True,False,clWhite);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
     dwSGSetCellStyle(StringGrid1,4,1,clAqua,'隶书',20,False,False,clBlue);
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
          ColWidths[1]   := 220;
          ColWidths[2]   := 220;
          ColWidths[3]   := 220;
          ColWidths[4]   := 240;
     end;

end;



end.
