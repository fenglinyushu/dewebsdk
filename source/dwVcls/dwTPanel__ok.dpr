library dwTPanel__ok;
(*
    功能；
        用于弹出一个”Cancel“/"ok"框
    属性：
        Visible     是否弹出
        Caption     标题
        Color       背景色
        Font        字体
        Top         上边距
        Height      高度
        Width       宽度
    Hint:
        ok          确定按钮标题，如{"ok":"确定"}
        cancel      取消按钮标题，如{"cancel":"取消"}
    事件：
        单击cancel按钮时触发OnExit事件
        单击OK按钮时触发OnEnter事件
*)


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

function _GetFont(AFont:TFont):string;
begin

    Result    := 'color:'+dwColor(AFont.color)+';'
               +'font-family:'''+AFont.name+''';'
               +'font-size:'+IntToStr(AFont.size+3)+'px;';

     //粗体
     if fsBold in AFont.Style then begin
          Result    := Result+'font-weight:bold;';
     end else begin
          Result    := Result+'font-weight:normal;';
     end;

     //斜体
     if fsItalic in AFont.Style then begin
          Result    := Result+'font-style:italic;';
     end else begin
          Result    := Result+'font-style:normal;';
     end;

     //下划线
     if fsUnderline in AFont.Style then begin
          Result    := Result+'text-decoration:underline;';
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end;
     end else begin
          //删除线
          if fsStrikeout in AFont.Style then begin
               Result    := Result+'text-decoration:line-through;';
          end else begin
               Result    := Result+'text-decoration:none;';
          end;
     end;
end;

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
function _GetTextAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'right';
          end;
          taCenter : begin
               Result    := 'center';
          end;
     end;
end;




function _GetAlignment(ACtrl:TControl):string;
begin
     Result    := '';
     case TPanel(ACtrl).Alignment of
          taRightJustify : begin
               Result    := 'text-align:right;';
          end;
          taCenter : begin
               Result    := 'text-align:center;';
          end;
     end;
end;

//==================================================================================================

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
    with TPanel(ACtrl) do begin
        //
        joData    := _Json(AData);

        if joData.e = 'onenter' then begin
            Visible := False;
            if Assigned(OnEnter) then begin
                OnEnter(TPanel(ACtrl));
            end;
        end else if joData.e = 'onexit' then begin
            Visible := False;
            if Assigned(OnExit) then begin
                OnExit(TPanel(ACtrl));
            end;
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
    //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TPanel(ACtrl) do begin
        //===============================================================



        //遮罩层
        sCode   :=
                '<div' +
                    ' id="'+sFull+'__cfm"' +
                    ' v-show="'+sFull+'__vis"'+
                    ' style="'+
                        'position:fixed;'+
                        'left:0;'+
                        'top:0;'+
                        'right:0;'+
                        'bottom:0;'+
                        'background: rgba(0,0,0,0.5);'+
                        'z-index:9;'+
                    '"'+
                '>';

        //弹出式面板
        sCode   := sCode +
                '<el-main'
                    +' id="'+dwFullName(Actrl)+'"'
                    +dwVisible(TControl(ACtrl))
                    +dwDisable(TControl(ACtrl))
                    +dwGetDWAttr(joHint)
                    +' :style="{'
                        +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                        //Font
                        +'color:'+dwFullName(Actrl)+'__fcl,'
                        +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                        +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                        +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                        +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                        +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'
                        //
                        +'top:'+dwFullName(Actrl)+'__top,'
                        +'width:'+dwFullName(Actrl)+'__wid,'
                        +'height:'+dwFullName(Actrl)+'__hei'
                    +'}"'
                    //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                    +' style="'
                        +'position:relative;'
                        +'overflow:hidden;'
                        +'margin: 0 auto;'
                        +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                        //+dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                        +'border-radius:10px;'
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                +'>';

        //标签
        sCode   := sCode +
                '<a'
                    +' v-html='+sFull+'__cap'
                    +' style="'
                        +'display: flex; '
                        +'align-items: center;'
                        +'height:'+IntToStr(Height-50)+'px;'
                        +'width:80%;'
                        +'padding-left: 10%;'
                    +'"' //style 封闭
                +'>'
                //+'{{'+sFull+'__cap}}'
                +'</a>';

        //根据是否仅显示OK按钮 onlyok = 1, 分别处理
        if dwGetInt(joHint,'onlyok',0) = 0 then begin
            //取消
            sCode   := sCode +
                    '<el-button'
                        +' style="'
                            +'border:0;'
                            +'border-top:solid 1px #DCDFE6;'
                            +'border-right:solid 1px #DCDFE6;'
                            +'border-radius:0;'
                            +'left:0;'
                            +'bottom:0;'
                            +'height:50px;'
                            +'width:50%;'
                        +'"' //style 封闭
                        +' @click="'+sFull+'__cancelclick"'
                    +'>'
                    +'{{'+sFull+'__can}}'
                    +'</el-button>';

            //确定
            sCode   := sCode +
                    '<el-button'
                        +' type="primary"'
                        +' style="'
                            +'border:0;'
                            +'border-top:solid 1px #DCDFE6;'
                            +'border-radius:0;'
                            +'left:50%;'
                            +'bottom:0;'
                            +'height:50px;'
                            +'width:50%;'
                        +'"' //style 封闭
                        +' @click="'+sFull+'__okclick"'
                    +'>'
                    +'{{'+sFull+'__ok}}'
                    +'</el-button>';
        end else begin
            //确定
            sCode   := sCode +
                    '<el-button'
                        +' type="primary"'
                        +' style="'
                            +'border:0;'
                            +'border-top:solid 1px #DCDFE6;'
                            +'border-radius:0;'
                            +'left:0;'
                            +'bottom:0;'
                            +'height:50px;'
                            +'width:100%;'
                        +'"' //style 封闭
                        +' @click="'+sFull+'__okclick"'
                    +'>'
                    +'{{'+sFull+'__ok}}'
                    +'</el-button>';
        end;


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
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-main>');
        joRes.Add('</div>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sFull   : string;
    sOK     : String;
    sCancel : String;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);

    //
    sCancel := dwGetStr(joHint,'cancel','Cancel');

    //
    sOK     := dwGetStr(joHint,'ok','OK');

    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TPanel(ACtrl) do begin
            joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
            joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
            joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
            joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
            //
            joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
            joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
            //
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add(sFull+'__col:"rgba(0,0,0,0)",');
            end else begin
                joRes.Add(sFull+'__col:"'+dwAlphaColor(TPanel(ACtrl))+'",');
            end;
            //
            joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
            //
            joRes.Add(sFull+'__can:"'+dwProcessCaption(sCancel)+'",');
            joRes.Add(sFull+'__ok:"'+dwProcessCaption(sOK)+'",');
            //
            joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
            joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sFull   : string;
    sOK     : String;
    sCancel : String;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);

    //
    sCancel := dwGetStr(joHint,'cancel','Cancel');

    //
    sOK     := dwGetStr(joHint,'ok','OK');

    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //
        with TPanel(ACtrl) do begin
            joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
            joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
            joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
            joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
            //
            joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
            joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
            //
            if TPanel(ACtrl).Color = clNone then begin
                joRes.Add('this.'+sFull+'__col="rgba(0,0,0,0)";');
            end else begin
                joRes.Add('this.'+sFull+'__col="'+dwAlphaColor(TPanel(ACtrl))+'";');
            end;
            //
            joRes.Add('this.'+sFull+'__fcl="'+dwColor(Font.Color)+'";');
            joRes.Add('this.'+sFull+'__fsz="'+IntToStr(Font.size+3)+'px";');
            joRes.Add('this.'+sFull+'__ffm="'+Font.Name+'";');
            joRes.Add('this.'+sFull+'__fwg="'+_GetFontWeight(Font)+'";');
            joRes.Add('this.'+sFull+'__fsl="'+_GetFontStyle(Font)+'";');
            joRes.Add('this.'+sFull+'__ftd="'+_GetTextDecoration(Font)+'";');
            //
            joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
            //
            joRes.Add('this.'+sFull+'__can="'+dwProcessCaption(sCancel)+'";');
            joRes.Add('this.'+sFull+'__ok="'+dwProcessCaption(sOK)+'";');
        end;
        //
        Result    := (joRes);
    end;
end;

//dwGetMethod
function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;

begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint := dwGetHintJson(TControl(ACtrl));


    with TEdit(ACtrl) do begin


        //Cancel事件
        sCode   :=
                sFull+'__cancelclick() '
                +'{'
                    +'_this.'+sFull+'__vis = false;'
                    +'var jo={};'
                    +'jo.m="event";'
                    +'jo.c="'+sFull+'";'
                    +'jo.i='+IntToStr(TForm(Owner).Handle)+';'
                    +'jo.v="0";'
                    +'jo.e="onexit";'
                    +'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'
                    +'.then(resp =>{this.procResp(resp.data)});'
                +'},';
        joRes.Add(sCode);


        //OK事件
        sCode   :=
                sFull+'__okclick() '
                +'{'
                    +'_this.'+sFull+'__vis = false;'
                    +'var jo={};'
                    +'jo.m="event";'
                    +'jo.c="'+sFull+'";'
                    +'jo.i='+IntToStr(TForm(Owner).Handle)+';'
                    +'jo.v="0";'
                    +'jo.e="onenter";'
                    +'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:2051}})'
                    +'.then(resp =>{this.procResp(resp.data)});'
                +'},';
        joRes.Add(sCode);


    end;
    //
    Result   := joRes;

end;



exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;
     
begin
end.
 
