library dwTMainMenu;

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
     StdCtrls;

//======辅助函数====================================================================================
//取得MenuItem
function dwGetMenuItem(AMenu:TMainMenu;AValue:string):TMenuItem;
var
    iIDs      : array of Integer;
    I         : Integer;
begin
    //将AValue 转换为int数组
    SetLength(iIDs,0);
    while Pos('-',AValue)>0 do begin
        SetLength(iIDs,Length(iIDs)+1);
        iIDs[High(iIDs)]    := StrToIntDef(Copy(AValue,1,Pos('-',AValue)-1),0);
        //
        Delete(AValue,1,Pos('-',AValue));
    end;
    SetLength(iIDs,Length(iIDs)+1);
    iIDs[High(iIDs)]    := StrToIntDef(AValue,0);

    //
    Result    := AMenu.Items[iIDs[0]];

    //
    for i := 1 to High(iIDs) do begin
        Result    := Result.Items[iIDs[i]];
    end;
end;

//控制菜单显隐
procedure SetItemVisible(APrefix:String;AParent:TMenuItem;AParentVisible:Boolean;var ARes:Variant);
var
    I       : Integer;
    oItem   : TMenuItem;
begin
    for I := 0 to AParent.Count-1 do begin
        oItem := AParent.Items[I];
        ARes.Add(LowerCase(APrefix + oItem.Name)+'__vis:'+dwIIF(AParentVisible AND oItem.Visible,'true,','false,'));
        ARes.Add(LowerCase(APrefix + oItem.Name)+'__dis:'+dwIIF(not oItem.Enabled,'true,','false,'));
        //
        SetItemVisible(APrefix,oItem,AParentVisible AND oItem.Visible,ARes);
    end;
end;

procedure GetMainMenuVisible(AMenu:TMainMenu;var ARes:Variant);
var
    sPrefix : string;
    I       : Integer;
    oItem   : TMenuItem;
begin
    //
    sPrefix := dwPrefix(AMenu);

    //
    for I := 0 to AMenu.Items.Count-1 do begin
        oItem := AMenu.Items[I];
        ARes.Add(Lowercase(sPrefix + oItem.Name)+'__vis:'+dwIIF(oItem.Visible,'true,','false,'));
        ARes.Add(LowerCase(sPrefix + oItem.Name)+'__dis:'+dwIIF(not oItem.Enabled,'true,','false,'));
        //
        SetItemVisible(sPrefix,oItem,oItem.Visible,ARes);
    end;
end;

procedure GetMainMenuActionVisible(AMenu:TMainMenu;var ARes:Variant);
var
    sPrefix : string;
    I       : Integer;
    oItem   : TMenuItem;
begin
    //
    sPrefix := dwPrefix(AMenu);

    //
    for I := 0 to AMenu.Items.Count-1 do begin
        oItem := AMenu.Items[I];
        ARes.Add('this.'+LowerCase(sPrefix + oItem.Name)+'__vis='+dwIIF(oItem.Visible,'true;','false;'));
        ARes.Add('this.'+LowerCase(sPrefix + oItem.Name)+'__dis='+dwIIF(not oItem.Enabled,'true;','false;'));
        //
        SetItemVisible(sPrefix,oItem,oItem.Visible,ARes);
    end;
end;

function GetMenuItemIndex(AItem:TMenuItem):String;
begin
    Result  := IntToStr(AItem.MenuIndex);
    while (AItem.Parent <> nil) and (AItem.Parent.MenuIndex >=0 ) do begin
        AItem   := AItem.Parent;
        Result  := IntToStr(AItem.MenuIndex)+'-'+Result;
    end;
end;

function _GetStyle(AItem:TMenuItem):string;
var
    joHint  : Variant;
begin
    Result  := '';
    //
    joHint  := _json(AItem.Hint);
    if joHint <> unassigned then begin
        if joHint.Exists('indent') then begin
            Result  := ' style="margin-left:'+IntToStr(joHint.indent)+'px;"';
        end;
    end;
end;


function _CreateItems (AItem:TMenuItem;APath:String; var ACode:String):Integer;
var
    ii        : Integer;
    ii1       : Integer;
    miItem    : TMenuItem;
    ssPath    : String;
