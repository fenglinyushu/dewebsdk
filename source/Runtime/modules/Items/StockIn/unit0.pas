unit unit0;
//产品入库

interface

uses
    //
    dwBase,
    dwAccess,
    //
    Math,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
  Vcl.Samples.Spin, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_Item = class(TForm)
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    GroupBox1: TGroupBox;
    Label2: TLabel;
    Label3: TLabel;
    Label6: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Button1: TButton;
    ComboBox_Product: TComboBox;
    ComboBox_Supplier: TComboBox;
    ComboBox_WareHouse: TComboBox;
    Edit_Memo: TEdit;
    SpinEdit_Num: TSpinEdit;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    FDQuery1: TFDQuery;
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
        procedure UpdateData(APage:Integer);
        procedure UpdateInfos;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

{ TForm3 }

procedure TForm_Item.Button1Click(Sender: TObject);
var
    iPID    : Integer;
    sTmp,sPName, sPModel, sPUnit:String;
    iPPrice : Integer;
    sSupplier : string;
    sWarehouse : string;
    iNum : Integer;
begin
    //<输入检查
    if ComboBox_Product.Text = '' then begin
        dwMessage('产品不能为空！','error',self);
        Exit;
    end;
    if ComboBox_Supplier.Text = '' then begin
        dwMessage('供应商不能为空！','error',self);
        Exit;
    end;
    if ComboBox_Warehouse.Text = '' then begin
        dwMessage('仓库不能为空！','error',self);
        Exit;
    end;
    if SpinEdit_Num.Value <=0 then begin
        dwMessage('数量不能为零！','error',self);
        Exit;
    end;
    //>

    //<先得到产品的ID,名称,型号,单位,单价;供应商,仓库等信息

    sPName  := ComboBox_Product.Text;
    sPModel := sPName;
    Delete(SPModel,1,Pos(' | ',sPModel)+2);
    sPName  := Copy(sPName,1,Pos(' | ',sPName)-1);
    //
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_Product WHERE 名称 = '''+sPName+''' AND 型号='''+sPModel+'''';
    FDQuery1.Open;
    sPModel := FDQuery1.FieldByName('型号').AsString;
    sPUnit  := FDQuery1.FieldByName('单位').AsString;
    iPPrice := FDQuery1.FieldByName('单价').AsInteger;
    //
    sSupplier   := ComboBox_Supplier.Text;
    sWarehouse  := ComboBox_Warehouse.Text;
    iNum        := SpinEdit_Num.Value;
    //>


    //<写库存库,增加一条记录------------------------------------------------------------------------
    FDQuery1.Close;
    FDQuery1.SQL.Text  := Format('INSERT INTO wms_Inventory '
            +'(名称,型号,供应商,仓库,单位,单价,数量,金额,备注) '
            +'VALUES(''%s'',''%s'',''%s'',''%s'',''%s'',%d,%d,%d,''%s'')',
            [sPName,sPModel,sSupplier,sWarehouse,sPUnit,iPPrice,iNum,iPPrice*iNum,Edit_Memo.Text]);
    FDQuery1.ExecSQL;
    //>

    //<写入库信息库,增加一条记录--------------------------------------------------------------------
    FDQuery1.Close;
    FDQuery1.SQL.Text  := Format('INSERT INTO wms_StockIn '
            +'(名称,型号,供应商,仓库,单位,单价,数量,金额,'
            +'入库员,入库时间,备注) '
            +'VALUES(''%s'',''%s'',''%s'',''%s'',''%s'',%d,%d,%d,'
            +'''%s'',#%s#,''%s'')',
            [sPName,sPModel,sSupplier,sWarehouse,sPUnit,iPPrice,iNum,iPPrice*iNum,
            'Admin',FormatDateTime('YYYY-MM-DD',Now),Edit_Memo.Text]);
    FDQuery1.ExecSQL;
    //>

    //更新当前数量,发防止多次入库
    SpinEdit_Num.Value  := 0;

    //刷新当前显示
    dwaGetDataToGrid(FDQuery1,'wms_Inventory','ID,名称,型号,供应商,仓库,单位,单价,数量',
        dwaGetWhere(FDQuery1,'wms_Inventory',''),'ORDER BY id DESC', 1,10,StringGrid1,TrackBar1);

    //
    dwMessage('入库成功!','success',self);
end;

procedure TForm_Item.Button5Click(Sender: TObject);
begin
    //
    UpdateInfos;
end;

procedure TForm_Item.FormCreate(Sender: TObject);
begin
    //ID,品名型号,供应商,仓库,单位,单价,数量
    //
    with StringGrid1 do begin
        Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '名称[*center*]';
        Cells[2,0]   := '型号[*center*]';
        Cells[3,0]   := '供应商[*center*]';
        Cells[4,0]   := '仓库[*center*]';
        Cells[5,0]   := '单位[*center*]';
        Cells[6,0]   := '单价[*right*]';
        Cells[7,0]   := '数量[*right*]';
        //
        ColWidths[0]     := 60;
        ColWidths[1]     := 130;
        ColWidths[2]     := 130;
        ColWidths[3]     := 130;
        ColWidths[4]     := 100;
        ColWidths[5]     := 60;
        ColWidths[6]     := 80;
        ColWidths[7]     := 80;
    end;

end;

procedure TForm_Item.FormResize(Sender: TObject);
begin
    with StringGrid1 do begin
        ColWidths[1]    := Max(100,(Width-380) div 3);
        ColWidths[2]    := ColWidths[1];
        ColWidths[3]    := ColWidths[1];
    end;

end;

procedure TForm_Item.FormShow(Sender: TObject);
begin
	//
	FDQuery1.Connection	:= TForm1(self.owner).FDConnection1;
    UpdateInfos;
    dwaGetDataToGrid(FDQuery1,'wms_Inventory','ID,名称,型号,供应商,仓库,单位,单价,数量',
        dwaGetWhere(FDQuery1,'wms_Inventory',''),'ORDER BY id DESC', TrackBar1.Position,10,StringGrid1,TrackBar1);
end;

procedure TForm_Item.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Inventory','ID,名称,型号,供应商,仓库,单位,单价,数量',
        dwaGetWhere(FDQuery1,'wms_Inventory',''),'ORDER BY id DESC', TrackBar1.Position,10,StringGrid1,TrackBar1);

end;

procedure TForm_Item.UpdateData(APage: Integer);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Inventory','ID,名称,型号,供应商,仓库,单位,单价,数量',
            '','ORDER BY id DESC',APage,10,StringGrid1,TrackBar1);
end;

procedure TForm_Item.UpdateInfos;
var
    I       : Integer;
begin
    //
    with FDQuery1 do begin
        //产品列表
        Close;
        SQL.Text  := 'SELECT * FROM wms_Product';
        Open;
        //
        ComboBox_Product.Clear;
        for I := 0 to FDQuery1.RecordCount -1 do begin
            ComboBox_Product.Items.Add(FieldByName('名称').AsString+' | '+FieldByName('型号').AsString);
            //
            Next;
        end;
        //
        if ComboBox_Product.items.Count>0 then begin
            ComboBox_Product.ItemIndex  := 0;
        end;

        //供应商列表
        Close;
        SQL.Text  := 'SELECT * FROM wms_Supplier';
        Open;
        //
        ComboBox_Supplier.Clear;
        for I := 0 to FDQuery1.RecordCount -1 do begin
            ComboBox_Supplier.Items.Add(FieldByName('名称').AsString);
            //
            Next;
        end;
        //
        if ComboBox_Supplier.items.Count>0 then begin
            ComboBox_Supplier.ItemIndex  := 0;
        end;

        //仓库列表
        Close;
        SQL.Text  := 'SELECT * FROM wms_Warehouse';
        Open;
        //
        ComboBox_Warehouse.Clear;
        for I := 0 to FDQuery1.RecordCount -1 do begin
            ComboBox_Warehouse.Items.Add(FieldByName('名称').AsString);
            //
            Next;
        end;
        //
        if ComboBox_Warehouse.items.Count>0 then begin
            ComboBox_Warehouse.ItemIndex  := 0;
        end;
    end;
end;

end.
