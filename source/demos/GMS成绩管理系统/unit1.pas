unit unit1;
{
说明：本窗体为应用主窗体，仅提供菜单，PageControl等基础框架服务
}

interface

uses
    //deweb基本单元
    dwBase,
    dwHistory,

    //增删改查单元
    dwCrudPanel,

    //基本单元
    dwfBase,

    //通用登录控制单元
    gLogin,

    //系统功能
    unit_sys_ChangePsd,         //更改密码
    unit_sys_Department,        //班级管理
    unit_sys_Student,           //学生管理
    unit_sys_Home,              //首页
    unit_sys_Log,               //系统日志
    unit_sys_Role,              //角色权限
    unit_sys_User,              //用户管理
    unit_sys_QuickBtn,          //快速按钮设置

    //功能模块
    unit_bop_Star1,             //星星示例一
    unit_bop_Star2,             //星星示例二
    unit_bop_Test,              //体质测试
    unit_bop_TestGroup,         //体测分组
    unit_bop_Entry,             //成绩录入

    //字典模块
    unit_dic_Item,              //项目标准
    unit_dic_Location,          //测试地点

    //第三方单元
    SynCommons,     //JSON解析单元，来自mormot

    //
    CloneComponents,


    //系统单元
    Graphics,
    Data.Win.ADODB,
    Variants,
	Rtti,
    Math,
    //
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
    FireDAC.Comp.DataSet,
    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL,
    Vcl.WinXPanels;

type
  TForm1 = class(TForm)
    PT: TPanel;
    PC: TPanel;
    PL: TPanel;
    BE: TButton;
    BtThm: TButton;
    BtLogout: TButton;
    LT: TLabel;
    ImageList_dw: TImageList;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    LL: TLabel;
    MainMenu1: TMainMenu;
    MIHome: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Mu3: TMenuItem;
    SM: TShape;
    FQ_Temp: TFDQuery;
    PnH: TPanel;
    BTTheme: TButton;
    FDQuery_Timer: TFDQuery;
    TS: TTimer;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    N16: TMenuItem;
    PnB: TPanel;
    LaUser: TLabel;
    N35: TMenuItem;
    N36: TMenuItem;
    Ms: TMemo;
    CP: TCardPanel;
    N2: TMenuItem;
    N4: TMenuItem;
    N8: TMenuItem;
    N1: TMenuItem;
    N5: TMenuItem;
    N9: TMenuItem;
    N10: TMenuItem;
    N3: TMenuItem;
    PnLogout: TPanel;
    N11: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BEClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BtThmClick(Sender: TObject);
    procedure BtLogoutClick(Sender: TObject);
    procedure BTThemeClick(Sender: TObject);
    procedure TSTimer(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Mu3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MIHomeClick(Sender: TObject);
    procedure MIQuickClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure P10Click(Sender: TObject);
    procedure PMChange(Sender: TObject);
    procedure Ts1Enter(Sender: TObject);
    procedure N36Click(Sender: TObject);
    procedure N16Click(Sender: TObject);
    procedure CPEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure N2Click(Sender: TObject);
    procedure CPCardChange(Sender: TObject; PrevCard, NextCard: TCard);
    procedure N3Click(Sender: TObject);
    procedure N4Click(Sender: TObject);
    procedure N8Click(Sender: TObject);
    procedure N1Click(Sender: TObject);
    procedure N5Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure FormUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);

    procedure OnClickMenuByName(Sender: TObject);
    procedure OnBack(Sender: TObject);
    procedure PnLogoutExit(Sender: TObject);
    procedure PnLogoutEnter(Sender: TObject);
    procedure N12Click(Sender: TObject);
    procedure N13Click(Sender: TObject);  //统一回退事件
  private
    { Private declarations }
  public
    //系统功能
    Form_sys_ChangePsd      : TForm_sys_ChangePsd;      //更改密码
    Form_sys_Department     : TForm_sys_Department;     //部门管理
    Form_sys_Home           : TForm_sys_Home;           //首页
    Form_sys_Log            : TForm_sys_Log;            //系统日志
    Form_sys_QuickBtn       : TForm_sys_QuickBtn;       //快捷按钮
    Form_sys_Role           : TForm_sys_Role;           //角色权限
    Form_sys_Student        : TForm_sys_Student;        //学生管理
    Form_sys_User           : TForm_sys_User;           //用户管理

    //
    Form_bop_Star1          : TForm_bop_Star1;          //星星示例一
    Form_bop_Star2          : TForm_bop_Star2;          //星星示例二
    Form_bop_Test           : TForm_bop_Test;           //体质测试
    Form_bop_TestGroup      : TForm_bop_TestGroup;      //体测分组
    Form_bop_Entry          : TForm_bop_Entry;          //成绩录入

    //
    Form_dic_Item           : TForm_dic_Item;           //项目标准
    Form_dic_Location       : TForm_dic_Location;       //测试地点


    //------公用变量--------------------------------------------------------------------------------

    //---字符串型变量
    gsMainDir           : string;           //系统工作目录，以 \ 结束

    //布尔型变量
    gbMobile            : Boolean;          //是否移动端

    //用户信息,包括 id/username/canvasid/rolename/avatar等
    gjoUserInfo         : Variant;

    //用户权限
    gjoRights           : Variant;

    //用户主题
    gjoThemes           : Variant;

    //点击标题的时间, 用于人工检查是否双击
    giTabClick          : Integer;

    //当前测试的组id
    giTestId            : Integer;

    //用于管理移动端回退时的变量, 类似:
    //[
    //    {
    //        "type":"auto"
    //    },
    //    {
    //        "type":"page",
    //        "oldindex":3
    //    },
    //    {
    //        "type":"visible",
    //        "true":["TreeView1","Pn2"],
    //        "false":["Pn1"]
    //    }
    //]
    gjoHistory          : Variant;

    //菜单项的JSON
    gjoMenus            : Variant;      //用于保存Checked菜单的所有叶节点的Name

  end;

