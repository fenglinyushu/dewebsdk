library dwTHeaderControl;

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

function _GetFont(AFont:TFont):string;
begin
     Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size)+'pt;';

     //����
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //б��
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //�»���
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //ɾ����
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //ɾ����
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;

function __GetAlignment(ACtrl:THeaderSection):string;
begin
     Result    := '';
     case ACtrl.Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;



//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onsectionclick' then begin
          THeaderControl(ACtrl).OnSectionClick(THeaderControl(ACtrl),THeaderControl(ACtrl).Sections[joData.v]);
     end else if joData.e = 'onenter' then begin
          THeaderControl(ACtrl).OnMouseEnter(THeaderControl(ACtrl));
     end else if joData.e = 'onexit' then begin
          THeaderControl(ACtrl).OnMouseLeave(THeaderControl(ACtrl));
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iSect     : Integer;
     sSect     : String;
     oSection  : THeaderSection;
     iLeft     : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     with THeaderControl(ACtrl) do begin
          //���
          sCode     := '<div'
                    +' id="'+dwPrefix(Actrl)+Name+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' :style="{left:'+dwPrefix(Actrl)+Name+'__lef,top:'+dwPrefix(Actrl)+Name+'__top,width:'+dwPrefix(Actrl)+Name+'__wid,height:'+dwPrefix(Actrl)+Name+'__hei}"'
                    +' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                    +'"' //style ���
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);

          //
          for iSect := 0 to Sections.Count-1 do begin
               sSect     := Format('%.2d',[iSect]);
               oSection  := Sections[iSect];
               //
               sCode     := '<div'
                         +' v-html="'+dwPrefix(Actrl)+Name+'__c'+sSect+'"'
                         +' :style="{left:'+dwPrefix(Actrl)+Name+'__l'+sSect+',top:0,width:'+dwPrefix(Actrl)+Name+'__w'+sSect+'}"'
                         +' style="position:absolute;'
                         +_GetFont(Font)
                         //style
                         +__GetAlignment(oSection)
                         +'line-height:'+IntToStr(Height)+'px;'
                         +'"'
                         //style ���
                         +'>{{'+dwPrefix(Actrl)+Name+'__c'+sSect+'}}</div>';
               //��ӵ�����ֵ����
               joRes.Add(sCode);

          end;


     end;
     //
     Result    := (joRes);
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</div>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : string;
     iSect     : Integer;
     sSect     : String;
     oSection  : THeaderSection;
     iLeft     : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with THeaderControl(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          //joRes.Add(dwPrefix(Actrl)+Name+'__col:"'+dwColor(Color)+'",');
          iLeft     := 0;     //���ڼ�����߽�
          for iSect := 0 to Sections.Count-1 do begin
               sSect     := Format('%.2d',[iSect]);
               oSection  := Sections[iSect];
               //
               joRes.Add(dwPrefix(Actrl)+Name+'__l'+sSect+':"'+IntToStr(iLeft)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__w'+sSect+':"'+IntToStr(oSection.Width)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__c'+sSect+':"'+oSection.Text+'",');
               //
               iLeft     := iLeft + oSection.Width;
          end;
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with THeaderControl(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          //joRes.Add('this.'+dwPrefix(Actrl)+Name+'__col="'+dwColor(Color)+'";');
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
 
