library dwTLabel__datetime;
{
功能说明:
    自动显示时间控件
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


function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TLabel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     else
               Result    := 'left';
     end;
end;


function _GetLayout(ACtrl:TControl):string;
begin
     Result    := '';
     case TLabel(ACtrl).Layout of
          tlBottom : begin
               Result    := '"justify-content": "'+_GetAlignment(ACtrl)+'","align-items": "flex-end","display": "flex",';
          end;
          tlCenter : begin
               Result    := '"justify-content": "center","flex-direction": "column","display": "flex",';
          end;
     else
               Result    := '';
     end;
end;
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
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    sFull       := dwFullName(Actrl);
    //
    with TLabel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        sCode   := '<div'
                +' id="'+sFull+'"'
                +dwGetDWAttr(joHint)
                +'>'
                +StringReplace(Caption,'`','\`',[rfReplaceAll])
                +dwGetStr(joHint,'dwchild','')
                +'</div>';

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
    sCode     : String;
begin
    with TLabel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        //joRes.Add('</div>');
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

    with TLabel(ACtrl) do begin
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


    with TLabel(ACtrl) do begin
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
                    //+'''line-height'': '1.6',
                    //+'''letter-spacing'': '1px',
                    //+'''text-transform'': 'capitalize',
                    //+'''text-shadow'': '1px 1px 3px rgba(0, 0, 0, 0.5)'''' +
        end;

        //对齐
        sCode   := sCode
                    +'''text-align'': "'+_GetAlignment(TControl(ACtrl))+'",'
                    +_GetLayout(TControl(ACtrl));


        //LTWH
        sCode   := sCode
                    +'''position'': ''absolute'','
                    +dwIIF(Transparent,'','"background-color": "'+dwColor(Color)+'",')
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
            joRes.Add('');
        end;

        //radius
        if joHint.Exists('dwstyle') then begin
            joRes.Add('var curStyle = $("#'+sFull+'").attr(''style'');$("#'+sFull+'").attr("style", curStyle+"'+dwGetStr(joHint,'dwstyle')+'");');
        end else begin
            joRes.Add('');
        end;

        //----- 可见性 -----
        if Visible then begin
            joRes.Add('$("#'+sFull+'").show();');
        end else begin
            joRes.Add('$("#'+sFull+'").hide();');
        end;

        //----- 可用性 -----
        if Enabled then begin
            joRes.Add('$("#'+sFull+'").prop(''disabled'', false);');
        end else begin
            joRes.Add('$("#'+sFull+'").prop(''disabled'', true);');
        end;

        //文本
        joRes.Add('$("#'+sFull+'").html(`'+StringReplace(Caption,'`','\`',[rfReplaceAll])+'`);');
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
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TLabel(ACtrl) do begin
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

        //对齐
        sCode   := sCode
                    +'''text-align'': "'+_GetAlignment(TControl(ACtrl))+'",'
                    +_GetLayout(TControl(ACtrl));


        //LTWH
        sCode   := sCode
                    +'''position'': ''absolute'','
                    +dwIIF(Transparent,'','"background-color": "'+dwColor(Color)+'",')
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

        //----- 可见性 -----
        if not Visible then begin
            joRes.Add('$("#'+sFull+'").hide();');
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

        sCode   := ''
                +'function '+sFull+'__updateTime() {'
                    +'const date = new Date();'
                    +'const year = date.getFullYear();'
                    +'const month = String(date.getMonth() + 1).padStart(2, "0");' // 月份从0开始需+1
                    +'const day = String(date.getDate()).padStart(2, "0");'
                    +'const hours = String(date.getHours()).padStart(2, "0");'
                    +'const minutes = String(date.getMinutes()).padStart(2, "0");'
                    +'const seconds = String(date.getSeconds()).padStart(2, "0");'

                    // 替换格式占位符
                    +'let sres = "'+dwGetStr(joHint,'format','YYYY-MM-DD hh:mm:ss')+'";'
                    +'sres = sres.replace("YYYY", year)'
                    +'.replace("MM", month)'
                    +'.replace("DD", day)'
                    +'.replace("hh", hours)'
                    +'.replace("mm", minutes)'
                    +'.replace("ss", seconds);'

                    +'document.getElementById("'+sFull+'").textContent = sres;'
                +'}'

                +'setInterval('+sFull+'__updateTime, 1000);' // 每秒更新
                +sFull+'__updateTime();'; // 初始化一次显示当前时间
        //
        joRes.Add(sCode);


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
 
