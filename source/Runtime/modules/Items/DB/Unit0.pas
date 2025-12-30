unit unit0;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Item = class(TForm)
    FDQuery1: TFDQuery;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    Label1: TLabel;
    Edit1: TEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button1: TButton;
    Button2: TButton;
    procedure FormShow(Sender: TObject);
    procedure FDQuery1AfterScroll(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;




{$R *.dfm}





procedure TForm_Item.Button1Click(Sender: TObject);
begin
    FDQuery1.Prior;
end;

procedure TForm_Item.Button2Click(Sender: TObject);
begin
    FDQuery1.Next;
end;

procedure TForm_Item.FDQuery1AfterScroll(DataSet: TDataSet);
begin
    Edit1.Text  := FDQuery1.FieldByName('AName').AsString;
    Edit2.Text  := FDQuery1.FieldByName('Addr').AsString;
end;

procedure TForm_Item.FormShow(Sender: TObject);
begin
    //
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM dw_Member';
    FDQuery1.Open;
end;

end.
