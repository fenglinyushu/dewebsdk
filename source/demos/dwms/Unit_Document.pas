unit Unit_Document;

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
    ComObj,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_Document = class(TForm)
    Label9: TLabel;
    StringGrid1: TStringGrid;
    TrackBar1: TTrackBar;
    Edit_Name: TEdit;
    Panel_Banner: TPanel;
    Button_Search: TButton;
    Edit_Memo: TEdit;
    Label1: TLabel;
    Panel_C: TPanel;
    Button_Preview: TButton;
    Button_Save: TButton;
    Button_Delete: TButton;
    BitBtn_Upload: TBitBtn;
    Label2: TLabel;
    DateTimePicker1: TDateTimePicker;
    Panel_L: TPanel;
    Panel2: TPanel;
    Label3: TLabel;
    Panel_Roles: TPanel;
    Button_AllType: TButton;
    Button_Doc: TButton;
    Button_Xls: TButton;
    Button_Ppt: TButton;
    Button_Pdf: TButton;
    Button_Image: TButton;
    Button_Mp4: TButton;
    Button_Mp3: TButton;
    Button_Txt: TButton;
    Panel3: TPanel;
    Edit_Search: TEdit;
    Button_Download: TButton;
    Panel4: TPanel;
    Label4: TLabel;
    Panel_Order: TPanel;
    ComboBox_Order: TComboBox;
    ComboBox_DESC: TComboBox;
    FDQuery1: TFDQuery;
    procedure TrackBar1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button_SearchClick(Sender: TObject);
    procedure Button_SaveClick(Sender: TObject);
    procedure StringGrid1Click(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button_AddClick(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure BitBtn_UploadEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Button_PreviewClick(Sender: TObject);
    procedure Button_DownloadClick(Sender: TObject);
    procedure Button_AllTypeClick(Sender: TObject);
    procedure Button_DocClick(Sender: TObject);
    procedure StringGrid1DblClick(Sender: TObject);
    procedure ComboBox_OrderChange(Sender: TObject);
    procedure BitBtn_UploadStartDock(Sender: TObject; var DragObject: TDragDockObject);
  private
    { Private declarations }
  public
        procedure UpdateData(APage:Integer);
        procedure UpdateInfos;
        function  GetTypeWhere:String; //根据类型选择情况, 得到where条件
        function  GetOrder:String;      //得到ORDER

  end;


implementation

uses
    Unit1;


{$R *.dfm}



procedure TForm_Document.BitBtn_UploadEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFile   : string;
    sExt    : string;
begin
    //得到最终上传的文件名
    sFile   := dwGetProp(TForm(self.Owner),'__upload');
    sExt    := LowerCase(ExtractFileExt(sFile));
    Delete(sExt,1,1);   //删除前面的.

    //复制文件到系统的文档目录
    MoveFile(PWideChar(ExtractFilePath(Application.ExeName)+'upload\'+sFile),PWideChar(ExtractFilePath(Application.ExeName)+'media\doc\dwms\'+sFile));

    //插入数据表记录
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'INSERT INTO wms_Document (名称,文件名,类型,上传时间,备注) '
            +Format('VALUES(''%s'',''%s'',''%s'',#%s#,''%s'')',
            [
            ChangeFileExt(sFile,''),
            sFile,
            sExt,
            FormatDateTime('YYYY-MM-DD',Now),
            ''
            ]);
    FDQuery1.ExecSQL;

    //更新数据
    dwaGetDataToGrid(FDQuery1,'wms_Document','ID,名称,类型,上传时间,备注',
            '',GetOrder,1,10,StringGrid1,TrackBar1);
end;

procedure TForm_Document.BitBtn_UploadStartDock(Sender: TObject; var DragObject: TDragDockObject);
begin
    dwMessage('Start upload','success',self);
end;

procedure TForm_Document.Button_AddClick(Sender: TObject);
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

procedure TForm_Document.Button_AllTypeClick(Sender: TObject);
var
    I   : Integer;
begin
    //清空其他
    for I := 0 to Panel_Roles.ControlCount-1 do begin
        TButton(Panel_Roles.Controls[I]).Hint   := '{"radius":"0"}';
    end;
    //
    TButton(Sender).Hint    := '{"type":"success","icon":"el-icon-circle-check","radius":"0"}';
end;

procedure TForm_Document.Button_DeleteClick(Sender: TObject);
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

procedure TForm_Document.Button_DocClick(Sender: TObject);
var
    bFound  : Boolean;
    I       : Integer;
begin
    //设置全部类型为非选中
    Button_AllType.Hint     := '{"radius":"0"}';
    //
    if TButton(Sender).Hint = '{"radius":"0"}' then begin
        TButton(Sender).Hint    := '{"type":"success","icon":"el-icon-circle-check","radius":"0"}';
    end else begin
        TButton(Sender).Hint    := '{"radius":"0"}';
    end;

    //如果都没有选中,则选中"全部类型"
    bFound := False;
    for I := 0 to Panel_Roles.ControlCount-1 do begin
        if TButton(Panel_Roles.Controls[I]).Hint <> '{"radius":"0"}' then begin
            bFound  := True;
            break;
        end;
    end;
    if not bFound then begin //如果都没有选中,则选中"全部类型"
        Button_AllType.Hint     := '{"type":"success","icon":"el-icon-circle-check","radius":"0"}';
    end;

    //
    UpdateData(TrackBar1.Position);
end;

procedure TForm_Document.Button_DownloadClick(Sender: TObject);
var
    iRow    : Integer;
    sID     : String;
    sFile   : String;
begin
    //得到行,以及相应ID
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    sID := StringGrid1.Cells[0,iRow];

    //根据ID打开表
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_Document WHERE ID = '+sID;
    FDQuery1.Open;

    //
    sFile   := FDQuery1.FieldByName('文件名').AsString;
    if FileExists(ExtractFilePath(Application.ExeName)+'media\doc\dwms\'+sFile) then begin
        dwOpenUrl(self,'/media/doc/dwms/'+sFile,'_blank');
    end else begin
        dwMessage('文件不存在!','error',self);
    end;

end;

procedure TForm_Document.Button_PreviewClick(Sender: TObject);
var
    iRow    : Integer;
    sID     : String;
    sFile   : String;
    sExt    : String;
begin
    //通过行号取得ID
    iRow := StringGrid1.Row;
    iRow    := Max(1,iRow);
    sID := StringGrid1.Cells[0,iRow];

    //取得数据表记录
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_Document WHERE ID = '+sID;
    FDQuery1.Open;

    //得到文件
    sFile   := FDQuery1.FieldByName('文件名').AsString;
    sExt    := FDQuery1.FieldByName('类型').AsString;
    if FileExists(ExtractFilePath(Application.ExeName)+'media\doc\dwms\'+sFile) then begin
        if sExt ='pdf' then begin
            dwOpenUrl(self,'/pdf?file=/media/doc/dwms/'+dwEscape(sFile),'_blank');
        end else if sExt = 'mp3' then begin
            dwOpenUrl(self,'/mp3?file=/media/doc/dwms/'+dwEscape(sFile),'_blank');
        end else if sExt = 'mp4' then begin
            dwOpenUrl(self,'/mp4?file=/media/doc/dwms/'+dwEscape(sFile),'_blank');
        end else if (sExt = 'doc') or (sExt = 'docx') or (sExt = 'xls') or(sExt = 'xlsx') or(sExt = 'ppt') or(sExt = 'pptx') then begin
            dwOpenUrl(self,'https://view.officeapps.live.com/op/view.aspx?src=https://delphibbs.com/media/doc/dwms/'+dwEscape(sFile),'_blank');
        end else begin
            dwOpenUrl(self,'/media/doc/dwms/'+(sFile),'_blank');
        end;
    end else begin
        dwMessage('文件不存在!','error',self);
    end;

end;

procedure TForm_Document.Button_SaveClick(Sender: TObject);
var
    iRow    : INteger;
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

procedure TForm_Document.Button_SearchClick(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Document','ID,名称,类型,上传时间,备注',
            dwaGetWhere(FDQuery1,'wms_Document',Edit_Search.Text)+GetTypeWhere,
            GetOrder,1,10,StringGrid1,TrackBar1);

end;

procedure TForm_Document.ComboBox_OrderChange(Sender: TObject);
begin
    UpdateData(TrackBar1.Position);
end;

procedure TForm_Document.FormCreate(Sender: TObject);
begin
    //ID,
    //
    with StringGrid1 do begin
        Cells[0,0]   := 'ID[*center*]';
        Cells[1,0]   := '名称[*left*]';
        Cells[2,0]   := '类型[*center*]';
        Cells[3,0]   := '上传时间[*center*]';
        Cells[4,0]   := '备注[*left*]';
        //
        ColWidths[0]     := 40;
        ColWidths[1]     := 200;
        ColWidths[2]     := 60;
        ColWidths[3]     := 200;
        ColWidths[4]     := 300;
    end;

end;

procedure TForm_Document.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : String;
    sValue  : String;
    sID     : String;
    iRow    : Integer;
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
            FDQuery1.SQL.Text  := 'SELECT * FROM wms_Document WHERE ID = '+sID;
            FDQuery1.Open;
            //保存到数据表
            with FDQuery1 do begin
                Edit;
                FieldByName('名称').AsString        := Edit_Name.Text;
                FieldByName('上传时间').AsDateTime  := DateTimePicker1.Date;
                FieldByName('备注').AsString        := Edit_Memo.Text;
                Post;
            end;

            //更新显示
            with StringGrid1 do begin
                Cells[1,iRow]   := Edit_Name.Text;
                Cells[3,iRow]   := FormatDateTime('YYYY-MM-DD',DateTimePicker1.Date);
                Cells[4,iRow]   := Edit_Memo.Text;
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
            FDQuery1.SQL.Text  := 'INSERT INTO wms_Document (名称,备注) '
                    +Format('VALUES(''%s'',''%s'')',
                    [
                    Edit_Name.Text,
                    Edit_Memo.Text
                    ]);
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_Document','ID,名称,类型,上传时间,备注',
                dwaGetWhere(FDQuery1,'wms_Document',Edit_Search.Text)+GetTypeWhere,
                GetOrder,999,10,StringGrid1,TrackBar1);
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
            FDQuery1.SQL.Text  := 'DELETE FROM wms_Document WHERE ID='+sID;
            FDQuery1.ExecSQL;

            //更新显示
            Edit_Search.Text    := '';
            dwaGetDataToGrid(FDQuery1,'wms_Document','ID,名称,类型,上传时间,备注',
                dwaGetWhere(FDQuery1,'wms_Document',Edit_Search.Text)+GetTypeWhere,
                GetOrder,1,10,StringGrid1,TrackBar1);
            //
            dwMessage('删除成功!','success',self);
        end;
    end else begin

    end;



end;

function TForm_Document.GetOrder: String;
begin
    if Trim(ComboBox_Order.Text)<>'' then begin
        Result  := ' ORDER BY '+ComboBox_Order.Text+' ';
        if ComboBox_Desc.Text = '降序' then begin
            Result  := Result + 'DESC ';
        end;
    end else begin
        Result  := '';
    end;

end;

function TForm_Document.GetTypeWhere: String;
begin
    if Button_AllType.Hint <> '{"radius":"0"}' then begin
        Result  := '';
    end else begin
        Result  := ' AND (';
        if Button_Doc.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''doc'') OR (类型=''docx'')) OR '
        end;
        if Button_Xls.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''xls'') OR (类型=''xlsx'')) OR '
        end;
        if Button_ppt.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''ppt'') OR (类型=''pptx'')) OR '
        end;
        if Button_pdf.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''pdf'')) OR '
        end;
        if Button_image.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''jpg'') OR (类型=''png'') OR (类型=''bmp'') OR (类型=''gif'') OR (类型=''png'')) OR '
        end;
        if Button_mp4.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''mp4'')) OR '
        end;
        if Button_mp3.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''mp3'')) OR '
        end;
        if Button_txt.Hint <> '{"radius":"0"}' then begin
            Result  := Result + '((类型=''txt'')) OR '
        end;
        //删除最后的OR
        Delete(Result,Length(Result)-3,4);
        //
        Result  := Result +') ';

    end;
