unit unit0;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb操作Access函数
    dwAccess,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_Item = class(TForm)
    GroupBox1: TGroupBox;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    ComboBox_Requisition: TComboBox;
    ComboBox_User: TComboBox;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    Edit_Memo: TEdit;
    Button7: TButton;
    SpinEdit_Num: TSpinEdit;
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search2: TButton;
    FDQuery1: TFDQuery;
    P_All: TPanel;
    Panel2: TPanel;
    Button1: TButton;
    Label1: TLabel;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button_Search2Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
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

procedure TForm_Item.Button7Click(Sender: TObject);
var
    iPID    : Integer;
    sTmp,sPName, sPModel, sPUnit:String;
    iPPrice,iPNum:Integer;
    sRequisition : string;
    sUser : string;
    iNum : Integer;

begin
    //<输入检查
    if ComboBox_Requisition.Text = '' then begin
        dwMessage('领料单位不能为空！','error',self);
        Exit;
    end;
    if ComboBox_User.Text = '' then begin
        dwMessage('领料人不能为空！','error',self);
        Exit;
    end;
    if SpinEdit_Num.Value <=0 then begin
        dwMessage('数量不能为零！','error',self);
        Exit;
    end;
    //>

    //<先得到当前产品的ID,名称,型号,单位,单价;供应商,仓库等信息
    if StringGrid1.Row =0 then begin
        StringGrid1.Row := 1;
    end;
    iPID    := StrToIntDef(StringGrid1.Cells[0,StringGrid1.Row],-1);


    //
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_Inventory WHERE ID = '+iPID.ToString;
    FDQuery1.Open;
    sPName  := FDQuery1.FieldByName('名称').AsString;
    sPModel := FDQuery1.FieldByName('型号').AsString;
    sPUnit  := FDQuery1.FieldByName('单位').AsString;
    iPPrice := FDQuery1.FieldByName('单价').AsInteger;
    iPNum   := FDQuery1.FieldByName('数量').AsInteger;
    //
    sRequisition    := ComboBox_Requisition.Text;
    sUser   := ComboBox_User.Text;
    iNum    := SpinEdit_Num.Value;
    //>

    //
    if SpinEdit_Num.Value > iPNum then begin
        dwMessage('出库数量不能大于库存数量！','error',self);
        Exit;
    end;

    //<写出库信息库,增加一条记录--------------------------------------------------------------------
    FDQuery1.Close;
    FDQuery1.SQL.Text  := Format('INSERT INTO wms_StockOut '
            +'(名称,型号,单位,单价,数量,金额,'
            +'领料单位,领料人,出库人,领料时间,备注) '
            +'VALUES(''%s'',''%s'',''%s'',%d,%d,%d,'
            +'''%s'',''%s'',''%s'',#%s#,''%s'')',
            [sPName,sPModel,sPUnit,iPPrice,iNum,iPPrice*iNum,
            sRequisition,sUser,'Admin',FormatDateTime('YYYY-MM-DD',Now),Edit_Memo.Text]);
    FDQuery1.ExecSQL;
    //>


    //<更新库存库数量 ------------------------------------------------------------------------------
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'UPDATE wms_Inventory SET 数量 = 数量 - '+iNum.ToString+' WHERE ID = '+iPID.ToString;
    FDQuery1.ExecSQL;
    //>

    //<删除库存库内数量为0的记录--------------------------------------------------------------------
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'DELETE FROM wms_Inventory WHERE 数量 <= 0';
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

procedure TForm_Item.Button_Search2Click(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Inventory','ID,名称,型号,供应商,仓库,单位,单价,数量',
            dwaGetWhere(FDQuery1,'wms_Inventory',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);

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
        dwaGetWhere(FDQuery1,'wms_Inventory',Edit_Search.Text),'ORDER BY id', TrackBar1.Position,10,StringGrid1,TrackBar1);
end;

procedure TForm_Item.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Inventory','ID,名称,型号,供应商,仓库,单位,单价,数量',
        dwaGetWhere(FDQuery1,'wms_Inventory',Edit_Search.Text),'ORDER BY id', TrackBar1.Position,10,StringGrid1,TrackBar1);

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
        //领料单位列表
        Close;
        SQL.Text  := 'SELECT * FROM wms_Requisition';
        Open;
        //
        ComboBox_Requisition.Clear;
        for I := 0 to FDQuery1.RecordCount -1 do begin
            ComboBox_Requisition.Items.Add(FieldByName('名称').AsString);
            //
            Next;
        end;
        //
        if ComboBox_Requisition.items.Count>0 then begin
            ComboBox_Requisition.ItemIndex  := 0;
        end;

        //领料人列表
        Close;
        SQL.Text  := 'SELECT * FROM wms_User WHERE 用户组=''领料人''';
        Open;
        //
        ComboBox_User.Clear;
        for I := 0 to FDQuery1.RecordCount -1 do begin
            ComboBox_User.Items.Add(FieldByName('用户名').AsString);
            //
            Next;
        end;
        //
        if ComboBox_User.items.Count>0 then begin
            ComboBox_User.ItemIndex  := 0;
        end;
    end;

end;

end.
