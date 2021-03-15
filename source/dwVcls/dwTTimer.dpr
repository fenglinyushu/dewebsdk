library dwTTimer;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,ExtCtrls,
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
begin
     //
     if Assigned(TTimer(ACtrl).OnTimer) then  begin
          TTimer(ACtrl).OnTimer(TTimer(ACtrl));
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     with TTimer(ACtrl) do begin
          if DesignInfo = 1 then begin   //创建定时器
               sCode     := Name+'__tmr = window.setInterval(function() {'
                    +'axios.get(''{"m":"event","i":''+this.clientid+'',"c":"'+Name+'"}'')'
                    +'.then(resp =>{this.procResp(resp.data);  })'
                    +'}, '+IntToStr(Interval)+');';

          end else begin                     //清除定时器
               sCOde     := 'clearInterval('+Name+'__tmr);';
          end;
          joRes.Add(sCode);
     end;

     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
     sCode     : String;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     with TTimer(ACtrl) do begin
          if DesignInfo = 1 then begin   //创建定时器
               sCode     := 'me=this;'+Name+'__tmr = window.setInterval(function() {'
                    +'axios.get(''{"m":"event","i":'+IntToStr(TForm(Owner).Handle)+',"c":"'+Name+'"}'')'
                    +'.then(resp =>{me.procResp(resp.data);  })'
                    +'},'+IntToStr(Interval)+');';

          end else begin                     //清除定时器
               sCode     := 'clearInterval('+Name+'__tmr);';
          end;
          joRes.Add(sCode);
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
     dwGetData;
     
begin
end.
 
