library dwTPanel__button;
(*
    主要用于使用TPanel来创建带图片的按钮，类似TSpeedButton.

    创建dwTPanel__button的最初原因是TPanel有TabOrder属性， 在多按钮情况下可以根据TabOrder排序

    主要原生属性有：
    1. Color 当为clNone时显示透明色，基本显示当前颜色
    2. BorderStyle 当为bsSingle，显示带阴影的边框

    主要Hint属性有：
    1. src 字符串类型，用于指定图片名称。注意；图片存放位置必须是可访问的，如media目录、image目录、dist目录、download目录等
       如：{"src":"media/images/logo.png"}
    2. href 字符串类型，指定当前按钮对应的链接，在新建页面打开,如；{"href":"http://www.delphibbs.com"}
    3. hrefself 字符串类型，指定当前按钮对应的链接，在当前页面打开
    4. radius 字符串类型， 指定当前面板的圆角半径，如:{"radius":"10px"}
    5. onenter 字符串类型，用于指定进入当前Panel时javascript代码，需要一定的javascript基础
    6. onexit 字符串类型，用于指定离开当前Panel时javascript代码，需要一定的javascript基础
    7. onclick 字符串类型，用于指定点击当前Panel时javascript代码，需要一定的javascript基础
    8. imageheight 数值型，默认为高度的一半
*)

uses
  ShareMem,
  dwCtrlBase,
  SynCommons,
  Buttons,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  ComCtrls,
  ExtCtrls,
  StdCtrls,
  Windows;

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

//当前控件需要引入的第三方JS/CSS ,一般为不做改动
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');

     {
     //以下是TChart时的代码,供参考
     joRes.Add('<script src="dist/charts/echarts.min.js"></script>');
     joRes.Add('<script src="dist/charts/lib/index.min.js"></script>');
     joRes.Add('<link rel="stylesheet" href="dist/charts/lib/style.min.css">');
     }
     (*
     joRes.Add(
        '<style>'
            +'.imgunselectable {'
                +'-moz-user-select: -moz-none;'
                +'-khtml-user-select: none;'
                +'-webkit-user-select: none;'
                +'-o-user-select: none;'
                +'user-select: none;'
            +'}'
        +'<style>'
        );
     *)
     //
     Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
     joData    : Variant;
begin
     //
     joData    := _Json(AData);

     if joData.e = 'onclick' then begin
          //
          if Assigned(TPanel(ACtrl).OnClick) then begin
               TPanel(ACtrl).OnClick(TPanel(ACtrl));
          end;
     end else if joData.e = 'onenter' then begin
          //
          if Assigned(TPanel(ACtrl).OnMouseEnter) then begin
               TPanel(ACtrl).OnMouseEnter(TPanel(ACtrl));
          end;
     end else if joData.e = 'onexit' then begin
          //
          if Assigned(TPanel(ACtrl).OnMouseLeave) then begin
               TPanel(ACtrl).OnMouseLeave(TPanel(ACtrl));
          end;
     end;

end;

function _ImageLTWH(ACtrl:TControl):String;  //可以更新位置的用法
var
    sFull   : string;
begin
    sFull   := dwFullName(ACtrl);
    //
    with ACtrl do begin
        Result  :=
                ' :style="{'
                    +'left:0,'
                    //+'top:0,'
                    //+'height:100%,'
                    +'top:'+sFull+'__imt,'
                    +'height:'+sFull+'__imh'
                +'}"'
                +' style="'
                    +'position:absolute;'
                    //+'height:100%;'
                    +'width:100%;';
    end;
end;
function _LabelLTWH(ACtrl:TControl):String;  //可以更新位置的用法
var
    sFull   : string;
begin
    sFull   := dwFullName(ACtrl);
    //
    with ACtrl do begin
        Result  :=
                ' :style="{'
                    +'left:0,top:'+sFull+'__lbt,'
                    +'height:'+sFull+'__lbh'
                +'}"'
                +' style="'
                    +'position:absolute;'
                    +'width:100%;';
    end;
end;



//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sSize       : string;
    sName       : string;
    sEnter      : String;
    sExit       : String;
    sClick      : string;
    sFull   : string;
    //
    joHint      : Variant;
    joRes       : Variant;
    //
    iImgHeight  : Integer;  //图片高度，用于控制位置
