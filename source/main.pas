unit Main;


//以下该行为STD版标志，如果有以下行，则为标准版，可免费永久使用，但不可使用Helpkeyword扩展的控件。
//{$DEFINE _STD}


{
2025-07-01(具体日期不定)
    1 由原来的5分钟释放无心跳的Form, 改为30分钟, 更合理

2025-05-01
    1 解决了FDQuery最多返回50条记录的bug
2025-04-07
    1 解决了cookie在不记住密码时未写入的bug
2025-03-20
    1 在接收关闭DWS指令时, 增加了单独关闭当前DWS的消息, 即发送与当前DWS端口一致的负值, 可关闭当前DWS
2025-03-18
    1 在OnShow前增加了在Hint中记录requestuseragent,可用于检查是否移动端等
2025-02-23
    1 解决了onmouseup时报错的808bug. 经查, 发现是_screen时, 没有记录screenwidth信息, 导致转存失败
2025-02-20
    1 基本去除了批量dwSetProp造成时间消耗.
    2 增加了支持udp控制消息
        -1027 - 立即关闭系统
        -1028 - 立即Terminate系统
        -1029 - 设置闲时关闭系统

2024-12-19
    1 可以根据dwDriect.dll类型应用中参数是否包含"json=1"字符串， 动态输出json格式或非json格式
2024-12-18
    1 暂时去除了heart心跳包未找到form时重载的问题
    2 加入了 gsContType, 可以控制输出application/json

2024-12-11
    1 增加了procResp运行时的try/catch
2024-12-04
    1 增加了可自定义的公共模块

2024-10-29
    1 增加了主动推送sse消息的函数，并在dwbase中添加了对应函数

2024-09-27
    1、发现0920的修改：“隐藏了app<div>的光标     caret-color: transparent;”会导致所有输入框无光标，
       通过增加了一个deweb.css解决

2024-09-20
    1、隐藏了app<div>的光标     caret-color: transparent;

2024-09-19
    1、为DWS的FDConnection增加了自动重连 (08.23)
    2、解决了DWS的gjoConnections.db多出几个的bug
    3、修改了DWS，增加了保存this和name, 用于实现JS向DELPHI传值（09.11）
    4、配合dwTTimer.dpr, 基本完成了多窗体情况下多Timer的控制

2024-07-18
    1、增加了dwIsTForm函数，代替原来用类名来检测，解除了子窗体Name必须以Form开头的限制
    2、在取bios时采用了try, 主要解决在某些特殊情况下，取不到bios信息导致报错的bug.
    3、默认端口改成9000

2024-04-18
    1、在OnMouseUp中增加了try， 以尽量避免报错。主要是发现有Timer后启动报错。
    2、dwTTimer.dpr的action中clear函数的参数前增加了this.

2024-04-12
    1、DeWeb增加了一个事件：
        可以在浏览器返回时，自动激活窗体的OnUndock事件， 以处理移动端弹出时一个对话框时，
        用户返回操作， 他是想隐藏这个对话框，而DeWeb原来的机制是返回到上一个URL了

2024-03-31
    1、将dwProcessresp单元中的清除所有时钟的个数由100升至10000， 基本解决了dwFrame打开多个单元后，大量时钟的问题
2024-03-06
    1、解决了Timer在docksite后多执行一次的bug。主要是增加了刷新时清除所有Timer的JS代码

2024-01-04
    1、dwevent函数加入了类型判断，以更好利用dwEvent函数
2023-12-26
    1、账套管理增加了“加密选项”
    注：设置为加密后，不可再编辑（因为这样一样会显示明文）只能删除和重建

2023-11-17
    1、将dwloading的z-index由原来的9改为50， 以解决被quickcrud遮挡的问题

2023-11-16
    1、配合dwTTimer.dpr, 解决了Timer重新启动后不正常的bug
    主要措施：在SetInterval前let _temp = this;然后在.then中使用_temp.procResp

2023-10-04
    1、解决了MultiForm例程中打开标题显示为Form4的问题
    原因： 在DWS的函数dwGetComponentInfos中对所有Form都使用了
    joRes.Add('document.title ="'+(AForm.Caption)+'";');
    解决：
    使用上述代码中增加了判断
        if AForm.Owner = nil then begin
            joRes.Add('document.title ="'+(AForm.Caption)+'";');
        end;

2023-09-25
    1、解决了dwGetProp(self,'fullurl')中文乱码问题
    方法：
    (1) 在dwVars的js中增加了escape
    (2) 在dwProcessData中的dwSetProp时增加了urldecode
2023-09-13
    1、增加了前端数据更新后，同步更新服务器端，并激活事件的方案。
       可用于取位置信息或扫码等
2023-09-02
    1、解决了浏览器回退后不能恢复原界面的bug

2023-08-27
    1、config.json中增加了数据库enabled属性，以暂时禁用数据库
}

interface

uses
    //
    dwVars,
    dwBase,
    dwUtils,

    //
    //第三方控件
    //QLog,
    WestWindUdp,
    SynCommons, //mormot的json单元
    //MsgDlg,     //汉化版MessageDlg
    //CloneComponents,
    OverbyteIcsWinSock,  OverbyteIcsWSocket, OverbyteIcsWndControl, OverbyteIcsTypes,
    OverbyteIcsHttpSrv, OverbyteIcsUtils, OverbyteIcsFormDataDecoder, OverbyteIcsMimeUtils,

    //用于计算HTML高度的单元
    //htmlcomp,

    //求MD5
    IdHashMessageDigest,IdGlobal, IdHash,

    //
    AdoConEd,
    HTTPApp,
    //XpMan,
    DateUtils,
    Math,
    Clipbrd,                //用于复制ServerID
    Generics.Collections,   //用于TDictionary
    TypInfo,
    Variants,
    Graphics,
    Dialogs,
    Registry,      //注册表
    ComObj,         //用于执行JS
    Windows, Messages, SysUtils, Classes, Controls, Forms,
    StdCtrls, ExtCtrls, StrUtils,
    //
    {$IFNDEF VER330}
        FireDAC.Phys.SQLiteWrapper.Stat,
    {$ENDIF}
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.ADSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef, FireDAC.Phys.ASADef,
    FireDAC.Phys.MongoDBDef, FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
    FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB, FireDAC.Phys.ASA,
    FireDAC.Phys.TData, FireDAC.Phys.Infx, FireDAC.Phys.DB2, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
    FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.ADS,
    FireDAC.Phys.MySQL, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageBin,
    FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient,
    //IniFiles,
    Vcl.Imaging.jpeg, Menus,  ShellAPI,  Spin, Vcl.FileCtrl,
    Data.Win.ADODB, Data.DB, Vcl.WinXCtrls, System.ImageList, Vcl.ImgList, Vcl.ComCtrls,
    Vcl.ToolWin, Vcl.Imaging.pngimage, Vcl.Buttons, FireDAC.VCLUI.Login, FireDAC.Comp.UI,
    Vcl.Grids ;



