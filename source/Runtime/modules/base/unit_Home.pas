unit unit_Home;

interface

uses
    //deweb基本单元
    dwBase,

    //dwFrame基本函数
    dwfUnit,

    //系统自带单元
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus;

type
  TForm_Home = class(TForm)
    Panel_Buttons: TPanel;
    Panel_Customer: TPanel;
    Panel14: TPanel;
    Panel_Goods: TPanel;
    Panel17: TPanel;
    Panel18: TPanel;
    Panel13: TPanel;
    Panel_Welcome: TPanel;
    Panel_bulletin: TPanel;
    Panel21: TPanel;
    Label6: TLabel;
    Label10: TLabel;
    Panel22: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Panel23: TPanel;
    Label11: TLabel;
    Label12: TLabel;
    Label15: TLabel;
    Panel11: TPanel;
    Panel_Provider: TPanel;
    Label_Welcome: TLabel;
    Label4: TLabel;
     ScrollBox_All: TScrollBox;
    Panel_All: TPanel;
    Panel_Buttons1: TPanel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel19: TPanel;
    Panel20: TPanel;
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
	gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;

var
  Form_Home: TForm_Home;

implementation

{$R *.dfm}

uses
    Unit1;


procedure TForm_Home.FormResize(Sender: TObject);
begin
    if TForm1(self.Owner).gbMobile then begin
        //====================================移动模式==============================================

        //设置欢迎面板
        Panel_Welcome.Height    := 2 * 100;

        //设置功能按钮面板
        Panel_Buttons.Height    := 3 * 110;
        dwfAlignHorzPro(Panel_Buttons,3);

        //设置简报面板
        Panel_Bulletin.Height   := 3 * 150;
        dwfAlignVert(Panel_Bulletin);


        //
        //Panel_All.Height  := 40+Panel_Welcome.Height + Panel_Buttons.Height + Panel_Bulletin.Height;
        Panel_All.AutoSize  := False;
        Panel_All.AutoSize  := True;
    end else begin
        //======================================PC模式==============================================


        //更新首页的控件显示

        //
        Panel_Buttons.Width     := Width - Panel_Buttons.Margins.Left - Panel_Buttons.Margins.Right;
        dwfAlignHorz(Panel_Buttons);
        //
        Panel_Buttons1.Width    := Width - Panel_Buttons.Margins.Left - Panel_Buttons.Margins.Right;
        dwfAlignHorz(Panel_Buttons1);
        //
        Panel_Bulletin.Width    := Width - Panel_Bulletin.Margins.Left - Panel_Bulletin.Margins.Right;
        dwfAlignHorz(Panel_Bulletin);

        //
        Panel_All.AutoSize  := False;
        Panel_All.AutoSize  := True;
    end;

end;


end.
