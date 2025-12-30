unit unit_sys_Role;

interface

uses
    //deweb基础函数
    dwBase,
    dwfBase,
    //
    dwCrudPanel,

    //
    CloneComponents,
    SynCommons,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls, Vcl.WinXCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.ButtonGroup, Vcl.Menus;

type
  TForm_sys_Role = class(TForm)
    FDQuery1: TFDQuery;
    B_EditPlus: TButton;
    P_InfoEdit: TPanel;
    Panel3: TPanel;
    L_RoleName: TLabel;
    B_Save: TButton;
    TV_Permission: TTreeView;
    B_True: TButton;
    B_False: TButton;
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure B_EditPlusClick(Sender: TObject);
    procedure FormDockDrop(Sender: TObject; Source: TDragDockObject; X, Y: Integer);
    procedure B_SaveClick(Sender: TObject);
    procedure B_TrueClick(Sender: TObject);
    procedure B_FalseClick(Sender: TObject);
    procedure TV_PermissionEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;

{$R *.dfm}



procedure TForm_sys_Role.B_FalseClick(Sender: TObject);
var
    iItem       : integer;
    joText      : Variant;
    tnNode      : TTreeNode;
begin
    //
    for iItem := 0 to TV_Permission.Items.Count - 1 do begin
        tnNode  := TV_Permission.Items[iItem];
        //得到JSON
        joText  := _json(tnNode.Text);
        //只保存功能菜单名称项
        if joText = unassigned then begin
            joText  := _json('[]');
            joText.Add(tnNode.Text);
        end else begin
            while joText._Count > 1 do begin
                joText.Delete(1);
            end;
        end;
        //添加未选中项
        while joText._Count < 15 do begin
            joText.Add(0);
        end;

        //赋值给TreeView
        tnNode.Text := joText;
    end;
end;

procedure TForm_sys_Role.B_SaveClick(Sender: TObject);
var
    sText       : string;
    //
    joText      : Variant;
    joRoleData  : Variant;
    //
    iItem       : Integer;
    //
    oFDQuery    : TFDQuery;
begin
    //保存当前权限到角色中

    try
        //取得权限内容
        joRoleData  := _json('[]');

        //
        for iItem := 0 to TV_Permission.Items.Count - 1 do begin
            //得到当前树形控件的节点Text, 为JSON数组
            sText   := TV_Permission.Items[iItem].Text;

            //转换为JSON对象
            joText  := _Json(sText);

            //异常检查
            if joText = unassigned then begin
                joText  := _json('[]');
                joText.Add(sText);
            end;

            //添加到所有菜单项的权限JSON数组
            joRoleData.Add(joText);
        end;

        //取得主表,并保存权限数据RoleData
        oFDQuery    := cpGetFDQuery(Pn1);               //取得主表
        oFDQuery.Edit;
        oFDQuery.FieldByName('rData').AsString   := joRoleData;
        oFDQuery.Post;
        //
        dwMessage('权限保存成功！','success',self);
    except
        dwMessage('权限保存失败！','error',self);
    end;
end;

procedure TForm_sys_Role.B_TrueClick(Sender: TObject);
var
    iItem       : integer;
    joText      : Variant;
    tnNode      : TTreeNode;
begin
    //
    for iItem := 0 to TV_Permission.Items.Count - 1 do begin
        tnNode  := TV_Permission.Items[iItem];
        //得到JSON
        joText  := _json(tnNode.Text);
        //只保存功能菜单名称项
        if joText = unassigned then begin
            joText  := _json('[]');
            joText.Add(tnNode.Text);
        end else begin
            while joText._Count > 1 do begin
                joText.Delete(1);
            end;
        end;
        //添加选中项
        while joText._Count < 15 do begin
            joText.Add(1);
        end;

        //赋值给TreeView
        tnNode.Text := joText;
    end;

end;

procedure TForm_sys_Role.B_EditPlusClick(Sender: TObject);
begin
    P_InfoEdit.Visible  := True;
end;

procedure TForm_sys_Role.FormDockDrop(Sender: TObject; Source: TDragDockObject; X, Y: Integer);
var
    oFDQuery    : TFDQuery;
    //
    sRoleData   : String;
    sAlias      : String;
    //
    joText      : Variant;
    joRoleData  : Variant;
    joRole      : Variant;
    //
    iItem       : Integer;
    iRole       : Integer;
    //
    bFound      : Boolean;
