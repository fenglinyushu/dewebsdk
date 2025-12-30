unit unit_Role;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb操作Access函数
    dwAccess,

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
  FireDAC.Comp.Client, Vcl.ButtonGroup;

type
  TForm_Role = class(TForm)
     Panel_L: TPanel;
    Panel2: TPanel;
    Panel_C: TPanel;
    P_Captions: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel_Roles: TPanel;
    P_Buttons: TPanel;
    Button_Delete: TButton;
    Button_Add: TButton;
    Button_Rename: TButton;
    FDQuery1: TFDQuery;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    SB_Roles: TScrollBox;
    P_Content: TPanel;
    B_Role1: TButton;
    SB_Rights: TScrollBox;
    P_Content1: TPanel;
    P_Module: TPanel;
    L_Name: TLabel;
    CB0: TCheckBox;
    CB1: TCheckBox;
    CB2: TCheckBox;
    CB3: TCheckBox;
    CB4: TCheckBox;
    CB5: TCheckBox;
    CB6: TCheckBox;
    CB7: TCheckBox;
    Label11: TLabel;
    Label12: TLabel;
    CB8: TCheckBox;
    CB9: TCheckBox;
    Panel1: TPanel;
    B_SaveRights: TButton;
    B_Reset: TButton;
    procedure B_Role1Click(Sender: TObject);
    procedure ToggleSwitch_1Click(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button_AddClick(Sender: TObject);
    procedure Button_RenameClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure B_SaveRightsClick(Sender: TObject);
    procedure B_ResetClick(Sender: TObject);
  private
    gsRole : string;
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
		procedure UpdateInfos;
  end;


implementation

uses
    Unit1;

{$R *.dfm}


procedure TForm_Role.B_ResetClick(Sender: TObject);
begin
    dwMessageDlg('确定要重置权限吗？重置权限将重写权限表，并赋于所有角色拥有全部权限！','确认','OK','Cancel','query_reset',self);

end;

procedure TForm_Role.Button_AddClick(Sender: TObject);
var
    iCount  : Integer;
begin
    //得到个数
    iCount := 0;
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT Count(*) FROM df2_Role';
    FDQuery1.Open;
    iCount  := FDQuery1.Fields[0].AsInteger;

    //
    if iCount >= 10 then begin
        dwMessage('系统最多10个角色!','warning',self);
    end else begin
        //确认删除
        dwInputQuery('请输入新角色名称','增加角色','新角色','确定','取消','query_add',self);
    end;
end;

procedure TForm_Role.Button_DeleteClick(Sender: TObject);
var
    iCount  : Integer;
begin
    //得到个数
    iCount := 0;
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT Count(*) FROM df2_Role';
    FDQuery1.Open;
    iCount  := FDQuery1.Fields[0].AsInteger;

    //
    if iCount <= 3 then begin
        dwMessage('系统至少3个角色!','warning',self);
    end else begin
        //确认删除
        dwMessageDlg('确定要将删除角色 '+gsRole+' 吗?','dwFrame','OK','Cancel','query_delete',self);
    end;


end;

procedure TForm_Role.Button_RenameClick(Sender: TObject);
begin
    //确认重命名
    dwInputQuery('请输入新角色名称','重命名',gsRole,'确定','取消','query_rename',self);
end;

procedure TForm_Role.FormShow(Sender: TObject);
begin
    FDQuery1.Connection	:= TForm1(self.owner).FDConnection1;
    UpdateInfos;
end;

procedure TForm_Role.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string;
    sRights : String;
    iItem   : Integer;
    //
    oButton : TButton;
    //
    joRights    : Variant;
    joRight     : Variant;
    //
    joRole      : Variant;
    joItem      : Variant;
    //
    sCaption    : string;
    sText       : string;
    //
    oForm1      : TForm1;
begin
    //
    sMethod := dwGetProp(Self,'interactionmethod');
    sValue  := dwGetProp(Self,'interactionvalue');

    //
    if sMethod = 'query_rename' then begin
        //重命名
        if sValue <> '' then begin
            //检查重复性
            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'SELECT * FROM df2_Role WHERE AName='''+sValue+'''';
            FDQuery1.Open;
            if not FDQuery1.IsEmpty then begin
                //
                dwMessage('角色名称重复,请输入一个新名称!','error',self);
            end else begin
                //重命名记录
                FDQuery1.Close;
                FDQuery1.SQL.Text  := 'UPDATE df2_Role SET AName='''+sValue+'''WHERE AName='''+gsRole+'''';
                FDQuery1.ExecSQL;

                //刷新数据
                for iItem := 1 to 10 do begin
                    oButton := TButton(FindComponent('B_Role'+IntToStr(iItem)));
                    if oButton.Caption = gsRole then begin
                        oButton.Caption := sValue;
                        gsRole  := sValue;
                    end;
                end;

                //显示成功
                dwMessage('重命名成功!','success',self);
            end;
        end;
    end else if sMethod = 'query_add' then begin
        //添加记录
        if sValue <> '' then begin
            //检查重复性
            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'SELECT * FROM df2_Role WHERE AName='''+sValue+'''';
            FDQuery1.Open;
            if not FDQuery1.IsEmpty then begin
                //
                dwMessage('角色名称重复,请输入一个新名称!','error',self);
            end else begin
                //生成权限字符串（采用JSON格式）
                joRights    := _json('[]');
                for iItem := 1 to P_Content1.ControlCount do begin
                    joRight :=  _json('{}');
                    joRight.caption := TLabel(FindComponent('L_Name'+IntToStr(iItem))).Caption;
                    joRight.rights  := _json('[1,1,1,1,1,1,1,1,1,1]');
                    //
                    joRights.Add(joRight);
                end;
                sRights := joRights;

                //
                FDQuery1.Close;
                FDQuery1.SQL.Text  := 'INSERT INTO df2_Role (AName,Rights) '
                        +'VALUES('''+sValue+''','''+sRights+''')';
                FDQuery1.ExecSQL;

                //刷新数据
                UpdateInfos;

                //
                dwMessage('添加成功!','success',self);
            end;
        end;
    end else if sMethod = 'query_delete' then begin
        //删除记录
        if sValue = '1' then begin
            //删除记录
            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'DELETE FROM df2_Role WHERE 名称='''+gsRole+'''';
            FDQuery1.ExecSQL;
            //刷新数据
            UpdateInfos;
            //显示成功
            dwMessage('删除成功!','success',self);
        end;
    end else if sMethod = 'query_reset' then begin
        if sValue = '1' then begin
            //<更新df2_role, 写入各模块信息
            oForm1  := TForm1(self.Owner);
            joRole  := _json('[]');
            for iItem := 0 to oForm1.gslModules.Count-1 do begin
                //
                sCaption    := oForm1.gslModules[iItem];    //模块的标题
                if sCaption[1] = '+' then begin
                    Delete(sCaption,1,1);
                    sCaption    := Trim(sCaption);
                end;
                //生成角色对象
                joItem          := _json('{}');
                joItem.caption  :=  sCaption;
                joItem.rights   := _json('[1,1,1,1,1,1,1,1,1,1]');//显示/运行/增/删/改/查/打印/预留1/预留2/预留3
                //
                joRole.Add(joItem);
            end;
            //
            sText   := joRole;
            FDQuery1.Close;
            FDQuery1.SQL.Text   := 'SELECT * FROM df2_Role';
            FDQuery1.Open;
            while not FDQuery1.Eof do begin
                //
                FDQuery1.Edit;
                FDQuery1.FieldByName('rights').AsString := sText;
                FDQuery1.Post;
                //
                FDQuery1.Next;
            end;
            //>

            //
            dwMessage('重置权限成功! ','success',self);
        end else begin
            dwMessage('重置权限已被取消! ','success',self);
        end;
    end else begin

    end;





end;

procedure TForm_Role.B_Role1Click(Sender: TObject);
var
    I,J         : Integer;
    sText       : String;
    sCaption    : string;
    joRights    : variant;
    joRight     : variant;
begin
    //控制按钮颜色
    for I := 1 to P_Content.ControlCount-1 do begin
        with TButton(FindComponent('B_Role'+I.ToString)) do begin
            Hint    := '{"type":"default"}';
        end;
    end;
    TButton(Sender).Hint    := '{"type":"success"}';

    //得到权限字符串
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM df2_role WHERE AName='''+TButton(Sender).Caption+'''';
    FDQuery1.Open;
    sText  := FDQuery1.FieldByName('rights').AsString;

    //控制各权限是否选中
    joRights    := _Json(sText);
    if joRights = unassigned then begin
        joRights    := _json('[]');
    end;
    for I := 1 to joRights._Count do begin
        joRight := joRights._(I-1).rights;
        for J := 0 to 9 do begin
            with TCheckBox(FindComponent('CB'+IntToStr(J)+IntToStr(I))) do begin
                Checked := (joRight._(J) = 1);
            end;
        end;
    end;

    //将当前角色名称保存到gsRole中，备用
    gsRole   := TButton(Sender).Caption;
end;

procedure TForm_Role.B_SaveRightsClick(Sender: TObject);
var
    I,J         : Integer;
    joRights    : Variant;
    joRight     : Variant;
begin
    //将当前权限保存到JSON
    joRights    := _Json('[]');
    for I := 1 to P_Content1.ControlCount do begin
        //创建权限JSON
        joRight := _Json('{}');
        //设置标题
        joRight.caption := TLabel(FindComponent('L_Name'+IntToStr(I))).Caption;
        //
        joRight.rights  := _Json('[]');
        for J := 0 to 9 do begin
            with TCheckBox(FindComponent('CB'+IntToStr(J)+IntToStr(I))) do begin
                if Checked then begin
                    joRight.rights.Add(1);
                end else begin
                    joRight.rights.Add(0);
                end;
            end;
        end;
        //
        joRights.Add(joRight);
    end;

    //保存
    FDQuery1.Edit;
    FDQuery1.FieldByName('rights').AsString := joRights;
    FDQuery1.Post;

    //
    dwMessage('保存成功！','success',self);
end;

procedure TForm_Role.ToggleSwitch_1Click(Sender: TObject);
var
    sText   : String;
    I       : Integer;
    sCaption: String;
begin
    //得到权限字符串
    sText := '';
    for I := 1 to 15 do begin
        sCaption := TLabel(FindComponent('Label_S'+I.ToString)).Caption;
        if  TToggleSwitch(FindComponent('ToggleSwitch_'+I.ToString)).State = tssOn then begin
            sText   := sText + sCaption +',';
        end;;
    end;

    //更新权限字符串
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'UPDATE df2_Role SET Rights='''+sText+''' WHERE AName='''+gsRole+'''';
    FDQuery1.ExecSQL;
end;

procedure TForm_Role.UpdateInfos;
var
    I           : Integer;
    joRights    : Variant;
    joRight     : Variant;
begin
    //设置Connection. 必须！
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;

    //初始化创建必须的控件  克隆生成另外9个角色按钮
    if P_Content.ControlCount = 1 then begin
        //克隆生成另外9个角色按钮
        for I := 2 to 10 do begin
            with TButton(CloneComponent(B_Role1)) do begin
                Name    := 'B_Role'+IntToStr(I);
                Top     := I*40;
            end;
        end;

    end;

    //打开数据表
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM df2_role ORDER BY ID';
    FDQuery1.Open;

    //更新角色列表
    for I := 1 to 10 do begin
        with TButton(FindComponent('B_Role'+IntToStr(I))) do begin
            Caption := FDQuery1.FieldByName('AName').AsString;
            Visible := not FDQuery1.Eof;
            Top     := I*40;
        end;
        //
        FDQuery1.Next;
    end;

    //<用最后的权限值 更新权限列表
    FDQuery1.First;
    joRights    := _json(FDQuery1.FieldByName('Rights').AsString);
    if joRights = unassigned then begin
        joRights    := _json('[]');
    end;
    //创建控件
    if P_Module <> nil then begin
        for I := 0 to joRights._Count-1 do begin
            //
            with TPanel(CloneComponent(P_Module)) do begin
                Visible := True;
                Top     := I*41;
            end;
        end;
        //
        P_Module.Destroy;
    end;
    //更新控件值
    for I := 0 to joRights._Count-1 do begin
        //得到权限
        joRight := joRights._(I);

        //
        with TLabel(FindComponent('L_Name'+IntToStr(I+1))) do begin
            Caption := joRight.caption;
        end;
    end;
    //>

    //激活当前按钮（当前角色）的OnClick事件，以更新各模块权限
    TButton(FindComponent('B_Role1')).OnClick(TButton(FindComponent('B_Role1')));

end;

end.

