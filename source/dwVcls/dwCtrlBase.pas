unit dwCtrlBase;

interface

uses

     //
     SynCommons,System.JSON,
     
     //求MD5
     IdHashMessageDigest,IdGlobal, IdHash,
     //
     Vcl.GraphUtil,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     Spin, Grids,
     Math,typinfo,
     DateUtils, StdCtrls, Menus,
     Windows,Types;

//根据控件的Hint生成JSON
function dwGetHintJson(ACtrl:TControl):Variant;

//生成可见性字符串
function dwVisible(ACtrl:TControl):String;

//生成可用性字符串
function dwDisable(ACtrl:TControl):String;

//生成LTWH字符串
function dwLTWH(ACtrl:TControl):String;      //可以更新位置的用法
function dwLTWHComp(ACtrl:TComponent):String;  //可以更新位置的用法
function dwLTWHBordered(ACtrl:TControl):String;  //针对需要外框的写法

//检查HINT的JOSN对象中如果存在在某属性,则返回字符串
//如果存在 AJsonName 则 返回 AHtmlName = "AJson.AJsonName";
//                 否则 返回 ADefault
function dwGetHintValue(AHint:Variant;AJsonName,AHtmlName,ADefault:String):String;

function dwGetHintStyle(AHint:Variant;AJsonName,AHtmlName,ADefault:String):String;

//得到属性字符串
function dwGetDWAttr(AHint:Variant):String;

//得到样式字符串
function dwGetDWStyle(AHint:Variant):String;

//根据HINT中是否有某属性，生成attr字符串。 没有返回空字符串
function dwGetAttr(AHint:Variant;AAttr:String):String;
function dwGetAttrBoolean(AHint:Variant;AAttr:String):String;


//检查HINT的JOSN对象中如果存在在某属性,则返回字符串
//如果存在 AJsonName 则 返回 AHtmlName:AJson.AJsonName;
//                 否则 返回 ADefault
function dwIIF(ABool:Boolean;AYes,ANo:string):string;
function dwIIFi(ABool:Boolean;AYes,ANo:Integer):Integer;

const
     //参数依次为:JS事件名称 ---  控件名称,控件值,D事件名称,句柄
     _DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%d'')"';
     _DWEVENT1 = ' %s="this.dwevent(event,''%s'',''%s'',''%s'',''%d'')"';   //用于Edit的OnKeyDown

     //参数依次为:JS事件名称 ---本地jS代码，控件名称,控件值,D事件名称,句柄
     _DWEVENTPlus = ' @%s="%s;dwevent($event,''%s'',''%s'',''%s'',''%d'')"';

//解密函数
function dwDecryptKey (Src:String; Key:String):string;

//Delphi 颜色转HTML 颜色字符串
function dwColor(AColor:Integer):string;

//Delphi 颜色转HTML 颜色字符串,带透明度
function dwAlphaColor(ACtrl:TPanel):string;

//
function dwEncodeURIComponent(S:AnsiString):AnsiString;

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
function dwSetProp(ACtrl:TControl;AAttr,AValue:String):Integer;
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

//对可能造成问题的字符串进行转义处理
function  dwChangeChar(AText:string):string;

//
function dwLongStr(AText:String):String;

//排列Panel的子控件
procedure dwRealignPanel(APanel:TPanel;AHorz:Boolean);

//检验当前字符串是否合法的JSON字符串
function    dwStrIsJson(AText:String):Boolean;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetInt(AJson:Variant;AName:String;ADefault:Integer):Integer;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetStr(AJson:Variant;AName:String;ADefault:String):String;

