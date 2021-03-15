library dwTComboBox;

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

     if joData.e = 'onchange' then begin
          //保存事件
          TComboBox(ACtrl).OnExit    := TComboBox(ACtrl).OnChange;
          //清空事件,以防止自动执行
          TComboBox(ACtrl).OnChange  := nil;
          //更新值
          TComboBox(ACtrl).Text    := dwUnescape(joData.v);
          //恢复事件
          TComboBox(ACtrl).OnChange  := TComboBox(ACtrl).OnExit;

          //执行事件
          if Assigned(TComboBox(ACtrl).OnChange) then begin
               TComboBox(ACtrl).OnChange(TComboBox(ACtrl));
          end;

          //清空OnExit事件
          TComboBox(ACtrl).OnExit  := nil;
     end else if joData.e = 'ondropdown' then begin
          if joData.v = 'true' then begin
               if Assigned(TComboBox(ACtrl).OnDropDown) then begin
                    TComboBox(ACtrl).OnDropDown(TLabel(ACtrl));
               end;
          end else if joData.v = 'false' then begin
               if Assigned(TComboBox(ACtrl).OnCloseUp) then begin
                    TComboBox(ACtrl).OnCloseUp(TLabel(ACtrl));
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

     with TComboBox(ACtrl) do begin
          //
          joRes.Add('<el-select'
                    +' v-model="'+Name+'__txt"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwLTWH(TControl(ACtrl))
                    +'border:1px solid #DCDFF0;'
                    +'border-radius:2px;'
                    +'"' //style 封闭
                    +dwIIF(Assigned(OnDropDown) OR Assigned(OnCloseUp),
                         '@visible-change="dwevent($event,''ComboBox1'',$event,''ondropdown'','''')"',
                         '')
                    +Format(_DWEVENT,['change',Name,'this.'+Name+'__txt','onchange',''])
                    +'>');
          joRes.Add('    <el-option v-for="item in '+Name+'__its" :key="item.value" :label="item.value" :value="item.value"/>');

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
     joRes.Add('</el-select>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : string;
     iItem     : Integer;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TComboBox(ACtrl) do begin
          //添加选项
          sCode     := Name+'__its:[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{value:'''+Items[iItem]+'''},';
          end;
          if Items.Count>0 then begin
               Delete(sCode,Length(sCode),1);     //删除最后的逗号
          end;
          sCode     := sCode + '],';
          joRes.Add(sCode);

          //
          joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
          if dwGetProp(TControl(ACtrl),'height')='' then begin
               joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
          end else begin
               joRes.Add(Name+'__hei:"'+dwGetProp(TControl(ACtrl),'height')+'px",');
          end;
          //
          joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //
          joRes.Add(Name+'__txt:"'+Text+'",');
     end;
     //
     Result    := (joRes);
end;

//取得Method
function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : string;
     iItem     : Integer;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TComboBox(ACtrl) do begin
          //添加选项
          sCode     := 'this.'+Name+'__its=[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{value:'''+Items[iItem]+'''},';
          end;
          if Items.Count>0 then begin
               Delete(sCode,Length(sCode),1);
          end;
          sCode     := sCode + '];';
          joRes.Add(sCode);
          //
          joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
          if dwGetProp(TControl(ACtrl),'height')='' then begin
               joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
          end else begin
               joRes.Add('this.'+Name+'__hei="'+dwGetProp(TControl(ACtrl),'height')+'px";');
          end;
          //
          joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
          //
          joRes.Add('this.'+Name+'__txt="'+Text+'";');
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
 
