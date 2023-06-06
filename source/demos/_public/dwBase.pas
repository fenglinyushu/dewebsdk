unit dwBase;

interface

uses
    //第三方
    SynCommons{用于解析JSON},
    //JsonDataObjects,


    //求MD5
    IdHashMessageDigest,IdGlobal, IdHash,
    //第三方
    IdCustomHTTPServer, IdHashSHA, IdHTTP, IdSSLOpenSSL, IdMultipartFormData,

    //AES加密解密
    FlyUtils.AES,FlyUtils.CnXXX.Common,


    //系统单元
    Buttons,
    AnsiStrings,
    RegularExpressions,    //正则表达式
    System.TypInfo,

    HTTPApp, Dialogs, ComCtrls,Math,DateUtils,Variants,
    Windows, Messages, SysUtils, Classes, Controls, Forms,Graphics,
    StdCtrls, ExtCtrls, StrUtils, Grids,Types,
    IniFiles,   Menus,  ShellAPI, FileCtrl ;

const
  FILE_CREATE_TIME = 0;  //创建时间
  FILE_MODIFY_TIME = 1;  //修改时间
  FILE_ACCESS_TIME = 3;  //访问时间



//Bool型转字符串：true/false
function  dwBoolToStr(AVal:Boolean):string;

//转换空格
function  dwConvertStr(AStr:String):String;

//Escape编码
function  dwEscape(const StrToEscape:string):String;

//
function  dwGetText(AText:string;ALen:integer):string;

//处理长字符
function  dwLongStr(AText:String):String;

//对HTML敏感的字符进行转义
function dwHtmlEscape(AText:String):String;

//将PHP中的日期转换为Delphi的日期
function  dwPHPToDate(ADate:Integer):TDateTime;
function  dwDateToPHPDate(ADate:TDateTime):Integer;

//处理Caption中的特殊字符
function  dwProcessCaption(AStr:String):String;

//重排子控件
procedure dwRealignChildren(ACtrl:TWinControl;AHorz:Boolean;ASize:Integer);

//重排Panel中的子控件
procedure dwRealignPanel(APanel:TPanel;AHorz:Boolean);

//设置LTWH
function  dwSetCompLTWH(AComponent:TComponent;ALeft,ATop,AWidth,AHeight:Integer):Integer;

//设置窗体高度，以解决当窗体高度大于屏幕分辨率高度时，无法设置当前窗体高度的问题
function  dwSetHeight(AControl:TControl;AHeight:Integer):Integer;

//设置默认选中的菜单项，如：dwSetMenuDefault(MainMenu,'1-0-2');注：序号从0开始，每层之间用-隔开
function dwSetMenuDefault(AMenu:TMainMenu;ADefault:String):Integer;

//常用版ShowMessage
procedure dwShowMessage(AMsg:String;AForm:TForm);
procedure dwShowMessagePro(AMsg,AJS:String;AForm:TForm);

//定制版ShowMessage, 可以定制标题， 按钮名称等
procedure dwShowMsg(AMsg,ACaption,AButtonCaption:String;AForm:TForm);

//MessageDlg
procedure dwMessageDlg(AMsg,ACaption,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);

//Escape解码
function  dwUnescape(S: string): string;

//将类似“%u4E2D”转成中文
function  dwUnicodeToChinese(inputstr: string): string;
function  dwISO8859ToChinese(AInput:String):string;


//Cookie操作
function  dwSetCookie(AForm:TForm;AName,AValue:String;AExpireHours:Integer):Integer;  //写cookie
function  dwSetCookiePro(AForm:TForm;AName,AValue,APath,ADomain:String;AExpireHours:Integer):Integer;
//function  dwPreGetCookie(AForm:TForm;AName,ANull:String):Integer;                    //预读cookie
function  dwGetCookie(AForm:TForm;AName:String):String;                              //读cookie

//输入
procedure dwInputQuery(AMsg,ACaption,ADefault,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);


//打开新页面
function dwOpenUrl(AForm:TForm;AUrl,Params:String):Integer;

//从控件的hint中读写值
function dwGetProp(ACtrl:TControl;AAttr:String):String;
function dwSetProp(ACtrl:TControl;AAttr,AValue:String):Integer;

//计算MD5
function dwGetMD5(AStr:String):string;

//处理ZXing扫描
function dwSetZXing(ACtrl:TControl;ACameraID:Integer):Integer;
function dwStopZXing(ACtrl:TControl;ACameraID:Integer):Integer;

//取得DLL名称
function dwGetDllName: string;

//执行一段JS代码，注意需要以分号结束
function dwRunJS(AJS:String;AForm:TForm):Boolean;

//快速IF
function dwIIF(ABool:Boolean;AYes,ANo:string):string;
function dwIIFi(ABool:Boolean;AYes,ANo:Integer):Integer;

//计算TimeLine的高度(参考)
function dwGetTimeLineHeight(APageControl:TPageControl):Integer;

//<转义可能出错的字符
function  dwChangeChar(AText:String):String;

//弹出窗体
function  dwShowModalPro(AForm,ASWForm:TForm):Integer;
function  dwShowModal(AForm,ASWForm:TForm):Integer;
function  dwCloseForm(AForm,ASWForm:TForm):Integer;

//计算手机可用高度
function  dwGetMobileAvailHeight(AForm:TForm):Integer;

//检查当前字符串是否JSON合法
function    dwStrIsJson(AText:String):Boolean;

//设置当前应用为移动应用，根据参数自动设置窗体Width,Height
//ADefaultWidth,ADefaultHeight为电脑浏览时的默认大小，一般建议为414/736(iPhone6/7/8 plus)
//如果有一项为0，则为当前屏幕大小（只设置宽度，不设置高度）
function    dwSetMobileMode(AForm:TForm;ADefaultWidth,ADefaultHeight:Integer):Integer;

//设置当前应用为桌面应用，根据参数自动设置窗体Width,Height
function    dwSetPCMode(AForm:TForm):Integer;


//加密函数
function dwAESDecrypt(StrHex, Key: string): string;
function dwAESEncrypt(Value, Key: string): string;
function dwRegAESDecrypt(StrHex, Key: string): string;  //注册机所用的加密函数
function dwRegAESEncrypt(Value, Key: string): string;

//取URL参数相关属性值
//例如:http://127.0.0.1/GetActivityinformation?language=Chinese&name=westwind
//用法:
//    sLang := dwGetParamValue(dwGetProp(Self,'params'),'language'); //获取语言
//    sName := dwGetParamValue(dwGetProp(Self,'params'),'name');    //获取name
function dwGetParamValue(QueryStr,Param_Name : string) : string;   //正则表达，获取URL中参数


//显示自动消失的消息框, AMessage 为消息内容, AType为消息类型:normal/success/warngin/error
procedure dwMessage(AMessage,AType:String;AForm:TForm);
procedure dwMessagePro(AMessage:String;AForm:TForm);

//根据owner是否为TForm1, 来增加前缀，主要用于区分多个Form中的同名控件
function  dwPrefix(ACtrl:TComponent):String;
function  dwFullName(ACtrl:TComponent):String;

//StringGrid按列排序
procedure dwGridQuickSort(Grid: TStringGrid; ACol: Integer; Order: Boolean ; AIsNum: Boolean);

//StringGrid按列筛选,AFilter 为类似 "filter":["襄阳","沈阳"]
procedure dwGridQuickFilter(Grid:TStringGrid;ACol:Integer;AFilter:String);

procedure dwGridSaveCells(Grid:TStringGrid;AForce:Boolean);
procedure dwGridRestoreCells(Grid:TStringGrid);

function  dwGetHtmlMemoHeight(AMemo:TMemo):Integer;


//AForm : 窗体本身，一般用self
//AAccept : 文件上传类型控制，类似"image/gif, image/jpeg"
//ADestDir : 上传目录，为空时上传到服务器upload目录，有值时上传到指定目录，支持子目录
//事件:
//上传完成后，自动触发窗体的OnEndDock事件
function  dwUpload(AForm:TForm;AAccept,ADestDir:String):Integer;
function  dwUploadMultiple(AForm:TForm;AAccept,ADestDir:String):Integer;
function  dwUploadPro(AForm:TForm;AAccept,ADestDir,ACapture:String):Integer;

