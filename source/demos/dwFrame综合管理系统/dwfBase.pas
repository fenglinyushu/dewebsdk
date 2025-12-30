unit dwfBase;
(*
    2023-12-18 创建，主要用于处理的基础函数
*)

interface

uses
    dwBase,

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
    TypInfo,Vcl.WinXPanels,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup;


//更新主题，AIndex为主题序号，主题具体设置在StyleName中
//AMode 好像是是否初次
function dwfChangeTheme(AForm1:TForm;AIndex: Integer;AMode:Integer): Integer;

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
function dwfQueryToTreeView(AQuery:TFDQuery;ATable,ANO,AText,AId:String;ATV:TTreeView):Integer;

//取菜单项的别名，保存在Hint中的alias, 如：{"alias":"菜单项311"}，默认为caption
//采用在Hint中设置别名
//1 菜单项更改名称后，不再影响权限
//2 可以区别多个菜单项重名的情况
function dwfGetAlias(AItem:TMenuItem):String;

//菜单项转TreeView__grid
procedure dwfMainMenuToTreeView(AMenu: TMainMenu; ATV: TTreeView);

//设置菜单栏是否展开
function dwfSetMenuExpand(AForm1:TForm;AExpand : Boolean):Integer;

////显示一个Form到TabSheet中
//AForm1:TForm; 为Form1
//AClass: TFormClass  子窗体类名
//AForm:TForm 子窗体对象
//AMenu:TMenuItem;激活当前模块的菜单
//ARefresh 是否刷新（每次新建）
//AClosable 是否可关闭（TabSheet标题右上角显示关闭）
function dwfShowForm(AForm1:TForm; AClass: TFormClass; var AForm:TForm;AMenu:TMenuItem;const ARefresh:Boolean = True; const AClosable: Boolean=True): Integer;

function dwfShowHome(AForm1:TForm; AClass: TFormClass; var AForm:TForm): Integer;

//web颜色字符串转TColor的函数
function dwfWebToColor(AColor:String):Integer;

//释放所有不可见窗体
function dwfCloseNoVisible(AForm1:TForm):Integer;

//添加日志
function dwfAddLog(AForm1:TForm;AMode:String):Integer;

//取得菜单的所有叶节点项菜单的caption
procedure dwfGetMenuLeafs(AMenu:TMainMenu;var Aitems: TStringList);

//取得菜单的所有叶节点项菜单的json
procedure dwfGetMenuLeafJson(AMenu:TMainMenu;var AJson: Variant);

//取得所有Checked为true的菜单项的Name
procedure dwfGetCheckedMenus(AMenu:TMainMenu;var Aitems: TStringList);

implementation

uses
    Unit1;

//取得菜单的所有叶节点项菜单的json
procedure dwfGetMenuLeafJson(AMenu:TMainMenu;var AJson: Variant);
    procedure GetMenuJson(AAmenu: TMenuItem; AAJson: Variant);
    var
        II      : Integer;
        jjItem  : Variant;
    begin
        for II := 0 to AAmenu.Count - 1 do begin
            if AAmenu.Items[II].Count = 0 then begin
                //===== 如果是叶节点项，则将其名称添加到 items 列表中

                //
                jjItem  := _json('{}');
                jjItem.count        := 0;
                jjItem.name         := AAmenu.Items[II].Name;
                jjItem.visible      := dwIIFi(AAmenu.Items[II].Visible,1,0);
                jjItem.enabled      := dwIIFi(AAmenu.Items[II].Enabled,1,0);
                jjItem.caption      := AAmenu.Items[II].Caption;
                jjItem.checked      := dwIIFi(AAmenu.Items[II].Checked,1,0);
                jjItem.imageindex   := AAmenu.Items[II].ImageIndex;
                jjItem.hint         := dwjson(AAmenu.Items[II].Hint);

                //
                AJson.Add(jjItem);
            end else begin

                //
                jjItem  := _json('{}');
                jjItem.count        := AAmenu.Items[II].Count;
                jjItem.name         := AAmenu.Items[II].Name;
                jjItem.visible      := dwIIFi(AAmenu.Items[II].Visible,1,0);
                jjItem.enabled      := dwIIFi(AAmenu.Items[II].Enabled,1,0);
                jjItem.caption      := AAmenu.Items[II].Caption;
                jjItem.checked      := dwIIFi(AAmenu.Items[II].Checked,1,0);
                jjItem.imageindex   := AAmenu.Items[II].ImageIndex;
                jjItem.hint         := dwjson(AAmenu.Items[II].Hint);

                //
                AJson.Add(jjItem);

                // 如果不是叶节点项，则递归调用 GetMenuItems 函数
                GetMenuJson(AAmenu.Items[II], AAJson);
            end;
        end;
    end;
