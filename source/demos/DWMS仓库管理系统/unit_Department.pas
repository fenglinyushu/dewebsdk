unit unit_Department;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb增删改查面板单元
    dwCrudPanel,
    //
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
  TForm_Department = class(TForm)
    FQ1: TFDQuery;
    P_L: TPanel;
    TV: TTreeView;
    P_LB: TPanel;
    B_DAdd: TButton;
    B_DEdit: TButton;
    B_DDelete: TButton;
    B_DChild: TButton;
    P_New: TPanel;
    L_NewTitle: TLabel;
    Panel2: TPanel;
    B_DPCancel: TButton;
    B_DPOK: TButton;
    L_NewParent: TLabel;
    L_NewName: TLabel;
    E_NewName: TEdit;
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure B_DAddClick(Sender: TObject);
    procedure B_DPCancelClick(Sender: TObject);
    procedure B_DChildClick(Sender: TObject);
    procedure B_DEditClick(Sender: TObject);
    procedure B_DDeleteClick(Sender: TObject);
    procedure B_DPOKClick(Sender: TObject);
  private
    { Private declarations }
  public
        gjoDept     : Variant;  //部门表的JSON
        gsID        : String;   //当前树节点的ID
        procedure UpdateView;
        function  GetNodedId(ANode:TTreeNode):String;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

function  TForm_Department.GetNodedId(ANode:TTreeNode):String;
var
    iItem       : Integer;
    iIds        : array of Integer;
    joNode      : Variant;
begin
    //生成树的层次index序列
    SetLength(iIds,ANode.Level);
    while ANode.Level>0 do begin
        iIds[ANode.Level-1] := ANode.Index;
        ANode  := ANode.Parent;
    end;

    //取得对应的JSOn
    joNode  := gjoDept._(0);
    for iItem := 0 to High(iIds) do begin
        joNode  := joNode.children._(iIds[iItem]);
    end;

    //取得当前节点对应数据表记录的did
    Result  := joNode.id;
end;


procedure TForm_Department.B_DAddClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    //== 增加部门

    //
    tnNode  := TV.Selected;

    if (tnNode = nil) or (tnNode.Level = 0) then begin
        dwMessage('请选择一个非根节点后再增加!','error',self);
        Exit;
    end;

    //得到父部门名称
    tnNode  := tnNode.Parent;
    sName   := tnNode.Text;
    while tnNode.Level>1 do begin
        tnNode  := tnNode.Parent;
        sName   := tnNode.Text+' -> '+sName;
    end;
    L_NewParent.Caption := '父部门名称：'+sName;
    L_NewName.Caption   := '新部门名称：';

    //
    L_NewTitle.Caption  := '增加部门';
    E_NewName.Text      := '新部门';
    P_New.Visible   := True;
    //
    E_NewName.Visible   := True;
    L_NewParent.Visible := True;
    L_NewParent.Top     := 70;

    //标记为增加，用于在“确定”按钮时分别处理
    B_DPOK.Tag      := 0;

end;

procedure TForm_Department.B_DEditClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    L_NewTitle.Caption  := '编辑部门';
    //
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    sName   := tnNode.Text;
    L_NewParent.Visible := False;
    L_NewName.Caption   := '新部门名称：';

    //
    E_NewName.Text      := sName;
    E_NewName.Visible   := True;
    //标记为编辑
    B_DPOK.Tag      := 1;
    //
    P_New.Visible   := True;
end;

procedure TForm_Department.B_DPOKClick(Sender: TObject);
var
    sSQL        : String;
    sDID        : string;

    //
    tnNode      : TTreeNode;
