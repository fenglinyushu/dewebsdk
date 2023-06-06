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
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus, VclTee.TeeGDIPlus,
  VCLTee.TeEngine, VCLTee.Series, VCLTee.TeeProcs, VCLTee.Chart, Data.DB, Vcl.DBGrids, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    P_0: TPanel;
    Timer1: TTimer;
    Panel8: TPanel;
    Panel9: TPanel;
    Label14: TLabel;
    Panel10: TPanel;
    L_000: TLabel;
    L_002: TLabel;
    L_001: TLabel;
    Panel11: TPanel;
    L_003: TLabel;
    L_006: TLabel;
    L_004: TLabel;
    L_005: TLabel;
    Panel12: TPanel;
    Panel13: TPanel;
    Label22: TLabel;
    Panel14: TPanel;
    L_020: TLabel;
    L_021: TLabel;
    Panel15: TPanel;
    L_022: TLabel;
    L_024: TLabel;
    L_023: TLabel;
    Panel16: TPanel;
    Panel17: TPanel;
    Label25: TLabel;
    Image1: TImage;
    Panel1: TPanel;
    Label1: TLabel;
    Panel2: TPanel;
    L_014: TLabel;
    Panel3: TPanel;
    L_013: TLabel;
    Panel4: TPanel;
    L_012: TLabel;
    Panel5: TPanel;
    L_011: TLabel;
    Panel6: TPanel;
    L_010: TLabel;
    Panel7: TPanel;
    Panel18: TPanel;
    Panel19: TPanel;
    Label7: TLabel;
    Panel22: TPanel;
    Panel23: TPanel;
    Label30: TLabel;
    Panel24: TPanel;
    L_130: TLabel;
    L_131: TLabel;
    Panel25: TPanel;
    L_132: TLabel;
    L_134: TLabel;
    L_133: TLabel;
    Panel26: TPanel;
    Panel27: TPanel;
    Panel28: TPanel;
    SG_10: TStringGrid;
    M_11: TMemo;
    M_12: TMemo;
    Panel20: TPanel;
    Panel21: TPanel;
    L_22: TLabel;
    Label9: TLabel;
    Panel29: TPanel;
    L_23: TLabel;
    Label11: TLabel;
    Panel30: TPanel;
    L_21: TLabel;
    Label13: TLabel;
    Panel31: TPanel;
    L_20: TLabel;
    Label36: TLabel;
    Panel32: TPanel;
    Panel34: TPanel;
    Panel35: TPanel;
    Panel36: TPanel;
    Panel33: TPanel;
    Label37: TLabel;
    Panel37: TPanel;
    L_304: TLabel;
    L_305: TLabel;
    Panel38: TPanel;
    L_302: TLabel;
    L_303: TLabel;
    Panel39: TPanel;
    L_300: TLabel;
    L_301: TLabel;
    Panel40: TPanel;
    Label44: TLabel;
    Panel41: TPanel;
    L_322: TLabel;
    L_323: TLabel;
    Panel42: TPanel;
    L_324: TLabel;
    L_325: TLabel;
    Panel43: TPanel;
    L_320: TLabel;
    L_321: TLabel;
    Panel44: TPanel;
    Label51: TLabel;
    M_31: TMemo;
    Panel45: TPanel;
    Panel46: TPanel;
    Panel47: TPanel;
    Label52: TLabel;
    Panel52: TPanel;
    Panel53: TPanel;
    M_41: TMemo;
    Panel54: TPanel;
    M_40: TMemo;
    Panel48: TPanel;
    Panel49: TPanel;
    Label53: TLabel;
    M_43: TMemo;
    M_42: TMemo;
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
    iRow    : integer;
