library dwTImage;

uses
     ShareMem,      //�������

     //
     dwCtrlBase,    //һЩ��������

     //
     SynCommons,    //mormot���ڽ���JSON�ĵ�Ԫ

     //
     SysUtils,DateUtils,ComCtrls, ExtCtrls,
     Vcl.Imaging.jpeg,Vcl.Graphics,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

const
     CodeChar: array [0 .. 31] of char = (
          '2','3','4','5','6','7','8','9',
          'A','B','C','D','E','F','G','H',
          'J','K','L','M','N','P','Q','R',
          'S','T','U','V','W','X','Y','Z');

     CodeChar1: array [0 .. 31] of char = (
          '��','��','��','��','��','��','��','��','��',
          '��','Ӣ','Ȧ','��','��','ƽ','��','��','Ҫ',
          '��','��','��','��','��','ֵ','��','��','��',
          'ǹ','��','��','Ѽ','��');


function _CreateCaptcha(AWidth,AHeight:Integer;var ASrc,ACaptcha:String):Integer;
var
     //
     iFont     : Integer;
     I,X,Y     : Integer;
     sTmp      : String;
     oBmp      : Vcl.Graphics.TBitmap;

begin
     try
          //�ļ�����=���ǰ׺�������и��ģ�+����
          ASrc     := 'LJTRNB_'+FormatDateTime('YYYYMMdd_hhmmss_zzz',now)+'.jpg';
          //
          oBmp := Vcl.Graphics.TBitmap.Create;
          oBmp.Width     := AWidth;
          oBmp.Height    := AHeight;
          oBmp.Canvas.Pen.Width    := 1;
          iFont     := AWidth div 8; //����дN���ַ���
          oBmp.Canvas.Font.Size:= iFont;
          oBmp.Canvas.Font.Name:='΢���ź�';
          oBmp.Canvas.Font.Color:=clGreen;
          //���������200��
          for I := 0 to (AWidth*AHeight) div 300 do  begin
               Randomize;
               oBmp.Canvas.Pen.Color:= RGB(Random(156)+100, Random(156)+100,Random(156)+100);
               oBmp.Canvas.MoveTo(Random(AWidth),Random(AHeight));
               oBmp.Canvas.LineTo(Random(AWidth),Random(AHeight));
          end;
          oBmp.Canvas.Font.Color:=RGB(Random(10), Random(100),Random(100));//clBlack;
          oBmp.Canvas.Font.Style:=[fsBold,fsItalic];


          //������ĸ��ַ�
          X    := 0;
          ACaptcha  := '';
          oBmp.Canvas.Brush.Style:=bsClear;
          for I :=0 to 3 do begin
               Randomize;
               sTmp      := CodeChar[Random(Length(CodeChar))];
               ACaptcha  := ACaptcha + sTmp;
               X    := X + Random((AWidth-iFont*2) div 4);
               oBmp.Canvas.TextOut(X,Random(AHeight-iFont*2),sTmp);
               x:=x+iFont;
          end;

          //���������
          for I := 0 to (AWidth*AHeight) div 400 do  begin
               Randomize;
               oBmp.Canvas.Pen.Color:= RGB(Random(156)+100, Random(156)+100,Random(156)+100);
               oBmp.Canvas.MoveTo(Random(AWidth),Random(AHeight));
               oBmp.Canvas.LineTo(Random(AWidth),Random(AHeight));
          end;

          //
          oBmp.SaveToFile('media/images/'+ASrc);
          oBmp.Destroy;
          //>

          //
          Result    := 1;
     except
     end;
end;


