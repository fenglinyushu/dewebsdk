unit dwfBase;
(*
    2023-12-18 创建，主要用于处理dwFrame中的基础函数
*)

interface

uses
    dwBase,
    Unit_QuickCrud,

    //第三方单元
    SynCommons,     //JSON解析单元，来自mormot


    //系统单元
    Graphics,
    Data.Win.ADODB,
    Variants,
	Rtti,
    Math,
    //
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
    FireDAC.Comp.DataSet,
    //
    TypInfo,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup;


//更新主题，AIndex为主题序号，主题具体设置在StyleName中
//AMode 好像是是否初次
function dwfChangeTheme(AForm1:TForm;AIndex: Integer;AMode:Integer): Integer;

//根据信息创建一个菜单项
function dwfCreateQuickCrudMenu(AForm1:TForm;AParent,ACaption,AAlias,AFileName:String;AImageIndex:Integer):Integer;

//将类似单位表，转化为树
//数据id基本如下
//01
//0101
//0102
//010101
//010102
//010201
//010202
//010203
//注意：
//1 第一条记录为总公司名称，id必须为01
//2 其他记录从01开始
//3 只支持数字
//
function dwfQueryToTreeView(AQuery:TFDQuery;ATable,AID,AText:String;ATV:TTreeView):Integer;

//取菜单项的别名，保存在Hint中的alias, 如：{"alias":"菜单项311"}，默认为caption
//采用在Hint中设置别名
//1 菜单项更改名称后，不再影响权限
//2 可以区别多个菜单项重名的情况
function dwfGetAlias(AItem:TMenuItem):String;

//菜单项转TreeView__grid
procedure dwfMainMenuToTreeView(AMenu: TMainMenu; ATV: TTreeView);

//自动创建一个QuickCrud模块到TabSheet中
function dwfQuickCrud(AForm1:TForm;AMenuItem:TMenuItem;AClosable:Boolean): Integer;

//设置菜单栏是否展开
function dwfSetMenuExpand(AForm1:TForm;AExpand : Boolean):Integer;

////显示一个Form到TabSheet中
//AForm1:TForm; 为Form1
//AClass: TFormClass  子窗体类名
//AForm:TForm 子窗体对象
//ARefresh 是否刷新（每次新建）
//AClosable 是否可关闭（TabSheet标题右上角显示关闭）
function dwfShowForm(AForm1:TForm; AClass: TFormClass; var AForm:TForm; const ARefresh:Boolean = True; const AClosable: Boolean = True): Integer;overload;

//web颜色字符串转TColor的函数
function dwfWebToColor(AColor:String):Integer;

//释放所有不可见窗体
function dwfCloseNoVisible(AForm1:TForm):Integer;

//添加日志
function dwfAddLog(AForm1:TForm;AMode:String):Integer;

//取得菜单的所有叶节点项
procedure dwfGetMenuLeafs(AMenu:TMainMenu;var Aitems: TStringList);


implementation

uses
    Unit1;


procedure dwfGetMenuLeafs(AMenu:TMainMenu;var Aitems: TStringList);
    procedure GetMenuItems(menu: TMenuItem; var items: TStringList);
    var
        i: Integer;
    begin
        for i := 0 to menu.Count - 1 do begin
            if menu.Items[i].Count = 0 then begin
                // 如果是叶节点项，则将其名称添加到 items 列表中
                items.Add(menu.Items[i].Caption);
            end else begin
                // 如果不是叶节点项，则递归调用 GetMenuItems 函数
                GetMenuItems(menu.Items[i], items);
            end;
        end;
    end;
var
    I       : Integer;
begin
    AItems  := TStringList.Create;
    try
        // 遍历 MainMenu 的顶级菜单项
        for i := 0 to AMenu.Items.Count - 1 do begin
            if AMenu.Items[i].Count = 0 then begin
                // 如果是叶节点项，则将其名称添加到 items 列表中
                AItems.Add(AMenu.Items[i].Caption);
            end else begin
                // 如果不是叶节点项，则递归调用 GetMenuItems 函数
                GetMenuItems(AMenu.Items[i], AItems);
            end;
        end;
    except
    end;

end;