var
    Form1   : TForm1;

implementation

{$R *.dfm}




//菜单折叠按钮
procedure TForm1.Button1Click(Sender: TObject);
begin
    if FDConnection1.SharedCliHandle = nil then begin
        dwMessage('false','',self);
    end else begin
        dwMessage('true','',self);
    end;
end;

procedure TForm1.CPCardChange(Sender: TObject; PrevCard, NextCard: TCard);
var
    joHint      : variant;
begin
    //

    if gbMobile then begin
        if CP.ActiveCardIndex > 0 then begin
            //非首页,则标题栏显示当前模块名称, 且显示返回按钮
            LT.Caption  := NextCard.Caption;
            LT.Margins.SetBounds(0,0,46,0);

            //
            BE.Hint     := '{"icon":"el-icon-arrow-left","type":"text"};';
            BE.Align    := alLeft;

        end else begin
            //首页,则标题栏显示固定标题, 且不显示返回按钮
            LT.Caption  := 'GMS 成绩管理系统';
            LT.Margins.SetBounds(46,0,0,0);

            //
            BE.Hint     := '{"icon":"el-icon-menu","type":"text"};';
            BE.Align    := alRight;
        end;

        //控制隐藏标题栏或导航栏
        if CP.ActiveCard.ControlCount > 0 then begin
            joHint  := dwJson(TForm(CP.ActiveCard.Controls[0]).Hint);
            PT.Visible  := dwGetInt(joHint,'hidehead') = 0;
            if TFlowPanel(FindComponent('FPTool')) <> nil then begin
                TFlowPanel(FindComponent('FPTool')).Visible  := dwGetInt(joHint,'hidefoot') = 0;
            end;
        end;
    end;
end;

procedure TForm1.CPEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //此处为标签页（TabSheet）的关闭事件 ,参数值：X = 0 为删除Tab, Y为待删除Tab的序号（从0开始）
    //
    if X = 0 then begin     //X=0表示执行删除操作
        //Y为待删除Tab的序号（从0开始）
        if (Y>=0) and (Y<CP.CardCount) then begin
            //关闭页面
            CP.Cards[Y].CardVisible    := False;

            //强制关闭页面，以防止关闭不成功
            if not gbMobile then begin
                dwRunJS('this.$refs.cp__ref.$children[0].$refs.tabs['+Y.ToString+'].style.display = ''none'';',self);
            end;
            //
            //CP.ActiveCardIndex  := Y - 1;
        end;
    end;

end;

procedure TForm1.BEClick(Sender: TObject);
begin
    if gbMobile then begin
        //===== 移动端状态下, 如果在首页, 则弹出菜单
        //如果非首页, 则为返回键

        //
        if CP.ActiveCardIndex = 0 then begin
            PL.Align    := alNone;
            PL.Left     := 0;
            PL.Top      := 0;
            PL.Width    := Width;
            PL.Height   := Height;
            PL.Visible  := True;

            //
            dwAddShowHistory(Self,[],[PL]);
        end else begin
            OnBack(Self);
        end;
    end else begin
        //菜单项展开/折叠
        dwfSetMenuExpand(self,PL.Width < 60);
    end;
