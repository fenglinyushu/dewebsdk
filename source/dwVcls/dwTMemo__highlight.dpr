library dwTMemo__highlight;
(*
功能说明：
    该控件用于在WEB中显示代码块
    lines中为代码内容
    在hint中
    language 为语言类型数组，默认为delphi, 其他如：c/csharp/delphi/java/javascript/json, 更多见dist\_highlight\languages
    style 为显示样式，默认为default,更多见 dist\_highlight\styles
    {"language":[delphi,json,c],"style":"dark"}

用法：
    1 配置Hint
    2 在代码文件写入到Memo的Lines中

*)

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

//Delphi的Memo中的字符串 -> Web用的字符串
function dwTextToWeb(AText:string):string;
var
    slTxt     : TStringList;
    iItem     : Integer;
begin
    //<转义可能出错的字符

{
    AText     := StringReplace(AText,'\"','[!__!]',[rfReplaceAll]);
    AText     := StringReplace(AText,'"','\"',[rfReplaceAll]);
    AText     := StringReplace(AText,'[!__!]','\"',[rfReplaceAll]);

    AText     := StringReplace(AText,'\>','[!__!]',[rfReplaceAll]);
    AText     := StringReplace(AText,'>','\>',[rfReplaceAll]);
    AText     := StringReplace(AText,'[!__!]','\>',[rfReplaceAll]);

    AText     := StringReplace(AText,'\<','[!__!]',[rfReplaceAll]);
    AText     := StringReplace(AText,'<','\<',[rfReplaceAll]);
    AText     := StringReplace(AText,'[!__!]','\<',[rfReplaceAll]);
}
    AText     := StringReplace(AText,'\','\\',[rfReplaceAll]);
    AText     := StringReplace(AText,'"','\"',[rfReplaceAll]);

    //AText     := StringReplace(AText,'&','&amp;',[rfReplaceAll]);
    //AText     := StringReplace(AText,'"','&quot;',[rfReplaceAll]);
    //AText     := StringReplace(AText,'>','&gt;',[rfReplaceAll]);
    //AText     := StringReplace(AText,'<','&lt;',[rfReplaceAll]);
    //AText     := StringReplace(AText,' ','&nbsp;',[rfReplaceAll]);
    //>

    //
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
    //
    //Result    := StringReplace(Result,'''','\''''+''',[rfReplaceAll]);

end;

//Web用的字符串 -> Delphi的Memo中的字符串
function dwWebToText(AText:string):string;
var
    slTxt     : TStringList;
begin
    //更新值
    Result  := dwUnescape(AText);
    Result  := dwUnescape(Result);
    Result  := StringReplace(Result,#10,#13#10,[rfReplaceAll]);
    //Result  := StringReplace(Result,'"','\"',[rfReplaceAll]);
end;



//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    iItem       : Integer;
begin
    //返回值数组
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //检查language / style
    if not joHint.Exists('language') then begin
        joHint.language := _json('["delphi"]');
    end;
    if joHint.language._Count = 0 then begin
        joHint.language := _json('["delphi"]');
    end;
    if not joHint.Exists('style') then begin
        joHint.style := 'default';
    end;

    //
    with TMemo(ACtrl) do begin
        //引入样式
        joRes.Add('<link rel="stylesheet" href="dist/_highlight/styles/'+joHint.style+'.min.css">');
        //基本JS
        joRes.Add('<script src="dist/_highlight/highlight.min.js"></script>');
        //各种语言
        for iItem := 0 to joHint.language._Count - 1 do begin
            joRes.Add('<script src="dist/_highlight/languages/'+joHint.language._(iItem)+'.min.js"></script>');
        end;
    end;

    //
    Result  := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
    with TMemo(ACtrl) do begin
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode     : string;
    joHint    : Variant;
    joRes     : Variant;
    sScroll   : string;
begin
    with TMemo(ACtrl) do begin
        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //生成返回值数组
        joRes   := _Json('[]');
        //
        sCode   := '<pre><code'
                +' id="'+dwFullName(Actrl)+'"'
                +' ref="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'left:'+dwFullName(Actrl)+'__lef,'
                    +'top:'+dwFullName(Actrl)+'__top,'
                    +'width:'+dwFullName(Actrl)+'__wid,'
                    +'height:'+dwFullName(Actrl)+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>';
        //
        joRes.Add(sCode);


        //去掉所有换行符，以避免错误
        //sCode   := StringReplace(Text,#13#10,'',[rfReplaceAll]);

        //
        joRes.Add(Text);

        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
begin
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</code><pre>');
        //
        Result    := (joRes);
    end;
end;




//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TMemo(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
            //2023-12-29采用了``做引号，解决了更换text报错的bug
            joRes.Add('this.$refs.'+dwFullName(Actrl)+'.innerHTML=`'+text+'`;');

        end;
        //
        Result    := (joRes);
    end;
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    //
    sCode   : string;
begin
    //生成返回值数组
    joRes   := _Json('[]');
    //
    joRes.Add('hljs.highlightAll();');
    //
    Result    := joRes;
end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetMounted,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
