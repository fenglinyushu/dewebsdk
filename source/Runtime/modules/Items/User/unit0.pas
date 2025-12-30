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
    Label9: TLabel;
    ComboBox_UserGroup: TComboBox;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    Edit_User: TEdit;
    Button_Save: TButton;
    SpinEdit_Age: TSpinEdit;
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    Label2: TLabel;
    Label3: TLabel;
    Edit_Partment: TEdit;
    Label4: TLabel;
    Edit_Title: TEdit;
    Label5: TLabel;
    ComboBox_Sex: TComboBox;
    Label6: TLabel;
    Edit_Phone: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Button_Add: TButton;
    Button_Delete: TButton;
    Button_ResetPsd: TButton;
    Edit_Addr: TEdit;
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

procedure TForm_Item.Button_AddClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    dwMessageDlg('确定要将当前 '+Edit_User.Text+' 信息作为新用户信息添中到数据库中吗?','DWMS','OK','Cancel','query_add',self);

end;

procedure TForm_Item.Button_DeleteClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    dwMessageDlg('确定要将删除用户 '+StringGrid1.Cells[1,iRow]+' 吗?','DWMS','OK','Cancel','query_delete',self);
end;

procedure TForm_Item.Button_SaveClick(Sender: TObject);
var
    iRow    : Integer;
begin
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    dwMessageDlg('确定要将 '+Edit_User.Text+' 的信息保存到数据库中吗?','DWMS','OK','Cancel','query_save',self);
end;

procedure TForm_Item.Button_SearchClick(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_User','ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
            dwaGetWhere(FDQuery1,'wms_User',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);

end;

procedure TForm_Item.FormCreate(Sender: TObject);
begin
    //ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注
    //
    with StringGrid1 do begin
        Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '用户名[*center*]';
        Cells[2,0]   := '用户组[*center*]';
        Cells[3,0]   := '部门[*center*]';
        Cells[4,0]   := '职务[*center*]';
        Cells[5,0]   := '性别[*center*]';
        Cells[6,0]   := '年龄[*right*]';
        Cells[7,0]   := '地址[*left*]';
        Cells[8,0]   := '电话[*center*]';
        Cells[9,0]   := '备注[*left*]';
        //
        ColWidths[0]     := 40;
        ColWidths[1]     := 80;
        ColWidths[2]     := 80;
        ColWidths[3]     := 80;
        ColWidths[4]     := 120;
        ColWidths[5]     := 50;
        ColWidths[6]     := 50;
        ColWidths[7]     := 150;
        ColWidths[8]     := 120;
        ColWidths[9]     := 80;
    end;

end;

procedure TForm_Item.FormResize(Sender: TObject);
begin
    with StringGrid1 do begin
        ColWidths[7]    := Max(50,(Width-630) div 2);
        ColWidths[9]    := ColWidths[7];
    end;

end;

procedure TForm_Item.FormShow(Sender: TObject);
begin
	//
	FDQuery1.Connection	:= TForm1(self.owner).FDConnection1;

    dwaGetDataToGrid(FDQuery1,'wms_User','ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
            dwaGetWhere(FDQuery1,'wms_User',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);
end;

procedure TForm_Item.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
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
            iRow    := StringGrid1.Row;
            iRow    := Max(1,iRow);
            sID     := StringGrid1.Cells[0,iRow];

            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'SELECT * FROM wms_user WHERE ID = '+sID;
            FDQuery1.Open;
            //保存到数据表   用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
            with FDQuery1 do begin
                Edit;
                FieldByName('用户名').AsString  := Edit_User.Text;
                FieldByName('用户组').AsString  := ComboBox_UserGroup.Text;
                FieldByName('部门').AsString    := Edit_Partment.Text;
                FieldByName('职务').AsString    := Edit_Title.Text;
                FieldByName('性别').AsString    := dwIIF(ComboBox_Sex.Text='男','男','女');
                FieldByName('年龄').AsInteger   := SpinEdit_Age.Value;
                FieldByName('地址').AsString    := Edit_Addr.Text;
                FieldByName('电话').AsString    := Edit_Phone.Text;
                FieldByName('备注').AsString    := Edit_Memo.Text;
                Post;
            end;

            //更新显示
            with StringGrid1 do begin
                Cells[1,iRow]   := Edit_User.Text;
                Cells[2,iRow]   := ComboBox_UserGroup.Text;
                Cells[3,iRow]   := Edit_Partment.Text;
                Cells[4,iRow]   := Edit_Title.Text;
                Cells[5,iRow]   := dwIIF(ComboBox_Sex.Text='男','男','女');
                Cells[6,iRow]   := SpinEdit_Age.Value.ToString;
                Cells[7,iRow]   := Edit_Addr.Text;
                Cells[8,iRow]   := Edit_Phone.Text;
                Cells[9,iRow]   := Edit_Memo.Text;
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
            FDQuery1.SQL.Text  := 'INSERT INTO wms_user (用户名,用户组,部门,职务,性别,年龄,地址,电话,备注) '
                    +Format('VALUES(''%s'',''%s'',''%s'',''%s'',''%s'',%d,''%s'',''%s'',''%s'')',
                    [
                    Edit_User.Text,
                    ComboBox_UserGroup.Text,
                    Edit_Partment.Text,
                    Edit_Title.Text,
                    dwIIF(ComboBox_Sex.Text='男','男','女'),
                    SpinEdit_Age.Value,
                    Edit_Addr.Text,
                    Edit_Phone.Text,
                    Edit_Memo.Text
                    ]);
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_User','ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
                dwaGetWhere(FDQuery1,'wms_User',Edit_Search.Text),'ORDER BY id',999,10,StringGrid1,TrackBar1);
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
            FDQuery1.SQL.Text  := 'DELETE FROM wms_user WHERE ID='+sID;
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_User','ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
                dwaGetWhere(FDQuery1,'wms_User',Edit_Search.Text),'ORDER BY id',1,10,StringGrid1,TrackBar1);
            //
            dwMessage('删除成功!','success',self);
        end;
    end else begin

    end;



