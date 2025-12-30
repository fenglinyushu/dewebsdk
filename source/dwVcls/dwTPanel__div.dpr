library dwTPanel__div;
{
功能说明:
    万能的panel, 默认仅生成<div> ...<div>, 其他由属性生成
}

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

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    sCode   : String;
    joRes   : Variant;
begin
     //生成返回值数组
    joRes   := _Json('[]');

    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
    with TPanel(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
            //通过panel.caption传递数据
            if joData.v <> '0' then begin
                Caption := joData.v;
            end;

            //
            TPanel(ACtrl).OnClick(TPanel(ACtrl));
        end else if joData.e = 'onenter' then begin
            TPanel(ACtrl).OnEnter(TPanel(ACtrl));
        end else if joData.e = 'onexit' then begin
            TPanel(ACtrl).OnExit(TPanel(ACtrl));
        end;
    end;
end;

//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sStyle      : String;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull       := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));
    //
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //处理可能存在的style
        sStyle  := '';
        if joHint.Exists('dwstyle') then begin
            sStyle  := ' style="'+dwGetStr(joHint,'dwstyle')+'"';
        end;

        //
        sCode   := '<'+dwGetStr(joHint,'type','div')
                +' id="'+sFull+'"'
                +dwGetDWAttr(joHint)
                +sStyle
                +'>'
                +dwGetStr(joHint,'dwchild','');

        //添加到返回值数据
        joRes.Add(sCode);
        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint      : Variant;
begin

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</'+dwGetStr(joHint,'type','div')+'>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
    sCode       : string;
begin
    sFull       := dwFullName(Actrl);
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TPanel(ACtrl) do begin
        //----- css -----
        sCode   := '$("#'+sFull+'").css({';

        //字体
        if not ParentFont then begin
            sCode   := sCode
                    +'''font-family'': '+dwIIF(Font.name='''微软雅黑','"Microsoft YaHei", "PingFang SC", "Arial", sans-serif''',''''+Font.Name+'''')+','
                    +'''font-size'': '''+IntToStr(Font.Size+3)+'px'','
                    +'''font-weight'': '''+dwIIF(fsBold in Font.Style,'bold','normal')+''','
                    +'''font-style'': '''+dwIIF(fsItalic in Font.Style,'italic','normal')+''','
                    +'''color'': '''+dwColor(Font.Color)+''','
                    +'''text-decoration'': '''+dwIIF(fsUnderLine in Font.Style,dwIIF(fsStrikeOut in Font.Style,'underline line-through','underline'),dwIIF(fsStrikeOut in Font.Style,'line-through','normal'))+''','
        end;

        //显示/隐藏
        sCode   := sCode
                    +'''display'': "'+dwIIF(Visible,'block','none')+'",';

        //超出隐藏
        sCode   := sCode
                    +'''box-sizing'': "border-box",'
                    +'''overflow'': "hidden",';


        //LTWH
        sCode   := sCode
                    +'''position'': ''absolute'','
                    +'''background-color'': '''+dwColor(Color)+''','
                    +'''left'': '''+InttoStr(Left)+'px'','
                    +'''top'': '''+InttoStr(top)+'px'','
                    +'''width'': '''+InttoStr(width)+'px'','
                    +'''height'': '''+InttoStr(height)+'px'''
                +'});';

        //添加到输出
        joRes.Add(sCode);

        //radius
        if joHint.Exists('radius') then begin
            joRes.Add('$("#'+sFull+'").css(''border-radius'', "'+dwGetStr(joHint,'radius')+'");');
        end else begin
            joRes.Add('  ');
        end;

        //radius
        if joHint.Exists('dwstyle') then begin
            joRes.Add('var curStyle = $("#'+sFull+'").attr(''style'');$("#'+sFull+'").attr("style", curStyle+"'+dwGetStr(joHint,'dwstyle')+'");');
        end else begin
            joRes.Add('  ');
        end;

        //----- 可用性 -----
        if Visible then begin
            joRes.Add('$("#'+sFull+'").prop(''disabled'', false);');
        end else begin
            joRes.Add('$("#'+sFull+'").prop(''disabled'', true);');
        end;

        //
        Result    := (joRes);
    end;
end;

function dwGetMounted(ACtrl:TComponent):string;StdCall;
var
    joRes       : Variant;
    joHint      : Variant;
    sFull       : string;
    sCode       : string;
begin
    sFull       := dwFullName(Actrl);

    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    with TPanel(ACtrl) do begin
        //----- css -----
        sCode   := '$("#'+sFull+'").css({';

        //字体
        if not ParentFont then begin
            sCode   := sCode
                    +'''overflow'': "hidden",'
                    +'''font-family'': '+dwIIF(Font.name='''微软雅黑','"Microsoft YaHei", "PingFang SC", "Arial", sans-serif''',''''+Font.Name+'''')+','
                    +'''font-size'': '''+IntToStr(Font.Size+3)+'px'','
                    +'''font-weight'': '''+dwIIF(fsBold in Font.Style,'bold','normal')+''','
                    +'''font-style'': '''+dwIIF(fsItalic in Font.Style,'italic','normal')+''','
                    +'''color'': '''+dwColor(Font.Color)+''','
                    +'''text-decoration'': '''+dwIIF(fsUnderLine in Font.Style,dwIIF(fsStrikeOut in Font.Style,'underline line-through','underline'),dwIIF(fsStrikeOut in Font.Style,'line-through','normal'))+''','
        end;

        //显示/隐藏
        sCode   := sCode
                    +'''display'': "'+dwIIF(Visible,'block','none')+'",';

        //LTWH
        sCode   := sCode
                    +'''position'': ''absolute'','
                    +'''background-color'': '''+dwColor(Color)+''','
                    +'''left'': '''+InttoStr(Left)+'px'','
                    +'''top'': '''+InttoStr(top)+'px'','
                    +'''width'': '''+InttoStr(width)+'px'','
                    +'''height'': '''+InttoStr(height)+'px'''
                +'});';

        //添加到输出
        joRes.Add(sCode);

        //radius
        if joHint.Exists('radius') then begin
            joRes.Add('$("#'+sFull+'").css(''border-radius'', "'+dwGetStr(joHint,'radius')+'");');
        end;

        //radius
        if joHint.Exists('dwstyle') then begin
            joRes.Add('var curStyle = $("#'+sFull+'").attr(''style'');$("#'+sFull+'").attr("style", curStyle+"'+dwGetStr(joHint,'dwstyle')+'");');
        end;

        //----- 可用性 -----
        if not Enabled then begin
            joRes.Add('$("#'+sFull+'").prop(''disabled'', true);');
        end;

        //click
        if Assigned(OnClick) or joHint.Exists('onclick') then begin
            sCode   := ''
                    +'$("#'+sFull+'").on("click", function() {'
                        //+'console.log("div 被点击");'
                        //js的onclick, 可以直接执行
                        +dwIIF(joHint.Exists('onclick'), dwGetStr(joHint,'onclick'), '')
                        //delphi版的onclick
                        +dwIIF(Assigned(OnClick), 'me.dwevent("","'+sFull+'","0","onclick","'+IntToStr(TForm(Owner).Handle)+'");', '')
                    +'});';
            joRes.Add(sCode);
        end;

        //enter
        if Assigned(OnEnter) or joHint.Exists('onenter') then begin
            sCode   := ''
                    +'$("#'+sFull+'").on("mouseenter", function() {'
                        //+'console.log("mouseenter");'
                        //js的事件, 可以直接执行
                        +dwIIF(joHint.Exists('onenter'), dwGetStr(joHint,'onenter'), '')

                        //delphi的
                        +dwIIF(Assigned(OnEnter), 'me.dwevent("","'+sFull+'","0","onenter","'+IntToStr(TForm(Owner).Handle)+'");', '')
                    +'});';
            joRes.Add(sCode);
        end;

        //leave
        if Assigned(OnExit) or joHint.Exists('onexit') then begin
            sCode   := ''
                    +'$("#'+sFull+'").on("mouseleave", function() {'
                        //+'console.log("mouseleave");'
                        //js的事件, 可以直接执行
                        +dwIIF(joHint.Exists('onexit'), dwGetStr(joHint,'onexit'), '')

                        //delphi的
                        +dwIIF(Assigned(OnExit), 'me.dwevent("","'+sFull+'","0","onexit","'+IntToStr(TForm(Owner).Handle)+'");', '')
                    +'});';
            joRes.Add(sCode);
        end;
    end;

    //
    Result    := (joRes);
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetMounted,
     dwGetTail,
     dwGetAction,
     dwGetData;
     
begin
end.
 
