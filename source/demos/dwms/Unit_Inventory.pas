unit Unit_Inventory;

interface

uses
    //
    Unit_Show,

    //
    dwBase,
    dwAccess,
    dwSGUnit,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids,
    Data.DB, Data.Win.ADODB, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Inventory = class(TForm)
    ListView1: TListView;
    FDQuery1: TFDQuery;
    procedure FormShow(Sender: TObject);
  private
  public
  end;


implementation

uses
    Unit1;

const
    _Fields : array[0..7] of String = ('ID','名称','型号','供应商','仓库','单位','单价','数量');



{$R *.dfm}





procedure TForm_Inventory.FormShow(Sender: TObject);
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_Inventory';
    FDQuery1.Open;
end;

end.
