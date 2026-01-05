unit unit1;

interface

uses
    //
    dwBase,

    //
    CloneComponents,


    //
    Math,
    Graphics,strutils,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    P_2: TPanel;
    P_1: TPanel;
    P_0: TPanel;
    P_000: TPanel;
    Label37: TLabel;
    P_00: TPanel;
    P_001: TPanel;
    L_302: TLabel;
    P_002: TPanel;
    L_300: TLabel;
    Memo1: TMemo;
    Label1: TLabel;
    Label25: TLabel;
    Memo2: TMemo;
    Memo3: TMemo;
    Label2: TLabel;
    Label3: TLabel;
    Memo4: TMemo;
    P_02: TPanel;
    Panel2: TPanel;
    Label4: TLabel;
    Memo5: TMemo;
    P_01: TPanel;
    P_04: TPanel;
    Panel5: TPanel;
    Label5: TLabel;
    P_03: TPanel;
    Memo6: TMemo;
    Panel1: TPanel;
    Panel3: TPanel;
    Label6: TLabel;
    StringGrid1: TStringGrid;
    Panel4: TPanel;
    Panel6: TPanel;
    Label7: TLabel;
    Memo7: TMemo;
    Memo8: TMemo;
    Panel7: TPanel;
    Panel8: TPanel;
    Label8: TLabel;
    Memo10: TMemo;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Timer1Timer(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    gsMainDir   : String;


    //<以下为动态数据变量，后面3位序号。 第1位为纵向行号，第2位为横向列号，第3位为序号

    //第0行-----------------------------------------------------------------------------------------
    //公开数据展示
    giD00   : array[0..6] of Integer;
    //公开服务数量
    giD01   : Integer;
    //统计数据展示
    giD02   : array[0..4] of Integer;

    //第1行-----------------------------------------------------------------------------------------
    //各自然村服务数据
    giD10   : array[0..3] of Integer;  //北京/上海/广州/深圳
    //中左饼图
    giD11   : array[0..4] of Integer;  //大营村/散洲村/康湾村/潼口村/郭河村
    //中右饼图
    giD12   : array[0..4] of Integer;  //张东/陈河/张西/柳林桥/黄桥
    //公开数据展示
    giD13   : array[0..4] of Integer;

    //第2行-----------------------------------------------------------------------------------------
    giD2    : array[0..3] of Integer;  //服务对象/服务项目/服务地点/服务类型

    //第3行-----------------------------------------------------------------------------------------
    //服务新闻
    gsD300  : String;
    gsD301  : String;
    gsD302  : String;
    gsD303  : String;
    gsD304  : String;
    gsD305  : String;
    //服务占比。中饼图
    giD31   : array[0..4] of Integer;  //张东/陈河/张西/柳林桥/黄桥;
    //服务热点
    gsD320  : String;
    gsD321  : String;
    gsD322  : String;
    gsD323  : String;
    gsD324  : String;
    gsD325  : String;

    //第4行-----------------------------------------------------------------------------------------
    //各自然村服务占比
    giD40   : array[0..4] of Integer;  //大营/康湾/张东/郭河/陈河

    //主动服务/被动服务/随机服务
    giD41   : array[0..4] of array[0..2] of Integer;  //大营/康湾/张东/郭河/陈河

    //上门服务/远程服务
    giD42   : array[0..4] of array[0..1] of Integer;  //大营/康湾/张东/郭河/陈河

    //各类服务公开数量
    giD43   : array[0..4] of array[0..3] of Integer;  //张东/陈河/郭河/康湾/大营
    //>
  end;

var
   Form1 : TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
var
     iR,iC     : Integer;
begin

     //
     Top  := 0;
     //
     with StringGrid1 do begin
          Cells[0,0]   := '';
          Cells[1,0]   := '城市';
          Cells[2,0]   := '区县';
          Cells[3,0]   := '数值';
          //
          Cells[0,1]   := '1';
          Cells[1,1]   := '阜新';
          Cells[2,1]   := '江北区';
          Cells[3,1]   := '498';
          //
          Cells[0,2]   := '2';
          Cells[1,2]   := '北京';
          Cells[2,2]   := '朝阳区';
          Cells[3,2]   := '487';
          //
          Cells[0,3]   := '3';
          Cells[1,3]   := '上海';
          Cells[2,3]   := '淞沪区';
          Cells[3,3]   := '446';
          //
          Cells[0,4]   := '4';
          Cells[1,4]   := '沈阳';
          Cells[2,4]   := '皇姑区';
          Cells[3,4]   := '423';
          //
          Cells[0,5]   := '5';
          Cells[1,5]   := '香港';
          Cells[2,5]   := '九龙区';
          Cells[3,5]   := '411';
          //
          Cells[0,6]   := '6';
          Cells[1,6]   := '兰州';
          Cells[2,6]   := '普华区';
          Cells[3,6]   := '408';
          //
          Cells[0,7]   := '7';
          Cells[1,7]   := '济南';
          Cells[2,7]   := '晋城区';
          Cells[3,7]   := '386';
          //
          Cells[0,8]   := '8';
          Cells[1,8]   := '大连';
          Cells[2,8]   := '大东区';
          Cells[3,8]   := '375';
          //
          Cells[0,9]   := '9';
          Cells[1,9]   := '西安';
          Cells[2,9]   := '灞桥区';
          Cells[3,9]   := '335';
          //
          ColWidths[0]   := 30;
          ColWidths[1]   := 70;
          ColWidths[2]   := 100;
          ColWidths[3]   := 80;
     end;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //刷新以启动动画
    DockSite        := True;
    //清除启动事件，以避免循环执行
    OnMouseDown    := nil;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);

