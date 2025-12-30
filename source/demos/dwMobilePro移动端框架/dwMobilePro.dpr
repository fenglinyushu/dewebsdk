library dwMobilePro;

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
  Unit_Embed in 'Unit_Embed.pas' {Form_Embed},
  unit_qrcode in 'unit_qrcode.pas' {Form_qrcode},
  Unit_QuickCard in 'Unit_QuickCard.pas' {Form_QuickCard},
  Unit_Phone in 'Unit_Phone.pas' {Form_Phone},
  unit_CheckIn in 'unit_CheckIn.pas' {Form_CheckIn},
  unit_qr in 'unit_qr.pas' {Form_qr},
  unit_bmap in 'unit_bmap.pas' {Form_bmap},
  unit_coupon in 'unit_coupon.pas' {Form_Coupon},
  unit_dbhello in 'unit_dbhello.pas' {Form_dbhello},
  Unit_Driver in 'Unit_Driver.pas' {Form_Driver},
  unit_wechatqr in 'unit_wechatqr.pas' {Form_wechatqr},
  unit_Book in 'unit_Book.pas' {Form_book};

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

    //设置数据账套， 与DWS中的数据账套连接的数据库相对应
    Form1.FDConnection1.sharedCliHandle  := dwBase.dwGetCliHandleByName(AParams,'dwDemo');

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
