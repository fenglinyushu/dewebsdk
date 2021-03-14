library dwTLabeledEdit;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

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

function _GetFontWeight(AFont:TFont):String;
begin
     if fsBold in AFont.Style then begin
          Result    := 'bold';
     end else begin
          Result    := 'normal';
     end;

end;
function _GetFontStyle(AFont:TFont):String;
begin
     if fsItalic in AFont.Style then begin
          Result    := 'italic';
     end else begin
          Result    := 'normal';
     end;
end;
function _GetTextDecoration(AFont:TFont):String;
begin
     if fsUnderline in AFont.Style then begin
          Result    :='underline';
          //ɾ����
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end;
     end else begin
          //ɾ����
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end else begin
               Result    := 'none';
          end;
     end;
end;
function _GetTextAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TLabel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
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


//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TChartʹ��ʱ��Ҫ�õ�
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     {
     //������TChartʱ�Ĵ���,���ο�
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }

     //
     Result    := joRes;
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
begin
     //
     joData    := _Json(AData);


     if joData.e = 'onenter' then begin
          if Assigned(TLabeledEdit(ACtrl).OnEnter) then begin
               TLabeledEdit(ACtrl).OnEnter(TLabeledEdit(ACtrl));
          end;
     end else if joData.e = 'onchange' then begin
          //�����¼�
          oChange   := TLabeledEdit(ACtrl).OnChange;
          //����¼�,�Է�ֹ�Զ�ִ��
          TLabeledEdit(ACtrl).OnChange  := nil;
          //����ֵ
          TLabeledEdit(ACtrl).Text    := dwUnescape(dwUnescape(joData.v));
          //�ָ��¼�
          TLabeledEdit(ACtrl).OnChange  := oChange;

          //ִ���¼�
          if Assigned(TLabeledEdit(ACtrl).OnChange) then begin
               TLabeledEdit(ACtrl).OnChange(TLabeledEdit(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TLabeledEdit(ACtrl).OnExit) then begin
               TLabeledEdit(ACtrl).OnExit(TLabeledEdit(ACtrl));
          end;
     end else if joData.e = 'onmouseenter' then begin
          if Assigned(TLabeledEdit(ACtrl).OnMouseEnter) then begin
               TLabeledEdit(ACtrl).OnMouseEnter(TLabeledEdit(ACtrl));
          end;
     end else if joData.e = 'onmouseexit' then begin
          if Assigned(TLabeledEdit(ACtrl).OnMouseLeave) then begin
               TLabeledEdit(ACtrl).OnMouseLeave(TLabeledEdit(ACtrl));
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
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));
     with TLabeledEdit(ACtrl) do begin
          //��ӱ�ǩ
          sCode     := '<div '
                    +' v-html="'+Name+'__lbc"'

                    //:style
                    +' :style="{left:'+Name+'__lbl,top:'+Name+'__lbt,width:'+Name+'__lbw,height:'+Name+'__lbh}"'

                    //style
                    +' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';'
                    +_GetFont(TLabeledEdit(ACtrl).EditLabel.Font)
                    +dwIIF(TLabeledEdit(ACtrl).EditLabel.Layout=tlCenter,'line-height:'+IntToStr(Height)+'px;','')
                    +'"'

                   +'>{{'+Name+'__lbc}}</div>';

          //��ӵ�����ֵ����
          joRes.Add(sCode);

          sCode     := '<el-input'
                    +dwVisible(TControl(ACtrl))                            //���ڿ��ƿɼ���Visible
                    +dwDisable(TControl(ACtrl))                            //���ڿ��ƿ�����Enabled(���ֿؼ���֧��)
                    +dwIIF(PasswordChar=#0,'',' show-password')            //�Ƿ�Ϊ����
                    +' v-model="'+Name+'__txt"'                            //ǰ��
                    +dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,��ʾ��
                    +dwGetHintValue(joHint,'prefix-icon','prefix-icon','') //ǰ��Icon
                    +dwGetHintValue(joHint,'suffix-icon','suffix-icon','') //����Icon
                    //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +' :style="{left:'+Name+'__edl,top:'+Name+'__edt,width:'+Name+'__edw,height:'+Name+'__edh}"'
                    +' style="position:absolute;'
                         +dwGetHintStyle(joHint,'borderradius','border-radius','border-radius:4px;')   //border-radius
                         +dwGetHintStyle(joHint,'border','border','border:1px solid #DCDFE6;')   //border-radius
                         +'overflow: hidden;'
                    +'"' // ���style
                    +Format(_DWEVENT,['input',Name,'escape(this.'+Name+'__txt)','onchange','']) //���¼�
                    //+dwIIF(Assigned(OnChange),    Format(_DWEVENT,['input',Name,'(this.'+Name+'__txt)','onchange','']),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter','']),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit','']),'')
                    +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',Name,'0','onexit','']),'')
                    +'></el-input>';
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
     //
     Result    := (joRes);
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     //����
     iL,iT     : Integer;
     iW,iH     : Integer;
     //��ǩ
     iLbL,iLbT : Integer;
     iLbW,iLbH : Integer;
     //�༭��
     iEdL,iEdT : Integer;
     iEdW,iEdH : Integer;

begin

     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TLabeledEdit(ACtrl) do begin
          //
          //joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          //joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          //joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          //joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__txt:"'+dwChangeChar(Text)+'",');



          //Label
          joRes.Add(Name+'__lbl:"'+IntToStr(EditLabel.Left)+'px",');
          joRes.Add(Name+'__lbt:"'+IntToStr(EditLabel.Top)+'px",');
          joRes.Add(Name+'__lbw:"'+IntToStr(EditLabel.Width)+'px",');
          joRes.Add(Name+'__lbh:"'+IntToStr(EditLabel.Height)+'px",');
          joRes.Add(Name+'__lbc:"'+EditLabel.Caption+'",');

          //Edit
          joRes.Add(Name+'__edl:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__edt:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__edw:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__edh:"'+IntToStr(Height)+'px",');

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
     with TLabeledEdit(ACtrl) do begin
          //
          //joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          //joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          //joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          //joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__txt="'+dwChangeChar(Text)+'";');

          //Label
          joRes.Add('this.'+Name+'__lbl="'+IntToStr(EditLabel.Left)+'px";');
          joRes.Add('this.'+Name+'__lbt="'+IntToStr(EditLabel.Top)+'px";');
          joRes.Add('this.'+Name+'__lbw="'+IntToStr(EditLabel.Width)+'px";');
          joRes.Add('this.'+Name+'__lbh="'+IntToStr(EditLabel.Height)+'px";');
          joRes.Add('this.'+Name+'__lbc="'+EditLabel.Caption+'";');

          //Edit
          joRes.Add('this.'+Name+'__edl="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__edt="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__edw="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__edh="'+IntToStr(Height)+'px";');
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
 
