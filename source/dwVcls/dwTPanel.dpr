library dwTPanel;

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
begin
     with TPanel(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //
               joData    := _Json(AData);

               if joData.e = 'onclick' then begin
                    TPanel(ACtrl).OnClick(TPanel(ACtrl));
               end else if joData.e = 'onenter' then begin
                    TPanel(ACtrl).OnEnter(TPanel(ACtrl));
               end else if joData.e = 'onexit' then begin
                    TPanel(ACtrl).OnExit(TPanel(ACtrl));
               end;
          end;
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sEnter    : String;
     sExit     : String;
     sClick    : string;
begin
     with TPanel(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               sCode     := '<el-dialog :title="'+dwPrefix(Actrl)+Name+'__cap" :visible.sync="'+dwPrefix(Actrl)+Name+'_vis" >';

               //��ӵ�����ֵ����
               joRes.Add(sCode);
               //
               Result    := (joRes);


          end else begin
               //===============================================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //�����¼�����--------------------------------------------------------
               sEnter  := '';
               if joHint.Exists('onenter') then begin
                    sEnter  := joHint.onenter;
               end;
               if sEnter='' then begin
                    if Assigned(OnEnter) then begin
                         sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]);
                    end else begin

                    end;
               end else begin
                    if Assigned(OnEnter) then begin
                         sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',TForm(Owner).Handle])
                    end else begin
                         sEnter    := ' @mouseenter.native="'+sEnter+'"';
                    end;
               end;


               //�˳��¼�����--------------------------------------------------------
               sExit  := '';
               if joHint.Exists('onexit') then begin
                    sExit  := joHint.onexit;
               end;
               if sExit='' then begin
                    if Assigned(OnExit) then begin
                         sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]);
                    end else begin

                    end;
               end else begin
                    if Assigned(OnExit) then begin
                         sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',TForm(Owner).Handle])
                    end else begin
                         sExit    := ' @mouseleave.native="'+sExit+'"';
                    end;
               end;

               //�����¼�����--------------------------------------------------------
               sClick    := '';
               if joHint.Exists('onclick') then begin
                    sClick := joHint.onclick;
               end;
               //
               if sClick='' then begin
                    if Assigned(OnClick) then begin
                         sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick',TForm(Owner).Handle]);
                    end else begin

                    end;
               end else begin
                    if Assigned(OnClick) then begin
                         sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',TForm(Owner).Handle])
                    end else begin
                         sClick    := ' @click.native="'+sClick+'"';
                    end;
               end;


               //
               sCode     := '<el-main'
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         //+dwGetHintValue(joHint,'type','type',' type="default"')
                         //+dwGetHintValue(joHint,'icon','icon','')
                         +' :style="{backgroundColor:'+dwPrefix(Actrl)+Name+'__col,left:'+dwPrefix(Actrl)+Name+'__lef,top:'+dwPrefix(Actrl)+Name+'__top,width:'+dwPrefix(Actrl)+Name+'__wid,height:'+dwPrefix(Actrl)+Name+'__hei}"'
                         +' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                         +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                         +dwGetHintStyle(joHint,'borderradius','border-radius','')   //border-radius
                         +'"' //style ���
                         +sClick
                         +sEnter
                         +sExit
                         +'>';
               //��ӵ�����ֵ����
               joRes.Add(sCode);
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     with TPanel(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               sCode     := '</el-dialog>';

               //��ӵ�����ֵ����
               joRes.Add(sCode);
               //
               Result    := (joRes);
          end else begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('</el-main>');
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TPanel(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TPanel(ACtrl) do begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__col:"'+dwColor(Color)+'",');
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TPanel(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TPanel(ACtrl) do begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__col="'+dwColor(Color)+'";');
               end;
               //
               Result    := (joRes);
          end;
     end;
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
 
