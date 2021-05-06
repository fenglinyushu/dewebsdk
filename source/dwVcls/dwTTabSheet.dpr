library dwTTabSheet;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Math,
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
begin
     with TPageControl(TTabSheet(Actrl).PageControl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //
               if Assigned( TTabSheet(ACtrl).OnShow) then begin
                    TTabSheet(ACtrl).OnShow(TTabSheet(ACtrl));
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
     iCtrl     : Integer;
     oMemo     : TMemo;
     iLine     : Integer;
begin
     with TPageControl(TTabSheet(Actrl).PageControl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               //
               joRes.Add('        <el-timeline-item '
                         +' id="'+dwPrefix(Actrl)+Name+'"'
                         +dwIIF(TTabSheet(Actrl).ImageIndex>0,'icon="'+dwIcons[Max(1,TTabSheet(Actrl).ImageIndex)]+'"','')
                         //+dwGetHintValue(joHint,'type','type','')
                         +dwGetHintValue(joHint,'color','color','')
                         +' timestamp="'+IntToStr(TTabSheet(Actrl).Tag)+'" placement="top">');
               if ParentBiDiMode = True then begin
                    joRes.Add('            <el-card>');
               end;
               joRes.Add('                <h4>'+TTabSheet(Actrl).Caption+'</h4>');
               //
               for iCtrl := 0 to TWinControl(Actrl).ControlCount-1 do begin
                    if TWinControl(Actrl).Controls[iCtrl].ClassName = 'TLabel' then begin
                         joRes.Add('                <p>'+TLabel(TWinControl(Actrl).Controls[iCtrl]).Caption+'</p>');
                    end else if TWinControl(Actrl).Controls[iCtrl].ClassName = 'TMemo' then begin
                         oMemo     := TMemo(TWinControl(Actrl).Controls[iCtrl]);
                         for iLine := 0 to oMemo.Lines.Count-1 do begin
                              joRes.Add('                <p>'+oMemo.Lines[iLine]+'</p>');
                         end;
                    end;
               end;

               //
               if ParentBiDiMode = True then begin
                    joRes.Add('            </el-card>');
               end;
               joRes.Add('        </el-timeline-item>');

               //
               Result    := (joRes);
          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               with TTabSheet(ACtrl) do begin
                    sCode     := '<el-main'
                              +' id="'+dwPrefix(Actrl)+Name+'"'
                              +' v-if="'+dwPrefix(Actrl)+PageControl.Name+'__apg=='''+dwPrefix(Actrl)+Name+'''"'
                              +dwDisable(TControl(ACtrl))
                              +dwGetHintValue(joHint,'icon','icon','')
                              +' :style="{left:'+dwPrefix(Actrl)+Name+'__lef,'
                                    +'top:'+dwPrefix(Actrl)+Name+'__top,'
                                    +'width:'+dwPrefix(Actrl)+Name+'__wid,'
                                    +'height:'+dwPrefix(Actrl)+Name+'__hei}"'
                              +' style="position:absolute;overflow:hidden;'
                              +'"' //style ���
                              +dwIIF(Assigned(OnShow),Format(_DWEVENT,['tab-click',Name,'0','onclick',TForm(Owner).Handle]),'')
                              +'>';
                    //��ӵ�����ֵ����
                    joRes.Add(sCode);
               end;
               //
               Result    := (joRes);
          end;
     end;

end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TPageControl(TTabSheet(Actrl).PageControl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               Result    := (joRes);
          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('</el-main>');
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ��Data��Ϣ
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sKeyword  : String;
begin
     sKeyword  := TPageControl(TTabSheet(Actrl).PageControl).HelpKeyword;
     if sKeyword = 'timeline' then begin
          //����ʱ���߿ؼ�-------------------------------------------------

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TTabSheet(ACtrl) do begin
               joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(0)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(0)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
               //
               joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
               joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
               //
               joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          end;
          //
          Result    := (joRes);
     end else if sKeyword = 'steps' then begin
          //�����������ؼ�-------------------------------------------------

     end else begin
          //����Tabs�ؼ�---------------------------------------------------

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TTabSheet(ACtrl) do begin
               joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
               joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
               //
               joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
               joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
               //
               joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          end;
          //
          Result    := (joRes);
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sKeyword  : String;
begin
     sKeyword  := TPageControl(TTabSheet(Actrl).PageControl).HelpKeyword;
     if sKeyword = 'timeline' then begin
          //����ʱ���߿ؼ�-------------------------------------------------

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TTabSheet(ACtrl) do begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
               //
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          end;
          //
          Result    := (joRes);
     end else if sKeyword = 'steps' then begin
          //�����������ؼ�-------------------------------------------------

     end else begin
          //����Tabs�ؼ�---------------------------------------------------

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TTabSheet(ACtrl) do begin
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
               //
               joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
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
     dwGetMethod,
     dwGetData;

begin
end.

