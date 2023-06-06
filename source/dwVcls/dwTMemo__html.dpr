library dwTMemo__html;

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



//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
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
        sCode   := '<div'
                +' id="'+dwFullName(Actrl)+'"'
                +' ref="'+dwFullName(Actrl)+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                    +'left:'+dwFullName(Actrl)+'__lef,'
                    +'top:'+dwFullName(Actrl)+'__top,'
                    +'width:'+dwFullName(Actrl)+'__wid,'
                    +'height:'+dwFullName(Actrl)+'__hei'
                +'}"'
                +' style="position:absolute;'
                    +_GetFont(Font)
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>';
        //
        joRes.Add(sCode);


        //去掉所有换行符，以避免错误
        sCode   := StringReplace(Text,#13#10,'',[rfReplaceAll]);
        //
        joRes.Add(sCode);

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
            joRes.Add(dwFullName(Actrl)+'__col:"'+dwColor(TMemo(ACtrl).Color)+'",');
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
            joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwColor(TMemo(ACtrl).Color)+'";');
            //this.$refs.test.innerHTML
            sCode   := StringReplace(Text,#13#10,'',[rfReplaceAll]);
            sCode   := StringReplace(sCode,'\','\\',[rfReplaceAll]);
            sCode   := StringReplace(sCode,'"','\"',[rfReplaceAll]);
            joRes.Add('this.$refs.'+dwFullName(Actrl)+'.innerHTML="'+sCode+'";');

        end;
        //
        Result    := (joRes);
    end;
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
