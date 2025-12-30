unit unit1;
{
说明：本窗体为应用主窗体，仅提供菜单，PageControl等基础框架服务
}

interface

uses
    //deweb基本单元
    dwBase,

    //通用登录控制单元
    gLogin,

    //自编单元
    Unit_Home,      //首页
    unit_Questions,
    unit_Test,
    unit_Score,
    unit_User,
    unit_Password,
    unit_Review,


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
    PC_Main: TPageControl;
    P_Banner: TPanel;
    P_C: TPanel;
    P_L: TPanel;
    B_Expand: TButton;
    Im_Avatar: TImage;
    L_Role: TLabel;
    B_Register: TButton;
    B_Skin: TButton;
    B_Logout: TButton;
    L_Title: TLabel;
    B_FullScreen: TButton;
    L_User: TLabel;
    BG_Menu: TButtonGroup;
    ImageList_dw: TImageList;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    P_Logo: TPanel;
    L_Logo: TLabel;
    P_Themes: TPanel;
    B_Theme3: TButton;
    B_Theme2: TButton;
    B_Theme1: TButton;
    B_Theme0: TButton;
    B_Theme4: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure B_ExpandClick(Sender: TObject);
    procedure B_FullScreenClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure B_SkinClick(Sender: TObject);
    procedure B_LogoutClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure PC_MainEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure BG_MenuButtonClicked(Sender: TObject; Index: Integer);
    procedure B_Theme0Click(Sender: TObject);
  private
    { Private declarations }
  public
    //首页
    Form_Home       : TForm_Home;
	
    Form_Questions : TForm_Questions;
    Form_Test : TForm_Test;
    Form_Score : TForm_Score;
    Form_User : TForm_User;
    Form_Password : TForm_Password;
    Form_Review : TForm_Review;


//[*public_end*]

    //

    //------公用变量--------------------------------------------------------------------------------

    //---字符串型变量
    gsMainDir           : string;           //系统工作目录，以 \ 结束

    //布尔型变量
    gbMobile            : Boolean;          //是否移动端

    //用户名
    gsUserName          : string;           //用户名
    gsJobNumber         : string;           //工号
    gsRole              : string;           //角色
    gjoRights           : Variant;

    //
    gslModules          : TStringList;      //系统模块，包括隐藏和禁用模块，主要用于权限控制

    //显示一个Form到TabSheet中
    function dwfShowForm(AClass: TFormClass; var AForm:TForm; AForceRecreate,AClosable: Boolean): Integer;

    //设置菜单栏是否展开
    function dwfSetMenuExpand(AExpand : Boolean):Integer;

    function dwfChangeTheme(AIndex: Integer;AMode:Integer): Integer;
  end;

var
    Form1   : TForm1;

implementation

{$R *.dfm}

function TForm1.dwfChangeTheme(AIndex: Integer;AMode:Integer): Integer;
var
    sStyle      : string;   //用于切换菜单的选中背景色和HOVER色
    joConfig    : Variant;
    joTheme     : Variant;

    //
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
    //
    joConfig   := _Json(StyleName);

    if (AIndex<0) or (AIndex>joConfig.theme.items._Count-1) then begin
        AIndex  := 0;
    end;

    //
    joTheme := joConfig.theme.items._(AIndex);

    //
    if not joTheme.Exists('menuactivefont') then begin
        joTheme.menuactivefont  := joTheme.menufont;
    end;

    //Logo
    P_Logo.Color            := _WebToColor(joTheme.logobk);
    L_Logo.font.Color       := _WebToColor(joTheme.logofont);
    //banner
    P_Banner.Color          := _WebToColor(joTheme.bannerbk);
    B_Expand.Font.Color     := _WebToColor(joTheme.bannerfont);
    L_User.Font.Color       := _WebToColor(joTheme.bannerfont);
    L_Title.Font.Color      := _WebToColor(joTheme.bannerfont);
    B_Register.Font.Color   := _WebToColor(joTheme.bannerfont);
    B_Logout.Font.Color     := _WebToColor(joTheme.bannerfont);
    B_Skin.Font.Color       := _WebToColor(joTheme.bannerfont);

    //注意此处没有修改选中的背景色，拟通过修改CSS解决
    //Menu
    P_L.Color               := _WebToColor(joTheme.menubk);
    L_Role.Font.Color       := _WebToColor(joTheme.menufont);
    BG_Menu.Font.Color      := _WebToColor(joTheme.menufont);
    BG_Menu.Hint            := '{'+
            '"bkcolor":"'+joTheme.menubk+'",'+
            '"hovercolor":"'+joTheme.menuhover+'",'+
            '"activetextcolor":"'+joTheme.menuactivefont+'",'+
            '"activebkcolor":"'+joTheme.menuactive+'"'+
            '}';
    //>


    //
    if AMode = 1 then begin
        //切换选中的背景色和HOVER色
        sStyle  := 'document.getElementById(''bg_menu__bk'').innerHTML = '''+
                '.el-menu-item.is-active {'+
                    'background-color: '+joTheme.menuactive+' !important;'+
                '}'';';
        dwRunJS(sStyle,self);
    sStyle  :=
            'document.getElementById(''bg_menu__hover'').innerHTML = '''+
            '.el-submenu__title:hover{'+
                'background-color: '+joTheme.menuhover+' !important;'+
            '} '+
            '.el-menu-item:hover { '+
                'background-color: '+joTheme.menuhover+' !important;'+
            '}'';';
        dwRunJS(sStyle,self);
    end;


