unit dwBase;

interface

uses
     //第三方
     //SynCommons{用于解析JSON},
     JsonDataObjects,


     //求MD5
     IdHashMessageDigest,IdGlobal, IdHash,


     //系统单元
     Buttons,
     HTTPApp, Dialogs, ComCtrls,Math,DateUtils,typinfo,Variants,
     Windows, Messages, SysUtils, Classes, Controls, Forms,Graphics,
     StdCtrls, ExtCtrls, StrUtils, Grids,Types,
     IniFiles,   Menus,  ShellAPI, FileCtrl ;

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
function  dwSetCookie(AForm:TForm;AName,AValue:String;AExpireHours:Double):Integer;  //写cookie
function  dwPreGetCookie(AForm:TForm;AName,ANull:String):Integer;                    //预读cookie
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

//取得DLL名称
function dwGetDllName: string;

//执行一段JS代码，注意需要以分号结束
function dwRunJS(AJS:String;AForm:TForm):Boolean;

//快速IF
function dwIIF(ABool:Boolean;AYes,ANo:string):string;

//计算TimeLine的高度(参考)
function dwGetTimeLineHeight(APageControl:TPageControl):Integer;

//<转义可能出错的字符
function  dwChangeChar(AText:String):String;

//弹出窗体
function  dwShowModal(AForm,ASWForm:TForm):Integer;
function  dwCloseForm(AForm,ASWForm:TForm):Integer;

//计算手机可用高度
function  dwGetMobileAvailHeight(AForm:TForm):Integer;


implementation  //==============================================================

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
function  dwShowModal(AForm,ASWForm:TForm):Integer;
var
     sClass    : String;
     iCtrl     : Integer;
begin
     for iCtrl :=0 to AForm.ControlCount-1 do begin
          sClass    := LowerCase(AForm.Controls[iCtrl].ClassName);
          //
          if sClass = LowerCase(ASWForm.ClassName) then begin
               dwRunJS('this.'+AForm.Controls[iCtrl].Name+'__vis=true;',AForm);
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
function dwSetZXing(ACtrl:TControl;ACameraID:Integer):Integer;
var
     sJS       : string;
const
     _JS       : string = ''
(*
                    +#13'var easyUTF8 = function(gbk){'
                    +#13'    if(!gbk){return '''';}'
                    +#13'    var utf8 = [];'
                    +#13'    for(var i=0;i<gbk.length;i++){'
                    +#13'        var s_str = gbk.charAt(i);'
                    +#13'        if(!(/^%u/i.test(escape(s_str)))){utf8.push(s_str);continue;}'
                    +#13'        var s_char = gbk.charCodeAt(i);'
                    +#13'        var b_char = s_char.toString(2).split('''');'
                    +#13'        var c_char = (b_char.length==15)?[0].concat(b_char):b_char;'
                    +#13'        var a_b =[];'
                    +#13'        a_b[0] = ''1110''+c_char.splice(0,4).join('''');'
                    +#13'        a_b[1] = ''10''+c_char.splice(0,6).join('''');'
                    +#13'        a_b[2] = ''10''+c_char.splice(0,6).join('''');'
                    +#13'        for(var n=0;n<a_b.length;n++){'
                    +#13'            utf8.push(''%''+parseInt(a_b[n],2).toString(16).toUpperCase());'
                    +#13'        }'
                    +#13'    }'
                    +#13'    return utf8.join('''');'
                    +#13'};'
*)
                    +#13'let selectedDeviceId=%d;'
                    +#13'const codeReader = new ZXing.BrowserMultiFormatReader();'
				+#13'codeReader.reset();'
				+#13'codeReader.decodeFromVideoDevice(selectedDeviceId, ''%s'', (result, err) => {'
				+#13'	if (result) {'
				//+#13'		alert(result);'
				//+#13'		alert(decodeURI((result)));'
 				+#13'		axios.get(''{"m":"event","i":%d,"c":"%s","name":"%s","v":"''+(escape(result))+''"}'').then(resp =>{this.procResp(resp.data);},resp => {console.log("err");});'
				+#13'	}'
				+#13'})'
                    ;
begin
     sJS  := Format(_JS,[ACameraID,ACtrl.Name,TForm(ACtrl.Owner).Handle,ACtrl.Name,'onenddock']);
     //
     TForm(ACtrl.Owner).HelpFile   := TForm(ACtrl.Owner).HelpFile + sJS;
     //
     Result    := 0;
