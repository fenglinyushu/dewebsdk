unit unit_sys_Department;

interface

uses
    //deweb基础函数
    dwBase,

    //
    dwfBase,

    //
    dwDBEditor,

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
  TForm_sys_Department = class(TForm)
    FDQuery1: TFDQuery;
    P_L: TPanel;
    TV: TTreeView;
    P_New: TPanel;
    L_NewTitle: TLabel;
    Panel2: TPanel;
    B_DPCancel: TButton;
    B_DPOK: TButton;
    L_NewParent: TLabel;
    L_NewName: TLabel;
    E_NewName: TEdit;
    Pn1: TPanel;
    PnTT: TPanel;
    B_DAdd: TButton;
    B_DDelete: TButton;
    B_DChild: TButton;
    BtMoveUp: TButton;
    BtMoveDown: TButton;
    procedure FormShow(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure B_DAddClick(Sender: TObject);
    procedure B_DPCancelClick(Sender: TObject);
    procedure B_DChildClick(Sender: TObject);
    procedure B_DEditClick(Sender: TObject);
    procedure B_DDeleteClick(Sender: TObject);
    procedure B_DPOKClick(Sender: TObject);
    procedure BtMoveDownClick(Sender: TObject);
    procedure BtMoveUpClick(Sender: TObject);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
  public
        giPID       : Integer;  //父节点ID
        procedure UpdateView;
        procedure TreeViewToDB(ATV:TTreeView;AFDQuery:TFDQuery;ATable,AId,ANo:String);
  end;


implementation

uses
    Unit1;

{$R *.dfm}

// 上移节点函数
function MoveTreeNodeUp(ANode: TTreeNode): Boolean;
var
    PrevSibling: TTreeNode;
begin
    Result := False;
    if not Assigned(ANode) then Exit;

    // 获取前一个兄弟节点
    PrevSibling := ANode.GetPrevSibling;

    if Assigned(PrevSibling) then
    begin
        // 移动节点到前一个兄弟节点之前
        ANode.MoveTo(PrevSibling, naInsert);
        Result := True;
    end;

    //
    ANode.Selected  := True;
end;

// 下移节点函数
function MoveTreeNodeDown(ANode: TTreeNode): Boolean;
var
    NextSibling: TTreeNode;
    ParentNode: TTreeNode;
begin
    Result := False;
    if not Assigned(ANode) then Exit;

    // 获取下一个兄弟节点
    NextSibling := ANode.GetNextSibling;

    if Assigned(NextSibling) then
    begin
        // 获取下下一个兄弟节点（用于插入位置）
        NextSibling := NextSibling.GetNextSibling;

        if Assigned(NextSibling) then
        begin
            // 插入到下下一个兄弟节点之前
            ANode.MoveTo(NextSibling, naInsert);
        end
        else
        begin
            // 移动到父节点末尾
            ParentNode := ANode.Parent;
            if Assigned(ParentNode) then
            begin
                ANode.MoveTo(ParentNode, naAddChild);
            end
            else
            begin
                // 根节点移动到TreeView末尾
                ANode.MoveTo(nil, naAdd);
            end;
        end;
        Result := True;
    end;

    //
    ANode.Selected  := True;
end;

//取得节点的WHERE
procedure _GetWhere(ANode:TTreeNode;AField:String;var AWhere:String);
var
    I  : Integer;
begin
    for I := 0 to ANode.Count-1 do begin
        AWhere  := AWhere + ' OR (' + AField + ' = '+IntTostr(ANode.Item[I].StateIndex)+')';
        _GetWhere(ANode.Item[I],AField,AWHERE);
    end;
end;


procedure TForm_sys_Department.BtMoveUpClick(Sender: TObject);
begin
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    MoveTreeNodeUp(TV.Selected);

    //根据树, 更新数据表
    TreeViewToDB(TV,FDQuery1,'sys_Department', 'dId', 'dNo');
    //
    deUpdate(Pn1,'(dId = '+IntTostr(TV.Selected.StateIndex)+')');
end;

procedure TForm_sys_Department.BtMoveDownClick(Sender: TObject);
begin
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    MoveTreeNodeDown(TV.Selected);

    //根据树, 更新数据表
    TreeViewToDB(TV,FDQuery1,'sys_Department', 'dId', 'dNo');

    //
    deUpdate(Pn1,'(dId = '+IntTostr(TV.Selected.StateIndex)+')');
end;

procedure TForm_sys_Department.B_DAddClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    //== 增加单位

    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    //
    if tnNode.Level>0 then begin
        tnNode  := tnNode.Parent;
    end;
    //得到父单位ID
    giPID   := tnNode.StateIndex;

    //得到父单位名称
    sName   := tnNode.Text;
    while tnNode.Level>1 do begin
        tnNode  := tnNode.Parent;
        sName   := tnNode.Text+' -> '+sName;
    end;
    L_NewParent.Caption := '父单位名称：'+sName;
    L_NewName.Caption   := '新单位名称：';

    //
    L_NewTitle.Caption  := '增加单位';
    E_NewName.Text      := '班';
    P_New.Visible   := True;
    //
    E_NewName.Visible   := True;
    L_NewParent.Visible := True;
    L_NewParent.Top     := 70;

    //标记为增加，用于在“确定”按钮时分别处理
    B_DPOK.Tag      := 0;

end;

procedure TForm_sys_Department.B_DEditClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    L_NewTitle.Caption  := '编辑单位';
    //
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    sName   := tnNode.Text;
    L_NewParent.Visible := False;
    L_NewName.Caption   := '新单位名称：';

    //
    E_NewName.Text      := sName;
    E_NewName.Visible   := True;
    //标记为编辑
    B_DPOK.Tag      := 1;
    //
    P_New.Visible   := True;
end;

procedure TForm_sys_Department.B_DPOKClick(Sender: TObject);
var
    sSQL        : String;
    sWHERE      : String;
    sWHEREDep   : String;
    sParent     : String;   //默认的父dept_id
    sDefault    : String;   //默认的dept_id
    sLen        : String;   //默认的dept_id的字符串长度
    //
    idId        : Integer;

    //
    tnNode      : TTreeNode;
begin
    case TButton(Sender).Tag of
        0 : begin       //增加单位--------------------------------------------------------------------------------------
            //生成SQL
            sSQL    := ''
                    +' DECLARE @NewDId INT;'

                    +' INSERT INTO sys_Department (dName, dCreatorId, dCreateTime)'
                    +' VALUES (''XXXXX'', YYYYY, GETDATE());'

                    +' SET @NewDId = SCOPE_IDENTITY();'

                    +' SELECT @NewDId AS NewDId;';

            sSQL    := StringReplace(sSQL,'XXXXX',E_NewName.Text,[]);
            sSQL    := StringReplace(sSQL,'YYYYY',IntToStr(TForm1(self.Owner).gjoUserInfo.id),[]);

            //插入记录,并返回dId
            FDQuery1.Open(sSQL);
            idId    := FDQuery1.Fields[0].AsInteger;

            //添加树节点
            if TV.Selected.Level = 0 then begin
                tnNode  := TV.Items.AddChild(TV.Selected,E_NewName.Text);
                tnNode.StateIndex   := idId;
            end else begin
                tnNode  := TV.Items.AddChild(TV.Selected.Parent,E_NewName.Text);
                tnNode.StateIndex   := idId;
            end;
            tnNode.Selected := True;

            //根据树, 更新数据表
            TreeViewToDB(TV,FDQuery1,'sys_Department', 'dId', 'dNo');

            //
            deUpdate(Pn1,'dId='+IntToStr(idId));
        end;
        1 : begin       //编辑单位名称----------------------------------------------------------------------------------
        end;
        2 : begin       //删除单位--------------------------------------------------------------------------------------
            //取得WHERE
            tnNode      := TV.Selected;
            sWhere      := '(uDepartmentId = '+IntTostr(tnNode.StateIndex)+')';
            _GetWhere(tnNode,'uDepartmentId',sWHERE);

            sWhereDep   := '(dId = '+IntTostr(tnNode.StateIndex)+')';
            _GetWhere(tnNode,'dId',sWhereDep);

            //删除当前单位/子单位的所有员工 和 当前单位/子单位
            sSQL    :=
                    'DELETE FROM sys_User '
                    +'WHERE '+sWHERE+';'
                    +'DELETE FROM sys_Department '
                    +'WHERE '+sWhereDep+';';
            TForm1(self.Owner).FDConnection1.ExecSQL(sSQL);

            //删除树节点
            tnNode.Destroy;
        end;
        3 : begin       //增加子单位------------------------------------------------------------------------------------
            //生成SQL
            sSQL    := ''
                    +' DECLARE @NewDId INT;'
                    +' INSERT INTO sys_Department (dName, dCreatorId, dCreateTime)'
                    +' VALUES (''XXXXX'', YYYYY, GETDATE());'
                    +' SET @NewDId = SCOPE_IDENTITY();'
                    +' SELECT @NewDId AS NewDId;';

            sSQL    := StringReplace(sSQL,'XXXXX',E_NewName.Text,[]);
            sSQL    := StringReplace(sSQL,'YYYYY',IntToStr(TForm1(self.Owner).gjoUserInfo.id),[]);

            //插入记录,并返回dId
            FDQuery1.Open(sSQL);
            idId    := FDQuery1.Fields[0].AsInteger;

            //添加树节点
            tnNode  := TV.Items.AddChild(TV.Selected,E_NewName.Text);
            tnNode.StateIndex   := idId;
            //
            tnNode.Parent.Expand(False);
            tnNode.Selected := True;

            //根据树, 更新数据表
            TreeViewToDB(TV,FDQuery1,'sys_Department', 'dId', 'dNo');

            //
            deUpdate(Pn1,'dId='+IntToStr(idId));
        end;
    end;

    //
    P_New.Visible   := False;
    //
    //UpdateView;
    //
    //DockSite    := True;
end;

procedure TForm_sys_Department.B_DDeleteClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    L_NewTitle.Caption  := '删除单位';

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
    L_NewParent.Caption := '单位名称：'+sName;
    L_NewName.Top       := 110;
    L_NewName.Caption   := '注：删除单位将同时删除当前单位以及子单位的所有员工！';

    //
    E_NewName.Visible   := False;
    //标记为编辑
    B_DPOK.Tag      := 2;
    //
    P_New.Visible   := True;

end;

procedure TForm_sys_Department.B_DChildClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    L_NewTitle.Caption  := '增加单位';
    //
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    giPID   := tnNode.StateIndex;   //父单位ID
    //
    sName   := tnNode.Text;
    while tnNode.Level>1 do begin
        tnNode  := tnNode.Parent;
        sName   := tnNode.Text+' -> '+sName;
    end;
    L_NewParent.Caption := '父单位名称：'+sName;
    L_NewName.Caption   := '新单位名称：';

    //
    E_NewName.Text      := '班';
    E_NewName.Visible   := True;
    E_newName.Top       := 160;
    //
    L_NewParent.Visible := True;
    L_NewParent.Top     := 70;
    //
    P_New.Visible   := True;

    //标记为增加子单位
    B_DPOK.Tag      := 3;
end;

procedure TForm_sys_Department.B_DPCancelClick(Sender: TObject);
begin
    P_New.Visible   := False;
end;


procedure TForm_sys_Department.TreeViewToDB(ATV: TTreeView; AFDQuery: TFDQuery; ATable, AId, ANo: String);
var
    iItem       : Integer;
    tnNode      : TTreeNode;

    //
    procedure _UpdateItem(ANode:TTreeNode;ACurrNo:String);
    var
        iiItem  : Integer;
    begin
        //先更新当前节点
        if not AFDQuery.Locate(AId,ANode.StateIndex,[]) then begin
            Exit;
        end else begin
            AFDQuery.Edit;
            AFDQuery.FieldByName(ANo).AsString  := ACurrNo;
            AFDQuery.Post;
        end;

        //再递归更新子节点
        for iiItem := 0 to ANode.Count - 1 do begin
            _UpdateItem(ANode.Item[iiItem], ACurrNo + Format('%.2d',[iiItem+1]));
        end;
    end;
begin
    //::::: 将TreeView的节点, 按照树的规律生成编号字段

    try
        //
        if ATV.Items.Count = 0 then begin
            Exit;
        end;

        //
        AFDQuery.Open('SELECT * FROM '+ ATable);

        //
        tnNode  := ATV.Items[0];

        //递归更新节点
        _UpdateItem(tnNode,'01');


    except
        dwRunJS('console.log("error when TreeViewToDB!");',TForm(AFDQuery.Owner));
    end;

end;

procedure TForm_sys_Department.UpdateView;
begin
    //将单位表sys_Department转化为树
    dwfQueryToTreeView(FDQuery1,'sys_Department','dNo','dName','dId',TV);

    //全部展开
    TV.Items[0].Expand(True);
end;

procedure TForm_sys_Department.FormShow(Sender: TObject);
begin
    //设置当前数据库连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //
    deInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');

    //
    UpdateView;
end;

procedure TForm_sys_Department.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oFDQuery    : TFDQuery;
begin
    case X of
        deEditPostAfter : begin
            if TV.Selected <> nil then begin
                oFDQuery    := deGetFDQuery(Pn1);
                TV.Selected.Text    := oFDQuery.FieldByName('dName').AsString;
            end;
        end;
    end;
end;

procedure TForm_sys_Department.TVChange(Sender: TObject; Node: TTreeNode);
begin
    //
    deUpdate(Pn1,'(dId = '+IntTostr(Node.StateIndex)+')');

end;

end.
