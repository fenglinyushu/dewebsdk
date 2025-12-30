unit unit1;

interface

uses
    //
    dwBase,
    cnDes,

    //
    DelphiZXIngQRCode,

    //
    SynCommons,

    //
    HttpApp,Math, Vcl.Imaging.jpeg,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
    Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
    FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
    FireDAC.Comp.Client, FireDAC.Comp.DataSet, Data.DB, FireDAC.Phys.SQLite,
    FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs, FireDAC.Phys.SQLiteWrapper.Stat,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MSSQL, FireDAC.Phys.MySQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC, FireDAC.Phys.TDataDef,
    FireDAC.Phys.TData, FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle, FireDAC.Phys.PGDef, FireDAC.Phys.PG;

type
  TForm1 = class(TForm)
    Imbg: TImage;
    PnLogin: TPanel;
    ImLogo: TImage;
    EtPassword: TEdit;
    PnCaptcha: TPanel;
    LaCaptcha: TLabel;
    EtCaptcha: TEdit;
    PnRemember: TPanel;
    CKRemember: TCheckBox;
    BtLogin: TButton;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysTDataDriverLink1: TFDPhysTDataDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    CbUser: TComboBox;
    EtUser: TEdit;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    LaError: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BtLoginClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    //配置文件对象
    gjoConfig   : Variant;
    //是否移动端
    gbMobile    : Boolean;
    //唯一ID
    gsCanvasId  : String;
    //
    giID        : Integer;
    gsMainDir   : string;

    //错误信息字符串
    gsError     : string;
  end;

var
     Form1          : TForm1;


implementation

{$R *.dfm}

procedure TForm1.BtLoginClick(Sender: TObject);
var
    iWrong      : Integer;
    iError      : Integer;
    //
    sSalt       : string;
    sPassword   : string;
    sName       : string;
    sId         : String;
    sTmp        : String;
    sStatus     : string;
    //
    bWrong      : Boolean;
    //
    joInfo      : Variant;      //写入的登录信息
