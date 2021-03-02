library dwADOConnection;


uses
  Sharemem,
  System.SysUtils,
  System.Classes,
  DB,
  ADODB,
  IniFiles;

{$R *.res}
var
     dwConnection     : TADOConnection;


function dwGetConnection:TADOConnection;stdcall;
var
     fConfig   : Tinifile;
     sConnect  : String;
begin
     Result    := nil;
     if dwConnection <> nil then begin
          Result     := dwConnection;
     end else begin
          if FileExists('ado.ini') then begin
               fConfig   := TIniFile.Create(GetCurrentDir+'\ado.ini');
               sConnect  := fConfig.ReadString('ado','connection','');
               fConfig.Destroy;
          end;
          if (sConnect<>'') then begin
               try
                    dwConnection := TADOConnection.Create(nil);
                    dwConnection.ConnectionString := sConnect;
                    dwConnection.Connected        := True;
                    //
                    Result    := dwConnection;
               except
                    dwConnection.Connected   := False;
               end;
          end;
     end;
end;

exports
     dwGetConnection;

begin
end.
