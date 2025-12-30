unit unit1;
{
说明：本窗体为应用主窗体，仅提供菜单，PageControl等基础框架服务
}

interface

uses
    //deweb基本单元
    dwBase,

    //自编单元
    Unit_Home,      //首页
//[*uses_start*]

//[*uses_end*]


    //第三方单元
    SynCommons,     //JSON解析单元，来自mormot


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
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup;

type
  TForm1 = class(TForm)
    PageControl_Main: TPageControl;
    P_Banner: TPanel;
    PC: TPanel;
    PL: TPanel;
    PCC: TPanel;
    B_Collapse: TButton;
    Image_Avatar: TImage;
    L_UserTitle: TLabel;
    B_Register: TButton;
    B_Login: TButton;
    B_Logout: TButton;
    L_Title: TLabel;
    B_FullScreen: TButton;
    L_UserName: TLabel;
    Panel_LoginForm: TPanel;
    Image_bk: TImage;
    Panel_Login: TPanel;
    Image_LoginLogo: TImage;
    Edit_User: TEdit;
    Edit_Password: TEdit;
    Panel_Captcha: TPanel;
    L_Captcha: TLabel;
    Panel2: TPanel;
    Edit_Captcha: TEdit;
    Panel3: TPanel;
    CheckBox_Rem: TCheckBox;
    B_Log: TButton;
    BG_Menu: TButtonGroup;
    ImageList_dw: TImageList;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    P_Title: TPanel;
    L_Logo: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure B_CollapseClick(Sender: TObject);
    procedure B_FullScreenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure B_LoginClick(Sender: TObject);
    procedure B_LogoutClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure PageControl_MainEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure B_LogClick(Sender: TObject);
    procedure BG_MenuButtonClicked(Sender: TObject; Index: Integer);
  private
    { Private declarations }
  public
    //首页
    Form_Home       : TForm_Home;
	
//[*public_start*]

//[*public_end*]

    //

    //------公用变量--------------------------------------------------------------------------------
    //系统配置
    gjoConfig   : variant;

    //---字符串型变量
    gsMainDir           : string;           //系统工作目录，以 \ 结束

    //布尔型变量
    gbMobile            : Boolean;          //是否移动端

    //用户名
    gsUserName          : string;
    gsRole              : string;           //角色
    gjoRights           : Variant;

    //
    gslModules          : TStringList;      //系统模块，包括隐藏和禁用模块，主要用于权限控制

    //
    function _Config:Integer;

    //显示一个Form到TabSheet中
    function dwfShowForm(AClass: TFormClass; var AForm:TForm; AClosable: Boolean): Integer;

    //检查登录
    function dwfCheckLogin:Integer; //登录成功：0，不成功返回-1，异常返回9

    //设置菜单栏是否展开
    function dwfSetMenuExpand(AExpand : Boolean):Integer;

  end;

var
    Form1   : TForm1;

implementation

{$R *.dfm}

procedure TForm1.BG_MenuButtonClicked(Sender: TObject; Index: Integer);
var	
	sCaption	: String;
    joHint      : Variant;
begin
    //处理无运行权限的情况
    joHint  := _Json(ButtonGroup1.Items[Index].Hint);
    if joHint <> unassigned then begin
        if joHint.enabled = 0 then begin
            dwMessage('无运行权限，请联系管理员！','error',self);
            Exit;
        end;
    end;

    //取当前菜单项标题，主要是去除前缀+
	sCaption	:= ButtonGroup1.Items[Index].Caption;
    if sCaption[1] = '+' then begin
        Delete(sCaption,1,1);
        sCaption    := Trim(sCaption);
    end;

    //根据标题分别打开模块
	//[*menuitemclick_start*]

	//[*menuitemclick_end*]
end;



function TForm1.dwfCheckLogin: Integer;
var
    sUserInfo   : string;
    //
    joUserInfo  : Variant;
