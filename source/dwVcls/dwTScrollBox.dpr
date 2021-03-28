library dwTScrollBox;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
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

     if joData.e = 'onenter' then begin
          if Assigned(TScrollBox(ACtrl).OnEnter) then begin
               TScrollBox(ACtrl).OnEnter(TScrollBox(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TScrollBox(ACtrl).OnExit) then begin
               TScrollBox(ACtrl).OnExit(TScrollBox(ACtrl));
          end;
     end else if joData.e = 'onenddock' then begin
          if Assigned(TScrollBox(ACtrl).OnEndDock) then begin
               if joData.v > 0 then begin
                    TScrollBox(ACtrl).OnEndDock(TScrollBox(ACtrl),nil,joData.v,1);
               end else begin
                    TScrollBox(ACtrl).OnEndDock(TScrollBox(ACtrl),nil,abs(Integer(joData.v)),-1);
               end;
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
     with TScrollBox(ACtrl) do begin

          //
          sCode     := '<div'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style 封闭
                    //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                    +'>';
          joRes.Add(sCode);
          //
          sCode     := '<el-scrollbar'
                    +' ref="'+dwPrefix(Actrl)+Name+'"'
                    +' style="height:100%;"'
                    +dwIIF(True,Format(_DWEVENT,['scroll',Name,'0','onscroll',TForm(Owner).Handle]),'')
                    +'>';
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
     joRes.Add('</el-scrollbar>');
     joRes.Add('</div>');
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
     with TScrollBox(ACtrl) do begin
          joRes.Add(dwPrefix(Actrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(Actrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(Actrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          //joRes.Add(dwPrefix(Actrl)+Name+'__cap:"'+dwProcessCaption(Caption)+'",');
          //
          joRes.Add(dwPrefix(Actrl)+Name+'__typ:"'+dwGetProp(TScrollBox(ACtrl),'type')+'",');
          //保存oldscrolltop以确定滚动方向
          joRes.Add(dwPrefix(Actrl)+Name+'__ost:0,');
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
     with TScrollBox(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          //joRes.Add('this.'+dwPrefix(Actrl)+Name+'__cap="'+dwProcessCaption(Caption)+'";');
          //
          joRes.Add('this.'+dwPrefix(Actrl)+Name+'__typ="'+dwGetProp(TScrollBox(ACtrl),'type')+'";');
     end;
     //
     Result    := (joRes);
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
     sCode     : string;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TScrollBox(ACtrl) do begin
          if Assigned(OnEndDock) then begin
               sCode     := 'let '+dwPrefix(Actrl)+Name+'__scr = this.$refs.'+dwPrefix(Actrl)+Name+'.wrap;'
                    +dwPrefix(Actrl)+Name+'__scr.onscroll = function() {'
                         +'if (me.'+dwPrefix(Actrl)+Name+'__ost<'+dwPrefix(Actrl)+Name+'__scr.scrollTop) {'
                              +'axios.get(''{"m":"event","i":''+me.clientid+'',"e":"onenddock","c":"'+dwPrefix(Actrl)+Name+'","v":''+'+dwPrefix(Actrl)+Name+'__scr.scrollTop+''}'')'
                              +'.then(resp =>{me.procResp(resp.data);});'
                         +'} else {'
                              +'axios.get(''{"m":"event","i":''+me.clientid+'',"e":"onenddock","c":"'+dwPrefix(Actrl)+Name+'","v":-''+'+dwPrefix(Actrl)+Name+'__scr.scrollTop+''}'')'
                              +'.then(resp =>{me.procResp(resp.data);});'
                         +'};'
                         +'me.'+dwPrefix(Actrl)+Name+'__ost='+dwPrefix(Actrl)+Name+'__scr.scrollTop;'
                    +'};';
               joRes.Add(sCode);
          end;
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
     dwGetMounted,
     dwGetData;
     
begin
end.
 
