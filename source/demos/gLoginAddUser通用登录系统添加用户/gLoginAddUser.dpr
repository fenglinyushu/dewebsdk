library gLoginAddUser;

uses
  ShareMem,

  //
  dwBase,

  //JSON解析单元
  SynCommons,

  //
  Vcl.Controls,
  SysUtils,
  Forms,
  Messages,
  StdCtrls,
  Variants,
  Windows,
  Classes,
  Data.Win.ADODB,
  unit1 in 'unit1.pas' {Form1};

{$R *.res}

var
     DLLApp         : TApplication;
     DLLScreen      : TScreen;

function dwLoad(AParams:String;AConnection:Pointer;AApp:TApplication;AScreen:TScreen):TForm;stdcall;
var
    sDir        : String;   //系统运行目录，一般为...\runtime\
    sParams     : String;   //参数
    sName       : String;   //配置文件名称，默认为main，指配置文件为main.json
    sSuccessUrl : String;   //可能在URL中指定的登录后跳转的URL，默认为空
    iPos        : Integer;  //pos函数结果
    //
    joParams    : Variant;  //参数JSON对象
    joRegister  : Variant;  //可能存在的注册 对象
    //
    oBRegister  : TButton;
begin
    //
    Application := AApp;
    Screen      := AScreen;

    //创建Form
    Form1       := TForm1.Create(nil);

    //取得当前路径
    sDir        := ExtractFilePath(Application.ExeName);

    //将AParams转换为JSON对象，以便后续处理，AParams类似如下：
    (*
        {
            "db":[
                    {"name":"dwAccess","handle":[54772212,55219036,55220860,55222684,55224508]},
                    {"name":"dwFrame","handle":[55232060,55251576,55259824,55261576,55240876]},
                    {"name":"dwCourse","handle":[55253644,55253908,55234064,55235212,55237300]},
                    {"name":"dwDaMeng","handle":[55268108,55274340,55250172,55269840,55268516]},
                    {"name":"dwMySQL","handle":[0,0,0,0,0]},
                    {"name":"dwDemo","handle":[55296080,55297772,55299544,55301256,55302844]},
                    {"name":"dwTest","handle":[55303296,55296488,55309084,55310228,55311216]}
                ],
            "app":{
                "name":"glogin",
                "params":"dwframe"
            }
        }'
    *)
    joParams    := _json(AParams);

    //从joParams中取得配置文件名称, 也有可能包括successurl， 形如：dwframe&&success=abc
    sParams     := joParams.app.params;
    sSuccessUrl := '';
    if sParams = '' then begin
        sName   := 'main';  //配置文件名称默认为main.json
    end else begin
        //检查是否有&&
        iPos    := pos('&&',sParams);
        if iPos > 0 then begin
            //如果有&&，则表示包括指定跳转URL，形如： dwframe&&success=abc
            //取得配置文件名称
            sName   := Copy(sParams,1,iPos-1);
            //取指定的跳转URL
            iPos    := pos('success=',sParams);
            Delete(sParams,1,iPos+7);
            sSuccessUrl := sParams;
        end else begin
            sName   := sParams;
        end;
    end;

    //读取配置文件到JSON对象
    dwBase.dwLoadFromJson(Form1.gjoConfig,sDir+'Data/'+sName+'.json');

    //<检查配置JSON对象的属性是否完备，如果不存在，则取默认值
    with Form1 do begin
        if gjoConfig = unassigned then begin
            gjoConfig    := _json('{}');
        end;
        //logo
        if not gjoConfig.Exists('logo') then begin
            gjoConfig.logo := 'media/images/glogin/logo.jpg';
        end;
        //电脑登录时的背景图
        if not gjoConfig.Exists('background') then begin
            gjoConfig.background   := 'media/images/glogin/background.jpg';
        end;
        //电脑登录时登录框中心点的左边距， 百分制
        if not gjoConfig.Exists('left') then begin
            gjoConfig.left    := 60;
        end;
        //电脑登录时登录框中心点的上边距，百分制
        if not gjoConfig.Exists('top') then begin
            gjoConfig.top    := 40;
        end;
        //页面标题
        if not gjoConfig.Exists('caption') then begin
            gjoConfig.caption    := 'Welcome to login';
        end;
        //是否使用验证码
        if not gjoConfig.Exists('captcha') then begin
            gjoConfig.captcha    := 1;
        end;
        //允许错误次数，默认为5次，输错5次后禁止输入3分钟。如果为0，则允许无限次。
        if not gjoConfig.Exists('wrongtimes') then begin
            gjoConfig.wrongtimes    := 5;
        end;
        //是否记住登录信息，以便下次自动登录
        if not gjoConfig.Exists('remember') then begin
            gjoConfig.remember    := 1;
        end;
        //登录信息有效期，单位：天
        if not gjoConfig.Exists('expire') then begin
            gjoConfig.expire    := 30;
        end;
        //账套名称，请与DWS的账套管理相同
        if not gjoConfig.Exists('accountname') then begin
            gjoConfig.accountname    := 'dwAccess';
        end;
        //数据表名称
        if not gjoConfig.Exists('tablename') then begin
            gjoConfig.tablename    := 'dw_user';
        end;
        //id字段名称
        if not gjoConfig.Exists('id') then begin
            gjoConfig.id    := 'id';
        end;
        //用户名 - 字段名称
        if not gjoConfig.Exists('username') then begin
            gjoConfig.username    := 'username';
        end;
        //密码字段名称
        if not gjoConfig.Exists('password') then begin
            gjoConfig.password    := 'psd';
        end;
        //SALT字段名称，仅采用密文时有效
        if not gjoConfig.Exists('salt') then begin
            gjoConfig.salt    := 'salt';
        end;
        //用户唯一标识字段名称
        if not gjoConfig.Exists('idname') then begin
            gjoConfig.idname    := 'id';
        end;
        //cookie的前缀，过程中用到多个前缀,注意不要和其他系统重复
        if not gjoConfig.Exists('cookieprefix') then begin
            gjoConfig.cookieprefix  := 'gl_';
        end;
        //域名， 比如： delphibbs.com
        if not gjoConfig.Exists('domain') then begin
            gjoConfig.domain    := '';
        end;
        //对COOKIE信息进行加密的密钥
        if not gjoConfig.Exists('key') then begin
            gjoConfig.key    := 'dw@12345';
        end;
        //数据库中保存用户密码时是否使用MD5加密方式，1表示加官，0：表示明文
        if not gjoConfig.Exists('secret') then begin
            gjoConfig.secret    := 1;
        end;
        //用户输错登录信息时的提示
        if not gjoConfig.Exists('errorhint') then begin
            gjoConfig.errorhint    := '请输入有效的用户信息！';
        end;
        //用户多次输错登录信息时的提示(禁止3分钟)
        if not gjoConfig.Exists('disablehint') then begin
            gjoConfig.disablehint    := '多次输入错误，请稍晚些再试！';
        end;

        //登录信息正常时跳转的URL
        if not gjoConfig.Exists('successurl') then begin
            gjoConfig.successurl    := 'default';
        end;
        if sSuccessUrl <> '' then begin     //通用URL中指定的跳转URL优先
            gjoConfig.successurl := sSuccessUrl;
        end;

    end;
    //>

    //
    with Form1 do begin
        //标题
        Caption     := sName;



    end;

    //指定数据库连接
    Form1.FDConnection1.SharedCliHandle := dwBase.dwGetCliHandleByName(AParams,Form1.gjoConfig.accountname);

    //返回
    Result      := Form1;
end;

procedure DLLUnloadProc(dwReason: DWORD);
begin
     if dwReason = DLL_PROCESS_DETACH then begin
          Application    := DLLApp; //恢复
          Screen         := DLLScreen;
     end;
end;

exports
     dwLoad;

begin
     DLLApp    := Application;     //保存 DLL 中初始的 Application 对象
     DLLScreen := Screen;
     DLLProc   := @DLLUnloadProc;  //保证 DLL 卸载时恢复原来的 Application
     DLLUnloadProc(DLL_PROCESS_DETACH);
end.
