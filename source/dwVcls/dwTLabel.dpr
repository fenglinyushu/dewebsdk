library dwTLabel;

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

function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TLabel(ACtrl).Alignment of
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

     if joData.event = 'onclick' then begin
          if Assigned(TLabel(ACtrl).OnClick) then begin
               TLabel(ACtrl).OnClick(TLabel(ACtrl));
          end;
     end else if joData.event = 'onenter' then begin
          if Assigned(TLabel(ACtrl).OnMouseEnter) then begin
               TLabel(ACtrl).OnMouseEnter(TLabel(ACtrl));
          end;
     end else if joData.event = 'onexit' then begin
          if Assigned(TLabel(ACtrl).OnMouseLeave) then begin
               TLabel(ACtrl).OnMouseLeave(TLabel(ACtrl));
          end;
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     //<����PageControl��ʱ���ߵ�����
     if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
          if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
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

     with TLabel(ACtrl) do begin
          sCode     := '<div '
                    +' v-html="'+Name+'__cap"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +_GetFont(Font)
                    //style
                    +_GetAlignment(TControl(ACtrl))
                    +dwIIF(Layout=tlCenter,'line-height:'+IntToStr(Height)+'px;','')
                    +'"'
                    //style ���

                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>{{'+Name+'__cap}}';
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
     if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
          if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
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
     joRes.Add('</div>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //<����PageControl��ʱ���ߵ�����
     if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
          if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
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
     with TLabel(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__cap:"'+dwProcessCaption(Caption)+'",');
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //<����PageControl��ʱ���ߵ�����
     if TLabel(ACtrl).Parent.ClassName = 'TTabSheet' then begin
          if TTabSheet(TLabel(ACtrl).Parent).PageControl.HelpKeyword = 'timeline' then begin
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
     with TLabel(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__cap="'+dwProcessCaption(Caption)+'";');
     end;
     //
     Result    := (joRes);
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetMethod,
     dwGetData;
     
begin
end.
 
