unit unit_sys_ClassStudent;

interface

uses
    //deweb基础函数
    dwBase,

    //deweb快速增删改查单元
    //dwQuickCrud,
    dwCrudPanel,

    //基础单元
    dwfBase,

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
  TForm_sys_ClassStudent = class(TForm)
    FDQuery1: TFDQuery;
    P_L: TPanel;
    TV: TTreeView;
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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



procedure TForm_sys_ClassStudent.UpdateNos;
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

procedure TForm_sys_ClassStudent.UpdateView;
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

procedure TForm_sys_ClassStudent.FormShow(Sender: TObject);
begin
    //设置当前数据库连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //根据uDepartmentId更新uDepartmentNo
    UpdateNos;

    //
    UpdateView;

    //
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,false,'');

end;



procedure TForm_sys_ClassStudent.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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

procedure TForm_sys_ClassStudent.TVChange(Sender: TObject; Node: TTreeNode);
var
    iDID    : Integer;
    sWhere  : String;
begin
    //取得过滤条件
    case Node.Level of
        0,1 : begin
            sWHERE  := '';
        end;
        2 : begin
            //先找到当前部门节点的dId值, 保存在 Node.StateIndex 中
            iDID    := Node.StateIndex;
            //找到对应的数据表记录
            FDQuery1.Open('SELECT dNumber FROM sys_Department WHERE dId='+IntToStr(idID));
            //根据 编号dNumber(年级编号) 过滤学生
            sWhere  := '(sGradeNum = '''+FDQuery1.Fields[0].AsString+''')';
        end;
        3 : begin
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
end;

end.