const
     dwIcons : array[1..280] of string = (
          'el-icon-platform-eleme'
          ,'el-icon-eleme'
          ,'el-icon-delete-solid'
          ,'el-icon-delete'
          ,'el-icon-s-tools'
          ,'el-icon-setting'
          ,'el-icon-user-solid'
          ,'el-icon-user'
          ,'el-icon-phone'
          ,'el-icon-phone-outline'
          ,'el-icon-more'
          ,'el-icon-more-outline'
          ,'el-icon-star-on'
          ,'el-icon-star-off'
          ,'el-icon-s-goods'
          ,'el-icon-goods'
          ,'el-icon-warning'
          ,'el-icon-warning-outline'
          ,'el-icon-question'
          ,'el-icon-info'
          ,'el-icon-remove'
          ,'el-icon-circle-plus'
          ,'el-icon-success'
          ,'el-icon-error'
          ,'el-icon-zoom-in'
          ,'el-icon-zoom-out'
          ,'el-icon-remove-outline'
          ,'el-icon-circle-plus-outline'
          ,'el-icon-circle-check'
          ,'el-icon-circle-close'
          ,'el-icon-s-help'
          ,'el-icon-help'
          ,'el-icon-minus'
          ,'el-icon-plus'
          ,'el-icon-check'
          ,'el-icon-close'
          ,'el-icon-picture'
          ,'el-icon-picture-outline'
          ,'el-icon-picture-outline-round'
          ,'el-icon-upload'
          ,'el-icon-upload2'
          ,'el-icon-download'
          ,'el-icon-camera-solid'
          ,'el-icon-camera'
          ,'el-icon-video-camera-solid'
          ,'el-icon-video-camera'
          ,'el-icon-message-solid'
          ,'el-icon-bell'
          ,'el-icon-s-cooperation'
          ,'el-icon-s-order'
          ,'el-icon-s-platform'
          ,'el-icon-s-fold'
          ,'el-icon-s-unfold'
          ,'el-icon-s-operation'
          ,'el-icon-s-promotion'
          ,'el-icon-s-home'
          ,'el-icon-s-release'
          ,'el-icon-s-ticket'
          ,'el-icon-s-management'
          ,'el-icon-s-open'
          ,'el-icon-s-shop'
          ,'el-icon-s-marketing'
          ,'el-icon-s-flag'
          ,'el-icon-s-comment'
          ,'el-icon-s-finance'
          ,'el-icon-s-claim'
          ,'el-icon-s-custom'
          ,'el-icon-s-opportunity'
          ,'el-icon-s-data'
          ,'el-icon-s-check'
          ,'el-icon-s-grid'
          ,'el-icon-menu'
          ,'el-icon-share'
          ,'el-icon-d-caret'
          ,'el-icon-caret-left'
          ,'el-icon-caret-right'
          ,'el-icon-caret-bottom'
          ,'el-icon-caret-top'
          ,'el-icon-bottom-left'
          ,'el-icon-bottom-right'
          ,'el-icon-back'
          ,'el-icon-right'
          ,'el-icon-bottom'
          ,'el-icon-top'
          ,'el-icon-top-left'
          ,'el-icon-top-right'
          ,'el-icon-arrow-left'
          ,'el-icon-arrow-right'
          ,'el-icon-arrow-down'
          ,'el-icon-arrow-up'
          ,'el-icon-d-arrow-left'
          ,'el-icon-d-arrow-right'
          ,'el-icon-video-pause'
          ,'el-icon-video-play'
          ,'el-icon-refresh'
          ,'el-icon-refresh-right'
          ,'el-icon-refresh-left'
          ,'el-icon-finished'
          ,'el-icon-sort'
          ,'el-icon-sort-up'
          ,'el-icon-sort-down'
          ,'el-icon-rank'
          ,'el-icon-loading'
          ,'el-icon-view'
          ,'el-icon-c-scale-to-original'
          ,'el-icon-date'
          ,'el-icon-edit'
          ,'el-icon-edit-outline'
          ,'el-icon-folder'
          ,'el-icon-folder-opened'
          ,'el-icon-folder-add'
          ,'el-icon-folder-remove'
          ,'el-icon-folder-delete'
          ,'el-icon-folder-checked'
          ,'el-icon-tickets'
          ,'el-icon-document-remove'
          ,'el-icon-document-delete'
          ,'el-icon-document-copy'
          ,'el-icon-document-checked'
          ,'el-icon-document'
          ,'el-icon-document-add'
          ,'el-icon-printer'
          ,'el-icon-paperclip'
          ,'el-icon-takeaway-box'
          ,'el-icon-search'
          ,'el-icon-monitor'
          ,'el-icon-attract'
          ,'el-icon-mobile'
          ,'el-icon-scissors'
          ,'el-icon-umbrella'
          ,'el-icon-headset'
          ,'el-icon-brush'
          ,'el-icon-mouse'
          ,'el-icon-coordinate'
          ,'el-icon-magic-stick'
          ,'el-icon-reading'
          ,'el-icon-data-line'
          ,'el-icon-data-board'
          ,'el-icon-pie-chart'
          ,'el-icon-data-analysis'
          ,'el-icon-collection-tag'
          ,'el-icon-film'
          ,'el-icon-suitcase'
          ,'el-icon-suitcase-1'
          ,'el-icon-receiving'
          ,'el-icon-collection'
          ,'el-icon-files'
          ,'el-icon-notebook-1'
          ,'el-icon-notebook-2'
          ,'el-icon-toilet-paper'
          ,'el-icon-office-building'
          ,'el-icon-school'
          ,'el-icon-table-lamp'
          ,'el-icon-house'
          ,'el-icon-no-smoking'
          ,'el-icon-smoking'
          ,'el-icon-shopping-cart-full'
          ,'el-icon-shopping-cart-1'
          ,'el-icon-shopping-cart-2'
          ,'el-icon-shopping-bag-1'
          ,'el-icon-shopping-bag-2'
          ,'el-icon-sold-out'
          ,'el-icon-sell'
          ,'el-icon-present'
          ,'el-icon-box'
          ,'el-icon-bank-card'
          ,'el-icon-money'
          ,'el-icon-coin'
          ,'el-icon-wallet'
          ,'el-icon-discount'
          ,'el-icon-price-tag'
          ,'el-icon-news'
          ,'el-icon-guide'
          ,'el-icon-male'
          ,'el-icon-female'
          ,'el-icon-thumb'
          ,'el-icon-cpu'
          ,'el-icon-link'
          ,'el-icon-connection'
          ,'el-icon-open'
          ,'el-icon-turn-off'
          ,'el-icon-set-up'
          ,'el-icon-chat-round'
          ,'el-icon-chat-line-round'
          ,'el-icon-chat-square'
          ,'el-icon-chat-dot-round'
          ,'el-icon-chat-dot-square'
          ,'el-icon-chat-line-square'
          ,'el-icon-message'
          ,'el-icon-postcard'
          ,'el-icon-position'
          ,'el-icon-turn-off-microphone'
          ,'el-icon-microphone'
          ,'el-icon-close-notification'
          ,'el-icon-bangzhu'
          ,'el-icon-time'
          ,'el-icon-odometer'
          ,'el-icon-crop'
          ,'el-icon-aim'
          ,'el-icon-switch-button'
          ,'el-icon-full-screen'
          ,'el-icon-copy-document'
          ,'el-icon-mic'
          ,'el-icon-stopwatch'
          ,'el-icon-medal-1'
          ,'el-icon-medal'
          ,'el-icon-trophy'
          ,'el-icon-trophy-1'
          ,'el-icon-first-aid-kit'
          ,'el-icon-discover'
          ,'el-icon-place'
          ,'el-icon-location'
          ,'el-icon-location-outline'
          ,'el-icon-location-information'
          ,'el-icon-add-location'
          ,'el-icon-delete-location'
          ,'el-icon-map-location'
          ,'el-icon-alarm-clock'
          ,'el-icon-timer'
          ,'el-icon-watch-1'
          ,'el-icon-watch'
          ,'el-icon-lock'
          ,'el-icon-unlock'
          ,'el-icon-key'
          ,'el-icon-service'
          ,'el-icon-mobile-phone'
          ,'el-icon-bicycle'
          ,'el-icon-truck'
          ,'el-icon-ship'
          ,'el-icon-basketball'
          ,'el-icon-football'
          ,'el-icon-soccer'
          ,'el-icon-baseball'
          ,'el-icon-wind-power'
          ,'el-icon-light-rain'
          ,'el-icon-lightning'
          ,'el-icon-heavy-rain'
          ,'el-icon-sunrise'
          ,'el-icon-sunrise-1'
          ,'el-icon-sunset'
          ,'el-icon-sunny'
          ,'el-icon-cloudy'
          ,'el-icon-partly-cloudy'
          ,'el-icon-cloudy-and-sunny'
          ,'el-icon-moon'
          ,'el-icon-moon-night'
          ,'el-icon-dish'
          ,'el-icon-dish-1'
          ,'el-icon-food'
          ,'el-icon-chicken'
          ,'el-icon-fork-spoon'
          ,'el-icon-knife-fork'
          ,'el-icon-burger'
          ,'el-icon-tableware'
          ,'el-icon-sugar'
          ,'el-icon-dessert'
          ,'el-icon-ice-cream'
          ,'el-icon-hot-water'
          ,'el-icon-water-cup'
          ,'el-icon-coffee-cup'
          ,'el-icon-cold-drink'
          ,'el-icon-goblet'
          ,'el-icon-goblet-full'
          ,'el-icon-goblet-square'
          ,'el-icon-goblet-square-full'
          ,'el-icon-refrigerator'
          ,'el-icon-grape'
          ,'el-icon-watermelon'
          ,'el-icon-cherry'
          ,'el-icon-apple'
          ,'el-icon-pear'
          ,'el-icon-orange'
          ,'el-icon-coffee'
          ,'el-icon-ice-tea'
          ,'el-icon-ice-drink'
          ,'el-icon-milk-tea'
          ,'el-icon-potato-strips'
          ,'el-icon-lollipop'
          ,'el-icon-ice-cream-square'
          ,'el-icon-ice-cream-round'
          );

