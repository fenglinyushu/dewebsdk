unit Unit_middle;

interface

uses
    //
    Syncommons,

    //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, FireDAC.Stan.StorageJSON;

type
  TForm_Middle = class(TForm)
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    function GetData(AStart,APageSize:Integer):String;
  end;

var
  Form_Middle: TForm_Middle;

implementation

{$R *.dfm}

{ TForm_Middle }

procedure TForm_Middle.FormCreate(Sender: TObject);
begin
    FDConnection1.ConnectionString  := 'Database=.\\main.mdb;DriverID=MSAcc';
    FDConnection1.Connected := True;
end;

function TForm_Middle.GetData(AStart, APageSize: Integer): String;
var
    joRes   : Variant;
    joRec   : Variant;
    ss      : TStringStream;
    iItem   : Integer;
    iField  : Integer;
begin
    //
    joRes   := _json('[]');

    //
    FDQuery1.Disconnect;
    FDQuery1.Close;
    FDQuery1.FetchOptions.RecsSkip  := AStart;
    FDQuery1.FetchOptions.RecsMax   := APageSize;
    FDQuery1.SQL.Text   := 'SELECT id,AName,HeadShip,Salary FROM dw_member';
    FDQuery1.Open;

    //
    for iItem := 1 to FDQuery1.RecordCount -1 do begin
        FDQuery1.RecNo  := iItem;
        joRec   := _json('[]');
        for iField := 0 to FDQuery1.Fields.Count -1 do begin
            joRec.Add(FDQuery1.Fields[iField].AsString);
        end;
        joRes.Add(joRec);
    end;

    //
    Result  := PChar(String(joRes));
end;

end.
