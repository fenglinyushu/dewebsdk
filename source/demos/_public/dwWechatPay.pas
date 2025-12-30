unit dwWechatPay;
(*
    功能说明：
    --------------------------------------------------------------------------------------------------------------------
    用于通过一个Image完成微信扫码支付, 支付后激活该image的OnContextpopup事件
*)


interface

uses
    //
    dwBase,

    //
    wxUserInfo,

    //
    SynCommons{用于解析JSON},

    //
    DelphiZXIngQRCode,

    //第三方
    IdCustomHTTPServer, IdHashSHA, IdGlobal, IdHTTP, IdSSLOpenSSL, IdMultipartFormData,

    //
    Math,
    ComObj, Imaging.Jpeg,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    XMLIntf,xmldoc,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;


//初始化模块
function  wpInit(AImage:TImage):Integer;

//接收并处理消息
function  wpReceive(AImage:TImage;AData: TWMCopyData):Integer;


//取当前配置，可能与原来的hint有所区别，主要是增加了默认值和自动生成的配置
function  wpGetConfig(AImage:TImage):Variant;

//销毁dwCrud，以便二次创建
function  wpDestroy(AImage:TImage):Integer;

implementation

function _RunJs(const JsCode, JsVar: string): string;
var
    script: OleVariant;
begin
    try
        script := CreateOleObject('ScriptControl');
        script.Language := 'JavaScript';
        script.ExecuteStatement(JsCode);
        Result := script.Eval(JsVar);
    except
        Result := '';
    end;
end;


