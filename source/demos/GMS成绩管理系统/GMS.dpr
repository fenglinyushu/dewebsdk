library GMS;

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
  unit_sys_User in 'unit_sys_User.pas' {Form_sys_User},
  unit_sys_ChangePsd in 'unit_sys_ChangePsd.pas' {Form_sys_ChangePsd},
  unit_sys_Log in 'unit_sys_Log.pas' {Form_sys_Log},
  unit_sys_Department in 'unit_sys_Department.pas' {Form_sys_Department},
  Unit_sys_Home in 'Unit_sys_Home.pas' {Form_sys_Home},
  unit_sys_QuickBtn in 'unit_sys_QuickBtn.pas' {Form_sys_QuickBtn},
  unit_bop_Entry in 'unit_bop_Entry.pas' {Form_bop_Entry},
  unit_bop_Test in 'unit_bop_Test.pas' {Form_bop_Test},
  unit_bop_Star2 in 'unit_bop_Star2.pas' {Form_bop_Star2},
  unit_dic_Location in 'unit_dic_Location.pas' {Form_dic_Location},
  unit_sys_Student in 'unit_sys_Student.pas' {Form_sys_Student},
  unit_dic_Item in 'unit_dic_Item.pas' {Form_dic_Item},
  dwHistory in '..\_public\dwHistory.pas',
  unit_bop_TestGroup in 'unit_bop_TestGroup.pas' {Form_bop_TestGroup},
  unit_bop_Star1 in 'unit_bop_Star1.pas' {Form_bop_Star1};

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
    Form1.FDConnection1.SharedCliHandle  := dwBase.dwGetCliHandleByName(AParams,'dwGMS');

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
