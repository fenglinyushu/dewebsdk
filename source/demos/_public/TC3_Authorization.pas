{
2021-02-15
广西南宁
张旭州
腾讯云 TC3-HMAC-SHA256 生成鉴权数据
}

unit TC3_Authorization;

interface

uses
  System.SysUtils, System.hash, System.NetEncoding, System.DateUtils;

{ -------------------------------------------------------------------------------
  过程名:    genTC3Auth
  作者:      张旭州
  日期:      2021.02.15
  参数:      SecretKey, SecretId, sDomain, bodyJSON, Service: string
  参数说明： AccessKeyID，AccessKeySecret，域名, 待发送的数据主体JSON， 服务ocr, cvm
  返回值:    string

  参数参考如下：
    SecretKey := '您的腾讯云SecretKey';
    SecretId := '您的腾讯云SecretId';
    Service := 'sms'  //发送短信
    sDomain := 'sms.tencentcloudapi.com'   //短信发送的域名
  ------------------------------------------------------------------------------- }
function genTC3Auth(SecretKey, SecretId, sDomain, bodyJSON, Service: string): string;

implementation


function DateTimeToUnix(const AValue: TDateTime): Int64;
// 日期转Unix时间戳
begin
  Result := System.DateUtils.DateTimeToUnix(AValue) - 8 * 60 * 60;
end;

//腾讯云TC3 V3签名鉴权
function genTC3Auth(SecretKey, SecretId, sDomain, bodyJSON, Service: string): string;
var
  httpRequestMethod: string; // = "POST";
  canonicalUri: string; //= "/";
  canonicalQueryString: string; //= "";
  canonicalHeaders: string; // = "content-type:application/json; charset=utf-8\n" + "host:" + host + "\n";
  signedHeaders: string; //= "content-type;host";
  SecretDate, SecretService, SecretSigning, Signature: TBytes;
  StringToSign, payload, CanonicalRequest, HashedRequestPayload, HashedCanonicalRequest: string;
  sDate,timestamp : string;
  Authorization, CredentialScope : string;
begin
  sDate := FormatDateTime('YYYY-MM-DD', now());
  timestamp := DateTimeToUnix(now).ToString;
  httpRequestMethod := 'POST';
  canonicalUri := '/';
  canonicalQueryString := '';
  canonicalHeaders := 'content-type:application/json' + #10
      + 'host:' + sDomain + #10;
  signedHeaders := 'content-type;host';

  payload := bodyJSON;
  //待发送的数据的哈希值:
  HashedRequestPayload := THashSHA2.GetHashString(payload);

  //拼接规范请求串
  CanonicalRequest := httpRequestMethod + #10
      + canonicalUri + #10
      + canonicalQueryString + #10
      + canonicalHeaders + #10
      + signedHeaders + #10
      + HashedRequestPayload;

  //计算派生签名密钥
  SecretDate := THashSHA2.GetHMACAsBytes(sDate, TEncoding.utf8.GetBytes('TC3' + SecretKey));
  SecretService := THashSHA2.GetHMACAsBytes(Service, SecretDate);
  SecretSigning := THashSHA2.GetHMACAsBytes('tc3_request', SecretService);

  //规范请求串的哈希值
  HashedCanonicalRequest := THashSHA2.GetHashString(CanonicalRequest);
  //组装待签名字符串
  StringToSign := 'TC3-HMAC-SHA256' + #10
      + timestamp + #10
      + sDate + '/' + Service + '/tc3_request' + #10
      + HashedCanonicalRequest;
  //计算签名
  Signature := THashSHA2.GetHMACAsBytes(Bytesof(StringToSign), SecretSigning);
//  Application.MessageBox(PChar(THash.DigestAsString(Signature)),
//      '提示', MB_OK + MB_ICONINFORMATION + MB_TOPMOST);

  CredentialScope := sDate + '/' + Service + '/tc3_request';
  //拼接 Authorization
  Authorization :=
    'TC3-HMAC-SHA256' + ' ' +
    'Credential=' + SecretId + '/' + CredentialScope + ', ' +
    'SignedHeaders=' + SignedHeaders + ', ' +
    'Signature=' + StringReplace(PChar(THash.DigestAsString(Signature)), Chr(13) + Chr(10), '',
    [rfReplaceAll]);

  Result := Authorization;
end;

end.