end;


procedure TForm1.Mu3Click(Sender: TObject);
begin
    //更改密码
    dwfShowForm(self,TForm_sys_ChangePsd, TForm(Form_sys_ChangePsd),TMenuItem(Sender));
end;

procedure TForm1.N10Click(Sender: TObject);
begin
    //测试地点
    dwfShowForm(self,TForm_dic_Location, TForm(Form_dic_Location),TMenuItem(Sender));

end;

procedure TForm1.N12Click(Sender: TObject);
begin
    //星星示例一
    dwfShowForm(self,TForm_bop_Star1, TForm(Form_bop_Star1),TMenuItem(Sender));

end;

procedure TForm1.N13Click(Sender: TObject);
begin
    //星星示例二
    dwfShowForm(self,TForm_bop_Star2, TForm(Form_bop_Star2),TMenuItem(Sender));

end;

procedure TForm1.N16Click(Sender: TObject);
begin
    //快捷模块
    dwfShowForm(self,TForm_sys_QuickBtn, TForm(Form_sys_QuickBtn),TMenuItem(Sender));
end;

procedure TForm1.N1Click(Sender: TObject);
begin
    PnLogout.Visible    := True;

    //为当前操作添加记录
    dwAddShowHistory(Self,[],[PnLogout]);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
    //体质测试
    dwfShowForm(self,TForm_bop_Test, TForm(Form_bop_Test),TMenuItem(Sender));
end;

procedure TForm1.N36Click(Sender: TObject);
begin
    //系统日志
    dwfShowForm(self,TForm_sys_Log, TForm(Form_sys_Log),TMenuItem(Sender));

end;

procedure TForm1.N3Click(Sender: TObject);
begin
    //班级管理
    dwfShowForm(self,TForm_sys_Department, TForm(Form_sys_Department),TMenuItem(Sender));

end;

procedure TForm1.N4Click(Sender: TObject);
begin
    //班级管理
    dwfShowForm(self,TForm_sys_Student, TForm(Form_sys_Student),TMenuItem(Sender));

end;

procedure TForm1.N5Click(Sender: TObject);
begin
    //用户管理
    dwfShowForm(self,TForm_dic_Item, TForm(Form_dic_Item),TMenuItem(Sender));
end;

procedure TForm1.MIHomeClick(Sender: TObject);
begin
    //首页
    CP.ActiveCardIndex  := 0;

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',self);
end;

procedure TForm1.MIQuickClick(Sender: TObject);
begin
    //快速按钮设置
    dwfShowForm(self,TForm_sys_QuickBtn, TForm(Form_sys_QuickBtn),TMenuItem(Sender));
end;

procedure TForm1.N6Click(Sender: TObject);
begin
    //用户管理
    dwfShowForm(self,TForm_sys_User, TForm(Form_sys_User),TMenuItem(Sender));

end;

procedure TForm1.N7Click(Sender: TObject);
begin
    //角色 管理
    dwfShowForm(self,TForm_sys_Role, TForm(Form_sys_Role),TMenuItem(Sender));
end;

procedure TForm1.N8Click(Sender: TObject);
begin
    //用户管理
    dwfShowForm(self,TForm_bop_TestGroup, TForm(Form_bop_TestGroup),TMenuItem(Sender));

end;

procedure TForm1.OnBack(Sender: TObject);
var
    joHistory   : Variant;
    joItem      : Variant;
    sType       : string;
    oForm       : TForm;
    oComp       : TComponent;
    iForm       : Integer;
    iComp       : Integer;
    iItem       : Integer;
