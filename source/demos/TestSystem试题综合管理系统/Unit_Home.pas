unit unit_Home;

interface

uses
    //deweb基本单元
    dwBase,

    //基本函数
    dwfUnit,

    //
    unit_Questions,
    unit_Test,
    unit_Score,
    unit_User,
    unit_Password,
    unit_Review,

    //系统自带单元
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons;

type
  TForm_Home = class(TForm)
    P_Buttons: TPanel;
    Panel_Customer: TPanel;
    Panel14: TPanel;
    Panel_Goods: TPanel;
    Panel17: TPanel;
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
    Label15: TLabel;
    Panel_Provider: TPanel;
    Label_Welcome: TLabel;
    L_Introduce: TLabel;
     ScrollBox_All: TScrollBox;
    Panel_All: TPanel;
    Panel1: TPanel;
    procedure FormResize(Sender: TObject);
    procedure Panel_ProviderClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
        //当前用户使用本模块的权限，格式是JSON的数组字符串，
        //形如            [1,1,1,1,1,1,0,1,0,1],
        //各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
	    gsRights : string;
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
        P_Buttons.Height        := 3 * 110;
        dwfAlignHorzPro(P_Buttons,3);

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
        P_Buttons.Width     := Width - P_Buttons.Margins.Left - P_Buttons.Margins.Right;
        dwfAlignHorz(P_Buttons);
        //
        Panel_Bulletin.Width    := Width - Panel_Bulletin.Margins.Left - Panel_Bulletin.Margins.Right;
        dwfAlignHorz(Panel_Bulletin);

        //
        Panel_All.AutoSize  := False;
        Panel_All.AutoSize  := True;
    end;

end;


procedure TForm_Home.FormShow(Sender: TObject);
var
    joRights    : Variant;  //对当前用户角色 的全部权限
    joRight     : Variant;
    //
    iItem       : Integer;
    iPanel      : Integer;
    //
    oPanel      : TPanel;
begin
    joRights    := TForm1(self.Owner).gjoRights;
    //
    for iPanel := P_Buttons.ControlCount - 1 downto 0 do begin
        oPanel  := TPanel(P_Buttons.Controls[iPanel]);
        for iItem := 1 to joRights._Count-1 do begin
            joRight := joRights._(iItem);
            if joRight.caption = oPanel.Caption then begin
                //
                if joRight.rights._(0) = 0 then begin   //如果不显示，则销毁
                    oPanel.Destroy;
                    break;
                end else if joRight.rights._(1) = 0 then begin  //如果禁用，则Enabled
                    oPanel.Enabled  := False;
                    break;
                end;
            end;
        end;
    end;

end;

procedure TForm_Home.Panel_ProviderClick(Sender: TObject);
var
    sCaption    : string;
    oForm1      : TForm1;
begin
    oForm1      := TForm1(Self.Owner);

    sCaption    := TPanel(Sender).Caption;
    with oForm1 do begin
        if sCaption = '试题管理' then begin
            dwfShowForm(TForm_Questions,TForm(Form_Questions),False,True);
            Exit;
        end;
        if sCaption = '自主考试' then begin
            dwfShowForm(TForm_Test,TForm(Form_Test),True,True);
            Exit;
        end;
        if sCaption = '成绩查询' then begin
            dwfShowForm(TForm_Score,TForm(Form_Score),True,True);
            Exit;
        end;
        if sCaption = '用户管理' then begin
            dwfShowForm(TForm_User,TForm(Form_User),False,True);
            Exit;
        end;
        if sCaption = '更改密码' then begin
            dwfShowForm(TForm_Password,TForm(Form_Password),False,True);
            Exit;
        end;
        if sCaption = '评阅试卷' then begin
            dwfShowForm(TForm_Review,TForm(Form_Review),True,True);
            Exit;
        end;
    end;

end;

end.
