unit unit_Password;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Password = class(TForm)
    FDQuery1: TFDQuery;
    Label1: TLabel;
    Edit_AName: TEdit;
    Label2: TLabel;
    Edit_OldPassword: TEdit;
    B_Cancel: TButton;
    B_OK: TButton;
    Label3: TLabel;
    Edit_NewPassword: TEdit;
    Label4: TLabel;
    Edit_ConfirmPassword: TEdit;
    Label5: TLabel;
    procedure FormShow(Sender: TObject);
    procedure B_CancelClick(Sender: TObject);
    procedure B_OKClick(Sender: TObject);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;




{$R *.dfm}


procedure TForm_Password.B_CancelClick(Sender: TObject);
begin
    TTabSheet(Self.Parent).TabVisible   := False;
end;

procedure TForm_Password.B_OKClick(Sender: TObject);
var
    sOldPsd     : string;
    sNewPsd     : String;
begin
    sOldPsd     := Trim(Edit_OldPassword.Text);
    sNewPsd     := Trim(Edit_NewPassword.Text);

    //检查确认密码的一致性
    if sNewPsd <> Trim(Edit_ConfirmPassword.Text) then begin
        dwMessage('更改失败！确认密码和新密码不一致！','error',self);
        Exit;
    end;

    //检查新密码长度
    if Length(sNewPsd) < 6 then begin
        dwMessage('更改失败！新密码至少6位！','error',self);
        Exit;
    end;

    //检查原密码的合法性
    if sOldPsd <> FDQuery1.FieldByName('APassword').AsString then begin
        dwMessage('更改失败！旧密码不正确！','error',self);
        Exit;
    end;

    //修改密码
    FDQuery1.Edit;
    FDQuery1.FieldByName('APassword').AsString  := sNewPsd;
    FDQuery1.Post;

    //提示成功
    dwMessage('更改成功！请牢记密码！','success',self);

    //关闭当前页面
    TTabSheet(Self.Parent).TabVisible   := False;

end;

procedure TForm_Password.FormShow(Sender: TObject);
begin
    //
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

    //
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM zh_User WHERE AName='''+TForm1(Self.Owner).gsUserName+'''';
    FDQuery1.Open;

    //
    Edit_AName.Text := TForm1(Self.Owner).gsUserName;
end;

end.