var
    I       : Integer;
    joItem  : Variant;
begin
    //
    if AJson = unassigned then begin
        AJson   := _json('[]');
    end;

    try
        // 遍历 MainMenu 的顶级菜单项
        for i := 0 to AMenu.Items.Count - 1 do begin
            if AMenu.Items[i].Count = 0 then begin
                //===== 如果是叶节点项，则将其名称添加到 items 列表中

                //
                joItem  := _json('{}');
                joItem.count        := 0;
                joItem.name         := AMenu.Items[I].Name;
                joItem.visible      := dwIIFi(AMenu.Items[I].Visible,1,0);
                joItem.enabled      := dwIIFi(AMenu.Items[I].Enabled,1,0);
                joItem.caption      := AMenu.Items[i].Caption;
                joItem.checked      := dwIIFi(AMenu.Items[i].Checked,1,0);
                joItem.imageindex   := AMenu.Items[i].ImageIndex;
                joItem.hint         := dwjson(AMenu.Items[i].Hint);

                //
                AJson.Add(joItem);
            end else begin

                //
                joItem  := _json('{}');
                joItem.count        := AMenu.Items[I].Count;
                joItem.name         := AMenu.Items[I].Name;
                joItem.visible      := dwIIFi(AMenu.Items[I].Visible,1,0);
                joItem.enabled      := dwIIFi(AMenu.Items[I].Enabled,1,0);
                joItem.caption      := AMenu.Items[i].Caption;
                joItem.checked      := dwIIFi(AMenu.Items[i].Checked,1,0);
                joItem.imageindex   := AMenu.Items[i].ImageIndex;
                joItem.hint         := dwjson(AMenu.Items[i].Hint);

                //
                AJson.Add(joItem);
                // 如果不是叶节点项，则递归调用 GetMenuItems 函数
                GetMenuJson(AMenu.Items[i], AJson);
            end;
        end;
    except
    end;
end;


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

//取得所有Checked为true的菜单项的Name
procedure dwfGetCheckedMenus(AMenu:TMainMenu;var Aitems: TStringList);
    procedure GetCheckedMenuItems(menu: TMenuItem; var items: TStringList);
    var
        i: Integer;
    begin
        for i := 0 to menu.Count - 1 do begin
            if menu.Items[i].Count = 0 then begin
                if menu.Items[i].Checked then begin
                    // 如果是叶节点项，则将其名称添加到 items 列表中
                    items.Add(menu.Items[i].Name);
                end;
            end else begin
                // 如果不是叶节点项，则递归调用 GetMenuItems 函数
                GetCheckedMenuItems(menu.Items[i], items);
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
                if AMenu.Items[i].Checked then begin
                    AItems.Add(AMenu.Items[i].Name);
                end;
            end else begin
                // 如果不是叶节点项，则递归调用 GetMenuItems 函数
                GetCheckedMenuItems(AMenu.Items[i], AItems);
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
        FQ_Temp.SQL.Text    := 'INSERT INTO sys_Log(lMode,lDate,lUserName,lCanvasId,lIp)'
                +' VALUES('
                +''''+AMode+''','
                +''''+FormatDateTime('yyyy-MM-DD hh:mm:ss',Now)+''','
                +''''+dwGetStr(gjoUserInfo,'username')+''','
                +''''+dwGetStr(gjoUserInfo,'canvasid')+''','
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
    joTheme     : Variant;
    joHint      : Variant;