begin
    sFull   := dwFullName(ACtrl);

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));


    with TPanel(ACtrl) do begin
        //
        iImgHeight  := Height div 2;
        if joHint.Exists('imageheight') then begin
            iImgHeight  := joHint.imageheight;
        end;


        //进入事件代码--------------------------------------------------------
        sEnter  := '';
        if joHint.Exists('onenter') then begin
            sEnter  := String(joHint.onenter);
        end;
        if sEnter='' then begin
            if Assigned(OnEnter) then begin
                sEnter    := Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnEnter) then begin
                sEnter    := Format(_DWEVENTPlus,['mouseenter.native',sEnter,Name,'0','onenter',TForm(Owner).Handle])
            end else begin
                sEnter    := ' @mouseenter.native="'+sEnter+'"';
            end;
        end;


        //退出事件代码--------------------------------------------------------
        sExit  := '';
        if joHint.Exists('onexit') then begin
            sExit  := String(joHint.onexit);
        end;
        if sExit='' then begin
            if Assigned(OnExit) then begin
                sExit    := Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnExit) then begin
                sExit    := Format(_DWEVENTPlus,['mouseleave.native',sExit,Name,'0','onexit',TForm(Owner).Handle])
            end else begin
                sExit    := ' @mouseleave.native="'+sExit+'"';
            end;
        end;

        //单击事件代码--------------------------------------------------------
        sClick    := '';
        if joHint.Exists('onclick') then begin
            sClick := String(joHint.onclick);
        end;
        //
        if sClick='' then begin
            if Assigned(OnClick) then begin
                sClick    := Format(_DWEVENT,['click.native',Name,'0','onclick',TForm(Owner).Handle]);
            end else begin

            end;
        end else begin
            if Assigned(OnClick) then begin
                sClick    := Format(_DWEVENTPlus,['click.native',sClick,Name,'0','onclick',TForm(Owner).Handle])
            end else begin
                sClick    := ' @click.native="'+sClick+'"';
            end;
        end;


        //如果有href，则直接对应链接
        if joHint.Exists('href') then begin
            joRes.Add('<a href="'+String(joHint.href)+'" target="_blank">');
        end else if joHint.Exists('hrefself') then begin
            //2024-01-09 屏蔽下面这行，增加了下面的代码
            joRes.Add('<a href="'+String(joHint.hrefself)+'">');
            //joRes.Add('<a @click="'+sFull+'__hrf('''+String(joHint.hrefself)+''')"  @touchstart="'+sFull+'__hrf('''+String(joHint.hrefself)+''')" >');
        end;           //@touchstart

        //添加外框
        sCode   := '<el-main'
                +' id="'+sFull+'"'
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))
                +dwGetDWAttr(joHint)
                +' :style="{'
                    +'backgroundColor:'+sFull+'__col,'
                    //Font
                    +'color:'+sFull+'__fcl,'
                    +'''font-size'':'+sFull+'__fsz,'
                    +'''font-family'':'+sFull+'__ffm,'
                    +'''font-weight'':'+sFull+'__fwg,'
                    +'''font-style'':'+sFull+'__fsl,'
                    +'''text-decoration'':'+sFull+'__ftd,'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="'
                    +'position:'+dwIIF((Parent.ControlCount=1)and(Parent.ClassName='TScrollBox'),'relative','absolute')+';'
                    +'overflow:hidden;'
                    +dwIIF(BorderStyle=bsSingle,'border-radius: 2px;box-shadow: 0 2px 4px rgba(0, 0, 0, .12), 0 0 6px rgba(0, 0, 0, .04);box-shadow: 0 2px 12px 0 rgba(0, 0, 0, 0.1);','')
                    +dwGetHintStyle(joHint,'radius','border-radius','')   //border-radius
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +sClick
                +sEnter
                +sExit
                +'>';
        joRes.Add(sCode);



        //文本
        joRes.Add('<div'
                +' v-html="'+sFull+'__cap"'
                +' class="dwdisselect"'      //禁止选中
                //style
                +' :style="{'

                    +'left:0,'
                    +'top:'+sFull+'__lbt,'
                    +'height:'+sFull+'__lbh'    //label height
                +'}"'
                +' style="'
                    +'position:absolute;'
                    +'backgroundColor:transparent;'
                    +'overflow:hidden;'
                    +'width:100%;'
                    +'text-align:center;'
                    //+'line-height:'+IntToStr(Round((Font.Size+3)*2))+'px;'
                    //+'cursor: pointer;'   //图片鼠标样式
                +'"'
                //style 封闭
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'>{{'+sFull+'__cap}}</div>'
        );

        //图标
        joRes.Add('<el-image'
                +' :src="'+sFull+'__src"'
                //+' class="imgunselectable"'
                +' fit="none"'
                +_ImageLTWH(TControl(ACtrl))
                //+'cursor: pointer;'   //图片鼠标样式
                +'"'
                //+dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                //+dwIIF(Assigned(OnMOuseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'></el-image>'
        );

        //增加一个空的文本层, 以便点击时, 选中全部
        joRes.Add('<div'
                +' :style="{'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}"'
                +' style="'
                    +'position:absolute;'
                    +'caret-color: transparent;'
                    +'backgroundColor:transparent,'
                    +'cursor: pointer;'   //图片鼠标样式
                +'"'
                //style 封闭
                +dwIIF(Assigned(OnClick),Format(_DWEVENT,['click',Name,'0','onclick',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),'')
                +dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),'')
                +'></div>'
        );
    end;

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
    joRes     : Variant;
    joHint      : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //生成返回值数组
    joRes.Add('</el-main>');          //此处需要和dwGetHead对应

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    if joHint.Exists('href') then begin
        joRes.Add('</a>');
    end else if joHint.Exists('hrefself') then begin
        joRes.Add('</a>');
    end;
    //
    Result    := (joRes);
end;

function _dwGeneral(ACtrl:TComponent;AMode:string):string;StdCall;
var
    iImgHeight  : Integer;  //图片实际高度（引用图片的像素值），用于计算上边界，默认为总高度的一半
    iImgTop     : Integer;  //图片的应该显示的Top,向上和向下扩展一些之前的top
    iImgRealT   : Integer;  //图片的Top,为了充满整个界面，向上和向下扩展一些
    iImgRealH   : Integer;  //图片的Height,为了充满整个界面，向上和向下扩展一些
    iLblRealT   : Integer;  //标题的Top
    iHeight     : Integer;  //图片和文字总体高度
    //
    sCode       : string;
    sFull       : string;
    sMiddle     : string;
    sTail       : string;

    //
    joRes       : variant;
    joHint      : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);

    //
    if AMode = 'data' then begin
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sMiddle := '=';
        sTail   := ';';
        sFull   := 'this.'+sFull;
    end;

    //
    with TPanel(ACtrl) do begin
        //基本LTWH
        joRes.Add(sFull+'__lef'+sMiddle+'"'+IntToStr(Left)+'px"'+sTail);
        joRes.Add(sFull+'__top'+sMiddle+'"'+IntToStr(Top)+'px"'+sTail);
        joRes.Add(sFull+'__wid'+sMiddle+'"'+IntToStr(Width)+'px"'+sTail);
        joRes.Add(sFull+'__hei'+sMiddle+'"'+IntToStr(Height)+'px"'+sTail);

        //可见性和禁用
        joRes.Add(sFull+'__vis'+sMiddle+''+dwIIF(Visible,'true'+sTail,'false'+sTail));
        joRes.Add(sFull+'__dis'+sMiddle+''+dwIIF(Enabled,'false'+sTail,'true'+sTail));

        //<-----计算图片和标题的显示位置，总的原则是“图片+文字”总体高度居中
        //取得图片高度
        iImgHeight  := Height div 2;
        if joHint.Exists('imageheight') then begin
            iImgHeight  := joHint.imageheight;
        end;
{
        iImgTop     := (Height - (iImgHeight + (Font.Size+3)*2)) div 2;
        iImgRealT   := - (Font.Size+3)*2;
        iImgRealH   := Height + (Font.Size+3)*2;
        iLblRealT   := iImgTop + iImgHeight;
}
        iHeight     := iImgHeight + Font.Size + 3;
        iImgRealT   := (Height - iHeight) div 2;
        iImgRealH   := iImgHeight;
        iLblRealT   := iImgRealT + iImgHeight ;
        //----->

        //
        joRes.Add(sFull+'__imt'+sMiddle+'"'+IntToStr(iImgRealT)+'px"'+sTail); //-Round(Font.Size*2)
        joRes.Add(sFull+'__imh'+sMiddle+'"'+IntToStr(iImgRealH)+'px"'+sTail); //-Round(Font.Size*2)
        joRes.Add(sFull+'__lbt'+sMiddle+'"'+IntToStr(iLblRealT)+'px"'+sTail);
        joRes.Add(sFull+'__lbh'+sMiddle+'"'+IntToStr((Font.Size+3)*2)+'px"'+sTail);
        //
        joRes.Add(sFull+'__src'+sMiddle+'"'+dwGetProp(TControl(ACtrl),'src')+'"'+sTail);
        //
        joRes.Add(sFull+'__cap'+sMiddle+'"'+dwProcessCaption(Caption)+'"'+sTail);
        //
        //
        if TPanel(ACtrl).Color = clNone then begin
            joRes.Add(sFull+'__col'+sMiddle+'"rgba(0,0,0,0)"'+sTail);
        end else begin
            joRes.Add(sFull+'__col'+sMiddle+'"'+dwAlphaColor(TPanel(ACtrl))+'"'+sTail);
        end;
        //
        joRes.Add(sFull+'__fcl'+sMiddle+'"'+dwColor(Font.Color)+'"'+sTail);
        joRes.Add(sFull+'__fsz'+sMiddle+'"'+IntToStr(Font.size+3)+'px"'+sTail);
        joRes.Add(sFull+'__ffm'+sMiddle+'"'+Font.Name+'"'+sTail);
        joRes.Add(sFull+'__fwg'+sMiddle+'"'+_GetFontWeight(Font)+'"'+sTail);
        joRes.Add(sFull+'__fsl'+sMiddle+'"'+_GetFontStyle(Font)+'"'+sTail);
        joRes.Add(sFull+'__ftd'+sMiddle+'"'+_GetTextDecoration(Font)+'"'+sTail);

    end;
    Result  := joRes;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
begin
     Result    := _dwGeneral(ACtrl,'data');
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
begin
     Result    := _dwGeneral(ACtrl,'action');
end;


function dwGetMethods(ACtrl:TControl):String;StdCall;
var
    //
    sCode   : string;
    sFull   : string;
    joRes   : Variant;
begin
    joRes   := _json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    with TPanel(ACtrl) do begin
        sCode   :=
                sFull + '__hrf(val){'
                    +'window.location.href = val;'
                +'},';
        joRes.Add(sCode);
    end;
    //
    Result  := joRes;

end;


exports
     //dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;

begin
end.

