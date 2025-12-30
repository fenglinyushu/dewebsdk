unit unit_Home;

interface

uses
    //deweb基本单元
    dwBase,

    //dwFrame基本函数
    dwfBase,
    dwfUnit,

    //系统自带单元
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Home = class(TForm)
    P1: TPanel;
    P12: TPanel;
    P13: TPanel;
    P11: TPanel;
    P14: TPanel;
    P16: TPanel;
    P17: TPanel;
    P0: TPanel;
    P2: TPanel;
    P20: TPanel;
    L200: TLabel;
    L201: TLabel;
    P21: TPanel;
    L210: TLabel;
    L211: TLabel;
    P22: TPanel;
    L220: TLabel;
    P15: TPanel;
    P10: TPanel;
    L01: TLabel;
    L02: TLabel;
    L221: TLabel;
    Mm: TMemo;
    P3: TPanel;
    FDQuery1: TFDQuery;
    procedure FormResize(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure P10Click(Sender: TObject);
  private
        procedure FindMenuItemAndClick(menuItemCaption: string; parentMenu: TMenuItem);
  public
	gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;

var
  Form_Home: TForm_Home;

implementation

{$R *.dfm}

uses
    Unit1;


procedure TForm_Home.FindMenuItemAndClick(menuItemCaption: string; parentMenu: TMenuItem);
var
  i: Integer;
begin
  // 遍历指定父菜单的子菜单项
  for i := 0 to parentMenu.Count - 1 do
  begin
    if parentMenu.Items[i].Caption = menuItemCaption then
    begin
      // 执行找到的菜单项的事件处理
      parentMenu.Items[i].Click;
    end
    else if parentMenu.Items[i].Count > 0 then
    begin
      // 递归查找子菜单中的菜单项
      FindMenuItemAndClick(menuItemCaption, parentMenu.Items[i]);
    end;
  end;end;

procedure TForm_Home.FormResize(Sender: TObject);
begin


    //更新首页的控件显示

    //
    P1.Width     := Width - P1.Margins.Left - P1.Margins.Right;
    dwfAlignHorz(P1);
    //
    P2.Width    := Width - P2.Margins.Left - P2.Margins.Right;
    dwfAlignHorz(P2);

    //
    //dwEcharts(Mm);
end;


procedure TForm_Home.FormShow(Sender: TObject);
var
    iYear       : Integer;
    iCurYear    : Integer;
    iItem       : Integer;
    sJS         : String;
    sJS0        : String;
    sJS1        : String;
    sJS2        : String;
    sJS3        : String;
    //
    oPanel      : TPanel;
    slMenu      : TStringList;

begin
    //简化系统,主要是简化button/panel/label, 优点是代码量小，缺点是部分属性失效
    dwSimple(self);

    //设置 Hi，dwFrame! 标签 为 “不简化”状态
    L01.HelpKeyword := '';

    //设置数据查询组件连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //库存数据
    FDQuery1.Close;
    FDQuery1.Open('SELECT Count(gId),Sum(gQuantity),Sum(gQuantity*ginprice) FROM eGoods');
    L201.Caption    := Format('总计库存 %d 项，%d 件，%n 元',
        [FDQuery1.Fields[0].AsInteger,FDQuery1.Fields[1].AsInteger,FDQuery1.Fields[2].AsFloat]);

    //入库数据
    FDQuery1.Close;
    FDQuery1.Open('SELECT Count(iId),Sum(iQuantity),Sum(iAmount) FROM eStockIn');
    L211.Caption    := Format('总计入库 %d 项，%d 件，%n 元',
        [FDQuery1.Fields[0].AsInteger,FDQuery1.Fields[1].AsInteger,FDQuery1.Fields[2].AsFloat]);

    //出库库数据
    FDQuery1.Close;
    FDQuery1.Open('SELECT Count(oId),Sum(oQuantity),Sum(oAmount) FROM eStockOut');
    L221.Caption    := Format('总计出库 %d 项，%d 件，%n 元',
        [FDQuery1.Fields[0].AsInteger,FDQuery1.Fields[1].AsInteger,FDQuery1.Fields[2].AsFloat]);

    //<更新图表数据
    //设置横轴
    iCurYear    := YearOf(Now);
    sJS     := 'this.value = [';
    for iYear := iCurYear - 4 to iCurYear do begin
        sJS := sJS + '''' + IntToStr(iYear) + '年'','
    end;
    Delete(sJS,Length(sJS),1);
    sJS := sJS + '];';
    Mm.Lines[0] := sJS;

    //更新纵轴数据
    sJS0    := 'this.value0 = [';   //出库数量
    sJS1    := 'this.value1 = [';   //出库金额
    sJS2    := 'this.value2 = [';   //入库数量
    sJS3    := 'this.value3 = [';   //入库金额
    for iYear := iCurYear - 4 to iCurYear do begin
        //出库
        FDQuery1.Close;
        FDQuery1.Open('SELECT Sum(oQuantity),Sum(oAmount) FROM eStockOut WHERE YEAR(oDate) = '+IntToStr(iYear));
        sJS0    := sJS0 + IntToStr(FDQuery1.Fields[0].AsInteger)+',';
        sJS1    := sJS1 + IntToStr(Round(FDQuery1.Fields[1].AsFloat/100))+',';
        //入库
        FDQuery1.Close;
        FDQuery1.Open('SELECT Sum(iQuantity),Sum(iAmount) FROM eStockIn WHERE YEAR(iDate) = '+IntToStr(iYear));
        sJS2    := sJS2 + IntToStr(FDQuery1.Fields[0].AsInteger)+',';
        sJS3    := sJS3 + IntToStr(Round(FDQuery1.Fields[1].AsFloat/100))+',';
    end;
    Delete(sJS0,Length(sJS0),1);
    Delete(sJS1,Length(sJS1),1);
    Delete(sJS2,Length(sJS2),1);
    Delete(sJS3,Length(sJS3),1);
    sJS0 := sJS0 + '];';
    sJS1 := sJS1 + '];';
    sJS2 := sJS2 + '];';
    sJS3 := sJS3 + '];';
    Mm.Lines[1] := sJS0;
    Mm.Lines[2] := sJS1;
    Mm.Lines[3] := sJS2;
    Mm.Lines[4] := sJS3;

    //取得菜单项所有叶节点
    dwfGetMenuLeafs(TForm1(self.Owner).MainMenu1,slMenu);

    //更新快捷按钮
    for iItem := 0 to 7 do begin
        oPanel  := TPanel(FindComponent('P1'+IntToStr(iItem)));
        with TForm1(self.Owner) do begin
            oPanel.Caption  := gjoUserInfo.quickbutton._(iItem)._(0);
            oPanel.Hint     := '{"radius":"5px","src":"media/images/32/a ('+IntToStr(gjoUserInfo.quickbutton._(iItem)._(1))+').png","dwstyle":"border:solid 1px #eee;"}';
        end;
    end;

end;

procedure TForm_Home.P10Click(Sender: TObject);
var
    iButton     : Integer;
    sCaption    : string;
    oForm1      : TForm1;
begin
    //取得主窗体
    oForm1  := TForm1(self.Owner);

    //取得当前按钮caption， 通过caption触发事件
    sCaption := (Sender as TPanel).Caption; // 获取当前按钮的 Caption

    // 遍历 MainMenu1 中的所有菜单项，找到与caption相同的，执行菜单事件
    for iButton := 0 to oForm1.MainMenu1.Items.Count - 1 do begin
        if oForm1.MainMenu1.Items[iButton].Caption = sCaption then begin
        // 执行找到的菜单项的事件处理
        oForm1.MainMenu1.Items[iButton].Click;
    end else begin
        // 在子菜单中查找
        FindMenuItemAndClick(sCaption, oForm1.MainMenu1.Items[iButton]);
    end;
    end;
end;

end.
