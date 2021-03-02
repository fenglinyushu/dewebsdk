unit dwDMLoader;

interface

uses
     //
     ZAbstractRODataset, ZAbstractDataset, ZDataset,ZConnection,

  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ZQuery    : TZReadOnlyQuery;
implementation

{$R *.dfm}

procedure TForm1.FormCreate(Sender: TObject);
type
     PdwGetConn   = function ():TZConnection;StdCall;
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
     ZQuery    := TZReadOnlyQuery.Create(self);
     //
     if FileExists('dwZConnection.dll') then begin
          iDll      := LoadLibrary('dwZConnection.dll');
          fGetConn  := GetProcAddress(iDll,'dwGetConnection');

          ZQuery.Connection   := fGetConn;
     end;
     ZQuery.SQL.Text     := 'SELECT * FROM Questions WHERE FQuestionTypeID=1';
     ZQuery.Open;

     //
     DataSource1.DataSet := ZQuery;
end;

end.
