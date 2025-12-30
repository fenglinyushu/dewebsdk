unit vUnits;

interface

uses
    //第三方
    SynCommons,
    IdCustomHTTPServer, IdHashSHA, IdGlobal, IdHTTP, IdSSLOpenSSL, IdMultipartFormData,

    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client,

    //
    Math,
    Graphics,
    Data.Win.ADODB,
    Variants,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls,  Vcl.ComCtrls;



function GetMethod(Url: String; Max: Integer): String;

function PostMethod(Url: String; Data: UTF8String; Max: Integer): String;

procedure CheckVaccine(AOpenId:String;FDQuery_User,FDQuery_Inoc,FDQuery_Vacc:TFDQuery);
function  dwGetAccessToken(Aappid, AappSecret: String;FDQuery1:TFDQuery): String;
function  _GetWeChatConf(AFile:String;var ADomain,AAppID,AAppSecret:String):Integer;


implementation

//==============================================================================
//说明
//为读取微信开发者信息的单元
//输入值为当前目录下的wechat.conf,格式 为JSON格式
//格式如下：
//{
//    domain":"delphibbs.com",
//    "appid":"wxc12560f7fbxxxxxx",
//    "appsecret":"43bf2ca4ed18f2ed9b7a80a88cxxxxxx"
//}
//返回值：正常返加0，否则返回-1
//使用需要 先引用 SynCommons
function _GetWeChatConf(AFile:String;var ADomain,AAppID,AAppSecret:String):Integer;
var
    slFile  : TstringList;
    joConf  : variant;
begin
    //默认返回值
    Result      := -1;
    AAppId      := '';
    AAppSecret  := '';
    ADomain     := '';

    if FileExists(AFile) then begin
        slFile  := TStringList.Create;
        slFile.LoadFromFile(AFile);
        joConf  := _json(slFile.Text);
        if joConf <> unassigned then begin
            if joConf.Exists('appid') then begin
                AAppId      := joConf.appid;
            end;
            if joConf.Exists('appsecret') then begin
                AAppSecret  := joConf.appsecret;
            end;
            if joConf.Exists('domain') then begin
                ADomain     := joConf.domain;
            end;
        end;
        slFile.Destroy;
        //
        Result  := 0;
    end;
end;


procedure CheckVaccine(AOpenId:String;FDQuery_User,FDQuery_Inoc,FDQuery_Vacc:TFDQuery);
var
    iNum        : Integer;
    iDate       : Integer;
    iMonth      : Integer;
    iUser       : Integer;
    iVid        : Integer;
    iAgeStart   : Integer;
    iAgeEnd     : Integer;
    //
    fDate       : Double;
    fNow        : Double;
    fAge        : Double;       //当前年龄
    //
    sName       : string;
    sVName      : string;
    sOpenId     : string;
    //
    joUsers     : Variant;
    joUser      : Variant;
    joDates     : Variant;  //各针次时间
    vRes        : Variant;