function  dwColorAlpha(AColor:Integer):string;

//设置焦点
function  dwSetFocus(ACtrl:TControl): Integer;
function  dwSetSelStart(ACtrl:TControl;AStart:Integer): Integer;
function  dwSetSelEnd(ACtrl:TControl;AEnd:Integer): Integer;

//取得主窗体
function dwGetMainForm(ACtrl:TControl): TForm;

//取文件时间
function dwGetFileTime(AFileName: string; AFlag: Byte): TDateTime;

//控制TScrollBox的滚动量
function dwSetScroll(AScrollBox:TScrollBox;AValue:Integer):Integer;

function dwPrint(ACtrl:TControl):Integer;

//初始化echarts图表
function dwEcharts(ACtrl:TComponent):Integer;

//刷新echarts地图
function dwEchartsMap(ACtrl:TComponent):Integer;


//控制滚动量
function dwScroll(ACtrl:TComponent;Value:Integer):Integer;


//控制全屏或退出全屏
function dwFullScreen(AFullScreen:Boolean;AForm:TForm):Integer;

//对Panel内的控件按TabOrder顺序进行水平等分排列 ，AColCount为每行的项目数，大于等于1
//要求：
//1 全自动根据Margins属性进行控制，不管AlignWithMargins是否为真，需要先设置了Magins
//2 子控件必须有TabOrder属性，如TPanel,TButton, 不能是TSpeedButton(可以在外面包一层TPanel)
//3 控件的Margins的left/right, Top/Bottom尽量保持一致
function dwAlignByColCount(AParent:TPanel;AColCount:Integer):Integer;


//从JSON中读属性，如果不存在的话，取默认值
function dwGetInt(AJson:Variant;AName:String;ADefault:Integer):Integer;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetStr(AJson:Variant;AName:String;ADefault:String):String;


function dwGetMethod(Url: String; Max: Integer): String;
function dwPostMethod(Url: String; Data: UTF8String; Max: Integer): String;

function dwLoadFromJson(var AJson:Variant;AFileName:String):Integer;
function dwSaveToJson(AJson:Variant;AFileName:String;ACompact:Boolean ):Integer;

//json 转 string
function _J2S(AJson:Variant):String;

implementation  //==================================================================================

function _J2S(AJson:Variant):String;
begin
    Result  := VariantSaveJSON(AJson);
end;
function dwLoadFromJson(var AJson:Variant;AFileName:String):Integer;
begin
    Result  := -1;
    if FileExists(AFileName) then begin
        AJson   := _Json('{}');
        DocVariantData(AJson).InitJSONFromFile(AFileName);
        //
        if AJson <> unassigned then begin
            Result  := 0;
        end;
    end;
end;

function dwSaveToJson(AJson:Variant;AFileName:String;ACompact:Boolean ):Integer;
begin
    if ACompact then begin
        JSONReformatToFile(DocVariantData(AJson).ToJSON(),AFileName);
    end else begin
        JSONReformatToFile(DocVariantData(AJson).ToJSON('','',jsonHumanReadable),AFileName);
    end;
end;

function dwGetMethod(Url: String; Max: Integer): String;
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

function dwPostMethod(Url: String; Data: UTF8String; Max: Integer): String;
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


//从JSON中读属性，如果不存在的话，取默认值
function dwGetInt(AJson:Variant;AName:String;ADefault:Integer):Integer;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            Result  := AJson._(AName);
        end;
    end;
end;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetStr(AJson:Variant;AName:String;ADefault:String):String;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            Result  := AJson._(AName);
        end;
    end;
end;

function dwFullScreen(AFullScreen:Boolean;AForm:TForm):Integer;
var
    sJS     : string;
begin
    if AFullScreen then begin
        //全屏
        sJS     := 'var el = document.documentElement;'
                +'var rfs = el.requestFullScreen || el.webkitRequestFullScreen || el.mozRequestFullScreen || el.msRequestFullscreen;'
                +'if(typeof rfs != "undefined" && rfs) {'
                +'    rfs.call(el);'
                +'};';
    end else begin
        //退出全屏
        sJS     := 'var em = document.exitFullscreen || document.mozCancelFullScreen || document.webkitExitFullscreen || document.webkitExitFullscreen;'
                +'if (em) {em.call(document);};';
        sJS     :=
                'if(document.exitFullScreen) {'
                +'    document.exitFullScreen();'
                +'} else if(document.mozCancelFullScreen) {'
                +'    document.mozCancelFullScreen();'
                +'} else if(document.webkitExitFullscreen) {'
                +'    document.webkitExitFullscreen();'
                +'} else if(document.msExitFullscreen) {'
                +'    document.msExitFullscreen();'
                +'}';
    end;
    dwRunJS(sJS,AForm);
end;


function dwScroll(ACtrl:TComponent;Value:Integer):Integer;
var
    oForm   : TForm;
begin
    oForm   := TForm(ACtrl.Owner);
    //
    dwRunJS(dwFullName(ACtrl)+'.scrollTop = '+IntToStr(Value)+';',oForm);
end;

function dwEcharts(ACtrl:TComponent):Integer;
var
    sJS     : String;
    slTmp   : TStringList;
    iFlag   : Integer;      //Memo__echarts的Lines中的标志行 即：//=====
    iRow    : Integer;
begin
    //定义一个变量，以标识 '//=====' 的行号
    iFlag   := -1;

    //取得TMemo的Lines
    slTmp   := TStringList.Create;
    slTmp.AddStrings(TMemo(ACtrl).Lines);

    //查找 '//=====' 的行号
    for iRow := 0 to slTmp.Count-1 do begin
        if Trim(slTmp[iRow]) = '//=====' then begin
            iFlag   := iRow;
            break;
        end;
    end;

    //删除标识以前的数据
    for iRow := iFlag downto 0 do begin
        slTmp.Delete(iRow);
    end;

    //绘制echarts
    sJS     :=
            ''
            +'var oEcharts = echarts.init(document.getElementById("'+dwFullName(ACtrl)+'"));'
            +slTmp.Text+#13
            +'oEcharts.setOption(option);'
            +'oEcharts.resize();'
            ;
    dwRunJS(sJS,TForm(ACtrl.Owner));

    //释放
    slTmp.Destroy;
    Result  := 0;
end;

function dwEchartsMap(ACtrl:TComponent):Integer;
var
    iItem   : Integer;
    //
    sJS     : String;
    sCode   : String;
    sFull   : String;
    //
    joHint      : Variant;