function dwGetText(AText:string;ALen:integer):string;

function dwGetMD5(AStr:String):string;


//取得DLL名称
function dwGetDllName: string;

//根据owner是否为TForm1, 来增加前缀，主要用于区分多个Form中的同名控件
function  dwPrefix(ACtrl:TComponent):String;
//取全名，包括窗体前缀
function  dwFullName(ACtrl:TComponent):String;

//为引号加下\
function  dwProcQuotation(AText:String):String;

//合并两个json字符串
function  dwCombineJson(S0,S1:String): string;

//取得可动态设置的字体头部
function  dwFontStyle(ACtrl:TControl):String;

//去重（注：会自动排序，也就是会改变原来的顺序）
function dwRemoveDuplicates(const stringList : TStringList):Integer ;

//取子字符串在字符串中的次数
function dwSubStrCount(const Source, Sub: string): integer;

//
function  dwFontStyleToStr(AStyle:TFontStyles):String;

//检查JSON属性，如果不存在的话，赋默认值
function dwSetDefaultInt(var AJson:Variant;AName:String;ADefault:Integer):Integer;
function dwSetDefaultStr(var AJson:Variant;AName:String;ADefault:String):Integer;
function dwSetDefaultObj(var AJson:Variant;AName:String;ADefault:Variant):Integer;

