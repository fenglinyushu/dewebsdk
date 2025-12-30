library dwTPanel__float;

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
     joData     : Variant;
     joValue    : Variant;
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
        end else if joData.e = 'ondrag' then begin
            if Pos('Panel',Parent.ClassName)>0 then begin
                joValue := _Json('['+dwUnescape(joData.v)+']');
                TPanel(Parent).Left := TPanel(Parent).Left + joValue._(0);
                TPanel(Parent).Top  := TPanel(Parent).Top  + joValue._(1);
            end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    joHint  : Variant;
    joRes   : Variant;
    sEnter  : String;
    sExit   : String;
    sClick  : string;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);

    with TPanel(ACtrl) do begin
        //===============================================================

        //生成返回值数组
        joRes    := _Json('[]');

        //取得HINT对象JSON
        joHint    := dwGetHintJson(TControl(ACtrl));

        //
        sCode   := '<el-main'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                //+dwGetHintValue(joHint,'type','type',' type="default"')
                //+dwGetHintValue(joHint,'icon','icon','')
                +' v-html="'+dwFullName(Actrl)+'__cap"'
                +' :style="{'
                    +'backgroundColor:'+sFull+'__col,'
                    //Font
                    +'color:'+sFull+'__fcl,'
                    +'''font-size'':'+sFull+'__fsz,'
                    +'''font-family'':'+sFull+'__ffm,'
                    +'''font-weight'':'+sFull+'__fwg,'
                    +'''font-style'':'+sFull+'__fsl,'
                    +'''text-decoration'':'+sFull+'__ftd,'
                    +'transform:''rotateZ({'+sFull+'__rtz}deg)'','
                    +'left:'+sFull+'__lef,top:'+sFull+'__top,width:'+sFull+'__wid,height:'+sFull+'__hei'
                +'}"'
                //+' style="position:'+dwIIF(Parent.ControlCount=1,'relative','absolute')+';overflow:hidden;'
                +' style="'
                    +'position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';overflow:hidden;'
                    +'cursor: move;'
                    +'line-height: '+IntToStr(Height-3)+'px;'
                    +'text-align: center;'
                    +'user-select: none;'
                    +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +' @mousedown.native = "'+sFull+'__mdw"'
                +' @mousemove.native = "'+sFull+'__mmv"'
                +' @mouseup.native = "'+sFull+'__mup"'
                +' @mouseleave.native = "'+sFull+'__mup"'
                +'>';
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
    with TPanel(ACtrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');
        //生成返回值数组
        joRes.Add('</el-main>');
        //
        Result    := (joRes);
    end;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint    : Variant;
    sFull   : string;
begin
    //
    sFull   := dwFullName(ACtrl);
    //
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
            joRes.Add(sFull+'__rtz:30,');
            //
            joRes.Add(sFull+'__fcl:"'+dwColor(Font.Color)+'",');
            joRes.Add(sFull+'__fsz:"'+IntToStr(Font.size+3)+'px",');
            joRes.Add(sFull+'__ffm:"'+Font.Name+'",');
            joRes.Add(sFull+'__fwg:"'+_GetFontWeight(Font)+'",');
            joRes.Add(sFull+'__fsl:"'+_GetFontStyle(Font)+'",');
            joRes.Add(sFull+'__ftd:"'+_GetTextDecoration(Font)+'",');

            //鼠标位置变量
            joRes.Add(sFull+'__msx : -9999,');
            joRes.Add(sFull+'__msy : -9999,');
            //
            joRes.Add(dwFullName(Actrl)+'__cap:"'+dwProcessCaption(Caption)+'",');
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
begin
    //
    sFull   := dwFullName(ACtrl);
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

            //鼠标位置变量
            joRes.Add('this.'+sFull+'__msx = -9999;');
            joRes.Add('this.'+sFull+'__msy = -9999;');
            //
            joRes.Add('this.'+dwFullName(Actrl)+'__cap="'+dwProcessCaption(Caption)+'";');
        end;
        //
        Result    := (joRes);
    end;
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    sParent     : String;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    if Pos('Panel',ACtrl.ClassName)<=0 then begin
        Exit;
    end;

    //取得父类全名
    sParent := dwFullName(ACtrl.Parent);

    with TPanel(ACtrl) do begin

        //mousedown
        sCode   :=
                sFull+'__mdw(e) {'#13#10+
                    //'console.log("down");'+
                    'this.'+sFull+'__msx = e.clientX;'#13+
                    'this.'+sFull+'__msy = e.clientY;'#13+
                '},';
        joRes.Add(sCode);

        //mousemove
        sCode   :=
                sFull+'__mmv(e) {'#13#10+
                    'let _this = this;'#13+
                    'if ((this.'+sFull+'__msx !== -9999)&&(this.'+sFull+'__msy !== -9999)) {'#13+
                        //'console.log("move");'#13+
                        'let deltax = e.clientX - this.'+sFull+'__msx;'#13+
                        'let deltay = e.clientY - this.'+sFull+'__msy;'#13+
                        'let svalue = ""+String(deltax)+","+String(deltay);'#13+
                        'this.'+sFull+'__msx = e.clientX;'#13+
                        'this.'+sFull+'__msy = e.clientY;'#13+
                        //
                        'let jo = {};'#13+
                        'jo.m = "event";'#13+
                        'jo.i = '+IntToStr(TForm(TButton(ACtrl).Owner).Handle)+';'#13+
                        'jo.c = "'+sFull+'";'#13+
                        'jo.v = escape(svalue);'#13+
                        'jo.e = "ondrag";'#13+
                        'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'#13+
                        '.then(resp =>{'#13+
                            'eval(String(resp.data.o)); '#13+
                        '});'#13+
                    '};'#13+
                '},';
        joRes.Add(sCode);

        //mouseup
        sCode   :=
                sFull+'__mup(e) {'#13#10+
                    //'console.log("up");'+
                    'this.'+sFull+'__msx = -9999;'#13+
                    'this.'+sFull+'__msy = -9999;'#13+
                '},';
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
 
