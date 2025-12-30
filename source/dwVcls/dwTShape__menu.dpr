library dwTShape__menu;

(*
说明：
    用Shape占位， 配合TMainMenu完成功能
使用方法：
    1 放一个TMainMenu,比如名称为MainMenu1
    2 放一个Tshape,设置其HelpKeyword = 'menu',设置hint  为
    {"menu":"MainMenu1"}

*)


uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,

     //
     SysUtils,
     Buttons,
     ExtCtrls,
     Classes,
     Dialogs,
     StdCtrls,
     Windows,
     Menus,
     StrUtils,
     Types,
     Graphics,
     System.Character,
     System.UITypes,
     Variants,
     Controls,
     Forms;

function _GetMainMenu(ACtrl:TComponent):TMainMenu;
var
    //
    joHint  : Variant;
    oForm   : TForm;
    sMenu   : String;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取默认menu
    if joHint.Exists('menu') then begin
        sMenu   := joHint.menu;
    end else begin
        sMenu   := 'MainMenu1';
    end;

    oForm   := TForm(ACtrl.Owner);
    Result  := TMainMenu(oForm.FindComponent(sMenu));

end;
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

//控制菜单显隐 （dwGetData 中使用）
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

//控制菜单显隐 （dwGetAction 中使用）
procedure SetItemActionVisible(APrefix:String;AParent:TMenuItem;AParentVisible:Boolean;var ARes:Variant);
var
    I       : Integer;
    oItem   : TMenuItem;
begin
    for I := 0 to AParent.Count-1 do begin
        oItem := AParent.Items[I];
        ARes.Add('this.'+LowerCase(APrefix + oItem.Name)+'__vis='+dwIIF(AParentVisible AND oItem.Visible,'true;','false;'));
        ARes.Add('this.'+LowerCase(APrefix + oItem.Name)+'__dis='+dwIIF(not oItem.Enabled,'true;','false;'));
        //
        SetItemActionVisible(APrefix,oItem,AParentVisible AND oItem.Visible,ARes);
    end;
end;

procedure GetMainMenuVisible(AMenu:TMainMenu;var ARes:Variant;AMode:String);
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
        if AMode = 'data' then begin
            ARes.Add(Lowercase(sPrefix + oItem.Name)+'__vis:'+dwIIF(oItem.Visible,'true,','false,'));
            ARes.Add(LowerCase(sPrefix + oItem.Name)+'__dis:'+dwIIF(not oItem.Enabled,'true,','false,'));
            //
            SetItemVisible(sPrefix,oItem,oItem.Visible,ARes);
        end else begin
            ARes.Add('this.'+Lowercase(sPrefix + oItem.Name)+'__vis='+dwIIF(oItem.Visible,'true;','false;'));
            ARes.Add('this.'+LowerCase(sPrefix + oItem.Name)+'__dis='+dwIIF(not oItem.Enabled,'true;','false;'));
            //
            SetItemActionVisible(sPrefix,oItem,oItem.Visible,ARes);
        end;
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
        SetItemActionVisible(sPrefix,oItem,oItem.Visible,ARes);
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
        if not joHint.Exists('indent') then begin
            joHint.indent   := 35;
        end;
        //
        //Result  := ' style="margin-left:'+IntToStr(joHint.indent)+'px;"';
    end;
end;


function _CreateItems (AItem:TMenuItem;APath:String; var ACode:String):Integer;
var
    ii        : Integer;
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
                        + '<el-menu-item'
                            +' index="'+APath+'-'+IntToStr(ii)+'"'
                            +dwVisible(TControl(miItem))
                            +dwDisable(TControl(miItem))
                            +' style="'
                                +'min-height:50px;'
                                +'line-height:45px;'
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
                            +'padding-left:15px;'
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



//==============================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
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
                'background-color: '+dwGetStr(joHint,'activebkcolor','#333A40')+' !important;'+
            '}'+
            '</style>');
    //hove颜色
    sColor  := dwGetStr(joHint,'hovercolor','#434A50');
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
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    joData      : Variant;
    joHint      : Variant;
    oMenu       : TMainMenu;
    oMenuItem   : TMenuItem;