begin
    //数据表记录切换事件  X = 0 表示主表，其余表示为从表。 Y为记录号
    //此处主要用于点击不同的角色后，TreeView__Grid显示当前角色的权限


    //取得主表数据
    oFDQuery    := cpGetFDQuery(Pn1);               //取得主表

    //显示当前角色名称
    L_RoleName.Caption  := oFDQuery.FieldByName('rname').AsString;

    //取得权限数据（应为字符串）,为JSON数组，无层次结构，如：
    //[
    //  ["首页",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ["基础数据",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ["客户管理",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ["商品信息",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ...
    //  ["系统设置",1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    //]
    sRoleData   := oFDQuery.FieldByName('rdata').AsString;

    //将权限数据（应为字符串）转换为JSON
    joRoleData  := _json(sRoleData);

    //异常处理，防止异常字符串导致JSON解析不正确
    if joRoleData = unassigned then begin
        joRoleData  := _json('[]');
    end;

    //权限JSON与菜单
    for iItem := 0 to TV_Permission.Items.Count - 1 do begin
        //得到当前节点对应的菜单别名（默认为名称）
        joText  := _json(TV_Permission.Items[iItem].Text);
        if joText = unassigned then begin
            sAlias  := TV_Permission.Items[iItem].Text;
        end else begin
            sAlias  := joText._(0);
        end;

        //取得与当前菜单匹配的权限项
        bFound  := False;
        for iRole := 0 to joRoleData._Count - 1 do begin
            joRole   := joRoleData._(iRole);
            if joRole._(0) = sAlias then begin
                bFound  := True;
                break;
            end;
        end;


        //根据是否查找到分别处理
        if bFound then begin
            //将当前权限值赋给TreeView__Grid的节点
            TV_Permission.Items[iItem].Text := joRole;
        end else begin
            //创建一个新权限
            joText  := _json(TV_Permission.Items[iItem].Text);
            //
            if joText = unassigned then begin
                joText  := _json('[]');
                joText.Add(TV_Permission.Items[iItem].Text);
            end else begin
                while joText._Count > 1 do begin
                    joText.Delete(1);
                end;
            end;
            //添加空值（此处15为标题+权限的数量，如果更新了权限数据，调整该值）
            while joText._Count < 15 do begin
                joText.Add(False);
            end;

            //
            TV_Permission.Items[iItem].Text := joText;
        end;
    end;


end;

procedure TForm_sys_Role.FormShow(Sender: TObject);
begin

    //创建Crud
    cpInit(Pn1,TForm1(Self.Owner).FDConnection1,False,'');

    //调整E_Keyword的宽度
    //with TEdit(FindComponent('EKw')) do begin
    //    Width       := 242;
    //    Margins.Top := 8;
    //    Hint        := '{"placeholder":"搜索","suffix-icon":"el-icon-search","dwstyle":"padding-left:10px;"}';
    //end;

    //将菜单转化为TreeView
    dwfMainMenuToTreeView(TForm1(self.Owner).MainMenu1,TV_Permission);

    //启动后激活主表选中第一条事件
    Self.OnDockDrop(self,nil,0,0);
end;


procedure TForm_sys_Role.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oFDQuery    : TFDQuery;
    //
    sRoleData   : String;
    sAlias      : String;
    //
    joText      : Variant;
    joRoleData  : Variant;
    joRole      : Variant;
    //
    iItem       : Integer;
    iRole       : Integer;
    //
    bFound      : Boolean;
begin
    //
    if X = dwCrudPanel.cpDataScroll then begin

        //取得主表数据
        oFDQuery    := cpGetFDQuery(Pn1);               //取得主表

    //显示当前角色名称
    L_RoleName.Caption  := oFDQuery.FieldByName('rname').AsString;

    //取得权限数据（应为字符串）,为JSON数组，无层次结构，如：
    //[
    //  ["首页",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ["基础数据",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ["客户管理",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ["商品信息",1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    //  ...
    //  ["系统设置",1,1,1,1,1,1,1,1,1,1,1,1,1,1]
    //]
    sRoleData   := oFDQuery.FieldByName('rdata').AsString;

    //将权限数据（应为字符串）转换为JSON
    joRoleData  := _json(sRoleData);

    //异常处理，防止异常字符串导致JSON解析不正确
    if joRoleData = unassigned then begin
        joRoleData  := _json('[]');
    end;

    //权限JSON与菜单
    for iItem := 0 to TV_Permission.Items.Count - 1 do begin
        //得到当前节点对应的菜单别名（默认为名称）
        joText  := _json(TV_Permission.Items[iItem].Text);
        if joText = unassigned then begin
            sAlias  := TV_Permission.Items[iItem].Text;
        end else begin
            sAlias  := joText._(0);
        end;

        //取得与当前菜单匹配的权限项
        bFound  := False;
        for iRole := 0 to joRoleData._Count - 1 do begin
            joRole   := joRoleData._(iRole);
            if joRole._(0) = sAlias then begin
                bFound  := True;
                break;
            end;
        end;


        //根据是否查找到分别处理
        if bFound then begin
            //将当前权限值赋给TreeView__Grid的节点
            TV_Permission.Items[iItem].Text := joRole;
        end else begin
            //创建一个新权限
            joText  := _json(TV_Permission.Items[iItem].Text);
            //
            if joText = unassigned then begin
                joText  := _json('[]');
                joText.Add(TV_Permission.Items[iItem].Text);
            end else begin
                while joText._Count > 1 do begin
                    joText.Delete(1);
                end;
            end;
            //添加空值（此处15为标题+权限的数量，如果更新了权限数据，调整该值）
            while joText._Count < 15 do begin
                joText.Add(False);
            end;

            //
            TV_Permission.Items[iItem].Text := joText;
        end;
    end;
    end;
end;

procedure TForm_sys_Role.TV_PermissionEndDock(Sender, Target: TObject; X, Y: Integer);
var
    tnNode      : TTreeNode;
    joText      : Variant;
begin
    //此处为TreeView_grid的点击事件，其中X为列序号，Y为列内元素序号，比如一列中有2个按钮，分别为0/1

    //
    if X = 15 then begin    //X 为列序号，目前15列为全选/全不选
        //得到当前节点
        tnNode  := TTreeNode(Target);

        //得到当前节点的text
        joText  := _json(tnNode.Text);

        //清除选中状态
        while joText._Count > 1 do begin
            joText.Delete(1);
        end;

        //全选/全不选（根据Y即按钮序号而定）
        while joText._Count < X do begin
            if (Y=0) then begin
                joText.Add(1);
            end else begin
                joText.Add(0);
            end;
        end;

        //返回值
        tnNode.Text := joText;
    end;
end;

end.

