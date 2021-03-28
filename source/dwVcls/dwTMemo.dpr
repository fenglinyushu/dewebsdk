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

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
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
          //�����¼�
          oChange   := TMemo(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TMemo(ACtrl).OnChange  := nil;
          //����ֵ
          sText     := dwUnescape(joData.v);
          sText     := dwUnescape(sText);
          sText     := StringReplace(sText,#10,#13#10,[rfReplaceAll]);
          sText     := StringReplace(sText,'"','\"',[rfReplaceAll]);
          TMemo(ACtrl).Text    := sText;

          //�ָ��¼�
          TMemo(ACtrl).OnChange  := oChange;

          //ִ���¼�
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


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sScroll   : string;
begin
     //<����PageControl��ʱ���ߵ�����
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

     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
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
                    +'"' //style ���
                    //
                    +Format(_DWEVENT,['input',Name,'escape(this.'+dwPrefix(Actrl)+Name+'__txt)','onchange',TForm(Owner).Handle])
                    //+dwIIF(Assigned(OnChange),    Format(_DWEVENT,['input',Name,'(this.'+dwPrefix(Actrl)+Name+'__txt)','onchange',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);
     end;

     //
     Result    := (joRes);
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //<����PageControl��ʱ���ߵ�����
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

     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</el-input>');
     //
     Result    := (joRes);
end;

function dwMemoTextToValue(AText:string):string;
var
     slTxt     : TStringList;
     iItem     : Integer;
begin
     //<ת����ܳ�����ַ�
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


//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
     //<����PageControl��ʱ���ߵ�����
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

     //���ɷ���ֵ����
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
     //<����PageControl��ʱ���ߵ�����
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

     //���ɷ���ֵ����
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
 
