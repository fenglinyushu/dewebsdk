library dwTSpinEdit;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Spin,
     StdCtrls, Windows;

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
     joData    := _json(AData);


     //保存事件
     TSpinEdit(ACtrl).OnExit    := TSpinEdit(ACtrl).OnChange;
     //清空事件,以防止自动执行
     TSpinEdit(ACtrl).OnChange  := nil;
     //更新值
     TSpinEdit(ACtrl).Value        := (joData.value);
     //恢复事件
     TSpinEdit(ACtrl).OnChange  := TSpinEdit(ACtrl).OnExit;

     //执行事件
     if Assigned(TSpinEdit(ACtrl).OnChange) then begin
          TSpinEdit(ACtrl).OnChange(TSpinEdit(ACtrl));
     end;

     //清空OnExit事件
     TSpinEdit(ACtrl).OnExit  := nil;
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

     with TSpinEdit(ACtrl) do begin
          if ( maxvalue =  0 ) and  ( maxvalue =  0 ) then begin
               joRes.Add('<el-input-number'
                         +' v-model="'+Name+'__val"'
                         +dwIIF(Ctl3D,'',' controls-position="right"')
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style 封闭
                         +Format(_DWEVENT,['change',Name,'(this.'+Name+'__val)','onchange',''])
                         +'>');
          end else begin
               joRes.Add('<el-input-number'
                         +' v-model="'+Name+'__val"'
                         +' :min="'+Name+'__min" :max="'+Name+'__max"'
                         +dwIIF(Ctl3D,'',' controls-position="right"')
                         +dwVisible(TControl(ACtrl))
                         +dwDisable(TControl(ACtrl))
                         +dwLTWH(TControl(ACtrl))
                         +'"' //style 封闭
                         +Format(_DWEVENT,['change',Name,'(this.'+Name+'__val)','onchange',''])
                         +'>');
          end;
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
     joRes.Add('</el-input-number>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TSpinEdit(ACtrl) do begin
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__val:"'+IntToStr(Value)+'",');
          joRes.Add(Name+'__min:"'+IntToStr(MinValue)+'",');
          joRes.Add(Name+'__max:"'+IntToStr(MaxValue)+'",');
     end;
     //
     Result    := (joRes);
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TSpinEdit(ACtrl) do begin
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__val="'+IntToStr(Value)+'";');
          joRes.Add('this.'+Name+'__min="'+IntToStr(MinValue)+'";');
          joRes.Add('this.'+Name+'__max="'+IntToStr(MaxValue)+'";');
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
 