//添加日志
function dwfAddLog(AForm1:TForm;AMode:String):Integer;
begin
    with TForm1(AForm1) do begin
        //将当前登录信息保存到日志表dwLog中
        FQ_Temp.Close;
        FQ_Temp.SQL.Text    := 'INSERT INTO eLog(lMode,lDate,lUserName,lCanvasId,lIp)'
                +' VALUES('
                +''''+AMode+''','
                +''''+FormatDateTime('yyyy-MM-DD hh:mm:ss',Now)+''','
                +''''+gjoUserInfo.username+''','
                +''''+gjoUserInfo.canvasid+''','
                +''''+''+''''
                +')';
        FQ_Temp.ExecSQL;
    end;
end;

//更新主题，AIndex为主题序号，主题具体设置在StyleName中
//AMode 好像是是否初次
function dwfChangeTheme(AForm1:TForm;AIndex: Integer;AMode:Integer): Integer;
var
    sStyle      : string;   //用于切换菜单的选中背景色和HOVER色
    joConfig    : Variant;
    joTheme     : Variant;
    joHint      : Variant;
begin
    try
        //取得主题配置JSON
        joConfig   := _Json(AForm1.StyleName);

        //异常处理，防止出错
        if joConfig = unassigned then begin
            Exit;
        end;
        if not joConfig.Exists('theme') then begin
            Exit;
        end;


        //如果拟设定主题的序号超出范围，则为默认主题
        if (AIndex<0) or (AIndex>joConfig.theme.items._Count-1) then begin
            AIndex  := 0;
        end;

        //取得拟设定的主题 JSON 节点对象
        joTheme := joConfig.theme.items._(AIndex);

        //如果当前节点没有设置 menuactivefont ，则默认为 menufont
        if not joTheme.Exists('menuactivefont') then begin
            joTheme.menuactivefont  := joTheme.menufont;
        end;

        //Logo 字体和背景颜色
        with TForm1(AForm1) do begin
            PO.Color            := dwfWebToColor(joTheme.logobk);
            LL.font.Color       := dwfWebToColor(joTheme.logofont);

            //banner 字体和背景颜色
            PT.Color            := dwfWebToColor(joTheme.bannerbk);
            BE.Font.Color       := dwfWebToColor(joTheme.bannerfont);
            LU.Font.Color       := dwfWebToColor(joTheme.bannerfont);
            LT.Font.Color       := dwfWebToColor(joTheme.bannerfont);
            BO.Font.Color       := dwfWebToColor(joTheme.bannerfont);
            BT.Font.Color       := dwfWebToColor(joTheme.bannerfont);

            //左侧面板颜色
            PL.Color            := dwfWebToColor(joTheme.menubk);
            LR.Font.Color       := dwfWebToColor(joTheme.menufont);
            //>


            //菜单选中的背景色和HOVER色
            if AMode = 1 then begin
                //切换选中的背景色和HOVER色
                sStyle  := 'document.getElementById('''+dwFullName(SM)+'__bk'').innerHTML = '''+
                        '.el-menu-item.is-active {'+
                            'background-color: '+joTheme.menuactive+' !important;'+
                        '}'';'+
                        'document.getElementById('''+dwFullName(SM)+'__hover'').innerHTML = '''+
                        '.el-submenu__title:hover{'+
                            'background-color: '+joTheme.menuhover+' !important;'+
                        '} '+
                        '.el-menu-item:hover { '+
                            'background-color: '+joTheme.menuhover+' !important;'+
                        '}'';';
                dwRunJS(sStyle,AForm1);
            end;

            //菜单的配色
            SM.Brush.Color := dwfWebToColor(joTheme.menubk);
            SM.Pen.Color   := dwfWebToColor(joTheme.menufont);
            //生成sp_menu的Hint
            joHint  := _json(SM.Hint);
            if joHint = unassigned then begin
                joHint  := _Json('{}');
            end;
            joHint.activetextcolor  := joTheme.menuactivefont;
            joHint.activebkcolor    := joTheme.menuactive;
            joHint.hovercolor       := joTheme.menuhover;
            //
            SM.Hint := joHint;
        end;
    except
        dwRunJS('console.log("error at dwfChangeTheme");',AForm1);
    end;

