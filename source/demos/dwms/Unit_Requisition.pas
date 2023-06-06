unit Unit_Requisition;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb操作Access函数
    dwAccess,
    //
    dwSGUnit,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_Requisition = class(TForm)
    GroupBox1: TGroupBox;
    Label9: TLabel;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    Edit_Name: TEdit;
    Button_Save: TButton;
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    Button_Add: TButton;
    Button_Delete: TButton;
    Edit_Memo: TEdit;
    Label1: TLabel;
    FDQuery1: TFDQuery;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Button_SearchClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button_AddClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
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

procedure TForm_Requisition.Button_AddClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    if Trim(Edit_Name.Text) = '' then begin
        //
        dwMessage('名称不能为空!','error',self);
    end else begin
        dwMessageDlg('确定要将当前 '+Edit_Name.Text+' 信息作为新信息添中到数据库中吗?','DWMS','OK','Cancel','query_add',self);
    end;
end;

procedure TForm_Requisition.Button_DeleteClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    if StringGrid1.Cells[0,iRow]='' then begin
        //
        dwMessage('空行不需要删除!','error',self);
    end else begin
        dwMessageDlg('确定要将删除 '+StringGrid1.Cells[1,iRow]+' 吗?','DWMS','OK','Cancel','query_delete',self);
    end;
end;

procedure TForm_Requisition.Button_SaveClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    if Trim(Edit_Name.Text) = '' then begin
        //
        dwMessage('名称不能为空!','error',self);
    end else begin
        dwMessageDlg('确定要将 '+Edit_Name.Text+' 的信息保存到数据库中吗?','DWMS','OK','Cancel','query_save',self);
    end;
end;

procedure TForm_Requisition.Button_SearchClick(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Supplier','ID,名称,备注',
            dwaGetWhere(FDQuery1,'wms_Supplier',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);

end;

procedure TForm_Requisition.FormCreate(Sender: TObject);
begin
    //ID,名称,联系人,联系电话,地址,邮编,邮箱,总体介绍,备注
    //
    with StringGrid1 do begin
        Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '名称[*center*]';
        Cells[2,0]   := '备注[*left*]';
        //
        ColWidths[0]     := 40;
        ColWidths[1]     := 200;
        ColWidths[2]     := 200;
    end;

end;

procedure TForm_Requisition.FormResize(Sender: TObject);
var
    iCol    : Integer;
    sWidth  : Integer;
begin
    //设备最后一列的列宽为完全
    sWidth := 0;
    with StringGrid1 do begin
        for iCol := 0 to ColCount-2 do begin
            sWidth  := sWidth + ColWidths[iCol];
        end;
        ColWidths[ColCount-1]    := Max(50,Width-sWidth);
    end;

end;

procedure TForm_Requisition.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    iRow    : Integer;
    iCol    : Integer;
    sID     : String;
    sMethod : string;
    sValue  : string;
begin
    //
    sMethod := dwGetProp(Self,'interactionmethod');
    sValue  := dwGetProp(Self,'interactionvalue');

    //
    if sMethod = 'query_save' then begin
        //保存编辑记录
        if sValue = '1' then begin
            iRow := StringGrid1.Row;
            iRow    := Max(1,iRow);
            sID := StringGrid1.Cells[0,iRow];

            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'SELECT * FROM wms_Supplier WHERE ID = '+sID;
            FDQuery1.Open;
            //保存到数据表
            with FDQuery1 do begin
                Edit;
                FieldByName('名称').AsString        := Edit_Name.Text;
                FieldByName('备注').AsString        := Edit_Memo.Text;
                Post;
            end;

            //更新显示
            with StringGrid1 do begin
                Cells[1,iRow]   := Edit_Name.Text;
                Cells[2,iRow]   := Edit_Memo.Text;
            end;
            //
            dwMessage('保存成功!','success',self);
        end;
    end else if sMethod = 'query_add' then begin
        //添加记录
        if sValue = '1' then begin

            iRow := StringGrid1.Row;
            iRow    := Max(1,iRow);
            sID := StringGrid1.Cells[0,iRow];

            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'INSERT INTO wms_Supplier (名称,备注) '
                    +Format('VALUES(''%s'',''%s'')',
                    [
                    Edit_Name.Text,
                    Edit_Memo.Text
                    ]);
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_Supplier','ID,名称,备注',
                dwaGetWhere(FDQuery1,'wms_Supplier',Edit_Search.Text),'ORDER BY id',999,10,StringGrid1,TrackBar1);
            //
            dwMessage('添加成功!','success',self);
        end;
    end else if sMethod = 'query_delete' then begin
        //删除记录
        if sValue = '1' then begin
            iRow := StringGrid1.Row;
            iRow    := Max(1,iRow);
            sID := StringGrid1.Cells[0,iRow];

            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'DELETE FROM wms_Supplier WHERE ID='+sID;
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_Supplier','ID,名称,备注',
                dwaGetWhere(FDQuery1,'wms_Supplier',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);
            //
            dwMessage('删除成功!','success',self);
        end;
    end else begin

    end;



end;

procedure TForm_Requisition.StringGrid1Click(Sender: TObject);
var
    iRow    : Integer;
begin
    //行
    iRow := StringGrid1.Row;
    if iRow = 0 then begin
        iRow    := 1;
    end;

    //
    Edit_Name.Text      := StringGrid1.Cells[1,iRow];
    Edit_Memo.Text      := StringGrid1.Cells[8,iRow];

end;

procedure TForm_Requisition.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Supplier','ID,名称,备注',
        dwaGetWhere(FDQuery1,'wms_Supplier',Edit_Search.Text),'ORDER BY id', TrackBar1.Position,10,StringGrid1,TrackBar1);

end;

procedure TForm_Requisition.UpdateData(APage: Integer);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Supplier','ID,名称,备注',
            '','ORDER BY id DESC',APage,10,StringGrid1,TrackBar1);

end;

procedure TForm_Requisition.UpdateInfos;
begin
    //
end;

end.
