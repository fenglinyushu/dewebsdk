library MobileLogin;

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
  unit1 in 'unit1.pas' {Form1};

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
