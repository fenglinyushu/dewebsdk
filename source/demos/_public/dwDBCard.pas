unit dwDBCard;
(*
功能说明：
--------------------------------------------------------------------------------------------------------------------
用于通过一个panel完成卡片式crud模块

### 2025-10-25
1. 增加了 dcSetNameValu 函数, 设置配置的属性 设置name的value

### 2025-09-01
1. 增加了在无新增和无编辑情况下, 不创建编辑框,以加快速度.  dcCreateEditorPanel
2. 增加了dcSetWhere函数, 用于在初始阶段增加where

### 2025-05-23
1. 删除了一些原CrudPanel中遗留SGD - StringGrid 相关函数和功能

### 2025-05-17
1. 增加了dcSetExtraWhere和dcGetExtraWhere函数

### 2025-05-13
1. 增加了editwidth/editheight/eidttop/labelwidth等属性
*)


interface

uses
    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    System.RegularExpressions,//正则表达式函数

    //
    FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAcc,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase,
    FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.ADSDef,
    FireDAC.Phys.FBDef, FireDAC.Phys.PGDef, FireDAC.Phys.IBDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef,
    FireDAC.Phys.DB2Def, FireDAC.Phys.InfxDef, FireDAC.Phys.TDataDef, FireDAC.Phys.ASADef,
    FireDAC.Phys.MongoDBDef, FireDAC.Phys.DSDef, FireDAC.Phys.TDBXDef, FireDAC.Phys.TDBX,
    FireDAC.Phys.TDBXBase, FireDAC.Phys.DS, FireDAC.Phys.MongoDB, FireDAC.Phys.ASA,
    FireDAC.Phys.TData, FireDAC.Phys.Infx, FireDAC.Phys.DB2, FireDAC.Phys.Oracle, FireDAC.Phys.SQLite,
    FireDAC.Phys.IB, FireDAC.Phys.PG, FireDAC.Phys.IBBase, FireDAC.Phys.FB, FireDAC.Phys.ADS,
    FireDAC.Phys.MySQL, FireDAC.Stan.StorageJSON, FireDAC.Stan.StorageXML, FireDAC.Stan.StorageBin,
    FireDAC.Moni.FlatFile, FireDAC.Moni.Custom, FireDAC.Moni.Base, FireDAC.Moni.RemoteClient,

    //
    Vcl.ButtonGroup,
    Math,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;

const
    dcInited            = 10;       //初始化完成事件
    dcPageNo            = 12;       //点击页码事件		Y 为当前页码，0开始
    dcMode              = 13;       //切换查询模式事件	Y 为切换后的查询模式，0/1/2

    //
    dcNew               = 20;       //新增按钮点击事件
    dcDelete            = 21;       //编辑按钮事件		Y 为当前行号，对应RecNo
    dcEdit              = 22;       //编辑按钮事件		Y 为当前行号，对应RecNo
    dcQuery             = 23;       //查询按钮事件
    dcReset             = 24;       //重置查询按钮事件

    //通用事件
    dcDataScroll      	= 60;       //数据表当前记录发生改变的事件。包括重新查询和点击记录
    dcAppendBefore      = 61;       //FDQuery.append前事件
    dcAppendAfter       = 62;       //FDQuery.append后事件
    dcAppendPostBefore  = 63;       //新增时FDQuery.post前事件
    dcAppendPostAfter   = 64;       //新增时FDQuery.post后事件
    dcCancelBefore      = 65;       //FDQuery.dcncel前事件
    dcCancelAfter       = 66;       //FDQuery.dcncel后事件
    dcDeleteBefore      = 67;       //FDQuery.dcncel前事件	Y 为oQuery.RecNo
    dcDeleteAfter       = 68;       //FDQuery.dcncel后事件  Y 为oQuery.RecNo
    dcEditPostBefore    = 69;       //编辑时FDQuery.post前事件
    dcEditPostAfter     = 70;       //编辑时FDQuery.post后事件

    //
    dcItemClick         = 100;      //控件点击事件

//一键生成CRUD模块
function  dcInit(APanel:TPanel;AConnection:TFDConnection;const AMobile:Boolean=False;const AReserved:String=''):Integer;

//取当前配置，可能与原来的hint有所区别，主要是增加了默认值和自动生成的配置
function  dcGetConfig(APanel:TPanel):Variant;

//销毁dwCrud，以便二次创建
function  dcDestroy(APanel:TPanel):Integer;

//更新数据
procedure dcUpdate(APanel:TPanel;const AWhere:String = '');

//取DBCard模块的 FDQuery 控件。 未找到返回空值
function  dcGetFDQuery(APanel:TPanel):TFDQuery;

//取DBCard模块的SQL语句
function  dcGetSQL(APanel:TPanel):String;

//取DBCard模块的SQL语句中的where(返回值不包含where)
function  dcGetSQLWhere(APanel:TPanel):String;

//在DBCard的按钮栏中插入控件
function  dcAddInButtons(APanel:TPanel;ACtrl:TWinControl):Integer;

//设置简洁模式，智能模糊查询模式下，将按钮和查询放到一排
function  dcSetOneLine(APanel:TPanel;ATrue:Boolean):Integer;

//取得元素文本
function  dcGetCellText(APanel:TPanel;AField,ARecNo:Integer):String;

//设置额外的where, AWhere 类似 'Id>20' , 保存在PQm面板(也就是EKw的容器面板)中
function  dcSetExtraWhere(APanel:TPanel;AWhere:String):Integer;

//设置where, AWhere 类似 'Id>20' , 直接更新APanel.Hint
function  dcSetWhere(APanel:TPanel;AWhere:String):Integer;

//取保存的 ExtraWhere
function  dcGetExtraWhere(APanel:TPanel):String;

//设置子控件位置
function  dcSetControlPos(APanel:TPanel;AName:String;ALeft,ATop:Integer):Integer;

//树形表转JSON对象
//ATable为表名
//ACode 为编码字符串，子项编码应大于并包含父类编码
//ADataField 保存在数据表的内容字段名
//AViewField 显示在表格和查询中的内容字段名
//ALink为多级之间的连接字符
//ACount为最多读取的记录数量，默认50
function dcDbToTreeListJson(AQuery:TFDQuery;ATable,AData,AView,ALink:String;ACount:Integer):Variant;

//将函数cpDbToTreeListJson生成的JSON转化为TreeView
function dcTreeListJsonToTV(AList:Variant;ATV:TTreeView):Integer;


//修改Apanel的Hint中的JSON中的AFieldName字段的属性Attr的值为AValue
function  dcChangeFieldValue(APanel:TPanel;AFieldName,Attr,AValue:String):Integer;
function  dcChangeFieldValueById(APanel:TPanel;AFieldIndex:Integer;Attr,AValue:String):Integer;


//设置field的值,通过name,
//如 dcSetFieldByName(Pn1,'qCreatorId','default',9);
//即 把Pn1的Hint的json对象中fields中的name为qCreatorId的字段JSON对象中的default属性设置为9
function  dcSetFieldByName(APanel:TPanel;AName,AAttr:String;AValue:Variant):Integer;

//设置配置的属性 设置name的value
function  dcSetNameValue(APanel:TPanel;AName:String;AValue:Variant):Integer;

const
    //整型类型集合
    dcstInteger : Set of TFieldType = [ftSmallint, ftInteger, ftWord, ftAutoInc,ftLargeint, ftLongWord, ftShortint, ftByte];
    //浮点型类型集合
    dcstFloat   : set of TFieldType = [ftFloat, ftCurrency, ftBCD, ftExtended, ftSingle];

implementation


//设置name的value
function  dcSetNameValue(APanel:TPanel;AName:String;AValue:Variant):Integer;
var
    joConfig    : Variant;
begin
    Result  := 0;

    //取得JSON配置
    joConfig    := _json(APanel.Hint);

	//
	if joConfig <> unassigned then begin
        //
        joConfig.Delete(AName);
        joConfig.Add(AName,AValue);

	    //反写到Hint中
	    APanel.Hint     := joConfig;
    end else begin
        Result  := -1;
    end;
end;



//设置field的值,通过name,
//如 dcSetFieldByName(Pn1,'qCreatorId','default',9);
//即 把Pn1的Hint的json对象中fields中的name为qCreatorId的字段JSON对象中的default属性设置为9
function  dcSetFieldByName(APanel:TPanel;AName,AAttr:String;AValue:Variant):Integer;
var
    joConfig    : Variant;
    iField      : Integer;
begin
    Result  := 0;

    //取得JSON配置
    joConfig    := _json(APanel.Hint);

	//
	if joConfig <> unassigned then begin
        if joConfig.Exists('fields') then begin
            //
            for iField := 0 to joConfig.fields._Count - 1 do begin
                if dwGetStr(joConfig.fields._(iField),'name') = AName then begin
                    //
                    joConfig.fields._(iField).Delete(AAttr);
                    joConfig.fields._(iField).Add(AAttr,AValue);

                    //取得前缀备用,默认为空
                    APanel.Hint     := joConfig;

                    //
                    Exit;
                end;
            end;
        end else begin
            Result  := -2;
        end;
    end else begin
        Result  := -1;
    end;
end;



//设置子控件位置
function  dcSetControlPos(APanel:TPanel;AName:String;ALeft,ATop:Integer):Integer;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
    oCtrl       : TControl;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix');

    //
    oCtrl   := TControl(oForm.FindComponent(sPrefix+AName));

    //
    if (oCtrl <> nil)  then begin
        oCtrl.Top   := ATop;
        oCtrl.Left  := ALeft;
    end;

end;

function _HaveList(AField:Variant;ACount:Integer):Boolean;
begin
    Result  := False;
    if AField <> unassigned then begin
        if AField.Exists('list') then begin
            if AField.list <> null then begin
                Result  := AField.list._Count >= ACount;
            end;
        end;
    end;
end;

//-----设置表格单元格的各种样式
//取得DBCard对应的表格的相应单元格的dom字符串,为设置各项样式做准备
function  dcSetCellGetCell(APanel:TPanel;AField,ARecNo:integer):string;
var
    oForm       : TForm;
    oComp       : TComponent;
    sPrefix     : String;
    joConfig    : Variant;
begin

	//取得Form备用
	oForm       := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得表格名称备用
    oComp       := oForm.FindComponent(sPrefix + 'DC'+IntToStr(ARecNo)+'_'+IntToStr(AField));

    if oComp <> nil then begin
        Result  := 'document.getElementById('''+dwFullName(oComp)+''')';
    end;
end;


//取得元素文本
function  dcGetCellText(APanel:TPanel;AField,ARecNo:Integer):String;
var
    sPrefix     : string;
    joConfig    : Variant;
    oComp       : TComponent;
begin
    Result  := '';

    //
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oComp       := TForm(APanel.Owner).FindComponent(sPrefix + 'DC'+IntToStr(ARecNo)+'_'+IntToStr(AField));

    //
    if oComp <> nil then begin
        if (oComp.ClassName = 'TButton') or (oComp.ClassName = 'TLabel') then begin
            Result  := TLabel(oComp).Caption;
        end;
    end;
end;
//设置控件的left/width/right和top/height/bottom,字体等属性
function  dcSetProperty(ACtrl:TControl;AField:Variant;var ATop:Integer):Integer;
var
    oPCd    : TPanel;
    bL,bR   : Boolean;
    bT,bB   : Boolean;
begin
    Result  := 0;

    //取得父控件
    oPCd    := TPanel(ACtrl.Parent);

    //
    bL      := True;
    bR      := False;
    bT      := True;
    bB      := False;

    //
    with ACtrl do begin
        if AField.Exists('left') then begin
            Left    := AField.left;
            if AField.Exists('width') then begin
                Width   := AField.width;
            end else if AField.Exists('right') then begin
                bR      := True;
                Width   := oPCd.Width - AField.left - AField.right;
            end else begin
                Width   := 200;
            end;
        end else begin
            if AField.Exists('width') then begin
                Width   := AField.width;
                if AField.Exists('right') then begin
                    bL      := False;
                    bR      := True;
                    Left    := oPCd.Width - AField.width - AField.right;
                end else begin
                    Left    := 20;
                end;
            end else begin
                Left    := 20;
                if AField.Exists('right') then begin
                    bL      := True;
                    bR      := True;
                    Width   := oPCd.Width - 20 - AField.right;
                end else begin
                    Width   := 200;
                end;
            end;
        end;

        //
        if AField.Exists('top') then begin
            top    := AField.top;
            if AField.Exists('height') then begin
                height   := AField.height;
            end else if AField.Exists('bottom') then begin
                bB      := True;
                height  := oPCd.height - AField.top - AField.bottom;
            end else begin
                height  := 20;
            end;
        end else begin
            if AField.Exists('height') then begin
                height  := AField.height;
                if AField.Exists('bottom') then begin
                    bT      := False;
                    bB      := True;
                    top     := oPCd.height - AField.height - AField.bottom;
                end else begin
                    top     := ATop;
                end;
            end else begin
                top    := ATop;
                if AField.Exists('bottom') then begin
                    bT      := False;
                    bB      := True;
                    Top     := oPCd.height - AField.bottom;
                    height  := 20;
                end else begin
                    height   := 20;
                end;
            end;
        end;

        //
        Anchors := [];
        if bL then begin
            Anchors := Anchors + [akLeft];
        end;
        if bR then begin
            Anchors := Anchors + [akRight];
        end;
        if bT then begin
            Anchors := Anchors + [akTop];
        end;
        if bB then begin
            Anchors := Anchors + [akBottom];
        end;

        //
        ATop    := ACtrl.Top + ACtrl.Height + 5;
    end;

    //设置font
    if AField.type <> 'image' then begin
        if AField.Exists('font') then begin
            if AField.font.Exists('size') then begin
                TButton(ACtrl).Font.Size    := AField.font.size;
            end;
            if AField.font.Exists('color') then begin
                TButton(ACtrl).Font.Color   := dwGetColorFromJson(AField.font.color,clBlack);
            end;
            if AField.font.Exists('bold') then begin
                if dwGetInt(AField.font,'bold',0) = 1 then begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style + [fsBold];
                end else begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style - [fsBold];
                end;
            end;
            if AField.font.Exists('italic') then begin
                if dwGetInt(AField.font,'italic',0) = 1 then begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style + [fsitalic];
                end else begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style - [fsitalic];
                end;
            end;
            if AField.font.Exists('strikeout') then begin
                if dwGetInt(AField.font,'strikeout',0) = 1 then begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style + [fsstrikeout];
                end else begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style - [fsstrikeout];
                end;
            end;
            if AField.font.Exists('underline') then begin
                if dwGetInt(AField.font,'underline',0) = 1 then begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style + [fsunderline];
                end else begin
                    TButton(ACtrl).Font.style   := TButton(ACtrl).Font.style - [fsunderline];
                end;
            end;
        end;
    end;

    //设置dwattr和dwstyle
    if AField.Exists('dwstyle') then begin
        if AField.Exists('dwattr') then begin
            ACtrl.Hint  := '{"dwstyle":"'+dwGetStr(AField,'dwstyle','')+'","dwattr":"'+dwGetStr(AField,'dwattr','')+'"}'
        end else begin
            ACtrl.Hint  := '{"dwstyle":"'+dwGetStr(AField,'dwstyle','')+'"}'
        end;
    end else begin
        if AField.Exists('dwattr') then begin
            ACtrl.Hint  := '{"dwattr":"'+dwGetStr(AField,'dwattr','')+'"}'
        end else begin

        end;
    end;
end;



function dwGetDWStyle(AHint:Variant):String;
begin
     Result    := '';
     if AHint <> unassigned then begin
          if AHint.Exists('dwstyle') then begin
               Result    := (AHint.dwstyle);
          end;
     end;
end;

function dwGetDWAttr(AHint:Variant):String;
begin
     Result    := '';
     if AHint<>null then begin
          if AHint.Exists('dwattr') then begin
               Result    := ' '+(AHint.dwattr);
          end;
     end;
end;

//设置where, AWhere 类似 'Id>20' , 直接更新APanel.Hint
function  dcSetWhere(APanel:TPanel;AWhere:String):Integer;
var
    joConfig    : Variant;
begin
    Result  := 0;

    //取得JSON配置
    joConfig    := _json(APanel.Hint);

	//
	if joConfig <> unassigned then begin
        //
        joConfig.where	:= AWhere;

	    //取得前缀备用,默认为空
	    APanel.Hint     := joConfig;
    end else begin
        Result  := -1;
    end;
end;



//设置额外的where, AWhere 类似 'Id>20' , 保存在PQm面板(也就是EKw的容器面板)中
function  dcSetExtraWhere(APanel:TPanel;AWhere:String):Integer;
var
    sPrefix     : String;
    oForm       : TForm;
    oPQm        : TPanel;
    joConfig    : Variant;
    joHint      : Variant;
begin

	//取得Form备用
	oForm       := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));

    //
    if (oPQm = nil) then begin
        Exit;
    end else begin
        joHint              := dwJson(oPQm.Hint);
        joHint.extrawhere   := AWhere;
        oPQm.Hint           := joHint;
    end;
end;

//取保存的 ExtraWhere
function  dcGetExtraWhere(APanel:TPanel):String;
var
    sPrefix     : String;
    oForm       : TForm;
    oPQm        : TPanel;
    joConfig    : Variant;
    joHint      : Variant;
begin
    //默认返回值
    Result      := '';

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));

    //
    if (oPQm = nil) then begin
        Exit;
    end else begin
        joHint  := dwJson(oPQm.Hint);
        Result  := dwGetStr(joHint,'extrawhere','');
    end;
end;




//将函数cpDbToTreeListJson生成的JSON转化为TreeView
//结构类似[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
//只是结构类似,但 上述是javascript对象， 参数应该JSON
function dcTreeListJsonToTV(AList:Variant;ATV:TTreeView):Integer;
    procedure _Add(AParentNode:TTreeNode;AJson:Variant);
    var
        iiItem  : Integer;
        ttNode  : TTreeNode;
        jjNode  : Variant;
    begin
        for iiItem := 0 to AJson.children._Count-1 do begin
            jjNode  := AJson.children._(iiItem);
            ttNode  := ATV.Items.AddChild(AParentNode,String(jjNode.label));
            _Add(ttNode,jjNode);
        end;
    end;
begin
    ATV.Items.Clear;
    ATV.Items.Add(nil,AList._(0).label);
    //
    _Add(ATV.Items[0],AList._(0));
end;


//树形表转JSON对象
//ATable为表名
//ACode 为编码字符串，子项编码应大于并包含父类编码
//ADataField 保存在数据表的内容字段名
//AViewField 显示在表格和查询中的内容字段名
//ALink为多级之间的连接字符
//ACount为最多读取的记录数量，默认50
function dcDbToTreeListJson(AQuery:TFDQuery;ATable,AData,AView,ALink:String;ACount:Integer):Variant;
var
    iItem       : Integer;
    iIndex      : Integer;
    sCurrData   : String;
    sCurrView   : String;
    sParView    : String;   //父节点的view


    //
    joNode      : variant;
    joIndexs    : Variant;
    //
    vNodes      : array of variant;
    procedure FindParent(AData:string;AJson:Variant);
    var
        iiItem  : Integer;
        jjNode  : Variant;
    begin
        for iiItem := 0 to AJson._Count - 1 do begin
            jjNode  := AJson._(iiItem);
            if (Pos(String(jjNode.id),AData) = 1) and (AData <> String(jjNode.id)) then begin
                sParView    := jjNode.label;
                joIndexs.Add(iiItem);
            end;
            //
            FindParent(AData,jjNode.children);
        end;
    end;
begin
    try
        Result  := _json('[]');

        //根据已知条件打开查询
        AQuery.Disconnect();
        AQuery.Close;
        AQuery.SQL.Text := 'SELECT '+AData+', '+AView+' AS AV' +' FROM '+ATable+' ORDER BY ' + AData;
        //
        AQuery.FetchOptions.RecsSkip    := 0;
        AQuery.FetchOptions.RecsMax     := ACount;  //只读若干条记录，默认为50
        AQuery.Open;

        //先写入第一条记录
        sCurrData   := AQuery.Fields[0].AsString;
        sCurrView   := AQuery.Fields[1].AsString;

        //生成当前节点数据
        joNode          := _json('{}');
        joNode.id       := sCurrData;
        joNode.label    := sCurrView;
        jonode.children := _json('[]');

        //
        Result.Add(joNode);

        //
        AQuery.Next;

        //循环处理所有数据
        while not AQuery.Eof do begin
            sCurrData   := AQuery.Fields[0].AsString;
            sCurrView   := AQuery.Fields[1].AsString;

            //生成当前节点数据
            joNode          := _json('{}');
            joNode.id       := sCurrData;
            joNode.label    := sCurrView;
            jonode.children := _json('[]');


            //查找其父节点
            joIndexs    := _json('[]');
            sParView    := '';
            FindParent(sCurrData,Result);

            //
            SetLength(vNodes,Integer(joIndexs._Count)+1);
            vNodes[0]   := Result ;
            for iItem := 0 to joIndexs._Count-1 do begin
                iIndex          := joIndexs._(iItem);
                vNodes[iItem+1] := vNodes[iItem]._(iIndex).children;
            end;
            //
            if ALink <> '' then begin
                joNode.label    := sParView + ALink + sCurrView;
            end;
            //
            vNodes[Integer(joIndexs._Count)].Add(joNode);

            //
            Result  := vNodes[0];

            //
            AQuery.Next;
        end;

    except

    end;

end;

//树形表转字符串，如[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
//ATable为表名
//ACode 为编码字符串，子项编码应大于并包含父类编码
//ADataField 保存在数据表的内容字段名
//AViewField 显示在表格和查询中的内容字段名
//ALink为多级之间的连接字符
function dcDbToTreeList(AQuery:TFDQuery;ATable,AData,AView,ALink:String;ACount:Integer):String;
var
    //
    joRes       : Variant;
begin
    try
        //先生成JSON
        joRes   := dcDbToTreeListJSON(AQuery,ATable,AData,AView,ALink,ACount);

        //取得JSON格式 字符串
        Result  := joRes;

        //
        Result  := StringReplace(Result,'"id":','id:',[rfReplaceAll]);
        Result  := StringReplace(Result,'"label":','label:',[rfReplaceAll]);
        Result  := StringReplace(Result,',"children":[]','',[rfReplaceAll]);
        Result  := StringReplace(Result,'"children":','children:',[rfReplaceAll]);
        Result  := StringReplace(Result,'"','''',[rfReplaceAll]);

    except

    end;

end;

//CrudPanel内的任意子孙控件查找源crud Panel
function dcGetDBCard(ACtrl:TControl):TPanel;
var
    oCtrl   : TControl;
begin
    /////////////////////////
    ///原理是查找当前控件的父控件，如果是TPanel且HelpContext为31028，则停止
    /////////////////////////

    Result  := nil;
    if (ACtrl <> nil) and (ACtrl.Parent<>nil) then begin
        if (ACtrl.ClassType = TPanel) and (ACtrl.HelpContext = 31028) then begin
            Result  := TPanel(ACtrl);
        end else begin
            oCtrl   := ACtrl;
            while True do begin
                oCtrl   := oCtrl.Parent;
                if oCtrl = nil then begin
                    break;
                end;
                if (oCtrl.ClassType = TPanel) and (oCtrl.HelpContext = 31028) then begin
                    Result  := TPanel(oCtrl);
                    break;
                end;
            end;
        end;
    end;
