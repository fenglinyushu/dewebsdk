library dwTBitBtn;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Buttons,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onenddock' then begin
          if Assigned(TBitBtn(ACtrl).OnEndDock) then begin
               TBitBtn(ACtrl).OnEndDock(TBitBtn(ACtrl),nil,0,0);
          end;
     end else if joData.e = 'onenter' then begin
          if Assigned(TBitBtn(ACtrl).OnEnter) then begin
               TBitBtn(ACtrl).OnEnter(TBitBtn(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TBitBtn(ACtrl).OnExit) then begin
               TBitBtn(ACtrl).OnExit(TBitBtn(ACtrl));
          end;
     end else if joData.e = 'getfilename' then begin
          TBitBtn(ACtrl).Caption   := dwUnescape(joData.v);
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
     sCode     : String;
     sSize     : String;

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
          //添加Form
          joRes.Add('<form'
                    +' id="'+Name+'__frm"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style 封闭
                    +' action="/dwupload"'
                    +' method="POST"'
                    +' enctype="multipart/form-data"'
                    +' target="upload_iframe"'
                    +'>');

          //添加Input
		joRes.Add('<input id="'+Name+'__inp" type="FILE" name="file"'
                    +' style="display:none"'
                    +dwGetHintValue(joHint,'accept','accept','')
                    +dwGetHintValue(joHint,'capture','capture','')
                    +' @change=dwInputChange('''+Name+''');>');

          //添加Button
          //得到大小：large/medium/small/mini
          if Height>50 then begin
               sSize     := ' size=large';
          end else if Height>35 then begin
               sSize     := ' size=medium';
          end else if Height>20 then begin
               sSize     := ' size=small';
          end else begin
               sSize     := ' size=mini';
          end;

          //
          sCode     := '<el-button'
                    +' id="'+Name+'__btn"'
                    +sSize
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    //+dwGetHintValue(joHint,'type','type',' type="default"')         //sButtonType
                    +' :type="'+Name+'__typ"'
                    +dwGetHintValue(joHint,'icon','icon','')         //ButtonIcon
                    +dwGetHintValue(joHint,'style','','')             //样式，空（默认）/plain/round/circle

                    +' style="width:100%;height:100%;"'
                    //默认选择文件
                    +' @click="dwInputClick('''+Name+'__inp'');"'

                    //其他事件
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick','']),'')
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>{{'+Name+'__cap}}';
          //
          joRes.Add(sCode);

     end;

     Result    := (joRes);
     //
     //@mouseenter.native=“enter”
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-button>');
     joRes.Add('</form>');
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
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          joRes.Add(Name+'__typ:"'+dwGetProp(TBitBtn(ACtrl),'type')+'",');
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
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+Name+'__typ="'+dwGetProp(TBitBtn(ACtrl),'type')+'";');
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

