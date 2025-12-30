unit unit1;
{
说明：本窗体为应用主窗体，仅提供菜单，PageControl等基础框架服务
}

interface

uses
    //deweb基本单元
    dwBase,

    //dwFrame基本单元
    dwfBase,

    //通用登录控制单元
    gLogin, 

    //
    Unit_Brand,         //品牌信息
    Unit_Category,      //商品类别
    unit_ChangePsd,     //更改密码
    unit_Department,    //部门管理
    Unit_InboundOrder,  //商品入库
    Unit_InQuery,       //入库查询
    Unit_Inventory,     //库存查询
    Unit_OutboundOrder, //商品入库
    Unit_OutQuery,      //出库查询
    unit_Pay,           //应付未付
    Unit_ReceiveUnit,   //供应商信息
    Unit_Supplier,      //供应商信息
    unit_User,          //用户管理
    Unit_Warehouse,     //仓库信息

    //自编单元
    unit_Document,  //资料管理
    unit_Hello,     //入门案例
    Unit_Home,      //首页
    unit_QuickCrud, //一键增删改查
    unit_QuickBtn,  //快速按钮设置
    unit_Role,      //角色权限

    unit_Stat,

    unit_xxx,

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
    PM: TPageControl;
    PT: TPanel;
    PC: TPanel;
    PL: TPanel;
    BE: TButton;
    IA: TImage;
    LR: TLabel;
    BT: TButton;
    BO: TButton;
    LT: TLabel;
    LU: TLabel;
    ImageList_dw: TImageList;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDODBC: TFDPhysODBCDriverLink;
    FDMSAcc: TFDPhysMSAccessDriverLink;
    PO: TPanel;
    LL: TLabel;
    MainMenu1: TMainMenu;
    MIHome: TMenuItem;
    N5: TMenuItem;
    N6: TMenuItem;
    N7: TMenuItem;
    Mu3: TMenuItem;
    N17: TMenuItem;
    SM: TShape;
    FQ_Temp: TFDQuery;
    PH: TPanel;
    BT3: TButton;
    BT2: TButton;
    BT1: TButton;
    BT0: TButton;
    BT4: TButton;
    FDQuery_Timer: TFDQuery;
    N20: TMenuItem;
    PR: TPanel;
    LE: TLabel;
    BR: TButton;
    Ms: TMemo;
    TS: TTimer;
    Mu4: TMenuItem;
    N10: TMenuItem;
    MIInboundOrder: TMenuItem;
    MIOutBoundOrder: TMenuItem;
    MIInQuery: TMenuItem;
    MIOutQuery: TMenuItem;
    MIPay: TMenuItem;
    N16: TMenuItem;
    N2: TMenuItem;
    MIBrand: TMenuItem;
    MIWareHouse: TMenuItem;
    MISupplier: TMenuItem;
    MIReceiveUnit: TMenuItem;
    MIQuick: TMenuItem;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BEClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure BTClick(Sender: TObject);
    procedure BOClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure PMEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure BT0Click(Sender: TObject);
    procedure MI_QuickCrudClick(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure TSTimer(Sender: TObject);
    procedure BRClick(Sender: TObject);
    procedure N6Click(Sender: TObject);
    procedure N7Click(Sender: TObject);
    procedure Mu3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MIWareHouseClick(Sender: TObject);
    procedure MQcClick(Sender: TObject);
    procedure MIHomeClick(Sender: TObject);
    procedure N2Click(Sender: TObject);
    procedure N17Click(Sender: TObject);
    procedure N9Click(Sender: TObject);
    procedure Mu4Click(Sender: TObject);
    procedure N10Click(Sender: TObject);
    procedure MIBrandClick(Sender: TObject);
    procedure MISupplierClick(Sender: TObject);
    procedure MIReceiveUnitClick(Sender: TObject);
    procedure MIInboundOrderClick(Sender: TObject);
    procedure MIOutBoundOrderClick(Sender: TObject);
    procedure MIInQueryClick(Sender: TObject);
    procedure MIOutQueryClick(Sender: TObject);
    procedure MIQuickClick(Sender: TObject);
    procedure MIPayClick(Sender: TObject);
  private
    { Private declarations }
  public

    //------功能模块--------------------------------------------------------------------------------
    //首页
    Form_Home       : TForm_Home;

    //
    Form_Brand          : TForm_Brand;
    Form_Category       : TForm_Category;
    Form_ChangePsd      : TForm_ChangePsd;
    Form_InBoundOrder   : TForm_InboundOrder;
    Form_InQuery        : TForm_InQuery;
    Form_Inventory      : TForm_Inventory;
    Form_OutBoundOrder  : TForm_OutboundOrder;
    Form_OutQuery       : TForm_OutQuery;
    Form_Pay            : TForm_Pay;
    Form_ReceiveUnit    : TForm_ReceiveUnit;
    Form_Supplier       : TForm_Supplier;
    Form_User           : TForm_User;
    Form_WareHouse      : TForm_WareHouse;

    //
    Form_Document   : TForm_Document;
    Form_Department : TForm_Department;
    Form_QuickCrud  : TForm_QC;
    Form_QuickBtn   : TForm_QuickBtn;
    Form_Role       : TForm_Role;
    Form_Stat       : TForm_Stat;

    Form_xxx        : TForm_xxx;


//[*public_end*]

    //

    //------公用变量--------------------------------------------------------------------------------

    //---字符串型变量
    gsMainDir           : string;           //系统工作目录，以 \ 结束

    //布尔型变量
    gbMobile            : Boolean;          //是否移动端

    //用户信息,包括 id/username/canvasid/rolename/avatar等
    gjoUserInfo         : Variant;

    //用户权限
    gjoRights           : Variant;

    //浏览器历史控制变量, 类型为json数组
    gjoHistory  : Variant;



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

procedure TForm1.BEClick(Sender: TObject);
begin
    //菜单项展开/折叠
    dwfSetMenuExpand(self,PL.Width < 60);
end;


//QuickCrud功能模块菜单的事件
procedure TForm1.MI_QuickCrudClick(Sender: TObject);
begin
    dwfQuickCrud(self, TMenuItem(Sender),True);
end;

procedure TForm1.Mu3Click(Sender: TObject);
begin

    //更改密码
    dwfShowForm(self,TForm_ChangePsd, TForm(Form_ChangePsd));
end;

procedure TForm1.Mu4Click(Sender: TObject);
begin
    //部门管理
    dwfShowForm(self,TForm_Department, TForm(Form_Department));
end;

procedure TForm1.MQcClick(Sender: TObject);
begin
    //一键增删改查模块
    dwfShowForm(self,TForm_QC, TForm(Form_QC));

end;

procedure TForm1.N10Click(Sender: TObject);
begin
    //库存查询
    dwfShowForm(self,TForm_Inventory, TForm(Form_Inventory));

end;

procedure TForm1.MIInboundOrderClick(Sender: TObject);
begin
    //商品入库
    dwfShowForm(self,TForm_InboundOrder, TForm(Form_InboundOrder));

end;

procedure TForm1.MIInQueryClick(Sender: TObject);
begin
    //入库查询
    dwfShowForm(self,TForm_InQuery, TForm(Form_InQuery));

end;

procedure TForm1.MIOutBoundOrderClick(Sender: TObject);
begin
    //商品出库
    dwfShowForm(self,TForm_OutboundOrder, TForm(Form_OutboundOrder));

end;

procedure TForm1.MIOutQueryClick(Sender: TObject);
begin
    //出库查询
    dwfShowForm(self,TForm_OutQuery, TForm(Form_OutQuery));

end;

procedure TForm1.MIPayClick(Sender: TObject);
begin
    //应付未付
    dwfShowForm(self,TForm_Pay, TForm(Form_Pay));
end;

procedure TForm1.N17Click(Sender: TObject);
begin
    //资料管理
    dwfShowForm(self,TForm_Document, TForm(Form_Document));
end;

procedure TForm1.MIHomeClick(Sender: TObject);
begin
    //首页
    PM.ActivePageIndex  := 0;

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',self);
end;

procedure TForm1.N2Click(Sender: TObject);
begin
    //商品类别
    dwfShowForm(self,TForm_Category, TForm(Form_Category));
end;

procedure TForm1.MIBrandClick(Sender: TObject);
begin
    //品牌管理
    dwfShowForm(self,TForm_Brand, TForm(Form_Brand));

end;

procedure TForm1.MIReceiveUnitClick(Sender: TObject);
begin
    //领料单位
    dwfShowForm(self,TForm_ReceiveUnit, TForm(Form_ReceiveUnit));

end;

procedure TForm1.MIQuickClick(Sender: TObject);
begin
    //快速按钮设置
    dwfShowForm(self,TForm_QuickBtn, TForm(Form_QuickBtn));
end;

procedure TForm1.MISupplierClick(Sender: TObject);
begin
    //供应商信息
    dwfShowForm(self,TForm_Supplier, TForm(Form_Supplier));

end;

procedure TForm1.MIWareHouseClick(Sender: TObject);
begin
    //仓库管理
    dwfShowForm(self,TForm_WareHouse, TForm(Form_WareHouse));
end;

procedure TForm1.N6Click(Sender: TObject);
begin
    //用户管理
    dwfShowForm(self,TForm_User, TForm(Form_User));

end;

procedure TForm1.N7Click(Sender: TObject);
begin
    //角色 管理
    dwfShowForm(self,TForm_Role, TForm(Form_Role));
end;

procedure TForm1.N9Click(Sender: TObject);
begin
    //我的模块
    dwfShowForm(self,TForm_xxx, TForm(Form_xxx));
end;

//选择主题按钮事件
procedure TForm1.BTClick(Sender: TObject);
begin
    PH.Visible    := True;
end;

//主题切换按钮事件
procedure TForm1.BT0Click(Sender: TObject);
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
    PH.Visible    := False;

    //写入cookie以备用
    dwSetCookie(self,'dwfTheme',IntToStr(iTheme),30*24);
end;

//登出按钮事件
procedure TForm1.BOClick(Sender: TObject);
begin
    dwMessageDlg('确定要注销登录吗？','注销','确定','取消','query_logout',self);
end;

//重新登录
procedure TForm1.BRClick(Sender: TObject);
begin
    gjoUserInfo := null;
    //如果没找到登录信息，则重新登录（调用通用登录模块）
    dwOpenUrl(self,'/glogin?DWMS','_self');

end;

//窗体创建事件
procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    //将当前操作保存到日志表dwLog中
    dwfAddLog(Self,'logout');
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    if gjoUserInfo <> null then begin
        //打开首页
        dwfShowForm(self,TForm_Home, TForm(Form_Home),False, false);

    end;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    iTab    : Integer;
    //
    sCookie : String;
    //
    oTab    : TTabSheet;
begin
    //说明：
    //当浏览器显示有变化时激活本事件

    try
        //设置为PC模式
        dwSetPCMode(self);

        //更新各TabSheet中内嵌Form的大小
        for iTab := 0 to PM.PageCount-1 do begin
            oTab    := PM.Pages[iTab];
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

        //读取保存的主题序号
        sCookie := dwGetCookie(self,'dwfTheme');
        dwfChangeTheme(self,StrToIntDef(SCookie,0),0);

        //设置菜单默认的Left/Top/Width/Height
        sCookie := dwGetCookie(self,'dwfExpand');
        dwfSetMenuExpand(self,sCookie <> '0');

        //
        if Form_Home <> nil then begin
            //dwEcharts(Form_Home.Mm);
        end;


    except
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    sInfo       : String;
    sParent     : String;       //自动根据数据表创建菜单时，父菜单的别名或标题, 如无，则默认为一级菜单
    sCaption    : string;       //自动根据数据表创建菜单时，标题
    sAlias      : String;       //自动根据数据表创建菜单时，别名
    sFileName   : String;       //自动根据数据表创建菜单时，quickcrud时对应的文件名
    //
    bValid      : Boolean;
    //
    joQuickBtn  : Variant;      //当前用户的快捷按钮设置[["产品出库",1],["产品入库",2],.....]
    //
    I           : Integer;
    iID         : Integer;
    iImageIndex : Integer;
    //
    oMenu       : TMenuItem;    //当前菜单
    //
    slMenu      : TStringList;  //用于保存菜单的所有叶节点

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
    sInfo       := glCheckLoginInfo('DWMS',FDConnection1);

    //将登录信息转换为JSON
    gjoUserInfo := _json(sInfo);

    //<检查登录信息是否正确
    bValid      := False;    //默认登录信息无效
    if gjoUserInfo <> unassigned then begin
        if gjoUserInfo.Exists('id') and gjoUserInfo.Exists('username') and gjoUserInfo.Exists('canvasid') then begin
            //设置当前登录信息有效
            bValid  := True;
        end;
    end;
    //>

    //如果登录信息有效，则载入Home页
    if bValid then begin
        //将当前操作保存到日志表dwLog中
        dwfAddLog(Self,'login');

        //查看用户表数据 ，保存gjoUserInfo.rolename
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'SELECT * FROM eUser WHERE uId = '+gjoUserInfo.id;
        FQ_Temp.Open;

        //取得用户头像avatar
        gjoUserInfo.avatar      := FQ_Temp.FieldByName('uAvatar').AsString;

        //取得用户的快捷按钮设置
        gjoUserInfo.quickbutton := _json(FQ_Temp.FieldByName('uQuickButton').AsString);

        //将当前设备id即canvasid写入eUser表的userdevice字段，以实现单点登录
        FQ_Temp.Edit;
        FQ_Temp.FieldByName('uDevice').AsString  := gjoUserInfo.canvasid;
        FQ_Temp.Post;

        //取当前权限，赋给gjoRights
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    :=
                'SELECT eRole.*, eUser.*'
                +' FROM eRole INNER JOIN eUser ON eRole.rName = eUser.uRole'
                +' WHERE eUser.uId='+IntToStr(gjoUserInfo.id);
        FQ_Temp.Open;

        //取得角色名称
        gjoUserInfo.rolename    := FQ_Temp.FieldByName('rName').AsString;;

        //取得当前角色的权限
        gjoRights               := _json(FQ_Temp.FieldByName('rData').AsString);
        if gjoRights = unassigned then begin
            gjoRights   := _json('[]');
        end;

        //显示用户头像
        IA.Hint      := '{"src":"'+gjoUserInfo.avatar+'","radius":"50%","dwstyle":"border:solid 2px #ddd;"}';

        //显示角色名称
        LR.Caption      := gjoUserInfo.rolename;

        //显示用户名称
        LU.Caption      := gjoUserInfo.username;

        //<动态创建菜单项
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'SELECT * FROM eModule ORDER BY mOrder';
        FQ_Temp.Open;
        while not FQ_Temp.Eof do begin
            //自动根据数据表创建菜单时，父菜单的别名或标题/菜单标题/菜单别名/菜单对应JSON文件名
            sParent     := FQ_Temp.FieldByName('mParent').AsString;
            sCaption    := FQ_Temp.FieldByName('mCaption').AsString;
            sAlias      := FQ_Temp.FieldByName('mAlias').AsString;
            sFileName   := FQ_Temp.FieldByName('mFileName').AsString;
            iImageIndex := FQ_Temp.FieldByName('mImageIndex').AsInteger;
            //
            if FileExists(gsMainDir+sFileName) then begin
                //创建一个QuickCrud菜单
                dwfCreateQuickCrudMenu(self,sParent,sCaption,sAlias,sFileName,iImageIndex);
            end;
            //
            FQ_Temp.Next;
        end;
        //>


        //根据当前角色控制菜单。先设置待删除的菜单项ImageIndex为-999，然后再逆序删除
        //1 隐藏不显示的菜单项
        //2 设置不能运行的菜单项

        //设置各菜单项权限
        if gjoUserInfo.username <> 'superadmin' then begin
            iID := 1;
            for I := 1 to MainMenu1.Items.Count - 1 do begin
                oMenu   := MainMenu1.Items[I];
                _SetMenuItem(oMenu,iID);    //设置菜单的可见性和可用性
            end;
        end;

        //<如果快捷按钮设置为空，则设置为默认配置
        //先取得菜单所有叶节点
        if gjoUserInfo.quickbutton = unassigned then begin
            //创建
            gjoUserInfo.quickbutton := _json('[]');
            //取得菜单项所有叶节点
            dwfGetMenuLeafs(MainMenu1,slMenu);
            //添加到配置
            for I := 0 to 7 do begin
                joQuickBtn  := _json('[]');
                joQuickBtn.Add(slMenu[I]);
                joQuickBtn.Add(I+1);
                //
                gjoUserInfo.quickbutton.Add(joQuickBtn);
            end;
            //释放
            slMenu.Destroy;
        end;
        //>


        //启动系统时钟
        TS.Enabled       := True;
    end else begin
        gjoUserInfo := null;
        //如果没找到登录信息，则重新登录（调用通用登录模块）
        dwOpenUrl(self,'/glogin?DWMS','_self');
    end;

    //简化系统，主要处理Panel/button/label, 设置HelpKeyword 为 simple.
    //此时相关控件的体积减少，同时可控的属性变少，一般不能控制字体字号。
    //如果需要单独控制某控件的属性，可以再单独设置该控件Helpkeyword 为空
    dwSimple(Self);

    //单独设置控件不为simple, 即可控制全部属性
    LL.HelpKeyword  := '';
    LT.HelpKeyword  := '';
    BO.HelpKeyword  := '';
    BT.HelpKeyword  := '';
    LU.HelpKeyword  := '';
    PT.HelpKeyword  := '';
    BE.HelpKeyword  := '';
    PO.HelpKeyword  := '';
    LR.HelpKeyword  := '';
    PL.HelpKeyword  := '';

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
            //将当前登录信息保存到日志表dwLog中
            FQ_Temp.Close;
            FQ_Temp.SQL.Text    := 'INSERT INTO eLog(lMode,lDate,lUserName,lCanvasId,lIp)'
                    +' VALUES('
                    +''''+'logout'+''','
                    +''''+FormatDateTime('yyyy-MM-DD hh:mm:ss',Now)+''','
                    +''''+gjoUserInfo.username+''','
                    +''''+gjoUserInfo.canvasid+''','
                    +''''+dwGetProp(self,'ip')+''''
                    +')';
            FQ_Temp.ExecSQL;

            //清除COOKIE
            glClearLoginInfo('DWMS',self);
            //
            BO.Visible    := False;
            LU.Visible      := False;
            //
            gjoUserInfo := null;
            //如果没找到登录信息，则重新登录（调用通用登录模块）
            dwOpenUrl(self,'/glogin?DWMS','_self');
        end;
    end;
end;




procedure TForm1.PMEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //此处为标签页（TabSheet）的关闭事件 ,参数值：X = 0 为删除Tab, Y为待删除Tab的序号（从0开始）

    //
    if X = 0 then begin     //X=0表示执行删除操作
        //Y为待删除Tab的序号（从0开始）
        if (Y>=0) and (Y<PM.PageCount) then begin
            //关闭页面
            PM.Pages[Y].TabVisible    := False;

            //强制关闭页面，以防止关闭不成功
            dwRunJS('this.$refs.pm__ref.$children[0].$refs.tabs['+Y.ToString+'].style.display = ''none'';',self);
        end;
    end;
end;


procedure TForm1.TSTimer(Sender: TObject);
begin
    //<检查当前用户是否有其他设备登录，如果有其他设备登录，则退出，重新登录
    FQ_Temp.Close;
    FQ_Temp.SQL.Text    := 'SELECT uDevice,uLastLive FROM eUser WHERE uId = '+gjoUserInfo.id;
    FQ_Temp.Open;

    //检查当前用户表eUser中的登录设备唯一标识uDevice是不是和当前的一致
    if FQ_Temp.FieldByName('uDevice').AsString <> gjoUserInfo.canvasid then begin
        PR.Visible   := True;
    end else begin
        //将当前时间写入到用户表中
        FQ_Temp.Edit;
        FQ_Temp.FieldByName('uLastLive').AsDateTime  := Now;
        FQ_Temp.Post;
    end;
    //>

end;

end.
