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
    Button_Register: TButton;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    Image_logo: TImage;
    Label_PsdConfirm: TLabel;
    Edit_PsdConfirm: TEdit;
    Label_Email: TLabel;
    Edit_Email: TEdit;
    procedure Button_RegisterClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
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
     gsEmailFld     : string='email';        //salt字段名
     gsInvalid      : string='用户名或密码不正确！';   //输入错误提示
     giRememberDays : Integer = 30;          //记住密码天数
     gsSuccessHref  : string='/bbs.dw';      //登录成功后打开的界面


implementation

{$R *.dfm}




procedure TForm1.Button_RegisterClick(Sender: TObject);
var
     sSalt     : string;
     iTicks    : Integer;
     sEmail    : string;
     sName     : string;
     sPassword : string;
     sConfirm  : string;
     sDBPsd    : string;
     sCode     : string;
begin
     //取得值
     sEmail    := Trim(Edit_Email.Text);
     sName     := Trim(Edit_User.Text);
     sPassword := Trim(Edit_Psd.Text);
     sConfirm  := Trim(Edit_PsdConfirm.Text);

     //<异常检查
     if (sEmail='') or (sName='') or (sPassword='') then begin
          dwShowMessage('邮箱、用户名、密码不能为空！',self);
          Exit;
     end;
     if (Pos('@',sEmail)<=0) or (Pos('.',sEmail)<=0) then begin
          dwShowMessage('请输入正确邮箱地址！',self);
          Exit;
     end;
     if (sPassword <> sConfirm) then begin
          dwShowMessage('两次输入的密码不一致！',self);
          Exit;
     end;
     if (Length(sPassword) < 8) then begin
          dwShowMessage('密码至少8位！',self);
          Exit;
     end;
     //>

     //<重复检查
     //打开数据表
     FDQuery.Close;
     FDQuery.SQL.Text   := 'SELECT * FROM '+gsTableName
          +' WHERE '+gsEmailFld+'='''+sEmail+'''';
     FDQuery.Open;
     if not FDQuery.IsEmpty then begin
          dwShowMessage('邮箱已注册！',self);
          Exit;
     end;
     FDQuery.Close;
     FDQuery.SQL.Text   := 'SELECT * FROM '+gsTableName
          +' WHERE '+gsUserNameFld+'='''+sName+'''';
     FDQuery.Open;
     if not FDQuery.IsEmpty then begin
          dwShowMessage('用户名已注册！',self);
          Exit;
     end;
     //>




     //开始注册
     sSalt     := FormatDateTime('YYYYMMDDhhmmss',now)+IntToStr(GetTickCount);
     sDBPsd    := dwGetMD5(dwGetMD5(sPassword)+sSalt);

     //用户名，邮箱，salt,password,create_date
     FDQuery.Close;
     FDQuery.SQL.Text   := 'INSERT INTO bbs_user (username,email,salt,password,create_date)'
               +Format(' VALUES(''%s'',''%s'',''%s'',''%s'',%d)',[sName,sEmail,sSalt,sDBPsd,dwDateToPHPDate(Now)]);
     FDQuery.ExecSQL;

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
               Edit_User.Hint           := '{"suffix-icon":"el-icon-user","placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';     //用户名输入框提示
               Edit_Psd.Hint            := '{"placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';    //密码输入框提示
               Button_Register.Caption  := gjoConfig.O['captions'].S['login'];       //登录按钮
               gsInvalid                := gjoConfig.O['captions'].S['invalid'];     //输入错误提示

               //
               giRememberDays           := gjoConfig.I['rememberdays'];    //记住天数
               gsSuccessHref            := gjoConfig.S['successhref'];     //登录成功后打开的网址

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

end.
