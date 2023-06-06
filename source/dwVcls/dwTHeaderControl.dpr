library dwTHeaderControl;

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
    with THeaderControl(ACtrl) do begin
        if joData.e = 'onsectionclick' then begin
            HelpContext := joData.v;
            if Assigned(OnSectionClick) then begin
                OnSectionClick(THeaderControl(ACtrl),Sections[HelpContext]);
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
    iMode       := _GetInt(joHint,'mode',0);
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
    case iMode of
        0 : begin
            sHotBorder  := 'border-top:solid '+IntToStr(iHotSize)+'px '+sHot+';'
        end;
        1 : begin
            sHotBorder  := 'border-bottom:solid '+IntToStr(iHotSize)+'px '+sHot+';'
        end;
    end;

    //
    sFull   := dwFullName(ACtrl);

    with THeaderControl(ACtrl) do begin
        //外框
        sCode   := concat('<div',
                ' id="'+sFull+'"',
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
                    'left:item.l,',
                    'right:item.r,',
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
                    'height:100%;',
                    'display:flex;',
                    'justify-content:center;',
                    'align-items:center;',
                    'text-align:center;',
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
    oSection    : THeaderSection;
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
    iMode       := _GetInt(joHint,'mode',0);
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
    with THeaderControl(ACtrl) do begin
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
        for iSect := 0 to Sections.Count-1 do begin
            oSection    := Sections[iSect];

            //
            sIcon       := '';
            sIconWidth  := '0px';
            if (oSection.ImageIndex>-1) and (oSection.ImageIndex<280) then begin
                sIcon   := dwIcons[oSection.ImageIndex];
                sIconWidth  := '30px';
            end;

            //
            sCode   := Concat(sCode,
                    '{',
                        //left
                        'l:"'+IntToStr(Round(iSect*100/Sections.Count))+'%",',
                        //right
                        'r:"'+dwIIF(iSect=Sections.Count-1,'0",',IntToStr(100-Round((iSect+1)*100/Sections.Count))+'%",'),
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
                        'cp:"'+oSection.Text+'"',
                    '},');

        end;
        if Sections.Count>0 then begin
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
    with THeaderControl(ACtrl) do begin
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
 
