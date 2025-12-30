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
    PnItem: TPanel;
    LaItem: TLabel;
    CbItem: TComboBox;
    PnClass: TPanel;
    FDQuery1: TFDQuery;
    CbGender: TComboBox;
    SECount: TSpinEdit;
    FDQuery2: TFDQuery;
    BtMember: TButton;
    BtBat: TButton;
    PnBat: TPanel;
    Panel2: TPanel;
    Label2: TLabel;
    CbManager: TComboBox;
    Panel1: TPanel;
    Label1: TLabel;
    CbLocation: TComboBox;
    Panel3: TPanel;
    Label3: TLabel;
    EtRemark: TEdit;
    SEFirst: TSpinEdit;
    BtClose: TButton;
    PnStatus: TPanel;
    LaStatus: TLabel;
    CbStatus: TComboBox;
    LaAuto: TLabel;
    EtGRemark: TEdit;
    procedure FormShow(Sender: TObject);
    procedure BtGroupClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtMemberClick(Sender: TObject);
    procedure BtBatClick(Sender: TObject);
    procedure PnBatEnter(Sender: TObject);
    procedure PnAutoEnter(Sender: TObject);
    procedure PnAutoExit(Sender: TObject);
    procedure BtCloseClick(Sender: TObject);
    procedure PnStatusEnter(Sender: TObject);
    procedure CbGradeChange(Sender: TObject);
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

procedure TForm_bop_TestGroup.BtBatClick(Sender: TObject);
begin
    PnBat.Visible   := True;
end;

procedure TForm_bop_TestGroup.BtCloseClick(Sender: TObject);
begin
    //弹出状态修改确认框
    PnStatus.Visible  := True;
end;

procedure TForm_bop_TestGroup.BtGroupClick(Sender: TObject);
begin
    //弹出自动分组选择框
    PnAuto.Visible  := True;
end;

procedure TForm_bop_TestGroup.BtMemberClick(Sender: TObject);
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

