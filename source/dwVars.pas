unit dwVars;

//以下该行为STD版标志，如果有以下行，则为标准版，可免费永久使用，但不可使用Helpkeyword扩展的控件。
//{$DEFINE _STD}



interface

uses

    //第三方控件
    SynCommons,

    //
    OverbyteIcsWinSock, OverbyteIcsWSocket, OverbyteIcsWndControl,
    OverbyteIcsHttpSrv, OverbyteIcsUtils,   OverbyteIcsFormDataDecoder, OverbyteIcsMimeUtils,

    //求MD5
    IdHashMessageDigest,IdGlobal, IdHash,

    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    //
    ADODB,
    HTTPApp,XpMan,
    //IdURI,
    //SynaCode,
    Generics.Collections, //用于TDictionary
    Math,
    DateUtils,
    TypInfo,
    Variants,
    Graphics,
    Dialogs,
    ComObj,    //用于scriptcontrol
    Windows, Messages, SysUtils, Classes, Controls, Forms,
    StdCtrls, ExtCtrls, StrUtils;
const
     WebServVersion     = 837;
     CopyRight : String = 'WebServ (c) 1999-2016 F. Piette V8.37 ';
     NO_CACHE           = 'Pragma: no-cache' + #13#10 + 'Expires: -1' + #13#10;
     WM_CLIENT_COUNT    = WM_USER + 1;
     //FILE_UPLOAD_URL    = '/cgi-bin/FileUpload/';
     FILE_UPLOAD_URL    = '/dwupload';

var
    //
    giResource          : Integer = 0;              //是使用本地资源（.js,.css等）0，   还是使用公用（七牛云） 1, 或第三方（2）
    giExpire            : Integer = 1800;           //服务端Form的有效时间，单位为秒。如果1800秒未发送心跳包，则清除
    gsResource          : array[0..2] of String = (
                            'dist',
                            'https://cdn.delphibbs.com/dist',
                            'https://cdn.delphibbs.com/dist'
                        );
    gsUPLOAD_DIR        : string = 'upload\';
    gsMAX_UPLOAD_SIZE   : Integer = 60; // Accept max 60MB file
    gsErrorHtml         : string =
        '''
        <!DOCTYPE html>
        <html lang="zh">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>页面不存在</title>
            <style>
                .message {
                    text-align: center;
                }
                .message p {
                    font-size: 16px;
                    color: #555;
                    margin: 10px 0;
                }
                button {
                    padding: 6px 16px;
                    font-size: 16px;
                    background-color: #409EFF;
                    color: white;
                    border: none;
                    border-radius: 4px;
                    cursor: pointer;
                }
                button:hover {
                    background-color: #66b1ff;
                }
            </style>
        </head>
        <body>
            <div class="message">
                <p>抱歉，您访问的页面不存在</p>
                <button onclick="location.reload()">刷新页面</button>
            </div>
        </body>
        </html>
        ''';

    //用于执行JS的对象，主要处理各种字符串编码和解码
    goJavaScript        : OleVariant;

const
    _Head : string =
        '<!DOCTYPE html>'#13#10     //<!DOCTYPE html>
        +'<html lang="zh-CN">'#13#10
        +''#13#10
        +'<head>'#13#10
        +'<meta charset="utf-8">'#13#10
        //+'<meta  name="keywords" content="delphi,web,unigui,intraweb,deweb,delphibbs">'#13
        //+'<meta  name="description" content="Delphi Web Application Framework">'#13
        //+'<meta name="viewport" content="width=device-width, initial-scale=1.0">'#13
        +'<meta name="viewport" content="width=device-width, initial-scale=1.0,minimum-scale=1.0,maximum-scale=1.0,user-scalable=no">'#13#10
        +'<meta http-equiv="X-UA-Compatible" content="ie=edge">'#13#10
        +'<title>[!caption!]</title>'#13#10
        +'<!-- icon -->'#13#10   //此处用作替换图标, 本行不要做改动
        //为VOD项目单独添加的
        {
        +'<meta name="description" content="星火直播是一款免费的在线电视直播软件，同也是是一款优秀的体育直播平台，除了香港台湾电视以外，还有热门NBA、英超、西甲等篮球足球免费高清直播" />'#13
        +'<meta name="keywords" content="星火直播,星火体育直播,星火电视直播,华人直播,中文电视直播,中文体育直播" />'#13
        +'<link rel="canonical" href="https://www.kds.tw">'#13
        +'<meta property="og:type" content="TV" />'#13
        +'<meta property="og:title" content="星火直播｜体育直播 | 华人直播" />'#13
        +'<meta property="og:description" content="星火直播｜体育直播｜港台直播｜NBA直播｜世界杯直播｜篮球直播｜足球直播" />'#13
        +'<meta property="og:image" content="https://iｍage.kds.tw/logo/kds.png" />'#13
        +'<meta property="og:url" content="https://www.kds.tw" />'#13
        +'<meta property="og:image:width" content="1024" />'#13
        +'<meta property="og:image:height" content="1024" />'#13
        +'<meta name="twitter:card" content="summary_large_image">'#13
        +'<meta name="twitter:image" content="https://iｍage.kds.tw/logo/kds.png">'#13
        +'<link rel="image_src" href="https://iｍage.kds.tw/logo/kds.png">'#13
        +'<!-- Favicon -->'#13
        +'<link rel="icon" href="https://image.kds.tw/logo/favicon.png">'#13
        }
        //
        +'</head>'#13;

     _RESOURCE : string =
        '<script src="dist/_zepto/zepto.min.js" type="text/javascript"></script>'#13#10
        +'<script src="[!resource!]/vue.js" type="text/javascript"></script>'#13#10
        +'<script src="[!resource!]/index.js" type="text/javascript"></script>'#13#10
        +'<script src="[!resource!]/axios.min.js" type="text/javascript"></script>'#13#10
        +'<script src="[!resource!]/deweb.js" type="text/javascript"></script>'#13#10
        +'<link rel="stylesheet" type="text/css" href="[!resource!]/theme-chalk/index.min.css" />'#13#10
        +'<link rel="stylesheet" type="text/css" href="[!resource!]/_deweb/deweb.css" />'#13#10;



Type
     PdwGetExtra    = function (ACtrl:TComponent):string;stdcall;
     PdwGetEvent    = function (ACtrl:TComponent;AData:String):string;StdCall;
     PdwGetHead     = function (ACtrl:TComponent):string;StdCall;
     PdwGetTail     = function (ACtrl:TComponent):string;StdCall;
     PdwGetData     = function (ACtrl:TComponent):string;StdCall;
     PdwGetAction   = function (ACtrl:TComponent):String;StdCall;   //用于操作控件
     PdwGetMount    = function (ACtrl:TComponent):string;StdCall;
     PdwGetMethods  = function (ACtrl:TComponent):string;StdCall;   //用于生成methods段的代码
     //
     PdwCreate      = function (APara:String):TForm;StdCall;
     //载入应用，并创建窗体函数
     PdwLoad        = function (AParams:String;AConnection:Pointer; AApp:TApplication; AScreen:TScreen):TForm;stdcall;
     //事件函数
     PdwEvent       = function (AForm:TForm;AParams:String;AEvent: PdwGetEvent):Integer;stdcall;
     //直接数据交互函数
     PdwDirect      = function (AData:PWideChar):PWideChar;stdcall;
    //
    TDWVclDLL = record
        DllName     : string;
        Inst        : THandle;
        GetExtra    : PdwGetExtra;
        GetEvent    : PdwGetEvent;
        GetHead     : PdwGetHead;
        GetTail     : PdwGetTail;
        GetData     : PdwGetData;
        GetMount    : PdwGetMount;
        GetAction   : PdwGetAction;     //用于操作控件
        GetMethods  : PdwGetMethods;    //用于生成Methods段代码
    end;
     //
     TDWAppDLL = record
          DllName   : string;      //对应的文件名
          DateTime  : TDateTime;   //创建日期
          Inst      : THandle;     //句柄
          Load      : PdwLoad;     //函数
          //Form      : TForm;       //窗体
          //Html      : String;      //HTML（默认函数）
     end;


var
    gsMainDir           : string;           //执行目录

    //
    giPort              : Integer = 80;     //端口

    //
    giShunt             : Integer = 0;     //分流标识， 用于nginx反代多个DWS时的标识

    //
    gfStartTime         : Double;           //DeWeb Start Time，直接到Now

    //
    goHttpServer        : THttpServer;                //系统的主Http控件

    //
    grDWVcls            : array of TDWVclDLL;         //用于一次性读入DLL, 加快转换速度
    grDWVclExs          : array of TDWVclDLL;         //用于一次性读入DLL(用于引入额外的单元)
    grDWVclNames        : TDictionary<string,Integer>;

    //配置文件
    gjoConfig           : Variant;

    //用于传递给应用DLL的JSON字符串，形如：
    //{
    //  "db":[
    //      {
    //          "name":"MyAccess",
    //          "handle":[12543,87477,34324,994501,25534]
    //      },
    //      {
    //          "name":"MS SQL 2000 test",
    //          "handle":[65543,85427,34986,342101,77734]
    //      }
    //  ]
    //}
    //
    gjoConnections      : Variant;

    //锁定文件
    LockFileAccess      : TRtlCriticalSection;

//比较两次FORM中各控件的关键信息,生成client端的JS语句
//2021-01-14 屏蔽TEdit的OnChange事件造成的Text变化
function dwGetDiffs(ABefore,AAfter:Variant;AComponent:String):Variant;

//仅得到最新的各控件关键信息,用于增加或删除了控件的情况
function dwGetAfters(AAfter:Variant):Variant;

//根据CID取得FORM
function  dwGetFormByCID(ACID:Integer):TForm;

//ShowMessage
procedure dwShowMsg(AMsg,ACaption,AButtonCaption:String;AForm:TForm);
procedure dwShowMessage(AMsg:String;AForm:TForm);

//OpenUrl 打开 一个URL  window.open("http://www.cnblogs.com/liumengdie/"，“_blank”);
procedure dwNavigate(AUrl:String;ANew:Boolean;AForm:TForm);

//MessageDlg
procedure dwMessageDlg(AMsg,ACaption,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);

//根据函数名称执行函数
procedure dwExecMethodByName(AObject: TObject; AMethodName,APara: string) ;

//InputQuery
procedure dwInputQuery(AMsg,ACaption,ADefault,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);

//FormToHtml
function dwFormToHtml(AForm:TForm):String;

//FormToDiv
function dwFormToDiv(AForm:TForm):String;

//根据控件的Hint生成JSON
function dwGetHintJson(ACtrl:TControl):Variant;

//生成可见性字符串
function dwVisible(ACtrl:TControl):String;

//生成可用性字符串
function dwDisable(ACtrl:TControl):String;

//生成LTWH字符串
function dwLTWH(ACtrl:TControl):String;      //可以更新位置的用法
function dwLTWHComp(ACtrl:TComponent):String;  //可以更新位置的用法

//检查HINT的JOSN对象中如果存在在某属性,则返回字符串
//如果存在 AJsonName 则 返回 AHtmlName = AJson.AJsonName;
//                 否则 返回 ADefault
function dwGetHintValue(AHint:Variant;AJsonName,AHtmlName,ADefault:String):String;

function dwIIF(ABool:Boolean;AYes,ANo:string):string;

const
     _DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';            //参数依次为:JS事件名称 ---  控件名称,控件值,D事件名称,备用

//解密函数
function dwDecryptKey (Src:String; Key:String):string;

//Delphi 颜色转HTML 颜色字符串
function dwColor(AColor:Integer):string;

//
function dwEncodeURIComponent(S:String):String;
function dwDecodeURIComponent(S:String):String;

function dwBoolToStr(AVal:Boolean):string;
function dwIsNull(AVar:Variant):Boolean;

//处理DELPHI中的特殊字符
function dwConvertStr(AStr:String):String;

//处理DELPHI中Caption的特殊字符
function dwProcessCaption(AStr:String):String;

//用于对中文进行编码, 对应JS中的escape函数
function dwEscape(const StrToEscape:string):String;
function dwUnescape(S: string): string;

//保存/读取以Hint中存放的值
function dwSetProp0(ACtrl:TControl;AAttr,AValue:String):Integer;
function dwGetProp(ACtrl:TControl;AAttr:String):String;
function dwGetJsonAttr(AJson:Variant;AAttr:String):String;   //从JSON对象中读取属性值

//读取并生成圆角信息
function dwRadius(AJson:Variant):string;

//重排ACtrl的子要素.   AHorz为真时 水平等宽排列, 否则垂直排列
procedure dwRealignChildren(ACtrl:TWinControl;AHorz:Boolean;ASize:Integer);



//Memo.text转换为elemenu Textarea 的格式
function  dwMemoValueToText(AText:string):string;
function  dwMemoTextToValue(AText:string):string;

procedure showMsg(AMsg:string);

//设置Height
function  dwSetHeight(AControl:TControl;AHeight:Integer):Integer;

//设置PlaceHolder
function  dwSetPlaceHodler(AControl:TControl;APH:String):Integer;

