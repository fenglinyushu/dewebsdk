library Timers;

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
  Unit2 in 'Unit2.pas' {Form2},
  Unit3 in 'Unit3.pas' {Form3},
  Unit4 in 'Unit4.pas' {Form4};

{$R *.res}

var
     DLLApp         : TApplication;
     DLLScreen      : TScreen;


function dwLoad(AParams:String;AConnection:Pointer;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
var
    sDir        : string;
begin
    //
    Application := AApp;
    Screen      := AScreen;
    //

    //
    Form1       := TForm1.Create(nil);
    Form1.gsMainDir := ExtractFilePath(Application.ExeName);

    //设置数据库连接
    //Form1.FDConnection1.SharedCliHandle  := AConnection;

    //----------嵌入式窗体--------------------------------------------------------------------------
    //创建FORM
    Form1.Form2   := TForm2.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form2.Parent  := Form1.TabSheet2;
    //设置嵌入标识,必须
    Form1.Form2.HelpKeyword := 'embed';
    //
    //Form1.goConnection  := AConnection;

{    //----------嵌入式窗体--------------------------------------------------------------------------
    //创建FORM
    Form1.Form3   := TForm3.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form3.Parent  := Form1.TabSheet3;
    //设置嵌入标识,必须
    Form1.Form3.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form3.ADOQuery1.Connection   := AConnection;
}
    //----------弹出窗体--------------------------------------------------------------------------
    //创建FORM
    Form1.Form4   := TForm4.Create(Form1);
    //设置Parent
    Form1.Form4.Parent   := Form1; //必须将新窗体的Parent设置为Form1


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
