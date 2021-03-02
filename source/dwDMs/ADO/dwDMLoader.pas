unit dwDMLoader;

interface

uses
     //
     ADODB,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    ADOTable1: TADOTable;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
type
     PdwGetConn   = function ():TADOConnection;StdCall;
var
     iIDs      : array[0..19] of 0..255;
     iRec      : Integer;
     I,J,K     : Integer;
     //
     iItem     : Integer;
     iA,iB     : Integer;
     iC,iD     : Integer;
     iRandom   : Integer;
     iDll      : Integer;

     //
     sContent  : String;
     sTitle    : string;
     sRight    : string;
     //
     fGetConn  : PdwGetConn;
begin
     //
     if FileExists('dwADOConnection.dll') then begin
          iDll      := LoadLibrary('dwADOConnection.dll');
          fGetConn  := GetProcAddress(iDll,'dwGetConnection');

          ADOTable1.Connection   := fGetConn;
     end;
     ADOTable1.TableName         := 'Member';
     ADOTable1.Open;

end;

end.
