library dwFrame;

uses
  ShareMem,
  SysUtils,
  Forms,
  Messages,
  StdCtrls,
  Variants,
  Windows,
  Classes,
  Data.Win.ADODB,
  unit1 in 'unit1.pas' {Form1},
  {__uses__}
  unit_Card in 'unit_Card.pas' {Form_Card},
  unit_DB in 'unit_DB.pas' {Form_DB},
  unit_Document in 'unit_Document.pas' {Form_Document},
  unit_Inventory in 'unit_Inventory.pas' {Form_Inventory},
  unit_Product in 'unit_Product.pas' {Form_Product},
  unit_DataV in 'unit_DataV.pas' {Form_DataV},
  unit_Stat in 'unit_Stat.pas' {Form_Stat},
  unit_Role in 'unit_Role.pas' {Form_Role},
  unit_Home in 'unit_Home.pas' {Form_Home};

{$R *.res}

var
    DLLApp      : TApplication;
    DLLScreen   : TScreen;


function dwLoad(AParams:String;AConnection:Pointer;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
var
    sDir        : string;
begin
    //赋值主程序参数
    Application := AApp;
    Screen      := AScreen;

    //创建应用主窗体
    Form1               := TForm1.Create(nil);
    //取得运行目录备用
    Form1.gsMainDir     := ExtractFilePath(Application.ExeName);
    //设置数据库连接
    Form1.FDConnection1.SharedCliHandle  := AConnection;


    //返回值
    Result      := Form1;
end;

procedure DLLUnloadProc(dwReason: DWORD);
begin
    if dwReason = DLL_PROCESS_DETACH then begin
        Application    := DLLApp;   //恢复
        Screen         := DLLScreen;
    end;
end;



exports
    dwLoad;

begin
    DLLApp    := Application;       //保存 DLL 中初始的 Application 对象
    DLLScreen := Screen;
    DLLProc   := @DLLUnloadProc;    //保证 DLL 卸载时恢复原来的 Application
    DLLUnloadProc(DLL_PROCESS_DETACH);
end.