begin
    //取得JSON
    joHint  := _JSON(TMemo(Actrl).Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;
    if not joHint.Exists('geojson') then begin
        joHint.geojson  := '';
    end;

    //
    sFull   := dwFullName(Actrl);

    //
    with TMemo(ACtrl) do begin
        sCode   := '';
        for iItem := 0 to Lines.Count-1 do begin
            sCode   := sCode + #13+Lines[iItem];//StringReplace(Lines[iItem],'''','"',[rfReplaceAll]);
        end;

        //
        sJS :=  'that = this;'+
                '$.get('''+joHint.geojson+''', function (mapJson) {'+
                    'echarts.registerMap(''MAP'', mapJson);'+

                    // 基于准备好的dom，初始化echarts实例
                    'var myChart = echarts.init(document.getElementById('''+sFull+'''));'+

                    // 指定图表的配置项和数据 option = {...}
                    sCode +#13+

                    // 使用刚指定的配置项和数据显示图表
                    'myChart.setOption(option);'+

                '});';
    end;
    dwRunJS(sJS,TForm(ACtrl.Owner));

    //
    Result  := 0;
end;


function dwPrint(ACtrl:TControl):Integer;
type
    PdwGetExtra = function (ACtrl:TComponent):string;stdcall;
var
    sCode       : string;
    sCss        : string;
    sDll        : string;
    sDir        : string;
    sExtra      : string;
    //
    iDll        : THandle;
    iArray      : Integer;
    //
    joArray     : Variant;
    //
    oGetExtra   : PdwGetExtra;
begin
    //<取得引用的css/js
    if GetPropInfo(ACtrl.classinfo,'FormStyle')<>nil then begin
        sCode   := 'window.print();';
        //
        dwRunJS(sCode,TForm(ACtrl));
    end else begin
        sCode   := '';

        //取得可能引用的JS/CSS
        sDir    := ExtractFilePath(Application.ExeName)+'vcls\';
        sDll    := 'dw'+ACtrl.ClassName;
        if ACtrl.HelpKeyword <> '' then begin
            sDll    := sDll + '__' + ACtrl.HelpKeyword;
        end;
        sDll    := sDir + sDll + '.dll';
        sCss    := '';
        if FileExists(sDll) then begin
            iDll        := LoadLibrary(PChar(sDll));
            oGetExtra   := GetProcAddress(iDll,'dwGetExtra');
            if Assigned(oGetExtra) then begin
                //得到额外的字符串
                sExtra    := oGetExtra(ACtrl);
                //将字符串转为JSON数组
                joArray   := _json(sExtra);
                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
                //复制到slExtr
                for iArray := 0 to joArray._Count-1 do begin
                    sCss    := sCss + joArray._(iArray) + ' ';
                end;
            end;
            //
            FreeLibrary(iDll);
        end;

        //
        sCode   := 'let Pdiv = window.document.getElementById('''+dwFullName(ACtrl)+''');'
        // 创建iframe
        +'let iframe = window.document.createElement(''IFRAME'');'
        +'document.body.appendChild(iframe);'
        +'let doc = iframe.contentWindow.document;'

        //打印时去掉页眉页脚
        //+'doc.write(''<style media="print">@page {size: auto;  margin: 0mm; }</style>'');'

        //引入默认的JS/CSS
        +'var fvue=doc.createElement("script");'
        +'fvue.setAttribute("type","text/javascript");'
        +'fvue.setAttribute("language","JavaScript"); '
        +'fvue.setAttribute("src", ''dist/vue.js'');'
        //
        +'var fjs=doc.createElement("script");'
        +'fjs.setAttribute("type","text/javascript");'
        +'fjs.setAttribute("language","JavaScript"); '
        +'fjs.setAttribute("src", ''dist/index.js'');'
        //
        +'var faxios=doc.createElement("script");'
        +'faxios.setAttribute("type","text/javascript");'
        +'faxios.setAttribute("language","JavaScript"); '
        +'faxios.setAttribute("src", ''dist/axios.min.js'');'
        //----
        +'var fcss=doc.createElement("link");'
        +'fcss.setAttribute("rel","stylesheet");'
        +'fcss.setAttribute("type","text/css"); '
        +'fcss.setAttribute("href", ''dist/theme-chalk/index.css'');'

        //引入可能的第三方JS/CSS
        +'doc.write('''+sCss+''');'
{
    <script src="dist/vue.js" type="text/javascript"></script>
    <script src="dist/index.js" type="text/javascript"></script>
    <script src="dist/axios.min.js" type="text/javascript"></script>
    <link rel="stylesheet" type="text/css" href="dist/theme-chalk/index.css" />


}
        //打印内容放入iframe中'
        +'doc.write(Pdiv.innerHTML);'

        //+'doc.write(''<script src="dist/index.js" type="text/javascript"></script>'');'
(*
        +'doc.write(''<link rel="stylesheet" type="text/css" href="dist/theme-chalk/index.css" />'');'
        +'doc.write('''+sCss+''');'
        +'doc.write(Pdiv.innerHTML);'
        //+'let ys = ''html,body{height:auto}'';'
        //+'let style = document.createElement(''style'');'
        //+'style.innerText = ys;'
        //+'doc.getElementsByTagName(''head'')[0].appendChild(style);'
*)

        +'doc.close();'
        //+'// 开始打印iframe内容'
        +'iframe.contentWindow.focus();'
        +'iframe.contentWindow.print();';
        //+'if (navigator.userAgent.indexOf(''MSIE'') > 0) {'
        //    +'  window.document.body.removeChild(iframe);'
        //+'}';
        //
        dwRunJS(sCode,TForm(ACtrl.Owner));
    end;
    //>

end;


function dwPrint0(ACtrl:TControl):Integer;
type
    PdwGetExtra    = function (ACtrl:TComponent):string;stdcall;
var
    sCode       : string;
    sDll        : string;
    sDir        : string;
    sExtra      : string;
    //
    iDll        : THandle;
    iArray      : Integer;
    //
    joArray     : Variant;
    //
    oGetExtra   : PdwGetExtra;
begin
    //<取得引用的css/js
    if GetPropInfo(ACtrl.classinfo,'FormStyle')<>nil then begin
        sCode   := 'window.print();';
        //
        dwRunJS(sCode,TForm(ACtrl));
    end else begin
        sCode   := '';
        sDir    := ExtractFilePath(Application.ExeName)+'vcls\';
        //
        sDll    := 'dw'+ACtrl.ClassName;
        if ACtrl.HelpKeyword <> '' then begin
            sDll    := sDll + '__' + ACtrl.HelpKeyword;
        end;
        sDll    := sDir + sDll + '.dll';
        if FileExists(sDll) then begin
            iDll        := LoadLibrary(PChar(sDll));
            oGetExtra   := GetProcAddress(iDll,'dwGetExtra');
            if Assigned(oGetExtra) then begin
                //得到额外的字符串
                sExtra    := oGetExtra(ACtrl);
                //将字符串转为JSON数组
                joArray   := _json(sExtra);
                //异常处理
                if joArray = unassigned then begin
                    joArray   := _json('[]');
                end;
                //复制到slExtr
                for iArray := 0 to joArray._Count-1 do begin
                    sCode   := sCode + joArray._(iArray) + ' ';
                end;
            end;
            //
            FreeLibrary(iDll);
        end;
        //
        sCode   := 'window.document.body.innerHTML='''
                +'<script src="dist/index.js" type="text/javascript"></script>'
                +'<link rel="stylesheet" type="text/css" href="dist/theme-chalk/index.css" />'
                + sCode;

        //
        sCode   := sCode
                +'''+'
                +'window.document.getElementById('''+dwFullName(ACtrl)+''').outerHTML;'
                +'window.print();'
                +'location.reload();' ;
        //
        dwRunJS(sCode,TForm(ACtrl.Owner));
        //TForm(ACtrl.Owner).DockSite := True;
    end;
    //>

end;


//控制TScrollBox的滚动量
function dwSetScroll(AScrollBox:TScrollBox;AValue:Integer):Integer;
begin
    //dwRunJS('this.$refs[''SB''].wrap.scrollTop = 200;',self);
    dwRunJS('this.$refs['''+dwFullName(AScrollBox)+'''].wrap.scrollTop = '+IntToStr(AValue)+';',TForm(AScrollBox.Owner));
    Result  := 0;
end;

function dwGetFileTime(AFileName: string; AFlag: Byte): TDateTime;
var
    ffd: TWin32FindData;
    dft: DWord;
    lft: TFileTime;
    h: THandle;
begin
    h   := FindFirstFile(PChar(AFileName),ffd);
    if h<>INVALID_HANDLE_VALUE then begin
        case AFlag of
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


//取得主窗体
function dwGetMainForm(ACtrl:TControl): TForm;
begin
    Result  := TForm(ACtrl.Owner);
    //
    if Result.Owner <> nil then begin
        if LowerCase(Result.Owner.ClassName) = 'tform1' then begin
            Result  := TForm(Result.Owner);
        end;
    end;
end;

function  dwSetFocus(ACtrl:TControl): Integer;
begin
    dwRunJS('document.getElementById('''+dwFullName(ACtrl)+''').focus();'
        //+'document.getElementById('''+dwFullName(ACtrl)+''').selectionStart = 2;'
        //+'document.getElementById('''+dwFullName(ACtrl)+''').selectionEnd=4;'
        ,dwGetMainForm(ACtrl));
end;

function  dwSetSelStart(ACtrl:TControl;AStart:Integer): Integer;
begin
    dwRunJS(''
        //+'document.getElementById('''+dwFullName(Actrl)+''').focus();'
        +'document.getElementById('''+dwFullName(Actrl)+''').selectionStart = '+IntToStr(AStart)+';'
        //+'document.getElementById('''+dwFullName(Actrl)+''').selectionEnd=4;'
        ,dwGetMainForm(ACtrl));
end;

function  dwSetSelEnd(ACtrl:TControl;AEnd:Integer): Integer;
begin
    dwRunJS(''
        //+'document.getElementById('''+dwFullName(Actrl)+''').focus();'
        //+'document.getElementById('''+dwFullName(Actrl)+''').selectionStart = '+IntToStr(AStart)+';'
        +'document.getElementById('''+dwFullName(Actrl)+''').selectionEnd='+IntToStr(AEnd)+';'
        ,dwGetMainForm(ACtrl));
end;

function  dwColorAlpha(AColor:Integer):string;
begin
    if AColor = clNone then begin
        Result  := 'rgbs(0,0,0,0)';
    end else begin
        Result  := Format('#%.2x%.2x%.2x',[GetRValue(ColorToRGB(AColor)),GetGValue(ColorToRGB(AColor)),GetBValue(ColorToRGB(AColor))]);
    end;
end;

function dwUpload(AForm:TForm;AAccept,ADestDir:String):Integer;
var
    sJS     : String;
begin
    //对ADestDir进行格式整理。主要：(1)去除前面\/;(2)将\改为/
    ADestDir    := Trim(ADestDir);
    if ADestDir <> '' then begin
        //去除前面的\
        if ADestDir[1] = '\' then begin
            Delete(ADestDir,1,1);
        end;
        //去除后面的\
        if ADestDir[Length(ADestDir)]='\' then begin
            Delete(ADestDir,Length(ADestDir),1);
        end;
    end;
    //把中间的\转化为/,以适应JS, 防止转义
    ADestDir    := StringReplace(ADestDir,'\','/',[rfReplaceAll]);

    //
    sJS     :=
            'let oInp=document.getElementById(''deweb__inp'');'+
            //'oInp.setAttribute("multiple","false");' +
            'oInp.removeAttribute("multiple");'+
            'this.dw_upload__dir = '''+ADestDir+''';'+
            'this.dw_upload__formhandle = '+IntToStr(AForm.Handle)+';' +
            'oInp.accept='''+AAccept+''';' +
            'oInp.removeAttribute("capture");' +
            'oInp.click();';
    dwRunJS(sJS,AForm);
    //
    Result  := 0;
end;

function dwUploadMultiple(AForm:TForm;AAccept,ADestDir:String):Integer;
var
    sJS     : String;
begin
    //对ADestDir进行格式整理。主要：(1)去除前面\/;(2)将\改为/
    ADestDir    := Trim(ADestDir);
    if ADestDir <> '' then begin
        //去除前面的\
        if ADestDir[1] = '\' then begin
            Delete(ADestDir,1,1);
        end;
        //去除后面的\
        if ADestDir[Length(ADestDir)]='\' then begin
            Delete(ADestDir,Length(ADestDir),1);
        end;
    end;
    //把中间的\转化为/,以适应JS, 防止转义
    ADestDir    := StringReplace(ADestDir,'\','/',[rfReplaceAll]);

    //
    sJS     :=
            'let oInp=document.getElementById(''deweb__inp'');'+
            'oInp.setAttribute("multiple","multiple");' +
            //'oInp.removeAttribute("multiple");'+
            'this.dw_upload__dir = '''+ADestDir+''';'+
            'this.dw_upload__formhandle = '+IntToStr(AForm.Handle)+';' +
            'oInp.accept='''+AAccept+''';' +
            'oInp.removeAttribute("capture");' +
            'oInp.click();';
    dwRunJS(sJS,AForm);
    //
    Result  := 0;
end;

function dwUploadPro(AForm:TForm;AAccept,ADestDir,ACapture:String):Integer;
var
    sJS     : String;
begin
    //对ADestDir进行格式整理。主要：(1)去除前面\/;(2)将\改为/
    ADestDir    := Trim(ADestDir);
    if ADestDir <> '' then begin
        //去除前面的\
        if ADestDir[1] = '\' then begin
            Delete(ADestDir,1,1);
        end;
        //去除后面的\
        if ADestDir[Length(ADestDir)]='\' then begin
            Delete(ADestDir,Length(ADestDir),1);
        end;
    end;
    //把中间的\转化为/,以适应JS, 防止转义
    ADestDir    := StringReplace(ADestDir,'\','/',[rfReplaceAll]);

    //
    sJS     := 'let oInp=document.getElementById('''+AForm.Name+'__inp'');'
            +'this.dw_upload__dir='''+ADestDir+''';'
            +'this.dw_upload__formhandle = '+IntToStr(AForm.Handle)+';'
            +'oInp.accept='''+AAccept+''';'
            +'oInp.capture='''+ACapture+''';'
            +'oInp.click();';
    dwRunJS(sJS,AForm);
    //
    Result  := 0;
end;

function  dwGetHtmlMemoHeight(AMemo:TMemo):Integer;
var
    ighh    : Integer;
    iH      : Integer;
    dwsGHH  : function (AFontName:String;AFontSize:Integer;AHtml:String;AWidth:Integer):Integer;
begin
    iGhh    := StrToInt(dwGetProp(TForm(AMemo.Owner),'gethtmlheight'));
    //
    dwsGHH  := Pointer(iGHH); //给函数指针赋值
    Result  := dwsGHH(AMemo.Font.Name,AMemo.Font.Size,AMemo.Text,AMemo.Width); //调用函数
end;

procedure dwGridRestoreCells(Grid:TStringGrid);
var
    sHint   : String;
    joHint  : Variant;
    joRow   : Variant;
    iR,iC   : Integer;
begin
     //根据Hint生成JSON
     sHint     := Grid.Hint;
     joHint    := _json('{}');
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
     end;

     //
     if joHint.Exists('__cells') then begin
        for iR := 1 to Grid.RowCount-1 do begin
            for iC := 0 to Grid.ColCount-1 do begin
                Grid.Cells[iC,iR]   := joHint.__cells._(iR-1)._(iC);
            end;
        end;
     end;

end;

procedure dwGridSaveCells(Grid:TStringGrid;AForce:Boolean);
var
    sHint   : String;
    joHint  : Variant;
    joRow   : Variant;
    iR,iC   : Integer;
begin
     //根据Hint生成JSON
     sHint     := Grid.Hint;
     joHint    := _json('{}');
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
     end;

     //
     if AForce OR (not joHint.Exists('__cells')) then begin
        joHint.__cells  := _json('[]');
        for iR := 1 to Grid.RowCount-1 do begin
            joRow   := _json('[]');
            for iC := 0 to Grid.ColCount-1 do begin
                joRow.Add(Grid.Cells[iC,iR]);
            end;
            joHint.__cells.Add(joRow);
        end;
        //
        Grid.Hint   := joHint;
     end;

end;

procedure dwGridQuickFilter(Grid:TStringGrid;ACol:Integer;AFilter:String);
    function InFilter(Grid:TStringGrid;ACol,ARow:Integer;AFilter:Variant):Boolean;
    var
        ii  : Integer;
        ss  : string;
    begin
        Result  := False;
        for ii := 0 to AFilter.filter._Count-1 do begin
            ss  := AFilter.filter._(ii);
            if Pos(ss,Grid.Cells[ACol,ARow])>0 then begin
                Result  := True;
                break;
            end;
        end;
    end;
    procedure CopyRowFromNext(Grid:TStringGrid;ARow:Integer);
    var
        iiC : Integer;
    begin
        for iiC := 0 to Grid.ColCount-1 do begin
            if ARow = Grid.RowCount - 1 then begin
                Grid.Cells[iiC,ARow]    := '';
            end else begin
                Grid.Cells[iiC,ARow]    := Grid.Cells[iiC,ARow+1];
            end;
        end;
    end;
var
    iR,iR1,iC   : Integer;
    joFilter    : Variant;
    iCount      : Integer;
begin
    if dwStrIsJson(AFilter) then begin
        //
        dwGridSaveCells(Grid,False);
        //
        dwGridRestoreCells(Grid);

        //
        joFilter    := _json(AFilter);

        iR := 1;
        iCount  := Grid.RowCount-1;
        while iR <= iCount do begin
            //
            if InFilter(Grid,ACol,iR,joFilter) then begin
                Inc(iR);
            end else begin
                for iR1 := iR to Grid.RowCount-1 do begin
                    CopyRowFromNext(Grid,iR1);
                end;
                Dec(iCount);
            end;
            //break;
        end;
    end else begin
        dwGridRestoreCells(Grid);
    end;
end;


procedure dwGridQuickSort(Grid: TStringGrid; ACol: Integer; Order: Boolean ; AIsNum: Boolean);
var
    I,J     : Integer;
    procedure dwSwapRow(Grid:TStringGrid;ARow0,ARow1:Integer);
    var
        sTmp  : String;
        iCol  : Integer;
    begin
        for iCol := 0 to Grid.ColCount-1 do begin
            sTmp    := Grid.Cells[iCol,ARow0];
            Grid.Cells[iCol,ARow0]  := Grid.Cells[iCol,ARow1];
            Grid.Cells[iCol,ARow1]  := sTmp;
        end;
    end;
begin
    for I := 1 to Grid.RowCount-1 do begin
        for J := 1 to Grid.RowCount-1 do begin
            if Order then begin
                if AIsNum then begin
                    if StrToFloatDef(Grid.Cells[ACol,J],0) > StrToFloatDef(Grid.Cells[ACol,I],0) then begin
                        dwSwapRow(Grid,I,J);
                    end;
                end else begin
                    if Grid.Cells[ACol,J] > Grid.Cells[ACol,I] then begin
                        dwSwapRow(Grid,I,J);
                    end;
                end;
            end else begin
                if AIsNum then begin
                    if StrToFloatDef(Grid.Cells[ACol,J],0) < StrToFloatDef(Grid.Cells[ACol,I],0) then begin
                        dwSwapRow(Grid,I,J);
                    end;
                end else begin
                    if Grid.Cells[ACol,J] < Grid.Cells[ACol,I] then begin
                        dwSwapRow(Grid,I,J);
                    end;
                end;
            end;
        end;
    end;
end;



//根据owner是否为TForm1, 来增加前缀，主要用于区分多个Form中的同名控件
function  dwPrefix(ACtrl:TComponent):String;
begin

     //默认为空
     Result    := '';
     //
     if ACtrl.Owner<> nil then begin
         if lowerCase(ACtrl.Owner.ClassName) <> 'tform1' then begin
              Result    := ACtrl.Owner.Name+'__';
         end;
     end;
end;

//取得全部名称，包括前缀
function  dwFullName(ACtrl:TComponent):String;
begin
     Result    := LowerCase(dwPrefix(Actrl)+ACtrl.Name);
end;

procedure dwMessagePro(AMessage:String;AForm:TForm);
begin
    dwRunJs('this.$message('+AMessage+');',AForm);
end;

//显示自动消失的消息框, AMessage 为消息内容, AType为消息类型:info/success/warning/error
procedure dwMessage(AMessage,AType:String;AForm:TForm);
begin
    if LowerCase(AType) = 'success' then begin
        dwRunJs('this.$message({dangerouslyUseHTMLString: true,  message: '''+AMessage+''', type: ''success'' });',AForm);
    end else if LowerCase(AType) = 'warning' then begin
        dwRunJs('this.$message({dangerouslyUseHTMLString: true,  message: '''+AMessage+''', type: ''warning'' });',AForm);
    end else if LowerCase(AType) = 'error' then begin
        dwRunJs('this.$message({dangerouslyUseHTMLString: true,  message: '''+AMessage+''', type: ''error'' });',AForm);
    end else begin
        dwRunJs('this.$message({dangerouslyUseHTMLString: true,  message: '''+AMessage+'''});',AForm);
    end;
end;

function dwGetParamValue(QueryStr,Param_Name : string) : string;   //正则表达，获取page参数
var
    Reg    : TRegEx;
    Match  : TMatch;
begin
    Result := '';
    Match := Reg.Match(QueryStr,'(?<=' + Param_Name + '=)[^&]*');
    if Match.Success then begin
        Result := Match.Value;
    end;
end;

function dwRegAESDecrypt(StrHex, Key: string): string;
begin
  //解密
  Result    := (StrHex);
  Result    := AESDecryptStr(DecodeBase64Bytes(Result), Key, TEncoding.UTF8, TEncoding.ANSI, kb128,
    'deweb', pmPKCS5or7RandomPadding, False, rlCRLF, rlCRLF);
end;
function dwRegAESEncrypt(Value, Key: string): string;
begin
  //加密
  Result := (EncodeBase64Bytes(AESEncryptStr(Value, Key, TEncoding.UTF8, TEncoding.ANSI, kb128,
    'deweb',pmPKCS5or7RandomPadding, False, rlCRLF, rlCRLF)));
end;


function dwAESDecrypt(StrHex, Key: string): string;
begin
  //解密
  Result    := HexToStrByEncoding(StrHex);
  Result    := AESDecryptStr(DecodeBase64Bytes(Result), Key, TEncoding.UTF8, TEncoding.ANSI, kb128,
    'deweb', pmPKCS5or7RandomPadding, False, rlCRLF, rlCRLF);
end;

function dwAESEncrypt(Value, Key: string): string;
begin
  //加密
  Result := StrToHexByEncoding(EncodeBase64Bytes(AESEncryptStr(Value, Key, TEncoding.UTF8, TEncoding.ANSI, kb128,
    'deweb',pmPKCS5or7RandomPadding, False, rlCRLF, rlCRLF)));
end;


function dwGetMD5(AStr:String):string;
var
     oMD5      : TIdHashMessageDigest5;
begin
     oMD5      := TIdHashMessageDigest5.Create;
     Result    := LowerCase(oMD5.HashStringAsHex(AStr));
     oMD5.Free;
end;

function    dwSetMobileMode(AForm:TForm;ADefaultWidth,ADefaultHeight:Integer):Integer;
var
    sInit   : String;
    //
    iOS     : Integer;
    iOrient : Integer;
    iW,iH   : Integer;
    iCltW   : Integer;
    iCltH   : Integer;
    //
    iMin    : Integer;
    iMax    : Integer;
    iMaxT   : Integer;
    iMinT   : Integer;
    iMinI   : Integer;
    iMaxI   : Integer;
    iMinI0  : Integer;
    iMaxI0  : Integer;
    bVert   : Boolean;
begin
    //
    iOs     := StrToIntDef(dwGetProp(AForm,'os'),0);            //分别对应0:未知/1:PC/2:Android/3:iPhone/4:Tablet
    iOrient := StrToIntDef(dwGetProp(AForm,'orientation'),0);   //

    //虚拟分辨率
    iW      := StrToIntDef(dwGetProp(AForm,'screenwidth'),0);
    iH      := StrToIntDef(dwGetProp(AForm,'screenheight'),0);

    //
    iCltW   := StrToIntDef(dwGetProp(AForm,'clientwidth'),0);
    iCltH   := StrToIntDef(dwGetProp(AForm,'clientheight'),0);


    AForm.Left      := 0;
    AForm.Top       := 0;

    if (iW>600)and(iH>600) then begin   //如果是大屏（电脑或平板）
        //如果未指定宽,高,则为屏幕宽(不设置高);否则,设置为默认值
        if ADefaultWidth*ADefaultHeight = 0 then begin
            AForm.Width     := iCltW;
        end else begin
            AForm.Width     := ADefaultWidth;
            AForm.Height    := ADefaultHeight;
        end;
    end else begin
        //检查是否已初始化
        sInit   := dwGetProp(AForm,'_inited');

        //如果未初始化,则先设置初始化标志,再计算宽度; 如果已初始化,则直接设置为Client宽高
        if sInit = '' then begin
            //
            dwSetProp(AForm,'_inited','true');

            //
            bVert   := (iOrient = 0) or (iOrient = 180);

            if bVert then begin
                //竖屏

                //
                AForm.Width     := iW;
                AForm.Height    := Ceil(iW*iCltH/iCltW);
            end else begin
                //横屏

                iMax    := Max(iW,iH);
                iMin    := Min(iW,iH);
                //
                AForm.Width     := iMax;
                AForm.Height    := Ceil(iMax*iCltH/iCltW);
            end;
        end else begin
            //
            iCltW   := StrToIntDef(dwGetProp(AForm,'clientwidth'),0);      //
            iCltH   := StrToIntDef(dwGetProp(AForm,'clientheight'),0);

            //
            AForm.Width     := iCltW;
            AForm.Height    := iCltH;
        end;
    end;

end;

function    dwSetPCMode(AForm:TForm):Integer;
var
    iW,iH   : Integer;
begin
    //分辨率
    iW      := StrToIntDef(dwGetProp(AForm,'innerwidth'),0);
    iH      := StrToIntDef(dwGetProp(AForm,'innerheight'),0);

    if (iW>0)and(iH>0) then begin
        AForm.Left      := 0;
        AForm.Top       := 0;
        AForm.Width     := iW;
        AForm.Height    := iH;
    end;

end;

function    dwStrIsJson(AText:String):Boolean;
begin
    //D自带单元的写法. uses system.json
    //Result  := System.Json.TJSONObject.ParseJSONValue(Trim(AText)) <> nil;

    //mormot的写法
    Result  := _json(AText) <> unassigned;
end;

//计算手机可用高度
function  dwGetMobileAvailHeight(AForm:TForm):Integer;
var
     iX,iY     : Integer;
     iTrueH    : Integer;
     iInnerH   : Integer;
     iTrueW    : Integer;
     iInnerW   : Integer;
begin
     iX        := StrToIntDef(dwGetProp(AForm,'screenwidth'),360);
     iY        := StrToIntDef(dwGetProp(AForm,'screenheight'),720);
     //
     iTrueW    := StrToIntDef(dwGetProp(AForm,'truewidth'),iX);
     iTrueH    := StrToIntDef(dwGetProp(AForm,'trueheight'),iY);
     iInnerW   := StrToIntDef(dwGetProp(AForm,'innerwidth'),iX);
     iInnerH   := StrToIntDef(dwGetProp(AForm,'innerheight'),iY);

     //
     Result    := Ceil(iInnerH*iY/iTrueH*iTrueW/iInnerW);

end;

//弹出窗体
function  dwShowModalPro(AForm,ASWForm:TForm):Integer;
var
    sClass  : String;
    sPrefix : String;
    sJS     : string;
    iCtrl   : Integer;
begin
    //取得窗体的前缀名，备用
    sPrefix := 'this.'+ASWForm.Name+'__';

    //生成JS语句
    sJS     := sPrefix+'cap="'+ASWForm.Caption+'";'  //设置窗体的caption
            +sPrefix+'vis=true;';                    //显示该窗体

    //执行JS语句
    dwRunJS(sJS,AForm);

    //返回值
    Result    := 0;
end;



//弹出窗体
function  dwShowModal(AForm,ASWForm:TForm):Integer;
var
    sClass  : String;
    sPrefix : String;
    sJS     : string;
    iCtrl   : Integer;
begin
    for iCtrl :=0 to AForm.ControlCount-1 do begin
        sClass    := LowerCase(AForm.Controls[iCtrl].ClassName);
        //
        if sClass = LowerCase(ASWForm.ClassName) then begin
            sPrefix := 'this.'+AForm.Controls[iCtrl].Name+'__';
            sJS     := sPrefix+'cap="'+ASWForm.Caption+'";'
                    //+sPrefix+'wid="'+IntToStr(ASWForm.Width)+'px";'
                    //+sPrefix+'hei="'+IntToStr(ASWForm.Height)+'px";'
                    +sPrefix+'vis=true;';
            dwRunJS(sJS,AForm);
            //
            break;
        end;
    end;
    Result    := 0;
end;


function  dwCloseForm(AForm,ASWForm:TForm):Integer;
var
     sClass    : String;
     iCtrl     : Integer;
begin
     for iCtrl :=0 to AForm.ControlCount-1 do begin
          sClass    := LowerCase(AForm.Controls[iCtrl].ClassName);
          //
          if sClass = LowerCase(ASWForm.ClassName) then begin
               dwRunJS('this.'+AForm.Controls[iCtrl].Name+'__vis=false;',AForm);
               //
               break;
          end;
     end;
     Result    := 0;
end;

//<转义可能出错的字符
function  dwChangeChar(AText:String):String;
begin
     AText     := StringReplace(AText,'\"','[!__!]',[rfReplaceAll]);
     AText     := StringReplace(AText,'"','\"',[rfReplaceAll]);
     AText     := StringReplace(AText,'[!__!]','\"',[rfReplaceAll]);

     AText     := StringReplace(AText,'\>','[!__!]',[rfReplaceAll]);
     AText     := StringReplace(AText,'>','\>',[rfReplaceAll]);
     AText     := StringReplace(AText,'[!__!]','\>',[rfReplaceAll]);

     AText     := StringReplace(AText,'\<','[!__!]',[rfReplaceAll]);
     AText     := StringReplace(AText,'<','\<',[rfReplaceAll]);
     AText     := StringReplace(AText,'[!__!]','\<',[rfReplaceAll]);
     //>
     //
     Result    := AText;
end;


//计算TimeLine的高度
function dwGetTimeLineHeight(APageControl:TPageControl):Integer;
var
     iTab      : Integer;
     iTabW     : Integer;
     iCtrl     : Integer;
     iLns      : Integer;
     iRow      : Integer;
     //
     oTab      : TTabSheet;
     oLabel    : TLabel;
     oMemo     : TMemo;
     oForm     : TForm;

begin
     oForm     := TForm(APageControl.Owner);
     oForm.Canvas.Font.Size   := 10;
     //
     Result    := 0;
     for iTab := 0 to APageControl.PageCount-1 do begin
          //日期高度
          if iTab = 0 then begin
               Result    := Result + 38;
          end else begin
               Result    := Result + 45;
          end;
          //标题高度
          Result    := Result + 80;
          //
          oTab      := APageControl.Pages[iTab];
          iTabW     := oTab.Width;

          //
          for iCtrl := 0 to oTab.ControlCount-1 do begin
               if oTab.Controls[iCtrl].ClassName = 'TLabel' then begin
                    oLabel    := TLabel(oTab.Controls[iCtrl]);
                    iLns      := Ceil(oForm.Canvas.TextWidth(oLabel.Caption) / (iTabW-70));
                    //
                    Result    := Result + iLns*11+(iLns-1)*8 + 24;
               end else if oTab.Controls[iCtrl].ClassName = 'TMemo' then begin
                    oMemo     := TMemo(oTab.Controls[iCtrl]);
                    for iRow := 0 to oMemo.Lines.Count-1 do begin
                         iLns      := Ceil(oForm.Canvas.TextWidth(oMemo.Lines[iRow]) / (iTabW-70));
                         //
                         Result    := Result + iLns*11+(iLns-1)*8 + 24;
                    end;
               end;
          end;

          //
          Result    := Result + 15;
     end;
     //
     Result    := Result + 15;

end;

function dwIIF(ABool:Boolean;AYes,ANo:string):string;
begin
     if ABool then begin
          Result    := AYes;
     end else begin
          Result    := ANo;
     end;
end;
function dwIIFi(ABool:Boolean;AYes,ANo:Integer):Integer;
begin
     if ABool then begin
          Result    := AYes;
     end else begin
          Result    := ANo;
     end;
end;


function dwRunJS(AJS:String;AForm:TForm):Boolean;
begin
     AForm.HelpFile := AForm.HelpFile + AJS;
     //
     Result    := True;

end;

function dwGetDllName: string;
var
     sModule   : string;
begin
     SetLength(sModule, 255);
     //取得Dll自身路径
     GetModuleFileName(HInstance, PChar(sModule), Length(sModule));
     //去除路径
     while Pos('\',sModule)>0 do begin
          Delete(sModule,1,Pos('\',sModule));
     end;
     //去除.dll
     if Pos('.',sModule)>0 then begin
          sModule     := Copy(sModule,1,Pos('.',sModule)-1);
     end;

     //
     Result := PChar(sModule);
end;



function StrSubCount(const Source, Sub: string): integer;
var
     Buf : string;
     i : integer;
     Len : integer;
begin
     Result := 0;
     Buf:=Source;
     i := Pos(Sub, Buf);
     Len := Length(Sub);
     while i <> 0 do begin
          Inc(Result);
          Delete(Buf, 1, i + Len -1);
          i:=Pos(Sub,Buf);
     end;
end;

function  dwISO8859ToChinese(AInput:String):string;
var
     iSource   : Integer;
     iDecode   : Integer;
     sDecode   : String;
begin
     sDecode   := TEncoding.GetEncoding(936).GetString(TEncoding.GetEncoding('iso-8859-1').GetBytes(AInput));
     //
     iSource   := StrSubCount(AInput,'?');
     iDecode   := StrSubCount(sDecode,'?');
     //
     if iSource<iDecode then begin
          Result    := AInput;
     end else begin
          Result    := sDecode;
     end;
end;


//处理ZXing扫描
function dwSetZXing000(ACtrl:TControl;ACameraID:Integer):Integer;
var
    sJS     : string;
const
    _JS     : string = ''
            +#13'let selectedDeviceId=%d;'
            +#13'const codeReader = new ZXing.BrowserMultiFormatReader();'
            +#13'codeReader.reset();'
            +#13'codeReader.decodeFromVideoDevice(selectedDeviceId, ''%s'', (result, err) => {'
            +#13'	 if (result) {'
            //+#13'		alert(result);'
            //+#13'		alert(decodeURI((result)));'
            +#13'        codeReader.reset();'
            +#13'		 axios.post(''/deweb/post'',''{"m":"event","i":%d,"c":"%s","name":"%s","v":"''+(escape(result))+''"}'')'
            +#13'		 .then(resp =>{this.procResp(resp.data);});'
            +#13'	 }'
            +#13'})'
            ;
begin
     sJS  := Format(_JS,[ACameraID,ACtrl.Name,TForm(ACtrl.Owner).Handle,ACtrl.Name,'onenddock']);
     //
     TForm(ACtrl.Owner).HelpFile   := TForm(ACtrl.Owner).HelpFile + sJS;

     //
     Result    := 0;
end;

//处理ZXing扫描
function dwSetZXing(ACtrl:TControl;ACameraID:Integer):Integer;
var
    sJS     : string;
const
    _JS     : string = ''
            +#13'let selectedDeviceId=%d;'
            //+#13'shape__crd = new ZXing.BrowserMultiFormatReader();'
            +#13'this.%s__crd.reset();'
            +#13'this.%s__crd.decodeFromVideoDevice(selectedDeviceId, ''%s'', (result, err) => {'
            +#13'	 if (result) {'
            //+#13'		alert(result);'
            //+#13'		alert(decodeURI((result)));'
            //+#13'        shape__crd.reset();'
            +#13'		 axios.post(''/deweb/post'',''{"m":"event","i":%d,"c":"%s","name":"%s","v":"''+(escape(result))+''"}'')'
            +#13'		 .then(resp =>{this.procResp(resp.data);});'
            +#13'	 }'
            +#13'})'
            ;
begin
     //sJS  := Format(_JS,[ACameraID,dwFullName(Actrl),dwFullName(Actrl),ACtrl.Name,TForm(ACtrl.Owner).Handle,ACtrl.Name,'onenddock']);
     sJS    := Format(_JS,[
                ACameraID,
                dwFullName(Actrl),
                dwFullName(Actrl),
                dwFullName(ACtrl),
                TForm(ACtrl.Owner).Handle,
                dwFullName(Actrl),
                'onenddock'
                ]);
     //
     TForm(ACtrl.Owner).HelpFile   := TForm(ACtrl.Owner).HelpFile + sJS;

     //
     Result    := 0;
end;


//处理ZXing扫描
function dwStopZXing(ACtrl:TControl;ACameraID:Integer):Integer;
var
    sJS     : string;
begin
     sJS    := 'this.'+dwFullName(Actrl)+'__crd.reset();';
     //
     TForm(ACtrl.Owner).HelpFile   := TForm(ACtrl.Owner).HelpFile + sJS;

     //
     Result    := 0;
end;


function dwOpenUrl(AForm:TForm;AUrl,Params:String):Integer;
var
     sCode     : string;
begin
     sCode     := 'this.ToWebsite("'+AUrl+'","'+Params+'");';
     //
     AForm.HelpFile := AForm.HelpFile + sCode;
     //
     Result    := 0;
end;

//Cookie操作
function  dwSetCookie(AForm:TForm;AName,AValue:String;AExpireHours:Integer):Integer;
var
     sCode     : string;
     sHint     : String;
     joHint    : variant;
begin
     sCode     := 'this.dwsetcookie("'+AName+'","'+AValue+'",'+IntToStr(AExpireHours)+');';

     //
     AForm.HelpFile := AForm.HelpFile + sCode;

     //写到本地
     sHint     := AForm.Hint;
     joHint    := _json('{}');
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
     end;
     //
     if not joHint.Exists('_cookies') then begin
          joHint._cookies   := _json('{}');
     end;
     joHint._cookies.Add(AName,AValue);
     AForm.Hint     := joHint;


     //
     Result    := 0;
end;

function  dwSetCookiePro(AForm:TForm;AName,AValue,APath,ADomain:String;AExpireHours:Integer):Integer;
var
     sCode     : string;
     sHint     : String;
     joHint    : variant;
begin
     sCode     := 'this.dwsetcookiepro("'+AName+'","'+AValue+'",'+IntToStr(AExpireHours)+',"'+APath+'","'+ADomain+'");';

     //
     AForm.HelpFile := AForm.HelpFile + sCode;

     //写到本地
     sHint     := AForm.Hint;
     joHint    := _json('{}');
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
     end;
     //
     if not joHint.Exists('_cookies') then begin
          joHint._cookies   := _json('{}');
     end;
     joHint._cookies.Add(AName,AValue);
     AForm.Hint     := joHint;


     //
     Result    := 0;
end;


function dwUnicodeToChinese(inputstr: string): string;   //将类似“%u4E2D”转成中文
var
     index: Integer;
     temp, top, last: string;
begin
     index := 1;
     while index >= 0 do begin
          index := Pos('%u', inputstr) - 1;
          if index < 0 then begin
               last := inputstr;
               Result := Result + last;
               Exit;
          end;
          top := Copy(inputstr, 1, index); // 取出 编码字符前的 非 unic 编码的字符，如数字
          temp := Copy(inputstr, index + 1, 6); // 取出编码，包括 \u,如\u4e3f
          Delete(temp, 1, 2);
          Delete(inputstr, 1, index + 6);
          Result := Result + top + WideChar(StrToInt('$' + temp));
     end;
end;

function  dwGetCookie(AForm:TForm;AName:String):String;                             //读cookie
var
    sHint     : String;
    joHint    : Variant;
begin
    //
    sHint     := AForm.Hint;
    joHint    := _json('{}');
    if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
    end;
    //
    Result    := '';
    if joHint.Exists('_cookies') then begin
        if joHint._cookies.Exists(AName) then begin
            Result    := dwUnicodeToChinese(HttpDecode(joHint._cookies._(AName)));
        end;
    end;
end;

procedure dwRealignPanel(APanel:TPanel;AHorz:Boolean);
var
    iCtrl   : Integer;
    I       : Integer;
    oCtrl   : TControl;
    oCtrl0  : TControl;
begin
    //
    if APanel.ControlCount<=1 then begin
        Exit;
    end;
    //
    if AHorz then begin
        for I := 0 to APanel.ControlCount-1 do begin
            APanel.Controls[I].AlignWithMargins := True;
            APanel.Controls[I].Width    :=  APanel.Controls[0].Width;
            //
            APanel.Controls[I].Margins.Left     := ((APanel.Width div APanel.ControlCount) - APanel.Controls[0].Width) div 2;
            APanel.Controls[I].Margins.Right    := APanel.Controls[I].Margins.Left;
        end;

        //
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



function dwPHPToDate(ADate:Integer):TDateTime;
var
     f1970     : TDateTime;
begin
     //PHP时间是格林威治时间1970-1-1 00:00:00到当前流逝的秒数
     f1970     := EncodeDateTime(1970, 1, 1, 8, 0, 0, 0);//StrToDateTime('1970-01-01 00:00:00');
     Result    := IncSecond(f1970,ADate);
     //Result    := ((ADate+28800)/86400+25569);
end;

function dwDateToPHPDate(ADate:TDateTime):Integer;
var
     f1970     : TDateTime;
begin
     //PHP时间是格林威治时间1970-1-1 08:00:00到当前流逝的秒数
     f1970     := EncodeDateTime(1970, 1, 1, 8, 0, 0, 0);//StrToDateTime('1970-01-01 00:00:00');
     //
     Result    := Round((ADate - f1970)*24*3600);
     //Result    := ((ADate+28800)/86400+25569);
end;

function dwSetHeight(AControl:TControl;AHeight:Integer):Integer;
var
     sHint     : String;
     joHint    : Variant;
begin
     sHint     := AControl.Hint;
     joHint    := _json('{}');
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
     end;
     joHint.height  := AHeight;
     AControl.Hint  := joHint;

     //
     Result    := 0;
end;


procedure dwShowMessage(AMsg:String;AForm:TForm);
begin
    AMsg    := StringReplace(AMsg,'''','\''',[rfReplaceAll]);
    dwShowMsg((AMsg),AForm.Caption,'OK',AForm);
end;

procedure dwShowMessagePro(AMsg,AJS:String;AForm:TForm);
var
     sMsgCode  : string;
begin
    //处理sMsg
    AMsg := StringReplace(AMsg,#13,'\r\n',[rfReplaceAll]);
    AMsg := StringReplace(AMsg,#10,'',[rfReplaceAll]);

    //
    sMsgCode    := 'this.$alert(''%s'', ''%s'', { confirmButtonText: ''%s''})';
    sMsgCode    := Format(sMsgCode,[AMsg,AForm.Caption,'OK']);
    sMsgCode    := sMsgCode
           +'.then(resp =>{'
           +AJS
           //+'document.body.innerHTML="dwclear";'
           +'});';
    AForm.HelpFile := AForm.HelpFile + sMsgCode;

end;

procedure dwShowMsg(AMsg,ACaption,AButtonCaption:String;AForm:TForm);
var
     sMsgCode  : string;
begin
     //处理sMsg
     AMsg := StringReplace(AMsg,#13,'\r\n',[rfReplaceAll]);
     AMsg := StringReplace(AMsg,#10,'',[rfReplaceAll]);

     //
     sMsgCode  := 'this.$alert(''%s'', ''%s'', {dangerouslyUseHTMLString:true, confirmButtonText: ''%s''});';
     sMsgCode  := Format(sMsgCode,[AMsg,ACaption,AButtonCaption]);
     AForm.HelpFile := AForm.HelpFile + sMsgCode;
end;


//MessageDlg
procedure dwMessageDlg(AMsg,ACaption,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);
var
     sMsgCode  : string;
const
     sConfirm  = 'axios.post(''/deweb/post'',''{"m":"interaction","i":%d,"t":"%s","v":%d}'')'
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




function dwGetProp(ACtrl:TControl;AAttr:String):String;
var
     sHint     : String;
     joHint    : Variant;
begin
    //
    sHint     := ACtrl.Hint;

    //创建HINT对象, 用于生成一些额外属性
    joHint    := _json('{}');

    if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
    end;

    //
    if joHint.Exists(AAttr) then begin
        Result    := joHint._(AAttr);
    end else begin
        Result  := '';
    end;
end;

function dwSetProp(ACtrl:TControl;AAttr,AValue:String):Integer;
var
    sHint     : String;
    joHint    : Variant;
begin
    Result    := 0;
    //
    sHint     := ACtrl.Hint;

    //创建HINT对象, 用于生成一些额外属性
    if dwStrIsJson(sHint) then begin
        joHint  := _json(sHint);
    end else begin
        joHint  := _json('{}');
    end;

    //如果当前存在该属性, 则先删除
    if joHint.Exists(AAttr) then begin
        joHint.Delete(AAttr);
    end;

    //添加属性
    joHint.Add(AAttr,AValue);

    //返回到HINT字符串
    ACtrl.Hint     := joHint;

end;


function dwEscape(const StrToEscape:string):String;
var
   i:Integer;

   w:Word;
begin
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
    i0,i1     : Integer;
begin
    Result := '';
    try
        while Length(S) > 0 do begin
            if S[1]<>'%' then begin
                Result    := Result + S[1];
                Delete(S,1,1);
            end else begin
                Delete(S,1,1);
                if (S[1]='u') then begin
                    if (length(s)>=5) then begin
                        i0      := StrToIntDef('$'+Copy(S, 2, 2),32);
                        i1      := StrToIntDef('$'+Copy(S, 4, 2),32);
                        Result  := Result + WideChar((i0 shl 8) or i1);
                        Delete(S,1,5);
                    end;
                end else begin
                    if (length(s)>=2) then begin
                        Result    := Result + Chr(StrToIntDef('$'+Copy(S, 1, 2),32));
                    end;
                    Delete(S,1,2);
                end;
            end;
        end;
    except
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

function dwHtmlEscape(AText:String):String;
begin
    Result  := AText;
    //
    Result  := StringReplace(Result,'&','&amp;',[rfReplaceAll]);
    Result  := StringReplace(Result,'"','&quot;',[rfReplaceAll]);
    Result  := StringReplace(Result,'<','&lt;',[rfReplaceAll]);
    Result  := StringReplace(Result,'>','&gt;',[rfReplaceAll]);
    Result  := StringReplace(Result,' ','&nbsp;',[rfReplaceAll]);
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
          slTmp.Destroy;
     end;
end;

function dwSetMenuDefault(AMenu:TMainMenu;ADefault:String):Integer;
var
    oItem0  : TMenuItem;
    sHint   : string;
    joHint  : Variant;
begin
     if AMenu.Items.Count>0 then begin
        //
        oItem0    := AMenu.Items[0];

        //取得HINT对象JSON
        sHint     := '{}';
        if AMenu.Items.Count>0 then begin
            sHint     := AMenu.Items[0].Hint;
        end;
        if dwStrIsJson(sHint) then begin
            joHint  := _Json(sHint);
        end else begin
            joHint  := _json('{}');
        end;

        //
        joHint.activeindex  := ADefault;
        //
        oItem0.Hint    := joHint;
        //
        Result    := 0;
    end else begin
        Result    := -1;
    end;
end;


function dwSetCompLTWH(AComponent:TComponent;ALeft,ATop,AWidth,AHeight:Integer):Integer;
begin
     AComponent.DesignInfo    := ALeft  * 10000 + ATop;
     AComponent.Tag           := AWidth * 10000 + AHeight;
     //
     Result    := 0;
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

function dwAlignByColCount(AParent:TPanel;AColCount:Integer):Integer;
var
    iItem   : Integer;
    iWidth  : Integer;
    iRCount : Integer;
    iHeight : Integer;
    iRow    : Integer;
    iCol    : Integer;
    iLeft   : Integer;
    iTop    : Integer;

    iMLeft      : Integer;
    iMTop       : Integer;
    iMRight     : Integer;
    iMBottom    : Integer;
begin
    //<异常检测
    //如果子控件为0，则退出
    if AParent.ControlCount = 0 then begin
        Exit;
    end;
    //>

    //控制行数
    if AColCount<1 then begin
        AColCount   := 1;
    end;

    //取得总行数
    iRCount  := AParent.ControlCount;
    iRCount  := Ceil(iRCount / AColCount);

    //
    iMLeft      := AParent.Controls[0].Margins.Left;
    iMTop       := AParent.Controls[0].Margins.Top;
    iMRight     := AParent.Controls[0].Margins.Right;
    iMBottom    := AParent.Controls[0].Margins.Bottom;

    //取得每个控件的宽度(此处要求每个子控件的Margins.Left和right相同)
    iWidth  := (AParent.Width  - AParent.Controls[0].Margins.Right) div AColCount;

    //取得每个控件的高度(含上下margins)
    iHeight :=  AParent.Controls[0].Margins.Top + AParent.Controls[0].Height + AParent.Controls[0].Margins.Bottom;
    //iHeight := iHeight - AParent.Controls[0].Margins.Top - AParent.Controls[0].Margins.Bottom

    //对子控件进行处理
    for iItem := 0 to AParent.ControlCount-1 do begin
        with TPanel(AParent.Controls[iItem]) do begin
            //得出行和列
            iRow    := TabOrder div AColCount;
            iCol    := TabOrder mod AColCount;
            //设置LTWH
            Align   := alNone;
            Left    := iCol * iWidth + iMLeft;
            Width   := iWidth - iMLeft - iMRight;
            Top     := iRow * iHeight + iMTop;
            Height  := iHeight - iMTop - iMBottom;
        end;
    end;
end;




end.


