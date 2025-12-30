unit unit1;

interface

uses
    //
    dwBase,

    //
    CloneComponents,


    //
    Math,
    Graphics,SysUtils,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button1: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Memo1Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    sCode   : string;
    slLines : TStringList;
    iDataB  : Integer;
    iDataE  : Integer;
    iRow    : Integer;
begin
    slLines := TStringList.Create;
    slLines.Text    := Memo1.Lines.Text;

    //查找 'data:[' 和对应的 ']'
    iDataB  := -1;
    for iRow := 0 to slLines.Count-1 do begin
        if iDataB = -1 then begin
            if Trim(slLines[iRow]) = 'data:[' then begin
                iDataB  := iRow;
            end;
        end else begin
            if Trim(slLines[iRow]) = ']' then begin
                iDataE  := iRow;
                break;
            end;
        end;
    end;

    //删除
    for iRow := iDataE -1 downto iDataB+1 do begin
        slLines.Delete(iRow);
    end;

    //添加新数据
    slLines.Insert(iDataB+1,'{name:''老河口市'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+2,'{name:''谷城县'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+3,'{name:''保康县'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+4,'{name:''南漳县'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+5,'{name:''襄城区'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+6,'{name:''樊城区'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+7,'{name:''襄州区'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+8,'{name:''宜城市'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+9,'{name:''襄州区'',value:'+IntToStr(Random(500))+'},');
    slLines.Insert(iDataB+10,'{name:''枣阳市'',value:'+IntToStr(Random(500))+'}');

    //
    //Memo1.Lines.Text    := slLines.Text;
    slLines.Destroy;

    //
    dwEchartsMap(Memo1);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    dwEcharts(memo1);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //浏览器尺寸变化事件


    //指定为PC模式
    dwSetPCMode(Self);
end;


procedure TForm1.Memo1Click(Sender: TObject);
begin
    if Pos('襄阳市',Memo1.ImeName)>0 then begin
        Memo1.Hint  := '{"geojson":"media/geojson/420600_full.json"}';
        Button1.Click();
        Button1.Visible := True;
        //
        dwEchartsMap(Memo1);
    end else begin
        if Button1.Visible then begin
            dwMessage(Memo1.ImeName,'success',self);
        end else begin
            dwMessage('请点击“襄阳市”！','error',self);
        end;
    end;
end;

end.
