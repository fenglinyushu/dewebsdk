unit Unit_UserRole;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb操作Access函数
    dwAccess,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls, Vcl.WinXCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client;

type
  TForm_UserRole = class(TForm)
     Panel_L: TPanel;
    Panel2: TPanel;
    Panel_C: TPanel;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Panel6: TPanel;
    Label_S15: TLabel;
    ToggleSwitch_15: TToggleSwitch;
    Panel7: TPanel;
    Label_S12: TLabel;
    ToggleSwitch_12: TToggleSwitch;
    Panel8: TPanel;
    Label_S11: TLabel;
    ToggleSwitch_11: TToggleSwitch;
    Panel9: TPanel;
    Label_S10: TLabel;
    ToggleSwitch_10: TToggleSwitch;
    Panel10: TPanel;
    Label_S9: TLabel;
    ToggleSwitch_9: TToggleSwitch;
    Panel11: TPanel;
    Label_S8: TLabel;
    ToggleSwitch_8: TToggleSwitch;
    Panel12: TPanel;
    Label_S7: TLabel;
    ToggleSwitch_7: TToggleSwitch;
    Panel13: TPanel;
    Label_S6: TLabel;
    ToggleSwitch_6: TToggleSwitch;
    Panel14: TPanel;
    Label_S5: TLabel;
    ToggleSwitch_5: TToggleSwitch;
    Panel15: TPanel;
    Label_S4: TLabel;
    ToggleSwitch_4: TToggleSwitch;
    Panel16: TPanel;
    Label_S3: TLabel;
    ToggleSwitch_3: TToggleSwitch;
    Panel17: TPanel;
    Label_S2: TLabel;
    ToggleSwitch_2: TToggleSwitch;
    Panel18: TPanel;
    Label_S1: TLabel;
    ToggleSwitch_1: TToggleSwitch;
    Panel_Roles: TPanel;
    Panel1: TPanel;
    Label_S14: TLabel;
    ToggleSwitch_14: TToggleSwitch;
    Panel3: TPanel;
    Label_S13: TLabel;
    ToggleSwitch_13: TToggleSwitch;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button8: TButton;
    Button9: TButton;
    Button10: TButton;
    Panel5: TPanel;
    Button_Delete: TButton;
    Button_Add: TButton;
    Button_Rename: TButton;
    FDQuery1: TFDQuery;
    procedure Button1Click(Sender: TObject);
    procedure ToggleSwitch_1Click(Sender: TObject);
    procedure Button_DeleteClick(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button_AddClick(Sender: TObject);
    procedure Button_RenameClick(Sender: TObject);
  private
    gsRole : string;
  public
    procedure UpdateInfos;
  end;


implementation

uses
    Unit1;

{$R *.dfm}


procedure TForm_UserRole.Button_AddClick(Sender: TObject);
var
    iCount  : Integer;
begin
    //得到个数
    iCount := 0;
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT Count(*) FROM wms_UserRole';
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

procedure TForm_UserRole.Button_DeleteClick(Sender: TObject);
var
    iCount  : Integer;
begin
    //得到个数
    iCount := 0;
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT Count(*) FROM wms_UserRole';
    FDQuery1.Open;
    iCount  := FDQuery1.Fields[0].AsInteger;

    //
    if iCount <= 3 then begin
        dwMessage('系统至少3个角色!','warning',self);
    end else begin
        //确认删除
        dwMessageDlg('确定要将删除角色 '+gsRole+' 吗?','DWMS','OK','Cancel','query_delete',self);
    end;


end;

procedure TForm_UserRole.Button_RenameClick(Sender: TObject);
begin
    //确认重命名
    dwInputQuery('请输入新角色名称','重命名',gsRole,'确定','取消','query_rename',self);
end;

procedure TForm_UserRole.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
    sMethod : string;
    sValue  : string ;
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
            FDQuery1.SQL.Text  := 'SELECT * FROM wms_UserRole WHERE 名称='''+sValue+'''';
            FDQuery1.Open;
            if not FDQuery1.IsEmpty then begin
                //
                dwMessage('角色名称重复,请输入一个新名称!','error',self);
            end else begin
                //重命名记录
                FDQuery1.Close;
                FDQuery1.SQL.Text  := 'UPDATE wms_userrole SET 名称='''+sValue+'''WHERE 名称='''+gsRole+'''';
                FDQuery1.ExecSQL;
                //刷新数据
                UpdateInfos;
                //显示成功
                dwMessage('重命名成功!','success',self);
            end;
        end;
    end else if sMethod = 'query_add' then begin
        //添加记录
        if sValue <> '' then begin
            //检查重复性
            FDQuery1.Close;
            FDQuery1.SQL.Text  := 'SELECT * FROM wms_UserRole WHERE 名称='''+sValue+'''';
            FDQuery1.Open;
            if not FDQuery1.IsEmpty then begin
                //
                dwMessage('角色名称重复,请输入一个新名称!','error',self);
            end else begin
                FDQuery1.Close;
                FDQuery1.SQL.Text  := 'INSERT INTO wms_UserRole (名称) '
                        +'VALUES('''+sValue+''')';
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
            FDQuery1.SQL.Text  := 'DELETE FROM wms_userrole WHERE 名称='''+gsRole+'''';
            FDQuery1.ExecSQL;
            //刷新数据
            UpdateInfos;
            //显示成功
            dwMessage('删除成功!','success',self);
        end;
    end else begin

    end;




end;

procedure TForm_UserRole.Button1Click(Sender: TObject);
var
    I       : Integer;
    sText   : String;
    sCaption: string;
begin
    //控制按钮颜色
    for I := 1 to 10 do begin
        with TButton(FindComponent('Button'+I.ToString)) do begin
            Hint    := '';
        end;
    end;
    TButton(Sender).Hint    := '{"type":"primary"}';

    //得到权限字符串
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_UserRole WHERE 名称='''+TButton(Sender).Caption+'''';
    FDQuery1.Open;
    sText  := FDQuery1.FieldByName('权限').AsString;

    //控制各权限是否选中
    for I := 1 to 15 do begin
        sCaption := TLabel(FindComponent('Label_S'+I.ToString)).Caption;
        with TToggleSwitch(FindComponent('ToggleSwitch_'+I.ToString)) do begin
            //
            OnClick := nil;

            //
            if Pos(sCaption+',',sText)>0 then begin
                State   := tssOn;
            end else begin
                State   := tssOff;
            end;

            //
            OnClick := ToggleSwitch_1Click;
        end;
    end;

    //得到角色字符串备用
    gsRole  := TButton(Sender).Caption;
end;

procedure TForm_UserRole.ToggleSwitch_1Click(Sender: TObject);
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
    FDQuery1.SQL.Text  := 'UPDATE wms_UserRole SET 权限='''+sText+''' WHERE 名称='''+gsRole+'''';
    FDQuery1.ExecSQL;
end;

procedure TForm_UserRole.UpdateInfos;
var
    I   : Integer;
begin
    //打开数据表
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM wms_UserRole ORDER BY ID';
    FDQuery1.Open;

    //更新角色列表
    for I := 1 to 10 do begin
        with TButton(FindComponent('Button'+I.ToString)) do begin
            if I <= FDQuery1.RecordCount then begin
                Caption := FDQuery1.FieldByName('名称').AsString;
                Visible := True;
                //
                FDQuery1.Next;
            end else begin
                Visible := False;
            end;
        end;
    end;
    //
    Button1.OnClick(Button1);

end;

end.
