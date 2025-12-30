unit gLogin;
(*
    通用登录模块公用函数单元
*)
interface

uses
    dwBase,

    //
    SynCommons,

    //
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
    FireDAC.Comp.DataSet,

    //
    variants,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup;

//根据当前配置和cookie检查是否为合法用户，如是返回cookie的JSON明文，否则 返回空值
//参数：
//  AConfig : String;           登录配置信息，应为主目录下'Data/'+AConfig+'.json'
//  AConnection:TFDConnection   对应数据库连接
//
//返回值：
//  cookie的JSON明文
function  glCheckLoginInfo(AConfig : String; AConnection:TFDConnection):String;

//清除cookie信息
function  glClearLoginInfo(AConfig : String; AForm:TForm):String;

//添加用户信息
//AConfig   为配置文件名, 路径为runtime/data, 如:dwFrameEn, 表示配置文件为runtime/data/dwFrameEn.json
//AUserName 为拟添加的用户名, 如果当前用户名存在,则直接修改其密码; 如果没有, 则创建
//APassword 为当前用户名的密码(明文)
//返回值:   成功返回0, 其他返回负值

function  glAddLoginInfo(AConfig,AUserName,APassword : String; AConnection:TFDConnection):Integer;

//检查glogin的合法性
function  glCheckConfig(AJOConfig:Variant):Integer;

implementation

function  glCheckConfig(AJOConfig:Variant):Integer;
begin
    Result  := 0;

    //
    //
    if AJOConfig = unassigned then begin
        AJOConfig    := _json('{}');
    end;
    //logo
    if not AJOConfig.Exists('logo') then begin
        AJOConfig.logo := 'media/images/glogin/logo.jpg';
    end;
    //电脑登录时的背景色
    if not AJOConfig.Exists('background') then begin
        AJOConfig.background   := 'media/images/glogin/background.jpg';
    end;
    //电脑登录时登录框中心点的左边距， 百分制
    if not AJOConfig.Exists('left') then begin
        AJOConfig.left    := 60;
    end;
    //电脑登录时登录框中心点的上边距，百分制
    if not AJOConfig.Exists('top') then begin
        AJOConfig.top    := 40;
    end;
    //页面标题
    if not AJOConfig.Exists('caption') then begin
        AJOConfig.caption    := 'Welcome to login';
    end;
    //是否使用验证码
    if not AJOConfig.Exists('captcha') then begin
        AJOConfig.captcha    := 1;
    end;
    //允许错误次数，默认为5次，输错5次后禁止输入3分钟。如果为0，则允许无限次。
    if not AJOConfig.Exists('wrongtimes') then begin
        AJOConfig.wrongtimes    := 5;
    end;
    //是否记住登录信息，以便下次自动登录
    if not AJOConfig.Exists('remember') then begin
        AJOConfig.remember    := 1;
    end;
    //登录信息有效期，单位：天
    if not AJOConfig.Exists('expire') then begin
        AJOConfig.expire    := 30;
    end;
    //账套名称，请与DWS的账套管理相同
    if not AJOConfig.Exists('accountname') then begin
        AJOConfig.accountname    := 'dwFrame';
    end;
    //数据表名称
    if not AJOConfig.Exists('tablename') then begin
        AJOConfig.tablename    := 'sys_user';
    end;
    //用户名 - 字段名称
    if not AJOConfig.Exists('username') then begin
        AJOConfig.username    := 'uName';
    end;
    //密码字段名称
    if not AJOConfig.Exists('password') then begin
        AJOConfig.password    := 'uPassword';
    end;
    //SALT字段名称，仅采用密文时有效
    if not AJOConfig.Exists('salt') then begin
        AJOConfig.salt    := 'uSalt';
    end;
    //用户唯一标识字段名称
    if not AJOConfig.Exists('idname') then begin
        AJOConfig.idname    := 'uId';
    end;
    //cookie的前缀，过程中用到多个前缀,注意不要和其他系统重复
    if not AJOConfig.Exists('cookieprefix') then begin
        AJOConfig.cookieprefix  := 'gl_';
    end;
    //域名， 比如： delphibbs.com
    if not AJOConfig.Exists('domain') then begin
        AJOConfig.domain    := '';
    end;
    //对COOKIE信息进行加密的密钥
    if not AJOConfig.Exists('key') then begin
        AJOConfig.key    := 'dw@12345';
    end;
    //数据库中保存用户密码时是否使用MD5加密方式，1表示加官，0：表示明文
    if not AJOConfig.Exists('secret') then begin
        AJOConfig.secret    := 1;
    end;
    //用户输错登录信息时的提示
    if not AJOConfig.Exists('errormessage') then begin
        AJOConfig.errormessage    := '请输入有效的用户信息！';
    end;
    //用户多次输错登录信息时的提示(禁止3分钟)
    if not AJOConfig.Exists('disablemessage') then begin
        AJOConfig.disablemessage    := '多次输入错误，请3分钟后再试！';
    end;
    //登录信息正常时跳转的URL
    if not AJOConfig.Exists('successurl') then begin
        AJOConfig.successurl    := 'dwFrame';
    end;

