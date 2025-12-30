library dwTButtonGroup__menu;

uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     StrUtils,
     Types, Winapi.Windows, System.Character,
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls, Menus,
     Vcl.ButtonGroup,
     StdCtrls;

//======辅助函数====================================================================================

function _GetEnabled(AItem : TGrpButtonItem):string;
var
    joHint  : Variant;
begin
    Result  := '';
    joHint  := _json(AItem.Hint);
    //
    if joHint <> unassigned then begin
        if joHint.Exists('enabled') then begin
            if joHint.enabled = 0 then begin
                Result  := ' disabled'
            end;
        end;
    end;
end;


//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):string;stdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sColor  : String;
    sFull   : string;
begin
    sFull   := dwFullName(ACtrl);
    //
    joRes   := _json('[]');
    //
    joHint  := dwGetHintJson(TControl(ACtrl));
    //active背景色
    joRes.Add('<style id="'+sFull+'__bk">'+
            '.el-menu-item.is-active {'+
                'background-color: '+dwGetStr(joHint,'activebkcolor','#006EFF')+' !important;'+
            '}'+
            '</style>');
    //hove颜色
    sColor  := dwGetStr(joHint,'hovercolor','#273446');
    sColor  := '<style id="'+sFull+'__hover">'+
                '.el-submenu__title:hover{'+
                    'background-color: '+sColor+' !important;'+
                '}'+
                ' .el-menu-item:hover { '+
                    'background-color: '+sColor+' !important;'+
                '}'+
                '</style>';
    joRes.Add(sColor);

	Result    := joRes;
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):string;StdCall;
var
    joData      : Variant;
    joHint      : Variant;
    sHint       : string;
begin
    joData    := _json(AData);


    //执行事件
    if Assigned(TButtonGroup(ACtrl).OnButtonClicked) then begin
        //
    	TButtonGroup(ACtrl).OnButtonClicked(TButtonGroup(ACtrl),joData.v);
    end;

    //
    TButtonGroup(ACtrl).HelpContext := joData.v;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode       : string;
    sFull       : string;
    sCaption    : String;
    sNextCapt   : String;
    sViewCapt   : string;
    //
    joHint      : Variant;
    joRes       : Variant;
    //
    iItem       : Integer;
    oItem       : TGrpButtonItem;