function _GetMD5JS(AStr:String):string;
const
    _JS =
    '!function(n){"use strict";function t(n,t){var r=(65535&n)+(65535&t);return(n>>16)+(t>>16)+(r>>16)<<16|65535&r}function r(n,t){return n<<t|n>>>32-t}function e(n,e,o,u,c,f){return t(r(t(t(e,n),t(u,f)),c),o)}'
    +'function o(n,t,r,o,u,c,f){return e(t&r|~t&o,n,t,u,c,f)}function u(n,t,r,o,u,c,f){return e(t&o|r&~o,n,t,u,c,f)}function c(n,t,r,o,u,c,f){return e(t^r^o,n,t,u,c,f)}function f(n,t,r,o,u,c,f){return e(r^(t|~o),n,t,u,c,f)}'
    +'function i(n,r){n[r>>5]|=128<<r%32,n[14+(r+64>>>9<<4)]=r;var e,i,a,d,h,l=1732584193,g=-271733879,v=-1732584194,m=271733878;for(e=0;e<n.length;e+=16)i=l,a=g,d=v,h=m,g=f(g=f(g=f(g=f(g=c(g=c(g=c(g=c(g=u(g=u(g=u(g=u(g=o(g=o'
    +'(g=o(g=o(g,v=o(v,m=o(m,l=o(l,g,v,m,n[e],7,-680876936),g,v,n[e+1],12,-389564586),l,g,n[e+2],17,606105819),m,l,n[e+3],22,-1044525330),v=o(v,m=o(m,l=o(l,g,v,m,n[e+4],7,-176418897),g,v,n[e+5],12,1200080426),l,g,n[e+6],17,-1473231341)'
    +',m,l,n[e+7],22,-45705983),v=o(v,m=o(m,l=o(l,g,v,m,n[e+8],7,1770035416),g,v,n[e+9],12,-1958414417),l,g,n[e+10],17,-42063),m,l,n[e+11],22,-1990404162),v=o(v,m=o(m,l=o(l,g,v,m,n[e+12],7,1804603682),g,v,n[e+13],12,-40341101),l,g,'
    +'n[e+14],17,-1502002290),m,l,n[e+15],22,1236535329),v=u(v,m=u(m,l=u(l,g,v,m,n[e+1],5,-165796510),g,v,n[e+6],9,-1069501632),l,g,n[e+11],14,643717713),m,l,n[e],20,-373897302),v=u(v,m=u(m,l=u(l,g,v,m,n[e+5],5,-701558691),g,v,n[e+10],'
    +'9,38016083),l,g,n[e+15],14,-660478335),m,l,n[e+4],20,-405537848),v=u(v,m=u(m,l=u(l,g,v,m,n[e+9],5,568446438),g,v,n[e+14],9,-1019803690),l,g,n[e+3],14,-187363961),m,l,n[e+8],20,1163531501),v=u(v,m=u(m,l=u(l,g,v,m,n[e+13],5,-1444681467),'
    +'g,v,n[e+2],9,-51403784),l,g,n[e+7],14,1735328473),m,l,n[e+12],20,-1926607734),v=c(v,m=c(m,l=c(l,g,v,m,n[e+5],4,-378558),g,v,n[e+8],11,-2022574463),l,g,n[e+11],16,1839030562),m,l,n[e+14],23,-35309556),v=c(v,m=c(m,l=c(l,g,v,m,n[e+1],4,-1530992060),'
    +'g,v,n[e+4],11,1272893353),l,g,n[e+7],16,-155497632),m,l,n[e+10],23,-1094730640),v=c(v,m=c(m,l=c(l,g,v,m,n[e+13],4,681279174),g,v,n[e],11,-358537222),l,g,n[e+3],16,-722521979),m,l,n[e+6],23,76029189),v=c(v,m=c(m,l=c(l,g,v,m,n[e+9],4,-640364487),g,'
    +'v,n[e+12],11,-421815835),l,g,n[e+15],16,530742520),m,l,n[e+2],23,-995338651),v=f(v,m=f(m,l=f(l,g,v,m,n[e],6,-198630844),g,v,n[e+7],10,1126891415),l,g,n[e+14],15,-1416354905),m,l,n[e+5],21,-57434055),v=f(v,m=f(m,l=f(l,g,v,m,n[e+12],6,1700485571),'
    +'g,v,n[e+3],10,-1894986606),l,g,n[e+10],15,-1051523),m,l,n[e+1],21,-2054922799),v=f(v,m=f(m,l=f(l,g,v,m,n[e+8],6,1873313359),g,v,n[e+15],10,-30611744),l,g,n[e+6],15,-1560198380),m,l,n[e+13],21,1309151649),v=f(v,m=f(m,l=f(l,g,v,m,'
    +'n[e+4],6,-145523070),g,v,n[e+11],10,-1120210379),l,g,n[e+2],15,718787259),m,l,n[e+9],21,-343485551),l=t(l,i),g=t(g,a),v=t(v,d),m=t(m,h);return[l,g,v,m]}function a(n){var t,r="",e=32*n.length;'
    +'for(t=0;t<e;t+=8)r+=String.fromCharCode(n[t>>5]>>>t%32&255);return r}function d(n){var t,r=[];for(r[(n.length>>2)-1]=void 0,t=0;t<r.length;t+=1)r[t]=0;var e=8*n.length;for(t=0;t<e;t+=8)r[t>>5]|=(255&n.charCodeAt(t/8))<<t%32;return r}'
    +'function h(n){return a(i(d(n),8*n.length))}function l(n,t){var r,e,o=d(n),u=[],c=[];for(u[15]=c[15]=void 0,o.length>16&&(o=i(o,8*n.length)),r=0;r<16;r+=1)u[r]=909522486^o[r],c[r]=1549556828^o[r];return e=i(u.concat(d(t)),512+8*t.length),'
    +'a(i(c.concat(e),640))}function g(n){var t,r,e="";for(r=0;r<n.length;r+=1)t=n.charCodeAt(r),e+="0123456789abcdef".charAt(t>>>4&15)+"0123456789abcdef".charAt(15&t);return e}function v(n){return unescape(encodeURIComponent(n))}function m(n)'
    +'{return h(v(n))}function p(n){return g(m(n))}function s(n,t){return l(v(n),v(t))}function C(n,t){return g(s(n,t))}function A(n,t,r){return t?r?s(t,n):C(t,n):r?m(n):p(n)}"function"==typeof define&&define.amd?define(function(){return A}):'
    +'"object"==typeof module&&module.exports?module.exports=A:n.md5=A}(this);'#13;

var
    sJS : string;
begin
    sJS := _JS + 'var hash=md5("'+AStr+'");';
    Result  := _RunJs(sJS,'hash');
end;

function _PostMethod(Url: String; Data: UTF8String; Max: Integer): String;
var
    PostData: TStringStream;
    RespData: TStringStream;
    HTTP    : TIdHTTP;
    SSL     : TIdSSLIOHandlerSocketOpenSSL;