end;


procedure TForm1.BG_MenuButtonClicked(Sender: TObject; Index: Integer);
var	
	sCaption	: String;
    joHint      : Variant;
begin
    //处理无运行权限的情况
    joHint  := _Json(BG_Menu.Items[Index].Hint);
    if joHint <> unassigned then begin
        if joHint.enabled = 0 then begin
            dwMessage('无运行权限，请联系管理员！','error',self);
            Exit;
        end;
    end;

    //取当前菜单项标题，主要是去除前缀+
	sCaption	:= BG_Menu.Items[Index].Caption;
    if sCaption[1] = '+' then begin
        Delete(sCaption,1,1);
        sCaption    := Trim(sCaption);
    end;

    //根据标题分别打开模块
    if Index = 0 then begin
        dwfShowForm(TForm_Home,TForm(Form_Home),False,True);
        Exit;
    end;
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


	//[*menuitemclick_end*]
end;




function TForm1.dwfShowForm(AClass: TFormClass; var AForm:TForm; AForceRecreate, AClosable: Boolean): Integer;
var
    iTab    : Integer;
    oTab    : TTabSheet;
	//
    sRights : string;       //当前权限
    iRight  : Integer;
    iItem   : Integer;
    //
    sCaption    : string;
    iImageIndex : Integer;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin
    //如果强制重建
    if AForceRecreate then begin

        //释放AForm
        if AForm <> nil then begin
            //保存Caption和HelpContext，以备后面删除TabSheet时使用
            sCaption    := AForm.Caption;
            iImageIndex := AForm.HelpContext;
            //
            FreeAndNil(AForm);

            //释放TabSheet
            for iTab := 0 to PC_Main.PageCount-1 do begin
                if (PC_Main.Pages[iTab].Caption = sCaption) and (PC_Main.Pages[iTab].ImageIndex = iImageIndex) then begin
                    PC_Main.Pages[iTab].Destroy;
                    break;
                end;
            end;
        end;
    end;

    //
    if AForm = nil then begin
        //==如果当前窗体未创建，则创建该窗体，并创建一个标签页来嵌入窗体

        //创建FORM
        AForm   := AClass.Create(self);

        //设置嵌入标识,必须
        AForm.HelpKeyword := 'embed';

        //创建一个TabSheet，以嵌入当前FORM
        oTab    := TTabSheet.Create(self);

        //设置PageControl
        oTab.PageControl    := PC_Main;

        //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
        oTab.ImageIndex     := AForm.HelpContext;

        //如果可以关闭
        if AClosable then begin
            oTab.Hint       := '{"dwattr":"closable"}';
        end;

        //显示
        PC_Main.ActivePage := oTab;
        oTab.TabVisible     := True;

        //生成oTab的Name,必须!!！
        for iTab := 1 to PC_Main.PageCount do begin
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

        for iTab := 0 to PC_Main.PageCount-1 do begin
            if (PC_Main.Pages[iTab].Caption = AForm.Caption) and (PC_Main.Pages[iTab].ImageIndex = AForm.HelpContext) then begin
                PC_Main.ActivePageIndex        := iTab;
                PC_Main.Pages[iTab].TabVisible := True;
                break;
            end;
        end;
    end;

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',self);
end;

