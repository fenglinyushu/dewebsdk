unit unit_Product;

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
  TForm_Product = class(TForm)
    GroupBox1: TGroupBox;
    Label9: TLabel;
    ComboBox_Group: TComboBox;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    Edit_Name: TEdit;
    Button_Save: TButton;
    SpinEdit_1: TSpinEdit;
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    Label2: TLabel;
    Label4: TLabel;
    Edit_1: TEdit;
    Label6: TLabel;
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

procedure TForm_Product.Button_AddClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    dwMessageDlg('确定要将当前 '+Edit_Name.Text+' 信息作为新信息添中到数据库中吗?','DWMS','OK','Cancel','query_add',self);

end;

procedure TForm_Product.Button_DeleteClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    dwMessageDlg('确定要将删除 '+StringGrid1.Cells[1,iRow]+' 吗?','DWMS','OK','Cancel','query_delete',self);
end;

procedure TForm_Product.Button_SaveClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    dwMessageDlg('确定要将 '+Edit_Name.Text+' 的信息保存到数据库中吗?','DWMS','OK','Cancel','query_save',self);
end;

procedure TForm_Product.Button_SearchClick(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Product','ID,名称,型号,单位,单价,备注',
            dwaGetWhere(FDQuery1,'wms_Product',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);

end;

procedure TForm_Product.FormCreate(Sender: TObject);
begin
    //ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注
    //
    with StringGrid1 do begin
        Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '名称[*center*]';
        Cells[2,0]   := '型号[*center*]';
        Cells[3,0]   := '单位[*center*]';
        Cells[4,0]   := '单价[*right*]';
        Cells[5,0]   := '备注[*left*]';
        //
        ColWidths[0]     := 40;
        ColWidths[1]     := 120;
        ColWidths[2]     := 120;
        ColWidths[3]     := 80;
        ColWidths[4]     := 80;
        ColWidths[5]     := 200;
    end;

end;

procedure TForm_Product.FormResize(Sender: TObject);
var
    sWidth : Integer;
    iCol    : Integer;
begin
    sWidth := 0;
    with StringGrid1 do begin
        for iCol := 0 to ColCount-2 do begin
            sWidth  := sWidth + ColWidths[iCol];
        end;
        ColWidths[ColCount-1]    := Max(50,Width-sWidth);
        //ColWidths[9]    := ColWidths[7];
    end;

end;

procedure TForm_Product.FormShow(Sender: TObject);
begin
	//
	FDQuery1.Connection	:= TForm1(self.owner).FDConnection1;

    dwaGetDataToGrid(FDQuery1,'wms_Product','ID,名称,型号,单位,单价,备注',
            dwaGetWhere(FDQuery1,'wms_Product',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);
end;

procedure TForm_Product.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string;
    iRow    : Integer;
    sID     : String;

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
            FDQuery1.SQL.Text  := 'SELECT * FROM wms_Product WHERE ID = '+sID;
            FDQuery1.Open;
            //保存到数据表   用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
            with FDQuery1 do begin
                Edit;
                FieldByName('名称').AsString    := Edit_Name.Text;
                FieldByName('型号').AsString    := Edit_1.Text;
                FieldByName('单位').AsString    := ComboBox_Group.Text;
                FieldByName('单价').AsInteger   := SpinEdit_1.Value;
                FieldByName('备注').AsString    := Edit_Memo.Text;
                Post;
            end;

            //更新显示
            with StringGrid1 do begin
                Cells[1,iRow]   := Edit_Name.Text;
                Cells[2,iRow]   := Edit_1.Text;
                Cells[3,iRow]   := ComboBox_Group.Text;
                Cells[4,iRow]   := SpinEdit_1.Value.ToString;
                Cells[5,iRow]   := Edit_Memo.Text;
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
            FDQuery1.SQL.Text  := 'INSERT INTO wms_Product (名称,型号,单位,单价,备注) '
                    +Format('VALUES(''%s'',''%s'',''%s'',%d,''%s'')',
                    [
                    Edit_Name.Text,
                    Edit_1.Text,
                    ComboBox_Group.Text,
                    SpinEdit_1.Value,
                    Edit_Memo.Text
                    ]);
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_Product','ID,名称,型号,单位,单价,备注',
                dwaGetWhere(FDQuery1,'wms_Product',Edit_Search.Text),'ORDER BY id',999,10,StringGrid1,TrackBar1);
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
            FDQuery1.SQL.Text  := 'DELETE FROM wms_Product WHERE ID='+sID;
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_Product','ID,名称,型号,单位,单价,备注',
                dwaGetWhere(FDQuery1,'wms_Product',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);
            //
            dwMessage('删除成功!','success',self);
        end;
    end else begin

    end;



end;

procedure TForm_Product.StringGrid1Click(Sender: TObject);
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
    Edit_1.Text         := StringGrid1.Cells[2,iRow];
    ComboBox_Group.Text := StringGrid1.Cells[3,iRow];
    SpinEdit_1.Value    := StrToIntDef(StringGrid1.Cells[4,iRow],0);
    Edit_Memo.Text      := StringGrid1.Cells[5,iRow];

end;

procedure TForm_Product.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Product','ID,名称,型号,单位,单价,备注',
        dwaGetWhere(FDQuery1,'wms_Product',Edit_Search.Text),'ORDER BY id', TrackBar1.Position,10,StringGrid1,TrackBar1);

end;

procedure TForm_Product.UpdateData(APage: Integer);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Product','ID,名称,型号,单位,单价,备注',
            '','ORDER BY id DESC',APage,10,StringGrid1,TrackBar1);

end;

procedure TForm_Product.UpdateInfos;
begin
    //
    dwSGSetRow(StringGrid1,0,clBtnFace,RGB(50,50,50));
end;

end.
