library dwTPageControl;

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
          Result    := ' :style="{width:'+Name+'__wid,height:'+Name+'__hei}"'
                    +' style="position:absolute;left:0px;top:0px;';
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
     iTab      : Integer;
     joData    : Variant;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //用作时间线控件-------------------------------------------------

          end else if HelpKeyword = 'steps' then begin
               //用作步骤条控件-------------------------------------------------

          end else begin
               //用作Tabs控件---------------------------------------------------

               //解析AData字符串到JSON对象
               joData    := _json(AData);

               //保存事件
               TPageControl(ACtrl).OnExit    := TPageControl(ACtrl).OnChange;

               //清空事件,以防止自动执行
               TPageControl(ACtrl).OnChange  := nil;
               //更新值
               for iTab := 0 to TPageControl(ACtrl).PageCount-1 do begin
                    if TPageControl(ACtrl).Pages[iTab].Name = joData.v then begin
                         TPageControl(ACtrl).ActivePageIndex     := iTab;
                         break;
                    end;
               end;
               //恢复事件
               TPageControl(ACtrl).OnChange  := TPageControl(ACtrl).OnExit;

               //执行事件
               if Assigned(TPageControl(ACtrl).OnChange) then begin
                    TPageControl(ACtrl).OnChange(TPageControl(ACtrl));
               end;

               //清空OnExit事件
               TPageControl(ACtrl).OnExit  := nil;

          end;
     end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
     sCode     : string;
     joHint    : Variant;
     joRes     : Variant;
     iTab      : Integer;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
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
                    //外框
                    joRes.Add('<div class="block"'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +dwLTWH(TControl(ACtrl))
                              +'"' //style 封闭
                              +'>');
                    //外框
                    joRes.Add('    <el-timeline>');

               end;
               //
               Result    := (joRes);

          end else if HelpKeyword = 'steps' then begin
               //用作步骤条控件-------------------------------------------------

          end else begin
               //用作Tabs控件---------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');

               //取得HINT对象JSON
               joHint    := dwGetHintJson(TControl(ACtrl));

               with TPageControl(ACtrl) do begin
                    //外框
                    joRes.Add('<el-tabs'
                              +dwVisible(TControl(ACtrl))
                              +dwDisable(TControl(ACtrl))
                              +' v-model="'+Name+'__apg"'        //ActivePage
                              +' :tab-position="'+Name+'__tps"'  //标题位置
                              +dwIIF(ParentBiDiMode,dwIIF(ParentShowHint,' type="border-card"',' type="card"'),'')   //是否有外框
                              +dwLTWH(TControl(ACtrl))
                              +'"' //style 封闭
                              +Format(_DWEVENT,['tab-click',Name,'this.'+Name+'__apg','onchange',''])
                              +'>');

                    //添加选项卡
                    for iTab := 0 to PageCount-1 do begin
                         //
                         joRes.Add('    <el-tab-pane'+' v-if="'+Pages[iTab].Name+'__tbv"'
                                   +' :label="'+Pages[iTab].Name+'__cap" name="'+Pages[iTab].name+'">');
                         //
                         joRes.Add('    </el-tab-pane>');
                    end;


                    //body框
                    joRes.Add('<div'+dwLTWHTab(TControl(ACtrl))+'">');

               end;
               //
               Result    := (joRes);

          end;
     end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //用作时间线控件-------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');
               //生成返回值数组
               joRes.Add('    </el-timeline>');
               //body框
               joRes.Add('</div>');
               //
               Result    := (joRes);
          end else if HelpKeyword = 'steps' then begin
               //用作步骤条控件-------------------------------------------------

          end else begin
               //用作Tabs控件---------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');
               //生成返回值数组
               joRes.Add('    </div>');
               joRes.Add('</el-tabs>');
               //
               Result    := (joRes);
          end;
     end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //用作时间线控件-------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');
               //
               with TPageControl(ACtrl) do begin
                    joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    joRes.Add(Name+'__apg:"'+ActivePage.Name+'",');
                    //方向
                    if TabPosition =  (tpTop) then begin
                         joRes.Add(Name+'__tps:"top",');
                    end else  if TabPosition =  (tpBottom) then begin
                         joRes.Add(Name+'__tps:"bottom",');
                    end else  if TabPosition =  (tpLeft) then begin
                         joRes.Add(Name+'__tps:"left",');
                    end else  if TabPosition =  (tpRight) then begin
                         joRes.Add(Name+'__tps:"right",');
                    end;
                    //各页面可见性
                    for iTab := 0 to PageCount-1 do begin
                         joRes.Add(Pages[iTab].Name+'__tbv:'+dwIIF(Pages[iTab].TabVisible,'true,','false,'));
                    end;
               end;
               //
               Result    := (joRes);
          end else if HelpKeyword = 'steps' then begin
               //用作步骤条控件-------------------------------------------------

          end else begin
               //用作Tabs控件---------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');
               //
               with TPageControl(ACtrl) do begin
                    joRes.Add(Name+'__lef:"'+IntToStr(Left)+'px",');
                    joRes.Add(Name+'__top:"'+IntToStr(Top)+'px",');
                    joRes.Add(Name+'__wid:"'+IntToStr(Width)+'px",');
                    joRes.Add(Name+'__hei:"'+IntToStr(Height)+'px",');
                    //
                    joRes.Add(Name+'__vis:'+dwIIF(Visible,'true,','false,'));
                    joRes.Add(Name+'__dis:'+dwIIF(Enabled,'false,','true,'));
                    //
                    if ActivePageIndex>=0 then begin
                         joRes.Add(Name+'__apg:"'+ActivePage.Name+'",');
                    end else begin
                         joRes.Add(Name+'__apg:"'+''+'",');
                    end;
                    //方向
                    if TabPosition =  (tpTop) then begin
                         joRes.Add(Name+'__tps:"top",');
                    end else  if TabPosition =  (tpBottom) then begin
                         joRes.Add(Name+'__tps:"bottom",');
                    end else  if TabPosition =  (tpLeft) then begin
                         joRes.Add(Name+'__tps:"left",');
                    end else  if TabPosition =  (tpRight) then begin
                         joRes.Add(Name+'__tps:"right",');
                    end;
                    //各页面可见性
                    for iTab := 0 to PageCount-1 do begin
                         joRes.Add(Pages[iTab].Name+'__tbv:'+dwIIF(Pages[iTab].TabVisible,'true,','false,'));
                    end;
               end;
               //
               Result    := (joRes);
          end;
     end;
