unit unit1;

interface

uses
    Unit_Inventory,
    Unit_StockIn,
    Unit_StockOut,
    Unit_StockInQuery,
    Unit_StockOutQuery,
    Unit_User,
    Unit_UserRole,
    Unit_Product,
    Unit_Warehouse,
    Unit_Supplier,
    Unit_Requisition,
    Unit_Stat,
    Unit_Document,
    Unit_Card,
    Unit_Show,

    //
    dwBase,

    //JSON解析处理单元
    SynCommons,


    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
    Vcl.Buttons, Data.DB, Data.Win.ADODB,
    //
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
    FireDAC.Comp.DataSet,
    //
    Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_Client: TPanel;
    Panel_0_Banner: TPanel;
    Panel_Title: TPanel;
    PageControl1: TPageControl;
    TabSheet_Home: TTabSheet;
    Label_Title: TLabel;
    Label3: TLabel;
    TabSheet_Inventory: TTabSheet;
    TabSheet_StockIn: TTabSheet;
    TabSheet_StockOut: TTabSheet;
    Panel5: TPanel;
    Panel_Buttons: TPanel;
    Panel11: TPanel;
    SpeedButton_StockOutQuery: TSpeedButton;
    Panel12: TPanel;
    SpeedButton_StockInQuery: TSpeedButton;
    Panel14: TPanel;
    SpeedButton_StockOut: TSpeedButton;
    Panel15: TPanel;
    SpeedButton_Inventory: TSpeedButton;
    Panel16: TPanel;
    SpeedButton_StockIn: TSpeedButton;
    Panel17: TPanel;
    SpeedButton_User: TSpeedButton;
    Panel18: TPanel;
    SpeedButton_Supplier: TSpeedButton;
    Panel6: TPanel;
    Image1: TImage;
    Label_Welcome: TLabel;
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
    TabSheet_User: TTabSheet;
    TabSheet_Supplier: TTabSheet;
    TabSheet_Requisition: TTabSheet;
    TabSheet_Warehouse: TTabSheet;
    TabSheet_Product: TTabSheet;
    TabSheet_StockInQuery: TTabSheet;
    TabSheet_StockOutQuery: TTabSheet;
    TabSheet_Stat: TTabSheet;
    MainMenu: TMainMenu;
    MenuItem_Inventory: TMenuItem;
    MenuItem_StockIn: TMenuItem;
    MenuItem_StockOut: TMenuItem;
    N4: TMenuItem;
    MenuItem_Supplier: TMenuItem;
    MenuItem_Requisition: TMenuItem;
    MenuItem_Warehouse: TMenuItem;
    MenuItem_Product: TMenuItem;
    MenuItem_StockInQuery: TMenuItem;
    MenuItem_StockOutQuery: TMenuItem;
    MenuItem_Stat: TMenuItem;
    Panel_Menu: TPanel;
    MenuItem_Home: TMenuItem;
    N14: TMenuItem;
    MenuItem_User: TMenuItem;
    Menu: TMenuItem;
    MenuItem_Option: TMenuItem;
    Button_Collapse: TButton;
    Panel13: TPanel;
    SpeedButton_Requisition: TSpeedButton;
    TabSheet_UserRole: TTabSheet;
    MenuItem_Document: TMenuItem;
    TabSheet_Document: TTabSheet;
    MenuItem_Card: TMenuItem;
    TabSheet_Card: TTabSheet;
    Label_User: TLabel;
    Button_Logout: TButton;
    Button_Register: TButton;
    Button_Login: TButton;
    StringGrid1: TStringGrid;
    Panel_LoginForm: TPanel;
    Image_bg: TImage;
    Panel_Login: TPanel;
    Image_Logo: TImage;
    Edit_User: TEdit;
    Edit_Password: TEdit;
    Panel1: TPanel;
    Panel2: TPanel;
    Edit_Captcha: TEdit;
    Panel3: TPanel;
    CheckBox_Rem: TCheckBox;
    Button_Log: TButton;
    Panel_Register: TPanel;
    Image3: TImage;
    Button1: TButton;
    Edit_NewPsd: TEdit;
    Edit_NewUser: TEdit;
    Panel20: TPanel;
    Edit_RegCaptcha: TEdit;
    Panel24: TPanel;
    Edit_NewPsdConfirm: TEdit;
    Label_Register: TLabel;
    Label_Captcha: TLabel;
    Label_RegCaptcha: TLabel;
    Panel19: TPanel;
    Label_ToLogin: TLabel;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    procedure PageControl1Change(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControl1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure MenuItem_InventoryClick(Sender: TObject);
    procedure MenuItem_StockInClick(Sender: TObject);
    procedure MenuItem_StockOutClick(Sender: TObject);
    procedure MenuItem_HomeClick(Sender: TObject);
    procedure SpeedButton_InventoryClick(Sender: TObject);
    procedure SpeedButton_StockInClick(Sender: TObject);
    procedure SpeedButton_StockOutClick(Sender: TObject);
    procedure MenuItem_StockInQueryClick(Sender: TObject);
    procedure MenuItem_StockOutQueryClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SpeedButton_StockInQueryClick(Sender: TObject);
    procedure SpeedButton_StockOutQueryClick(Sender: TObject);
    procedure MenuItem_UserClick(Sender: TObject);
    procedure Button_CollapseClick(Sender: TObject);
    procedure SpeedButton_UserClick(Sender: TObject);
    procedure SpeedButton_SupplierClick(Sender: TObject);
    procedure MenuItem_WarehouseClick(Sender: TObject);
    procedure MenuItem_SupplierClick(Sender: TObject);
    procedure MenuClick(Sender: TObject);
    procedure MenuItem_ProductClick(Sender: TObject);
    procedure MenuItem_RequisitionClick(Sender: TObject);
    procedure MenuItem_StatClick(Sender: TObject);
    procedure MenuItem_DocumentClick(Sender: TObject);
    procedure MenuItem_CardClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_LogoutClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button_LoginClick(Sender: TObject);
    procedure Button_RegisterClick(Sender: TObject);
    procedure Button_LogClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Label_RegisterClick(Sender: TObject);
    procedure Label_ToLoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    giUserId : Integer;
    Form_Inventory      : TForm_Inventory;      //库存查询
    Form_StockIn        : TForm_StockIn;        //入库
    Form_StockOut       : TForm_StockOut;       //出库
    Form_StockInQuery   : TForm_StockInQuery;   //入库单查询
    Form_StockOutQuery  : TForm_StockOutQuery;  //出库单查询
    Form_User           : TForm_User;           //用户管理
    Form_UserRole       : TForm_UserRole;       //角色管理
    Form_Product        : TForm_Product;        //产品管理
    Form_Warehouse      : TForm_Warehouse;      //仓库管理
    Form_Supplier       : TForm_Supplier;       //供应商管理
    Form_Requisition    : TForm_Requisition;    //领料单位
    Form_Stat           : TForm_Stat;           //统计
    Form_Document       : TForm_Document;       //资料管理
    Form_Card           : TForm_Card;           //用户卡片
    Form_Show           : TForm_Show;           //弹出式窗体，用于添加新供应商
    gsMainDir   : String;
const
    _config = '{'
            +'"tablename":"dw_user",'                   //数据表名
            +'"fields":["uid","username","salt","psd"],'//关键字段名，依次分别为用户id,用户名，盐，密码
            +'"successurl":"/dwms",'                    //成功后跳转的URL
            +'"cookie":["bbs_user","bbs123"],'          //成功后写入的COOKIE名称,和加密字符串
            +'"error":"账号或密码或验证码错误"'
            +'}';
  end;

var
    Form1       : TForm1;

implementation

{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);
var
    joConfig    : Variant;
    joUser      : Variant;
    //
    iUid        : Integer;
    sName       : String;
    sPassword   : String;
    sSalt       : String;
    sCookie     : string;
    sValue      : string;
    sInfo       : string;
    bRegister   : Boolean;
begin
    //检查配置文件是否合法的JSON字符串.如果不是,则提示,退出
    if not dwStrIsJson(_config) then begin
        dwMessage('配置信息不正确,请检查!','error',self);
        Exit;
    end;
    if Length(Trim(Edit_NewUser.Text))<4 then begin
        dwMessage('用户名不能少于4个字符!','error',self);
        Exit;
    end;
    if Length(Trim(Edit_NewPsd.Text))<6 then begin
        dwMessage('密码不能少于6个字符!','error',self);
        Exit;
    end;
    if lowercase(Edit_RegCaptcha.Text) <> lowercase(Label_RegCaptcha.Caption) then begin
        dwMessage('验证码不正确,请重新输入!','error',self);
        Exit;
    end;
    if Edit_NewPsd.Text <> Edit_NewPsdConfirm.Text then begin
        dwMessage('密码和确认密码不一致!','error',self);
        Exit;
    end;


    //创建配置JSON对象,以备后面使用
    joConfig    := _JSON(_config);

    try
        //设置注册标识默认为未注册
        bRegister   := False;


        //在数据表中内查询
        FDQuery1.Close;
        FDQuery1.SQL.Text   := 'SELECT ['+joConfig.fields._(1)+'] '
                +' FROM '+joConfig.tablename
                +' WHERE ('+joConfig.fields._(1)+'='''+Trim(Edit_NewUser.Text)+''')';
                    // or (email='''+Edit_Mail.Text+''')';
        FDQuery1.Open;

        //检查
        if FDQuery1.IsEmpty then begin
            //
            sSalt       := FormatDateTime('YYYYMMDDhhmmsszzz',Now);
            sPassword   := dwGetMD5(dwGetMD5(Edit_NewPsd.Text)+sSalt);
            sName       := Trim(Edit_NewUser.Text);

            //
            FDQuery1.close;
            FDQuery1.SQL.Text  := 'INSERT INTO '+joConfig.tablename
                    +' (username,salt,psd)'
                    +' VALUES('''+sName+''','''+sSalt+''','''+sPassword+''')';
            FDQuery1.ExecSQL;

            //取得当前UID
            FDQuery1.close;
            FDQuery1.SQL.Text  := 'SELECT uid FROM '+joConfig.tablename+' WHERE username='''+sName+'''';
            FDQuery1.Open;
            iUid    := FDQuery1.FieldByName('uid').AsInteger;


            //把注册数据保存在JSON字符串中,以便写入更多数据, 如id等
            joUser  := _json('{}');
            joUser.uid      := iUid;
            joUser.name     := sName;
            joUser.logindate:= dwDateToPHPDate(Now);
            sInfo   := joUser;

            //写入cookie. 对写入值进行加密
            sCookie := joConfig.cookie._(0);
            sValue  := joConfig.cookie._(1);
            sValue  := dwAESEncrypt(sInfo,sValue);
            dwSetCookiePro(self,sCookie,sValue,'/','.delphibbs.com',30*24);

            //下面是检查验证码. 验证码可点击自动切换
            dwOpenUrl(self,'/dwms','_self');
        end else begin
            dwMessage(joConfig.error,'error',self);
        end;
    except
        dwMessage('配置信息不正确,请检查!','error',self);
        Exit;
    end;

end;

procedure TForm1.Button_CollapseClick(Sender: TObject);
begin
    if MainMenu.AutoMerge then begin
        Panel_Menu.Width        := 200;
        Label_Title.Caption     := 'D.W.M.S';
        Label_Title.Font.Size   := 18;
        Button_Collapse.Hint    := '{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}';
    end else begin
        Panel_Menu.Width        := 48;
        Label_Title.Caption     := '.W.';
        Label_Title.Font.Size   := 11;
        Button_Collapse.Hint    := '{"icon":"el-icon-s-unfold","type":"text","color":"#EEE"}';
    end;
    Panel_Title.Width   := Panel_Menu.Width;
    //更新菜单位置
    MainMenu.AutoMerge  := not MainMenu.AutoMerge;
    //
    dwSetCompLTWH(MainMenu,0,Panel_Menu.Top,Panel_Menu.Width-1,Panel_Menu.Height);
end;

procedure TForm1.Button_LogClick(Sender: TObject);
var
    joConfig    : Variant;
    joUser      : Variant;
    //
    iUid        : Integer;
    sName       : String;
    sPassword   : String;
    sSalt       : String;
    sCookie     : string;
    sValue      : string;
    sInfo       : string;
    bLogin      : Boolean;
begin
    //检查配置文件是否合法的JSON字符串.如果不是,则提示,退出
    if not dwStrIsJson(_config) then begin
        dwMessage('配置信息不正确,请检查!','error',self);
        Exit;
    end;
    if lowercase(Edit_Captcha.Text) <> lowercase(Label_Captcha.Caption) then begin
        dwMessage('验证码不正确,请检查!','error',self);
        Exit;
    end;

    //创建配置JSON对象,以备后面使用
    joConfig    := _JSON(_config);

    //检查用户名信息是否正确
    try
        //设置登录标识默认为未登录
        bLogin  := False;


        //在数据表中内查询
        FDQuery1.Close;
        FDQuery1.SQL.Text   := 'SELECT ['+joConfig.fields._(0)+'],['+joConfig.fields._(1)+'],['+joConfig.fields._(2)+'],['+joConfig.fields._(3)+'] '
                +' FROM '+joConfig.tablename
                +' WHERE '+joConfig.fields._(1)+'='''+Trim(Edit_User.Text)+'''';
        FDQuery1.Open;

        //检查ovnr
        if not FDQuery1.IsEmpty then begin
            //得到数据表内的信息备用
            iUid        := FDQuery1.Fields[0].AsInteger;
            sName       := FDQuery1.Fields[1].AsString;
            sSalt       := FDQuery1.Fields[2].AsString;
            sPassword   := FDQuery1.Fields[3].AsString;
            //
            //检查正确性
            if sPassword = dwGetMD5(dwGetMD5(Edit_Password.Text)+sSalt) then begin
                //设置登录正确
                bLogin  := True;

                //把登录数据保存在JSON字符串中,以便写入更多数据, 如id等
                joUser  := _json('{}');
                joUser.uid      := iUid;
                joUser.name     := sName;
                joUser.logindate:= dwDateToPHPDate(Now);
                sInfo   := joUser;

                //写入cookie. 对写入值进行加密
                sCookie := joConfig.cookie._(0);
                sValue  := joConfig.cookie._(1);
                sValue  := dwAESEncrypt(sInfo,sValue);
                //根据是否记住密码进行处理
                if CheckBox_Rem.Checked then begin
                    dwSetCookie(self,sCookie,sValue,30*24);
                    dwSetCookiePro(self,sCookie,sValue,'/','.delphibbs.com',30*24);
                end else begin
                    dwSetCookie(self,sCookie,sValue,0);
                    dwSetCookiePro(self,sCookie,sValue,'/','.delphibbs.com',0);
                end;

                //下面是检查验证码. 验证码可点击自动切换
                dwOpenUrl(self,joConfig.successurl,'_self');
            end;
        end;

        //
        if not bLogin then begin
            dwMessage(joConfig.error,'error',self);
        end;
    except
        dwMessage('配置信息不正确,请检查!','error',self);
        Exit;
    end;

end;

procedure TForm1.Button_LoginClick(Sender: TObject);
begin
    Panel_LoginForm.Visible := True;
    Panel_Login.Visible     := True;
    Panel_Register.Visible  := False;
end;

procedure TForm1.Button_LogoutClick(Sender: TObject);
begin
    dwMessageDlg('确定要注销登录吗？','注销','确定','取消','query_logout',self);

end;

procedure TForm1.Button_RegisterClick(Sender: TObject);
begin
    Panel_LoginForm.Visible := True;
    Panel_Login.Visible     := False;
    Panel_Register.Visible  := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    //
    PageControl1.ActivePageIndex    := 0;
    //
    giUserID    := -1;
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
    dwSetCompLTWH(MainMenu,0,Panel_Menu.Top,Panel_Menu.Width-1,Panel_Menu.Height);


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

    //设置登录/注册面板
    Panel_LoginForm.Left    := 0;
    Panel_LoginForm.Top     := 0;
    Panel_LoginForm.Width   := Width;
    Panel_LoginForm.Height  := Height;

end;

procedure TForm1.FormShow(Sender: TObject);
var
    sCookie : string;
    iDemo   : Integer;
    oPanel  : TPanel;
    joUser  : Variant;
begin

    //读cookie
    try
        //读取cookie
        sCookie    := dwGetCookie(self,'bbs_user');
        //解密
        sCookie    := dwAESDecrypt(sCookie,'bbs123');
        //检查是否json格式字符串
        if dwStrIsJson(sCookie) then begin
            //转换成JSON对象
            joUser      := _json(sCookie);

            //得到用户名和ID
            Label_User.Caption      := joUser.name;
            giUserId                := joUser.uid;

            //显隐控件
            Button_Logout.Left      := 9999;
            Label_User.Visible      := True;
            Button_Logout.Visible   := True;
            BUtton_Login.Visible    := False;
            Button_Register.Visible := False;

            //
            Label_Welcome.Caption   := '欢迎您！ '+Label_User.Caption;
        end else begin
            //显示登录窗体
            //Form_Login  := TForm_Login.Create(self);
            //Form_Login.Parent   := self; //必须将新窗体的Parent设置为Form1
            //dwShowModalPro(self,Form_Login);
            Panel_LoginForm.Visible := True;
            Panel_Login.Visible     := True;
            Panel_Register.Visible  := False;
        end;
    except
    end;
end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string;
begin
    sMethod := dwGetProp(Self,'interactionmethod');
    //通过类似以下得到返回的结果，为'1'时表示为"确定"，否则为"取消"
    sValue  := dwGetProp(Self,'interactionvalue');
    //
    if sMethod = 'query_logout' then  begin
        if sValue = '1' then begin
            //清除COOKIE
            dwSetCookie(self,'bbs_user','',0);
            dwSetCookiePro(self,'bbs_user','','/','.delphibbs.com',0);
            //
            Button_Logout.Visible   := False;
            Label_User.Visible     := False;
            //
            Button_Login.Visible    := True;
            Button_Register.Visible := True;
            //
            giUserID    := -1;
            //
            dwOpenURL(self,'/dwms','_self');
        end;
    end;
end;

procedure TForm1.Label_RegisterClick(Sender: TObject);
begin
    Panel_Login.Visible     := False;
    Panel_Register.Visible  := True;

end;

procedure TForm1.Label_ToLoginClick(Sender: TObject);
begin
    Panel_Login.Visible     := True;
    Panel_Register.Visible  := False;

end;

procedure TForm1.MenuItem_CardClick(Sender: TObject);
begin
    //----------名称夹系统--------------------------------------------------------------------------
    if Form_Card = nil then begin
        //创建FORM
        Form_Card   := TForm_Card.Create(self);
        //嵌入到TabSheet中
        Form_Card.Parent  := TabSheet_Card;
        //设置嵌入标识,必须
        Form_Card.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Card.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Card do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_Card.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Card;
    //默认查询
    Form_Card.Button_Search.OnClick(self);
    //显示用户组列表
    Form_Card.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_DocumentClick(Sender: TObject);
begin
    if Form_Document = nil then begin
        //----------资料管理系统-----------------------------------------------------------------------
        //创建FORM
        Form_Document   := TForm_Document.Create(self);
        //嵌入到TabSheet中
        Form_Document.Parent  := TabSheet_Document;
        //设置嵌入标识,必须
        Form_Document.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Document.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Document do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;


    //显示页面
    TabSheet_Document.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Document;
    //默认查询
    Form_Document.Button_Search.OnClick(self);
    //显示用户组列表
    Form_Document.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_HomeClick(Sender: TObject);
begin
    //切换到该页面
    PageControl1.ActivePageIndex    := 0;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_InventoryClick(Sender: TObject);
begin
    //----------库存查询----------------------------------------------------------------------------
    if Form_Inventory = nil then begin
        //创建FORM
        Form_Inventory   := TForm_Inventory.Create(self);
        //嵌入到TabSheet中
        Form_Inventory.Parent  := TabSheet_Inventory;
        //设置嵌入标识,必须
        Form_Inventory.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Inventory.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Inventory do begin
            //
            Show;
            //
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示"库存查询"页面
    TabSheet_Inventory.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage    := TabSheet_Inventory;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_ProductClick(Sender: TObject);
begin
    //----------产品信息管理------------------------------------------------------------------------
    if Form_Product = nil then begin
        //创建FORM
        Form_Product   := TForm_Product.Create(self);
        //嵌入到TabSheet中
        Form_Product.Parent  := TabSheet_Product;
        //设置嵌入标识,必须
        Form_Product.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Product.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Product do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_Product.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Product;
    //默认查询
    Form_Product.Button_Search.OnClick(self);
    //显示用户组列表
    Form_Product.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_RequisitionClick(Sender: TObject);
begin
    if Form_Requisition = nil then begin
        //----------领料单位信息管理--------------------------------------------------------------------
        //创建FORM
        Form_Requisition   := TForm_Requisition.Create(self);
        //嵌入到TabSheet中
        Form_Requisition.Parent  := TabSheet_Requisition;
        //设置嵌入标识,必须
        Form_Requisition.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Requisition.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Requisition do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_Requisition.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Requisition;
    //默认查询
    Form_Requisition.Button_Search.OnClick(self);
    //显示用户组列表
    Form_Requisition.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_StatClick(Sender: TObject);
begin
    //----------产品入库----------------------------------------------------------------------------
    if Form_Stat = nil then begin
        //----------分类统计信息管理--------------------------------------------------------------------
        //创建FORM
        Form_Stat   := TForm_Stat.Create(self);
        //嵌入到TabSheet中
        Form_Stat.Parent  := TabSheet_Stat;
        //设置嵌入标识,必须
        Form_Stat.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Stat.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Stat do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_Stat.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Stat;
    //更新信息
    Form_Stat.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_StockInClick(Sender: TObject);
begin
    //----------产品入库----------------------------------------------------------------------------
    if Form_StockIn = nil then begin
        //创建FORM
        Form_StockIn   := TForm_StockIn.Create(self);
        //嵌入到TabSheet中
        Form_StockIn.Parent  := TabSheet_StockIn;
        //设置嵌入标识,必须
        Form_StockIn.HelpKeyword := 'embed';
        //设置数据库连接
        Form_StockIn.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_StockIn do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示"产品入库"页面
    TabSheet_StockIn.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage    := TabSheet_StockIn;
    //默认查询,显示当前库存
    Form_StockIn.UpdateData(1);
    //更新信息
    Form_StockIn.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_StockOutClick(Sender: TObject);
begin
    //----------产品出库库----------------------------------------------------------------------------
    if Form_StockOut = nil then begin
        //创建FORM
        Form_StockOut   := TForm_StockOut.Create(self);
        //嵌入到TabSheet中
        Form_StockOut.Parent  := TabSheet_StockOut;
        //设置嵌入标识,必须
        Form_StockOut.HelpKeyword := 'embed';
        //设置数据库连接
        Form_StockOut.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_StockOut do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示"产品入库"页面
    TabSheet_StockOut.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage   := TabSheet_StockOut;
    //默认查询,显示当前库存
    Form_StockOut.UpdateData(1);
    //更新信息
    Form_StockOut.UpdateInfos;
    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_StockInQueryClick(Sender: TObject);
begin
    //----------入库查询----------------------------------------------------------------------------
    if Form_StockInQuery = nil then begin
        //创建FORM
        Form_StockInQuery   := TForm_StockInQuery.Create(self);
        //嵌入到TabSheet中
        Form_StockInQuery.Parent  := TabSheet_StockInQuery;
        //设置嵌入标识,必须
        Form_StockInQuery.HelpKeyword := 'embed';
        //设置数据库连接
        Form_StockInQuery.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_StockInQuery do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示"库存查询"页面
    TabSheet_StockInQuery.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_StockInQuery;
    //默认查询
    Form_StockInQuery.Button_Search.OnClick(self);

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_StockOutQueryClick(Sender: TObject);
begin
    //----------入库查询----------------------------------------------------------------------------
    if Form_StockOutQuery = nil then begin
        //创建FORM
        Form_StockOutQuery   := TForm_StockOutQuery.Create(self);
        //嵌入到TabSheet中
        Form_StockOutQuery.Parent  := TabSheet_StockOutQuery;
        //设置嵌入标识,必须
        Form_StockOutQuery.HelpKeyword := 'embed';
        //设置数据库连接
        Form_StockOutQuery.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_StockOutQuery do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_StockOutQuery.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_StockOutQuery;
    //默认查询
    Form_StockOutQuery.Button_Search.OnClick(self);

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_SupplierClick(Sender: TObject);
begin
    if Form_Supplier = nil then begin
        //----------供应商信息管理----------------------------------------------------------------------
        //创建FORM
        Form_Supplier   := TForm_Supplier.Create(self);
        //嵌入到TabSheet中
        Form_Supplier.Parent  := TabSheet_Supplier;
        //设置嵌入标识,必须
        Form_Supplier.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Supplier.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Supplier do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_Supplier.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Supplier;
    //默认查询
    Form_Supplier.Button_Search.OnClick(self);
    //显示用户组列表
    Form_Supplier.UpdateInfos;
    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_UserClick(Sender: TObject);
begin
    //----------用户管理----------------------------------------------------------------------------
    if Form_User = nil then begin
        //创建FORM
        Form_User   := TForm_User.Create(self);
        //嵌入到TabSheet中
        Form_User.Parent  := TabSheet_User;
        //设置嵌入标识,必须
        Form_User.HelpKeyword := 'embed';
        //设置数据库连接
        Form_User.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_User do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_User.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_User;
    //默认查询
    Form_User.Button_Search.OnClick(self);
    //显示用户组列表
    Form_User.UpdateInfos;
    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuItem_WarehouseClick(Sender: TObject);
begin
    if Form_Warehouse = nil then begin
        //----------仓库信息管理------------------------------------------------------------------------
        //创建FORM
        Form_Warehouse   := TForm_Warehouse.Create(self);
        //嵌入到TabSheet中
        Form_Warehouse.Parent  := TabSheet_Warehouse;
        //设置嵌入标识,必须
        Form_Warehouse.HelpKeyword := 'embed';
        //设置数据库连接
        Form_Warehouse.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_Warehouse do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;

    //显示页面
    TabSheet_Warehouse.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_Warehouse;
    //默认查询
    Form_Warehouse.Button_Search.OnClick(self);
    //显示用户组列表
    Form_Warehouse.UpdateInfos;
    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.MenuClick(Sender: TObject);
begin
    //----------角色权限----------------------------------------------------------------------------
    if Form_UserRole = nil then begin
        //创建FORM
        Form_UserRole   := TForm_UserRole.Create(self);
        //嵌入到TabSheet中
        Form_UserRole.Parent  := TabSheet_UserRole;
        //设置嵌入标识,必须
        Form_UserRole.HelpKeyword := 'embed';
        //设置数据库连接
        Form_UserRole.FDQuery1.Connection   := FDQuery1.Connection;
        //设置满框
        With Form_UserRole do begin
            Left    := 0;
            Top     := 0;
            Width   := TTabSheet(Parent).Width;
            Height  := TTabSheet(Parent).Height;
        end;
        //
        DockSite    := True;
    end;


    //显示页面
    TabSheet_UserRole.TabVisible    := True;
    //切换到该页面
    PageControl1.ActivePage     := TabSheet_UserRole;
    //显示角色权限
    Form_UserRole.UpdateInfos;

    //
    dwRunJS('this.dwloading=false',self);

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin
    Label_Title.Caption := PageControl1.ActivePage.Caption;
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

procedure TForm1.SpeedButton_StockOutClick(Sender: TObject);
begin
    MenuItem_StockOut.OnClick(self);
end;

procedure TForm1.SpeedButton_InventoryClick(Sender: TObject);
begin
    MenuItem_Inventory.OnClick(self);
end;

procedure TForm1.SpeedButton_StockOutQueryClick(Sender: TObject);
begin
    MenuItem_StockOutQuery.OnClick(self);

end;

procedure TForm1.SpeedButton_SupplierClick(Sender: TObject);
begin
    MenuItem_Supplier.OnClick(self);
end;

procedure TForm1.SpeedButton_UserClick(Sender: TObject);
begin
    MenuItem_User.OnClick(self);
end;

procedure TForm1.SpeedButton_StockInClick(Sender: TObject);
begin
    MenuItem_StockIn.OnClick(self);
end;

procedure TForm1.SpeedButton_StockInQueryClick(Sender: TObject);
begin
    MenuItem_StockInQuery.OnClick(self);
end;

end.
