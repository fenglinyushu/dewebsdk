//dwProcessData
{！！！本单元严禁手动编辑！！！}
unit dwProcessData;
//::分离出来一个单独的单元，用于处理前端消息

interface

uses
    dwVars,
    dwBase,
    dwUtils,
    Main,
    dwDM,
    System.NetEncoding,
                      
    //
    IdURI,
    //Qlog,
    SynCommons, //mormot的json单元

    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.ADSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef, FireDAC.Phys.ASADef,
    FireDAC.Phys.MongoDBDef, FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
    FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB, FireDAC.Phys.ASA,
    FireDAC.Phys.TData, FireDAC.Phys.Infx, FireDAC.Phys.DB2, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
    FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.ADS,
    FireDAC.Phys.MySQL, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageBin,
    FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient,
    //
    Variants,
    ShellApi,
    HttpApp,
    Generics.Collections, //用于TDictionary
    Data.Win.ADODB, Data.DB, Spin, Vcl.DBGrids,
    Windows, Messages, SysUtils, Classes, Controls, Forms,
    StdCtrls, ExtCtrls, StrUtils;

function DecodeUtf8Str(const S: UTF8String): WideString;

function dwGetPostResponse(ClientCnx: TDWHttpConnection;AData:String): String;


implementation
//DecodeUtf8Str
function DecodeUtf8Str(const S: UTF8String): WideString;
var
    lenSrc, lenDst  : Integer;
begin
    lenSrc  := Length(S);
    if(lenSrc=0)then Exit;
    lenDst  := MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, nil, 0);
    SetLength(Result, lenDst);
    MultiByteToWideChar(CP_UTF8, 0, Pointer(S), lenSrc, Pointer(Result), lenDst);
end;

//function DynExtra(AExtra:String):String;
function DynExtra(AExtra:String):String;
var
    iId     : Integer;
    //
    iStart  : Integer;  // Start
    iEnd    : Integer;  // End
    //
    sLine   : string;
    sData   : string;
    //
    slExtra : TStringList;
begin
    try 
        Result  := '';
        slExtra := TStringList.Create;
        slExtra.Text    := AExtra;
        for iId := 0 to slExtra.Count-1 do begin
            sLine   := Trim(slExtra[iId]);
            //根据当前行的类型分别处理
            if LowerCase(Copy(sLine,1,8))='<script ' then begin
                //是<script>
                //从<script>...</script>中解析出src的内容
                iStart  := Pos('src=',sLine);
                Delete(sLine,1,iStart+3);
                iStart  := Pos('"',sLine);
                Delete(sLine,1,iStart);
                iStart  := Pos('"',sLine);
                sData   := Copy(sLine,1,iStart-1);
                //追加到result
                Result  := Result 
                        +'var oScript'+IntToStr(iId)+' = document.createElement("script");'
                        +'oScript'+IntToStr(iId)+'.type = "text/javascript";'
                        +'oScript'+IntToStr(iId)+'.src = "'+sData+'";'
                        +'document.getElementsByTagName("head")[0].appendChild(oScript'+IntToStr(iId)+');';
            //是<style>
            end else if LowerCase(Copy(sLine,1,7))='<style>' then begin
                //从<style>...</style>中解析出style的内容
                iStart  := Pos('<style>',LowerCase(sLine));
                iEnd    := Pos('</style>',LowerCase(sLine));
                sData   := Copy(sLine, iStart + 7, iEnd - iStart - 7);
                //追加到result
                Result  := Result
                        +'var styleNode'+IntToStr(iId)+' = document.createElement("style");'
                        +'styleNode'+IntToStr(iId)+'.innerHTML="'+sData+'";'
                        +'document.head.appendChild(styleNode'+IntToStr(iId)+');';
            //是<link>
            end else if LowerCase(Copy(sLine,1,6))='<link ' then begin
                //从<link...>中解析出href的内容
                iStart  := Pos('href=',sLine);
                Delete(sLine,1,iStart+4);
                iStart  := Pos('"',sLine);
                Delete(sLine,1,iStart);
                iStart  := Pos('"',sLine);
                sData   := Copy(sLine,1,iStart-1);
                //追加到result
                Result  := Result 
                        +'var oScript'+IntToStr(iId)+' = document.createElement("link");'
                        +'oScript'+IntToStr(iId)+'.type = "text/css";'
                        +'oScript'+IntToStr(iId)+'.rel  = "stylesheet";'        
                        +'oScript'+IntToStr(iId)+'.href = "'+sData+'";'
                        +'document.getElementsByTagName("head")[0].appendChild(oScript'+IntToStr(iId)+');';
            end;
        end;
    except
        Result  := '';
    end;
end;

//ProcessAfter 取得jaAfter,并处理.做成一个过程, 以方便管理
function ProcessAfter(AForm:TForm;AComponent:String;ABefore:Variant;AShunt:Integer):String;
var
    ssCode  : string;
    sResp   : string;
    iTmp    : Integer;
    //
    jaAfter : Variant;
    joDiff  : Variant;
    //
    iHtmlE  : Integer;
    iHtmlS  : Integer;
    iDataE  : Integer;
    iDataS  : Integer;
    iMethE  : Integer;
    iMethS  : Integer;
    iMounE  : Integer;
    iMounS  : Integer;
    iStylE  : Integer;
    iStylS  : Integer;
    //
    sHtml   : String;
    sData   : string;
    sMeth   : string;
    sMoun   : string;
    sTemp   : string;
    sStyl   : string;   //用于添加style
    sJS     : string;
    oMouseUp: Procedure(Sender:TObject;utton: TMouseButton; Shift: TShiftState; X, Y: Integer) of Object;
begin
    //取得事件执行后控件信息
    if (AForm.Parent<>nil) and (LowerCase(Copy(AForm.ClassName,1,5))='tform') then begin
        jaAfter  := _json(dwGetComponentInfos(TForm(AForm.Owner)));
    //2021-07-26为了嵌入FORM增加
    end else if (AForm.Parent<>nil) then begin
        jaAfter  := _json(dwGetComponentInfos(TForm(AForm.Parent.Owner)));
    end else begin
        jaAfter  := _json(dwGetComponentInfos(AForm));
    end;
    //根据执行情况回应CLIENT
    if (AForm.HelpKeyword = 'normal') or (AForm.HelpKeyword = '') or (AForm.HelpKeyword = 'embed') then begin
        //本情况为: 客户端事件 致 控件信息改变 DockSite := True;
        if ((AForm.ParentFont) OR (AForm.DockSite)) or ((AForm.Parent<>nil) and (TForm(AForm.Owner).DockSite=True)) then begin
            //新的无闪烁处理Docksite
            try 
                //保存原OnMouseUp函数, 并清空 原OnMouseUp函数, 以防止多次执行
                oMouseUp    := AForm.OnMouseUp;
                AForm.OnMouseUp := nil;
                //清除当前Form的DockSite标志
                AForm.DockSite      := False;
                //清除父Form的DockSite标志
                if (AForm.Parent<>nil) and (TForm(AForm.Owner).DockSite=True) then begin
                    TForm(AForm.Owner).DockSite := False;
                end;
                //如果不是主窗体，则切换到主窗体，以重绘所有
                if AForm.ClassName <> 'TForm1' then begin
                    AForm   := TForm(AForm.Owner);
                end;
                //重建Form
                sResp     := dwFormToHtml(AForm);
                //更新标题，类名，句柄，分流号，资源等
                sResp     := StringReplace(sResp,'[!caption!]',AForm.Caption,[rfReplaceAll]);
                sResp     := StringReplace(sResp,'[!classname!]',AForm.ClassName,[rfReplaceAll]);
                sResp     := StringReplace(sResp,'[!handle!]',IntToStr(AForm.Handle),[rfReplaceAll]);
                sResp     := StringReplace(sResp,'[!shuntflag!]',IntToStr(AShunt),[rfReplaceAll]);
                sResp     := StringReplace(sResp,'[!resource!]',gsResource[giResource],[rfReplaceAll]);
                //查找各部分的起止位置
                iHtmlS  := Pos('<!--[app_start]-->',sResp) + Length('<!--[app_start]-->');
                iHtmlE  := Pos('<!--[app_end]-->',sResp);
                iDataS  := Pos('/*[data_start]*/',sResp) + Length('/*[data_start]*/');
                iDataE  := Pos('/*[data_end]*/',sResp);
                iMethS  := Pos('/*[methods_start]*/',sResp) + Length('/*[methods_start]*/');
                iMethE  := Pos('/*[methods_end]*/',sResp);
                iMounS  := Pos('/*[mounted_start]*/',sResp) + Length('/*[methods_start]*/');
                iMounE  := Pos('/*[mounted_end]*/',sResp);
                iStylS  := Pos('<!--[style_start]-->',sResp) + Length('<!--[style_start]-->');
                iStylE  := Pos('<!--[style_end]-->',sResp);
                //取各部分字符串
                sHtml   := Copy(sResp,iHtmlS,iHtmlE - iHtmlS);
                sData   := Copy(sResp,iDataS,iDataE - iDataS);
                sMeth   := Copy(sResp,iMethS,iMethE - iMethS);
                sMoun   := Copy(sResp,iMounS,iMounE - iMounS);
                sStyl   := Copy(sResp,iStylS,iStylE - iStylS);
                //根据sStyl生成添加style的字符串sJS
                sJS     := DynExtra(sStyl);
                //组合拼接代码字符串
                sTemp   := concat(
                        #13'template : `',
                        sHtml,
                        '`,',
                        '');
                //添加清除所有时钟的代码
                sJS     := sJS
                        +#13'for (let i = 1; i < 10000; i++) {'
                            +#13'clearInterval(i);'
                        +#13'}';
                sResp   := Concat(
                        sJS,
                        #13'var Profile = Vue.extend({',
                        sTemp,
                        #13,
                        sData,
                        #13,
                        sMoun,
                        #13,
                        sMeth,
                        #13'})',
                        //#13'document.getElementById("app").innerHTML = ''<div id="temp"></div>'';',
                        #13'new Profile().$mount("#app");',
                        '');
                //添加可能的OnMouseDown事件
                for iTmp := 0 to Screen.FormCount-1 do begin
                    if (Screen.Forms[iTmp].Owner = AForm ) and Assigned( Screen.Forms[iTmp].OnMouseDown ) then begin
                        sResp   := sResp + #13'axios.post(''/deweb/post'',''{"m":"mounted","i":'+IntToStr(Screen.Forms[iTmp].Handle)+'}'')'
                                +'.then('
                                    +'resp =>{'
                                        +'window._this.procResp(resp.data);'
                                    +'}'
                                +');';
                         
                    end;
                end;
                //生成返回值字符串
                joDiff    := _json('{}');
                joDiff.m  := 'update';
                joDiff.o  := sResp;
                
                //发送回应
                Result  := joDiff;
            finally
                //清空HelpFile, 并恢复OnMouseUp事件
                AForm.HelpFile  := '';
                AForm.OnMouseUp := oMouseUp;
            end;
        end else begin
            iTmp    := ABefore._Count;
            //比较,得到更新信息
            joDiff    := dwGetDiffs(ABefore,jaAfter,AComponent);
            //增加可能的客户端直接JS代码,如:dwShowMessage等
            ssCode    := UTF8ToWideString(joDiff.o);
            ssCode    := ssCode + AForm.HelpFile;    
            //如果当前不是主窗体，则同时复制主窗体的HelpFile
            if AForm.Owner<>nil then begin
                if lowerCase(AForm.Owner.ClassName) = 'tform1' then begin
                    ssCode    := ssCode + TForm(AForm.Owner).HelpFile;
                    TForm(AForm.Owner).HelpFile := '';
                end;
            end;
            //清空HelpFile,并生成返回值字符串
            joDiff.o  := ssCode;
            
            //清空HelpFile (其他JS代码)
            AForm.HelpFile      := '';
            
            //发送回应
            Result  := joDiff;
        end;
    end;
    //释放变量
    VarClear(ABefore);
    VarClear(jaAfter);
