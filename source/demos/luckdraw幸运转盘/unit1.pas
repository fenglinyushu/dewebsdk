unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Buttons, Data.DB, Data.Win.ADODB;

type
  TForm1 = class(TForm)
    SG: TStringGrid;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure SGEndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
var
    I   : Integer;
begin
    //行数为为红包数量
    for I:=1 to 8 do begin
        with sg do begin
            //第一列,红包标题
            Cells[0,I-1]  := (I*10).ToString+'元红包';
            //第二列,红包区颜色
            if I mod 2 = 0 then begin
                Cells[1,I-1]  := '#f9e3bb';
            end else begin
                Cells[1,I-1]  := '#f8d384';
            end;
            //第三列, 红包显示文本
            Cells[2,I-1]    := (I*10).ToString+'元红包';
            //文本顶部距离,建议10%
            Cells[3,I-1]    := '10%';
            //红包图片
            Cells[4,I-1]    := 'media/images/luck/'+(I-1).ToString+'.png';
            //红包图片宽度, 建议30%
            Cells[5,I-1]    := '30%';
            //红包图片顶部距离 , 建议45%
            Cells[6,I-1]    := '45%';
        end;
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置为移动端模式,如果电脑访问,则为  414x736
    dwSetMobileMode(self,414,736);

    //确保不大于300
    if SG.Width>300 then begin
        SG.Margins.Left     := (Width - 300) div 2;
        SG.Margins.Right    := SG.Margins.Left;
    end;
    SG.Height   := SG.Width;
end;

procedure TForm1.SGEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //结束后自动激活该事件
    dwShowMessage('恭喜！您获得了'+SG.Cells[0,X],self);
end;

end.
