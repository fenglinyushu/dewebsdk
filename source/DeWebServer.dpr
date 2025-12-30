program DeWebServer;


uses
  ShareMem,
  Forms,
  ActiveX,
  dwVars in 'dwVars.pas',
  main in 'main.pas' {MainForm},
  Vcl.Themes,
  Vcl.Styles,
  dwProcessData in 'dwProcessData.pas',
  dwUtils in 'dwUtils.pas',
  dwDM in 'dwDM.pas' {DM: TDataModule},
  Account in 'Account.pas' {Form_Account};

{$R *.RES}

begin
    ReportMemoryLeaksOnShutdown := DebugHook<>0;

    CoInitialize(nil);
    Application.Title := 'Deweb Server';
    Application.CreateForm(TDM, DM);
    Application.CreateForm(TMainForm, MainForm);
    Application.CreateForm(TForm_Account, Form_Account);
    Application.Run;
    CoUninitialize;
end.