begin
    //注释： index 从0开始，每一层用-隔开，如1-3-2

    //
    for ii := 0 to AItem.Count-1 do begin
        miItem   := AItem.items[ii];

        //
        if miItem.Count = 0 then begin
            //无子项的情况

            if (miItem.ImageIndex>0)and(miItem.ImageIndex<=High(dwIcons)) then begin
                //有图标
                ACode   := ACode
                        + '                    <el-menu-item'
                            +' index="'+APath+'-'+IntToStr(ii)+'"'
                            +dwVisible(TControl(miItem))
                            +dwDisable(TControl(miItem))
                            +' style="'
                                +dwGetDWStyle(_json(miItem.Hint))
                            +'"' //style 封闭
                        +'>'
                        +'<i class="'+dwIcons[miItem.ImageIndex]+'"></i>'
                        +'<span slot="title">'+miItem.caption+'</span>'
                        +'</el-menu-item>'#13;
            end else begin
                //无图标
                ACode   := ACode
                        + '<el-menu-item'
                            +' index="'+APath+'-'+IntToStr(ii)+'"'
                            +dwVisible(TControl(miItem))
                            +dwDisable(TControl(miItem))
                            +' style="'
                                +dwGetDWStyle(_json(miItem.Hint))
                            +'"' //style 封闭
                        +'>'
                        +miItem.caption
                        +'</el-menu-item>'#13;
            end;
        end else begin
            //有子项的情况

            //
            ACode   := ACode
                    +'<el-submenu'
                        +' index="'+APath+'-'+IntToStr(ii)+'"'
                        +dwVisible(TControl(miItem))
                        +dwDisable(TControl(miItem))

                        +' style="'
                            +dwGetDWStyle(_json(miItem.Hint))
                        +'"' //style 封闭
                    +'>'
                    +'<template'
                        +' slot="title"'
                    +'>'#13;

            //图标
            if (miItem.ImageIndex>0)and(miItem.ImageIndex<=High(dwIcons)) then begin
	            ACode     := ACode + '<i class="'+dwIcons[miItem.ImageIndex]+'"></i>';
            end;

            //菜单标题
            ACode     := ACode + '<span>'+miItem.caption+'</span></template>'#13;

            //路径
            ssPath    := APath+'-'+IntToStr(ii);

            //递归生成子项
            _CreateItems(miItem,ssPath,ACode);

            //增加尾部字符
            ACode     := ACode + '</el-submenu>'#13;
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
    joData      : Variant;
    joHint      : Variant;
    oMenuItem   : TMenuItem;
    sHint       : string;
begin
    joData    := _json(AData);

    //先找到对应的菜单项
    oMenuItem := dwGetMenuItem(TMainMenu(ACtrl),joData.v);

    //
    if oMenuItem = nil then begin
    	Exit;
    end;

    //执行事件
    if Assigned(oMenuItem.OnClick) then begin
        //
    	oMenuItem.OnClick(oMenuItem);
    end;

    //将当前菜单位置保存起来，备用
    if TMainMenu(ACtrl).Items.Count>0 then begin
        sHint     := TMainMenu(ACtrl).Items[0].Hint;
        if dwStrIsJson(sHint) then begin
            joHint  := _Json(sHint);
        end else begin
            joHint  := _json('{}');
        end;
        joHint.activeindex  := GetMenuItemIndex(oMenuItem);  //从0开始，每一层用-隔开，如1-3-2
        TMainMenu(ACtrl).Items[0].Hint  := joHint;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):string;StdCall;
