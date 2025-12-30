library DWMS;

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
  unit_ChangePsd in 'unit_ChangePsd.pas' {Form_ChangePsd},
  unit_Pay in 'unit_Pay.pas' {Form_Pay},
  unit_Role in 'unit_Role.pas' {Form_Role},
  unit_Stat in 'unit_Stat.pas' {Form_Stat},
  unit_User in 'unit_User.pas' {Form_User},
  unit_Home in 'unit_Home.pas' {Form_Home},
  dwfBase in 'dwfBase.pas',
  unit_QuickBtn in 'unit_QuickBtn.pas' {Form_QuickBtn},
  unit_Department in 'unit_Department.pas' {Form_Department},
  unit_Category in 'unit_Category.pas' {Form_Category},
  Unit_ReceiveUnit in 'Unit_ReceiveUnit.pas' {Form_ReceiveUnit},
  Unit_Supplier in 'Unit_Supplier.pas' {Form_Supplier},
  unit_Inventory in 'unit_Inventory.pas' {Form_Inventory},
  unit_OutQuery in 'unit_OutQuery.pas' {Form_OutQuery},
  Unit_OutboundOrder in 'Unit_OutboundOrder.pas' {Form_OutboundOrder},
  Unit_InboundOrder in 'Unit_InboundOrder.pas' {Form_InboundOrder},
  unit_Brand in 'unit_Brand.pas' {Form_Brand},
  unit_InQuery in 'unit_InQuery.pas' {Form_InQuery},
  unit_Document in 'unit_Document.pas' {Form_Document};

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
    Form1.FDConnection1.SharedCliHandle  := dwBase.dwGetCliHandleByName(AParams,'dwERP');

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
