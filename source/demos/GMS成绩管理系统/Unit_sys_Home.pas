unit Unit_sys_Home;

interface

uses
    //deweb基本单元
    dwBase,
    dwHistory,

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
  TForm_sys_Home = class(TForm)
    P0: TPanel;
    FDQuery1: TFDQuery;
    P0C: TPanel;
    LaWelcome: TLabel;
    LaIntra: TLabel;
    P0L: TPanel;
    ImAvatar: TImage;
    LaRole: TLabel;
    Fp1: TFlowPanel;
    PnM0: TPanel;
    PnM1: TPanel;
    PnM2: TPanel;
    PnM3: TPanel;
    PnM4: TPanel;
    PnM5: TPanel;
    PnM6: TPanel;
    PnM7: TPanel;
    Fp2: TFlowPanel;
    PnD0: TPanel;
    LaT0: TLabel;
    LaV0: TLabel;
    PnD1: TPanel;
    LaT1: TLabel;
    LaV1: TLabel;
    PnD2: TPanel;
    LaT2: TLabel;
    LaV2: TLabel;
    procedure FormShow(Sender: TObject);
    procedure P10Click(Sender: TObject);
  private
        procedure FindMenuItemAndClick(menuItemCaption: string; parentMenu: TMenuItem);
  public
	gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;

var
  Form_sys_Home: TForm_sys_Home;

implementation

{$R *.dfm}

uses
    Unit1;


procedure TForm_sys_Home.FindMenuItemAndClick(menuItemCaption: string; parentMenu: TMenuItem);
var
    i       : Integer;
begin
    // 遍历指定父菜单的子菜单项
    for i := 0 to parentMenu.Count - 1 do begin
        if parentMenu.Items[i].Caption = menuItemCaption then begin
            // 执行找到的菜单项的事件处理
            parentMenu.Items[i].Click;
        end else if parentMenu.Items[i].Count > 0 then begin
            // 递归查找子菜单中的菜单项
            FindMenuItemAndClick(menuItemCaption, parentMenu.Items[i]);
        end;
    end;
end;

procedure TForm_sys_Home.FormShow(Sender: TObject);
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
    //设置数据查询组件连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //取得菜单项所有叶节点
    dwfGetMenuLeafs(TForm1(self.Owner).MainMenu1,slMenu);

    //显示欢迎用户
    LaWelcome.Caption   := '欢迎您, '+TForm1(self.Owner).gjoUserinfo.username+'!';
    //显示角色
    LaRole.Caption      := TForm1(self.Owner).gjoUserinfo.rolename;
    //显示头像
    ImAvatar.Hint       := '{"src":"media/system/GMS/'+TForm1(self.Owner).gjoUserInfo.avatar+'","radius":"50%","dwstyle":"border:solid 2px #ddd;"}';

    //更新快捷按钮
    for iItem := 0 to 7 do begin
        oPanel  := TPanel(FindComponent('PnM'+IntToStr(iItem)));

        //
        with TForm1(self.Owner) do begin
            if iItem < gjoUserInfo.quickbutton._Count then begin
                oPanel.Caption  := gjoUserInfo.quickbutton._(iItem)._(0);
                oPanel.Hint     := '{"radius":"5px","src":"media/images/32/a ('+IntToStr(gjoUserInfo.quickbutton._(iItem)._(1))+').png","dwstyle":"border:solid 1px #eee;"}';
                oPanel.Visible  := oPanel.Caption <> '';

                //<移动端处理
                if TForm1(self.Owner).gbMobile then begin
                    oPanel.Height   := 80;
                    oPanel.Margins.SetBounds(5,10,5,10);
                end;
                //>
            end else begin
                oPanel.Visible  := False;
            end;
        end;
    end;


    //
    if TForm1(self.Owner).gbMobile then begin
        //设置固定为4列
        FP1.HelpContext := 10004;
        //
        PnD0.Height     := 80;
        PnD1.Height     := 80;
        PnD2.Height     := 80;
        //
        P0.Margins.Top      := 60;
    end;

    //显示统计值
    FDQuery1.Open('SELECT COUNT(DISTINCT sClassnum) AS UniqueClassCount FROM sys_Student;');
    LaV0.Caption    := IntToStr(FDQuery1.Fields[0].AsInteger)+' 个';
    FDQuery1.Open('SELECT COUNT(*) AS TotalRecords FROM sys_Student;');
    LaV1.Caption    := IntToStr(FDQuery1.Fields[0].AsInteger)+' 个';
    FDQuery1.Open('SELECT COUNT(DISTINCT iName) AS UniqueClassCount FROM dic_Item;');
    LaV2.Caption    := IntToStr(FDQuery1.Fields[0].AsInteger)+' 项';
end;

procedure TForm_sys_Home.P10Click(Sender: TObject);
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
