library dwTSplitter;

{
功能说明:
    简化版的panel
    1 默认显示LTWH和color
    2 动态设置LTWH
    3 支持dwattr和dwstyle

更新说明
    ### 2025-03-29
    1 增加了dwchild属性HINT, 可以添加一段HTML代码, 用于子元素
    2 增加了font属性支持
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
    sCode   := '<script src="dist/_zepto/zepto.min.js"></script>';
    joRes.Add(sCode);

    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData      : Variant;
    joHint      : Variant;
    oLinkPanel  : TPanel;
begin

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TSplitter(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onmove' then begin
            oLinkPanel  := TPanel(TForm(Owner).FindComponent(dwGetStr(joHint,'link')));
            if oLinkPanel <> nil then begin
                case Align of
                    alLeft : begin
                        oLinkPanel.Width    := oLinkPanel.Width + StrToIntDef(joData.v,0);
                    end;
                    alRight : begin
                        oLinkPanel.Width    := oLinkPanel.Width - StrToIntDef(joData.v,0);
                    end;
                    alTop : begin
                        oLinkPanel.Height   := oLinkPanel.Height + StrToIntDef(joData.v,0);
                    end;
                    alBottom : begin
                        oLinkPanel.Height   := oLinkPanel.Height - StrToIntDef(joData.v,0);
                    end;
                end;
            end;
            //
            //TSplitter(ACtrl).OnClick(TSplitter(ACtrl));
        end else if joData.e = 'onenter' then begin
            //TSplitter(ACtrl).OnEnter(TSplitter(ACtrl));
        end else if joData.e = 'onexit' then begin
            //TSplitter(ACtrl).OnExit(TSplitter(ACtrl));
        end;
    end;
end;

//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull       := dwFullName(Actrl);
    //
    with TSplitter(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwGetDWAttr(joHint)
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
begin
    with TSplitter(ACtrl) do begin
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
    joRes       : Variant;
    sFull       : string;
begin
    sFull       := dwFullName(Actrl);

    with TSplitter(ACtrl) do begin
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


    with TSplitter(ACtrl) do begin
        //----- css -----
        sCode   := '$("#'+sFull+'").css({';

        //显示/隐藏
        sCode   := sCode
                    +'''display'': "'+dwIIF(Visible,'block','none')+'",';

        //禁用/可用
        sCode   := sCode
                +'''pointer-events'': "'+dwIIF(Enabled,'auto','none')+'",';

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
    with TSplitter(ACtrl) do begin

        //----- css -----
        sCode   := '$("#'+sFull+'").css({';

        //显示/隐藏
        sCode   := sCode
                    +'''display'': "'+dwIIF(Visible,'block','none')+'",';

        //禁用/可用
        sCode   := sCode
                    +'''pointer-events'': "'+dwIIF(Enabled,'auto','none')+'",';

        //鼠标
        case TSplitter(ACtrl).Align of
            alLeft,alRight : begin
                sCode   := sCode
                            +'''cursor'': "e-resize",';
            end;
            alTop,alBottom : begin
                sCode   := sCode
                            +'''cursor'': "s-resize",';
            end;
        end;

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


        //添加事件
        if Align in [alLeft,alRight] then begin
            sCode   := ''
                    //js的事件, 可以直接执行
                    +'var '+sFull+'__mousedown = false;'
                    +'var '+sFull+'__mouseOld = 0;'
                    +'var '+sFull+'__timer;'
                    +'$("#'+sFull+'").on("mousedown", function(e) {'
                        +sFull+'__mousedown = true;'

                        // 记录初始位置
                        +sFull+'__mouseOld = e.clientX;'

                        // 绑定事件到document确保快速移动不丢失
                        +'$(document).on("mousemove", '+sFull+'__onMouseMove);'
                        +'$(document).on("mouseup", '+sFull+'__onMouseUp);'
                    +'});';
            joRes.Add(sCode);

            //添加事件
            sCode   := ''
                    // 鼠标移动处理
                    +'function '+sFull+'__onMouseMove(e) {'
                        //禁止选中文本
                        +'$("body").css("user-select", "none");'

                        //左键未按下,则释放
                        +'if (event.button !== 0) {'
                            +sFull+'__mousedown = false;'

                            // 移除事件监听
                            +'$(document).off("mousemove", '+sFull+'__onMouseMove);'
                            +'$(document).off("mouseup", '+sFull+'__onMouseUp);'
                            +'return;'
                        +'};'

                        //+'console.log("mousemove");'
                        +'if (!'+sFull+'__mousedown) return;'

                        //防抖
                        +'if (!'+sFull+'__timer) {'
                            +sFull+'__timer = setTimeout(function() {'
                                // 执行需要的操作
                                //console.log("鼠标移动触发");
                                +sFull+'__timer = null;'  // 重置定时器

                                // 计算移动距离
                                +'const delta = e.clientX - '+sFull+'__mouseOld;'

                                // 记录初始位置
                                +sFull+'__mouseOld = e.clientX;'

                                //给后端发送消息
                                +'me.dwevent("","'+sFull+'",delta,"onmove","'+IntToStr(TForm(Owner).Handle)+'");'

                            +'}, 100);'  // 每100ms触发一次
                        +'}'
                    +'}'

                    // 鼠标释放处理
                    +'function '+sFull+'__onMouseUp(e) {'
                        //恢复可选中文本
                        +'$("body").css("user-select", "auto");'

                        //
                        +sFull+'__mousedown = false;'

                        // 移除事件监听
                        +'$(document).off("mousemove", '+sFull+'__onMouseMove);'
                        +'$(document).off("mouseup", '+sFull+'__onMouseUp);'
                    +'};';

            joRes.Add(sCode);
        end else if Align in [alTop,alBottom] then begin
            sCode   := ''
                    //js的事件, 可以直接执行
                    +'var '+sFull+'__mousedown = false;'
                    +'var '+sFull+'__mouseOld = 0;'
                    +'var '+sFull+'__timer;'
                    +'$("#'+sFull+'").on("mousedown", function(e) {'
                        +sFull+'__mousedown = true;'

                        // 记录初始位置
                        +sFull+'__mouseOld = e.clientY;'

                        // 绑定事件到document确保快速移动不丢失
                        +'$(document).on("mousemove", '+sFull+'__onMouseMove);'
                        +'$(document).on("mouseup", '+sFull+'__onMouseUp);'
                    +'});';
            joRes.Add(sCode);

            //添加事件
            sCode   := ''
                    // 鼠标移动处理
                    +'function '+sFull+'__onMouseMove(e) {'
                        //禁止选中文本
                        +'$("body").css("user-select", "none");'

                        //左键未按下,则释放
                        +'if (event.button !== 0) {'
                            +sFull+'__mousedown = false;'

                            // 移除事件监听
                            +'$(document).off("mousemove", '+sFull+'__onMouseMove);'
                            +'$(document).off("mouseup", '+sFull+'__onMouseUp);'
                            +'return;'
                        +'};'

                        //+'console.log("mousemove");'
                        +'if (!'+sFull+'__mousedown) return;'

                        //防抖
                        +'if (!'+sFull+'__timer) {'
                            +sFull+'__timer = setTimeout(function() {'
                                // 执行需要的操作
                                //console.log("鼠标移动触发");
                                +sFull+'__timer = null;'  // 重置定时器

                                // 计算移动距离
                                +'const delta = e.clientY - '+sFull+'__mouseOld;'

                                // 记录初始位置
                                +sFull+'__mouseOld = e.clientY;'

                                //给后端发送消息
                                +'me.dwevent("","'+sFull+'",delta,"onmove","'+IntToStr(TForm(Owner).Handle)+'");'

                            +'}, 100);'  // 每100ms触发一次
                        +'}'
                    +'}'

                    // 鼠标释放处理
                    +'function '+sFull+'__onMouseUp(e) {'
                        //恢复可选中文本
                        +'$("body").css("user-select", "auto");'

                        //
                        +sFull+'__mousedown = false;'

                        // 移除事件监听
                        +'$(document).off("mousemove", '+sFull+'__onMouseMove);'
                        +'$(document).off("mouseup", '+sFull+'__onMouseUp);'
                    +'};';

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


