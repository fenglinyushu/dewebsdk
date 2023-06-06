unit unit1;

interface

uses
    //
    dwBase,
    dwAccess,

    //
    SynCommons,


    //
    Math,Variants,
    Graphics,strutils,
    ComObj,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    Panel_0_Banner: TPanel;
    Label_Name: TLabel;
    Panel_Title: TPanel;
    Label_Title: TLabel;
    Edit_Search: TEdit;
    Button_ToExcel: TButton;
    Button_Print: TButton;
    ListView1: TListView;
    Button_Edit: TButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure Edit_SearchChange(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button_PrintClick(Sender: TObject);
    procedure ListView1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Button_EditClick(Sender: TObject);
  private
    { Private declarations }
  public
        gsMainDir   : String;
        giPageNo    : Integer;  //页码
        gsOrder     : string;
        gsExcel     : string;
        procedure UpdateDatas;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function _GetFields(AGrid:TDBGrid):Variant;
var
    iCol    : Integer;
    //
    sCapt   : string;
    //
    joField : Variant;
begin
    Result  := _json('[]');

    //
    for iCol := 0 to AGrid.Columns.Count-1 do begin
        //得到caption
        sCapt   := AGrid.Columns[iCol].Title.Caption;
        //根据caption生成JSON
        joField := _json(sCapt);
        //根据是否成功解析为JSON进行处理
        if joField = unassigned then begin
            //未采用JSON来描述
            joField := _json('{}');
            joField.fieldname   := AGrid.Columns[iCol].FieldName;
            joField.width       := AGrid.Columns[iCol].Width;
            joField.caption     := AGrid.Columns[iCol].Title.Caption;
        end else begin
            //采用JSON对字段进行描述
            joField.width       := AGrid.Columns[iCol].Width;
            if not joField.Exists('caption') then begin
                joField.caption := '';
            end;
        end;
        //
        Result.Add(joField);
    end;

end;


function dwDBGridToXls(AGrid:TDBGrid;ADir,AFileName:String):Integer;
var
    iCol        : Integer;
    iRow        : Integer;
    iRowHeight  : Integer;
    //
    sValue      : String;
    //
    oXls        : Variant;
    oPicture    : OleVariant;
    oRange      : OleVariant;
    oDataSet    : TDataSet;
    //
    joHint      : Variant;
    joFields    : Variant;
    joField     : Variant;
begin
    //
    if ( AGrid.DataSource = nil ) or ( AGrid.DataSource.DataSet = nil ) or ( AGrid.DataSource.DataSet.Active = false ) then begin
        dwMessage('No Data!','error',TForm(AGrid.Owner));
        Exit;
    end;
    //确定文件扩展名
    if LowerCase(RightStr(AfileName, 4)) <> '.xls' then begin
        AFileName := ChangeFileExt(AFileName,'.xls');
    end;
    //检查是否安装了Excel
    try
        oXls := CreateOleObject('Excel.application');
        oXls.workbooks.add;
    except
        dwMessage('Please install MICROSOFT EXCEL first!','error',TForm(AGrid.Owner));
        Exit;
    end;
    //得到表头信息
    joFields    := _GetFields(AGrid);
    //
    joHint      := _json(AGrid.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;
    //得到行高
    iRowHeight  := 35;
    if joHint.Exists('rowheight') then begin
        iRowHeight  := joHint.rowheight;
    end;

    //写表头
    for iCol := 0 to joFields._Count-1 do begin
        joField := joFields._(iCol);
        oXls.cells[1, iCol+1] := String(joField.caption);
        oXls.Columns[iCol+1].ColumnWidth := joField.width *1.5 / AGrid.Font.size;//这里的非象素，而是8个字符的平均宽度;
    end;
    //行高
    oXls.Rows[1].RowHeight := iRowHeight;
    iRow    := 2;
    oDataSet    := AGrid.DataSource.DataSet;
    try
        AGrid.DataSource.DataSet.DisableControls;
        AGrid.DataSource.DataSet.First;
        while not AGrid.DataSource.DataSet.Eof do begin
            for iCol := 0 to joFields._Count-1 do begin
                joField := joFields._(iCol);
                //根据类型进行处理
                if joField.Exists('type') and (joField.type = 'check') then begin
                    sValue  := '';
                end else if joField.Exists('type') and (joField.type = 'index') then begin
                    sValue  := IntToStr(oDataSet.RecNo);
                end else if joField.Exists('type') and (joField.type = 'boolean') then begin
                    if joField.Exists('list') then begin
                        if oDataSet.FieldByName(joField.fieldname).AsBoolean then begin
                            sValue  := joField.list._(0);
                        end else begin
                            sValue  := joField.list._(1);
                        end;
                    end else begin
                        sValue  := oDataSet.FieldByName(joField.fieldname).AsString;
                    end;
                end else if joField.Exists('type') and (joField.type = 'datetime') then begin
                    if joField.Exists('format') then begin
                        sValue  := FormatDateTime(joField.format,oDataSet.FieldByName(joField.fieldname).AsDateTime);
                    end else begin
                        sValue  := oDataSet.FieldByName(joField.fieldname).AsString;
                    end;
                end else if joField.Exists('type') and (joField.type = 'image') then begin
                    sValue  := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                    sValue  := StringReplace(sValue,'/','\',[rfReplaceAll]);
                    sValue  := ADir+sValue;
                    //sValue  := StringReplace(sValue,'\','/',[rfReplaceAll]);
                    //
                    if FileExists(sValue) then begin
                        oRange          := oXls.Range[oXls.Cells.Item[iRow, iCol+1],oXls.Cells.item[iRow, iCol+1]]; //目标位置
                        oPicture        := oXls.activeSheet.Pictures.Insert(sValue); //插入图片
                        oPicture.left   := oRange.left + 4; //左
                        oPicture.top    := oRange.top + 4; //高
                        oPicture.width  := 32;//workRange.width - 1; //宽度
                        oPicture.height := 32;//workRange.height - 1; //高度
                        //
                        sValue  := '*image*';
                    end else begin
                        sValue  := Format(joField.format,[oDataSet.FieldByName(joField.fieldname).AsString]);
                    end;

                end else if joField.Exists('type') and (joField.type = 'progress') then begin
                    sValue  := IntToStr(Round(100*oDataSet.FieldByName(joField.fieldname).AsFloat / joField.total));
                end else if joField.Exists('type') and (joField.type = 'button') then begin
                    sValue  := '';
                end else begin
                    sValue  := oDataSet.FieldByName(joField.fieldname).AsString;
                end;
                //
                if sValue <> '*image*' then begin
                    oXls.Cells[iRow, iCol+1].NumberFormat := '@';
                    oXls.Cells[iRow, iCol+1] := sValue;
                end;
            end;
            //行高
            oXls.Rows[iRow].RowHeight := iRowHeight;
            //
            inc(iRow);
            AGrid.DataSource.DataSet.Next;
        end;
        //
        oXls.Range['a1','z100'].HorizontalAlignment := -4108; // xlCenter//水平居中
    finally
        oXls.WorkBooks[oXls.WorkBooks.Count].SaveAS(AFileName);
        oXls.activeWorkBook.saved := true;
        oXls.workbooks.close;
        oXls.quit;
        AGrid.DataSource.DataSet.EnableControls;
    end;
end;


procedure TForm1.Button_EditClick(Sender: TObject);
begin
    ListView1.ReadOnly  := not ListView1.ReadOnly;
    //
    if ListView1.ReadOnly then begin
        TButton(Sender).Caption := 'ReadOnly';
    end else begin
        TButton(Sender).Caption := 'Edit';
    end;
end;

procedure TForm1.Button_PrintClick(Sender: TObject);
begin
    //
    dwPrint(ListView1);
end;

procedure TForm1.ListView1EndDock(Sender, Target: TObject; X, Y: Integer);
var
    joHint  : Variant;
begin
    //>>> 说明
    //处理DBGrid的各种事件

    //得到Hint的转换JSON对象（因为有些信息保存在DBGrid的Hint中）
    joHint  := _json(ListView1.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    //
    case X of
        1 : begin   //升序排序
            gsOrder := 'ORDER BY salary,id';
            UpdateDatas;
        end;
        2 : begin   //逆序排序
            gsOrder := 'ORDER BY salary DESC,id ASC';
            UpdateDatas;
        end;
        3 : begin   //CheckBox选中事件
            //Label_Selections.Caption    := joHint.__selection;
            //Label_Selections.Caption    := StringReplace(Label_Selections.Caption,'"','',[rfReplaceAll]);
        end;
        4 : begin   //保存前事件
            //dwMessage('Save start!','info',self);
        end;
        5 : begin   //保存后事件
            //退出编辑模式
            //ListView1.Options := ListView1.Options - [dgEditing];
            //
            dwMessage('Save success!','success',self);
        end;
        100..199 : begin    //操作按钮事件
            case Y of
                0 : begin
                    dwMessage('审核：','success',self);
                end;
                1 : begin
                    dwMessage('检查：'+FDQuery1.FieldByName('AName').AsString,'primary',self);
                end;
                2 : begin
                    dwMessage('删除：'+FDQuery1.FieldByName('AName').AsString,'error',self);
                end;
            end;
        end;
    end;
end;

procedure TForm1.Edit_SearchChange(Sender: TObject);
begin
    giPageNo    := 1;
    //
    UpdateDatas;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    iRowHeight  : Integer;      //行高
    //
    joHint      : Variant;
begin
    //取得配置JSON对象
    joHint  := _json(ListView1.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    //
    if (X>600)and(Y>600) then begin
        dwSetPCMode(self);

        //设置为普通表格模式
        ListView1.Ctl3D   := True;

    end else begin
        //
        dwSetMobileMode(self,360,720);

        //
        Panel_Title.Visible         := False;
        Label_Name.Caption          := 'DBGrid';
        Label_Name.Width            := 80;
        Edit_Search.Width           := 150;//           := alClient;
        //Edit_Search.Margins.Right   := 10;
        //
        Button_ToExcel.Caption      := '';
        Button_ToExcel.Width        := 30;
        //Button_Edit.Caption         := '';
        //Button_Edit.Width           := 30;
        //Button_Edit.Margins.Right   := 0;
        //Button_Print.Caption        := '';
        Button_Print.Width          := 30;
        Button_Print.Margins.Right  := 0;

        //设置为纵向单列模式
        ListView1.Ctl3D   := False;

        //得到行高，以计算总高度
        iRowHeight  := 35;
        if joHint.Exists('rowheight') then begin
            iRowHeight  := joHint.rowheight;
        end;

        //
        ListView1.Height  := FDQuery1.RecordCount * ((ListView1.Columns.Count+1) * iRowHeight);

        //
        self.Height := ListView1.Height + 200;
    end;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    giPageNo    := 1;
    gsOrder     := 'ORDER BY id';
    //
    UpdateDatas;
end;

procedure TForm1.UpdateDatas;
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM dw_Member '
        +dwaGetWhere(FDQuery1,'dw_Member',Edit_Search.Text)
        +gsOrder;
    FDQuery1.Open;
    //
    //dwRunJS(dwFullName(ListView1)+'.scrollTop=0;',self);
    dwScroll(ListView1,0);
end;

end.
