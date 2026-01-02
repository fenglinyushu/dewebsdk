unit dwBase;
(*
功能说明 ： deweb的基础功能函数

更新说明；
------------------------------------------------------------------------------------------------------------------------
#### 2025-09-13
1. 增加了dwGetForm1, 可以通过当前Form取Form1
    function dwGetForm1(AForm:TForm):TForm;

#### 2025-09-04
1. 消除了dwDeleteControl因为TCardPanel__page造成的bug

#### 2025-08-28
1. 增加了dwIsMobile函数, 可以在Form1的OnShow事件中通过dwIsMobile(Self)判断是否为移动端

#### 2025-08-08
1. 开始撰写更新说明
2. 增加了dwReload函数，以重载当前页面, 使用方法: dwReload(Self);

*)
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

    //FireDac
    FireDAC.Comp.Client,


    //系统单元
    System.Rtti,        //RTTI单元
    Buttons,
    AnsiStrings,
    RegularExpressions,     //正则表达式
    Vcl.WinXPanels,         //TCardPanel/TCard
    System.TypInfo, System.NetEncoding,

    HTTPApp, Dialogs, ComCtrls,Math,DateUtils,Variants,
    Windows, Messages, SysUtils, Classes, Controls, Forms,Graphics,
    StdCtrls, ExtCtrls, StrUtils, Grids,Types,
    IniFiles,   Menus,  ShellAPI, FileCtrl ;

const
  FILE_CREATE_TIME = 0;  //创建时间
  FILE_MODIFY_TIME = 1;  //修改时间
  FILE_ACCESS_TIME = 3;  //访问时间

//-----公共模块控制函数-------------------------------------------------------------------------------------------------
///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取得公共模块Form。</summary>
/// <param name="AForm">需要获取的公共模块的名称。</param>
/// <remarks>函数补充信息:
/// <returns>返回公共模块TForm</returns>
/// <para>调用例子：</para>
/// <code>dwGetPublic('sFormName');</code>
/// </remarks>
function  dwGetPublic(AForm:String):TForm;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取得公共模块中的控件。</summary>
/// <param name="AForm">需要从中获取控件的公共模块名称。</param>
/// <param name="AComponent">需要获取的控件名称。</param>
/// <remarks>函数补充信息:
/// <returns>返回公共模块中的控件</returns>
/// <para>调用例子：</para>
/// <code>dwGetPublicComponent('sFormName','sComponent');</code>
/// </remarks>
function  dwGetPublicComponent(AForm,AComponent:String):TComponent;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取得公共模块中的公共变量。</summary>
/// <param name="AForm">需要从中获取变量的公共模块名称。</param>
/// <param name="AVarName">需要获取的公共变量名称。</param>
/// <remarks>函数补充信息:
/// <returns>返回公共模块中的变量</returns>
/// <para>调用例子：</para>
/// <code>dwGetPublicVar('sFormName','sVar');</code>
/// </remarks>
function  dwGetPublicVar(AForm,AVarName:String):TValue;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置公共模块中的公共变量。</summary>
/// <param name="AForm">需要设置公共变量的公共模块名称。</param>
/// <param name="AVarName">需要设置的公共变量名称。</param>
/// <param name="AValue">需要设置的变量值。</param>
/// <remarks>函数补充信息:
/// <returns>成功返回0，失败返回非0值</returns>
/// <para>调用例子：</para>
/// <code>dwSetPublicVar('sFormName','sVar','555');</code>
/// </remarks>
function  dwSetPublicVar(AForm,AVarName:String;AValue:TValue):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>Bool型转字符串：true/false。</summary>
/// <param name="AVal">需要转换的Boolean值。</param>
/// <remarks>函数补充信息:
/// <returns>返回'true'/'false'</returns>
/// <para>调用例子：</para>
/// <code>dwBoolToStr(isBool);</code>
/// </remarks>
function  dwBoolToStr(AVal:Boolean):string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>转换空格为Html格式'&ensp;'。</summary>
/// <param name="AStr">需要转换的字符串。</param>
/// <remarks>函数补充信息:
/// <returns>返回Html字符串</returns>
/// <para>调用例子：</para>
/// <code>dwConvertStr('<td>this is a apple.</td>');</code>
/// </remarks>
function  dwConvertStr(AStr:String):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>
/// Escape编码,用于在 URL（统一资源定位符）中或者在某些文本传输场景下，将一些特殊字符转换为特定的编码格式，
///以便能够正确地传输和处理。例如，空格会被编码为%20，“&” 会被编码为%26等。</summary>
/// <param name="S">需要做Escape解码的字符串</param>
/// <returns>返回编码后的字符串</returns>
/// <remarks>函数补充信息:
/// <seealso>dwUnEscape</seealso>
/// <para>调用例子：</para>
/// <code>dwEscape(s);</code>
/// </remarks>
function  dwEscape(const StrToEscape:string):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取字符串前ALen位，超出部分用3个点代替,如'123...'。</summary>
/// <param name="S">需要做Escape解码的字符串</param>
/// <returns>如果字符串长度小表ALen,返回原串;否则返回字符串前ALen位加3个点</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwGetText('12345678',3);</code>
/// </remarks>
function  dwGetText(AText:string;ALen:integer):string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>处理长字符，如TstringList.Text这种字符串。</summary>
/// <param name="AText">需要处理的长字符串</param>
/// <returns>返回处理后的字符串，在每行尾加#13#10</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwLongStr(aStringList.text);</code>
/// </remarks>
function  dwLongStr(AText:String):String;


