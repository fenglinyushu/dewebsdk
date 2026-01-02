unit unit_dem_DBHello;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    CloneComponents,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
    Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TForm_dem_DBHello = class(TForm)
    LaTitle: TLabel;
    EtValue: TEdit;
    FDQuery1: TFDQuery;
    Panel4: TPanel;
    BtPrev: TButton;
    BtNext: TButton;
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BtPrevClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
  private
  public
		gsRights    : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_dem_DBHello.BtNextClick(Sender: TObject);
begin
    //get the next value
    FDQuery1.Next;
    EtValue.Text        := FDQuery1.FieldByName('uname').AsString;
end;

procedure TForm_dem_DBHello.BtPrevClick(Sender: TObject);
begin
    //get the prior value
    FDQuery1.Prior;
    EtValue.Text        := FDQuery1.FieldByName('uname').AsString;
end;

procedure TForm_dem_DBHello.FormShow(Sender: TObject);
begin
    //set FDConnection
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;

    //get table field value
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM sys_user';
    FDQuery1.Open;
    EtValue.Text        := FDQuery1.FieldByName('uname').AsString;

end;

end.
