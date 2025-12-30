unit unit1;
{
说明：本窗体为应用主窗体，仅提供菜单，PageControl等基础框架服务
}

interface

uses
    //deweb基本单元
    dwBase,

    //增删改查单元
    dwCrudPanel,

    //基本单元
    dwfBase,

    //通用登录控制单元
    gLogin,


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
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL;

type
  TForm1 = class(TForm)
    PT: TPanel;
    LT: TLabel;
    ImageList_dw: TImageList;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    MainMenu1: TMainMenu;
    MIHome: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Mu3: TMenuItem;
    FQ_Temp: TFDQuery;
    FDQuery_Timer: TFDQuery;
    TS: TTimer;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    N16: TMenuItem;
    N27: TMenuItem;
    N35: TMenuItem;
    N5: TMenuItem;
    N36: TMenuItem;
    N18: TMenuItem;
    N38: TMenuItem;
    N39: TMenuItem;
    N1: TMenuItem;
    Label1: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure BtThmClick(Sender: TObject);
    procedure BtLogoutClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure BTThemeClick(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private
    { Private declarations }
  public

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

procedure TForm1.N9Click(Sender: TObject);
begin
end;

//选择主题按钮事件
procedure TForm1.BtThmClick(Sender: TObject);
begin
end;

//主题切换按钮事件
procedure TForm1.BTThemeClick(Sender: TObject);
begin
end;

//登出按钮事件
procedure TForm1.BtLogoutClick(Sender: TObject);
begin
end;

//重新登录
procedure TForm1.BRClick(Sender: TObject);
begin
    gjoUserInfo := null;
    //如果没找到登录信息，则重新登录（调用通用登录模块）
    dwOpenUrl(self,'/glogin?mobilelogin','_self');
end;
//avatar有点问题!

//窗体创建事件
procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin

    //说明：
    //当浏览器显示有变化时激活本事件
    dwSetMobileMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    sInfo       : String;
    //
    bSuccess    : Boolean;
    //
    joTheme     : Variant;
    joQuickBtn  : Variant;      //当前用户的快捷按钮设置[["产品出库",1],["产品入库",2],.....]
    //
    I           : Integer;
    iID         : Integer;
    //
    oMenu       : TMenuItem;    //当前菜单
    //
    slMenu      : TStringList;  //用于保存菜单的所有叶节点
    iItem       : Integer;
    //
    oPanel      : TPanel;
    oButton     : TButton;

    //设置菜单的可见性visible和可用性Enabled,
    //通过读取对应gjoRights中的AID项
    //采用递归方式
    procedure _SetMenuItem(AItem:TMenuItem;var AID:Integer);
    var
        II      : Integer;
        joRight : Variant;
    begin
        //默认不可见/不可用
        AItem.Visible   := False;
        AItem.Enabled   := False;

        //在当前权限表中查找同名项，以赋值
        if AID < gjoRights._Count then begin
            joRight         := gjoRights._(AID);
            AItem.Visible   := joRight._(1)=1;
            AItem.Enabled   := joRight._(2)=1;
        end;

        //增加序号AID
        Inc(AID);

        //递归设置其子菜单项
        for II := 0 to AItem.Count-1 do begin
            _SetMenuItem(AItem.Items[II],AID);
        end;
    end;
begin



    //检查登录信息，
    //如果成功，则返回JSON，(以JSON格式保存id,username和canvasid)
    //否则返回空
    //参数1为登录配置文件名，默认存入在Runtime|Data目录
    //参数2为当前数据库连接
    sInfo       := glCheckLoginInfo('mobilelogin',FDConnection1);

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

        //查看用户表数据 ，保存gjoUserInfo.rolename
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
        FQ_Temp.SQL.Text    :=
                'SELECT rData'
                +' FROM sys_Role'
                +' WHERE rName='''+String(gjoUserInfo.rolename)+'''';
        FQ_Temp.Open;


    end else begin
        gjoUserInfo     := null;
        //如果没找到登录信息，则重新登录（调用通用登录模块）
        dwOpenUrl(self,'/glogin?mobilelogin','_self');
    end;
end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string;
begin
    //===主要处理DeWeb的交互事件


    //取得交互的事件名称
    sMethod := dwGetProp(Self,'interactionmethod');

    //通过类似以下得到返回的事件结果，为'1'时表示为"确定"，否则为"取消"
    sValue  := dwGetProp(Self,'interactionvalue');

    //根据事件名称和事件结果进行处理
    if sMethod = 'query_logout' then  begin
        if sValue = '1' then begin

            //清除COOKIE
            glClearLoginInfo('mobilelogin',self);

            //如果没找到登录信息，则重新登录（调用通用登录模块）
            dwOpenUrl(self,'/glogin?MobileLogin','_self');
        end;
    end;
end;






procedure TForm1.Label1Click(Sender: TObject);
begin
    dwMessageDlg('确定要注销登录吗？','注销','确定','取消','query_logout',self);

end;

end.