begin
    try
        with TForm1(AForm1) do begin
            //异常处理，防止出错
            if gjoThemes = unassigned then begin
                Exit;
            end;

            if not gjoThemes.Exists('theme') then begin
                Exit;
            end;


            //如果拟设定主题的序号超出范围，则为默认主题
            if (AIndex<0) or (AIndex>gjoThemes.theme.items._Count-1) then begin
                AIndex  := 0;
            end;

            //取得拟设定的主题 JSON 节点对象
            joTheme := gjoThemes.theme.items._(AIndex);

            //如果当前节点没有设置 menuactivefont ，则默认为 menufont
            if not joTheme.Exists('menuactivefont') then begin
                joTheme.menuactivefont  := joTheme.menufont;
            end;

            //Logo 字体和背景颜色
            LL.Color                := dwfWebToColor(joTheme.logobk);
            LL.font.Color           := dwfWebToColor(joTheme.logofont);
            //banner 字体和背景颜色
            PT.Color                := dwfWebToColor(joTheme.bannerbk);
            BE.Font.Color           := dwfWebToColor(joTheme.bannerfont);
            LaUser.Font.Color       := dwfWebToColor(joTheme.bannerfont);
            LT.Font.Color           := dwfWebToColor(joTheme.bannerfont);
            BtLogout.Font.Color     := dwfWebToColor(joTheme.bannerfont);
            BtThm.Font.Color        := dwfWebToColor(joTheme.bannerfont);

            //左侧面板颜色
            PL.Color            := dwfWebToColor(joTheme.menubk);
            //LR.Font.Color       := dwfWebToColor(joTheme.menufont);
            //>


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

            //
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

            //为logo绘制下边框
            if joTheme.Exists('logoborder') then begin
                sStyle  := sStyle + 'var div = document.getElementById("ll");div.style.boxSizing = "border-box";div.style.borderBottom = "1px solid '+dwGetStr(joTheme,'logoborder','#ddd')+'";';
            end else begin
                sStyle  := sStyle + 'var div = document.getElementById("ll");div.style.boxSizing = "border-box";div.style.borderBottom = "0px";';
            end;

            //
            dwRunJS(sStyle,AForm1);
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
        for iTab := CP.CardCount-1 downto 1 do begin
            if CP.Cards[iTab].CardVisible = False then begin
                //
                FreeAndNil(TForm(CP.Cards[iTab].Controls[0]));
                //
                CP.Cards[iTab].Destroy;
            end;
        end;
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
function dwfQueryToTreeView(AQuery:TFDQuery;ATable,ANO,AText,AId:String;ATV:TTreeView):Integer;
var
    sOldNo      : String;   //上一记录的ID
    sCurNo      : string;   //当前ID
    sText       : String;
    //
    tnNode      : TTreeNode;
    //
    oFDTemp     : TFDQuery;
