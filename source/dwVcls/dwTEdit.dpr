library dwTEdit;

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
     joData    : Variant;
     oChange   : Procedure(Sender:TObject) of Object;
begin
     //
     joData    := _Json(AData);


     if joData.e = 'onenter' then begin
          if Assigned(TEdit(ACtrl).OnEnter) then begin
               TEdit(ACtrl).OnEnter(TEdit(ACtrl));
          end;
     end else if joData.e = 'onchange' then begin
          //保存事件
          oChange   := TEdit(ACtrl).OnChange;
          //清空事件,以防止自动执行
          TEdit(ACtrl).OnChange  := nil;
          //更新值
          TEdit(ACtrl).Text    := dwUnescape(dwUnescape(joData.v));
          //恢复事件
          TEdit(ACtrl).OnChange  := oChange;

          //执行事件
          if Assigned(TEdit(ACtrl).OnChange) then begin
               TEdit(ACtrl).OnChange(TEdit(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          if Assigned(TEdit(ACtrl).OnExit) then begin
               TEdit(ACtrl).OnExit(TEdit(ACtrl));
          end;
     end else if joData.e = 'onmouseenter' then begin
          if Assigned(TEdit(ACtrl).OnMouseEnter) then begin
               TEdit(ACtrl).OnMouseEnter(TEdit(ACtrl));
          end;
     end else if joData.e = 'onmouseexit' then begin
          if Assigned(TEdit(ACtrl).OnMouseLeave) then begin
               TEdit(ACtrl).OnMouseLeave(TEdit(ACtrl));
          end;
     end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     sBorder   : string;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     //取得HINT对象JSON
     joHint    := dwGetHintJson(TControl(ACtrl));

     //计算Border
     if TEdit(ACtrl).BorderStyle = bsSingle then begin
          sBorder   := dwGetHintStyle(joHint,'borderradius','border-radius','border-radius:4px;')   //border-radius
                    +dwGetHintStyle(joHint,'border','border','border:1px solid #DCDFE6;')   //border-radius
     end else begin
          sBorder   := 'border:0px;'+dwGetHintStyle(joHint,'borderradius','border-radius','border-radius:4px;')   //border-radius
                    +dwGetHintStyle(joHint,'border','border','border:0px solid #DCDFE6;')   //border-radius
     end;


     with TEdit(ACtrl) do begin
          sCode     := '<el-input'
                    +' id="'+dwPrefix(Actrl)+Name+'"'
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +dwDisable(TControl(ACtrl))                            //用于控制可用性Enabled(部分控件不支持)
                    +dwIIF(PasswordChar=#0,'',' show-password')            //是否为密码
                    +' v-model="'+dwPrefix(ACtrl)+Name+'__txt"'                            //前置
                    +dwGetHintValue(joHint,'placeholder','placeholder','') //placeholder,提示语
                    +dwGetHintValue(joHint,'prefix-icon','prefix-icon','') //前置Icon
                    +dwGetHintValue(joHint,'suffix-icon','suffix-icon','') //后置Icon
                    //+dwLTWH(TControl(ACtrl))                               //Left/Top/Width/Height
                    +' :style="{'
                              +'backgroundColor:'+dwPrefix(ACtrl)+Name+'__col,'
                              +'left:'+dwPrefix(ACtrl)+Name+'__lef,'
                              +'top:'+dwPrefix(ACtrl)+Name+'__top,'
                              +'width:'+dwPrefix(ACtrl)+Name+'__wid,'
                              +'height:'+dwPrefix(ACtrl)+Name+'__hei}"'
                    +' style="position:absolute;'
                              +sBorder
                              +'overflow: hidden;'
                    +'"' // 封闭style
                    +Format(_DWEVENT,['input',Name,'escape(this.'+dwPrefix(ACtrl)+Name+'__txt)','onchange',TForm(Owner).Handle]) //绑定事件
                    //+dwIIF(Assigned(OnChange),    Format(_DWEVENT,['input',Name,'(this.'+Name+'__txt)','onchange',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onmouseenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onmouseexit',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnEnter),     Format(_DWEVENT,['focus',Name,'0','onenter',TForm(Owner).Handle]),'')
                    +dwIIF(Assigned(OnExit),      Format(_DWEVENT,['blur',Name,'0','onexit',TForm(Owner).Handle]),'')
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
     joRes.Add('</el-input>');          //此处需要和dwGetHead对应
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
     with TEdit(ACtrl) do begin
          joRes.Add(dwPrefix(ACtrl)+Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwPrefix(ACtrl)+Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwPrefix(ACtrl)+Name+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwPrefix(ACtrl)+Name+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwPrefix(ACtrl)+Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwPrefix(ACtrl)+Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(dwPrefix(ACtrl)+Name+'__txt:"'+dwChangeChar(Text)+'",');
          //
          joRes.Add(dwPrefix(ACtrl)+Name+'__col:"'+dwColor(Color)+'",');
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
     with TEdit(ACtrl) do begin
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__txt="'+dwChangeChar(Text)+'";');
          //
          joRes.Add('this.'+dwPrefix(ACtrl)+Name+'__col="'+dwColor(Color)+'";');
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
 
