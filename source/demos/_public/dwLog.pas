unit dwLog;

interface

uses
  SysUtils, Forms;

Type
  TLog = Class
  private
    procedure WriteToFile(const Msg: string);
  public
    Constructor Create;
    Destructor Destroy; override;
    procedure WriteLog(const Str: String);
    procedure WriteLogFmt(const Str: String; const Args: array of const );
    function GetLogFileName: String;
  End;

var
  flog: TLog=nil;

function log: TLog;

implementation

{ TLog }



function log: TLog;
begin
  if not Assigned(flog) then
    flog := TLog.Create;
  result:=flog;
end;

function TLog.GetLogFileName: String;
var
  Logpath: String;
begin
  Logpath :=ExtractFileDir(ParamStr(0))+ '\Logs\';
  if not DirectoryExists(Logpath) then
    ForceDirectories(Logpath);
  Result := Logpath + FormatDateTime('YYYY-MM-DD', Now) + '.log';
end;

constructor TLog.Create;
begin

end;

destructor TLog.Destroy;
begin

  inherited;
end;

procedure TLog.WriteLog(const Str: String);
begin
  WriteToFile(Str);
end;

procedure TLog.WriteLogFmt(const Str: String; const Args: array of const );
begin
  WriteToFile(Format(Str, Args));
end;

procedure TLog.WriteToFile(const Msg: string);
var
  FileName: String;
  FileHandle: TextFile;
begin
  FileName := GetLogFileName;
  Assignfile(FileHandle, FileName);
  try
    if FileExists(FileName) then
      Append(FileHandle)
    else
      ReWrite(FileHandle);
    WriteLn(FileHandle, FormatDateTime('[HH:MM:SS ZZZ]', Now) + '  ' + Msg);
  finally
    CloseFile(FileHandle);
  end;
end;

end.