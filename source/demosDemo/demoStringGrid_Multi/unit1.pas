unit unit1;

interface

uses
    //
    dwBase,

    //
    Math,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
    Data.DB,
    Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    PC: TPageControl;
    TS_Demo: TTabSheet;
    TS_Doc: TTabSheet;
    Label2: TLabel;
    P_Banner: TPanel;
    Label1: TLabel;
    StringGrid1: TStringGrid;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure StringGrid1EndDrag(Sender, Target: TObject; X, Y: Integer);
    procedure StringGrid1EndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public

    gsMainDir   : String;
    goConnection    : TADOConnection;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.FormCreate(Sender: TObject);
var
    iRow    : Integer;
    iCol    : Integer;
begin
    with StringGrid1 do begin
        iCol    := 0;
        Cells[iCol,0]  :=
                '{'
                    +'"type":"check",'
                   +'"align":"center",'
                    +'"caption":"选择"'
                +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"label",'
                   +'"caption":"姓名"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"edit",'
                   +'"caption":"职务"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"spin",'
                   +'"caption":"年龄"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"combo",'
                   +'"caption":"角色",'
                   +'"list":["管理员","质管员","业务员"]'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"process",'
                   +'"caption":"工程进度"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"switch",'
                   +'"caption":"在岗"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"date",'
                   +'"caption":"入职日期"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"time",'
                   +'"caption":"时间"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"datetime",'
                   +'"caption":"最后登录"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"spin",'
                   +'"caption":"月薪"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"spin",'
                   +'"caption":"月数"'
               +'}';
        Inc(iCol);
        Cells[iCol,0]  :=
               '{'
                   +'"type":"calc",'
                   +'"mode":"*",'
                   +'"column":[10,11],'
                   +'"k":[1,1],'
                   +'"decimal":-1,' //-1表示使用format %n
                   +'"align":"right",'
                   +'"caption":"全年薪资"'
               +'}';

        Inc(iCol);
        Cells[iCol,0]  :=
                '{'
                    +'"type":"button",'
                    +'"caption":"操作",'
                    +'"items":[["增加","primary",40],["减少","success",40],["删除","danger",40]]'
                +'}';
        //
        ColWidths[0]    := 40;
        ColWidths[1]    := 60;
        ColWidths[4]    := 120;
        ColWidths[5]    := 160;
        ColWidths[6]    := 60;
        ColWidths[7]    := 120;
        ColWidths[8]    := 120;
        ColWidths[9]    := 200;
        ColWidths[10]   := 100;
        ColWidths[12]   := 100;

        //
        iRow    := 1;
        Cells[0,iRow]   := 'True';
        Cells[1,iRow]   := '李宏杉';
        Cells[2,iRow]   := '总经理';
        Cells[3,iRow]   := '52';
        Cells[4,iRow]   := '管理员';
        Cells[5,iRow]   := '98';
        Cells[6,iRow]   := 'False';
        Cells[7,iRow]   := '2024-03-12';
        Cells[8,iRow]   := '22:45:08';
        Cells[9,iRow]   := '1994-04-03 08:08:08';
        Cells[10,iRow]  := '28110';
        Cells[11,iRow]  := '13';
        Cells[12,iRow]  := '';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'False';
        Cells[1,iRow]  := '张志军';
        Cells[2,iRow]  := '经理';
        Cells[3,iRow]  := '48';
        Cells[4,iRow]  := '质管员';
        Cells[5,iRow]  := '86';
        Cells[6,iRow]  := 'True';
        Cells[7,iRow]   := '2021-01-02';
        Cells[8,iRow]   := '12:45:23';
        Cells[9,iRow]   := '1999-04-03 18:23:12';
        Cells[10,iRow]  := '4567';
        Cells[11,iRow]  := '12';
        Cells[12,iRow]  := '';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'True';
        Cells[1,iRow]  := '万明';
        Cells[2,iRow]  := '主管';
        Cells[3,iRow]  := '36';
        Cells[4,iRow]  := '业务员';
        Cells[5,iRow]  := '76';
        Cells[6,iRow]  := 'False';
        Cells[7,iRow]   := '2035-05-02';
        Cells[8,iRow]   := '12:12:12';
        Cells[9,iRow]   := '2024-02-13 18:23:12';
        Cells[10,iRow]  := '7654';
        Cells[11,iRow]  := '12';
        Cells[12,iRow]  := '';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'True';
        Cells[1,iRow]  := '马明竞';
        Cells[2,iRow]  := '经理';
        Cells[3,iRow]  := '26';
        Cells[4,iRow]  := '业务员';
        Cells[5,iRow]  := '86';
        Cells[6,iRow]  := 'False';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'False';
        Cells[1,iRow]  := '李一辰';
        Cells[2,iRow]  := '经理';
        Cells[3,iRow]  := '45';
        Cells[4,iRow]  := '质管员';
        Cells[5,iRow]  := '82';
        Cells[6,iRow]  := 'True';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'True';
        Cells[1,iRow]  := '邓有为';
        Cells[2,iRow]  := '主管';
        Cells[3,iRow]  := '32';
        Cells[4,iRow]  := '业务员';
        Cells[5,iRow]  := '48';
        Cells[6,iRow]  := 'False';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'True';
        Cells[1,iRow]  := '赵丰';
        Cells[2,iRow]  := '经理';
        Cells[3,iRow]  := '46';
        Cells[4,iRow]  := '业务员';
        Cells[5,iRow]  := '36';
        Cells[6,iRow]  := 'False';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'True';
        Cells[1,iRow]  := '张小丰';
        Cells[2,iRow]  := '主管';
        Cells[3,iRow]  := '36';
        Cells[4,iRow]  := '业务员';
        Cells[5,iRow]  := '76';
        Cells[6,iRow]  := 'False';
        //
        Inc(iRow);
        Cells[0,iRow]  := 'True';
        Cells[1,iRow]  := '张楠';
        Cells[2,iRow]  := '经理';
        Cells[3,iRow]  := '35';
        Cells[4,iRow]  := '业务员';
        Cells[5,iRow]  := '55';
        Cells[6,iRow]  := 'False';
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.StringGrid1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    dwMessage(Format('after Col=%d,Row=%d',[X,Y]),'success',self);

end;

procedure TForm1.StringGrid1EndDrag(Sender, Target: TObject; X, Y: Integer);
begin
    dwMessage(Format('Col=%d,Row=%d',[X,Y]),'info',self);
end;

end.