end;


function dwGetMD5(AStr:String):string;
var
     oMD5      : TIdHashMessageDigest5;
begin
     oMD5      := TIdHashMessageDigest5.Create;
     Result    := LowerCase(oMD5.HashStringAsHex(AStr));
     oMD5.Free;
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
function  dwSetCookie(AForm:TForm;AName,AValue:String;AExpireHours:Double):Integer;
var
     sCode     : string;
     sHint     : String;
     joHint    : TJsonObject;
begin
     sCode     := 'this.dwsetcookie("'+AName+'","'+AValue+'",1);';

     //
     AForm.HelpFile := AForm.HelpFile + sCode;

     //写到本地
     sHint     := AForm.Hint;
     joHint    := TJsonObject.Create;
     if (sHint<>'') then begin
          if (Copy(sHint,1,1) = '{') and (Copy(sHint,Length(sHint),1) = '}') then begin
               try
                    joHint    := TJsonObject(TJsonObject.Parse(sHint));
               except
                    joHint    := TJsonObject.Create;
               end;
          end;
     end;
     //
     if not joHint.Contains('_cookies') then begin
          joHint.O['_cookies']     := TJsonObject.Create;
     end;
     joHint.O['_cookies'].S[AName]  := AValue;
     AForm.Hint     := joHint.ToString;

     //
     joHint.Destroy;

     //
     Result    := 0;
end;

function  dwPreGetCookie(AForm:TForm;AName,ANull:String):Integer;                    //预读cookie
var
     sCode     : string;
     sHint     : String;
     joHint    : TJsonObject;
const
     sUpload   = 'axios.get(''{"m":"event","i":%d,"c":"_cookie","name":"%s","v":"''+res+''"}'');';
          //+'.then(resp =>{'
          //+'this.procResp(resp.data);'
          //+'},resp => {'
          //+'console.log("err");'
          //+'});';


begin
     //预置cookie空值到本地
     sHint     := AForm.Hint;
     joHint    := TJsonObject.Create;
     if (sHint<>'') then begin
          if (Copy(sHint,1,1) = '{') and (Copy(sHint,Length(sHint),1) = '}') then begin
               try
                    joHint    := TJsonObject(TJsonObject.Parse(sHint));
               except
                    joHint    := TJsonObject.Create;
               end;
          end;
     end;
     //
     if not joHint.Contains('_cookies') then begin
          joHint.O['_cookies']     := TJsonObject.Create;
     end;
     joHint.O['_cookies'].S[AName]  := ANull;
     AForm.Hint     := joHint.ToString;

     //
     //sCode     := 'var reg=new RegExp("(^| )"+'+AName+'+"=([^;]*)(;|$)");';
     //sCode     := sCode + 'var arr,res;if(arr=document.cookie.match(reg)) res = unescape(arr[2]); else res="'+ANull+'";console.log(res);';
     //sCode     := sCode + Format(sUpload,[AForm.Handle,AName]);

     //
     sCode     := 'var res=this.dwgetcookie("'+AName+'"); ';
     sCode     := sCode + Format(sUpload,[AForm.Handle,AName]);
     //
     AForm.HelpFile := AForm.HelpFile + sCode;

     //
     joHint.Destroy;

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
     joHint    : TJsonObject;
begin
     //
     sHint     := AForm.Hint;
     joHint    := TJsonObject.Create;
     if (sHint<>'') then begin
          if (Copy(sHint,1,1) = '{') and (Copy(sHint,Length(sHint),1) = '}') then begin
               try
                    joHint    := TJsonObject(TJsonObject.Parse(sHint));
               except
                    joHint    := TJsonObject.Create;
               end;
          end;
     end;
     //
     Result    := '';
     if joHint.Contains('_cookies') then begin
          Result    := dwUnicodeToChinese(HttpDecode(joHint.O['_cookies'].S[AName]));
     end;
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
     joHint    : TJsonObject;
