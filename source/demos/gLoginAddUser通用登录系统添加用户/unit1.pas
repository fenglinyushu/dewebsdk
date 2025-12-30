unit unit1;

interface

uses
    //
    dwBase,
    dwDB,
    cnDes,

    //
    SynCommons,

    //
    HttpApp,Math, Vcl.Imaging.jpeg,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
    Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
    FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
    FireDAC.Comp.Client, FireDAC.Comp.DataSet, Data.DB, FireDAC.Phys.SQLite,
    FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MSSQL, FireDAC.Phys.MySQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC, FireDAC.Phys.TDataDef,
    FireDAC.Phys.TData, FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysTDataDriverLink1: TFDPhysTDataDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    E_User: TEdit;
    E_Password: TEdit;
    BtAdd: TButton;
    P0: TPanel;
    L0: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtAddClick(Sender: TObject);
  private
    { Private declarations }
  public
    //配置文件对象
    gjoConfig   : Variant;
    //是否移动端
    gbMobile    : Boolean;
    //唯一ID
    gsCanvasId  : String;

    //
    giID        : Integer;
    gsMainDir   : string;

  end;

var
     Form1          : TForm1;


implementation

{$R *.dfm}

//==============================================================================
//说明
//为读取微信开发者信息的单元
//输入值为当前目录下的wechat.conf,格式 为JSON格式
//格式如下：
//{
//    domain":"delphibbs.com",
//    "appid":"wxc12560f7fbxxxxxx",
//    "appsecret":"43bf2ca4ed18f2ed9b7a80a88cxxxxxx"
//}
//返回值：正常返加0，否则返回-1
//使用需要 先引用 SynCommons
function _GetWeChatConf(AFile:String;var ADomain,AAppID,AAppSecret:String):Integer;
var
    slFile  : TstringList;
    joConf  : variant;
begin
    //默认返回值
    Result      := -1;
    AAppId      := '';
    AAppSecret  := '';
    ADomain     := '';

    if FileExists(AFile) then begin
        slFile  := TStringList.Create;
        slFile.LoadFromFile(AFile);
        joConf  := _json(slFile.Text);
        if joConf <> unassigned then begin
            if joConf.Exists('appid') then begin
                AAppId      := joConf.appid;
            end;
            if joConf.Exists('appsecret') then begin
                AAppSecret  := joConf.appsecret;
            end;
            if joConf.Exists('domain') then begin
                ADomain     := joConf.domain;
            end;
        end;
        slFile.Destroy;
        //
        Result  := 0;
    end;
end;



procedure TForm1.BtAddClick(Sender: TObject);
var
    iWrong      : Integer;
    iError      : Integer;
    //
    sSalt       : string;
    sPassword   : string;
    sName       : string;
    sId         : String;
    sTmp        : String;
    sStatus     : string;
    //
    bWrong      : Boolean;
    //
    joInfo      : Variant;      //写入的登录信息
begin
    try
        //异常检查变量
        iError  := 0;
        sStatus := 'captcha error';



        //打开数据表
        try

            //取得用户名
            sName   := E_User.Text;

            //异常检查变量
            iError  := 3;
            sStatus := 'dbopen error : '++gjoConfig.tablename
                    +' - '+gjoConfig.username+'='''+sName+'''';


            //根据当前输入的用户名打开数据表
            FDQuery1.Close;
            FDQuery1.SQL.Clear;
            FDQuery1.SQL.Text   := 'SELECT * FROM '+gjoConfig.tablename
                    +' WHERE '+gjoConfig.username+'='''+sName+'''';
            FDQuery1.Open;

            //异常检查变量
            iError  := 4;
            sStatus := 'usercheck error';

            //默认错误
            bWrong  := True;

            //判断是否正确
            if FDQuery1.IsEmpty then begin
                //异常检查变量
                iError  := 5;
                FDQuery1.Append;
            end else begin
                FDQuery1.Edit;
            end;

            //根据密码是否加密保存分别处理
            if gjoConfig.secret = 1 then begin  //MD5加密
                //异常检查变量
                iError  := 6;

                //取得数据表中salt和密码
                sSalt       := 'dewebsystem'+FormatDateTime('YYYYMMDDhhmmsszzz',now);

                //异常检查变量
                iError      := 7;
                sPassword   := dwGetMD5(dwGetMD5(Trim(E_Password.Text))+sSalt);

                FDQuery1.FieldByName(gjoConfig.salt).AsString       := sSalt;
                FDQuery1.FieldByName(gjoConfig.password).AsString   := sPassword;

            end else begin      //明码保存
                //异常检查变量
                iError  := 13;

                FDQuery1.FieldByName(gjoConfig.password).AsString   := Trim(E_Password.Text);

            end;

            //保存
            FDQuery1.Post;

            //
            dwMessage('--- 添加成功!---','success',self);
        except
            //异常检查变量
            //iError  := 17;

            dwMessage('config error! Please check!'+IntToStr(iError)+' : '+sStatus,'error',self);
            Exit;
        end;

    except
        dwMessage('登录异常,请联系开发人员! ' + IntToStr(iError),'error',self);
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
    dwSetMobileMode(self,414,736);

end;

end.