end;

//释放所有不可见窗体
function dwfCloseNoVisible(AForm1:TForm):Integer;
var
    iTab        : Integer;
begin
    with TForm1(AForm1) do begin
        for iTab := PM.PageCount-1 downto 1 do begin
            if PM.Pages[iTab].TabVisible = False then begin
                //
                FreeAndNil(TForm(PM.Pages[iTab].Controls[0]));
                //
                PM.Pages[iTab].Destroy;
            end;
        end;
    end;

end;

function dwfCreateQuickCrudMenu(AForm1:TForm;AParent,ACaption,AAlias,AFileName:String;AImageIndex:Integer):Integer;
var
    I0,I1,I2,I3 : integer;
    iTmp        : Integer;
    //
    oMenu       : TMainMenu;
    miParent    : TMenuItem;
    miCurrent   : TMenuItem;
    miMenu0     : TMenuItem;
    miMenu1     : TMenuItem;
    miMenu2     : TMenuItem;
    miMenu3     : TMenuItem;

begin
    try
        //
        dwfCloseNoVisible(AForm1);

        //
        with TForm1(AForm1) do begin
            //取父菜单项 到miParent
            oMenu       := MainMenu1;
            miParent    := nil;
            for I0 := 0 to oMenu.Items.Count-1 do begin
                miMenu0 := oMenu.Items[I0];
                if dwfGetAlias(miMenu0) = AParent then begin
                    miParent    := miMenu0;
                    break;
                end;;
                for I1 := 0 to miMenu0.Count-1 do begin
                    miMenu1 := miMenu0.Items[I1];
                    if dwfGetAlias(miMenu1) = AParent then begin
                        miParent    := miMenu1;
                        break;
                    end;;
                    for I2 := 0 to miMenu1.Count-1 do begin
                        miMenu2 := miMenu1.Items[I2];
                        if dwfGetAlias(miMenu2) = AParent then begin
                            miParent    := miMenu2;
                            break;
                        end;;
                        for I3 := 0 to miMenu2.Count-1 do begin
                            miMenu3 := miMenu2.Items[I3];
                            if dwfGetAlias(miMenu3) = AParent then begin
                                miParent    := miMenu3;
                                break;
                            end;;
                        end;
                        if miParent <> nil then begin
                            break;
                        end;
                    end;
                    if miParent <> nil then begin
                        break;
                    end;
                end;
                if miParent <> nil then begin
                    break;
                end;
            end;

            //创建菜单项
            miCurrent   := TMenuItem.Create(TForm1(AForm1));
            with miCurrent do begin
                for iTmp := 0 to 999 do begin
                    if AForm1.FindComponent('MN__'+IntToStr(iTmp)) = nil then begin
                        Name        := 'MN__'+IntToStr(iTmp);
                        System.break;
                    end;
                end;
                Caption     := ACaption;
                if AAlias <> '' then begin
                    Hint        := '{"alias":"'+AAlias+'","quickcrud":"'+AFileName+'","dwloading":1}';
                end else begin
                    Hint        := '{"quickcrud":"'+AFileName+'","dwloading":1}';
                end;
                ImageIndex  := AImageIndex;
                OnClick     := MI_QuickCrudClick;
            end;

            //设置父菜单
            if miParent = nil then begin
                MainMenu1.Items.Add(miCurrent);
            end else begin
                miParent.Add(miCurrent);
            end;
        end;
    except

    end;
end;

//将类似单位表，转化为树
//数据id基本如下
//01
//0101
//0102
//010101
//010102
//010201
//010202
//010203
//注意：
//1 第一条记录为总公司名称，id必须为01
//2 其他记录从01开始
//3 只支持数字
//
function dwfQueryToTreeView(AQuery:TFDQuery;ATable,AID,AText:String;ATV:TTreeView):Integer;
var
    sOldID      : String;   //上一记录的ID
    sCurID      : string;   //当前ID
    sText       : String;
    //
    tnNode      : TTreeNode;