begin
    try
        //异常检查变量
        iError  := 0;
        sStatus := '验证码代码异常！';

        //检查验证码
        if PnCaptcha.Visible then begin
            if LowerCase(EtCaptcha.Text) <> LowerCase(LaCaptcha.Caption) then begin
                dwMessage(gjoconfig.errorhint,'error',self);
                Exit;
            end;
        end;

        //异常检查变量
        iError  := 1;
        sStatus := '禁止登录代码异常！';

        //禁止登录
        sTmp    := dwGetCookie(self,gjoConfig.cookieprefix+'disablelogin');
        if StrToFloatDef(sTmp,Now) > Now then begin
            dwMessage(gjoconfig.disablehint,'error',self);
            Exit;
        end;

        //异常检查变量
        iError  := 2;
        sStatus := '数据表打开代码异常！';

        //打开数据表
        try

            //取得用户名
            if dwGetInt(gjoConfig,'listuser') = 1 then begin
                sName   := CbUser.Text;
            end else begin
                sName   := EtUser.Text;
            end;

            //异常检查变量
            iError  := 3;
            sStatus := '数据表打开代码异常！SQL = SELECT * FROM '++gjoConfig.tablename
                    +' WHERE '+gjoConfig.username+'='''+sName+'''';


            //根据当前输入的用户名打开数据表
            FDQuery1.Close;
            FDQuery1.SQL.Clear;
            FDQuery1.SQL.Text   := 'SELECT * FROM '+gjoConfig.tablename
                    +' WHERE '+gjoConfig.username+'='''+sName+'''';
            FDQuery1.Open;

            //异常检查变量
            iError  := 4;
            sStatus := '用户检查代码异常！';

            //默认错误
            bWrong  := True;

            //判断是否正确
            if not FDQuery1.IsEmpty then begin
                //异常检查变量
                iError  := 5;
                sStatus := '数据库非空进入后代码异常！';

                //根据密码是否加密保存分别处理
                if gjoConfig.secret = 1 then begin  //MD5加密
                    //异常检查变量
                    iError  := 6;
                    sStatus := '取 salt 字段代码异常！';

                    //取得数据表中salt和密码
                    sSalt       := FDQuery1.FieldByName(gjoConfig.salt).AsString;
                    //异常检查变量
                    iError  := 7;
                    sStatus := '取 password 字段代码异常！';
                    sPassword   := FDQuery1.FieldByName(gjoConfig.password).AsString;

                    //异常检查变量
                    iError  := 8;
                    sStatus := '取 id 字段代码异常！';
                    sId         := FDQuery1.FieldByName(gjoConfig.id).AsString;

                    //异常检查变量
                    iError  := 9;

                    //异常检查变量
                    iError  := 10;
                    //检查正确性 (MD5加密比较)
                    sStatus := 'MD5加密比较代码异常！';
                    if sPassword = dwGetMD5(dwGetMD5(EtPassword.Text)+sSalt) then begin
                        bWrong  := False;
                        //异常检查变量
                        iError  := 11;
                    end;

                    //异常检查变量
                    iError  := 12;
                end else begin      //明码保存
                    //异常检查变量
                    iError  := 13;
                    //取得数据表中密码
                    sStatus := '非密状态下取 password 字段代码异常！';
                    sPassword   := FDQuery1.FieldByName(gjoConfig.password).AsString;

                    //异常检查变量
                    iError  := 14;
                    sStatus := '非密状态下取 id 字段代码异常！';
                    sId         := FDQuery1.FieldByName(gjoConfig.id).AsString;

                    //异常检查变量
                    iError  := 15;
                    sStatus := '非密状态下合法性检查代码异常！';
                    //检查正确性(明文比较)
                    bWrong      := (sPassword <> EtPassword.Text);

                    //异常检查变量
                    iError  := 16;

                end;
            end;
        except
            //异常检查变量
            //iError  := 17;

            dwMessage('config error! Please check!'+IntToStr(iError)+' : '+sStatus,'error',self);
            Exit;
        end;

        //如果输入错误,则写入到cookie中, 禁止多次尝试
        if bWrong then begin
            //异常检查变量
            iError  := 18;

            sStatus := '合法性检验未通过后代码异常！';
            dwMessage(gjoConfig.errorhint,'error',self);

            //
            if gjoConfig.wrongtimes > 0 then begin
                //异常检查变量
                iError  := 19;


                //当配置文件中  captcha 为2时表示：如果输入错误1次后，显示验证码框
                if gjoConfig.captcha = 2 then begin
                    PnCaptcha.Visible   := True;
                    PnCaptcha.Top       := EtPassword.Top + 20;
                end;

                //异常检查变量
                iError  := 20;


                //取得错误次数
                sStatus := '取错误次数代码异常！';
                sTmp    := dwGetCookie(self,gjoConfig.cookieprefix+'wrongtimes');
                iWrong  := Max(0,StrToIntDef(sTmp,0));

                //异常检查变量
                iError  := 21;


                //判断次数
                sStatus := '判断错误次数代码异常！';
                if iWrong+1 >= gjoConfig.wrongtimes then begin
                    //异常检查变量
                    iError  := 22;

                    //如果超过
                    dwSetCookie(self,gjoConfig.cookieprefix+'disablelogin',FloatToStr(Now+3/24/60),0);
                    dwSetCookie(self,gjoConfig.cookieprefix+'wrongtimes','0',3/60);
                end else begin
                    //异常检查变量
                    iError  := 23;

                    dwSetCookie(self,gjoConfig.cookieprefix+'wrongtimes',IntToStr(iWrong+1),0);
                    sTmp    := dwGetCookie(self,gjoConfig.cookieprefix+'wrongtimes');
                end;
            end;
        end else begin
            //异常检查变量
            iError  := 24;
            sStatus := '合法性检验通过后代码异常！';

            //错误次数置0
            dwSetCookie(self,gjoConfig.cookieprefix+'wrongtimes','0',3/60);

            //异常检查变量
            iError  := 25;

            //得到登录信息
            sStatus := '生成登录信息代码异常！';
            joInfo          := _json('{}');
            joInfo.id       := sId;
            joInfo.username := sName;
            joInfo.canvasid := gsCanvasId;

            //异常检查变量
            iError  := 26;

            //生成加密字符串，以JSON格式保存id,username和canvasid
            sStatus := '生成加密字符串代码异常！';
            sTmp    := joInfo;
            sTmp    := dwAESEncrypt(sTmp,gjoConfig.key);

            //将当前登录用户信息写入cookie
            if PnRemember.Visible and CKRemember.Checked then begin
                //异常检查变量
                iError  := 27;

                //写cookie
                sStatus := '保存登录信息代码异常！';
                dwSetCookie(self,gjoConfig.cookieprefix+'login',sTmp,24*gjoConfig.expire);
                //写域名cookie
                if gjoConfig.Exists('domain') then begin
                    //异常检查变量
                    iError  := 28;

                    dwSetCookiePro(self,gjoConfig.cookieprefix+'login',sTmp,'/','.'+gjoConfig.domain,24*gjoConfig.expire);  //
                end;
            end else begin
                //异常检查变量
                iError  := 29;

                //写cookie
                sStatus := '未保存登录信息代码异常！';
                dwSetCookie(self,gjoConfig.cookieprefix+'login',sTmp,0);

                //异常检查变量
                iError  := 30;

                //写域名cookie
                if gjoConfig.Exists('domain') then begin
                    //异常检查变量
                    iError  := 31;

                    dwSetCookiePro(self,gjoConfig.cookieprefix+'login',sTmp,'/','.'+gjoConfig.domain,-1);  //
                end;
            end;

            //异常检查变量
            iError  := 32;

            //打开新网页
            sStatus := '打开登录成功后网址代码异常！';
            dwOpenUrl(self,gjoConfig.successurl,'_self');

            //异常检查变量
            iError  := 33;
        end;
    except
        dwMessage('登录异常,请联系开发人员!'+IntToStr(iError)+' : '+sStatus,'error',self);
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    sTmp    : String;
    iWrong  : Integer;
    iScreenW    : Integer;
    iScreenH    : Integer;
begin
    //取得客户端唯一标识备用
    gsCanvasId  := dwGetProp(Self,'canvasid');

    //确定是否移动端模式
    gbMobile    := dwIsMobile(Self);

    //根据是否移动端进行处理
    if gbMobile then begin
        //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
        dwSetMobileMode(self,414,736);

        //销毁背景图片
        if ImBg <> nil then begin
            ImBg.Destroy;
        end;

        if gsError = '' then begin

            //登录框全屏
            PnLogin.Align   := alClient;

            //控件加高高度
            EtUser.Height           := 40;
            CbUser.Height           := EtUser.Height;
            cbUser.Hint             := '{"height":"'+IntTostr(EtUser.Height)+'"}';
            EtPassword.Height       := EtUser.Height;
            BtLogin.Height          := EtUser.Height+10;
            PnLogin.Font.Size       := 13;

            //间距拉大
            EtUser.Margins.Bottom       := 30;
            CbUser.Margins.Bottom       := EtUser.Margins.Bottom + (EtUser.Height - CbUser.Height);
            EtPassword.Margins.Bottom   := EtUser.Margins.Bottom;
            PnCaptcha.Margins.Bottom    := EtUser.Margins.Bottom;
            PnRemember.Margins.Bottom   := EtUser.Margins.Bottom;

            //字体
            BtLogin.Font.Size           := 16;

        end;
    end else begin
        //设置当前屏幕显示模式为PC模式
        dwSetPCMode(Self);

        if gsError = '' then begin

            //取得浏览器W/H
            iScreenW    := StrToIntDef(dwGetProp(self,'innerwidth'),0);
            iScreenH    := StrToIntDef(dwGetProp(self,'innerheight'),0);

            //更新登录框位置
            PnLogin.BorderStyle := bsSingle;
            PnLogin.Left        := (iScreenW * dwGetInt(gjoConfig,'left',70) div 100) - 180;
            PnLogin.Top         := (iScreenH * dwGetInt(gjoConfig,'top',40) div 100) - 270;

            //设置高度至少能显示完整登录框P_Login
            Height  := Max(Height,PnLogin.Top+PnLogin.Height+10);

            //
            cbUser.Hint         := '{"height":"'+IntTostr(EtPassword.Height)+'"}';
        end;
    end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
    if gsError <> '' then begin
        //显示错误信息
        LaError.Caption := gsError;
        LaError.Visible := True;
        //
        PnLogin.Destroy;
        //销毁背景图片
        if ImBg <> nil then begin
            ImBg.Destroy;
        end;
    end;
end;

end.