//设置LTWH
function  dwSetCompLTWH(AComponent:TComponent;ALeft,ATop,AWidth,AHeight:Integer):Integer;

//反编码函数
function  dwDecode(AText:string):string;

//
function dwPHPToDate(ADate:Integer):TDateTime;

//
function dwLongStr(AText:String):String;

//排列Panel的子控件
procedure dwRealignPanel(APanel:TPanel;AHorz:Boolean);


function dwStop:Integer;

function dwGetText(AText:string;ALen:integer):string;

function dwGetMD5(AStr:String):string;

//ssShift, ssAlt, ssCtrl,ssLeft, ssRight,
//分别对应0:未知/1:PC/2:Android/3:iPhone/4:Tablet
function  dwPlatFormToShiftState(APlatform:Integer):TShiftState;
function  dwShiftStateToPlatForm(AShiftState:TShiftState):string;


//获取文件创建时间
function    dwGetFileDateTime(a_FileName: string;a_Flag: Byte): TDateTime;

//
function    dwStrIsJson(AText:String):Boolean;

//合并两个json字符串
function    dwCombineJson(S0,S1:String): string;

//将提交上来的cookie字符串解析成JSON,存放到Form的Hint字段的_cookies子对象中
function    dwSetFormCookies(AForm:TForm;ACookie:String):Integer;

//从文件中读入JSON
function    dwJsonFromFile(AFileName:String):Variant;

//执行JS代码,并返回值  ACode为代码, AVar是拟返回变量的变量名
function    dwRunJS(ACode,AVar:String):String;

//得到Component对应的DLL名称
function    dwGetCompDllName(AComp:TComponent):String;

function dwHasProperty(AComponent: TComponent; APropertyName: String): Boolean;
function dwIsTForm(AComponent: TComponent): Boolean;



function dwGetDWAttr(AHint:Variant):String;
function dwGetAttr(AHint:Variant;AAttr:String):String;
function dwGetAttrBoolean(AHint:Variant;AAttr:String):String;
function dwGetDWStyle(AHint:Variant):String;



implementation

uses
    dwBase;

function dwGetDWAttr(AHint:Variant):String;
begin
     Result    := '';
     if AHint<>null then begin
          if AHint.Exists('dwattr') then begin
               Result    := ' '+dwGetStr(AHint,'dwattr','');
          end;
     end;
end;


function dwGetAttr(AHint:Variant;AAttr:String):String;
begin
    Result    := '';
    if AHint<>null then begin
        if AHint.Exists(AAttr) then begin
            Result    := ' '+AAttr+'="'+AHint._(AAttr)+'"';
        end;
    end;
end;

function dwGetAttrBoolean(AHint:Variant;AAttr:String):String;
begin
    Result    := '';
    if AHint<>null then begin
        if AHint.Exists(AAttr) then begin
            if AHint._(AAttr) = True then begin
                Result    := ' '+AAttr+'="true"';
            end else begin
                Result    := ' '+AAttr+'="false"';
            end;
        end;
    end;
end;

function dwGetDWStyle(AHint:Variant):String;
begin
     Result    := '';
     if AHint <> unassigned then begin
          if AHint.Exists('dwstyle') then begin
               Result    := (AHint.dwstyle);
          end;
     end;
end;


function dwIsTForm(AComponent: TComponent): Boolean;
begin
    Result  := dwHasProperty(AComponent,'WindowState') and dwHasProperty(AComponent,'PrintScale');
end;

function dwHasProperty(AComponent: TComponent; APropertyName: String): Boolean;
var
    PropInfo:PPropInfo;
begin
    PropInfo:=getpropinfo(AComponent.classinfo,APropertyName);
    Result:=PropInfo<>nil;
end;

//得到Component对应的DLL名称
function    dwGetCompDllName(AComp:TComponent):String;
begin
    //得到默认deweb控件DLL名称
    Result  := lowerCase('dw'+AComp.ClassName+'.dll');
    try
        //TForm窗体统一处理
        if dwHasProperty(AComp,'FormStyle') then begin
            Result  := lowerCase('dwTForm.dll');
        end else begin
            {$IFNDEF _STD}
            //如果有HelpKeyword，则添加相应HelpKeyword
            if dwHasProperty(AComp,'HelpKeyword') then begin
                if TControl(AComp).HelpKeyword <> '' then begin
                    Result  := lowerCase('dw'+AComp.ClassName+'__'+TControl(AComp).HelpKeyword+'.dll');
                end;
            end;
            {$ENDIF}
        end;
    except
        Result  := lowerCase('dw'+AComp.ClassName+'.dll');
    end;
end;

function    dwRunJS(ACode,AVar:String):String;
begin
    try
        goJavaScript.ExecuteStatement(ACode);
        Result  := goJavaScript.Eval(AVar);
    except
        Result := '';
    end;
end;

function dwJsonFromFile(AFileName:String):Variant;
var
    slFile  : TStringList;
begin
    slFile  := TStringList.Create;
    slFile.LoadFromFile(AFileName,TEncoding.UTF8);
    Result  := _json(slFile.Text);
    //slFile.Destroy;
    if slFile <> nil then begin
        FreeAndNil(slFile);
    end;
end;


//将提交上来的cookie字符串解析成JSON,存放到Form的Hint字段的_cookies子对象中
//test=ljt; Edit1=ljt; Ed=ljt
function    dwSetFormCookies(AForm:TForm;ACookie:String):Integer;
var
    joHint      : Variant;
    joCookie    : Variant;
    sName       : String;
    sValue      : String;
