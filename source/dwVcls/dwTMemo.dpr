library dwTMemo;

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
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
     sText     : string;
begin
    with TMemo(ACtrl) do begin
        //
        joData    := _Json(AData);


        if joData.e = 'onenter' then begin
            if Assigned(TMemo(ACtrl).OnEnter) then begin
                TMemo(ACtrl).OnEnter(TMemo(ACtrl));
            end;
        end else if joData.e = 'onchange' then begin
            //保存事件
            oChange   := TMemo(ACtrl).OnChange;
            //清空事件,以防止自动执行
            TMemo(ACtrl).OnChange  := nil;
            TMemo(ACtrl).Text    := dwWebToText(joData.v);

            //恢复事件
            TMemo(ACtrl).OnChange  := oChange;

            //执行事件
            if Assigned(TMemo(ACtrl).OnChange) then begin
               TMemo(ACtrl).OnChange(TMemo(ACtrl));
            end;
        end else if joData.e = 'onexit' then begin
            if Assigned(TMemo(ACtrl).OnExit) then begin
                TMemo(ACtrl).OnExit(TMemo(ACtrl));
            end;
        end else if joData.e = 'onmouseenter' then begin
            if Assigned(TMemo(ACtrl).OnMouseEnter) then begin
                TMemo(ACtrl).OnMouseEnter(TMemo(ACtrl));
            end;
        end else if joData.e = 'onmouseexit' then begin
            if Assigned(TMemo(ACtrl).OnMouseLeave) then begin
                TMemo(ACtrl).OnMouseLeave(TMemo(ACtrl));
            end;
        end else if joData.e = 'onclick' then begin
            if Assigned(TMemo(ACtrl).OnClick) then begin
                TMemo(ACtrl).OnClick(TMemo(ACtrl));
            end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sScroll     : string;
    sFull       : string;
    sFontFamily : String;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull   := dwFullName(ACtrl);
    //
    with TMemo(ACtrl) do begin

        //<处理PageControl做时间线的问题
        if TMemo(ACtrl).Parent.ClassName = 'TTabSheet' then begin
            if TTabSheet(TMemo(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                joRes    := _Json('[]');
                //
                Result    := joRes;
                //
                Exit;
            end;
        end;
        //>

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TMemo(ACtrl) do begin
            //取得滚动条
            sScroll := '';

            //取得字符设置
            sFontFamily     := '';
            if joHint.Exists('fontfamily') then begin
                sFontFamily := 'font-family: '+dwGetStr(joHint,'fontfamily',Font.Name)+';';
            end;

            sCode   :=
                    '<el-input type="textarea"'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+dwFullName(Actrl)+'__txt"'
                    +dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,提示语
                    +dwIIF(ReadOnly,' readonly','')
                    +dwGetDWAttr(joHint)

                    //style
                    +dwLTWH(TControl(ACtrl))
                    +sFontFamily
                    +sScroll
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    //
                    +Format(_DWEVENT,['input',sFull,'escape(this.'+dwFullName(Actrl)+'__txt)','onchange',TForm(Owner).Handle])
                    //+dwIIF(Assigned(OnChange),    Format(_DWEVENT,['input',sFull,'(this.'+dwFullName(Actrl)+'__txt)','onchange',TForm(Owner).Handle]),'')

                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click.native',sFull,'0','onclick',TForm(Owner).Handle]),'')

                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',sFull,'0','onmouseenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',sFull,'0','onmouseexit',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',sFull,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',sFull,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
                    //添加到返回值数据
            joRes.Add(sCode);
        end;

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
        //<处理PageControl做时间线的问题
        if TMemo(ACtrl).Parent.ClassName = 'TTabSheet' then begin
            if TTabSheet(TMemo(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                joRes    := _Json('[]');
                //
                Result    := joRes;
                //
                Exit;
            end;
        end;
        //>

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-input>');
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
        //<处理PageControl做时间线的问题
        if TMemo(ACtrl).Parent.ClassName = 'TTabSheet' then begin
            if TTabSheet(TMemo(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                joRes    := _Json('[]');
                //
                Result    := joRes;
                //
                Exit;
            end;
        end;
        //>

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
            joRes.Add(dwFullName(Actrl)+'__txt:"'+dwTextToWeb(Text)+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sCode       : String;
    iItem       : Integer;
    joHint      : Variant;  //__eventcomponent
    sEventComp  : String;
begin
    //得到事件源控件
    joHint  := dwGetHintJson(TControl(ACtrl.Owner));
    sEventComp  := '';
    if joHint.Exists('__eventcomponent') then begin
        sEventComp  := LowerCase(joHint.__eventcomponent);
    end;

    with TMemo(ACtrl) do begin
        //<处理PageControl做时间线的问题
        if TMemo(ACtrl).Parent.ClassName = 'TTabSheet' then begin
            if TTabSheet(TMemo(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
                joRes    := _Json('[]');
                //
                Result    := joRes;
                //
                Exit;
            end;
        end;
        //>


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
(*
        //如果当前是事件源控件，则不处理
        if (sEventComp <> dwFullName(Actrl)) or (TEdit(ACtrl).DoubleBuffered = True) then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__txt="'+dwChangeChar(Text)+'";');
        end else begin
            joRes.Add('');
        end;


*)
            if (sEventComp <> dwFullName(Actrl)) or (TMemo(ACtrl).DoubleBuffered = True) then begin
                joRes.Add('this.'+dwFullName(Actrl)+'__txt="'+dwTextToWeb(Text)+'";');
            end else begin
                joRes.Add('');
            end
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
 
