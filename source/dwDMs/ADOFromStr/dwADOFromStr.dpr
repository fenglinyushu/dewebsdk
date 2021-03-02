library dwADOFromStr;


uses
  Sharemem,
  System.SysUtils,
  System.Classes,
  DB,
  ADODB;

{$R *.res}
var
     dwConnection     : TADOConnection;


function dwGetConnection(AConnect:String):TADOConnection;stdcall;
var
     sConnect  : String;
begin
     Result    := nil;
     if dwConnection <> nil then begin
          Result     := dwConnection;
     end else begin
          if (AConnect<>'') then begin
               try
                    dwConnection := TADOConnection.Create(nil);
                    dwConnection.ConnectionString := AConnect;
                    dwConnection.Connected        := True;
                    //
                    Result    := dwConnection;
               except
                    Result    := nil;
               end;
          end;
     end;
end;

exports
     dwGetConnection;

begin
end.
