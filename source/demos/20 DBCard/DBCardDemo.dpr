library DBCardDemo;

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
  unit1 in 'unit1.pas' {Form1},
  dwDBCard in '..\..\demos\_public\dwDBCard.pas';

{$R *.res}

var
    DLLApp         : TApplication;
    DLLScreen      : TScreen;


function dwLoad(AParams:String;AConnection:Pointer;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
begin
    //
    Application := AApp;
    Screen      := AScreen;

    //
    Form1       := TForm1.Create(nil);

    //保存AParams备用
    Form1.FDConnection1.SharedCliHandle := dwGetCliHandleByName(AParams,'dwDemo');

    //
    Result      := Form1;
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
