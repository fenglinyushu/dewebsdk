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

//当前控件需要引入的第三方JS/CSS
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
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     for I := 0 to High(SS) do begin
          joRes.Add(SS[I]);
     end;
     //
     Result    := (joRes);
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
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

     if joData.e = 'onclick' then begin
          with TBitBtn(ACtrl) do begin
               HelpKeyword    := HelpKeyword + sJS;
          end;
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
     sCode     : String;

     //
     joHint    : Variant;
     joRes     : Variant;

begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //_DWEVENT = ' @%s="dwevent($event,''%s'',''%s'',''%s'',''%s'')"';
     //参数依次为: JS事件名称, 控件名称,控件值,Delphi事件名称,备用


     //
     with TBitBtn(ACtrl) do begin
          //
          sCode     := '<video'
                    +' style="border: 1px solid gray"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style 封闭
                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    //+dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
     end;
     joRes.Add(sCode);

     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</video>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TBitBtn(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          //joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          //joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          //joRes.Add(dwPrefix(Actrl)+Name+'__typ:"'+dwGetProp(TBitBtn(ACtrl),'type')+'",');
     end;
     //
     Result    := (joRes);
end;

//取得事件
function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TBitBtn(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          //joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          //joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          //joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          //joRes.Add('this.'+dwPrefix(Actrl)+Name+'__typ="'+dwGetProp(TBitBtn(ACtrl),'type')+'";');
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
 