function dwGetAlignment(AAlign:TAlignment):String;

//json to string
function dwJsonToStr(AData : Variant):String;
function _J2S(AData : Variant):String;

implementation      //==============================================================================

function _J2S(AData : Variant):String;
begin
    Result  := dwJsonToStr(AData);
end;
function dwJsonToStr(AData : Variant):String;
begin
    Result  := 'nil';
    if AData <> unassigned then begin
        Result  := VariantSaveJSON(AData);
    end;

end;

function dwGetAlignment(AAlign:TAlignment):String;
begin
    Result  := 'center';
    if AAlign = taLeftJustify then begin
        Result  := 'left';
    end else if AAlign = taRightJustify then begin
        Result  := 'right';
    end
end;

//检查JSON属性，如果不存在的话，赋默认值
function dwSetDefaultInt(var AJson:Variant;AName:String;ADefault:Integer):Integer;
begin
    if AJson <> unassigned then begin
        if not AJson.Exists(AName) then begin
            AJson.Add(AName,ADefault);
        end;
        Result  := 0;
    end else begin
        Result  := -1;
    end;

end;
function dwSetDefaultStr(var AJson:Variant;AName:String;ADefault:String):Integer;
begin
    if AJson <> unassigned then begin
        if not AJson.Exists(AName) then begin
            AJson.Add(AName,ADefault);
        end;
        Result  := 0;
    end else begin
        Result  := -1;
    end;