end;

procedure TForm_Item.StringGrid1Click(Sender: TObject);
var
    iRow    : Integer;
begin
    //行
    iRow := StringGrid1.Row;
    if iRow = 0 then begin
        iRow    := 1;
    end;

    //
    Edit_User.Text          := StringGrid1.Cells[1,iRow];
    ComboBox_UserGroup.Text := StringGrid1.Cells[2,iRow];
    Edit_Partment.Text      := StringGrid1.Cells[3,iRow];
    Edit_Title.Text         := StringGrid1.Cells[4,iRow];
    ComboBox_Sex.Text       := StringGrid1.Cells[5,iRow];
    SpinEdit_Age.Value      := StrToIntDef(StringGrid1.Cells[6,iRow],25);
    Edit_Addr.Text          := StringGrid1.Cells[7,iRow];
    Edit_Phone.Text         := StringGrid1.Cells[8,iRow];
    Edit_Memo.Text          := StringGrid1.Cells[9,iRow];

end;

procedure TForm_Item.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_User','ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
        dwaGetWhere(FDQuery1,'wms_User',Edit_Search.Text),'ORDER BY id', TrackBar1.Position,10,StringGrid1,TrackBar1);

end;

procedure TForm_Item.UpdateData(APage: Integer);
begin
    dwaGetDataToGrid(FDQuery1,'wms_User','ID,用户名,用户组,部门,职务,性别,年龄,地址,电话,备注',
            '','ORDER BY id DESC',APage,10,StringGrid1,TrackBar1);

end;

procedure TForm_Item.UpdateInfos;
var
    I       : Integer;
begin
    //
    with FDQuery1 do begin
        //用户组列表
        Close;
        SQL.Text  := 'SELECT * FROM wms_UserGroup';
        Open;
        //
        ComboBox_UserGroup.Clear;
        for I := 0 to FDQuery1.RecordCount -1 do begin
            ComboBox_UserGroup.Items.Add(FieldByName('名称').AsString);
            //
            Next;
        end;
        //
        if ComboBox_UserGroup.items.Count>0 then begin
            ComboBox_UserGroup.ItemIndex  := 0;
        end;

    end;

end;

end.