begin
    joData    := _json(AData);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取得绑定的菜单
    oMenu   := _GetMainMenu(ACtrl);
    if oMenu = nil then begin
        Exit;
    end;


    //先找到对应的菜单项
    oMenuItem := dwGetMenuItem(oMenu,joData.v);

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
    if joHint.Exists('activeindex') then begin
        joHint.Delete('activeindex');
    end;
    joHint.activeindex  := GetMenuItemIndex(oMenuItem);  //从0开始，每一层用-隔开，如1-3-2
    TShape(ACtrl).Hint  := joHint;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode       : string;
    sFull       : String;
    //
    joHint      : Variant;
    joRes       : Variant;
    //
    iItem       : Integer;
    //
    oMenu       : TMainMenu;
    oItem       : TMenuItem;
    oShape      : TShape;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取得绑定的菜单
    oMenu   := _GetMainMenu(ACtrl);
    if oMenu = nil then begin
        Exit;
    end;

    //
    oShape  := TShape(ACtrl);

    //取得全名备用
    sFull   := dwFullName(Actrl);


    with oMenu do begin
        //关闭"自动热键"
        AutoHotkeys := maManual;

        //外框
        sCode   := '<div'
                +dwGetDWAttr(joHint)
                +dwVisible(TControl(ACtrl))
                +dwDisable(TControl(ACtrl))

                +' :style=''{'
                    +'left:'+sFull+'__lef,'
                    +'top:'+sFull+'__top,'
                    +'width:'+sFull+'__wid,'
                    +'height:'+sFull+'__hei,'
                    +'background:'+sFull+'__bgc'     //背景色
                +'}'''
                +' style="'
                    +'position:absolute;'
                    +'background:'+dwColor(oShape.Brush.Color)+';'     //背景色
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭
                +'>';
        joRes.Add(sCode);

        //滚动框scrollbar
        sCode   := '<el-scrollbar'
                //+' ref="'+sFull+'"'
                +' style="height:100%;width:100%"'
                //+dwIIF(True,Format(_DWEVENT,['scroll',Name,'0','onscroll',TForm(Owner).Handle]),'')
                +'>';
        joRes.Add(sCode);

        //总menu项
        sCode	:= '<el-menu'
                +' id="'+sFull+'"'
                +' :default-active="'+sFull+'__act"'     //默认选中状态
                //默认打开的菜单 :default-openeds
                +' :default-openeds="'+sFull+'__opd"'    //默认打开的菜单项 openeds: ['1','2','3']
                +' class="el-menu-demo"'
                +dwIIF(oShape.Height>=100,'',' mode="horizontal"')    //水平或垂直

                //+' background-color="'+dwColor(oShape.Brush.Color)+'"'     //背景色
                +' :background-color="'+sFull+'__bgc"'     //背景色

                //+' text-color="'+dwColor(oShape.Pen.Color)+'"'           //文本色
                +' :text-color="'+sFull+'__txc"'           //文本色

                //+dwGetHintValue(joHint,'active-text-color','active-text-color',' active-text-color="#ffd04b"')
                +' :active-text-color="'+sFull+'__atc"'   //激活状态文本色

                //:collapse="isCollapse"           //折叠
                +' :collapse="'+sFull+'__cps"'

                //折叠动画
                +' :collapse-transition="false"'

                //+dwVisible(ACtrl)
                //+dwDisable(ACtrl)
                +dwGetDWAttr(joHint)
                +' style="'
                    +'left:0;top:0;width:99%;height:100%;'  //
                    //+dwLTWHComp(ACtrl)
                    +dwGetHintStyle(joHint,'line-height','line-height','30px')
                    //+dwIIF(ParentBiDiMode=False,'line-height:30px;','line-height:'+IntToStr((Tag mod 10000)-22)+'px;')
                    +dwGetDWStyle(joHint)
                +'"' //style 封闭

                //单击事件
                //+Format(_DWEVENT,['select',Name,'val','onclick',TForm(Owner).Handle])
                +Format(_DWEVENTPlus,['select',dwIIF(dwGetInt(joHint,'dwloading',0)=1,'_this.dwloading=true;',''),sFull,'val','onclick',TForm(Owner).Handle])
                //+Format(_DWEVENTPlus,['click',Name,'0','onclick',TForm(Owner).Handle])
                +'>';
        //添加
        joRes.Add(sCode);

        //
        sCode      := '';

        for iItem := 0 to Items.Count-1 do begin
            oItem     := Items[iItem];

            //
            if oItem.Count = 0 then begin //无子菜单

                //根据有无图标判断
                if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                    joRes.Add(
                            '<el-menu-item'
                                +dwVisible(TControl(oItem))
                                +dwDisable(TControl(oItem))
                                +' index="'+IntToStr(iItem)+'"'
                                //+' style="height:50px;line-height:35px"'
                            +_GetStyle(oItem)
                            +'>'
                            +'<i class="'+dwIcons[oItem.ImageIndex]+'"></i>'
                            +'<span slot="title">'+oItem.caption+'</span>'
                            +'</el-menu-item>');
                end else begin
                    joRes.Add(
                            '<el-menu-item'
                                +dwVisible(TControl(oItem))
                                +dwDisable(TControl(oItem))
                                +' index="'+IntToStr(iItem)+'"'
                                //+' style="height:50px;line-height:35px"'
                                +_GetStyle(oItem)
                            +'>'
                            +oItem.Caption
                            +'</el-menu-item>');
                end;

            end else begin
                joRes.Add(
                        '<el-submenu'
                            +dwVisible(TControl(oItem))
                            +dwDisable(TControl(oItem))
                            +' index="'+IntToStr(iItem)+'"'
                            +_GetStyle(oItem)
                        +'>'
                        +'<template slot="title">');
                if (oItem.ImageIndex>0)and(oItem.ImageIndex<=High(dwIcons)) then begin
                    joRes.Add('<i class="'+dwIcons[oItem.ImageIndex]+'"></i>');
                end;
                joRes.Add('<span>'+oItem.Caption+'</span></template>');
                //递归生成菜单项
                _CreateItems(oItem,IntToStr(iItem),sCode);
                //
                joRes.Add(sCode);
                sCode     := '';
                //
                joRes.Add('</el-submenu>');
            end;
        end;
        //添加
        joRes.Add(sCode);
    end;

    //
    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
    joRes     : Variant;