end;


//检查JSON属性，如果不存在的话，赋默认值
function dwSetDefaultObj(var AJson:Variant;AName:String;ADefault:Variant):Integer;
begin
    if AJson <> unassigned then begin
        if not AJson.Exists(AName) then begin
            AJson.Add(AName,ADefault);
        end;
        Result  := 0;
    end else begin
        Result  := -1;
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


function  dwFontStyleToStr(AStyle:TFontStyles):String;
begin
    Result  := '';
    if fsBold in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
    if fsItalic in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
    if fsStrikeOut in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
    if fsUnderLine in AStyle then begin
        Result  := Result + '1';
    end else begin
        Result  := Result + '0';
    end;
end;

function dwSubStrCount(const Source, Sub: string): integer;
var
    Buf     : string;
    i       : integer;
    Len     : integer;
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


function dwRemoveDuplicates(const stringList : TStringList):Integer ;
var
    buffer  : TStringList;
    cnt     : Integer;
begin
    stringList.Sort;
    buffer  := TStringList.Create;
    try
        buffer.Sorted       := True;
        buffer.Duplicates   := dupIgnore;
        buffer.BeginUpdate;
        for cnt := 0 to stringList.Count - 1 do
        buffer.Add(stringList[cnt]) ;
        buffer.EndUpdate;
        stringList.Assign(buffer) ;
    finally
        FreeandNil(buffer) ;
    end;
    Result   := 0;
end;


function  dwFontStyle(ACtrl:TControl):String;
begin
    with ACtrl do begin
        Result    := 'color:'+dwFullName(Actrl)+'__fcl,'         //颜色
            +'''font-size'':'+dwFullName(Actrl)+'__fsz,'         //size
            +'''font-family'':'+dwFullName(Actrl)+'__ffm,'       //字体
            +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'       //bold
            +'''font-style'':'+dwFullName(Actrl)+'__fsl,'        //italic
            +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'   //下划线或贯穿线，只能选一种
    end;
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


//为引号加下\
function  dwProcQuotation(AText:String):String;
begin
    //Result  := StringReplace(AText,'"','&quot;',[rfReplaceAll]);
    Result  := StringReplace(AText,'"','\''',[rfReplaceAll]);
    //Result  := StringReplace(Result,'''','&#39;',[rfReplaceAll]);
    //Result  := StringReplace(Result,'<','&lt;',[rfReplaceAll]);
    //Result  := StringReplace(Result,'>','&gt;',[rfReplaceAll]);
end;

//根据owner是否为TForm1, 来增加前缀，主要用于区分多个Form中的同名控件
function  dwPrefix(ACtrl:TComponent):String;
begin

     //默认为空
     Result    := '';

     //<异常处理
     //ACtrl已被销毁的情况
     if ACtrl.Name = '' then begin
        Exit;
     end;
     //ACtrl.Owner 为nil情况
     if ACtrl.Owner = nil then begin
        Exit;
     end;
     //>

     //
     if lowerCase(ACtrl.Owner.ClassName) <> 'tform1' then begin
          Result    := LowerCase(ACtrl.Owner.Name)+'__';
     end;
end;


//取全名，包括窗体前缀
function  dwFullName(ACtrl:TComponent):String;
begin
    Result  := LowerCase(dwPrefix(ACtrl)+ACtrl.Name);
end;

function  dwChangeChar(AText:String):String;
begin
     //<转义可能出错的字符
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

//取得DLL名称
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