begin
    Result  := 0;
    try
        //打开数据表
        AQuery.Close;
        AQuery.SQL.Text := 'SELECT '+AID+','+AText+' FROM '+ATable +' ORDER BY '+AID;
        AQuery.Open;

        //
        ATV.Items.Clear;
        //第一个应该为00， 总单位名称
        sOldID  := AQuery.FieldByName(AID).AsString;
        ATV.Items.Add(nil,AQuery.FieldByName(AText).AsString).StateIndex := StrToInt(sOldID);
        //
        AQuery.Next;
        while not AQuery.eof do begin
            //得到当前单位ID
            sCurID  := AQuery.FieldByName(AID).AsString;
            //得到标题
            sText   := AQuery.FieldByName(AText).AsString;
            //得到最后一个树节点
            tnNode  := ATV.items[ATV.Items.Count-1];
            //
            if sCurID = sOldID then begin   //和上一记录的单位同一Parent
                if tnNode.Parent = nil then begin
                    //这种情况不应出现，但这里主要防出错
                    ATV.Items.AddChild(tnNode,sText).StateIndex := StrToInt(sCurID);
                end else begin
                    ATV.Items.AddChild(tnNode.Parent,sText).StateIndex := StrToInt(sCurID);
                end;
            end else if Pos(sOldID,sCurID)>0 then begin //当前单位是上一记录的子单位的情况
                ATV.Items.AddChild(tnNode,sText).StateIndex := StrToInt(sCurID);
            end else begin  //当前单位不是上一记录的子单位，而上一记录的某级祖先的子单位的情况
                while tnNode <> nil do begin
                    tnNode  := tnNode.Parent;
                    sOldID  := '0'+IntToStr(tnNode.StateIndex);
                    if sOldID = Copy(sCurID,1,Length(sOldID)) then begin
                        ATV.Items.AddChild(tnNode,sText).StateIndex := StrToInt(sCurID);
                        break;
                    end;
                end;
            end;
            //
            sOldID  := sCurID;
            AQuery.Next;
        end;

    except

    end;
end;

//取菜单项的别名，保存在Hint中的alias, 如：{"alias":"菜单项311"}，默认为caption
//采用在Hint中设置别名
//1 菜单项更改名称后，不再影响权限
//2 可以区别多个菜单项重名的情况
function dwfGetAlias(AItem:TMenuItem):String;
var
    jjHint  : Variant;
begin
    Result  := AItem.Caption;
    //
    jjHint  := _json(AItem.Hint);
    if jjHint <> unassigned then begin
        if jjHint.Exists('alias') then begin
            Result  := jjHint.alias;
        end;
    end;
end;

//菜单项转TreeView__grid
procedure dwfMainMenuToTreeView(AMenu: TMainMenu; ATV: TTreeView);
var
    I0,I1,I2,I3 : integer;
    tnNode0     : TTreeNode;
    tnNode1     : TTreeNode;
    tnNode2     : TTreeNode;
    miMenu0     : TMenuItem;
    miMenu1     : TMenuItem;
    miMenu2     : TMenuItem;
    miMenu3     : TMenuItem;

begin
    //笨办法将MainMenu创建为树形结构，目前仅支持4层，感觉够了
    ATV.Items.Clear;
    for I0 := 0 to AMenu.Items.Count-1 do begin
        miMenu0 := AMenu.Items[I0];
        tnNode0 := ATV.Items.Add(nil,dwfGetAlias(miMenu0));
        for I1 := 0 to miMenu0.Count-1 do begin
            miMenu1 := miMenu0.Items[I1];
            tnNode1 := ATV.Items.AddChild(tnNode0,dwfGetAlias(miMenu1));
            for I2 := 0 to miMenu1.Count-1 do begin
                miMenu2 := miMenu1.Items[I2];
                tnNode2 := ATV.Items.AddChild(tnNode1,dwfGetAlias(miMenu2));
                for I3 := 0 to miMenu2.Count-1 do begin
                    miMenu3 := miMenu2.Items[I3];
                    ATV.Items.AddChild(tnNode2,dwfGetAlias(miMenu3));
                end;
            end;
        end;
    end;
end;



