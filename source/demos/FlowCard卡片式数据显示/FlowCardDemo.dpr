library FlowCardDemo;

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
  Data.Win.ADODB,
  CloneComponents,
  unit1 in 'unit1.pas' {Form1};

{$R *.res}

var
    DLLApp         : TApplication;
    DLLScreen      : TScreen;

function dwLoad(AParams:String;AConnection:Pointer;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
begin
    //
    Application    := AApp;
    Screen         := AScreen;

    //
    Form1          := TForm1.Create(nil);


    //<---- 此处用于给当前应用指定 DeWebServer.exe 的“账套管理”中设置的数据库连接
    //可以采用以下两种方式之一：根据序号dwGetCliHandleByID 或 根据名称 dwGetCliHandleByName
    //需要在uses中引用dwBase. 注意保持uses中ShareMem是第一个引用

    //根据 id (序号，0开始) 获取数据库连接
    Form1.FDConnection1.SharedCliHandle   := dwGetCliHandleByID(AParams,0);

    //根据 Name (不区分大小写) 获取数据库连接
    //Form1.FDConnection1.SharedCliHandle   := dwGetCliHandleByName(AParams,'dwAccess');
    //----->


    Result         := Form1;
end;

procedure DLLUnloadProc(dwReason: DWORD);
begin
    if dwReason = DLL_PROCESS_DETACH then begin
        Application    := DLLApp; //恢复
        Screen         := DLLScreen;
    end;
end;

exports
    dwLoad;

begin
    DLLApp    := Application;     //保存 DLL 中初始的 Application 对象
    DLLScreen := Screen;
    DLLProc   := @DLLUnloadProc;  //保证 DLL 卸载时恢复原来的 Application
    DLLUnloadProc(DLL_PROCESS_DETACH);
end.
