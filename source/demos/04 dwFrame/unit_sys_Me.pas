unit unit_sys_Me;

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
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage, Vcl.Imaging.jpeg;

type
  TForm_sys_Me = class(TForm)
    FDQuery1: TFDQuery;
    Pn0: TPanel;
    LaNo: TLabel;
    LaName: TLabel;
    Im1: TImage;
    PnAvatar: TPanel;
    LaAvatar: TLabel;
    Pn1: TPanel;
    Bt1: TButton;
    PnOption: TPanel;
    LaOption: TLabel;
    Pn4: TPanel;
    Bt4: TButton;
    PnPassword: TPanel;
    LaPsd: TLabel;
    Pn3: TPanel;
    Bt3: TButton;
    PnScore: TPanel;
    LaScore: TLabel;
    Pn2: TPanel;
    Bt2: TButton;
    Pn5: TPanel;
    LaLogout: TLabel;
    procedure LaLogoutClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure PnAvatarClick(Sender: TObject);
    procedure PnOptionClick(Sender: TObject);
    procedure PnPasswordClick(Sender: TObject);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;




{$R *.dfm}



procedure TForm_sys_Me.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFile       : String;
    sSQL        : String;
begin
    //===== 上传图片完成后自动激活本事件


    //取得上传完成的图片
    sFile   := dwGetProp(Self,'__upload');

    //更新数据表记录
    sSQL    := 'UPDATE sys_User SET uAvatar = '''+sFile+''' WHERE uId = '+IntToStr(TForm1(self.Owner).gjoUserInfo.id);
    TForm1(self.Owner).FDConnection1.ExecSQL(sSQL);

    //更新当前界面的头像显示
    Im1.Hint    := '{"dwstyle":"border-radius:8px;","src":"media/system/dw'+TForm1(self.Owner).gsName+'/head/'+sFile+'"}';

    //更新"首页"界面的头像显示
    TForm1(self.Owner).Form_sys_Home.ImAvatar.Hint := '{"src":"media/system/dw'+TForm1(self.Owner).gsName+'/head/'+sFile+'","radius":"50%","dwstyle":"border:solid 2px #ddd;"}';
end;

procedure TForm_sys_Me.FormShow(Sender: TObject);
begin
    //指定数据库连接
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;

    //打开用户表当前记录
    FDQuery1.Open('SELECT * FROM sys_User WHERE uId = '+IntToStr(TForm1(self.Owner).gjoUserInfo.id));

    //更新显示
    LaName.Caption      := TForm1(self.Owner).gjoUserInfo.username;
    LaNo.Caption        := '编号：'+IntToStr(TForm1(self.Owner).gjoUserInfo.id);
    Im1.Hint            := '{"dwstyle":"border-radius:8px;","src":"media/system/dw'+TForm1(self.Owner).gsName+'/head/'+FDQuery1.FieldByName('uAvatar').AsString+'"}';

end;

procedure TForm_sys_Me.LaLogoutClick(Sender: TObject);
begin
    //退出登录
    TForm1(self.Owner).PnLogout.Visible    := True;
end;

procedure TForm_sys_Me.PnAvatarClick(Sender: TObject);
begin
    //修改头像
    dwUpload(Self,'image/gif, image/jpeg, image/png','media/system/dw'+TForm1(self.Owner).gsName+'/head/');
end;

procedure TForm_sys_Me.PnOptionClick(Sender: TObject);
begin
    dwMessage('建设中......','succcess',self);
end;

procedure TForm_sys_Me.PnPasswordClick(Sender: TObject);
begin
    //修改密码
    TForm1(self.Owner).Mu3.Click;
end;

end.