function dwfQuickCrud(AForm1:TForm; AMenuItem: TMenuItem;AClosable:Boolean): Integer;
var
    iTab    : Integer;
    iRight  : Integer;
    iItem   : Integer;
    iForm   : Integer;
    //
    bFound  : Boolean;
    //
    oForm   : TForm_QC;
    oTab    : TTabSheet;
	//
    sRights : string;       //当前权限
    sDir    : String;       //主目录，最后带\
    sFile   : string;       //QuickCrud配置文件，保存在菜单的Hint中的quickcrud属性中
    //
    joHint  : Variant;
    joQC    : Variant;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin
    with TForm1(AForm1) do begin

        //先释放所有隐藏的tabsheet
        for iTab := PM.PageCount-1 downto 1 do begin
            if PM.Pages[iTab].TabVisible = False then begin
                //
                FreeAndNil(TForm(PM.Pages[iTab].Controls[0]));
                //
                PM.Pages[iTab].Destroy;
            end;
        end;

        //先检查当前模块是否打开，如果打开，则直接切换到当前模块
        oTab    := nil;
        for iTab := 0 to PM.PageCount-1 do begin
            if PM.Pages[iTab].Caption = AMenuItem.Caption then begin
                PM.Pages[iTab].TabVisible  := True;
                PM.ActivePage              := PM.Pages[iTab];
                Exit;
            end;
        end;

        //限制同时打开模块数量不大于8个
        if PM.PageCount>7 then begin
            //
            FreeAndNil(TForm(PM.Pages[1].Controls[0]));
            //
            PM.Pages[1].Destroy;
        end;

        //<异常检查
        joHint  := _json(AMenuItem.Hint);
        //JSON格式检查
        if joHint = unassigned then begin
            dwMessage('QuickCrud Config is unassigned!','error',AForm1);
            Exit;
        end;
        //无配置项检查
        if not joHint.Exists('quickcrud') then begin
            dwMessage('QuickCrud Config is not exist!','error',AForm1);
            Exit;
        end;
        //配置文件检查
        sDir    := ExtractFilePath(Application.ExeName);
        sFile   := sDir + joHint.quickcrud;
        if not FileExists(sFile) then begin
            dwMessage('QuickCrud Config file is not exist!\n'+sFile,'error',AForm1);
            Exit;
        end;
        //配置文件是JSON检查
        dwLoadFromJson(joQC,sFile);
        if joQC = unassigned then begin
            dwMessage('QuickCrud Config is not JSON!','error',AForm1);
            Exit;
        end;
        //>


        //将当前操作保存到日志表dwLog中
        dwfAddLog(TForm1(AForm1),AMenuItem.Caption);

        //创建FORM
        oForm   := TForm_QC.Create(AForm1);

        //给当前Form赋一个较短的Name, 以减少网页重量
        for iItem := 0 to 9999 do begin
            bFound  := False;
            for iForm := 0 to Screen.FormCount - 1 do begin
                if Screen.Forms[iForm].Name = 'FQ'+IntToStr(iItem) then begin
                    bFound  := True;
                    break;
                end;
            end;
            if not bFound then begin
                oForm.Name  := 'FQ'+IntToStr(iItem);
                break;
            end;
        end;

        //设置qcConfig 字符串
        oForm.StyleName  := joQC;

        //设置嵌入标识,必须
        oForm.HelpKeyword := 'embed';

        //创建一个TabSheet，以嵌入当前FORM
        if oTab = nil then begin
            oTab    := TTabSheet.Create(AForm1);

            //设置PageControl
            oTab.PageControl    := PM;

            //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
            oTab.ImageIndex     := AMenuItem.ImageIndex;

            //如果可以关闭
            if AClosable then begin
                oTab.Hint       := '{"dwattr":"closable"}';
            end;

            //显示
            PM.ActivePage := oTab;
            oTab.TabVisible     := True;

            //生成oTab的Name,必须!!！
            for iTab := 1 to PM.PageCount do begin
                if FindComponent('TabSheet'+IntToStr(iTab)) = nil then begin
                    oTab.Name   := 'TabSheet'+IntToStr(iTab);
                    break;
                end;
            end;
            //Caption 来设置嵌入式窗体的对应TabSheet的Caption
            oTab.Caption        := AMenuItem.Caption;
        end;


        //嵌入到TabSheet中
        oForm.Width     := oTab.Width;
        oForm.Height    := oTab.Height;
        oForm.Parent    := oTab;
        oForm.Caption   := AMenuItem.Caption;


        //<根据登录时取得的gjoRights，取得当前模块的权限
        //gjoRights : [{"caption":"入门模块","rights":[1,1,1,1,1,1,1,1,1,1]},...,{"caption":"角色权限","rights":[1,1,1,1,1,1,1,1,1,1]}]
        //取得权限
        sRights := '';
        for iRight := 0 to gjoRights._Count-1 do begin
            if gjoRights._(iRight)._(0) = oForm.Caption then begin
                sRights := VariantSaveJSON(gjoRights._(iRight));
                break;
            end;
        end;
        //>

        //<将当前模块的权限赋于AForm的gsRights属性
        if sRights <> '' then begin;
            try
                ctx := TRttiContext.Create;
                t   := ctx.GetType(TForm_QC);
                for f in t.GetFields do begin
                    if f.Name = 'gsRights' then begin
                        f.SetValue(oForm,sRights);
                        break;
                    end;
                end;
            finally
                ctx.Free;
            end;
        end;
        //>

        //显示
        oForm.Show;

        //控制界面刷新（新增/删除控件后需要）
        DockSite    := True;

        //如果有进度条， 关闭载入中进度条
        dwRunJS('this.dwloading=false;',AForm1);
    end;
