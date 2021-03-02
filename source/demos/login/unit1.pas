unit unit1;

interface

uses
     //
     dwBase,
     cnDes,

     //
     JsonDataObjects,

     //
     HttpApp,Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
     FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
     FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
     FireDAC.Comp.Client, FireDAC.Comp.DataSet, Data.DB, FireDAC.Phys.SQLite,
     FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs;

type
  TForm1 = class(TForm)
    Panel_Full: TPanel;
    Label_User: TLabel;
    Edit_User: TEdit;
    Label_Psd: TLabel;
    Edit_Psd: TEdit;
    Button_Login: TButton;
    CheckBox_Remember: TCheckBox;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    Image_logo: TImage;
    Timer_GetCookie: TTimer;
    procedure Button_LoginClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer_GetCookieTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1          : TForm1;
     //
     gjoConfig      : TJsonObject;           //配置文件
     //
     gsConfigFile   : string='bbs_login.json';
     gsTableName    : String='bbs_user';     //用户表名
     gsUserNameFld  : string='username';     //用户名字段名
     gsPasswordFld  : string='password';     //密码字段名
     gsSaltFld      : string='salt';         //salt字段名
     gsInvalid      : string='用户名或密码不正确！';   //输入错误提示
     giRememberDays : Integer = 30;          //记住密码天数
     gsSuccessHref  : string='/bbs.dw';      //登录成功后打开的界面


implementation

{$R *.dfm}




procedure TForm1.Button_LoginClick(Sender: TObject);
var
     sSalt     : string;
     sPassword : string;
     iTicks    : Integer;
     sName     : string;
     sCode     : string;
begin
     //打开数据表
     FDQuery.Close;
     FDQuery.SQL.Text   := 'SELECT * FROM '+gsTableName+' WHERE '+gsUserNameFld+'='''+Edit_User.Text+'''';
     FDQuery.Open;

     //
     if FDQuery.IsEmpty then begin
          dwShowMessage(gsInvalid,self);
     end else begin
          //取得数据表中salt和密码
          sSalt     := FDQuery.FieldByName(gsSaltFld).AsString;
          sPassword := FDQuery.FieldByName(gsPasswordFld).AsString;
          sName     := Edit_User.Text;

          //检查正确性
          if sPassword = dwGetMD5(dwGetMD5(Edit_Psd.Text)+sSalt) then begin
               //
               dwSetCookie(self,'dw_user',Edit_User.Text,24*giRememberDays);      //

               //将当前登录用户信息写入cookie（实际使用时可以先加密，再写入）
               if CheckBox_Remember.Checked then begin
                    dwSetCookie(self,'dw_loginuser',Edit_User.Text,24*giRememberDays);  //一个月
                    dwSetCookie(self,'dw_loginpassword', Edit_Psd.Text,24*giRememberDays);  //一个月
               end else begin
                    dwSetCookie(self,'dw_loginuser','',1);  //
                    dwSetCookie(self,'dw_password', '',1);  //
               end;

               //打开新网页
               dwOpenUrl(self,gsSuccessHref,'_self');
          end else begin
               dwShowMessage(gsInvalid,self);
          end;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     //
     try
          if FileExists(gsConfigFile) then begin
               gjoConfig := TJsonObject.Create;
               gjoConfig.LoadFromFile(gsConfigFile);
               //数据库
               FDConnection.ConnectionString := gjoConfig.O['database'].S['connectionstring'];
               FDConnection.Open();

               //Caption/PlaceHolder
               Caption                  := gjoConfig.O['captions'].S['form'];        //页面标题
               Label_User.Caption       := gjoConfig.O['captions'].S['username'];    //用户名
               Label_Psd.Caption        := gjoConfig.O['captions'].S['password'];    //密码
               CheckBox_Remember.Caption:= gjoConfig.O['captions'].S['rememberme'];  //记住密码
               Edit_User.Hint           := '{"suffix-icon":"el-icon-user","placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';     //用户名输入框提示
               Edit_Psd.Hint            := '{"placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';    //密码输入框提示
               Button_Login.Caption     := gjoConfig.O['captions'].S['login'];       //登录按钮
               gsInvalid                := gjoConfig.O['captions'].S['invalid'];     //输入错误提示

               //
               giRememberDays           := gjoConfig.I['rememberdays'];    //记住天数
               gsSuccessHref            := gjoConfig.S['successhref'];     //登录成功后打开的网址
               CheckBox_Remember.Checked:= gjoConfig.B['remember'];

               //logo
               if gjoConfig.S['logo']<>'' then begin
                    Image_Logo.Hint     := '{"src":"'+gjoConfig.S['logo']+'"}';
               end;

               //
               gsTableName    := gjoConfig.O['database'].S['tablename'];
               gsUserNameFld  := gjoConfig.O['database'].S['usernamefield'];
               gsPasswordFld  := gjoConfig.O['database'].S['passwordfield'];
               gsSaltFld      := gjoConfig.O['database'].S['saltfield'];
          end;
     except

     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     bMobile   : Boolean;     //是否为手机
     bVert     : Boolean;     //是否为竖屏
     iWidth    : Integer;     //宽度
     iHeight   : Integer;     //高度
begin
     //<取得客户端属性
     //是否手机
     bMobile   := (ssCtrl in Shift) or (ssLeft in Shift);

     //是否为竖屏
     bVert     := Button = mbLeft;

     //得到宽度和高度（因为iphone的宽度不随纵向/横向变化）
     iWidth    := X;
     iHeight   := Y;
     if  (ssLeft in Shift) and (not bVert) then begin
          iWidth    := Y;
          iHeight   := X;
     end;
     //>

     //手机/电脑自动适应
     //如果是手机，则进行如下设置：
     //1 外框Panel无边框
     //2 背景色为白色

     if bMobile then begin
          //纵向时为等宽，否则限制宽度为最大360
          if bVert then begin
               Width     := iWidth;
          end else begin
               Width     := Min(480,iWidth);
          end;
          //
          Panel_Full.BorderStyle   := bsNone;
          TransparentColorValue    := clWhite;
     end else begin
          //
          Width     := Min(360,iWidth);

          //
          Panel_Full.BorderStyle   := bsSingle;
          TransparentColorValue    := clBtnFace;
     end;

end;

procedure TForm1.Timer_GetCookieTimer(Sender: TObject);
var
     sUser     : string;
begin
     //
     if Timer_GetCookie.Tag=0 then begin
          //预读取
          dwPreGetCookie(self,'dw_loginuser','');
          dwPreGetCookie(self,'dw_loginpassword','');
     end else if Timer_GetCookie.Tag < 30 then begin
          sUser     := dwGetCookie(self,'dw_loginuser');
          //
          if sUser <>'' then begin
               //显示用户名
               Edit_User.Text      := sUser;
               Edit_Psd.Text       := dwGetCookie(self,'dw_loginpassword');
               //停止Timer
               Timer_GetCookie.DesignInfo        := 0;
          end;
     end else begin
          //停止Timer
          Timer_GetCookie.DesignInfo   := 0;
     end;

     //
     Timer_GetCookie.Tag := Timer_GetCookie.Tag +1;

end;

end.
