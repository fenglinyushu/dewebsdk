unit Unit_StockOutQuery;

interface

uses
    //
    dwAccess,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids,
    Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_StockOutQuery = class(TForm)
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    FDQuery1: TFDQuery;
    procedure Button_SearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer; var Value: string);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_StockOutQuery.Button_SearchClick(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_StockOut','ID,名称,型号,领料人,领料单位,领料时间,数量,单位,单价,出库人',
            dwaGetWhere(FDQuery1,'wms_StockOut',Edit_Search.Text),'ORDER BY id DESC',1,10,StringGrid1,TrackBar1);
end;

procedure TForm_StockOutQuery.FormCreate(Sender: TObject);
begin
    //ID,品名型号,供应商,仓库,单位,单价,数量
    with StringGrid1 do begin
        Cells[0,0]   := '{"caption":"ID","align":"center","sort":true}';
        //Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '名称[*center*]';
        Cells[2,0]   := '型号[*center*]';
        Cells[3,0]   := '领料人[*center*]';
        Cells[4,0]   := '领料单位[*center*]';
        Cells[5,0]   := '领料时间[*center*]';
        Cells[6,0]   := '数量[*right*]';
        Cells[7,0]   := '单位[*center*]';
        Cells[8,0]   := '单价[*right*]';
        Cells[9,0]   := '出库人[*center*]';
        //
        ColWidths[0]     := 80;
        ColWidths[1]     := 120;
        ColWidths[2]     := 100;
        ColWidths[3]     := 70;
        ColWidths[4]     := 80;
        ColWidths[5]     := 100;
        ColWidths[6]     := 50;
        ColWidths[7]     := 50;
        ColWidths[8]     := 50;
        ColWidths[9]     := 80;
    end;

end;

procedure TForm_StockOutQuery.FormResize(Sender: TObject);
begin
    with StringGrid1 do begin
        ColWidths[1]    := Max(100,(Width-530) div 2);
        ColWidths[2]    := ColWidths[1];
    end;

end;

procedure TForm_StockOutQuery.StringGrid1GetEditMask(Sender: TObject; ACol, ARow: Integer;
  var Value: string);
var
    I       : Integer;
    bFound  : Boolean;
    joFilter: Variant;
    gsOrder : string;
begin
    if Value='sort' then begin
        //::处理客户端的排序操作消息


        //根据Arow得到升序/降序
        if ARow = 0 then begin
            gsOrder := 'ORDER BY ID DESC';
        end else begin
            gsOrder := 'ORDER BY ID';
        end;

        //更新数据
        dwaGetDataToGrid(FDQuery1,'wms_StockOut','ID,名称,型号,单位,单价,数量,领料单位,领料人,领料时间,出库人',
            dwaGetWhere(FDQuery1,'wms_StockOut',Edit_Search.Text),
            gsOrder, TrackBar1.Position,10,StringGrid1,TrackBar1);
    end;

end;

procedure TForm_StockOutQuery.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_StockOut','ID,名称,型号,单位,单价,数量,领料单位,领料人,领料时间,出库人',
        dwaGetWhere(FDQuery1,'wms_StockOut',Edit_Search.Text),'ORDER BY id DESC', TrackBar1.Position,10,StringGrid1,TrackBar1);
end;

end.