end;



function dwfSetMenuExpand(AForm1:TForm;AExpand: Boolean): Integer;
var
    iTab        : Integer;
    oTab        : TTabSheet;
begin
    with TForm1(AForm1) do begin
        //左侧框宽度
        PL.Width           := dwIIFi(AExpand,200,48);

        //
        SM.ShowHint    := not AExpand;

        //更新本按钮的图标
        BE.Hint       := dwIIF(AExpand,
                                '{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}',
                                '{"icon":"el-icon-s-unfold","type":"text","color":"#EEE"}');

        //项目LOGO
        LL.Caption      := dwIIF(AExpand,
                                '.W.M.S.',
                                '.W.');

        //头像
        IA.Margins.Left     := dwIIFi(AExpand,72,3);
        IA.Margins.Right    := dwIIFi(AExpand,78,7);
        IA.Height           := dwIIFi(AExpand,50,40);

        //更新各TabSheet中内嵌Form的大小
        for iTab := 0 to PM.PageCount-1 do begin
            oTab    := PM.Pages[iTab];
            if oTab.ControlCount>0 then begin
                with TForm(oTab.Controls[0]) do begin
                    BorderStyle := bsNone;
                    Left        := 0;
                    Top         := 0;
                    Width       := oTab.Width;
                    Height      := oTab.Height;
                end;
            end;
        end;
        //
        Result  := 0;

        //将当前展开/合拢信息写入cookie以备用
        dwSetCookie(AForm1,'dwfExpand',dwIIF(AExpand,'1','0'),24*30);
    end;
end;


