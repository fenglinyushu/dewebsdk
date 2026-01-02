library dwFrame;

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
  unit1 in 'unit1.pas' {Form1},
  unit_sys_Role in 'unit_sys_Role.pas' {Form_sys_Role},
  unit_sys_User in 'unit_sys_User.pas' {Form_sys_User},
  unit_bop_ExamSyn in 'unit_bop_ExamSyn.pas' {Form_bop_ExamSyn},
  Unit_sys_Home in 'Unit_sys_Home.pas' {Form_sys_Home},
  unit_sys_QuickBtn in 'unit_sys_QuickBtn.pas' {Form_sys_QuickBtn},
  unit_bop_Select in 'unit_bop_Select.pas' {Form_bop_Select},
  unit_bop_Judge in 'unit_bop_Judge.pas' {Form_bop_Judge},
  unit_bop_JudgeSel in 'unit_bop_JudgeSel.pas' {Form_bop_JudgeSel},
  unit_bop_SelectSel in 'unit_bop_SelectSel.pas' {Form_bop_SelectSel},
  unit_bop_Ranking in 'unit_bop_Ranking.pas' {Form_bop_Ranking},
  unit_bop_ShortSel in 'unit_bop_ShortSel.pas' {Form_bop_ShortSel},
  unit_bop_Foot in 'unit_bop_Foot.pas' {Form_bop_Foot},
  unit_bop_Full in 'unit_bop_Full.pas' {Form_bop_Full},
  unit_bop_Score in 'unit_bop_Score.pas' {Form_bop_Score},
  unit_bop_WeekExam in 'unit_bop_WeekExam.pas' {Form_bop_WeekExam},
  unit_sys_Me in 'unit_sys_Me.pas' {Form_sys_Me},
  unit_sys_ChangePsd in 'unit_sys_ChangePsd.pas' {Form_sys_ChangePsd},
  unit_dem_DBHello in 'unit_dem_DBHello.pas' {Form_dem_DBHello},
  unit_bop_Short in 'unit_bop_Short.pas' {Form_bop_Short},
  unit_dem_Hello in 'unit_dem_Hello.pas' {Form_dem_Hello},
  unit_bop_head in 'unit_bop_head.pas' {Form_bop_Head};

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
