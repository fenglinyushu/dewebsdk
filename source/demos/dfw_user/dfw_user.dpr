library dfw_user;

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
  unit1 in 'unit1.pas' {Form1};

{$R *.res}

var
     DLLApp         : TApplication;
     DLLScreen      : TScreen;

function dwLoad(AParams:String;AConnection:TADOConnection;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
var
     AForm     : TForm1;
begin
     //
     Application    := AApp;
     Screen         := AScreen;
     //

     //
     AForm          := TForm1.Create(nil);
     AForm.Hint     := AParams;

     //AForm.ADOQuery1.Connection   := AConnection;

     Result         := AForm;
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