end;

function dwGetMethod(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
     with TPageControl(Actrl) do begin
          if HelpKeyword = 'timeline' then begin
               //用作时间线控件-------------------------------------------------

          end else if HelpKeyword = 'steps' then begin
               //用作步骤条控件-------------------------------------------------

          end else begin
               //用作Tabs控件---------------------------------------------------

               //生成返回值数组
               joRes    := _Json('[]');
               //
               //
               with TPageControl(ACtrl) do begin
                    joRes.Add('this.'+Name+'__lef="'+IntToStr(Left)+'px";');
                    joRes.Add('this.'+Name+'__top="'+IntToStr(Top)+'px";');
                    joRes.Add('this.'+Name+'__wid="'+IntToStr(Width)+'px";');
                    joRes.Add('this.'+Name+'__hei="'+IntToStr(Height)+'px";');
                    //
                    joRes.Add('this.'+Name+'__vis='+dwIIF(Visible,'true;','false;'));
                    joRes.Add('this.'+Name+'__dis='+dwIIF(Enabled,'false;','true;'));
                    //
                    if ActivePageIndex>=0 then begin
                         joRes.Add('this.'+Name+'__apg="'+ActivePage.Name+'";');
                    end else begin
                         joRes.Add('this.'+Name+'__apg="'+''+'";');
                    end;

                    //方向
                    if TabPosition =  (tpTop) then begin
                         joRes.Add('this.'+Name+'__tps="top";');
                    end else  if TabPosition =  (tpBottom) then begin
                         joRes.Add('this.'+Name+'__tps="bottom";');
                    end else  if TabPosition =  (tpLeft) then begin
                         joRes.Add('this.'+Name+'__tps="left";');
                    end else  if TabPosition =  (tpRight) then begin
                         joRes.Add('this.'+Name+'__tps="right";');
                    end;
                    //各页面可见性
                    for iTab := 0 to PageCount-1 do begin
                         joRes.Add('this.'+Pages[iTab].Name+'__tbv='+dwIIF(Pages[iTab].TabVisible,'true;','false;'));
                    end;
               end;
               //
               Result    := (joRes);
          end;
     end;
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
 