begin
    //===说明===
    //该函数检查是否已登录
    //主要读取cookie, 与数据库比较

    //默认返回值
    Result      := -9;
    gsUserName  := '';
    try

        //读取cookie(根据配置字符串中的cookie对应的名称)
        sUserInfo   := dwBase.dwGetCookie(self,gjoConfig.login.cookie);

        if Trim(sUserInfo)<>'' then begin
            //解密，得到用户名（根据配置信息中的encrypt进行解密 ）
            sUserInfo   := dwBase.dwAESDecrypt(sUserInfo,gjoConfig.login.encrypt);

            if sUserInfo <> '' then begin
                //将用户信息字符串转换为JSON对象
                joUserInfo    := _json(sUserInfo);

                //
                if joUserInfo <> unassigned then begin
                    //在数据库中查找
                    FDQuery1.Close;
                    FDQuery1.SQL.Text  := 'SELECT * FROM '+gjoConfig.table.prefix+'user'
                            +' WHERE username='''+joUserInfo.name+'''';
                    FDQuery1.Open;

                    //如果未找到，则跳转到登录界面
                    if FDQuery1.IsEmpty then begin
                        Result  := -2;
                        //
                        gsUserName  := '';
                    end else begin
                        Result      := 0;
                        gsUserName  := FDQuery1.FieldByName('UserName').AsString;
                        gsRole      := FDQuery1.FieldByName('Role').AsString;

                        //在角色数据库中查找
                        FDQuery1.Close;
                        FDQuery1.SQL.Text  := 'SELECT * FROM df2_Role'
                                +' WHERE AName=''' + gsRole +'''';
                        FDQuery1.Open;

                        //得到权限JSON
                        gjoRights   := _json(FDQuery1.FieldByName('Rights').AsString);
                        //
                        if gjoRights = unassigned then begin
                            gjoRights   := _json('[]');
                        end;
                    end;
                end;
            end;
        end;

    except
        Result  := -9;
    end;
end;



function TForm1.dwfShowForm(AClass: TFormClass; var AForm:TForm; AClosable: Boolean): Integer;
var
    iTab    : Integer;
    oTab    : TTabSheet;
	//
    sRights : string;       //当前权限
    iRight  : Integer;
    iItem   : Integer;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin
    if AForm = nil then begin
        //==如果当前窗体未创建，则创建该窗体，并创建一个标签页来嵌入窗体

        //创建FORM
        AForm   := AClass.Create(self);

        //设置嵌入标识,必须
        AForm.HelpKeyword := 'embed';

        //创建一个TabSheet，以嵌入当前FORM
        oTab    := TTabSheet.Create(self);

        //设置PageControl
        oTab.PageControl    := PageControl_Main;

        //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
        oTab.ImageIndex     := AForm.HelpContext;

        //如果可以关闭
        if AClosable then begin
            oTab.Hint       := '{"dwattr":"closable"}';
        end;

        //显示
        PageControl_Main.ActivePage := oTab;
        oTab.TabVisible     := True;

        //生成oTab的Name,必须!!！
        for iTab := 1 to PageControl_Main.PageCount do begin
            if FindComponent('TabSheet'+IntToStr(iTab)) = nil then begin
                oTab.Name   := 'TabSheet'+IntToStr(iTab);
                break;
            end;
        end;


        //嵌入到TabSheet中
        AForm.Width     := oTab.Width;
        AForm.Height    := oTab.Height;
        AForm.Parent    := oTab;

        //<根据登录时取得的gjoRights，取得当前模块的权限
        //gjoRights : [{"caption":"入门模块","rights":[1,1,1,1,1,1,1,1,1,1]},...,{"caption":"角色权限","rights":[1,1,1,1,1,1,1,1,1,1]}]
        //取得权限
        sRights := '';
        for iRight := 0 to gjoRights._Count-1 do begin
            if gjoRights._(iRight).caption = AForm.Caption then begin
                sRights := VariantSaveJSON(gjoRights._(iRight).rights);
				break;
            end;
        end;
        //>

        //<将当前模块的权限赋于AForm的gsRights属性
        if sRights <> '' then begin;
            t   := ctx.GetType(AClass);
            for f in t.GetFields do begin
                if f.Name = 'gsRights' then begin
                    f.SetValue(AForm,sRights);
                end;
            end;
        end;
        //>

        //显示
        AForm.Show;

        //Caption 来设置嵌入式窗体的对应TabSheet的Caption
        oTab.Caption        := AForm.Caption;


        //控制界面刷新（新增/删除控件后需要）
        DockSite    := True;
    end else begin
        //==如果当前窗体已创建，则切换到该窗体对应的标签页

        for iTab := 0 to PageControl_Main.PageCount-1 do begin
            if (PageControl_Main.Pages[iTab].Caption = AForm.Caption) and (PageControl_Main.Pages[iTab].ImageIndex = AForm.HelpContext) then begin
                PageControl_Main.ActivePageIndex        := iTab;
                PageControl_Main.Pages[iTab].TabVisible := True;
                break;
            end;
        end;
    end;

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',self);
end;

procedure TForm1.B_CollapseClick(Sender: TObject);
begin
    dwfSetMenuExpand(PL.Width < 60);
end;

function TForm1.dwfSetMenuExpand(AExpand: Boolean): Integer;
var
    iTab        : Integer;
    oTab        : TTabSheet;
begin
    //左侧框宽度
    PL.Width                := dwIIFi(AExpand,200,50);

    //更新本按钮的图标
    B_Collapse.Hint    := dwIIF(AExpand,'{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}',
                            '{"icon":"el-icon-s-unfold","type":"text","color":"#EEE"}');

    //项目LOGO
    L_Logo.Caption          := dwIIF(AExpand,
                            'W.M.S.',
                            '.W.');

    //头像
    Image_Avatar.Margins.Left   := dwIIFi(AExpand,72,3);
    Image_Avatar.Margins.Right  := dwIIFi(AExpand,78,7);
    Image_Avatar.Height         := dwIIFi(AExpand,50,40);

    //更新各TabSheet中内嵌Form的大小
    for iTab := 0 to PageControl_Main.PageCount-1 do begin
        oTab    := PageControl_Main.Pages[iTab];
        if oTab.ControlCount>0 then begin
            with TForm(oTab.Controls[0]) do begin
                BorderStyle := bsNone;
                Left        := 0;
                Top         := 0;
                Width       := oTab.Width;
                Height      := oTab.Height;
            end;
        end;
    end;
    //
    Result  := 0;
end;


procedure TForm1.B_FullScreenClick(Sender: TObject);
begin
    if B_FullScreen.Tag = 1 then begin
        //退出全屏
        dwFullScreen(False,self);

        //设置标志，1表示已全屏，0表示未全屏
        B_FullScreen.Tag   := 0;
    end else begin
        //全屏
        dwFullScreen(True,self);

        //设置标志，1表示已全屏，0表示未全屏
        B_FullScreen.Tag   := 1;
    end;
end;

procedure TForm1.B_LogClick(Sender: TObject);
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
    //检查验证码是否有效
    if Panel_Captcha.Visible then begin
        if lowercase(Edit_Captcha.Text) <> lowercase(L_Captcha.Caption) then begin
            dwMessage('验证码不正确,请检查!','error',self);
            Exit;
        end;
    end;

    //检查用户名信息是否正确
    try
        //设置登录标识默认为未登录
        bLogin  := False;


        //在数据表中内查询
        FDQuery1.Close;
        FDQuery1.SQL.Text   := 'SELECT id,username,salt,psd '
                +' FROM df2_user'
                +' WHERE username='''+Trim(Edit_User.Text)+'''';
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
                sCookie := gjoConfig.login.cookie;      //cookie名称
                sValue  := gjoConfig.login.encrypt;     //密钥
                sValue  := dwAESEncrypt(sInfo,sValue);  //对用户信息采用密钥进行加密

                //根据是否记住密码进行处理
                if CheckBox_Rem.Checked then begin
                    dwSetCookie(self,sCookie,sValue,30*24);
                    dwSetCookiePro(self,sCookie,sValue,'/',gjoConfig.login.domain,30*24);
                end else begin
                    dwSetCookie(self,sCookie,sValue,0);
                    dwSetCookiePro(self,sCookie,sValue,'/',gjoConfig.login.domain,0);
                end;

                //刷新
                dwOpenURL(self,'/dwFrame','_self');
            end;
        end;

        //
        if not bLogin then begin
            dwMessage(gjoConfig.login.invalid,'error',self);
        end;
    except
        dwMessage('配置信息不正确,请检查!','error',self);
        Exit;
    end;

end;

procedure TForm1.B_LoginClick(Sender: TObject);
begin
    dwOpenURL(self,'/dwLogin','_self');
end;

procedure TForm1.B_LogoutClick(Sender: TObject);
begin
    dwMessageDlg('确定要注销登录吗？','注销','确定','取消','query_logout',self);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    sConfig : string;
    iItem   : integer;
const
{
   //若依
    _LogoBK     = '#127EA2';    //左上角颜色
    _LogoFont   = '#ffffff';
    _BannerBK   = '#018CB5';    //banner颜色
    _BannerFont = '#ffffff';
    _MenuBK     = '#0A2D4D';    //
    _MenuActive = '#088EFD';
    _MenuHover  = '#088EFD';
    _MenuFont   = '#ffffff';


    //腾讯云
    _LogoBK     = '#262F40';    //左上角颜色
    _LogoFont   = '#A1ABB7';
    _BannerBK   = '#262F3E';    //banner颜色
    _BannerFont = '#A1ABB7';
    _MenuBK     = '#1E222D';    //
    _MenuActive = '#006FFF';
    _MenuHover  = '#272E3E';
    _MenuFont   = '#A1ABB7';

}
//[*theme_start*]
    //蓝色清爽
    _LogoBK     = '#ffffff';    //左上角颜色
    _LogoFont   = '#5F69FE';
    _BannerBK   = '#ffffff';    //banner颜色
    _BannerFont = '#5F69FE';
    _MenuBK     = '#5F72FD';    //
    _MenuActive = '#7E8EFD';
    _MenuHover  = '#7E8EFD';
    _MenuFont   = '#ffffff';
//[*theme_end*]

    function _WebToColor(AColor:String):Integer;
    var
        iiR     : Integer;
        iiG     : Integer;
        iiB     : Integer;
    begin
        iiR     := StrToIntDef('$'+Copy(AColor,2,2),0);
        iiG     := StrToIntDef('$'+Copy(AColor,4,2),0);
        iiB     := StrToIntDef('$'+Copy(AColor,6,2),0);
        //
        Result  := iiB*65536 + iiG*256 + iiR;
    end;
begin
    //<-----设置主题
    //Logo
    P_Logo.Color        := _WebToColor(_LogoBK);
    L_Logo.font.Color   := _WebToColor(_LogoFont);
    //banner
    PCT.Color               := _WebToColor(_BannerBK);
    B_Collapse.Font.Color   := _WebToColor(_BannerFont);
    L_Title.Font.Color      := _WebToColor(_BannerFont);
    L_UserName.Font.Color   := _WebToColor(_BannerFont);
    B_Register.Font.Color   := _WebToColor(_BannerFont);
    B_Logout.Font.Color     := _WebToColor(_BannerFont);
    B_Login.Font.Color      := _WebToColor(_BannerFont);
    //Menu
    PL.Color                := _WebToColor(_MenuBK);
    L_UserTitle.Font.Color  := _WebToColor(_MenuFont);
    BG_Menu.Font.Color      := _WebToColor(_MenuFont);
    BG_Menu.Hint            := '{'+
            '"bkcolor":"'+_MenuBK+'",'+
            '"hovercolor":"'+_MenuHover+'",'+
            '"activetextcolor":"'+_MenuFont+'",'+
            '"activebkcolor":"'+_MenuActive+'"'+
            '}';
    //>

    //配置信息
    sConfig :=concat(
            '{',
                //应用的标题
                '"title"    : "DeWeb Framework ",',

                //表设置
                '"table":{',
                    '"prefix" : "df2_"',               //表名前缀
                '},',

                //菜单设置
                '"menu":{',
                    '"expand" : 1',                     //默认是否展开。如果展开，则为200宽，否则为50
                '},',

                //登录窗体
                '"login":{',
                    '"title"    : "DeWeb Framework",',          //用于保存登录信息的cookie名称
                    '"logo"     : "image/df2/login.jpg",',      //登录窗体显示logo, 300x150
                    '"bkimage"  : "image/df2/loginbk.jpg",',    //登录窗体背景图片,会自动拉伸到全屏，可以无此项
                    '"cookie"   : "df2_userinfo",',             //用于保存登录信息的cookie名称
                    '"encrypt"  : "dwf*2047",',                 //加密字符串，用于加密保存登录信息
                    '"invalid"  : "登录信息不正确！",',         //输入错误提示
                    '"captcha"  : 0,',                          //是否输入验证码，0：不验证，1：验证
                    '"remember" : 30, ',                        //记住密码天数
                    '"domain"   : ".delphibbs.com", ',          //生成该 Cookie 的域名, 用于该域名下多应用登录
                    '"bkcolor"  : [255,255,255]',               //登录窗体背景颜色.RGB
                '}',
            '}');

    //
    gjoConfig   := _Json(sConfig);


    //设置菜单默认的Left/Top/Width/Height
	dwfSetMenuExpand(True);

    //获取系统模块列表，备用
    gslModules  := TStringList.Create;
    for iItem := 0 to ButtonGroup1.Items.Count - 1 do begin
        gslModules.Add(ButtonGroup1.Items[iItem].Caption);
    end;
end;

//根据配置文件修改窗体参数
function TForm1._Config: Integer;
begin
    //默认返回0
    Result  := 0;

    //如果配置JSON不存在，则退出
    if gjoConfig = unassigned then begin
        Result  := -1;
        Exit;
    end;


    //如果不需要输入验证码，则隐藏
    if dwGetInt(gjoConfig,'captcha',0)=0 then begin
        Panel_Captcha.Visible   := False;
        B_Log.Margins.Top  := 30;
    end;
end;


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    iWidth  : Integer;
    iHeight : Integer;
    iTab    : Integer;
    //
    oTab    : TTabSheet;
begin
    //说明：
    //当浏览器显示有变化时激活本事件
    //根据是否为手机分别处理，差别标准为：X和Y都>500时为电脑/平板，其余为手机（该标准可以自行修改）
    //注意：此处手机为虚拟分辨率，不是屏幕的物理分辨论

    //
    if ( X > 500)and( Y > 500 )  then begin
        //======================================PC模式==============================================
        //设置终端类型标识
        gbMobile    := False;

        //设置为PC模式
        dwSetPCMode(self);


        //隐藏全屏按钮
        B_FullScreen.Visible   := False;


        //更新各TabSheet中内嵌Form的大小
        for iTab := 0 to PageControl_Main.PageCount-1 do begin
            oTab    := PageControl_Main.Pages[iTab];
            if oTab.ControlCount>0 then begin
                with TForm(oTab.Controls[0]) do begin
                    BorderStyle := bsNone;
                    Left        := 0;
                    Top         := 0;
                    Width       := oTab.Width;
                    Height      := oTab.Height;
                end;
            end;
        end;
    end else begin
        //====================================移动模式==============================================
        //设置终端类型标识
        gbMobile    := True;

        //设置为mobile模式
        dwSetMobileMode(self,360,720);

        //
        if Image_BK <> nil then begin
            Image_Bk.Visible    := False;
        end;


        //
        PCT.Color       := clBtnFace;

        //设置菜单图标
        B_Collapse.Hint    := '{"icon":"el-icon-menu","type":"text"}';

        //显示全屏按钮
        B_FullScreen.Visible   := True;
        B_FullScreen.Left      := 9999;

        //隐藏 注册，登录，退出，换肤
        B_Register.Visible     := False;
        B_Login.Visible        := False;
        B_Logout.Visible       := False;

        //
        L_Title.Caption     := '通用进销存';
        L_Title.Alignment   := taCenter;
        L_Title.Align       := alClient;

        //隐藏菜单，设置菜单Left/Top/Width/Height

        //更新菜单展开/合拢状态, 当前状态为展开


        //移动隐藏部分控件
        Image_Avatar.Visible    := False;   //头像
        L_UserTitle.Visible := False;   //用户角色
        PL.Visible              := False;   //左侧总框


        //更新各TabSheet中内嵌Form的大小
        for iTab := 0 to PageControl_Main.PageCount-1 do begin
            oTab    := PageControl_Main.Pages[iTab];
            if oTab.ControlCount>0 then begin
                with TForm(oTab.Controls[0]) do begin
                    BorderStyle := bsNone;
                    Left        := 0;
                    Top         := 0;
                    Width       := oTab.Width;
                    Height      := oTab.Height;
                end;
            end;
        end;
    end;

    //
    if Panel_LoginForm <> nil then begin
        //
        Panel_LoginForm.Left    := 0;
        Panel_LoginForm.Top     := 0;
        Panel_LoginForm.Width   := Width;
        Panel_LoginForm.Height  := Height;
        //
        Image_BK.Align          := alClient;
        //
        with Panel_Login do begin
            Top     := 50;
            Left    := (self.Width - Panel_Login.Width) div 2;
        end;
    end;

end;

procedure TForm1.FormShow(Sender: TObject);
var
    I,J     : Integer;
    sCurr   : string;
    sNext   : string;
begin
    //
    _Config;

    //如果登录成功，则打开首页
    if dwfCheckLogin = 0 then begin
        //释放登录面板
        Panel_LoginForm.Destroy;


        //隐藏一批按钮
        B_Login.Visible    := False;    //
        B_Register.Visible := False;    //
        //显示
        B_Logout.Visible   := True;    //
        L_UserName.Visible  := True;    //
        L_UserName.Left     := 0;
        L_UserName.Caption  := gsUserName;
        //根据当前角色控制菜单。先设置待删除的菜单项ImageIndex为-999，然后再逆序删除
        //1 隐藏不显示的菜单项
        //2 设置不能运行的菜单项

        //<设置无权限的菜单项I
        for I:= 1 to Min(gjoRights._Count - 1,ButtonGroup1.Items.Count - 1) do begin
            //处理
            if gjoRights._(I).rights._(1) = 0 then begin
                //先设置当前菜单项
                ButtonGroup1.Items[I].Hint  := '{"enabled":0}';
            end;
        end;
        //>

        //<设置待删除的菜单项ImageIndex为-999
        I := 0;
        while I < Min(gjoRights._Count - 1,ButtonGroup1.Items.Count - 1) do begin
            //处理不显示的情况，也即权限数组的第1个元素值为0
            if gjoRights._(I).rights._(0) = 0 then begin
                //先设置当前菜单为待删除 (I+1是因为还有一个“首页”菜单项)
                ButtonGroup1.Items[I].ImageIndex    := -999;

                //先将可能存在的子菜单标记为删除
                if (I < ButtonGroup1.Items.Count - 2) then begin
                    sCurr   := ButtonGroup1.Items[I+1].caption;
                    sNext   := ButtonGroup1.Items[I+2].caption;
                    if (sCurr[1] <> '+') and (sNext[1] = '+') then begin
                        //
                        for J := I + 1 to ButtonGroup1.Items.Count - 1 do begin
                            sNext   := ButtonGroup1.Items[J+1].caption;
                            if sNext[1] = '+' then begin
                                ButtonGroup1.Items[J+1].ImageIndex    := -999;
                            end else begin
                                I   := J;
                                break;
                            end;
                        end
                    end else begin
                        Inc(I);
                    end;
                end else begin
                    Inc(I);
                end;
            end else begin
                Inc(I);
            end;
        end;
        //>

        //<逆序删除 ImageIndex为-999 的菜单项
        for I := ButtonGroup1.Items.Count - 1 downto 1 do begin
            if ButtonGroup1.Items[I].ImageIndex = -999 then begin
                ButtonGroup1.Items.Delete(I);
            end;
        end;
        //>
        //打开首页
        dwfShowForm(TForm_Home, TForm(Form_Home), false);
    end

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
            dwSetCookie(self,gjoConfig.cookie,'',0);
            if gjoConfig.Exists('domain') then begin
                dwSetCookiePro(self,gjoConfig.cookie,'','/',gjoConfig.domain,0);
            end;
            //
            B_Logout.Visible   := False;
            L_UserName.Visible  := False;
            //
            B_Login.Visible    := True;
            B_Register.Visible := True;
            //
            gsUserName  := '';
            //
            dwOpenURL(self,gjoConfig.successhref,'_self');
        end;
    end;
end;




procedure TForm1.PageControl_MainEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //此处为标签页（TabSheet）的关闭事件 ,参数值：X = 0 为删除Tab, Y为待删除Tab的序号（从0开始）

    //
    if X = 0 then begin     //X=0表示执行删除操作
        //Y为待删除Tab的序号（从0开始）
        if (Y>=0) and (Y<PageControl_Main.PageCount) then begin
            PageControl_Main.Pages[Y].TabVisible    := False;
        end;
    end;
end;


end.
