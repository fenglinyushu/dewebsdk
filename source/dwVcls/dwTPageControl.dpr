library dwTPageControl;

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

//--------------һЩ���ú���------------------------------------------------------------------------
function dwLTWHTab(ACtrl:TControl):String;  //���Ը���λ�õ��÷�
begin
     //ֻ��W��H
     with ACtrl do begin
          Result    := ' :style="{width:'+dwPrefix(Actrl)+Name+'__wid,height:'+dwPrefix(Actrl)+Name+'__hei}"'
                    +' style="position:absolute;left:0px;top:0px;';
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
     iTab      : Integer;
     joData    : Variant;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //����AData�ַ�����JSON����
               joData    := _json(AData);

               //�����¼�
               TPageControl(ACtrl).OnExit    := TPageControl(ACtrl).OnChange;

               //����¼�,�Է�ֹ�Զ�ִ��
               TPageControl(ACtrl).OnChange  := nil;
               //����ֵ
               for iTab := 0 to TPageControl(ACtrl).PageCount-1 do begin
                    if TPageControl(ACtrl).Pages[iTab].Name = joData.v then begin
                         TPageControl(ACtrl).ActivePageIndex     := iTab;
                         break;
                    end;
               end;
               //�ָ��¼�
               TPageControl(ACtrl).OnChange  := TPageControl(ACtrl).OnExit;

               //ִ���¼�
               if Assigned(TPageControl(ACtrl).OnChange) then begin
                    TPageControl(ACtrl).OnChange(TPageControl(ACtrl));
               end;

               //���OnExit�¼�
               TPageControl(ACtrl).OnExit  := nil;

          end;
     end;

end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iTab      : Integer;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------
               (*
               <div class="block">
                 <el-timeline>
                   <el-timeline-item timestamp="2018/4/12" placement="top">
                     <el-card>
                       <h4>���� Github ģ��</h4>
                       <p>��С�� �ύ�� 2018/4/12 20:46</p>
                     </el-card>
                   </el-timeline-item>
                   <el-timeline-item timestamp="2018/4/3" placement="top">
                     <el-card>
                       <h4>���� Github ģ��</h4>
                       <p>��С�� �ύ�� 2018/4/3 20:46</p>
                     </el-card>
                   </el-timeline-item>
                 </el-timeline>
               </div>
               *)

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               with TPageControl(ACtrl) do begin
                    //���
                    joRes.Add('<div class="block"'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +dwLTWH(TControl(ACtrl))
                              +'"' //style ���
                              +'>');
                    //���
                    joRes.Add('    <el-timeline>');

               end;
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

               with TPageControl(ACtrl) do begin
                    //���
                    joRes.Add('<el-tabs'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +' v-model="'+dwPrefix(Actrl)+Name+'__apg"'        //ActivePage
                              +' :tab-position="'+dwPrefix(Actrl)+Name+'__tps"'  //����λ��
                              +dwIIF(ParentBiDiMode,dwIIF(ParentShowHint,' type="border-card"',' type="card"'),'')   //�Ƿ������
                              +dwLTWH(TControl(ACtrl))
                              +'"' //style ���
                              +Format(_DWEVENT,['tab-click',Name,'this.'+dwPrefix(Actrl)+Name+'__apg','onchange',TForm(Owner).Handle])
                              +'>');

                    //���ѡ�
                    for iTab := 0 to PageCount-1 do begin
                         //
                         if (Pages[iTab].ImageIndex>0)and(Pages[iTab].ImageIndex<=280) then begin
                              joRes.Add('    <el-tab-pane'+' v-if="'+dwPrefix(Actrl)+Pages[iTab].Name+'__tbv" name="'+dwPrefix(Actrl)+Pages[iTab].Name+'">');
                              joRes.Add('    <span slot="label"><i class="'+dwIcons[Pages[iTab].ImageIndex]+'"></i> {{'+dwPrefix(Actrl)+Pages[iTab].Name+'__cap}}</span>');
                         end else begin
                              joRes.Add('    <el-tab-pane'+' v-if="'+dwPrefix(Actrl)+Pages[iTab].Name+'__tbv"'
                                   +' :label="'+dwPrefix(Actrl)+Pages[iTab].Name+'__cap" name="'+dwPrefix(Actrl)+Pages[iTab].Name+'">');
                         end;
                         //
                         joRes.Add('    </el-tab-pane>');
                    end;


                    //body��
                    joRes.Add('<div'+dwLTWHTab(TControl(ACtrl))+'">');

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
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('    </el-timeline>');
               //body��
               joRes.Add('</div>');
               //
               Result    := (joRes);
          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('    </div>');
               joRes.Add('</el-tabs>');
               //
               Result    := (joRes);
          end;
     end;
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TPageControl(ACtrl) do begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__apg:"'+dwPrefix(Actrl)+ActivePage.Name+'",');
                    //����
                    if TabPosition =  (tpTop) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"top",');
                    end else  if TabPosition =  (tpBottom) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"bottom",');
                    end else  if TabPosition =  (tpLeft) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"left",');
                    end else  if TabPosition =  (tpRight) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"right",');
                    end;
                    //��ҳ��ɼ���
                    for iTab := 0 to PageCount-1 do begin
                         joRes.Add(dwPrefix(Actrl)+Pages[iTab].Name+'__tbv:'+dwIIF(Pages[iTab].TabVisible,'true,','false,'));
                    end;
               end;
               //
               Result    := (joRes);
          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TPageControl(ACtrl) do begin
                    joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    if ActivePageIndex>=0 then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__apg:"'+dwPrefix(Actrl)+ActivePage.Name+'",');
                    end else begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__apg:"'+''+'",');
                    end;
                    //����
                    if TabPosition =  (tpTop) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"top",');
                    end else  if TabPosition =  (tpBottom) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"bottom",');
                    end else  if TabPosition =  (tpLeft) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"left",');
                    end else  if TabPosition =  (tpRight) then begin
                         joRes.Add(dwPrefix(Actrl)+Name+'__tps:"right",');
                    end;
                    //��ҳ��ɼ���
                    for iTab := 0 to PageCount-1 do begin
                         joRes.Add(dwPrefix(Actrl)+Pages[iTab].Name+'__tbv:'+dwIIF(Pages[iTab].TabVisible,'true,','false,'));
                    end;
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //����ʱ���߿ؼ�-------------------------------------------------

          end else if HelpKeyword = 'steps' then begin
               //�����������ؼ�-------------------------------------------------

          end else begin
               //����Tabs�ؼ�---------------------------------------------------

               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               //
               with TPageControl(ACtrl) do begin
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                    //
                    if ActivePageIndex>=0 then begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__apg="'+dwPrefix(Actrl)+ActivePage.Name+'";');
                    end else begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__apg="'+''+'";');
                    end;

                    //����
                    if TabPosition =  (tpTop) then begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tps="top";');
                    end else  if TabPosition =  (tpBottom) then begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tps="bottom";');
                    end else  if TabPosition =  (tpLeft) then begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tps="left";');
                    end else  if TabPosition =  (tpRight) then begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Name+'__tps="right";');
                    end;
                    //��ҳ��ɼ���
                    for iTab := 0 to PageCount-1 do begin
                         joRes.Add('this.'+dwPrefix(Actrl)+Pages[iTab].Name+'__tbv='+dwIIF(Pages[iTab].TabVisible,'true;','false;'));
                    end;
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
 
