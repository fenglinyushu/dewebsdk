library dwTScanZing;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,
     Buttons,
     ExtCtrls,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//��ǰ�ؼ���Ҫ����ĵ�����JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
const
     ss : array[0..3] of string = (
          '<script type="text/javascript" src="ZXing_files/librarylatest"></script>',
          '<link rel="stylesheet" as="style" href="ZXing_files/css.css">',
          '<link rel="stylesheet" as="style" href="ZXing_files/normalize.css">',
          '<link rel="stylesheet" as="style" href="ZXing_files/milligram.css">'
     );
var
     joRes     : Variant;
     I         : Integer;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     for I := 0 to High(SS) do begin
          joRes.Add(SS[I]);
     end;
     //
     Result    := (joRes);
end;

//����JSON����ADataִ�е�ǰ�ؼ����¼�, �����ؽ���ַ���
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
     joData    : Variant;
const
     sJS       : string = 'let selectedDeviceId;'
                    +#13'const codeReader = new ZXing.BrowserMultiFormatReader()'
				+#13'codeReader.reset()'
				+#13'document.getElementById(''result'').textContent = '';'
				+#13'codeReader.decodeFromVideoDevice(selectedDeviceId, ''video'', (result, err) => {'
				+#13'	if (result) {'
				+#13'		console.log(result)'
				+#13'		document.getElementById(''result'').textContent = result.text'
				+#13'	}'
				+#13'	if (err && !(err instanceof ZXing.NotFoundException)) {'
				+#13'		console.error(err)'
				+#13'		document.getElementById(''result'').textContent = err'
				+#13'	}'
				+#13'})';
begin
     //
     joData    := _Json(AData);

     if joData.event = 'onclick' then begin
          with TBitBtn(ACtrl) do begin
               HelpKeyword    := HelpKeyword + sJS;
          end;
     end;
end;


//ȡ��HTMLͷ����Ϣ
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
     sCode     : String;

     //
     joHint    : Variant;
     joRes     : Variant;

begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');

     //ȡ��HINT����JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
     //��������Ϊ: JS�¼�����, �ؼ�����,�ؼ�ֵ,Delphi�¼�����,����


     //
     with TBitBtn(ACtrl) do begin
          //
          sCode     := '<video'
                    +' style="border: 1px solid gray"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style ���
                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>';
     end;
     joRes.Add(sCode);

     Result    := (joRes);
end;

//ȡ��HTMLβ����Ϣ
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //���ɷ���ֵ����
     joRes.Add('</video>');
     //
     Result    := (joRes);
end;

//ȡ��Data��Ϣ
function dwGetData(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TBitBtn(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          //joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          //joRes.Add(Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          //joRes.Add(Name+'__typ:"'+dwGetProp(TBitBtn(ACtrl),'type')+'",');
     end;
     //
     Result    := (joRes);
end;

//ȡ���¼�
function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //���ɷ���ֵ����
     joRes    := _Json('[]');
     //
     with TBitBtn(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          //joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          //joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          //joRes.Add('this.'+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          //joRes.Add('this.'+Name+'__typ="'+dwGetProp(TBitBtn(ACtrl),'type')+'";');
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
 
