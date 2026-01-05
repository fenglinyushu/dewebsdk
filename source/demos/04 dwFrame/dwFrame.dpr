library dwFrame;

uses
  ShareMem,
  dwBase,
  SysUtils,
  Forms,
  Messages,
  StdCtrls,
  Variants,
  Windows,
  Classes,
  dwfBase in 'dwfBase.pas',
  unit1 in 'unit1.pas' {Form1},
  unit_sys_Role in 'unit_sys_Role.pas' {Form_sys_Role},
  unit_dem_CrudButton in 'unit_dem_CrudButton.pas' {Form_dem_CrudButton},
  Unit_sys_Home in 'Unit_sys_Home.pas' {Form_sys_Home},
  unit_sys_QuickBtn in 'unit_sys_QuickBtn.pas' {Form_sys_QuickBtn},
  unit_dem_Foot in 'unit_dem_Foot.pas' {Form_dem_Foot},
  unit_dem_Full in 'unit_dem_Full.pas' {Form_dem_Full},
  unit_sys_Me in 'unit_sys_Me.pas' {Form_sys_Me},
  unit_sys_ChangePsd in 'unit_sys_ChangePsd.pas' {Form_sys_ChangePsd},
  unit_dem_DBHello in 'unit_dem_DBHello.pas' {Form_dem_DBHello},
  unit_dem_Hello in 'unit_dem_Hello.pas' {Form_dem_Hello},
  unit_dem_head in 'unit_dem_head.pas' {Form_dem_Head},
  unit_sys_Department in 'unit_sys_Department.pas' {Form_sys_Department},
  unit_sys_Log in 'unit_sys_Log.pas' {Form_sys_Log},
  unit_dem_CrudMS in 'unit_dem_CrudMS.pas' {Form_dem_CrudMS},
  unit_dem_CrudMSS in 'unit_dem_CrudMSS.pas' {Form_dem_CrudMSS},
  unit_dem_CrudAuto in 'unit_dem_CrudAuto.pas' {Form_dem_CrudAuto},
  unit_sys_User in 'unit_sys_User.pas' {Form_sys_User},
  unit_dem_CrudNormal in 'unit_dem_CrudNormal.pas' {Form_dem_CrudNormal};

{$R *.res}

var
    DLLApp      : TApplication;
    DLLScreen   : TScreen;


function dwLoad(AParams:String;AConnection:Pointer;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
begin
    //赋值主程序参数
    Application := AApp;
    Screen      := AScreen;

    //创建应用主窗体
    Form1               := TForm1.Create(nil);

    //取得运行目录备用
    Form1.gsMainDir     := ExtractFilePath(Application.ExeName);

    //设置数据库连接
    Form1.FDConnection1.SharedCliHandle  := dwBase.dwGetCliHandleByName(AParams,'dwFrame');

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