begin
    //生成返回值数组
    joRes    := _Json('[]');
    //菜单
    joRes.Add('</el-menu>');
    //scrollbar
    joRes.Add('</el-scrollbar>');
    //最外框
    joRes.Add('</div>');
    //
    Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    sActive     : String;
    sIds        : TStringDynArray;
    sCur        : String;
    sOpens      : string;
    sFull       : String;
    //
    joRes       : Variant;
    joHint      : Variant;
    iItem       : Integer;
    iTmp        : Integer;
    oMenu       : TMainMenu;
begin
    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取得绑定的菜单
    oMenu   := _GetMainMenu(ACtrl);
    if oMenu = nil then begin
        Exit;
    end;

    //取得全名备用
    sFull   := dwFullName(Actrl);

    //
    with TShape(ACtrl) do begin
        joRes.Add(sFull+'__lef:"'+IntToStr(Left)+'px",');
        joRes.Add(sFull+'__top:"'+IntToStr(Top)+'px",');
        joRes.Add(sFull+'__wid:"'+IntToStr(Width)+'px",');
        joRes.Add(sFull+'__hei:"'+IntToStr(Height)+'px",');
        //
        joRes.Add(sFull+'__vis:'+dwIIF(Visible,'true,','false,'));
        joRes.Add(sFull+'__dis:'+dwIIF(Enabled,'false,','true,'));
        //
        //折叠状态
        joRes.Add(sFull+'__cps:'+dwIIF(ShowHint,'true','false')+',');
        //
        joRes.Add(dwFullName(Actrl)+'__bgc:"'+dwColor(Brush.Color)+'",');
        joRes.Add(dwFullName(Actrl)+'__txc:"'+dwColor(Pen.Color)+'",');
        if joHint.Exists('activetextcolor') then begin
            joRes.Add(dwFullName(Actrl)+'__atc:"'+joHint.activetextcolor+'",');
        end else begin
            joRes.Add(dwFullName(Actrl)+'__atc:"#ffd04b",');
        end;

    end;

    //
    with oMenu do begin


        //当前激活菜单位置(保存在Items[0].Hint)
        sOpens  := '';
        if Items.Count>0 then begin
            if joHint.Exists('activeindex') then begin
                sActive := String(joHint.activeindex);
            end;
            if sActive<>'' then begin
                joRes.Add(sFull+'__act:"'+sActive+'",');
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
                joRes.Add(sFull+'__act:"0",');
            end;
        end else begin
            joRes.Add(sFull+'__act:"0",');
        end;
        //
        joRes.Add(sFull+'__opd:['+sOpens+'],');

    end;

    //得到可视性和可用性
    GetMainMenuVisible(oMenu,joRes,'data');

    //
    Result    := VariantSaveJSON(joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    sActive     : String;
    sIds        : TStringDynArray;
    sCur        : String;
    sOpens      : string;
    sFull       : String;
    //
    joRes       : Variant;
    joHint      : Variant;
    iItem       : Integer;
    iTmp        : Integer;
    oMenu       : TMainMenu;
begin
    //iT0     := GetTickCount;

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取得绑定的菜单
    oMenu   := _GetMainMenu(ACtrl);
    if oMenu = nil then begin
        Exit;
    end;


    //取得全名备用
    sFull   := dwFullName(Actrl);

    //
    with TShape(ACtrl) do begin
        joRes.Add('this.'+sFull+'__lef="'+IntToStr(Left)+'px";');
        joRes.Add('this.'+sFull+'__top="'+IntToStr(Top)+'px";');
        joRes.Add('this.'+sFull+'__wid="'+IntToStr(Width)+'px";');
        joRes.Add('this.'+sFull+'__hei="'+IntToStr(Height)+'px";');
        //
        joRes.Add('this.'+sFull+'__vis='+dwIIF(Visible,'true;','false;'));
        joRes.Add('this.'+sFull+'__dis='+dwIIF(Enabled,'false;','true;'));
        //折叠状态
        joRes.Add('this.'+sFull+'__cps='+dwIIF(ShowHint,'true','false')+';');
        //
        joRes.Add('this.'+sFull+'__bgc="'+dwColor(Brush.Color)+'";');
        joRes.Add('this.'+sFull+'__txc="'+dwColor(Pen.Color)+'";');
        if joHint.Exists('activetextcolor') then begin
            joRes.Add('this.'+sFull+'__atc="'+joHint.activetextcolor+'";');
        end else begin
            joRes.Add('this.'+sFull+'__atc="#ffd04b";');
        end;
    end;

    //
    with oMenu do begin
        //当前激活菜单位置(保存在Items[0].Hint)
        sOpens  := '';
        if Items.Count>0 then begin
            if joHint.Exists('activeindex') then begin
                sActive := String(joHint.activeindex);
            end;
            if sActive<>'' then begin
                joRes.Add('this.'+sFull+'__act="'+sActive+'";');
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
                joRes.Add('this.'+sFull+'__act="0";');
            end;
        end else begin
            joRes.Add('this.'+sFull+'__act="0";');
        end;
        //
        joRes.Add('this.'+sFull+'__opd=['+sOpens+'];');
    end;

    //得到可视性和可用性
    GetMainMenuVisible(oMenu,joRes,'action');


    //
    Result    := VariantSaveJSON(joRes);

    //showmessage(IntToStr(gettickcount-iT0));
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
 