begin
    Result  := 0;
    try
        //打开数据表
        AQuery.Close;
        AQuery.SQL.Text := 'SELECT '+ANo+','+AText+','+AId+' FROM '+ATable +' ORDER BY '+ANo;
        AQuery.Open;

        //创建一个临时表, 以用于辅助生成树
        oFDTemp := TFDQuery.Create(AQuery.Owner);
        oFDTemp.Connection  := AQuery.Connection;
        oFDTemp.Name        := 'FDTemp_'+FormatDatetime('YYYYMMDD_hhmmsszzz',Now);

        //
        ATV.Items.Clear;

        //第一个应该为 01， 总单位名称
        sOldNo  := AQuery.FieldByName(ANo).AsString;
        ATV.Items.Add(nil,AQuery.FieldByName(AText).AsString).StateIndex := AQuery.FieldByName(AId).AsInteger;

        //
        AQuery.Next;
        while not AQuery.eof do begin
            //得到当前单位 No
            sCurNo  := AQuery.FieldByName(ANo).AsString;

            //得到标题
            sText   := AQuery.FieldByName(AText).AsString;

            //得到最后一个树节点
            tnNode  := ATV.items[ATV.Items.Count-1];

            //
            if sCurNo = sOldNo then begin
                //::::: 和上一记录的单位同一Parent

                if tnNode.Parent = nil then begin
                    //这种情况不应出现，但这里主要防出错
                    ATV.Items.AddChild(tnNode,sText).StateIndex := AQuery.FieldByName(AId).AsInteger;
                end else begin
                    ATV.Items.AddChild(tnNode.Parent,sText).StateIndex := AQuery.FieldByName(AId).AsInteger;
                end;
            end else if Pos(sOldNo,sCurNo)>0 then begin
                //::::: 当前单位是上一记录的子单位的情况

                 ATV.Items.AddChild(tnNode,sText).StateIndex := AQuery.FieldByName(AId).AsInteger;
            end else begin
                //::::: 当前单位不是上一记录的子单位，而上一记录的某级祖先的子单位的情况

                while tnNode <> nil do begin
                    //取父节点
                    tnNode  := tnNode.Parent;

                    //打开数据表查询当前节点
                    oFDTemp.Open('SELECT '+ANo+' FROM '+ATable +' WHERE '+AId + '='+IntToStr(tnNode.StateIndex));

                    //取得待查的树节点的 No
                    sOldNo  := oFDTemp.Fields[0].AsString;

                    //和拟添加节点比对
                    if sOldNo = Copy(sCurNo,1,Length(sOldNo)) then begin
                        ATV.Items.AddChild(tnNode,sText).StateIndex := AQuery.FieldByName(AId).AsInteger;
                        break;
                    end;
                end;
            end;

            //保存当前 no 为 sOldNo
            sOldNo  := sCurNo;

            //处理下一记录
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


function dwfSetMenuExpand(AForm1:TForm;AExpand: Boolean): Integer;
var
    iTab        : Integer;
    oTab        : TCard;
begin
    with TForm1(AForm1) do begin
        //左侧框宽度
        PL.Width    := dwIIFi(AExpand,200,48);

        //
        SM.ShowHint := not AExpand;

        //更新本按钮的图标
        BE.Hint       := dwIIF(AExpand,
                                '{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}',
                                '{"icon":"el-icon-s-unfold","type":"text","color":"#EEE"}');

        //项目LOGO
        LL.Caption      := dwIIF(AExpand, '.G.M.S.', '.G.');

        //头像
        //IA.Margins.Left     := dwIIFi(AExpand,72,2);
        //IA.Margins.Right    := dwIIFi(AExpand,78,6);
        //IA.Height           := dwIIFi(AExpand,50,40);

        //更新各TabSheet中内嵌Form的大小
        for iTab := 1 to CP.CardCount-1 do begin
            oTab    := CP.Cards[iTab];
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
        dwSetCookie(AForm1,'dwdExpand',dwIIF(AExpand,'1','0'),24*30);
    end;
end;


function dwfShowForm(AForm1:TForm; AClass: TFormClass; var AForm:TForm;AMenu:TMenuItem;const ARefresh:Boolean = True; const AClosable: Boolean=True): Integer;
var
    iCard       : Integer;
    oCard       : TCard;
    iForm       : Integer;
    //
    bFound      : Boolean;
	//
    sRights     : string;       //当前权限
    iRight      : Integer;
    iItem       : Integer;
    //
    ctx         : TRttiContext;
    t           : TRttiType;
    f           : TRttiField;
    //
    joHistory   : Variant;
    joHint      : Variant;
