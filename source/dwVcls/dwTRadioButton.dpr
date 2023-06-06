library dwTRadioButton;

uses
     ShareMem,      //必须添加

     //
     dwCtrlBase,    //一些基础函数

     //
     SynCommons,    //mormot用于解析JSON的单元

     //
     SysUtils,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Controls,
     Forms;

//当前控件需要引入的第三方JS/CSS ,一般为不做改动,目前仅在TChart使用时需要用到
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     {
     //以下是TChart时的代码,供参考
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }

     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData      : Variant;
    oProcedure  : procedure(Sender:TObject) of Object;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onclick' then begin
          //保存事件
          oProcedure    := TRadioButton(ACtrl).OnClick;
          //清空事件,以防止自动执行
          TRadioButton(ACtrl).OnClick := nil;
          //更新值
          TRadioButton(ACtrl).Checked := not TRadioButton(ACtrl).Checked;//dwUnescape(joData.v)='true';
          //恢复事件
          TRadioButton(ACtrl).OnClick := oProcedure;
          //执行事件
          if Assigned(TRadioButton(ACtrl).OnClick) then begin
               TRadioButton(ACtrl).OnClick(TRadioButton(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
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
     with TRadioButton(ACtrl) do begin
          sCode     := '<el-radio'
                    +' id="'+dwFullName(Actrl)+'"'
                    +' label="1"'       //选中值
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+dwFullName(Actrl)+'__chk"'
                    +dwLTWH(TControl(ACtrl))
                    +'"' //style 封闭
                    +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click.native.prevent',Name,'(this.'+dwFullName(Actrl)+'__chk)','onclick',TForm(Owner).Handle]),'')
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
     joRes.Add('</el-radio>');          //此处需要和dwGetHead对应
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
     with TRadioButton(ACtrl) do begin
          joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
          joRes.Add(dwFullName(Actrl)+'__chk:"'+dwIIF(Checked,'1','0')+'",');
     end;
     //
     Result    := (joRes);
end;

//取得Data
function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TRadioButton(ACtrl) do begin
          joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
          joRes.Add('this.'+dwFullName(Actrl)+'__chk="'+dwIIF(Checked,'1','0')+'";');
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
 
