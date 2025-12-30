library dwTButtonGroup__category;
(*
    一、功能
        用ButtonGroup来仿kfc的左侧分类

    二、配置
    1. TButtonGroup的HelpKeyword设置为category
    2. 每个Button对应一个分类项，
        caption为标题
        hint中的src为分类的图标

*)
uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     Vcl.ButtonGroup,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     StdCtrls, Windows;

function _GetInt(AHint:Variant;AName:String;ADefault:Integer):Integer;
begin
    Result  := ADefault;
    if AHint.Exists(AName) then begin
        Result  := AHint._(AName);
    end;
end;
function _GetStr(AHint:Variant;AName:String;ADefault:String):String;
begin
    Result  := ADefault;
    if AHint.Exists(AName) then begin
        Result  := AHint._(AName);
    end;
end;


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
    //
    joData    := _Json(AData);
    with TButtonGroup(ACtrl) do begin
        if joData.e = 'onsectionclick' then begin
            HelpContext := joData.v;
            if Assigned(OnButtonClicked) then begin
                OnButtonClicked(TButtonGroup(ACtrl),HelpContext);
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
    //
    iMode       : Integer;
    sHot        : String;
    iHotSize    : Integer;
    sActiveBk   : string;
    sActiveClr  : string;
    iActiveSize : Integer;
    iActiveBold : Integer;
    sNormalBk   : string;
    sNormalClr  : string;
    sRadius     : string;
    iMargin     : Integer;
    //
    sHotBorder  : string;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sHot        := _GetStr(joHint,'hot','rgb(13,95,171)');
    iHotSize    := _GetInt(joHint,'hotsize',3);
    sActiveBk   := _GetStr(joHint,'activebk','#fff');
    sActiveClr  := _GetStr(joHint,'activecolor','rgb(13,95,171)');
    iActiveSize := _GetInt(joHint,'activesize',THeaderControl(ACtrl).Font.Size);
    iActiveBold := _GetInt(joHint,'activebold',0);
    sNormalBk   := _GetStr(joHint,'normalbk','rgb(240,240,240)');
    sNormalClr  := _GetStr(joHint,'normalcolor','#000');
    sRadius     := _GetStr(joHint,'radius','0px');
    iMargin     := _GetInt(joHint,'margin',0);

    //
    sHotBorder  := '';
    sHotBorder  := 'border-left:solid '+IntToStr(iHotSize)+'px '+sHot+';';

    //
    sFull   := dwFullName(ACtrl);

    with TButtonGroup(ACtrl) do begin
        //外框
        sCode   := concat('<div',
                ' id="'+sFull+'"',
                dwGetDWAttr(joHint),
                dwVisible(TControl(ACtrl)),
                dwDisable(TControl(ACtrl)),
                ' :style="{',
                    'left:'+sFull+'__lef,',
                    'top:'+sFull+'__top,',
                    'width:'+sFull+'__wid,',
                    'height:'+sFull+'__hei',
                '}"',
                ' style="',
                    'position:absolute;',
                    'overflow:hidden;',
                    'background:'+sNormalBk+';',
                    dwGetDWStyle(joHint),
                '"',
                dwIIF(Assigned(OnMouseEnter),Format(_DWEVENT,['mouseenter.native',Name,'0','onenter',TForm(Owner).Handle]),''),
                dwIIF(Assigned(OnMouseLeave),Format(_DWEVENT,['mouseleave.native',Name,'0','onexit',TForm(Owner).Handle]),''),
                '>');
        //添加到返回值数据
        joRes.Add(sCode);

        //
        sCode   := concat('<div',
                ' v-for="(item,index) in '+sFull+'__itm"',
                ' :style="{',
                    'top:item.t,',
                    //'right:item.r,',
                    'color:item.c,',
                    '''font-size'':item.fs,',
                    '''font-weight'':item.fb,',
                    '''margin-left'':item.mg,',
                    '''margin-right'':item.mg,',
                    '''border-width'':item.bw,',
                    '''border-radius'':item.br,',
                    'background:item.bg',
                '}"',
                ' style="',
                    'position:absolute;',
                    'padding-left:'+IntToStr(BorderWidth)+'px;',
                    'padding-right:'+IntToStr(BorderWidth*2)+'px;',
                    'height:'+IntToStr(ButtonHeight)+'px;',
                    //'width:'+IntToStr(Width-3*BorderWidth)+'px;',
                    'width:100%;',
                    'display:flex;',
                    'justify-content:center;',
                    'align-items:center;',
                    'text-align:center;',
                    'cursor:pointer',   //光标是手指
                    sHotBorder,
                '"',
                ' @click="'+sFull+'__onsectionclick(index)"',
                '>',
                '<i :class="item.ic" :style="{width:item.iw}"></i>',
                '{{item.cp}}',
                '</div>');
        //添加到返回值数据
        joRes.Add(sCode);

    end;

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):string;StdCall;
var
     joRes     : Variant;