end;

//dwProcessData
function dwGetPostResponse(ClientCnx: TDWHttpConnection;AData:String): String;
var
    //
    sResp       : String;
    sPath       : string;
    sName       : string;
    sParams     : string;       //URL参数
    sDLL        : string;       //应用DLL
    sHot        : string;       //hot目录的应用dll
    sLast       : String;       //多重热加载文件
    sDw         : string;
    sHint       : String;
    sTmp        : String;
    sClass      : String;
    sCompClass  : string;
    sCompName   : string;
    sPost       : string;
    //
    pData       : PAnsiChar;
    //
    hInst       : THandle;
    fLoad       : PdwLoad;     //载入页面函数
    fDirect     : PdwDirect;   //直接数据交互函数

    //
    slDebug     : TStringList;
    dtApp       : TDateTime;    //用于热加载时保存文件时间

    //
    joResp      : Variant;
    joData      : Variant;
    joPara      : Variant;
    jaBefore    : Variant;  //事件执行前的控件信息
    jaAfter     : Variant;  //事件执行后的控件信息
    joDiff      : Variant;  //事件执行后的区别信息
    joHint      : Variant;
    joTemp      : Variant;
    //
    oForm       : TForm;
    oForm1      : TForm;
    oFormCrt    : TForm;
    oComp       : TComponent;
    oDock       : TDragDockObject;

    //
    iError      : Integer;        //用于记录当前错误位置
    iOrient     : Integer;
    iDWVcl      : Integer;
    iParamLn    : Integer;
    //iShunt      : Integer;          //分流标识
    iApp        : Integer;          //用于在grDWApps中查找
    iRedir      : Integer;          //用于查找重定向表
    iHot        : Integer;          //用于检查多重热加载
    iDel        : Integer;          //用于删除多余的热加载文件
    Remains     : Integer;
    iTmp        : Integer;
    iFormCount  : Integer;          //用于避免未生成到screen中
    iCount      : Integer;

    //
    mbOrient    : TMouseButton;     //纵向LEFT,横向:Right
    //屏幕属性
    iOS         : Integer;
    iWidth      : Integer;
    iHeight     : Integer;
    sOrient     : String;
    iForm       : Integer;
    iComp       : Integer;

    //
    bTmp        : Boolean;          //用于OnHide中的一个没用的必须变量
