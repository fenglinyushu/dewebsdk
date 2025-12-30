library M00;

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
  Vcl.Graphics,
  Vcl.Controls,
  Vcl.Dialogs,
  Vcl.ComCtrls,
  Vcl.ExtCtrls,
  Vcl.Grids,
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

    //
    //Form_Home           := TForm_Home.Create(Form1);
    //Form_Home.Parent    := Form1.P_0;
    //Form_Home.Align     := alClient;
    //Form_Home.Show;


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