procedure TForm1.B_ExpandClick(Sender: TObject);
begin
    dwfSetMenuExpand(P_L.Width < 60);
end;

function TForm1.dwfSetMenuExpand(AExpand: Boolean): Integer;
var
    iTab        : Integer;
    oTab        : TTabSheet;
begin
    //左侧框宽度
    P_L.Width           := dwIIFi(AExpand,200,50);

    //更新本按钮的图标
    B_Expand.Hint       := dwIIF(AExpand,
                            '{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}',
                            '{"icon":"el-icon-s-unfold","type":"text","color":"#EEE"}');

    //项目LOGO
    L_Logo.Caption      := dwIIF(AExpand,
                            'ZHeart',
                            '.Z.');

    //头像
    Im_Avatar.Margins.Left  := dwIIFi(AExpand,72,3);
    Im_Avatar.Margins.Right := dwIIFi(AExpand,78,7);
    Im_Avatar.Height        := dwIIFi(AExpand,50,40);

    //更新各TabSheet中内嵌Form的大小
    for iTab := 0 to PC_Main.PageCount-1 do begin
        oTab    := PC_Main.Pages[iTab];
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


procedure TForm1.B_SkinClick(Sender: TObject);
begin
    P_Themes.Visible    := True;
end;

procedure TForm1.B_Theme0Click(Sender: TObject);
var
    sName   : string;
    sStyle  : string;
    iTheme  : Integer;
begin
    //得到名称，名称和主题的序号对应
    sName   := TButton(Sender).Name;
    Delete(sName,1,7);
    iTheme  := StrToIntDef(sName,0);

    //切换主题
    dwfChangeTheme(iTheme,1);

    //隐藏
    P_Themes.Visible    := False;

end;

procedure TForm1.B_LogoutClick(Sender: TObject);
begin
    dwMessageDlg('确定要注销登录吗？','注销','确定','取消','query_logout',self);

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    iItem       : Integer;
const
    iThemeIndex = 0;
begin

    //切换主题
    dwfChangeTheme(iThemeIndex,0);

    //设置菜单默认的Left/Top/Width/Height
	dwfSetMenuExpand(True);

    //获取系统模块列表，备用
    gslModules  := TStringList.Create;
    for iItem := 0 to BG_Menu.Items.Count - 1 do begin
        gslModules.Add(BG_Menu.Items[iItem].Caption);
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
        for iTab := 0 to PC_Main.PageCount-1 do begin
            oTab    := PC_Main.Pages[iTab];
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
        P_Banner.Color       := clBtnFace;

        //设置菜单图标
        B_Expand.Hint    := '{"icon":"el-icon-menu","type":"text"}';

        //显示全屏按钮
        B_FullScreen.Visible   := True;
        B_FullScreen.Left      := 9999;

        //隐藏 注册，登录，退出，换肤
        B_Register.Visible      := False;
        B_Skin.Visible          := False;
        B_Expand.Visible        := False;

        //
        L_Title.Caption         := 'ZHeart';
        L_Title.Align           := alClient;

        //隐藏菜单，设置菜单Left/Top/Width/Height

        //更新菜单展开/合拢状态, 当前状态为展开


        //移动隐藏部分控件
        Im_Avatar.Visible   := False;   //头像
        L_Role.Visible      := False;   //用户角色
        P_L.Visible         := False;   //左侧总框


        //更新各TabSheet中内嵌Form的大小
        for iTab := 0 to PC_Main.PageCount-1 do begin
            oTab    := PC_Main.Pages[iTab];
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


end;

procedure TForm1.FormShow(Sender: TObject);
var
    I,J     : Integer;
    sInfo   : String;
    sCurr   : string;
    sNext   : string;
    sParams : String;
    //
    joConfig    : Variant;
    joInfo      : Variant;
