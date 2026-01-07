unit unit1;

interface

uses
    //
    dwBase,

    //
    dwBoard,

    //json解析单元, 优点是使用后不用释放
    Syncommons,

    //用于还原编码后的中文为原中文字符
    IdURI,

    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client, FireDAC.Phys.MSSQLDef, FireDAC.Phys.ODBCBase,
  FireDAC.Phys.MSSQL, FireDAC.Phys.OracleDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MySQLDef, FireDAC.Stan.ExprFuncs,
  FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC, FireDAC.Phys.SQLite,
  FireDAC.Phys.MySQL, FireDAC.Phys.MSAcc, FireDAC.Phys.Oracle,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    FDConnection1: TFDConnection;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    gsParams    : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    oTimer  : TTimer;
begin
    //启动完成后自动执行的事件

    //
    oTimer  := TTimer(FindComponent('Panel1__Timer'));
    if oTimer <> nil then begin
        oTimer.OnTimer(oTimer);
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);

end;

procedure TForm1.FormShow(Sender: TObject);
var
    sDir        : String;       //当前路径
    sName       : String;       //应用名称，默认为qcDefault, 建议以qc开始
    //
    joparams    : Variant;      //dwLoad参数对应的JSON对象
    //
    joConfig    : Variant;
begin
    try
        //取得当前路径
        sDir    := ExtractFilePath(Application.ExeName);

        //从joParams中取得配置文件名称
        sName   := dwGetProp(Self,'params');
        if sName = '' then begin
            sName   := 'bdDefault';     //cpDefault.json
        end;

        //读取配置文件到JSON对象
        dwBase.dwLoadFromJson(joConfig,sDir+'Data/'+sName+'.json');

        //读取配置文件
        Panel1.Hint := joConfig;

        //初始化panel
        bdInit(Panel1,FDConnection1,False,'');

    except

    end;
end;


end.