end;

function dcGetConfig(APanel:TPanel):Variant;
var
    iField      : Integer;
    //
    joField     : Variant;
begin
    try
        //取配置JSON : 读AForm的 dcConfig 变量值
        Result  := _json(APanel.Hint);

        //如果不是JSON格式，则退出
        if Result = unassigned then begin
            Exit;
        end;

        //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        if not Result.Exists('border') then begin    //默认表格显示竖线
            Result.border   := 1;
        end;

        //radius与原panel的radius冲突，所以不能用
        if not Result.Exists('borderradius') then begin     //角半径
            Result.borderradius := 0;
        end;
        if not Result.Exists('buttondcaption') then begin    //按钮显示标题设置
            Result.buttondcaption   := 1;  //0:全不显示,1:全显示,2:左显右侧(隐藏/显示,模糊/精确,查询模式)不显
        end;
        if not Result.Exists('buttons') then begin          //默认各按钮面板
            Result.buttons  := 1;
        end;
        if not Result.Exists('cardheight') then begin       //默认数据卡片的高度
            Result.rowheight  := 200;
        end;
        if not Result.Exists('cardwidth') then begin        //默认数据卡片的宽度,为1则为单列,2为双列,负值为卡片宽度
            Result.rowheight  := 1;
        end;
        if not Result.Exists('defaulteditmax') then begin   //是否默认最大化
            Result.defaulteditmax := 1;
        end;
        if not Result.Exists('delete') then begin       //默认显示删除按钮
            Result.delete  := 1;
        end;
        if not Result.Exists('edit') then begin         //默认显示编辑按钮
            Result.edit  := 1;
        end;
        if not Result.Exists('editwidth') then begin    //数据编辑框的宽度
            Result.editwidth := 360;
        end;
        if not Result.Exists('fields') then begin       //显示的字段列表
            Result.fields   := _json('[]');
        end;
        if not Result.Exists('margins') then begin       //默认边距
            Result.margins  := _json('[10,0,0,0]');      //默认底部边距10
        end else if Result.margins._kind <> 2 then begin
            Result.margins  := _json('[10,0,0,0]');
        end else begin
            while Result.margins._Count < 4 do begin
                Result.margins.Add(0);
            end;
        end;
        if not Result.Exists('new') then begin          //默认显示新增按钮
            Result.new  := 0;
        end;
        if not Result.Exists('pagesize') then begin     //默认数据每页显示的行数
            Result.pagesize  := 10;
        end;
        if not Result.Exists('query') then begin        //默认显示查询
            Result.query  := 1;
        end;
        if not Result.Exists('select') then begin       //默认第一列非选择列
            Result.select   := 0;
        end;
        if not Result.Exists('switch') then begin       //默认显示切换搜索模式按钮
            Result.switch   := 1;
        end;
        if not Result.Exists('table') then begin        //默认表名
            Result.table := 'dw_member';
        end;
        if not Result.Exists('where') then begin        //默认where
            Result.where := '';
        end;

        //确保存在fields子对象数组
        if not Result.Exists('fields') then begin
            Result.fields := _json('[]')
        end else begin
            if Result.fields = null then begin
                Result.fields := _json('[]')
            end;
        end;

        //更新各字段的默认值
        for iField := 0 to Result.fields._Count - 1 do begin
            joField := Result.fields._(iField);
            //
            if not joField.Exists('name') then begin
                joField.name    := 'id';
            end;
            //
            if not joField.Exists('caption') then begin
                joField.caption := String(joField.name);
            end;
            //
            if not joField.Exists('type') then begin
                joField.type := 'string';
            end;
            if not joField.Exists('view') then begin        //默认显示
                joField.view    := 0;
            end;
            if not joField.Exists('sort') then begin        //默认不排序
                joField.sort    := 0;
            end;
            if not joField.Exists('query') then begin       //默认不查询
                joField.query   := 0;
            end;
            if not joField.Exists('align') then begin       //默认居中显示
                joField.align   := 'left';
            end;

            //处理index列
            if joField.type = 'index' then begin
                joField.dbfilter    := 0;
                joField.filter      := 0;
                joField.query       := 0;
                joField.sort        := 0;
            end;

        end;

    except

    end;
end;

//根据列号，求JSON序号
function  dcGetJsonIdFromColId(AConfig:Variant;ACol:Integer):Integer;
var
    iItem       : Integer;
    iCurCol     : Integer;
    joField     : Variant;
begin
    try
        Result  := -1;

        //如果有选择列，则加1
        iCurCol := -1;
        if dwGetInt(AConfig,'select',0)>0 then begin
            iCurCol := 0;
        end;

        //
        if ACol = iCurCol then begin
            Result  := -1;
            Exit;
        end;

        //
        for iItem := 0 to AConfig.fields._Count - 1 do begin
            joField := AConfig.fields._(iItem);
            if dwGetInt(joField,'view',0)=0 then begin
                Inc(iCurCol);
            end;
            //
            if ACol = iCurCol then begin
                Result  := iItem;
                Exit;
            end;
        end;
    except
        Result  := -1;
    end;

end;



//从JSON对象fields中取得字符串形式的字段列表，以用于sql语句
//返回值形如：id,fieldname,filetime,size
//同时把当前字段JSON对应的数据表字段以fieldid写入json中
function dcGetFields(AFields:Variant):String;
var
    iField      : Integer;
    joField     : variant;
    iFieldId    : Integer;  //数据表字段序号, 用于后面准确定位数据表字段
begin
    try
        Result  := '';

        //拼接字段字符串
        iFieldId    := 0;
        for iField := 0 to AFields._Count-1 do begin
            joField := AFields._(iField);

            //
            if joField.type = 'index' then begin
                joField.fieldid := -1;
                Continue;
            end;

            //
            if joField.type = 'totalindex' then begin
                joField.fieldid := -1;
                Continue;
            end;

            //
            if joField.type = 'button' then begin
                joField.fieldid := -2;
                Continue;
            end;

            //
            if joField.Exists('name') then begin
                Result := Result + AFields._(iField).name + ',';

                //当前字段JSON对应的数据表字段以fieldid写入json中
                joField.fieldid := iFieldId;
                Inc(iFieldId);
            end;
        end;

        //删除最后的逗号
        if Length(Result)>1 then begin
            Delete(Result,Length(Result),1);
        end;
    except
        Result  := 'ErrorWhen_GetFields';
    end;
end;