begin
    //写日志
    //PostLog(llDebug,dwUnEscape(AData));
    iError  := 0;
    //设置当前工作目录，并设置默认返回值
    SetCurrentDir(gsMainDir);
    Result  := '';
    try 
        //表明收到了get/post消息
        MainForm.AddDebugMsg(' -> Enter GetResponse Function');
        //取得Get/post值  反编码, 去除其中可能{}"
        sPath     := dwUnEscape(AData);
        //错误捕捉框架 -10
        if iError = 0 then begin
            try 
                //10 URL致重启退出
                if sPath = '__restart' then begin
                    //通过辅助程序重启
                    //先运行辅助程序
                    ShellExecute(0,'open',Pchar('dwsaux.exe'),nil,nil,SW_SHOWNORMAL);
                    
                    //发送回应,表明正在重启
                    Result  := '   ---   restarting   ---';
                    
                    //ClientCnx.Answer404;
                    MainForm.AddDebugMsg(' -> Exit with restart');
                    Exit;
                end;
            except
                iError  := -10;
            end;
        end;
        //错误捕捉框架 -20
        if iError = 0 then begin
            try 
                //20 禁止直接下载文件(特定的目录直接返回404)
                if FileExists(gsMainDir+sPath) then begin
                    if (Copy(sPath,1,3)<>'dl/')
                                        and (Copy(sPath,1,9)<>'download/')
                                        and (Copy(sPath,1,5)<>'dist/')
                                        and (Copy(sPath,1,12)<>'ZXing_files/')
                                        and (Copy(sPath,1,6)<>'image/')
                                        and (Copy(sPath,1,6)<>'media/')
                                        and (Copy(sPath,1,Length(gsUPLOAD_DIR))<>Copy(gsUPLOAD_DIR,1,Length(gsUPLOAD_DIR)-1)+'/') //允许upload目录下载
                                        and (sPath<>'favicon.ico')
                                        and (LowerCase(ExtractFileExt(sPath))<>'.txt')
                                        and (LowerCase(ExtractFileExt(sPath))<>'.zip')
                                        and (LowerCase(ExtractFileExt(sPath))<>'.rar')
                                        and (LowerCase(ExtractFileExt(sPath))<>'.html')
                                        and (LowerCase(ExtractFileExt(sPath))<>'.htm') then begin
                        Result  := '404';
                        Exit;
                    end;
                end;
            except
                iError  := -20;
            end;
        end;
        //错误捕捉框架 -30
        if iError = 0 then begin
            try 
                //30 path为空时，如存在index.html，则优先打开
                if sPath='' then begin
                    if FileExists(gsMainDir+'index.html') then begin
                        Exit;
                    end;
                end;
            except
                iError  := -30;
            end;
        end;
        //错误捕捉框架 -40
        if iError = 0 then begin
            try 
                //40 取得参数，并显示调试信息
                sParams   := dwEscape(ClientCnx.Params);
                MainForm.AddDebugMsg(' -> '+sPath + ', Params : '+sParams);
            except
                iError  := -40;
            end;
        end;
        //错误捕捉框架 -50
        if iError = 0 then begin
            try 
                //50 用于兼容未缩减的代码
                if pos('"mode":',sPath)>0 then begin
                    sPath     := StringReplace(sPath,'"mode":','"m":',[]);
                    sPath     := StringReplace(sPath,'"cid":','"i":',[]);
                    sPath     := StringReplace(sPath,'"component":','"c":',[]);
                    sPath     := StringReplace(sPath,'"method":','"t":',[]);
                    sPath     := StringReplace(sPath,'"value":','"v":',[]);
                    sPath     := StringReplace(sPath,'"class":','"s":',[]);
                end;
            except
                iError  := -50;
            end;
        end;
        //错误捕捉框架 -60
        if iError = 0 then begin
            try 
                //60 自动切换大量的keylift/iblog连接  如：http://www.delphibbs.com/keylife/iblog_show.asp?xid=19903
                if Pos('iblog_show',sPath)>0 then begin
                    sPath   := '';
                    sParams := '';
                    //
                    Result  := '<meta http-equiv="refresh" content="1;url=/">';
                    Exit;
                end;
            except
                iError  := -60;
            end;
        end;
        //错误捕捉框架 -70
        if iError = 0 then begin
            try 
                //70 默认网址。如果没有输入，则默认为default.dw
                if sPath='' then begin
                    sPath     := 'default.dw';
                end;
            except
                iError  := -70;
            end;
        end;
        //错误捕捉框架 -80 主要处理过程
        if iError = 0 then begin
            try 
                //80 === 判断是否JSON 生成响应
                if dwStrIsJson(sPath) then begin
                    //生成JSON对象
                    MainForm.AddDebugMsg(' -> is JSON');
                    TDocVariant.New(joData);
                    joData    := _Json(sPath);
                    MainForm.AddDebugMsg(' -> Get Json');
                    
                    //根据模式mode即m进行处理
                    if joData.m = 'direct' then begin
                        //[direct] 直接数据交互模式,也即API模式
                        //错误捕捉框架 -801
                        if iError = 0 then begin
                            try 
                                sTmp := gsMainDir+'apps\'+joData.n+'.dll';
                                if FileExists(sTmp) then begin
                                    try 
                                        //载入DLL，并执行，返回
                                        //载入DLL
                                        hInst     := LoadLibrary(PChar(sTmp));
                                        //取得函数
                                        fDirect   := GetProcAddress(hInst,'dwDirectInteraction');
                                        //执行函数，取得返回值
                                        sResp     := String(fDirect(PWideChar(String(joData.data))));
                                        //发送回应
                                        Result  := sResp;
                                        //用于对直接函数输出，根据设置json=1确定输出格式
                                        if Pos('json=1',String(joData.data))>0 then begin
                                            gsContType  := 'application/json';
                                        end;
                                    finally
                                        //释放DLL
                                        FreeLibrary(hInst);
                                    end;
                                end else begin
                                    Result  := 'no library';
                                end;
                            except
                                iError  := -801;
                            end;
                        end;
                    //[onbeforeunload] 收到页面关闭消息.收到该消息后，在服务器中删除Handle为joData.i的子窗体
                    end else if joData.m = 'onbeforeunload' then begin
                        //错误捕捉框架 -802
                        if iError = 0 then begin
                            try 
                                MainForm.AddDebugMsg(' -> Enter onbeforeunload');
                            except
                                iError  := -802;
                            end;
                        end;
                    //[reload] 收到页面重载消息.收到该消息后， 随意回复一个消息就能成功
                    end else if joData.m = 'reload' then begin
                        //错误捕捉框架 -803
                        if iError = 0 then begin
                            try 
                                MainForm.AddDebugMsg(' -> Enter reload');
                                
                                //发送回应
                                Result  := 'this.Label1__cap="DeWebreload";';
                            except
                                iError  := -803;
                            end;
                        end;
                    //[init] 初始化网页,也即第一次生成网页
                    end else if joData.m = 'init' then begin
                        //错误捕捉框架 -804
                        if iError = 0 then begin
                            try 
                                //生成对象(包含各种参数)
                                MainForm.AddDebugMsg(' -> Enter Init');
                                //说明: 收到init包, 包含窗体Width/height信息, 应该根据当前WH信息
                                //第一次创建窗体消息,生成HTML
                                
                                //截取名称(删除后面的.dw)
                                sPath     := joData.url;
                                sName     := Copy(sPath,1,Length(sPath)-3);  //删除后面的.dw
                                
                                //生成对象(包含各种参数)
                                TDocVariant.New(joPara);
                                joPara.m                := 'init';
                                joPara.params           := HttpDecode(joData.Params); //UTF8Decode
                                joPara.dwclass          := sName;
                                joPara.ip               := ClientCnx.GetPeerAddr;//PeerAddr;//  .GetXAddr;//..GetPeerAddr;
                                joPara.os               := joData.os;
                                joPara.ua               := joData.ua;
                                joPara.url              := joData.fullurl;      //获取完整URL http://127.0.0.1:8020/Test/index.html#test?name=test
                                
                                joPara.screenwidth      := joData.screenwidth;
                                joPara.screenheight     := joData.screenheight;
                                joPara.innerwidth       := joData.innerwidth;
                                joPara.innerheight      := joData.innerheight;
                                joPara.clientwidth      := joData.clientwidth;
                                joPara.clientheight     := joData.clientheight;
                                joPara.orientation      := joData.orientation;
                                
                                joPara.bodywidth        := joData.bodywidth;
                                joPara.bodyheight       := joData.bodyheight;
                                
                                //joPara.availwidth       := joData.availwidth;
                                //joPara.availheight      := joData.availheight;
                                //
                                joPara.devicepixelratio := joData.devicepixelratio;
                                
                                joPara.shuntflag        := giShunt; //分流标志, 用于多个NG反代时负载平衡
                                joPara.requestuseragent := ClientCnx.RequestUserAgent;
                                joPara.requesthost      := ClientCnx.RequestHost;
                                joPara.requesthostname  := ClientCnx.RequestHostName;
                                joPara.requesthostport  := ClientCnx.RequestHostPort;
                                MainForm.AddDebugMsg(' -> Start Load Apps dll');
                                
                                //指定hInst默认值，代表没有打开任何应用
                                hInst     := 0;
                                
                                //取得DLL文件名
                                sDll    := gsMainDir+'Apps\'+sName+'.dll';
                                sHot    := gsMainDir+'Apps\Hot\'+sName+'.dll';
                                //延迟热加载处理 FileExists(sDll)
                                if FileExists(sDll) then begin
                                    sLast   := sDll;
                                    dtApp   := dwGetFileTime(sDll,FILE_MODIFY_TIME);
                                    for iHot := 1 to 10 do begin
                                        sHot    := gsMainDir+'Apps\'+sName+'__'+IntToStr(iHot)+'.dll';
                                        if FileExists(sHot) then begin
                                            if dwGetFileTime(sHot,FILE_MODIFY_TIME) > dtApp then begin
                                                dtApp   := dwGetFileTime(sHot,FILE_MODIFY_TIME);
                                                sLast   := sHot;
                                            end;
                                        end;
                                    end;
                                    if sLast <> sDll then begin
                                        if DeleteFile(sDll) then begin
                                            if CopyFile(PChar(sLast),PChar(sDll),False) then begin
                                                sLast   := sDll;
                                            end;
                                        end;
                                    end;
                                    hInst  := LoadLibrary(PChar(sLast));
                                    //删除老的应用
                                    for iHot := 1 to 10 do begin
                                        DeleteFile(gsMainDir+'Apps\'+sName+'__'+IntToStr(iHot)+'.dll');
                                    end;
                                end;
                                //得到函数地址
                                fLoad   := GetProcAddress(hInst,'dwLoad');
                                //默认返回gsErrorHtml;
                                sResp    := gsErrorHtml;
                                //载入结果判断
                                if (hInst <> 0) and  Assigned( fLoad) then begin
                                    MainForm.AddDebugMsg('0 Assigned fLoad.');
                                    //执行，并得到resp
                                    //重新设置一下目录,以防出错
                                    SetCurrentDir(gsMainDir);
                                    
                                    // 调用函数
                                    oForm     := fLoad(_J2S(gjoConnections),
                                        TFDConnection(MainForm.FindComponent('FDConnection_0_'+IntToStr(Random(5)))).CliHandle,
                                        Application,
                                        Screen);
                                    
                                    //
                                    MainForm.AddDebugMsg('0 fLoad Success.');
                                    
                                    //合并Hint
                                    oForm.Hint     := dwCombineJson(oForm.Hint,joPara);
                                    
                                    //强制AllphiBlend,以生成心跳包
                                    oForm.AlphaBlend    := False;
                                    
                                    //
                                    MainForm.AddDebugMsg('1 dwCombineJson Success.');
                                    
                                    joTemp  := dwJson(oForm.Hint);
                                    //保存DLL句柄 (到 hint)
                                    joTemp.DllHandle        := IntToStr(hInst);
                                    
                                    //将相应屏幕属性写入HINT以遗传给二次打开的窗体
                                    joTemp.os               := joData.os;
                                    joTemp.ip               := String(joPara.ip);
                                    joTemp.ua               := String(joPara.ua);
                                    joTemp.orientation      := String(joData.orientation);
                                    joTemp.screenwidth      := Integer(joData.screenwidth);
                                    joTemp.screenheight     := Integer(joData.screenheight);
                                    joTemp.innerwidth       := Integer(joData.innerwidth);
                                    joTemp.innerheight      := Integer(joData.innerheight);
                                    joTemp.clientwidth      := Integer(joData.clientwidth);
                                    joTemp.clientheight     := Integer(joData.clientheight);
                                    joTemp.availwidth       := Integer(joData.availwidth);
                                    joTemp.availheight      := Integer(joData.availheight);
                                    joTemp.bodywidth        := Integer(joData.bodywidth);
                                    joTemp.bodyheight       := Integer(joData.bodyheight);
                                    joTemp.orientation      := String(joData.orientation);
                                    joTemp.devicepixelratio := Double(joData.devicepixelratio);
                                    joTemp.params           := TIdURI.URLDecode(joData.params);
                                    joTemp.shuntflag        := IntToStr(giShunt);
                                    
                                    //写入物理分辨率
                                    joTemp.truewidth        := Integer(joData.screenwidth*joData.devicepixelratio);
                                    joTemp.trueheight       := Integer(joData.screenheight*joData.devicepixelratio);
                                    
                                    //写入
                                    joTemp.gethtmlheight    := IntToStr(Integer(@dwsGetHtmlLabelHeight));
                                    
                                    oForm.Hint  := String(joTemp);
                                    //
                                    MainForm.AddDebugMsg('3 dwSetProp Success.');
                                    
                                    //隐藏FORM
                                    oForm.ParentWindow  := MainForm.Panel_Forms.Handle;
                                    
                                    //
                                    MainForm.AddDebugMsg('4 Hide Form Success.');
                                    
                                    //标记为网页应用窗体
                                    oForm.ScreenSnap    := True;       //
                                    
                                    
                                    //从JSON对象中取得相应屏幕属性
                                    iOS       := joData.os;
                                    iWidth    := joData.screenwidth;
                                    iHeight   := joData.screenheight;
                                    sOrient   := joData.orientation;
                                    
                                    //
                                    MainForm.AddDebugMsg('5 dwSetProp Success.');
                                    
                                    //更新Cookie
                                    dwSetFormCookies(oForm,ClientCnx.RequestCookies);
                                    
                                    //
                                    oForm.Show;
                                    
                                    //
                                    MainForm.AddDebugMsg('6 oForm.Showed .');
                                    //方向
                                    iOrient   := StrToIntDef(sOrient,0);
                                    if iOrient in [0,180] then begin
                                        mbOrient  := mbLeft;
                                    end else begin
                                        mbOrient  := mbRight;
                                    end;
                                    //运行事件,主要用于做多操作系统(iPhone,Android,PC)适配
                                    if Assigned(oForm.OnMouseUp) then begin
                                        oForm.OnMouseUp(oForm,mbOrient,dwPlatFormToShiftState(iOS),iWidth,iHeight);
                                    end;
                                    //用SnapBuffer来表示失效时间，HelpContext用来标志DLL的load句柄
                                    oForm.SnapBuffer    := Round((Now-gfStartTime)*24*3600) + giExpire ;
                                    oForm.HelpContext   := hInst;
                                    //***根据Form生成网页(此时一些信息还未输入, 比如caption, handle等)
                                    MainForm.AddDebugMsg('7 Before dwFormToHtml.');
                                    sResp     := dwFormToHtml(oForm);
                                    MainForm.AddDebugMsg('8 After dwFormToHtml.');
                                    //替换关键内容
                                    sResp     := StringReplace(sResp,'[!caption!]',oForm.Caption,[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!classname!]',oForm.ClassName,[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!handle!]',IntToStr(oForm.Handle),[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!shuntflag!]',IntToStr(giShunt),[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!resource!]',gsResource[giResource],[rfReplaceAll]);
                                    
                                    //
                                    MainForm.AddDebugMsg('9 After StringReplace.');
                                    if MainForm.PageControl.ActivePage = MainForm.TabSheet_Debug then begin
                                        slDebug   := TStringList.Create;
                                        slDebug.Text   := sResp;
                                        slDebug.SaveToFile('_dwtemp.html',TEncoding.UTF8);
                                        FreeAndNil(slDebug);
                                        //
                                        MainForm.AddDebugMsg('10 After SaveToFile.');
                                    end;
                                end else begin
                                    if (hInst = 0) then begin
                                        MainForm.AddDebugMsg(' -> error at : hInst = 0. (1)'+ IntToStr(GetLastError));
                                    end else begin
                                        MainForm.AddDebugMsg(' -> error at : not Assigned( fLoad). (1) ');   
                                    end;
                                end;
                                //生成返回值字符串
                                MainForm.AddDebugMsg('11 Before joPara.');
                                
                                //生成返回的JSON对象, 应该为创建一个html
                                joPara  := _json('{}');
                                joPara.m    := 'html';
                                joPara.o    := sResp;
                                
                                //
                                MainForm.AddDebugMsg('12 Before SendResp.');
                                
                                //发送回应
                                Result  := VariantSaveJSON(joPara);
                                //SendResp(sResp);
                                
                                //
                                MainForm.AddDebugMsg('13 After SendResp.');
                            except
                                iError  := -804;
                            end;
                        end;
                    //[heart] 心跳包
                    end else if joData.m = 'heart' then begin
                        //错误捕捉框架 -805
                        if iError = 0 then begin
                            try 
                                //取得对应FORM的控件值
                                oForm     := dwGetFormByCID(joData.i);
                                if oForm = nil then begin
                                    MainForm.AddDebugMsg(' -> No Form');
                                    
                                    //未找到窗体的情况下，发送一个刷新
                                    joDiff    := _json('{}');
                                    joDiff.m  := 'update';
                                    joDiff.o  := 'location.reload();';
                                    
                                    //发送回应
                                    Result  := joDiff;
                                    
                                    //发送临时回应，以暂时屏蔽重载
                                    Result  := '{"m":"ok"}';
                                    
                                    MainForm.AddDebugMsg(' -> Response dwreload');
                                end else begin
                                    //更新对应FORM的失效期
                                    oForm.SnapBuffer    := Round((Now-gfStartTime)*24*3600) + giExpire ;
                                    
                                    //发送回应
                                    Result  := '{"m":"ok"}';
                                end;
                            except
                                iError  := -805;
                            end;
                        end;
                    //[popstate] 回退消息
                    end else if joData.m = 'popstate' then begin
                        //错误捕捉框架 -806
                        if iError = 0 then begin
                            try 
                                //取得对应FORM的控件值
                                oForm   := dwGetFormByCID(joData.i);
                                oForm1  := oForm;
                                //如果当前不是主窗体，则取得主窗体
                                if oForm.Owner<>nil then begin
                                    if lowerCase(oForm.Owner.ClassName) = 'tform1' then begin
                                        oForm1  := TForm(oForm.Owner);
                                    end;
                                end;
                                if oForm = nil then begin
                                    MainForm.AddDebugMsg(' -> No Form');
                                    
                                    //未找到窗体的情况下，发送一个刷新
                                    joDiff    := _json('{}');
                                    joDiff.m  := 'update';
                                    joDiff.o  := 'location.reload();';
                                    
                                    //发送回应
                                    Result  := joDiff;
                                    
                                    MainForm.AddDebugMsg(' -> Response dwreload');
                                end else begin
                                    //自动触发Form的OnUndock事件
                                    if assigned(oForm.OnUnDock) then begin
                                        //取得事件执行前控件信息
                                        jaBefore  := _json(dwGetComponentInfos(oForm1));
                                        //执行oForm.OnUnDock事件
                                        oForm.OnUnDock(oForm,nil,nil,bTmp);
                                        //比较事件执行的控件信息，并取得返回值
                                        Result  := ProcessAfter(oForm1,'',jaBefore,giShunt);
                                    end else begin
                                        Result  := '{"m":"ok"}';
                                    end;
                                end;
                            except
                                iError  := -806;
                            end;
                        end;
                    //[mounted] 网页启动完成事件,对应窗体的OnMouseDown事件
                    end else if joData.m = 'mounted' then begin
                        //错误捕捉框架 -807
                        if iError = 0 then begin
                            try 
                                MainForm.AddDebugMsg(' -> Enter mounted');
                                //取得对应FORM
                                oForm     := dwGetFormByCID(joData.i);
                                if oForm = nil then begin
                                    MainForm.AddDebugMsg(' -> No event''s Form ');
                                    
                                    //发送回应
                                    Result  :=  '{"m":"no form"}';
                                    Exit;
                                end;
                                MainForm.AddDebugMsg(' -> Get Form');
                                //__javascript用于保存一些信息, 所以先清空
                                dwSetProp(oForm,'__javascript','');
                                if Assigned(oForm.OnMouseDown) then begin
                                    jaBefore    := _json(dwGetComponentInfos(oForm));
                                    //iTmp        := jaBefore._Count;
                                    oForm.OnMouseDown(oForm,mbOrient,dwPlatFormToShiftState(iOS),iWidth,iHeight);
                                    
                                    //清除以避免重复执行
                                    oForm.OnMouseDown   := nil;
                                    
                                    //处理后续
                                    Result  := (ProcessAfter(oForm,'',jaBefore,giShunt));
                                end else begin
                                    Result  := '{"m":"ok"}';
                                end;
                            except
                                iError  := -807;
                            end;
                        end;
                    //[event] === 控件事件 说明 : 用户触发事件,如:Button.OnClick等 ===
                    end else if joData.m = 'event' then begin
                        //错误捕捉框架 -808
                        if iError = 0 then begin
                            try 
                                MainForm.AddDebugMsg(' -> Enter event');
                                //取得对应FORM
                                oForm     := dwGetFormByCID(joData.i);
                                if oForm = nil then begin
                                    MainForm.AddDebugMsg(' -> No event''s Form ');
                                    
                                    //未找到窗体的情况下，发送一个刷新
                                    joDiff    := _json('{}');
                                    joDiff.m  := 'update';
                                    joDiff.o  := 'location.reload();';  //2025-07-26 恢复
                                    joDiff.o  := '';
                                    
                                    //发送回应
                                    Result  := (joDiff);
                                    
                                    MainForm.AddDebugMsg(' -> Response dwreload');
                                    Exit;
                                end;
                                //处理时设置oForm为busy. 设置TipMode=tipClose, 以防止多次执行事件导致宕机
                                try 
                                    MainForm.AddDebugMsg(' -> Get Form');
                                    if oForm.TipMode = tipClose then begin
                                        MainForm.AddDebugMsg(' -> oForm is busy ');
                                        
                                        //未找到窗体的情况下，发送一个空回复
                                        joDiff    := _json('{}');
                                        joDiff.m  := 'none';
                                        joDiff.o  := '';  
                                        joDiff.o  := '';
                                        
                                        //发送回应
                                        Result  := (joDiff);
                                        
                                        MainForm.AddDebugMsg(' -> oForm is busy');
                                        Exit;
                                    end else begin
                                        //设置当前Form为忙的标识 TipMode   := tipClose;
                                        oForm.TipMode   := tipClose;
                                    end;
                                    //HelpFile用于保存一些信息, 所以先清空
                                    oForm.HelpFile := '';
                                    //根据事件来源分别处理
                                    if joData.c = '_screen' then begin
                                        //joData.c = '_screen' 表示为屏幕事件, 一般是旋转了
                                        //运行事件,主要用于做多操作系统(iPhone,Android,PC)适配
                                        if Assigned(oForm.OnMouseUp) then begin
                                            //从JSON对象中取得相应屏幕属性
                                            //默认PC
                                            iOS  := 1;
                                            if joData.Exists('os') then begin
                                                iOS       := joData.os;
                                            end;
                                            iWidth    := joData.width;
                                            iHeight   := joData.height;
                                            sOrient   := joData.orientation;
                                            iOrient   := StrToIntDef(sOrient,0);
                                            if iOrient in [0,180] then begin
                                                mbOrient  := mbLeft;
                                            end else begin
                                                mbOrient  := mbRight;
                                            end;
                                            joTemp  := dwJson(oForm.Hint);
                                            //
                                            joTemp.os               := Integer(iOS);
                                            //joTemp.screenwidth      := Integer(joData.screenwidth);
                                            //joTemp.screenheight     := Integer(joData.screenheight);
                                            joTemp.innerwidth       := Integer(joData.innerwidth);
                                            joTemp.innerheight      := Integer(joData.innerheight);
                                            joTemp.clientwidth      := Integer(joData.clientwidth);
                                            joTemp.clientheight     := Integer(joData.clientheight);
                                            joTemp.availwidth       := Integer(joData.availwidth);
                                            joTemp.availheight       := Integer(joData.availheight);
                                            joTemp.bodywidth        := Integer(joData.bodywidth);
                                            joTemp.bodyheight       := Integer(joData.bodyheight);
                                            joTemp.orientation      := String(joData.orientation);
                                            joTemp.devicepixelratio := Double(joData.devicepixelratio);
                                            joTemp.truewidth        := joData.screenwidth*joData.devicepixelratio;
                                            joTemp.trueheight       := joData.screenheight*joData.devicepixelratio;
                                            //
                                            oForm.Hint  := String(joTemp);
                                            if (oForm.Parent<>nil) and (LowerCase(Copy(oForm.ClassName,1,5))='tform') then begin
                                                jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Owner)));
                                            end else if (oForm.Parent<>nil) then begin
                                                jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Parent.Owner)));
                                            end else begin
                                                jaBefore  := _json(dwGetComponentInfos(oForm));
                                            end;
                                            //执行事件
                                            if Assigned(oForm.OnMouseUp) then begin
                                                oForm.OnMouseUp(oForm,mbOrient,dwPlatFormToShiftState(iOS),iWidth,iHeight);
                                            end;
                                            //处理后续
                                            Result  := ProcessAfter(oForm,'',jaBefore,giShunt);
                                        end else begin
                                            Result  := '{"m":"ok"}';
                                        end;
                                    end else if joData.c = '_cookie' then begin
                                        sHint     := oForm.Hint;
                                        joHint    := _json('{}');
                                        if dwStrIsJson(sHint) then begin
                                            joHint    := _json(sHint);
                                        end;
                                        if not joHint.Exists('_cookies') then begin
                                            joHint._cookies := _json('[]');
                                        end;
                                        joTemp  := _json('{}');
                                        joTemp.name     := string(joData.name);
                                        joTemp.value    := String(joData.v);
                                        joHint._cookies.Add(joTemp);
                                        
                                        
                                        //
                                        oForm.Hint     := joHint;
                                        //
                                        Result  := ('{"m":"ok"}');
                                    end else if joData.c = '_scroll' then begin
                                        if Assigned(oForm.OnHelp) then begin
                                            //取得事件执行前控件信息 (区分是否第一窗体还是嵌入窗体分开处理)
                                            if (oForm.Parent<>nil) and (LowerCase(Copy(oForm.ClassName,1,5))='tform') then begin
                                                jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Owner)));
                                            //2021-07-26为了嵌入FORM增加
                                            end else if (oForm.Parent<>nil) then begin
                                                jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Parent.Owner)));
                                            end else begin
                                                jaBefore  := _json(dwGetComponentInfos(oForm));
                                            end;
                                            //执行事件
                                            oForm.OnHelp(0,Round(StrToFloatDef(joData.v,0)),bTmp);
                                            //处理后续
                                            Result  := ProcessAfter(oForm,'',jaBefore,giShunt);
                                        end else begin
                                            Result  := ('{"m":"ok"}');
                                        end;
                                    end else begin
                                        //此时为其他控件激活的事件
                                        //控件的ClassName, 使用此变量主要为了解决当为Form时其类名不是TForm,而可能是TForm2
                                        sClass := '';
                                        //如果事件源控件是窗体
                                        if LowerCase(oForm.Name) = LowerCase(joData.c) then begin
                                            MainForm.AddDebugMsg(' -> Component is Form');
                                            oComp   := oForm;
                                            if oForm.HelpKeyword <> '' then begin
                                                sClass  := 'dwtform' + '__' + oForm.HelpKeyword+'.dll';
                                            end else begin
                                                sClass  := 'dwtform.dll';
                                            end;
                                            if ( joData.v = '__start__' ) then begin
                                                joTemp  := _json(oForm.Hint);
                                                if joTemp = unassigned then begin
                                                    joTemp  := _json('{"__uploadsources":[],"__uploadfiles":[]}');
                                                    oForm.Hint  := joTemp;
                                                end else begin
                                                    if joTemp.Exists('__uploadsources') then begin
                                                        joTemp.delete('__uploadsources');
                                                    end;
                                                    if joTemp.Exists('__uploadfiles') then begin
                                                        joTemp.delete('__uploadfiles');
                                                    end;
                                                    joTemp.__uploadsources  := _json('[]');
                                                    joTemp.__uploadfiles    := _json('[]');
                                                    oForm.Hint  := joTemp;
                                                end;
                                            end;
                                        end else if ( joData.v = '__success__' ) then begin
                                            MainForm.AddDebugMsg(' -> Component is Upload Form');
                                            oComp   := oForm;
                                            sClass  := 'dwtform.dll';
                                        end else if ( joData.v = '__start__upload__' ) then begin
                                            MainForm.AddDebugMsg(' -> Start Upload... ');
                                            oComp   := oForm;
                                            sClass  := 'dwtform.dll';
                                        end else if ( joData.v = '__end__upload__' ) then begin
                                        end else begin
                                            MainForm.AddDebugMsg(' -> Component is not Form');
                                            oComp   := oForm.FindComponent(joData.c);
                                            //如果oComp为nil,则找第二个窗体的控件，form2_1__button1
                                            if (oComp = nil) and (Pos(LowerCase(oForm.Name)+'__',joData.c)>0) then begin
                                                MainForm.AddDebugMsg(' -> Component in sub Form');
                                                sTmp    := joData.c;                        //得到完整名称，类似form2_1__button1
                                                Delete(sTmp,1,Length(oForm.Name+'__'));     //删除前面的，得到类似button1
                                                oComp     := oForm.FindComponent(sTmp);     //在窗体中找控件button1
                                            end;
                                            //如果不为nil，则取得类名备用
                                            if oComp <> nil then begin
                                                MainForm.AddDebugMsg(' -> Component is not nil');
                                                sClass  := dwGetCompDllName(oComp);
                                                //将当前事件的发起控件名称保存到其父窗体的Hint中，以备用
                                                dwSetProp(oForm,'__eventcomponent',dwFullName(oComp));
                                            end;
                                        end;
                                        //取得事件执行前控件信息 (区分是否第一窗体还是嵌入窗体分开处理)
                                        if (oForm.Parent<>nil) and (LowerCase(Copy(oForm.ClassName,1,5))='tform') then begin
                                            jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Owner)));
                                        end else if (oForm.Parent<>nil) then begin
                                            jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Parent.Owner)));
                                        end else begin
                                            jaBefore  := _json(dwGetComponentInfos(oForm));
                                        end;
                                        //更新控件值
                                        if oComp <> nil then begin
                                            MainForm.AddDebugMsg(' -> Get Component');
                                            
                                            if grDWVclNames.TryGetValue(sClass,iDWVcl) then begin
                                                MainForm.AddDebugMsg(' -> Enter Process : '+grDWVcls[iDWVcl].DllName);
                                                //joData.e = '_update' 用于手动更新服务端控件属性
                                                if joData.e = '_update' then begin
                                                    if oComp.ClassName = 'TLabel' then begin
                                                        
                                                        TLabel(oComp).Caption := dwUnescape(joData.v);
                                                        joData.e    := 'onclick';
                                                    end else if oComp.ClassName = 'TPanel' then begin
                                                        
                                                        TPanel(oComp).Caption := dwUnescape(joData.v);
                                                        joData.e    := 'onclick';
                                                    end else if oComp.ClassName = 'TButton' then begin
                                                        
                                                        TButton(oComp).Caption := dwUnescape(joData.v);
                                                        joData.e    := 'onclick';
                                                    end;
                                                end;
                                                //为上传函数的OnStartDock事件增加一个标识
                                                if (oComp = oForm) and (joData.v='__start__') then begin
                                                    dwSetProp(oForm,'interactionmethod','__upload_start');
                                                end;
                                                
                                                //以下前两行原来位于 【执行控件事件】代码以后，但执行事件可以删除当前控件，造成异常，所以提前了
                                                sCompName   := dwPrefix(oComp)+oComp.Name;
                                                sCompClass  := oComp.ClassName;    //得到控件类型，原因同上
                                                //执行控件事件
                                                grDWVcls[iDWVcl].GetEvent(TControl(oComp),joData);
                                                //
                                                MainForm.AddDebugMsg(' -> After GetEvent : '+grDWVcls[iDWVcl].DllName);
                                                if ( joData.v = '__start__' ) or ( joData.v = '__success__' ) then begin
                                                    if oForm.Owner = nil then begin
                                                        Result  := ProcessAfter(oForm,'',jaBefore,giShunt);
                                                    end else begin
                                                        Result  := ProcessAfter(TForm(oForm.Owner),'',jaBefore,giShunt);
                                                    end;
                                                end else begin
                                                    Result  := ProcessAfter(oForm,'',jaBefore,giShunt);
                                                end;
                                                MainForm.AddDebugMsg(' -> Get ProcessAfter : '+grDWVcls[iDWVcl].DllName);
                                            end else begin
                                                MainForm.AddDebugMsg(' -> TryGetValues false : '+sClass);
                                            end;
                                        end;
                                    end;
                                finally
                                    //移除当前Form为忙的标识 TipMode   := tipDontCare;
                                    oForm.TipMode   := tipDontCare;
                                end;
                            except
                                iError  := -808;
                            end;
                        end;
                    //[interaction] 处理与CLIENT交互事件 用户交互等事件, 如 inputquery, messagedlg
                    end else if joData.m = 'interaction' then begin
                        //错误捕捉框架 -809
                        if iError = 0 then begin
                            try 
                                //取得对应FORM的控件值
                                oForm     := dwGetFormByCID(joData.i);
                                if oForm = nil then begin
                                    Exit;
                                end;
                                //取得事件执行前控件信息 (区分是否第一窗体还是嵌入窗体分开处理)
                                if (oForm.Parent<>nil) and (LowerCase(Copy(oForm.ClassName,1,5))='tform') then begin
                                    jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Owner)));
                                //2021-07-26为了嵌入FORM增加
                                end else if (oForm.Parent<>nil) then begin
                                    jaBefore  := _json(dwGetComponentInfos(TForm(oForm.Parent.Owner)));
                                end else begin
                                    jaBefore  := _json(dwGetComponentInfos(oForm));
                                end;
                                //执行事件
                                dwSetProp(oForm,'interactionmethod', joData.t);   //用于区别多个事件
                                dwSetProp(oForm,'interactionvalue', joData.v);    //当前事件的返回值
                                if Assigned(oForm.OnStartDock) then begin
                                    oForm.OnStartDock(nil,oDock);
                                end;
                                //综合过程After
                                Result  := ProcessAfter(oForm,'',jaBefore,giShunt);
                            except
                                iError  := -809;
                            end;
                        end;
                    //[onmouseup] 用来发送设备参数
                    end else if joData.m = 'onmouseup' then begin
                        //错误捕捉框架 -810
                        if iError = 0 then begin
                            try 
                                MainForm.AddDebugMsg(' -> Enter onmouseup');
                                //取得对应FORM
                                oForm     := dwGetFormByCID(joData.i);
                                MainForm.AddDebugMsg(' -> Form geted');
                                if oForm = nil then begin
                                    //改造由于小程序回退造成的onmouseup事件中的相关参数
                                    sPath   := joData.fullurl;
                                    while pos('/',sPath)>0 do begin
                                        Delete(sPath,1,Pos('/',sPath));
                                    end;
                                    sPath   := ChangeFileExt(sPath,'.dw');
                                    //因SEO，此处直接生成HTML
                                    //生成对象joPara(包含各种参数)
                                    MainForm.AddDebugMsg(' -> Enter Create SEO HTML');
                                    
                                    //截取名称(删除后面的.dw)
                                    sName     := Copy(sPath,1,Length(sPath)-3);  //删除后面的.dw
                                    
                                    //生成对象(包含各种参数)
                                    TDocVariant.New(joPara);
                                    joPara.m                := 'init';
                                    joPara.params           := ClientCnx.Params;
                                    joPara.dwclass          := sName;
                                    joPara.shuntflag        := giShunt; //分流标志, 用于多个NG反代时负载平衡
                                    joPara.requestuseragent := ClientCnx.RequestUserAgent;
                                    joPara.requesthost      := ClientCnx.RequestHost;
                                    joPara.requesthostname  := ClientCnx.RequestHostName;
                                    joPara.requesthostport  := ClientCnx.RequestHostPort;
                                    MainForm.AddDebugMsg(' -> Start Load Apps dll');
                                    
                                    //指定hInst默认值，代表没有打开任何应用
                                    hInst     := 0;
                                    
                                    //取得DLL文件名
                                    sDll    := gsMainDir+'Apps\'+sName+'.dll';
                                    sHot    := gsMainDir+'Apps\Hot\'+sName+'.dll';
                                    //延迟热加载处理 FileExists(sDll)
                                    if FileExists(sDll) then begin
                                        sLast   := sDll;
                                        dtApp   := dwGetFileTime(sDll,FILE_MODIFY_TIME);
                                        for iHot := 1 to 10 do begin
                                            sHot    := gsMainDir+'Apps\'+sName+'__'+IntToStr(iHot)+'.dll';
                                            if FileExists(sHot) then begin
                                                if dwGetFileTime(sHot,FILE_MODIFY_TIME) > dtApp then begin
                                                    dtApp   := dwGetFileTime(sHot,FILE_MODIFY_TIME);
                                                    sLast   := sHot;
                                                end;
                                            end;
                                        end;
                                        if sLast <> sDll then begin
                                            if DeleteFile(sDll) then begin
                                                if CopyFile(PChar(sLast),PChar(sDll),False) then begin
                                                    sLast   := sDll;
                                                end;
                                            end;
                                        end;
                                        hInst  := LoadLibrary(PChar(sLast));
                                        //删除老的应用
                                        for iHot := 1 to 10 do begin
                                            DeleteFile(gsMainDir+'Apps\'+sName+'__'+IntToStr(iHot)+'.dll');
                                        end;
                                    end;
                                    //得到函数地址
                                    fLoad   := GetProcAddress(hInst,'dwLoad');
                                    //默认返回gsErrorHtml;
                                    sResp    := gsErrorHtml;
                                    //载入结果判断
                                    if (hInst <> 0) and  Assigned( fLoad) then begin
                                        MainForm.AddDebugMsg('0 Assigned fLoad.');
                                        //创建Form
                                        //重新设置一下目录,以防出错
                                        SetCurrentDir(gsMainDir);
                                        
                                        //
                                        iFormCount := Screen.FormCount;               
                                        
                                        // 调用函数
                                        oForm     := fLoad(_J2S(gjoConnections),
                                            TFDConnection(MainForm.FindComponent('FDConnection_0_'+IntToStr(Random(5)))).CliHandle,
                                            Application,
                                            Screen);
                                        
                                        //
                                        MainForm.AddDebugMsg('0 fLoad Success.');
                                        if iFormCount = Screen.FormCount then begin
                                            //创建Form
                                            oForm     := fLoad(_J2S(gjoConnections),
                                                TFDConnection(MainForm.FindComponent('FDConnection_0_'+IntToStr(Random(5)))).CliHandle,
                                                Application,
                                                Screen);
                                            
                                            //
                                            MainForm.AddDebugMsg('0 fLoad 2 times.');
                                        end;
                                        //设置Form属性
                                        //合并Hint
                                        oForm.Hint     := dwCombineJson(oForm.Hint,joPara);
                                        
                                        //强制AllphiBlend,以生成心跳包
                                        oForm.AlphaBlend    := False;
                                        
                                        //
                                        MainForm.AddDebugMsg('1 dwCombineJson Success.');
                                        
                                        joTemp  := dwJson(oForm.Hint);
                                        //保存DLL句柄 (到 hint)
                                        joTemp.DllHandle := IntToStr(hInst);
                                        
                                        //
                                        MainForm.AddDebugMsg('2 dwSetProp Success.');
                                        
                                        //将相应屏幕属性写入HINT以遗传给二次打开的窗体
                                        joTemp.params    := TIdURI.URLDecode(joPara.params);
                                        joTemp.shuntflag := IntToStr(giShunt);
                                        joTemp.gethtmlheight := IntToStr(Integer(@dwsGetHtmlLabelHeight));
                                        
                                        oForm.Hint  := String(joTemp);
                                        MainForm.AddDebugMsg('3 dwSetProp Success.');
                                        
                                        //隐藏FORM
                                        oForm.ParentWindow  := MainForm.Panel_Forms.Handle;
                                        
                                        //
                                        MainForm.AddDebugMsg('4 Hide Form Success.');
                                        
                                        //标记为网页应用窗体
                                        oForm.ScreenSnap    := True;       //
                                        
                                        //
                                        MainForm.AddDebugMsg('5 dwSetProp Success.');
                                        
                                        //更新Cookie
                                        dwSetFormCookies(oForm,ClientCnx.RequestCookies);
                                        
                                        //
                                        oForm.Show;
                                        
                                        //
                                        MainForm.AddDebugMsg('6 oForm.Showed .');
                                        //运行事件,主要用于做多操作系统(iPhone,Android,PC)适配
                                        if Assigned(oForm.OnMouseUp) then begin
                                            //需要设置一些属性才能执行一般在OnMouseUp中执行的dwSetMobileMode等
                                            joTemp  := dwJson(oForm.Hint);
                                            //
                                            joTemp.orientation      := String(joData.orientation);
                                            joTemp.screenwidth      := Integer(joData.screenwidth);
                                            joTemp.screenheight     := Integer(joData.screenheight);
                                            joTemp.clientwidth      := Integer(joData.clientwidth);
                                            joTemp.clientheight     := Integer(joData.clientheight);
                                            //
                                            oForm.Hint  := String(joTemp);
                                            oForm.OnMouseUp(oForm,mbOrient,dwPlatFormToShiftState(iOS),iWidth,iHeight);
                                        end;
                                        //用SnapBuffer来表示失效时间，HelpContext用来标志DLL的load句柄
                                        oForm.SnapBuffer    := Round((Now-gfStartTime)*24*3600) + giExpire ;
                                        oForm.HelpContext   := hInst;
                                        //***根据Form生成网页(此时一些信息还未输入, 比如caption, handle等)
                                        MainForm.AddDebugMsg('7 Before dwFormToHtml.');
                                        sResp     := dwFormToHtml(oForm);
                                        MainForm.AddDebugMsg('8 After dwFormToHtml.');
                                        //替换关键内容
                                        sResp     := StringReplace(sResp,'[!caption!]',oForm.Caption,[rfReplaceAll]);
                                        sResp     := StringReplace(sResp,'[!classname!]',oForm.ClassName,[rfReplaceAll]);
                                        sResp     := StringReplace(sResp,'[!handle!]',IntToStr(oForm.Handle),[rfReplaceAll]);
                                        sResp     := StringReplace(sResp,'[!shuntflag!]',IntToStr(giShunt),[rfReplaceAll]);
                                        sResp     := StringReplace(sResp,'[!resource!]',gsResource[giResource],[rfReplaceAll]);
                                        MainForm.AddDebugMsg('9 After StringReplace.');
                                        //如果调试状态，则保存为_dwtemp.html
                                        if MainForm.PageControl.ActivePage = MainForm.TabSheet_Debug then begin
                                            slDebug   := TStringList.Create;
                                            slDebug.Text   := sResp;
                                            slDebug.SaveToFile('_dwtemp.html',TEncoding.UTF8);
                                            FreeAndNil(slDebug);
                                            //
                                            MainForm.AddDebugMsg('10 After SaveToFile.');
                                        end;
                                    end else begin
                                        if (hInst = 0) then begin
                                            MainForm.AddDebugMsg(' -> error at : hInst = 0. (2)'+ IntToStr(GetLastError));
                                        end else begin
                                            MainForm.AddDebugMsg(' -> error at : not Assigned( fLoad). (2)');   
                                        end;
                                    end;
                                    //生成返回值字符串
                                    MainForm.AddDebugMsg('11 Before joPara.');
                                    
                                    //发送回应
                                    joPara      := _json('{}');
                                    joPara.m    := 'recreate';
                                    joPara.o    := sResp;
                                    Result      := joPara;
                                    
                                    //
                                    MainForm.AddDebugMsg('12 After SendResp.');
                                end else begin
                                    //将一些JSON变量处理为普通变量，以便后面调用
                                    iOS  := 1;
                                    if joData.Exists('os') then begin
                                        iOS       := joData.os;
                                    end;
                                    iWidth    := joData.screenwidth;
                                    iHeight   := joData.screenheight;
                                    sOrient   := joData.orientation;
                                    iOrient   := StrToIntDef(sOrient,0);
                                    if iOrient in [0,180] then begin
                                        mbOrient  := mbLeft;
                                    end else begin
                                        mbOrient  := mbRight;
                                    end;
                                    MainForm.AddDebugMsg(' -> params processed');
                                    //保存一些参数到Form的Hint
                                    joTemp  := dwJson(oForm.Hint);
                                    //
                                    joTemp.os               := Integer(joData.os);
                                    joTemp.canvasid         := String(joData.canvasid);
                                    joTemp.ua               := String(joData.ua);
                                    joTemp.fullurl          := TIdURI.URLDecode(joData.fullurl);
                                    joTemp.ip               := ClientCnx.GetPeerAddr;
                                    joTemp.screenwidth      := Integer(joData.screenwidth);
                                    joTemp.screenheight     := Integer(joData.screenheight);
                                    joTemp.innerwidth       := Integer(joData.innerwidth);
                                    joTemp.innerheight      := Integer(joData.innerheight);
                                    joTemp.clientwidth      := Integer(joData.clientwidth);
                                    joTemp.clientheight     := Integer(joData.clientheight);
                                    joTemp.availwidth       := Integer(joData.availwidth);
                                    joTemp.availheight       := Integer(joData.availheight);
                                    joTemp.bodywidth        := Integer(joData.bodywidth);
                                    joTemp.bodyheight       := Integer(joData.bodyheight);
                                    joTemp.orientation      := String(joData.orientation);
                                    joTemp.devicepixelratio := Double(joData.devicepixelratio);
                                    joTemp.shuntflag        := IntToStr(giShunt);
                                    joTemp.truewidth        := joData.screenwidth*joData.devicepixelratio;
                                    joTemp.trueheight       := joData.screenheight*joData.devicepixelratio;
                                    //
                                    oForm.Hint  := String(joTemp);
                                    MainForm.AddDebugMsg(' -> Params saved');
                                    jaBefore  := _json(dwGetComponentInfos(oForm));
                                    MainForm.AddDebugMsg(' -> jaBefore geted');
                                    //运行事件,主要用于做多操作系统(iPhone,Android,PC)适配
                                    if Assigned(oForm.OnMouseUp) then begin
                                        oForm.OnMouseUp(oForm,mbOrient,dwPlatFormToShiftState(iOS),iWidth,iHeight);
                                        MainForm.AddDebugMsg(' -> run onmouseup');
                                    end;
                                    
                                    //清空jaBefore， 以解决回退后不能恢复原状的bug 2023-09-02
                                    iCount      := jaBefore._Count;
                                    jaBefore    := _json('[]');
                                    for iTmp := 0 to iCount-1 do begin
                                        jaBefore.Add('');
                                    end;
                                    Result  := ProcessAfter(oForm,'',jaBefore,giShunt);
                                    MainForm.AddDebugMsg(' -> ProcessAfter success');
                                end;
                            except
                                iError  := -810;
                            end;
                        end;
                    end;
                end else begin
                    //错误捕捉框架 -820
                    if iError = 0 then begin
                        try 
                            if sPath = 'favicon.ico' then begin
                                MainForm.AddDebugMsg(' -> get favicon.ico');
                            end else if ExtractFileExt(sPath)='' then begin
                                if FileExists(gsMainDir+'apps\'+sPath+'.dll') then begin
                                    MainForm.AddDebugMsg('-> get app');
                                    sPath     := sPath + '.dw';
                                end else begin
                                    MainForm.AddDebugMsg('-> get app but not exists');
                                end;
                            //此情况为直接交互模式
                            end else if ExtractFileExt(LowerCase(sPath)) = '.dll' then begin
                                sTmp := gsMainDir+'apps\'+sPath;
                                if FileExists(sTmp) then begin
                                    MainForm.AddDebugMsg('-> get direct api dll');
                                    try 
                                        //载入DLL
                                        hInst     := LoadLibrary(PChar(sTmp));
                                        //取得函数
                                        fDirect   := GetProcAddress(hInst,'dwDirectInteraction');
                                        //得到参数
                                        sParams   := ClientCnx.Params;
                                        //执行函数，取得返回值
                                        sResp     := String(fDirect(PWideChar(sParams)));
                                        //发送回应
                                        Result  := (sResp);
                                        //用于对直接函数输出，根据设置json=1确定输出格式
                                        if Pos('json=1',sParams)>0 then begin
                                            gsContType  := 'application/json';
                                        end;
                                    finally
                                        FreeLibrary(hInst);
                                    end;
                                end else begin
                                    Result  := ('no library');
                                end;
                                Exit;
                            end else if ExtractFileExt(LowerCase(sPath)) = '.wx' then begin
                                sTmp    := gsMainDir+'apps\'+sPath;
                                sTmp    := ChangeFileExt(sTmp,'.dll');
                                if FileExists(sTmp) then begin
                                    try 
                                        //得到post的数据
                                        sPost   := '';
                                        if ClientCnx.RequestContentLength > 0 then begin
                                            ClientCnx.ReceiveStr;
                                            //Flags := hgAcceptData;
                                            // We wants to receive any data type. So we turn line mode off on
                                            // client connection.
                                            ClientCnx.LineMode := FALSE;
                                            // We need a buffer to hold posted data. We allocate as much as the
                                            // size of posted data plus one byte for terminating nul char.
                                            // We should check for ContentLength = 0 and handle that case...
                                            Remains := ClientCnx.RequestContentLength + 2;
                                            //=== 以下几行代码
                                            
                                            pData   := AnsiStrAlloc(Remains);
                                            //Clear received length
                                            //ClientCnx.FDataLen := 0;
                                            ClientCnx.Receive(pData,Remains);
                                            //pData[Remains]  := #0;
                                            
                                            //
                                            sPost   := StrPas(pData);
                                            sPost   := Copy(sPost,1,Remains);
                                            sPost   := DecodeUtf8Str(sPost);
                                            
                                            StrDispose(pData);
                                        end;
                                        MainForm.AddDebugMsg('-> get direct api dll,postdata = '+sPost);
                                        //载入DLL
                                        hInst     := LoadLibrary(PChar(sTmp));
                                        //取得函数
                                        fDirect   := GetProcAddress(hInst,'dwDirectInteraction');
                                        //
                                        joResp := _json('{}');
                                        joResp.data         := ClientCnx.Params;
                                        //joResp.params   := ClientCnx.Params;
                                        //joResp.data     := sPost;
                                        //发送回应
                                        //Result  := joResp;
                                        //joData.data := sPost;
                                        
                                        //执行函数，取得返回值
                                        sResp     := String(fDirect(PWideChar(String(joResp))));
                                        //发送回应
                                        Result  := sResp;
                                        //用于对直接函数输出，根据设置json=1确定输出格式
                                        if Pos('json=1',ClientCnx.Params)>0 then begin
                                            gsContType  := 'application/json';
                                        end;
                                    finally
                                        FreeLibrary(hInst);
                                    end;
                                end else begin
                                    Result  := 'no library';
                                end;
                                Exit;
                            end;
                        except
                            iError  := -820;
                        end;
                    end;
                    //错误捕捉框架 -821
                    if iError = 0 then begin
                        try 
                            if Pos('.dw',LowerCase(sPath)) > 0 then begin
                                //因SEO，此处直接生成HTML
                                //生成对象joPara(包含各种参数)
                                MainForm.AddDebugMsg(' -> Enter Create SEO HTML');
                                
                                //截取名称(删除后面的.dw)
                                sName     := Copy(sPath,1,Length(sPath)-3);  //删除后面的.dw
                                
                                //生成对象(包含各种参数)
                                TDocVariant.New(joPara);
                                joPara.m                := 'init';
                                joPara.params           := ClientCnx.Params;
                                joPara.dwclass          := sName;
                                joPara.shuntflag        := giShunt; //分流标志, 用于多个NG反代时负载平衡
                                joPara.requestuseragent := ClientCnx.RequestUserAgent;
                                joPara.requesthost      := ClientCnx.RequestHost;
                                joPara.requesthostname  := ClientCnx.RequestHostName;
                                joPara.requesthostport  := ClientCnx.RequestHostPort;
                                MainForm.AddDebugMsg(' -> Start Load Apps dll');
                                
                                //指定hInst默认值，代表没有打开任何应用
                                hInst     := 0;
                                
                                //取得DLL文件名
                                sDll    := gsMainDir+'Apps\'+sName+'.dll';
                                sHot    := gsMainDir+'Apps\Hot\'+sName+'.dll';
                                //延迟热加载处理 FileExists(sDll)
                                if FileExists(sDll) then begin
                                    sLast   := sDll;
                                    dtApp   := dwGetFileTime(sDll,FILE_MODIFY_TIME);
                                    for iHot := 1 to 10 do begin
                                        sHot    := gsMainDir+'Apps\'+sName+'__'+IntToStr(iHot)+'.dll';
                                        if FileExists(sHot) then begin
                                            if dwGetFileTime(sHot,FILE_MODIFY_TIME) > dtApp then begin
                                                dtApp   := dwGetFileTime(sHot,FILE_MODIFY_TIME);
                                                sLast   := sHot;
                                            end;
                                        end;
                                    end;
                                    if sLast <> sDll then begin
                                        if DeleteFile(sDll) then begin
                                            if CopyFile(PChar(sLast),PChar(sDll),False) then begin
                                                sLast   := sDll;
                                            end;
                                        end;
                                    end;
                                    hInst  := LoadLibrary(PChar(sLast));
                                    //删除老的应用
                                    for iHot := 1 to 10 do begin
                                        DeleteFile(gsMainDir+'Apps\'+sName+'__'+IntToStr(iHot)+'.dll');
                                    end;
                                end;
                                //得到函数地址
                                fLoad   := GetProcAddress(hInst,'dwLoad');
                                //默认返回gsErrorHtml;
                                sResp    := gsErrorHtml;
                                //载入结果判断
                                if (hInst <> 0) and  Assigned( fLoad) then begin
                                    MainForm.AddDebugMsg('0 Assigned fLoad.');
                                    
                                    //为gjoConnections增加当前应用的一些参数
                                    if not gjoConnections.Exists('app') then begin
                                        gjoConnections.app  := _json('{}');
                                    end;
                                    gjoConnections.app.name     := sName;
                                    gjoConnections.app.params   := ClientCnx.Params;
                                    //创建Form
                                    //重新设置一下目录,以防出错
                                    SetCurrentDir(gsMainDir);
                                    
                                    //
                                    iFormCount := Screen.FormCount;               

                                    //
                                    MainForm.AddDebugMsg('0 fLoad before.');

                                    // 调用函数
                                    oForm     := fLoad(_J2S(gjoConnections),
                                        TFDConnection(MainForm.FindComponent('FDConnection_0_'+IntToStr(Random(5)))).CliHandle,
                                        Application,
                                        Screen);
                                    
                                    //
                                    MainForm.AddDebugMsg('0 fLoad Success.');
                                    if iFormCount = Screen.FormCount then begin
                                        //创建Form
                                        oForm     := fLoad(_J2S(gjoConnections),
                                            TFDConnection(MainForm.FindComponent('FDConnection_0_'+IntToStr(Random(5)))).CliHandle,
                                            Application,
                                            Screen);
                                        
                                        //
                                        MainForm.AddDebugMsg('0 fLoad 2 times.');
                                    end;
                                    //设置Form属性
                                    //合并Hint
                                    oForm.Hint     := dwCombineJson(oForm.Hint,joPara);
                                    
                                    //强制AllphiBlend,以生成心跳包
                                    oForm.AlphaBlend    := False;
                                    
                                    //
                                    MainForm.AddDebugMsg('1 dwCombineJson Success.');
                                    
                                    joTemp  := dwJson(oForm.Hint);
                                    //保存DLL句柄 (到 hint)
                                    joTemp.DllHandle        := IntToStr(hInst);
                                    
                                    //将相应屏幕属性写入HINT以遗传给二次打开的窗体
                                    joTemp.params           := TIdURI.URLDecode(joPara.params);
                                    joTemp.shuntflag        := IntToStr(giShunt);
                                    joTemp.gethtmlheight    := IntToStr(Integer(@dwsGetHtmlLabelHeight));
                                    
                                    oForm.Hint  := String(joTemp);
                                    
                                    MainForm.AddDebugMsg('2 dwSetProp Success.');
                                    
                                    //隐藏FORM
                                    oForm.ParentWindow  := MainForm.Panel_Forms.Handle;
                                    
                                    //
                                    MainForm.AddDebugMsg('3 Hide Form Success.');
                                    
                                    //标记为网页应用窗体
                                    oForm.ScreenSnap    := True;       //
                                    
                                    //
                                    MainForm.AddDebugMsg('4 dwSetProp Success.');
                                    
                                    //更新Cookie
                                    dwSetFormCookies(oForm,ClientCnx.RequestCookies);
                                    
                                    //
                                    bTmp    := oForm.Docksite;
                                    oForm.Show;
                                    oForm.DockSite  := bTmp;
                                    
                                    //
                                    MainForm.AddDebugMsg('5 oForm.Showed .');
                                    //用SnapBuffer来表示失效时间，HelpContext用来标志DLL的load句柄
                                    oForm.SnapBuffer    := Round((Now-gfStartTime)*24*3600) + giExpire ;
                                    oForm.HelpContext   := hInst;
                                    //***根据Form生成网页(此时一些信息还未输入, 比如caption, handle等)
                                    MainForm.AddDebugMsg('7 Before dwFormToHtml.');
                                    sResp     := dwFormToHtml(oForm);
                                    MainForm.AddDebugMsg('8 After dwFormToHtml.');
                                    //替换关键内容
                                    sResp     := StringReplace(sResp,'[!caption!]',oForm.Caption,[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!classname!]',oForm.ClassName,[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!handle!]',IntToStr(oForm.Handle),[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!shuntflag!]',IntToStr(giShunt),[rfReplaceAll]);
                                    sResp     := StringReplace(sResp,'[!resource!]',gsResource[giResource],[rfReplaceAll]);
                                    MainForm.AddDebugMsg('9 After StringReplace.');
                                    //如果调试状态，则保存为_dwtemp.html
                                    if MainForm.PageControl.ActivePage = MainForm.TabSheet_Debug then begin
                                        slDebug   := TStringList.Create;
                                        slDebug.Text   := sResp;
                                        slDebug.SaveToFile('_dwtemp.html',TEncoding.UTF8);
                                        FreeAndNil(slDebug);
                                        //
                                        MainForm.AddDebugMsg('10 After SaveToFile.');
                                    end;
                                end else begin
                                    if (hInst = 0) then begin
                                        MainForm.AddDebugMsg(' -> error at : hInst = 0. (3) '+ IntToStr(GetLastError));
                                    end else begin
                                        MainForm.AddDebugMsg(' -> error at : not Assigned( fLoad). (3)');   
                                    end;
                                end;
                                //生成返回值字符串
                                MainForm.AddDebugMsg('11 Before joPara.');
                                
                                //发送回应
                                Result  := sResp;
                                
                                //
                                MainForm.AddDebugMsg('12 After SendResp.');
                            end else begin
                                MainForm.AddDebugMsg(' -> Exist without response');
                            end;
                        except
                            iError  := -821;
                        end;
                    end;
                end;
            except
                if iError = 0 then begin
                    iError  := -80;
                end;
            end;
        end;
        //输出调试信息：try异常
        MainForm.AddDebugMsg(' -> End of dwProcessData '+IntToStr(iError));
    except
        //输出调试信息：try异常
        MainForm.AddDebugMsg(' -> Except when dwProcessData '+IntToStr(iError));
    end;
end;

end.