begin
    with SG_10 do begin
        iRow    := 0;
        Cells[0,iRow]   := '北京';  Cells[1,iRow]   := '55';    Cells[2,iRow]   := '#FF5D1D';   Inc(iRow);
        Cells[0,iRow]   := '上海';  Cells[1,iRow]   := '98';    Cells[2,iRow]   := '#FFA91F';   Inc(iRow);
        Cells[0,iRow]   := '广州';  Cells[1,iRow]   := '76';    Cells[2,iRow]   := '#9DF90D';   Inc(iRow);
        Cells[0,iRow]   := '深圳';  Cells[1,iRow]   := '83';    Cells[2,iRow]   := '#B283FC';   Inc(iRow);
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
var
    iW,iH   : Integer;
    sCode   : String;
begin
    iW      := StrToIntDef(dwGetProp(self,'innerwidth'),0);
    iH      := StrToIntDef(dwGetProp(self,'innerheight'),0);
    //
    if iW<=Width then begin
        sCode   :='document.body.parentNode.style.overflow = "hidden";'
                +'document.getElementById(''app'').style.transformOrigin ="0 0";'
                +'document.getElementById(''app'').style.transform = ''scale('+FloatToStr(iW/Width)+','+FloatToStr(iH/Height)+')'';';
    end else begin
        sCode   :='document.body.parentNode.style.overflow = "hidden";'
                +'document.getElementById(''app'').style.transformOrigin ="50% 0";'
                +'document.getElementById(''app'').style.transform = ''scale('+FloatToStr(iW/Width)+','+FloatToStr(iH/Height)+')'';';
    end;
    dwRunJS(sCode,self);

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
    //公开数据展示
    L_000.Caption   := IntToStr(giD00[0])+#13+'党务公开';
    L_001.Caption   := IntToStr(giD00[1])+#13+'政务公开';
    L_002.Caption   := IntToStr(giD00[2])+#13+'财务公开';
    L_003.Caption   := IntToStr(giD00[3])+#13+'村务公开';
    L_004.Caption   := IntToStr(giD00[4])+#13+'居务公开';
    L_005.Caption   := IntToStr(giD00[5])+#13+'债务公开';
    L_006.Caption   := IntToStr(giD00[6])+#13+'权力公开';
    //公开服务数量
    L_010.Caption   := IntToStr(giD01 div 10000);
    L_011.Caption   := IntToStr((giD01 mod 10000) div 1000);
    L_012.Caption   := IntToStr((giD01 mod 1000) div 100);
    L_013.Caption   := IntToStr((giD01 mod 100) div 10);
    L_014.Caption   := IntToStr((giD01 mod 10));
    //统计数据展示
    L_020.Caption   := IntToStr(giD02[0])+#13+'本年公开';
    L_021.Caption   := IntToStr(giD02[1])+#13+'本月公开';
    L_022.Caption   := IntToStr(giD02[2])+#13+'电力数据';
    L_023.Caption   := IntToStr(giD02[3])+#13+'用水数据';
    L_024.Caption   := IntToStr(giD02[4])+#13+'排污数据';

    //第1行-----------------------------------------------------------------------------------------
    //各自然村服务情况数据
    for I:=0 to 3 do begin
        SG_10.Cells[1,I]    := IntToStr(giD10[I]);
    end;
    //中左环图
    sJS := 'this.value11 =  ['+
            '{ value: %d, name: ''大营村'' },'+
            '{ value: %d, name: ''散洲村'' },'+
            '{ value: %d, name: ''康湾村'' },'+
            '{ value: %d, name: ''潼口村'' },'+
            '{ value: %d, name: ''郭河村'' }'+
        '];';
    sJS := Format(sJS,[giD11[0],giD11[1],giD11[2],giD11[3],giD11[4]]);
    dwRunJS(sjS,self);
    dwEcharts(M_11);
    //中右玫瑰图
    sJS := 'this.value12 =  ['+
            '{ value: %d, name: ''张东''  },'+
            '{ value: %d, name: ''陈诃''  },'+
            '{ value: %d, name: ''张西''  },'+
            '{ value: %d, name: ''柳林桥''},'+
            '{ value: %d, name: ''黄桥'' }'+
        '];';
    sJS := Format(sJS,[giD12[0],giD12[1],giD12[2],giD12[3],giD12[4]]);
    dwRunJS(sjS,self);
    dwEcharts(M_12);
    //待公开数据
    L_130.Caption   := IntToStr(giD13[0])+#13+'本年公开';
    L_131.Caption   := IntToStr(giD13[1])+#13+'本月公开';
    L_132.Caption   := IntToStr(giD13[2])+#13+'电力数据';
    L_133.Caption   := IntToStr(giD13[3])+#13+'用水数据';
    L_134.Caption   := IntToStr(giD13[4])+#13+'排污数据';


    //第2行-----------------------------------------------------------------------------------------
    //服务对象 / 服务项目 / 服务地点 / 服务类型
    L_20.Caption    := IntToStr(giD2[0]);
    L_21.Caption    := IntToStr(giD2[1]);
    L_22.Caption    := IntToStr(giD2[2]);
    L_23.Caption    := IntToStr(giD2[3]);

    //第3行-----------------------------------------------------------------------------------------
    //服务新闻
    L_300.Caption   := gsD300;
    L_301.Caption   := gsD301;
    L_302.Caption   := gsD302;
    L_303.Caption   := gsD303;
    L_304.Caption   := gsD304;
    L_305.Caption   := gsD305;
    //服务占比
    sJS := 'this.value31 =  ['+
            '{ value: %d, name: ''张东''  },'+
            '{ value: %d, name: ''陈诃''  },'+
            '{ value: %d, name: ''张西''  },'+
            '{ value: %d, name: ''柳林桥''},'+
            '{ value: %d, name: ''黄桥'' }'+
        '];';
    sJS := Format(sJS,[giD31[0],giD31[1],giD31[2],giD31[3],giD31[4]]);
    dwRunJS(sjS,self);
    dwEcharts(M_31);
    //服务热点
    L_320.Caption   := gsD320;
    L_321.Caption   := gsD321;
    L_322.Caption   := gsD322;
    L_323.Caption   := gsD323;
    L_324.Caption   := gsD324;
    L_325.Caption   := gsD325;

    //第4行-----------------------------------------------------------------------------------------
    //各自然村服务占比
    sJS := 'this.value40 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD40[0],giD40[1],giD40[2],giD40[3],giD40[4]]);
    dwRunJS(sjS,self);
    dwEcharts(M_40);
    //主动服务/被动服务/随机服务
    sJS := 'this.value410 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD41[0,0],giD41[1,0],giD41[2,0],giD41[3,0],giD41[4,0]]);
    dwRunJS(sjS,self);
    sJS := 'this.value411 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD41[0,1],giD41[1,1],giD41[2,1],giD41[3,1],giD41[4,1]]);
    dwRunJS(sjS,self);
    sJS := 'this.value412 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD41[0,2],giD41[1,2],giD41[2,2],giD41[3,2],giD41[4,2]]);
    dwRunJS(sjS,self);
    dwEcharts(M_41);
    //上门服务/远程服务
    sJS := 'this.value420 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD42[0,0],giD42[1,0],giD42[2,0],giD42[3,0],giD42[4,0]]);
    dwRunJS(sjS,self);
    sJS := 'this.value421 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD42[0,1],giD42[1,1],giD42[2,1],giD42[3,1],giD42[4,1]]);
    dwRunJS(sjS,self);
    dwEcharts(M_42);
    //各类服务公开数量
    sJS := 'this.value430 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD43[0,0],giD43[1,0],giD43[2,0],giD43[3,0],giD43[4,0]]);
    dwRunJS(sjS,self);
    sJS := 'this.value431 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD43[0,1],giD43[1,1],giD43[2,1],giD43[3,1],giD43[4,1]]);
    dwRunJS(sjS,self);
    sJS := 'this.value432 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD43[0,2],giD43[1,2],giD43[2,2],giD43[3,2],giD43[4,2]]);
    dwRunJS(sjS,self);
    sJS := 'this.value433 =  [%d,%d,%d,%d, %d];';
    sJS := Format(sJS,[giD43[0,3],giD43[1,3],giD43[2,3],giD43[3,3],giD43[4,3]]);
    dwRunJS(sjS,self);
    dwEcharts(M_43);
end;

end.