begin
    RespData    :=TStringstream.Create('',TEncoding.UTF8);
    PostData := TStringStream.Create(Data);
    SSL := TIdSSLIOHandlerSocketOpenSSL.Create;
    HTTP := TIdHTTP.Create;
    HTTP.IOHandler := SSL;
    try
        try
            if HTTP = nil then
                Exit;
            HTTP.Post(Url, PostData, RespData);
            Result := RespData.DataString;
            HTTP.Request.Referer := Url;
        except
        end;
    finally
        HTTP.Disconnect;
        HTTP.Free;
        SSL.Free;
        FreeAndNil(RespData);
        FreeAndNil(PostData);
    end;
end;


function _GetCodeUrl(AData:String;var AResult:String):String;
var
    Url     : string;
    xdDoc   : IXMLDocument;
begin
    //
    Url     := 'https://api.mch.weixin.qq.com/pay/unifiedorder';
    AResult := _PostMethod(Url, UTF8String(AData),1);
    xdDoc   := TXMLDocument.Create(nil);
    xdDoc.LoadFromXML(AResult);
    Result  := xdDoc.DocumentElement.ChildNodes['code_url'].Text;
end;

//根据URL生成图片文件
procedure _UrlToQrCode(AUrl:String;ASize:Integer;AFileName:String);
var
    QRCode  : TDelphiZXingQRCode;
    Row, Column: Integer;
    QRCodeBitmap: TBitmap;
    oImage  : TImage;
    Scale   : Double;
    oJpg    : TJPEGImage;
begin
    QRCodeBitmap := TBitmap.Create;
    QRCode := TDelphiZXingQRCode.Create;
    try
        QRCode.Data := AUrl;
        QRCode.Encoding := TQRCodeEncoding(0);
        QRCode.QuietZone := 4;//StrToIntDef(, 4);
        QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
        for Row := 0 to QRCode.Rows - 1 do begin
            for Column := 0 to QRCode.Columns - 1 do begin
                if (QRCode.IsBlack[Row, Column]) then  begin
                    QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
                end else begin
                    QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
                end;
            end;
        end;
    finally
        QRCode.Free;
    end;
    //
    oImage  := TImage.Create(nil);
    oImage.Width    := ASize;
    oImage.Height   := ASize;
    oImage.Canvas.Brush.Color := clWhite;
    oImage.Canvas.FillRect(Rect(0, 0, oImage.Width, oImage.Height));
    if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then begin
        if (oImage.Width < oImage.Height) then begin
            Scale := oImage.Width / QRCodeBitmap.Width;
        end else begin
            Scale := oImage.Height / QRCodeBitmap.Height;
        end;
        oImage.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width), Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
    end;
    QRCodeBitmap.Free;
    //
    oJpg    := TJPEGImage.Create;
    oJpg.Assign(oImage.Picture.Graphic);
    oJpg.SaveToFile(AFileName);
    oImage.Destroy;
    FreeAndNil(oJpg);
end;

