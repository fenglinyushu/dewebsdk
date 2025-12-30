library dwTMemo__codemirror;
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

function _GetFont(AFont:TFont):string;
begin

    Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size+3)+'px;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;

function _GetFontWeight(AFont:TFont):String;
begin
     if fsBold in AFont.Style then begin
          Result    := 'bold';
     end else begin
          Result    := 'normal';
     end;

end;
function _GetFontStyle(AFont:TFont):String;
begin
     if fsItalic in AFont.Style then begin
          Result    := 'italic';
     end else begin
          Result    := 'normal';
     end;
end;
function _GetTextDecoration(AFont:TFont):String;
begin
     if fsUnderline in AFont.Style then begin
          Result    :='underline';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end else begin
               Result    := 'none';
          end;
     end;
end;
function _GetTextAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     end;
end;




function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;


//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    iItem       : Integer;
    sLang       : String;
    sCode       : string;
begin
    //返回值数组
    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //检查language / style
    if not joHint.Exists('language') then begin
        joHint.language := _json('["pascal"]');
    end;
    if joHint.language._Count = 0 then begin
        joHint.language := _json('["pascal"]');
    end;
    if not joHint.Exists('style') then begin
        joHint.style := 'eclipse';
    end;

    //基本JS/CSS
    joRes.Add('<link rel="stylesheet" href="dist/_codemirror/lib/codemirror.css">');
    joRes.Add('<script src="dist/_codemirror/lib/codemirror.js"></script>');

    //引入theme，用以支持主题
    joRes.Add('<link rel="stylesheet" href="dist/_codemirror/theme/'+joHint.style+'.css">');

    //支持代码折叠
    joRes.Add('<link rel="stylesheet" href="dist/_codemirror/addon/fold/foldgutter.css"/>');
    joRes.Add('<script src="dist/_codemirror/addon/fold/foldcode.js"></script>');
    joRes.Add('<script src="dist/_codemirror/addon/fold/foldgutter.js"></script>');
    joRes.Add('<script src="dist/_codemirror/addon/fold/brace-fold.js"></script>');
    joRes.Add('<script src="dist/_codemirror/addon/fold/comment-fold.js"></script>');

    //各种语言
    with TMemo(ACtrl) do begin
        for iItem := 0 to joHint.language._Count - 1 do begin
            sLang   := joHint.language._(iItem);
            //<script src="mode/javascript/javascript.js"></script>
            joRes.Add('<script src="dist/_codemirror/mode/'+sLang+'/'+sLang+'.js"></script>');
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
    sCode       : string;
    sFull       : string;
    joHint      : Variant;
    joRes       : Variant;
begin

    //
    sFull   := dwFullName(ACtrl);

    //
    with TMemo(ACtrl) do begin
        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //生成返回值数组
        joRes   := _Json('[]');
        //
        sCode   := '<div'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                    +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                    +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                    +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                    +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>'
                +'<textarea'
                +' id="'+sFull+'"'
                +' :style="{'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="'
                    +'position:absolute;'
                    +'left:0;'
                    +'top:0;'
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>';
        //
        joRes.Add(sCode);

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
        joRes.Add('</textarea>');
        joRes.Add('</div>');
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
            //
            joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(dwFullName(Actrl)+'__ffm:"'+Font.Name+'",');
            joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');
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
            //
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
    joHint  : Variant;
    //
    sCode   : string;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //检查language / style
    if not joHint.Exists('language') then begin
        joHint.language := _json('["pascal"]');
    end;
    if joHint.language._Count = 0 then begin
        joHint.language := _json('["pascal"]');
    end;
    if not joHint.Exists('style') then begin
        joHint.style := 'default';
    end;

    sCode   := 'var '+sFull+'__editor = CodeMirror.fromTextArea(document.getElementById("'+sFull+'"), {'+
                'mode: "text/x-'+joHint.language._(0)+'",' +    //实现groovy代码高亮
                'lineNumbers: true,' +	    //显示行号
                'theme: "'+joHint.style+'",' +	    //设置主题
                'lineWrapping: true,' +	    //代码折叠
                'foldGutter: true,' +
                'gutters: ["CodeMirror-linenumbers", "CodeMirror-foldgutter"],' +
                'matchBrackets: true,' +	//括号匹配
                //readOnly: true,           //只读
            '});';
    joRes.Add(sCode);

    //
    //sCode   := sFull+'__editor.setSize('''+IntToStr(TMemo(ACtrl).Width)+'px'', '''+IntToStr(TMemo(ACtrl).Height)+'px''); ';
    sCode   := sFull+'__editor.setSize(''100%'', ''100%''); ';
    joRes.Add(sCode);

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
 
