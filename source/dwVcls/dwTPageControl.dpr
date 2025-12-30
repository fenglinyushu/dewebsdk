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
var
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);
    //只有W，H
    with ACtrl do begin
        Result  := ' :style="{width:'+sFull+'__wid,height:'+sFull+'__hei}"'
                +' style="position:absolute;left:0px;top:0px;';
    end;
end;


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    //
    sStyle  : String;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);
    //
    sStyle  :=
            '<style lang="style" scoped>'+
(*
                .el-tabs__item.is-active {
                    color: #fff !important;
                    background: #2597DD !important;
                    border-top:solid 1px #0f0;
                }
                .el-tabs__item{
                    font-weight:bold;
                    color: #2597DD !important;
                    background: transparent !important;
                }
                .el-tabs__active-bar{
                    display: none;
                }
                .el-tabs__nav-wrap::after{
                    background: #2597DD !important;
                }
                .el-tabs__header{
                    margin: 0;
                    background: #ccc !important;
                    height:40px;
                }
*)
            '</style>';

    with TPageControl(Actrl) do begin
        joRes   := _json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        if joHint.Exists('style') then begin
            sStyle  := '<style lang="style" scoped>'+joHint.style+'</style>';
            joRes.Add(sStyle);
        end;
        //
        Result  := joRes;
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    iTab        : Integer;
    iName       : Integer;
    sTabName    : string;
    sAction     : string;
    joData      : Variant;
    oTab        : TTabSheet;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);
    with TPageControl(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

           //解析AData字符串到JSON对象
        joData    := _json(AData);

        if joData.e = 'onchange' then begin
            //先执行PageControl的切换事件
            if joData.v <> dwFullName(ActivePage) then begin
                //保存事件
                OnExit  := OnChange;

                //清空事件,以防止自动执行
                OnChange  := nil;
                //更新值
                for iTab := 0 to PageCount-1 do begin
                    if dwFullName(Pages[iTab]) = joData.v then begin
                         ActivePageIndex     := iTab;
                         break;
                    end;
                end;
                //恢复事件
                OnChange    := OnExit;

                //执行事件
                if Assigned(OnChange) then begin
                    OnChange(TPageControl(ACtrl));
                end;

                //清空OnExit事件
                OnExit  := nil;
            end else begin

                //<----- 再执行 tabsheet 的 点击事件
                //先找到被点击的 tabsheet
                oTab    := nil;
                for iTab := 0 to PageCount-1 do begin
                    if dwFullName(Pages[iTab]) = joData.v then begin
                         oTab   := Pages[iTab];
                         break;
                    end;
                end;

                if oTab = nil then begin
                    Exit;
                end;

                //
                if Assigned(oTab.OnEnter) then begin
                    oTab.OnEnter(oTab);
                end;

                //>-----
            end;


        end else if joData.e = 'onenddock' then begin
            //ShowMessage(joData.v);
            sAction := dwUnescape(joData.v);
            //
            sTabName    := Copy(sAction,1,Pos(',',sAction)-1);
            Delete(sAction,1,Pos(',',sAction));
            //
            if sAction = 'add' then begin
                //oTab    := TTabSheet.Create(TForm(ACtrl.Owner));
                //oTab.ParentFont     := False;

                //设置一个可用的Name
                //for iName := 1 to 9999 do begin
                //    if not Assigned(TForm(ACtrl.Owner).FindComponent('TabSheet'+IntToStr(iName))) then begin
                //        oTab.Name           := 'TabSheet'+IntToStr(iName);
                //        //
                //        break;
                //    end;
                //end;
                //oTab.PageControl    := TPageControl(ACtrl);

                //执行事件
                if Assigned(TPageControl(ACtrl).OnEndDock) then begin
                    TPageControl(ACtrl).OnEndDock(TPageControl(ACtrl),nil,1,0);
                end;
                //
                //TForm(ACtrl.Owner).DockSite   := True;
            end else if sAction = 'remove' then begin
                for iTab := 0 to TPageControl(ACtrl).PageCount-1 do begin
                    oTab    := TPageControl(ACtrl).Pages[iTab];
                    if LowerCase(dwFullName(oTab)) = sTabName then begin
                        //oTab.Destroy;
                        //执行事件
                        if Assigned(TPageControl(ACtrl).OnEndDock) then begin
                            TPageControl(ACtrl).OnEndDock(TPageControl(ACtrl),nil,0,iTab);
                        end;
                        //
                        //TForm(ACtrl.Owner).DockSite   := True;
                        //
                        break;
                    end;
                end;
            end;
        end;
    end;

end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sEdit       : string;   //增减TTabSheet的处理代码
    joHint      : Variant;
    joRes       : Variant;
    joTabHint   : Variant;
    iTab        : Integer;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);
    with TPageControl(Actrl) do begin
        //用作Tabs控件--------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TPageControl(ACtrl) do begin
            //增减事件处理代码
            //@edit="function(targetName,action){var data=0;if (action === 'add') {data=1};data = targetName*10+data; dwevent(this.$event,'PageControl1',data,'onenddock','10095742')}">>

            sEdit   := ' @edit="function(targetName,action)'
                    //+'{var data=0;if (action === ''add'') {data=1};data = targetName*10+data;dwevent(this.$event,'''+Name+''',data,''onenddock'','''+IntToStr(TForm(Owner).Handle)+''')}"';
                    +'{'
                        +'var data = new String(targetName+'',''+action);'
                        +'dwevent(this.$event,'''+Name+''',data,''onenddock'','''+IntToStr(TForm(Owner).Handle)+''')'
                    +'}"';
            //sEdit   := ' @edit="function(targetName,action){var data=0;if (action === ''add'') {data=1};dwevent(this.$event,'''+Name+''',data,''onenddock'','''+IntToStr(TForm(Owner).Handle)+''')}"';



            //外框
            joRes.Add('<el-tabs'
                    +' id="'+sFull+'"'
                    +' ref="'+sFull+'__ref"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +' v-model="'+sFull+'__apg"'        //ActivePage
                    +' :tab-position="'+sFull+'__tps"'  //标题位置
                    +dwIIF(ParentBiDiMode,dwIIF(ParentShowHint,' type="border-card"',' type="card"'),'')   //是否有外框
                    +dwGetDWAttr(joHint)

                    //:style 和 style
                    +dwLTWH(TControl(ACtrl))
                    +'font-size:'+IntToStr(Font.Size+3)+'px;'
                    +dwGetDWStyle(joHint)
                    +'"' //style 封闭

                    //事件
                    +Format(_DWEVENT,['tab-click',Name,'this.'+sFull+'__apg','onchange',TForm(Owner).Handle])
                    //+Format(_DWEVENT,['edit',Name,'this.'+sFull+'__apg','onenddock',TForm(Owner).Handle])
                    +sEdit
                    +'>');



            //添加选项卡(标题)
            for iTab := 0 to PageCount-1 do begin
                joTabHint   := dwGetHintJson(Pages[iTab]);
                //根据是否有图标分别处理
                if (Pages[iTab].ImageIndex>0)and(Pages[iTab].ImageIndex<=280) then begin
                    joRes.Add('    <el-tab-pane'
                            +dwGetDWAttr(joTabHint)
                            +' name="'+LowerCase(dwPrefix(Actrl)+Pages[iTab].Name)+'"'
                            +' style="'
                                //+dwIIF(Pages[iTab].TabVisible,'','display:none;')
                                +dwIIF(TabWidth>0,'width:'+IntToStr(TabWidth)+'px;','')
                            +'"'
                            +'>');
                            //+' name="'+IntToStr(iTab)+'">');
                    joRes.Add('        <span slot="label">'
                            +'<i class="'+dwIcons[Pages[iTab].ImageIndex]+'"></i>'
                            +' {{'+LowerCase(dwPrefix(Actrl)+Pages[iTab].Name)+'__cap}}'
                            +'</span>');
                end else begin
                    joRes.Add('    <el-tab-pane'
                            +dwGetDWAttr(joTabHint)
                            +' :label="'+LowerCase(dwPrefix(Actrl)+Pages[iTab].Name)+'__cap"'
                            +' name="'+LowerCase(dwPrefix(Actrl)+Pages[iTab].Name)+'"'
                            +' style="'
                                //+dwIIF(Pages[iTab].TabVisible,'','display:none;')
                                +dwIIF(TabWidth>0,'width:'+IntToStr(TabWidth)+'px;','')
                            +'"'
                            +'>');
                end;
                //
                joRes.Add('    </el-tab-pane>');
            end;


            //body框
            joRes.Add('    <div'+dwLTWHTab(TControl(ACtrl))+'">');

        end;
        //
        Result    := (joRes);

    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);
    with TPageControl(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');
        joRes.Add('</el-tabs>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    iTab        : Integer;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TPageControl(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

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
            if ActivePageIndex>=0 then begin
                 joRes.Add(sFull+'__apg:"'+LowerCase(dwPrefix(Actrl)+ActivePage.Name)+'",');
            end else begin
                 joRes.Add(sFull+'__apg:"'+''+'",');
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
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    iTab        : Integer;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TPageControl(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        //
        with TPageControl(ACtrl) do begin
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            if ActivePageIndex>=0 then begin
                 joRes.Add('this.'+sFull+'__apg="'+LowerCase(dwPrefix(Actrl)+ActivePage.Name)+'";');
            end else begin
                 joRes.Add('this.'+sFull+'__apg="'+''+'";');
            end;

            //方向
            if TabPosition =  (tpTop) then begin
                 joRes.Add('this.'+sFull+'__tps="top";');
            end else  if TabPosition =  (tpBottom) then begin
                 joRes.Add('this.'+sFull+'__tps="bottom";');
            end else  if TabPosition =  (tpLeft) then begin
                 joRes.Add('this.'+sFull+'__tps="left";');
            end else  if TabPosition =  (tpRight) then begin
                 joRes.Add('this.'+sFull+'__tps="right";');
            end;
            //各页面可见性
            for iTab := 0 to PageCount-1 do begin
                joRes.Add('this.$refs.'+sFull+'__ref.$children[0].$refs.tabs['+IntToStr(iTab)+'].style.display = '''
                    +dwIIF(Pages[iTab].TabVisible,'inline-block','none')+''';');
            end;
        end;
        //
        Result    := (joRes);
    end;
end;

//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    sCode       : string;
    iTab        : Integer;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //各页面可见性
    joRes.Add('this.$nextTick(() => {');
    with TPageControl(Actrl) do begin
        //
        for iTab := 0 to PageCount-1 do begin
            if not Pages[iTab].TabVisible then begin
                joRes.Add('this.$refs.'+sFull+'__ref.$children[0].$refs.tabs['+IntToStr(iTab)+'].style.display = ''none'';');
            end;
        end;
        joRes.Add('});');

        //标题栏高度
        iTab    := dwIIFi(TabHeight=0, 20, TabHeight);
        sCode   := '$("#'+sFull+' .el-tabs__header").css("height", "'+IntToStr(iTab)+'px");'
                //+'$("#'+sFull+' .el-tabs__header .el-tab").css("line-height", "'+IntToStr(iTab)+'px");';
                +'$("#'+sFull+' .el-tabs__nav").css({"line-height":"100%", "padding":"0"});';
        //joRes.Add(sCode);

    end;
    //
    Result    := (joRes);
end;


exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetMounted,
    dwGetData;
     
begin
end.
 