end;

procedure TForm_Document.StringGrid1Click(Sender: TObject);
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
    DateTimePicker1.DateTime    := StrToDateTimeDef(StringGrid1.Cells[2,iRow],Now);
    Edit_Memo.Text      := StringGrid1.Cells[4,iRow];

end;

procedure TForm_Document.StringGrid1DblClick(Sender: TObject);
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
    DateTimePicker1.DateTime    := StrToDateTimeDef(StringGrid1.Cells[2,iRow],Now);
    Edit_Memo.Text      := StringGrid1.Cells[4,iRow];

    //
    Button_Preview.OnClick(self);
end;

procedure TForm_Document.TrackBar1Change(Sender: TObject);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Document','ID,名称,类型,上传时间,备注',
        dwaGetWhere(FDQuery1,'wms_Document',Edit_Search.Text)+GetTypeWhere,
        GetOrder, TrackBar1.Position,10,StringGrid1,TrackBar1);

end;

procedure TForm_Document.UpdateData(APage: Integer);
begin
    dwaGetDataToGrid(FDQuery1,'wms_Document','ID,名称,类型,上传时间,备注',
            dwaGetWhere(FDQuery1,'wms_Document',Edit_Search.Text)+GetTypeWhere,
            GetOrder,APage,10,StringGrid1,TrackBar1);

end;

procedure TForm_Document.UpdateInfos;
begin
    //
end;

end.
