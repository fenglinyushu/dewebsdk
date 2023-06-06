library dwTCheckBox;

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
     Graphics,
     Controls,
     Forms;

{
     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;
}
function _GetFont(AFont:TFont):string;
begin
     Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size+3)+'px;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;


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

     if joData.e = 'onclick' then begin
          //保存事件
          TCheckBox(ACtrl).OnExit := TCheckBox(ACtrl).OnClick;
          //清空事件,以防止自动执行
          TCheckBox(ACtrl).OnClick := nil;
          //更新值
          TCheckBox(ACtrl).Checked := dwUnescape(joData.v)='true';
          //恢复事件
          TCheckBox(ACtrl).OnClick := TCheckBox(ACtrl).OnExit;
          //执行事件
          if Assigned(TCheckBox(ACtrl).OnClick) then begin
               TCheckBox(ACtrl).OnClick(TCheckBox(ACtrl));
          end;
          //清空OnExit事件
          TCheckBox(ACtrl).OnExit := nil;
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

     with TCheckBox(ACtrl) do begin
          sCode     := '<el-checkbox'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+dwFullName(Actrl)+'__chk"'
                    +dwGetHintValue(joHint,'type','type',' type="default"')         //sCheckBoxType
                    +dwGetHintValue(joHint,'icon','icon','')         //CheckBoxIcon
                    +dwGetDWAttr(joHint)
                    +dwLTWH(TControl(ACtrl))
                    +dwGetDWStyle(joHint)
                    +_GetFont(Font)
                    +'"' //style 封闭
                    +Format(_DWEVENT,['change',Name,'this.'+dwFullName(Actrl)+'__chk','onclick',TForm(Owner).Handle])
                    +'>{{'+dwFullName(Actrl)+'__cap}}';
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
     joRes.Add('</el-checkbox>');
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
     with TCheckBox(ACtrl) do begin
          joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
          joRes.Add(dwFullName(Actrl)+'__chk:'+dwIIF(Checked,'true,','false,'));
     end;
     //
     Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TCheckBox(ACtrl) do begin
          joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
          joRes.Add('this.'+dwFullName(Actrl)+'__chk='+dwIIF(Checked,'true;','false;'));
     end;
     //
     Result    := (joRes);
end;



exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