//将类似字符转为JSON
//[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]
function dcGetTreeListJson(AList:String):Variant;
begin
    AList   := stringReplace(AList,'''','"',[rfReplaceAll]);
    AList   := stringReplace(AList,'id:','"id":',[rfReplaceAll]);
    AList   := stringReplace(AList,'label:','"label":',[rfReplaceAll]);
    AList   := stringReplace(AList,',children:',',"children":',[rfReplaceAll]);
    Result  := _json(AList);
end;

//根据当前数据表记录的存储值，以及树形列表，找出对应的显示值
function dcGetTreeListView(AList:Variant;AData:String):String;
var
    iItem   : Integer;
begin
    Result  := '';
    //
    if AList._Count >0 then begin
        for iItem := 0 to AList._Count - 1 do begin
            if AList._(iItem).id = AData then begin
                Result  := AList._(iItem).label;
                break;
            end else begin
                if AList._(iItem).Exists('children') then begin
                    Result  := dcGetTreeListView(AList._(iItem).children,AData);
                    if Result <> '' then begin
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

//根据当前数据表记录的显示值，以及树形列表，找出对应的存储值
function dcGetTreeListData(AList:Variant;AView:String):String;
var
    iItem   : Integer;
begin
    Result  := '';
    //
    if AList._Count >0 then begin
        for iItem := 0 to AList._Count - 1 do begin
            if AList._(iItem).label = AView then begin
                Result  := AList._(iItem).id;
                break;
            end else begin
                if AList._(iItem).Exists('children') then begin
                    Result  := dcGetTreeListData(AList._(iItem).children,AView);
                    if Result <> '' then begin
                        break;
                    end;
                end;
            end;
        end;
    end;
end;

function dcAppend(
    APanel:TPanel;      //控件所在窗体
    AQuery:TFDQuery;    //数据查询
    AFields:Variant     //字段列表JSON
    ):Integer;
var
    iField      : Integer;
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    //
    joField     : Variant;
    joConfig    : Variant;
    joInfo      : Variant;
    //
    oForm       : TForm;
    oPEr        : TPanel;       //panel Editor
    oComp       : TComponent;
    oCB         : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    oM          : TMemo;
    oI          : TImage;
    oField      : TField;       //字段变量，用于简化代码
    //
    sPrefix     : String;
    sFields     : string;
    bAccept     : Boolean;
begin
    try
        //取得Form备用
        oForm   := TForm(APanel.Owner);

        //取得参数配置JSON对象，以便后续处理
        joConfig    := dcGetConfig(APanel);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        // dcAppendBefore 事件
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,dcAppendBefore,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //-----
        //2024-11-15 使用达梦数据库时发现，当FDQuery1.FetchOptions.RecsMax 不为-1，
        //且数据表中有自增字段时， post时报错！！！
        //所以采用了一个复杂的机制：
        //1 新增前把Aquery的关键信息（RecsMax，RecsSkip,SQL.text）保存在PEr(编辑/新增的总面板)的caption中
        //2 关闭AQuery
        //3 设置RecsMax=-1，RecsSkip=0
        //4 重新open AQuery,其中 where (1=0)
        //5 AQuery.append
        //6 在post或dcncel时， 根据以前保存的关键信息 （RecsMax，RecsSkip,SQL.text） 重新打开AQuery
        //-----

        //<先添加上述机制中的1/2/3/4
        //1 新增前把Aquery的关键信息（RecsMax，RecsSkip,SQL.text）保存在PEr(编辑/新增的总面板)的caption中
        joInfo          := _json('{}');
        joInfo.recsmax  := AQuery.FetchOptions.RecsMax;
        joInfo.recsskip := AQuery.FetchOptions.RecsSkip;
        joInfo.sqltext  := AQuery.SQL.Text;
        oPEr            := TPanel(oForm.FindComponent(sPrefix+'PEr'));
        oPEr.Caption    := String(joInfo);

        //2 关闭AQuery
        AQuery.Close;

        //3 设置RecsMax=-1，RecsSkip=0
        AQuery.FetchOptions.RecsMax     := -1;
        AQuery.FetchOptions.RecsSkip    := 0;

        //4 重新open AQuery,其中 where (1=0)
        sFields     := dcGetFields(joConfig.Fields);
        AQuery.SQL.Text := 'SELECT '+sFields+' FROM '+String(+joConfig.table )+' WHERE (1=0)';
        AQuery.Open;
        //>

        //新增
        AQuery.Append;

        // dcAppendAfter 事件
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,dcAppendAfter,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //循环处理各字段
        for iField := 0 to AFields._Count -1 do begin
            //取得字段的JSON
            joField := AFields._(iField);

            //取得当前JSON字段对应的数据表字段index
            iFieldId    := dwGetInt(joField,'fieldid',-1);

            //不处理序号列,不处理按钮列
            if iFieldId < 0 then begin
                Continue;
            end;

            //取得对应控件
            oComp   := oForm.FindComponent(sPrefix + 'F' + IntToStr(iField));

            //如果找到了控件（有可能因为view<>0的原因找不到）
            if oComp <> nil then begin

                //取得字段变量，以简化代码
                oField  := AQuery.Fields[iFieldId];

                //根据当前字段JSON信息进行处理
                //------------------------ 1 append --------------------------------------------------------------------
                if joField.type = 'auto' then begin                 //----- 1 -----
                    oE          := TEdit(oComp);
                    oE.Text     := oField.AsString;
                    TEdit(oComp).Enabled    := False;

                end else if joField.type = 'boolean' then begin     //----- 2 -----
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        oField.AsBoolean    := dwGetInt(joField,'default',0)=1;
                    end else begin
                        oField.AsBoolean    := False;
                    end;
                    oCB.ItemIndex   := dwIIFi(oField.AsBoolean,1,0);
                end else if joField.type = 'button' then begin      //----- 3 -----
                    //暂空

                end else if joField.type = 'combo' then begin       //----- 4 -----
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsString   := '';
                        end;
                    end;
                    oCB.Text    := oField.AsString;

                end else if joField.type = 'combopair' then begin   //----- 5 -----
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsString   := '';
                        end;
                    end;
                    oCB.Text    := oField.AsString;

                end else if joField.type = 'date' then begin        //----- 6 -----
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        oField.AsDateTime := StrToDateDef(joField.default,Now);
                    end else begin
                        if oField.IsNull then begin
                            oField.AsDateTime := Now;
                        end;
                    end;
                    oDT.Kind    := dtkDate;
                    oDT.Date    := oField.AsDateTime;

                end else if joField.type = 'datetime' then begin    //----- 7 -----
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        oField.AsDateTime := StrToDateTimeDef(String(joField.default),Now);
                    end else begin
                        if oField.IsNull then begin
                            oField.AsDateTime := Now;
                        end;
                    end;
                    oDT.DateTime    := oField.AsDateTime;

                end else if joField.type = 'dbcombo' then begin     //----- 8 -----
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsString   := '';
                        end;
                    end;
                    oCB.Text:= oField.AsString;

                end else if joField.type = 'dbcombopair' then begin //----- 9 -----
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsString   := '';
                        end;
                    end;
                    oCB.Text:= oField.AsString;

                end else if joField.type = 'dbtree' then begin      //----- 10 -----
                    oE          := TEdit(oComp);
                    oE.Text     := oField.AsString;
                    //TEdit(oComp).Enabled    := False;

                end else if joField.type = 'dbtreepair' then begin  //----- 11 -----
                    oE          := TEdit(oComp);
                    oE.Text     := oField.AsString;
                    //TEdit(oComp).Enabled    := False;

                end else if joField.type = 'float' then begin       //----- 12 -----
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        oField.AsFloat  := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsFloat   := 0;
                        end;
                    end;
                    oE.Text := oField.AsString;

                end else if joField.type = 'image' then begin       //----- 13 -----
                    oI  := TImage(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString := joField.default;
                    end;
                    oI.Hint := '{"src":"'+dwGetStr(joField,'imgdir','')+oField.AsString+'"}';

                end else if joField.type = 'index' then begin       //----- 13A -----
                    //序号列
                end else if joField.type = 'integer' then begin     //----- 14 -----
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        oField.AsInteger  := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsInteger   := 0;
                        end;
                    end;
                    oE.Text := oField.AsString;

                end else if joField.type = 'memo' then begin       //----- 15 -----
                    oM  := TMemo(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsString   := '';
                        end;
                    end;
                    oM.Text := oField.AsString;

                end else if joField.type = 'money' then begin       //----- 16 -----
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        oField.AsFloat   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsFloat   := 0;
                        end;
                    end;
                    oE.Text := oField.AsString;

                end else if joField.type = 'string' then begin      //----- 17 -----
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        oField.AsString   := '';
                    end;
                    oE.Text := oField.AsString;

                end else if joField.type = 'time' then begin        //----- 18 -----
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        oField.AsDateTime := StrToTimeDef(joField.default,Now);
                    end else begin
                        if oField.IsNull then begin
                            oField.AsDateTime := Now;
                        end;
                    end;
                    oDT.Kind    := dtkTime;
                    oDT.Time    := oField.AsDateTime;

                end else if joField.type = 'tree' then begin        //----- 19 -----
                    oE          := TEdit(oComp);
                    oE.Text     := oField.AsString;
                    TEdit(oComp).Enabled    := False;

                end else if joField.type = 'treepair' then begin    //----- 20 -----
                    oE          := TEdit(oComp);
                    oE.Text     := oField.AsString;
                    TEdit(oComp).Enabled    := False;

                end else begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        oField.AsString   := joField.default;
                    end else begin
                        if oField.AsVariant = null then begin
                            oField.AsString   := '';
                        end;
                    end;
                    oE.Text := oField.AsString;
                end;

                //设置只读（编辑时只读，新增时可编辑）
                if joField.type <> 'auto' then begin
                    if joField.readonly = 1 then begin
                        if joField.Exists('default') then begin
                            TEdit(oComp).Enabled    := False;
                        end else begin
                            TEdit(oComp).Enabled    := True;
                        end;
                    end;
                end;

            end;
        end;
    except
    end;
end;


//取数据字段的值
function dcGetFieldValue(AFDQuery:TFDQuery;AField:String;AConfig:Variant):String;
var
    iTemp       : Integer;
    iItem       : Integer;
    iField      : Integer;
    sTemp       : string;
    joField     : Variant;
    joList      : Variant;
begin
    //默认为空
    Result  := '';

    //异常退出
    if AConfig = unassigned then begin
        Exit;
    end;
    if AFDQuery = nil then begin
        Exit;
    end;

    //指定默认DBCard字段类型
    if not AConfig.Exists('type') then begin
        AConfig.type    := 'string';
    end;

    //默认值
    iField  := -1;
    for iItem := 0 to AFDQuery.Fields.Count -1 do begin
        if LowerCase(AFDQuery.Fields[iItem].FieldName) = LowerCase(AField) then begin
            Result  := AFDQuery.Fields[iItem].AsString;
            iField  := iItem;
            break;
        end;
    end;

    //根据当前类型重新赋值
    if AConfig.type = 'auto' then begin                     //----- 1 -----

    end else if AConfig.type = 'boolean' then begin         //----- 2 -----
        if AConfig.Exists('list')  then begin
            if AConfig.list._Count > 1 then begin
                if iField <> -1 then begin
                    Result  := dwIIF(AFDQuery.Fields[iField].AsBoolean,AConfig.list._(1),AConfig.list._(0));
                end else begin
                    Result  := AConfig.list._(0);
                end;
            end;
        end;
    end else if AConfig.type = 'button' then begin          //----- 3 -----

    end else if (AConfig.type = 'combo') then begin         //----- 4 -----
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if (AConfig.type = 'combopair') then begin     //----- 5 -----
        if AFDQuery.Fields[iField].AsString <> '' then begin
            for iTemp := 0 to AConfig.list._Count - 1 do begin
                if AConfig.list._(iTemp)._(0) = AFDQuery.Fields[iField].AsString then begin
                    Result  := AConfig.list._(iTemp)._(1);
                    break;
                end;
            end;
        end;
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'date' then begin            //----- 6 -----
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AFDQuery.Fields[iField].AsDateTime);
        end else begin
            if Trunc(AFDQuery.Fields[iField].AsDateTime) = 0 then begin
                Result  := '';
            end else begin
                Result  := FormatDatetime('yyyy-MM-dd',AFDQuery.Fields[iField].AsDateTime);
            end;
        end;

    end else if AConfig.type = 'datetime' then begin        //----- 7 -----
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AFDQuery.Fields[iField].AsDateTime);
        end else begin
            if Trunc(AFDQuery.Fields[iField].AsDateTime) = 0 then begin
                Result  := '';
            end else begin
                Result  := FormatDatetime('yyyy-MM-dd hh:mm:ss',AFDQuery.Fields[iField].AsDateTime);
            end;
        end;

    end else if (AConfig.type = 'dbcombo') then begin       //----- 8 -----
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if (AConfig.type = 'dbcombopair') then begin   //----- 9 -----
        if AFDQuery.Fields[iField].AsString <> '' then begin
            for iTemp := 0 to AConfig.list._Count - 1 do begin
                if AConfig.list._(iTemp)._(0) = AFDQuery.Fields[iField].AsString then begin
                    Result  := AConfig.list._(iTemp)._(1);
                    break;
                end;
            end;
        end;
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'dbtree' then begin          //----- 10 -----
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AFDQuery.Fields[iField].AsString]);
        end else begin
            Result  := AFDQuery.Fields[iField].AsString;
        end;

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;
    end else if AConfig.type = 'dbtreepair' then begin      //----- 11 -----
        if AFDQuery.Fields[iField].AsString <> '' then begin
            //将tree的list转化为JSON
            joList  := dcGetTreeListJson(AConfig.list);
            //查找对应的显示值
            Result  := dcGetTreeListView(joList,AFDQuery.Fields[iField].AsString);
        end;

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;
    end else if AConfig.type = 'float' then begin           //----- 12 -----
        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'image' then begin           //----- 13 -----
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AFDQuery.Fields[iField].AsString]);
        end else begin
            Result  := AFDQuery.Fields[iField].AsString;
        end;
        //
        if AConfig.Exists('imgdir') then begin
            Result  := AConfig.imgdir + Result;
        end;

    end else if AConfig.type = 'index' then begin           //----- 13A -----
        //序号列 记录号
        Result  := IntToStr(AFDQuery.RecNo);
    end else if AConfig.type = 'totalindex' then begin           //----- 13A -----
        //序号列 总记录号
        Result  := IntToStr(AFDQuery.FetchOptions.RecsSkip+AFDQuery.RecNo);
    end else if AConfig.type = 'integer' then begin         //----- 14 -----
        Result  := IntToStr(AFDQuery.Fields[iField].AsInteger);

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;
    end else if AConfig.type = 'link' then begin            //----------
        //取得url字段名
        sTemp   := dwGetStr(AConfig,'urlfield',AConfig.name);
        if AFDQuery.FieldByName(sTemp) <> nil then begin
            sTemp   := AFDQuery.FieldByName(sTemp).AsString;
            Result  := '<a%s style="%s" href="%s" target="%s">%s</a>';
            Result  := Format(Result,[dwGetDWAttr(AConfig),dwGetDWStyle(AConfig),sTemp,dwGetStr(AConfig,'target','_blank'),AFDQuery.Fields[iField].AsString]);
        end;

    end else if AConfig.type = 'memo' then begin            //----- 15 -----

    end else if AConfig.type = 'money' then begin           //----- 16 -----
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AFDQuery.Fields[iField].AsFloat]);
        end else begin
            Result  := Format('%n',[AFDQuery.Fields[iField].AsFloat]);
        end;

    end else if AConfig.type = 'string' then begin          //----- 17 -----

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'time' then begin            //----- 18 -----
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AFDQuery.Fields[iField].AsDateTime);
        end else begin
            Result  := FormatDatetime('hh:mm:ss',AFDQuery.Fields[iField].AsDateTime);
        end;

    end else if AConfig.type = 'tree' then begin            //----- 19 -----

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else if AConfig.type = 'treepair' then begin        //----- 20 -----
        if AFDQuery.Fields[iField].AsString <> '' then begin
            //将tree的list转化为JSON
            joList  := dcGetTreeListJson(AConfig.list);
            //查找对应的显示值
            Result  := dcGetTreeListView(joList,AFDQuery.Fields[iField].AsString);
        end;

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end else begin

        //处理可能存在的format
        if AConfig.Exists('format') then begin
            if Pos('%n',AConfig.format) > 0 then begin
                Result  := Format(AConfig.format,[StrToFloatDef(Result,0)]);
            end else begin
                Result  := Format(AConfig.format,[Result]);
            end;
        end;

    end;

    //删除结果中的特殊字符
    Result  := StringReplace(Result,#10,'',[rfReplaceAll]);
    Result  := StringReplace(Result,#13,'',[rfReplaceAll]);

end;

//根据表名、字段名，生成选项JSON数组
function dcGetItems(
        AQuery:TFDQuery;       //对应的TFDQuery控件
        ATable:string;          //表名
        AField:string
        ):Variant;
begin
    Result  := _json('[]');
    //
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := 999;
    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Distinct('+AField+') FROM '+ATable;
    AQuery.Open;

    //
    while not AQuery.Eof do begin
        if Trim(AQuery.Fields[0].AsString)<>'' then begin
            Result.Add(AQuery.Fields[0].AsString);
        end;
        //
        AQuery.Next;
    end;
end;

//计算字段列表中在表格中显示的数量
function dcGetViewFieldCount(AFields:Variant):Integer;
var
    iItem   : Integer;
begin
    Result  := 0;
    //
    for iItem := 0 to AFields._Count - 1 do begin
        if dwGetInt(AFields._(iItem),'view',0) = 0 then begin
            Inc(Result);
        end;
    end;
end;

function dcGetWhere(
        AFields     : string;          //字段列表  = '*'或'Name,Age,job,title'
        AKeyword    : String
        ):string;
var
    sKeywords   : TStringDynArray;  //关键字列表，以空格隔开
    sFields     : TStringDynArray;  //字段名列表，以逗号隔开
    iPos        : Integer;
    iKey        : Integer;
    iField      : Integer;
begin
    if Trim(AKeyword)='' then begin
        Result  := ' WHERE (1=1) ';
    end else begin
        //拆分出多个关键字。 如查询 ”delphi 控件开发“
        SetLength(sKeywords,0);
        AKeyword    := Trim(AKeyword);
        while AKeyword<>'' do begin
            iPos := Pos(' ',AKeyword);
            if iPos>0 then begin
                SetLength(sKeywords,Length(sKeywords)+1);
                sKeywords[High(sKeywords)]    := Trim(Copy(AKeyword,1,iPos-1));
                //
                Delete(AKeyword,1,iPos);
                AKeyword    := Trim(AKeyword);
            end else begin
                SetLength(sKeywords,Length(sKeywords)+1);
                sKeywords[High(sKeywords)]    := AKeyword;
                //
                break;
            end;
        end;
        //拆分出多个字段名。 如”Name,Age,Addr“
        SetLength(sFields,0);
        AFields    := Trim(AFields);
        while AFields<>'' do begin
            iPos := Pos(',',AFields);
            if iPos>0 then begin
                SetLength(sFields,Length(sFields)+1);
                sFields[High(sFields)]    := Trim(Copy(AFields,1,iPos-1));
                //
                Delete(AFields,1,iPos);
                AFields    := Trim(AFields);
            end else begin
                SetLength(sFields,Length(sFields)+1);
                sFields[High(sFields)]    := AFields;
                //
                break;
            end;
        end;
        //得到字段名
        Result  := ' WHERE (';
        for iKey := 0 to High(sKeywords) do begin
            Result  := Result +'(';
            for iField := 0 to High(sFields) do begin
                //不查询iD字段
                if lowerCase(sFields[iField])='id' then begin
                    Continue;
                end;
                //
                Result  := Result + sFields[iField] +' like ''%'+sKeywords[iKey]+'%'' OR '
            end;
            Delete(Result,Length(Result)-3,4);
            Result  := Result +') AND ';
        end;
        Delete(Result,Length(Result)-3,4);
        //
        Result  := Result + ')';
    end;
end;

//根据表名、字段名、条件，排序，页数，每页记录数自动读取数据，更新自定义显示和分页
//AFileds = '*'或'Name,Age,job,title'
//AWhere = 'WHERE id>10'
//AOrder = 'ORDER BY name DESC'
//注意:必须有id自增字段
procedure dcGetPageData(
        APanel:TPanel;
        AQuery:TFDQuery;        //对应的ADOQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        APage:Integer;          //当前页码,从1开始
        ACount:Integer;         //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );
begin

    //----求总数------------------------------------------------------------------------------------
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := -1;

    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Count(*) FROM '+ATable+' '+AWhere;
    AQuery.Open;

    //记录总数
    ARecordCount    := AQuery.Fields[0].AsInteger;

    //如果超出最大页数,则为最大页数
    if APage > Ceil(ARecordCount / ACount) then begin
        APage   := Ceil(ARecordCount / ACount);
    end;

    //强制APage 从0开始
    APage   := Max(0,APage);

    //----更新当前页--------------------------------------------------------------------------------

    AQuery.Close;

    //<2023-04-13 改成的FireDAC的机制
    AQuery.SQL.Text := 'SELECT '+ AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    AQuery.FetchOptions.RecsSkip    := APage * ACount;
    AQuery.FetchOptions.RecsMax     := ACount;
    //>

    //
    AQuery.Open;

end;

//设置简洁模式，智能模糊查询模式下，将按钮和查询放到一排
function  dcSetOneLine(APanel:TPanel;ATrue:Boolean):Integer;
var
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
    oPBs        : TPanel;
    oPQm        : TPanel;
    oCSo        : TComboBox;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPQm    := TPanel(oForm.FindComponent(sPrefix+'PQm'));
    oPBs    := TPanel(oForm.FindComponent(sPrefix+'PBs'));
    oCSo    := TComboBox(oForm.FindComponent(sPrefix+'CSo'));

    //
    if (oPQm = nil) or (oPBs = nil) then begin
        Exit;
    end;

    //是否放在同一行
    if ATrue then begin
        oPBs.Parent := oPQm;
        oPBs.Align  := alClient;
        oCSo.Align  := alRight;
    end else begin
        oPBs.Parent := oForm;
        oPQm.Align  := alTop;
        oPBs.Align  := alTop;
        oPBs.Top    := 9999;
        oCSo.Align  := alLeft;
    end;

end;

//根据显示的值, 取得数据表存储的值
function dcGetPairData(AField:Variant;AValue:String):String;
var
    iItem   : Integer;
    joList  : Variant;
begin
    if (AField.type = 'combopair') or (AField.type = 'dbcombopair') then begin
        //"list":[
        //    ["029","西安"],
        //    ["0271","纽约"],
        //    ["0971","新奥尔良"]

        Result  := '';
        for iItem := 0 to AField.list._Count - 1 do begin
            if AField.list._(iItem)._(1) = AValue then begin
                Result  := AField.list._(iItem)._(0);
                break;
            end;
        end;
    end else if (AField.type = 'treepair') or (AField.type = 'dbtreepair') then begin
        //"list":"[{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]"

        //
        joList  := dcGetTreeListJson(AField.list);

        //
        Result  := dcGetTreeListData(joList,AValue);

    end;
end;

//取得
function dwGetFilter(APanel:TPanel):String;
var
    oForm       : TForm;
    oPFi        : TPanel;
    oCFi        : TCardPanel;
    oCF         : TCard;
    oFF         : TFlowpanel;
    oBF         : TButton;
    //
    iItem       : Integer;
    iCtrl       : Integer;
    iField      : Integer;
    iList       : Integer;
    //
    sPrefix     : string;
    sName       : String;
    sCFFilter   : String;   //
    sCaption    : string;
    bFound      : Boolean;
    bPair       : Boolean;
    //
    joConfig    : Variant;
    joField     : Variant;
    joList      : Variant;
begin
    Result      := '';


	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得筛选总面板
    oPFi        := TPanel(oForm.FindComponent(sPrefix+'PFi'));

    //如果未筛选，则退出
    if oPFi  = nil then begin
        Exit;
    end;

    if oPFi.Tag = 0 then begin
        Exit;
    end;

    //取得用于筛选的cardpanel
    oCFi        := TCardPanel(oForm.FindComponent(sPrefix+'CFi'));

    //置所有选项未选中状态
    for iItem := 0 to OCFi.CardCount - 1 do begin
        //得到当前card
        oCF     := oCFi.Cards[iItem];

        //从Name中取得字段序号
        sName   := oCF.Name;
        iField  := StrToIntDef(Copy(sName,3,3),-1);

        //异常处理
        if iField = -1 then begin
            Continue;
        end;

        //取得字段JSON
        joField := joConfig.fields._(iField);

        //字段名称
        sName   := joField.name;

        //默认当前字段的筛选
        sCFFilter   := '';
        //取得筛选项的容器FlowPanel
        oFF     := TFlowPanel(oCF.Controls[0]);
        for iCtrl := 0 to oFF.ControlCount - 1 do begin
            //取得筛选项 BFx - button filter
            oBF := TButton(oFF.Controls[iCtrl]);

            //如果当前筛选项选中，则添加到where字符串
            if oBF.Tag = 1 then begin
                if joField.type = 'boolean' then begin
                    //先检查是否有合法的list： 有且Count>=2
                    bFound  := _HaveList(joField,2);

                    //根据是否有合法的list，分别处理
                    if bFound then begin
                        if oBF.Caption = joField.list._(0) then begin
                            sCFFilter   := sCFFilter+'('+sName+'=0)or';
                        end else if oBF.Caption = joField.list._(1) then begin
                            sCFFilter   := sCFFilter+'('+sName+'=1)or';
                        end;
                    end else begin
                        sCaption    := lowercase(oBF.Caption);
                        if (sCaption = 'false') or (sCaption = 'f') or (sCaption = 'n') then begin
                            sCFFilter   := sCFFilter+'('+sName+'=0)or';
                        end else if (sCaption = 'true') or (sCaption = 't') or (sCaption = 'y') then begin
                            sCFFilter   := sCFFilter+'('+sName+'=1)or';
                        end;
                    end;
                end else begin
                    //检查是否为映射类型
                    bPair   := False;
                    if joField.Exists('list') then begin
                        if joField.list._Count > 0 then begin
                            if (Pos('[',String(joField.list._(0))) > 0) and (Pos(']',String(joField.list._(0))) > 0)then begin
                                bPair   := True;
                            end;
                        end;
                    end;

                    //根据是否为映射, 分别处理
                    //"list":
                    //[
                    //    [
                    //        0,
                    //        "待录入"
                    //    ],
                    //    [
                    //        1,
                    //        "已完成"
                    //    ]
                    //],
                    if bPair then begin
                        for iList := 0 to joField.list._Count - 1 do begin
                            joList  := joField.list._(iList);
                            if joList._(1) = oBF.Caption then begin
                                sCFFilter   := sCFFilter+'('+sName+'='''+String(joList._(0))+''')or';
                                break;
                            end;
                        end;
                    end else begin
                        sCFFilter   := sCFFilter+'('+sName+'='''+oBF.Caption+''')or';
                    end;
                end;
            end;
        end;

        //处理最后的'or'
        if Length(sCFFilter) > 1 then begin
            Delete(sCFFilter,Length(sCFFilter)-1,2);
            Result  := Result + '('+sCFFilter+')and';
        end;
    end;
    //处理最后的'and'
    if Length(Result) > 1 then begin
        Delete(Result,Length(Result)-2,3);
    end;

end;

function dwGetOrder(APanel:TPanel):String;
var
    joConfig    : Variant;
    joField     : Variant;
    iField      : Integer;
    //
    oForm       : TForm;
    oCSo        : TCombobox;    //combobox sort
    sCaption    : String;       //排序的标题
    sName       : string;       //排序标题对应的字段名
    sOrder      : String;       //正序或反序
    sPrefix     : String;
begin
    Result      := '';

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得控件
    oCSo        := TComboBox(oForm.FindComponent(sPrefix+'CSo'));

    //
    if oCSo <> nil then begin
        if oCSo.ItemIndex > 0 then begin
            sCaption    := oCSo.Text;
            sOrder      := Copy(sCaption,Length(sCaption),1);
            sCaption    := Copy(sCaption,1,Length(sCaption)-2);
            //
            sName   := '';
            for iField := 0 to joConfig.fields._Count - 1 do begin
                joField := joConfig.fields._(iField);
                if sCaption = String(joField.caption) then begin
                    sName   := joField.name;
                    break;
                end;
            end;

            //
            if sName <> '' then begin
                Result  := ' ORDER BY '+sName;
                if sOrder = '↓' then begin
                    Result  := Result + ' DESC';
                end;
            end;
        end;
    end;

    //如果没有, 则使用默认排序

    if (Result = '') and joConfig.Exists('defaultorder') then begin
        Result  := ' ORDER BY '+joConfig.defaultorder;
    end;

end;



function dcGetFDQuery(APanel:TPanel):TFDQuery;
var
    sPrefix     : String;
    joConfig    : Variant;
begin
    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //求当前模块的 FDQuery
    Result      := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
end;

function  dcGetSQL(APanel:TPanel):String;
var
    sPrefix     : String;
    joConfig    : Variant;
    oFDQuery    : TFDQuery;
begin
    Result  := '';

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
    if oFDQuery<>nil then begin
        Result  := oFDQuery.SQL.Text;
    end;
end;


function  dcGetSQLWhere(APanel:TPanel):String;
var
    sPrefix     : String;
    joConfig    : Variant;
    Regex       : TRegEx;
    Match       : TMatch;
begin

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    Result      := dcGetSQL(APanel);

    // 正则表达式匹配 WHERE 子句
    Regex   := TRegEx.Create('(?i)\bWHERE\b\s*(.*?)(?=\bORDER BY\b|\bGROUP BY\b|$)', [roIgnoreCase]);
    Match   := Regex.Match(Result);

    if Match.Success then begin
        Result := Match.Groups[1].Value.Trim; // 返回 WHERE 子句内容
    end else begin
        Result := ''; // 如果没有找到，返回空字符串
    end;

end;


Procedure EKwChange(Self: TObject; Sender: TObject);    //EKw : Edit Keyword
var
    oEKw        : TEdit;
    oDBCard     : TPanel;
    oForm       : TForm;
    oTbP        : TTrackBar;
    //
    sPrefix     : String;
    joConfig    : Variant;
	bAccept		: boolean;
begin
    //dwMessage('B_ResetClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oEKw        := TEdit(Sender);
    oForm       := TForm(oEKw.Owner);

    //取得源crud panel
    oDBCard     := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));

    //
    oTbP.Position   := 0;

    // dcQuery 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcQuery,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新数据
    dcUpdate(oDBCard,'');
end;

Procedure FQyResize(Self: TObject; Sender: TObject);
var
    oFQy        : TFlowPanel;
    oChange     : Procedure(Sender:TObject) of Object;
begin
    //取得各控件
    oFQy        := TFlowPanel(Sender);
    //
    oChange         := oFQy.OnResize;
    oFQy.OnResize   := nil;
    oFQy.AutoSize   := True;
    oFQy.AutoSize   := False;
    //
    oFQy.OnResize   := oChange;
end;

Procedure BQmClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oFQy        : TFlowPanel;
    oPQSmt      : TPanel;
    oBFz        : TButton;
    //
    sPrefix     : String;
    joConfig    : Variant;
    oDBCard  : TPanel;
	bAccept		: boolean;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));


    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    oForm       := TForm(oButton.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));
    oPQSmt      := TPanel(oForm.FindComponent(sPrefix+'PQm'));
    oBFz        := TButton(oForm.FindComponent(sPrefix+'BFz'));

    //
    oButton.Tag := oButton.Tag - 1;
    if not(oButton.Tag in [0,1,2]) then begin
        oButton.Tag := 2;
    end;

    // dcMode 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcMode,oButton.Tag,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    if oFQy = nil then begin
        //切换查询模式： 分字段查询 / 智能模糊查询
        case oButton.Tag of
            0 : begin
                //切换到 无查询
                oPQSmt.Visible := False;
                //该模式下支持2种匹配方式：模糊/精确
                oBFz.Visible    := False;
            end;
            1,2 : begin
                //切换到 智能模糊查询
                oPQSmt.Visible := True;
                oPQSmt.Top     := 0;
                //该模式下仅支持模糊查询
                oBFz.Visible    := False;
                //
                oButton.Tag := 1;
            end;
        else
        end;
    end else begin
        //切换查询模式： 分字段查询 / 智能模糊查询
        case oButton.Tag of
            0 : begin
                //切换到 无查询
                oFQy.Top       := oPQSmt.Top;
                oPQSmt.Visible := False;
                oFQy.Visible   := False;
                //该模式下支持2种匹配方式：模糊/精确
                oBFz.Visible    := False;
            end;
            1 : begin
                //切换到 智能模糊查询
                oPQSmt.Top     := oFQy.Top;
                oFQy.Visible   := False;
                oPQSmt.Visible := True;
                //该模式下仅支持模糊查询
                oBFz.Visible    := False;
            end;
            2 : begin
                //切换到 分字段查询
                oFQy.Top       := oPQSmt.Top;
                oPQSmt.Visible := False;
                oFQy.Visible   := True;
                //该模式下支持2种匹配方式：模糊/精确
                oBFz.Visible    := True;
                oFQy.OnResize(oFQy);
            end;
        else
        end;
    end;
end;

Procedure BFzClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    if oButton.Tag = 0 then begin
        //精确
        oButton.Tag     := 1;
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-c-sdcle-to-original"}';
        oButton.Caption := '精确';
    end else begin
        //模糊
        oButton.Tag     := 0;
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-open"}';
        oButton.Caption := '模糊';
    end;
end;

Procedure PQmUnDock(Self: TObject; Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
var
    oPQm        : TPanel;
    oPanel      : TPanel;
begin
    //dwMessage('PQmUnDock','',TForm(TEdit(Sender).Owner));
    ///该方法主要用于其他程序从外部更新当前模块, 比如和DBCard模块联动, DBCard为主表, dBcard为从表
    /// 具体做法是: 当其他模块需要更新dbcard中, 先找到 PQM, 然后设置 pqm的caption为where, 然后调用该方法
    ///

    //取得各控件
    oPQm        := TPanel(Sender);

    //
    oPanel      := TPanel(oPQM.Parent);

    //
    dcUpdate(oPanel,oPQm.Caption);

end;


Procedure BDOClick(Self: TObject; Sender: TObject); //Button Delete OK
var
    oDBCard  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPanel      : TPanel;
    //
    bAccept     : Boolean;
    //
    joConfig    : variant;
    //
    sPrefix     : String;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent(sPrefix+'PDe'));
    oQuery      := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));

    // dcDeleteBefore 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcDeleteBefore,oQuery.RecNo,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //删除当前行所有记录
    oQuery.Delete;
    //
    dcUpdate(oDBCard,'');

    // dcDeleteAfter 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcDeleteAfter,oQuery.RecNo,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    oPanel.Visible  := False;
end;

Procedure BDCClick(Self: TObject; Sender: TObject);
var
    oButton : TButton;
    oForm   : TForm;
    oPanel  : TPanel;
    //
    sPrefix     : String;
    joConfig    : Variant;
    oDBCard  : TPanel;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
    //关闭面板
    oPanel.Visible  := False;
end;

Procedure BEAClick(Self: TObject; Sender: TObject);     //Button Edit Cancel
var
    oDBCard  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPEr        : TPanel;
    //
    sPrefix     : String;
	bAccept		: boolean;
    //
    joConfig    : Variant;
    joInfo      : Variant;
begin
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各对象
    oForm       := TForm(oButton.Owner);
    oPEr        := TPanel(oForm.FindComponent(sPrefix+'PEr'));

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    // dcCancelBefore 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcCancelBefore,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //用 PEr 的tag来标记当前状态，
    oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));
    oQuery.Cancel;

    // dcCancelAfter 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcCancelAfter,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    oPEr.Visible  := False;

    //恢复由于兼容达梦时的数据查询
(*
        joInfo          := _json('{}');
        joInfo.recsmax  := AQuery.FetchOptions.RecsMax;
        joInfo.recsskip := AQuery.FetchOptions.RecsSkip;
        joInfo.sqltext  := AQuery.SQL.Text;
        oPEr            := TPanel(oForm.FindComponent(sPrefix+'PEr'));
        oPEr.Caption    := String(joInfo);
*)
    joInfo  := _json(oPEr.Caption);
    if joInfo <> unassigned then begin
        oQuery.Disconnect();
        oQuery.Close;
        oQuery.FetchOptions.RecsMax     := joInfo.recsmax;
        oQuery.FetchOptions.RecsSkip    := joInfo.recsskip;
        oQuery.SQL.Text                 := joInfo.sqltext;
        oQuery.Open();
    end;

    //更新显示（仅tag=999时，此时表示已批量增加）
    if oButton.Tag = 999 then begin
        oButton.Tag := 0;

        //更新显示
        dcUpdate(oDBCard,'');
    end;
end;

Procedure BEtClick(Self: TObject; Sender: TObject);
var
    oDBCard  : TPanel;
    oForm       : TForm;
    oBEt        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oI          : TImage;
    oM          : TMemo;
    oDT         : TDateTimePicker;
    oCB         : TComboBox;
    oCKB        : TCheckBox;
    //
    iItem       : Integer;
    iTemp       : Integer;
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    //用于取字段值，并清除其中的换行
    sValue      : String;
    //
    joConfig    : Variant;
    joField     : Variant;
    joList      : Variant;
    //
    sPrefix     : String;
	bAccept		: boolean;
begin
    //编辑事件

    //取得各控件
    oBEt    := TButton(Sender); //Et : Edit

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oBEt.Owner);
    oPEr    := TPanel(oForm.FindComponent(sPrefix+'PEr'));
    oBEL    := TButton(oForm.FindComponent(sPrefix+'BEL'));
    oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));
    oCKB    := TCheckBox(oForm.FindComponent(sPrefix+'CKB'));

    //空表检测
    if oQuery.IsEmpty then begin
        Exit;
    end;

    // dcEdit 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcEdit,oBEt.Tag,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;
    //
    oCKB.Visible  := False;

    //EL Edit Label
    oBEL.Caption   := '编  辑';

    //用 PEr 的tag来标记当前状态   0表示编辑 100表示新增
    oPEr.Tag   := 0;

    //更新字段值
    for iItem := 0 to joConfig.fields._Count-1 do begin  //此处需要避免多选列问题
        //得到字段JSON
        joField := joConfig.fields._(iItem);

        //取得当前JSON字段对应的数据表字段index
        iFieldId    := dwGetInt(joField,'fieldid',-1);

        //跳过非数据表列
        if iFieldId < 0 then begin
            continue;
        end;

        //查找字段对应的编辑控件
        oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iItem));

        //如果找到了控件（有可能因为view<>0的原因找不到）
        if oComp <> nil then begin
            //取字段的AsString，并清除其中的特殊字符串（如换行），备用
            sValue  := oQuery.Fields[iFieldId].AsString;
            sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
            sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

            //根据字段类型分类处理
            //------------------------ 4 BEt - Button Edit -------------------------------------------------------------
            if joField.type = 'auto' then begin                     //----- 1 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'boolean' then begin         //----- 2 -----
                oCB         := TComboBox(oComp);
                if LowerCase(sValue)='true' then begin
                    oCB.ItemIndex   := 1;
                end else begin
                    oCB.ItemIndex   := 0;
                end;

            end else if joField.type = 'button' then begin          //----- 3 -----

            end else if (joField.type = 'combo') then begin         //----- 4 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;

            end else if (joField.type = 'combopair') then begin     //----- 5 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if sValue <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(0) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(1);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'date' then begin            //----- 6 -----
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkDate;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iFieldId].AsDateTime;
                end;

            end else if joField.type = 'datetime' then begin        //----- 7 -----
                oDT         := TDateTimePicker(oComp);
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Date    := oQuery.Fields[iFieldId].AsDateTime;
                    oDT.Time    := oQuery.Fields[iFieldId].AsDateTime;
                end;

            end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;

            end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if sValue <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(0) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(1);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'dbtree' then begin          //----- 10 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
                oE          := TEdit(oComp);
                joList      := dcGetTreeListJson(joField.list);
                oE.Text     := dcGetTreeListView(joList,sValue);

            end else if joField.type = 'float' then begin           //----- 12 -----

            end else if joField.type = 'image' then begin           //----- 13 -----
                oI          := TImage(oComp);
                if joField.Exists('imgdir') then begin
                    sValue  := String(joField.imgdir) + sValue;
                end;
                oI.Hint     := '{"dwstyle":"border-radius:3px;","src":"'+sValue+'"}';

            end else if joField.type = 'index' then begin           //----- 13A -----
                //序号列, 不应该显示在编辑面板中

            end else if joField.type = 'integer' then begin         //----- 14 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'memo' then begin            //----- 15 -----
                oM          := TMemo(oComp);
                oM.Text     := sValue;

            end else if joField.type = 'money' then begin           //----- 16 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'string' then begin          //----- 17 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end else if joField.type = 'time' then begin            //----- 18 -----
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkTime;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Time    := oQuery.Fields[iFieldId].AsDateTime;
                end;

            end else if joField.type = 'tree' then begin            //----- 19 -----
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end else if joField.type = 'treepair' then begin        //----- 20 -----
                oE          := TEdit(oComp);
                joList      := dcGetTreeListJson(joField.list);
                oE.Text     := dcGetTreeListView(joList,sValue);
            end else begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;

            end;

            //设置只读（编辑时只读，新增时可编辑）
            if joField.type <> 'auto' then begin
                if joField.readonly = 1 then begin
                    TEdit(oComp).Enabled    := False;
                end;
            end;
        end;
    end;

    //
    //oPEr.Width      := oDBCard.Width;
    oPEr.Visible   := True;
end;

Procedure BEOClick(Self: TObject; Sender: TObject); //BEO : button Edit OK
var
    oButton     : TButton;
    oDBCard  : TPanel;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oFQTemp     : TFDQuery;
    oBEA        : TButton;
    oPEr        : TPanel;
    oE_Field    : TEdit;
    oM_Field    : TMemo;
    oDT_Field   : TDateTimePicker;
    oComp       : TComponent;
    oCB_Field   : TComboBox;
    oCKB        : TCheckBox;
    oMasterPanel: TPanel;
    oFDQuery    : TFDQuery;
    //
    iField      : Integer;
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    //
    bAccept     : Boolean;
    //
    sOldValue   : string;   //编辑前字段值，用于防重
    //
    joConfig    : variant;
    joField     : Variant;
    joMaster    : Variant;
    joInfo      : Variant;
    //
    sPrefix     : String;

    //
    procedure dcSaveData;
    var
        iiTmp   : integer;
    begin
        try
            //根据字段类型分类处理
            //------------------------ 3 BEK - Button Edit OK  ---------------------------------------------------------
            if joField.type = 'auto' then begin                     //----- 1 -----
                //Continue;

            end else if joField.type = 'boolean' then begin         //----- 2 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);

            end else if joField.type = 'button' then begin          //----- 3 -----
                //暂不支持

            end else if (joField.type = 'combo') then begin         //----- 4 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := oCB_Field.text;

            end else if (joField.type = 'combopair') then begin     //----- 5 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := '';
                if oCB_Field.Text <> '' then begin
                    for iiTmp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iiTmp)._(1) = oCB_Field.text then begin
                            oQuery.Fields[iFieldId].AsString  := joField.list._(iiTmp)._(0);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'date' then begin            //----- 6 -----
                oDT_Field   := TDateTimePicker(oComp);
                oQuery.Fields[iFieldId].AsDateTime    := oDT_Field.Date;

            end else if joField.type = 'datetime' then begin        //----- 7 -----
                oDT_Field   := TDateTimePicker(oComp);
                oQuery.Fields[iFieldId].AsDateTime    := oDT_Field.DateTime;

            end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := oCB_Field.text;

            end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
                oCB_Field   := TComboBox(oComp);
                oQuery.Fields[iFieldId].AsString  := '';
                if oCB_Field.Text <> '' then begin
                    for iiTmp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iiTmp)._(1) = oCB_Field.text then begin
                            oQuery.Fields[iFieldId].AsString  := joField.list._(iiTmp)._(0);
                            break;
                        end;
                    end;
                end;

            end else if joField.type = 'dbtree' then begin          //----- 10 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else if joField.type = 'float' then begin           //----- 12 -----

            end else if joField.type = 'image' then begin           //----- 13 -----

            end else if joField.type = 'index' then begin           //----- 13A -----

            end else if joField.type = 'integer' then begin         //----- 14 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsInteger := StrToIntDef(oE_Field.text,0);

            end else if joField.type = 'memo' then begin            //----- 15 -----
                oM_Field := TMemo(oComp);
                oQuery.Fields[iFieldId].AsString := oM_Field.text;

            end else if joField.type = 'money' then begin           //----- 16 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsFloat := StrToFloatDef(oE_Field.text,0);

            end else if joField.type = 'string' then begin          //----- 17 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;

            end else if joField.type = 'time' then begin            //----- 18 -----
                oDT_Field   := TDateTimePicker(oComp);
                oQuery.Fields[iFieldId].AsDateTime    := oDT_Field.Time;

            end else if joField.type = 'tree' then begin            //----- 19 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else if joField.type = 'treepair' then begin        //----- 20 -----
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;
            end else begin
                oE_Field := TEdit(oComp);
                oQuery.Fields[iFieldId].AsString := oE_Field.text;

            end;
        except

        end;
    end;
begin
    //编辑/新增面板的确定按钮事件

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEr        := TPanel(oForm.FindComponent(sPrefix+'PEr'));
    oBEA        := TButton(oForm.FindComponent(sPrefix+'BEA'));   //取消按钮，用于记录是否批量新增过
    oCKB        := TCheckBox(oForm.FindComponent(sPrefix+'CKB'));

    //取得Query备用
    oFQTemp     := TFDQuery(oDBCard.FindComponent(sPrefix+'FQTemp'));

    //用 PEr 的tag来标记当前状态 0表示编辑，100表示新增
    case oPEr.Tag of
        0 : begin   //编辑
            oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));

            //更新数值
            oQuery.Edit;
            for iField := 0 to joConfig.fields._Count -1 do begin

                //得到字段JSON对象
                joField := joConfig.fields._(ifield);

                //取得当前JSON字段对应的数据表字段index
                iFieldId    := dwGetInt(joField,'fieldid',-1);

                //跳过非数据表列
                if iFieldId < 0 then begin
                    continue;
                end;

                //保存当前字段值，以用于防重
                sOldValue   := oQuery.Fields[iFieldId].AsString;

                //
                oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    //将编辑框内的数据保存到数据表
                    dcSaveData;

                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iFieldId].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oFQTemp.Close;
                            if oQuery.Fields[iFieldId].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iFieldId].AsString;
                            end else begin
                                oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iFieldId].AsString+'''';
                            end;
                            oFQTemp.Open;

                            //根据当前字段是否更改分别处理
                            if sOldValue = oQuery.Fields[iFieldId].AsString then begin
                                if oFQTemp.Fields[0].AsInteger > 1 then begin
                                    //
                                    dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                    oQuery.Cancel;
                                    Exit;
                                end;
                            end else begin
                                if oFQTemp.Fields[0].AsInteger > 0 then begin
                                    //
                                    dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                    oQuery.Cancel;
                                    Exit;
                                end;
                            end;
                        end;
                    end;
                end;
            end;

            // dcPostBefore 事件
            bAccept := True;
            if Assigned(oDBCard.OnDragOver) then begin
                oDBCard.OnDragOver(oDBCard,nil,dcEditPostBefore,0,dsDragEnter,bAccept);
                if not bAccept then begin
                    Exit;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;
            //关闭伪窗体
            oPEr.Visible  := False;

            // dcPostAfter 事件
            bAccept := True;
            if Assigned(oDBCard.OnDragOver) then begin
                oDBCard.OnDragOver(oDBCard,nil,dcEditPostAfter,0,dsDragEnter,bAccept);
                if not bAccept then begin
                    Exit;
                end;
            end;

        end;
        100 : begin   //新增
            oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));
            //更新数值
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);

                //取得当前JSON字段对应的数据表字段index
                iFieldId    := dwGetInt(joField,'fieldid',-1);

                //跳过非数据表列
                if iFieldId < 0 then begin
                    continue;
                end;
                //
                oComp   := oForm.FindComponent(sPrefix+'F'+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    //将编辑框内的数据保存到数据表
                    dcSaveData;

                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iFieldId].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oFQTemp.Close;
                            if oQuery.Fields[iFieldId].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iFieldId].AsString;
                            end else begin
                                oFQTemp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iFieldId].AsString+'''';
                            end;
                            oFQTemp.Open;
                            if oFQTemp.Fields[0].AsInteger > 0 then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                Exit;
                            end;
                        end;
                    end;
                end;
            end;

            //如果有主表，则根据主表写入当前与主表关联的字段
            if joConfig.Exists('master') then begin
                joMaster    := joConfig.master;
                if joMaster.Exists('panel') and joMaster.Exists('masterfield') and joMaster.Exists('slavefield') then begin
                    //取得从表panel
                    oMasterPanel := TPanel(oForm.FindComponent(joMaster.panel));

                    //更新从表
                    if oMasterPanel <> nil then begin
                        //取得主表查询
                        oFDQuery    := dcGetFDQuery(oMasterPanel);

                        //根据主表更新从表
                        oQuery.FieldByName(String(joMaster.slavefield)).AsVariant
                                := oFDQuery.FieldByName(String(joMaster.masterfield)).AsVariant;
                    end;
                end;
            end;

            // dcNewBeforePost 事件
            bAccept := True;
            if Assigned(oDBCard.OnDragOver) then begin
                oDBCard.OnDragOver(oDBCard,nil,dcAppendPostBefore,0,dsDragEnter,bAccept);
                if not bAccept then begin
                    Exit;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;

            // dcNewAfterPost 事件
            bAccept := True;
            if Assigned(oDBCard.OnDragOver) then begin
                oDBCard.OnDragOver(oDBCard,nil,dcAppendPostAfter,0,dsDragEnter,bAccept);
                if not bAccept then begin
                    Exit;
                end;
            end;

            //如果选中的“批量录入”，则重新append, 否则关闭退出
            if oCKB.Checked then begin
                //做标记
                oBEA.Tag  := 999;

                //自动新增
                dcAppend(oDBCard,oQuery,joConfig.fields);
            end else begin
                //关闭伪窗体
                oPEr.Visible  := False;
            end;
        end;
    end;
    //更新显示（仅关闭编辑/新增面板时）
    if not oPEr.Visible then begin
        //恢复由于兼容达梦时的数据查询
        (*
                joInfo          := _json('{}');
                joInfo.recsmax  := AQuery.FetchOptions.RecsMax;
                joInfo.recsskip := AQuery.FetchOptions.RecsSkip;
                joInfo.sqltext  := AQuery.SQL.Text;
                oPEr            := TPanel(oForm.FindComponent(sPrefix+'PEr'));
                oPEr.Caption    := String(joInfo);
        *)
        joInfo  := _json(oPEr.Caption);
        if joInfo <> unassigned then begin
            oQuery.Disconnect();
            oQuery.Close;
            oQuery.FetchOptions.RecsMax     := joInfo.recsmax;
            oQuery.FetchOptions.RecsSkip    := joInfo.recsskip;
            oQuery.SQL.Text                 := joInfo.sqltext;
            oQuery.Open();
        end;
        dcUpdate(oDBCard,'');
    end;
end;

//筛选按钮
Procedure  BFiClick(Self: TObject; Sender: TObject);     //card中的过滤按钮的click事件
var
    oForm       : TForm;
    oBFi        : TButton;
    oPFi        : TPanel;
begin

    //主表新增事件
    //dwMessage('B_NewClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oBFi        := TButton(Sender);
    oForm       := TForm(oBFi.Owner);
    oPFi        := TPanel(oForm.FindComponent('PFi'));

    //显示过滤界面
    oPFi.Visible  := True;
end;

Procedure BtnClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oBtn        : TButton;
    oDBCard     : TPanel;   //总Panel
    //
    iTag        : Integer;
    iField      : Integer;
    iRecNo      : Integer;
    bAccept     : Boolean;
begin
    try
        //按钮click事件
        //dwMessage('B_NewClick','',TForm(TEdit(Sender).Owner));
        //取得各控件
        oBtn        := TButton(Sender);     //其中的tag = field序号 + RecNo 8 1000
        oForm       := TForm(oBtn.Owner);

        //取得源DBCard panel
        oDBCard     := dcGetDBCard(TControl(Sender));

        // 激活 事件:  控件点击事件
        bAccept := True;
        if Assigned(oDBCard.OnDragOver) then begin
            oDBCard.OnDragOver(oDBCard,nil,dcItemClick,oBtn.Tag,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;
    except

    end;
end;

Procedure ImgClick(Self: TObject; Sender: TObject);
var
    oImg        : TImage;
    oDBCard     : TPanel;   //总Panel
    oFDQuery    : TFDQuery;
    //
    sName       : String;
    iField      : Integer;
    bAccept     : Boolean;
begin
    //dwMessage('ImgClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oImg        := TImage(Sender);

    //取得源DBCard panel
    oDBCard     := dcGetDBCard(TControl(Sender));

    //
    oFDQuery    := dcGetFDQuery(oDBCard);

    //取得当前记录位置
    oFDQuery.RecNo  := TPanel(oImg.Parent).DesignInfo;

    //
    sName       := oImg.Name;
    while Pos('_',sName) > 0 do begin
        Delete(sName,1,Pos('_',sName));
    end;
    iField  := StrToIntDef(sName,-1);

    // 激活 事件:  控件点击事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcItemClick,iField,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;


end;



Procedure BNwClick(Self: TObject; Sender: TObject);
var
    oDBCard  : TPanel;
    oForm       : TForm;
    oBNw        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oQuery      : TFDQuery;
    oCKB        : TCheckBox;
    //
    joConfig    : Variant;
    //
    bAccept     : Boolean;
    //
    sPrefix     : String;
begin
    //主表新增事件

    //取得各控件
    oBNw    := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    // dcNew 事件  新增按钮点击事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcNew,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //取得配置JSON
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oBNw.Owner);
    oPEr    := TPanel(oForm.FindComponent(sPrefix+'PEr'));
    oBEL    := TButton(oForm.FindComponent(sPrefix+'BEL'));
    oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));
    oCKB    := TCheckBox(oForm.FindComponent(sPrefix+'CKB'));

    //批量处理
    oCKB.Visible  := True;

    //
    oBEL.Caption   := '新  增';

    //用 PEr 的tag来标记当前状态，0表示编辑，,100表示新增
    oPEr.Tag  := 100;

    //append前事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oForm,nil,0,1,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新字段值
    dcAppend(oDBCard, oQuery, joConfig.fields);

    //
    //oPEr.Width      := oDBCard.Width;
    oPEr.Visible    := True;
end;

Procedure BDeClick(Self: TObject; Sender: TObject);
var
    //
    bAccept     : Boolean;
    //
    oDBCard  : TPanel;
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oLabel      : TLabel;
    oQuery      : TFDQuery;
    //
    iField      : Integer;
    sInfo       : string;
    //
    joConfig    : Variant;
    //
    sPrefix     : String;
begin
    //主表的删除事件。
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
    oLabel  := TLabel(oForm.FindComponent(sPrefix+'LCF'));
    oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));

    //空表检测
    if oQuery.IsEmpty then begin
        Exit;
    end;

    // dcDelete 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcDelete,oButton.tag,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;



    //标志当前是主表，用面板的tag
    oPanel.Tag  := 0;

    //删除前提示当前行的信息
    sInfo   := '';
    for iField := 0 to Min(2,oQuery.FieldCount-1) do begin
        sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
    end;
    sInfo   := Copy(sInfo,1,Length(sInfo)-3);


    //删除主表删除弹框前事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oForm,nil,0,10,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    oLabel.Caption  := '确定要删除当前记录吗？'#13#13+sInfo;
    oPanel.Visible  := True;
end;

Procedure BQyClick(Self: TObject; Sender: TObject); //"查询"按钮
var
    oDBCard  : TPanel;
    oButton     : TButton;
    oForm       : TForm;
    oTbP        : TTrackBar;
    //
    sPrefix     : String;
    joConfig    : Variant;
	bAccept		: boolean;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    // dcQuery 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcQuery,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //取得配置JSON备用
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(oButton.Owner);
    oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));

    //设置为第1页
    oTbP.Position   := 0;

    //置标志，表示已查询，即当前查询条件有效
    TButton(Sender).Tag := 1;

    //更新数据
    dcUpdate(oDBCard,'');
end;

Procedure BRsClick(Self: TObject; Sender: TObject);     //button reset
var
    oDBCard  : TPanel;
    oButton     : TButton;
    oBQy        : TButton;
    oForm       : TForm;
    oPQF        : TPanel;
    oFQy        : TFlowPanel;
    oEQy        : TEdit;
    oMQy        : TMemo;
    oTbP        : TTrackBar;
    oCBQy       : TComboBox;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    //
    iItem       : Integer;
    iField      : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
    //
    sPrefix     : String;
	bAccept		: boolean;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));

    //取得控件,当前应为 BRs - Button Reset
    oButton     := TButton(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    // dcReset 事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcReset,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');


    //取得各控件
    oForm       := TForm(oButton.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));
    oTbP        := TTrackBar(oForm.FindComponent(sPrefix+'TbP'));
    oBQy        := TButton(oForm.FindComponent(sPrefix+'BQy'));


    //置标志，表示未处于查询状态，即当前查询条件无效
    oBQy.Tag    := 1;


    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //取得JSON配置
    joConfig    := dcGetConfig(oDBCard);

    //默认分页为第1页
    oTbP.Position   := 0;

    //
    for iItem := 0 to oFQy.ControlCount-1 do begin
        //得到每个字段的面板
        oPQF := TPanel(oFQy.Controls[iItem]);

        //取得字段序号
        iField      := oPQF.Tag;

        //如果 <0, 则表示为按钮组，跳出
        if iField < 0 then begin
            break
        end;

        //取得当前字段对象
        joField     := joConfig.fields._(iField);

        //根据字段类型分类处理
        //-------------------------------- 2 Button Reset --------------------------------------------------------------
        if joField.type = 'auto' then begin                     //----- 1 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'boolean' then begin         //----- 2 -----
            oCBQy       := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if joField.type = 'button' then begin          //----- 3 -----
            //不支持按钮查询

        end else if (joField.type = 'combo') then begin         //----- 4 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if (joField.type = 'combopair') then begin     //----- 5 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if joField.type = 'date' then begin            //----- 6 -----
            //取得起始结束日期控件
            oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
            oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);
            //
            if joField.Exists('min') then begin
                oDT_Start.Date  := StrToDateDef(joField.min,Now);
            end else begin
                oDT_Start.Date  := StrToDateDef('1900-01-01',Now);  //空值
            end;
            //
            if joField.Exists('max') then begin
                oDT_End.Date    := StrToDateDef(joField.max,Now);
            end else begin
                oDT_End.Date    := StrToDateDef('2500-12-31',Now);  //空值
            end;

        end else if joField.type = 'datetime' then begin        //----- 7 -----
            //暂不支持

        end else if (joField.type = 'dbcombo') then begin       //----- 8 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if (joField.type = 'dbcombopair') then begin   //----- 9 -----
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;

        end else if joField.type = 'dbtree' then begin          //----- 10 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'dbtreepair' then begin      //----- 11 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'float' then begin           //----- 12 -----
            //暂不支持

        end else if joField.type = 'image' then begin           //----- 13 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'index' then begin           //----- 13A -----
            //暂不支持

        end else if joField.type = 'integer' then begin         //----- 14 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'memo' then begin            //----- 15 -----
            oMQy        := TMemo(oPQF.Controls[1]);
            oMQy.Text   := '';

        end else if joField.type = 'money' then begin           //----- 16 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'string' then begin          //----- 17 -----
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';

        end else if joField.type = 'time' then begin            //----- 18 -----
            //暂不支持

        end else if joField.type = 'tree' then begin            //----- 19 -----
            //暂不支持

        end else if joField.type = 'treepair' then begin        //----- 20 -----
            //暂不支持

        end else begin
            oEQy        := TEdit(oPQF.Controls[1]);
            oEQy.Text   := '';
        end;
    end;

    dcUpdate(oDBCard,'');
end;

procedure CSoChange(Self: TObject; Sender: TObject);
var
    oDBCard  : TPanel;
begin
    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    //joConfig    := dcGetConfig(oDBCard);

    //
    dcUpdate(oDBCard,'');
end;

Procedure BUpClick(Self: TObject; Sender: TObject); //"图片上传"按钮 BUp - Button upload
var
    oButton     : TButton;
    oForm       : TForm;
    joHint      : Variant;
    iItem       : Integer;
    sImgDir     : String;
    sAccept     : String;
begin
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);

    joHint      := _json(oButton.Hint);

    if joHint = unassigned then begin
        dwMessage('error json when BUpClick','',oForm);
        Exit;
    end;

    if not joHint.Exists('imgdir') then begin
        dwMessage('error imgdir when BUpClick','',oForm);
        Exit;
    end;

    if not joHint.Exists('imgtype') then begin
        dwMessage('error imgtype when BUpClick','',oForm);
        Exit;
    end;

    //取得图片目录
    sImgDir := joHint.imgdir;

    //取得上传文件类型 accept
    sAccept := '';
    for iItem := 0 to joHint.imgtype._Count - 1 do begin
        sAccept := sAccept + '.'+joHint.imgtype._(iItem)+',';
    end;
    if Length(sAccept)>0 then begin
        Delete(sAccept,Length(sAccept),1);
    end;

    //上传前将upload上传事件转移到当前控件中
    dwSetUploadTarget(oForm,TButton(Sender));

    //开始上传
    dwUpload(oForm, sAccept, sImgDir);

end;

//上传完成事件
procedure BUpEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    oDBCard  : TPanel;
    oButton     : TButton;
    oImage      : TImage;
    oQuery      : TFDQuery;
    sFile       : String;
    sSource     : String;
    sDir        : String;
    sPrefix     : string;
    //
    joConfig    : Variant;
    joHint      : Variant;
begin
    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oButton := TButton(Sender);
    oQuery  := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));

    //取得上传完成后的文件名和源文件名
    sFile   := dwGetProp(oButton,'__upload');
    sSource := dwGetProp(oButton,'__uploadsource');

    //取得当前按钮的JSON
    joHint  := _json(oButton.Hint);

    //将上传完成的文件改重命名为源文件名
    sDir        := ExtractFilePath(Application.ExeName)+String(joHint.imgdir);
    //RenameFile(sDir+sFile,sDir+sSource);

    //显示
    oImage      := TImage(oButton.Parent.Controls[0]);
    oImage.Hint := '{"src":"'+joHint.imgdir+sFile+'"}';

    //保存数据
    oQuery.Edit;
    oQuery.FieldByName(joHint.name).AsString    := sFile;

    //
    if joConfig.Exists('uploadsuccess') then begin
        dwMessage(joConfig.uploadsuccess, 'success',TForm(oButton.Owner));
    end;
end;


//数据表点击
//panel cards
Procedure PCsEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    oForm       : TForm;
    oDBCard  : TPanel;

    //
    sPrefix     : String;
    //
    joConfig    : Variant;
begin
    //此处主要处理按钮列的事件

    //取得列、行和按钮序号
    //iCol        := X mod 1000;
    //iRow        := Y;
    //iButtonID   := X div 1000;
    //

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(oDBCard.Owner);

    if Y = 0 then begin
        dwMessage('top','success',oForm);
    end else if Y = 9 then begin
        dwMessage('bottom','success',oForm);
    end;
end;


procedure BGFButtonClicked(Self: TObject; Sender: TObject; Index: Integer);
var
    oBGF        : TButtonGroup;
    oForm       : TForm;
    oCFi        : TCardpanel;
begin
    //取得各对象
    oBGF        := TButtonGroup(Sender);
    oForm       := TForm(oBGF.Owner);
    oCFi        := TCardPanel(oForm.FindComponent('CFi'));

    oCFi.ActiveCardIndex    := Index;
end;

procedure BFRClick(Self: TObject; Sender: TObject);     //button filter reset
var
    oButton     : TButton;
    oDBCard  : TPanel;
    oForm       : TForm;
    oPFi        : TPanel;
    oTbP        : TTrackBar;
    oCFi        : TCardPanel;
    oCF         : TCard;
    oFF         : TFlowpanel;
    oBF         : TButton;
    iItem       : Integer;
    iCtrl       : Integer;
begin
    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    //
    oPFi        := TPanel(oForm.FindComponent('PFi'));
    oCFi        := TCardPanel(oForm.FindComponent('CFi'));
    oTbP        := TTrackBar(oForm.FindComponent('TbP'));

    //置所有选项未选中状态
    for iItem := 0 to OCFi.CardCount - 1 do begin
        oCF     := oCFi.Cards[iItem];
        oFF     := TFlowPanel(oCF.Controls[0]);
        for iCtrl := 0 to oFF.ControlCount - 1 do begin
            oBF := TButton(oFF.Controls[iCtrl]);
            //
            oBF.Tag := 0;
            dwSetCtrlColor(oBF,clBlack);
            dwSetCtrlBKColor(oBF,$F6F6F6);
            dwSetCtrlBorder(oBF,'0');
        end;
    end;

    //
    oPFi.Visible    := False;
    oPFi.Tag        := 0;

    //
    oTbP.Position   := 0;

    //更新数据
    dcUpdate(oDBCard,'');
end;


//筛选确定事件
procedure BFOClick(Self: TObject; Sender: TObject);     //button filter OK
var
    oButton     : TButton;
    oForm       : TForm;
    oPFi        : TPanel;
    oTbp        : TTrackBar;
    oDBCard     : TPanel;
begin
    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    //
    oPFi        := TPanel(oForm.FindComponent('PFi'));
    oTbP        := TTrackBar(oForm.FindComponent('TbP'));

    //
    oPFi.Visible    := False;
    oPFi.Tag        := 1;

    //
    oTbP.Position   := 0;
    //
    dcUpdate(oDBCard,'');
end;


procedure BFxClick(Self: TObject; Sender: TObject);
var
    oBFx        : TButton;
    sFull       : String;
begin
    oBFx        := TButton(Sender);
    sFull       := dwFullName(oBFx);
    //
    if oBFx.Tag = 0 then begin
        oBFx.Tag    := 1;   //标志选中
        dwSetCtrlColor(oBFx,clRed);
        dwSetCtrlBKColor(oBFx,$E8EBFF);
        dwSetCtrlBorder(oBFx,'solid 1px #f00');
    end else begin
        oBFx.Tag    := 0;   //标志未选中
        dwSetCtrlColor(oBFx,clBlack);
        dwSetCtrlBKColor(oBFx,$F6F6F6);
        dwSetCtrlBorder(oBFx,'0');
    end;
end;

procedure FPsResize(Self: TObject; Sender: TObject);    //FlowPanel of panels Resize
var
    iItem       : Integer;
    //
    oFPs        : TFlowPanel;
    oPanel      : TPanel;
    oDBCard  : TPanel;
    oForm       : TForm;
    oEKw        : TEdit;
    //
    joConfig    : Variant;
    //
    sPrefix     : String;
begin
    oFPs        := TFlowPanel(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);


	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oForm       := TForm(oFPs.Owner);
    oEKw        := TEdit(oForm.FindComponent(sPrefix+'EKw'));

    //
    for iItem := 0 to oFPs.ControlCount - 1 do begin
        oPanel  := TPanel(oFPs.Controls[iItem]);
        if oPanel.Width > oFPs.Width - oPanel.Margins.Left - oPanel.Margins.Right then begin
            oPanel.Width    := oFPs.Width - oPanel.Margins.Left - oPanel.Margins.Right - 5;  //-5主要是滚动条位置
        end;
    end;

    //
    if oEKw.Width > oFPs.Width - oPanel.Margins.Left - oPanel.Margins.Right then begin
        oEKw.Width  := oFPs.Width - oPanel.Margins.Left - oPanel.Margins.Right - 15;  //-3主要是滚动条位置
    end;

end;

//卡片点击事件, 1 先将当前数据库记录跳转后指定位置
procedure PCdClick(Self: TObject; Sender: TObject);
var
    //
    oDBCard  : TPanel;
    oPanel      : TPanel;
    oQuery      : TFDQuery;
    //
    joConfig    : Variant;
    //
    sPrefix     : String;
begin
    //取得各控件
    oPanel      := TPanel(Sender);

    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //取得各控件
    oQuery      := TFDQuery(oDBCard.FindComponent(sPrefix+'FQMain'));

    //空表检测
    if oQuery.IsEmpty then begin
        Exit;
    end;

    //
    oQuery.RecNo    := oPanel.Tag+1;

    //触发crud panel的DblClick事件
    if Assigned(oDBCard.OnDblClick) then begin
        oDBCard.OnDblClick(oDBCard);
    end;
end;



Procedure TbPChange(Self: TObject; Sender: TObject);    //TbP TrackBar page
var
	bAccept		: boolean;
    sPrefix     : String;
    //
    oDBCard     : TPanel;
    oTbP        : TTrackBar;
    //
    joConfig    : Variant;
begin
    //取得源crud panel
    oDBCard  := dcGetDBCard(TControl(Sender));

    //取得JSON配置
    joConfig    := dcGetConfig(oDBCard);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oTbP        := TTrackBar(sender);

    //append事件
    bAccept := True;
    if Assigned(oDBCard.OnDragOver) then begin
        oDBCard.OnDragOver(oDBCard,nil,dcPageNo,oTbP.Position,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //更新数据
    dcUpdate(dcGetDBCard(TControl(Sender)),'');
end;

procedure dcCreateConfirmPanel(APanel:TPanel);
var
    oForm       : TForm;
    oPDe        : TPanel;
    oLCF        : TLabel;
    oBDO        : TButton;
    oBDC        : TButton;
    //用于指定事件
    tM          : TMethod;
    sPrefix     : String;
    joConfig    : Variant;
begin
    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    oPDe   := TPanel.Create(oForm);
    with oPDe do begin
        Name        := sPrefix + 'PDe';
        Parent      := APanel;
        HelpKeyword := 'modal';
        Visible     := False;
        //BorderStyle := bsSingle;
        Top         := 150;
        Width       := 340;
        Height      := 200;
        Hint        := '{"radius":"10px"}';
        Font.Color  := $323232;
    end;
    //
    oLCF  := TLabel.Create(oForm);
    with oLCF do begin
        Name        := sPrefix + 'LCF';
        Parent      := oPDe;
        AutoSize    := False;
        Alignment   := taCenter;
        Top         := 10;
        Left        := 10;
        Width       := 320;
        Height      := 130;
        Caption     := 'Are you sure ?';
        Layout      := tlCenter;
    end;
    //
    oBDO  := TButton.Create(oForm);
    with oBDO do begin
        Name        := sPrefix + 'BDO';
        Parent      := oPDe;
        Top         := 140;
        Left        := 170;
        Width       := 170;
        Height      := 60;
        Caption     := '确定';
        Font.Size   := 14;
        Hint        := '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border-right:0px;","radius":"0px"}';
        //
        tM.Code         := @BDOClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
    //
    oBDC  := TButton.Create(oForm);
    with oBDC do begin
        Name        := sPrefix + 'BDC';
        Parent      := oPDe;
        Top         := 140;
        Left        := 0;
        Width       := 170;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '取消';
        Hint        := '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":"0px"}';
        //
        tM.Code         := @BDCClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;
end;



procedure dcCreateFilterPanel(APanel:TPanel;AFilter:Variant);
type
    TdwButtonClicked = procedure (Sender: TObject; AIndex: Integer) of object;
var
    oForm       : TForm;
    oPBs        : TPanel;       //panel buttons
    oPFi        : TPanel;       //panel filter 总Panel
    oBGF        : TButtonGroup; //buttongroup filter 左侧分字段栏
    oCFi        : TCardPanel;   //cardpanel filter
    oCF         : TCard;        //
    oFF         : TFlowPanel;   //flowpanel filter , 用于容纳筛选项
    oBF         : TButton;      //button filter    筛选项
    oFFB        : TFlowPanel;   //Flowpanel filter buttons  重置/确定按钮的外面板
    oBFR        : TButton;      //button filter reset  重置
    oBFO        : TButton;      //button filter ok  确定
    //
    iList       : Integer;
    iItem       : Integer;
    //
    sPrefix     : String;
    //
    joConfig    : Variant;
    joFilter    : Variant;
    //用于指定事件
    tM          : TMethod;
begin

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得配置JSON
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //
    oPBs        := TPanel(oForm.FindComponent(sPrefix+'PBs'));

    //筛选总面板
    oPFi    := TPanel.Create(oForm);
    with oPFi do begin
        Name            := 'PFi';
        Parent          := APanel;
        HelpKeyword     := 'popup';
        Visible         := False;
        BevelOuter      := bvNone;
        BorderStyle     := bsNone;
        Anchors         := [akBottom,akTop,akleft,akRight];
        Font.Size       := 9;
        Top             := oPBs.Top + oPBs.Height;
        Height          := oForm.Height - Top - 50;
        Hint            := '{"radius":"0 0 10px 10px","dwstyle":"border-bottom: solid 1px #aaa;"}';
        //Font.Color      := $606060;
        Color           := clWhite;
        Width           := oForm.width;
    end;

    //字段分栏
    oBGF    := TButtonGroup.Create(oForm);
    with oBGF do begin
        Name            := 'BGF';
        Parent          := oPFi;
        Align           := alLeft;
        Width           := 100;
        ButtonHeight    := 50;
        HelpKeyword     := 'category';
        Hint            := '{"hot":"#f00","activecolor":"#f00","normalcolor":"#888"}';
        //
        tM.Code         := @BGFButtonClicked;
        tM.Data         := Pointer(325); // 随便取的数
        OnButtonClicked := TdwButtonClicked(tM);
        //
        for iItem := 0 to AFilter._Count - 1 do begin
            with Items.Add do begin
                Name    := 'BG'+IntToStr(iItem);
                Caption := AFilter._(iItem).caption;
            end;
        end;
    end;

    //字段分栏面板容器
    oCFi  := TCardPanel.Create(oForm);
    with oCFi do begin
        Name            := 'CFi';
        Parent          := oPFi;
        Align           := alClient;
        Width           := 60;
        BevelOuter      := bvNone;
        //
        for iItem := 0 to AFilter._Count - 1 do begin
            //
            joFilter    := AFilter._(iItem);

            //
            oCF := CreateNewCard;
            with oCF do begin
                Name        := 'CF'+IntToStr(joFilter.index);
                Color       := clWhite;
                BevelOuter  := bvNone;
                Caption     := joFilter.name;   //将字段名称保存到caption中，以便后面获取筛选WHERE

                //
                oFF := TFlowPanel.Create(oForm);
                with oFF do begin
                    Parent      := oCF;
                    Name        := 'FF'+IntToStr(joFilter.index);
                    Color       := clWhite;
                    BevelOuter  := bvNone;
                    Align       := alClient;
                    HelpKeyword := 'auto';

                    HelpContext := 10003;
                end;

                //
                for iList := 0 to joFilter.list._Count - 1 do begin
                    oBF := TButton.Create(oForm);
                    with oBF do begin
                        Parent          := oFF;
                        Name            := 'BF'+IntToStr(joFilter.index)+'_'+IntToStr(iList);
                        Caption         := String(joFilter.list._(iList));
                        Hint            := '{"style":"round","dwstyle":"background:#F6F6F6;border:0;"}';
                        Width           := 60;
                        Height          := 28;
                        AlignWithMargins:= True;
                        Margins.Top     := 10;
                        Margins.Bottom  := 10;
                        Margins.Left    := 10;
                        Margins.Right   := 10;


                        //
                        tM.Code         := @BFxClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;
                end;
            end;
        end;

        //
        ActiveCardindex := 0;
    end;

    //用于放置 OK/Cancel 的Panel
    oFFB    := TFlowPanel.Create(oForm);
    with oFFB do begin
        Name            := 'PFB';
        Parent          := oPFi;
        Helpkeyword     := 'auto';
        HelpContext     := 10002;
        BevelOuter      := bvNone;
        BorderStyle     := bsNone;
        Align           := alBottom;
        Height          := 50;
        Color           := clWhite;
    end;

    //
    oBFR  := TButton.Create(oForm);
    with oBFR do begin
        Name            := 'BFR';
        Parent          := oFFB;
        Align           := alLeft;
        //Width           := oFFB.Width div 2;
        Top             := 0;
        Left            := 0;
        Height          := 30;
        Caption         := '重置';
        Hint            := '{"style":"round","dwstyle":"background:transparent;border:solid 1px #f00;"}';
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 10;
        Margins.Left    := 30;
        Margins.Right   := 20;

        //
        tM.Code         := @BFRClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oBFO  := TButton.Create(oForm);
    with oBFO do begin
        Name            := 'BFO';
        Parent          := oFFB;
        //Align           := alClient;
        Width           := 80;
        Top             := 0;
        Left            := 0;
        Height          := 30;
        Caption         := '确定';
        Hint            := '{"style":"round","type":"danger","dwstyle":"background:#f00;border:0;"}';
        AlignWithMargins:= True;
        Margins.Top     := 10;
        Margins.Bottom  := 10;
        Margins.Left    := 20;
        Margins.Right   := 30;
        //
        tM.Code         := @BFOClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;


end;

procedure dcCreateField(APanel:TPanel;AWidth:Integer;ASuffix:String;AConfig,AField:Variant;AP_Content:TPanel;const AMobile:Boolean=False);
type
    TdwEndDock  = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    oForm       : TForm;
    oP          : TPanel;
    oPIn        : TPanel;
    oL          : TLabel;
    oE          : TEdit;
    oM          : TMemo;
    oI          : TImage;
    oB          : TButton;
    oDT         : TDateTimePicker;
    oCB         : TComboBox;
    //
    iItem       : Integer;
    //
    joList      : Variant;
    //joItems     : Variant;
    //
    sPrefix     : String;
    joConfig    : Variant;
    //
    tM,tM1      : TMethod;
begin
    oE      := nil;
    oDT     := nil;
    oM      := nil;
    oPIn    := nil;
    oCB     := nil;

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //标题默认为field.name
    if not AField.Exists('caption') then begin
        AField.caption  := String(AField.name);
    end;

    //取得Form
    oForm   := TForm(APanel.Owner);

    //字段容器Panel
    oP      := TPanel.Create(oForm);
    with oP do begin
        Name        := sPrefix + 'PF'+ASuffix;
        Parent      := AP_Content;
        Align       := alTop;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        AutoSize    := False;
        Height      := 46;
        Width       := AWidth;
        Color       := clNone;
        Font.Size   := 11;
        Top         := 10000;

        //适配移动端
        if AMobile then begin
            Height      := 35+30;
        end;
    end;
    //字段的标签 在容器左边
    oL      := TLabel.Create(oForm);
    with oL do begin
        Name            := sPrefix + 'LF'+ASuffix;
        Parent          := oP;
        AutoSize        := False;
        Align           := alLeft;
        Alignment       := taLeftJustify;
        Width           := dwGetInt(joConfig,'labelwidth',60);
        AlignWithMargins:= True;
        Margins.Top     := 0;
        Margins.Left    := 10;
        Margins.Right   := 15;
        Layout          := tlCenter;
        if dwGetInt(AField,'must',0) = 1 then begin
            Caption         := '*&nbsp;'+StringReplace(AField.caption,'\n','',[rfReplaceAll]);
        end else begin
            Caption         := StringReplace(AField.caption,'\n','',[rfReplaceAll]);
        end;

        //适配移动端
        if AMobile then begin
            Align       := alTop;
            Height      := 25;
            Margins.SetBounds(25,0,20,0);
        end;
    end;

    //各字段编辑控件
    //根据字段类型分类处理
    //------------------------ 5 dcCreateField --------------------------------------------------------------------------
    if AField.type = 'auto' then begin                     //----- 1 -----
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            Enabled         := False;
        end;

    end else if AField.type = 'boolean' then begin         //----- 2 -----
        oCB := TComboBox.Create(oForm);
        with oCB do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            if AField.Exists('list') then begin
                joList  := AField.list;
                //添加选项
                for iItem := 0 to Min(1,joList._Count-1) do begin
                    Items.Add(joList._(iItem));
                end;
            end else begin
                Items.Add('False');
                Items.Add('True');
            end;
        end;

    end else if AField.type = 'button' then begin          //----- 3 -----

    end else if (AField.type = 'combo') then begin         //----- 4 -----
        oCB := TComboBox.Create(oForm);
        with oCB do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            if AField.Exists('list') then begin
                joList  := AField.list;
                //默认添加一个空值
                if joList._Count > 0 then begin
                    if joList._(0) <> '' then begin
                        Items.Add('');
                    end;
                end;
                //添加选项
                for iItem := 0 to joList._Count-1 do begin
                    Items.Add(joList._(iItem));
                end;
            end else begin
                Items.Add('');
            end;
        end;

    end else if (AField.type = 'combopair') then begin     //----- 5 -----
        oCB := TComboBox.Create(oForm);
        with oCB do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            //
            Items.Add('');

            //添加数据库内的值
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(1));
            end;
        end;

    end else if AField.type = 'date' then begin            //----- 6 -----
        oDT    := TDateTimePicker.Create(oForm);
        with oDT do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;

    end else if AField.type = 'datetime' then begin        //----- 7 -----
        oDT    := TDateTimePicker.Create(oForm);
        with oDT do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;

    end else if (AField.type = 'dbcombo') then begin       //----- 8 -----
        oCB := TComboBox.Create(oForm);
        with oCB do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            Items.Add('');

            //添加数据库内的值
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;

    end else if (AField.type = 'dbcombopair') then begin   //----- 9 -----
        oCB := TComboBox.Create(oForm);
        with oCB do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint        := '{"height":34}';
            //
            Items.Add('');

            //添加数据库内的值
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(1));
            end;
        end;

    end else if AField.type = 'dbtree' then begin          //----- 10 -----
        //
        oP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'treelist','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;

    end else if AField.type = 'dbtreepair' then begin      //----- 11 -----
        //
        oP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'treelist','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;

    end else if AField.type = 'float' then begin           //----- 12 -----
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '0.00';
            Color           := clNone;
            //
            if AField.Exists('min') then begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end else begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end;
            end else begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end else begin

                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end;
            end;
        end;

    end else if AField.type = 'image' then begin           //----- 13 -----
        oPIn    := TPanel.Create(oForm);
        with oPIn do begin
            Name            := sPrefix + 'PI'+ASuffix;
            Align           := alClient;
            Parent          := oP;
            BevelOuter      := bvNone;
            BorderStyle     := bsNone;
            AutoSize        := False;
            Color           := clNone;
            Hint            := '{"dwstyle":"border:solid 1px rgb(220, 223, 230);border-radius:3px;"}';
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 5;
            Margins.Top     := 5;
        end;
        //先显示一个图片
        oI := TImage.Create(oForm);
        with oI do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oPIn;
            Align           := alLeft;
            AlignWithMargins:= True;
            Margins.left    := 1;
            Margins.Right   := 1;
            Margins.Bottom  := 3;
            Margins.Top     := 1;
            Width           := 34;
            Stretch         := True;
            Proportional    := True;
            Hint            := '{"dwstyle":"border-radius:3px;"}';
            //是否预览
            IncrementalDisplay  := dwGetInt(AField,'preview')=1;
        end;

        //添加一个上传按钮
        oB := TButton.Create(oForm);
        with oB do begin
            Name            := sPrefix + 'FB'+ASuffix;
            Parent          := oPIn;
            Align           := alRight;
            AlignWithMargins:= True;
            Margins.Right   := 3;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Width           := 34;
            Cancel          := True;
            Font.Color      := rgb(192, 196, 204);
            Caption         := '';
            Hint            := '{'
                    +'"icon":"el-icon-upload2"'
                    +',"type":"text"'
                    +',"name":"'+AField.name+'"'
                    +',"imgdir":"'+dwGetStr(AField,'imgdir','media/images/temp/')+'"'
                    +',"imgtype":'+dwGetStr(AField,'imgtype','["jpg","png","bmp","gif"]')
                    +'}';
            //
            tM.Code         := @BUpClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
            //
            tM1.Code        := @BUpEndDock;
            tM1.Data        := Pointer(325); // 随便取的数
            OnEndDock       := TdwEndDock(tM1);
        end;

    end else if AField.type = 'index' then begin           //----- 13A -----
        //序号列

    end else if AField.type = 'integer' then begin         //----- 14 -----
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '0.00';
            Color           := clNone;
            //
            if AField.Exists('min') then begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end else begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end;
            end else begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end else begin

                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end;
            end;
        end;

    end else if AField.type = 'memo' then begin            //----- 15 -----
        oM := TMemo.Create(oForm);
        with oM do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":""}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;

            //设置高度(仅memo类型)
            if AField.Exists('height') then begin
                oP.Height   := AField.height;
            end;
        end;

    end else if AField.type = 'money' then begin           //----- 16 -----
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '0.00';
            Color           := clNone;
            //
            if AField.Exists('min') then begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end else begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        ' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end;
            end else begin
                if AField.Exists('max') then begin
                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        ' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';

                end else begin

                    Hint        := '{'+
                                    '"dwattr":"'+
                                        'type=\"number\"'+
                                        ' step=\"0.01\"'+
                                        //' onkeyup=\"value=value.match(/\d+\.?\d{0,2}/,'''')\"'+
                                        //' min=\"'+IntToStr(AField.min)+'\"'+
                                        //' max=\"'+IntToStr(AField.max)+'\"'+
                                    '",'+
                                    ' "dwstyle":""'+
                                    '}';
                end;
            end;
        end;

    end else if AField.type = 'string' then begin          //----- 17 -----
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":""}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;

    end else if AField.type = 'time' then begin            //----- 18 -----
        oDT    := TDateTimePicker.Create(oForm);
        with oDT do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            Kind            := dtkTime;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;

    end else if AField.type = 'tree' then begin            //----- 19 -----
        //
        oP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;

    end else if AField.type = 'treepair' then begin        //----- 20 -----
        //
        oP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;

    end else begin
        oE := TEdit.Create(oForm);
        with oE do begin
            Name            := sPrefix + 'F'+ASuffix;
            Parent          := oP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":""}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;

    end;

    //适配移动端
    if AMobile then begin
        if oE <> nil then begin
            with oE do begin
                Align       := alTop;
                Top         := 10000;
                Margins.SetBounds(20,0,20,10);
            end;
        end;
        if oDT <> nil then begin
            with oDT do begin
                Align       := alTop;
                Top         := 10000;
                Margins.SetBounds(20,0,20,10);
            end;
        end;
        if oM <> nil then begin
            with oM do begin
                Align       := alTop;
                Top         := 10000;
                Margins.SetBounds(20,0,20,10);
            end;
        end;
        if oPIn <> nil then begin
            with oPIn do begin
                Align       := alTop;
                Top         := 10000;
                Margins.SetBounds(20,0,20,10);
            end;
        end;
        if oCB <> nil then begin
            with oCB do begin
                Align       := alTop;
                Top         := 10000;
                Margins.SetBounds(20,0,20,10);
                Hint        := '{"height":28}';
            end;
        end;
    end;