begin
    //=====浏览器回退事件

    //
    if gjoHistory = unassigned then begin
        Exit;
    end;
    if gjoHistory._Count = 0 then begin
        Exit;
    end;

    //取得当前操作记录
    joHistory   := gjoHistory._(gjoHistory._Count - 1);

    //取得记录类型
    sType       := dwGetStr(joHistory,'type','auto');

    if dwGetInt(joHistory,'isnull') <> 1 then begin
        //根据类型分别处理
        if sType = 'auto' then begin
            //===== 先查找当前页面的Form中有没有已弹出的Panel__modal/Panel__ok, 如果有, 则隐藏；
            //否则隐藏当前页面(TCard), 置当前为ActiveCardIndex为最末页
        end else if sType = 'page' then begin
            //=====	oldindex保存当前退回的CardIndex，隐藏当前页面(TCard), 置当前为ActiveCardIndex为oldindex


            //主要处理dwfShowForm弹出的对话框
            if CP.ActiveCardIndex > 0 then begin
                CP.ActiveCard.CardVisible   := False;
            end;
            CP.ActiveCardIndex  := dwGetInt(joHistory,'oldindex');

        end else if sType = 'control' then begin
            //===== control	将”visible”数组中的控件的visible设置为true, ”hidden”数组中的控件的visible设置为false

            //取得窗体
            for iForm := 0 to Screen.FormCount -1 do begin
                oForm   := Screen.Forms[iForm];
                if oForm.Name = dwGetStr(joHistory,'form') then begin
                    break;
                end;
            end;

            //逐个处理拟控制显隐的控件
            for iComp := 0 to oForm.ComponentCount - 1 do begin
                oComp   := oForm.Components[iComp];

                //将”visible”数组中的控件的visible设置为true
                if joHistory.Exists('visible') then begin
                    for iItem := 0 to joHistory.visible._Count - 1 do begin
                        if LowerCase(joHistory.visible._(iItem)) = LowerCase(oComp.Name) then begin
                            TControl(oComp).Visible := True;
                        end;
                    end;
                end;

                //”hidden”数组中的控件的visible设置为false
                if joHistory.Exists('hidden') then begin
                    for iItem := 0 to joHistory.hidden._Count - 1 do begin
                        if LowerCase(joHistory.hidden._(iItem)) = LowerCase(oComp.Name) then begin
                            TControl(oComp).Visible := False;
                        end;
                    end;
                end;
            end;

            //处理标题
            if joHistory.Exists('caption') then begin
                LT.Caption := dwGetStr(joHistory,'caption',LT.Caption);
            end;
        end;
    end;

    //删除数组中最后一个元素
    gjoHistory.Delete(gjoHistory._Count - 1);
end;

procedure TForm1.OnClickMenuByName(Sender: TObject);
var
    iItem       : Integer;
    sCaption    : string;
    oMenu       : TMenuItem;
    oFPTool     : TFlowPanel;
    oPanel      : TPanel;
begin

    //取得当前按钮caption， 通过caption触发事件
    sCaption := (Sender as TPanel).Caption; // 获取当前按钮的 Caption

    //移动端处理
    if gbMobile then begin
        //===== 处理移动端下的工具栏

        //取得底部工具栏面板
        oFPTool := TFlowPanel(FindComponent('FPTool'));

        //
        if oFPTool = nil then begin
            Exit;
        end;

        //全部设置为非选中状态
        for iItem := 0 to oFPTool.ControlCount - 1 do begin
            oPanel  := TPanel(oFPTool.Controls[iItem]);
            oPanel.Hint := '{"src":"'+dwGetStr(gjoMenus._(oPanel.Tag).hint,'normal')+'"}';
        end;

    end;

    // 遍历 MainMenu1 中的所有菜单项，找到与caption相同的，执行菜单事件
    for iItem := 0 to gjoMenus._Count - 1 do begin
        if gjoMenus._(iItem).caption = sCaption then begin
            // 执行找到的菜单项的事件处理
            oMenu   := TMenuItem(FindComponent(gjoMenus._(iItem).name));
            if oMenu <> nil then begin
                oMenu.Click;
            end;
        end;
    end;

    //
    oPanel  := TPanel(Sender);
    oPanel.Hint := '{"src":"'+dwGetStr(gjoMenus._(oPanel.Tag).hint,'active')+'"}';
end;

//选择主题按钮事件
procedure TForm1.BtThmClick(Sender: TObject);
begin
    PnH.Visible    := True;
end;

//主题切换按钮事件
procedure TForm1.BTThemeClick(Sender: TObject);
var
    sName   : string;
    iTheme  : Integer;
begin
    //得到名称，名称和主题的序号对应
    sName   := TButton(Sender).Name;
    Delete(sName,1,2);
    iTheme  := StrToIntDef(sName,0);

    //切换主题
    dwfChangeTheme(self,iTheme,1);

    //隐藏
    PnH.Visible    := False;

    //写入cookie以备用
    dwSetCookie(self,'dwdTheme',IntToStr(iTheme),30*24);
end;

//登出按钮事件
procedure TForm1.BtLogoutClick(Sender: TObject);
begin
    PnLogout.Visible    := True;

    //为当前操作添加记录
    dwAddShowHistory(Self,[],[PnLogout]);

end;

