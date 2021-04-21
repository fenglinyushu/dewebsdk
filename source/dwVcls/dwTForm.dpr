library dwTForm;

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
     oAction   : TCloseAction;
begin
     with TForm(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //
               joData    := _Json(AData);

               if joData.e = 'onclose' then begin
                    TForm(ACtrl).OnClose(TForm(ACtrl),oAction);
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
     with TForm(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin


          end else begin
               //===============================================================

               //���ɷ���ֵ����
               joRes    := _Json('[]');

               //ȡ��HINT����JSON
               joHint    := dwGetHintJson(TControl(ACtrl));



               //�˳��¼�����--------------------------------------------------------
               sExit  := '';
               if joHint.Exists('onexit') then begin
                    sExit  := joHint.onexit;
               end;
               if sExit='' then begin
                    if Assigned(OnClose) then begin
                         sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',Handle]);
                    end else begin

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
                         sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick',Handle]);
                    end else begin

                    end;
               end else begin
                    if Assigned(OnClick) then begin
                         sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',Handle])
                    end else begin
                         sClick    := ' @click.native="'+sClick+'"';
                    end;
               end;

               //
               sCode     := '<el-dialog'
                         +' :title="'+Name+'__cap"'
                         +' width="'+IntToStr(Width+40)+'px"'
                         +' :visible.sync="'+Name+'__vis"'
                         +' :close-on-click-modal="false"'
                         +'>';
               //:width='+Name+'__wid :height='+Name+'__hei
               //��ӵ�����ֵ����
               joRes.Add(sCode);

               //
               sCode     := '<el-form'
                         +' id="'+Name+'"'
                         +' v-if="'+Name+'__vis"'
                         //+dwGetHintValue(joHint,'type','type',' type="default"')
                         //+dwGetHintValue(joHint,'icon','icon','')
                         +' :style="{'
                              //+'backgroundColor:'+Name+'__col,'
                              +'left:'+Name+'__lef,top:'+Name+'__top,width:'+Name+'__wid,height:'+Name+'__hei}"'
                         +' style="position:relative;overflow:hidden;'
                         //+dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                         //+dwGetHintStyle(joHint,'borderradius','border-radius','')   //border-radius
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
     with TForm(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //���ɷ���ֵ����
               joRes.Add('</el-form>');
               joRes.Add('</el-dialog>');
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
     with TForm(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TForm(ACtrl) do begin
                    joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(Name+'__wid:"'+IntToStr(ClientWidth)+'px",');
                    joRes.Add(Name+'__hei:"'+IntToStr(ClientHeight)+'px",');
                    //
                    joRes.Add(Name+'__col:"'+dwColor(Color)+'",');
                    //
                    joRes.Add(Name+'__vis:false,');     //Ĭ�ϲ���ʾ
                    //����
                    joRes.Add(Name+'__cap:"'+Caption+'",');
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
     with TForm(ACtrl) do begin
          if HelpKeyword = 'dialog' then begin

          end else begin
               //���ɷ���ֵ����
               joRes    := _Json('[]');
               //
               with TForm(ACtrl) do begin
                    joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+Name+'__wid="'+IntToStr(ClientWidth)+'px";');
                    joRes.Add('this.'+Name+'__hei="'+IntToStr(ClientHeight)+'px";');
                    //
                    //joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    //joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                    //
                    joRes.Add('this.'+Name+'__col="'+dwColor(Color)+'";');
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
 
