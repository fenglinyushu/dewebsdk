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
    SG2: TStringGrid;
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
     iR,iC     : Integer;
begin

     //
     Top  := 0;
     //
     with SG1 do begin
          Cells[0,0]   := '日期';
          Cells[1,0]   := '姓名';
          Cells[2,0]   := '省份';
          Cells[3,0]   := '城市';
          Cells[4,0]   := '数量';
          //
          Cells[0,1]   := '2000-01-01';
          Cells[1,1]   := '张云政';
          Cells[2,1]   := '湖北';
          Cells[3,1]   := '襄阳';
          Cells[4,1]   := '8900';
          //
          Cells[0,2]   := '2001-07-01';
          Cells[1,2]   := '李景学';
          Cells[2,2]   := '北京';
          Cells[3,2]   := '朝阳区';
          Cells[4,2]   := '6700';
          //
          Cells[0,3]   := '2002-12-01';
          Cells[1,3]   := '周子琴';
          Cells[2,3]   := '上海';
          Cells[3,3]   := '淞沪区';
          Cells[4,3]   := '7654';
          //
          Cells[0,4]   := '2006-03-01';
          Cells[1,4]   := '谢玲芳';
          Cells[2,4]   := '辽宁';
          Cells[3,4]   := '沈阳';
          Cells[4,4]   := '12345';
          //
          Cells[0,5]   := '2007-03-01';
          Cells[1,5]   := '张曼玉';
          Cells[2,5]   := '香港';
          Cells[3,5]   := '九龙';
          Cells[4,5]   := '66666';
          //
          Cells[0,6]   := '2008-03-01';
          Cells[1,6]   := '刘德华';
          Cells[2,6]   := '甘肃';
          Cells[3,6]   := '兰州';
          Cells[4,6]   := '77777';
          //
          Cells[0,7]   := '2009-03-01';
          Cells[1,7]   := '梁朝伟';
          Cells[2,7]   := '山东';
          Cells[3,7]   := '济南';
          Cells[4,7]   := '888';
          //
          Cells[0,8]   := '2010-03-01';
          Cells[1,8]   := '张益';
          Cells[2,8]   := '辽宁';
          Cells[3,8]   := '大连';
          Cells[4,8]   := '21000';
          //
          Cells[0,9]   := '2011-03-01';
          Cells[1,9]   := '贾玲';
          Cells[2,9]   := '湖北';
          Cells[3,9]   := '宜城';
          Cells[4,9]   := '999999';
          //
          ColWidths[0]   := 100;
          ColWidths[1]   := 80;
          ColWidths[2]   := 80;
          ColWidths[3]   := 80;
          ColWidths[4]   := 90;
     end;
     //
     with SG2 do begin
          Cells[0,0]   := '日期';
          Cells[1,0]   := '姓名';
          Cells[2,0]   := '省份';
          Cells[3,0]   := '城市';
          Cells[4,0]   := '数量';
          //
          Cells[0,1]   := '2000-01-01';
          Cells[1,1]   := '张云政';
          Cells[2,1]   := '湖北';
          Cells[3,1]   := '襄阳';
          Cells[4,1]   := '8900';
          //
          Cells[0,2]   := '2001-07-01';
          Cells[1,2]   := '李景学';
          Cells[2,2]   := '北京';
          Cells[3,2]   := '朝阳区';
          Cells[4,2]   := '6700';
          //
          Cells[0,3]   := '2002-12-01';
          Cells[1,3]   := '周子琴';
          Cells[2,3]   := '上海';
          Cells[3,3]   := '淞沪区';
          Cells[4,3]   := '7654';
          //
          Cells[0,4]   := '2006-03-01';
          Cells[1,4]   := '谢玲芳';
          Cells[2,4]   := '辽宁';
          Cells[3,4]   := '沈阳';
          Cells[4,4]   := '12345';
          //
          Cells[0,5]   := '2007-03-01';
          Cells[1,5]   := '张曼玉';
          Cells[2,5]   := '香港';
          Cells[3,5]   := '九龙';
          Cells[4,5]   := '66666';
          //
          Cells[0,6]   := '2008-03-01';
          Cells[1,6]   := '刘德华';
          Cells[2,6]   := '甘肃';
          Cells[3,6]   := '兰州';
          Cells[4,6]   := '77777';
          //
          Cells[0,7]   := '2009-03-01';
          Cells[1,7]   := '梁朝伟';
          Cells[2,7]   := '山东';
          Cells[3,7]   := '济南';
          Cells[4,7]   := '888';
          //
          Cells[0,8]   := '2010-03-01';
          Cells[1,8]   := '张益';
          Cells[2,8]   := '辽宁';
          Cells[3,8]   := '大连';
          Cells[4,8]   := '21000';
          //
          Cells[0,9]   := '2011-03-01';
          Cells[1,9]   := '贾玲';
          Cells[2,9]   := '湖北';
          Cells[3,9]   := '宜城';
          Cells[4,9]   := '999999';
          //
          ColWidths[0]   := 100;
          ColWidths[1]   := 80;
          ColWidths[2]   := 80;
          ColWidths[3]   := 80;
          ColWidths[4]   := 90;
     end;
end;

end.
