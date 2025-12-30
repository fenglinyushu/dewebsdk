unit dwDM;

interface

  {$IFDEF VER330}
  {$ELSE}
  {$ENDIF}

uses
    System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
    FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.Phys.MSSQL, FireDAC.Phys.MSSQLDef, FireDAC.VCLUI.Wait, FireDAC.VCLUI.Login,
    FireDAC.Phys.ADSDef, FireDAC.Phys.ASADef, FireDAC.Phys.DB2Def, FireDAC.Phys.DSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.IBDef, FireDAC.Phys.InfxDef, FireDAC.Phys.MongoDBDef,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.ODBCDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.PGDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteDef, FireDAC.Phys.TDataDef, FireDAC.Phys.TDBXDef, FireDAC.Stan.StorageXML,
    FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageBin, FireDAC.Phys.TDBX, FireDAC.Phys.TData,
    FireDAC.Phys.SQLite, FireDAC.Phys.PG, FireDAC.Phys.Oracle, FireDAC.Phys.ODBC, FireDAC.Phys.MySQL,
    FireDAC.Phys.MSAcc, FireDAC.Phys.MongoDB, FireDAC.Phys.Infx, FireDAC.Phys.IB, FireDAC.Phys.IBBase,
    FireDAC.Phys.FB, FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.DB2, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ASA, FireDAC.Phys.ADS, FireDAC.Moni.RemoteClient, FireDAC.Moni.FlatFile,
    FireDAC.Moni.Base, FireDAC.Moni.Custom, FireDAC.Comp.UI, Data.DB, FireDAC.Comp.Client,
  FireDAC.Phys.SQLiteWrapper.Stat
  {Delphi 10.4之前版本请删除FireDAC.Phys.SQLiteWrapper.Stat};

type
  TDM = class(TDataModule)
    FDGUIxLoginDialog1: TFDGUIxLoginDialog;
    FDMoniCustomClientLink1: TFDMoniCustomClientLink;
    FDMoniFlatFileClientLink1: TFDMoniFlatFileClientLink;
    FDMoniRemoteClientLink1: TFDMoniRemoteClientLink;
    FDPhysADSDriverLink1: TFDPhysADSDriverLink;
    FDPhysASADriverLink1: TFDPhysASADriverLink;
    FDPhysDB2DriverLink1: TFDPhysDB2DriverLink;
    FDPhysDSDriverLink1: TFDPhysDSDriverLink;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    FDPhysIBDriverLink1: TFDPhysIBDriverLink;
    FDPhysInfxDriverLink1: TFDPhysInfxDriverLink;
    FDPhysMongoDriverLink1: TFDPhysMongoDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDPhysSQLiteDriverLink1: TFDPhysSQLiteDriverLink;
    FDPhysTDataDriverLink1: TFDPhysTDataDriverLink;
    FDPhysTDBXDriverLink1: TFDPhysTDBXDriverLink;
    FDStanStorageBinLink1: TFDStanStorageBinLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    FDStanStorageXMLLink1: TFDStanStorageXMLLink;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DM: TDM;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

end.