///----------------------------------------------------------------------------------------------------------------------------
/// <summary>对HTML敏感的字符(如& > < 空格 引号等）进行转义。</summary>
/// <param name="AText">需要对HTML敏感的字符进行转义的字符串</param>
/// <returns>返回对HTML敏感字符转义后的字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwHtmlEscape(sString);</code>
/// </remarks>
function dwHtmlEscape(AText:String):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将PHP中的日期转换为Delphi的日期。</summary>
/// <param name="ADate">PHP中的日期</param>
/// <returns>返回Delphi用的日期</returns>
/// <remarks>函数补充信息:
/// <seealso>dwDateToPHPDate</seealso>
/// <para>调用例子：</para>
/// <code>dwPHPToDate(ADate);</code>
/// </remarks>
function  dwPHPToDate(ADate:Integer):TDateTime;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将Delphi中的日期转换为PHP的日期。</summary>
/// <param name="ADate">Delphi中的日期</param>
/// <returns>返回PHP用的日期</returns>
/// <remarks>函数补充信息:
/// <seealso>dwPHPToDate</seealso>
/// <para>调用例子：</para>
/// <code>dwDateToPHPDate(ADate);</code>
/// </remarks>
function  dwDateToPHPDate(ADate:TDateTime):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>处理Caption中的特殊字符(将引号进行转义,#13#10转为\n)。</summary>
/// <param name="AStr">需要处理的Caption</param>
/// <returns>返回可用于Caption的字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwProcessCaption(sString);</code>
/// </remarks>
function  dwProcessCaption(AStr:String):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>重排ACtrl(TWinControl控件)中的子控件。</summary>
/// <param name="ACtrl">需要进行对子控件进行重排的控件</param>
/// <param name="AHorz">如果水平(AHorz=True), 则取所有控件等宽水平放置;如果垂直, 则所有控件Align=alTop</param>
/// <param name="ASize">如果ASize>0、垂直排列时子控件的高度为ASize</param>
/// <remarks>函数补充信息:
/// <seealso>dwRealignPanel</seealso>
/// <para>调用例子：</para>
/// <code>dwRealignChildren(aPanel,false,18);</code>
/// </remarks>
procedure dwRealignChildren(ACtrl:TWinControl;AHorz:Boolean;ASize:Integer);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>重排APanel(TPanel)中的子控件。</summary>
/// <param name="APanel">需要进行对子控件进行重排的TPanel控件</param>
/// <param name="AHorz">水平(AHorz=True)或垂直(AHorz=false)排列。</param>
/// <remarks>函数补充信息:
/// <seealso>dwRealignChildren</seealso>
/// <para>调用例子：</para>
/// <code>dwRealignPanel(aPanel,false,18);</code>
/// </remarks>
procedure dwRealignPanel(APanel:TPanel;AHorz:Boolean);


///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置控件AComponent的Left、Top、Width、Height。</summary>
/// <param name="AComponent">需要设置LTWH的AComponent控件</param>
/// <param name="ALeft">控件新的左边位置</param>
/// <param name="ATop">控件新的顶边位置</param>
/// <param name="AWidth">控件新的宽度</param>
/// <param name="AHeight">控件新的高度</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetCompLTWH(aPanel,5,7,20,20);</code>
/// </remarks>
function  dwSetCompLTWH(AComponent:TComponent;ALeft,ATop,AWidth,AHeight:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置窗体高度，以解决当窗体高度大于屏幕分辨率高度时，无法设置当前窗体高度的问题。</summary>
/// <param name="AControl">需要设置高度的控件</param>
/// <param name="AHeight">控件新的高度</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetHeight(aPanel,20);</code>
/// </remarks>
function  dwSetHeight(AControl:TControl;AHeight:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置默认选中的菜单项。</summary>
/// <param name="AMenu">需要设置默认选中项的菜单</param>
/// <param name="ADefault">选中菜单项，格式如：'1-0-2'，序号从0开始，每层之间用-隔开</param>
/// <returns>成功返回0，否则返回非0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetMenuDefault(MainMenu,'1-0-2');</code>
/// </remarks>
function dwSetMenuDefault(AMenu:TMainMenu;ADefault:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>代替ShowMessage。</summary>
/// <param name="AMsg">消息内容。注意:需要提前把AMsg的字符串的HTML特殊字符替换掉，如：\替换为\\等</param>
/// <param name="AForm">当前窗体，一般可以使用self。</param>
/// <remarks>函数补充信息:
/// <seealso>dwShowMessagePro,dwProcessCaption</seealso>
/// <para>调用例子：</para>
/// <code>dwShowMessage('Welecome to DeWeb!',Self);</code>
/// </remarks>
procedure dwShowMessage(AMsg:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>代替ShowMessage增强版。</summary>
/// <param name="AMsg">消息内容。注意:需要提前把AMsg的字符串的HTML特殊字符替换掉，如：\替换为\\等</param>
/// <param name="AJS">消息框关闭后执行的javaScript程序。</param>
/// <param name="AForm">当前窗体，一般可以使用self。</param>
/// <remarks>函数补充信息:
/// <seealso>dwShowMessage,dwProcessCaption</seealso>
/// <para>调用例子：</para>
/// <code>dwShowMessagePro('Welecome to DeWeb!','',Self);</code>
/// </remarks>
procedure dwShowMessagePro(AMsg,AJS:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>定制版ShowMessage, 可以定制标题， 按钮名称等。</summary>
/// <param name="AMsg">消息内容。注意:需要提前把AMsg的字符串的HTML特殊字符替换掉，如：\替换为\\等</param>
/// <param name="ACaption">消息框标题。</param>
/// <param name="AButtonCaption">按钮标题。</param>
/// <param name="AForm">当前窗体，一般可以使用self。</param>
/// <remarks>函数补充信息:
/// <seealso>dwShowMessage,dwProcessCaption</seealso>
/// <para>调用例子：</para>
/// <code>dwShowMsg('Welecome to DeWeb!','消息','关闭',Self);</code>
/// </remarks>
procedure dwShowMsg(AMsg,ACaption,AButtonCaption:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>
/// <para>用于弹出一个自定义消息对话框，允许用户通过确认按钮和取消按钮来进行交互操作，并且可以自定义对话框显示的</para>
/// <para>消息内容、标题以及确认按钮和取消按钮的标题文本，同时记录调用此过程的方法名称，方便后续追踪相关操作来源。</para>
/// <para>调用完成后，自动调用AForm表单的StartDock事件，具体情况见调用例子。</para>
/// </summary>
/// <param name="AMsg">代表要在消息对话框中显示的主要消息内容。</param>
/// <param name="ACaption">用于设置消息对话框的标题栏显示文本。</param>
/// <param name="confirmButtonCaption">指定消息对话框中确认按钮上显示的文本。</param>
/// <param name="cancelButtonCaption">设定消息对话框中取消按钮上显示的文本。</param>
/// <param name="AMethedName">传入调用此过程的方法名称，便于在程序运行过程中进行相关操作记录、调试或者追踪操作发起源头。</param>
/// <param name="AForm">指定消息对话框要依附显示的表单对象，确定对话框在应用程序界面中的显示位置及所属父容器等情况。</param>
/// <remarks>
/// <code>调用例子：
/// dwMessageDlg('确定要将当前 '+Edit_Name.Text+' 信息作为新信息添中到数据库中吗?','DWMS','OK','Cancel','query_add',self);
/// sMethod := dwGetProp(Self,'interactionmethod');
/// sValue  := dwGetProp(Self,'interactionvalue');
/// if sMethod = 'query_save' then begin
///   if sValue = '1' then begin ... end;
/// end else if sMethod = 'query_add' then begin
/// end else if sMethod = 'query_delete' then begin
/// end;
/// </code>
/// </remarks>
procedure dwMessageDlg(AMsg,ACaption,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>Escape解码,经过编码的字符串还原为原始的字符串内容。</summary>
/// <param name="S">需要做Escape解码的字符串</param>
/// <returns>返回解码后的字符串</returns>
/// <remarks>函数补充信息:
/// <seealso>dwEscape</seealso>
/// <para>调用例子：</para>
/// <code>dwUnescape(s);</code>
/// </remarks>
function  dwUnescape(S: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将Unicode字符串(类似“%u4E2D”)转成中文。</summary>
/// <param name="inputstr">需要转换为中文的字符串</param>
/// <returns>返回中文字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwUnicodeToChinese(s);</code>
/// </remarks>
function  dwUnicodeToChinese(inputstr: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将ISO8859字符串(类似“à、è、ï”)转成中文。</summary>
/// <param name="AInput">需要转换为中文的字符串</param>
/// <returns>返回中文字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwISO8859ToChinese(s);</code>
/// </remarks>
function  dwISO8859ToChinese(AInput:String):string;

//Cookie操作
///----------------------------------------------------------------------------------------------------------------------------
/// <summary>删除一个Cookie信息。</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <param name="AName">要删除的Cookie的名称。</param>
/// <returns>固定返回0/returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwDeleteCookie(AForm1,'dwrExpand');</code>
/// </remarks>
function  dwDeleteCookie(AForm:TForm;AName:String):Integer;
function  dwDeleteCookiePro(AForm:TForm;AName,ADomain:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置一个Cookie信息。</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <param name="AName">要设置的Cookie的名称，在同一个域下Cookie名称应具有唯一性，以便后续能准确识别和获取对应的Cookie。</param>
/// <param name="AValue">设置Cookie所对应的值，其格式和具体含义取决于业务应用中对该Cookie的使用需求。</param>
/// <param name="AExpireHours">以小时为单位来设定Cookie的过期时间，用于控制该Cookie在客户端浏览器上的有效时长，过期后浏览器会自动删除该Cookie。</param>
/// <returns>固定返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetCookie(AForm1,'dwrExpand',dwIIF(AExpand,'1','0'),24*30);</code>
/// </remarks>
function  dwSetCookie(AForm:TForm;AName,AValue:String;AExpireHours:Double):Integer;  //写cookie

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置一个Cookie信息（增强版）。</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <param name="AName">要设置的Cookie的名称，在同一个域下Cookie名称应具有唯一性，以便后续能准确识别和获取对应的Cookie。</param>
/// <param name="AValue">设置Cookie所对应的值，其格式和具体含义取决于业务应用中对该Cookie的使用需求。</param>
/// <param name="APath">Cookie在服务器端对应的有效路径，决定了哪些页面或资源可以访问该Cookie。</param>
/// <param name="ADomain">Cookie所属的域名，它定义了Cookie能够在哪些主机上被发送和接收，准确设置域名对于多域名应用、子域名共享Cookie等场景非常关键，
/// 同时也要遵循相关网络协议（如HTTP协议中关于域名格式和跨域限制等规定），确保Cookie能在期望的域名范围内正确传递和生效。</param>
/// <param name="AExpireHours">以小时为单位来设定Cookie的过期时间，用于控制该Cookie在客户端浏览器上的有效时长，过期后浏览器会自动删除该Cookie。</param>
/// <returns>固定返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetCookiePro(AForm1,'dwrExpand',dwIIF(AExpand,'1','0'),'/','dwFrame',24*30);</code>
/// </remarks>
function  dwSetCookiePro(AForm:TForm;AName,AValue,APath,ADomain:String;AExpireHours:Double):Integer;
//function  dwPreGetCookie(AForm:TForm;AName,ANull:String):Integer;                    //预读cookie
///----------------------------------------------------------------------------------------------------------------------------
/// <summary>读取一个Cookie信息。</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <param name="AName">要读取的Cookie的名称。</param>
/// <returns>返回AName所指定的Cookie值</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwGetCookie(AForm1,'dwrExpand');</code>
/// </remarks>
function  dwGetCookie(AForm:TForm;AName:String):String;                              //读cookie

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>弹出输入对话框等待输入，并返回输入值。</summary>
/// <para>调用完成后，自动调用AForm表单的StartDock事件，具体情况见示例。</para>
/// <param name="AMsg">要在输入对话框中显示的消息内容。</param>
/// <param name="ACaption">输入对话框。</param>
/// <param name="ADefault">输入框中的缺省值。</param>
/// <param name="confirmButtonCaption">指定输入对话框中确认按钮上显示的文本。</param>
/// <param name="cancelButtonCaption">设定输入对话框中取消按钮上显示的文本。</param>
/// <param name="AMethedName">传入调用此函数的方法名称，便于在程序运行过程中进行相关操作记录、调试或者追踪操作发起源头。</param>
/// <param name="AForm">要在其中显示输入对话框的表单对象。</param>
/// <returns>返回输入值</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwInputQuery('请输入新角色名称','增加角色','新角色','确定','取消','query_add',self);
/// sMethod := dwGetProp(Self,'interactionmethod');
/// sValue  := dwGetProp(Self,'interactionvalue');
/// if sMethod = 'query_save' then begin
///   if sValue = '1' then begin ... end;
/// end else if sMethod = 'query_add' then begin
/// end else if sMethod = 'query_delete' then begin
/// end;
/// </code>
/// </remarks>
procedure dwInputQuery(AMsg,ACaption,ADefault,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>打开新页面</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <param name="AUrl">新页面在服务器中的路径。</param>
/// <param name="Params">指定打开的窗口，如'_self'为在当前窗口打开新网页; '_blank'为在新窗口打开。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwOpenURL(self,'/dwRuoYi','_self');;</code>
/// </remarks>
function dwOpenUrl(AForm:TForm;AUrl,Params:String):Integer;

//从控件的hint中读写值
///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从给定的TControl控件的（Hint）中获取特定属性的值</summary>
/// <param name="ACtrl">代表要从中获取Hint中特定属性的控件对象，函数将从该控件的提示信息（Hint）中尝试提取属性。</param>
/// <param name="AAttr">指定要在Hint中查找的属性名称，用于明确获取哪个属性的值。</param>
/// <returns>该值为在控件Hint中查找到的对应属性值，不存在指定属性或者Hint不符合要求等情况，则返回空字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>sMethod := dwGetProp(Self,'interactionmethod');</code>
/// </remarks>
function dwGetProp(ACtrl:TControl;AAttr:String):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置的TControl控件的（Hint）中特定属性的值</summary>
/// <param name="ACtrl">代表需要设置Hint中特定属性值的控件对象。</param>
/// <param name="AAttr">指定要在Hint中查找的属性名称，用于明确设置哪个属性的值。</param>
/// <param name="AValue">新的属性值。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetProp(Self,'interactionmethod','insert');</code>
/// </remarks>
function dwSetProp(ACtrl:TControl;AAttr:String;AValue:Variant):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>计算MD5</summary>
/// <param name="AStr">获取字符串的MD5码。</param>
/// <returns>MD5码</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwGetMD5(sText);</code>
/// </remarks>
function dwGetMD5(AStr:String):string;

//处理ZXing扫描
///----------------------------------------------------------------------------------------------------------------------------
/// <summary>处理ZXing扫描,扫描二维码。
///当扫描识别完成后自动激活TShape对象的OnEndDock事件，并通过类似的代码取得识别的值：
///  dwISO8859ToChinese(dwUnEscape(dwGetProp(Shape1,'scanvalue')))
///  在此代码后，应该加上以下代码以用于二次扫描
///  Shape1.HelpKeyword := ''
/// </summary>
/// <param name="ACtrl">TShape对象。</param>
/// <param name="ACameraID">摄像头ID。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetZXing(Shape1,0);</code>
/// </remarks>
function dwSetZXing(ACtrl:TControl;ACameraID:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>中止ZXing扫描</summary>
/// <param name="ACtrl">TShape对象。</param>
/// <param name="ACameraID">摄像头ID。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwStopZXing(Shape1,0);</code>
/// </remarks>
function dwStopZXing(ACtrl:TControl;ACameraID:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取得当前DLL名称,不包含.dll</summary>
/// <returns>DLL名称</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>s:=dwGetDllName;</code>
/// </remarks>
function dwGetDllName: string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>执行一段JS代码，注意需要以分号结束。</summary>
/// <param name="AJS">需要执行JavaScript代码。</param>
/// <param name="AForm">需要在其中执行JavaScript代码的表单。</param>
/// <returns>返回值总是True。</returns>
function dwRunJS(AJS:String;AForm:TForm):Boolean;

//延迟执行代码, 采用setTimeout
function dwRunJSTimeout(AJS:String;AForm:TForm;const ATimeOut:Integer=10):Boolean;


///----------------------------------------------------------------------------------------------------------------------------
/// <summary>快速IIF,根据输入条件返回字符串。</summary>
/// <param name="ABool">判断条件。</param>
/// <param name="AYes">ABool为True时返回的值。</param>
/// <param name="ANo">ABool为False时返回的值。</param>
/// <returns>ABool为真返回AYes,否则返回ANo,类型为String。</returns>
function dwIIF(ABool:Boolean;AYes,ANo:string):string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>快速IIF,根据输入条件返回数值。</summary>
/// <param name="ABool">判断条件。</param>
/// <param name="AYes">ABool为True时返回的值。</param>
/// <param name="ANo">ABool为False时返回的值。</param>
/// <returns>ABool为真返回AYes,否则返回ANo,类型为Integer。</returns>
function dwIIFi(ABool:Boolean;AYes,ANo:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>计算TimeLine的高度(参考)。</summary>
/// <param name="APageControl">显示时间线的TPageControl控件。</param>
function dwGetTimeLineHeight(APageControl:TPageControl):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>转义可能出错的字符</summary>
/// <param name="AText">待处理字符串。</param>
/// <returns>返回经过转义的字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwChangeChar(s);</code>
/// </remarks>
function  dwChangeChar(AText:String):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>弹出窗体。</summary>
/// <param name="AForm">需要在其中显示窗体的窗体。</param>
/// <param name="ASWForm">需要弹出的窗体</param>
/// <returns>返回0</returns>
function  dwShowModalPro(AForm,ASWForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>弹出窗体,如果ASWForm是AForm中的子窗体，则弹出ASWForm。</summary>
/// <param name="AForm">包含子窗体的窗体。</param>
/// <param name="ASWForm">需要弹出的子窗体</param>
/// <returns>返回0</returns>
function  dwShowModal(AForm,ASWForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>关闭窗体,如果ASWForm是AForm中的子窗体，则关闭ASWForm。</summary>
/// <param name="AForm">包含子窗体的窗体。</param>
/// <param name="ASWForm">需要关闭的子窗体</param>
/// <returns>返回0</returns>
function  dwCloseForm(AForm,ASWForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>计算手机可用高度。</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <returns>返回手机可用高度</returns>
function  dwGetMobileAvailHeight(AForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>检查当前字符串是否JSON合法。</summary>
/// <param name="AText">待检查的字符串。</param>
/// <returns>如果是合法的JSON字符串则返回true;否则返回false</returns>
function dwStrIsJson(AText:String):Boolean;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置当前应用为移动应用，根据参数自动设置窗体Width,Height。
/// 一般建议为414/736(iPhone6/7/8 plus),如果有一项为0，则为当前屏幕大小（只设置宽度，不设置高度）
/// </summary>
/// <param name="AForm">待检查的字符串。</param>
/// <param name="ADefaultWidth">为电脑浏览时的默认宽度，一般建议为414(iPhone6/7/8 plus)。</param>
/// <param name="ADefaultHeight">为电脑浏览时的默认高度，一般建议为736(iPhone6/7/8 plus)。</param>
/// <returns>返回无意义</returns>
function dwSetMobileMode(AForm:TForm;const ADefaultWidth : Integer = 400; const ADefaultHeight:Integer=900):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置当前应用为桌面应用，根据参数自动设置窗体Width,Height。</summary>
/// <param name="AForm">与当前操作相关联的表单对象。</param>
/// <returns>返回不确定</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwSetPCMode(self);</code>
/// </remarks>
function dwSetPCMode(AForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>AES解密。</summary>
/// <param name="StrHex">待解密的字符串。</param>
/// <param name="Key">密码。</param>
/// <returns>返回解密后的字符串</returns>
function dwAESDecrypt(StrHex, Key: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>AES加密。</summary>
/// <param name="StrHex">待加密的字符串。</param>
/// <param name="Key">密码。</param>
/// <returns>返回加密后的字符串</returns>
function dwAESEncrypt(Value, Key: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>注册机所用的解密函数。</summary>
/// <param name="StrHex">待解密的字符串。</param>
/// <param name="Key">密码。</param>
/// <returns>返回解密后的字符串</returns>
function dwRegAESDecrypt(StrHex, Key: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>注册机所用的加密函数。</summary>
/// <param name="StrHex">待加密的字符串。</param>
/// <param name="Key">密码。</param>
/// <returns>返回加密后的字符串</returns>
function dwRegAESEncrypt(Value, Key: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取URL参数相关属性值，例如:http://127.0.0.1/GetActivityinformation?language=Chinese&name=westwind。</summary>
/// <param name="QueryStr">URL字符串。</param>
/// <param name="Param_Name">参数名。</param>
/// <returns>返回属性值</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>
///    sLang := dwGetParamValue(dwGetProp(Self,'params'),'language'); //获取语言
///    sName := dwGetParamValue(dwGetProp(Self,'params'),'name');    //获取name
/// </code>
/// </remarks>
function dwGetParamValue(QueryStr,Param_Name : string) : string;   //正则表达，获取URL中参数

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>显示自动消失的消息框。</summary>
/// <param name="AMessage">消息内容。</param>
/// <param name="AType">消息类型:info/success/warning/error。</param>
/// <param name="AForm">需要在其中显示消息的表单。</param>
procedure dwMessage(AMessage,AType:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>显示消息框。</summary>
/// <param name="AMessage">消息内容。</param>
/// <param name="AForm">需要在其中显示消息的表单。</param>
procedure dwMessagePro(AMessage:String;AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>根据owner是否为TForm1, 来增加前缀，主要用于区分多个Form中的同名控件。</summary>
/// <param name="ACtrl">需要获取前缀的控件。</param>
function  dwPrefix(ACtrl:TComponent):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取得全部名称，包括前缀。</summary>
/// <param name="ACtrl">需要获取全名的控件。</param>
function  dwFullName(ACtrl:TComponent):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>StringGrid按列排序。</summary>
/// <param name="Grid">需要排序的TStringGrid。</param>
/// <param name="ACol">排序的列。</param>
/// <param name="Order">是否升序排列,True为升，false为降。</param>
/// <param name="AIsNum">True按数值排,false按字符串排。</param>
procedure dwGridQuickSort(Grid: TStringGrid; ACol: Integer; Order: Boolean ; AIsNum: Boolean);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>StringGrid按列筛选。</summary>
/// <param name="Grid">需要进行筛选的TStringGrid。</param>
/// <param name="ACol">筛选列。</param>
/// <param name="AFilter">筛选器，类似 "filter":["襄阳","沈阳"]</param>
procedure dwGridQuickFilter(Grid:TStringGrid;ACol:Integer;AFilter:String);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将StringGrid的单元格数组转为JSON对象保存到Grid的Hint中，
/// 对象中包含__cells二维数组，如'{__cells[[id,'name'],[5,'ff'],...]}'。</summary>
/// <param name="Grid">需要保存数据的TStringGrid。</param>
/// <param name="AForce">为True时，不管在Hint中是否存在__cells数组，都要重新保存；为false时，在不存在__cells时保存。</param>
procedure dwGridSaveCells(Grid:TStringGrid;AForce:Boolean);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将Grid的Hint的JSON对象中__cells数组的数据恢复到StringGrid中。
/// Hint格式如'{__cells[[id,'name'],[5,'ff'],...]}'。</summary>
/// <param name="Grid">需要恢复数据的TStringGrid。</param>
procedure dwGridRestoreCells(Grid:TStringGrid);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>获取Memo的在网页上的高度。</summary>
/// <param name="AMemo">需要获取高度的Memo。</param>
function  dwGetHtmlMemoHeight(AMemo:TMemo):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>上传一个文件到服务器，上传完成后，自动触发窗体的OnEndDock事件。</summary>
/// <param name="AForm">与当前操作相关联的表单对象，一般用self。</param>
/// <param name="AAccept">文件上传类型控制，类似"image/gif, image/jpeg"。</param>
/// <param name="ADestDir">上传目录，为空时上传到服务器upload目录，有值时上传到指定目录，支持子目录。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwUpload(self,'*.*','mydir');
///  dwGetProp(TForm(self.Owner),'__upload')取上传后的文件名
///  dwGetProp(TForm(self.Owner),'__uploadsource')取源文件名
/// </code>
/// </remarks>
function  dwUpload(AForm:TForm;AAccept,ADestDir:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>上传多个文件到服务器，上传完成后，自动触发窗体的OnEndDock事件。</summary>
/// <param name="AForm">与当前操作相关联的表单对象，一般用self。</param>
/// <param name="AAccept">文件上传类型控制，类似"image/gif, image/jpeg"。</param>
/// <param name="ADestDir">上传目录，为空时上传到服务器upload目录，有值时上传到指定目录，支持子目录。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwUploadMultiple(self,'*.*','mydir');
///  dwGetProp(TForm(self.Owner),'__upload')取上传后的文件名
///  dwGetProp(TForm(self.Owner),'__uploadsource')取源文件名
/// </code>
/// </remarks>
function  dwUploadMultiple(AForm:TForm;AAccept,ADestDir:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从移动设备抓取音频或视频，并上传到服务器。上传完成后，自动触发窗体的OnEndDock事件。</summary>
/// <param name="AForm">与当前操作相关联的表单对象，一般用self。</param>
/// <param name="AAccept">文件上传类型控制，类似"image/*, video/*, audio/*"。</param>
/// <param name="ADestDir">上传目录，为空时上传到服务器upload目录，有值时上传到指定目录，支持子目录。</param>
/// <param name="ACapture">控制文件选择器打开摄像头和麦克风等媒体设备。
/// 当capture属性被设置为camera时，在移动设备上点击文件上传按钮，它会直接打开设备的摄像头，让用户拍摄照片
/// 或录制视频来作为要上传的文件。如果设置为microphone，则会打开麦克风，用于录制音频作为上传文件</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwUploadPro(self,'*.*','mydir','camera');
///  dwGetProp(TForm(self.Owner),'__upload')取上传后的文件名
/// </code>
/// </remarks>
function  dwUploadPro(AForm:TForm;AAccept,ADestDir,ACapture:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将颜色值转换为 RGB 格式，并以#RRGGBB的十六进制形式的字符串返回对应的颜色表示。</summary>
/// <param name="AColor">颜色值，如clWhite。</param>
/// <returns>返回'#RRGGBB'的十六进制形式的字符串</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwColorAlpha(clRed);</code>
/// </remarks>
function  dwColorAlpha(AColor:Integer):string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置焦点。</summary>
/// <param name="ACtrl">需要设置为焦点控件</param>
/// <returns>返回无</returns>
function  dwSetFocus(ACtrl:TControl): Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置文本选择的开始。</summary>
/// <param name="ACtrl">与处理相关的控件</param>
/// <param name="AStart">选择开始位置</param>
/// <returns>返回无</returns>
function  dwSetSelStart(ACtrl:TControl;AStart:Integer): Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置文本选择的结束。</summary>
/// <param name="ACtrl">与处理相关的控件</param>
/// <param name="AEnd">选择结束位置</param>
/// <returns>返回无</returns>
function  dwSetSelEnd(ACtrl:TControl;AEnd:Integer): Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取得主窗体form1。</summary>
/// <param name="ACtrl">与处理相关的控件</param>
/// <returns>返回form1,未找到form1时返回ACtrl.Owner</returns>
function dwGetMainForm(ACtrl:TControl): TForm;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>取文件时间。</summary>
/// <param name="AFileName">文件名</param>
/// <param name="AFlag">aFlag为FILE_CREATE_TIME取创建时间,FILE_MODIFY_TIME取修改时间,FILE_ACCESS_TIME和其它时取最后访问时间</param>
/// <returns>文件时间</returns>
function dwGetFileTime(AFileName: string; AFlag: Byte): TDateTime;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>控制TScrollBox的滚动量。</summary>
/// <param name="AScrollBox">与处理相关的AScrollBox控件</param>
/// <param name="AValue">滚动量</param>
/// <returns>返回0</returns>
function dwSetScroll(AScrollBox:TScrollBox;AValue:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>打印控件ACtrl。</summary>
/// <param name="ACtrl">需要打印的控件</param>
/// <returns>返回无</returns>
function dwPrint(ACtrl:TControl):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>初始化图表</summary>
/// <param name="ACtrl">用于绘制图表的控件，一般为TMemo控件。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwEcharts(memo1);</code>
/// </remarks>
function dwEcharts(ACtrl:TComponent):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>刷新echarts地图</summary>
/// <param name="ACtrl">用于绘制图表的控件，一般为TMemo控件。</param>
/// <returns>返回0</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwEchartsMap(memo1);</code>
/// </remarks>
function dwEchartsMap(ACtrl:TComponent):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>控制滚动量。</summary>
/// <param name="ACtrl">与处理相关的控件</param>
/// <param name="AValue">滚动量</param>
/// <returns>返回无</returns>
function dwScroll(ACtrl:TComponent;Value:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>控制全屏或退出全屏。</summary>
/// <param name="AFullScreen">True进入全屏;false退出全屏</param>
/// <param name="AForm">与处理相关的表单</param>
/// <returns>返回无</returns>
function dwFullScreen(AFullScreen:Boolean;AForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>对Panel内的控件按TabOrder顺序进行水平等分排列 ，AColCount为每行的项目数(列数），大于等于1。
///要求：
///1 全自动根据Margins属性进行控制，不管AlignWithMargins是否为真，需要先设置了Magins
///2 子控件必须有TabOrder属性，如TPanel,TButton, 不能是TSpeedButton(可以在外面包一层TPanel)
///3 控件的Margins的left/right, Top/Bottom尽量保持一致
/// </summary>
/// <param name="AParent">父控件，对其中的子控件进行排列。</param>
/// <param name="AColCount">AColCount为列数，大于等于1。</param>
/// <returns>无</returns>
/// <remarks>函数补充信息:
/// <para>调用例子：</para>
/// <code>dwAlignByColCount(Panel1,3);</code>
/// </remarks>
function dwAlignByColCount(AParent:TPanel;AColCount:Integer):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从JSON中读属性(数值)，如果不存在的话，取默认值。</summary>
/// <param name="AJson">JSON对象</param>
/// <param name="AName">需要取值的属性</param>
/// <param name="ADefault">默认值</param>
/// <returns>返回JSON中属性值</returns>
function dwGetInt(AJson:Variant;AName:String;const ADefault:Integer = 0):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从JSON中读属性(数值)，如果不存在的话，取默认值。</summary>
/// <param name="AJson">JSON对象</param>
/// <param name="AName">需要取值的属性</param>
/// <param name="ADefault">默认值</param>
/// <returns>返回JSON中属性值</returns>
function dwGetDouble(AJson:Variant;AName:String;const ADefault:Double = 0):Double;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从JSON中读属性(数值)，如果不存在的话，取默认值。</summary>
/// <param name="AJson">JSON对象</param>
/// <param name="AName">需要取值的属性</param>
/// <param name="ADefault">默认值</param>
/// <returns>返回JSON中属性值</returns>
function dwGetBoolean(AJson:Variant;AName:String;const ADefault:Boolean = false):Boolean;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从JSON中读属性(字符串)，如果不存在的话，取默认值。</summary>
/// <param name="AJson">JSON对象</param>
/// <param name="AName">需要取值的属性</param>
/// <param name="ADefault">默认值</param>
/// <returns>返回JSON中属性值</returns>
function dwGetStr(AJson:Variant;AName:String;const ADefault:String = ''):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从Url获取数据。</summary>
/// <param name="Url">网络URL地址</param>
/// <param name="Max">未使用</param>
/// <returns>返回获取到的数据</returns>
function dwGetMethod(Url: String; Max: Integer): String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>向Url发送数据。</summary>
/// <param name="Url">网络URL地址</param>
/// <param name="Data">要发送的数据</param>
/// <param name="Max">未使用</param>
/// <returns>返回获取到的数据</returns>
function dwPostMethod(Url: String; Data: UTF8String; Max: Integer): String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从文件中读取JSON数据。</summary>
/// <param name="AJson">读取到的JSON格式的数据</param>
/// <param name="AFileName">包含JSON数据的文件名</param>
/// <returns>成功读取返回0</returns>
function dwLoadFromJson(var AJson:Variant;AFileName:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将JSON数据保存到文件中。</summary>
/// <param name="AJson">需要保存的JSON格式的数据</param>
/// <param name="AFileName">文件名</param>
/// <param name="ACompact">True,以紧凑格式的 JSON 字符串保存;False以方便阅读格式保存</param>
/// <returns>无</returns>
function dwSaveToJson(AJson:Variant;AFileName:String;ACompact:Boolean ):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>json 转 string。</summary>
/// <param name="AJson">需要转换的JSON格式的数据</param>
/// <returns>返回字符串格式的数据</returns>
function _J2S(AJson:Variant):String;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>根据 id 取得FireDac连接。</summary>
/// <param name="AParams">帐套信息。</param>
/// <param name="AIndex">帐套序号，对应DeWebServer管理账套信息（从0开始）。</param>
/// <returns>返回FireDac连接</returns>
function dwGetCliHandleByID(AParams:String;AIndex:Integer):Pointer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>根据 name 取得FireDac连接。</summary>
/// <param name="AParams">帐套信息。</param>
/// <param name="AName">帐套名称。</param>
/// <returns>返回FireDac连接</returns>
function dwGetCliHandleByName(AParams:String;AName:String):Pointer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>优化窗体，主要把其中的Panel/label/button的helpkeyword设置为simple,以减少代码量。</summary>
/// <param name="AForm">与处理相关的窗体。</param>
/// <returns>返回被优化的控件数量</returns>
function dwSimple(AForm:TForm):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>增删浏览器记录History,以监听用户返回事件。</summary>
/// <param name="AForm">TForm对象。</param>
procedure dwHistoryPush(AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>让浏览器导航到历史记录中的上一个页面。</summary>
/// <param name="AForm">TForm对象。</param>
procedure dwhistoryBack(AForm:TForm);

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>在界面上指定StringGrid的当前行(用于高亮显示)。</summary>
/// <param name="ASG">StringGrid表格</param>
/// <returns>成功返回0，否则返回-1</returns>
function dwSetStringGridRow(ASG:TStringGrid):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>通过JS设置控件:设置控件颜色。</summary>
/// <param name="ACtrl">需要处理的控件</param>
/// <param name="AColor">颜色</param>
/// <returns>返回无</returns>
function dwSetCtrlColor(ACtrl:TControl;AColor:TColor):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>通过JS设置控件:设置控件背景颜色。</summary>
/// <param name="ACtrl">需要处理的控件</param>
/// <param name="AColor">颜色</param>
/// <returns>返回无</returns>
function dwSetCtrlBKColor(ACtrl:TControl;AColor:TColor):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>通过JS设置控件:设置控件边框风格及颜色。</summary>
/// <param name="ACtrl">需要处理的控件</param>
/// <param name="ABorder">边框串，如'solid 1 #f00'</param>
/// <returns>返回无</returns>
function dwSetCtrlBorder(ACtrl:TControl;ABorder:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>从JSON数组中取得颜色，输入如:[0,0,255],。</summary>
/// <param name="AJson">JSON格式的颜色数组</param>
/// <param name="ADefault">缺省颜色</param>
/// <returns>返回RGB格式的颜色</returns>
function dwGetColorFromJson(AJson:Variant;ADefault:TColor):TColor;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>向前端发送SSE（Server-Sent Events）消息。</summary>
/// <param name="AForm">与处理相关的表单</param>
/// <param name="AMsg">消息内容</param>
/// <returns>返回0</returns>
function dwSendSSEMsg(AForm:TForm;AMsg:String):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>设置upload触发事件的控件，默认为当前Form。</summary>
/// <param name="AForm">与处理相关的表单</param>
/// <param name="ACtrl">消息内容</param>
/// <returns>返回0</returns>
function dwSetUploadTarget(AForm:TForm;ACtrl:TControl):Integer;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将字符串转换为JSON对象, 如果不成功,则设置为空JSON对象。</summary>
/// <param name="AText">拟转换的字符串</param>
/// <returns>返回字符串对应的JSON对象, 或空JSON对象</returns>
function dwJson(AText:String):Variant;


///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将URL中的参数字符串转换为JSON对象, 如果不成功,则设置为空JSON对象。</summary>
/// <param name="AParams">拟转换的字符串</param>
/// <returns>返回字符串对应的JSON对象, 或空JSON对象</returns>
function dwParamsToJson(AParams:String):Variant;


///----------------------------------------------------------------------------------------------------------------------------
/// <summary>将字符串编码为只包含数字、字母、连字符（-）和下划线（_）的字符串</summary>
/// <param name="Input">拟编码的字符串</param>
/// <returns>返回结果字符串</returns>
function dwUrlSafeBase64Encode(const Input: string): string;


///----------------------------------------------------------------------------------------------------------------------------
/// <summary>解码 -- 将字符串编码为只包含数字、字母、连字符（-）和下划线（_）的字符串</summary>
/// <param name="Input">拟解码的字符串</param>
/// <returns>返回结果字符串</returns>
function dwUrlSafeBase64Decode(const Input: string): string;

///----------------------------------------------------------------------------------------------------------------------------
/// <summary>删除的指定控件</summary>
/// <param name="ACtrl">拟删除的指定控件</param>
/// <returns>返回结果</returns>
/// 注 : 不能删除当前操作控件的父控件
function dwDeleteControl(ACtrl:TControl):integer;
function dwDeleteControlEx(ACtrl:TControl;const AForm:TForm):integer;

//在线打开office文件
function dwOpenOffice(AForm:TForm;AUrl:String):Integer;

//重载
function dwReload(AForm:TForm):Integer;

//判断是否为移动端
function dwIsMobile(AForm:TForm):Boolean;

//通过当前Form取Form1
function dwGetForm1(AForm:TForm):TForm;


implementation  //======================================================================================================


//通过当前Form取Form1
function dwGetForm1(AForm:TForm):TForm;
begin
    if AForm.Parent = nil then begin
        Result  := AForm;
    end else begin
        While AForm.Parent <> nil do begin
            AForm   := TForm(AForm.Parent);
        end;
        Result  := AForm;
    end;
end;


//判断是否为移动端
function dwIsMobile(AForm:TForm):Boolean;
var
    sUA     : String;
begin
    Result  := False;
    sUA := lowercase(dwGetProp(AForm,'requestuseragent'));
    if (Pos('iphone',sUA)>0) or (Pos('ipod',sUA)>0) or (Pos('macintosh',sUA)>0)
            or (Pos('android',sUA)>0)
            or (Pos('windows phone',sUA)>0)
            or (Pos('harmonyos',sUA)>0) or (Pos('arkweb',sUA)>0)
    then begin
        Result  := True;
    end;
end;

//重载
function dwReload(AForm:TForm):Integer;
begin
    Result  := 0;
    dwRunJSTimeout('location.reload();',AForm);
end;


function dwDeleteControl(ACtrl:TControl):integer;
var
    oForm   : TForm;
    sFull   : String;
    sPar    : String;
    sIndex  : String;
    sJS     : String;
begin
    if ACtrl = nil then begin
        Exit;
    end;
    //取得窗体
    oForm   := TForm(ACtrl.Owner);

    //
    if oForm = nil then begin
        Exit;
    end;

    //取得全名备用
    sFull   := dwFullName(ACtrl);


    //从dom中删除控件
    if ACtrl.ClassName = 'TComboBox' then begin
        //
        dwRunJS('document.getElementById("'+sFull+'").parentElement.parentElement.remove();',oForm);
    end else if ACtrl.ClassName = 'TEdit' then begin
        //
        dwRunJS('document.getElementById("'+sFull+'").parentElement.remove();',oForm);
    end else if ACtrl.ClassName = 'TTabSheet' then begin
        //
        sPar    := dwFullName(TTabSheet(ACtrl).PageControl);
        sIndex  := IntToStr(TTabSheet(ACtrl).PageIndex);
        //
        sJS     := ''
                +'const tabs = document.getElementById("'+sPar+'");'

                // 获取所有的 el-tab-pane 元素
                +'const tabPanes = tabs.querySelectorAll(''.el-tab-pane'');'
                +'if ('+sIndex+' < 0 || '+sIndex+' >= tabPanes.length) {'
                    +'console.error(''索引超出范围'');'
                +'};'

                // 获取要删除的 el-tab-pane 元素
                +'const tabPaneToDelete = tabPanes['+sIndex+'];'
                // 获取对应的 el-tab 标签元素
                +'const tabLabelId = tabPaneToDelete.getAttribute(''aria-labelledby'');'
                +'const tabLabel = document.getElementById(tabLabelId);'
                // 删除 el-tab-pane 元素
                +'tabPaneToDelete.parentNode.removeChild(tabPaneToDelete);'
                // 删除对应的 el-tab 标签元素
                +'if (tabLabel) {'
                    +'tabLabel.parentNode.removeChild(tabLabel);'
                +'};'

                +'';

            dwRunJS(sJS,oForm);
    end else if ACtrl.ClassName = 'TCard' then begin
        //
        sPar    := dwFullName(TCard(ACtrl).Parent);
        sIndex  := IntToStr(TCard(ACtrl).CardIndex);
        //
        sJS     := ''
                +'const tabs = document.getElementById("'+sPar+'");'

                // 获取所有的 el-tab-pane 元素
                +'const tabPanes = tabs.querySelectorAll(''.el-tab-pane'');'
                +'if ('+sIndex+' < 0 || '+sIndex+' >= tabPanes.length) {'
                    +'console.error(''索引超出范围'');'
                +'};'

                // 获取要删除的 el-tab-pane 元素
                +'const tabPaneToDelete = tabPanes['+sIndex+'];'
                // 获取对应的 el-tab 标签元素
                +'const tabLabelId = tabPaneToDelete.getAttribute(''aria-labelledby'');'
                +'const tabLabel = document.getElementById(tabLabelId);'
                // 删除 el-tab-pane 元素
                +'tabPaneToDelete.parentNode.removeChild(tabPaneToDelete);'
                // 删除对应的 el-tab 标签元素
                +'if (tabLabel) {'
                    +'tabLabel.parentNode.removeChild(tabLabel);'
                +'};'

                +'';

            dwRunJS(sJS,oForm);
    end else begin
        //
        dwRunJS('document.getElementById("'+sFull+'").remove();',oForm);
    end;

    //释放当前控件
    ACtrl.Destroy;
end;

function dwDeleteControlEx(ACtrl:TControl;const AForm:TForm):integer;
var
    oForm   : TForm;
    sFull   : String;
    sPar    : String;
    sIndex  : String;
    sJS     : String;
begin
    if ACtrl = nil then begin
        Exit;
    end;
    //取得窗体
    oForm   := TForm(ACtrl.Owner);

    //
    if oForm = nil then begin
        Exit;
    end;

    //取得全名备用
    sFull   := dwFullName(ACtrl);


    //从dom中删除控件
    if ACtrl.ClassName = 'TComboBox' then begin
        //
        dwRunJS('document.getElementById("'+sFull+'").parentElement.parentElement.remove();',AForm);
    end else if ACtrl.ClassName = 'TEdit' then begin
        //
        dwRunJS('document.getElementById("'+sFull+'").parentElement.remove();',AForm);
    end else if ACtrl.ClassName = 'TTabSheet' then begin
        //
        sPar    := dwFullName(TTabSheet(ACtrl).PageControl);
        sIndex  := IntToStr(TTabSheet(ACtrl).PageIndex);
        //
        sJS     := ''
                +'const tabs = document.getElementById("'+sPar+'");'

                // 获取所有的 el-tab-pane 元素
                +'const tabPanes = tabs.querySelectorAll(''.el-tab-pane'');'
                +'if ('+sIndex+' < 0 || '+sIndex+' >= tabPanes.length) {'
                    +'console.error(''索引超出范围'');'
                +'};'

                // 获取要删除的 el-tab-pane 元素
                +'const tabPaneToDelete = tabPanes['+sIndex+'];'
                // 获取对应的 el-tab 标签元素
                +'const tabLabelId = tabPaneToDelete.getAttribute(''aria-labelledby'');'
                +'const tabLabel = document.getElementById(tabLabelId);'
                // 删除 el-tab-pane 元素
                +'tabPaneToDelete.parentNode.removeChild(tabPaneToDelete);'
                // 删除对应的 el-tab 标签元素
                +'if (tabLabel) {'
                    +'tabLabel.parentNode.removeChild(tabLabel);'
                +'};'

                +'';

            dwRunJS(sJS,AForm);
    end else begin
        //
        dwRunJS('document.getElementById("'+sFull+'").remove();',AForm);
    end;

    //释放当前控件
    ACtrl.Destroy;
end;


function dwUrlSafeBase64Encode(const Input: string): string;
var
    Base64Str: string;
begin
    // 先使用标准 Base64 编码
    Base64Str := TNetEncoding.Base64.Encode(Input);

    // 替换字符使其符合 URL-safe Base64 格式
    Base64Str := StringReplace(Base64Str, '+', '-', [rfReplaceAll]);
    Base64Str := StringReplace(Base64Str, '/', '_', [rfReplaceAll]);
    Base64Str := StringReplace(Base64Str, '=', '', [rfReplaceAll]); // 去除填充字符

    Result := Base64Str;
end;

function dwUrlSafeBase64Decode(const Input: string): string;
var
    Base64Str: string;
begin
    // 恢复为标准 Base64 编码格式
    Base64Str := StringReplace(Input, '-', '+', [rfReplaceAll]);
    Base64Str := StringReplace(Base64Str, '_', '/', [rfReplaceAll]);

    // 填充字符，根据 Base64 的要求添加等号（=）
    while Length(Base64Str) mod 4 <> 0 do
    Base64Str := Base64Str + '=';

    // 解码并返回
    Result := TNetEncoding.Base64.Decode(Base64Str);
end;

function dwParamsToJson(AParams:String):Variant;
begin
    //AParams 类似 title=WechatNative&&amount=2
    //转变为{"title":"WechatNative","amount":"2"}

    //
    try
        //title=WechatNative&&amount=2  ->  title=WechatNative","amount=2
        AParams := StringReplace(AParams,'&&','","',[rfReplaceAll]);
        //title=WechatNative","amount=2 ->  title":"WechatNative","amount":"2
        AParams := StringReplace(AParams,'=','":"',[rfReplaceAll]);
        //title":"WechatNative","amount":"2  ->  {"title":"WechatNative","amount":"2"}
        AParams := '{"'+AParams+'"}';
        //
        Result  := _json(AParams);
    except
        Result  := _json('{}');
    end;
end;

//
function dwJson(AText:String):Variant;
begin
    Result  := _json(AText);
    if Result = unassigned then begin
        Result  := _json('{}');
    end;
end;


//设置upload触发事件的控件，默认为当前Form
function dwSetUploadTarget(AForm:TForm;ACtrl:TControl):Integer;
var
    joHint  : variant;
begin
    Result  := 0;

    //
    if (AForm.Parent<>nil) then begin

    end;

    //为当前upload设置事件转移。 转移到ACtrl上
    joHint  := _json(AForm.Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;
    joHint.__uploadinfo := _json('{}');
    if ACtrl = nil then begin
        joHint.__uploadinfo.target := '';
    end else begin
        joHint.__uploadinfo.target := ACtrl.Name;
    end;
    AForm.Hint  := joHint;
end;

//取得公共模块Form
function  dwGetPublic(AForm:String):TForm;
var
    iForm   : Integer;
begin
    //默认返回值
    Result  := nil;
    //
    for iForm := 2 to Screen.FormCount-1 do begin
        if LowerCase(Screen.Forms[iForm].Name) = LowerCase(AForm)  then begin
            Result  := Screen.Forms[iForm];
        end;
    end;
end;

//取得公共模块中的控件
function  dwGetPublicComponent(AForm,AComponent:String):TComponent;
var
    oForm   : TForm;
begin
    //默认返回值
    Result  := nil;
    //取得公共模块form
    oForm   := dwGetPublic(AForm);
    //
    if oForm <> nil then begin
        Result  := oForm.FindComponent(AComponent);
    end;
end;
//取得公共模块中的变量
function  dwGetPublicVar(AForm,AVarName:String):TValue;
var
    oForm   : TForm;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin
    //默认返回值
    Result  := nil;
    //取得公共模块form
    oForm   := dwGetPublic(AForm);
    //
    if oForm <> nil then begin
        ctx     := TRttiContext.Create;
        t       := ctx.GetType(oForm.ClassType);
        for f in t.GetFields do begin
            if LowerCase(f.Name) = LowerCase(AVarName) then begin
                Result  := f.GetValue(oForm);
                //
                break;
            end;
        end;
    end;
end;

//设置公共模块中的变量的值
function  dwSetPublicVar(AForm,AVarName:String;AValue:TValue):Integer;
var
    oForm   : TForm;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin
    //默认返回值
    Result  := -1;

    //取得公共模块form
    oForm   := dwGetPublic(AForm);

    //
    if oForm <> nil then begin
        ctx := TRttiContext.Create;
        t   := ctx.GetType(oForm.ClassType);
        for f in t.GetFields do begin
            if LowerCase(f.Name) = LowerCase(AVarName) then begin
                f.SetValue(oForm,AValue);
                //
                Result  := 0;
                //
                break;
            end;
        end;
    end else begin
        Result  := -2;
    end;
end;


//向前端发送SSE（Server-Sent Events）消息
function dwSendSSEMsg(AForm:TForm;AMsg:String):Integer;
var
    Context     : TRttiContext;
    RttiType    : TRttiType;
    RttiMethod  : TRttiMethod;
    //
    oMainForm   : TForm;
begin
    Result  := 0;

    //先取MainForm
    oMainForm   := APPlication.MainForm;

    // 使用 RTTI 获取 TMainForm 类型
    try
        Context     := TRttiContext.Create;
        RttiType    := Context.GetType(oMainForm.ClassType);
        RttiMethod  := RttiType.GetMethod('SendMsgToForm');

        // 调用方法
        if Assigned(RttiMethod) then begin
            RttiMethod.Invoke(oMainForm, [AForm.Handle,dwEscape(AMsg)]);
        end;
    finally
        Context.Free;
    end;
end;

//从JSON数组中取得颜色，输入如:[0,0,255],
function dwGetColorFromJson(AJson:Variant;ADefault:TColor):TColor;
begin
    Result  := ADefault;
    //
    try
        if (AJson <> unassigned) and (AJson <> null) then begin
            case AJson._Count of
                0 : begin

                end;
                1 : begin
                    Result  := RGB(AJson._(0),AJson._(0),AJson._(0));
                end;
                2 : begin
                    Result  := RGB(AJson._(0),AJson._(1),AJson._(1));
                end;
                3 : begin
                    if (AJson._(0)=254) and (AJson._(1)=254) and (AJson._(2)=254) then begin
                        Result  := clNone;
                    end else begin
                        Result  := RGB(AJson._(0),AJson._(1),AJson._(2));
                    end;
                end;
            end;
        end;
    except

    end;
end;

function dwSetCtrlColor(ACtrl:TControl;AColor:TColor):Integer;
begin
    dwRunJS('document.getElementById(`'+dwFullName(ACtrl)+'`).style.color = `'+dwColorAlpha(AColor)+'`;',TForm(ACtrl.Owner));
end;

function dwSetCtrlBKColor(ACtrl:TControl;AColor:TColor):Integer;
begin
    dwRunJS('document.getElementById(`'+dwFullName(ACtrl)+'`).style.backgroundColor = `'+dwColorAlpha(AColor)+'`;',TForm(ACtrl.Owner));
end;

function dwSetCtrlBorder(ACtrl:TControl;ABorder:String):Integer;
begin
    dwRunJS('document.getElementById(`'+dwFullName(ACtrl)+'`).style.border = `'+ABorder+'`;',TForm(ACtrl.Owner));
end;

function dwSetStringGridRow(ASG:TStringGrid):Integer;
var
    sJS     : String;
begin
    try
        Result  := 0;
        //
        sJS :=
        'const table = document.getElementById('''+dwFullName(ASG)+''');'
        +'const rowIndex = '+IntToStr(ASG.Row-1)+';'
        +'const rows = table.querySelectorAll(''tbody > tr'');'
        +'const targetRow = rows[rowIndex];'
        +'rows.forEach(row => {'
            +'row.classList.remove(''current-row'');'
        +'});'
        +'targetRow.classList.add(''current-row'');';

        //
        dwRunJS(sJS,TForm(ASG.Owner));
    except
        Result  := -1;
    end;
end;


procedure dwHistoryPush(AForm:TForm);
begin
    dwRunJS('history.pushState({}, "", "");',AForm);
end;

procedure dwhistoryBack(AForm:TForm);
begin
    dwRunJS('try{history.back()}finally{};',AForm);
end;

//优化窗体，主要把其中的Panel/label/button的helpkeyword设置为simple,以减少代码量
function dwSimple(AForm:TForm):Integer;
var
    iItem   : Integer;
    oPanel  : TPanel;
    oButton : TButton;
    oLabel  : TLabel;
begin
    Result  := 0;
    for iItem := 0 to AForm.ComponentCount - 1 do begin
        if AForm.Components[iItem].ClassType = TPanel then begin
            oPanel  := TPanel(AForm.Components[iItem]);
            if oPanel.HelpKeyword = '' then begin
                Inc(Result);
                oPanel.HelpKeyword  := 'simple';
            end;
        end else if AForm.Components[iItem].ClassType = TButton then begin
            oButton  := TButton(AForm.Components[iItem]);
            if oButton.HelpKeyword = '' then begin
                Inc(Result);
                oButton.HelpKeyword := 'simple';
            end;
        end else if AForm.Components[iItem].ClassType = TLabel then begin
            oLabel  := TLabel(AForm.Components[iItem]);
            if oLabel.HelpKeyword = '' then begin
                Inc(Result);
                oLabel.HelpKeyword  := 'simple';
            end;
        end;
    end;
end;

function dwGetCliHandleByID(AParams:String;AIndex:Integer):Pointer;
var
    joConnections   : Variant;
    iHandle         : Integer;
begin
    //默认不成功
    Result  := 0;

    //转化为JSON并检查
    joConnections   := _json(AParams);
    if joConnections = unassigned then begin
        Exit;
    end;
    if not joConnections.Exists('db') then begin
        Exit;
    end;
    if (AIndex < 0) or ( AIndex >= joConnections.db._Count) then begin
        Exit;
    end;

    //
    if joConnections.db._(AIndex).handle._Count = 5 then begin
        Randomize;
        iHandle := joConnections.db._(AIndex).handle._(Random(5));
        Result  := Pointer(iHandle);
    end;
end;

function dwGetCliHandleByName(AParams:String;AName:String):Pointer;
var
    joConnections   : Variant;
    iHandle         : Int64;
    iItem           : Integer;
begin
    //默认不成功
    Result  := 0;

    //转化为JSON并检查
    joConnections   := _json(AParams);
    if joConnections = unassigned then begin
        Exit;
    end;
    if not joConnections.Exists('db') then begin
        Exit;
    end;

    //
    for iItem := 0 to joConnections.db._Count - 1 do begin
        if LowerCase(joConnections.db._(iItem).name) = LowerCase(AName) then begin
            Randomize;
            iHandle := joConnections.db._(iItem).handle._(Random(5));
            Result  := Pointer(iHandle);
            //
            break;
        end;
    end;
end;


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
function dwGetBoolean(AJson:Variant;AName:String;const ADefault:Boolean = false):Boolean;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            if AJson._(AName) <> null then begin
                Result  := AJson._(AName);
            end;
        end;
    end;
end;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetDouble(AJson:Variant;AName:String;const ADefault:Double = 0):Double;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            if AJson._(AName) <> null then begin
                Result  := AJson._(AName);
            end;
        end;
    end;
end;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetInt(AJson:Variant;AName:String;const ADefault:Integer = 0):Integer;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            if AJson._(AName) <> null then begin
                Result  := AJson._(AName);
            end;
        end;
    end;
end;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetStr(AJson:Variant;AName:String;const ADefault:String = ''):String;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            if AJson._(AName) <> null then begin
                Result  := AJson._(AName);
            end;
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
            +'var oEcharts = echarts.init(document.getElementById(`'+dwFullName(ACtrl)+'`));'
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
        +'fvue.setAttribute(`type`,`text/javascript`);'
        +'fvue.setAttribute(`language`,`JavaScript`); '
        +'fvue.setAttribute(`src`, ''dist/vue.js'');'
        //
        +'var fjs=doc.createElement(`script`);'
        +'fjs.setAttribute(`type`,`text/javascript`);'
        +'fjs.setAttribute(`language`,`JavaScript`); '
        +'fjs.setAttribute(`src`, `dist/index.js`);'
        //
        +'var faxios=doc.createElement(`script`);'
        +'faxios.setAttribute(`type`,`text/javascript`);'
        +'faxios.setAttribute(`language`,`JavaScript`); '
        +'faxios.setAttribute(`src`, ''dist/axios.min.js'');'
        //----
        +'var fcss=doc.createElement(`link`);'
        +'fcss.setAttribute(`rel`,`stylesheet`);'
        +'fcss.setAttribute(`type`,`text/css`); '
        +'fcss.setAttribute(`href`, ''dist/theme-chalk/index.css'');'

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
    dwRunJSTimeout('document.getElementById('''+dwFullName(ACtrl)+''').focus();'
        //+'document.getElementById('''+dwFullName(ACtrl)+''').selectionStart = 2;'
        //+'document.getElementById('''+dwFullName(ACtrl)+''').selectionEnd=4;'
        ,dwGetMainForm(ACtrl));
end;

function  dwSetSelStart(ACtrl:TControl;AStart:Integer): Integer;
begin
    dwRunJSTimeout(''
        //+'document.getElementById('''+dwFullName(Actrl)+''').focus();'
        +'document.getElementById('''+dwFullName(Actrl)+''').selectionStart = '+IntToStr(AStart)+';'
        //+'document.getElementById('''+dwFullName(Actrl)+''').selectionEnd=4;'
        ,dwGetMainForm(ACtrl));
end;

function  dwSetSelEnd(ACtrl:TControl;AEnd:Integer): Integer;
begin
    dwRunJSTimeout(''
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
    iR,iR1      : Integer;
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
    if AForm.Owner <> nil then begin
        AForm   := TForm(AForm.Owner);
    end;
    //替换所有换行符为<br/>
    AMessage    := StringReplace(AMessage,#13#10,'<br/>',[rfReplaceAll]);
    AMessage    := StringReplace(AMessage,#13,'<br/>',[rfReplaceAll]);
    AMessage    := StringReplace(AMessage,'\','\\',[rfReplaceAll]);
    AMessage    := StringReplace(AMessage,'''','\''',[rfReplaceAll]);

    //
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
    oReg    : TRegEx;
    Match   : TMatch;
begin
    Result  := '';
    Match   := oReg.Match(QueryStr,'(?<=' + Param_Name + '=)[^&]*');
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
    oMD5        : TIdHashMessageDigest5;
begin
    oMD5        := TIdHashMessageDigest5.Create;
    //Result    := LowerCase(oMD5.HashStringAsHex(AStr));
    Result      := LowerCase(oMd5.HashstringAsHex(AStr,IndyTextEncoding(Tencoding.UTF8)));
    oMD5.Free;
end;

function    dwSetMobileMode(AForm:TForm;const ADefaultWidth : Integer = 400; const ADefaultHeight:Integer=900):Integer;
var
    sInit   : String;
    //
    iOrient : Integer;
    iW,iH   : Integer;
    iCltW   : Integer;
    iCltH   : Integer;
    //
    iMax    : Integer;
    bVert   : Boolean;
begin
    //
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
    Result  := 0;

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
    Result  := 0;
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
    sPrefix : String;
    sJS     : string;
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

function dwRunJSTimeout(AJS:String;AForm:TForm;const ATimeOut:Integer=10):Boolean;
begin
     AForm.HelpFile := AForm.HelpFile + 'setTimeout(() => {'+AJS+'}, '+IntToStr(ATimeOut)+');';
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

function dwOpenOffice(AForm:TForm;AUrl:String):Integer;
begin
    AUrl    := 'https://view.officeapps.live.com/op/view.aspx?src='+AUrl;
    //dwRunJS('console.log('''+sUrl+''');',self);
    dwOpenUrl(AForm,AUrl,'_blank');
end;

function dwOpenUrl(AForm:TForm;AUrl,Params:String):Integer;
var
     sCode     : string;
begin
    //


    //
    sCode     := 'this.ToWebsite(`'+AUrl+'`,"'+Params+'");';
    //
    AForm.HelpFile := AForm.HelpFile + sCode;
    //
    Result    := 0;
end;

function  dwDeleteCookie(AForm:TForm;AName:String):Integer;
var
     sCode      : string;
     sHint      : String;
     joHint     : variant;
     iItem      : Integer;
begin
    //清除浏览器cookie
    sCode   := 'document.cookie = `'+AName+'=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;';
    AForm.HelpFile := AForm.HelpFile + sCode;

    //写到本地
    sHint     := AForm.Hint;
    joHint    := _json(sHint);
    if joHint <> unassigned then begin
        if not joHint.Exists('_cookies') then begin
            joHint._cookies := _json('[]');
        end;
        for iItem := 0 to joHint._cookies._Count-1 do begin
            if dwGetStr(joHint._cookies._(iItem),'name','')= AName then begin
                joHint._cookies.Delete(iItem);
                break;
            end;
        end;
    end;
    AForm.Hint     := joHint;

    //
    Result    := 0;
end;


function  dwDeleteCookiePro(AForm:TForm;AName,ADomain:String):Integer;
var
     sCode      : string;
     sHint      : String;
     joHint     : variant;
     iItem      : Integer;
begin
    //清除浏览器cookie
    sCode   := 'document.cookie = `'+AName+'=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;`;'
            +  'document.cookie = `'+AName+'=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/; domain=.'+ADomain+'`;';
    AForm.HelpFile := AForm.HelpFile + sCode;

    //写到本地
    sHint     := AForm.Hint;
    joHint    := _json(sHint);
    if joHint <> unassigned then begin
        if not joHint.Exists('_cookies') then begin
            joHint._cookies := _json('[]');
        end;
        for iItem := 0 to joHint._cookies._Count-1 do begin
            if dwGetStr(joHint._cookies._(iItem),'name','')= AName then begin
                joHint._cookies.Delete(iItem);
                break;
            end;
        end;
    end;
    AForm.Hint     := joHint;

    //
    Result    := 0;
end;

//Cookie操作
function  dwSetCookie(AForm:TForm;AName,AValue:String;AExpireHours:Double):Integer;
var
    sCode       : string;
    sHint       : String;
    iItem       : Integer;
    joHint      : variant;
    joCookie    : variant;
begin
    sCode      := 'window._this.dwsetcookie(`'+AName+'`,`'+AValue+'`,'+FloatToStr(AExpireHours)+');';

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
        joHint._cookies   := _json('[]');
    end;

    //删除可能存在的老的同名cookie
    for iItem := 0 to joHint._cookies._Count-1 do begin
        if dwGetStr(joHint._cookies._(iItem),'name','')=AName then begin
            joHint._cookies.Delete(iItem);
            break;
        end;
    end;

    //添加新cookie值
    joCookie       := _Json('{}');
    joCookie.name  := Aname;
    joCookie.value := AValue;
    joHint._cookies.Add(joCookie);

    //反写到Hint中
    AForm.Hint     := joHint;

    //
    Result    := 0;
end;

function  dwSetCookiePro(AForm:TForm;AName,AValue,APath,ADomain:String;AExpireHours:Double):Integer;
var
    sCode       : string;
    iItem       : Integer;
    sHint       : String;
    joHint      : variant;
    joCookie    : variant;
begin
    sCode     := 'window._this.dwsetcookiepro(`'+AName+'`,`'+AValue+'`,'+FloatToStr(AExpireHours)+',`'+APath+'`,`'+ADomain+'`);';

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
        joHint._cookies   := _json('[]');
    end;

    //删除可能存在的老的同名cookie
    for iItem := 0 to joHint._cookies._Count-1 do begin
        if dwGetStr(joHint._cookies._(iItem),'name','')=AName then begin
            joHint._cookies.Delete(iItem);
            break;
        end;
    end;

    //添加新cookie值
    joCookie       := _Json('{}');
    joCookie.name  := Aname;
    joCookie.value := AValue;
    joHint._cookies.Add(joCookie);
    //
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
    sHint       : String;
    iItem       : integer;
    joHint      : Variant;
    joCookie    : Variant;
begin
    //
    sHint     := AForm.Hint;
    joHint    := _json(sHint);
    //
    Result    := '';
    if joHint <> unassigned then begin
        if joHint.Exists('_cookies') then begin
            for iItem := 0 to joHint._cookies._Count - 1 do begin
                joCookie    := joHint._cookies._(iItem);
                if dwGetStr(joCookie,'name','') = AName then begin
                    Result  := dwUnescape(dwGetStr(joCookie,'value',''));
                    Result  := dwUnicodeToChinese(Result);
                    break;
                end;
            end;
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
     sMsgCode  := 'this.$confirm(''%s'', ''%s'', {dangerouslyUseHTMLString: true, confirmButtonText: ''%s'', cancelButtonText: ''%s'', type: ''warning''})'
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
    joHint  : Variant;
begin
    Result  := '';
    //
    if ACtrl <> nil then begin
        //创建HINT对象, 用于生成一些额外属性
        joHint  := dwJson(ACtrl.Hint);

        //取得相应子项的值
        Result  := dwGetStr(joHint,AAttr,'');
    end;
end;

function dwSetProp(ACtrl:TControl;AAttr:String;AValue:Variant):Integer;
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
    iHeight : Integer;
    iRow    : Integer;
    iCol    : Integer;

    iMLeft      : Integer;
    iMTop       : Integer;
    iMRight     : Integer;
    iMBottom    : Integer;
begin
    Result  := 0;
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


