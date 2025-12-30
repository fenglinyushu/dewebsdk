unit unit_sys_Student;

interface

uses
    //deweb基础函数
    dwBase,

    dwHistory,

    //deweb快速增删改查单元
    dwCrudPanel,

    //基础单元
    dwfBase,

    //导入excel单元
    dwExcel,

    //
    SynCommons,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_sys_Student = class(TForm)
    FDQuery1: TFDQuery;
    PnL: TPanel;
    TV: TTreeView;
    Pn1: TPanel;
    BtConv: TButton;
    PnConfirm: TPanel;
    L_NewTitle: TLabel;
    Panel2: TPanel;
    BtCancel: TButton;
    BtOK: TButton;
    procedure FormShow(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure BtConvClick(Sender: TObject);
    procedure BtCancelClick(Sender: TObject);
    procedure BtOKClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
        giPID       : Integer;  //父节点ID
        procedure UpdateView;

        //根据uDepartmentId更新uDepartmentNo
        procedure UpdateNos;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

//取得节点的WHERE
procedure _GetWhere(ANode:TTreeNode;var AWhere:String);
var
    I  : Integer;
begin
    for I := 0 to ANode.Count-1 do begin
        AWhere  := AWhere + ' OR (uDepartmentId = '+IntTostr(ANode.Item[I].StateIndex)+')';
        _GetWhere(ANode.Item[I],AWHERE);
    end;
end;



procedure TForm_sys_Student.UpdateNos;
begin
    //更新dwUser表! 根据uDepartmentId更新所有uDepartmentNo
    //根据uDepartmentId和部门表的dId的对应关系, 更新uDepartmentNo
    TForm1(Self.Owner).FDConnection1.ExecSQL(
        ''
        +' UPDATE sys_User'
        +' SET uDepartmentNo = ('
        +'     SELECT dNo'
        +'     FROM sys_Department'
        +'     WHERE dId = sys_User.uDepartmentId'
        +' )'
        +' WHERE EXISTS ('
        +'     SELECT 1'
        +'     FROM sys_Department'
        +'     WHERE dId = sys_User.uDepartmentId'
        +' );'
    );
end;

procedure TForm_sys_Student.UpdateView;
var
    iItem       : Integer;
    tnNode      : TTreeNode;
    sName       : String;
    sDId        : String;
    //
    joPair      : Variant;
    joValue     : Variant;
    //
    joConfig    : Variant;
begin
    //将单位表dwDepartment转化为树,将StateIndex为当前 id
    dwfQueryToTreeView(FDQuery1,'sys_Department','dNo','dName','dId',TV);

    //全部展开
    TV.Items[0].Expand(True);

    //生成 单位did 与单位名称的键值对
    joPair  := _json('[]');
    for iItem := 0 to TV.Items.Count - 1 do begin

        //得到树节点
        tnNode  := TV.Items[iItem];

        //得到单位ID
        sDID    := '0'+IntToStr(tnNode.StateIndex);

        //生成多级单位名称，如: 总公司 ->  西安分公司 -> 研发部
        sName   := tnNode.Text;
        while tnNode.Level>1 do begin
            tnNode  := tnNode.Parent;
            sName   := tnNode.Text+' -> '+sName;
        end;

        //转换JSON
        joValue := _json('[]');
        joValue.Add(sName);
        joValue.Add(sDID);

        //添加到键值对数组
        joPair.Add(joValue);
    end;



    //先销毁，以防出错
    //dwCrudDestroy(Self);

    //创建quickcrud
    //dwCrud(self,TForm1(Self.Owner).FDConnection1,False,'');

end;

procedure TForm_sys_Student.BtCancelClick(Sender: TObject);
begin
    PnConfirm.Visible   := False;
end;

procedure TForm_sys_Student.BtConvClick(Sender: TObject);
begin
    PnConfirm.Visible   := True;
end;

procedure TForm_sys_Student.BtOKClick(Sender: TObject);
begin
    //上传文件
    dwUpload(Self,'.xlsx','media/system/gms/');

    //隐藏确认框
    PnConfirm.Visible   := False;
end;

procedure TForm_sys_Student.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFileName   : string;
    sOldGrade   : String;
    sSQL        : String;
    iGradeId    : Integer;
    iClassId    : Integer;
    joConfig    : Variant;
begin
    //=====FormEndDock为默认的上传完成事件


    //取得上传完成的名称
    sFileName   := dwGetProp(Self,'__upload');

    //生成配置json
    joConfig    := _json(
        '{'#13#10
        +'    "table":"sys_Student",'#13#10
        +'    "fields":['#13#10
        +'        {'#13#10
        +'            "name":"sGradeNum"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sClassNum"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sClassName"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sRegisterNum"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sEthnicity"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sName"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sGender"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sBirthday",'#13#10
        +'            "type":"date"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sSource"'#13#10
(*
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sHeight"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sWeight"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sVitalCapacity"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"s50mRun"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sStandingLongJump"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sSeatedForwardBend"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"s800mRun"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"s1000mRun"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sOneminSitups"'#13#10
        +'        },'#13#10
        +'        {'#13#10
        +'            "name":"sPullup"'#13#10
*)
        +'        }'#13#10
        +'    ]'#13#10
        +'}'
    );

    //先清空bop_excel表
    FDQuery1.ExecSQL('TRUNCATE TABLE sys_student');

    //将Excel数据导入到bop_excel表中
    exImportFromFile(ExtractFilePath(application.ExeName)+'media\system\gms\'+sFileName,FDQuery1,joConfig);

    //<-----创建班级列表
    //清空 sys_department表
    FDQuery1.ExecSQL('TRUNCATE TABLE sys_Department');

    //查询出年级和班级单独项
    FDQuery1.Open(
        'SELECT'#13#10
        +'    GradePart,'#13#10
        +'    ClassPart,'#13#10
        +'    eGradeNum,'#13#10
        +'    eClassNum'#13#10
        +'FROM'#13#10
        +'    ('#13#10
        +'SELECT DISTINCT'#13#10
        +'    eClassName,'#13#10
        +'    eGradeNum,'#13#10
        +'    eClassNum,'#13#10
        +'    SUBSTRING( eClassName, 1, CHARINDEX ( ''级'', eClassName ) ) AS GradePart,'#13#10
        +'    SUBSTRING( eClassName, CHARINDEX ( ''级'', eClassName ) + 1, LEN ( eClassName ) ) AS ClassPart,'#13#10
        +'    CAST( REPLACE ( SUBSTRING( eClassName, 3, CHARINDEX ( ''级'', eClassName ) - 3 ), ''初中'', '''' ) AS INT ) AS YearNumber,'#13#10
        +'    CAST('#13#10
        +'    REPLACE ( SUBSTRING( eClassName, CHARINDEX ( ''级'', eClassName ) + 1, LEN ( eClassName ) ), ''班'', '''' ) AS INT'#13#10
        +'    ) AS ClassNumber'#13#10
        +'FROM'#13#10
        +'    bop_excel'#13#10
        +'    ) AS T'#13#10
        +'ORDER BY'#13#10
        +'    YearNumber DESC,'#13#10
        +'    ClassNumber;'
    );

    //创建根节点
    FDQuery1.Connection.ExecSQL('INSERT INTO sys_Department(dNo,dName) VALUES(''01'',''所有'');');

    //
    sOldGrade   := '';
    iGradeId    := 1;
    iClassId    := 1;
    sSQL        := '';
    while not FDQuery1.Eof do begin
        //创建年级
        if sOldGrade <> FDQuery1.FieldByName('GradePart').AsString then begin
            //取得当前年级名称
            sOldGrade   := FDQuery1.FieldByName('GradePart').AsString;

            //更新SQL
            sSQL    := sSQL + 'INSERT INTO sys_Department(dNo,dNumber,dName)'
                    +' VALUES('''+Format('01%.2d',[iGradeId])+''','''+FDQuery1.FieldByName('eGradeNum').AsString+''','''+sOldGrade+''');';

            //
            Inc(iGradeId);
            iClassId    := 1;
        end;

        //创建班级,更新SQL
        sSQL    := sSQL + 'INSERT INTO sys_Department(dNo,dNumber,dName)'
                +' VALUES('''+Format('01%.2d%.2d',[iGradeId-1,iClassId])+''','''+FDQuery1.FieldByName('eClassNum').AsString+''','''+FDQuery1.FieldByName('ClassPart').AsString+''');';

        //
        Inc(iClassId);

        //
        FDQuery1.Next;
    end;
    FDQuery1.Connection.ExecSQL(sSQL);
    //----->

    //<-----更新学生名单
    //清空学生名单表 sys_student
    //FDQuery1.Connection.ExecSQL('TRUNCATE TABLE sys_student;');

    //

    //----->


    //
    dwMessage('导入成功!请重新载入!','success',self);

end;

procedure TForm_sys_Student.FormShow(Sender: TObject);
var
    joConfig    : Variant;
begin
    //设置当前数据库连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //根据uDepartmentId更新uDepartmentNo
    UpdateNos;

    //
    UpdateView;

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin
        //隐藏学生信息表格
        Pn1.Visible     := False;

        //班级列表全屏
        PnL.Align       := alClient;

        //
        Caption         := '年级/班级';

        //功能按钮只显示图标, 不显示标题
        //cpSetButtonCaption(Pn1,0);

        //
        BtConv.Width    := 70;
        BtConv.Caption  := '重置';
    end;

    //初始化CrudPanel
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');

    //插入自定义按钮
    cpAddInButtons(Pn1,BtConv);
    BtConv.Left             := 999;
    BtConv.Margins.Right    := 10;

    //
    PnConfirm.BevelKind := bkNone;

end;



procedure TForm_sys_Student.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    sSQL        : String;
    oFDQuery    : TFDQuery;
begin
    case X of

        //----- 新增或编辑后, 根据当前uDepartmentNo 更新 uDepartmentId
        cpAppendPostAfter, cpEditPostAfter : begin
            //
            oFDQuery    := cpGetFDQuery(Pn1);

            //
            sSQL    := ''
                    +' UPDATE sys_Student'
                    +' SET sClassId = (SELECT dId FROM sys_Department WHERE sys_Department.dNo = sys_User.sClassId)'
                    +' WHERE sId = XXXXX;';
            sSQL    := StringReplace(sSQL,'XXXXX',IntToStr(oFDQuery.FieldByName('sid').AsInteger),[]);

            //
            //TForm1(Self.Owner).FDConnection1.ExecSQL(sSQL);

        end;
    end;
end;

procedure TForm_sys_Student.TVChange(Sender: TObject; Node: TTreeNode);
var
    iDID        : Integer;
    sWhere      : String;
    //
    joHistory   : Variant;
begin
    //取得过滤条件
    case Node.Level of
        0 : begin   //所有
            sWHERE  := '';
        end;
        1 : begin   //年级
            //先找到当前部门节点的dId值, 保存在 Node.StateIndex 中
            iDID    := Node.StateIndex;
            //找到对应的数据表记录
            FDQuery1.Open('SELECT dNumber FROM sys_Department WHERE dId='+IntToStr(idID));
            //根据 编号dNumber(年级编号) 过滤学生
            sWhere  := '(sGradeNum = '''+FDQuery1.Fields[0].AsString+''')';
        end;
        2 : begin   //班级
            //先找到当前部门节点的dId值, 保存在 Node.StateIndex 中
            iDID    := Node.StateIndex;
            //找到对应的数据表记录
            FDQuery1.Open('SELECT dNumber FROM sys_Department WHERE dId='+IntToStr(idID));
            //根据 编号dNumber(班级编号) 过滤学生
            sWhere  := '(sClassNum = '''+FDQuery1.Fields[0].AsString+''')';
        end;
    end;

    //
    cpSetExtraWhere(Pn1,sWhere);
    cpUpdate(Pn1);

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin
        //隐藏学生信息表格
        Pn1.Visible     := True;
        Pn1.Align       := alClient;

        //班级列表全屏
        PnL.Visible     := False;

        //
        with TForm1(self.Owner) do begin
            //显示标题
            LT.Caption   := '学生信息';

            //为当前操作添加记录
            dwAddShowHistory(Self,[PnL],[Pn1],'年级/班级');
        end;
    end;

end;

end.