end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
    I,J     : Integer;
    sJS     : string;
const
    _Names  : array[0..7] of String = ('大营','康湾','郭河','陈河','潼口','张东','柳林桥','张西');
begin
    Randomize();

    //更新数据======================================================================================
    //第0行-----------------------------------------------------------------------------------------
    //公开数据展示
    for I := 0 to 6 do begin
        giD00[I]    := Random(1000);
    end;
    //公开服务数量
    giD01   := 10000+Random(90000);
    //统计数据展示
    for I := 0 to 4 do begin
        giD02[I]    := Random(5000);
    end;

    //第1行-----------------------------------------------------------------------------------------
    //各自然村服务情况数据
    for I := 0 to 3 do begin
        giD10[I]    := Random(100);
    end;
    //
    for I := 0 to 4 do begin
        //中左环图
        giD11[I]    := Random(50);//(I+1)*10;//
        //中右玫瑰图
        giD12[I]    := 100+Random(50);
        //待公开数据
        giD13[I]    := Random(500);
    end;

    //第2行-----------------------------------------------------------------------------------------
    //服务对象 / 服务项目 / 服务地点 / 服务类型
    for I := 0 to 3 do begin
        giD2[I]     := 100+Random(500);
    end;

    //第3行-----------------------------------------------------------------------------------------
    //服务新闻
    gsD300  := _Names[random(8)]+' 村公开服务数据';
    gsD301  := FormatDateTime('YYYY-MM-DD',Now-Random(10));
    gsD302  := _Names[random(8)]+' 村公开服务数据';
    gsD303  := FormatDateTime('YYYY-MM-DD',Now-Random(20));
    gsD304  := _Names[random(8)]+' 村公开服务数据';
    gsD305  := FormatDateTime('YYYY-MM-DD',Now-Random(30));
    //服务占比
    for I := 0 to 4 do begin
        giD31[I]    := 100+Random(50);
    end;
    //服务热点
    gsD320  := _Names[random(8)]+' 村服务热点情况';
    gsD321  := FormatDateTime('YYYY-MM-DD',Now-Random(10));
    gsD322  := _Names[random(8)]+' 村服务热点情况';
    gsD323  := FormatDateTime('YYYY-MM-DD',Now-Random(20));
    gsD324  := _Names[random(8)]+' 村服务热点情况';
    gsD325  := FormatDateTime('YYYY-MM-DD',Now-Random(30));

    //第4行-----------------------------------------------------------------------------------------
    //各自然村服务占比
    for I := 0 to 4 do begin
        giD40[I]    := 20+Random(50);
    end;
    //主动服务/被动服务/随机服务
    for I := 0 to 4 do begin
        for J := 0 to 2 do begin
            giD41[I,J]    := 20+Random(50);
        end;
    end;
    //上门服务/远程服务
    for I := 0 to 4 do begin
        for J := 0 to 1 do begin
            giD42[I,J]    := 10+Random(50);
        end;
    end;
    //各类服务公开数量
    for I := 0 to 4 do begin
        for J := 0 to 3 do begin
            giD43[I,J]    := 100+Random(300);
        end;
    end;


    //刷新显示======================================================================================
    //第0行-----------------------------------------------------------------------------------------

    //第1行-----------------------------------------------------------------------------------------


    //第2行-----------------------------------------------------------------------------------------

    //第3行-----------------------------------------------------------------------------------------

    //第4行-----------------------------------------------------------------------------------------
end;

end.