end;

function  glAddLoginInfo(AConfig,AUserName,APassword : String; AConnection:TFDConnection):Integer;
var
    oConnection : TFDConnection;
    oQuery      : TFDQuery;
    oForm       : TForm;
    //
    sDir        : string;
    sSalt       : String;
    sPassword   : string;
    //
    joConfig    : Variant;
begin
    //
    Result      := 0;

    try
        AUserName   := Trim(AUserName);
        APassword   := Trim(APassword);

        //
        if (AUserName = '') or (APassword = '') then begin
            Result  := -2;
        end;

        //取得当前窗体
        oForm   := TForm(AConnection.Owner);

        //创建FDQuery
        oQuery  := TFDQuery.Create(oForm);
        oQuery.Connection   := AConnection;

        //检查配置文件是否存在
        sDir    := ExtractFilePath(Application.ExeName);
        if FileExists(sDir+'Data/'+AConfig+'.json') then begin
            //载入
            dwLoadFromJson(joConfig,sDir+'Data/'+AConfig+'.json');

            //检查合法性，补齐属性
            glCheckConfig(joConfig);

            //
            oQuery.Close;
            oQuery.SQL.Text := 'SELECT * FROM '+joConfig.tablename
                    +' WHERE '+joConfig.username+'='''+AUserName+'''';
            oQuery.Open;

            //
            if oQuery.IsEmpty then begin
                oQuery.Append;
            end else begin
                oQuery.Edit;
            end;

            //根据是否加密分别处理
            if dwGetInt(joConfig,'secret')=1 then begin
                //::::: md5加密保存密码

                //取得salt和加密后的password
                sSalt       := 'dewebsystem'+FormatDateTime('YYYYMMDDhhmmsszzz',now);
                sPassword   := dwGetMD5(dwGetMD5(APassword)+sSalt);

                //
                oQuery.FieldByName(dwGetStr(joConfig,'salt','salt')).AsString       := sSalt;
                oQuery.FieldByName(dwGetStr(joConfig,'password','psd')).AsString    := sPassword;
            end else begin
                oQuery.FieldByName(dwGetStr(joConfig,'password','psd')).AsString    := APassword;
            end;
            oQuery.Post;
        end else begin
            dwMessage('配置文件不存在!'#13+sDir+'Data/'+AConfig+'.json','error',oForm);
            Result  := -2;
        end;
    except
        Result  := -1;
    end;

    //
    if oQuery <> nil then begin
        oQuery.Destroy;
    end;
end;



function  glCheckLoginInfo( AConfig : String; AConnection:TFDConnection):String;
var
    oQuery      : TFDQuery;
    oForm       : TForm;
    //
    sDir        : string;
    sCookie     : string;
    sCanvasId   : string;
    //
    joConfig    : Variant;
    joInfo      : Variant;
begin
    //
    Result  := '';

    try

        //取得当前窗体
        oForm   := TForm(AConnection.Owner);

        //创建FDQuery
        oQuery  := TFDQuery.Create(oForm);
        oQuery.Connection   := AConnection;

        //
        sDir    := ExtractFilePath(Application.ExeName);
        if FileExists(sDir+'Data/'+AConfig+'.json') then begin
            dwLoadFromJson(joConfig,sDir+'Data/'+AConfig+'.json');

            //检查合法性，补齐属性
            glCheckConfig(joConfig);

            //
            sCanvasId   := dwGetProp(oForm,'canvasid');

            //取得cookie
            sCookie := dwGetCookie(oForm,joConfig.cookieprefix+'login');
            //解密
            sCookie := dwAESDecrypt(sCookie,joConfig.key);
            //转换为json
            joInfo  := _json(sCookie);

            //
            if joInfo <> unassigned then begin
                if joInfo.Exists('username') then begin
                    oQuery.Close;
                    oQuery.SQL.Text := 'SELECT * FROM '+joConfig.tablename
                            +' WHERE '+joConfig.username+'='''+joInfo.username+'''';
                    oQuery.Open;
                    //
                    if not oQuery.IsEmpty then begin
                        Result  := joInfo;
                    end;
                end;
            end;
        end;
    except
        Result  := '';
    end;

    //
    if oQuery <> nil then begin
        oQuery.Destroy;
    end;

end;


//清除cookie信息
function  glClearLoginInfo(AConfig : String; AForm:TForm):String;
var
    //
    sDir        : string;
    //
    joConfig    : Variant;
begin
    //
    Result  := '';

    try
        //
        sDir    := ExtractFilePath(Application.ExeName);
        if FileExists(sDir+'Data/'+AConfig+'.json') then begin
            dwLoadFromJson(joConfig,sDir+'Data/'+AConfig+'.json');

            //检查合法性，补齐属性
            glCheckConfig(joConfig);

            //
            dwDeleteCookiePro(AForm,joConfig.cookieprefix+'login',dwGetStr(joconfig,'domain'));

        end;
    except

    end;

end;


end.

