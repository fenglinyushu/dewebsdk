library dwTPageControl__timeline;

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

//--------------一些自用函数------------------------------------------------------------------------
function dwLTWHTab(ACtrl:TControl):String;  //可以更新位置的用法
begin
     //只有W，H
     with ACtrl do begin
          Result    := ' :style="{width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}"'
                    +' style="position:absolute;left:0px;top:0px;';
     end;
end;


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    iTab    : Integer;
begin
    with TPageControl(Actrl) do begin
        //用作时间线控件-------------------------------------------------
        for iTab := 0 to PageCount - 1 do begin
            Pages[iTab].HelpKeyword := 'timeline';
        end;



        Result    := '[]';
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
begin
    with TPageControl(Actrl) do begin
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    joHint      : Variant;
    joRes       : Variant;
    iTab        : Integer;
    sFull       : String;
begin
    sFull       := dwFullName(ACtrl);
    //
    with TPageControl(Actrl) do begin
           //用作时间线控件-------------------------------------------------
           (*
           <div class="block">
             <el-timeline>
               <el-timeline-item timestamp="2018/4/12" placement="top">
                 <el-card>
                   <h4>更新 Github 模板</h4>
                   <p>王小虎 提交于 2018/4/12 20:46</p>
                 </el-card>
               </el-timeline-item>
               <el-timeline-item timestamp="2018/4/3" placement="top">
                 <el-card>
                   <h4>更新 Github 模板</h4>
                   <p>王小虎 提交于 2018/4/3 20:46</p>
                 </el-card>
               </el-timeline-item>
             </el-timeline>
           </div>
           *)

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TPageControl(ACtrl) do begin
            //为其TabSheet赋值HelpKeyword,以保持一致性
            for iTab := 0 to PageCount-1 do begin
                Pages[iTab].HelpKeyword := HelpKeyword;
            end;

            //外框
            joRes.Add('<div class="block"'
                    +' id="'+sFull+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    //动态Style
                    +' :style="{'
                        +'left:'+sFull+'__lef,'
                        +'top:'+sFull+'__top,'
                        +'width:'+sFull+'__wid,'
                        +'height:'+sFull+'__hei'
                    +'}"'
                    //静态style
                    +' style="'
                        +'position:absolute;'
                        +'overflow-y:auto;'
                        +'overflow-x:hidden;'
                        //+_GetFont(Font)                   //字体
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +'>');
            //外框
            joRes.Add('<el-timeline>');

        end;
        //
        Result    := (joRes);

    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    with TPageControl(Actrl) do begin
        //用作时间线控件-------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-timeline>');
        //body框
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    iTab    : Integer;
    sFull   : String;
begin
    sFull       := dwFullName(ACtrl);

    //
    with TPageControl(Actrl) do begin
        //用作时间线控件-------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TPageControl(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            if ActivePage = nil then begin
                joRes.Add('');
            end else begin
                joRes.Add(sFull+'__apg:"'+LowerCase(dwPrefix(Actrl)+ActivePage.Name)+'",');
            end;
            //方向
            if TabPosition =  (tpTop) then begin
                joRes.Add(sFull+'__tps:"top",');
            end else  if TabPosition =  (tpBottom) then begin
                joRes.Add(sFull+'__tps:"bottom",');
            end else  if TabPosition =  (tpLeft) then begin
                joRes.Add(sFull+'__tps:"left",');
            end else  if TabPosition =  (tpRight) then begin
                joRes.Add(sFull+'__tps:"right",');
            end;
            //各页面可见性
            for iTab := 0 to PageCount-1 do begin
                joRes.Add(LowerCase(dwPrefix(Actrl)+Pages[iTab].Name)+'__tbv:'+dwIIF(Pages[iTab].TabVisible,'true,','false,'));
            end;
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    iTab    : Integer;
    sFull   : String;
begin
    sFull   := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //
    with TPageControl(Actrl) do begin
        //用作时间线控件-------------------------------------------------
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        //
        if ActivePage = nil then begin
            joRes.Add('');
        end else begin
            joRes.Add('this.'+sFull+'__apg="'+LowerCase(dwPrefix(Actrl)+ActivePage.Name)+'";');
        end;
        //方向
        if TabPosition =  (tpTop) then begin
            joRes.Add('this.'+sFull+'__tps="top";');
        end else  if TabPosition =  (tpBottom) then begin
            joRes.Add('this.'+sFull+'__tps"bottom";');
        end else  if TabPosition =  (tpLeft) then begin
            joRes.Add('this.'+sFull+'__tps="left";');
        end else  if TabPosition =  (tpRight) then begin
            joRes.Add('this.'+sFull+'__tps="right";');
        end;

        //各页面可见性
        for iTab := 0 to PageCount-1 do begin
            joRes.Add('this.'+LowerCase(dwPrefix(Actrl)+Pages[iTab].Name)+'__tbv='+dwIIF(Pages[iTab].TabVisible,'true;','false;'));
        end;

        //-
        Result    := joRes;
    end;
end;


exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;
     
begin
end.
 