end;

function  dcCreateFieldQuery(APanel:TPanel;AField:Variant;AIndex:Integer;ASuffix:String;AFlowPanel:TFlowPanel):Integer;
var
    oForm       : TForm;
    oPQF        : TPanel;
    oL_Query    : TLabel;
    oCBQy       : TComboBox;
    oP_DateSE   : TPanel;
    oDT_Start   : TDateTimePicker;
    oL_Space    : TLabel;
    oDT_End     : TDateTimePicker;
    oE_Query    : TEdit;
    //
    iItem       : Integer;
    //
    joConfig    : Variant;
    //
    sTable      : String;
    sTemp       : String;
    sPrefix     : String;
begin
    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

	//取得Form备用
	oForm       := TForm(APanel.Owner);

    //创建一个单字段查询面板
    oPQF := TPanel.Create(oForm);
    with oPQF do begin
        Name            := sPrefix + 'PQ'+ASuffix;
        Parent          := AFlowPanel;
        Color           := clNone;
        Width           := joConfig.editwidth - 15 ;
        Height          := 45;
        Tag             := AIndex;
        Hint            := '{"dwstyle":"overflow:visible;"}';
    end;
    //创建查询字段标签
    oL_Query    := TLabel.Create(oForm);
    with oL_Query do begin
        Name            := sPrefix + 'LQ'+ASuffix;
        Parent          := oPQF;
        Tag             := AIndex;
        Align           := alLeft;
        Layout          := tlCenter;
        if AField.Exists('caption') then begin
            Caption         := AField.caption ;
        end else begin
            Caption         := AField.name ;
        end;
        Alignment       := taRightJustify;
        Width           := 80;
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
        Margins.Bottom  := 10;
    end;

    //------------------ 6  dcCreateFieldQuery --------------------------------------------------------------------------
    if AField.type = 'auto' then begin                     //----- 1 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'boolean' then begin         //----- 2 -----
        //创建查询字段控件
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alClient;
            Style               := csDropDownList;
            Text                := '';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 10;

            //默认添加一个空值
            if AField.list._Count > 0 then begin
                if AField.list._(0) <> '' then begin
                    Items.Add('');
                end;
            end;
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;

    end else if AField.type = 'button' then begin          //----- 3 -----

    end else if (AField.type = 'combo') then begin         //----- 4 -----
        //创建查询字段控件
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alClient;
            Style               := csDropDownList;
            Text                := '';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 10;

            //默认添加一个空值
            if AField.list._Count > 0 then begin
                if AField.list._(0) <> '' then begin
                    Items.Add('');
                end;
            end;
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;

    end else if (AField.type = 'combopair') then begin     //----- 5 -----
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alClient;
            Style               := csDropDownList;
            Text                := '';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 10;

            //默认添加一个空值
            Items.Add('');
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(1));
            end;
        end;

    end else if AField.type = 'date' then begin            //----- 6 -----
        //创建面板存放起始结束日期
        oP_DateSE := TPanel.Create(oForm);
        with oP_DateSE do begin
            Name            := sPrefix + 'PDE'+ASuffix;
            Parent          := oPQF;
            Color           := clNone;
            Align           := alClient;
            Tag             := AIndex;
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
            //
            AlignWithMargins:= True;
            Margins.Top     := 4;
            Margins.Bottom  := 8;
            Margins.Right   := 0;
        end;
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(oForm);
        with oDT_Start do begin
            Name        := sPrefix + 'DS'+ASuffix;
            Parent      := oP_DateSE;
            Align       := alLeft;
            Tag         := AIndex;
            Width       := 135;
            Height      := 28;
            if AField.Exists('min') then begin
                Date        := StrToDateDef(AField.min,Now);
            end else begin
                Date        := StrToDateDef('1900-01-01',Now);;
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;
        //起止日期间分隔符
        oL_Space    := TLabel.Create(oForm);
        with oL_Space do begin
            Name        := sPrefix + 'LS'+ASuffix;
            Parent      := oP_DateSE;
            Tag         := AIndex;
            AutoSize    := False;
            Alignment   := taCenter;
            Left        := 105;
            Top         := 5;
            Caption     := '—';
            Width       := 20;
        end;
        //创建查询结束日期
        oDT_End   := TDateTimePicker.Create(oForm);
        with oDT_End do begin
            Parent      := oP_DateSE;
            Name        := sPrefix + 'DE'+ASuffix;
            Tag         := AIndex;
            Left        := 120;
            Top         := 1;
            Width       := 135;
            Height      := 28;
            if AField.Exists('max') then begin
                Date    := StrToDateDef(AField.max,Now);
            end else begin
                Date    := StrToDateDef('2500-12-31',Now);;
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

    end else if AField.type = 'datetime' then begin        //----- 7 -----
        //<-----创建起始日期时间
        //设置默认值
        if not AField.Exists('min') then begin
            AField.min := '2000-01-01 00:00:00'
        end;
        //更新标签
        oL_Query.Caption    := AField.caption + '>=';
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(oForm);
        with oDT_Start do begin
            Name            := sPrefix + 'DS'+ASuffix;
            Parent          := oPQF;
            Align           := alClient;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            Format          := 'yyyy-MM-dd HH:mm:ss';
            Tag             := AIndex;
            Height          := 28;
            HelpContext     := 1;  //标记为起始时间
            Date            := StrToDateDef(Copy(AField.min,1,10),Now);
            Time            := StrToTimeDef(Copy(AField.min,12,8),Now);
            Hint            := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
                            //+',"dwattr":"format=\"yyyy-MM-dd HH:mm:ss\" :type=\"datetime\""}';
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
        end;
        //----->

        //<-----创建结束日期时间
        //默认值
        if not AField.Exists('max') then begin
            AField.max := '2050-01-01 00:00:00';
        end;
        //创建一个单字段查询面板
        oPQF := TPanel.Create(oForm);
        with oPQF do begin
            Name            := sPrefix + 'PDT'+ASuffix;
            Parent          := AFlowPanel;
            Color           := clNone;
            Width           := 335;
            Height          := 40;
            Tag             := AIndex;
        end;
        //创建查询字段标签
        oL_Query    := TLabel.Create(oForm);
        with oL_Query do begin
            Name        := sPrefix + 'LQE'+ASuffix;
            Parent      := oPQF;
            Tag         := AIndex;
            Align       := alLeft;
            Layout      := tlCenter;
            Caption     := AField.caption + '<=';
            Alignment   := taRightJustify;
            Width       := 80;
            //
            AlignWithMargins    := True;
            Margins.Left        := 10;
        end;
        //

        //创建查询结束日期
        oDT_End := TDateTimePicker.Create(oForm);
        with oDT_End do begin
            Name            := sPrefix + 'DE'+ASuffix;
            Parent          := oPQF;
            Align           := alClient;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            Format          := 'yyyy-MM-dd HH:mm:ss';
            Tag             := AIndex;
            Height          := 28;
            HelpContext     := -1;  //标记为结束时间
            Date            := StrToDateDef(Copy(AField.max,1,10),Now);
            Time            := StrToTimeDef(Copy(AField.max,12,8),Now);
            Hint            := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
                            //+',"dwattr":"format=\"yyyy-MM-dd HH:mm:ss\" :type=\"datetime\""}';
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;
        //----->

    end else if (AField.type = 'dbcombo') then begin       //----- 8 -----
        //创建数据库查询ComboBox
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Style           := csDropDownList;
            Text            := '';
            Align           := alClient;
            //
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;

            //默认添加一个空值
            Items.Add('');
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem));
            end;
        end;

    end else if (AField.type = 'dbcombopair') then begin   //----- 9 -----
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(oForm);
        with oCBQy do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            Style           := csDropDownList;
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

            //默认添加一个空值
            Items.Add('');

            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(1));
            end;
        end;

    end else if AField.type = 'dbtree' then begin          //----- 10 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oPQF;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

        end;
    end else if AField.type = 'dbtreepair' then begin      //----- 11 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oPQF;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

        end;

    end else if AField.type = 'float' then begin           //----- 12 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'image' then begin           //----- 13 -----
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'index' then begin           //----- 13A -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'integer' then begin         //----- 14 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'memo' then begin            //----- 15 -----
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'money' then begin           //----- 16 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'string' then begin          //----- 17 -----
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'time' then begin            //----- 18 -----
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end else if AField.type = 'tree' then begin            //----- 19 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oPQF;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

        end;

    end else if AField.type = 'treepair' then begin        //----- 20 -----
        //
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name            := sPrefix + 'EQ'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := oPQF;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{'
                +'"options":"'+dwGetStr(AField,'list','')+'"'
                +',"disablebranchnodes":'+IntToStr(dwGetInt(AField,'disablebranchnodes',0))
                +'}';

        end;

    end else begin
        //创建查询字段控件
        oE_Query    := TEdit.Create(oForm);
        with oE_Query do begin
            Name                := sPrefix + 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;

    end;


end;

procedure dcCreateEditorPanel(APanel:TPanel;const AMobile:Boolean=False);
var
    oForm       : TForm;
    oPEr        : TPanel;       //编辑/新增 总Panel
    oPET        : TPanel;       //顶部Panel, 用于放置：标题、最大化、关闭
    oBEL        : TButton;      //标题
    oPES        : TPanel;       //底部按钮Panel, 放置：取消，确定
    oBEK        : TButton;      //确定按钮
    oBEA        : TButton;      //取消按钮
    oPEC        : TPanel;       //多字段编辑信息的容器 panel editor content
    oCK_Batch   : TCheckBox;    //批量新增checkbox
    //
    iField      : Integer;
    iMode       : Byte;
    sPrefix     : String;
    //
    joConfig    : Variant;
    joField     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //try
        //取得Form备用
        oForm   := TForm(APanel.Owner);

        //
        joConfig    := dcGetConfig(APanel);

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //编辑/新增的总面板
        oPEr   := TPanel.Create(oForm);
        with oPEr do begin
            Name        := sPrefix + 'PEr';
            Parent      := APanel;
            Height      := dwGetInt(joConfig,'editheight',APanel.Height);
            Width       := dwGetInt(joConfig,'editwidth',APanel.Width);
            Top         := dwGetInt(joConfig,'edittop',0);
            AutoSize    := False;
            //Align       := alClient;
            HelpKeyword := 'modal';
            Visible     := False;
            BevelOuter  := bvNone;
            BorderStyle := bsNone;
            //Anchors     := [akBottom,akTop];
            Font.Size   := 14;
            Font.Color  := $323232;
            Color       := clWhite;
            Hint        := '{"radius":"4px"}';

            //适配移动端
            if AMobile then begin
                Align   := alClient;
                if oForm.Owner = nil then begin
                    Height      := oForm.Height;
                    Width       := oForm.Width;
                end else begin
                    Height      := TForm(oForm.Owner).Height;
                    Width       := TForm(oForm.Owner).Width;
                end;
                Top         := 0;
                Hint        := '';
            end;
        end;

        //标题 Panel
        oPET  := TPanel.Create(oForm);
        with oPET do begin
            Name            := sPrefix + 'PET';
            Parent          := oPEr;
            Align           := alTop;
            Height          := 50;
            Font.Size       := 17;
            Color           := clNone;
            //
            AlignWithMargins:= True;
            Margins.Left    := 20;
        end;

        //标题 Button
        oBEL  := TButton.Create(oForm);
        with oBEL do begin
            Name        := sPrefix + 'BEL';
            Parent      := oPET;
            Align       := alLeft;
            Width       := 60;
            Caption     := '新  增';
            Font.Size   := 15;
            Hint        := '{"dwstyle":"background:#fff;text-align:left;border:0;"}';
            //
            AlignWithMargins:= True;
            Margins.Left    := 10;
        end;

        //用于放置 OK/Cancel 的Panel
        oPES   := TPanel.Create(oForm);
        with oPES do begin
            Name        := sPrefix + 'PES';
            Parent      := oPEr;
            BevelOuter  := bvNone;
            BorderStyle := bsNone;
            Align       := alBottom;
            Height      := 50;
            Color       := clNone;
        end;

        //
        oBEK  := TButton.Create(oForm);
        with oBEK do begin
            Name        := sPrefix + 'BEK';
            Parent      := oPES;
            Align       := alLeft;
            Width       := 80;
            Top         := 0;
            Left        := 0;
            Height      := 60;
            Font.Size   := 13;
            Caption     := '确定';
            Hint        := '{"type":"primary"}';
            //
            AlignWithMargins:= True;
            Margins.left    := 50;
            Margins.Bottom  := 19;
            //
            tM.Code         := @BEOClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;

        //
        oBEA  := TButton.Create(oForm);
        with oBEA do begin
            Name        := sPrefix + 'BEA';
            Parent      := oPES;
            Align       := alLeft;
            Top         := 0;
            Left        := 900;
            Width       := oBEK.Width;

            Height      := 60;
            Font.Size   := 13;
            Caption     := '取消';
            Hint        := '';
            //
            AlignWithMargins:= True;
            Margins.Left    := 10;
            Margins.Bottom  := 19;
            //
            tM.Code         := @BEAClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;

        //批量新增 checkbox
        oCK_Batch   := TCheckBox.Create(oForm);
        with oCK_Batch do begin
            Name        := sPrefix + 'CKB';
            Parent      := oPEr;
            Align       := alBottom;
            Height      := 30;
            Caption     := '批量处理';
            AlignWithMargins:= True;
            Margins.Left    := 20;
        end;

        //主表ScrollBox的内容Panel
        oPEC    := TPanel.Create(oForm);
        with oPEC do begin
            Name        := sPrefix + 'PEC';
            Parent      := oPEr;
            BevelOuter  := bvNone;
            BorderStyle := bsNone;
            Align       := alClient;
            Color       := clNone;
            Hint        := '{"dwstyle":"overflow-y:auto;"}';
        end;

        //创建主表各字段的编辑框
        for iField := 0 to joConfig.fields._Count-1 do begin

            //取得主表字段的JSON对象
            joField := joConfig.fields._(iField);

            //不显示部分类型字段
            if (joField.type = 'index') or (joField.type = 'totalindex') or (joField.type = 'auto')
                    or (joField.type = 'button') then
            begin
                Continue;
            end;

            //创建控件
            iMode   := dwGetInt(joField,'view',0);  //显示模式，0：全部显示，1：仅新增/编辑时显示，2：全不显示
            case iMode of
                0,1 : begin
                    dcCreateField(
                            APanel,
                            APanel.Width,
                            IntToStr(iField),   //后缀名，用于区分多个控件
                            joConfig,
                            joField,            //字段的JSON对象
                            oPEC                //父panel
                            ,AMobile            //是否移动端
                            );
                end;
            end;
        end;
    //except
        //ShowMessage('error when dcCreateEditorPanel');
    //end;
end;


//在DBCard的按钮栏中插入控件
function dcAddInButtons(APanel:TPanel;ACtrl:TWinControl):Integer;
var
    oPBs        : TPanel;
    oBNw        : TButton;
    oForm       : TForm;
    sPrefix     : String;
    joConfig    : Variant;
begin

    result  := 0;

	//取得Form备用
	oForm   := TForm(APanel.Owner);

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');
    try
        //取得按钮面板
        oPBs      := TPanel(oForm.FindComponent(sPrefix+'PBs'));
        //取得“新增”按钮，以设置新控件的Margins
        oBNw          := TButton(oForm.FindComponent(sPrefix+'BNw'));
        //嵌入
        ACtrl.Parent    := oPBs;
        ACtrl.Align     := alLeft;
        //设置Margins
        ACtrl.Margins   := oBNw.Margins;
        ACtrl.AlignWithMargins  := True;
    except
        Result  := -1;
    end;
end;


procedure dcUpdate(APanel:TPanel;const AWhere:String = '');
var
    iField      : Integer;
    iRecord     : Integer;
    iItem       : Integer;
    iList       : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    sValue      : String;
    sText       : String;
    sFilter     : String;
    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    joMaster    : variant;
    joList      : Variant;
    joSlave     : Variant;
    //
    oForm       : TForm;
    oFQM        : TFDQuery;
    oEKw        : TEdit;
    oFQy        : TFlowPanel;
    oPQF        : TPanel;
    oPCs        : TPanel;               //多个数据卡片的容器面板, 其tag为当前页码, 从0始
    oPCd        : TPanel;               //数据卡片
    oTbP        : TTrackBar;            //分页栏
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCBQy       : TComboBox;
    oBQy        : TButton;
    oComp       : TComponent;
    oBtn        : TButton;      //按钮类数据
    oChk        : TCheckBox;    //选择框
    oImg        : TImage;       //图片类数据
    oLbl        : TLabel;       //标签类数据
    oMasterPanel: TPanel;       //主表面板
    oFQMaster   : TFDQuery;     //主表查询
    //
    sPrefix     : String;
    sTmp        : string;
	bAccept		: boolean;
    oClick      : Procedure(Sender:TObject) of Object;

begin

    //取得JSON配置
    joConfig    := dcGetConfig(APanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

	//取得Form备用
	oForm       := TForm(APanel.Owner);

    //取得字段名称列表，备用，返回值为sFields, 如：id,Name,age
    sFields     := dcGetFields(joConfig.fields);

    //取得各控件备用
    oFQM        := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));    //主表数据库
    oEKw        := TEdit(oForm.FindComponent(sPrefix+'EKw'));           //查询关键字
    oBQy        := TButton(oForm.FindComponent(sPrefix+'BQy'));         //查询按钮
    oFQy        := TFlowPanel(oForm.FindComponent(sPrefix+'FQy'));      //分字段查询字段的流式布局容器面板
    oPCs        := TPanel(oForm.FindComponent(sPrefix+'PCs'));          //多数据卡片的容器面板
    oTbP        := TTrackbar(oForm.FindComponent(sPrefix+'TbP'));       //分页栏

    //数据库类型
    if not joConfig.Exists('database') then begin
        joConfig.database   := lowerCase(oFQM.Connection.DriverName); //'access';
        APanel.Hint	        := joConfig;
    end;

    //取得WHERE, 区分“智能模糊查询”和“分字段查询”2种情况
    //结果类似:  WHERE ((model like '%ljt%') and (name like '%west%'))
    if ( oFQy <> nil ) and (oFQy.Visible) then begin
        //初始化查询 WHERE 字符串
        if joConfig.where = '' then begin
            sWhere  := 'WHERE ((1=1) AND ';
        end else begin
            sWhere  := 'WHERE (('+joConfig.where+') AND ';
        end;

        //逐个字段处理
        if oFQy.Visible AND (oBQy.Tag = 1) then begin
            for iItem := 0 to oFQy.ControlCount-1 do begin
                //得到每个字段的面板 PQF - panel query field
                oPQF := TPanel(oFQy.Controls[iItem]);

                //取得字段序号
                iField      := oPQF.Tag;

                //如果 <0, 则表示为按钮组，跳出
                if iField < 0 then begin
                    break
                end;

                //取得当前字段对象
                joField     := joConfig.fields._(iField);
                if joField.Exists('type') then begin
                    sType   := joField.type;
                end else begin
                    sType   := 'string';
                end;

                //根据字段类型分类处理
                //------------------ 7  dcUpdate -----------------------------------------------------------------------
                if sType = 'auto' then begin                     //----- 1 -----
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //模糊查询
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'boolean' then begin         //----- 2 -----
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        //
                        if oCBQy.Text = joField.list._(0) then begin
                            sWhere  := sWhere + '('+joField.name +' = 0 ) AND ';
                        end else begin
                            sWhere  := sWhere + '('+joField.name +' = 1  ) AND ';
                        end;
                    end;

                end else if sType = 'button' then begin          //----- 3 -----

                end else if (sType = 'combo') then begin         //----- 4 -----
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCBQy.Text)+''' ) AND ';
                    end;

                end else if (sType = 'combopair') then begin     //----- 5 -----
                    //得到字段控件
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        //根据字段的list取到对应的值
                        sText   := '';
                        for iList := 0 to joField.list._Count - 1 do begin
                            if joField.list._(iList)._(1) = oCBQy.Text then begin
                                sText   := joField.list._(iList)._(0);
                                break;
                            end;
                        end;

                        //
                        if sText <> '' then begin
                            if TFieldType(joField.datatype) in dcstInteger then begin
                                sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(sText,0))+' ) AND ';
                            end else if TFieldType(joField.datatype) in dcstFloat then begin
                                sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(sText,0))+' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+sText+''' ) AND ';
                            end;
                        end;
                    end;

                end else if sType = 'date' then begin            //----- 6 -----
                    //取得起始结束日期控件
                    oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
                    oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);
                    //转为字符串以方便后面生成WHERE
                    sStart  := FormatDateTime('YYYY-MM-DD',oDT_Start.Date);
                    sEnd    := FormatDateTime('YYYY-MM-DD',oDT_End.Date+1);  //+1 以避免查询不到当天的bug
                    //根据不同数据库，生成不同的SQL
                    if lowercase(joConfig.database) = 'msacc' then begin
                        sWhere  := sWhere +
                                '('+
                                    '('+joField.name +' >= #'+sStart+'# )'+
                                    ' AND '+
                                    '('+joField.name +' < #'+sEnd+'# )'+
                                ') AND ';
                    end else if lowercase(joConfig.database) = 'oracle' then begin
                        sWhere  := sWhere +
                                '('+
                                    '(to_char('+joField.name +',''YYYY-MM-DD'') >= '''+sStart+''' )'+
                                    ' AND '+
                                    '(to_char('+joField.name +',''YYYY-MM-DD'') < '''+sEnd+''' )'+
                                ') AND ';
                    end else begin
                        sWhere  := sWhere +
                                '('+
                                    '('+joField.name +' >= '''+sStart+''' )'+
                                    ' AND '+
                                    '('+joField.name +' < '''+sEnd+''' )'+
                                ') AND ';
                    end;

                end else if sType = 'datetime' then begin        //----- 7 -----
                    oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]));
                    if oDT_Start.HelpContext = 1 then begin //起始时间
                        sStart  := FormatDateTime('YYYY-MM-DD hh:mm:ss',oDT_Start.DateTime);
                        if lowercase(joConfig.database) = 'msacc' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' >= #'+sStart+'# )'+
                                    ') AND ';
                        end else if lowercase(joConfig.database) = 'oracle' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '(to_char('+joField.name +',''YYYY-MM-DD hh:mm:ss'') >= '''+sStart+''' )'+
                                    ') AND ';
                        end else begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' >= '''+sStart+''' )'+
                                    ') AND ';
                        end;
                    end;
                    if oDT_Start.HelpContext = -1 then begin //结束时间
                        sEnd    := FormatDateTime('YYYY-MM-DD hh:mm:ss',oDT_Start.DateTime);
                        if lowercase(joConfig.database) = 'msacc' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' <= #'+sEnd+'# )'+
                                    ') AND ';
                        end else if lowercase(joConfig.database) = 'oracle' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '(to_char('+joField.name +',''YYYY-MM-DD hh:mm:ss'') <= '''+sEnd+''' )'+
                                    ') AND ';
                        end else begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' <= '''+sEnd+''' )'+
                                    ') AND ';
                        end;
                    end;

                end else if (sType = 'dbcombo') then begin       //----- 8 -----
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        //
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCBQy.Text)+'%'' ) AND ';
                    end;

                end else if (sType = 'dbcombopair') then begin   //----- 9 -----
                    //得到字段控件
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        //根据字段的list取到对应的值
                        sText   := '';
                        for iList := 0 to joField.list._Count - 1 do begin
                            if joField.list._(iList)._(1) = oCBQy.Text then begin
                                sText   := joField.list._(iList)._(0);
                                break;
                            end;
                        end;

                        //
                        if sText <> '' then begin
                            if TFieldType(joField.datatype) in dcstInteger then begin
                                sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(sText,0))+' ) AND ';
                            end else if TFieldType(joField.datatype) in dcstFloat then begin
                                sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(sText,0))+' ) AND ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+sText+''' ) AND ';
                            end;
                        end;
                    end;

                end else if sType = 'dbtree' then begin          //----- 10 -----
                    //取得当前查询框的值
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    //仅非空时查询
                    if Trim(oE_Query.Text) <> '' then begin
                        //根据是否模糊分别查询
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'dbtreepair' then begin      //----- 11 -----
                    //取得当前查询框的值
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    //仅非空时查询
                    if Trim(oE_Query.Text) <> '' then begin
                        //根据是否模糊分别查询
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'float' then begin           //----- 12 -----

                end else if sType = 'image' then begin           //----- 13 -----
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'index' then begin           //----- 13A -----

                end else if sType = 'integer' then begin         //----- 14 -----
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //模糊查询
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'memo' then begin            //----- 15 -----
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //模糊查询
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'money' then begin           //----- 16 -----

                end else if sType = 'string' then begin          //----- 17 -----
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //模糊查询
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else if sType = 'time' then begin            //----- 18 -----

                end else if sType = 'tree' then begin            //----- 19 -----
                    //取得当前查询框的值
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    //仅非空时查询
                    if Trim(oE_Query.Text) <> '' then begin
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;
                end else if sType = 'treepair' then begin        //----- 20 -----
                    //取得当前查询框的值
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    //仅非空时查询
                    if Trim(oE_Query.Text) <> '' then begin
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end else begin
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //
                        sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                    end;

                end;
            end;
        end;
        //删除最后的 ' AND '
        sWhere  := Copy(sWhere,1,Length(sWhere)-4);

        //
        sWhere  := sWhere + ')';
    end else begin
        //从智能模糊查询框的关键字中生成查询字符串
        //返回值为 ' WHERE (1=1) ' 或
        //         ' WHERE ((....) oR (...))'
        sWhere  := dcGetWhere(sFields, oEKw.Text);
    end;

    //添加固定的where(config中自带的where)
    if joConfig.where <> '' then begin
        Delete(sWhere,1,Length(' WHERE'));
        sWhere  := ' WHERE (('+joConfig.where+') and ' + sWhere+')';
    end;

    //AWhere 额外的 WHERE 条件(从外部调用dcUpdate函数)
    if AWhere <> '' then begin
        sWhere  := sWhere + ' AND ('+AWhere+')';
    end;

    //如果当前表有它的主表，则增加当前表与主表关联的字段的where部分
    if joConfig.Exists('master') then begin
        joMaster    := joConfig.master;
        if joMaster.Exists('panel') and joMaster.Exists('masterfield') and joMaster.Exists('slavefield') then begin
            //取得从表panel
            oMasterPanel := TPanel(oForm.FindComponent(joMaster.panel));

            //更新从表
            if oMasterPanel <> nil then begin
                //取得主表查询
                oFQMaster   := dcGetFDQuery(oMasterPanel);

                //
                if oFQMaster <> nil then begin
                    if oFQMaster.IsEmpty then begin
                        sWhere  := sWhere + ' AND (1=0)';
                    end else begin
                        //根据主表更新从表
                        if (oFQMaster.FieldByName(String(joMaster.masterfield)).DataType in dcstInteger) then begin
                            sWhere  := sWhere + ' AND ('+String(joMaster.slavefield)+'='
                                    +IntToStr(oFQMaster.FieldByName(String(joMaster.masterfield)).AsInteger)+')';
                        end else begin
                            sWhere  := sWhere + ' AND ('+String(joMaster.slavefield)+'="'
                                    +oFQMaster.FieldByName(String(joMaster.masterfield)).AsString+'")';
                        end;
                    end;
                end;
            end;
        end;
    end;

    //增加处理额外的where信息, 保存在PQm的hint中
    sTmp    := Trim(dcGetExtraWhere(APanel));
    if sTmp <> '' then begin
        sWhere  := sWhere + ' and ('+sTmp+')';
    end;

    //取得表格中保存的排序和筛选信息JSON
    sFilter := dwGetFilter(APanel);
    if sFilter <> '' then begin
        sWhere  := sWhere + ' and '+sFilter
    end;

    //计算总数量, 以更新分页栏
    oFQM.Close;
    oFQM.SQL.Text   := 'SELECT Count(*) FROM '+joConfig.table+' '+sWhere;
    oFQM.FetchOptions.RecsSkip  := 0;
    oFQM.FetchOptions.RecsMax   := -1;
    oFQM.Open;
    oTbP.Max        := oFQM.Fields[0].AsInteger;

    //如果仅有1页，则不显示分页栏
    if dwGetInt(joConfig,'hidewhensingle',1) = 1 then begin
        oTbP.Visible    := (oTbP.Max / oTbP.PageSize) > 1;
    end else begin
        oTbP.Visible    := True;
    end;

    //打开数据表
    oFQM.Close;
    oFQM.SQL.Text   := 'SELECT '+ sFields+' FROM '+joConfig.table+' '+sWhere+' '+dwGetOrder(APanel);
    oFQM.FetchOptions.RecsSkip  := joConfig.pagesize * oTbP.Position;    //oTbP.Position为当前页码
    oFQM.FetchOptions.RecsMax   := joConfig.pagesize;
    oFQM.Open;

    //绘制数据卡片
    for iItem := 0 to joConfig.pagesize - 1 do begin
        if iItem < oFQM.RecordCount then begin
            oFQM.RecNo      := iItem + 1;
            //当前卡片
            oPCd            := TPanel(oForm.FindComponent(sPrefix+'PCd'+IntToStr(iItem)));
            oPCd.Visible    := True;
            oPCd.Top        := 10000;
            oPCd.DesignInfo := oFQM.RecNo;  //当每个卡片对应的RecNo保存在 DesignInfo 中

            //
            for iField := 0 to joConfig.fields._Count - 1 do begin
                joField := joConfig.fields._(iField);

                //只处理view=0的字段
                if joField.view = 0 then begin

                    //取得控件类型type
                    sType   := joField.type;

                    //取得数据值
                    sValue  := dcGetFieldValue(oFQM,joField.name,joField);

                    //取得控件
                    oComp   := oForm.FindComponent(sPrefix + 'DC'+IntToStr(iItem)+'_'+IntToStr(iField));

                    //
                    if sType = 'button' then begin
                        oBtn    := TButton(oComp);
                        with oBtn do begin
                            //Caption := sValue;
                            Tag := iField + oFQM.RecNo * 1000;
                        end;
                    end else if sType = 'check' then begin
                        oChk    := TCheckBox(oComp);
                        sValue  := LowerCase(sValue);
                        if (sValue ='t') or (sValue ='1') or (sValue ='y') or (sValue ='true') then begin
                            oChk.Checked    := True;
                        end else begin
                            oChk.Checked    := False;
                        end;
                    end else if sType = 'image' then begin
                        oImg    := TImage(oComp);
                        if joField.Exists('dwstyle') then begin
                            if joField.Exists('dwattr') then begin
                                oImg.Hint   := '{"src":"'+sValue+'","dwstyle":"'+string(joField.dwstyle)+'","dwattr":"'+string(joField.dwattr)+'"}';
                            end else begin
                                oImg.Hint   := '{"src":"'+sValue+'","dwstyle":"'+string(joField.dwstyle)+'"}';
                            end;
                        end else begin
                            oImg.Hint   := '{"src":"'+sValue+'"}';
                        end;
                    end else begin
                        oLbl    := TLabel(oComp);
                        with oLbl do begin
                            Caption := sValue;
                        end;
                    end;
                end;
            end;
        end else begin
            oPCd    := TPanel(oForm.FindComponent(sPrefix+'PCd'+IntToStr(iItem)));
            oPCd.Visible    := False;
        end;
    end;

    //控制滚动条到顶部
    dwRunJS('document.getElementById("'+dwFullName(oPCs)+'").scrollTop = 0;',oForm);

    // dcDataScroll 事件
    bAccept := True;
    if Assigned(APanel.OnDragOver) then begin
        APanel.OnDragOver(APanel,nil,dcDataScroll,oFQM.RecNo,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

end;

function dcInit(APanel:TPanel;AConnection:TFDConnection;const AMobile:Boolean=False;const AReserved:String=''):Integer;
type
    TdwUnDock       = procedure (Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean) of object;
var
    joConfig    : variant;
    //
    sFields     : String;
    sPrefix     : String;
    sText       : string;
    sType       : String;
    sValue      : String;
    sCardStyle  : string;       //卡片的style

    //
    oForm       : TForm;
    oPQy        : TPanel;       //分字段查询面板 : PQy
    oPQF        : TPanel;       //单独字段查询面板 : PQ0, PQ1,...
    oPQm        : TPanel;       //智能模糊查询面板 : PQm
    oPBs        : TPanel;       //功能按钮面板 : PBs
    oBQm        : TButton;      //切换查询模式的按钮 ： BQm
    oBFz        : TButton;      //切换查询模式的按钮 ： BFz 模糊/精确
    oFPs        : TFlowPanel;   //用于显示数据的cards   和下面的2选1, 如果有cardwidth,则选这个
    oPCs        : TPanel;       //用于显示数据的cards
    oPCd        : TPanel;       //用于显示数据的card
    oTbP        : TTrackBar;    //分页栏
    oBtn        : TButton;      //按钮类数据
    oChk        : TCheckBox;    //选择框
    oImg        : TImage;       //图片类数据
    oLbl        : TLabel;       //标签类数据

    //
    oBNw        : TButton;
    oBEt        : TButton;
    oBDe        : TButton;
    oBFi        : TButton;      //Button filter
    oCSo        : TComboBox;    //ComboBox sort
    //
    oEKw        : TEdit;

    //
    oFQMain     : TFDQuery;     //主查询表
    oFQTemp     : TFDQuery;     //用于生成combo的临时性FDQuery
    oFieldType  : TFieldType;

    //
    iItem       : Integer;
    iDec        : Integer;
    iField      : Integer;
    iCount      : Integer;
    iCol        : Integer;
    iList       : Integer;
    iMode       : Byte;         //字段的模式，0：正常（默认），1：表格中不显示，新增/编辑时显示；2：仅FDQuery读取， 表格/新增/编辑均不显示
    iFieldId    : Integer;      //每个字段JSON对应的数据表字段index
    iTop        : Integer;
    iHover      : Integer;      //用于配置当mouseenter时当前卡片高度上升的值. 如果为0,则不激活mouseenter/事件
    //
    joField     : variant;
    joSort      : Variant;      //用于排序的字段数组
    joFilter    : Variant;      //用于筛选的字段信息
    joFi        : Variant;      //用于筛选的字段信息
    joHint      : variant;
    joCell      : variant;
    joPair      : Variant;
    joList      : Variant;
    joSGHint    : Variant;
    //
    tM          : TMethod;      //用于指定事件
	bAccept		: boolean;
    procedure dcSetCaption(ALabel:TLabel);
    begin
        with ALabel do begin
            if joField.must = 1 then begin
                Caption     := '* '+joField.caption;
            end else begin
                Caption     := joField.caption;
            end;
            if joField.type <> 'group' then begin
                if joConfig.align = 'right' then begin
                    Alignment   := taRightJustify;
                end else if joConfig.align = 'center' then begin
                    Alignment   := taCenter;
                end;
            end;
        end;
    end;
begin
    //默认返回值
    Result  := 0;

    //置所有对象为nil
    //
    oForm       := nil;
    oPQy        := nil;
    oPQF        := nil;
    oPQm        := nil;
    oPBs        := nil;
    oBQm        := nil;
    oBFz        := nil;
    oFPs        := nil;
    oPCs        := nil;
    oPCd        := nil;
    oTbP        := nil;
    oBtn        := nil;
    oChk        := nil;
    oImg        := nil;
    oLbl        := nil;
    oBNw        := nil;
    oBEt        := nil;
    oBDe        := nil;
    oBFi        := nil;
    oCSo        := nil;
    oEKw        := nil;


    try
        //
        //LockWindowUpdate(APanel.Handle);

        //-----------------处理字段, 主要是无字段情况下自动生成字段列表-----------------------------------------------------
        try

            //为当前Panel赋一个特殊的数值，以方便各控件查找到该panel控件
            APanel.HelpContext  := 31028;

            //取得form备用
            oForm   := TForm(APanel.Owner);

            //取得配置json
            joConfig    := dcGetConfig(APanel);

            //取得前缀备用,默认为空
            sPrefix     := dwGetStr(joConfig,'prefix','');

            //如果不是JSON格式，则退出
            if joConfig = unassigned then begin
                Result  := -201;
                dwMessage('Error when DBCard : '+IntToStr(Result),'error',oForm);
                Exit;
            end;

            //配置 oFQMain 的连接
            oFQMain       := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));

            //生成一个主查询
            if oFQMain = nil then begin
                oFQMain             := TFDQuery.Create(APanel);
                oFQMain.Name        := sPrefix + 'FQMain';
                oFQMain.Connection  := AConnection;
            end;

            //得到字段名列表
            sFields := dcGetFields(joConfig.fields);

            //打开表
            oFQTemp       := TFDQuery(APanel.FindComponent(sPrefix+'FQTemp'));

            //生成一个临时查询
            if oFQTemp = nil then begin
                oFQTemp               := TFDQuery.Create(APanel);
                oFQTemp.Name          := sPrefix+'FQTemp';
                oFQTemp.Connection    := AConnection;
            end;

            //<如果没有定义字段，则自动生成全部字段
            if sFields = '' then begin
                //
                oFQTemp.Disconnect;
                oFQTemp.Close;
                oFQTemp.SQL.Text  := 'SELECT * FROM ' + joConfig.table + ' WHERE 1=0'; // 打开一个空查询
                oFQTemp.Open;

                //先清空原字段数组
                joConfig.fields := _json('[]');

                //根据每个字段的DataType自动进行配置
                for iField := 0 to oFQTemp.Fields.Count - 1 do begin
                    //取得
                    oFieldType  := oFQTemp.Fields[iField].DataType;

                    joField := _json('{}');

                    //字段名
                    joField.name := oFQTemp.Fields[iField].FieldName;

                    //8排序
                    joField.sort        := 1;

                    if oFieldType in [ftAutoInc] then begin     //自增类型
                        //宽度
                        joField.width       := '80';

                        //3类型
                        joField.type        := 'auto';

                        //11对齐
                        joField.align       := 'center';

                    end else if (oFieldType in [ftBoolean]) then begin  //布尔型
                        //宽度
                        joField.width       := '120';

                        //3类型
                        joField.type        := 'boolean';

                        //11对齐
                        joField.align       := 'center';

                        //自动筛选
                        joField.dbfilter    := 1;

                    end else if (oFieldType in dcstInteger) or (oFieldType in dcstFloat) then begin
                        //宽度
                        joField.width       := '120';

                        //3类型
                        joField.type        := 'integer';

                        //11对齐
                        joField.align       := 'right';

                    end else if (oFieldType in [ftDate, ftTime, ftDateTime,ftTimeStamp,ftOraTimeStamp,ftTimeStampOffset])  then begin
                        //宽度
                        joField.width       := '120';

                        //3类型
                        joField.type        := 'date';

                        //11对齐
                        joField.align       := 'center';
                    end else begin
                        //宽度
                        joField.width       := '150';

                        //3类型
                        joField.type        := 'string';

                        //8排序
                        joField.query       := 1;

                        //自动筛选
                        joField.dbfilter    := 1;
                    end;

                    //
                    joConfig.fields.Add(joField);
                end;


                //反写回
                APanel.Hint := joConfig;

                //重新读取，取得配置json
                joConfig    := dcGetConfig(APanel);

                //重新得到字段名列表
                sFields := dcGetFields(joConfig.fields);
            end;
            //>
        except
            //异常时调试使用
            Result  := -1;
        end;

        //-----------------主要是创建各DB字段的list-------------------------------------------------------------------------
        if Result = 0 then begin
            try

                oFQTemp.Close;

                oFQTemp.SQL.Text  := 'SELECT ' + sFields + ' FROM ' + joConfig.table + ' WHERE 1=0'; // 打开一个空查询
                oFQTemp.Open;

                //设置每个字段的DataType
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    joField := joConfig.fields._(iField);

                    //取得当前JSON字段对应的数据表字段index
                    iFieldId    := dwGetInt(joField,'fieldid',-1);

                    //跳过非数据表列
                    if iFieldId < 0 then begin
                        joField.datatype := ftString;
                        continue;
                    end;

                    //
                    joField.datatype := oFQTemp.Fields[iFieldId].DataType;
                end;

                //添加dbxxxx类型和boolean的list
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    joField := joConfig.fields._(iField);

                    //
                    if joField.type = 'boolean' then begin              //--------------------
                        //
                        if not joField.Exists('list') then begin
                            joField.list	:= _json('[]');
                            joField.list.Add('false');
                            joField.list.Add('true');
                        end;

                    end else if joField.type = 'dbcombo' then begin     //--------------------
                        joField.list	:= _json('[]');
                        //
                        if not joField.Exists('table') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;
                        //
                        oFQTemp.FetchOptions.RecsSkip    := 0;
                        oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'listcount',50);
                        oFQTemp.Close;
                        if dwGetStr(joField,'listorder','')='' then begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+' FROM '+joField.table;
                        end else begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+' FROM '+joField.table+' ORDER By '+joField.listorder;
                        end;
                        oFQTemp.Open;

                        //
                        while not oFQTemp.Eof do begin
                            //
                            joField.list.Add(oFQTemp.Fields[0].AsString);
                            //
                            oFQTemp.Next;
                        end;

                    end else if joField.type = 'dbcombopair' then begin //--------------------
                        joField.list	:= _json('[]');
                        //
                        if not joField.Exists('table') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('viewfield') then begin
                            continue;
                        end;
                        //
                        oFQTemp.FetchOptions.RecsSkip    := 0;
                        oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'listcount',50);
                        oFQTemp.Close;
                        if dwGetStr(joField,'listorder','')='' then begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+','+joField.viewfield+' FROM '+joField.table;
                        end else begin
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.datafield+','+joField.viewfield+' FROM '+joField.table+' ORDER By '+joField.listorder;
                        end;
                        oFQTemp.Open;

                        //
                        while not oFQTemp.Eof do begin
                            joPair  := _json('[]');
                            joPair.Add(oFQTemp.Fields[0].AsString);
                            joPair.Add(oFQTemp.Fields[1].AsString);
                            //
                            joField.list.Add(joPair);
                            //
                            oFQTemp.Next;
                        end;
                    end else if joField.type = 'dbtree' then begin      //--------------------
                        joField.list	:= _json('[]');

                        //
                        if not joField.Exists('table') then begin
                            joField.table := joConfig.table;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;

                        //创建树形字段的选项，参数分别为：查询控件、表名、数据存储字段、数据显示字段
                        joField.list    := dcDBToTreeList(
                                oFQTemp,
                                joField.table,
                                joField.datafield,
                                joField.datafield,
                                dwGetStr(joField,'listlink',' - '),
                                dwGetInt(joField,'listcount',50));

                        joField.treelist    := dcDBToTreeList(
                                oFQTemp,
                                joField.table,
                                joField.datafield,
                                joField.datafield,
                                '',
                                dwGetInt(joField,'listcount',50));
                    end else if joField.type = 'dbtreepair' then begin      //--------------------
                        joField.list	:= _json('[]');

                        //
                        if not joField.Exists('table') then begin
                            joField.table := joConfig.table;
                        end;
                        //
                        if not joField.Exists('datafield') then begin
                            continue;
                        end;
                        //
                        if not joField.Exists('viewfield') then begin
                            continue;
                        end;

                        //创建树形字段的选项，参数分别为：查询控件、表名、数据存储字段、数据显示字段
                        joField.list    := dcDBToTreeList(oFQTemp,joField.table,joField.datafield,joField.viewfield,
                                dwGetStr(joField,'listlink',' - '),    //连接字符串
                                dwGetInt(joField,'listcount',50));
                        joField.treelist    := dcDBToTreeList(oFQTemp,joField.table,joField.datafield,joField.viewfield,
                                '',    //连接字符串,专门设置为空
                                dwGetInt(joField,'listcount',50));

                    end;

                    //如果设置了数据表自动筛选
                    if dwGetInt(joField,'dbfilter',0)=1 then begin
                        //排除一些不能自动筛选的类型
                        if TFieldType(joField.datatype) in [ftMemo] then begin
                            joField.dbfilter := 0;
                        end else begin
                            //
                            oFQTemp.FetchOptions.RecsSkip    := 0;
                            oFQTemp.FetchOptions.RecsMax     := dwGetInt(joField,'filtercount',50);
                            oFQTemp.Close;
                            oFQTemp.SQL.Text := 'SELECT Distinct '+joField.name+' FROM '+joConfig.table;
                            oFQTemp.Open;

                            //
                            joField.filterlist  := _json('[]');

                            //根据类型设置筛选项,分xxxpair和非pair
                            if          joField.type = 'boolean'      then begin    //----- 2 -----
                                //list类似如下:
                                //"list":["女","男"]

                                //取得list的JSON对象
                                joList  := _json(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    joField.filterlist.Add(joList._(iList));
                                end;

                            end else if joField.type = 'combopair'      then begin  //----- 5 -----
                                //list类似如下:
                                //"list":[
                                //    ["029","西安"],
                                //    ["0271","纽约"],
                                //    ["0971","新奥尔良"]

                                //取得list的JSON对象
                                joList  := _json(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    joField.filterlist.Add(joList._(iList)._(1));
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //默认为字段的值
                                        sText   := '';

                                        //在pair中查找对应值
                                        for iList := 0 to joList._Count -1 do begin
                                            if joList._(iList)._(0) = oFQTemp.Fields[0].AsString then begin
                                                sText   := joList._(iList)._(1);
                                                break;
                                            end;
                                        end;
                                        //
                                        if sText = '' then begin
                                            joField.filterlist.Add(oFQTemp.Fields[0].AsString);
                                        end;
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else if joField.type = 'dbcombopair'    then begin  //----- 9 -----
                                //list类似如下:
                                //"list":[
                                //    ["029","西安"],
                                //    ["0271","纽约"],
                                //    ["0971","新奥尔良"]

                                //取得list的JSON对象
                                joList  := _json(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    joField.filterlist.Add(joList._(iList)._(1));
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //默认为字段的值
                                        sText   := '';

                                        //在pair中查找对应值
                                        for iList := 0 to joList._Count -1 do begin
                                            if joList._(iList)._(0) = oFQTemp.Fields[0].AsString then begin
                                                sText   := joList._(iList)._(1);
                                                break;
                                            end;
                                        end;
                                        //
                                        if sText = '' then begin
                                            joField.filterlist.Add(oFQTemp.Fields[0].AsString);
                                        end;
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else if joField.type = 'dbtreepair'     then begin  //----- 11 -----
                                //list类似如下: [{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]

                                //取得list的JSON对象
                                joList  := dcGetTreeListJson(joField.list);

                                //先添加在pair中的值
                                sText   := joField.list;
                                while Pos('label:''',sText) > 0 do begin
                                    Delete(sText,1,Pos('label:''',sText)+6);
                                    sValue  := Copy(sText,1,Pos('''',sText)-1);
                                    joField.filterlist.Add(sValue);
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else if joField.type = 'treepair'       then begin  //----- 20 -----
                                //list类似如下: [{id:'a',label:'a',children:[{id:'aa',label:'aa'}, {id:'ab',label:'ab'}]}, {id:'b',label:'b'}]

                                //取得list的JSON对象
                                joList  := dcGetTreeListJson(joField.list);

                                //先添加在pair中的值
                                for iList := 0 to joList._Count -1 do begin
                                    sText   := joField.list;
                                    while Pos('label:''',sText) > 0 do begin
                                        Delete(sText,1,Pos('label:''',sText)+7);
                                        sValue  := Copy(sText,1,Pos('''',sText)-1);
                                        joField.filterlist.Add(sValue);
                                    end;
                                end;

                                //添加数据表中非pair中的值
                                if dwGetInt(joField,'filteronlylist',1) = 0 then begin
                                    //
                                    while not oFQTemp.Eof do begin
                                        //
                                        oFQTemp.Next;
                                    end;
                                end;
                            end else begin
                                while not oFQTemp.Eof do begin
                                    //
                                    joField.filterlist.Add(oFQTemp.Fields[0].AsString);
                                    //
                                    oFQTemp.Next;
                                end;
                            end;
                        end
                    end;

                end;
            except
                //异常时调试使用
                Result  := -2;
            end;
        end;

        //-----------------主要是创建智能查询面板和增删改查等功能按钮面板-----------------------------------------------
        if Result = 0 then begin
            try

                //反写回
                APanel.Hint := joConfig;

                //智能查询面板 PQm =====================================================================================
                oPQm := TPanel.Create(oForm);
                with oPQm do begin
                    Parent          := APanel;
                    Name            := sPrefix + 'PQm';
                    Align           := alTop;
                    Height          := 45;
                    Top             := 0;
                    if joConfig.Exists('topcolor') then begin
                        Color       := dwGetColorFromJson(joConfig.topcolor,clBtnFace);
                    end;
                    //
                    //Visible         := (iCount = 0) and (joConfig.defaultquerymode <> 0);
                    Visible         := joConfig.defaultquerymode <> 0;

                    //
                    tM.Code         := @PQmUndock;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnUnDock        := TdwUnDock(tM);
                end;
                //智能查询EKw : Edit keyword
                oEKw  := TEdit.Create(oForm);
                with oEKw do begin
                    Parent          := oPQm;
                    Name            := sPrefix + 'EKw';
                    Text            := '';
                    //如果为多列,则和卡片宽度相同
                    if dwGetInt(joConfig,'cardwidth',0)>0 then begin
                        Align       := alLeft;
                        Width       := dwGetInt(joConfig,'cardwidth',0)-10; //-10主要是有padding-left
                    end else begin
                        Align       := alClient;
                    end;
                    //
                    AlignWithMargins:= True;
                    if AMobile then begin
                        Margins.SetBounds(10,5,20,8); //右侧需要考虑padding-left
                    end else begin
                        Margins.Bottom  := 5;
                        Margins.Left    := joConfig.margins._(1);
                        Margins.Right   := 25;
                        Margins.Top     := 8;
                    end;
                    Hint            := '{"placeholder":"search","suffix-icon":"el-icon-search",'
                                    +'"dwstyle":"border-radius:7px;padding-left:10px;"}';
                    //
                    tM.Code         := @EKwChange;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnChange        := TNotifyEvent(tM);
                end;

                //功能按钮面板 ： PBs : panel buttons ===========================================================================
                oPBs  := TPanel.Create(oForm);
                with oPBs do begin
                    Parent          := APanel;
                    Name            := sPrefix + 'PBs';
                    Align           := alTop;
                    Height          := 45;
                    Top             := 200;
                    Font.Size       := 11;
                    if joConfig.Exists('topcolor') then begin
                        Color       := dwGetColorFromJson(joConfig.topcolor,clBtnFace);
                    end;
                    Visible         := joConfig.buttons = 1;
                end;

                //sort ↑↓
                //先查找是否有需要排序的字段
                joSort  := _json('[]');
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    joField := joConfig.fields._(iField);
                    if joField.sort = 1 then begin
                        joSort.add(joField.caption);
                    end;
                end;
                if joSort._Count > 0 then begin
                    oCSo    := TCombobox.Create(oForm);
                    with oCSo do begin
                        Parent          := oPBs;
                        Name            := 'CSo';
                        Align           := alLeft;
                        width           := 100;
                        style           := csDropdownlist;
                        Color           := clNone;
                        Font.Color      := RGB(144,147,153);
                        //
                        Items.Add('默认排序');
                        for iField := 0 to joSort._Count - 1 do begin
                            Items.Add(String(joSort._(iField))+' ↑');
                            Items.Add(String(joSort._(iField))+' ↓');
                        end;
                        ItemIndex   := 0;
                        //
                        AlignWithMargins:= True;
                        Margins.Top     := 4;
                        Margins.Bottom  := 11;
                        Margins.Left    := 10;
                        Margins.Right   := 15;
                        Hint            := '{"height":30,"dwstyle":"border:0;caret-color: transparent;font-size:12px;"}';
                        //
                        tM.Code         := @CSoChange;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnChange        := TNotifyEvent(tM);
                    end;
                end;

                //筛选
                //先查找是否有需要筛选的字段
                joFilter    := _json('[]');
                for iField := 0 to joConfig.fields._Count - 1 do begin
                    joField := joConfig.fields._(iField);
                    if joField.Exists('filterlist') then begin
                        joFi            := _json('{}');
                        joFi.index      := iField;
                        joFi.name       := string(joField.name);
                        joFi.caption    := string(joField.caption);
                        joFi.list       := joField.filterlist;
                        joFilter.add(joFi);
                    end;
                end;
                if joFilter._Count > 0 then begin
                    oBFi    := TButton.Create(oForm);
                    with oBFi do begin
                        Parent          := oPBs;
                        Name            := sPrefix+'BFi';
                        Align           := alRight;
                        Width           := 80;
                        Caption         := '筛选　';
                        Font.Color      := RGB(144,147,153);
                        Font.Size       := 11;
                        //
                        AlignWithMargins:= True;
                        Margins.Top     := 8;
                        Margins.Bottom  := 7;
                        Margins.Left    := 15;
                        Margins.Right   := 15;
                        Hint            := '{"dwstyle":"z-index:3;","type":"text","style":"plain","righticon":"el-icon-circle-check"}';
                        //
                        tM.Code         := @BFiClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end ;

                    //创建确定面板P_Confirm
                    dcCreateFilterPanel(APanel,joFilter);

                end;

                //创建新增按钮
                if dwGetInt(joConfig,'new',0)=1 then begin
                    oBNw    := TButton.Create(oForm);
                    with oBNw do begin
                        Parent      := APanel;
                        Name            := sPrefix+'BNw';
                        Width           := 80;
                        Caption         := '';
                        Font.Color      := RGB(144,147,153);
                        Font.Size       := 23;
                        Cancel          := True;

                        //
                        Top             := APanel.Height - 110;
                        Left            := APanel.Width - 70;
                        Anchors         := [akRight,akBottom];
                        width           := 45;
                        height          := 45;
                        Hint            :=
                                '{'
                                    +'"type":"primary",'
                                    +'"style":"circle",'
                                    +'"dwstyle":"z-index:3;box-shadow: rgba(0, 0, 0, 0.35) 0px 5px 15px;",'
                                    +'"icon":"el-icon-plus"'
                                +'}';
                        //
                        tM.Code         := @BNwClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;
                end;
            except
                //异常时调试使用
                Result  := -3;
            end;
        end;

        //-------------------创建数据卡片 和数据显示组件----------------------------------------------------------------
        if Result = 0 then begin
            try
                //所有卡片的父容器 =====================================================================================
                if dwGetInt(joConfig,'cardwidth',0)>0 then begin
                    oFPs    := TFlowPanel.Create(oForm);
                    with oFPs do begin
                        Parent          := APanel;
                        Name            := sPrefix + 'Pcs';
                        Align           := alClient;
                        BevelOuter      := bvNone;
                        if joConfig.Exists('datacolor') then begin
                            Color       := dwGetColorFromJson(joConfig.backgroundcolor,clWhite);
                        end else begin
                            Color       := APanel.Color;
                        end;
                        Hint            := '{"dwstyle":"overflow-y:auto;"}';

                        //
                        tM.Code         := @FPsResize;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnResize        := TNotifyEvent(tM);

                    end;
                end else begin
                    oPCs    := TPanel.Create(oForm);
                    with oPCs do begin
                        Parent          := APanel;
                        Name            := sPrefix + 'Pcs';
                        Align           := alClient;
                        BevelOuter      := bvNone;
                        if joConfig.Exists('backgroundcolor') then begin
                            Color       := dwGetColorFromJson(joConfig.backgroundcolor,clWhite);
                        end else begin
                            Color       := clWhite;
                        end;
                        Hint            := '{"dwstyle":"overflow-y:auto;"}';
                    end;
                end;

                //
                sCardStyle  := dwGetStr(joConfig,'cardstyle');
                if sCardStyle = '' then begin
                    sCardStyle  := 'this.style.boxShadow=''''; this.style.border='''';';
                end else begin
                    sCardStyle  := 'this.style.cssText  = '''+sCardStyle+''';';
                end;

                //
                iHover  := dwGetInt(joConfig,'hover');

                //创建多个数据卡片======================================================================================
                for iItem := 0 to joConfig.pagesize - 1 do begin
                    oPCd    := TPanel.Create(oForm);
                    with oPCd do begin
                        if oFPs <> nil then begin
                            Parent          := oFPs;
                        end else begin
                            Parent          := oPCs;
                        end;

                        //
                        Tag             := iItem;   //保存位置
                        Name            := sPrefix + 'PCd'+IntToStr(iItem);
                        BevelOuter      := bvNone;
                        Height          := dwGetInt(joConfig,'cardheight',200);
                        Top             := 900*iItem;   //保证新生成的在最底部

                        if oFPs <> nil then begin
                            //宽度为设定的cardwidth
                            Width       := dwGetInt(joConfig,'cardwidth',0);
                        end else begin
                            Align       := alTop;
                        end;

                        //
                        AlignWithMargins:= True;
                        Margins.Bottom  := joConfig.margins._(0);
                        Margins.Left    := joConfig.margins._(1);
                        Margins.Right   := joConfig.margins._(2);
                        Margins.Top     := joConfig.margins._(3);

                        //
                        Hint            :=
                                '{'
                                    +'"dwstyle":"'+dwGetStr(joConfig,'cardstyle','')+'"'
                                    //+dwIIF(iHover=0,'',',"dwattr":"onmouseover=\"this.style.top='''+IntToStr(Top-iHover)+'px'';\"'
                                    //    +' onmouseout=\"this.style.top='''+IntToStr(Top)+'px'';\""')
                                    +dwIIF(iHover=0,'',',"dwattr":"onmouseover=\"this.style.top = (parseInt(this.style.top) - '+IntToStr(iHover)+') + ''px'';\"'
                                        +' onmouseout=\"this.style.top = (parseInt(this.style.top) + '+IntToStr(iHover)+') + ''px'';\""')
                                +'}';

                        //
                        tM.Code         := @PCdClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                    end;

                    //为每个可视组件创建一个对应的控件
                    iTop    := 15;
                    for iField := 0 to joConfig.fields._Count - 1 do begin
                        //取得控件JSON对象
                        joField := joConfig.fields._(iField);

                        //
                        if joField.view = 0 then begin

                            //取得控件类型type
                            sType   := joField.type;

                            //
                            if sType = 'button' then begin
                                oBtn    := TButton.Create(oForm);
                                with oBtn do begin
                                    Parent          := oPCd;
                                    Name            := sPrefix + 'DC'+IntToStr(iItem)+'_'+IntToStr(iField);
                                    Caption         := dwGetStr(joField,'caption');
                                    Tag             := iField;
                                    //
                                    tM.Code         := @BtnClick;
                                    tM.Data         := Pointer(325); // 随便取的数
                                    OnClick         := TNotifyEvent(tM);

                                end;
                                //
                                dcSetProperty(oBtn,joField,iTop);
                                //

                            end else if sType = 'check' then begin
                                oChk    := TCheckBox.Create(oForm);
                                with oChk do begin
                                    Parent  := oPCd;
                                    Name    := sPrefix + 'DC'+IntToStr(iItem)+'_'+IntToStr(iField);
                                    Caption := joField.caption;
                                end;
                                //
                                dcSetProperty(oChk,joField,iTop);
                            end else if sType = 'image' then begin
                                oImg    := TImage.Create(oForm);
                                with oImg do begin
                                    Parent          := oPCd;
                                    Stretch         := True;
                                    Proportional    := True;
                                    Name    := sPrefix + 'DC'+IntToStr(iItem)+'_'+IntToStr(iField);
                                    if joField.Exists('dwstyle') then begin
                                        Hint    := '{"dwstyle":"'+String(joField.dwstyle)+'"}';
                                        if joField.Exists('dwattr') then begin
                                            Hint    := '{"dwstyle":"'+String(joField.dwstyle)+'","dwattr":"'+String(joField.dwattr)+'"}';
                                        end;
                                    end else  if joField.Exists('dwattr') then begin
                                        Hint    := '{"dwattr":"'+String(joField.dwattr)+'"}';
                                    end;
                                    //是否预览
                                    IncrementalDisplay  := dwGetInt(joField,'preview')=1;
                                    //
                                    if dwGetInt(joField,'onclick')=1 then begin
                                        //
                                        tM.Code         := @ImgClick;
                                        tM.Data         := Pointer(325); // 随便取的数
                                        OnClick         := TNotifyEvent(tM);
                                    end;
                                end;
                                //
                                dcSetProperty(oImg,joField,iTop);
                            end else begin
                                oLbl    := TLabel.Create(oForm);
                                with oLbl do begin
                                    Parent      := oPCd;
                                    AutoSize    := False;
                                    Name        := sPrefix + 'DC'+IntToStr(iItem)+'_'+IntToStr(iField);

                                    //对齐方式
                                    if joField.align = 'center' then begin
                                        Alignment   := taCenter;
                                    end else if joField.align = 'right' then begin
                                        Alignment   := taRightJustify;
                                    end;

                                    //是否换行
                                    if dwGetInt(joField,'wrap',0) = 1 then begin
                                        WordWrap    := True;
                                    end;

                                    //
                                    if dwGetStr(joField,'dwstyle') <> '' then begin
                                        Hint    := '{"dwstyle":"'+dwGetStr(joField,'dwstyle')+'"}';
                                    end;
                                end;
                                //
                                dcSetProperty(oLbl,joField,iTop);
                            end;

                        end;

                    end;

                    //创建编辑按钮
                    if dwGetInt(joConfig,'edit',0)=1 then begin
                        oBEt    := TButton.Create(oForm);
                        with oBEt do begin
                            Parent          := oPCd;
                            Name            := sPrefix + 'BE'+IntToStr(iItem);
                            Width           := 20;
                            Caption         := '';
                            Font.Color      := RGB(200,200,200);
                            Font.Size       := 17;
                            Cancel          := True;
                            //
                            Tag             := iItem+1;   //用于标记行号

                            //
                            Top             := dwGetInt(joConfig,'editbuttontop',15);
                            Left            := dwGetInt(joConfig,'editbuttonleft',oPCd.Width - 35);
                            Anchors         := [akRight,akTop];
                            width           := 20;
                            height          := 20;
                            Hint            :=
                                    '{'
                                        +'"type":"text",'
                                        +'"icon":"el-icon-edit-outline"'
                                    +'}';
                            //
                            tM.Code         := @BEtClick;
                            tM.Data         := Pointer(325); // 随便取的数
                            OnClick         := TNotifyEvent(tM);
                        end;
                    end;

                    //创建删除按钮
                    if dwGetInt(joConfig,'delete',0)=1 then begin
                        oBDe    := TButton.Create(oForm);
                        with oBDe do begin
                            Parent          := oPCd;
                            Name            := sPrefix + 'BD'+IntToStr(iItem);
                            Width           := 20;
                            Caption         := '';
                            Font.Color      := RGB(200,200,200);
                            Font.Size       := 17;
                            Cancel          := True;
                            //
                            Tag             := iItem+1;   //用于标记行号

                            //
                            if dwGetInt(joConfig,'edit',0)=1 then begin
                                Top         := dwGetInt(joConfig,'deletebuttontop',45);
                            end else begin
                                Top         := dwGetInt(joConfig,'deletebuttontop',15);
                            end;
                            Left            := dwGetInt(joConfig,'deletebuttonleft',oPCd.Width - 35);
                            Anchors         := [akRight,akTop];
                            width           := 20;
                            height          := 20;
                            Hint            :=
                                    '{'
                                        +'"type":"text",'
                                        +'"icon":"el-icon-delete"'
                                    +'}';
                            //
                            tM.Code         := @BDeClick;
                            tM.Data         := Pointer(325); // 随便取的数
                            OnClick         := TNotifyEvent(tM);
                        end;
                    end;
                end;
                //分页       ===============================================================================================
                oTbP    := TTrackBar.Create(oForm);
                with oTbP do begin
                    Parent          := APanel;
                    Name            := sPrefix + 'TbP';
                    Align           := alBottom;
                    HelpKeyword     := 'page';
                    Height          := 35;
                    PageSize        := joConfig.pagesize;
                    if dwGetInt(joConfig,'totalfirst',0)=1 then begin
                        Hint            := '{"dwattr":"small :pager-count=5 background layout=\"total, ->, prev, pager, next\""}';
                    end else begin
                        Hint            := '{"dwattr":"small :pager-count=5 background layout=\"prev, pager, next, ->, total\""}';
                    end;
                    //
                    AlignWithMargins:= True;
                    Margins.Top     := 5;
                    Margins.Bottom  := 0;
                    Margins.Left    := 0;
                    Margins.Right   := 20;

                    //
                    tM.Code         := @TbPChange;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnChange        := TNotifyEvent(tM);

                    //移动端处理
                    if AMobile then begin
                        Hint            := '{"dwattr":"layout=\"total ,->, prev, next\"","dwstyle":"background:#fff;"}';
                    end;

                end;
            except
                //异常时调试使用
                Result  := -4;
            end;
        end;

        if Result = 0 then begin
            try

                //更新数据
                dcUpdate(APanel,'');
            except

                //异常时调试使用
                Result  := -5;
            end;
        end;


        if Result = 0 then begin
            try
                //创建确定面板P_Confirm
                dcCreateConfirmPanel(APanel);
            except

                //异常时调试使用
                Result  := -6;
            end;
        end;

        if Result = 0 then begin
            try
                //创建编辑面板PEr
                if (joConfig.new=1) or (joConfig.edit=1) then begin
                    dcCreateEditorPanel(APanel,AMobile);
                end;

            except

                //异常时调试使用
                Result  := -7;
            end;
        end;

        // dcInited 事件
        bAccept := True;
        if Assigned(APanel.OnDragOver) then begin
            APanel.OnDragOver(APanel,nil,dcInited,0,dsDragEnter,bAccept);
            if not bAccept then begin
                Exit;
            end;
        end;

        //
        if Result <> 0 then begin
            dwMessage('Error when DBCard : '+IntToStr(Result),'error',oForm);
        end;

        //
        //oTbP.Visible    := False;

    finally
        //
        //LockWindowUpdate(0);
    end;
end;

//修改Apanel的Hint中的JSON中的AField字段的属性Attr的值为AValue
function  dcChangeFieldValue(APanel:TPanel;AFieldName,Attr,AValue:String):Integer;
var
    iItem       : Integer;
    joConfig    : Variant;
    joField     : Variant;
begin
    try
        Result  := 0;

        //取得json备用
        joConfig    := _json(APanel.Hint);

        //
        if joConfig = unassigned then begin
            Result  := -2;
            Exit;
        end;

        //
        if not joConfig.Exists('fields') then begin
            Result  := -3;
            Exit;
        end;

        //循环检查所有字段
        for iItem := 0 to joConfig.fields._Count - 1 do begin
            //取得字段JSON对象
            joField := joConfig.fields._(iItem);

            //检查是否为拟修改的字段
            if LowerCase(joField.name) = LowerCase(AFieldName) then begin
                jofield.Delete(Attr);
                jofield.Add(Attr,AValue);
                //
                APanel.Hint := joConfig;
                Break;
            end;
        end;

    except
        Result  := -1;
    end;
end;

function  dcChangeFieldValueById(APanel:TPanel;AFieldIndex:Integer;Attr,AValue:String):Integer;
var
    iItem       : Integer;
    joConfig    : Variant;
    joField     : Variant;
begin
    try
        //
        Result  := 0;

        //取得json备用
        joConfig    := _json(APanel.Hint);

        //
        if joConfig = unassigned then begin
            Result  := -2;
            Exit;
        end;

        //
        if not joConfig.Exists('fields') then begin
            Result  := -3;
            Exit;
        end;

        //循环检查所有字段
        if (AFieldIndex>=0) and (AFieldIndex < joConfig.fields._Count) then begin
            //取得字段JSON对象
            joField := joConfig.fields._(AFieldIndex);

            //修改字段
            jofield.Delete(Attr);
            jofield.Add(Attr,AValue);

            //
            APanel.Hint := joConfig;
        end else begin
            Result  := -4;
            Exit;
        end;

    except
        Result  := -1;
    end;
end;


//销毁dwCrud，以便二次创建
function  dcDestroy(APanel:TPanel):Integer;
var
    sPrefix     : String;
    joConfig    : Variant;
    oForm       : TForm;
    oPanel      : TPanel;
    oFDQuery    : TFDQuery;
    iItem       : Integer;
begin
    try
        //取得form备用
        oForm   := TForm(APanel.Owner);

        //
        joConfig    := dcGetConfig(APanel);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //取得前缀备用,默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //销毁编辑面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PEr'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁删除面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PDe'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁Query面板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PQy'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁主表板
        oPanel  := TPanel(oForm.FindComponent(sPrefix+'PQC'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁临时表
        oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQTemp'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

        //销毁主表
        oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQMain'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

        //
        for iItem := APanel.ControlCount - 1 downto 0 do begin
            APanel.Controls[iItem].Destroy;
        end;

    except

    end;
end;


end.