begin
    case TButton(Sender).Tag of
        0 : begin       //增加部门------------------------------------------------------------------
            //=====增加当前节点的兄弟节点
            //步骤:
            //1 取得当前节点的最后兄弟节点的did
            //2 将该did增加1作为新节点的did
            //3 以该did和dname为值插入新记录

            //1 取得当前节点的最后兄弟节点的did
            tnNode  := TV.Selected;
            sDID    := GetNodeDID(tnNode.Parent.GetLastChild);

            //2 将该did增加1作为新节点的did
            sDID    := '0'+IntToStr(StrToInt(sDID)+1);

            //3 以该did和dname为值插入新记录


            //添加数据库记录
            sSQL    := 'INSERT INTO eDepartment(dId,dName) VALUES('''+sDID+''','''+E_NewName.Text+''')';

            FQ1.Close;
            FQ1.SQL.Clear;
            FQ1.SQL.Text   := sSQL;
            FQ1.ExecSQL;

            //更新! 将单位表eDepartment转化为JSON
            gjoDept     :=  cpDbToTreeListJson(FQ1,'eDepartment','dId','dName','',-1);

            //添加树
            TV.Items.AddChild(tnNode.Parent,E_NewName.Text).Selected    := True;
        end;
        1 : begin       //编辑部门名称--------------------------------------------------------------
            //更新树节点
            TV.Selected.Text    := E_NewName.Text;

            //
            tnNode  := TV.Selected;
            sDID    := GetNodeDID(tnNode);

            //更新数据库记录
            sSQL    := 'UPDATE eDepartment '
                    +'SET dName = '''+E_NewName.Text+''' '
                    +'WHERE dId = '''+sDID+'''';

            TForm1(self.Owner).FDConnection1.ExecSQL(sSQL);

            //更新! 将单位表eDepartment转化为JSON
            gjoDept     :=  cpDbToTreeListJson(FQ1,'eDepartment','dId','dName','',-1);
        end;
        2 : begin       //删除部门------------------------------------------------------------------
            //取得WHERE
            tnNode  := TV.Selected;
            sDID    := GetNodeDID(tnNode);

            //删除当前部门/子部门的所有员工 和 当前部门/子部门
            sSQL    :=
                    'DELETE FROM eUser '
                    +'WHERE (uDepartment like '''+sDID+'%'');'
                    +'DELETE FROM eDepartment '
                    +'WHERE (dId like '''+sDID+'%'');';
            TForm1(self.Owner).FDConnection1.ExecSQL(sSQL);
            //删除树节点
            TV.Selected.Destroy;

            //更新! 将单位表eDepartment转化为JSON
            gjoDept     :=  cpDbToTreeListJson(FQ1,'eDepartment','dId','dName','',-1);
        end;
        3 : begin       //增加子部门----------------------------------------------------------------
            //=====增加当前节点的兄弟节点
            //步骤:
            //1 取得当前节点的最后子节点的did ,将该did增加1作为新节点的did
            //2 以该did和dname为值插入新记录


            //1 取得当前节点的最后子节点的did ,将该did增加1作为新节点的did
            tnNode  := TV.Selected;
            if tnNode.Count = 0 then begin
                sDID    := GetNodeDID(tnNode);
                sDID    := sDID+'01';
            end else begin
                sDID    := GetNodeDID(tnNode.GetLastChild);
                sDID    := '0'+IntToStr(StrToInt(sDID)+1);
            end;

            //2 以该did和dname为值插入新记录
            sSQL    := 'INSERT INTO eDepartment(dId,dName) VALUES('''+sDID+''','''+E_NewName.Text+''')';

            FQ1.Close;
            FQ1.SQL.Clear;
            FQ1.SQL.Text   := sSQL;
            FQ1.ExecSQL;

            //更新! 将单位表eDepartment转化为JSON
            gjoDept     :=  cpDbToTreeListJson(FQ1,'eDepartment','dId','dName','',-1);

            //添加树
            TV.Items.AddChild(TV.Selected,E_NewName.Text).Selected    := True;
        end;
    end;

    //
    P_New.Visible   := False;
    //
    //UpdateView;
    //
    //DockSite    := True;
end;

procedure TForm_Department.B_DDeleteClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    L_NewTitle.Caption  := '删除部门';

    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    if tnNode.Level = 0 then begin
        dwMessage('当前不能删除！','error',self);
        Exit;
    end;
    sName   := tnNode.Text;
    L_NewParent.Visible := True;
    L_NewParent.Top     := 70;
    L_NewParent.Caption := '部门名称：'+sName;
    L_NewName.Top       := 110;
    L_NewName.Caption   := '注：删除部门将同时删除当前部门以及子部门的所有员工！';

    //
    E_NewName.Visible   := False;
    //标记为编辑
    B_DPOK.Tag      := 2;
    //
    P_New.Visible   := True;

end;

procedure TForm_Department.B_DChildClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    L_NewTitle.Caption  := '增加部门';
    //
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    //giPID   := tnNode.StateIndex;   //父部门ID
    //
    sName   := tnNode.Text;
    while tnNode.Level>1 do begin
        tnNode  := tnNode.Parent;
        sName   := tnNode.Text+' -> '+sName;
    end;
    L_NewParent.Caption := '父部门名称：'+sName;
    L_NewName.Caption   := '新部门名称：';

    //
    E_NewName.Text      := '新部门';
    E_NewName.Visible   := True;
    E_newName.Top       := 160;
    //
    L_NewParent.Visible := True;
    L_NewParent.Top     := 70;
    //
    P_New.Visible   := True;

    //标记为增加子部门
    B_DPOK.Tag      := 3;
end;

procedure TForm_Department.B_DPCancelClick(Sender: TObject);
begin
    P_New.Visible   := False;
end;


procedure TForm_Department.UpdateView;
var
    iItem       : Integer;
    tnNode      : TTreeNode;
    sName       : String;
    sDId        : String;
    //
    joPair      : Variant;
    joValue     : Variant;
begin
    //将单位表eDepartment转化为JSON
    gjoDept     :=  cpDbToTreeListJson(FQ1,'eDepartment','dId','dName','',-1);

    //将JSON转换化表
    cpTreeListJsonToTV(gjoDept,TV);

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


    //销毁重新CRUD前先移除P_LB
    P_LB.Parent := self;


    //将P_LB移入
    P_LB.Parent := TPanel(FindComponent('PBs'));
    P_LB.Align  := alLeft;
    P_LB.Width  := 300;
    P_LB.Left   := 0;
end;

procedure TForm_Department.FormCreate(Sender: TObject);
begin
    //设置当前数据库连接
    FQ1.Connection := TForm1(Self.Owner).FDConnection1;
end;

procedure TForm_Department.FormShow(Sender: TObject);
begin
    //设置当前数据库连接
    FQ1.Connection := TForm1(Self.Owner).FDConnection1;

    //创建quickcrud
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');

    //
    UpdateView;
end;



procedure TForm_Department.TVChange(Sender: TObject; Node: TTreeNode);
var
    sWhere      : String;
    tnNode      : TTreeNode;
begin
    //
    tnNode  := TV.Selected;

    if tnNode = nil then begin
        Exit;
    end;

    //取得当前节点对应数据表记录的did
    gsId    := GetNodedId(tnNode);
    sWhere  := '(uDepartment like '''+gsId+'%'')';

    //
    cpUpdate(Pn1, sWhere);
end;

end.
