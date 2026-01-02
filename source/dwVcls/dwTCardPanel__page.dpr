library dwTCardPanel__page;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Vcl.WinXPanels, Vcl.WinXCtrls,
     StdCtrls, Windows;

//--------------一些自用函数------------------------------------------------------------------------
function dwLTWHTab(ACtrl:TControl):String;  //可以更新位置的用法
var
    sFull       : string;
begin
    sFull       := dwFullName(ACtrl);

    //只有W，H
    with ACtrl do begin
        Result    := ' :style="{width:'+sFull+'__wid,height:'+sFull+'__hei}"'
                  +' style="position:absolute;left:0px;top:0px;';
    end;
end;


//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    //
    iCard       : Integer;
    sStyle      : String;
    oChange     : Procedure(Sender:TObject; PrevCard, NextCard: TCard) of Object;
    sFull       : string;
begin
    sFull       := dwFullName(ACtrl);

    with TCardPanel(Actrl) do begin

        //设置所有card的helpkeyword为page
        for iCard := 0 to CardCount - 1 do begin
            Cards[iCard].HelpKeyword    := 'page';
        end;

        joRes   := _json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //用于自定义样式
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
    oTab        : TCard;
    oChange     : Procedure(Sender:TObject; PrevCard, NextCard: TCard) of Object;
    sFull       : string;
begin
    sFull       := dwFullName(ACtrl);

    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

           //解析AData字符串到JSON对象
        joData    := _json(AData);

        if joData.e = 'ontabclick' then begin
            //保存事件
            oChange := OnCardChange;

            //清空事件,以防止自动执行
            OnCardChange    := nil;

            //更新值
            ActiveCardIndex := StrToIntDef(joData.v,0);

            //恢复事件
            OnCardChange    := oChange;

            //执行事件
            if Assigned(OnCardChange) then begin
                OnCardChange(TCardPanel(ACtrl),ActiveCard,ActiveCard );
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
                //oTab.CardPanel    := TCardPanel(ACtrl);

                //执行事件
                if Assigned(TCardPanel(ACtrl).OnEndDock) then begin
                    TCardPanel(ACtrl).OnEndDock(TCardPanel(ACtrl),nil,1,0);
                end;
                //
                //TForm(ACtrl.Owner).DockSite   := True;
            end else if sAction = 'remove' then begin
                for iTab := 0 to TCardPanel(ACtrl).CardCount-1 do begin
                    oTab    := TCardPanel(ACtrl).Cards[iTab];
                    if LowerCase(dwFullName(oTab)) = sTabName then begin
                        //oTab.Destroy;
                        //执行事件
                        if Assigned(TCardPanel(ACtrl).OnEndDock) then begin
                            TCardPanel(ACtrl).OnEndDock(TCardPanel(ACtrl),nil,0,iTab);
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
    sFull       : string;
    joHint      : Variant;
    joRes       : Variant;
    joTabHint   : Variant;
    iTab        : Integer;
