unit unit_sys_Department;

interface

uses
    //deweb基础函数
    dwBase,

    //
    dwfBase,

    //
    dwDBEditor,

    //浏览器历史记录控制单元
    dwHistory,

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
    PnL: TPanel;
    TV: TTreeView;
    PnNew: TPanel;
    LaNewTitle: TLabel;
    LaNewParent: TLabel;
    LaNewName: TLabel;
    EtNewName: TEdit;
    Pn1: TPanel;
    PnTT: TPanel;
    BtDAdd: TButton;
    BtDDelete: TButton;
    BtDChild: TButton;
    BtMoveUp: TButton;
    BtMoveDown: TButton;
    BtEdit: TButton;
    PnSimple: TPanel;
    LaSimple: TLabel;
    procedure FormShow(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure BtDAddClick(Sender: TObject);
    procedure B_DPCancelClick(Sender: TObject);
    procedure BtDChildClick(Sender: TObject);
    procedure B_DEditClick(Sender: TObject);
    procedure BtDDeleteClick(Sender: TObject);
    procedure BtMoveDownClick(Sender: TObject);
    procedure BtMoveUpClick(Sender: TObject);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure PnNewEnter(Sender: TObject);
    procedure BtEditClick(Sender: TObject);
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
    TreeViewToDB(TV,FDQuery1,'sys_department', 'dId', 'dcode');
    //
    deUpdate(Pn1,'(did = '+IntTostr(TV.Selected.StateIndex)+')');
end;

procedure TForm_sys_Department.BtMoveDownClick(Sender: TObject);
begin
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    MoveTreeNodeDown(TV.Selected);

    //根据树, 更新数据表
    TreeViewToDB(TV,FDQuery1,'sys_department', 'dId', 'dcode');

    //
    deUpdate(Pn1,'(did = '+IntTostr(TV.Selected.StateIndex)+')');
end;

procedure TForm_sys_Department.BtDAddClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    //== 增加门店

    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    //
    if tnNode.Level>0 then begin
        tnNode  := tnNode.Parent;
    end;
    //得到父门店ID
    giPID   := tnNode.StateIndex;

    //得到父门店名称
    sName   := tnNode.Text;
    while tnNode.Level>1 do begin
        tnNode  := tnNode.Parent;
        sName   := tnNode.Text+' -> '+sName;
    end;
    LaNewParent.Caption := '父门店名称：'+sName;
    LaNewName.Caption   := '新门店名称：';

    //
    LaNewTitle.Caption  := '增加门店';
    EtNewName.Text      := '新门店';
    PnNew.Visible   := True;
    //
    EtNewName.Visible   := True;
    LaNewParent.Visible := True;
    LaNewParent.Top     := 70;

    //标记为增加，用于在“确定”按钮时分别处理
    PnNew.Tag      := 0;

end;

procedure TForm_sys_Department.B_DEditClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    LaNewTitle.Caption  := '编辑门店';
    //
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    sName   := tnNode.Text;
    LaNewParent.Visible := False;
    LaNewName.Caption   := '新门店名称：';

    //
    EtNewName.Text      := sName;
    EtNewName.Visible   := True;
    //标记为编辑
    PnNew.Tag           := 1;
    //
    PnNew.Visible   := True;
end;

procedure TForm_sys_Department.BtDDeleteClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    LaNewTitle.Caption  := '删除门店';

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
    LaNewParent.Visible := True;
    LaNewParent.Top     := 70;
    LaNewParent.Caption := '门店名称：'+sName;
    LaNewName.Top       := 110;
    LaNewName.Caption   := '注：删除门店将同时删除当前门店以及子门店的所有员工！';

    //
    EtNewName.Visible   := False;
    //标记为编辑
    PnNew.Tag       := 2;
    //
    PnNew.Visible   := True;

end;

procedure TForm_sys_Department.BtEditClick(Sender: TObject);
begin
    //隐藏左侧的门店树
    PnL.Visible := False;

    //显示右侧的信息编辑面板
    Pn1.Visible := True;
    Pn1.Align   := alclient;

    //更新主界面设计
    with TForm1(self.Owner) do begin
        //显示标题
        LT.Caption   := '门店信息';

        //为当前操作添加记录
        dwAddShowHistory(Self,[PnL],[Pn1],'门店管理');
    end;
end;

procedure TForm_sys_Department.BtDChildClick(Sender: TObject);
var
    sName   : String;
    tnNode  : TTreeNode;
begin
    LaNewTitle.Caption  := '增加门店';
    //
    if TV.Selected = nil then begin
        TV.Items[0].Selected    := True;
    end;
    //
    tnNode  := TV.Selected;
    giPID   := tnNode.StateIndex;   //父门店ID
    //
    sName   := tnNode.Text;
    while tnNode.Level>1 do begin
        tnNode  := tnNode.Parent;
        sName   := tnNode.Text+' -> '+sName;
    end;
    LaNewParent.Caption := '父门店名称：'+sName;
    LaNewName.Caption   := '新门店名称：';

    //
    EtNewName.Text      := '新门店';
    EtNewName.Visible   := True;
    EtnewName.Top       := 160;
    //
    LaNewParent.Visible := True;
    LaNewParent.Top     := 70;
    //
    PnNew.Visible   := True;

    //标记为增加子门店
    PnNew.Tag       := 3;
end;

procedure TForm_sys_Department.B_DPCancelClick(Sender: TObject);
begin
    PnNew.Visible   := False;
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
    //将门店表sys_Store转化为树
    dwfQueryToTreeView(FDQuery1,'sys_department','dcode','dname','did',TV);

    //全部展开
    TV.Items[0].Expand(True);
end;

procedure TForm_sys_Department.FormShow(Sender: TObject);
var
    iItem   : Integer;
begin
    //设置当前数据库连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //创建 信息编辑框 DBEditor
    deInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');

    //
    UpdateView;

    //显示简要信息
    FDQuery1.Open('SELECT dname,dtype,dregion,daddress,dphone,dstatus FROM sys_department WHERE did = '+IntTostr(TV.Items[0].StateIndex));
    //
    LaSimple.Caption   := FDQuery1.Fields[0].AsString;
    for iItem := 1 to FDQuery1.FieldCount - 1 do begin
        if FDQuery1.Fields[iItem].AsString <> '' then begin
            LaSimple.Caption    := LaSimple.Caption + '，' + FDQuery1.Fields[iItem].AsString;
        end;
    end;

    //移动端处理
    //if TForm1(self.Owner).gbMobile then begin
    //    PnL.Align       := alClient;
    //    Pn1.Visible     := True;
    //    BtEdit.Visible  := True;
    //    BtEdit.Left     := BtMoveDown.Left - 30;
    //end;
end;

procedure TForm_sys_Department.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oFDQuery    : TFDQuery;
begin
    case X of
        deEditPostAfter : begin
            if TV.Selected <> nil then begin
                oFDQuery    := deGetFDQuery(Pn1);
                TV.Selected.Text    := oFDQuery.FieldByName('dname').AsString;
            end;
        end;
    end;
end;

procedure TForm_sys_Department.PnNewEnter(Sender: TObject);
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
    case TPanel(Sender).Tag of
        0 : begin       //增加门店--------------------------------------------------------------------------------------
            //生成SQL
            sSQL    := ''
                    +' DECLARE @NewDId INT;'

                    +' INSERT INTO sys_user (dname, dcreatetime)'
                    +' VALUES (''XXXXX'',  GETDATE());'

                    +' SET @NewDId = SCOPE_IDENTITY();'

                    +' SELECT @NewDId AS NewDId;';

            sSQL    := StringReplace(sSQL,'XXXXX',EtNewName.Text,[]);
            //sSQL    := StringReplace(sSQL,'YYYYY',IntToStr(TForm1(self.Owner).gjoUserInfo.id),[]);

            //插入记录,并返回dId
            FDQuery1.Open(sSQL);
            idId    := FDQuery1.Fields[0].AsInteger;

            //添加树节点
            if TV.Selected.Level = 0 then begin
                tnNode  := TV.Items.AddChild(TV.Selected,EtNewName.Text);
                tnNode.StateIndex   := idId;
            end else begin
                tnNode  := TV.Items.AddChild(TV.Selected.Parent,EtNewName.Text);
                tnNode.StateIndex   := idId;
            end;

            //根据树, 更新数据表
            TreeViewToDB(TV,FDQuery1,'sys_department', 'did', 'dcode');

            //
            deUpdate(Pn1,'did='+IntToStr(idId));
        end;
        1 : begin       //编辑门店名称----------------------------------------------------------------------------------
        end;
        2 : begin       //删除门店--------------------------------------------------------------------------------------
            //取得WHERE
            tnNode      := TV.Selected;
            sWhere      := '(eStoreId = '+IntTostr(tnNode.StateIndex)+')';
            _GetWhere(tnNode,'eStoreId',sWHERE);

            sWhereDep   := '(did = '+IntTostr(tnNode.StateIndex)+')';
            _GetWhere(tnNode,'did',sWhereDep);

            //删除当前门店/子门店的所有员工 和 当前门店/子门店
            sSQL    :=
                    'DELETE FROM fwEmployee '
                    +'WHERE '+sWHERE+';'
                    +'DELETE FROM sys_department '
                    +'WHERE '+sWhereDep+';';
            TForm1(self.Owner).FDConnection1.ExecSQL(sSQL);

            //删除树节点
            tnNode.Destroy;
        end;
        3 : begin       //增加子门店------------------------------------------------------------------------------------
            //生成SQL
            sSQL    := ''
                    +' DECLARE @NewDId INT;'
                    +' INSERT INTO sys_department (dname, dcreatetime)'
                    +' VALUES (''XXXXX'',  GETDATE());'
                    +' SET @NewDId = SCOPE_IDENTITY();'
                    +' SELECT @NewDId AS NewDId;';

            sSQL    := StringReplace(sSQL,'XXXXX',EtNewName.Text,[]);
            //sSQL    := StringReplace(sSQL,'YYYYY',IntToStr(TForm1(self.Owner).gjoUserInfo.id),[]);

            //插入记录,并返回dId
            FDQuery1.Open(sSQL);
            idId    := FDQuery1.Fields[0].AsInteger;

            //添加树节点
            tnNode  := TV.Items.AddChild(TV.Selected,EtNewName.Text);
            tnNode.StateIndex   := idId;
            //
            tnNode.Parent.Expand(False);

            //根据树, 更新数据表
            TreeViewToDB(TV,FDQuery1,'sys_department', 'did', 'dcode');

            //
            deUpdate(Pn1,'did='+IntToStr(idId));
        end;
    end;

    //
    PnNew.Visible   := False;
    //
    //UpdateView;
    //
    //DockSite    := True;
end;

procedure TForm_sys_Department.TVChange(Sender: TObject; Node: TTreeNode);
var
    iItem   : Integer;
begin
    //
    deUpdate(Pn1,'(did = '+IntTostr(Node.StateIndex)+')');

    //显示简要信息
    FDQuery1.Open('SELECT dname,dtype,dregion,daddress,dphone,dstatus FROM sys_department WHERE did = '+IntTostr(Node.StateIndex));
    //
    LaSimple.Caption   := FDQuery1.Fields[0].AsString;
    for iItem := 1 to FDQuery1.FieldCount - 1 do begin
        if FDQuery1.Fields[iItem].AsString <> '' then begin
            LaSimple.Caption    := LaSimple.Caption + '，' + FDQuery1.Fields[iItem].AsString;
        end;
    end;

end;

end.
