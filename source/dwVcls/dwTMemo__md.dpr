library dwTMemo__md;
{
功能说明:
    显示markdown控件
    1 默认显示LTWH和color
    2 动态设置LTWH
    3 支持dwattr和dwstyle

更新说明
    ### 2025-03-29
    1 增加了dwchild属性HINT, 可以添加一段HTML代码, 用于子元素
    2 增加了font属性支持
}

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

//-------辅助函数-----------------------------------------------------------------------------------
//Delphi的Memo中的字符串 -> Web用的字符串
function dwTextToWeb(AText:string):string;
var
    slTxt     : TStringList;
    iItem     : Integer;
begin
    //<转义可能出错的字符
    AText     := StringReplace(AText,'\','\\',[rfReplaceAll]);
    AText     := StringReplace(AText,'"','\"',[rfReplaceAll]);

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
//-------辅助函数-----------------------------------------------------------------------------------


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

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    sCode   : String;
    joRes   : Variant;
begin
     //生成返回值数组
    joRes   := _Json('[]');

    //
    joRes.Add('<link rel="stylesheet" href="dist/_marked/markedtable.css">');
    joRes.Add('<script src="dist/_marked/marked.min.js"></script>');

    //
    Result := joRes;
end;



//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sFont       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull       := dwFullName(Actrl);
    //
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //字体
        sFont   := '';
        if ParentFont = False then begin
            sFont   := _GetFont(Font);
        end;

        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwGetDWAttr(joHint)
                +' style="'
                    +'position:absolute;'
                    +'backgroundColor:'+dwAlphaColor(TPanel(ACtrl))+';'
                    +'left:'+IntToStr(Left)+'px;'
                    +'top:'+IntToStr(top)+'px;'
                    +'width:'+IntToStr(width)+'px;'
                    +'height:'+IntToStr(height)+'px;'
                    +'overflow:clip auto;'
                    //+'display:inline !important;'
                    +'text-align:left;'
                    +sFont
                    +dwGetDWStyle(joHint)
                +'"'
                +'>'
                    +'<div'
                    +' style="'
                        +'border:none;'
                        +'width:100%;'
                    +'"'
                    +'></div>'
                +'</div>';
        //添加到返回值数据
        joRes.Add(sCode);
        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    sCode     : String;
begin
    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    iItem   : Integer;
    sCode       : String;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TMemo(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add(
            '$("#'+sFull+'").css({'
                +'''left'': '''+InttoStr(Left)+'px'','
                +'''top'': '''+InttoStr(top)+'px'','
                +'''width'': '''+InttoStr(width)+'px'','
                +'''height'': '''+InttoStr(height)+'px'''
            +'});'
        );

        //重绘
        if ShowHint then begin
            sCode   := ''
                    +'dwLoadResourcesIfNotExists('
                        +'['
                            +'{ type: "js", globalVar: "marked", url: "dist/_marked/marked.min.js" }'
                            //+',{ type: "css", url: "dist/_marked/markedtable.css" }'
                        +'], function() {';
            if Lines.Count = 0 then begin
                sCode   := sCode +#13'const markdownText = ``;';
            end else begin
                sCode   := sCode +#13'const markdownText = `'+TrimLeft(Lines[0])+'  ';
                for iItem := 1 to Lines.Count - 2 do begin
                    sCode   := sCode +#13+TrimLeft(Lines[iItem])+'  ';
                end;
                    sCode   := sCode +#13+TrimLeft(Lines[Lines.Count - 1])+'`;';
            end;
            //
            sCode   := sCode +#13'const htmlContent = marked.parse(markdownText);'
                    +'document.getElementById('''+sFull+''').firstElementChild.innerHTML = htmlContent;'
                            //-------------------end---------------------
                        +'}'
                    +');';
            joRes.Add(sCode);
            //
            ShowHint    := False;
        end else begin
            joRes.Add('/* */;');    //写一个空行以对齐
        end;

        //
        Result    := (joRes);
    end;
end;

//取得面渲染完成后执行代码
function dwGetMounted(ACtrl:TControl):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    iItem   : Integer;
    sCode   : String;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TMemo(ACtrl) do begin
        sCode   := ''
                +'dwLoadResourcesIfNotExists('
                    +'['
                        +'{ type: "js", globalVar: "marked", url: "dist/_marked/marked.min.js" }'
                        //+',{ type: "css", url: "dist/_marked/markedtable.css" }'
                    +'], function() {';
        if Lines.Count = 0 then begin
            sCode   := sCode +#13'const markdownText = ``;';
        end else begin
            sCode   := sCode +#13'const markdownText = `'+TrimLeft(Lines[0])+'  ';
            for iItem := 1 to Lines.Count - 2 do begin
                sCode   := sCode +#13+TrimLeft(Lines[iItem])+'  ';
            end;
                sCode   := sCode +#13+TrimLeft(Lines[Lines.Count - 1])+'`;';
        end;
        //
        sCode   := sCode +#13'const htmlContent = marked.parse(markdownText);'
                +'document.getElementById('''+sFull+''').firstElementChild.innerHTML = htmlContent;'
                        //-------------------end---------------------
                    +'}'
                +');';
        joRes.Add(sCode);
    end;
    //
    Result    := (joRes);

end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMounted,
     dwGetAction,
     dwGetData;
     
begin
end.
 