function dwGetMD5(AStr:String):string;
var
     oMD5      : TIdHashMessageDigest5;
begin
     oMD5      := TIdHashMessageDigest5.Create;
     {$IFDEF VER150}
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
          slTmp.Destroy;
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
     //
     TDocVariant.New(joHint);
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
     end;
     joHint.planeholder  := APH;
     AControl.Hint  := VariantSaveJSON(joHint);
     //
     Result    := 0;
end;

//设置Height
function dwSetHeight(AControl:TControl;AHeight:Integer):Integer;
var
     sHint     : String;
     joHint    : Variant;
begin
     sHint     := AControl.Hint;
     TDocVariant.New(joHint);
     if dwStrIsJson(sHint) then begin
        joHint    := _json(sHint);
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
     slTxt.Destroy;
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
     TDocVariant.New(joHint);
     if ( sHint <> '' ) and ( Pos('{',sHint) >= 0 ) and ( Pos('}',sHint) > 0 ) then begin
          try
               joHint    := _Json(sHint);
          except
               TDocVariant.New(joHint);
          end;
     end;

     //
     if not dwIsNull(joHint) then begin
          Result    := joHint._(AAttr);
     end;
end;


function dwGetProp(ACtrl:TControl;AAttr:String):String;
var
    sHint   : String;
    joHint  : Variant;
begin
    joHint  := dwGetHintJson(ACtrl);
{
     //
     sHint     := ACtrl.Hint;

     //创建HINT对象, 用于生成一些额外属性
     TDocVariant.New(joHint);
     if dwStrIsJson(sHint) then begin
        joHint    := _JSON(UTF8ToWideString(sHint));
     end;
}
    //
    if joHint.Exists(AAttr) then begin
        Result    := joHint._(AAttr);
    end else begin
        Result    := '';
    end;
end;

function dwSetProp(ACtrl:TControl;AAttr,AValue:String):Integer;
var
    sHint   : String;
    joHint  : Variant;
