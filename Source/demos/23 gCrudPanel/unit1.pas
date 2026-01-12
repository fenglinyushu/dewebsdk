unit unit1;

interface

uses
    //
    dwBase,

    //
    dwCrudPanel,

    //
    SynCommons,


    //
    Math,Variants,
    Graphics,strutils,
    ComObj,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
    FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
    Vcl.Imaging.pngimage, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle,
    FireDAC.Phys.SQLite, FireDAC.Phys.MySQL;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    LaInfo: TLabel;
    Panel1: TPanel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    //dwLoad中的参数AParams, 保存有数据账套信息
    gsParams    : String;

    //
    gjoConfig   : Variant;

    //浏览器历史控制变量, 类型为json数组
    gjoHistory  : Variant;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    iRes        : Integer;
    sDir        : String;       //当前路径
    sName       : String;       //应用名称，默认为qcDefault, 建议以qc开始
    //
    joparams    : Variant;      //dwLoad参数对应的JSON对象
begin
    try
        //取得当前路径
        sDir        := ExtractFilePath(Application.ExeName);

        //将AParams转换为JSON对象，以便后续处理
        joParams    := _json(gsParams);

        //从joParams中取得配置文件名称
        sName     := joParams.app.params;
        if sName = '' then begin
            sName   := 'cpDefault';     //cpDefault.json
        end;

        //读取配置文件到JSON对象
        dwBase.dwLoadFromJson(gjoConfig,sDir+'Data/'+sName+'.json');

        //<-----检查是否正确
        if gjoConfig = unassigned then begin
            LaInfo.Caption  := '启动未成功！配置文件不是正确的JSON格式！';
            Exit;
        end;
        if not gjoConfig.Exists('account') then begin
            LaInfo.Caption  := '启动未成功！配置文件需要account属性！';
            Exit;
        end;
        if not gjoConfig.Exists('table') then begin
            LaInfo.Caption  := '启动未成功！配置文件需要table属性！';
            Exit;
        end;
        //>-----

        LaInfo.Caption  := '0';

        //设置数据库
        FDConnection1.SharedCliHandle   := dwBase.dwGetCliHandleByName(gsParams,gjoConfig.account);

        LaInfo.Caption  := '1';

        //自动创建CRUD模块
        Panel1.Hint := gjoConfig;

        //
        LaInfo.Caption  := '2';

        //
        iRes    := cpInit(Panel1,FDConnection1,False,'');

        //
        LaInfo.Caption  := 'Res='+IntToStr(iRes);


        //信息Label
        LaInfo.Destroy;
    except
        dwMessage('gCrudPanel result : '+IntToStr(iRes),'error',self);

    end;
end;

end.