//重新登录
procedure TForm1.BRClick(Sender: TObject);
begin
    gjoUserInfo := null;
    //如果没找到登录信息，则重新登录（调用通用登录模块）
    dwOpenUrl(self,'/glogin?dwGMS','_self');
end;
//avatar有点问题!

//窗体创建事件
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //将当前操作保存到日志表dwLog中
    dwfAddLog(Self,'logout');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    //释放仅为设计时使用的图标库
    ImageList_dw.Destroy;
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    sCookie     : String;
begin
    if not gbMobile then begin
        //读取保存的主题序号
        sCookie := dwGetCookie(self,'dwdTheme');
        dwfChangeTheme(self,StrToIntDef(SCookie,0),0);

        //设置菜单默认的折叠状态
        sCookie := dwGetCookie(self,'dwdExpand');
        dwfSetMenuExpand(self,sCookie <> '0');
    end;

    //
    OnMouseDown := nil;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    iTab    : Integer;
    fdpr    : Double;
    //
    oTab    : TCard;
begin
    //说明：
    //当浏览器显示有变化时激活本事件

    try
        //设置为PC模式
        dwSetPCMode(self);

        //针对移动端荣耀/360浏览器的处理
        if gbMobile then begin
            if Width > 1000 then begin
                fdpr    := StrToFloatDef(dwGetProp(Self,'devicepixelratio'),-1);
                if fdpr > 0 then begin
                    Width   := Round(Width/fdpr);
                    Height  := Round(Height/fdpr);
                end;
            end;
        end;

        //更新各TabSheet中内嵌Form的大小
        for iTab := 1 to CP.CardCount-1 do begin
            oTab    := CP.Cards[iTab];
            if oTab.ControlCount>0 then begin
                with TForm(oTab.Controls[0]) do begin
                    BorderStyle := bsNone;
                    Left        := 0;
                    Top         := 0;
                    Width       := oTab.Width;
                    Height      := oTab.Height;
                    Update;
                end;
            end;
        end;


    except
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    sInfo       : String;
    //
    bSuccess    : Boolean;
    bFound      : Boolean;
    //
    joTheme     : Variant;
    joQuickBtn  : Variant;      //当前用户的快捷按钮设置[["产品出库",1],["产品入库",2],.....]
    joMenu      : variant;      //{"count":0,"name":"xxx","imageindex":32,"checked":0,...}
    joRight     : Variant;
    //
    I           : Integer;
    iID         : Integer;
    iBtn        : Integer;
    iMenu       : integer;
    iRight      : Integer;
    iCount      : Integer;
    //
    oMenu       : TMenuItem;    //当前菜单
    //
    sCaption    : string;
    iItem       : Integer;
    iCheckeds   : array[0..4] of integer;
    //
    oPanel      : TPanel;
    oButton     : TButton;
    oFPTool     : TFlowPanel;

