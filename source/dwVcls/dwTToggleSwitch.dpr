library dwTToggleSwitch;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Vcl.WinXCtrls,
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     with TToggleSwitch(ACtrl) do begin
          if joData.e = 'onclick' then begin
               if joData.v = 'true' then begin
                    State     := tssON;
               end else begin
                    State     := tssOFF;
               end;
               if Assigned(OnClick) then begin
                    OnClick(TToggleSwitch(ACtrl));
               end;
          end else if joData.e = 'onenter' then begin
               if Assigned(OnEnter) then begin
                    OnEnter(TToggleSwitch(ACtrl));
               end;
          end else if joData.e = 'onexit' then begin
               if Assigned(OnExit) then begin
                    OnExit(TToggleSwitch(ACtrl));
               end;
          end;
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));
(*

<el-switch
  style="display: block"
  v-model="value2"
  active-color="#13ce66"
  inactive-color="#ff4949"
  active-text="按月付费"
  inactive-text="按年付费">
</el-switch>

*)
     with TToggleSwitch(ACtrl) do begin
          sCode     := '<el-switch'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+Name+'__sta"'
                    +' :width="'+Name+'__stw"'
                    +' :active-color="'+Name+'__acc"'
                    +' :inactive-color="'+Name+'__inc"'
                    +' :active-text="'+Name+'__act"'
                    +' :inactive-text="'+Name+'__int"'
                    //+dwGetHintValue(joHint,'type','type',' type="default"')         //sCheckBoxType
                    //+dwGetHintValue(joHint,'icon','icon','')         //CheckBoxIcon
                    //
                    +dwLTWH(TControl(ACtrl))
                    +'display: block;'
                    +'"' //style 封闭
                    +Format(_DWEVENT,['change',Name,'this.'+Name+'__sta','onclick',''])
                    +dwIIF(Assigned(OnEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter','']),'')
                    +dwIIF(Assigned(OnExit),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit','']),'')
                    +'>';
          //添加到返回值数据
          joRes.Add(sCode);
     end;
     //
     Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</el-switch>');
     //
     Result    := (joRes);
end;

//取得Data消息, ASeparator为分隔符, 一般为:或=
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TToggleSwitch(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));

          //
          joRes.Add(Name+'__stw:'+IntToStr(SwitchWidth)+',');
          joRes.Add(Name+'__sta:'+dwIIF(State = tssOn,'true,','false,'));
          joRes.Add(Name+'__acc:"'+dwColor(ThumbColor)+'",');
          joRes.Add(Name+'__inc:"'+dwColor(DisabledColor)+'",');
          //
          joRes.Add(Name+'__act:"'+StateCaptions.CaptionOn+'",');
          joRes.Add(Name+'__int:"'+StateCaptions.CaptionOff+'",');
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
     with TToggleSwitch(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          //
          joRes.Add('this.'+Name+'__stw='+IntToStr(SwitchWidth)+';');
          joRes.Add('this.'+Name+'__sta='+dwIIF(State = tssOn,'true;','false;'));
          joRes.Add('this.'+Name+'__acc="'+dwColor(ThumbColor)+'";');
          joRes.Add('this.'+Name+'__inc="'+dwColor(DisabledColor)+'";');
          //
          joRes.Add('this.'+Name+'__act="'+StateCaptions.CaptionOn+'";');
          joRes.Add('this.'+Name+'__int="'+StateCaptions.CaptionOff+'";');
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
 
