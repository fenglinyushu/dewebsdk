library dwTGroupBox;

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

     if joData.e = 'onclick' then begin
          TGroupBox(ACtrl).OnClick(TGroupBox(ACtrl));
     end else if joData.e = 'onenter' then begin
          TGroupBox(ACtrl).OnEnter(TGroupBox(ACtrl));
     end else if joData.e = 'onexit' then begin
          TGroupBox(ACtrl).OnExit(TGroupBox(ACtrl));
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     with TGroupBox(ACtrl) do begin
          //���
          sCode     := '<el-main'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    //+dwGetHintValue(joHint,'type','type',' type="default"')
                    //+dwGetHintValue(joHint,'icon','icon','')         
                    +' :style="{left:'+dwPrefix(Actrl)+Name+'__lef,top:'+dwPrefix(Actrl)+Name+'__top,width:'+dwPrefix(Actrl)+Name+'__wid,height:'+dwPrefix(Actrl)+Name+'__hei}"'
                    +' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                    +'"' //style ���
                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);

          //�ڿ�
          sCode     := '    <el-main'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    //+dwGetHintValue(joHint,'type','type',' type="default"')
                    //+dwGetHintValue(joHint,'icon','icon','')
                    +' :style="{backgroundColor:'+dwPrefix(Actrl)+Name+'__col,left:''2px'',top:''10px'',width:'+dwPrefix(Actrl)+Name+'__wi2,height:'+dwPrefix(Actrl)+Name+'__he2}"'
                    +' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                    +'border-radius: 4px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);'
                    +dwGetHintStyle(joHint,'borderradius','border-radius','')   //border-radius
                    +'"' //style ���
                    +'></el-main>';
          //��ӵ�����ֵ����
          joRes.Add(sCode);

          //����
          sCode     := '    <div '
                    +' v-html="'+dwPrefix(Actrl)+Name+'__cap"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' :style="{backgroundColor:'+dwPrefix(Actrl)+Name+'__col,left:''20px'',top:''0px'',height:''20px''}"'
                    +' style="position:absolute;'
                    +'line-height:20px;'
                    +_GetFont(Font)
                    +'"'
                    //style ���
                    +'>{{'+dwPrefix(Actrl)+Name+'__cap}}'
                    +'</div>';
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
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</el-main>');
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TGroupBox(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__wi2:"'+IntToStr(Width-5)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__he2:"'+IntToStr(Height-12)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__col:"'+dwColor(Color)+'",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
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
     with TGroupBox(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wi2="'+IntToStr(Width-5)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__he2="'+IntToStr(Height-12)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__col="'+dwColor(Color)+'";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
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
 