begin
     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     joRes.Add('</div>');
     //
     Result    := (joRes);
end;

function _dwGeneral(ACtrl:TComponent;AMode:string):string;StdCall;
var
    iSect       : Integer;
    //
    sCode       : string;
    sFull       : string;
    sMiddle     : string;
    sTail       : string;
    sIcon       : string;
    sIconWidth  : string;

    //
    joRes       : variant;
    joHint      : Variant;
    oButton     : TGrpButtonItem;
    //
    iMode       : Integer;
    sHot        : String;
    iHotSize    : Integer;
    sActiveBk   : string;
    sActiveClr  : string;
    iActiveSize : Integer;
    iActiveBold : Integer;
    sNormalBk   : string;
    sNormalClr  : string;
    sRadius     : string;
    iMargin     : Integer;
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
    sHot        := _GetStr(joHint,'hot','rgb(13,95,171)');
    iHotSize    := _GetInt(joHint,'hotsize',3);
    sActiveBk   := _GetStr(joHint,'activebk','#fff');
    sActiveClr  := _GetStr(joHint,'activecolor','rgb(13,95,171)');
    iActiveSize := _GetInt(joHint,'activesize',TButtonGroup(ACtrl).Font.Size);
    iActiveBold := _GetInt(joHint,'activebold',0);
    sNormalBk   := _GetStr(joHint,'normalbk','rgb(240,240,240)');
    sNormalClr  := _GetStr(joHint,'normalcolor','#000');
    sRadius     := _GetStr(joHint,'radius','0px');
    iMargin     := _GetInt(joHint,'margin',0);

    //
    with TButtonGroup(ACtrl) do begin
        //基本LTWH
        joRes.Add(sFull+'__lef'+sMiddle+'"'+IntToStr(Left)+'px"'+sTail);
        joRes.Add(sFull+'__top'+sMiddle+'"'+IntToStr(Top)+'px"'+sTail);
        joRes.Add(sFull+'__wid'+sMiddle+'"'+IntToStr(Width)+'px"'+sTail);
        joRes.Add(sFull+'__hei'+sMiddle+'"'+IntToStr(Height)+'px"'+sTail);

        //可见性和禁用
        joRes.Add(sFull+'__vis'+sMiddle+''+dwIIF(Visible,'true'+sTail,'false'+sTail));
        joRes.Add(sFull+'__dis'+sMiddle+''+dwIIF(Enabled,'false'+sTail,'true'+sTail));

        //
        sCode   := sFull + '__itm'+sMiddle+'[';
        for iSect := 0 to Items.Count-1 do begin
            oButton    := Items[iSect];

            //
            sIcon       := '';
            sIconWidth  := '0px';
            if (oButton.ImageIndex>0) and (oButton.ImageIndex<280) then begin
                sIcon   := dwIcons[oButton.ImageIndex];
                sIconWidth  := IntToStr(Font.Size*2)+'px';
            end;

            //
            sCode   := Concat(sCode,
                    '{',
                        //left
                        't:"'+IntToStr(iSect*ButtonHeight)+'px",',
                        //right
                        //'r:"'+dwIIF(iSect=Items.Count-1,'0",',IntToStr(100-Round((iSect+1)*100/Items.Count))+'%",'),
                        //color
                        'c:"'+dwIIF(iSect=HelpContext,sActiveClr,sNormalClr)+'",',
                        //font bold
                        'fb:"'+dwIIF( (iSect=HelpContext)and(iActiveBold=1),'bold','normal')+'",',
                        //font size
                        'fs:"'+dwIIF(iSect=HelpContext,IntToStr(iActiveSize+4),IntToStr(Font.Size+4))+'px",',
                        //background
                        'bg:"'+dwIIF(iSect=HelpContext,sActiveBk,sNormalBk)+'",',
                        //border width (hot track)
                        'bw:"'+dwIIF(iSect=HelpContext,IntToStr(iHotSize),'0')+'px",',
                        //border radius
                        'br:"'+sRadius+'",',
                        //margin
                        'mg:"'+IntToStr(iMargin)+'px",',
                        //icon 图标
                        'ic:"'+sIcon+'",',
                        //icon width
                        'iw:"'+sIconWidth+'",',
                        //text
                        'cp:"'+oButton.Caption+'"',
                    '},');

        end;
        if items.Count>0 then begin
            Delete(sCode,Length(sCode),1);
        end;
        sCode   := sCode +']'+sTail;
        joRes.Add(sCode);
    end;
    //
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
    with TButtonGroup(ACtrl) do begin
        sCode   := concat(sFull + '__onsectionclick(val){',
                'this.dwevent(null,"'+sFull+'",val,"onsectionclick",'+IntToStr(TForm(Owner).Handle)+');',
                '},');
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
 