begin

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',AForm1);
    try
        //
        with TForm1(AForm1) do begin

            //<移动端处理
            if gbMobile then begin
                //隐藏顶部栏
                PL.Visible  := False;
            end;
            //>

            //<为当前操作添加记录, 包括2部分: 浏览器中的历史记录和gjoHistory数组中的记录
            //浏览器中的历史记录
            dwHistoryPush(TForm1(AForm1));
            //gjoHistory数组中的记录
            joHistory           := _json('{}');
            joHistory.type      := 'page';
            joHistory.oldindex  := CP.ActiveCardIndex;
            //检查gjoHistory数组是否创建
            if gjoHistory = unassigned then begin
                gjoHistory  := _json('[]');
            end;
            //添加到记录中
            gjoHistory.Add(joHistory);
            //>

            //先检查当前模块是否打开，
            if ARefresh then begin
                //如果ARefresh, 且已打开，则设置当前模块 CardVisible   := False;
                //
                if AForm <> nil then begin
                    for iCard := 0 to CP.CardCount-1 do begin
                        oCard   := CP.Cards[iCard];
                        if (oCard.CardVisible) and (oCard.Name = 'TS_'+AClass.ClassName) then begin
                            oCard.CardVisible   := False;
                        end;
                    end;
                end;
            end else begin
                //如果非ARefresh, 且已打开，则直接切换到当前模块

                if AForm <> nil then begin
                    for iCard := 0 to CP.CardCount-1 do begin
                        oCard   := CP.Cards[iCard];
                        if (oCard.CardVisible) and (oCard.Name = 'TS_'+AClass.ClassName) then begin
                            CP.ActiveCard       := oCard;
                            oCard.CardVisible   := True;

                            //
                            Exit;
                        end;
                    end;
                end;
            end;

            //先释放所有隐藏的tabsheet
            for iCard := CP.CardCount-1 downto 1 do begin
                if CP.Cards[iCard].CardVisible = False then begin
                    //
                    FreeAndNil(TForm(CP.Cards[iCard].Controls[0]));
                    //
                    CP.Cards[iCard].Destroy;
                end;
            end;

            //限制同时打开模块数量不大于8个.如果超过, 则自动关闭最先打开的页面
            if CP.CardCount > 7 then begin
                dwDeleteControl(CP.Cards[1]);
            end;

            //强制销毁当前Form
            if AForm <> nil then begin
                AForm   := nil;
            end;

            //创建FORM，参数必须为AForm1
            AForm   := AClass.Create(AForm1);

            //移动端处理
            if gbMobile then begin
                //控制隐藏标题栏或导航栏
                joHint      := dwJson(AForm.Hint);
                PT.Visible  := dwGetInt(joHint,'hidehead') = 0;
                TFlowPanel(FindComponent('FPTool')).Visible  := dwGetInt(joHint,'hidefoot') = 0;
            end;

            //将当前操作保存到日志表dwLog中
            dwfAddLog(TForm1(AForm1),AForm.Caption);

            //给当前Form赋一个较短的Name, 以减少网页重量, Name = F_x
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

            //此处必须设置为bsNone, 默认值bsSizable在Destory时会报错!
            AForm.BorderStyle   := bsNone;

            //创建一个TabSheet，以嵌入当前FORM
            if FindComponent('TS_'+AForm.ClassName) = nil then begin
                //创建Card
                oCard       := TCard.Create(AForm1);

                //设置名称
                oCard.Name  := 'TS_'+AForm.ClassName;

                //设置PageControl
                oCard.Parent := CP;

                //非移动端在顶部留出40px的标题高度
                if not gbMobile then begin
                    oCard.AlignWithMargins  := True;
                    oCard.Margins.SetBounds(0, 40, 0, 0);  // 设置左、上、右、下边距
                end;

                //赋给双击事件, 以双击时重载模块
                oCard.OnEnter   := TForm1(AForm1).CardClick;

                //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
                oCard.HelpContext   := AForm.HelpContext;

                //如果可以关闭
                if AClosable then begin
                    oCard.Hint      := '{"dwattr":"closable"}';
                end;
            end else begin
                //===== 存在 'TS_'+AForm.ClassName 的情况. 一般不应存在
                //也就是下面的代码应该不会执行


                oCard   := TCard(FindComponent('TS_'+AForm.ClassName));

                //释放其中已有的控件
                for iItem := oCard.ControlCount - 1 downto 0 do begin
                    oCard.Controls[iItem].Destroy;
                end;
            end;

            //设置强制刷新标志，保存在PopupMode中, 用于在关闭时释放
            if ARefresh then begin
                AForm.PopupMode := pmAuto;
            end else begin
                AForm.PopupMode := pmNone;
            end;

            //显示
            CP.ActiveCard       := oCard;
            oCard.CardVisible   := True;

            //嵌入到TabSheet中
            AForm.Width     := oCard.Width;
            AForm.Height    := oCard.Height;
            AForm.Parent    := oCard;

            //<根据登录时取得的gjoRights，取得当前模块的权限
            //gjoRights : [{"caption":"入门模块","rights":[1,1,1,1,1,1,1,1,1,1]},...,{"caption":"角色权限","rights":[1,1,1,1,1,1,1,1,1,1]}]

            if AMenu <> nil then begin
                //取得权限
                if gjoRights = unassigned then begin
                    gjoRights   := _Json('[]');
                end;
                sRights := '';

                for iRight := 0 to gjoRights._Count-1 do begin
                    if gjoRights._(iRight)._(0) = AMenu.Caption then begin
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
            end;
            //>

            //显示
            AForm.Show;

            //Caption 来设置嵌入式窗体的对应TabSheet的Caption
            oCard.Caption       := AForm.Caption;

            //移动端时, 更新标题
            if gbMobile then begin
                LT.Caption  := AForm.Caption;
            end;

            //保存当前AMenu信息
            if AMenu <> nil then begin
                dwSetProp(oCard,'menu',AMenu.Name);
            end;

            //控制界面刷新（新增/删除控件后需要）
            DockSite    := True;
        end;
    finally
        //TForm1(AForm1).CP.Visible  := True;
    end;