procedure TForm_bop_TestGroup.CbGradeChange(Sender: TObject);
begin
    //
    cpUpdate(PnClass,'');
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

        //置CrudPanel的按钮只显示图标
        cpSetButtonCaption(Pn1,0);
    end else begin
        BtMember.Visible    := False;
    end;

    //初始化测试分组表
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //初始化测试分组的明细表
    cpInit(PnS,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');

    //初始化班级表
    cpInit(PnClass,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');

    //读取项目列表
    dwGetDISTINCTComboBoxItems(FDQuery1,'dic_ItemCode','cName',CbItem,'cCode');

    //添加体质健康
    CbItem.Items.Insert(0,'所有体质健康');
    CbItem.ItemIndex    := 0;


    //插入自定义的按钮
    cpAddInButtons(Pn1,BtGroup);
    BtGroup.Left    := 999;
    cpAddInButtons(Pn1,BtMember);
    BtMember.Left    := 999;
    cpAddInButtons(Pn1,BtBat);
    BtBat.Left    := 999;
    cpAddInButtons(Pn1,BtClose);
    BtClose.Left    := 999;

    //
    dwGetComboBoxItems(
        FDQuery1,
        'sys_User',     //表名
        'uName',        //字段，例如：Name
        False,          //是否支持空值
        CbManager      //ComboBox
        );
    dwGetComboBoxItems(
        FDQuery1,
        'dic_Location',     //表名
        'lName',            //字段，例如：Name
        False,              //是否支持空值
        CbLocation         //ComboBox
        );

    //
    SlR.Left    := 0;
end;

procedure TForm_bop_TestGroup.PnAutoEnter(Sender: TObject);
var
    iItem       : Integer;
    iGender     : Integer;
    iGenderV    : Integer;
    iClass      : Integer;
    iCount      : Integer;
    iGroupNo    : Integer;
    //
    sClassNums  : string;
    //
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
    //
    joItems     : variant;  //拟分组的项目数组, [{100,"身高"},{101,"体重"},....]
    joGenders   : variant;  //拟分组的性别数组,[1,2]    1男/2女
    joClasses   : variant;  //班级数组  [{"21","202418","初中2024级18班"},{"22","202419","初中2024级19班"},....
    joTemp      : variant;
    joItem      : variant;
    joClass     : variant;

    //创建当前项目,当前性别的分组   AGender :1男/2女
    function _GenerateGroup(AItem:Variant;AGender:Word;AClasses:Variant;var AGroupNo:integer):Integer;
    var
        iiGroup     : Integer;
        iiGItem     : Integer;
        iiGroupId   : integer;
        ssGroupName : String;
        ssClassNStr : string;   //用作分组名称的字符串 = ClassNameString
        ssManager   : string;   //负责人
    begin
        Result      := 0;
        try
            //取得当前班级列表(需要根据是否为体质健康, 如果, 则需要查数据表;否则直接生成全部)
            if CbItem.ItemIndex = 0 then begin
                //打开当前班级的男/女生, 根据班级号和学籍号排序
                FDQuery1.Open(
                        'SElECT sId, sName, sGradeNum, sClassNum, sClassName, sRegisterNum'
                        +' FROM sys_Student'
                        +' WHERE'
                            +' sClassNum in '+sClassNums
                            +' AND sGender='''+IntToStr(AGender)+''''
                            +' AND sGradeNum in ('+
                                'SElECT mGradeNum '
                                +' FROM dic_ItemMust'
                                +' WHERE '
                                    +' mItems like ''%'+IntToStr(AItem.code)+'%'''
                                    +' AND mGender = '''+IntToStr(AGender)+''''
                                +')'
                        +' ORDER BY sClassNum DESC,sRegisterNum'
                );
            end else begin
                //打开当前班级的男/女生, 根据班级号和学籍号排序
                FDQuery1.Open(
                        'SElECT sId, sName, sGradeNum, sClassNum, sClassName, sRegisterNum'
                        +' FROM sys_Student'
                        +' WHERE'
                            +' sClassNum in '+sClassNums
                            +' AND sGender='''+IntToStr(AGender)+''''
                        +' ORDER BY sClassNum DESC,sRegisterNum'
                );
            end;

            //
            for iiGroup := 0 to Ceil(FDQuery1.RecordCount / SECount.Value)-1 do begin   //iGroup为分组的循环变量,0开始

                //创建一个组, 返回组id
                FDQuery2.Close;
                FDQuery2.SQL.Text := 'INSERT INTO bop_Test(tName,tDate, tGradeNum, tGender,tItemName,tItemUnit,tLocation,tStatus,tRemark)'
                    +' OUTPUT inserted.tId'
                    +' VALUES(''temp'',:Date,:GradeNum, :Gender,:ItemName,:ItemUnit,:Location,0,:Remark)';
                FDQuery2.ParamByName('Date').AsDateTime     := Now;
                FDQuery2.ParamByName('GradeNum').AsInteger  := FDQuery1.FieldByName('sGradeNum').AsInteger;
                FDQuery2.ParamByName('Gender').AsInteger    := AGender;//=1,'男','女');
                FDQuery2.ParamByName('ItemName').AsString   := AItem.name;
                FDQuery2.ParamByName('ItemUnit').AsString   := AItem.unit;
                FDQuery2.ParamByName('Location').AsString   := AItem.location;
                FDQuery2.ParamByName('Remark').AsString     := EtGRemark.Text;
                FDQuery2.Open;

                //取得分组测试的id
                iiGroupId   := FDQuery2.Fields[0].AsInteger;

                //处理当前分组的学生
                ssManager   := '';
                for iiGItem := 0 to SECount.Value - 1 do begin
                    //跳转到指定记录  , FDQuery1 为 sys_Student
                    FDQuery1.RecNo  := iiGroup * SECount.Value + iiGItem + 1;

                    //取得分组用的班级名称, 最多两个班级
                    if iiGItem = 0 then begin
                        ssClassNStr := FDQuery1.FieldByName('sClassName').AsString;
                    end else begin
                        if (Pos('/',ssClassNStr)<=0) and (ssClassNStr <> FDQuery1.FieldByName('sClassName').AsString) then begin
                            ssClassNStr  := ssClassNStr+'/'+FDQuery1.FieldByName('sClassName').AsString;
                        end;
                    end;

                    //取得负责人. 通过sClassNum , 对应sys_Department表的dNumber, 取dManager
                    if ssManager = '' then begin
                        FDQuery2.Open('SELECT dManager FROM sys_Department WHERE dNumber = '''+FDQuery1.FieldByName('sClassNum').AsString+'''');
                        ssManager   := FDQuery2.FieldByName('dManager').AsString;
                    end;

                    //将当前学生插入到分组中
                    FDQuery2.Close;
                    FDQuery2.SQL.Text := 'INSERT INTO bop_TestRoster(rTestId,rClassNum,rRegisterNum,rName,rGender,rStudentId,rItemName,rItemCode,rItemUnit)'
                        +' VALUES(:TestId,:ClassNum,:RegisterNum,:Name,:Gender,:StudentId,:ItemName,:ItemCode,:ItemUnit)';
                    FDQuery2.ParamByName('TestId').AsInteger    := iiGroupId;
                    FDQuery2.ParamByName('ClassNum').AsString   := FDQuery1.FieldByName('sClassNum').AsString;
                    FDQuery2.ParamByName('RegisterNum').AsString:= FDQuery1.FieldByName('sRegisterNum').AsString;
                    FDQuery2.ParamByName('Name').AsString       := FDQuery1.FieldByName('sName').AsString;
                    FDQuery2.ParamByName('Gender').AsInteger    := AGender;//=1,'男','女');;       // FDQuery1.FieldByName('sGender').AsString;
                    FDQuery2.ParamByName('StudentId').AsInteger := FDQuery1.FieldByName('sId').AsInteger;
                    FDQuery2.ParamByName('ItemName').AsString   := AItem.name;
                    FDQuery2.ParamByName('ItemCode').AsInteger  := AItem.code;
                    FDQuery2.ParamByName('ItemUnit').AsString   := AItem.unit;
                    FDQuery2.ExecSQL;
                    //
                    if FDQuery1.RecNo = FDQuery1.RecordCount then begin
                        break;
                    end;
                end;

                //自动生成组名并更新 : 项目名称 - 性别 - 班级 - 序号, 如: 1000米-男-初中2024级11班-3
                ssGroupName := String(AItem.name)+'-'+dwIIF(AGender=1,'男','女')+'-'+ssClassNStr+'-'+IntToStr(iGroupNo);
                FDQuery1.Connection.ExecSQL('UPDATE bop_Test SET tName='''+ssGroupName+''',tManager ='''+ssManager+''' WHERE tId='+IntToStr(iiGroupId));

                //
                Inc(iGroupNo);
            end;
        except
            Result  := -1;
        end;
    end;
begin
    //::::: 基本思想是先生成 joItems,joGenders,joClasses , 然后逐个生成


    //取得表格控件
    oSGD        := cpGetStringGrid(PnClass);

    //取得选中的班级   班级数组  [{"21","202418","初中2024级18班"},{"22","202419","初中2024级19班"},....
    joClasses   := _json('[]');
    oFDQuery    := cpGetFDQuery(PnClass);
    for iItem := 1 to oSGD.RowCount - 1 do begin
        //非空则退出
        if oSGD.Cells[1,iItem] = '' then begin
            break;
        end;

        //处理选中的班级
        if oSGD.Cells[0,iItem] = 'true' then begin
            //跳转到当前记录
            oFDQuery.RecNo  := iItem;

            //取得班级信息号列表, sClassNums = ("202501","202503",......
            joTemp              := _json('{}');
            joTemp.gradenum     := oFDQuery.FieldByName('dGradeNum').AsString;
            joTemp.classnum     := oFDQuery.FieldByName('dNumber').AsString;
            joTemp.classname    := oSGD.Cells[1,iItem]+oFDQuery.FieldByName('dName').AsString;
            joTemp.manager      := oFDQuery.FieldByName('dManager').AsString;
            //
            joClasses.Add(joTemp);
        end;
    end;


    //根据结果判断
    if joClasses._Count = 0 then begin
        dwMessage('请至少选择一个班级!','error',self);
        Exit;
    end else begin
        //生成班级查询用的列表
        sClassNums  := '(';
        for iItem := 0 to joClasses._Count - 1 do begin
            sClassNums  := sClassNums + joClasses._(iItem).classnum +',';
        end;
        Delete(sClassNums,Length(sClassNums),1);
        sClassNums  := sClassNums + ')';
    end;

    //取得项目列表  joItems  拟分组的项目数组, [{100,"身高"},{101,"体重"},....]
    joItems := _json('[]');
    if CbItem.ItemIndex = 0 then begin  //所有体质健康项目
        //打开项目表, 查找所有体质健康项目
        FDQuery1.Open('SELECT cName,cCode,cUnit,cDefaultLocation FROM dic_ItemCode WHERE cCode < 200 ORDER BY cCode ');

        //添加到joItems
        while not FDQuery1.Eof do begin
            //
            joTemp          := _json('{}');
            joTemp.name     := FDQuery1.FieldByName('cName').AsString;              //名称
            joTemp.code     := FDQuery1.FieldByName('cCode').AsInteger;             //编号
            joTemp.unit     := FDQuery1.FieldByName('cUnit').AsString;              //单位
            joTemp.location := FDQuery1.FieldByName('cDefaultLocation').AsString;   //单位
            //
            joItems.Add(joTemp);

            //
            FDQuery1.Next;
        end;
    end else begin
        //打开项目表, 查找当前项目
        FDQuery1.Open('SELECT cName,cCode,cUnit,cDefaultLocation FROM dic_ItemCode WHERE cName =''' + CbItem.Text + '''');

        //添加到joItems
        if not FDQuery1.IsEmpty then begin
            //
            joTemp          := _json('{}');
            joTemp.name     := FDQuery1.FieldByName('cName').AsString;
            joTemp.code     := FDQuery1.FieldByName('cCode').AsInteger;
            joTemp.unit     := FDQuery1.FieldByName('cUnit').AsString;              //单位
            joTemp.location := FDQuery1.FieldByName('cDefaultLocation').AsString;   //单位
            //
            joItems.Add(joTemp);
        end;
    end;

    //取得性别信息  joGenders  1:男,2:女
    if CbGender.ItemIndex = 0  then begin
        joGenders := _json('[1,2]');
    end else begin
        joGenders := _json('['+IntToStr(CbGender.ItemIndex)+']');
    end;

    //逐个项目处理
    iGroupNo    := SeFirst.Value;
    for iItem := 0 to joItems._Count - 1 do begin
        //取得当前项目 {100,"身高"}
        joItem  := joItems._(iItem);

        //逐个性别处理
        for iGender := 0 to joGenders._Count - 1 do begin
            //取得性别  1:男,2:女
            iGenderV    := joGenders._(iGender);

            //生成当前项目, 当前性别下班级分组
            _GenerateGroup(joItem,iGenderV,joClasses,iGroupNo);
        end;
    end;

    //更新分组的初始编号
    SEFirst.Value   := iGroupNo;

    //关闭自动分组面板
    PnAuto.Visible  := False;

    //更新数据显示
    cpUpdate(Pn1);

    //弹出提示框
    dwMessage('自动分组成功!','success',self);
end;

procedure TForm_bop_TestGroup.PnAutoExit(Sender: TObject);
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

procedure TForm_bop_TestGroup.PnBatEnter(Sender: TObject);
var
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
    oFDTemp     : TFDQuery;
    iItem       : Integer;
    iCount      : Integer;
    iUserId     : Integer;
begin
    //
    oSGD        := cpGetStringGrid(Pn1);
    oFDQuery    := cpGetFDQuery(Pn1);
    oFDTemp     := cpGetFDQueryTemp(Pn1);

    //
    iCount      := 0;
    for iItem := 1 to oSGD.RowCount - 1 do begin
        if oSGD.Cells[0,iItem] = 'true' then begin
            Inc(iCount);
        end;
    end;

    //
    if iCount = 0 then begin
        //----- 如果没有选择一个, 则直接处理当前记录


        //取得负责人的uid
        oFDTemp.Open('SELECT uId FROM sys_User WHERE uName='''+CbManager.Text+'''');
        if oFDTemp.IsEmpty then begin
            dwMessage('未找到指定姓名!','error',self);
        end else begin
            iUserId := oFDTemp.FieldByName('uId').AsInteger;
        end;

        //
        if oFDTemp.IsEmpty then begin
            dwMessage('未找到指定姓名!','error',self);
        end else begin
            oFDQuery.Edit;
            oFDQuery.FieldByName('tManagerId').AsInteger    := iUserId;
            oFDQuery.FieldByName('tManager').AsString       := CbManager.Text;
            oFDQuery.FieldByName('tLocation').AsString      := CbLocation.Text;
            oFDQuery.FieldByName('tRemark').AsString        := EtRemark.Text;
            oFDQuery.Post;
            //
            cpUpdate(Pn1);
        end;
    end else begin
        //----- 如果有选中, 则逐个处理

        //取得负责人的uid
        oFDTemp.Open('SELECT uId FROM sys_User WHERE uName='''+CbManager.Text+'''');
        if oFDTemp.IsEmpty then begin
            dwMessage('未找到指定姓名!','error',self);
        end else begin
            iUserId := oFDTemp.FieldByName('uId').AsInteger;
        end;

        //
        for iItem := 1 to oSGD.RowCount - 1 do begin
            if oSGD.Cells[0,iItem] = 'true' then begin
                //跳转到当前记录
                oFDQuery.RecNo  := iItem;
                oFDQuery.Edit;
                oFDQuery.FieldByName('tManagerId').AsInteger    := iUserId;
                oFDQuery.FieldByName('tManager').AsString       := CbManager.Text;
                oFDQuery.FieldByName('tLocation').AsString      := CbLocation.Text;
                oFDQuery.FieldByName('tRemark').AsString        := EtRemark.Text;
                oFDQuery.Post;
            end;
        end;
        //
        cpUpdate(Pn1);
    end;
end;

procedure TForm_bop_TestGroup.PnStatusEnter(Sender: TObject);
var
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
    oFDTemp     : TFDQuery;
    iItem       : Integer;
    iCount      : Integer;
    iUserId     : Integer;
begin
    //===== 将当前测试分组的状态统一设置为"开放"或"关闭"


    //取得相关控件
    oSGD        := cpGetStringGrid(Pn1);
    oFDQuery    := cpGetFDQuery(Pn1);
    oFDTemp     := cpGetFDQueryTemp(Pn1);

    //取得当前选中的个数
    iCount      := 0;
    for iItem := 1 to oSGD.RowCount - 1 do begin
        if oSGD.Cells[0,iItem] = 'true' then begin
            Inc(iCount);
        end;
    end;

    //
    if iCount = 0 then begin
        //----- 如果没有选择一个, 则直接处理当前记录

        oFDQuery.Edit;
        oFDQuery.FieldByName('tStatus').AsInteger   := CbStatus.ItemIndex;
        oFDQuery.Post;
    end else begin
        //----- 如果有选中, 则逐个处理

        //逐个处理
        for iItem := 1 to oSGD.RowCount - 1 do begin
            if oSGD.Cells[0,iItem] = 'true' then begin
                //跳转到当前记录
                oFDQuery.RecNo  := iItem;
                oFDQuery.Edit;
                oFDQuery.FieldByName('tStatus').AsInteger   := CbStatus.ItemIndex;
                oFDQuery.Post;
            end;
        end;
    end;

    //更新显示
    cpUpdate(Pn1);
end;

end.