begin
    //取得是否为移动端
    gbMobile    := dwIsMobile(Self);


    //
    if gbMobile then begin    //移动端的操作--------------------------------------------------------------------------
        //
    end else begin              //非移动端的操作------------------------------------------------------------------------

        //取得主题配置JSON
        dwLoadFromJson(gjoThemes, ExtractFilePath(Application.ExeName)+'data/themes.json');

        //根据 gjoThemes 动态生成主题按钮
        if gjoThemes <> unassigned then begin
            if gjoThemes.Exists('theme') then begin
                for iItem := 0 to gjoThemes.theme.items._Count - 1 do begin
                    //取得拟设定的主题 JSON 节点对象
                    joTheme := gjoThemes.theme.items._(iItem);

                    //克隆一个切换主题按锯
                    oButton := TButton(CloneComponent(BTTheme));
                    with oButton do begin
                        Parent  := PnH;
                        Name    := 'BT'+IntToStr(iItem);
                        Top     := iItem * 100;
                        Caption := joTheme.name;
                        Hint    := '{"dwstyle":"background-color: '+dwGetStr(joTheme,'menubk','#304156')+'; color: '+dwGetStr(joTheme,'menufont','#304156')+';"}';
                    end;
                end;

                //释放源主题切换按钮
                BTTheme.Destroy;

                //使PnH自动size, 以更好显示
                PnH.AutoSize := False;
                PnH.AutoSize := True;
            end;
        end;

        //显示退出按钮
        BtLogout.Visible    := True;
    end;


    //共同的操作--------------------------------------------------------------------------------------------------------

    //检查登录信息，
    //如果成功，则返回JSON，(以JSON格式保存id,username和canvasid)
    //否则返回空
    //参数1为登录配置文件名，默认存入在Runtime|Data目录
    //参数2为当前数据库连接
    sInfo       := glCheckLoginInfo('dwGMS',FDConnection1);

    //将登录信息转换为JSON
    gjoUserInfo := _json(sInfo);
    //<检查登录信息是否正确
    bSuccess    := False;    //默认登录信息无效
    if gjoUserInfo <> unassigned then begin
        if gjoUserInfo.Exists('id') and gjoUserInfo.Exists('username') and gjoUserInfo.Exists('canvasid') then begin
            //设置当前登录信息有效
            bSuccess    := True;
        end;
    end;
    //>

    //如果登录信息有效，则载入Home页
    if bSuccess then begin

        //将当前操作保存到日志表dwLog中
        dwfAddLog(Self,'login');

        //查看用户表数据 ，取得uAvatar, uRole, uQuickButton 等信息
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'SELECT * FROM sys_User WHERE uId = '+gjoUserInfo.id;
        FQ_Temp.Open;

        //取得用户头像avatar
        gjoUserInfo.avatar      := FQ_Temp.FieldByName('uAvatar').AsString;

        //取得角色名称
        gjoUserInfo.rolename    := FQ_Temp.FieldByName('uRole').AsString;;

        //取得用户的快捷按钮设置
        gjoUserInfo.quickbutton := _json(FQ_Temp.FieldByName('uQuickButton').AsString);

        //将当前设备id即canvasid写入eUser表的userdevice字段，以实现单点登录
        FQ_Temp.Edit;
        FQ_Temp.FieldByName('uDevice').AsString  := gjoUserInfo.canvasid;
        FQ_Temp.Post;

        //取当前权限，赋给gjoRights
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'SELECT rData FROM sys_Role WHERE rName='''+String(gjoUserInfo.rolename)+'''';
        FQ_Temp.Open;

        //取得当前角色的权限
        gjoRights           := _json(FQ_Temp.FieldByName('rData').AsString);
        if gjoRights = unassigned then begin
            gjoRights   := _json('[]');
        end;

        //显示用户名称
        LaUser.Caption  := gjoUserInfo.username;
        PnB.Left        := 0;

        //先将所有菜单项->json数组,
        //形如:[{"count":3,"name":"xxx","caption":"xxx",checked:0,"imageindex":12,"hint":{"normal":"xxx","active":"xxxx"}},....]
        dwfGetMenuLeafJson(MainMenu1,gjoMenus);

        //根据当前角色控制菜单。先设置待删除的菜单项ImageIndex为-999，然后再逆序删除
        //1 隐藏不显示的菜单项
        //2 设置不能运行的菜单项

        //设置各菜单项权限, 包括可见性和可用性, superadmin不限制权限, 以防止个别菜单由于角色限制永久无法访问
        if gjoUserInfo.username <> 'superadmin' then begin
            //逐个菜单项处理, 通过预选 读取的菜单项json数组
            for iMenu := 0 to gjoMenus._Count - 1 do begin
                //取得当前菜单项json对象
                joMenu  := gjoMenus._(iMenu);

                //根据菜单项json对象的name属性找到该菜单
                oMenu   := TMenuItem(FindComponent(joMenu.name));

                //对当前菜单进行处理
                if oMenu <> nil then begin

                    //默认不显示
                    oMenu.Visible   := False;
                    oMenu.Enabled   := False;
                    joMenu.visible  := 0;
                    joMenu.enabled  := 0;

                    //
                    for iRight := 0 to gjoRights._Count - 1 do begin
                        joRight := gjoRights._(iRight);
                        if String(joRight._(0)) = joMenu.caption then begin
                            //=====找到对应的权限

                            //可见性
                            if Integer(joRight._(1)) = 1 then begin
                                oMenu.Visible   := True;
                                joMenu.visible  := 1;
                            end;

                            //可用性
                            if Integer(joRight._(2)) = 1 then begin
                                oMenu.Enabled   := True;
                                joMenu.enabled  := 1;
                            end;

                            //
                            break;
                        end;
                    end;
                end;
            end;
        end;

        //<如果快捷按钮设置为空，则自动添加前面的7个非枝节点
        if gjoUserInfo.quickbutton = unassigned then begin
            //创建
            gjoUserInfo.quickbutton := _json('[]');
            //添加到配置
            iCount  := 0;
            for I := 0 to gjoMenus._Count - 1 do begin
                joMenu  := gjoMenus._(I);
                if (joMenu.count = 0) and (joMenu.visible = 1) and (joMenu.enabled = 1) then begin
                    joQuickBtn  := _json('[]');
                    joQuickBtn.Add(joMenu.caption); //菜单项名称
                    joQuickBtn.Add(I+1);            //菜单项默认的图标序号
                    //
                    gjoUserInfo.quickbutton.Add(joQuickBtn);

                    //
                    Inc(iCount);
                    //
                    if iCount >=8 then begin
                        break;
                    end;
                end;
            end;
        end;
        //>

        //清除快捷按钮中菜单项没有或禁用的
        for iBtn := gjoUserInfo.quickbutton._Count - 1 downto 0 do begin
            //取得快捷按钮标题
            sCaption    := gjoUserInfo.quickbutton._(iBtn)._(0);

            //在菜单项中查找
            bFound      := False;
            for iMenu := 0 to gjoMenus._Count - 1 do begin
                joMenu  := gjoMenus._(iMenu);
                if (sCaption = joMenu.caption) and (joMenu.count = 0) and (joMenu.visible = 1) and (joMenu.enabled = 1) then begin
                    bFound  := True;
                    break;
                end;
            end;

            //如果没有找到对应的菜单项, 则删除
            if not bFound then begin
                gjoUserInfo.quickbutton.Delete(iBtn);
            end;
        end;

        //启动系统时钟
        TS.Enabled      := True;

        if gbMobile then begin    //移动端的操作--------------------------------------------------------------------------
            //隐藏左侧面板
            PL.Visible          := False;

            //顶部稍增高一些
            PT.Height           := 50;

            //设置CardPanel为无标题样式
            CP.HelpKeyword      := '';

            //隐藏"主题" "用户名" "退出"
            BtThm.Visible       := False;
            PnB.Visible         := False;
            BtLogout.Visible    := False;

            //标题居中显示
            LT.Align            := alClient;
            LT.Alignment        := taCenter;

            //释放主题选项的面板
            PnH.destroy;

            //取得底部按钮数量
            iCount  := 0;
            for I := 0 to gjoMenus._Count - 1 do begin
                if gjoMenus._(I).checked then begin
                    iCheckeds[iCount]   := I;
                    Inc(iCount);
                    //
                    if iCount > 4 then begin
                        break;
                    end;
                end;
            end;

            //<创建底部工具栏
            oFPTool     := TFlowPanel.Create(Self);
            with oFPTool do begin
                Parent      := self;
                Name        := 'FPTool';
                Align       := alBottom;
                Height      := 60;
                HelpKeyword := 'auto';
                HelpContext := 10000+iCount;
                AutoSize    := False;
                Color       := RGB(250,250,250);
                Hint        := '{"dwstyle":"border-top: solid 1px #f0f0f0;"}';  //顶部显示一条线
            end;

            //创建底部工具按钮
            for I := 0 to iCount-1 do begin
                oPanel  := TPanel.Create(Self);
                with oPanel do begin
                    Name        := 'PnT'+IntTostr(I);
                    Caption     := gjoMenus._(iCheckeds[I]).caption;
                    Parent      := oFPTool;
                    HelpKeyword := 'button';
                    Height      := 50;
                    Color       := clNone;      //透明色
                    Font.Size   := 10;
                    if I = 0 then begin
                        Hint        := '{"src":"'+dwGetStr(gjoMenus._(iCheckeds[I]).hint,'active')+'"}';
                    end else begin
                        Hint        := '{"src":"'+dwGetStr(gjoMenus._(iCheckeds[I]).hint,'normal')+'"}';
                    end;
                    OnClick     := OnClickMenuByName;

                    AlignWithMargins    := True;
                    Margins.SetBounds(0,0,0,10);

                    //
                    Tag     := iCheckeds[I];
                end;
            end;
            //>
        end;

        //显示首页
        dwfShowHome(Form1, TForm_sys_Home, TForm(Form1.Form_sys_Home));

    end else begin
        gjoUserInfo     := null;
        //如果没找到登录信息，则重新登录（调用通用登录模块）
        dwOpenUrl(self,'/glogin?dwGMS','_self');
    end;
end;

procedure TForm1.FormUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
    //统一回退事件
    OnBack(Self);
end;

procedure TForm1.P10Click(Sender: TObject);
var
    iButton     : Integer;
    sCaption    : string;

    //根据标题, 找到指定的菜单, 并点击
    procedure FindMenuItemAndClick(menuItemCaption: string; parentMenu: TMenuItem);
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
begin

    //取得当前按钮caption， 通过caption触发事件
    sCaption := (Sender as TPanel).Caption; // 获取当前按钮的 Caption

    // 遍历 MainMenu1 中的所有菜单项，找到与caption相同的，执行菜单事件
    for iButton := 0 to MainMenu1.Items.Count - 1 do begin
        if MainMenu1.Items[iButton].Caption = sCaption then begin
            // 执行找到的菜单项的事件处理
            MainMenu1.Items[iButton].Click;
        end else begin
            // 在子菜单中查找
            FindMenuItemAndClick(sCaption, MainMenu1.Items[iButton]);
        end;
    end;
end;

//模块切换时, 自动激活该功能模块窗体的 OnActivate 事件
procedure TForm1.PMChange(Sender: TObject);
var
    oForm   : TForm;
begin
    if CP.ActiveCardIndex > 0 then begin
        oForm   := TForm(CP.ActiveCard.Controls[0]);

        //
        if oForm is TForm then begin
            if Assigned(oForm.OnActivate) then begin
                oForm.OnActivate(oForm);
            end;
        end;
    end;
end;



procedure TForm1.PnLogoutEnter(Sender: TObject);
begin
    try
        //将当前登录信息保存到日志表dwLog中
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'INSERT INTO sys_Log(lMode,lDate,lUserName,lCanvasId,lIp)'
                +' VALUES('
                +''''+'logout'+''','
                +''''+FormatDateTime('yyyy-MM-DD hh:mm:ss',Now)+''','
                +''''+gjoUserInfo.username+''','
                +''''+gjoUserInfo.canvasid+''','
                +''''+dwGetProp(self,'ip')+''''
                +')';
        FQ_Temp.ExecSQL;

        //清除COOKIE
        glClearLoginInfo('dwGMS',self);

        //如果没找到登录信息，则重新登录（调用通用登录模块）
        dwOpenUrl(self,'/glogin?dwGMS','_self');
    except

    end;