begin
    //
    sFull       := sFull;

    with TCardPanel(Actrl) do begin
        //用作Tabs控件--------------------------------------------------------------------------
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //增减事件处理代码
        //@edit="function(targetName,action){var data=0;if (action === 'add') {data=1};data = targetName*10+data; dwevent(this.$event,'CardPanel1',data,'onenddock','10095742')}">>

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
                //+' :tab-position="'+sFull+'__tps"'  //标题位置
                +dwIIF(joHint.Exists('type'),' type="'+dwGetStr(joHint,'type')+'"','type="border-card"')   //是否有card/border-card
                +dwGetDWAttr(joHint)

                //:style 和 style
                +dwLTWH(TControl(ACtrl))
                +'font-size:'+IntToStr(Font.Size+3)+'px;'
                +dwGetDWStyle(joHint)
                +'"' //style 封闭

                //事件
                //+Format(_DWEVENT,['tab-click',Name,'this.'+sFull+'__apg','oncardchange',TForm(Owner).Handle])
                //+' @tab-click="console.log(''tabclick'');"'
                +' @tab-click="'+sFull+'__tabclick($event)"'
                //+Format(_DWEVENT,['edit',Name,'this.'+sFull+'__apg','onenddock',TForm(Owner).Handle])
                +sEdit
                +'>');



        //添加选项卡(标题)
        for iTab := 0 to CardCount-1 do begin
            joTabHint   := dwGetHintJson(Cards[iTab]);
            //根据是否有图标分别处理
            if (Cards[iTab].HelpContext>0)and(Cards[iTab].HelpContext<=280) then begin
                joRes.Add('    <el-tab-pane'
                        +dwGetDWAttr(joTabHint)
                        +' name="'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'"'
                        +' style="'
                            //+dwIIF(Cards[iTab].TabVisible,'','display:none;')
                            //+dwIIF(TabWidth>0,'width:'+IntToStr(TabWidth)+'px;','')
                        +'"'
                        +'>');
                        //+' name="'+IntToStr(iTab)+'">');
                joRes.Add('        <span slot="label">'
                        +'<i class="'+dwIcons[Cards[iTab].HelpContext]+'"></i>'
                        +' {{'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'__cap}}'
                        +'</span>');
            end else begin
                joRes.Add('    <el-tab-pane'
                        +dwGetDWAttr(joTabHint)
                        +' :label="'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'__cap"'
                        +' name="'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'"'
                        +' style="'
                            //+dwIIF(Cards[iTab].TabVisible,'','display:none;')
                            //+dwIIF(TabWidth>0,'width:'+IntToStr(TabWidth)+'px;','')
                        +'"'
                        +'>');
            end;
            //
            joRes.Add('    </el-tab-pane>');
        end;


        //body框
        joRes.Add('    <div'+dwLTWHTab(TControl(ACtrl))+'">');

        //恢复事件
        //TCardPanel(ACtrl).OnCardChange  := oChange;

        //
        Result    := (joRes);

    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
    with TCardPanel(Actrl) do begin
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
    sFull       := dwFullName(ACtrl);

    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        if ActiveCardIndex>=0 then begin
             joRes.Add(sFull+'__apg:"'+LowerCase(dwPrefix(Actrl)+ActiveCard.Name)+'",');
        end else begin
             joRes.Add(sFull+'__apg:"'+''+'",');
        end;
        //方向
        //joRes.Add(sFull+'__tps:"top",');

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
    sFull       := dwFullName(ACtrl);

    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //
        if ActiveCardIndex>=0 then begin
             joRes.Add('this.'+sFull+'__apg="'+LowerCase(dwPrefix(Actrl)+ActiveCard.Name)+'";');
        end else begin
             joRes.Add('this.'+sFull+'__apg="'+''+'";');
        end;

        //方向
        //joRes.Add('this.'+sFull+'__tps="top";');
        //各页面可见性
        for iTab := 0 to CardCount-1 do begin
            joRes.Add('this.$refs.'+sFull+'__ref.$children[0].$refs.tabs['+IntToStr(iTab)+'].style.display = '''
                +dwIIF(Cards[iTab].CardVisible,'inline-block','none')+''';');
        end;

        //
        Result    := (joRes);
    end;
end;

//dwGetMethod
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    iItem       : Integer;  //
    //
    sCode       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull       := dwFullName(ACtrl);

    joRes   := _json('[]');

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));


    with TCardPanel(ACtrl) do begin


        //编辑后save事件
        sCode   :=
                sFull+'__tabclick(e) '
                +'{'
                    //+'console.log(e.index);'
                    +'this.dwevent("","'+sFull+'",e.index,"ontabclick",'+IntToStr(TForm(Owner).Handle)+');'
                +'},';
        joRes.Add(sCode);



    end;
    //
    Result   := joRes;

end;


//取得Mounted
function dwGetMounted(ACtrl:TComponent):String;StdCall;
var
    joRes       : Variant;
    sCode       : string;
    sFull       : string;
    iTab        : Integer;
begin
    sFull       := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');
    //
    joRes.Add('this.$nextTick(() => {');
    with TCardPanel(Actrl) do begin
        //各页面可见性
        for iTab := 0 to CardCount-1 do begin
            if not Cards[iTab].CardVisible then begin
                joRes.Add('this.$refs.'+sFull+'__ref.$children[0].$refs.tabs['+IntToStr(iTab)+'].style.display = ''none'';');
            end;
        end;
    end;
    joRes.Add('});');
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
    dwGetMethods,
    dwGetData;
     
begin
end.
 