function dwfShowForm(AForm1:TForm; AClass: TFormClass; var AForm:TForm;const ARefresh:Boolean = True; const AClosable: Boolean=True): Integer;
var
    iTab    : Integer;
    oTab    : TTabSheet;
    iForm   : Integer;
    //
    bFound  : Boolean;
	//
    sRights : string;       //当前权限
    iRight  : Integer;
    iItem   : Integer;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',AForm1);

    //
    with TForm1(AForm1) do begin

        //先检查当前模块是否打开，如果打开，则直接切换到当前模块
        if AForm <> nil then begin
            for iTab := 0 to PM.PageCount-1 do begin
                oTab    := PM.Pages[iTab];
                if (oTab.TabVisible) and (oTab.Name = 'TS_'+AClass.ClassName) then begin
                    PM.ActivePage  := oTab;
                    oTab.TabVisible     := True;

                    //
                    Exit;
                end;
            end;
        end;

        //先释放所有隐藏的tabsheet
        for iTab := PM.PageCount-1 downto 1 do begin
            if PM.Pages[iTab].TabVisible = False then begin
                //
                FreeAndNil(TForm(PM.Pages[iTab].Controls[0]));
                //
                PM.Pages[iTab].Destroy;
            end;
        end;

        //限制同时打开模块数量不大于8个
        if PM.PageCount>7 then begin
            //
            FreeAndNil(TForm(PM.Pages[1].Controls[0]));
            //
            PM.Pages[1].Destroy;
        end;


        //强制销毁当前Form
        if AForm <> nil then begin
            AForm   := nil;
        end;

        //创建该窗体，并创建一个标签页来嵌入窗体


        //创建FORM，参数必须为AForm1
        AForm   := AClass.Create(AForm1);

        //将当前操作保存到日志表dwLog中
        dwfAddLog(TForm1(AForm1),AForm.Caption);

        //给当前Form赋一个较短的Name, 以减少网页重量
        for iItem := 0 to 9999 do begin
            bFound  := False;
            for iForm := 0 to Screen.FormCount - 1 do begin
                if Screen.Forms[iForm].Name = 'F_'+IntToStr(iItem) then begin
                    bFound  := True;
                    break;
                end;
            end;
            if not bFound then begin
                AForm.Name  := 'F_'+IntToStr(iItem);
                break;
            end;
        end;


        //设置嵌入标识,必须
        AForm.HelpKeyword := 'embed';

        //创建一个TabSheet，以嵌入当前FORM
        if FindComponent('TS_'+AForm.ClassName) = nil then begin
            //创建Tab
            oTab    := TTabSheet.Create(AForm1);

            //设置名称
            oTab.Name   := 'TS_'+AForm.ClassName;

            //设置PageControl
            oTab.PageControl    := PM;

            //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
            oTab.ImageIndex     := AForm.HelpContext;

            //如果可以关闭
            if AClosable then begin
                oTab.Hint       := '{"dwattr":"closable"}';
            end;
        end else begin
            //
            oTab    := TTabSheet(FindComponent('TS_'+AForm.ClassName));

            //释放其中已有的控件
            for iItem := oTab.ControlCount - 1 downto 0 do begin
                oTab.Controls[iItem].Destroy;
            end;
        end;

        //设置强制刷新标志，保存在PopupMode中, 用于在关闭时释放
        if ARefresh then begin
            AForm.PopupMode := pmAuto;
        end else begin
            AForm.PopupMode := pmNone;
        end;

        //显示
        PM.ActivePage := oTab;
        oTab.TabVisible     := True;

        //嵌入到TabSheet中
        AForm.Width     := oTab.Width;
        AForm.Height    := oTab.Height;
        AForm.Parent    := oTab;

        //<根据登录时取得的gjoRights，取得当前模块的权限
        //gjoRights : [{"caption":"入门模块","rights":[1,1,1,1,1,1,1,1,1,1]},...,{"caption":"角色权限","rights":[1,1,1,1,1,1,1,1,1,1]}]
        //取得权限
        if gjoRights = unassigned then begin
            gjoRights   := _Json('[]');
        end;
        sRights := '';

        for iRight := 0 to gjoRights._Count-1 do begin
            if gjoRights._(iRight)._(0) = AForm.Caption then begin
                sRights := VariantSaveJSON(gjoRights._(iRight));
                break;
            end;
        end;
        //>

        //<将当前模块的权限赋于AForm的gsRights属性
        if sRights <> '' then begin;
            t   := ctx.GetType(AClass);
            for f in t.GetFields do begin
                if f.Name = 'gsRights' then begin
                    f.SetValue(AForm,sRights);
                    break;
                end;
            end;
        end;
        //>

        //显示
        AForm.Show;

        //Caption 来设置嵌入式窗体的对应TabSheet的Caption
        oTab.Caption        := AForm.Caption;

        //控制界面刷新（新增/删除控件后需要）
        DockSite    := True;
    end;
end;



//web颜色字符串转TColor的函数
function dwfWebToColor(AColor:String):Integer;
var
    iiR     : Integer;
    iiG     : Integer;
    iiB     : Integer;
begin
    iiR     := StrToIntDef('$'+Copy(AColor,2,2),0);
    iiG     := StrToIntDef('$'+Copy(AColor,4,2),0);
    iiB     := StrToIntDef('$'+Copy(AColor,6,2),0);
    //
    Result  := iiB*65536 + iiG*256 + iiR;
end;



end.

