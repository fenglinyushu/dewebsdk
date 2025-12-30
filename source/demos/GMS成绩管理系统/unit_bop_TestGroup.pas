unit unit_bop_TestGroup;

interface

uses
    dwBase,
    dwDB,
    dwCrudPanel,
    dwfBase,

    //浏览器历史记录控制单元
    dwHistory,

    //
    SynCommons,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.Grids, Vcl.Samples.Spin;

type
  TForm_bop_TestGroup = class(TForm)
    Pn1: TPanel;
    PnS: TPanel;
    SlR: TSplitter;
    BtGroup: TButton;
    PnAuto: TPanel;
    LaAuto: TLabel;
    PnItem: TPanel;
    LaItem: TLabel;
    CbItem: TComboBox;
    PnBtn: TPanel;
    PnClass: TPanel;
    BtCancel: TButton;
    BtOK: TButton;
    FDQuery1: TFDQuery;
    CbGender: TComboBox;
    SECount: TSpinEdit;
    FDQuery2: TFDQuery;
    BtMember: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtOKClick(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
    procedure BtMemberClick(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串, 如:'["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_bop_TestGroup             : TForm_bop_TestGroup;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_TestGroup.BtCancelClick(Sender: TObject);
begin
    //弹出自动分组选择框
    PnAuto.Visible  := False;

    //<-----为当前操作删除记录, 包括2部分: 浏览器中的历史记录和gjoHistory数组中的记录
    //浏览器中的历史记录
    dwhistoryBack(dwGetForm1(self));
    with TForm1(dwGetForm1(self)) do begin
        //标记最后一条记录为空记录
        if gjoHistory._Count > 0 then begin
            gjoHistory._(gjoHistory._Count - 1).isnull  := 1;
        end;
    end;
end;

procedure TForm_bop_TestGroup.BtGroupClick(Sender: TObject);
begin
    //弹出自动分组选择框
    PnAuto.Visible  := True;
end;

procedure TForm_bop_TestGroup.BtMemberClick(Sender: TObject);
var
    joHistory   : Variant;
begin

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin
        //显示学生信息表格
        PnS.Visible     := True;
        PnS.Align       := alClient;

        //隐藏分组列表
        Pn1.Visible     := False;

        //
        with TForm1(self.Owner) do begin
            //显示标题
            LT.Caption   := '学生信息';

            //为当前操作添加记录
            dwAddShowHistory(Self,[Pn1],[Pns],'体测分组');
        end;
    end;

end;

procedure TForm_bop_TestGroup.BtOKClick(Sender: TObject);
var
    iItem       : Integer;
    iCount      : Integer;
    iGItem      : Integer;
    iGroup      : Integer;
    iGroupId    : integer;
    //
    sClassNums  : string;
    sGroupName  : String;
    //
    oSGD        : TStringGrid;
begin
    //取得表格控件
    oSGD        := cpGetStringGrid(PnClass);

    //取得选中的数量
    iCount      := 0;
    sClassNums  := '(';
    for iItem := 1 to oSGD.RowCount - 1 do begin
        //非空则退出
        if oSGD.Cells[1,iItem] = '' then begin
            break;
        end;

        //处理选中的班级
        if oSGD.Cells[0,iItem] = 'true' then begin
            //增加数量
            Inc(iCount);

            //取得班级号列表
            sClassNums  := sClassNums + ''''+oSGD.Cells[1,iItem]+''',';
        end;
    end;

    //根据结果判断
    if iCount = 0 then begin
        dwMessage('请至少选择一个班级!','error',self);
    end else begin
        //取得班级号列表
        Delete(sClassNums,Length(sClassNums),1);
        sClassNums  := sClassNums + ')';

        //打开当前班级的男/女生
        FDQuery1.Open('SElECT * FROM sys_Student'
                +' WHERE sClassNum in '+sClassNums+' AND sGender='''+IntToStr(CbGender.ItemIndex+1)+''''
                +' ORDER BY sClassNum,sRegisterNum');

        //
        for iGroup := 0 to Ceil(FDQuery1.RecordCount / SECount.Value)-1 do begin
            //自动生成组名
            sGroupName  := CbItem.Text+'-'+CbGender.Text+'-'+IntToStr(iGroup+1);

            //创建一个组
            FDQuery2.Close;
            FDQuery2.SQL.Text := 'INSERT INTO bop_Test(tName,tDate,tGender,tItemName,tStatus)'
                +' OUTPUT inserted.tId'
                +' VALUES(:Name,:Date,:Gender,:ItemName,0)';
            FDQuery2.ParamByName('Name').AsString       := sGroupName;
            FDQuery2.ParamByName('Date').AsDateTime     := Now;
            FDQuery2.ParamByName('Gender').AsString     := CbGender.Text;
            FDQuery2.ParamByName('ItemName').AsString   := CbItem.Text;
            FDQuery2.Open;

            //取得分组测试的id
            iGroupId    := FDQuery2.Fields[0].AsInteger;

            //处理当前分组的学生
            for iGItem := 0 to SECount.Value - 1 do begin
                FDQuery1.RecNo  := iGroup * SECount.Value + iGItem + 1;

                //将当前学生插入到分组中
                FDQuery2.Close;
                FDQuery2.SQL.Text := 'INSERT INTO bop_TestRoster(rTestId,rClassNum,rRegisterNum,rName,rGender,rStudentId)'
                    +' VALUES(:TestId,:ClassNum,:RegisterNum,:Name,:Gender,:StudentId)';
                FDQuery2.ParamByName('TestId').AsInteger    := iGroupId;
                FDQuery2.ParamByName('ClassNum').AsString   := FDQuery1.FieldByName('sClassNum').AsString;
                FDQuery2.ParamByName('RegisterNum').AsString:= FDQuery1.FieldByName('sRegisterNum').AsString;
                FDQuery2.ParamByName('Name').AsString       := FDQuery1.FieldByName('sName').AsString;
                FDQuery2.ParamByName('Gender').AsString     := FDQuery1.FieldByName('sGender').AsString;
                FDQuery2.ParamByName('StudentId').AsInteger := FDQuery1.FieldByName('sId').AsInteger;
                FDQuery2.ExecSQL;
                //
                if FDQuery1.RecNo = FDQuery1.RecordCount then begin
                    break;
                end;
            end;
        end;
    end;

    //
    PnAuto.Visible  := False;

    //
    cpUpdate(Pn1);

    //
    dwMessage('自动分组成功!','success',self);
end;

procedure TForm_bop_TestGroup.FormCreate(Sender: TObject);
begin
    //
    PnAuto.BevelKind    := bkNone;
end;

procedure TForm_bop_TestGroup.FormShow(Sender: TObject);
begin
    //指定数据查询连接
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;
    FDQuery1.FetchOptions.Mode   := fmAll;
    FDQuery2.Connection := TForm1(self.Owner).FDConnection1;
    FDQuery2.FetchOptions.Mode   := fmAll;

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin
        //隐藏学生信息表格
        PnS.Visible     := False;

        //分组列表全屏
        Pn1.Align       := alClient;

        //
        BtMember.Visible    := True;

        //置CrudPanel的按钮只显示图标
        cpSetButtonCaption(Pn1,0);
    end;

    //初始化测试分组表
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //初始化测试分组的明细表
    cpInit(PnS,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');

    //初始化班级表
    cpInit(PnClass,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');

    //读取项目列表
    dwGetDISTINCTComboBoxItems(FDQuery1,'dic_Item','iName',CbItem);


    //插入自定义的按钮
    cpAddInButtons(Pn1,BtGroup);
    BtGroup.Left    := 999;
    cpAddInButtons(Pn1,BtMember);
    BtMember.Left    := 999;
end;

end.