begin
    joConfig    := _json(StyleName);

    //取得URL参数
    sParams := dwGetProp(self,'params');

    //检查登录信息，如果成功，返回id/username/canvasid, 否则返回空值
    sInfo   := glCheckLoginInfo('zheart',FDConnection1);
    if sInfo <> '' then begin
        joInfo  := _json(sInfo);

        //在用户数据库中查找
        FDQuery1.Close;
        FDQuery1.SQL.Text  := 'SELECT * FROM zh_user'
                +' WHERE id=' + joInfo.id ;
        FDQuery1.Open;

        //<根据登录信息取得一些变量
        gsUserName      := FDQuery1.FieldByName('AName').AsString;
        gsJobNumber     := FDQuery1.FieldByName('AJobNumber').AsString;
        gsRole          := FDQuery1.FieldByName('ARole').AsString;
        L_Role.Caption  := gsRole;

        //在角色数据库中查找
        FDQuery1.Close;
        FDQuery1.SQL.Text  := 'SELECT * FROM zh_Role'
                +' WHERE AName=''' + gsRole +'''';
        FDQuery1.Open;

        //得到权限JSON
        gjoRights   := _json(FDQuery1.FieldByName('Rights').AsString);
        //
        if gjoRights = unassigned then begin
            gjoRights   := _json('[]');
        end;
        //>


        //隐藏一批按钮
        B_Register.Visible  := False;    //
        //显示
        B_Logout.Visible    := True;    //
        L_User.Visible      := True;    //
        L_User.Left         := 0;
        L_User.Caption      := gsUserName+' ['+gsJobNumber+']';
        //根据当前角色控制菜单。先设置待删除的菜单项ImageIndex为-999，然后再逆序删除
        //1 隐藏不显示的菜单项
        //2 设置不能运行的菜单项

        //<设置无权限的菜单项I
        for I:= 1 to Min(gjoRights._Count - 1,BG_Menu.Items.Count - 1) do begin
            //处理
            if gjoRights._(I).rights._(1) = 0 then begin
                //先设置当前菜单项
                BG_Menu.Items[I].Hint  := '{"enabled":0}';
            end;
        end;
        //>

        //<设置待删除的菜单项ImageIndex为-999
        I := 0;
        while I <= Min(gjoRights._Count - 1,BG_Menu.Items.Count - 1) do begin
            //处理不显示的情况，也即权限数组的第1个元素值为0
            if gjoRights._(I).rights._(0) = 0 then begin
                //先设置当前菜单为待删除 (I+1是因为还有一个“首页”菜单项)
                BG_Menu.Items[I].ImageIndex    := -999;

                //先将可能存在的子菜单标记为删除
                if (I < BG_Menu.Items.Count - 2) then begin
                    sCurr   := BG_Menu.Items[I+1].caption;
                    sNext   := BG_Menu.Items[I+2].caption;
                    if (sCurr[1] <> '+') and (sNext[1] = '+') then begin
                        //
                        for J := I + 1 to BG_Menu.Items.Count - 1 do begin
                            sNext   := BG_Menu.Items[J+1].caption;
                            if sNext[1] = '+' then begin
                                BG_Menu.Items[J+1].ImageIndex    := -999;
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
        for I := BG_Menu.Items.Count - 1 downto 1 do begin
            if BG_Menu.Items[I].ImageIndex = -999 then begin
                BG_Menu.Items.Delete(I);
            end;
        end;
        //>
        //打开首页
        dwfShowForm(TForm_Home, TForm(Form_Home),False, false);
    end else begin
        //调用通用登录系统
        dwOpenUrl(self,'glogin?zheart','_self');
    end

end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string;
    //
    joConfig    : Variant;
begin
    joConfig    := _json(StyleName);


    //取得交互的事件名称
    sMethod := dwGetProp(Self,'interactionmethod');

    //通过类似以下得到返回的事件结果，为'1'时表示为"确定"，否则为"取消"
    sValue  := dwGetProp(Self,'interactionvalue');

    //根据事件名称和事件结果进行处理
    if sMethod = 'query_logout' then  begin
        if sValue = '1' then begin

            //清除COOKIE
            glClearLoginInfo('zheart',self);
            //
            B_Logout.Visible   := False;
            L_User.Visible  := False;
            //
            B_Register.Visible := True;
            //
            gsUserName  := '';
            gsJobNumber := '';
            //
            dwOpenURL(self,'/zheart','_self');
        end;
    end;
end;




procedure TForm1.PC_MainEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //此处为标签页（TabSheet）的关闭事件 ,参数值：X = 0 为删除Tab, Y为待删除Tab的序号（从0开始）

    //
    if X = 0 then begin     //X=0表示执行删除操作
        //Y为待删除Tab的序号（从0开始）
        if (Y>=0) and (Y<PC_Main.PageCount) then begin
            PC_Main.Pages[Y].TabVisible    := False;
        end;
    end;
end;





end.