begin
     sHint     := AControl.Hint;
     joHint    := TJsonObject.Create;
     if (sHint<>'') then begin
          if (Copy(sHint,1,1) = '{') and (Copy(sHint,Length(sHint),1) = '}') then begin
               joHint    := TJsonObject(TJsonObject.Parse(sHint));
          end;
     end;
     joHint.I['height']  := AHeight;
     AControl.Hint  := joHint.ToString;
     joHint.Destroy;
     //
     Result    := 0;
end;


procedure dwShowMessage(AMsg:String;AForm:TForm);
begin
     AMsg := StringReplace(AMsg,'''','\''',[rfReplaceAll]);
     dwShowMsg((AMsg),AForm.Caption,'OK',AForm);
end;

procedure dwShowMsg(AMsg,ACaption,AButtonCaption:String;AForm:TForm);
var
     sMsgCode  : string;
begin
     //处理sMsg
     AMsg := StringReplace(AMsg,#13,'\r\n',[rfReplaceAll]);
     AMsg := StringReplace(AMsg,#10,'',[rfReplaceAll]);

     //
     sMsgCode  := 'this.$alert(''%s'', ''%s'', { confirmButtonText: ''%s''});';
     sMsgCode  := Format(sMsgCode,[AMsg,ACaption,AButtonCaption]);
     AForm.HelpFile := AForm.HelpFile + sMsgCode;
end;


//MessageDlg
procedure dwMessageDlg(AMsg,ACaption,confirmButtonCaption,cancelButtonCaption,AMethedName:String;AForm:TForm);
var
     sMsgCode  : string;
const
     sConfirm  = 'axios.get(''{"m":"interaction","i":%d,"t":"%s","v":%d}'')'
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
     joHint    : TJsonObject;
begin
     //
     sHint     := ACtrl.Hint;

     //创建HINT对象, 用于生成一些额外属性
     joHint    := TJsonObject.Create;
     if ( sHint <> '' ) and ( Pos('{',sHint) >= 0 ) and ( Pos('}',sHint) > 0 ) then begin
          try
               joHint    := TJsonObject(TJsonObject.Parse(sHint));
          except
               joHint    := TJsonObject.Create;
          end;
     end;

     //
     Result    := joHint.S[AAttr];
     //
     joHint.Destroy;
end;

function dwSetProp(ACtrl:TControl;AAttr,AValue:String):Integer;
var
     sHint     : String;
     joHint    : TJsonObject;
begin
     Result    := 0;
     //
     sHint     := ACtrl.Hint;

     //创建HINT对象, 用于生成一些额外属性
     joHint    := TJsonObject.Create;
     if ( sHint <> '' ) and ( Pos('{',sHint) >= 0 ) and ( Pos('}',sHint) > 0 ) then begin
          try
               joHint.Parse(sHint);
          except
               joHint    := TJsonObject.Create;
          end;
     end;

     //如果当前存在该属性, 则先删除
     if joHint.Contains(AAttr) then begin
          joHint.Remove(AAttr);
     end;

     //添加属性
     joHint.S[AAttr]     := AValue;

     //返回到HINT字符串
     ACtrl.Hint     := joHint.ToString;

     //
     joHint.Destroy;
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
     while Length(S) > 0 do
     begin
          if S[1]<>'%' then
          begin
               Result    := Result + S[1];
               Delete(S,1,1);
          end
          else
          begin
               Delete(S,1,1);
               if S[1]='u' then
               begin
                    try
                         //Result    := Result + Chr(StrToInt('$'+Copy(S, 2, 2)))+ Chr(StrToInt('$'+Copy(S, 4, 2)));
                         i0   := StrToInt('$'+Copy(S, 2, 2));
                         i1   := StrToInt('$'+Copy(S, 4, 2));
                         Result    := Result + WideChar((i0 shl 8) or i1);
                    except
                         ShowMessage(Result);

                    end;
                    Delete(S,1,5);
               end
               else
               begin
                    try
                         Result    := Result + Chr(StrToInt('$'+Copy(S, 1, 2)));
                    except
                         ShowMessage(Result);

                    end;
                    Delete(S,1,2);
               end;
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
     oItem0    : TMenuItem;

begin
     if AMenu.Items.Count>1 then begin
          oItem0    := AMenu.Items[1];
          //
          oItem0.Hint    := ADefault;
          //dwSetProp(TControl(oItem0),'actionindex',ADefault);
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
          +'this.input_query_visible=true;';
     AForm.HelpFile := sMsgCode;
end;



end.
