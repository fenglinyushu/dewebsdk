unit unit_bop_JudgeSel;

interface

uses
    dwBase,
    dwCrudPanel,

    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.Grids;

type
  TForm_bop_JudgeSel = class(TForm)
    Pn1: TPanel;
    BtSel: TButton;
    BtRemove: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtSelClick(Sender: TObject);
    procedure BtRemoveClick(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串 '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_bop_JudgeSel             : TForm_bop_JudgeSel;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_JudgeSel.BtRemoveClick(Sender: TObject);
var
    iItem       : Integer;
    iCount      : Integer;
    iRow        : Integer;
    //
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
begin
    //取得表格控件
    oSGD        := cpGetStringGrid(Pn1);
    oFDQuery    := cpGetFDQuery(Pn1);

    //
    if oFDQuery.IsEmpty then begin
        dwMessage('数据为空!','error',self);
        Exit;
    end;

    //取得选中的数量
    iCount      := 0;
    for iItem := 1 to oSGD.RowCount - 1 do begin
        //非空则退出
        if oSGD.Cells[1,iItem] = '' then begin
            break;
        end;

        //处理选中的班级
        if oSGD.Cells[0,iItem] = 'true' then begin
            //增加数量
            Inc(iCount);
        end;
    end;

    //
    if iCount = 0 then begin
        //如果没有采用勾选方式,则直接处理当前试题
        oFDQuery.Edit;
        oFDQuery.FieldByName('qStatus').AsInteger   := 0;
        oFDQuery.Post;
    end else begin
        for iItem := 1 to oSGD.RowCount - 1 do begin
            //非空则退出
            if oSGD.Cells[1,iItem] = '' then begin
                break;
            end;

            //处理选中的班级
            if oSGD.Cells[0,iItem] = 'true' then begin
                oFDQuery.RecNo  := iItem;
                oFDQuery.Edit;
                oFDQuery.FieldByName('qStatus').AsInteger   := 0;
                oFDQuery.Post;
            end;
        end;
    end;
    //
    iRow    := oSGD.Row;
    cpUpdate(Pn1);
    oSGD.Row        := iRow;
    oFDQuery.RecNo  := iRow;
end;

procedure TForm_bop_JudgeSel.BtSelClick(Sender: TObject);
var
    iItem       : Integer;
    iCount      : Integer;
    iRow        : Integer;
    //
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
begin
    //取得表格控件
    oSGD        := cpGetStringGrid(Pn1);
    oFDQuery    := cpGetFDQuery(Pn1);

    //
    if oFDQuery.IsEmpty then begin
        dwMessage('数据为空!','error',self);
        Exit;
    end;

    //取得选中的数量
    iCount      := 0;
    for iItem := 1 to oSGD.RowCount - 1 do begin
        //非空则退出
        if oSGD.Cells[1,iItem] = '' then begin
            break;
        end;

        //处理选中的班级
        if oSGD.Cells[0,iItem] = 'true' then begin
            //增加数量
            Inc(iCount);
        end;
    end;

    //
    if iCount = 0 then begin
        //如果没有采用勾选方式,则直接处理当前试题
        oFDQuery.Edit;
        oFDQuery.FieldByName('qStatus').AsInteger   := 1;
        oFDQuery.Post;
    end else begin
        for iItem := 1 to oSGD.RowCount - 1 do begin
            //非空则退出
            if oSGD.Cells[1,iItem] = '' then begin
                break;
            end;

            //处理选中的班级
            if oSGD.Cells[0,iItem] = 'true' then begin
                oFDQuery.RecNo  := iItem;
                oFDQuery.Edit;
                oFDQuery.FieldByName('qStatus').AsInteger   := 1;
                oFDQuery.Post;
            end;
        end;
    end;
    //
    iRow    := oSGD.Row;
    cpUpdate(Pn1);
    oSGD.Row        := iRow;
    oFDQuery.RecNo  := iRow;
end;

procedure TForm_bop_JudgeSel.FormShow(Sender: TObject);
var
    iCurUserId  : Integer;
begin
    //取得当前用户的id
    iCurUserId  := TForm1(self.Owner).gjoUserInfo.id;

    //设置当前只显示选择题和当前用户提供的试题
    cpSetWhere(Pn1,'qType=''判断题''');

    //初始化CRUD模块
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(Self.Owner).gbMobile,gsRights);

    //插入"选择"按钮
    cpAddInButtons(Pn1,BtSel);
    BtSel.Align := alLeft;
    BtSel.Left  := -1;

    //插入"移除"按钮
    cpAddInButtons(Pn1,BtRemove);
    BtRemove.Align := alLeft;
    BtRemove.Left  := 70;
end;

end.