begin
    //
    joHint  := _json(AForm.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    //创建_cookies子对象
    joHint._cookies := _json('[]');

    //循环处理
    while Pos(';',ACookie)>0 do begin
        //取得名称
        sName   := Trim(Copy(ACookie,1,Pos('=',ACookie)-1));
        Delete(ACookie,1,Pos('=',ACookie));
        //取得值
        sValue  := Copy(ACookie,1,Pos(';',ACookie)-1);
        Delete(ACookie,1,Pos(';',ACookie));
        //
        joCookie        := _json('{}');
        joCookie.name   := sName;
        joCookie.value  := sValue;
        //
        joHint._cookies.Add(joCookie);
    end;

    //处理最后的值
    if Pos('=',ACookie)>0 then begin
        //取得名称
        sName   := Trim(Copy(ACookie,1,Pos('=',ACookie)-1));
        Delete(ACookie,1,Pos('=',ACookie));
        //取得值
        sValue  := ACookie;
        //
        //
        joCookie        := _json('{}');
        joCookie.name   := sName;
        joCookie.value  := sValue;
        //
        joHint._cookies.Add(joCookie);
    end;

    //
    AForm.Hint  := joHint;

    //
    Result  := 0;
end;


//合并两个json字符串
function  dwCombineJson(S0,S1:String): string;
var
     b0,b1     : Boolean;
begin
     b0   := dwStrIsJson(S0);   //判断是否JSON字符串
     b1   := dwStrIsJson(S1);
     //
     if b0 then begin
          if b1 then begin
               S0     := Trim(S0);
               Delete(S0,Length(S0),1);   //删除最后的花括号
               //
               S1     := Trim(S1);
               Delete(S1,1,1);            //删除最前的花括号
               //
               Result    := S0+','+s1;
          end else begin
               Result    := S0;
          end;
     end else begin
          if b1 then begin
               Result    := S1;
          end else begin
               Result    := S0;
          end;
     end;
end;

function dwStrIsJson(AText:String):Boolean;
begin
    //D自带单元的写法. uses system.json
    //Result  := System.Json.TJSONObject.ParseJSONValue(Trim(AText)) <> nil;

    //mormot的写法
    Result  := _json(AText) <> unassigned;
end;


const
     FILE_CREATE_TIME = 0;  //创建时间
     FILE_MODIFY_TIME = 1;  //修改时间
     FILE_ACCESS_TIME = 3;  //访问时间

function dwGetFileDateTime(a_FileName: string; a_Flag: Byte): TDateTime;
var
    ffd : TWin32FindData;
    dft : DWord;
    lft : TFileTime;
    h   : THandle;
begin
    h:=FindFirstFile(PChar(a_FileName),ffd);
    if h<>INVALID_HANDLE_VALUE then begin
        case a_Flag of
            FILE_CREATE_TIME:FileTimeToLocalFileTime(ffd.ftCreationTime,lft);
            FILE_MODIFY_TIME:FileTimeToLocalFileTime(ffd.ftLastWriteTime,lft);
            FILE_ACCESS_TIME:FileTimeToLocalFileTime(ffd.ftLastAccessTime,lft);
        else
            FileTimeToLocalFileTime(ffd.ftLastAccessTime,lft);
        end;
        FileTimeToDosDateTime(lft,LongRec(dft).Hi,LongRec(dft).Lo);
        Result := FileDateToDateTime(dft);
        Windows.FindClose(h);
    end else
        Result:=0;
end;





function dwIsWinCtrol(ACtrl:TControl):Boolean;
var
    sName   : String;
    oClass  : TClass;
begin
    Result  := False;
    oClass  := ACtrl.ClassParent;

    while True do begin
        sName   := oClass.ClassName;
        oClass  := oClass.ClassParent;
        //
        if sName = 'TWinControl' then begin
            Result    := True;
            break;
        end else if sName = 'TControl' then begin
            Result    := False;
            break;
        end else if sName = 'TComponent' then begin
            Result    := False;
            break;
        end else if sName = 'TGraphicControl' then begin
            Result    := False;
            break;
        end;
    end;

end;


//网上找的TStringList去重函数
procedure RemoveDuplicates(const stringList : TStringList) ;
var
    slOld   : TStringList;
    buffer  : TStringList;
    cnt     : Integer;
    iIndex  : Integer;
begin
    //
    slOld   := TStringList.Create;
    slOld.Assign(stringList);

    //
    slOld.Sort;
    buffer := TStringList.Create;
    try
        buffer.Sorted := True;
        buffer.Duplicates := dupIgnore;
        buffer.BeginUpdate;
        for cnt := 0 to slOld.Count - 1 do begin
            buffer.Add(slOld[cnt]) ;
        end;
        buffer.EndUpdate;
        slOld.Assign(buffer) ;

        //从stringList中剔除重复项
        for cnt := stringList.Count - 1 downto 0 do begin
            iIndex  := slOld.IndexOf(StringList[cnt]);
            if iIndex >= 0 then begin
                slOld.Delete(iIndex);
            end else begin
                StringList.Delete(cnt)
            end;
        end;

    finally
        FreeandNil(buffer) ;
    end;
end;



function dwFormToHtml(AForm:TForm):String;
var
    iCtrl       : Integer;
    iVcl        : Integer;
    iTmp        : Integer;
    iExtrPos    : Integer;      //slHtml中拟插入slExtr的位置
    //
    sExtra      : string;
    sClass      : String;
    sCode       : string;
    sMounted    : string;       //mounted时的事件代码字符串
    sTemp       : string;
    sExt        : String;
    sIco        : string;
    //
    slhtml      : TStringList;  //HTML
    slData      : TStringList;  //Data
    slMeth      : TStringList;  //Methods
    slMoun      : TStringList;  //Mounted
    slExtr      : TStringList;  //额外引入的JS/CSS
    //
    oComp       : TComponent;
    //
    joArray     : Variant;
    joHint      : Variant;
    //
    procedure _AddToHtml(AJson:Variant;AList:TStringList);
    var
         iiArray   : Integer;
    begin
         for iiArray := 0 to AJson._Count-1 do begin
              AList.Add(UTF8ToWideString(AJson._(iiArray)));
        end;
    end;
    //
    procedure _AddToData(AJson:Variant;AList:TStringList);
    var
         iiArray   : Integer;
    begin
         for iiArray := 0 to AJson._Count-1 do begin
            if Trim(AJson._(iiArray))<>'' then begin
                AList.Add(AJson._(iiArray));
            end;
         end;
    end;
    //
    procedure _AddToExtra(AJson:Variant;AList:TStringList);
    var
         iiArray   : Integer;
    begin
         for iiArray := 0 to AJson._Count-1 do begin
              AList.Add(AJson._(iiArray));
         end;
    end;
    procedure _ComponentToHtml(ACtrl:TComponent);
    var
        iiChild   : Integer;
        iDWVcl    : integer;
        //
        joArray   : Variant;     //各控件计算返回值
        //
        sVcl      : string;
    begin
        if grDWVclNames.TryGetValue(dwGetCompDllName(ACtrl),iDWVcl) then begin
            //头部
            sVcl      := grDWVcls[iDWVcl].GetHead(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToHtml(joArray,slHtml);

            //处理容器控件的子控件
            if ACtrl is TWinControl then begin
                for iiChild := 0 to TWinControl(ACtrl).ControlCount-1 do begin
                     //_ControlToHtml(TWinControl(ACtrl).Controls[iiChild]);
                end;
            end;

            //尾部
            sVcl      := grDWVcls[iDWVcl].GetTail(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToHtml(joArray,slHtml);

            //Data值
            sVcl      := grDWVcls[iDWVcl].GetData(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToData(joArray,slData);
        end;
    end;
    procedure _ControlToHtml(ACtrl:TControl);
    var
        iiChild : Integer;
        iiArray : Integer;
        iDWVcl  : Integer;
        //
        joArray : Variant;     //各控件计算返回值
        //
        sVcl    : string;
        bbTmp   : Boolean;


        //
        ooComp  : TComponent;
    begin
        //通过字典技术快速查找对应DLL
        //2024-07-17 使用 dwIsTForm函数 代替 检查ClassName前5是否 'tform'
        if dwIsTForm(ACtrl) then begin
            bbTmp   := grDWVclNames.TryGetValue('dwtform.dll',iDWVcl);
        end else begin
            sVcl    := dwGetCompDllName(ACtrl);
            bbTmp   := grDWVclNames.TryGetValue(sVcl,iDWVcl);
        end;


        if bbTmp then begin

            //插入额外引入的JS/CSS
            if Assigned(grDWVcls[iDWVcl].GetExtra) then begin
                //得到额外的字符串
                sExtra    := grDWVcls[iDWVcl].GetExtra(ACtrl);
                //将字符串转为JSON数组
                joArray   := _json(sExtra);
                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
                //复制到slExtr
                for iiArray := 0 to joArray._Count-1 do begin
                    if slExtr.IndexOf('    '+joArray._(iiArray))<0 then begin
                        slExtr.Add('    '+joArray._(iiArray));
                    end;
                end;

                //_AddToExtra(joArray,slExtr);
            end;


            //头部
            sVcl      := grDWVcls[iDWVcl].GetHead(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToHtml(joArray,slHtml);

            //处理容器控件的子控件
            try
                if dwIsWinCtrol(ACtrl) then begin
                    for iiChild := 0 to TWinControl(ACtrl).ControlCount-1 do begin
                        _ControlToHtml(TWinControl(ACtrl).Controls[iiChild]);
                    end;

                    //如果当前控件为TForm, 则添加其内的Component
                    if dwHasProperty(ACtrl,'WindowMenu') then begin
                        //处理不可见控件
                        for iiChild := 0 to TForm(ACtrl).ComponentCount-1 do begin
                            ooComp  := TForm(ACtrl).Components[iiChild];

                            //
                            if (ooComp.ClassName = 'TMainMenu') then begin
                                _ComponentToHtml(ooComp);
                            end else if (ooComp.ClassName = 'TTimer') then begin
                                _ControlToHtml(TControl(ooComp));
                            end;
                        end;
                    end
                end;
            except

            end;

            //尾部
            if Assigned(grDWVcls[iDWVcl].GetTail) then begin
                sVcl      := grDWVcls[iDWVcl].GetTail(ACtrl);
                joArray   := _json(sVcl);
                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
                //
                _AddToHtml(joArray,slHtml);
            end;

            //Data值
            sVcl      := grDWVcls[iDWVcl].GetData(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToData(joArray,slData);

            //Mounted值
            if Assigned(grDWVcls[iDWVcl].GetMount) then begin
                sVcl      := grDWVcls[iDWVcl].GetMount(ACtrl);
                joArray   := _json(sVcl);
                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
                //
                _AddToData(joArray,slMoun);
            end;

            //Methods值
            if Assigned(grDWVcls[iDWVcl].GetMethods) then begin
                sVcl      := grDWVcls[iDWVcl].GetMethods(ACtrl);
                joArray   := _json(sVcl);
                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
                //
                _AddToData(joArray,slMeth);
            end;


        end;

    end;
begin
    try

        //创建html字符串列表
        slhtml    := TStringList.Create;

        //得到hint
        joHint    := dwGetHintJson(AForm);

        //<替换图标. 在hint中设置icon项, 其中.ico文件路径必须在runtime\media目录下或子孙目录下
        //如果没有指定icon, 则删除当前行字符, 以减少流量
        //如果指定icon, 则替换为设置icon的html字符
        sTemp   := _HEAD;
        if dwGetStr(joHint,'icon','') = '' then begin
            //如果没有设置图标,则删除原代码中关于图标的片段, 以提高速度
            sTemp   := StringReplace(sTemp, '<!-- icon -->'#13#10,'',[]);
        end else begin
            //先取得Hint设置的icon值
            sExt    := dwGetStr(joHint,'icon','');
            //
            sIco    := '<link rel="shortcut icon" href="'+sExt+'"';
            //根据扩展名, 确定后面的type值
            sExt    := LowerCase(Copy(sExt,Length(sExt)-3,4));
            if sExt = '.gif' then begin
                sIco    := sIco +' type="image/gif">';
            end else if sExt = '.png' then begin
                sIco    := sIco +' type="image/png">';
            end else if sExt = '.jpg' then begin
                sIco    := sIco +' type="image/jpeg">';
            end else if sExt = '.svg' then begin
                sIco    := sIco +' type="image/svg+xml">';
            end else begin
                sIco    := sIco +' type="image/x-icon">';
            end;
            //植入到字符串中
            sTemp   := StringReplace(sTemp, '<!-- icon -->',sIco,[]);
        end;
        //>

        //加入头部
        slhtml.Add(sTemp);

        //创建字符串列表，以存放额外引入的Css/js
        slExtr  := TStringList.Create;

        //根据TWindowState.wsNormal进行处理
        //如果wsNormal, 则为居中. 背景色为COLOR或transparentcolorvalue(必须transparentcolor=true)
        //否则, 为全背景
        //if AForm.Windowstate = wsNormal then begin
        if False{AForm.transparentcolor} then begin //底色+前景色的情况,
            //
            slhtml.Add('<body style="overflow:hidden;top:0px;background-color:'+dwColor(AForm.transparentcolorvalue)+'">');


            //添加载入进度图层，置顶层，用于等待OnMouseUp完成分辨率事件
            //两种情况下不显示载入进度图层_loading
            //1 重绘，也就是DockSite := True;
            //2 无OnMouseUp事件
            slhtml.Add('    <style type="text/css">');
            slhtml.Add('    .loading-container{width:50px;height:50px;'
                    +'animation:loading-animation 1s infinite linear;display:inline-block;'
                    +'border:3px solid #f3f3f3;border-top:3px solid #87CEEB;border-radius:50%}'
                    +'@keyframes loading-animation{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}');
            slhtml.Add('    </style>');
            slhtml.Add('    <div id="_loading"'
                    +' style="'
                        +'background-color:'+dwColor(AForm.transparentcolorvalue)+';'
                        +'z-index:990;'
                        +'display: flex;'
                        +'justify-content: center;'
                        +'left:0;'
                        +'top:0;'
                        +'height:100%;'
                        +'width:100%;'
                        +'position:absolute;'
                        +dwIIF(AForm.DockSite OR (not Assigned(AForm.OnMouseUp)),'display:none;','')
                    +'">');
            slhtml.Add('        <div class="loading-container" style="position:absolute;top:100px;">');
            slhtml.Add('        </div>');
            slhtml.Add('    </div>');

            //添加资源
            slhtml.Add(_RESOURCE);

            //保存当前位置，以插入额外的js/css
            iExtrPos    := slHtml.Count;    //+1是为了插入到<!--[app_start]-->后面

            //添加特别的资源
            if joHint.Exists('head') then begin
                for iTmp := 0 to joHint.head._Count-1 do begin
                    slHtml.Add('    '+joHint.head._(iTmp));
                end;
            end;
            //添加主体div
            slhtml.Add('    <!--[style_start]-->');
            slhtml.Add('    <!--[style_end]-->');
            slhtml.Add('    <!--[app_start]-->');
            slhtml.Add('<div id="app"'
                    //+' v-show="form___vis"'
                    +' class="dwnocusor"'
                    +' style="'
                        //+'display:none;'
                        +'position:absolute;'
                        +dwIIF(AForm.VertScrollBar.Visible,'overflow-x:hidden;overflow-y:auto;','overflow:hidden;')
                        +'left:0;'
                        +'right:0;'
                        +'bottom:0;'
                        +'margin: 0 auto;'
                        //+'caret-color: transparent;'    //隐藏光标
                        +'background-color:'+dwColor(AForm.color)
                    +'"'
                    +' :style="{'
                        +'top:'+AForm.name+'__top,'
                        +'width:'+AForm.name+'__wid,'
                        +'height:'+AForm.name+'__hei'
                    +'}"'
                    +' >');
        end else begin //全部一个颜色的情况
            //slhtml.Add('<body style="overflow:hidden;top:0px;background-color:'+dwColor(AForm.color)+'">');
            slhtml.Add(
            '<body '
                +dwGetDWAttr(joHint)
                +' style="'
                    +'top:0px;'
                    +'background-color:'+dwColor(AForm.color)+';'
                    +dwGetDWStyle(joHint)
                +'"'
            +'>');

            //添加载入进度图层，置顶层，用于等待OnMouseUp完成分辨率事件
            //两种情况下不显示载入进度图层_loading
            //1 重绘，也就是DockSite := True;
            //2 无OnMouseUp事件
(*
            slhtml.Add('    <style type="text/css">');
            slhtml.Add('    .loading-container{width:50px;height:50px;'
                    +'animation:loading-animation 1s infinite linear;display:inline-block;'
                    +'border:3px solid #f3f3f3;border-top:3px solid #87CEEB;border-radius:50%}'
                    +'@keyframes loading-animation{0%{transform:rotate(0deg)}100%{transform:rotate(360deg)}}');
            slhtml.Add('    </style>');
*)
            slhtml.Add('    <div id="_loading"'
                    +' style="'
                        +'background-color:#fff;'
                        +'z-index:990;'
                        +'display: flex;'
                        +'justify-content: center;'
                        +'left:0;'
                        +'top:0;'
                        +'height:100%;'
                        +'width:100%;'
                        +'position:absolute;'
                        +dwIIF(AForm.DockSite OR (not Assigned(AForm.OnMouseUp)),'display:none;','')
                    +'">');

            slhtml.Add('<div class="loading-container" style="position:absolute;top:100px;">'#13
                    +'<div class="dwloadingring"></div>'#13
                    +'</div>'#13
                    +'</div>');

            //添加资源
            slhtml.Add(_RESOURCE);

            //保存当前位置，以插入额外的js/css
            iExtrPos    := slHtml.Count;

            //添加特别的资源
            if joHint.Exists('head') then begin
                for iTmp := 0 to joHint.head._Count-1 do begin
                    slHtml.Add('    '+joHint.head._(iTmp));
                end;
            end;

            //添加主体div
            slhtml.Add('    <!--[style_start]-->');
            slhtml.Add('    <!--[style_end]-->');
            slhtml.Add('    <!--[app_start]-->');
            slhtml.Add('<div'
                    +' id="app"'
                    //+' v-show="form___vis"'
                    +' class="dwnocusor"'
                    +' style="'
                        //+'display:none;'
                        +'position:absolute;'
                        //+'caret-color: transparent;'    //隐藏光标
                        +dwIIF(AForm.VertScrollBar.Visible,'overflow-x:hidden;overflow-y:auto;','overflow:hidden;')
                        +'left:0;top:0;right:0;bottom:0;margin: 0 auto;'
                        +'background-color:'+dwColor(AForm.color)
                    +'"'
                    +' :style="{'
                        +'width:'+AForm.name+'__wid,'
                        +'height:'+AForm.name+'__hei'
                    +'}"'
                    +' >');
        end;


        //slhtml.Add('            <router-view></router-view>');

        //注册链接按钮
        //slhtml.Add('        <el-button v-if="version__istrial" type="success" @click="this.window.open(''http://www.web0000.com/buy'')" size="mini" icon="el-icon-shopping-cart-2"'
        //     +' style="position:relative;z-index:999;float:right;margin:10px;">Buy Now!</el-button>');


        //增加一个进度条，以显示正在加载
        //下面是全屏显示进度条的，用户反应闪一下，不好
        //slhtml.Add('        <div v-loading.fullscreen.lock="dwloading" :element-loading-text="dwloading__cap"  > </div>');
        //以下是100x100的中间显示方案
        slhtml.Add('<div id="__dwloading" style="'
                +'border-radius:10px;'
                +'overflow:hidden;'
                +'position:absolute;'
                +'width:100px;height:100px;top:50%;left:50%;transform: translate(-50%,-50%);'
                +'z-index:50;pointer-events:none;"'
                +' v-loading="dwloading" :element-loading-text="dwloading__cap"></div>');

        //增加一个图片预览框
        //slhtml.Add('        <el-image-viewer  style="z-index:999;" v-if="dwshowimageviewer" :url-list="[dwimageviewer]" />');
        //slhtml.Add('        <el-image-viewer v-if="dwshowimageviewer" :url-list="[dwimageviewer]"></el-image-viewer>');

        //增加一个iframe,用来处理iframe
        slhtml.Add('<iframe id="id_iframe" name="upload_iframe" style="display:none;"></iframe>');

        //增加一个input,用来处理直接使用函数上传    dwInputSubmit(this.clientid,'dw_upload','gif')
        slhtml.Add('<label style="cursor: pointer;display: block;width:0px;">'
                +'<input id="deweb__inp"'
                +' type="FILE"'
                +' name="file"'
                +' placeholder="please upload"'
                +' :accept="dw_upload__acc"'
                +' style="display:none;cursor:pointer;"'
                +' @change=dwInputSubmit(clientid,dw_upload__dir)'
                +' >'
                +'</input>'
                +'</label>');

        // 创建DataSL
        slData    := TStringList.Create;
        //添加inputquery ,
        slData.Add('        <el-dialog :title="input_query_caption" :visible.sync="input_query_visible" >');
        slData.Add('            <el-form style="width:90%;padding-left:5%;">');
        slData.Add('                <el-form-item :label="input_query_inputname" >');
        slData.Add('                    <el-input v-model="input_query_inputdefault" style="border:solid 1px #DCDFE6;border-radius: 2px;" autocomplete="off"></el-input>');
        slData.Add('                </el-form-item>');
        slData.Add('            </el-form>');
        slData.Add('            <div slot="footer" class="dialog-footer">');
        slData.Add('                <el-button style="width:70px;" @click="input_query_visible=false">{{input_query_cancelcaption}}</el-button>');
        slData.Add('                <el-button style="width:70px;" type="primary" @click="processinputquery">{{input_query_okcaption}}</el-button>');
        slData.Add('            </div>');
        slData.Add('        </el-dialog>');
        slData.Add('    </div><!--[app_end]-->');

        //
        slData.Add('    <script>');



        //cookie函数
        sCode   :=
                'Vue.prototype.dwsetcookie = function(name, value, hours) {'#13#10
                    +'let expires = '''';'#13#10
                    +'if (typeof hours !== ''undefined'') {'#13#10
                        +'const date = new Date();'#13#10
                        +'date.setTime(date.getTime() + hours * 60 * 60 * 1000);'#13#10
                        +'expires = ''; expires='' + date.toUTCString();'#13#10
                    +'};'#13#10
                    +'if(hours>0) {'
                        +'document.cookie = name + ''='' + encodeURIComponent(value) + expires + '' path=/'';'#13#10
                    +'} else {'
                        +'document.cookie = name + ''='' + encodeURIComponent(value)  + ''; path=/'';'#13#10
                    +'};'#13#10
                +'},'#13#10
                //
                +'Vue.prototype.dwsetcookiepro = function(name, value, hours, path, domain) {'#13#10
                    // 计算过期时间
                    +'const date = new Date();'#13#10
                    +'date.setTime(date.getTime() + (hours * 60 * 60 * 1000));'#13#10
                    +'const expires = "expires=" + date.toUTCString();'#13#10

                    // 构建 Cookie 字符串
                    +'let cookieString = name + "=" + value + "; " + expires;'#13#10

                    // 添加 path 和 domain
                    +'if (path) {'#13#10
                        +'cookieString += "; path=" + path;'#13#10
                    +'}'#13#10
                    +'if (domain) {'#13#10
                        +'cookieString += "; domain=" + domain;'#13#10
                    +'}'#13#10

                    // 设置 Cookie
                    +'document.cookie = cookieString;'#13#10
                +'},'#13#10;
        slData.Add(sCode);

        slData.Add('    Vue.prototype.dwgetcookie = function (name) {');
        slData.Add('        var arr,reg=new RegExp("(^| )"+name+"=([^;]*)(;|$)"); ');
        slData.Add('        if(arr=document.cookie.match(reg))');
        slData.Add('            return unescape(arr[2]); ');
        slData.Add('        else');
        slData.Add('            return '''';');
        slData.Add('    },');

        //处理回复消息
        slData.Add('    Vue.prototype.procResp = function (data){');
        //slData.Add('        resp = JSON.parse((String(data))); ');//先解析为JSON
        //slData.Add('        resp = JSON.parse(unescape(String(data))); ');//先解析为JSON
        slData.Add('        if (data.m === "update"){');
        slData.Add('            try {');
        slData.Add('                eval(String(data.o));');
        slData.Add('            } catch (err) {');
        slData.Add('                console.log("error when procResp : ",String(data.o));');
        slData.Add('            }');
        slData.Add('        } else if (data.m === "html"){');
        slData.Add('            document.body.innerHTML="";');
        slData.Add('            document.write(String(data.o));');
        slData.Add('            document.close();');
        slData.Add('        } else if (data.m === "recreate"){');
        //先清空时钟
        slData.Add('            let end = setInterval(function () { }, 10000);');
        slData.Add('            for (let i = 1; i <= end; i++) {');
        slData.Add('                clearInterval(i);');
        slData.Add('            }');
        //
        slData.Add('            document.body.innerHTML="";');
        slData.Add('            document.write(String(data.o));');
        slData.Add('            document.close();');
        //slData.Add('        document.body.innerHTML="";');
        slData.Add('        } else if (data.m === "showform"){');
        slData.Add('            document.open();document.write(String(data.o));');
        slData.Add('        } else if (data.m === "wx_getuserprofile"){');
        slData.Add('            wx.getUserProfile({desc: "获取你的昵称、头像、地区及性别",success: res => {console.log("dw_success");},fail: res => {console.log("dw_false");return;}});');
        slData.Add('        }');
        slData.Add('    } ');

        slData.Add('    new Vue(');
        slData.Add('    {');
        slData.Add('        el: ''#app'',');
        //slData.Add('        router,');

        //单独引入el-image-viewer
        //slData.Add('        components: {''el-image-viewer'':()=>import(''element-ui/packages/image/src/image-viewer'')},');
        //slData.Add('        import ElImageViewer from ''element-ui/packages/image/src/image-viewer'',');

        //
        slData.Add('        /*[data_start]*/data: function () {');
        slData.Add('            return {');
        //添加imagelist以预览图片
        slData.Add('                image_preview_list:[],');
        //添加Form的LTWH
        //slData.Add('    '+AForm.name+'__lef:"'+IntToStr(AForm.left)+'px",');
        slData.Add('                name:"'+AForm.Name+'",');
        slData.Add('                '+AForm.name+'__top:"'+IntToStr(AForm.top)+'px",');
        slData.Add('                '+AForm.name+'__wid:"'+IntToStr(AForm.width)+'px",');
        if dwGetProp(AForm,'height')='' then begin
            slData.Add('                '+AForm.name+'__hei:"'+IntToStr(AForm.height)+'px",');
        end else begin
            slData.Add('                '+AForm.name+'__hei:"'+dwGetProp(AForm,'height')+'px",');
        end;

        // 创建Motheds SL
        slMeth := TStringList.Create;
        slMeth.Add('        /*[methods_start]*/methods: {');

        //添加跳转URL函数(2022-09-18增加了第2参数为空格情况，此时采用window.location.href = e ，可以在iOS中有效，其他无效)
        slMeth.Add('            ToWebsite (e,n) {');
        slMeth.Add('                if (n==""){');
        slMeth.Add('                    window.location.href = e ');
        slMeth.Add('                }else{');
        slMeth.Add('                    var aTag = document.createElement(''a''); ');
        slMeth.Add('                    aTag.setAttribute(''href'', e);');
        slMeth.Add('                    aTag.setAttribute(''target'', n);');
        slMeth.Add('                    aTag.click();');
        slMeth.Add('                };');
        slMeth.Add('            },');

        //添加选择拟上传文件函数
        slMeth.Add('            dwInputClick (e) {');
        slMeth.Add('                document.getElementById(e).click();');
        slMeth.Add('            },');
        //添加选择拟上传文件Change函数
        sCode   :=
                'dwInputChange (fid,e) {' +
                    'let oinp = document.getElementById(e+"__inp");'+
                    'console.log(oinp.files[i]);'+
                    'for (let i = 0; i < oinp.files.length; i++) {'+
                        'console.log(oinp.files[i].name);'+
                        'var sget = ''{"m":"event","i":"''+fid+''","c":"''+e+''","e":"getfilename","v":"''+escape(oinp.files[i].name)+''"}'';'+
                        'axios.post(''/deweb/post'',sget)' +
                    '}'+
                '},';
        slMeth.Add(sCode);
        //
        slMeth.Add('            filterHandler(value, row, column) {');
        slMeth.Add('                const property = column[''property''];');
        slMeth.Add('                return row[property] === value;');
        slMeth.Add('            },');


        //添加上传文件函数,fid为窗体句柄, ipname为控件名称,destdir为目标目录
        sCode   :=
                'dwInputSubmit (fid,destdir) {'#13 +

                    'let that = this;'+
                    'let config = {};'+

                    //2023-04-21加入以下行，以解决子窗体中upload未激活本窗体StartDock/EndDock事件的问题
                    //需要在执行之前先赋值this.dw_upload__formhandle为当前窗体的handle
                    'if (this.dw_upload__formhandle > 0) {'+
                        'fid = this.dw_upload__formhandle; '+
                        'this.dw_upload__formhandle = 0;'+
                        //2023-06-27新增加了所有上传前消息，激活ondragdrop
                        'config = {'+
                            'headers: {'+
                                '''Content-Type'': ''multipart/form-data'','+
                                '''clientid'': fid,'+
                                '''destdir'': destdir,'+
                                '''shuntflag'': 0'+
                            '}'+
                        '};'+
                    '} else {;'+
                        //2023-06-27新增加了所有上传前消息，激活ondragdrop
                        'config = {'+
                            'headers: {'+
                                '''Content-Type'': ''multipart/form-data'','+
                                '''clientid'': ''[!handle!]'','+
                                '''destdir'': destdir,'+
                                '''shuntflag'': 0'+
                            '}'+
                        '};'+
                    '};'+

                    'var sstart = '''';'+

                    //
                    'for (let i = 0; i < document.getElementById("deweb__inp").files.length; i++) {'+
                        'let formData = new FormData();' +
                        'formData.append(''file'', document.getElementById("deweb__inp").files[i]);'+

                        //正在此处增加直接自定义上传目录功能。目前需要提供上传位置参数，写到Header中
                        //'let config = {headers: {''Content-Type'': ''multipart/form-data'',''clientid'': ''[!handle!]'',''destdir'':destdir,''shuntflag'':[!shuntflag!]}}; ' +

                         //自动激活OnStartDock事件
                        'if ( i == 0 ) {'+
                            'sstart = ''{"m":"event","i":"''+fid+''","c":"'+AForm.Name+'","e":"onstartdock","v":"__start__"}'';' +
                            'axios.post(''/deweb/post'',sstart, config)' +
                            '.then(resp =>{that.procResp(resp.data)});' +
                        '};'+
                        //开始上传
                        'axios.post(''/upload'', formData, config)' +
                        '.then(function (res) {' +

                            //上传完成自动激活OnEndDock事件
                            'if ( i == document.getElementById("deweb__inp").files.length-1 ) {'+
                                'var sget = ''{"m":"event","i":"''+fid+''","c":"'+AForm.Name+'","e":"onenddock","v":"__success__"}'';' +
                                'axios.post(''/deweb/post'',sget, config)' +
                                '.then(resp =>{that.procResp(resp.data)});' +

                                //清空，以下次可以激活onchange
                                'document.getElementById("deweb__inp").value = null;' +
                            '};'+
                        '});' +
                    '};'#13 +
                '},';
        slMeth.Add(sCode);

        //页面关闭事件
        slMeth.Add('            beforeunloadHandler (e) {');
        slMeth.Add('                e = e || window.event');
        slMeth.Add('                if (e) {');
        slMeth.Add('                    axios.post(''/deweb/post'',''{"m":"onbeforeunload","i":[!handle!]}'',{headers:{shuntflag:[!shuntflag!]}})');
        slMeth.Add('                }'); //slMeth.Add('      return ''关闭提示''');
        slMeth.Add('            },');

        // 创建Mounted SL
        slMoun := TStringList.Create;
        slMoun.Add('/*[mounted_start]*/mounted() {');
        slMoun.Add('var me = this;');
        slMoun.Add('window._this = this;');

        //添加SSE启动消息
        if dwGetProp(AForm,'sse') = '1' then begin
            slMoun.Add(''
                +'function ssesend(url) {'#13#10
                    +'let eventSource = new EventSource(url);'#13#10
                    +'eventSource.onmessage = function (e) {'#13#10
                        //+'console.log(e.data);'#13#10
                        +'eval(unescape(e.data));'#13#10
                    +'};'#13#10
                    +'eventSource.onopen = function (e) {'#13#10
                        //+'console.log(''Connection opened'');'#13#10
                    +'};'#13#10
                    +'eventSource.onerror = function (e) {'#13#10
                        //+'console.log(''Connection closed'');'#13#10
                    +'};'#13#10
                +'};'#13#10
                +'ssesend("/dws_sse_start_[!handle!]");'#13#10
            );
        end;

        //添加可能存在的OnMouseUp事件，以更新界面===================================================
        if Assigned(AForm.OnMouseUp) then begin
            sCode   := '            '       //用于对齐的空格
                +'axios.post('
                        +'''/deweb/post'','
                        +'''{'
                         +'"m":"onmouseup",'
                         +'"i":[!handle!],'
                         +'"os":''+getOs()+'','
                         +'"canvasid":"''+getCanvasId()+''",'
                         +'"fullurl":"''+escape(window.location.href)+''",'
                         +'"ua":"''+navigator.userAgent+''",'
                         +'"clientwidth":''+document.documentElement.clientWidth+'','
                         +'"clientheight":''+document.documentElement.clientHeight+'','
                         +'"bodywidth":''+document.body.clientWidth+'','
                         +'"bodyheight":''+document.body.clientHeight+'','
                         +'"innerwidth":''+window.innerWidth+'','
                         +'"innerheight":''+window.innerHeight+'','
                         +'"screenwidth":''+window.screen.width+'','
                         +'"screenheight":''+window.screen.height+'','
                         +'"availwidth":''+window.screen.availWidth+'','
                         +'"availheight":''+window.screen.availHeight+'','
                         +'"devicepixelratio":''+window.devicePixelRatio+'','
                         +'"orientation":"''+window.orientation+''"}'''
                         +',{headers:{shuntflag:[!shuntflag!]}}'
                +')'#13
                +'.then(function (resp) {'#13
                +'    try {'#13
                +'        document.getElementById("_loading").style.display = "none";'
                +'        if (resp.data.m == "update"){'#13
                            //+'console.log("--- update ---"); '
                            //+'eval(String(resp.data.o).replace(new RegExp("this.","gm"),"me."));'#13
                            //+'console.log(String(resp.data.o));'
                            //+'let stemp = String(resp.data.o).replace(new RegExp("this\.","gm"),"me\.");'#13
                +'              let stemp = String(resp.data.o);'#13
                +'              stemp = stemp.replace(/this\./g, ''window._this\.'');'#13
                +'              stemp = stemp.replace(/let _temp = this;/g, ''let _temp = window._this;'');'#13
                //+'console.log(stemp); '
                +'              try{eval(stemp)} catch (error){console.log("error when eval(stemp):"+stemp)};'#13
                            //+'console.log("--- eval(stemp); ---"); '

                //OnMouseDown
                +dwIIF(Assigned(AForm.OnMouseDown),
                 '              setTimeout(function(){'#13
                //+'console.log("--- OnMouseDown; ---"); '#13
                +'                  axios.post(''/deweb/post'',''{"m":"mounted","i":[!handle!]}'')'#13
                +'                  .then('#13
                +'                      resp =>{'#13
                +'                          window._this.procResp(resp.data);'#13
                +'                      }'#13
                +'                  );'#13
                +'              },10);'
                ,''
                )

                        +'} else if (resp.data.m == "recreate"){'#13
                            +'document.write(resp.data.o);'#13
                        +'} else {'
                            +'console.log("resp.data error!");'
                        +'};'#13
                    +'} catch (error) {;'#13
                    +'} finally {;'#13
                    +'};'#13
                +'})'#13
                +'.catch(function (error) {'#13
                    +'console.log(" errro when onmouseup",error); '
                    +'document.getElementById("_loading").style.display = "none";'#13
                    //+'setTimeOut(function(){document.getElementById("_loading").style.display = "none";},0);'
                +'});'#13;
            //
            slMoun.Add(sCode);
        end; //=====================================================================================

        //挂载页面关闭事件
        slMoun.Add('window.addEventListener(''beforeunload'', e => this.beforeunloadHandler(e));');


        //以下代码会造成v-charts首次不绘制，2022-03-03时移入reload处
        //先清除所有时钟，主要因为采用DockSite刷新后可能残存有时钟
        //slMoun.Add('            let end = setInterval(function () { }, 10000);');
        //slMoun.Add('            for (let i = 1; i <= end; i++) {');
        //slMoun.Add('                clearInterval(i);');
        //slMoun.Add('            }');


        //加入可能存在的启动即需执行的JS, 用于启动后直接执行相关代码
        if AForm.HelpFile <> '' then begin
            slMoun.Add(AForm.HelpFile);
        end;

        //挂载页面回退事件。 判断浏览器是否支持popstate
        //slMoun.Add('                    if (window.history && window.history.pushState) {');
        //slMoun.Add('                        history.pushState(null, null, document.URL);');
        //slMoun.Add('                        window.addEventListener(''popstate'', this.goBack, false);');
        //slMoun.Add('                    };');

        //挂载pageshow事件,以在此事件时检查当前是否为缓存,如果为缓存(即为回退),则刷新
        //slMoun.Add('                    window.addEventListener(''pageshow'', e => this.pageshowHandler(e));');
        //slMoun.Add('window.addEventListener(''pageshow'', function(e){');
        //slMoun.Add('    if (e.persisted || (window.performance && window.performance.navigation.type == 2)) { ');
        //slMoun.Add('        axios.post(''/deweb/post'',''{"m":"pageshow","i":[!handle!]}'',{headers:{shuntflag:[!shuntflag!]}});');
        //slMoun.Add('        location.reload();console.log("reload");');
        //slMoun.Add('    }else{console.log("NOreload");}');
        //slMoun.Add('}, false);');
        //slMoun.Add('      alert("pageshow");      });');


        //更新slHtml
        for iCtrl := 0 to AForm.ControlCount-1 do begin
            _ControlToHtml(AForm.Controls[iCtrl]);
        end;

        //处理不可见控件
        for iCtrl := 0 to AForm.ComponentCount-1 do begin
            oComp     := AForm.Components[iCtrl];

            //
            if  (oComp.ClassName = 'TMainMenu') then begin

                _ComponentToHtml(oComp);
            end else if (oComp.ClassName = 'TTimer') then begin
                _ControlToHtml(TControl(oComp));
            end;
        end;

        //生成slData尾部
        //if Assigned(AForm.OnMouseUp) then begin //避免onmouseup时界面闪动
            //slData.Add('                form___vis:false,');
        //    slData.Add('                form1__top:"999999px",');
        //end else begin
            //slData.Add('                form___vis:true,');
        //    slData.Add('                form1__top:"'+IntToStr(AForm.Top)+'",');
        //end;
        //slData.Add('                ''__top:"'+IntToStr(AForm.Top)+'",');
        slData.Add('input_query_visible:false,');
        slData.Add('input_query_caption:"Input Query",');
        slData.Add('input_query_inputname:"new",');
        slData.Add('input_query_cancelcaption:"Cancel",');
        slData.Add('input_query_okcaption:"OK",');
        slData.Add('input_query_inputdefault:"",');
        slData.Add('input_query_method:"processinputquery",');
        slData.Add('input_query_handle:0,');
        slData.Add('input_query_visible:false,');
        slData.Add('version__istrial:false,');
        slData.Add('dw_upload__acc:'''',');         //用于动态指定上传类型
        slData.Add('dw_upload__dir:'''',');         //用于动态指定上传目录
        slData.Add('clientid:[!handle!],');         //主窗体句柄
        slData.Add('dw_upload__formhandle:0,');     //用于upload的子窗体句柄
        slData.Add('dwloading:false,');                 //显示进度条控制变量，0表示从主窗体上传
        slData.Add('dwloading__cap:"loading ...",');    //显示进度条方案
        slData.Add('shuntflag:[!shuntflag!]');          //分流标识
        slData.Add('}');
        slData.Add('},/*[data_end]*/');

        //
        //<额外引入的CSS/JS
        //去重
        //RemoveDuplicates(slExtr);
        //插入到HTML中
        for iTmp := slExtr.Count-1 downto 0 do begin
            slHtml.Insert(iExtrPos+1,slExtr[iTmp]);
        end;
        //销毁
        slExtr.Destroy;
        //>


        //<把Data追加到HTML中
        slhtml.AddStrings(slData);

        //生成Mounted尾部------
        //添加屏幕滚动监听事件
        if Assigned(AForm.OnHelp) then begin
            slMoun.Add('window.addEventListener(''scroll'', function() {');
            slMoun.Add('let top = document.documentElement.scrollTop || document.body.scrollTop || window.pageYOffset;');
            slMoun.Add('axios.post(''/deweb/post'',''{"m":"event","i":[!handle!],"c":"_scroll","v":"''+top+''"}'')');
            slMoun.Add('.then(resp =>{me.procResp(resp.data)});');
            slMoun.Add('});');
        end;

        //挂载popstate 2024-04-07
        //此处需要有交互后，才能激活popstate事件，研究中
        slMoun.Add(''
            //'history.pushState({page: 1}, "title 1", window.location.href);'
            +'window.onpopstate  = function(event) {'
                //+'console.log("pops!!!!");'
                +'axios.post(''/deweb/post'',''{"m":"popstate","i":[!handle!]}'')'
                +'.then(resp =>{window._this.procResp(resp.data)})'
            +'}; '
        );

        //如果定义的屏幕事件，则添加屏幕改变(主要是旋转)监听事件
        if Assigned(AForm.OnMouseUp) then begin
            slMoun.Add('window.addEventListener(');
            slMoun.Add('"resize" ,');
            slMoun.Add('function() {');
            //
            slMoun.Add('var target = this;');
            slMoun.Add('if (target.resizeFlag){');
            slMoun.Add('clearTimeout(target.resizeFlag);');
            slMoun.Add('}');


            slMoun.Add('target.resizeFlag = setTimeout(function() {');
            slMoun.Add('var os = function (){'#13
                    +'var ua = navigator.userAgent,'#13
                    +'isWindowsPhone = /(?:Windows Phone)/.test(ua),'#13
                    +'isSymbian = /(?:SymbianOS)/.test(ua) || isWindowsPhone,'#13
                    +'isAndroid = /(?:Android)/.test(ua),'#13
                    +'isFireFox = /(?:Firefox)/.test(ua),'#13
                    +'isChrome = /(?:Chrome|CriOS)/.test(ua), '#13
                    +'isTablet = /(?:iPad|PlayBook)/.test(ua) || (isAndroid && !/(?:Mobile)/.test(ua)) || (isFireFox && /(?:Tablet)/.test(ua)),'#13
                    +'isPhone = /(?:iPhone)/.test(ua) && !isTablet ,'#13   //|| (?:iPhone)/.test(ua) && !isTablet
                    +'isPc = !isPhone && !isAndroid && !isSymbian;'#13
                    +'if (isPc) {return 1;} '#13
                    +'else if (isAndroid){return 2;} '#13
                    +'else if (isPhone){return 3;} '#13
                    +'else if (isTablet){return 4;} '#13
                    +'else {return 0;}'#13
                +'                        };'#13
                );

            slMoun.Add('axios.post(''/deweb/post'',''{'
                    +'"m":"event",'
                    +'"i":[!handle!],'
                    +'"c":"_screen",'
                    +'"os":''+getOs()+'','
                    +'"canvasid":"''+getCanvasId()+''",'
                    +'"fullurl":"''+escape(window.location.href)+''",'
                    +'"ua":"''+navigator.userAgent+''",'
                    +'"orientation":"''+window.orientation+''",'
                    +'"clientwidth":''+document.documentElement.clientWidth+'','
                    +'"clientheight":''+document.documentElement.clientHeight+'','
                    +'"innerwidth":''+innerWidth+'','
                    +'"innerheight":''+innerHeight+'','
                    +'"availwidth":''+screen.availWidth+'','
                    +'"availheight":''+screen.availHeight+'','
                    +'"bodywidth":''+document.body.clientWidth+'','
                    +'"bodyheight":''+document.body.clientHeight+'','
                    +'"devicepixelratio":''+devicePixelRatio+'','
                    +'"width":''+screen.width+'','
                    +'"height":''+screen.height+''}'','
                    +'{headers:{shuntflag:[!shuntflag!]}})');
            slMoun.Add('.then(resp =>{window._this.procResp(resp.data)});');
            slMoun.Add('target.resizeFlag = null;');
            slMoun.Add('}, 100);');
            slMoun.Add('},');
            slMoun.Add('false');
            slMoun.Add(');');
        end;

        //添加心跳包事件(仅AlphaBlend=False)
        if not AForm.AlphaBlend then begin
            slMoun.Add('let '+AForm.name+'hearttimer = window.setInterval(function() {');
            slMoun.Add('axios.post(''/deweb/post'',''{"m":"heart","i":[!handle!]}'',{headers:{shuntflag:[!shuntflag!]}})');
            slMoun.Add('.then(resp =>{window._this.procResp(resp.data)})');
            slMoun.Add('.catch((error) =>{window._this.dwnotify("Info","'+gjoConfig.disconnect+'");clearInterval('+AForm.name+'hearttimer);});');
            slMoun.Add('}, 300000);');
        end;

        //启动后发送一个mounted消息,服务器收到此消息会自动运行可能有的OnMouseDown事件
        if Assigned(AForm.OnMouseDown) and (not Assigned(AForm.OnMouseUp))then begin
            sMounted    := ConCat('axios.post(''/deweb/post'',''{"m":"mounted","i":[!handle!]}'',{headers:{shuntflag:[!shuntflag!]}})',
                        '.then(',
                            'resp =>{',
                                'window._this.procResp(resp.data);',
                                '}',
                        ');');
            slMoun.Add(sMounted);
        end;


        //slMoun.Add('            axios.post(''/deweb/post'',''{"m":"mounted","i":[!handle!]}'',{headers:{shuntflag:[!shuntflag!]}})');
        //slMoun.Add('            .then('
        //        +'resp =>{'
        //            +'document.getElementById("app").style.display = "block";'
        //            +'document.getElementById("_loading").style.display = "none";'
        //            +'me.procResp(resp.data);'
        //            +'});');

        //
        slMoun.Add('        },/*[mounted_end]*/');

        //把slMoun追加到HTML中
        slhtml.AddStrings(slMoun);
        //>

        //<生成slMotd尾部
        //弹框函数
        slMeth.Add('            dwnotify(caption,text) {this.$notify.warning({ title: caption, message: text, duration: 0,showClose: false });},');

        //执行代码函数
        slMeth.Add('            dwexecute(code) {');
        slMeth.Add('                eval(code);');
        slMeth.Add('            },');

        //用于调试的alert函数
        slMeth.Add('            dwalert(code) {');
        slMeth.Add('                alert(code);');
        slMeth.Add('            },');

        //调试用的通用事件函数
(*
        slMeth.Add('            dwevent_debug(val,compname,compvalue,compevent,handle) {');
        slMeth.Add('                var jo={};');
        slMeth.Add('                jo.m="event";');
        slMeth.Add('                jo.i=handle;');
        slMeth.Add('                jo.c=compname;');
        slMeth.Add('                jo.v=escape(eval(compvalue))');
        slMeth.Add('                jo.e=compevent;');
        slMeth.Add('                alert(jo);');
        slMeth.Add('                axios.post('
                +'''/deweb/post'','
                +'escape(JSON.stringify(jo)),'
                +'{headers:{shuntflag:[!shuntflag!]}}'
        +')');
        slMeth.Add('                .then(resp =>{this.procResp(resp.data)});');
        //slMeth.Add('                console.log(val);');
        slMeth.Add('                if (val !== null && val !== undefined && val !== '''' && typeof val === ''object'' && val.stopPropagation !== undefined){val.stopPropagation();};');
        slMeth.Add('            },');
*)
        //<-----wechat事件
        slMeth.Add('            dwwechat(wxtype,wxvalue) {');
        slMeth.Add('                var jo={};');
        slMeth.Add('                jo.m="wechat";');
        slMeth.Add('                jo.i=handle;');
        slMeth.Add('                jo.v=escape(wxvalue)');
        slMeth.Add('                jo.e=wxtype;');
        slMeth.Add('                axios.post('
                                        +'''/deweb/post'','
                                        +'escape(JSON.stringify(jo)),'
                                        +'{headers:{shuntflag:[!shuntflag!]}}'
                                    +')');
        slMeth.Add('                .then(resp =>{this.procResp(resp.data)});');
        //slMeth.Add('                console.log(val);');
        slMeth.Add('                if (val !== null && val !== undefined && val !== '''' && typeof val === ''object'' && val.stopPropagation !== undefined){val.stopPropagation();};');
        slMeth.Add('            },');
        //>-----

        //通用事件函数
        sCode   :=
        'dwevent(val,compname,compvalue,compevent,handle) {'+
            'var jo={};'#13+
            'jo.m="event";'#13+
            'jo.i=handle;'#13+
            'jo.c=compname;'#13+

            //2023-01-04加入了判断，以更好利用dwEvent函数
            //'jo.v=escape(eval(compvalue))'#13+
            'try{'#13+
                'jo.v=escape(eval(compvalue));'#13+
            '} catch (e) {'#13+
                'jo.v=escape(compvalue);'#13+
            '}'#13+

            'jo.e=compevent;'#13+
            'axios.post('+
                '''/deweb/post'','+
                'escape(JSON.stringify(jo)),'+
                '{headers:{shuntflag:[!shuntflag!]}}'+
            ')'#13+
            '.then(resp =>{'#13+
                'this.procResp(resp.data);'#13+
            '});'#13+
            ' if (val !== null && val !== undefined && val !== '''' && typeof val === ''object'' && val.stopPropagation !== undefined){'+
                'val.stopPropagation();'#13+
            '};'#13+
        '},';
        slMeth.Add(sCode);

        //处理InputQuery类函数
        slMeth.Add('            processinputquery(val) {');
        //slMeth.Add('this.alert("query");');
        slMeth.Add('                this.input_query_visible = false;');
        slMeth.Add('                axios.post('
                +'''/deweb/post'','
                +'''{'
                    +'"m":"interaction",'
                    +'"i":''+this.input_query_handle+'','
                    +'"s":"inputquery",'
                    +'"t":"''+this.input_query_method+''",'
                    +'"v":"''+escape(this.input_query_inputdefault)+''"'
                +'}'','
                +'{headers:{shuntflag:[!shuntflag!]}}'
        +')');
        slMeth.Add('                .then(resp =>{this.procResp(resp.data)});');
        slMeth.Add('            },');
        //
        slMeth.Add('        },/*[methods_end]*/');

        //销毁
        slMeth.Add('        beforeDestroy() {');

        //销毁心跳时钟
        slMeth.Add('            clearInterval(hearttimer);');

        //先清除所有时钟，主要因为采用DockSite刷新后可能残存有时钟
        slMeth.Add('            let end = setInterval(function () { }, 10000);');
        slMeth.Add('            for (let i = 1; i <= end; i++) {');
        slMeth.Add('                clearInterval(i);');
        slMeth.Add('            }');

        //销毁页面关闭监听
        slMeth.Add('            window.removeEventListener(''beforeunload'', e => this.beforeunloadHandler(e));');
        //销毁回退监听
        //slMeth.Add('window.removeEventListener(''popstate'', this.goBack, false); ');
        //
        slMeth.Add('        }');
        slMeth.Add('    }); ');
        slMeth.Add('    </script>');
        slMeth.Add('</body>');
        //隐藏载入进度条
        //slMeth.Add('<script>');
        //slMeth.Add('function Lodinng () {');
        //slMeth.Add('document.getElementById("loader-wrapper").style.display = "none"');
        //slMeth.Add('}');
        //slMeth.Add('Lodinng()');
        //slMeth.Add('</script> ');
        slMeth.Add('</html>');
        //把slMotd追加到HTML中
        slhtml.AddStrings(slMeth);
        //>

        //减重
        for iTmp := 0 to slHtml.Count-1 do begin
            slHtml[iTmp]    := Trim(slHtml[iTmp]);
        end;

        //
        Result    := slhtml.Text;


    finally
        if slhtml <> nil then begin
            FreeAndNil(slhtml);
        end;

        if slData <> nil then begin
            FreeAndNil(slData);
        end;

        if slMoun <> nil then begin
            FreeAndNil(slMoun);
        end;

        if slMeth <> nil then begin
            FreeAndNil(slMeth);
        end;
    end;
end;

function dwFormToDiv(AForm:TForm):String;
var
    iCtrl     : Integer;
    iVcl      : Integer;
    iTmp      : Integer;
    //
    sExtra    : string;
    //
    slhtml    : TStringList;
    //
    oComp     : TComponent;
    //
    joArray   : Variant;
    joHint    : Variant;
    //
    procedure _AddToHtml(AJson:Variant;AList:TStringList);
    var
        iiArray   : Integer;
    begin
        for iiArray := 0 to AJson._Count-1 do begin
            AList.Add(UTF8ToWideString(AJson._(iiArray)));
        end;
    end;
    //
    procedure _AddToData(AJson:Variant;AList:TStringList);
    var
        iiArray   : Integer;
    begin
        for iiArray := 0 to AJson._Count-1 do begin
            AList.Add(AJson._(iiArray));
        end;
    end;
    //
    procedure _AddToExtra(AJson:Variant;AList:TStringList);
    var
         iiArray   : Integer;
    begin
        for iiArray := 0 to AJson._Count-1 do begin
            AList.Add(AJson._(iiArray));
        end;
    end;
    procedure _ControlToHtml(ACtrl:TControl);
    var
        iiChild   : Integer;
        iDWVcl    : Integer;
        //
        joArray   : Variant;     //各控件计算返回值
        //
        sVcl      : string;
        bbTmp   : Boolean;
    begin
         //
         bbTmp  := False;
         if dwIsTForm(ACtrl) then begin
            bbTmp   := grDWVclNames.TryGetValue('tform',iDWVcl);
         end else begin
            bbTmp   := grDWVclNames.TryGetValue(lowerCase('dw'+ACtrl.ClassName+'.dll'),iDWVcl);
         end;

         if bbTmp then begin
               //头部
               sVcl      := grDWVcls[iDWVcl].GetHead(ACtrl);
               joArray   := _json(sVcl);
               //异常处理
               if joArray = unassigned then begin
                   joArray   := _json('[]');
               end;
               //
               _AddToHtml(joArray,slHtml);

               //处理容器控件的子控件
               try
                    //oWinCtrl  := ACtrl as TWinControl;
                    if dwIsWinCtrol(ACtrl) then begin
                         for iiChild := 0 to TWinControl(ACtrl).ControlCount-1 do begin
                              _ControlToHtml(TWinControl(ACtrl).Controls[iiChild]);
                         end;
                    end;
               except

               end;

               //尾部
               if Assigned(grDWVcls[iDWVcl].GetTail) then begin
                   sVcl      := grDWVcls[iDWVcl].GetTail(ACtrl);
                   joArray   := _json(sVcl);
                   //异常处理
                   if joArray = unassigned then begin
                       joArray   := _json('[]');
                   end;
                   //
                   _AddToHtml(joArray,slHtml);
               end;

         end;

    end;
    procedure _ComponentToHtml(ACtrl:TComponent);
    var
         iiChild   : Integer;
         iDWVcl    : integer;
         //
         joArray   : Variant;     //各控件计算返回值
         //
         sVcl      : string;
    begin
        //
        if grDWVclNames.TryGetValue(lowerCase('dw'+ACtrl.ClassName+'.dll'),iDWVcl) then begin
            //头部
            sVcl      := grDWVcls[iDWVcl].GetHead(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToHtml(joArray,slHtml);

            //处理容器控件的子控件
            if ACtrl is TWinControl then begin
                for iiChild := 0 to TWinControl(ACtrl).ControlCount-1 do begin
                    _ControlToHtml(TWinControl(ACtrl).Controls[iiChild]);
                end;
            end;

            //尾部
            sVcl      := grDWVcls[iDWVcl].GetTail(ACtrl);
            joArray   := _json(sVcl);
            //异常处理
            if joArray = unassigned then begin
                joArray   := _json('[]');
            end;
            //
            _AddToHtml(joArray,slHtml);
        end;
    end;
begin
     try

          //创建html字符串列表
          slhtml    := TStringList.Create;

          //得到hint
          joHint    := dwGetHintJson(AForm);


          //根据TWindowState.wsNormal进行处理
          //如果wsNormal, 则为居中. 背景色为COLOR或transparentcolorvalue(必须transparentcolor=true)
          //否则, 为全背景
          //if AForm.Windowstate = wsNormal then begin
          if AForm.transparentcolor then begin //底色+前景色的情况,
               //添加主体div
               slhtml.Add('    <div id="app"'
                        +' class="dwnocusor"'
                        +' style="'
                            +'position:absolute;'
                            +dwIIF(AForm.VertScrollBar.Visible,'overflow-x:hidden;overflow-y:auto;','overflow:hidden;')
                            //+'caret-color: transparent;'    //隐藏光标
                            +'left:0;'
                            +'right:0;'
                            +'bottom:0;'
                            +'margin: 0 auto;'
                            +'background-color:'+dwColor(AForm.color)
                        +'"'
                        +' :style="{'
                            +'top:'+AForm.name+'__top,'
                            +'width:'+AForm.name+'__wid,'
                            +'height:'+AForm.name+'__hei}"'
                         +' >');
          end else begin //全部一个颜色的情况
               //添加主体div
               slhtml.Add('    <div id="app"'
                        +' class="dwnocusor"'
                        +' style="'
                            +'position:absolute;'
                            +dwIIF(AForm.VertScrollBar.Visible,'overflow-x:hidden;overflow-y:auto;','overflow:hidden;')
                            //+'caret-color: transparent;'    //隐藏光标
                            +'left:0;'
                            +'top:0;'
                            +'right:0;'
                            +'bottom:0;'
                            +'margin: 0 auto;'
                            +'background-color:'+dwColor(AForm.color)
                        +'"'
                         +' :style="{'
                            +'width:'+AForm.name+'__wid,'
                            +'height:'+AForm.name+'__hei}"'
                         +' >');
          end;

          slHtml.Add('</div>');

          //将DIV字符中转义, 返回
          Result    := StringReplace(slhtml.Text,'''','\''',[rfReplaceAll]);
          Result    := StringReplace(slhtml.Text,#13#10,'',[rfReplaceAll]);

          if slhtml <> nil then begin
            FreeAndNil(slHtml);
          end;
     except
     end;
end;





procedure dwInputQuery(AMsg,ACaption,ADefault,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);
var
     sMsgCode  : string;
begin
     sMsgCode  := 'this.input_query_caption="'+ACaption+'";'
          +'this.input_query_inputname="'+AMsg+'";'
          +'this.input_query_inputdefault="'+ADefault+'";'
          +'this.input_query_cancelcaption="'+cancelButtonCaption+'";'
          +'this.input_query_okcaption="'+confirmButtonCaption+'";'
          +'this.input_query_method="'+AMethedName+'";'
          +'this.input_query_handle='+IntToStr(AForm.Handle)+';'
          +'this.input_query_visible=true;';
     AForm.HelpFile := sMsgCode;
end;

//根据函数名称执行函数
procedure dwExecMethodByName(AObject: TObject; AMethodName,APara: string) ;
type
     TExec = procedure(AText:String) of object;
var
     Routine   : TMethod;
     Exec      : TExec;
begin
     Routine.Data := Pointer(AObject) ;
     Routine.Code := AObject.MethodAddress(AMethodName) ;
     if NOT Assigned(Routine.Code) then Exit;
     Exec := TExec(Routine) ;
     Exec(APara);
end;

//OpenUrl   打开 一个URL  window.open("http://www.cnblogs.com/liumengdie/"，“_blank”);
procedure dwNavigate(AUrl:String;ANew:Boolean;AForm:TForm);
begin
     AForm.HelpFile := AForm.HelpFile+'window.open("'+AUrl+'","_blank");';
end;


//ShowMessage
procedure dwShowMessage(AMsg:String;AForm:TForm);
begin
     dwShowMsg(AMsg,AForm.Caption,'OK',AForm);
end;

procedure dwShowMsg(AMsg,ACaption,AButtonCaption:String;AForm:TForm);
var
     sMsgCode  : string;
begin
     //处理sMsg
     AMsg := StringReplace(AMsg,#13,'\r\n',[rfReplaceAll]);
     AMsg := StringReplace(AMsg,#10,'',[rfReplaceAll]);

     //
     sMsgCode  := 'this.$alert(''%s'', ''%s'', {confirmButtonText: ''%s''});';
     sMsgCode  := Format(sMsgCode,[AMsg,ACaption,AButtonCaption]);
     AForm.HelpFile := AForm.HelpFile + sMsgCode;
end;


//MessageDlg
procedure dwMessageDlg(AMsg,ACaption,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);
var
     sMsgCode  : string;
const
     sConfirm  = 'axios.post(''/deweb/post'',''{"m":"interaction","i":%d,"t":"%s","v":%d}'',{headers:{shuntflag:[!shuntflag!]}})'
          +'.then(resp =>{'
          +'this.procResp(resp.data);'
          +'},resp => {'
          +'console.log("err");'
          +'});';

begin
     sMsgCode  := 'this.$confirm(''%s'', ''%s'', {confirmButtonText: ''%s'', cancelButtonText: ''%s'', type: ''warning''})'
               +'.then(()  => {'
                   //+'    this.$message({type: ''success'',message: ''删除成功!'' });'
                   +Format(sConfirm,[AForm.Handle, AMethedName,1])
               +'})'
               +'.catch(() => {'
                   //+'    this.$message({type: ''info'',   message: ''已取消删除''});'
                   +Format(sConfirm,[AForm.Handle, AMethedName,0])
               +'});';
     sMsgCode  := Format(sMsgCode,[AMsg,ACaption,confirmButtonCaption,cancelButtonCaption]);
     AForm.HelpFile  := sMsgCode;
end;




//根据CID:clientid取得FORM
function dwGetFormByCID(ACID:Integer):TForm;
var
    iForm   : Integer;
begin
    Result    := nil;
    for iForm := Screen.FormCount-1 downto 0 do begin
        if Screen.Forms[iForm].Handle = ACID then begin
            //取得窗体
            Result    := Screen.Forms[iForm];
            //
            Break;
        end;
    end;
end;




//比较两次FORM中各控件的关键信息,生成client端的JS语句
function dwGetDiffs(ABefore,AAfter:Variant;AComponent:String):Variant;
var
    iComp       : Integer;
    iBefore     : Integer;
    iAfter      : Integer;
    //
    sCode       : string;
    sBefore     : string;
    sAfter      : string;
begin
    iBefore     := ABefore._Count;
    //
    Result      := _json('{}');
    Result.m    := 'update';

    //逐个控件比较
    sCode       := '';
    iAfter      := AAfter._Count;
    iBefore     := ABefore._Count;
    for iComp := 0 to Round(Min(iBefore, iAfter))-1 do begin
        //得到控件事件前后
        sBefore  := UTF8ToWideString(ABefore._(iComp));
        sAfter   := UTF8ToWideString(AAfter._(iComp));
        //
        if (sBefore <> sAfter) or (Copy(sAfter,1,9)='/*real*/ ') then begin
            //此处屏蔽TEdit的OnChange造成的Text回跳 (2021-06-07发现此处在第二窗体时没有屏蔽)
            if (AComponent='')

                or (
                    //屏蔽TEdit / TSpinEdit
                    ((pos('__'+AComponent+'__txt=',sAfter)<=0) and (System.pos('this.'+AComponent+'__txt=',sAfter)<=0))
                    //屏蔽TSpinEdit
                    and
                    ((pos('__'+AComponent+'__val=',sAfter)<=0) and (System.pos('this.'+AComponent+'__val=',sAfter)<=0))
                )
            then begin
                 sCode     := sCode + sAfter;
            end;
        end;
    end;

    //
    Result.o    := sCode;
end;

//推荐最新的的关键信息,生成client端的JS语句
function dwGetAfters(AAfter:Variant):Variant;
var
     iComp     : Integer;
     //
     sCode     : string;
     sBefore   : string;
     sAfter    : string;
begin
     //
     TDocVariant.New(Result);
     Result.m    := 'update';

     //逐个控件比较
     sCode     := '';
     for iComp := 0 to AAfter._Count-1 do begin
          //得到控件事件前后
          sAfter   := UTF8ToWideString(AAfter._(iComp));
          //
          sCode     := sCode + sAfter;
     end;

     //
     Result.o    := sCode;
end;


function dwStop:Integer;
begin
     //
     goHttpServer.Stop;
     Result    := 0;
end;




















{ We need to override parent class destructor because we have allocated     }
{ memory for our data buffer.                                               }

function dwPlatFormToShiftState(APlatform:Integer):TShiftState;
begin
     //ssShift, ssAlt, ssCtrl,ssLeft, ssRight,
     //分别对应0:未知/1:PC/2:Android/3:iPhone/4:Tablet
     case APlatform of
          0 : begin
               Result    := [ssShift];
          end;
          1 : begin
               Result    := [ssAlt];
          end;
          2 : begin
               Result    := [ssCtrl];
          end;
          3 : begin
               Result    := [ssLeft];
          end;
          4 : begin
               Result    := [ssRight];
          end;
     else
          Result    := [ssShift];
     end;
end;

function dwShiftStateToPlatForm(AShiftState:TShiftState):string;
begin
     //ssShift, ssAlt, ssCtrl,ssLeft, ssRight, ...
     //分别对应0:未知/1:PC/2:Android/3:iPhone/4:Tablet
     if AShiftState = [ssShift] then begin
          Result    := 'unknown';
     end else if AShiftState = [ssAlt] then begin
          Result    := 'pc';
     end else if AShiftState = [ssCtrl] then begin
          Result    := 'android';
     end else if AShiftState = [ssLeft] then begin
          Result    := 'iphone';
     end else if AShiftState = [ssRight] then begin
          Result    := 'tablet';
     end else begin
          Result    := 'unknown';
     end;
end;


function dwGetMD5(AStr:String):string;
var
     oMD5      : TIdHashMessageDigest5;
begin
     oMD5      := TIdHashMessageDigest5.Create;
     {$IFDEF VER150} //D7
     Result    := LowerCase(oMD5.AsHex(oMD5.HashValue(AStr)));
     {$ELSE}
     Result    := LowerCase(oMD5.HashStringAsHex(AStr));
     {$ENDIF}
     oMD5.Free;
end;


function dwGetText(AText:string;ALen:integer):string;
begin
     if Length(AText)<ALen then begin
          Result    := AText;
     end else begin
          //先判断要截取的字符串最后一个字节的类型
          //如果为汉字的第一个字节则减(加)一位
          if ByteType(AText,ALen) = mbLeadByte then
               ALen := ALen - 1;
          result := copy(AText,1,ALen) + '...';
     end;
end;

function dwLongStr(AText:String):String;
var
     slTmp     : TStringList;
     iItem     : Integer;
begin
     if AText = '' then begin
          Result    := AText;
     end else begin
          slTmp     := TStringList.Create;
          //AText     := StringReplace(AText,'<br/>','"'#13'+"',[rfReplaceAll]);
          //AText     := StringReplace(AText,'<br>', '"'#13'+"',[rfReplaceAll]);
          slTmp.Text     := AText;
          //
          Result    := '';
          for iItem := 0 to slTmp.Count-2 do begin
               Result    := Result + slTmp[iItem]+#13#10;
          end;
          Result    := Result + slTmp[slTmp.Count-1];
        if slTmp <> nil then begin
            FreeAndNil(slTmp);
        end;
     end;
end;

function dwPHPToDate(ADate:Integer):TDateTime;
var
     f1970     : TDateTime;
begin
     //PHP时间是格林威治时间1970-1-1 00:00:00到当前流逝的秒数
     f1970     := StrToDateTime('1970-01-01 00:00:00');
     Result    := IncSecond(f1970,ADate);
     //Result    := ((ADate+28800)/86400+25569);
end;


//反编码函数
function dwDecode(AText:string):string;
begin
     Result    := StringReplace(AText,'%7B','{',[rfReplaceAll]);
     Result    := StringReplace(Result,'%7D','}',[rfReplaceAll]);
     Result    := StringReplace(Result,'%22','"',[rfReplaceAll]);
end;


//设置LTWH
function dwSetCompLTWH(AComponent:TComponent;ALeft,ATop,AWidth,AHeight:Integer):Integer;
begin
     AComponent.DesignInfo    := ALeft  * 10000 + ATop;
     AComponent.Tag           := AWidth * 10000 + AHeight;
     //
     Result    := 0;
end;

//设置PlaceHolder
function dwSetPlaceHodler(AControl:TControl;APH:String):Integer;
var
     sHint     : String;
     joHint    : Variant;
begin
     sHint     := AControl.Hint;
     //joHint    := Variant.Create;
     joHint    := _json(sHint);
     if joHint = unassigned then begin
        joHint    := _json('{}');
     end;
     joHint.planeholder  := APH;
     AControl.Hint  := VariantSaveJSON(joHint);
end;

//设置Height
function dwSetHeight(AControl:TControl;AHeight:Integer):Integer;
var
     sHint     : String;
     joHint    : Variant;
begin
    sHint     := AControl.Hint;
    joHint    := _json(sHint);
    if joHint = unassigned then begin
        joHint    := _json('{}');
    end;
    joHint.height  := AHeight;
    AControl.Hint  := VariantSaveJSON(joHint);
    //
    Result    := 0;
end;




function dwMemoValueToText(AText:string):string;
begin
     Result    := StringReplace(AText,'\r\n',#13,[rfReplaceAll]);
     Result    := dwUnescape(Result);
end;



function dwMemoTextToValue(AText:string):string;
var
     slTxt     : TStringList;
     iItem     : Integer;
begin
    slTxt     := TStringList.Create;
    slTxt.Text     := AText;
    Result    := '';
    for iItem := 0 to slTxt.Count-1 do begin
        if iItem <slTxt.Count-1 then begin
           Result     := Result + slTxt[iItem]+'\n';
        end else begin
           Result     := Result + slTxt[iItem];
        end;
    end;
    if slTxt <> nil then begin
        FreeAndNil(slTxt);
    end;
end;


procedure showMsg(AMsg:string);
begin
     {$IFDEF DEBUG}
          //ShowMessage(AMsg);
     {$ENDIF}

end;

procedure dwRealignPanel(APanel:TPanel;AHorz:Boolean);
var
     iCtrl     : Integer;
     oCtrl     : TControl;
     oCtrl0    : TControl;
begin
     //
     if APanel.ControlCount<=1 then begin
          Exit;
     end;

     //取得第一个控件, 以检测当前状态
     oCtrl0    := APanel.Controls[0];

     if AHorz then begin
          //水平排列的情况
          if (oCtrl0.Align = alLeft) and (oCtrl0.Width = (APanel.Width-2*APanel.BorderWidth) div APanel.ControlCount) then begin
               //已经水平排列,
          end else begin
               APanel.Height  := APanel.BorderWidth*2+oCtrl0.Height;
               //
               for iCtrl := 0 to APanel.ControlCount-2 do begin
                    oCtrl     := APanel.Controls[iCtrl];
                    //
                    oCtrl.Align    := alLeft;
                    oCtrl.Width    := (APanel.Width-2*APanel.BorderWidth) div APanel.ControlCount;
                    oCtrl.Left     := 9000+iCtrl;
               end;
               //最后一个alClient
               oCtrl     := APanel.Controls[APanel.ControlCount-1];
               oCtrl.Align    := alClient;
          end;
     end else begin
          //垂直排列的情况
          if (oCtrl0.Align = alTop) and (oCtrl0.Height = (APanel.Height-2*APanel.BorderWidth) div APanel.ControlCount) then begin
               //已经垂直排列,
          end else begin
               APanel.Height  := APanel.BorderWidth*2+oCtrl0.Height*APanel.ControlCount;
               //
               for iCtrl := 0 to APanel.ControlCount-2 do begin
                    oCtrl     := APanel.Controls[iCtrl];
                    //
                    oCtrl.Align    := alTop;
                    oCtrl.Height   := (APanel.Height-2*APanel.BorderWidth) div APanel.ControlCount;
                    oCtrl.Top      := 9000+iCtrl;
               end;
               //最后一个alClient
               oCtrl     := APanel.Controls[APanel.ControlCount-1];
               oCtrl.Align    := alClient;
          end;
     end;

end;

procedure dwRealignChildren(ACtrl:TWinControl;AHorz:Boolean;ASize:Integer);
var
     iCount    : Integer;
     iItem     : Integer;
     iW        : Integer;
     iItemW    : Integer;
     //
     oCtrl     : TControl;
     //
     procedure _AutoSize(ooCtrl:TControl);
     begin
          if Assigned(GetPropInfo(ooCtrl.ClassInfo,'AutoSize')) then begin
               TPanel(ooCtrl).AutoSize  := False;
               TPanel(ooCtrl).AutoSize  := True;
          end;
     end;
begin
     //重排ACtrl的子控件
     //如果水平(AHorz=True), 则取所有控件等宽水平放置
     //如果垂直, 则所有控件Align=alTop


     //得到子控件数量
     iCount    := ACtrl.ControlCount;
     if iCount = 0 then begin
          Exit;
     end;


     if AHorz then begin
          //水平排列

          //先取得总宽度
          if Assigned(GetPropInfo(ACtrl.ClassInfo,'BorderWidth')) then begin
               iW   := ACtrl.Width - TPanel(ACtrl).BorderWidth;
          end else begin
               iW   := ACtrl.Width;
          end;
          iItemW    := Round(iW / iCount);

          //重新排列
          for iItem := 0 to ACtrl.ControlCount-1 do begin
               oCtrl     := ACtrl.Controls[iItem];
               //自动大小
               //_AutoSize(oCtrl);
               //
               if iItem<ACtrl.ControlCount-1 then begin
                    oCtrl.Align    := alLeft;
                    oCtrl.Width    := iItemW;
                    oCtrl.Top      := 0;
                    oCtrl.Left     := 99999;
               end else begin
                    oCtrl.Align    := alClient;
               end;

               //自动大小
               _AutoSize(oCtrl);
          end;

          //自动大小
          _AutoSize(ACtrl);
     end else begin
          //垂直排列

          //重新排列
          for iItem := 0 to ACtrl.ControlCount-1 do begin
               oCtrl     := ACtrl.Controls[iItem];
               //自动大小
               _AutoSize(oCtrl);
               //
               oCtrl.Align    := alTop;
               oCtrl.Top      := 99999;
               if ASize>0 then begin
                    oCtrl.Height   := ASize;
               end else begin
                    //自动大小
                    _AutoSize(oCtrl);
               end;
          end;

          //自动大小
          _AutoSize(ACtrl);
     end;

end;


//读取并生成圆角信息
function dwRadius(AJson:Variant):string;
var
     sRadius   : string;
begin
     sRadius   := dwGetJsonAttr(AJson,'radius');
     //
     Result    := '';
     if sRadius<>'' then begin
          Result    := 'border-radius:'+sRadius+';'
     end;
end;

function dwGetJsonAttr(AJson:Variant;AAttr:String):String;
var
     sHint     : String;
     joHint    : Variant;
begin
    Result    := '';
    //
    sHint     := AJson.hint;

     //创建HINT对象, 用于生成一些额外属性
    joHint    := _json(sHint);
    if joHint = unassigned then begin
        joHint    := _json('{}');
    end;

    //
    if not dwIsNull(joHint) then begin
        Result    := joHint._(AAttr);
    end;
end;


function dwGetProp(ACtrl:TControl;AAttr:String):String;
var
    joHint  : Variant;
begin
    //默认返回值
    Result  := '';
    //
    joHint  := _json(ACtrl.Hint);
    //
    if joHint <> unassigned then begin
        if joHint.Exists(AAttr) then begin
            if joHint._(AAttr) <> null then begin
                Result  := joHint._(AAttr);
            end;
        end;
    end;

end;

function dwSetProp0(ACtrl:TControl;AAttr,AValue:String):Integer;
var
    joHint  : Variant;
begin
    Result    := 0;
    //
    joHint  := _json(ACtrl.Hint);
    //
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    joHint.Add(AAttr,AValue);

    //返回到HINT字符串
    ACtrl.Hint     := String(joHint);
end;


function dwEscape(const StrToEscape:string):String;
var
    i : Integer;

    w : Word;
    S : String;
begin
    //
    S   := StringReplace(StrToEscape,'''','\''',[rfReplaceAll]);
    Result  := dwRunJS('var res=escape('''+S+''')','res');
    Exit;

    //
    Result:='';

    for i:=1 to Length(StrToEscape) do
    begin
        w:=Word(StrToEscape[i]);

        if w in [Ord('0')..Ord('9'),Ord('A')..Ord('Z'),Ord('a')..Ord('z')] then
            Result:=Result+Char(w)
        else if w<=255 then
            Result:=Result+'%'+IntToHex(w,2)
        else
            Result:=Result+'%u'+IntToHex(w,4);
    end;
end;

function dwUnescape(S: string): string;
var
    i0,i1   : Integer;
    iTmp    : Integer;
    sOld    : string;
begin
    //先保存S以备用
    sOld    := S;
    //
    Result := '';
    while Length(S) > 0 do begin
        if S[1]<>'%' then begin
            Result    := Result + S[1];
            Delete(S,1,1);
        end else begin
            Delete(S,1,1);
            if S[1]='u' then begin
                try
                    //Result    := Result + Chr(StrToInt('$'+Copy(S, 2, 2)))+ Chr(StrToInt('$'+Copy(S, 4, 2)));
                    i0   := StrToIntDef('$'+Copy(S, 2, 2),-1);
                    i1   := StrToIntDef('$'+Copy(S, 4, 2),-1);
                    if (i0>=0)and(i1>=0) then begin
                        Result  := Result + WideChar((i0 shl 8) or i1);
                    end else begin
                        Result  := sOld;
                        Exit;
                    end;
                except
                    //ShowMessage(Result);

                end;
                Delete(S,1,5);
            end else begin
                try
                    iTmp    := StrToIntDef('$'+Copy(S, 1, 2),-1);
                    if (iTmp>=0)then begin
                        Result    := Result + Chr(iTmp);
                    end else begin
                        Result  := sOld;
                        Exit;
                    end;
                except
                    //ShowMessage(Result);

                end;
                Delete(S,1,2);
            end;
        end;
    end;
end;




function dwConvertStr(AStr:String):String;
begin
     //替换空格
     Result    := StringReplace(AStr,' ','&ensp;',[rfReplaceAll]);
end;

function dwProcessCaption(AStr:String):String;
begin
     //替换空格
     Result    := AStr;
     //Result    := StringReplace(Result,' ','&nbsp;',[rfReplaceAll]);
     Result    := StringReplace(Result,'"','\"',[rfReplaceAll]);
     Result    := StringReplace(Result,'''','\''',[rfReplaceAll]);
     Result    := StringReplace(Result,#13#10,'\n',[rfReplaceAll]);
     Result    := Trim(Result);
end;


function dwBoolToStr(AVal:Boolean):string;
begin
     if AVal then begin
          Result    := 'true';
     end else begin
          Result    := 'false';
     end;
end;

function dwIsNull(AVar:Variant):Boolean;
begin
     Result    := (lowerCase(VarToStr(AVar)) = 'null') or (VarToStr(AVar) = '');
end;


function HTTPEncodeEx(const AStr: String): String;
const
     NoConversion = ['A'..'Z','a'..'z','*','@','.','_','-','0'..'9','$','!','''','(',')'];
var
     Sp, Rp: PChar;
begin
     SetLength(Result, Length(AStr) * 3);
     Sp := PChar(AStr);
     Rp := PChar(Result);
     while Sp^ <> #0 do begin
          if Sp^ in NoConversion then begin
               Rp^ := Sp^
          end else begin
               FormatBuf(Rp^, 3, '%%%.2x', 6, [Ord(Sp^)]);
               Inc(Rp,2);
          end;
          Inc(Rp);
          Inc(Sp);
     end;
     SetLength(Result, Rp - PChar(Result));
end;



function dwEncodeURIComponent(S:String):String;
begin

    //发送消息到监控器
    //MainForm.AddMsg(' ->>> 0 dwEncodeURIComponent');

    //S    := 'ABC+12  3';
    S    := StringReplace(S,'+','[&&&&&]',[rfReplaceAll]);
    //发送消息到监控器
    //MainForm.AddMsg(' ->>> 1 dwEncodeURIComponent');

    S    := HttpEncode((S));

    //发送消息到监控器
    //MainForm.AddMsg(' ->>> 2 dwEncodeURIComponent');

    S    := StringReplace(S,'+',' ',[rfReplaceAll]);
    S    := StringReplace(S,'%5B%26%26%26%26%26%5D','+',[rfReplaceAll]);
    //发送消息到监控器
    //MainForm.AddMsg(' ->>> 3 dwEncodeURIComponent');

    Result    := S;



end;

function dwDecodeURIComponent(S:String):String;
begin
    //Result   := UTF8Decode(HttpDecode(S));
    //Exit;

    //S    := 'ABC+12  3';
    S    := StringReplace(S,'+','[&&&&&]',[rfReplaceAll]);
    S    := (HttpDecode(S));
    S    := StringReplace(S,'[&&&&&]','+',[rfReplaceAll]);
    Result    := S;
end;



function dwColor(AColor:Integer):string;
begin
     Result := Format('#%.2x%.2x%.2x',[GetRValue(ColorToRGB(AColor)),GetGValue(ColorToRGB(AColor)),GetBValue(ColorToRGB(AColor))]);
end;



//解密函数
function dwDecryptKey (Src:String; Key:String):string;
var
     KeyLen :Integer;
     KeyPos :Integer;
     offset :Integer;
     dest :string;
     SrcPos :Integer;
     SrcAsc :Integer;
     TmpSrcAsc :Integer;
begin
     try
          KeyLen:=Length(Key);
          if KeyLen = 0 then key:='Think Space';
          KeyPos:=0;
          offset:=StrToInt('$'+ copy(src,1,2));
          SrcPos:=3;
          repeat
               SrcAsc:=StrToInt('$'+ copy(src,SrcPos,2));
               if KeyPos < KeyLen Then KeyPos := KeyPos + 1 else KeyPos := 1;
               TmpSrcAsc := SrcAsc xor Ord(Key[KeyPos]);
               if TmpSrcAsc <= offset then
                    TmpSrcAsc := 255 + TmpSrcAsc - offset
               else
                    TmpSrcAsc := TmpSrcAsc - offset;
               dest := dest + chr(TmpSrcAsc);
               offset:=srcAsc;
               SrcPos:=SrcPos + 2;
          until SrcPos >= Length(Src);
               Result:=Dest;
     except
          Result    := 'ias@njw#oriu$we_em1!83~4r`mskjhr?';
     end;
end;


function dwIIF(ABool:Boolean;AYes,ANo:string):string;
begin
     if ABool then begin
          Result    := AYes;
     end else begin
          Result    := ANo;
     end;
end;

function dwVisible(ACtrl:TControl):String;
begin
     Result    := ' v-if="'+ACtrl.Name+'__vis"';
end;

function dwDisable(ACtrl:TControl):String;
begin
     Result    := ' :disabled="'+ACtrl.Name+'__dis"';
end;

function dwGetHintJson(ACtrl:TControl):Variant;
var
     sHint     : String;
begin
    sHint     := ACtrl.Hint;
    TDocVariant.New(Result);
    Result    := _json(sHint);
    if Result = unassigned then begin
        Result    := _json('{}');
    end;
end;

function dwLTWH(ACtrl:TControl):String;  //可以更新位置的用法
var
     joHint    : Variant;
     sZI       : String;
begin
     //
     joHint    := dwGetHintJson(ACtrl);

     //
     if joHint.Exists('z-index')  then begin
          sZI  := 'z-index:'+IntToStr(Min(joHint._('z-index'),998))+';';
     end;

     //
     with ACtrl do begin
          Result    := ' :style="{left:'+Name+'__lef,top:'+Name+'__top,width:'+Name+'__wid,height:'+Name+'__hei}"'
                    +' style="position:absolute;'+sZI;
     end;
end;
function dwLTWHComp(ACtrl:TComponent):String;  //可以更新位置的用法
begin

     //
     with ACtrl do begin
          Result    := ' :style="{left:'+Name+'__lef,top:'+Name+'__top,width:'+Name+'__wid,height:'+Name+'__hei}"'
                    +' style="position:absolute;';
     end;
end;

function dwGetHintValue(AHint:Variant;AJsonName,AHtmlName,ADefault:String):String;
begin
     if AHint.Exists(AJsonName) then begin
          Result    := AnsiString(' '+AHtmlName+'="'+AHint._(AJsonName)+'"');
     end else begin
          Result    := ADefault;
     end;
end;

end.
