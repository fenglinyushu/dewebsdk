unit Unit_StockInQuery;

interface

uses
    //
    dwBase,
    dwAccess,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids,
    Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_StockInQuery = class(TForm)
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    StringGrid2: TStringGrid;
    TrackBar1: TTrackBar;
    FDQuery1: TFDQuery;
    procedure Button_SearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_StockInQuery.Button_SearchClick(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_StockIn','ID,名称,型号,供应商,仓库,单位,单价,数量,入库时间',
            dwaGetWhere(FDQuery1,'wms_StockIn',Edit_Search.Text),'ORDER BY id DESC',1,10,StringGrid2,TrackBar1);
end;

procedure TForm_StockInQuery.FormCreate(Sender: TObject);
begin
    //ID,品名型号,供应商,仓库,单位,单价,数量
    with StringGrid2 do begin
        Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '名称[*center*]';
        Cells[2,0]   := '型号[*center*]';
        Cells[3,0]   := '供应商[*center*]';
        Cells[4,0]   := '仓库[*center*]';
        Cells[5,0]   := '单位[*center*]';
        Cells[6,0]   := '单价[*right*]';
        Cells[7,0]   := '数量[*right*]';
        Cells[8,0]   := '入库时间[*center*]';
        //
        ColWidths[0]     := 1;
        ColWidths[1]     := 100;
        ColWidths[2]     := 80;
        ColWidths[3]     := 80;
        ColWidths[4]     := 80;
        ColWidths[5]     := 50;
        ColWidths[6]     := 50;
        ColWidths[7]     := 50;
        ColWidths[7]     := 120;
    end;

end;

procedure TForm_StockInQuery.FormResize(Sender: TObject);
begin
    with StringGrid2 do begin
        ColWidths[1]    := Max(60,(Width-500) div 3);
        ColWidths[2]    := ColWidths[1];
        ColWidths[3]    := ColWidths[1];
    end;
end;

procedure TForm_StockInQuery.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_StockIn','ID,名称,型号,供应商,仓库,单位,单价,数量,入库时间',
        dwaGetWhere(FDQuery1,'wms_StockIn',Edit_Search.Text),'ORDER BY id DESC', TrackBar1.Position,10,StringGrid2,TrackBar1);
end;

end.