begin
    Result  := 0;
    joHint  := dwGetHintJson(ACtrl);

    //如果当前存在该属性, 则先删除
    if joHint.Exists(AAttr) then begin
        joHint.Delete(AAttr);
    end;

    //添加属性
    joHint.Add(AAttr,AValue);

    //返回到HINT字符串
    ACtrl.Hint  := VariantSaveJSON(joHint);


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
     Result    := StringReplace(Result,#13#10,'<br>',[rfReplaceAll]);
     Result    := StringReplace(Result,#13,'<br>',[rfReplaceAll]);
     Result    := Trim(Result);
     //异常处理(中文乱码)
     if Length(Result)>800 then begin
          //Result    := dwGetText(Result,800);
     end;

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

function dwEncodeURIComponent(S:AnsiString):AnsiString;
begin
     Result    := HTTPEncodeEx(AnsiToUtf8(S));
end;


function dwColor(AColor:Integer):string;
begin
    if AColor = clNone then begin
        Result    := 'rgba(0,0,0,0)';
    end else begin
        Result    := ColorToWebColorStr(AColor);
    end;
     //Result := Format('#%.2x%.2x%.2x',[GetRValue(ColorToRGB(AColor)),GetGValue(ColorToRGB(AColor)),GetBValue(ColorToRGB(AColor))]);
end;

//Delphi 颜色转HTML 颜色字符串,带透明度
function dwAlphaColor(ACtrl:TPanel):string;
var
     RGB: Integer;
     iR,iG,iB  : Integer;
     iA        : Integer;     //0:完全透明，1-9半透明，10：不透明
begin
     RGB  := ColorToRGB(ACtrl.Color);
     iR   := GetRValue(RGB);
     iG   := GetGValue(RGB);
     iB   := GetBValue(RGB);
     //用HelpContext来控制透明度
     iA   := ACtrl.HelpContext;
     if iA>10 then begin
          iA   := 10;
     end;
     iA   := 10-iA;

     Result    := Format('RGB(%d,%d,%d,%.1f)',[iR,iG,iB,iA/10]);
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
function dwIIFi(ABool:Boolean;AYes,ANo:Integer):Integer;
begin
    if ABool then begin
        Result    := AYes;
    end else begin
        Result    := ANo;
    end;
end;

function dwVisible(ACtrl:TControl):String;
begin
    Result    := ' v-show="'+dwFullName(Actrl)+'__vis"';
end;

function dwDisable(ACtrl:TControl):String;
begin
    Result    := ' :disabled="'+dwFullName(Actrl)+'__dis"';
end;

function    dwStrIsJson(AText:String):Boolean;
begin
    Result  := _json(AText) <> unassigned;
(*
    if Length(Trim(AText))<7 then begin //{"a":0}
        Result  := False;
    end else if (Pos('{',AText)<=0) OR (Pos('}',AText)<=0) OR (Pos('"',AText)<=0) OR (Pos(':',AText)<=0) then begin
        Result  := False;
    end else begin
        Result  := TJSONObject.ParseJSONValue(Trim(AText)) <> nil;
    end;
*)
end;

function dwGetHintJson(ACtrl:TControl):Variant;
var
    sHint     : String;
begin
    //方法2，无内存泄漏
    sHint     := ACtrl.Hint;
    Result  := _json(ACtrl.Hint);
    if Result = unassigned then begin
        Result  := _json('{}');
    end;
end;

function dwLTWH(ACtrl:TControl):String;  //可以更新位置的用法
begin
    with ACtrl do begin
        Result    := ' :style="{'
                +'left:'+dwFullName(Actrl)+'__lef,'
                +'top:'+dwFullName(Actrl)+'__top,'
                +'width:'+dwFullName(Actrl)+'__wid,'
                +'height:'+dwFullName(Actrl)+'__hei'
                +'}"'
                +' style="position:absolute;';
    end;
end;

function dwLTWHBordered(ACtrl:TControl):String;  //可以更新位置的用法
begin
    with ACtrl do begin
        Result    := ' :style="{'
                +'left:'+dwFullName(Actrl)+'__leb,'
                +'top:'+dwFullName(Actrl)+'__tob,'
                +'width:'+dwFullName(Actrl)+'__wib,'
                +'height:'+dwFullName(Actrl)+'__heb'
                +'}"'
                +' style="position:absolute;';
    end;
end;


function dwLTWHComp(ACtrl:TComponent):String;  //可以更新位置的用法
begin
     //
     with ACtrl do begin
          Result    := ' :style=''{'
                    +'left:'+dwFullName(Actrl)+'__lef,'
                    +'top:'+dwFullName(Actrl)+'__top,'
                    +'width:'+dwFullName(Actrl)+'__wid,'
                    +'height:'+dwFullName(Actrl)+'__hei}'''
                    +' style="position:absolute;';
     end;
end;


function dwGetHintValue(AHint:Variant;AJsonName,AHtmlName,ADefault:String):String;
begin
     if AHint<>null then begin
          if AHint.Exists(AJsonName) then begin
               if AHtmlName <> '' then begin
                    Result    := (' '+AHtmlName+'="'+AHint._(AJsonName)+'"');
               end else begin
                    Result    := (' '+AHint._(AJsonName));
               end;
          end else begin
               Result    := ADefault;
          end;
     end else begin
          Result    := ADefault;
     end;
end;
function dwGetHintStyle(AHint:Variant;AJsonName,AHtmlName,ADefault:String):String;
begin
     if AHint<>null then begin
          if AHint.Exists(AJsonName) then begin
               if AHtmlName <> '' then begin
                    Result    := (AHtmlName+':'+AHint._(AJsonName)+';');
               end else begin
                    Result    := (AHint._(AJsonName));
               end;
          end else begin
               Result    := ADefault;
          end;
     end else begin
          Result    := ADefault;
     end;
end;

function dwGetDWAttr(AHint:Variant):String;
begin
     Result    := '';
     if AHint<>null then begin
          if AHint.Exists('dwattr') then begin
               Result    := ' '+(AHint.dwattr);
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

end.