begin
    //生成返回值数组
    joRes   := _Json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint  := _Json(TButtonGroup(ACtrl).Hint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    with TButtonGroup(ACtrl) do begin

        //外框
        sCode   := '<div'
                +' :style=''{'
                    +'backgroundColor:'+sFull+'__bkc,'     //背景色
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei'
                +'}'''
                +' style="position:absolute;'
                +'"' //style 封闭
                +'>';
        joRes.Add(sCode);

        //滚动框scrollbar
        sCode   := '    <el-scrollbar'
                //+' ref="'+sFull+'"'
                +' style="height:100%;width:100%"'
                +'>';
        joRes.Add(sCode);

        //总menu项
        sCode	:= concat('<el-menu',
                ' id="'+sFull+'"',
                ' :default-active="'+sFull+'__act"',        //默认选中状态
                //' :default-openeds="'+sFull+'__opd"',       //默认打开的菜单项 openeds: ['1','2','3']
                ' class="el-menu-demo"',
                //dwIIF(ParentDoubleBuffered,'',' mode="horizontal"'),   //水平或垂直
                ' :background-color="'+sFull+'__bkc"',      //背景色,bkcolor
                ' :text-color="'+sFull+'__txc"',            //正常文本色,textcolor
                ' :active-text-color="'+sFull+'__atc"',     //激活状态文本色,activetextcolor
                ' :collapse="'+sFull+'__cps"',              //折叠
                ' :collapse-transition="false"',
                dwGetDWAttr(joHint),
                ' style="',
                    'left:0;',
                    'top:0;',
                    'width:99%;',
                    'height:100%;',
                    'line-height:'+IntToStr(ButtonHeight-20)+'px;',
                    dwGetDWStyle(joHint),
                '"', //style 封闭

                //单击事件
                Format(_DWEVENTPlus,['select',dwIIF(joHint.Exists('dwloading'),'dwloading=true',''),Name,'val','onclick',TForm(Owner).Handle]),
                //+Format(_DWEVENTPlus,['click',Name,'0','onclick',TForm(Owner).Handle])
                '>');
        //添加
        joRes.Add(sCode);

        //
        sCode      := '';

        for iItem := 0 to Items.Count-1 do begin
            oItem       := Items[iItem];
            //取到当前标题
            sCaption    := oItem.Caption;
            //防止空标题
            if sCaption = '' then begin
                sCaption := '-';
            end;
            //取下一项标题
            if iItem < Items.Count-1 then begin
                sNextCapt   := Items[iItem+1].Caption;
            end else begin
                sNextCapt   := '[!null!]';
            end;

            if (sCaption[1] <> '+') and (sNextCapt[1] = '+') then begin
                joRes.Add('<el-submenu'
                        //+dwVisible(TControl(oItem))
                        //+dwDisable(TControl(oItem))
                        +' index="'+IntToStr(iItem)+'"'
                        +' style="'
                            //+'height:'+IntToStr(ButtonHeight)+'px;'
                            //+'line-height:'+IntToStr(ButtonHeight)+'px;'
                            //+'padding:0 0 0 0px!important;'
                            //+'margins:0 0 0 10px!important;'
                        +'"'
                        //+_GetStyle(oItem)
                        +'>'
                        +'<template slot="title">');
                if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                    joRes.Add('<i class="'+dwIcons[oItem.ImageIndex]+'"></i>');
                end;
                joRes.Add('<span>'+oItem.Caption+'</span></template>');

            end else begin
                //删除标题前面的+
                sViewCapt   := sCaption;
                if sViewCapt[1]='+' then begin
                    Delete(sViewCapt,1,1);
                end;

                //根据有无图标判断
                if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                    joRes.Add(' <el-menu-item'
                                //+dwVisible(TControl(oItem))
                                //+dwDisable(TControl(oItem))
                                +' index="'+IntToStr(iItem)+'"'
                                +' style="'
                                    +'height:'+IntToStr(ButtonHeight)+'px;'
                                    +'line-height:'+IntToStr(dwIIFi(sCaption[1] = '+',ButtonHeight,ButtonHeight-20))+'px;'
                                    //+'padding:0 0 0 20px!important;'
                                +'"'
                                +_GetEnabled(oItem)
                            //+_GetStyle(oItem)
                            +'>'
                            +'<i class="'+dwIcons[oItem.ImageIndex]+'"></i>'
                            +'<span slot="title">'+sViewCapt+'</span>'
                            +'</el-menu-item>');
                end else begin
                    joRes.Add('<el-menu-item'
                                //+dwVisible(TControl(oItem))
                                //+dwDisable(TControl(oItem))
                                +' index="'+IntToStr(iItem)+'"'
                                +' style="'
                                    +'height:'+IntToStr(ButtonHeight)+'px;'
                                    +'line-height:'+IntToStr(dwIIFi(sCaption[1] = '+',ButtonHeight,ButtonHeight-20))+'px;'
                                    //+'padding:0 0 0 20px!important;'
                                +'"'
                                +_GetEnabled(oItem)
                            //+_GetStyle(oItem)
                            +'>'
                            +sViewCapt
                            +'</el-menu-item>');
                end;
                //
                if (sCaption[1] = '+') and (sNextCapt[1] <> '+') then begin
                    joRes.Add('</el-submenu>');
                end;
            end;
        end;
        //添加
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
    //菜单
    joRes.Add('        </el-menu>');
    //scrollbar
    joRes.Add('    </el-scrollbar>');
    //最外框
    joRes.Add('</div>');
    //
    Result    := (joRes);
end;

function _dwGeneral(ACtrl:TComponent;AMode:String):Variant;
var
    iRow, iCol  : Integer;
    iItem       : Integer;
    iSum        : Integer;
    iSumW       : Integer;      //所有字段的宽度之和，用于更新倒1/2字段viewwidth
    iSumCol     : Integer;
    iSumCount   : Integer;      //
    iTitleCount : Integer;
    iCount      : Integer;
    iTotal      : Integer;
    iMax        : Integer;
    iRecCount   : Integer;
    iHeadH      : Integer;
    iRowH       : Integer;
    iL,iT,iW,iH : Integer;
    iLevel      : Integer;
    iStart      : Integer;
    iEnd        : Integer;
    iTopH       : Integer;
    iPageH      : Integer;
    iDch        : Integer;
    //
    sCode       : string;
    sCols       : string;
    sHover      : string;
    sRecord     : string;
    sFull       : string;
    sMiddle     : string;
    sTail       : string;
    sTopBack    : string;
    //解析SQL
    sField      : string;
    sTable      : string;
    sWhere      : String;
    sOrder      : string;
    sSQL        : string; //SQL
    iPageSize   : Integer;
    //
    fValues     : array of Double;
    //
    joHint      : Variant;
    joRes       : Variant;
begin
    //默认返回值
    joRes := _Json('[]');

    //取得HINT对象joHint,并预处理
    joHint := dwGetHintJson(TControl(ACtrl));

    //区分是否GetData，以确定使用 ;/,
    if LowerCase(AMode) = 'data' then begin
        sFull   := dwFullName(Actrl);
        sMiddle := ':';
        sTail   := ',';
    end else begin
        sFull   := 'this.'+dwFullName(Actrl);
        sMiddle := '=';
        sTail   := ';';
    end;

    //
    with TButtonGroup(ACtrl) do begin
        //基本LTWH/VD/recordcount
        joRes.Add(sFull + '__lef'+sMiddle+'"' + IntToStr(Left) + 'px"'+sTail);
        joRes.Add(sFull + '__top'+sMiddle+'"' + IntToStr(Top) + 'px"'+sTail);
        joRes.Add(sFull + '__wid'+sMiddle+'"' + IntToStr(Width) + 'px"'+sTail);
        joRes.Add(sFull + '__hei'+sMiddle+'"' + IntToStr(Height) + 'px"'+sTail);

        //visible/enabled
        joRes.Add(sFull + '__vis'+sMiddle+'' + dwIIF(Visible, 'true', 'false')+sTail);
        joRes.Add(sFull + '__dis'+sMiddle+'' + dwIIF(Enabled, 'false', 'true')+sTail);
        //总背景色
        joRes.Add(sFull + '__bkc'+sMiddle+'"' + dwGetStr(joHint,'bkcolor','rgb(49,65,87)')+'"'+sTail);
        //正常文本色
        joRes.Add(sFull + '__txc'+sMiddle+'"' + dwColor(Font.Color)+'"'+sTail);
        //激活文本色
        joRes.Add(sFull + '__atc'+sMiddle+'"' + dwGetStr(joHint,'activetextcolor','#ffd04b')+'"'+sTail);
        //默认激活菜单
        joRes.Add(sFull + '__act'+sMiddle + '"' + IntToStr(dwGetInt(joHint,'activeindex',HelpContext))+'"' + sTail);
        //默认打开菜单
        joRes.Add(sFull + '__opd'+sMiddle + '[' + ''+']' + sTail);
        //折叠状态
        joRes.Add(sFull + '__cps'+sMiddle + dwIIF(Width<=60,'true','false') + sTail);

    end;

    //
    Result  := joRes;
end;

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    joRes   : Variant;
    joHint  : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    joRes   := _dwGeneral(ACtrl,'data');
    Result := (joRes);

    //
    Result    := joRes;
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    sCode   : string;
    joRes   : Variant;
    joHint  : Variant;
begin
    //生成返回值数组
    joRes   := _Json('[]');
    joRes   := _dwGeneral(ACtrl,'action');

    //
    Result  := joRes;
end;


exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;
     
begin
end.
 
