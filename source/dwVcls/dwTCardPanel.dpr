library dwTCardPanel;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls,Vcl.WinXPanels, Vcl.WinXCtrls, Windows;

function _GetFontWeight(AFont:TFont):String;
begin
     if fsBold in AFont.Style then begin
          Result    := 'bold';
     end else begin
          Result    := 'normal';
     end;

end;
function _GetFontStyle(AFont:TFont):String;
begin
     if fsItalic in AFont.Style then begin
          Result    := 'italic';
     end else begin
          Result    := 'normal';
     end;
end;
function _GetTextDecoration(AFont:TFont):String;
begin
     if fsUnderline in AFont.Style then begin
          Result    :='underline';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := 'line-through';
          end else begin
               Result    := 'none';
          end;
     end;
end;

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
    joRes   : Variant;
begin
    with TCardPanel(Actrl) do begin
        Result    := '[]';
    end;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    iTab        : Integer;
    iOld,iNew   : Integer;
    iName       : Integer;
    sTabName    : string;
    sAction     : string;
    joData      : Variant;
    oTab        : TCard;
    oChange     : Procedure(Sender: TObject; PrevCard, NextCard: TCard) of Object;
begin
    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

           //解析AData字符串到JSON对象
        joData    := _json(AData);

        if joData.e = 'onchange' then begin
            //先执行PageControl的切换事件
            if joData.v <> dwFullName(ActiveCard) then begin
                //保存事件
                oChange := TCardPanel(ACtrl).OnCardChange;

                //
                iOld    := TCardPanel(ACtrl).ActiveCardIndex;

                //清空事件,以防止自动执行
                TCardPanel(ACtrl).OnCardChange  := nil;
                //更新值
                for iTab := 0 to TCardPanel(ACtrl).CardCount-1 do begin
                    if LowerCase(dwPrefix(ACtrl) + TCardPanel(ACtrl).Cards[iTab].Name) = joData.v then begin
                         TCardPanel(ACtrl).ActiveCardIndex  := iTab;
                         break;
                    end;
                end;
                //恢复事件
                TCardPanel(ACtrl).OnCardChange  := oChange;

                //执行事件
                if Assigned(TCardPanel(ACtrl).OnCardChange) then begin
                    //
                    iNew    := TCardPanel(ACtrl).ActiveCardIndex;

                    TCardPanel(ACtrl).OnCardChange(TCardPanel(ACtrl),TCardPanel(ACtrl).Cards[iOld],TCardPanel(ACtrl).Cards[iNew]);
                end;

                //清空OnExit事件
                TCardPanel(ACtrl).OnExit  := nil;
            end else begin

                //<----- 再执行 tabsheet 的 点击事件
                //先找到被点击的 tabsheet
                oTab    := nil;
                for iTab := 0 to CardCount-1 do begin
                    if dwFullName(Cards[iTab]) = joData.v then begin
                         oTab   := Cards[iTab];
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
    with TCardPanel(Actrl) do begin
        //用作Tabs控件--------------------------------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TCardPanel(ACtrl) do begin
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
            for iTab := 0 to CardCount-1 do begin
                joTabHint   := dwGetHintJson(Cards[iTab]);
                //根据是否有图标分别处理
                if (Cards[iTab].Tag>0)and(Cards[iTab].Tag<=280) then begin
                    joRes.Add('    <el-tab-pane'
                            +dwGetDWAttr(joTabHint)
                            +' name="'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'"'
                            +' style="'
                                //+dwIIF(Pages[iTab].TabVisible,'','display:none;')
                                //+dwIIF(CardWidth>0,'width:'+IntToStr(CardWidth)+'px;','')
                            +'"'
                            +'>');
                            //+' name="'+IntToStr(iTab)+'">');
                    joRes.Add('        <span slot="label">'
                            +'<i class="'+dwIcons[Cards[iTab].Tag]+'"></i>'
                            +' {{'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'__cap}}'
                            +'</span>');
                end else begin
                    joRes.Add('    <el-tab-pane'
                            +dwGetDWAttr(joTabHint)
                            +' :label="'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'__cap"'
                            +' name="'+LowerCase(dwPrefix(Actrl)+Cards[iTab].Name)+'"'
                            +' style="'
                                //+dwIIF(Pages[iTab].TabVisible,'','display:none;')
                                //+dwIIF(CardWidth>0,'width:'+IntToStr(CardWidth)+'px;','')
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
     joRes     : Variant;
begin
    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TCardPanel(ACtrl) do begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(dwFullName(Actrl)+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(dwFullName(Actrl)+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            if TCardPanel(ACtrl).Color = clNone then begin
                joRes.Add(dwFullName(Actrl)+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(dwFullName(Actrl)+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
            end;
            //
            joRes.Add(dwFullName(Actrl)+'__rtz:30,');
            //
            joRes.Add(dwFullName(Actrl)+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(dwFullName(Actrl)+'__ffm:"'+Font.Name+'",');
            joRes.Add(dwFullName(Actrl)+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(dwFullName(Actrl)+'__ftd:"'+_GetTextDecoration(Font)+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
     iTab      : Integer;
begin
    with TCardPanel(Actrl) do begin
        //用作Tabs控件---------------------------------------------------

        //生成返回值数组
        joRes    := _Json('[]');
        //
        //
        with TCardPanel(ACtrl) do begin
            joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+dwFullName(Actrl)+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add('this.'+dwFullName(Actrl)+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+dwFullName(Actrl)+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
            end;
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fsz="'+IntToStr(Font.size+3)+'px";');
            joRes.Add('this.'+dwFullName(Actrl)+'__ffm="'+Font.Name+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+dwFullName(Actrl)+'__ftd="'+_GetTextDecoration(Font)+'";');
        end;
        //
        Result    := (joRes);
    end;
end;


exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    //dwGetMounted,
    dwGetData;

begin
end.
 
