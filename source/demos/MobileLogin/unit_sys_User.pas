unit unit_sys_User;

interface

uses
    //deweb基础函数
    dwBase,

    //deweb快速增删改查单元
    //dwQuickCrud,
    dwCrudPanel,

    //dwframe基础单元
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
  TForm_sys_User = class(TForm)
    FDQuery1: TFDQuery;
    P_L: TPanel;
    TV: TTreeView;
    Pn1: TPanel;
    BtConv: TButton;
    PnHint: TPanel;
    Label1: TLabel;
    BtClose: TButton;
    procedure FormShow(Sender: TObject);
    procedure TVChange(Sender: TObject; Node: TTreeNode);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
    procedure BtConvClick(Sender: TObject);
    procedure TVClick(Sender: TObject);
    procedure BtCloseClick(Sender: TObject);
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



procedure TForm_sys_User.UpdateNos;
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

procedure TForm_sys_User.UpdateView;
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
    //将单位表dwDepartment转化为树
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

procedure TForm_sys_User.BtCloseClick(Sender: TObject);
begin
    PnHint.Visible  := False;
end;

procedure TForm_sys_User.BtConvClick(Sender: TObject);
var
    oSGD        : TStringGrid;
    //
    iRow        : Integer;
    iCount      : Integer;
begin
    oSGD        := cpGetStringGrid(Pn1);

    //
    iCount      := 0;
    for iRow := 1 to oSGD.RowCount - 1 do begin
        if oSGD.Cells[0,iRow] = 'true' then begin
            Inc(iCount);
        end;
    end;

    //如果选择了批量设置部门,则弹出提示框
    if iCount > 0 then begin
        PnHint.Visible  := True;
    end else begin
        dwMessage('请选择拟设置的用户!','error',self);
    end;

end;

procedure TForm_sys_User.FormShow(Sender: TObject);
begin
    //设置当前数据库连接
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //根据uDepartmentId更新uDepartmentNo
    UpdateNos;

    //
    UpdateView;

    //UpdateView;
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,false,'');

    //插入"批量设置部门"按钮
    cpAddInButtons(Pn1,BtConv);
    BtConv.Left     := 999;
end;



procedure TForm_sys_User.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
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
                    +' UPDATE sys_User'
                    +' SET uDepartmentId = (SELECT dId FROM sys_Department WHERE sys_Department.dNo = sys_User.uDepartmentNo)'
                    +' WHERE uId = XXXXX;';
            sSQL    := StringReplace(sSQL,'XXXXX',IntToStr(oFDQuery.FieldByName('uid').AsInteger),[]);

            //
            TForm1(Self.Owner).FDConnection1.ExecSQL(sSQL);
        end;
    end;
end;

procedure TForm_sys_User.TVChange(Sender: TObject; Node: TTreeNode);
var
    iDID    : Integer;
    sWhere  : String;
begin
    //不处理处于批量设置部门的状态
    if PnHint.Visible then begin
        Exit;
    end;

    if Node.Level = 0 then begin
        sWHERE  := '';
    end else begin
        iDID    := Node.StateIndex;
        sWhere  := '(uDepartmentId = '+IntTostr(iDID)+')';
        _GetWhere(Node,sWHERE);
    end;

    //
    cpSetExtraWhere(Pn1,sWhere);
    cpUpdate(Pn1);
end;

procedure TForm_sys_User.TVClick(Sender: TObject);
var
    oSGD        : TStringGrid;
    oFDQuery    : TFDQuery;
    //
    iRow        : Integer;
    iCount      : Integer;
    iDId        : Integer;
begin

    //
    if PnHint.Visible then begin
        //
        if TV.Selected = nil then begin
            dwMessage('请选择一个部门节点!','error',self);
            Exit;
        end;

        //
        oSGD        := cpGetStringGrid(Pn1);
        oFDQuery    := cpGetFDQuery(Pn1);

        //
        for iRow := 1 to oSGD.RowCount - 1 do begin
            if oSGD.Cells[0,iRow] = 'true' then begin
                //移动到相应记录
                oFDQuery.RecNo  := iRow;

                //修改数据
                oFDQuery.Edit;
                oFDQuery.FieldByName('uDepartmentId').AsInteger := TV.Selected.StateIndex;
                oFDQuery.Post;
            end;
        end;


        //根据uDepartmentId更新uDepartmentNo
        UpdateNos;

        //隐藏提示框
        PnHint.Visible  := False;

        //更新显示
        TV.OnChange(TV,TV.Selected);
    end;
end;

end.
