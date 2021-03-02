library dwZConnection;


uses
  Sharemem,
  System.SysUtils,
  System.Classes,
  DB,
  ADODB,
  IniFiles,
  ZConnection;

{$R *.res}
var
     dwConnection     : TZConnection;


function dwGetConnection:TZConnection;stdcall;
begin
     if dwConnection = nil then begin
          dwConnection   := TZConnection.create(nil);
          //
          with dwConnection do begin
               DataBase       := 'deweb.db';
               port           := 3306;
               Protocol       := 'sqlite-3';
               Connect;
          end;
     end;
     Result    := dwConnection;
end;

exports
     dwGetConnection;

begin
end.