var
    sCode     : string;
    joHint    : Variant;
    joRes     : Variant;
    iItem     : Integer;
    oItem     : TMenuItem;
    sHint     : String;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    sHint     := '{}';
    if TMainMenu(ACtrl).Items.Count>0 then begin
        sHint     := TMainMenu(ACtrl).Items[0].Hint;
    end;

    //
    joHint  := _Json(sHint);
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;

    with TMainMenu(ACtrl) do begin
        //关闭"自动热键"
        AutoHotkeys := maManual;

        //外框
        sCode   := '<div'
                +' :style=''{'
                    +'backgroundColor:'+dwFullName(Actrl)+'__col,'     //背景色
                    +'left:'+dwFullName(Actrl)+'__lef,'
                    +'top:'+dwFullName(Actrl)+'__top,'
                    +'width:'+dwFullName(Actrl)+'__wid,'
                    +'height:'+dwFullName(Actrl)+'__hei'
                +'}'''
                +' style="position:absolute;'
                +'"' //style 封闭
                +'>';
        joRes.Add(sCode);

        //滚动框scrollbar
        sCode   := '    <el-scrollbar'
                //+' ref="'+dwFullName(Actrl)+'"'
                +' style="height:100%;width:100%"'
                //+dwIIF(True,Format(_DWEVENT,['scroll',Name,'0','onscroll',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);

        //总menu项
        sCode	:= '        <el-menu'
                +' id="'+dwFullName(Actrl)+'"'
                +' :default-active="'+dwFullName(Actrl)+'__act"'     //默认选中状态
                //默认打开的菜单 :default-openeds
                +' :default-openeds="'+dwFullName(Actrl)+'__opd"'    //默认打开的菜单项 openeds: ['1','2','3']
                +' class="el-menu-demo"'
                +dwIIF(ParentBiDiMode=False,'',' mode="horizontal"')    //水平或垂直

                //+' background-color="#545c64"'  背景色
                //+dwGetHintValue(joHint,'background-color','background-color',' background-color="#545c64"')
                +' :background-color="'+dwFullName(Actrl)+'__col"'     //背景色

                //+' text-color="#fff"'           //文本色
                +dwGetHintValue(joHint,'text-color','text-color',' text-color="#fff"')

                //+' active-text-color="#ffd04b"' //激活状态文本色
                +dwGetHintValue(joHint,'active-text-color','active-text-color',' active-text-color="#ffd04b"')

                //:collapse="isCollapse"           //折叠
                +' :collapse="'+dwFullName(Actrl)+'__cps"'
                +' :collapse-transition="false"'

                //+dwVisible(ACtrl)
                //+dwDisable(ACtrl)
                +dwGetDWAttr(joHint)
                +' style="left:0;top:0;width:99%;height:100%;'  //
                //+dwLTWHComp(ACtrl)
                +dwIIF(ParentBiDiMode=False,'line-height:30px;','line-height:'+IntToStr((Tag mod 10000)-22)+'px;')
                +dwGetDWStyle(joHint)
                +'"' //style 封闭

                //单击事件
                //+Format(_DWEVENT,['select',Name,'val','onclick',TForm(Owner).Handle])
                +Format(_DWEVENTPlus,['select',dwIIF(joHint.Exists('dwloading'),'dwloading=true',''),Name,'val','onclick',TForm(Owner).Handle])
                //+Format(_DWEVENTPlus,['click',Name,'0','onclick',TForm(Owner).Handle])
                +'>';
        //添加
        joRes.Add(sCode);

        //
        sCode      := '';

        for iItem := 0 to Items.Count-1 do begin
            oItem     := Items[iItem];
            if oItem.Count = 0 then begin //无子菜单

                //根据有无图标判断
                if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                    joRes.Add('            <el-menu-item'
                                +dwVisible(TControl(oItem))
                                +dwDisable(TControl(oItem))
                                +' index="'+IntToStr(iItem)+'"'
                                +' style="height:50px;line-height:35px"'
                            +_GetStyle(oItem)
                            +'>'
                            +'<i class="'+dwIcons[oItem.ImageIndex]+'"></i>'
                            +'<span slot="title">'+oItem.caption+'</span>'
                            +'</el-menu-item>');
                end else begin
                    joRes.Add('            <el-menu-item'
                                +dwVisible(TControl(oItem))
                                +dwDisable(TControl(oItem))
                                +' index="'+IntToStr(iItem)+'"'
                                +' style="height:50px;line-height:35px"'
                            +_GetStyle(oItem)
                            +'>'
                            +oItem.Caption
                            +'</el-menu-item>');
                end;

            end else begin
                joRes.Add('            <el-submenu'
                        +dwVisible(TControl(oItem))
                        +dwDisable(TControl(oItem))
                        +' index="'+IntToStr(iItem)+'"'
                        +_GetStyle(oItem)
                        +'>'
                        +'<template slot="title">');
                if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                    joRes.Add('            <i class="'+dwIcons[oItem.ImageIndex]+'"></i>');
                end;
                joRes.Add('            <span>'+oItem.Caption+'</span></template>');
                //递归生成菜单项
                _CreateItems(oItem,IntToStr(iItem),sCode);
                //
                joRes.Add(sCode);
                sCode     := '';
                //
                joRes.Add('            </el-submenu>');
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