end;



function dwfShowHome(AForm1:TForm; AClass: TFormClass; var AForm:TForm): Integer;
var
    oCard       : TCard;
    iForm       : Integer;
    //
    bFound      : Boolean;
	//
    sRights     : string;       //当前权限
    iRight      : Integer;
    iItem       : Integer;
    //
    joHint      : variant;
begin
    try
        //
        with TForm1(AForm1) do begin

            //创建FORM，参数必须为AForm1
            AForm   := AClass.Create(AForm1);

            //移动端处理
            if gbMobile then begin
                //控制隐藏标题栏或导航栏
                joHint      := dwJson(AForm.Hint);
                PT.Visible  := dwGetInt(joHint,'hidehead') = 0;
                TFlowPanel(FindComponent('FPTool')).Visible  := dwGetInt(joHint,'hidefoot') = 0;
            end;

            //将当前操作保存到日志表dwLog中
            dwfAddLog(TForm1(AForm1),AForm.Caption);

            //给当前Form赋一个较短的Name, 以减少网页重量, Name = F_x
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

            //此处必须设置为bsNone, 默认值bsSizable在Destory时会报错!
            AForm.BorderStyle   := bsNone;

            //创建一个TabSheet，以嵌入当前FORM
            oCard   := TCard.Create(AForm1);
            //非移动端在顶部留出40px的标题高度
            if not gbMobile then begin
                oCard.AlignWithMargins   := True;
                oCard.Margins.SetBounds(0, 40, 0, 0);  // 设置左、上、右、下边距
            end;

            //设置名称
            oCard.Name   := 'TS_'+AForm.ClassName;

            //设置PageControl
            oCard.Parent := CP;

            //赋给双击事件, 以双击时重载模块
            oCard.OnEnter        := TForm1(AForm1).CardClick;

            //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
            oCard.HelpContext     := AForm.HelpContext;

            //显示
            CP.ActiveCard   := oCard;
            oCard.CardVisible := True;

            //嵌入到TabSheet中
            AForm.Width     := oCard.Width;
            AForm.Height    := oCard.Height;
            AForm.Parent    := oCard;

            //显示
            AForm.Show;

            //Caption 来设置嵌入式窗体的对应TabSheet的Caption
            oCard.Caption       := AForm.Caption;

            //移动端时, 更新标题
            if gbMobile then begin
                //LT.Caption  := AForm.Caption;
            end;

        end;
    finally
        //TForm1(AForm1).CP.Visible  := True;
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

