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
          //更新值
          sText     := dwUnescape(joData.v);
          sText     := dwUnescape(sText);
          sText     := StringReplace(sText,#10,#13#10,[rfReplaceAll]);
          sText     := StringReplace(sText,'"','\"',[rfReplaceAll]);
          TMemo(ACtrl).Text    := sText;

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
          //
          sScroll   := '';

          sCode     := '<el-input type="textarea"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+dwPrefix(Actrl)+Name+'__txt"'
                    //style
                    +dwLTWH(TControl(ACtrl))
                    +sScroll
                    +'"' //style 封闭
                    //
                    +Format(_DWEVENT,['input',Name,'escape(this.'+dwPrefix(Actrl)+Name+'__txt)','onchange',TForm(Owner).Handle])
                    //+dwIIF(Assigned(OnChange),    Format(_DWEVENT,['input',Name,'(this.'+dwPrefix(Actrl)+Name+'__txt)','onchange',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
          //添加到返回值数据
          joRes.Add(sCode);
     end;

     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
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

function dwMemoTextToValue(AText:string):string;
var
     slTxt     : TStringList;
     iItem     : Integer;
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


//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
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
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__txt:"'+dwMemoTextToValue(Text)+'",');
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
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
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__txt="'+dwMemoTextToValue(Text)+'";');
     end;
     //
     Result    := (joRes);
end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;
     
begin
end.
 
