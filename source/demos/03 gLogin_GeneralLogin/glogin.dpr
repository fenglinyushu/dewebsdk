library glogin;

uses
    ShareMem,

    //
    dwBase,
    dwDB,

    //JSON解析单元
    SynCommons,

    //
    FireDAC.Phys.Intf, FireDAC.Comp.Client,

    //
    Vcl.Controls,
    SysUtils,
    Forms,
    Messages,
    StdCtrls,
    Variants,
    Windows,
    Classes,
    Math,
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
    sTmp        : String;   //临时字符串变量
    iPos        : Integer;  //pos函数结果
    iWrong      : Integer;
    //
    joParams    : Variant;  //参数JSON对象
    joRegister  : Variant;  //可能存在的注册 对象
    //
    oBRegister  : TButton;
    //
    bFound      : Boolean;
    slTables    : TStringList;


    function _FieldExists(const AConnection:TFDConnection; const ATableName, AFieldName: string): Boolean;
    var
        slFields: TStringList;
    begin
        Result  := False;


        slFields := TStringList.Create;
        try
            // 获取指定表的所有字段名
            AConnection.GetFieldNames('', '', ATableName, '', slFields);

            // 检查字段是否存在
            Result := slFields.IndexOf(AFieldName) >= 0;
        finally
            slFields.Free;
        end;
    end;

    function _TableExists(FDConnection1: TFDConnection; ATableName: string): Boolean;
    var
        MetaInfo: TFDMetaInfoQuery;
    begin
        Result := False;

        MetaInfo := TFDMetaInfoQuery.Create(nil);
        try
            MetaInfo.Connection := FDConnection1;

            // 设置元数据查询类型为表
            MetaInfo.MetaInfoKind := mkTables;

            // 设置过滤条件
            MetaInfo.CatalogName := '';
            MetaInfo.SchemaName := '';
            MetaInfo.ObjectName := ATableName;

            try
                MetaInfo.Open;

                // 遍历所有表，检查是否存在指定表名
                while not MetaInfo.Eof do begin
                    if SameText(MetaInfo.FieldByName('TABLE_NAME').AsString, ATableName) then begin
                        Result := True;
                        Break;
                    end;
                    MetaInfo.Next;
                end;

                MetaInfo.Close;
            except
                // 有些数据库可能不支持某些元数据查询
                Result := False;
            end;
        finally
            MetaInfo.Free;
        end;
    end;

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
        sName   := 'glDefault';  //配置文件名称默认为 glDefault.json
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


    //<检查配置JSON对象的属性是否完备，如果不存在，则取默认值
    with Form1 do begin
        //默认无异常
        gsError := '';

        //
        if not FileExists(sDir+'Data/'+sName+'.json') then begin
            gsError := 'Config file not exists! '#13+stringReplace(sDir,'\','/',[rfReplaceAll])+'Data/'+sName+'.json';
        end else begin
            //读取配置文件到JSON对象
            dwBase.dwLoadFromJson(Form1.gjoConfig,sDir+'Data/'+sName+'.json');
        end;

        if gsError = '' then begin
            if (gjoConfig = unassigned) OR (String(gjoConfig) = 'null') then begin
                gsError := 'Config file is not JSON! '#13+stringReplace(sDir,'\','/',[rfReplaceAll])+'Data/'+sName+'.json';
            end;
        end;

        if gsError = '' then begin
            //账套名称，请与DWS的账套管理相同
            if not gjoConfig.Exists('accountname') then begin
                gsError := '配置文件中缺少账套信息( "accountname" )! ';
            end;
        end;

        if gsError = '' then begin
            //数据表名称
            if not gjoConfig.Exists('tablename') then begin
                gsError := '配置文件中缺少数据表名称字段信息( "tablename" )! ';
            end;
        end;

        if gsError = '' then begin
            //id字段名称
            if not gjoConfig.Exists('id') then begin
                gsError := '配置文件中缺少数据表索引字段信息( "id" )! ';
            end;
        end;

        if gsError = '' then begin
            //用户名 - 字段名称
            if not gjoConfig.Exists('username') then begin
                gsError := '配置文件中缺少数据表用户名字段信息( "username" )! ';
            end;
        end;

        if gsError = '' then begin
            //密码字段名称
            if not gjoConfig.Exists('password') then begin
                gjoConfig.password    := 'psd';
                gsError := '配置文件中缺少数据表密码字段信息( "password" )! ';
            end;
        end;

        if gsError = '' then begin
            //成功后跳转网址字段名称
            if not gjoConfig.Exists('successurl') then begin
                gjoConfig.password    := 'psd';
                gsError := '配置文件中缺少登录成功后跳转的网址信息( "successurl" )! ';
            end;
        end;

        if gsError = '' then begin
            //SALT字段名称，仅采用密文时有效
            if dwGetInt(gjoConfig,'secret') = 1 then begin
                if not gjoConfig.Exists('salt') then begin
                    gsError := '配置文件中缺少数据表密码的盐字段信息( "salt" )! ';
                end;
            end;
        end;


        if gsError = '' then begin
            //数据库中保存用户密码时是否使用MD5加密方式，1表示加官，0：表示明文
            if not gjoConfig.Exists('secret') then begin
                gjoConfig.secret    := 0;
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

        //更新属性 -----------------------------------------------------------------------------------------------------
        if gsError <> '' then begin
            //标题
            Caption     := 'Error';

            //显示错误信息
            LaError.Caption := gsError;
            LaError.Visible := True;
        end else begin
            //标题
            Caption     := gjoConfig.caption;

            //
            PnLogin.Visible := True;

            //加载图片
            ImBg.Align  := alClient;
            ImBg.Hint   := '{"src":"'+gjoConfig.background+'"}';

            //
            ImLogo.Hint     := '{"src":"'+gjoConfig.logo+'"}';

            //默认用户名
            if gjoConfig.Exists('defaultusername') then begin
                EtUser.Text := gjoConfig.defaultusername;
            end;

            //默认密码
            if gjoConfig.Exists('defaultpassword') then begin
                EtPassword.Text := gjoConfig.defaultpassword;
            end;


            //记住登录信息
            PnRemember.Visible  := gjoConfig.remember = 1;

            //验证码
            case gjoConfig.captcha of
                //不显示验证码
                0 : begin
                    PnCaptcha.Visible   := False;
                end;
                //显示验证码
                1 : begin
                    PnCaptcha.Visible   := True;
                end;
                //初次不显示验证码，输入错误后显示验证码
                2 : begin
                    //取得错误次数
                    sTmp    := dwGetCookie(Form1,gjoConfig.cookieprefix+'wrongtimes');
                    iWrong  := Max(0,StrToIntDef(sTmp,0));
                    PnCaptcha.Visible   := iWrong > 0;
                end;
            end;

            //指定数据库连接
            FDConnection1.SharedCliHandle := dwBase.dwGetCliHandleByName(AParams,Form1.gjoConfig.accountname);

            //
            if Integer(FDConnection1.SharedCliHandle) = 0 then begin
                gsError := '未取到数据库账套或指定的账套未正常连接！';
            end;

            //
            if gsError = '' then begin
                if not _TableExists(FDConnection1,gjoConfig.tablename) then begin
                    gsError := '数据库内不存在指定的用户表 : '+gjoConfig.tablename;
                end;
            end;


            if gsError = '' then begin
                if not _FieldExists(FDConnection1,gjoConfig.tablename,gjoConfig.id) then begin
                    gsError := '数据库用户表不存在指定的字段 : '+gjoConfig.id;
                end;
            end;

            if gsError = '' then begin
                if not _FieldExists(FDConnection1,gjoConfig.tablename,gjoConfig.username) then begin
                    gsError := '数据库用户表不存在指定的字段 : '+gjoConfig.username;
                end;
            end;

            if gsError = '' then begin
                if not _FieldExists(FDConnection1,gjoConfig.tablename,gjoConfig.password) then begin
                    gsError := '数据库用户表不存在指定的字段 : '+gjoConfig.password;
                end;
            end;

            //
            if gsError = '' then begin
                if dwGetInt(gjoConfig,'listuser') = 1 then begin
                    EtUser.Visible      := False;
                    CbUser.Visible      := True;
                    CbUser.Top          := 170;
                    //
                    dwGetComboBoxItems(FDQuery1,gjoConfig.tablename,gjoConfig.username,false,cbUser);
                    //
                    if gjoConfig.Exists('defaultusername') then begin
                        CbUser.Text := gjoConfig.defaultusername;
                    end;
                end;
            end;
        end;
    end;

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