//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS ,һ��Ϊ�����Ķ�,Ŀǰ����TChartʹ��ʱ��Ҫ�õ�
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============��֤��=================================================

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
     end else begin
          //=============��ͨͼƬ===============================================

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
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
     sSrc      : string;
     sCaptcha  : string;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============��֤��=================================================
          //
          joData    := _Json(AData);

          if joData.e = 'onclick' then begin
               //����������֤��
               with TImage(ACtrl) do begin
                    _CreateCaptcha(Width,Height,sSrc,sCaptcha);
                    //
                    Hint := '{"src":"media/images/'+sSrc+'","captcha":"'+sCaptcha+'"}';
               end;
          end;
     end else begin
          //=============��ͨͼƬ===============================================

          //
          joData    := _Json(AData);

          if joData.e = 'onclick' then begin
               //
               if Assigned(TImage(ACtrl).OnClick) then begin
                    TImage(ACtrl).OnClick(TImage(ACtrl));
               end;
          end else if joData.e = 'onenter' then begin
               //
               if Assigned(TImage(ACtrl).OnMouseEnter) then begin
                    TImage(ACtrl).OnMouseEnter(TImage(ACtrl));
               end;
          end else if joData.e = 'onexit' then begin
               //
               if Assigned(TImage(ACtrl).OnMouseLeave) then begin
                    TImage(ACtrl).OnMouseLeave(TImage(ACtrl));
               end;
          end;
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     sSize     : string;
     sName     : string;
     sRadius   : string;
     //
     joHint    : Variant;
     joRes     : Variant;
     sSrc      : String;
     sCaptcha  : string;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============��֤��=================================================

          //���ɷ���ֵ����
          joRes    := _Json('[]');

          //ȡ��HINT����JSON
          joHint    := dwGetHintJson(TControl(ACtrl));


          with TImage(ACtrl) do begin
               //������֤��
               _CreateCaptcha(Width,Height,sSrc,sCaptcha);
               //
               Hint := '{"src":"media/images/'+sSrc+'","captcha":"'+sCaptcha+'"}';

               //
               joRes.Add('<el-image'
                         +' id="'+Name+'"'
                         +' :src="'+Name+'__src"'
                         +' fit="none"'
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +dwLTWH(TControl(ACtrl))
                         +sRadius
                         +'cursor: pointer;'
                         +'"'
                         +dwIIF(True,Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    +'>');
          end;

          //
          Result    := (joRes);

     end else begin
          //=============��ͨͼƬ===============================================

          //���ɷ���ֵ����
          joRes    := _Json('[]');

          //ȡ��HINT����JSON
          joHint    := dwGetHintJson(TControl(ACtrl));

          //�õ�Բ�ǰ뾶��Ϣ
          sRadius   := dwGetHintValue(joHint,'radius','border-radius','');
          sRadius   := StringReplace(sRadius,'=',':',[]);
          sRadius   := Trim(StringReplace(sRadius,'"','',[rfReplaceAll]));
          if sRadius<>'' then begin
               sRadius   := sRadius + ';';
          end;

          with TImage(ACtrl) do begin
               //���û���ֶ�����ͼƬԴ�����Զ����浱ǰͼƬ��������ΪͼƬԴ
               if dwGetProp(TControl(ACtrl),'src')='' then begin
                    sName     := 'dist\webimages\'+Name+'.jpg';
                    //����ͼƬ������
                    if not FileExists(sName) then begin
                         Picture.SaveToFile(sName);
                    end;
               end;

               if Proportional then begin
                    joRes.Add('<el-image'
                              +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                              +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                              +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                              +' :src="'+Name+'__src" fit="contain"'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +dwLTWH(TControl(ACtrl))
                              +sRadius
                              +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                              +'"'
                              +'>');
               end else begin
                    if Stretch then begin
                         joRes.Add('<el-image :src="'+Name+'__src" fit="fill"'
                                   +dwVisible(TControl(ACtrl))
                                   +dwDisable(TControl(ACtrl))
                                   +dwLTWH(TControl(ACtrl))
                                   +sRadius
                                   +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                                   +'"'
                                   +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                                   +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                                   +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                              +'>');
                    end else begin
                         joRes.Add('<el-image :src="'+Name+'__src" fit="none"'
                                   +dwVisible(TControl(ACtrl))
                                   +dwDisable(TControl(ACtrl))
                                   +dwLTWH(TControl(ACtrl))
                                   +sRadius
                                   +dwIIF(Assigned(OnClick),'cursor: pointer;','')
                                   +'"'
                                   +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                                   +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                                   +dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                              +'>');
                    end;
               end;
          end;

          //
          Result    := (joRes);
     end;
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============��֤��=================================================


          //���ɷ���ֵ����
          joRes    := _Json('[]');

          //���ɷ���ֵ����
          joRes.Add('</el-Image>');          //�˴���Ҫ��dwGetHead��Ӧ

          //
          Result    := (joRes);
     end else begin
          //=============��ͨͼƬ===============================================

          //���ɷ���ֵ����
          joRes    := _Json('[]');

          //���ɷ���ֵ����
          joRes.Add('</el-Image>');          //�˴���Ҫ��dwGetHead��Ӧ

          //
          Result    := (joRes);
     end;
end;

//ȡ��Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============��֤��=================================================

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
               joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
               joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
               joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
               //
               joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
               joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
               //
               joRes.Add(Name+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
          end;
          //
          Result    := (joRes);
     end else begin
          //=============��ͨͼƬ===============================================

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
               joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
               joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
               joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
               //
               joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
               joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
               //
               if dwGetProp(TControl(ACtrl),'src')='' then begin
                    joRes.Add(Name+'__src:"dist/webimages/'+Name+'.jpg",');
               end else begin
                    joRes.Add(Name+'__src:"'+dwGetProp(TControl(ACtrl),'src')+'",');
               end;
          end;
          //
          Result    := (joRes);
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     if TImage(ACtrl).HelpKeyword = 'captcha' then begin
          //=============��֤��=================================================


          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
               //
               joRes.Add('this.'+Name+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
          end;
          //
          Result    := (joRes);
     end else begin
          //=============��ͨͼƬ===============================================

          //���ɷ���ֵ����
          joRes    := _Json('[]');
          //
          with TImage(ACtrl) do begin
               joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
               joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
               joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
               //
               joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
               joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
               //
               if dwGetProp(TControl(ACtrl),'src')='' then begin
                    joRes.Add('this.'+Name+'__src="dist/webimages/'+Name+'.jpg";');
               end else begin
                    joRes.Add('this.'+Name+'__src="'+dwGetProp(TControl(ACtrl),'src')+'";');
               end;
          end;
          //
          Result    := (joRes);
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
 
