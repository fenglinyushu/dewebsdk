unit Main;

interface

uses
    Unit2,
    Unit3,
    Unit4,
    Unit_StockIn,
    Unit_StockOut,
    //
    dwBase,

    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
    Vcl.Buttons, Data.DB, Data.Win.ADODB;

type
  TForm1 = class(TForm)
    Panel_Client: TPanel;
    Panel_0_Banner: TPanel;
    Panel36: TPanel;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    Label1: TLabel;
    Label3: TLabel;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    TabSheet4: TTabSheet;
    Panel5: TPanel;
    Panel_Buttons: TPanel;
    Panel11: TPanel;
    SpeedButton_StockOutQuery: TSpeedButton;
    Panel12: TPanel;
    SpeedButton_StockInQuery: TSpeedButton;
    Panel13: TPanel;
    SpeedButton24: TSpeedButton;
    Panel14: TPanel;
    SpeedButton31: TSpeedButton;
    Panel15: TPanel;
    SpeedButton38: TSpeedButton;
    Panel16: TPanel;
    SpeedButton44: TSpeedButton;
    Panel17: TPanel;
    SpeedButton53: TSpeedButton;
    Panel18: TPanel;
    SpeedButton1: TSpeedButton;
    Panel6: TPanel;
    Image1: TImage;
    Label2: TLabel;
    Label4: TLabel;
    Image2: TImage;
    Panel8: TPanel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button7: TButton;
    Panel9: TPanel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Button8: TButton;
    Panel10: TPanel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Button9: TButton;
    Panel7: TPanel;
    Panel21: TPanel;
    Label6: TLabel;
    Label10: TLabel;
    Button10: TButton;
    Panel22: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Panel23: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    TabSheet8: TTabSheet;
    TabSheet9: TTabSheet;
    TabSheet10: TTabSheet;
    TabSheet11: TTabSheet;
    TabSheet_StockIn: TTabSheet;
    TabSheet_StockOut: TTabSheet;
    TabSheet14: TTabSheet;
    MainMenu: TMainMenu;
    MenuItem_Inventory: TMenuItem;
    MenuItem_StockIn: TMenuItem;
    MenuItem_StockOut: TMenuItem;
    N4: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    MenuItem_StockInQuery: TMenuItem;
    MenuItem_StockOutQuery: TMenuItem;
    N13: TMenuItem;
    Panel_Menu: TPanel;
    Button4: TButton;
    MenuItem_Home: TMenuItem;
    N14: TMenuItem;
    N16: TMenuItem;
    N17: TMenuItem;
    N18: TMenuItem;
    N1: TMenuItem;
    procedure PageControl1Change(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControl1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure MenuItem_InventoryClick(Sender: TObject);
    procedure MenuItem_StockInClick(Sender: TObject);
    procedure MenuItem_StockOutClick(Sender: TObject);
    procedure MenuItem_HomeClick(Sender: TObject);
    procedure SpeedButton38Click(Sender: TObject);
    procedure SpeedButton44Click(Sender: TObject);
    procedure SpeedButton31Click(Sender: TObject);
    procedure MenuItem_StockInQueryClick(Sender: TObject);
    procedure MenuItem_StockOutQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton_StockInQueryClick(Sender: TObject);
    procedure SpeedButton_StockOutQueryClick(Sender: TObject);
  private
    { Private declarations }
  public
    gsMainDir   : String;
    Form2 : TForm2;
    Form3 : TForm3;
    Form4 : TForm4;
    Form_StockIn : TForm_StockIn;
    Form_StockOut : TForm_StockOut;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormCreate(Sender: TObject);
begin
    //
    PageControl1.ActivePageIndex    := 0;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
    iButtonW    : Integer;
    I           : Integer;
begin
    //设置当前为PC模式
    dwSetPCMode(self);

    //更新菜单位置
    dwSetCompLTWH(MainMenu,0,Panel_Menu.Top,200,Panel_Menu.Height);


    //更新首页中8个按钮的宽度
    iButtonW    := (Panel_Buttons.Width - 115) div 8;
    for I := 11 to 18 do begin
        TPanel(Self.FindComponent('Panel'+IntToStr(I))).Width   := iButtonW;
    end;

    //更新首页中3个消息栏的宽度
    iButtonW    := (Panel_Buttons.Width - 20) div 3;
    for I := 21 to 23 do begin
        TPanel(Self.FindComponent('Panel'+IntToStr(I))).Width   := iButtonW;
    end;

    //更新所有TabSheet中的Form的宽度和TabSheet一样
    for I := 1 to PageControl1.PageCount-1 do begin
        //暂时略过空TAB
        if PageControl1.Pages[I].ControlCount = 0 then begin
            Continue;
        end;
        //设置大小
        with TForm(PageControl1.Pages[I].Controls[0]) do begin
            Width  := PageControl1.Pages[I].Width;
            Height := PageControl1.Pages[I].Height;
        end;
    end;



end;

procedure TForm1.MenuItem_HomeClick(Sender: TObject);
begin
    //切换到该页面
    PageControl1.ActivePageIndex    := 0;

end;

procedure TForm1.MenuItem_InventoryClick(Sender: TObject);
begin
    //显示"库存查询"页面
    TabSheet2.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePageIndex    := 1;
    //默认查询
    Form2.Button_Search2.OnClick(self);

end;

procedure TForm1.MenuItem_StockInClick(Sender: TObject);
begin
    //显示"产品入库"页面
    TabSheet3.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePageIndex    := 2;
    //默认查询,显示当前库存
    Form3.UpdateData(1);
    //更新产品\供应商\仓库信息
    Form3.UpdateInfos;
end;

procedure TForm1.MenuItem_StockOutClick(Sender: TObject);
begin
    //显示"产品入库"页面
    TabSheet4.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePageIndex    := 3;
    //默认查询,显示当前库存
    Form4.UpdateData(1);
    //更新领料单位\领料人等信息
    Form4.UpdateInfos;
end;

procedure TForm1.MenuItem_StockInQueryClick(Sender: TObject);
begin
    //显示"库存查询"页面
    TabSheet_StockIn.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_StockIn;
    //默认查询
    Form_StockIn.Button_Search.OnClick(self);

end;

procedure TForm1.MenuItem_StockOutQueryClick(Sender: TObject);
begin
    //显示"库存查询"页面
    TabSheet_StockOut.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_StockOut;
    //默认查询
    Form_StockOut.Button_Search.OnClick(self);

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
    //设置选中的菜单项
    dwSetMenuDefault(MainMenu,PageControl1.ActivePageIndex.ToString);
end;

procedure TForm1.PageControl1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //
    if X = 0 then begin
        if Y > 0 then begin
            PageControl1.Pages[Y].TabVisible    := False;
            PageControl1.ActivePageIndex        := 0;
        end;
    end;
end;

procedure TForm1.SpeedButton31Click(Sender: TObject);
begin
    MenuItem_StockOut.OnClick(self);
end;

procedure TForm1.SpeedButton38Click(Sender: TObject);
begin
    MenuItem_Inventory.OnClick(self);
end;

procedure TForm1.SpeedButton_StockOutQueryClick(Sender: TObject);
begin
    MenuItem_StockOutQuery.OnClick(self);

end;

procedure TForm1.SpeedButton44Click(Sender: TObject);
begin
    MenuItem_StockIn.OnClick(self);
end;

procedure TForm1.SpeedButton_StockInQueryClick(Sender: TObject);
begin
    MenuItem_StockInQuery.OnClick(self);
end;

end.
