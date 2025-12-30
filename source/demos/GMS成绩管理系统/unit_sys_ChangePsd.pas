unit unit_sys_ChangePsd;

interface

uses

    //
    dwBase,

    //
    gLogin,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TForm_sys_ChangePsd = class(TForm)
    FDQuery1: TFDQuery;
    P0: TPanel;
    L1: TLabel;
    L2: TLabel;
    E1: TEdit;
    E2: TEdit;
    B0: TButton;
    L0: TLabel;
    E0: TEdit;
    Image1: TImage;
    procedure FormShow(Sender: TObject);
    procedure B0Click(Sender: TObject);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;




{$R *.dfm}





procedure TForm_sys_ChangePsd.B0Click(Sender: TObject);
begin
    try
        //密码不能为空
        if (Trim(E0.Text) = '') or (Trim(E1.Text) = '') or (Trim(E2.Text) = '') then begin
            dwMessage('密码不能为空，请重新输入！','error',self);
            Exit;
        end;

        //密码不一致
        if (Trim(E1.Text) <> Trim(E2.Text)) then begin
            dwMessage('确认密码和新密码不一致，请重新输入！','error',self);
            Exit;
        end;

        //密码长度控制
        if Length(Trim(E1.Text)) < 6 then begin
            dwMessage('密码至少需要6位，请重新输入！','error',self);
            Exit;
        end;

        //原密码不正确
        if (Trim(E0.Text) <> Trim(FDQuery1.FieldByName('uPassword').AsString)) then begin
            dwMessage('原密码不正确，请重新输入！','error',self);
            E1.Text := '';
            E2.Text := '';
            Exit;
        end;

        //修改密码
        FDQuery1.Edit;
        FDQuery1.FieldByName('uPassword').AsString  := Trim(E1.Text);
        FDQuery1.Post;

        //将当前登录信息保存到日志表dwLog中
        FDQuery1.Close;
        FDQuery1.SQL.Text    := 'INSERT INTO sys_Log(lMode,lDate,lUserName,lCanvasId,lIp)'
                +' VALUES('
                +''''+'logout'+''','
                +''''+FormatDateTime('yyyy-MM-DD hh:mm:ss',Now)+''','
                +''''+TForm1(self.Owner).gjoUserInfo.username+''','
                +''''+TForm1(self.Owner).gjoUserInfo.canvasid+''','
                +''''+dwGetProp(self,'ip')+''''
                +')';
        FDQuery1.ExecSQL;

        //清除COOKIE
        glClearLoginInfo('dwFrame',self);

        //如果没找到登录信息，则重新登录（调用通用登录模块）
        dwOpenUrl(self,'/glogin?dwFrame','_self');

    except
        dwMessage('Error when TForm_ChangePsd.B0Click!','error',self);
    end;

end;

procedure TForm_sys_ChangePsd.FormShow(Sender: TObject);
begin
    try
        //设置数据库连接
        FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

        //打开数据表
        FDQuery1.Close;
        FDQuery1.SQL.Text   := 'SELECT * FROM sys_User WHERE uId = '+TForm1(Self.Owner).gjoUserInfo.id;
        FDQuery1.Open;

        //设置当前焦点
        dwSetFocus(E0);
    except
        dwMessage('Error when TForm_ChangePsd.FormShow!','error',self);
    end;
end;

end.
