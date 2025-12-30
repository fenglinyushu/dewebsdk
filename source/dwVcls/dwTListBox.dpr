library dwTListBox;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
begin
     Result    := '[]';
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    sValue  : String;
    iItem   : Integer;
    joData  : Variant;
    oOld    : Procedure(Sender:TObject) of Object;  //用于保存事件
begin
    with TListBox(ACtrl) do begin
        if HelpKeyword = 'dialog' then begin


        end else begin
            joData    := _json(AData);

            //保存事件
            oOld    := TListBox(ACtrl).OnClick;

            //清空事件,以防止自动执行
            TListBox(ACtrl).OnClick  := nil;

            //更新值
            sValue    := dwUnescape(joData.v);
            sValue    := ','+sValue+',';
            for iItem := 0 to TListBox(ACtrl).Items.Count-1 do begin
                TListBox(ACtrl).Selected[iItem]    := Pos(','+IntToStr(iItem)+',',sValue)>0;
            end;

            //恢复事件
            TListBox(ACtrl).OnClick  := oOld;

            //处理事件
            if joData.e = 'onclick' then begin
                if Assigned(TListBox(ACtrl).OnClick) then begin
                    TListBox(ACtrl).OnClick(TListBox(ACtrl));
                end;
            end else if joData.e = 'ondblclick' then begin
                TListBox(ACtrl).OnDblClick(TListBox(ACtrl));
            end;
            {
            //保存事件
            oOld    := TListBox(ACtrl).OnClick;

            //清空事件,以防止自动执行
            TListBox(ACtrl).OnClick  := nil;


            //执行事件
            if Assigned(TListBox(ACtrl).OnClick) then begin
            TListBox(ACtrl).OnClick(TListBox(ACtrl));
            end;
            }
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

     with TListBox(ACtrl) do begin
          //
          joRes.Add('<select class="dwselect" size=2'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwIIF(MultiSelect,' multiple','')
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+dwFullName(Actrl)+'__val"'
                    +dwGetDWAttr(joHint)
                    +dwLTWH(TControl(ACtrl))
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +Format(_DWEVENT,['click',dwFullName(Actrl),'String(this.'+dwFullName(Actrl)+'__val)','onclick',TForm(Owner).Handle])
                    +'>');
          joRes.Add('    <option class="dwoption" v-for=''(item,index) in '+dwFullName(Actrl)+'__its''  :value=item.value :key=''index''>{{ item.text }}</option>');

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
     joRes.Add('</select>');
     //
     Result    := (joRes);
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TListBox(ACtrl) do begin
          //
          joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
          joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
          joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
          joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
          //
          joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
          joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
          //添加选项
          sCode     := dwFullName(Actrl)+'__its:[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{text:'''+Items[iItem]+''',value:'''+IntToStr(iItem)+'''},';
          end;
          if Items.Count>0 then begin
            Delete(sCode,Length(sCode),1);
          end;
          sCode     := sCode + '],';
          joRes.Add(sCode);
          //
          sCode     := '';
          for iItem := 0 to Items.Count-1 do begin
               if Selected[iItem] then begin
                    sCode     := sCode + IntToStr(iItem)+',';
               end
          end;
          if sCode<>'' then begin
               Delete(sCode,Length(sCode),1);
          end;
          joRes.Add(dwFullName(Actrl)+'__val:['+sCode+'],');
     end;
     //
     Result    := (joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     sCode     : String;
     iItem     : Integer;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //
     with TListBox(ACtrl) do begin
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
          joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
          //
          joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
          joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
          //添加选项
          sCode     := 'this.'+dwFullName(Actrl)+'__its=[';
          for iItem := 0 to Items.Count-1 do begin
               sCode     := sCode + '{text:'''+Items[iItem]+''',value:'''+IntToStr(iItem)+'''},';
          end;
          //删除最后的逗号
          if Items.Count>0 then begin
            Delete(sCode,Length(sCode),1);
          end;

          sCode     := sCode + '];';
          joRes.Add(sCode);
          //设置选中
          if MultiSelect then begin
              sCode     := '';
              for iItem := 0 to Items.Count-1 do begin
                   if Selected[iItem] then begin
                        sCode     := sCode + '' + IntToStr(iItem)+',';
                   end
              end;
              if sCode<>'' then begin
                   Delete(sCode,Length(sCode),1);
              end;
              joRes.Add('this.'+dwFullName(Actrl)+'__val=['+sCode+'];');
          end else begin
              joRes.Add('this.'+dwFullName(Actrl)+'__val='+IntToStr(ItemIndex)+';');
          end;

          //调试信息
          //joRes.Add('/*real*/ console.log(this.'+dwFullName(Actrl)+'__val);');
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
 