begin
    //检查当前用户的所有人员的接种信息是否完全都已存在

    //人员数据表
    FDQuery_User.Close;
    if AOpenId='' then begin
        FDQuery_User.SQL.Text      := 'SELECT * FROM v_user ORDER BY birthday';
    end else begin
        FDQuery_User.SQL.Text      := 'SELECT * FROM v_user WHERE openid='''+AOpenId+''' ORDER BY birthday';
    end;
    FDQuery_User.Open;

    //将数据保存到JSON
    joUsers := _json('[]');
    while not FDQuery_User.Eof do begin
        joUser  := _json('{}');
        joUser.id       := FDQuery_User.FieldByName('id').AsInteger;
        joUser.username := FDQuery_User.FieldByName('username').AsString;
        joUser.openid   := FDQuery_User.FieldByName('openid').AsString;
        //fDate           := FDQuery_User.FieldByName('birthday').AsDateTime;
        joUser.birthday := FDQuery_User.FieldByName('birthday').AsDateTime ;
        joUser.age      := (Now-FDQuery_User.FieldByName('birthday').AsDateTime)/365 ;
        //
        joUsers.add(joUser);
        //
        FDQuery_User.Next;
    end;

    //接种数据表
    if AOpenId = '' then  begin
        FDQuery_Inoc.Close;
        FDQuery_Inoc.SQL.Text      := 'SELECT * FROM v_Inoculation ';
        FDQuery_Inoc.Open;
    end else begin
        FDQuery_Inoc.Close;
        FDQuery_Inoc.SQL.Text      := 'SELECT * FROM v_Inoculation WHERE openid='''+AOpenId+'''';
        FDQuery_Inoc.Open;
    end;

    //人员数据表
    //FDQuery_User.Close;
    //FDQuery_User.SQL.Text      := 'SELECT * FROM v_user WHERE openid='''+AOpenId+''' ORDER BY birthday';
    //FDQuery_User.Open;

    //疫苗数据表
    FDQuery_Vacc.Close;
    FDQuery_Vacc.SQL.Text      := 'SELECT * FROM v_vaccine ';
    FDQuery_Vacc.Open;

    //
    fNow    := Now;
    while not FDQuery_Vacc.Eof do begin
        iNum    := FDQuery_Vacc.FieldByName('num').AsInteger;

        //疫苗ID,名称
        iVId    := FDQuery_Vacc.FieldByName('id').AsInteger;
        sVName  := FDQuery_Vacc.FieldByName('name').AsString;

        //接种时间，单位：月
        joDates := _json('['+FDQuery_Vacc.FieldByName('date').AsString+']');
        //
        for iDate := 0 to joDates._Count-1 do begin
            iMonth  := joDates._(iDate);    //得到month数
            //
            for iUser := 0 to joUsers._Count-1 do begin
                joUser  := joUsers._(iUser);
                sName   := joUser.username;
                //检查是否过期
                fDate       := joUser.birthday + Max(1,iMonth) * 31;
                iAgeStart   := FDQuery_Vacc.FieldByName('agestart').AsInteger;
                iAgeEnd     := FDQuery_Vacc.FieldByName('ageend').AsInteger;

                //跳过
                if (joUser.age<iAgeStart) or (joUser.age>iAgeEnd)  then begin
                    Continue;
                end;

                if  (fDate >= fNow) or (iAgeStart>=20) then begin
                    //检查数据库中是否有。如果没有，则添加
                    //vRes    := FDQuery_Inoc.Lookup('username;vaccineid;no',VarArrayOf([joUser.username,iVId,iDate+1]),'v_user;v_vaccineid;v_no');
                    //if VarType(vRes) = varNull then begin
                    if not FDQuery_Inoc.Locate('username;vaccineid;no;openid',VarArrayOf([sName,iVId,iDate+1,string(joUser.openid)]),[]) then begin
                        //此时应该有接种信息

                        FDQuery_Inoc.Append;
                        FDQuery_Inoc.FieldByName('username').AsString       := joUser.username;
                        FDQuery_Inoc.FieldByName('openid').AsString         := joUser.openid;
                        FDQuery_Inoc.FieldByName('birthday').AsFloat        := joUser.birthday;
                        FDQuery_Inoc.FieldByName('vaccineid').AsInteger     := iVId;
                        FDQuery_Inoc.FieldByName('vaccinename').AsString    := sVName;
                        FDQuery_Inoc.FieldByName('no').AsInteger            := iDate+1;
                        FDQuery_Inoc.FieldByName('plandate').AsFloat        := Max(IncYear(joUser.birthday,iAgeStart),IncMonth(joUser.birthday,iMonth));
                        FDQuery_Inoc.FieldByName('price').AsInteger         := FDQuery_Vacc.FieldByName('price').AsInteger;
                        FDQuery_Inoc.FieldByName('remind').AsInteger        := 0;
                        FDQuery_Inoc.Post;
                    end;
                end;

            end;
        end;
        //
        FDQuery_Vacc.Next;
    end;
end;

//取得access_token
//条件：
//    界面需要控件FDQuery1
//参数：
//    分别为appid和appsecret
//返回值：
//    字符串型
function dwGetAccessToken(Aappid, AappSecret: String;FDQuery1:TFDQuery): String;
var
    sUrl        : string;
    sRes        : string;
    joRes       : variant;
begin
    Result  := '';
    //<检查数据库内是否存在有效的access_token,如果没有，则读取
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM dw_system WHERE name=''wechat_access_token''';
    FDQuery1.Open;

    //如果不存在，或已过期，则重新取得
    Result  := '';
    if FDQuery1.IsEmpty OR (FDQuery1.FieldByName('expire').AsDateTime<Now) then begin
        //
        sUrl    := 'https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid=%s&secret=%s';
        sUrl    := Format(sUrl,[AappId,AappSecret]);
        //
        sRes    := GetMethod(sUrl, 1);
        joRes   := _json(sRes);
        if joRes <> unassigned then begin
            if joRes.Exists('access_token') then begin
                Result  := joRes.access_token;
                //写入数据库
                if FDQuery1.IsEmpty then begin
                    FDQuery1.Append;
                end else begin
                    FDQuery1.Edit;
                end;
                FDQuery1.FieldByName('name').AsString      := 'wechat_access_token';
                FDQuery1.FieldByName('value').AsString     := Result;
                FDQuery1.FieldByName('expire').AsDateTime  := Now + 7000/3600/24;
                FDQuery1.Post;
            end;
        end;
    end else begin
        Result  := FDQuery1.FieldByName('value').AsString;
    end;
    //>

end;


//==============================================================================
function GetMethod(Url: String; Max: Integer): String;
var
    RespData    : TStringStream;
    HTTP        : TIdHTTP;
    SSL         : TIdSSLIOHandlerSocketOpenSSL;
begin
  RespData := TStringStream.Create('', TEncoding.UTF8);
  SSL := TIdSSLIOHandlerSocketOpenSSL.Create;
  HTTP := TIdHTTP.Create;
  HTTP.IOHandler := SSL;
  try
    try
      HTTP.Get(Url, RespData);
      HTTP.Request.Referer := Url;
      Result := RespData.DataString;
    except
    end;
  finally
    HTTP.Free;
    SSL.Free;
    FreeAndNil(RespData);
  end;
end;

function PostMethod(Url: String; Data: UTF8String; Max: Integer): String;
var
  PostData, RespData: TStringStream;
  HTTP: TIdHTTP;
  SSL: TIdSSLIOHandlerSocketOpenSSL;
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
//==============================================================================


end.
