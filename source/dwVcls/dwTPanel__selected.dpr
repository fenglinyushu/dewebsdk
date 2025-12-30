library dwTPanel__selected;
{
    本模块用于解析DataV系统的dv-border-box-13
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


//=====================以上为辅助函数===============================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    sCode       : String;
    sSelColor   : String;   //选中的边框颜色
    sNorColor   : String;   //未选中的边框颜色
    sFull       : String;
    joRes       : Variant;
    joHint      : Variant;
    iSize       : Integer;  //控制选择框的大小
begin
     //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //选中颜色
    if joHint.Exists('selected') then begin
        sSelColor   := joHint.selected;
    end else begin
        sSelColor   := '#1871FF';
    end;

    //未选中颜色
    if joHint.Exists('normal') then begin
        sNorColor   := joHint.normal;
    end else begin
        sNorColor   := '#dcdef6';
    end;

    //选中区大小
    if joHint.Exists('size') then begin
        iSize   := joHint.size;
    end else begin
        iSize   := 17;
    end;


    //
    sCode   :=
            '<style>'+
                '.'+sFull+'_normal {'+
                    'color: '+sNorColor+';'+
                    'box-shadow:0 1px 3px 0 rgba(85,110,97,0.35);'+
                    'border:1px solid '+sNorColor+';'+
                '} '+
                '.'+sFull+'_selected {'+
                    'color: '+sSelColor+';'+
                    'box-shadow:0 2px 7px 0 rgba(85,110,97,0.35);'+
                    'border:1px solid '+sSelColor+';'+
                '} '+
                '.'+sFull+'_selected:before {'+
                    'content: '''';'+
                    'position: absolute;'+
                    'right: 0;'+
                    'bottom: 0;'+
                    'border: '+IntToStr(iSize)+'px solid '+sSelColor+';'+
                    'border-top-color: transparent;'+
                    'border-left-color: transparent;'+
                '}'+
                '.'+sFull+'_selected:after {'+
                    'content: '''';'+
                    'width: '+IntToStr(Round(iSize*5/17))+'px;'+
                    'height: '+IntToStr(Round(iSize*12/17))+'px;'+
                    'position: absolute;'+
                    'right: '+IntToStr(Round(iSize*6/17))+'px;'+
                    'bottom: '+IntToStr(Round(iSize*5/17))+'px;'+
                    'border: 2px solid #fff;'+
                    'border-top-color: transparent;'+
                    'border-left-color: transparent;'+
                    'transform: rotate(45deg);'+
                '}'+
            '</style>';
    //引入对应的库
    joRes.Add(sCode);
    //
    Result := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData  : Variant;
    iX,iY   : Integer;
begin
    with TPanel(Actrl) do begin

        //
        joData    := _Json(AData);

        if joData.e = 'onclick' then begin
            if Enabled then begin
                Locked  := not Locked;
            end;
             if Assigned(TPanel(ACtrl).OnClick) then begin
                  TPanel(ACtrl).OnClick(TPanel(ACtrl));
             end;
        end else if joData.e = 'onmousedown' then begin
            if Assigned(TPanel(ACtrl).OnMouseDown) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TPanel(ACtrl).OnMouseDown(TPanel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onmouseup' then begin
            if Assigned(TPanel(ACtrl).OnMouseup) then begin
                iX  := StrToIntDef(joData.v,0);
                iY  := iX mod 100000;
                iX  := iX div 100000;
                TPanel(ACtrl).OnMouseup(TPanel(ACtrl),mbLeft,[],iX,iY);
            end;
        end else if joData.e = 'onenter' then begin
             if Assigned(TPanel(ACtrl).OnMouseEnter) then begin
                  TPanel(ACtrl).OnMouseEnter(TPanel(ACtrl));
             end;
        end else if joData.e = 'onexit' then begin
             if Assigned(TPanel(ACtrl).OnMouseLeave) then begin
                  TPanel(ACtrl).OnMouseLeave(TPanel(ACtrl));
             end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    sId     : string;
    sFull   : String;
    joHint  : Variant;
    joRes   : Variant;
begin
    //
    sFull   := dwFullName(ACtrl);

    //
    with TPanel(Actrl) do begin


        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        with TPanel(ACtrl) do begin
            //
            sCode   := '<div'
                    +' :class="'+sFull+'__cls"'
                    +' id="'+sFull+'"'
                    +' :value="'+sFull+'__cap"'
                    +dwGetDWAttr(joHint)
                    +dwVisible(TControl(ACtrl))                            //用于控制可见性Visible
                    +' :style="{'
                        +'backgroundColor:'+dwFullName(Actrl)+'__col,'
                        //Font
                        +'color:'+dwFullName(Actrl)+'__fcl,'
                        +'''font-size'':'+dwFullName(Actrl)+'__fsz,'
                        +'''font-family'':'+dwFullName(Actrl)+'__ffm,'
                        +'''font-weight'':'+dwFullName(Actrl)+'__fwg,'
                        +'''font-style'':'+dwFullName(Actrl)+'__fsl,'
                        +'''text-decoration'':'+dwFullName(Actrl)+'__ftd,'

                        +'transform:''rotateZ({'+dwFullName(Actrl)+'__rtz}deg)'','
                        +'left:'+dwFullName(Actrl)+'__lef,top:'+dwFullName(Actrl)+'__top,width:'+dwFullName(Actrl)+'__wid,height:'+dwFullName(Actrl)+'__hei}"'
                        //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                        +' style="position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';overflow:hidden;'
                        +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                        +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                        +dwGetDWStyle(joHint)
                    +'"' //style 封闭
                    +' @click="'+sFull+'__click()"'
                    +'>';
            //添加到返回值数据
            joRes.Add(sCode);
        end;
        //
        Result    := (joRes);
    end;
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    sId     : string;
    sFull   : String;
begin
    with TPanel(Actrl) do begin

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
    joHint      : Variant;
    sType       : String;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(Actrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

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
            //
            joRes.Add(sFull+'__cap:"'+dwProcessCaption(Caption)+'",');
            //
            joRes.Add(sFull+'__cls:"'+dwIIF(Locked,sFull+'_selected',sFull+'_normal')+'",');
            //
            //
            if TPanel(ACtrl).Color = clNone then begin
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
    joRes   : Variant;
    joHint  : Variant;
    sType   : string;
    sFull   : String;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(Actrl) do begin
        joHint  := dwGetHintJson(TControl(Actrl));

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
            //
            joRes.Add('this.'+sFull+'__cap="'+dwProcessCaption(Caption)+'";');
            //
            joRes.Add('this.'+sFull+'__cls="'+dwIIF(Locked,sFull+'_selected',sFull+'_normal')+'";');
            //
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

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode   : string;
    sFull   : string;
    //
    joHint  : Variant;
    joRes   : Variant;
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    with TPanel(ACtrl) do begin
        //函数头部
        sCode   := sFull+'__click(event) {'#13;

        //加入Hint中的onclick赋于的直接js代码
        if joHint.Exists('onclick') then begin
            sCode   := sCode +joHint.onclick+#13;
        end;

        //如果Enabled, 则自动翻转选中状态
        if Enabled then begin
            sCode   := sCode +
                    'if (this.'+sFull+'__cls == "'+sFull+'_selected"){'#13#10+
                        'this.'+sFull+'__cls = "'+sFull+'_normal";'#13#10+
                    '} else {'#13#10+
                        'this.'+sFull+'__cls = "'+sFull+'_selected";'#13#10+
                    '};'#13#10;
        end;

        //
        sCode   := sCode + 'this.dwevent("",'''+sFull+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'},';

        //
        joRes.Add(sCode);
    end;

    //
    Result   := joRes;
end;



exports
     dwGetExtra,
     dwGetMethods,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetData;

begin
end.