Procedure wpOnTimer(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oTimer      : TTimer;
    oImage      : TImage;
    //
    sImageName  : String;   //写在oForm的Hint中
    oPt         : TPoint;
    bHandled    : Boolean;
const
    bDebug      = False;
    procedure Console(AMsg:String);
    begin
        if bDebug then begin
            dwRunJS('console.log(`'+AMsg+'`);',oForm);
        end;
    end;
begin
    //取得时间控件
    oTimer      := TTimer(Sender);

    //
    if oTimer <> nil then begin
        //取得各控件
        oForm       := TForm(oTimer.Owner);

        if oForm <> nil then begin
            //
            Console('oForm <>nil');

            // oTimer.Tag = 987123 表示已收到支付成功消息
            if oTimer.Tag = 987123 then begin
                //
                Console('oTimer.Tag = 987123');
                //
                sImageName  := dwGetProp(oForm,'wechatimage');
                //
                Console(sImageName);
                //
                oImage  := TImage(oForm.FindComponent(sImageName));
                if oImage <> nil then begin
                    //
                    Console('oImage<> nil');
                    //
                    if Assigned(oImage.OnContextPopup) then begin
                        //
                        Console('Assigned(oImage.OnContextPopup)');
                        //
                        oImage.OnContextPopup(oImage,oPt,bHandled);
                    end else begin
                        //
                        Console('not Assigned(oImage.OnContextPopup)');
                    end;
                end else begin
                    //
                    Console('oImage is nil');
                end;

                //停止时钟
                oTimer.DesignInfo   := 0;
                oTimer.Enabled      := False;
            end else begin
                //
                Console('oTimer.Tag <> 987123');
            end;
        end else begin

        end;
    end;
end;

function wpGetConfig(AImage:TImage):Variant;
begin
    try
        //取配置JSON : 读AForm的 cpConfig 变量值
        Result  := dwJson(AImage.Hint);

        //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        //Appid
        if dwGetStr(Result,'appid','')='' then begin
            Result.appid    := _dwwechat_Appid;
        end;
        //body
        if dwGetStr(Result,'body','')='' then begin
            Result.body := 'unknown';
        end;
        //商户号
        if dwGetStr(Result,'mchid','')='' then begin
            Result.mchid  := _dwwechat_Mch_Id;
        end;
        //noncestr
        if dwGetStr(Result,'noncestr','')='' then begin
            Result.noncestr	:= 'noncestr';
        end;
        //微信服务器支付完成后的回调地址
        if dwGetStr(Result,'notifyurl','')='' then begin
            Result.notifyurl    := _dwwechat_Notify_url;
        end;
        //自动生成交易号(此处outtradeno的前18位可以自由设置, 不重复就好. 一般为2位标识+15位时间+下划线
        //第19位(包含)后应该是发起方窗体的handle, 以方便发送交易消息
        if dwGetStr(Result,'outtradeno','')='' then begin
            Result.outtradeno   := 'MD'+FormatDateTime('YYMMDDhhmmsszzz',now)+'_'+IntToStr(TForm(AImage.Owner).Handle);;
        end;
        //服务器IP
        if dwGetStr(Result,'spbillcreateip','')='' then begin
            Result.spbillcreateip  := _dwwechat_ServerIP;
        end;
        //金额
        if dwGetInt(Result,'totalfee',0) <= 0 then begin
            Result.totalfee  := 1;
        end;
        //
        if dwGetStr(Result,'key','')='' then begin
            Result.key  := _dwwechat_NativeKey;
        end;


        //name
        if dwGetStr(Result,'name','')='' then begin
            Result.name	:= 'unname';
        end;
        if dwGetStr(Result,'imagedir','')='' then begin
            Result.imagedir	:= 'media/images/wechat/';
        end;
        //>

    except

    end;
end;

//接收并处理消息
function  wpReceive(AImage:TImage;AData: TWMCopyData):Integer;
var
    sData       : string;
    joConfig    : Variant;
    oForm       : TForm;
    oTimer      : TTimer;
begin
    //应该收到的是交易号
    sData   := Trim(PChar(AData.CopyDataStruct.lpData));

    //showmessage('WMC geted sData');
    //
    joConfig    := wpGetConfig(AImage);

    //
    if joConfig <> unassigned then begin
        if dwGetStr(joConfig,'outtradeno','')= sData then begin
            //取Form
            oForm   := TForm(AImage.Owner);

            //
            oTimer  := TTimer(oForm.FindComponent('Timer__wechatpay'));

            //设置一个特殊的数字表示已支付成功
            if oTimer <> nil then begin
                oTimer.Tag  := 987123;
            end;
        end;
    end;
end;

function wpInit(AImage:TImage):Integer;
type
    TdwGetEditMask  = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
    TdwEndDock      = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    joConfig    : variant;
    //
    oForm       : TForm;
    oTimer      : TTimer;       //用于监视支付状态的时钟
    //
    sString     : String;
    sSign       : String;
    sXML        : String;
    sCodeUrl    : String;
    sRes        : string;
    //
    sName       : string;
    //
    tM          : TMethod;      //用于指定事件
begin
    //默认返回值
    Result  := 0;

    //-----------------处理字段, 主要是无字段情况下自动生成字段列表-----------------------------------------------------
    try
        //
        oForm       := TForm(AImage.Owner);

        //
        joConfig    := wpGetConfig(AImage);
        if joConfig = unassigned then begin
            dwMessage('Image的Hint中格式不正确或参数不完整!','error',oForm);
            Exit;
        end;

    except
        //异常时调试使用
        Result  := -1;
    end;

    //------------------------------------------------------------------------------------------------------------------
    if Result = 0 then begin
        try
            //把当前图片的名称保存的oForm.Hint中, 以备后面使用
            dwSetProp(oForm,'wechatimage',AImage.Name);

            //<计算签名
            //得到计算签名用的字符串 sString
            sString := 'appid='+joConfig.appid                          //微信公众号ID
                    +'&body='+joConfig.body                             //商名显示名称,显示在扫码后的界面上
                    +'&mch_id='+joConfig.mchid                          //服务商ID
                    +'&nonce_str='+joConfig.noncestr                    //备用字符串
                    +'&notify_url='+joConfig.notifyurl+'?'+joConfig.outtradeno                  //回调url
                    +'&out_trade_no='+joConfig.outtradeno               //每次必须不同的交易号
                    +'&spbill_create_ip='+joConfig.spbillcreateip       //IP
                    +'&total_fee='+IntToStr(joConfig.totalfee)              //价格(元)
                    +'&trade_type=NATIVE'                       //交易方式,固定值
                    +'&key='+joConfig.key;   //KEY
            sSign   := UpperCase(_GetMD5JS(sString));
            //>

        except
            //异常时调试使用
            Result  := -2;
        end;
    end;


    //------------------------------------------------------------------------------------------------------------------
    if Result = 0 then begin
        try

            //<取得XML字符串
            sXML    := '<xml>'#13#10
                    +'<appid><![CDATA['+joConfig.appid+']]></appid>'#13#10
                    +'<body><![CDATA['+joConfig.body+']]></body>'#13#10
                    +'<mch_id>'+joConfig.mchid+'</mch_id>'#13#10
                    +'<nonce_str><![CDATA['+joConfig.noncestr+']]></nonce_str>'#13#10
                    +'<notify_url><![CDATA['+joConfig.notifyurl+'?'+joConfig.outtradeno+']]></notify_url>'#13#10
                    +'<out_trade_no><![CDATA['+joConfig.outtradeno+']]></out_trade_no>'#13#10
                    +'<spbill_create_ip><![CDATA['+joConfig.spbillcreateip+']]></spbill_create_ip>'#13#10
                    +'<total_fee>'+IntToStr(joConfig.totalfee)+'</total_fee>'#13#10
                    +'<trade_type><![CDATA[NATIVE]]></trade_type>'#13#10
                    +'<sign><![CDATA['+sSign+']]></sign>'#13#10
                    +'</xml>';
            //>

            //<取得code_URL.即二维码的链接字符串。 将sxml提交到微信，微信返回该值
            sCodeUrl    := _GetCodeUrl(sXML,sRes);
            if sCodeUrl = '' then begin
                dwMessage('error when _GetCodeUrl : '+sRes,'error',oForm);
                Exit;
            end;
            //>
        except
            //异常时调试使用
            Result  := -3;
        end;
    end;

    //------------------------------------------------------------------------------------------------------------------
    if Result = 0 then begin
        try
            //
            Randomize;
            sName := FormatDateTime('YYYYMMDDhhmmsszzz_',Now)+Format('%4.4d',[Random(10000)]);
            _UrlToQrCode(sCodeUrl,300,ExtractFilePath(Application.ExeName) + joConfig.imagedir + sName + '.jpg');

            //>
        except
            //异常时调试使用
            Result  := -4;
        end;
    end;

    //------------------------------------------------------------------------------------------------------------------
    if Result = 0 then begin
        try


            //设置显示
            joConfig.src    := joConfig.imagedir+sName+'.jpg';
            AImage.Hint     := joConfig;

            //
            oTimer      := TTimer.Create(oForm);
            with oTimer do begin
                Name            := 'Timer__wechatpay';
                Interval        := 1000;
                //
                tM.Code         := @wpOnTimer;
                tM.Data         := Pointer(325); // 随便取的数
                OnTimer         := TNotifyEvent(tM);
            end;
            //>
        except
            //异常时调试使用
            Result  := -5;
        end;
    end;


    //
    if Result <> 0 then begin
        dwMessage('Error when WechatPay : '+IntToStr(Result),'error',oForm);
    end;
end;

//销毁dwCrud，以便二次创建
function  wpDestroy(AImage:TImage):Integer;
var
    sPrefix     : String;
    joConfig    : Variant;
    oForm       : TForm;
    oPanel      : TPanel;
begin
    try
        //取得form备用
        oForm   := TForm(AImage.Owner);

        //
        joConfig    := wpGetConfig(AImage);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //销毁编辑面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PEr'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁删除面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁Query面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PQy'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁主表板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PQC'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;


    except

    end;
end;


end.
