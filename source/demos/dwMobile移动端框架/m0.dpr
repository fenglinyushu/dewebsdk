library m0;

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
  Unit_Modal in 'Unit_Modal.pas' {Form_Modal},
  Unit_CarNo in 'Unit_CarNo.pas' {Form_CarNo},
  Unit_Embed2 in 'Unit_Embed2.pas' {Form_Embed2},
  Unit_Embed in 'Unit_Embed.pas' {Form_Embed};

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

    //
    Form1       := TForm1.Create(nil);
    //Form1.gsMainDir := ExtractFilePath(Application.ExeName);

    //
    //Form1.fdconnection1.sharedCliHandle  := dwBase.dwGetCliHandleByName(AParams,'dwOracle');

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