end;

procedure TForm1.PnLogoutExit(Sender: TObject);
begin

    //为当前操作删除历史记录
    dwRemoveLastHistory(self);

end;

//检查是否双击, 如果双击, 则重载当前模块
//Tabsheet的标题 Click 时 激活 OnEnter事件
procedure TForm1.Ts1Enter(Sender: TObject);
var
    oTab        : TCard;
    oMenu       : TMenuItem;
    //
    sMenuName   : String;
begin
    //检查是否双击, 如果双击, 则重载当前模块
    if GetTickCount - giTabClick < 400 then begin

        //取得当前 tabsheet
        oTab        := TCard(Sender);

        //取得菜单项名称
        sMenuName   := dwGetProp(oTab,'menu');

        //取得菜单
        oMenu       := TMenuItem(FindComponent(sMenuName));

        //异常处理
        if oMenu = nil then begin
            Exit;
        end;

        //先删除当前模块
        dwDeleteControl(oTab);

        //重新打开
        oMenu.OnClick(oMenu);
    end;

    //记录当前点击时间, 以下次击时检查是否双击
    giTabClick  := GetTickCount;
end;

procedure TForm1.TSTimer(Sender: TObject);
var
    iItem       : Integer;
    oTab        : TCard;
begin
{
    //如果当前用户已登录, 则写入用户表
    if gjoUserInfo.Exists('id') then begin
        //<检查当前用户是否有其他设备登录，如果有其他设备登录，则退出，重新登录
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'SELECT uDevice,uLastLive FROM eUser WHERE uId = '+gjoUserInfo.id;
        FQ_Temp.Open;

        //检查当前用户表 eUser中的登录设备唯一标识 uDevice 是不是和当前的一致
        if FQ_Temp.FieldByName('uDevice').AsString <> gjoUserInfo.canvasid then begin
            ////PR.Visible   := True;
        end else begin
            //将当前时间写入到用户表中
            FQ_Temp.Edit;
            FQ_Temp.FieldByName('uLastLive').AsDateTime  := Now;
            FQ_Temp.Post;
        end;
    end;
    //>
}
    //删除所有不可见的imageindex为-1的TabSheet
    //为什么要在这里设置,是因为在子模块中无法使用dwDeleteControl删除所在的Form
    //所以, 在子模块中如果要删除当前模块, 可以先标记, 然后在unit1中定时清除
    for iItem := CP.CardCount - 1 downto 1 do begin
        oTab    := CP.Cards[iItem];
        if (oTab.CardVisible = False) and (oTab.ShowCaption = True) then begin
            dwDeleteControl(oTab);
        end;
    end;
end;


end.
