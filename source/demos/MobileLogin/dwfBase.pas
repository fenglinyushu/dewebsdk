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
    TypInfo,
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


//web颜色字符串转TColor的函数
function dwfWebToColor(AColor:String):Integer;

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

            //banner 字体和背景颜色
            PT.Color                := dwfWebToColor(joTheme.bannerbk);
            LT.Font.Color           := dwfWebToColor(joTheme.bannerfont);




        end;
    except
        dwRunJS('console.log("error at dwfChangeTheme");',AForm1);
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
begin
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

