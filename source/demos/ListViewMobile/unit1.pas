unit unit1;

interface

uses
     dwBase,
     SynCommons,    //第三方的JSON解析单元
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.Grids,
  Data.DB, Vcl.DBGrids, Data.Win.ADODB, Vcl.DBCtrls;

type
  TForm1 = class(TForm)
    LV: TListView;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure LVEndDrag(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
var
    sDATA   : string;
    joData  : Variant;
    I,J     : Integer;
begin

    sData   := concat(
            '[',
                '["理疗仪",       "LQP1-12","台","233.5", "沈阳金德日化公司        ", "g1" ],',
                '["空气炸锅",     "ZG2108","台", "233.5", "西安迈华科技信息有限公司", "g2" ],',
                '["长虹电视机",   "CH2588","台", "1688" , "襄阳奥的斯              ", "g3" ],',
                '["史密斯热水器", "SMS380","部", "215"  , "华为管业                ", "g4" ],',
                '["空调",         "Green7","台", "1986" , "沈阳金德日化公司        ", "g5" ],',
                '["海尔热水器",   "GL9180","部", "215"  , "西安迈华科技信息有限公司", "g6" ],',
                '["净水管",       "GD2505","米", "99"   , "华美科技                ", "g7" ],',
                '["格力空调",     "Green5","台", "2318" , "华为管业                ", "g8" ],',
                '["IBM笔记本",    "TX-268","台", "9999" , "西安迈华科技信息有限公司", "g9" ],',
                '["LG笔记本",     "LG1730","台", "99"   , "华美科技                ", "g10"]',
            ']');

    joData  := _json(sData);
    //
    for I:= 0 to joData._Count-1 do begin
        with LV.Items.Add do begin
            Caption := joData._(I)._(0);
            for J:=1 to joData._(I)._Count-1 do begin
                SubItems.Add(joData._(I)._(J));
            end;
        end;
    end;


end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //
    dwSetMobileMode(self,360,740);
end;

procedure TForm1.LVEndDrag(Sender, Target: TObject; X, Y: Integer);
begin
    //
    dwMessage(Format('OnEndDrag X:%d,Y:%d',[X,Y]),'success',self);

end;

end.
