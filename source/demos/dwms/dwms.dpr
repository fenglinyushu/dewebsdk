library dwms;

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
  dwAccess in '..\_public\dwAccess.pas',
  Unit_Inventory in 'Unit_Inventory.pas' {Form_Inventory},
  unit1 in 'unit1.pas' {Form1},
  Unit_UserRole in 'Unit_UserRole.pas' {Form_UserRole},
  Unit_StockOutQuery in 'Unit_StockOutQuery.pas' {Form_StockOutQuery},
  Unit_StockIn in 'Unit_StockIn.pas' {Form_StockIn},
  Unit_StockInQuery in 'Unit_StockInQuery.pas' {Form_StockInQuery},
  Unit_StockOut in 'Unit_StockOut.pas' {Form_StockOut},
  Unit_Document in 'Unit_Document.pas' {Form_Document},
  Unit_Card in 'Unit_Card.pas' {Form_Card},
  Unit_Product in 'Unit_Product.pas' {Form_Product},
  Unit_Warehouse in 'Unit_Warehouse.pas' {Form_Warehouse},
  Unit_Stat in 'Unit_Stat.pas' {Form_Stat},
  Unit_Supplier in 'Unit_Supplier.pas' {Form_Supplier},
  Unit_Requisition in 'Unit_Requisition.pas' {Form_Requisition},
  Unit_User in 'Unit_User.pas' {Form_User},
  Unit_Show in 'Unit_Show.pas' {Form_Show};

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

    //创建主窗体
    Form1   := TForm1.Create(nil);
    //设置数据库连接
    Form1.FDConnection1.SharedCliHandle  := AConnection;

    //创建必要的目录
    if not DirectoryExists(ExtractFilePath(Application.ExeName)+'media\doc') then begin
        ChDir(ExtractFilePath(Application.ExeName)+'media\');
        MkDir('doc');
    end;
    if not DirectoryExists(ExtractFilePath(Application.ExeName)+'media\doc\dwms') then begin
        ChDir(ExtractFilePath(Application.ExeName)+'media\doc\');
        MkDir('dwms');
    end;
    ChDir(ExtractFilePath(Application.ExeName));
    SetCurrentDir(ExtractFilePath(Application.ExeName));


{
    //----------库存查询----------------------------------------------------------------------------

    //创建FORM
    Form1.Form_Inventory   := TForm_Inventory.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Inventory.Parent  := Form1.TabSheet_Inventory;
    //设置嵌入标识,必须
    Form1.Form_Inventory.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Inventory.ADOQuery1.Connection   := AConnection;

    //----------产品入库----------------------------------------------------------------------------
    //创建FORM
    Form1.Form_StockIn   := TForm_StockIn.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_StockIn.Parent  := Form1.TabSheet_StockIn;
    //设置嵌入标识,必须
    Form1.Form_StockIn.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_StockIn.ADOQuery1.Connection   := AConnection;

    //----------产品出库----------------------------------------------------------------------------
    //创建FORM
    Form1.Form_StockOut   := TForm_StockOut.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_StockOut.Parent  := Form1.TabSheet_StockOut;
    //设置嵌入标识,必须
    Form1.Form_StockOut.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_StockOut.ADOQuery1.Connection   := AConnection;

    //----------入库查询----------------------------------------------------------------------------
    //创建FORM
    Form1.Form_StockInQuery   := TForm_StockInQuery.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_StockInQuery.Parent  := Form1.TabSheet_StockInQuery;
    //设置嵌入标识,必须
    Form1.Form_StockInQuery.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_StockInQuery.ADOQuery1.Connection   := AConnection;

    //----------出库查询----------------------------------------------------------------------------
    //创建FORM
    Form1.Form_StockOutQuery   := TForm_StockOutQuery.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_StockOutQuery.Parent  := Form1.TabSheet_StockOutQuery;
    //设置嵌入标识,必须
    Form1.Form_StockOutQuery.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_StockOutQuery.ADOQuery1.Connection   := AConnection;

    //----------用户管理----------------------------------------------------------------------------
    //创建FORM
    Form1.Form_User   := TForm_User.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_User.Parent  := Form1.TabSheet_User;
    //设置嵌入标识,必须
    Form1.Form_User.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_User.ADOQuery1.Connection   := AConnection;

    //----------角色权限----------------------------------------------------------------------------
    //创建FORM
    Form1.Form_UserRole   := TForm_UserRole.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_UserRole.Parent  := Form1.TabSheet_UserRole;
    //设置嵌入标识,必须
    Form1.Form_UserRole.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_UserRole.ADOQuery1.Connection   := AConnection;

    //----------产品信息管理------------------------------------------------------------------------
    //创建FORM
    Form1.Form_Product   := TForm_Product.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Product.Parent  := Form1.TabSheet_Product;
    //设置嵌入标识,必须
    Form1.Form_Product.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Product.ADOQuery1.Connection   := AConnection;

    //----------仓库信息管理------------------------------------------------------------------------
    //创建FORM
    Form1.Form_Warehouse   := TForm_Warehouse.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Warehouse.Parent  := Form1.TabSheet_Warehouse;
    //设置嵌入标识,必须
    Form1.Form_Warehouse.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Warehouse.ADOQuery1.Connection   := AConnection;

    //----------供应商信息管理----------------------------------------------------------------------
    //创建FORM
    Form1.Form_Supplier   := TForm_Supplier.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Supplier.Parent  := Form1.TabSheet_Supplier;
    //设置嵌入标识,必须
    Form1.Form_Supplier.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Supplier.ADOQuery1.Connection   := AConnection;

    //----------领料单位信息管理--------------------------------------------------------------------
    //创建FORM
    Form1.Form_Requisition   := TForm_Requisition.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Requisition.Parent  := Form1.TabSheet_Requisition;
    //设置嵌入标识,必须
    Form1.Form_Requisition.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Requisition.ADOQuery1.Connection   := AConnection;

    //----------分类统计信息管理--------------------------------------------------------------------
    //创建FORM
    Form1.Form_Stat   := TForm_Stat.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Stat.Parent  := Form1.TabSheet_Stat;
    //设置嵌入标识,必须
    Form1.Form_Stat.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Stat.ADOQuery1.Connection   := AConnection;

    //----------资料管理系统-----------------------------------------------------------------------
    //创建FORM
    Form1.Form_Document   := TForm_Document.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Document.Parent  := Form1.TabSheet_Document;
    //设置嵌入标识,必须
    Form1.Form_Document.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Document.ADOQuery1.Connection   := AConnection;

    //----------名称夹系统--------------------------------------------------------------------------
    //创建FORM
    Form1.Form_Card   := TForm_Card.Create(Form1);
    //嵌入到TabSheet中
    Form1.Form_Card.Parent  := Form1.TabSheet_Card;
    //设置嵌入标识,必须
    Form1.Form_Card.HelpKeyword := 'embed';
    //设置数据库连接
    Form1.Form_Card.ADOQuery1.Connection   := AConnection;
}

    //弹出式窗体
    Form1.Form_Show   := TForm_Show.Create(Form1);
    Form1.Form_Show.Parent   := Form1; //必须将新窗体的Parent设置为Form1
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