type
    TDWHttpConnection = class(THttpConnection)
    protected
        FPostedRawData      : PAnsiChar; { Will hold dynamically allocated buffer }
        FPostedDataBuffer   : PChar;     { Contains either Unicode or Ansi data   }
        FPostedDataSize     : Integer;   { Databuffer size                        }
        FDataLen            : Integer;   { Keep track of received byte count.     }
        FDataFile           : TextFile;  { Used for datafile display              }
        FFileIsUtf8         : Boolean;
        FRespTimer          : TTimer;
        //
        SseHandle           : THandle;  //用于保存句柄
    public
        destructor  Destroy; override;
    end;
    //ReallocMem(ClientCnx.FPostedRawData, ClientCnx.RequestContentLength + 1);

  TMainForm = class(TForm)
    Memo_msg: TMemo;
    Timer_Manager: TTimer;
    FileListBox_Vcls: TFileListBox;
    FileListBox_Apps: TFileListBox;
    ListView_Apps: TListView;
    ImageList_16: TImageList;
    Panel_Forms: TPanel;
    Timer_Init: TTimer;
    Panel_Progress: TPanel;
    Panel_Title: TPanel;
    TrayIcon: TTrayIcon;
    PopupMenu_Tray: TPopupMenu;
    PopItem_Show: TMenuItem;
    N3: TMenuItem;
    PopItem_Close: TMenuItem;
    ProgressBar: TProgressBar;
    Panel_Top: TPanel;
    SpeedButton_Exit: TSpeedButton;
    SpeedButton_Stop: TSpeedButton;
    SpeedButton_Start: TSpeedButton;
    Panel_TopLine: TPanel;
    Panel_Port: TPanel;
    Label2: TLabel;
    SpinEdit_Port: TSpinEdit;
    SpeedButton_demos: TSpeedButton;
    Label_Hours: TLabel;
    PageControl: TPageControl;
    TabSheet_Apps: TTabSheet;
    TabSheet_Debug: TTabSheet;
    TabSheet_Account: TTabSheet;
    TabSheet_Help: TTabSheet;
    Panel_AccountButtons: TPanel;
    SpeedButton_AccountDelete: TSpeedButton;
    SpeedButton_AccountAdd: TSpeedButton;
    StringGrid_Account: TStringGrid;
    SpeedButton_AccountEdit: TSpeedButton;
    Memo1: TMemo;
    Panel4: TPanel;
    Panel_Info: TPanel;
    Label3: TLabel;
    SpeedButton_BuyNow: TSpeedButton;
    SpeedButton_Copy: TSpeedButton;
    Edit_UUID: TEdit;
    Panel3: TPanel;
    SpeedButton_Doc: TSpeedButton;
    Panel1: TPanel;
    SpeedButton_Format: TSpeedButton;
    SpeedButton_Clear: TSpeedButton;
    SpeedButton_Export: TSpeedButton;
    Panel2: TPanel;
    Label_Version: TLabel;
    FileListBox_publics: TFileListBox;
    ImageListMain: TImageList;
    procedure ProcessPostedData_FileUpload(ClientCnx : TDWHttpConnection);
    procedure ProcessPosteData_FileUploadMultipartFormData(ClientCnx : TDWHttpConnection;const AFileName : String);
    procedure ProcessPosteData_FileUploadBinaryData( ClientCnx : TDWHttpConnection; const FileName : String);
    //
    procedure HttpServerGetDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
    procedure HttpServerPostDocument(Sender, Client: TObject;var Flags: THttpGetFlag);
    procedure HttpServerPostedData(Sender : TObject;Client : TObject;Error: Word);

    //--------------------------------------------------------------------------
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure Timer_ManagerTimer(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListView_AppsDblClick(Sender: TObject);
    procedure Timer_InitTimer(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure Memo_msgChange(Sender: TObject);
    procedure RadioButton_LocalClick(Sender: TObject);
    procedure RadioButton_PublicClick(Sender: TObject);
    procedure RadioButton_ThirdClick(Sender: TObject);
    procedure SpinEdit_PortChange(Sender: TObject);
    procedure TrayIconClick(Sender: TObject);
    procedure PopItem_CloseClick(Sender: TObject);
    procedure PopItem_ShowClick(Sender: TObject);
    procedure PopItem_HideClick(Sender: TObject);
    procedure SpeedButton_ExitClick(Sender: TObject);
    procedure SpeedButton_StartClick(Sender: TObject);
    procedure SpeedButton_StopClick(Sender: TObject);
    procedure SpeedButton_debugClick(Sender: TObject);
    procedure SpeedButton_ClearClick(Sender: TObject);
    procedure SpeedButton_BuyClick(Sender: TObject);
    procedure SpeedButton_CopyClick(Sender: TObject);
    procedure SpeedButton_demosClick(Sender: TObject);
    procedure SpeedButton_DocClick(Sender: TObject);
    procedure SpeedButton_AccountAddClick(Sender: TObject);
    procedure SpeedButton_AccountEditClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure SpeedButton_AccountDeleteClick(Sender: TObject);
    procedure FDConnectionError(ASender, AInitiator: TObject; var AException: Exception);

    private
        FInitialized   : Boolean;
    public
        gbRegistered : Boolean;
        procedure AddDebugMsg(AMsg:string);     //添加调试信息
        procedure SendWMMsg(AMsg:String);
        procedure SetRegistered(ABool:Boolean); //根据是否注册进行处理
        function  CheckRegister:Boolean;
        //
        function  UpdateConnections:Integer;

        //向某窗体对应的前端发向SSE消息
        function  SendMsgToForm(AHandle:THandle;AMsg:String):Integer;
    protected
    end;

var
    MainForm        : TMainForm;
    giTmp           : Integer = 0;
    gfStartTime     : TDateTime;        //记录初始时间，以判断是否注册
    {$IFDEF _STD}
        gsTitle     : string = 'DeWeb Standard v2.2.20250701'; //用于显示系统版本
    {$ELSE}
        gsTitle     : string = 'DeWebServer v20251230'; //用于显示系统版本
    {$ENDIF}

    goSSEs          : array of TDWHttpConnection;

    gsContType      : String = '';  //返回的数据类型， 默认为text/html,需要时可以设置为application/json

    gbCloseWhenIdle : Boolean = False;  //是否空闲时关闭系统
    giIdleHour      : Byte = 6;         //设置空闲时关闭系统时, 系统已运行时间的下限,单位:小时

const
    _DEFUALTPORT    = 9000;



function dwStart(APort:Integer):Integer;

function dwsGetHtmlLabelHeight(AFontName:String;AFontSize:Integer;AHtml:String;AWidth:Integer):Integer;

function ProcessMsg(AIP,AText :string):Integer;


implementation  //==================================================================================


uses dwProcessData, dwDM, Account;

{$R *.DFM}

function ProcessMsg(AIP,AText: string): Integer;
var
    joData      : Variant;
    iId         : Integer;
    oTmp        : TCloseAction;
begin
    try
        //
        joData  := _Json(AText);
        if joData <> unassigned then begin
            //
            iId     := dwGetInt(joData,'id',0);
            //
            case iId of
                -1027 : begin   //立即关闭系统
                    MainForm.Tag := 999;
                    MainForm.Close;
                end;
                -1028 : begin   //立即关闭系统, 带Terminate
                    MainForm.Tag := 999;
                    MainForm.OnClose(MainForm,oTmp);
                    Application.Terminate;
                end;
                -1029 : begin   //闲时关闭系统
                    gbCloseWhenIdle := True;
                    giIdleHour      := dwGetInt(joData,'idlehour',6);
                end;
            else
                //处理单独关系某DWS. 发送和商品相同的负值,如:-8083
                if iId = -giPort then begin
                    MainForm.Tag := 999;
                    MainForm.Close;
                end;
            end;
        end;
    except
      //
    end;
end;


function dwsGetHtmlLabelHeight(AFontName:String;AFontSize:Integer;AHtml:String;AWidth:Integer):Integer;
begin
    Result  := AFontSize;
(*
    try
        //默认返回值
        Result  := 100;

        //创建一个Panel, 主要用于限制其宽度
        oPanel  := TPanel.Create(MainForm);
        oPanel.Parent   := MainForm;
        oPanel.Width    := AWidth;

        //创建HtLabel
        oHtml           := THtLabel.Create(MainForm);

        //设置值
        oHtml.Parent    := oPanel;
        oHtml.Align     := alTop;
        oHtml.font.Name := AFontName;   //建议: 微软雅黑
        oHtml.Font.Size := AFontSize;   //建议: 12
        oHtml.WordWrap  := True;
        oHtml.Caption   := AHtml;       //选用23行距计算较准确

        //
        Result  := oHtml.Height;
    finally
        //
        oHtml.Destroy;
        oPanel.Destroy;

    end;
*)
end;



procedure TMainForm.HttpServerGetDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
var
    ClientCnx   : TDWHttpConnection;
    sResp       : String;
    sPath       : String;
begin
    //设置当前工作目录
    SetCurrentDir(gsMainDir);

    //指定默认为text/html返回模式
    gsContType  := '';

    try
        //表明收到了get消息
        AddDebugMsg(' -');
        AddDebugMsg(' -> Enter OnGetDocument');

        //如果为401,则退出
        if Flags = hg401 then begin
            AddDebugMsg(' -> Exit with hg401');
            Exit;
        end;

        // 取得连接
        ClientCnx := TDWHttpConnection(Client);
        AddDebugMsg(' -> Get ClientCnx');

        //反编码, 去除其中可能{}"
        sPath     := dwUnescape(dwDecode(ClientCnx.Path));

        //删除/
        Delete(sPath,1,1);

        //根据是否为JSON字符串分别处理（只处理非JSON的情况）
        if not dwStrIsJson(sPath) then begin

            //处理SSE启动消息,主要包括：
            //1 回复SSE消息,消息格式为：标志头+句柄， 如： /dws_sse_start_4365433
            //2 在数组中创建一个对象，用于保存当前ClientCnx；同时保存当前对应的handle
            if Copy(ClientCnx.Path,1,Length('/dws_sse_start_')) = '/dws_sse_start_' then begin
                //1 回复SSE消息，创建SSE
                ClientCnx.SendStr(
                        'HTTP/1.1200 OK'#13#10 +
                        'Content-Type: text/event-stream; charset=UTF-8'#13#10 +
                        'Cache-Control: no-cache'#13#10 +
                        'Connection: keep-alive'#13#10 +
                        //'Access-Control-Allow-Origin: *'#13#10+
                        #13#10);
                Flags   := hgWillSendMyself;
                ClientCnx.KeepAlive := True;

                //
                SetLength(goSSEs,Length(goSSEs)+1);
                goSSEs[High(goSSEs)]    := ClientCnx;
                goSSEs[High(goSSEs)].SseHandle := StrToIntDef(Copy(ClientCnx.Path,Length('/dws_sse_start_')+1,10),-1);

                //
                Exit;
            end;

            //得到响应字符串  HttpServerGetDocument
            sResp   := dwGetPostResponse(ClientCnx,sPath);

            //
            sResp   := UTF8Encode(sResp);

            //为空字符串时表示是系统下载文件
            if sResp <> '' then begin
                //2024-03-09 增加了以下2行代码，以解决dwdirect返回中文乱码问题
                //ClientCnx.FRequestContentType    := 'text/html; charset=utf-8';
                //ClientCnx.AnswerString(Flags,'','', '', sResp);

                //2024-03-09 屏蔽了以下1行代码，以解决dwdirect返回中文乱码问题
                ClientCnx.AnswerStringEx(Flags,'',gsContType, '', sResp,65001); //CP_UTF8 = 65001; UTF-8 translation

                //AddDebugMsg(' Resp1 = '+sResp);
                AddDebugMsg(' Resp = HTML');
            end;
        end;
    except
    end;
end;



procedure TMainForm.FormShow(Sender: TObject);
var
    joReg       : Variant;
begin
    if not FInitialized then begin
        FInitialized := TRUE;


        {$IFDEF VER330}
            Label_Version.Caption := '[ D10.3.3 ]';
        {$ENDIF}
        {$IFDEF VER340}
            Label_Version.Caption := '[ D10.4.2 ]';
        {$ENDIF}
        {$IFDEF VER350}
            Label_Version.Caption := '[ D11.3 ]';
        {$ENDIF}
        {$IFDEF VER360}
            Label_Version.Caption := '[ D12 ]';
        {$ENDIF}
        {$IFDEF VER370}
            Label_Version.Caption := '[ D13 ]';
        {$ENDIF}

        //根据参数情况处理
        case ParamCount of
            0 : begin //从INI中恢复
            end;
            1,2 : begin //命令行模式，一参数，仅端口模式
                giPort    := StrToIntDef(ParamStr(1),_DEFUALTPORT);
            end;
            3 : begin //命令行模式，三参数： 端口，left , Top
                giPort    := StrToIntDef(ParamStr(1),_DEFUALTPORT);
                Left      := StrToIntDef(ParamStr(2),Left);
                Top       := StrToIntDef(ParamStr(3),Top);
            end;
            5 : begin //命令行模式，三参数： 端口，left , Top ，Width, Height
                giPort    := StrToIntDef(ParamStr(1),_DEFUALTPORT);
                Left      := StrToIntDef(ParamStr(2),Left);
                Top       := StrToIntDef(ParamStr(3),Top);
                Width     := StrToIntDef(ParamStr(4),Width);
                Height    := StrToIntDef(ParamStr(5),Height);
            end;

            6 : begin //命令行模式，三参数： 端口，left , Top ，Width, Height, shuntflag
                giPort    := StrToIntDef(ParamStr(1),_DEFUALTPORT);
                Left      := StrToIntDef(ParamStr(2),Left);
                Top       := StrToIntDef(ParamStr(3),Top);
                Width     := StrToIntDef(ParamStr(4),Width);
                Height    := StrToIntDef(ParamStr(5),Height);
                giShunt   := StrToIntDef(ParamStr(6),-1);
            end;

        end;

        //端口
        SpinEdit_Port.Value := giPort;

        //SeverID
        Edit_UUID.Text  := Copy(dwGetMacAddress(0),1,12)+''+Copy(dwGetUUID,1,12);

        //初始化udp端口
        wwuInit(13027,13027, ProcessMsg);

        //启动时间
        Timer_Init.Enabled  := True;

        //启动管理Timer
        Timer_Manager.Enabled    := True;

    end;
end;




procedure TMainForm.HttpServerPostDocument(Sender, Client: TObject; var Flags: THttpGetFlag);
var
    ClientCnx   : TDWHttpConnection;
    //
    sPath       : string;      //路径
    sParams     : string;      //参数
    sResp       : string;      //回应
    sPost       : string;      //post的数值
    sTmp        : string;      //临时
    pData       : PAnsiChar;
    //
    hInst       : THandle;
    fDirect     : PdwDirect;   //直接数据交互函数
    Remains     : Integer;
    //
    joResp      : Variant;

    //发送回应, 并发送给监控模块
    procedure SendResp(S:String);
    begin

        //发送回应
        //S    := (UTF8ToWideString(S));
        //S    := dwEncodeURIComponent(S);
        //ClientCnx.AnswerString(Flags,'','application/json', '', S);
        ClientCnx.AnswerStringEx(Flags,'',gsContType, '', s,65001); //CP_UTF8 = 65001; UTF-8 translation


        //发送消息到监控器
        AddDebugMsg(' SendResp = '+dwDecodeURIComponent(s));
    end;
begin
    //指定默认为text/html返回模式
    gsContType  := '';


    AddDebugMsg(' - ');
    AddDebugMsg(' -> HttpServerPostDocument   ');
    try
        { Not authenticated (yet), we might be still in an authentication       }
        { session with ClientCnx.RequestContentLength = 0 which was valid,      }
        { i.e. NTLM uses a challenge/response method, anyway just exit.         }
        if Flags = hg401 then begin
             Exit;
        end;

        // It's easier to do the cast one time. Could use with clause...
        ClientCnx := TDWHttpConnection(Client);

        // Count request and display a message }
        //InterlockedIncrement(FCountRequests);

        //Display('[' + FormatDateTime('HH:NN:SS', Now) + ' ' + ClientCnx.GetPeerAddr + '] ' + IntToStr(FCountRequests) +  ': ' + ClientCnx.Version + ' POST ' + ClientCnx.Path);
        //DisplayHeader(ClientCnx);
        //for var I := 0 to ClientCnx.RequestHeader.Count - 1 do
        //    AddDebugMsg(' HDR' + IntToStr(I + 1) + ') ' +  ClientCnx.RequestHeader.Strings[I]);

        //得到path
        sPath     := dwUnescape(dwDecode(ClientCnx.Path));  //反编码, 去除其中可能{}"
        Delete(sPath,1,1);                      //删除/

        //得到参数
        sParams   := ClientCnx.Params;


        //显示原始信
        AddDebugMsg(' -> ' + sPath);
        AddDebugMsg(' -> Para = ' + sParams);
        //ClientCnx.FPostedRawData[ClientCnx.FDataLen] := #0;
        //AddDebugMsg(' Post RAW  = ' + String(ClientCnx.FPostedRawData));



        if dwStrIsJson(sPath) then begin
            //::如果是JSON,则表明是deweb的消息

            AddDebugMsg(' -> Post DeWeb Application ');

            //得到处理回应字符串 HttpServerPostDocument
            sResp   := dwGetPostResponse(ClientCnx,sPath);

            //为空字符串时表示是系统下载文件,此时不处理即可;
            //如果不为空,则表示deweb回应消息
            if sResp <> '' then begin
                ClientCnx.AnswerStringEx(Flags,'','', '', sResp,65001); //CP_UTF8 = 65001; UTF-8 translation
                AddDebugMsg(' Resp2 = '+sResp);
            end;
        end else begin
            //说明：直接数据交互模式
            if ExtractFileExt(LowerCase(sPath)) = '.dll' then begin

                sTmp := gsMainDir+'apps\'+sPath;
                if FileExists(sTmp) then begin
                    try
                        //载入DLL
                        hInst     := LoadLibrary(PChar(sTmp));
                        //取得函数
                        fDirect   := GetProcAddress(hInst,'dwDirectInteraction');
                        //得到参数
                        sParams   := ClientCnx.Params;

                        //得到post的数据 2022-11-25添加
                        sPost   := '';
                        if ClientCnx.RequestContentLength > 0 then begin
                            ClientCnx.ReceiveStr;
                            Flags := hgAcceptData;
                            // We wants to receive any data type. So we turn line mode off on
                            // client connection.
                            ClientCnx.LineMode := FALSE;
                            // We need a buffer to hold posted data. We allocate as much as the
                            // size of posted data plus one byte for terminating nul char.
                            // We should check for ContentLength = 0 and handle that case...
                            Remains := ClientCnx.RequestContentLength - ClientCnx.FDataLen+2;
                            //=== 以下几行代码

                            pData   := AnsiStrAlloc(Remains);
                            //Clear received length                                            /
                            //ClientCnx.FDataLen := 0;
                            ClientCnx.Receive(pData,Remains);
                            //pData[Remains]  := #0;    //此行代码导致异常

                            //
                            sPost   := StrPas(pData);
                            sPost   := Copy(sPost,1,Remains);
                            sPost   := DecodeUtf8Str(sPost);

                            StrDispose(pData);
                        end;

                        //执行函数，取得返回值
                        sResp     := String(fDirect(PWideChar(sPost)));//sParams)));   //2022-11-25修改为sPost

                        //如果参数中指定输出为json模式，则输出为json格式
                        if pos('json=1',sPost) > 0 then begin
                            gsContType  := 'application/json';
                        end;

                        //发送回应
                        SendResp(sResp);
                        //
                        AddDebugMsg(' DllPath = ' + sPath);
                        AddDebugMsg(' Params = ' + sParams);
                    finally
                         //释放DLL
                         FreeLibrary(hInst);
                    end;
                end else begin
                    //发送回应
                    SendResp('no library');
                end;
                Exit;
            end else if ExtractFileExt(LowerCase(sPath)) = '.wx' then begin
                //
                AddDebugMsg(' wechat Application in main');

                //
                sTmp    := gsMainDir+'apps\'+sPath;
                sTmp    := ChangeFileExt(sTmp,'.dll');
                if FileExists(sTmp) then begin
                    try
                        //得到post的数据
                        sPost   := '';
                        if ClientCnx.RequestContentLength > 0 then begin
                            ClientCnx.ReceiveStr;
                            Flags := hgAcceptData;
                            // We wants to receive any data type. So we turn line mode off on
                            // client connection.
                            ClientCnx.LineMode := FALSE;
                            // We need a buffer to hold posted data. We allocate as much as the
                            // size of posted data plus one byte for terminating nul char.
                            // We should check for ContentLength = 0 and handle that case...
                            Remains := ClientCnx.RequestContentLength - ClientCnx.FDataLen+2;
                            //=== 以下几行代码

                            pData   := AnsiStrAlloc(Remains);
                            //Clear received length                                            /
                            //ClientCnx.FDataLen := 0;
                            ClientCnx.Receive(pData,Remains);
                            //pData[Remains]  := #0;    //此行代码导致异常

                            //
                            sPost   := StrPas(pData);
                            sPost   := Copy(sPost,1,Remains);
                            sPost   := DecodeUtf8Str(sPost);

                            StrDispose(pData);
                        end;

                        //
                        AddDebugMsg(' wechat post data = '+sPost);

                        //载入DLL
                        hInst     := LoadLibrary(PChar(sTmp));
                        //取得函数
                        fDirect   := GetProcAddress(hInst,'dwDirectInteraction');
                        //得到参数
                        sParams   := ClientCnx.Params;
                        //
                        joResp  := _json('{}');
                        joResp.path    := ClientCnx.Path;
                        joResp.params  := ClientCnx.Params;
                        joResp.data    := dwEscape(sPost);
                        //执行函数，取得返回值
                        sResp     := String(fDirect(PWideChar(string(joResp))));

                        //如果参数中指定输出为json模式，则输出为json格式
                        if pos('json=1',sPost) > 0 then begin
                            gsContType  := 'application/json';
                        end;

                        //发送回应
                        //SendResp(sResp);
                        //ClientCnx.AnswerString(Flags,'','', '', UTF8Encode(sResp));
                        ClientCnx.AnswerStringEx(Flags,'',gsContType, '', sResp,65001); //CP_UTF8 = 65001; UTF-8 translation
                        //
                        AddDebugMsg(' wxPath = ' + sPath);
                        AddDebugMsg(' wxResp = ' + sResp);
                    finally
                         //释放DLL
                         FreeLibrary(hInst);
                    end;
                end else begin
                    //发送回应
                    SendResp('no library');
                end;
                Exit;
            end;

            //如果上传超过限制，则退出
            if (ClientCnx.RequestContentLength > gsMAX_UPLOAD_SIZE*1024*1024) or (ClientCnx.RequestContentLength <= 0) then
            begin
                 if (ClientCnx.RequestContentLength > gsMAX_UPLOAD_SIZE*1024*1024) then begin
                   //Display('Upload size exceeded limit (' + IntToStr(MAX_UPLOAD_SIZE) + ')');
                      Flags := hg403;
                 end;
                 Exit;
            end;



            { Check for request past. We accept data for '/cgi-bin/FormHandler'    }
            { and any name starting by /cgi-bin/FileUpload/' (End of URL will be   }
            { the filename                                                         }
            //if (CompareText(ClientCnx.Path, '/cgi-bin/FormHandler') = 0) or (CompareText(Copy(ClientCnx.Path, 1, Length(FILE_UPLOAD_URL)), FILE_UPLOAD_URL) = 0) then
            begin
                { Tell HTTP server that we will accept posted data                 }
                { OnPostedData event will be triggered when data comes in          }
                Flags := hgAcceptData;
                { We wants to receive any data type. So we turn line m ode off on   }
                { client connection.                                               }
                ClientCnx.LineMode := FALSE;
                { We need a buffer to hold posted data. We allocate as much as the }
                { size of posted data plus one byte for terminating nul char.      }
                { We should check for ContentLength = 0 and handle that case...    }
                ReallocMem(ClientCnx.FPostedRawData, ClientCnx.RequestContentLength + 1);
                //GetMem(ClientCnx.FPostedRawData, ClientCnx.RequestContentLength + 1);
                { Clear received length                                            }
                ClientCnx.FDataLen := 0;
            end;

        end;
    except

    end;
end;


procedure TMainForm.HttpServerPostedData(
    Sender : TObject;               { HTTP server component                 }
    Client : TObject;               { Client posting data                   }
    Error  : Word);                 { Error in data receiving               }
var
    Len     : Integer;
    Remains : Integer;
    Junk    : array [0..255] of AnsiChar;
    ClientCnx  : TDWHttpConnection;
    Dummy  : THttpGetFlag;
    sData   : String;
    sResp   : string;
begin


    AddDebugMsg(' -');
    AddDebugMsg(' -> HttpServerPostedData 2');

    //指定默认为text/html返回模式
    gsContType  := '';


    { It's easyer to do the cast one time. Could use with clause... }
    ClientCnx := TDWHttpConnection(Client);

    //ClientCnx.PostedDataReceived;
    //AddDebugMsg(' -> PostedRawData : '+ClientCnx.FPostedRawData);

    { How much data do we have to receive ? }
    Remains := ClientCnx.RequestContentLength - ClientCnx.FDataLen;
    if Remains <= 0 then begin
        { We got all our data. Junk anything else ! }
        Len := ClientCnx.Receive(@Junk, SizeOf(Junk) - 1);
        if Len >= 0 then
            Junk[Len] := #0;
        Exit;
    end;

    { Receive as much data as we need to receive. But warning: we may       }
    { receive much less data. Data will be split into several packets we    }
    { have to assemble in our buffer.                                       }
    Len := ClientCnx.Receive(ClientCnx.FPostedRawData + ClientCnx.FDataLen, Remains);
    { Sometimes, winsock doesn't wants to givve any data... }
    if Len <= 0 then
        Exit;

    AddDebugMsg(' -> PostedRawData : '+ClientCnx.FPostedRawData);

    { Add received length to our count }
    Inc(ClientCnx.FDataLen, Len);
    { Check maximum length }
    if ClientCnx.FDataLen > gsMAX_UPLOAD_SIZE*1024*1024 then begin
        { Break the connexion }
        ClientCnx.CloseDelayed;
        //Display('Upload size exceeded limit (' +  IntToStr(MAX_UPLOAD_SIZE) + ')');
        Exit;
    end;
    { Add a nul terminating byte (handy to handle data as a string) }
    ClientCnx.FPostedRawData[ClientCnx.FDataLen] := #0;

    { When we received the whole thing, we can process it }
    if ClientCnx.FDataLen = ClientCnx.RequestContentLength then begin
        { First we must tell the component that we've got all the data }
        ClientCnx.PostedDataReceived;

        if ClientCnx.RequestMethod = httpMethodPost then begin

            { Then we check if the request is one we handle }
            if CompareText(ClientCnx.Path, '/deweb/post') = 0 then begin
                //此处处理deweb的post消息
                sData   := ClientCnx.FPostedRawData;

                //HttpServerPostedData
                sResp   := dwGetPostResponse(ClientCnx,sData);
                (*
                if giTmp = 0 then begin
                    giTmp   := 1;
                end else begin
                    sResp   := '{"m":"update","o":""}';//dwGetPostResponse(ClientCnx,sData);
                end;
                *)
                //sResp   := '{"m":"update","o":""}';
                //
                ClientCnx.AnswerStringEx(Dummy,'','', '', sResp,65001); //CP_UTF8 = 65001; UTF-8 translation
                //
                AddDebugMsg(' -> Resp = '+sResp);
                AddDebugMsg(' -');
            end else
            //if (CompareText(Copy(ClientCnx.Path, 1, Length(FILE_UPLOAD_URL)), FILE_UPLOAD_URL) = 0) then
            begin
                { We are happy to handle this one }
                ProcessPostedData_FileUpload(ClientCnx);
            end
            //else ClientCnx.Answer404;
        end;

    end;
end;

procedure TMainForm.ListView_AppsDblClick(Sender: TObject);
var
     sApp      : String;
begin
     if  ListView_Apps.Selected = nil then begin
          Exit;
     end;
     //
     sApp      := ListView_Apps.Selected.Caption;
     //
     sApp      := 'http://127.0.0.1:'+IntToStr(SpinEdit_Port.Value)+'/'+sApp;

     ShellExecute(Application.Handle, nil, PChar(sApp), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.Memo_msgChange(Sender: TObject);
begin

end;

//
procedure TMainForm.AddDebugMsg(AMsg:string);
begin
     if PageControl.ActivePage = TabSheet_Debug then begin
          Memo_Msg.Lines.Add(FormatDateTime('hh:mm:ss zzz ',Now)+AMsg);
     end;
end;

procedure TMainForm.RadioButton_LocalClick(Sender: TObject);
begin
     giResource     := 0;
end;

procedure TMainForm.RadioButton_PublicClick(Sender: TObject);
begin
     giResource     := 1;

end;

procedure TMainForm.RadioButton_ThirdClick(Sender: TObject);
begin
     giResource     := 2;

end;

procedure TMainForm.PopItem_CloseClick(Sender: TObject);
begin
    //
    Tag := 999; //设置一个标志，表示确实要退出
    Application.Terminate;
end;

procedure TMainForm.PopItem_HideClick(Sender: TObject);
begin
    //关闭到托盘
    Tag := Ord(WindowState);
    WindowState := wsMinimized;
    TrayIcon.SetDefaultIcon;
    TrayIcon.Visible := True;
    Hide;

end;

procedure TMainForm.PopItem_ShowClick(Sender: TObject);
begin
    TrayIcon.Visible := False;
    Show;
    WindowState := TWindowState(tag);
    SetForegroundWindow(Handle);
end;

procedure TMainForm.ProcessPosteData_FileUploadBinaryData(
  ClientCnx: TDWHttpConnection; const FileName: String);
var
    Stream   : TFileStream;
    DataDir  : String;
    Dummy    : THttpGetFlag;
begin
     { We don't want any slash or backslash or colon for security.        }
     if (Pos('/', FileName) > 0) or
          (Pos('\', FileName) > 0) or
          (Pos(':', FileName) > 0) then begin
               ClientCnx.Answer403;  // Forbidden
               Exit;
     end;

     // Before saving the file, we should check if it is
     // allowed. But this is just a demo :-)
     DataDir := IncludeTrailingPathDelimiter(
                   goHttpServer.DocDir) + gsUPLOAD_DIR;
     ForceDirectories(DataDir);
     Stream := TFileStream.Create(DataDir + FileName, fmCreate);
     try
          Stream.WriteBuffer(ClientCnx.FPostedRawData^, ClientCnx.FDataLen);
     finally
          FreeAndNil(Stream);
     end;
     ClientCnx.AnswerString(Dummy,
          '',           { Default Status '200 OK'         }
          '',           { Default Content-Type: text/html }
          '',           { Default header                  }
          '<HTML>' +
               '<HEAD>' +
                    '<TITLE>ICS WebServer Form Demo</TITLE>' +
               '</HEAD>' + #13#10 +
               '<BODY>' +
                    '<H2>Your file has been saved1:</H2>' + #13#10 +
                    '<P>Filename = &quot;' +
                    '<A HREF="/formupload.html">More file upload</A><BR>' +
                    '<A HREF="/demo.html">Back to demo menu</A><BR>' +
               '</BODY>' +
          '</HTML>');
end;

procedure TMainForm.ProcessPosteData_FileUploadMultipartFormData( ClientCnx: TDWHttpConnection; const AFileName: String);
var
    Stream      : TMemoryStream;
    Decoder     : TFormDataAnalyser;
    Field       : TFormDataItem;
    FileName    : String;
    ErrMsg      : String;
    DataDir     : String;
    Dummy       : THttpGetFlag;
    //以下是为了防止提交时会覆盖同名文件的处理
    sFileName   : String;       //文件名，不含扩展名
    sFileExt    : string;       //文件扩展名，如.png
    iFile       : Integer;      //用于查找可用文件名的变量
    sLastName   : string;       //最后接收的文件名
    sSourceName : string;       //上传文件的原始名称
    sAxios      : string;
    //
    sPath       : string;
    joTemp      : Variant;
    sDestDir    : string;      //上传文件指定的目录,格式为: mydir\  前面无\,后面有\. 若为空,则为默认目录
    //
    iHead       : Integer;     //用于读取参数的循环变量
    iClientId   : Integer;     //窗体Handle
    sTmp        : String;      //临时变量
    oForm       : TForm;       //窗体
begin
    //-------------------------------------------------------------------------
    // Filename passed as argument is from the URL.
    // When using multipart/form-data, filename is into data so we don't
    // accept anything in the URL.
    // 上面的翻译。
    //FileName是通过URL传递过来的，
    //当使用multipart/form-data模式时，文件名在data中，所以我们在URL中什么也取不到
    //-------------------------------------------------------------------------


    if AFileName <> '' then begin
         ClientCnx.Answer403;   // Forbidden
         Exit;
    end;

    //从RequestHeader中得到destdir,即上传文件的目标目录
    sDestDir    := '';
    for iHead := 0 to ClientCnx.RequestHeader.Count-1 do begin
        sTmp := ClientCnx.RequestHeader[iHead];
        if Copy(sTmp,1,7) = 'destdir' then begin
            Delete(sTmp,1,Pos(':',sTmp));
            sTmp    := Trim(sTmp);
            if sTmp <> '' then begin
                sDestDir    := Trim(sTmp)+'\';
                //将目录中的/转换为\
                sDestDir    := StringReplace(sDestDir,'/','\',[rfReplaceAll]);
            end;
            //
            break;
        end;
    end;


    ErrMsg := '';
    try
         Stream := TMemoryStream.Create;
         try
              Stream.WriteBuffer(ClientCnx.FPostedRawData^, ClientCnx.FDataLen);
              Stream.Seek(0, 0);
              Decoder := TFormDataAnalyser.Create(nil);
              try
                   // Decoder.OnDisplay := WebAppSrvDataModule.DisplayHandler;
                   Decoder.DecodeStream(Stream);

                   // Extract file, do a minimal validity check
                   Field := Decoder.Part('File');
                   if not Assigned(Field) then begin
                        AddDebugMsg(' -> Missing file');
                   end else begin
                        FileName := ExtractFileName(Field.ContentFileName);
                        if FileName = '' then begin
                             AddDebugMsg(' -> Missing file name');
                        end else if Field.DataLength <= 0 then begin
                             AddDebugMsg(' -> Empty file');
                        end else begin
                             //说明：以下注释的代码为以前检查文件名合法性的。 由于后面采用了随机文件名，所以没用了
                             // We don't want any slash or backslash or colon
                             // for security.
                             //if (Pos('/', FileName) > 0) or (Pos('\', FileName) > 0) or (Pos(':', FileName) > 0) then begin
                             //     ClientCnx.Answer403;  // Forbidden
                             //     Exit;
                             //end;

                             //保存原始上传的文件名称，后面写到窗体__uploadsource属性中
                             sSourceName    := FileName;

                             // 保存文件之前，先检查目录是否存在。如果不存在，则创建
                             if sDestDir = '' then begin
                                DataDir := IncludeTrailingPathDelimiter( goHttpServer.DocDir) + gsUPLOAD_DIR;
                             end else begin
                                DataDir := IncludeTrailingPathDelimiter( goHttpServer.DocDir) + sDestDir;
                             end;
                             ForceDirectories(DataDir);

                             //重新生成文件名,采用年月日时分秒毫秒+随机数
                             sFileExt  := ExtractFileExt(DataDir+FileName);    //先得到扩展名
                             FileName  := FormatDateTime('YYYYMMDD_hhmmsszzz_',Now)+format('%.3d', [Random(1000)])+sFileExt;

                             // 如果存在同名，则更新文件名
                             if FileExists(DataDir + FileName) then begin
                                  sFileName := ChangeFileExt(DataDir+FileName,'');
                                  sFileExt  := ExtractFileExt(DataDir+FileName);
                                  //循环查找文件名
                                  for iFile := 1 to 9999 do begin
                                       if not FileExists(sFileName+'___'+IntToStr(iFile)+sFileExt) then begin
                                            Field.SaveToFile(sFileName+'___'+IntToStr(iFile)+sFileExt);
                                            //保存最后的文件名，以反馈消息
                                            sLastName := sFileName+'___'+IntToStr(iFile)+sFileExt;


                                            //中断，退出
                                            break;
                                       end;
                                  end;
                             end else begin
                                  Field.SaveToFile(DataDir + FileName);

                                  //保存最后的文件名，以反馈消息
                                  sLastName := DataDir + FileName;
                             end;

                             //自动激活控件事件，以取得最终的文件名
                             sPath     := ClientCnx.RequestHeader.Text;
                             Delete(sPath,1,1);


                        end;
                   end;
              finally
                   FreeAndNil(Decoder);
              end;
         finally
              FreeAndNil(Stream);
         end;
    except
         on E:Exception do ErrMsg := E.ClassName + ': ' + E.Message;
    end;


    if ErrMsg <> '' then
         ClientCnx.AnswerString(Dummy,
              '',           { Default Status '200 OK'         }
              '',           { Default Content-Type: text/html }
              '',           { Default header                  }
              '<HTML>' +
              '<HEAD>' +
                   '<TITLE>ICS WebServer Upload Demo Error</TITLE>' +
              '</HEAD>' + #13#10 +
              '<BODY>' +
                   '<H2>ERROR:</H2>' + #13#10 +
                   '<P>Filename = &quot;' + (FileName) +'&quot;</P>' +
                   '<P>' + ErrMsg + '</P>' +
                   '<A HREF="/formupload.html">More file upload</A><BR>' +
                   '<A HREF="/demo.html">Back to demo menu</A><BR>' +
              '</BODY>' +
              '</HTML>')
    else begin
         //1 从RequestHeader中得到clientid即窗体句柄
         //2 找到对应的窗体
         //3 将最后的文件名写入到对应窗体的Hint中__upload
         //4 主动激活窗体事件。后面不激活了，原因有2：在js中已激活；此处激活不能改前端

         //1 从RequestHeader中得到clientid即窗体句柄
         for iHead := 0 to ClientCnx.RequestHeader.Count-1 do begin
              sTmp := ClientCnx.RequestHeader[iHead];
              if Copy(sTmp,1,8) = 'clientid' then begin
                   Delete(sTmp,1,Pos(':',sTmp));
                   iClientId := StrToIntDef(Trim(sTmp),-1);
                   //
                   break;
              end;
         end;

         //2 找到对应的窗体
         oForm     := nil;
         for iHead := Screen.FormCount-1 downto 1 do begin
              if Screen.Forms[iHead].Handle = iClientId then begin
                   oForm     := Screen.Forms[iHead];
                   //
                   break;
              end;
         end;
         if oForm = nil then begin
              Exit;
         end;

         //3 将最后的文件名写入到对应窗体的Hint中__upload
         //dwSetProp(oForm,'__upload',ExtractFileName(sLastName));

         //4 将原始的文件名写入到对应窗体的Hint中__uploadsource
         //dwSetProp(oForm,'__uploadsource',ExtractFileName(sSourceName));

        //2024-12-26改成
        //上传前向oForm中写一个上传信息__uploadinfo，包括：拟触发事件的控件target，失效时间exprie，其他参数data
        //如: {"target":"panel1","expire":"2024-12-26 16:55:00","data":"asfiwre236"}
        //DWS在处理上传事件时，先检查__uploadinfo
        //如果当前__uploadinfo已过期，则删除__uploadinfo
        //如果未过期，则触发target控件的OnStartDock事件/OnEndDock事件，并将data写入该控件Hint的JSON对象的__uploaddata，如{"__uploaddata":"asfiwre236"}
        //如果无__uploadinfo，则按原来的处理


        //<2023-06-28 改写同时写入 __upload / __uploadsource和__uploadsources / __uploadfiles
        joTemp := _json(oForm.Hint);
        if joTemp = unassigned then begin
            joTemp := _json('{}');
        end;
        joTemp.__uploadsource  := ExtractFileName(sSourceName);    //写入上传前的文件名
        joTemp.__upload        := ExtractFileName(sLastName);      //写入上传后的服务器文件名
        if not joTemp.Exists('__uploadsources') then begin
            joTemp.__uploadsources := _json('[]');
        end;
        if not joTemp.Exists('__uploadfiles') then begin
            joTemp.__uploadfiles   := _json('[]');
        end;
        joTemp.__uploadsources.Add(ExtractFileName(sSourceName));
        joTemp.__uploadfiles.Add(ExtractFileName(sLastName));
        oForm.Hint := joTemp;
        //>


        //4 主动激活窗体事件
        //if Assigned(oForm.OnStartDock) then begin
        //     oObject   := TDragDockObject.Create(self);
        //     //oObject..UnitName   := sLastName;
        //     oForm.OnStartDock(oForm, oObject);
        //end;


        //当接收到upload文件后的回应
        {
        ClientCnx.AnswerString(Dummy,
              '',            // Default Status '200 OK'
              '',            // Default Content-Type: text/html
              '',            // Default header
              '<HTML>' +
                   '<HEAD>' +
                        '<TITLE>ICS WebServer Upload Demo</TITLE>' +
                   '</HEAD>' + #13#10 +
                   '<BODY>' +
                        '<H2>Your file has been saved2:</H2>' + #13#10 +
                        '<P>Filename = &quot;' + TextToHtmlText(FileName) +'&quot;</P>' +
                        '<P>Path = &quot;' + ClientCnx.Path +'&quot;</P>' +
                        '<A HREF="/formupload.html">More file upload</A><BR>' +
                        '<A HREF="/demo.html">Back to demo menu</A><BR>' +
                   '</BODY>' +
              '</HTML>'
         );
         }
        //
        sAxios    :=
        '{'
            +'"m":"event",'
            +'"i":[!handle!],'
            +'"c":"_FORM_",'
            +'"v":{"m":"upload","name":"'+sLastName+'"}'
        +'}';

        //
        joTemp          := _json('{}');
        joTemp.m        := 'update';
        joTemp.o        := 'console.log("ok");';
        joTemp.file     := dwEscape(sLastName);
        joTemp.source   := dwEscape(sSourceName);

        ClientCnx.AnswerString(Dummy,
            '',            // Default Status '200 OK'
            '',            // Default Content-Type: text/html
            '',            // Default header
            String(joTemp)
            //'{"m":"update","o":"console.log('''+dwEscape(sSourceName)+''','''+dwEscape(sLastName)+''');"}'
        );

    end;
end;

procedure TMainForm.ProcessPostedData_FileUpload(ClientCnx: TDWHttpConnection);
var
     FileName  : String;
begin
     { FileName is the end of URL                                         }
     FileName := UrlDecode(Copy(ClientCnx.Path, Length(FILE_UPLOAD_URL) + 1, MAXINT));
     //FileName := UrlDecode(Copy(ClientCnx.Path, 1, MAXINT));

     if Pos('multipart/form-data', ClientCnx.RequestContentType) > 0 then begin
          // We come here from a HTML form
          //Display('Data from HTML form');
          ProcessPosteData_FileUploadMultipartFormData(ClientCnx, FileName);
     end
     else if SameText(ClientCnx.RequestContentType, 'application/binary') then begin
          // We come here from HttpPost demo
          //Display('Data from HttpPost demo');
          ProcessPosteData_FileUploadBinaryData(ClientCnx, FileName);
     end else begin
          // We won't accept anything else
          ClientCnx.Answer403;  // Forbidden
     end;
end;

function TMainForm.SendMsgToForm(AHandle: THandle; AMsg: String): Integer;
var
    iForm   : Integer;
begin
    try
        for iForm := High(goSSEs) downto 0 do begin
            if goSSEs[iForm].SseHandle = AHandle then begin
                goSSEs[iForm].SendStr('data:'+AMsg+#13#10#13#10);
                //
                AddDebugMsg('[SSE]'+AMsg);
                //
                break;
            end;
        end;
    except
        //
        AddDebugMsg('[ErrorSSE]'+AMsg);
    end;
end;

procedure TMainForm.SendWMMsg(AMsg: String);
var
     cdds      : TCopyDataStruct;
     iHandle   : THandle;
begin
     //Exit;

     iHandle   := FindWindow('TMsgMonitor',nil);
     if iHandle >0 then begin
          cdds.dwData := 0;
          cdds.cbData := length(AMsg)*SizeOf(Char)+1;
          cdds.lpData := pWidechar((AMsg));
          Windows.SendMessage(iHandle,WM_COPYDATA,0,LongWord(@cdds));
     end;
end;

procedure TMainForm.SpeedButton_ClearClick(Sender: TObject);
begin
     Memo_Msg.Lines.Clear;
end;

procedure TMainForm.SpeedButton_CopyClick(Sender: TObject);
var
    clip: TClipboard;
begin
    clip := TClipboard.Create; {建立}
    clip.AsText := Edit_UUID.Text;  {把窗体标题放入剪切板}
    //ShowMessage(clip.AsText);  {从剪切板读取, 返回结果是: Form1}
    {因为剪切板是全局的, 此时可以在其他地方粘贴一试}
    clip.Free;                 {释放}
end;

procedure TMainForm.SpeedButton_debugClick(Sender: TObject);
begin
     with TSpeedButton(Sender) do begin
        if Caption = 'silence' then begin
            Caption             := 'debug';
            {$IF CompilerVersion >= 34}
                ImageIndex          := 6;
            {$IFEND}
            Memo_Msg.Visible    := True;
            //
            ListView_Apps.Align     := alTop;
            ListView_Apps.Height    := 100;
        end else begin
            Caption                 := 'silence';
            {$IF CompilerVersion >= 34}
                ImageIndex              := 2;
            {$IFEND}
            //Memo_Msg.Visible    := False;
        end;
     end;

end;

procedure TMainForm.SpeedButton_demosClick(Sender: TObject);
begin
    //打开
    ShellExecute(Application.Handle, nil, PChar('https://www.delphibbs.com/mall'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.SpeedButton_ExitClick(Sender: TObject);
var
    otmp    : TCloseAction;
begin
    if MessageDlg(#13#13'      Are you sure to exit DeWeb server?      '#13#13,mtConfirmation,[mbOK,mbCancel],0) = mrOK then begin
        Tag := 999;
        Self.OnClose(self,oTmp);
        Application.Terminate;
    end;
end;

procedure TMainForm.SpeedButton_DocClick(Sender: TObject);
begin
    //打开
    ShellExecute(Application.Handle, nil, PChar('https://www.delphibbs.com/doc'), nil, nil, SW_SHOWNORMAL);

end;

procedure TMainForm.SpeedButton_AccountAddClick(Sender: TObject);
var
    iDataBase   : Integer;
    iItem       : Integer;
    iParams     : Integer;
    bConnected  : Boolean;
    joDataBase  : Variant;
    oFDConn     : TFDConnection;
begin
    Form_Account.Tag    := 0;
    Form_Account.ShowModal;

    //如果新增成功，则新增一行
    if gjoConfig.database._Count > StringGrid_Account.RowCount - 1 then begin
        //取得最后一个节点
        iDataBase   := gjoConfig.database._Count-1;
        joDataBase  := gjoConfig.database._(iDataBase);

        //创建数据库连接控件。暂不连接，以防止连接不成功，导致后续代码运行异常
        for iItem := 0 to 4 do begin
            oFDConn                     := TFDConnection.Create(self);
            oFDConn.Name                := 'FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem);
            oFDConn.ConnectionString    := joDataBase.string;
            oFDConn.LoginPrompt         := False;
            oFDConn.FetchOptions.RecordCountMode := cmTotal;

            for iParams := 0 to joDataBase.params._Count - 1 do begin
                oFDConn.Params.Add(joDataBase.params._(iParams));
            end;
        end;

        //连接数据库
        bConnected  := False;
        for iItem := 0 to 4 do begin
            oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
            //只有当前账套的第1个连接成功后，才连接
            if iItem = 0 then begin
                try
                    oFDConn.Connected   := True;
                    bConnected          := oFDConn.Connected;
                except
                    bConnected  := False;
                end;
            end else begin
                if bConnected then begin
                    oFDConn.Connected   := True;
                end;
            end;
        end;

        //更新表格
        StringGrid_Account.RowCount := iDataBase + 2;
        with StringGrid_Account do begin
            Cells[0,iDataBase+1]    := '  '+IntToStr(iDataBase);
            Cells[1,iDataBase+1]    := joDataBase.name;
            Cells[2,iDataBase+1]    := dwIIF(oFDConn.Connected,'   已连接','  连接失败');
            Cells[3,iDataBase+1]    := joDataBase.string;
            Cells[4,iDataBase+1]    := joDataBase.remark;
        end;

    end;
end;

procedure TMainForm.SpeedButton_AccountDeleteClick(Sender: TObject);
var
    iRow        : Integer;
    iDataBase   : Integer;
    iItem       : Integer;
    oFDConn     : TFDConnection;
begin
    //
    iRow        := StringGrid_Account.Row;
    iDataBase   := iRow - 1;
    if MessageDlg('确定要删除账套 “'+StringGrid_Account.Cells[1,iRow]+'” 吗？',mtConfirmation,[mbOK,mbCancel],0)=mrOK then begin
        //从配置JSON对象中删除
        gjoConfig.database.Delete(iDataBase);

        //保存JSON到文件
        dwSaveTOJson(gjoConfig,gsMainDir+'config.json',False);

        //删除连接控件FDConnection_x_x
        for iItem := 0 to 4 do begin
            oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
            //
            if oFDConn <> nil then begin
                oFDConn.Destroy;
            end;
        end;

        //重命名后续的连接控件 FDConnection_x_x
        for iRow := iDataBase + 1 to StringGrid_Account.RowCount - 2 do begin
            for iItem := 0 to 4 do begin
                oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
                //
                if oFDConn <> nil then begin
                    oFDConn.Name    := 'FDConnection_'+IntToStr(iDataBase-1)+'_'+IntToStr(iItem);
                end;
            end;
        end;

        //更新表格
        with StringGrid_Account do begin
            for iRow := Row to RowCount - 2 do begin
                for iItem := 0 to ColCount - 1 do begin
                    Cells[iItem,iRow]   := Cells[iItem,iRow+1];
                end;
            end;
            RowCount    := RowCount - 1;
        end;
    end;
end;

procedure TMainForm.SpeedButton_AccountEditClick(Sender: TObject);
var
    iRow        : Integer;
    iParams     : Integer;
    joDataBase  : Variant;
    iDataBase   : Integer;
    iItem       : Integer;
    oFDConn     : TFDConnection;
    bConnected  : Boolean;
begin
    //为账套设置窗体设置一个标记: tag
    iRow    := StringGrid_Account.Row;
    //
    if gjoConfig.database._Count >= iRow then begin
        joDataBase  := gjoConfig.database._(iRow-1);
    end else begin
        ShowMessage('配置信息错误！');
        Exit;
    end;

    //显示当前
    with Form_Account do begin
        Tag                 := iRow;
        Caption             := '编辑账套信息';
        Edit_Name.Text      := joDataBase.name;
        if joDataBase.Exists('secret') then begin
            if  (joDataBase.secret=1) then begin
                ShowMessage('由于安全原因，加密账套不可编辑！只能删除后重新创建');
                Exit;
            end else begin
                Memo_String.Text    := joDataBase.string;
            end;
        end else begin
            Memo_String.Text    := joDataBase.string;
        end;
        Edit_Remark.Text    := joDataBase.remark;
        Memo_Params.Lines.Clear;
        for iParams := 0 to joDataBase.params._Count -1 do begin
            Memo_Params.Lines.Add(joDataBase.params._(iParams));
        end;
        //
        CheckBox_Disable.Checked    := False;
        if joDataBase.Exists('enabled') then begin
            if  (joDataBase.enabled=0) then begin
                CheckBox_Disable.Checked    := True;
            end;
        end;


        //更新当前连接信息
        if ShowModal = mrOK then begin
            //取得当前连接信息
            iDataBase   := iRow-1;
            joDataBase  := gjoConfig.database._(iDataBase);

            //连接数据库
            bConnected  := False;
            for iItem := 0 to 4 do begin
                oFDConn := TFDConnection(MainForm.FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
                //只有当前账套的第1个连接成功后，才连接
                if iItem = 0 then begin
                    try
                        oFDConn.Connected   := True;
                        bConnected          := oFDConn.Connected;
                    except
                        bConnected  := False;
                    end;
                end else begin
                    if bConnected then begin
                        oFDConn.Connected   := True;
                    end;
                end;
            end;

            //更新表格
            with StringGrid_Account do begin
                Cells[0,iDataBase+1]    := '  '+IntToStr(iDataBase);
                Cells[1,iDataBase+1]    := joDataBase.name;
                Cells[2,iDataBase+1]    := dwIIF(oFDConn.Connected,'   已连接','  连接失败');
                Cells[3,iDataBase+1]    := joDataBase.string;
                Cells[4,iDataBase+1]    := joDataBase.remark;
            end;
        end;
    end;

end;

procedure TMainForm.SpeedButton_BuyClick(Sender: TObject);
begin
    ShellExecute(Application.Handle, nil, PChar('https://item.taobao.com/item.htm?ft=t&id=851898123133'), nil, nil, SW_SHOWNORMAL);
end;

procedure TMainForm.SpeedButton_StartClick(Sender: TObject);
begin
    giPort    := SpinEdit_Port.Value;
    if dwStart(giPort) = 0 then begin
        SpeedButton_Start.Enabled     := False;
        SpeedButton_Stop.Enabled      := not SpeedButton_Start.Enabled;
        SpinEdit_Port.Enabled    := SpeedButton_Start.Enabled;
    end else begin
        ShowMessage('启动失败! 请检查端口是否被占用!');
    end;

end;

procedure TMainForm.SpeedButton_StopClick(Sender: TObject);
begin
    dwStop;
    //
    SpeedButton_Start.Enabled   := True;
    SpeedButton_Stop.Enabled    := not SpeedButton_Start.Enabled;
    SpinEdit_Port.Enabled       := SpeedButton_Start.Enabled;
    //
    Timer_Manager.Enabled       := False;
end;

procedure TMainForm.SpinEdit_PortChange(Sender: TObject);
begin
     giPort    := SpinEdit_Port.Value;

end;



procedure TMainForm.Timer_InitTimer(Sender: TObject);
var
    iDll    : Integer;
    sDll    : string;
    //
    hInst   : THandle;
    fLoad   : PdwLoad;     //载入页面函数
    oForm   : TForm;
begin
    //检查apps目录是否存在
    SetCurrentDir(gsMainDir);
    if not DirectoryExists('apps') then begin
        MkDir('apps');
    end;

    //检查公用模块目录
    if not DirectoryExists('publics') then begin
        MkDir('publics');
    end;

    //检查vcls目录是否存在
    SetCurrentDir(gsMainDir);
    if not DirectoryExists('vcls') then begin
        MkDir('vcls');
    end;

    //
    //ToolBar_Main.AutoSize    := False;
    //ToolBar_Main.AutoSize    := True;

    //停止当前时钟
    TTimer(Sender).Enabled   := False;

    //载入支持控件------------------------------------------------------------------------------------------------------
    Panel_Title.Caption      := 'DeWeb Component Loading ...';
    Panel_Progress.Visible   := True;

    //查找所有支持的控件
    FileListBox_Vcls.Directory    := gsMainDir+'vcls\';
    FileListBox_VCls.Update;

    //一次性读入支持控件的DLL
    if FileListBox_Vcls.Count = 0 then begin
        ShowMessage('no DeWeb Component! Please compile all .dpr in Source\dwVcls!');
    end else begin
        SetLength(grDWVcls, FileListBox_Vcls.Count);
        //同时创建字典，以快速查找控件
        grDWVclNames    := TDictionary<string,Integer>.Create();
        //
        ProgressBar.Max    := Max(0,FileListBox_Vcls.Count-1);
        //
        for iDLL := 0 to FileListBox_Vcls.Count-1 do begin
            grDWVcls[iDLL].DllName      := LowerCase(ExtractFileName(FileListBox_Vcls.Items[iDLL]));
            //
            grDWVcls[iDLL].Inst         := LoadLibrary(PChar(gsMaindir+'vcls\'+FileListBox_Vcls.Items[iDLL]));
            grDWVcls[iDLL].GetExtra     := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetExtra');
            grDWVcls[iDLL].GetEvent     := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetEvent');
            grDWVcls[iDLL].GetHead      := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetHead');
            grDWVcls[iDLL].GetTail      := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetTail');
            grDWVcls[iDLL].GetData      := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetData');
            grDWVcls[iDLL].GetMount     := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetMounted');
            grDWVcls[iDLL].GetAction    := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetAction');
            grDWVcls[iDLL].GetMethods   := GetProcAddress(grDWVcls[iDLL].Inst,'dwGetMethods');
            //Panel_Progress.Caption   := Format('%d / %d %s',[iDll+1,FileListBox_Vcls.Count,grDWVcls[iDLL].DllName]);
            ProgressBar.Position        := iDll;

            //添加DWVcls控件字典项，以便后面快速查找控件
            grDWVclNames.Add(grDWVcls[iDLL].DllName,iDLL);
            //
            Application.ProcessMessages;
        end;
    end;

    //检查注册
    //gbRegistered    := CheckRegister;
    //SetRegistered(gbRegistered);

    //设置当前工作目录
    SetCurrentDir(gsMainDir);


    //显示当前应用列表--------------------------------------------------------------------------------------------------
    //添加到ListView
    ListView_Apps.Items.Clear;
    for iDLL := 0 to FileListBox_Apps.Count-1 do begin  //
        sDll    := ChangeFileExt(ExtractFileName(FileListBox_Apps.Items[iDLL]),'');
        if Pos('__',sDll)<=0 then begin
            with ListView_Apps.Items.Add do begin
                Caption     := sDll;
                ImageIndex  := 0;
            end;
        end;
    end;

    //加载公共模块------------------------------------------------------------------------------------------------------
    for iDLL := 0 to FileListBox_Publics.Count-1 do begin  //
        //取得文件名
        sDll    := lowercase(ExtractFileName(FileListBox_Publics.Items[iDLL]));

        //跳过系统文件
        if (sDll='libmysqld51.dll') or (sDll='libmysql.dll') then begin
            continue;
        end;


        //载入dll
        hInst  := LoadLibrary(PChar(gsMainDir+'publics\'+sDll));

        //得到函数地址
        fLoad   := GetProcAddress(hInst,'dwLoad');

        //载入结果判断
        if (hInst <> 0) and  Assigned( fLoad) then begin
            //重新设置一下目录,以防出错
            SetCurrentDir(gsMainDir);

            // 调用函数
            oForm   := fLoad(_J2S(gjoConnections), nil, Application, Screen);
        end;

    end;


    //设置当前工作目录
    SetCurrentDir(gsMainDir);

    //隐藏进度条
    Panel_Progress.Visible   := False;

    //自动启动
    SpeedButton_Start.OnClick(Self);

end;

procedure TMainForm.Timer_ManagerTimer(Sender: TObject);
var
    iForm   : Integer;
    iSSE    : Integer;
    iItem   : Integer;
    iSecs   : Integer;
    iCount  : Integer;
    //
    hInst   : THandle;
    //
    bFound  : Boolean;
    //
    oForm   : TForm;
    otmp    : TCloseAction;
    //
    joMsg   : Variant;
begin
    try
        //更新在线用户数
        //SendWMMsg('[Count] : '+IntToStr(Screen.FormCount));
        iCount  := 0;
        for iForm := 4 to Screen.FormCount-1 do begin
            if LowerCase(Screen.Forms[iForm].ClassName) = 'tform1' then begin
                Inc(iCount);
            end;
        end;
        if Width > 400 then begin
            Caption := gsTitle+' --- Count : '+IntToStr(iCount);
        end else begin
            Caption := 'Count : '+IntToStr(iCount);
        end;

        //更新持续工作时间
        iSecs   := Floor((Now-gfStartTime)*24*3600);
        if iSecs<60 then begin
            Label_Hours.Caption := 'last '+IntToStr(iSecs)+' secs';
        end else if iSecs<3600 then begin
            Label_Hours.Caption := 'last '+IntToStr((iSecs div 60))+' mins';
        end else begin
            Label_Hours.Caption := 'last '+Format('%.1f',[iSecs/3600])+' hours';
        end;

        //如果启动了空闲时关闭系统, 则关闭
        if iSecs > giIdleHour *3600 then begin
            if gbCloseWhenIdle then begin
                if iCount = 0 then begin
                    MainForm.Tag := 999;
                    MainForm.OnClose(MainForm,oTmp);
                    Application.Terminate;
                    Exit;
                end;
            end;
        end;

        //定时释放过期未发送心跳包的FORM
        //AddDebugMsg(Format('[Enter Free Form Count] : %d ',[Screen.FormCount]));
        if Screen.FormCount>3 + 20 then begin
            for iForm := Screen.FormCount- 1 downto 4 do begin
                try
                    //AddDebugMsg(Format('[Enter Free Form id] : %d ',[iForm]));
                    //得到FORM对象
                    oForm     := Screen.Forms[iForm];
                    //AddDebugMsg(Format('[Get Form id] : %d ',[iForm]));

                    //只检查网页应用窗体 , 网页应用对象的ScreenSnap=True
                    if oForm.ScreenSnap then begin
                        //AddDebugMsg(Format('[ScreenSnap Form id] : %d ',[iForm]));
                        //
                        if (Now-gfStartTime)*24*3600 > oForm.SnapBuffer then begin
                            //
                            //AddDebugMsg(Format('[FreeAndNil] : %s when %d , %d',[oForm.Caption,round((Now-gfStartTime)*24*3600),Integer(oForm.SnapBuffer)]));
                            //SendWMMsg(Format('[Destroy] : %s when %d , %d',[oForm.Name,Integer((Now-gfStartTime)*24*3600),Integer(oForm.SnapBuffer]));

                            //得到DLL的句柄
                            hInst   := oForm.HelpContext;

                            //
                            //oForm.Close;
                            FreeAndNil(oForm);

                            //
                            if hInst > 0 then begin
                                AddDebugMsg(Format('[FreeLibrary for release app] : %d ',[hInst]));
                                FreeLibrary(hInst);
                            end;
                        end ;
                    end;
                except
                    //AddDebugMsg(Format('[FreeAndNil Form error] : %d ',[iForm]));
                end;
            end;
        end;
        //AddDebugMsg(Format('[Leave Free Form Count] : %d ',[Screen.FormCount]));

        //定时释放对应FORM不存在的goSSEs中的值
        for iSSE := High(goSSEs) downto 0 do begin
            //默认为未找到
            bFound  := False;

            //在所有Form中查找
            for iForm := Screen.FormCount- 1 downto 2 do begin
                //得到FORM对象
                oForm     := Screen.Forms[iForm];
                if oForm.Handle = goSSEs[iSSE].SseHandle then begin
                    bFound  := True;
                    break;
                end;
            end;

            //如果没找到，则清除当前goSSEs
            if not bFound then begin
                for iItem := iSSE to High(goSSEs)-1 do begin
                    goSSEs[iItem]   := goSSEs[iItem+1];
                end;
                SetLength(goSSEs,Length(goSSEs)-1);
            end;

        end;
(*
        //超过2小时后，随机检查注册，如果未注册，则5%概率退出系统
        {$IFNDEF _STD}
        Randomize;
        if (Now-gfStartTime)*24>2 then begin
            if Random(1000)<5 then begin
                //
                AddDebugMsg('[CheckRegister]');
                if not CheckRegister then begin
                    //
                    AddDebugMsg('[stop]');
                    //
                    SpeedButton_Stop.OnClick(self);
                    Close;
                    Exit;
                end;
            end;
        end;
        {$ENDIF}
*)
        (* 2023-06-07 做多套账时去除。感觉采用DWSGuardor后作用不大
        //闲时重启 , 3个条件 : 1选中闲时重启;2无客户访问;3当天未重启过
        if ( CheckBox_Restart.Checked ) and ( Screen.FormCount = 2 ) and (gjoConfig.restartdate <> Trunc(Now) )then begin
            DecodeTime(now,ihour,imin,isec,ims);
            if iHour in [1,2,3,4] then begin

                //取得当前重启日期
                //保存到gjoConfig
                gjoConfig.restartdate  := Trunc(Now);

                //执行关闭事件,以保存配置
                MainForm.OnClose(self,oAct);

                //运行辅助程序,以重启
                ShellExecute(0,'open',Pchar('dwsaux.exe'),nil,nil,SW_SHOWNORMAL);
            end
        end;
        *)

        //给DWSGuardor发送消息
        if FInitialized then begin
            joMsg           := _json('{}');
            joMsg.port      := giPort;
            joMsg.processid := GetCurrentProcessId;
            joMsg.formcount := Screen.FormCount;
            wwuSend(joMsg);
        end;
    except
        AddDebugMsg('Error when Timer_Manager!');

    end;
end;

procedure TMainForm.TrayIconClick(Sender: TObject);
begin
    TrayIcon.Visible := False;
    Show;
    WindowState := TWindowState(tag);
    SetForegroundWindow(Handle);

end;

function TMainForm.UpdateConnections: Integer;
var
    iDataBase   : Integer;
    iItem       : Integer;
    iParams     : Integer;
    //
    oFDConn     : TFDConnection;
    joDataBase  : Variant;
    bConnected  : Boolean;
begin
    try
        Result  := -1;

        //创建数据库
        for iDataBase := 0 to gjoConfig.database._Count -1 do begin
            joDataBase  := gjoConfig.database._(iDataBase);

            //创建数据库连接控件。暂不连接，以防止连接不成功，导致后续代码运行异常
            for iItem := 0 to 4 do begin
                oFDConn                     := TFDConnection.Create(self);
                //oFDConn.FormatOptions.StrsTrim2Len  := True;
                oFDConn.Name                := 'FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem);
                oFDConn.ConnectionString    := joDataBase.string;
                oFDConn.LoginPrompt         := False;
                oFDConn.FetchOptions.RecordCountMode := cmTotal;

                for iParams := 0 to joDataBase.params._Count - 1 do begin
                    oFDConn.Params.Add(joDataBase.params._(iParams));
                end;
            end;

            //连接数据库
            bConnected  := False;
            for iItem := 0 to 4 do begin
                oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
                //只有当前账套的第1个连接成功后，才连接
                if iItem = 0 then begin
                    try
                        oFDConn.Connected   := True;
                        bConnected          := oFDConn.Connected;
                    except
                        bConnected  := False;
                    end;
                end else begin
                    if bConnected then begin
                        oFDConn.Connected   := True;
                    end;
                end;
            end;
        end;
        //
        Result  := 0;
    except
        Result  := -1;
    end;

end;

procedure TMainForm.SetRegistered(ABool:Boolean); //根据是否注册进行处理
begin
    //默认8081端口
    if ABool then begin
        //已注册
        SpinEdit_Port.MinValue      := 0;
        SpinEdit_Port.MaxValue      := 99999;
        Panel_Port.Visible          := True;
        SpeedButton_BuyNow.Visible  := not Panel_Port.Visible ;
        SpinEdit_Port.Enabled       := True;
    end else begin
        //未注册用户
        giPort  := _DEFUALTPORT;
        //限制端口
        SpinEdit_Port.MinValue      := _DEFUALTPORT;
        SpinEdit_Port.MaxValue      := _DEFUALTPORT;
        SpinEdit_Port.Value         := _DEFUALTPORT;
    end;
    //
    SpinEdit_Port.Enabled   := ABool;
    Panel_Port.Visible      := ABool;
    //Panel_Resource.Visible  := ABool;
    SpeedButton_BuyNow.Visible := not Panel_Port.Visible ;


end;

function TMainForm.CheckRegister: Boolean;
begin
    //检查注册
    Result  := True;
end;

procedure TMainForm.FDConnectionError(ASender, AInitiator: TObject; var AException: Exception);
begin
    //AException := TFDAction.Unknown;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
    try
        Timer_Manager.Enabled            := False;

        //
        Sleep(10);
        Application.ProcessMessages;
        Sleep(10);

        //
        if goHttpServer <> nil then begin
            goHttpServer.Destroy;
        end;


    except
           //ShowMessage('Error when FormClose!');
    end;

end;



procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
    {
    if Panel_Progress.Visible then begin
        CanClose  := False ;
    end else begin
        if MessageDlg('Are you sure to exit?',mtConfirmation,[mbOK,mbCancel],0) = mrOK then begin
            CanClose  := True;
        end else begin
            CanClose  := False;
        end;
        CanClose  := True;
    end;
    }

    //关闭到托盘
    if Tag = 999 then begin
        CanClose  := True;
    end else begin
        Tag := Ord(WindowState);
        WindowState := wsMinimized;
        TrayIcon.SetDefaultIcon;
        TrayIcon.Visible := True;
        Hide;
        CanClose := False;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
    iDataBase   : Integer;
    iItem       : Integer;
    iParams     : Integer;
    //
    bConnected  : Boolean;
    //
    joDataBase  : Variant;
    joConn      : Variant;
    //
    oFDConn     : TFDConnection;
begin
    //取得系统目录
    gsMainDir := ExtractFilePath(Application.ExeName);

    //设置日志
    //SetDefaultLogFile(gsMainDir+'deweb.log');

    //设置日期格式
    SetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SSHORTDATE,pchar('yyyy-MM-dd')); //短日期
    SetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_SLONGDATE,pchar('yyyy''年''M''月 ''d''日'''));
    SetLocaleInfo(LOCALE_USER_DEFAULT,LOCALE_STIMEFORMAT,pchar('HH:mm:ss')); //设置时间
    //SendMessageTimeOut(HWND_BROADCAST,WM_SETTINGCHANGE,0,0,SMTO_ABORTIFHUNG,10,p);

    //设置标题
    Caption := gsTitle;

    //默认到第一页面
    PageControl.ActivePageIndex := 0;

    //创建JS对象
    //goJavaScript    := CreateOleObject('ScriptControl');
    //goJavaScript.Language   := 'JavaScript';

    //创建APPS目录
    if not DirectoryExists(gsMainDir+'apps') then begin
        MkDir('apps');
    end;

    //默认端口
    giPort    := _DEFUALTPORT;

    //读取配置
    gjoConfig   := _json('{}');
    if FileExists(gsMainDir+'config.json') then begin
        //从配置文件中载入
        dwLoadFromJson(gjoConfig, gsMainDir+'config.json');

        //端口号
        giPort    := gjoConfig.port;
        SpinEdit_Port.Value := giPort;

        //上传文件大小限制
        if gjoConfig.Exists('max_upload_size') then begin
            gsMAX_UPLOAD_SIZE   := gjoConfig.max_upload_size;
        end;

        //服务端缓存有效期giExpire
        if gjoConfig.Exists('expire') then begin
            giExpire    := gjoConfig.expire;
        end;

        //隐藏案例和文档
        if not gjoConfig.Exists('simple') then begin
            gjoConfig.simple    := 0;
        end;
        if gjoConfig.simple = 1 then begin
            SpeedButton_demos.Visible   := False;
            SpeedButton_doc.Visible     := False;
        end;

        //上传文件目录
        if gjoConfig.Exists('upload_dir') then begin
            gsUPLOAD_DIR        := Trim(gjoConfig.upload_dir);
            if gsUPLOAD_DIR='' then begin
                gsUPLOAD_DIR := 'upload\';
            end else begin
                if gsUPLOAD_DIR[Length(gsUPLOAD_DIR)] <> '\' then begin
                    gsUPLOAD_DIR    := gsUPLOAD_DIR+'\';
                end;
            end;
            if not DirectoryExists(gsMainDir+gsUPLOAD_DIR) then begin
                MkDir(gsUPLOAD_DIR);
            end;
        end;

        //错误网页
        if gjoConfig.Exists('errorhtml') then begin
            gsErrorHtml := gjoConfig.errorhtml;
        end;

        //自定义断开提示
        if not gjoConfig.Exists('disconnect') then begin
            gjoConfig.disconnect    := 'Network is disconnected!';
        end;

        //转换connectionstring
        if gjoConfig.Exists('connectionstring') then begin
            if not gjoConfig.Exists('database') then begin
                gjoConfig.database  := _json('[]');
            end;

            //
            joDataBase          := _json('{}');
            joDataBase.name     := 'default';
            joDataBase.string   := gjoConfig.connectionstring;
            joDataBase.remark   := '';
            joDataBase.params   := _json('[]');

            //
            gjoConfig.database.Add(joDatabase);

            //
            gjoConfig.Delete('connectionstring');

            //保存JSON到文件
            dwSaveTOJson(gjoConfig,gsMainDir+'config.json',False);
        end;

        //确保存在database
        if not gjoConfig.Exists('database') then begin
            gjoConfig.database  := _json('[]');
        end;

        //创建数据库
        for iDataBase := 0 to gjoConfig.database._Count -1 do begin
            joDataBase  := gjoConfig.database._(iDataBase);

            //创建数据库连接控件。暂不连接，以防止连接不成功，导致后续代码运行异常
            for iItem := 0 to 4 do begin
                oFDConn         := TFDConnection.Create(self);
                oFDConn.Name    := 'FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem);
                oFDConn.OnError := FDConnectionError;
                oFDConn.FetchOptions.RecordCountMode := cmTotal;
                //2025-09-02 为解决断线重连时添加
                oFDConn.ResourceOptions.AutoConnect := True;

                //如果连接字符串加密了,则先解密后再处理
                if joDataBase.Exists('secret') then begin
                    if  (joDataBase.secret=1) then begin
                        oFDConn.ConnectionString    := dwBase.dwAESDecrypt(joDataBase.string,'DeWeb@87114');
                    end else begin
                        oFDConn.ConnectionString    := joDataBase.string;
                    end;
                end else begin
                    oFDConn.ConnectionString    := joDataBase.string;
                end;

                //不显示登录框
                oFDConn.LoginPrompt         := False;

                //增加Params
                for iParams := 0 to joDataBase.params._Count - 1 do begin
                    oFDConn.Params.Add(joDataBase.params._(iParams));
                end;
            end;

            //连接数据库
            bConnected  := False;
            for iItem := 0 to 4 do begin
                oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
                //只有当前账套的第1个连接成功后，才连接
                if iItem = 0 then begin
                    try
                        //如果"enabled":0 可暂时禁用当前账套
                        if dwGetInt(joDataBase,'enabled',1) = 1 then begin
                            oFDConn.Connected   := True;
                        end;

                        //
                        bConnected          := oFDConn.Connected;
                    except
                        bConnected  := False;
                    end;
                end else begin
                    if bConnected then begin
                        oFDConn.Connected   := True;
                    end;
                end;
            end;
        end;

        //创建多数据库连接JSON字符串,用于传递给deweb应用
        gjoConnections      := _Json('{}');
        gjoConnections.db   := _Json('[]');
        for iDataBase := 0 to gjoConfig.database._Count -1 do begin
            joDataBase  := gjoConfig.database._(iDataBase);
            //
            joConn          := _Json('{}');
            joConn.name     := joDataBase.name;
            joConn.handle   := _Json('[]');
            //
            for iItem := 0 to 4 do begin
                oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_'+IntToStr(iItem)));
                if oFDConn.Connected then begin
                    joConn.handle.Add(Int64(oFDConn.CliHandle));
                    //2024-08-23添加了自动重连。
                    //2025-01-13 有用户反应运行一段后无法访问, 重启DWS正常. 暂时关闭试试
                    //oFDConn.ResourceOptions.AutoConnect := True;
                end else begin
                    joConn.handle.Add(0);
                end;
            end;

            //
            gjoConnections.db.Add(joConn);
        end;

        //////gjoConnections在dwload时有变化，待查

        //此处将数据库连接信息写到表格中
        with StringGrid_Account do begin
            Cells[0,0]      := '序号';
            Cells[1,0]      := '             账套名称';
            Cells[2,0]      := '  连接状态';
            Cells[3,0]      := '            连接字符串';
            Cells[4,0]      := '      备注';
            //
            ColWidths[0]    := 50;
            ColWidths[1]    := 200;
            ColWidths[2]    := 100;
            ColWidths[3]    := 250;
            ColWidths[4]    := 100;
        end;
        StringGrid_Account.RowCount := gjoConfig.database._Count + 1;
        for iDataBase := 0 to gjoConfig.database._Count -1 do begin
            //取得JSON对象
            joDataBase  := gjoConfig.database._(iDataBase);
            //取得第1个数据库连接
            oFDConn := TFDConnection(FindComponent('FDConnection_'+IntToStr(iDataBase)+'_0'));
            //
            with StringGrid_Account do begin
                Cells[0,iDataBase+1]    := '  '+IntToStr(iDataBase);
                Cells[1,iDataBase+1]    := joDataBase.name;
                Cells[2,iDataBase+1]    := dwIIF(oFDConn.Connected,'   已连接','  连接失败');
                Cells[3,iDataBase+1]    := joDataBase.string;
                Cells[4,iDataBase+1]    := joDataBase.remark;
            end;
        end;

{
        //
        try

            DM.FDConnection0.Close;
            DM.FDConnection0.ConnectionString := sConnect;
            DM.FDConnection0.Params.Add('CharacterSet=gb2312');
            DM.FDConnection0.Connected  := True;



        except

        end;
        if DM.FDConnection0.Connected then begin
            //SpeedButton_DB.Caption    := 'DB ON';
            //重置数据库连接
            for I := 1 to 4 do begin
                with TFDConnection(DM.FindComponent('FDConnection'+IntToStr(I))) do begin
                    Close;
                    ConnectionString    := DM.FDConnection0.ConnectionString;
                    Connected  := True;
                end;;
            end;
        end else begin
            //SpeedButton_DB.Caption    := 'DB Off';
        end;
}
    end;

    //取得启动时间
    gfStartTime    := Now;

    //
    if not DirectoryExists('apps') then begin
        MkDir('apps');
    end;

    //
    if not DirectoryExists('publics') then begin
        MkDir('publics');
    end;

    //
    FileListBox_Apps.Directory    := gsMainDir+'apps\';
    FileListBox_Apps.Update;

    //
    FileListBox_Publics.Directory    := gsMainDir+'Publics\';
    FileListBox_Publics.Update;


    //设置当前工作目录
    SetCurrentDir(gsMainDir);


{
    //
    Reg := TRegistry.Create(KEY_WRITE OR KEY_READ or KEY_WOW64_64KEY);

    Reg.RootKey := HKEY_LOCAL_MACHINE;

    if Reg.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',false) then begin

      Caption := Reg.ReadString('APoint');

    // Reg.GetValues(....) //失败!!!

    //这里就读不到了,GetLastError返回5,权限不足!

    end;


    //写注册表
    ARegistry := TRegistry.Create(KEY_WRITE OR KEY_READ or KEY_WOW64_64KEY);

    //建立一个TRegistry实例
    with ARegistry do begin
      RootKey   := HKEY_LOCAL_MACHINE;
      if OpenKey('\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows\',True) then begin
           WriteInteger('USERProcessHandleQuota',500000);
      end;
      CloseKey;
      Destroy;
    end;
}

    //设置当前工作目录
    SetCurrentDir(gsMainDir);


end;

procedure TMainForm.FormDestroy(Sender: TObject);
var
    iDWVcl    : Integer;
    iForm     : Integer;
    oForm     : TForm;
begin
    //
    Timer_Manager.Enabled            := False;

    //
    for iForm := Screen.FormCount- 1 downto 0 do begin
        //得到FORM对象
        oForm     := Screen.Forms[iForm];

        //只检查网页应用窗体 , 网页应用对象的ScreenSnap=True
        if oForm.ScreenSnap then begin
            //
            FreeAndNil(oForm);
        end;
    end;

    for iDWVcl := High(grDWVcls) downto 0 do begin
        if grDWVcls[iDWVcl].Inst > 0 then begin
            FreeLibrary(grDWVcls[iDWVcl].Inst);
        end;
    end;
end;

procedure TMainForm.FormResize(Sender: TObject);
var
    iWidth      : Integer;
begin
    with StringGrid_Account do begin
        iWidth          := ColWidths[0] + ColWidths[1] + ColWidths[2] + ColWidths[4];
        ColWidths[3]    := Width - iWidth;
    end;
    SpeedButton_demos.Visible   := (Width >= 500) and (gjoConfig.simple = 0);
    SpeedButton_doc.Visible     := SpeedButton_demos.Visible;
    Panel_Port.Visible          := (Width >= 500) and (gjoConfig.simple = 0);
end;

function dwStart(APort:Integer):Integer;
begin
    Result    := 0;

    //
    if goHttpServer = nil  then begin
        //goHttpServer    := MainForm.HttpServer1;
        goHttpServer                := THttpServer.Create(MainForm);
        with goHttpServer do begin
            DocDir          := gsMainDir;
            DefaultDoc      := 'index.html';
            MimeTypesList   := TMimeTypesList.Create(MainForm);
            MimeTypesList.AddContentType('.js', 'text/javascript');//('.zip', 'application/octet-stream')'.js')   := MainForm.MimeTypesList1;
            Options         := [hoAllowOptions,hoAllowPut,hoAllowDelete,hoAllowTrace,hoAllowPatch,hoSendServerHdr];
            OnGetDocument   := MainForm.HttpServerGetDocument;
            OnPostDocument  := MainForm.HttpServerPostDocument;
            OnPostedData    := MainForm.HttpServerPostedData;

            //
            Addr                := '0.0.0.0';
            BandwidthSampling   := 1000;
            ExclusiveAddr       := True;
            KeepAliveTimeSec    := 86400;//保活1天， 31536000;    //保活1年
            KeepAliveTimeXferSec:= 1800;    //原为300, 2025-10-29改为1800,即半小时
            LingerOnoff         := wsLingerNoSet;   //wsLingerOff, wsLingerOn, wsLingerNoSet
            LingerTimeout       := 1;
            ListenBacklog       := 5;
            SocketFamily        := sfIPv4;
            //


        end;
        //
        //goHttpServer.MimeTypesList  := MainForm.MimeTypesList1;

    end;

    //
    goHttpServer.Port               := IntToStr(giPort);
    goHttpServer.ClientClass        := TDWHttpConnection;
    goHttpServer.TemplateDir        := gsMainDir;
    try
        goHttpServer.Start;
    except
        Result    := -1;
    end;
end;



{ TDWHttpConnection }

destructor TDWHttpConnection.Destroy;
begin
    if Assigned(FPostedRawData) then begin
        FreeMem(FPostedRawData, FPostedDataSize);
        FPostedRawData  := nil;
        FPostedDataSize := 0;
    end;
    FreeAndNil (FRespTimer);  { V7.21 }
  inherited;
end;

end.