//取得Data
function dwGetData(ACtrl:TComponent):string;StdCall;
var
    sActive : String;
    sHint   : string;
    sCode   : string;
    sIds    : TStringDynArray;
    sCur    : String;
    sOpens  : string;
    joRes   : Variant;
    joHint  : Variant;
    iItem   : Integer;
    iTmp    : Integer;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //
    with TMainMenu(ACtrl) do begin

        //取得HINT对象JSON
        sHint     := '{}';
        if TMainMenu(ACtrl).Items.Count>0 then begin
            sHint     := TMainMenu(ACtrl).Items[0].Hint;
        end;
        if dwStrIsJson(sHint) then begin
            joHint  := _Json(sHint);
        end else begin
            joHint  := _json('{}');
        end;


        //折叠状态
        joRes.Add(dwFullName(Actrl)+'__cps:'+dwIIF(AutoMerge,'true','false')+',');

        //背景色
        if joHint.Exists('background-color') then begin
            joRes.Add(dwFullName(Actrl)+'__col:"'+String(joHint._('background-color'))+'",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__col:"#545c64",');
        end;

        //设置位置大小LTWH
        if Tag < 10000 then begin
            //如果没有设置当前菜单的LTWH,则为默认值
            joRes.Add(dwFullName(Actrl)+'__lef:"0px",');
            joRes.Add(dwFullName(Actrl)+'__top:"0px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"600px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"38px",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__lef:"'+IntToStr(DesignInfo div 10000)+'px",');
            joRes.Add(dwFullName(Actrl)+'__top:"'+IntToStr(DesignInfo mod 10000)+'px",');
            joRes.Add(dwFullName(Actrl)+'__wid:"'+IntToStr(Tag div 10000)+'px",');
            joRes.Add(dwFullName(Actrl)+'__hei:"'+IntToStr(Tag mod 10000)+'px",');
        end;



        //当前激活菜单位置(保存在Items[0].Hint)
        sOpens  := '';
        if Items.Count>0 then begin
            if joHint.Exists('activeindex') then begin
                sActive := String(joHint.activeindex);
            end;
            if sActive<>'' then begin
                joRes.Add(dwFullName(Actrl)+'__act:"'+sActive+'",');
                //默认打开的菜单
                if Pos('-',sActive)>0 then begin
                    sIDs    := SplitString(sActive,'-');
                    for iItem := 0 to High(sIDs) do begin
                        sCur    := sIDs[0];
                        for iTmp := 1 to iItem do begin
                            sCur    := sCur + '-' + sIDs[iTmp];
                        end;
                        sOpens  := sOpens+''''+sCur+''',';
                    end;
                    Delete(sOpens,Length(sOpens),1);
                end;
            end else begin
                joRes.Add(dwFullName(Actrl)+'__act:"0",');
            end;
        end else begin
            joRes.Add(dwFullName(Actrl)+'__act:"0",');
        end;
        //
        joRes.Add(dwFullName(Actrl)+'__opd:['+sOpens+'],');

    end;

    //得到可视性和可用性
    GetMainMenuVisible(TMainMenu(ACtrl),joRes);

    //
    Result    := VariantSaveJSON(joRes);
end;

function dwGetAction(ACtrl:TComponent):string;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sHint   : string;
    sActive : string;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //
    with TMainMenu(ACtrl) do begin
        //取得HINT对象JSON
        sHint     := '{}';
        if TMainMenu(ACtrl).Items.Count>0 then begin
            sHint     := TMainMenu(ACtrl).Items[0].Hint;
        end;

        joHint  := _Json(sHint);
        if joHint = unassigned then begin
            joHint  := _json('{}');
        end;

        joRes.Add('this.'+dwFullName(Actrl)+'__lef="'+IntToStr(DesignInfo div 10000)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__top="'+IntToStr(DesignInfo mod 10000)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__wid="'+IntToStr(Tag div 10000)+'px";');
        joRes.Add('this.'+dwFullName(Actrl)+'__hei="'+IntToStr(Tag mod 10000)+'px";');

        //折叠状态
        joRes.Add('this.'+dwFullName(Actrl)+'__cps='+dwIIF(AutoMerge,'true','false')+';');

        //背景色
        if joHint.Exists('backgroundcolor') then begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="'+String(joHint.backgroundcolor)+'";');
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__col="#545c64";');
        end;

        //当前激活菜单位置(保存在Items[0].Hint)
        if Items.Count>0 then begin
            if joHint.Exists('activeindex') then begin
                sActive := String(joHint.activeindex);
            end;
            if sActive<>'' then begin
                joRes.Add('this.'+dwFullName(Actrl)+'__act="'+sActive+'";');
            end else begin
                joRes.Add('this.'+dwFullName(Actrl)+'__act="0";');
            end;
        end else begin
            joRes.Add('this.'+dwFullName(Actrl)+'__act="0";');
        end;
    end;

    //得到可视性和可用性
    GetMainMenuActionVisible(TMainMenu(ACtrl),joRes);

    //
    Result    := (joRes);
end;


exports
    //dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;
     
begin
end.
 
