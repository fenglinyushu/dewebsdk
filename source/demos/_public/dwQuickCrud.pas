unit dwQuickCrud;
{
使用说明：
1 当前Forms必须在Public中的有qcConfig:String;变量
2 一般建议把配置信息放到当前Form的StyleName中(非必要)
3 在Form的OnShow中，使用以下代码
    procedure TForm_RoleRY.FormShow(Sender: TObject);
    begin
        qcConfig    := StyleName;
        dwCrud(self,TForm1(Self.Owner).FDConnection1,False,'');
    end;

## dwQuickCrud的命名规则：
 - 下划线前的字母表示类型，
    B=Button, P=Panel, PC=PageControl, FP=FlowPanel,
    CB=ComboBox, E=Edit, SG=StringGrid，TB=TrackBar
 - 下划后面:
   带E的表示是编辑/新增框内控件， 如BEM
   带S表示为从表（Slave）,如BSE
   带D表示删除（Delete）,如BDO,BDC
 - 最后面的单词表示功能，如BSN,BEA

## 事件
数据表记录切换时激活 Form 的 OnDockDrop 事件
procedure TForm1.FormDockDrop(Sender: TObject; Source: TDragDockObject; X, Y: Integer);
begin
    //数据表记录切换事件
    if X = 0 then begin
        dwMessage('数据表记录切换事件！ 主表, 数据记录 : '+IntToStr(Y),'success',self);
    end else begin
        dwMessage('数据表记录切换事件！ 从表 '+IntToStr(X)+', 数据记录 : '+IntToStr(Y),'info',self);
    end;
end;

常用的显示/隐藏
    "Edit":0,
    "new":0,
    "delete":0,
    "switch":0,
    "fuzzy":0,
    "buttons":0,
默认查询模式
    "defaultquerymode":1



更新说明：
--------------------------------------------------------------------------------
2024-10-18
    1. 更改表格控件为dwTStringGrid__multi(前一段的事了)
    2. 解决了defaultorder未生效的bug

2024-09-26
    1. 解决了runtime目录中无download子目录报错的bug。解决办法： 导出前先检测download子目录是否存在，如不存在，则创建
    2. 解决了boolean类型时， 新增时报错的bug
    3. 增加了exportonlyvisible属性，只导出可见字段

2024-09-23
    1. 增加了默认不显示数据选项defaultempty, 默认为0

2024-08-28
    1. 字段中增加了view属性,用于:全显示/新增编辑显示/全不显示

2024-03-29
    1. 解决了datetime查询的bug
    2. 增加了qcInsert函数，用于在界面上插入按钮
    3. 对控件名进行了精简，所有控件由3个字符组成，
       第1个字符为类型，如P:Panel/L:Label/E:Edit/B:Button/G:StringGrid/T:Trackbar/
       后2个字符为名称简写，如Nw=New, Et=Edit,
2024-03-27
    1. 暂时删除了“打印”按钮
2024-03-25
    1. 解决了不在第0页时，查询时为空的BUG
2024-03-07
    1. 解决了编辑后字段数据置空的bug. 原因是前面对控件name做了简化，在BEK事件中依然在查找控件名Field0..., 应该查找F0...
    2. 增加了对boolean字段的支持，对应 "list":["女","男"]. 该项主表基本通过测试。 从表还没有处理

2024-01-07
    1. 完善EKwChange事件，在更新数据时先设置TBMain到第1页

2023-12-04
    1. 增加支持字段type为dbtree
    2. qcGetFDQuery支持取得临时表FDQueryTmp

2023-12-01
    1. 增加了设置表头颜色的设置。 即在config中添加类似 "headerbackground": "#f7f7f7",
    2. 增加了对主从表关联字段采用字符串类型的支持。 原来只支持关联字段为整型
    3. 增加了菜单中使用配置文件直接创建quickCrud模块

2023-11-30
    1、增加记录时对日期型字段进行检查，如IsNull, 则默认当前Now
    2、调宽了字段标签宽度，以解决4汉字略挤的问题
    3、解决了“新增”记录时未默认最大的bug

2023-11-27
    1、增加支持字段type为combopair，其list为二维数组，显示为元素0，保存为元素1

2023-11-24
    1、字段类型为dbcombo时，增加支持它表字段，可以当前字段节点增加table(默认为当前表)/field（默认name）属性

2023-11-19
    1、支持margin属性（数值型），可以改变边距，默认10
    2、支持switch属性（0/1），控制切换模式按钮是否显示，默认1
    3、支持border属性（0/1），控制表格的竖线是否显示，默认1
    4、分页栏增加了仅一页时不显示

2023-11-18
    1、支持memo类型
    2、支持memo使用高度height

2023-08-24
    1、字段防重
    2、序号类型

2023-08-12
    1、加入了主从表defaultorder,以解决默认order的问题， 如："defaultorder":" ORDER BY actdate DESC"
       创建后设置对应SG的stylename ,如    oSG.StyleName   := joConfig.defaultorder;
    2、加入了"query":0时的处理，完全禁止查询
    3、对小于400的TrackBar设置了pager-count

2023-08-10
    1、解决了“重置”未清空的问题；
    2、通过判断 BQy.tag 是否为1 ， 确定是否当前查询条件生效
    3、mainwidth支持负值， 如为负值，则从表为固定宽度，主表为client
    4、为从表的imageindex赋默认值，以解决未设置该项可能的错误
    5、为从表的字段caption指定了默认值，为其name
-
2023-07-11
    1、支持从表where属性, 如："where":"id>20"
    2、支持日期型显示为空，当设置日期为1899-12-30或3000-01-01时显示为空 （需同步更新dwTDateTimePicker.dpr）
    3、修改了readonly属性使用方法。当字段"readonly":1时，编辑时为只读；新增时，如果有default属性，则只读，否则可编辑
    4、消除了主表为空时，从表不刷新的bug
    5、消除了数据为空时，点击排序报错的bug
    6、增加了表格中将日期字段的1899-12-30显示为空值
-
}

interface
uses
    //
    dwBase,
    //dwAccess,

    //导出XLS
    dwExportToXLSUnit,

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
    Math,System.DateUtils,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;

//一键生成CRUD模块
function  dwCrud(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

//设置为移动模式
function  qcSetMobile(AForm:TForm):Integer;

//销毁dwCrud，以便二次创建
function  dwCrudDestroy(AForm:TForm):Integer;

//更新数据
procedure qcUpdateMain(AForm:TForm;AWhere:String);
procedure qcUpdateSlaves(AForm:TForm);

//取QuickCrud模块的 FDQuery 控件，AIndex : 0 为主表，-1表示临时表，1~n为从表。 未找到返回空值
function  qcGetFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;

//取QuickCrud模块的 StringGrid 控件，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function  qcGetStringGrid(AForm:TForm;AIndex:Integer):TStringGrid;

//取QuickCrud模块的SQL语句，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function  qcGetSQL(AForm:TForm;AIndex:Integer):String;

//取QuickCrud模块的SQL语句中的where(返回值不包含where)，AIndex : 0 为主表， 1~n为从表。 未找到返回空值
function  qcGetWhere(AForm:TForm;AIndex:Integer):String;

//树形表转js对象
function  qcDbToOptions(AQuery:TFDQuery;AField:Variant;AMode:Integer):String;

//在quickcrud的按钮栏中插入控件
function  qcAdd(AForm:TForm;ACtrl:TWinControl):Integer;

const
    //整型类型集合
    qcstInteger : Set of TFieldType = [ftSmallint, ftInteger, ftWord, ftAutoInc,ftLargeint, ftLongWord, ftShortint, ftByte];
    //浮点型类型集合
    qcstFloat   : set of TFieldType = [ftFloat, ftCurrency, ftBCD, ftExtended, ftSingle];

implementation

//从JSON对象fields中取得字符串形式的字段列表，以用于sql语句
//AOnlyVisbile:Boolean 是否仅显示可见字段
//返回值形如：id,fieldname,filetime,size
function _GetFields(AFields:Variant;AOnlyVisbile:Boolean):String;
var
    iField      : Integer;
    joField     : variant;
begin
    try
        Result  := '';
        //拼接字段字符串
        for iField := 0 to AFields._Count-1 do begin
            //取得当前字段JSON对象
            joField := AFields._(iField);

            //控制可视化
            if AOnlyVisbile and (dwGetInt(joField,'view',0)<>0) then begin
                Continue;
            end;

            //
            if joField.Exists('name') then begin
                if joField.type <> 'check'  then begin
                    Result := Result + AFields._(iField).name + ','
                end;
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

//得到主表的字段caption列表,如：["姓名","性别","年龄","地址"]
function _GetCaptions(AFields:Variant;AOnlyVisbile:Boolean):String;
var
    iField      : Integer;
    joField     : variant;
    joRes       : Variant;
begin
    try
        joRes   := _json('[]');
        //拼接字段字符串
        for iField := 0 to AFields._Count-1 do begin
            //取得当前字段JSON对象
            joField := AFields._(iField);

            //控制可视化
            if AOnlyVisbile and (dwGetInt(joField,'view',0)<>0) then begin
                Continue;
            end;

            //
            if joField.type <> 'check'  then begin
                joRes.Add(AFields._(iField).caption);
            end;
        end;
        //
        Result  := joRes;
    except
        Result  := 'ErrorWhen_GetCaptions';
    end;
end;

//从字符串型的默认查询值中取得查询开始日期
function  _GetQueryStartDate(AValue:String):TDateTime;
begin
    if AValue = 'none' then begin               //无
        Result  := StrToDateDef('9999-09-09',Now);
    end else if AValue = 'today' then begin     //当天
        Result  := Trunc(Now);
    end else if AValue = 'week' then begin      //本周
        Result  := Trunc(StartOfTheWeek(Now));
    end else if AValue = 'month' then begin     //当月
        Result  := Trunc(StartOfTheMonth(Now));
    end else if AValue = 'year' then begin      //当年
        Result  := Trunc(StartOfTheYear(Now));
    end else if AValue = '3 days' then begin    //3天内
        Result  := Trunc(Now-2);
    end else if AValue = '7 days' then begin    //7天内
        Result  := Trunc(Now-6);
    end else if AValue = '15 days' then begin   //15天内
        Result  := Trunc(Now-14);
    end else if AValue = '1 month' then begin   //1月内
        Result  := Trunc(IncMonth(Today, -1)+1);
    end else if AValue = '3 months' then begin   //1月内
        Result  := Trunc(IncMonth(Today, -3)+1);
    end else if AValue = '6 months' then begin   //1月内
        Result  := Trunc(IncMonth(Today, -6)+1);
    end else if AValue = '1 year' then begin    //1年内
        Result  := Trunc(IncYear(Today, -1)+1);
    end else if AValue = '3 years' then begin    //3年内
        Result  := Trunc(IncYear(Today, -3)+1);
    end else if AValue = '10 years' then begin    //1年内
        Result  := Trunc(IncYear(Today, -10)+1);
    end else if AValue = 'all' then begin       //全部
        Result  := StrToDatedef('1900-01-01',Trunc(Now+1));
    end else begin
        Result  := StrToDateDef('9999-09-09',Now);;
    end;
end;

//从字符串型的默认查询值中取得查询结束日期
function  _GetQueryEndDate(AValue:String):TDateTime;
begin
    if AValue = 'none' then begin               //无
        Result  := StrToDateDef('9999-09-09',Now);
    end else if AValue = 'today' then begin     //当天
        Result  := Trunc(Now+1);
    end else if AValue = 'week' then begin      //本周
        Result  := Trunc(EndOfTheWeek(Now));
    end else if AValue = 'month' then begin     //当月
        Result  := Trunc(EndOfTheMonth(Now));
    end else if AValue = 'year' then begin      //当年
        Result  := Trunc(EndOfTheYear(Now));
    end else if AValue = '3 days' then begin    //3天内
        Result  := Trunc(Now+1);
    end else if AValue = '7 days' then begin    //7天内
        Result  := Trunc(Now+1);
    end else if AValue = '15 days' then begin   //15天内
        Result  := Trunc(Now+1);
    end else if AValue = '1 month' then begin   //1月内
        Result  := Trunc(Now+1);
    end else if AValue = '3 months' then begin   //1月内
        Result  := Trunc(Now+1);
    end else if AValue = '6 months' then begin   //1月内
        Result  := Trunc(Now+1);
    end else if AValue = '1 year' then begin    //1年内
        Result  := Trunc(Now+1);
    end else if AValue = '10 years' then begin   //10年内
        Result  := Trunc(Now+1);
    end else if AValue = 'all' then begin       //全部
        Result  := StrToDatedef('2050-01-01',Trunc(Now+1));
    end else begin
        Result  := Trunc(Now+1);
    end;
end;

//取得当前表格是否多选
//输入值：AForm为当前窗本，ASGIndex 为当前表格的序号，0：主表，1/2/3。。。为从表
//返回值：为字符串，如果没有，则为"[]",否则为类似"["3","5","6"]"
//        异常返回 NoStringGridIn_GetSelection / ErrorWhen_GetSelection
function  _GetSelection(AForm:TForm;ASGIndex:Integer):String;
var
    oSG         : TStringGrid;
    joCell      : variant;
    joRes       : Variant;
    iRow        : Integer;
begin
    try
        //默认返回值
        joRes   := _json('[]');

        //查找控件
        case ASGIndex of
            0 : begin
                oSG     := TStringGrid(AForm.FindComponent('GMn'));
            end;
        else
                oSG     := TStringGrid(AForm.FindComponent('SG'+IntTostr(ASGIndex-1)));
        end;

        //异常检查
        if oSG = nil then begin
            Result  := 'error!NoStringGridIn_GetSelection';
            Exit;
        end;

        //读SG的hint取得返回值
        joCell  := _json(oSG.cells[0,0]);
        if joCell.type = 'check' then begin
            for iRow := 1 to oSG.RowCount - 1 do begin
                if oSG.Cells[0,iRow] = 'true' then begin
                    joRes.Add(iRow);
                end;
            end;
        end;

        //
        Result  := joRes;
    except
        Result  := 'error!When_GetSelection';
    end;
end;

//根据列号，求JSON字段序号
function  _GetFieldIndexFromCol(AFields:Variant;ACol:Integer):Integer;
var
    iField  : Integer;
    iCurCol : Integer;
    //
    joField : Variant;
begin
    try
        Result  := 0;
        //
        iCurCol := -1;
        for iField := 0 to AFields._Count - 1 do begin
            joField := AFields._(iField);

            //
            if not joField.Exists('view') then begin
                joField.view := 0;
            end;

            //
            if joField.view = 0 then begin
                Inc(iCurCol);
            end;

            //找到结果
            if iCurCol = ACol then begin
                Result  := iField;
                break;
            end;
        end;

    except
        Result  := -1;
    end;

end;

//从TImage的Hint中取得文件名，不包括目录
function  _GetImageValue(AImage:TImage):String;
var
    joHint  : Variant;
begin
    Result  := '';
    joHint  := _json(AImage.Hint);
    if joHint <> unassigned then begin
        Result  := joHint.src;
        while Pos('/',Result)>0 do begin
            Delete(Result,1,Pos('/',Result));
        end;
        while Pos('\',Result)>0 do begin
            Delete(Result,1,Pos('\',Result));
        end;
    end;
end;

//在quickcrud的按钮栏中插入控件
function  qcAdd(AForm:TForm;ACtrl:TWinControl):Integer;
var
    oPBs  : TPanel;
    oBNw      : TButton;
begin
    //取得按钮面板
    oPBs      := TPanel(AForm.FindComponent('PBs'));
    //取得“新增”按钮，以设置新控件的Margins
    oBNw          := TButton(AForm.FindComponent('BNw'));
    //嵌入
    ACtrl.Parent    := oPBs;
    ACtrl.Align     := alLeft;
    //设置Margins
    ACtrl.Margins   := oBNw.Margins;
    ACtrl.AlignWithMargins  := True;
end;

//
function  qcSetMobile(AForm:TForm):Integer;
begin
    Result  := 0;
    //设置分页栏使用移动版
    with TTrackBar(AForm.FindComponent('TMa')) do begin
        HelpKeyword     := 'mobile';
        Margins.Top     := 0;
    end;
    with TStringGrid(AForm.FindComponent('GMn')) do begin
        Margins.Left    := 0;
        Margins.Right   := 0;
    end;
    with TPanel(AForm.FindComponent('PMd')) do begin
        BorderStyle     := bsNone;
        Margins.Left    := 0;
        Margins.Right   := 0;
        BevelOuter      := bvNone;
        Hint            := '';
    end;
    with TPanel(AForm.FindComponent('PQm')) do begin
        BorderStyle     := bsNone;
        Margins.Left    := 0;
        Margins.Right   := 0;
        Hint            := '';
    end;
    with TEdit(AForm.FindComponent('EKw')) do begin
        Align           := alClient;
        Margins.Left    := 20;
        Margins.Right   := 20;
        Color           := clBtnFace;
        Hint            := '{"placeholder":"搜索","prefix-icon":"el-icon-search","dwstyle":"padding-left:5px;border:solid 0px;","radius":"15px"}';
    end;
end;



//树形表转js对象
function qcDbToOptions(AQuery:TFDQuery;AField:Variant;AMode:Integer):String;
var
    I           : Integer;
    sPrevMC     : String;
    sPrevBH     : String;
    sCurrMC     : String;
    sCurrBH     : String;
begin
    case AMode of
        1 : begin
            Result  := '[';
            AQuery.Close;
            AQuery.SQL.Text := 'SELECT '+AField.id+','+AField.pid+','+AField.field
                    +' FROM '+AField.table
                    +' ORDER BY ' +AField.id+','+AField.pid;
            AQuery.FetchOptions.RecsSkip    := 0;
            AQuery.FetchOptions.RecsMax     := -1;
            AQuery.Open;
            //
            sPrevMC     := AQuery.FieldByName(AField.field).AsString;
            sPrevBH     := AQuery.FieldByName(AField.id).AsString;
            Result      := Result + '{id:'''+sPrevMC+''',label:'''+sPrevMC+''',children:[';
            //
            AQuery.Next;
            //
            while not AQuery.Eof do begin
                sCurrMC     := AQuery.FieldByName(AField.field).AsString;
                sCurrBH     := AQuery.FieldByName(AField.id).AsString;

                //如果当前记录是上一记录的子记录
                if (sPrevBH <> sCurrBH) and (Pos(sPrevBH,sCurrBH)>0) then begin    //当前是上一节点的子节点
                    Result  := Result + '{id:'''+sCurrMC+''',label:'''+sCurrMC+''',children:[';
                end else begin  //当前节点是上一节点叔/小爷节点
                    for I := (Length(sPrevBH)-Length(sCurrBH)) div 2  downto 0 do begin
                        Result  := Result + ']},';
                    end;
                    Result  := Result + '{id:'''+sCurrMC+''',label:'''+sCurrMC+''',children:[';
                end;
                sPrevMC     := sCurrMC;
                sPrevBH     := sCurrBH;
                //
                AQuery.Next;
            end;
            //
            for I := (Length(sCurrBH) div 2) - 1 downto 0 do begin
                Result  := Result + ']},';
            end;
            Result  := Result + ']';

            //删除空children
            Result  := StringReplace(Result,',children:[]','',[rfReplaceAll]);
            Result  := StringReplace(Result,',]',']',[rfReplaceAll]);


        end;
    end;
end;

//通过rtti读form的 qcConfig 变量
function qcGetConfig(AForm:TForm):String;
var
    oRC : TRttiContext;
    oRT : TRttiType;
    oRF : TRttiField;
begin
    //
    Result  := unassigned;
    //
    try
        oRC := TRttiContext.Create;
        oRT := oRC.GetType(AForm.ClassType);
        oRF := oRT.GetField('qcConfig');
        if oRF <> nil then begin
            Result  := oRF.GetValue(AForm).AsString;
        end;
    finally
        oRC.Free;
    end;
end;


function qcGetConfigJson(AForm:TForm):Variant;
var
    iSlave      : Integer;
    iField      : Integer;
    //
    joField     : Variant;
    joSlave     : Variant;
begin
    try
        //取配置JSON : 读AForm的 qcConfig 变量值
        Result  := _json(qcGetConfig(AForm));

        //如果不是JSON格式，则退出
        if Result = unassigned then begin
            Exit;
        end;
        //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        if not Result.Exists('table') then begin //默认表名
            Result.table := 'dw_member';
        end;
        if not Result.Exists('where') then begin
            Result.where := '';
        end;
        if not Result.Exists('pagesize') then begin  //默认数据每页显示的行数
            Result.pagesize  := 5;
        end;
        if not Result.Exists('rowheight') then begin//默认数据行的行高
            Result.rowheight  := 45;
        end;
        if not Result.Exists('edit') then begin     //默认显示编辑按钮
            Result.edit  := 1;
        end;
        if not Result.Exists('new') then begin      //默认显示新增按钮
            Result.new  := 1;
        end;
        if not Result.Exists('delete') then begin   //默认显示删除按钮
            Result.delete  := 1;
        end;
        if not Result.Exists('query') then begin    //默认显示查询
            Result.query  := 1;
        end;
        if not Result.Exists('hide') then begin     //默认显示隐藏按钮
            Result.hide := 1;
        end;
        if not Result.Exists('export') then begin    //默认显示导出按钮
            Result.export := 1;
        end;
        if not Result.Exists('exportonlyvisible') then begin    //默认只导出可见字段
            Result.exportonlyvisible := 1;
        end;
        if not Result.Exists('switch') then begin    //默认显示切换搜索模式按钮
            Result.switch   := 1;
        end;
        if not Result.Exists('buttons') then begin    //默认各按钮面板
            Result.buttons  := 1;
        end;
        if not Result.Exists('border') then begin    //默认表格显示竖线
            Result.border   := 1;
        end;
        if not Result.Exists('fields') then begin    //显示的字段列表
            Result.fields  := _json('[]');
        end;
        if not Result.Exists('margin') then begin   //默认边距
            Result.margin := 10;
        end;
        if not Result.Exists('radius') then begin   //默认表名
            Result.radius := 5;
        end;
        if not Result.Exists('defaulteditmax') then begin //是否默认最大化
            Result.defaulteditmax := 0;
        end;
        if not Result.Exists('defaultempty') then begin     //是否默认不显示数据
            Result.defaultempty := 0;
        end;
        //if not Result.Exists('editwidth') then begin //数据编辑框的宽度
        //    Result.editwidth := 320;
        //end;
        if not Result.Exists('editwidth') then begin //数据编辑框的宽度
            Result.editwidth := 360;
        end;
        if not Result.Exists('buttoncaption') then begin //按钮显示标题设置
            Result.buttoncaption    := 1;  //0:全不显示,1:全显示,2:左显右侧(隐藏/显示,模糊/精确,查询模式)不显
        end;
        if not Result.Exists('slavepagesize') then begin  //默认数据每页显示的行数
            Result.slavepagesize  := 5;
        end;
        if not Result.Exists('teminate') then begin  //
            Result.teminate  := 'terminate by user';
        end;

        //更新主表字段的默认值
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
            if not joField.Exists('width') then begin
                joField.width := 120;
            end;
            //
            if not joField.Exists('type') then begin
                joField.type := 'string';
            end;
            if not joField.Exists('sort') then begin        //默认不排序
                joField.sort    := 0;
            end;
            if not joField.Exists('fuzzy') then begin       //默认模糊查询
                joField.fuzzy    := 1;
            end;
            if not joField.Exists('query') then begin       //默认不查询
                joField.query   := 0;
            end;
            if not joField.Exists('align') then begin       //默认居中显示
                joField.align   := 'left';
            end;
            if not joField.Exists('view') then begin        //可见性
                joField.view    := 0;
            end;
        end;

        //更新所有slave表字段的默认值
        if Result.Exists('slave') then begin
            for iSlave := 0 to Result.slave._Count - 1 do begin
                joSlave := Result.slave._(iSlave);
                for iField := 0 to joSlave.fields._Count - 1 do begin
                    joField := joSlave.fields._(iField);
                    //
                    if not joField.Exists('name') then begin
                        joField.name    := 'id';
                    end;
                    //
                    if not joField.Exists('caption') then begin
                        joField.caption := String(joField.name);
                    end;
                    //
                    if not joField.Exists('width') then begin
                        joField.width := 120;
                    end;
                    //
                    if not joField.Exists('type') then begin
                        joField.type := 'string';
                    end;
                    if not joField.Exists('sort') then begin        //默认不排序
                        joField.sort    := 0;
                    end;
                    if not joField.Exists('fuzzy') then begin       //默认模糊查询
                        joField.fuzzy    := 1;
                    end;
                    if not joField.Exists('query') then begin       //默认不查询
                        joField.query   := 0;
                    end;
                    if not joField.Exists('align') then begin       //默认居中显示
                        joField.align   := 'left';
                    end;
                    if not joField.Exists('view') then begin        //可见性
                        joField.view    := 0;
                    end;
                end;
            end;
        end;


        //>
    except

    end;
end;


function qcAppend(
    AForm:TForm;        //控件所在窗体
    APrefix:Integer;    //控件名称的前缀，用于查找控件
    AQuery:TFDQuery;    //数据查询
    AFields:Variant;    //字段列表JSON
    AMasterValue:String;//主从表对应的主表字段值
    ASlaveName:String   //主从表对应的从表字段名称
    ):Integer;
var
    iField      : Integer;
    //
    joField     : Variant;
    joConfig    : Variant;
    //
    oComp       : TComponent;
    oCB         : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    oI          : TImage;
    //
    bAccept     : Boolean;
    iDec        : Integer;
begin
    try
        //新增
        AQuery.Append;

        //取得参数配置JSON对象，以便后续处理
        joConfig    := qcGetConfigJson(AForm);

        //append后事件
        bAccept := True;
        if Assigned(AForm.OnDragOver) then begin
            AForm.OnDragOver(AForm,nil,APrefix,2,dsDragEnter,bAccept);
            if not bAccept then begin
                dwMessage(joConfig.teminate,'error',AForm);
                Exit;
            end;
        end;


        //循环处理各字段
        iDec    := 0;
        //AFields := joConfig.fields;
        for iField := 0 to AFields._Count -1 do begin
            //取得字段的JSON
            joField := AFields._(iField);

            //避免多选列问题
            if joField.type = 'check' then begin
                iDec    := -1;
                continue;
            end;

            //取得对应控件
            oComp   := AForm.FindComponent('F'+IntToStr(APrefix) + IntToStr(iField));

            //如果找到了控件（有可能因为view<>0的原因找不到）
            if oComp <> nil then begin

                //根据当前字段JSON信息进行处理
                if joField.type = 'auto' then begin
                    oE      := TEdit(oComp);
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
                    TEdit(oComp).Enabled    := False;
                end else if joField.type = 'combo' then begin
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oCB.Text    := AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'combopair' then begin
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oCB.Text    := AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'dbcombo' then begin
                    oCB := TComboBox(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oCB.Text:= AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'image' then begin
                    oI  := TImage(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString  := joField.default;
                    end;
                    oI.Hint := '{"src":"'+joField.imgdir+AQuery.Fields[iField+iDec].AsString+'"}';
                end else if joField.type = 'integer' then begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsInteger  := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsInteger = null then begin
                            AQuery.Fields[iField+iDec].AsInteger   := 0;
                        end;
                    end;
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
                end else if joField.type = 'date' then begin
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsDateTime := StrToDateDef(joField.default,Now);
                    end else begin
                        if AQuery.Fields[iField+iDec].IsNull then begin
                            AQuery.Fields[iField+iDec].AsDateTime := Now;
                        end;
                    end;
                    oDT.Kind    := dtkDate;
                    oDT.Date    := AQuery.Fields[iField+iDec].AsDateTime;
                end else if joField.type = 'time' then begin
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsDateTime := StrToTimeDef(joField.default,Now);
                    end else begin
                        if AQuery.Fields[iField+iDec].IsNull then begin
                            AQuery.Fields[iField+iDec].AsDateTime := Now;
                        end;
                    end;
                    oDT.Kind    := dtkTime;
                    oDT.Time    := AQuery.Fields[iField+iDec].AsDateTime;
                end else if joField.type = 'datetime' then begin
                    oDT := TDateTimePicker(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsDateTime := StrToDateTimeDef(String(joField.default),Now);
                    end else begin
                        if AQuery.Fields[iField+iDec].IsNull then begin
                            AQuery.Fields[iField+iDec].AsDateTime := Now;
                        end;
                    end;
                    oDT.DateTime    := AQuery.Fields[iField+iDec].AsDateTime;
                end else if joField.type = 'money' then begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsFloat   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsFloat = null then begin
                            AQuery.Fields[iField+iDec].AsFloat   := 0;
                        end;
                    end;
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
                end else begin
                    oE  := TEdit(oComp);
                    if joField.Exists('default') then begin
                        AQuery.Fields[iField+iDec].AsString   := joField.default;
                    end else begin
                        if AQuery.Fields[iField+iDec].AsString = null then begin
                            AQuery.Fields[iField+iDec].AsString   := '';
                        end;
                    end;
                    oE.Text := AQuery.Fields[iField+iDec].AsString;
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

                //处理主从表关联字段
                if joField.name = ASlaveName then begin
                    if joField.type = 'integer' then begin
                        AQuery.Fields[iField+iDec].AsInteger  := StrToIntDef(AMasterValue,0);
                        oE          := TEdit(oComp);
                        oE.Text     := AQuery.Fields[iField+iDec].AsString;
                        oE.Enabled  := False;
                    end else begin
                        AQuery.Fields[iField+iDec].AsString   := AMasterValue;
                        oE          := TEdit(oComp);
                        oE.Text     := AQuery.Fields[iField+iDec].AsString;
                        oE.Enabled  := False;
                    end;
                end;
            end;
        end;
    except
    end;
end;



function qcGetFDQuery(AForm:TForm;AIndex:Integer):TFDQuery;
begin
    if AIndex = 0 then begin
        Result  := TFDQuery(AForm.FindComponent('FQ_Main'));
    end else if AIndex = -1 then begin
        Result  := TFDQuery(AForm.FindComponent('FDQueryTmp'));
    end else begin
        Result  := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(AIndex-1)));
    end;
end;
function qcGetStringGrid(AForm:TForm;AIndex:Integer):TStringGrid;
begin
    if AIndex = 0 then begin
        Result  := TStringGrid(AForm.FindComponent('GMn'));
    end else begin
        Result  := TStringGrid(AForm.FindComponent('SG'+IntToStr(AIndex-1)));
    end;
end;

//通过rtti为form的 qcConfig 变量 赋值
function qcSetConfig(AForm:TForm;AConfig:String):Integer;
var
    oRC : TRttiContext;
    oRT : TRttiType;
    oRF : TRttiField;
begin
    //
    Result  := 0;
    //
    try
        oRC := TRttiContext.Create;
        oRT := oRC.GetType(AForm.ClassType);
        oRF := oRT.GetField('qcConfig');
        if oRF <> nil then begin
            oRF.SetValue(AForm,AConfig);
        end else begin
            Result  := -1;
        end;
    finally
        oRC.Free;
    end;
end;

function  qcGetSQL(AForm:TForm;AIndex:Integer):String;
var
    oFDQuery    : TFDQuery;
begin
    Result  := '';
    case AIndex of
        0 : begin
            oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));
        end
    else
            oFDQuery    := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(AIndex-1)));
    end;
    if oFDQuery<>nil then begin
        Result  := oFDQuery.SQL.Text;
    end;
end;


function  qcGetWhere(AForm:TForm;AIndex:Integer):String;
var
    Regex       : TRegEx;
    Match       : TMatch;
begin
    Result  := qcGetSQL(AForm,AIndex);

    // 正则表达式匹配 WHERE 子句
    Regex   := TRegEx.Create('(?i)\bWHERE\b\s*(.*?)(?=\bORDER BY\b|\bGROUP BY\b|$)', [roIgnoreCase]);
    Match   := Regex.Match(Result);

    if Match.Success then begin
        Result := Match.Groups[1].Value.Trim; // 返回 WHERE 子句内容
    end else begin
        Result := ''; // 如果没有找到，返回空字符串
    end;

end;

//智能查询关键字输入框EKw (Edit keyword) 输入事件
Procedure EKwChange(Self: TObject; Sender: TObject);
var
    oEKw    : TEdit;
    oForm   : TForm;
    oTMa    : TTrackBar;
begin
    //dwMessage('EKwChange','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oEKw    := TEdit(Sender);
    oForm   := TForm(oEKw.Owner);
    oTMa    := TTrackBar(oForm.FindComponent('TMa'));

    //
    oTMa.Position   := 0;

    //更新主表数据
    qcUpdateMain(TForm(TEdit(Sender).Owner),'');

    //更新从表数据
    qcUpdateSlaves(TForm(TEdit(Sender).Owner));
end;

procedure FormEndDock(Self: TObject; Sender, Target: TObject; X, Y: Integer);
var
    oForm   : TForm;
    oButton : TButton;
    oComp   : TComponent;
    sID     : string;
    sFile   : String;
    sSource : String;
    sDir    : String;
    //
    joHint  : Variant;
begin


    oForm   := TForm(Sender);

    //
    sFile   := dwGetProp(oForm,'__upload');
    sSource := dwGetProp(oForm,'__uploadsource');

    //取得上传时设定的uploadid，主要是区分是哪个字段上传的图片
    sId     := dwGetProp(oForm,'__uploadid');

    oButton     := TButton(oForm.FindComponent('FB'+sID));

    //异常检查
    if oButton = nil then begin
        dwMessage('error when FormEndDock! 0','error',oForm);
        Exit;
    end;

    joHint      := _json(oButton.Hint);

    //将上传完成的文件改重命名为源文件名
    sDir        := ExtractFilePath(Application.ExeName)+String(joHint.imgdir);
    RenameFile(sDir+sFile,sDir+sSource);

    //
    oComp   := oForm.FindComponent('F'+sID);

    //异常检查
    if oComp = nil then begin
        dwMessage('error when FormEndDock! 1','error',oForm);
        Exit;
    end;

    if oComp.ClassName = 'TImage' then begin
        TImage(oComp).Hint      := '{"src":"'+joHint.imgdir+sSource+'"}';
    end else begin
        TLabel(oComp).Caption   := sSource;
    end;
end;

Procedure FQyResize(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oFQy        : TFlowPanel;
    oPBs        : TPanel;
    oGMn        : TStringGrid;
    oPTM        : TPanel;
    oPCS        : TPageControl;
    oChange     : Procedure(Sender:TObject) of Object;
    oPSB        : TPanel;
begin
    //取得各控件
    oFQy        := TFlowPanel(Sender);
    oForm       := TForm(oFQy.Owner);
    oPBs        := TPanel(oForm.FindComponent('PBs'));
    oGMn        := TStringGrid(oForm.FindComponent('GMn'));
    oPTM        := TPanel(oForm.FindComponent('PTM'));
    oPCS        := TPageControl(oForm.FindComponent('PCS'));
    oPSB        := TPanel(oForm.FindComponent('PSB'));
    //控制各控件大小位置信息
    if oPTM <> nil then begin
        //
        oChange         := oFQy.OnResize;
        oFQy.OnResize   := nil;
        oFQy.AutoSize   := True;
        oFQy.AutoSize   := False;
        //
        oPBs.Top        := oFQy.top + oFQy.Height + 10;
        oGMn.Top        := oPBs.Top + oPBs.Height;
        //
        if ( oPCS <> nil ) and oPCS.Visible then begin
            oPCS.Top    := oPTM.Top + oPTM.Height + 10;
            oPCS.Height := oForm.Height - oPCS.Top - 10;
            oPSB.Top    := oPCS.top + 1;
            oPTM.Top    := oGMn.Top + oGMn.Height;
        end else begin
            oGMn.Height := oPTM.Top - oGMn.Top;
        end;
        //
        oFQy.OnResize   := oChange;
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
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-c-scale-to-original"}';
        oButton.Caption := '精确';
    end else begin
        //模糊
        oButton.Tag     := 0;
        oButton.Hint    := '{"style":"plain","type":"info","icon":"el-icon-open"}';
        oButton.Caption := '模糊';
    end;
end;

Procedure BQmClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oFQy        : TFlowPanel;
    oPQSmt      : TPanel;
    oBFz    : TButton;
begin
    //dwMessage('BQmClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent('FQy'));
    oPQSmt      := TPanel(oForm.FindComponent('PQm'));
    oBFz        := TButton(oForm.FindComponent('BFz'));
    //
    oButton.Tag := oButton.Tag - 1;
    if not(oButton.Tag in [0,1,2]) then begin
        oButton.Tag := 2;
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
            end;
        else
        end;
    end;
end;

Procedure BQyClick(Self: TObject; Sender: TObject); //"查询"按钮 BQy - Button Query
var
    oButton     : TButton;
    oForm       : TForm;
    oTMa    : TTrackBar;
begin
    //dwMessage('BQyClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oTMa        := TTrackBar(oForm.FindComponent('TMa'));

    //设置为第1页
    oTMa.Position   := 0;

    //置标志，表示已查询，即当前查询条件有效
    TButton(Sender).Tag := 1;

    //更新主表
    qcUpdateMain(TForm(TEdit(Sender).Owner),'');

    //更新各从表
    qcUpdateSlaves(TForm(TEdit(Sender).Owner));
end;

Procedure BUpClick(Self: TObject; Sender: TObject); //"图片上传"按钮 BUp - Button upload
var
    oButton     : TButton;
    oForm       : TForm;
    joHint      : Variant;
    iItem       : Integer;
    sImgDir     : String;
    sAccept     : String;
    sName       : String;
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

    //取得按钮名称，如：'FB'+ASuffix ，以保存当前id，用于上传完成后更新相关控件值
    sName   := oButton.Name;
    Delete(sName,1,2);
    dwSetProp(oForm,'__uploadid',sName);

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

    //
    dwUpload(oForm, sAccept, sImgDir);
end;

Procedure BQCClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oPQy    : TPanel;
begin
    //dwMessage('BQCClick','',TForm(TEdit(Sender).Owner));

    //
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPQy        := TPanel(oForm.FindComponent('PQy'));

    //关闭查询窗体
    oPQy.Visible    := False;
end;

Procedure BQXClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oForm1      : TForm;
    oPQy    : TPanel;
    oPCS   : TPageControl;
    oFC : TFlowPanel;
    //
    iItem       : Integer;
    //
    joConfig    : variant;

begin
    //dwMessage('BQXClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPQy    := TPanel(oForm.FindComponent('PQy'));
    oPCS   := TPageControl(oForm.FindComponent('PCS'));

    //
    if oForm.Owner <> nil then begin
        oForm1  := TForm(oForm.Owner);
    end else begin
        oForm1  := oForm;
    end;

    //先设置非AutoSize
    for iItem := 1 to oPCS.PageCount do begin
        oFC := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iItem)));
        oFC.AutoSize    := False;
    end;

    //
    joConfig    := qcGetConfigJson(oForm);

    //
    if oForm1.Width < 500 then begin
        if oPQy.Width = Min(oForm1.width-20,joConfig.editwidth) then begin
            //标志当前最大化
            oButton.Tag := 9;
            //最大化
            oPQy.Width      := oForm1.Width - 20;
            oPQy.Top        := 10;
            oPQy.Height     := oForm1.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPQy.Width     := Min(oForm1.width-20,joConfig.editwidth);
            oPQy.Top       := 10;
            oPQy.Height    := oForm1.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end;
    end else begin
        //标志当前正常大小
        oButton.Tag := 0;

        //正常界面
        if oPQy.Width = Min(oForm1.width-100,joConfig.editwidth) then begin
            oPQy.Width     := oForm1.width-100;
            oPQy.Top       := 50;
            oPQy.Height    := oForm1.Height - 100;
            oButton.Hint       := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPQy.Width      := Min(oForm1.Width - 100,joConfig.editwidth);
            oPQy.Top        := 50;
            oPQy.Height     := oForm.Height - 100;
            oButton.Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        end;
    end;

    //设置AutoSize,以配合ScrollBox滚动
    for iItem := 1 to oPCS.PageCount do begin
        oFC := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iItem)));
        oFC.AutoSize    := True;
    end;
end;

Procedure BQUClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oPCS        : TPageControl;
    oPQy        : TPanel;
    oSBQ        : TScrollBox;
    oFC         : TFlowPanel;
    oPQF        : TPanel;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oE_Query    : TEdit;
    oCBQy       : TComboBox;
    oBFz        : TButton;

    //
    iSlave      : Integer;
    iField      : Integer;
    iItem       : Integer;
    //
    sWhere      : string;   //主表的关键字段值
    sType       : string;
    sStart,sEnd : String;
    //
    joConfig    : variant;
    joSlave     : variant;
    joField     : Variant;
    joTemp      : Variant;
begin
    //=====
    //说明：将查询条件写入对应的ScrollBox中，如："where":((ID<10) AND (name like '%west%'))
    //      在qcUpdateSlaves中读取这些值，然后刷新显示
    //=====

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPCS        := TPageControl(oForm.FindComponent('PCS'));
    iSlave      := oPCS.ActivePageIndex;
    oSBQ        := TScrollBox(oForm.FindComponent('SBQ'+IntToStr(iSlave+1)));
    oFC         := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iSlave+1)));
    oPQy        := TPanel(oForm.FindComponent('PQy'));
    oBFz        := TButton(oForm.FindComponent('BFz'));

    //
    joConfig    := qcGetConfigJson(oForm);
    joSlave     := joConfig.slave._(iSlave);

    //
    sWhere      := '(';
    for iItem := 0 to oFC.ControlCount - 1 do begin

        //得到当前查询字段的panel,其中包括：Label + Edit/Combox/DatetimePicker
        oPQF := TPanel(oFC.Controls[iItem]);

        //取得字段序号
        iField      := oPQF.Tag;

        //如果 <0, 则表示为按钮组，跳出
        if (iField < 0) or (iField>=joSlave.fields._Count) then begin
            Continue;
        end;

        //取得当前字段对象
        joField     := joSlave.fields._(iField);
        if joField.Exists('type') then begin
            sType   := joField.type;
        end else begin
            sType   := 'string';
        end;

        //根据字段类型分类处理
        if sType = 'date' then begin

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
        end else if (sType = 'datetime') then begin
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
        end else if (sType = 'combo')  OR (sType = 'combopair') OR (sType = 'dbcombo') then begin
            oCBQy   := TComboBox(oPQF.Controls[1]);
            if Trim(oCBQy.Text) <> '' then begin
                //
                if oBFz.Tag = 0 then begin
                    sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCBQy.Text)+'%'' ) AND ';
                end else begin
                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCBQy.Text)+''' ) AND ';
                end;
            end;
        end else begin  //
            oE_Query    := TEdit(oPQF.Controls[1]);
            if Trim(oE_Query.Text) <> '' then begin
                //
                if oBFz.Tag = 0 then begin
                    sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) AND ';
                end else begin
                    sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) AND ';
                end;
            end;
        end;

    end;

    //删除最后的 ' AND '
    if Length(sWhere)>5 then begin
        sWhere  := Copy(sWhere,1,Length(sWhere)-5);
        //
        sWhere  := sWhere + ')';
    end else begin
        sWhere  := '';
    end;

    //将当前查询条件保存到对应的ScrollBox中
    joTemp  := _json(oSBQ.Hint);
    if joTemp = unassigned then begin
        joTemp  := _json('{}');
    end;
    joTemp.where    := sWhere;
    oSBQ.Hint      := joTemp;

    //
    oPQy.Visible    := False;
    //
    qcUpdateSlaves(oForm);
end;

Procedure BRSClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oPCS        : TPageControl;
    oFC         : TFlowPanel;
    oSBQ        : TScrollBox;
    oPQF        : TPanel;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oE_Query    : TEdit;
    oCBQy       : TComboBox;

    //
    iItem       : Integer;
    iSlave      : Integer;
    iField      : Integer;
    //
    sType       : string;

    //
    joConfig    : variant;
    joSlave     : variant;
    joField     : Variant;
{
    oFC : TFlowPanel;
    oPQF : TPanel;
    oCtrl       : TComponent;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oE_Query    : TEdit;
    oCBQy   : TComboBox;
    oBFz    : TButton;

    //
    iSlave      : Integer;
    iField      : Integer;
    iItem       : Integer;
    //
    sWhere      : string;   //主表的关键字段值
    sType       : string;
    sStart,sEnd : String;
    //
    joConfig    : variant;
    joSlave     : variant;
    joField     : Variant;
    joTemp      : Variant;

}
begin
    //=====
    //说明：清空ScrollBox中的查询条件
    //      在qcUpdateSlaves中读取这些值，然后刷新显示
    //=====

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPCS   := TPageControl(oForm.FindComponent('PCS'));

    //
    joConfig    := qcGetConfigJson(oForm);
    joSlave     := joConfig.slave._(iSlave);

    //
    for iSlave := 0 to oPCS.PageCount - 1 do begin
        //清空已有的条件项

        //
        oFC := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iSlave+1)));

        for iItem := 0 to oFC.ControlCount - 1 do begin
            //得到当前查询字段的panel,其中包括：Label + Edit/Combox/DatetimePicker
            oPQF := TPanel(oFC.Controls[iItem]);

            //取得字段序号
            iField      := oPQF.Tag;

            //如果 <0, 则表示为按钮组，跳出
            if (iField < 0) or (iField>=joSlave.fields._Count) then begin
                Continue;
            end;

            //取得当前字段对象
            joField     := joSlave.fields._(iField);
            if joField.Exists('type') then begin
                sType   := joField.type;
            end else begin
                sType   := 'string';
            end;

            //根据字段类型分类处理
            if sType = 'date' then begin

                //取得起始结束日期控件
                oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
                oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);

                //
                oDT_Start.Date  := StrToDateDef('1900-01-01',0);
                oDT_End.Date    := StrToDateDef('2500-12-31',Now);

            end else if (sType = 'datetime') then begin
                oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]));
                if oDT_Start.HelpContext = 1 then begin //起始时间
                    oDT_Start.Date  := StrToDateTimeDef('1900-01-01 00:00:00',0);
                end;
                if oDT_Start.HelpContext = -1 then begin //结束时间
                    oDT_Start.Date  := StrToDateTimeDef('2500-12-31 23:59:59',Now);
                end;
            end else if (sType = 'combo') OR (sType = 'combopair') OR (sType = 'dbcombo') then begin
                oCBQy   := TComboBox(oPQF.Controls[1]);
                oCBQy.Text  := '';
            end else begin  //
                oE_Query    := TEdit(oPQF.Controls[1]);
                oE_Query.Text   := '';
            end;
        end;

        //
        oSBQ       := TScrollBox(oForm.FindComponent('SBQ'+IntToStr(iSlave+1)));
        oSBQ.Hint  := '';
    end;

    //
    qcUpdateSlaves(oForm);
end;

//多字段查询时的重置事件
Procedure B_ResetClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oBQy        : TButton;
    oForm       : TForm;
    oPQy        : TPanel;
    oPQF        : TPanel;
    oFQy        : TFlowPanel;
    oE_Query    : TEdit;
    oTMa        : TTrackBar;
    oCBQy       : TComboBox;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    //
    iItem       : Integer;
    iField      : Integer;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //dwMessage('B_ResetClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oFQy        := TFlowPanel(oForm.FindComponent('FQy'));
    oTMa        := TTrackBar(oForm.FindComponent('TMa'));
    oBQy        := TButton(oForm.FindComponent('BQy'));


    //置标志，表示未处于查询状态，即当前查询条件无效
    oBQy.Tag    := 1;

    //取得配置JSON对象
    joConfig    := _json(qcGetConfig(oForm));
    //默认主表分页为第1页
    oTMa.Position   := 0;
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
        if joField.type = 'date' then begin
            //取得起始结束日期控件
            oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
            oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);
            //
            if joField.Exists('min') then begin
                oDT_Start.Date  := StrToDateDef(joField.min,Now);
            end else begin
                oDT_Start.Date  := StrToDateDef('1900-01-01',Now);;
            end;
            //
            if joField.Exists('max') then begin
                oDT_End.Date    := StrToDateDef(joField.max,Now);
            end else begin
                oDT_End.Date    := StrToDateDef('2500-12-31',Now);;
            end;
        end else if joField.type = 'datetime' then begin
            //取得起始结束日期控件
            oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]));
            //
            if oDT_Start.HelpContext = 1 then begin
                if joField.Exists('min') then begin
                    oDT_Start.Date  := StrToDateTimeDef(String(joField.min),Now);
                end else begin
                    oDT_Start.Date  := StrToDateTimeDef('1900-01-01 00:00:00',Now);;
                end;
            end;
            //
            if oDT_Start.HelpContext = -1 then begin
                if joField.Exists('max') then begin
                    oDT_Start.Date  := StrToDateTimeDef(String(joField.max),Now);
                end else begin
                    oDT_Start.Date  := StrToDateTimeDef('2500-12-31 23:59:59',Now);;
                end;
            end;
        end else if (joField.type = 'combo') OR (joField.type = 'combopair') OR (joField.type = 'dbcombo') then begin
            oCBQy   := TComboBox(oPQF.Controls[1]);
            oCBQy.ItemIndex := 0;
        end else begin
            oE_Query        := TEdit(oPQF.Controls[1]);
            oE_Query.Text   := '';
        end;
    end;

    qcUpdateMain(TForm(TEdit(Sender).Owner),'');
    qcUpdateSlaves(TForm(TEdit(Sender).Owner));
end;

Procedure CB_PageSizeChange(Self: TObject; Sender: TObject);
var
    oCB_PageSize: TComboBox;
    oForm       : TForm;
    oGMn    : TStringGrid;
    //
    joConfig    : Variant;
    iOldPageSz  : Integer;
    iNewPageSz  : Integer;
    iItem       : Integer;
begin
    //dwMessage('CB_PageSizeChange','',TForm(TComboBox(Sender).Owner));
    //取得各控件
    oCB_PageSize:= TComboBox(Sender);
    oForm       := TForm(oCB_PageSize.Owner);
    oGMn    := TStringGrid(oForm.FindComponent('GMn'));
    //取得当前配置
    joConfig            := qcGetConfigJson(oForm);
    //更新配置,保存PageSize
    iOldPageSz          := joConfig.pagesize;
    iNewPageSz          := StrToIntDef(oCB_PageSize.Text,iOldPageSz);
    joConfig.pagesize   := iNewPageSz;
    qcSetConfig(oForm,joConfig);
    //
    if iNewPageSz > iOldPageSz then begin
        for iItem := iOldPageSz to iNewPageSz -1 do begin
            //dwSGAddRow(oGMn);
        end;
        oGMn.RowCount   := 1 + iNewPageSz;
        //更新数据
        qcUpdateMain(TForm(TEdit(Sender).Owner),'');
        qcUpdateSlaves(TForm(TEdit(Sender).Owner));
    end;
    //
    if iNewPageSz < iOldPageSz then begin
        for iItem := iOldPageSz-1 downto iNewPageSz do begin
            //dwSGDelRow(oGMn);
        end;
        oGMn.RowCount   := 1 + iNewPageSz;
        //更新数据
        qcUpdateMain(TForm(TEdit(Sender).Owner),'');
        qcUpdateSlaves(TForm(TEdit(Sender).Owner));
    end;
end;

Procedure BDOClick(Self: TObject; Sender: TObject); //Button Delete OK
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oSQuery     : TFDQuery;
    oPanel      : TPanel;
    //
    iSlave      : Integer;
    iSelect     : Integer;
    iRow        : Integer;
    //
    sMValue     : string;   //主表的关键字段值
    sSelect     : string;   //用于取得当前多选列的选择信息，如["1","5","6"]
    //
    joConfig    : variant;
    joSlave     : variant;
    joSelect    : Variant;
begin
    //删除时的确定按钮事件
    //dwMessage('BDOClick','',TForm(TEdit(Sender).Owner));


    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('PDe'));


    //oTMa    := TTrackBar(oForm.FindComponent('TMa'));
    //默认到第1页
    //oTMa.Position   := 0;

    //取得配置JSON对象
    joConfig    := _json(qcGetConfig(oForm));

    //根据 oPanel.Tag 区分当前删除的是主表，还是从表
    //0：表示主表，其他表示从表，1：从表0
    if oPanel.Tag = 0 then begin
        oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));

        //得到当前表格的选择信息
        sSelect := _GetSelection(oForm,0);

        //异常检查
        if Pos('error',sSelect) > 0 then begin
            dwMessage('error result _GetSelection','error',oForm);
            exit;
        end;

        //根据是否已通过checkbox选择情况分别处理
        if sSelect = '[]' then begin
            //先删除关联的从表记录
            if joConfig.Exists('slave') then begin
                oSQuery    := TFDQuery.Create(oForm);
                oSQuery.Connection := oQuery.Connection;
                for iSlave := 0 to joConfig.slave._Count-1 do begin
                    joSlave := joConfig.slave._(iSlave);
                    //取得关联值
                    sMValue := oQuery.FieldByName(joSlave.masterfield).AsString;
                    //执行删除
                    oSQuery.Close;
                    if oQuery.FieldByName(joSlave.masterfield).DataType in
                        [ftSmallint, ftInteger, ftWord, ftAutoInc]
                    then begin
                        oSQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                                +' WHERE '+joSlave.slavefield+'='+sMValue;
                    end else begin
                        oSQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                                +' WHERE '+joSlave.slavefield+'='''+sMValue+'''';
                    end;
                    oSQuery.ExecSQL;
                end;
                oSQuery.Destroy;
            end;

            //
            oQuery.Delete;
            //
            qcUpdateMain(oForm,'');
        end else begin

            //转换化JSON
            joSelect    := _json(sSelect);
            //先删除关联的从表记录
            for iSelect := joSelect._Count - 1 downto 0 do begin //反向
                //取得多选的项，为当前行号
                iRow    := StrToIntDef(joSelect._(iSelect),-1);

                //异常检查
                if (iRow <1 ) or ( iRow > oQuery.RecordCount) then begin
                    Continue;
                end;

                //跳转到主表相关记录处
                oQuery.RecNo    := iRow;

                //删除关联的从表记录
                if joConfig.Exists('slave') then begin
                    oSQuery    := TFDQuery.Create(oForm);
                    oSQuery.Connection := oQuery.Connection;
                    for iSlave := 0 to joConfig.slave._Count-1 do begin
                        joSlave := joConfig.slave._(iSlave);
                        //取得关联值
                        sMValue := oQuery.FieldByName(joSlave.masterfield).AsString;
                        //执行删除
                        oSQuery.Close;
                        if oQuery.FieldByName(joSlave.masterfield).DataType in
                            [ftSmallint, ftInteger, ftWord, ftAutoInc]
                        then begin
                            oSQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                                    +' WHERE '+joSlave.slavefield+'='+sMValue;
                        end else begin
                            oSQuery.SQL.Text   := 'DELETE FROM '+joSlave.table
                                    +' WHERE '+joSlave.slavefield+'='''+sMValue+'''';
                        end;
                        oSQuery.ExecSQL;
                    end;
                    oSQuery.Destroy;
                end;

                //删除主表记录
                oQuery.Delete;
            end;
            //
            qcUpdateMain(oForm,'');
        end;
    end else begin
        //=====此处为删除从表

        //从表序号
        iSlave  := oPanel.Tag - 1;

        //得到当前表格的选择信息
        sSelect := _GetSelection(oForm,iSlave+1);

        //异常检查
        if Pos('error',sSelect) > 0 then begin
            dwMessage('error result _GetSelection','error',oForm);
            exit;
        end;

        //得到从表FDQuery
        oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

        //转换化JSON
        joSelect    := _json(sSelect);

        if joSelect._Count = 0 then begin
            //确保删除的记录不出错
            if oQuery.RecNo <> oQuery.Tag then begin
                oQuery.RecNo    := oQuery.Tag;
            end;

            //
            oQuery.Delete;
        end else begin
            for iSelect := joSelect._Count - 1 downto 0 do begin //反向
                //取得多选的项，为当前行号
                iRow    := StrToIntDef(joSelect._(iSelect),-1);

                //异常检查
                if (iRow <1 ) or ( iRow > oQuery.RecordCount) then begin
                    Continue;
                end;

                //跳转到主表相关记录处
                oQuery.RecNo    := iRow;

                //
                oQuery.Delete;
            end;

        end;
    end;
    //
    qcUpdateSlaves(oForm);
    //
    oPanel.Visible  := False;
end;

Procedure BDCClick(Self: TObject; Sender: TObject);
var
    oButton : TButton;
    oForm   : TForm;
    oPanel  : TPanel;
begin
    //dwMessage('BDCClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('PDe'));
    //关闭面板
    oPanel.Visible  := False;
end;

Procedure BEKClick(Self: TObject; Sender: TObject);     //BEK Button Edit OK
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oQueryTmp   : TFDQuery;
    oBEA        : TButton;
    oPEr        : TPanel;
    oE_Field    : TEdit;
    oI_Field    : TImage;
    oDT_Field   : TDateTimePicker;
    oComp       : TComponent;
    oCB_Field   : TComboBox;
    oDT         : TDateTimePicker;
    oE          : TEdit;
    oCKB        : TCheckBox;
    //
    iSlave      : Integer;
    iField      : Integer;
    iItem       : Integer;
    iTemp       : Integer;
    iDec        : Integer;
    //
    bAccept     : Boolean;
    //
    sMValue     : string;   //主表的关键字段值
    sOldValue   : string;   //编辑前字段值，用于防重
    //
    joConfig    : variant;
    joSlave     : variant;
    joField     : Variant;
begin
    //编辑/新增面板的确定按钮事件
    //dwMessage('BDOClick','',TForm(TEdit(Sender).Owner));


    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEr        := TPanel(oForm.FindComponent('PEr'));
    oBEA        := TButton(oForm.FindComponent('BEA'));   //取消按钮，用于记录是否批量新增过
    oCKB        := TCheckBox(oForm.FindComponent('CKB'));

    //用于表示因多选列造成的序号偏差
    iDec        := 0;

    //取得Query备用
    oQueryTmp   := TFDQuery(oForm.FindComponent('FDQueryTmp'));

    //取得配置JSON对象
    joConfig    := _json(qcGetConfig(oForm));
    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oPEr.Tag of
        0 : begin   //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            //更新数值
            oQuery.Edit;
            iDec    := 0;
            for iField := 0 to joConfig.fields._Count -1 do begin

                //得到字段JSON对象
                joField := joConfig.fields._(ifield);

                //避免多选列问题
                if joField.type = 'check' then begin
                    iDec    := -1;
                    continue;
                end;

                //保存当前字段值，以用于防重
                sOldValue   := oQuery.Fields[iField+iDec].AsString;

                //
                oComp   := oForm.FindComponent('F0'+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    if joField.type = 'auto' then begin
                        Continue;
                    end else if joField.type = 'boolean' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);
                    end else if joField.type = 'combo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'combopair' then begin   //根据字符串对进行保存
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := '';
                        if oCB_Field.Text <> '' then begin
                            for iTemp := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iTemp)._(0) = oCB_Field.text then begin
                                    oQuery.Fields[iField+iDec].AsString  := joField.list._(iTemp)._(1);
                                    break;
                                end;
                            end;
                        end;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'file' then begin
                        oQuery.Fields[iField+iDec].AsString := TLabel(oComp).Caption;
                    end else if joField.type = 'image' then begin
                        oI_Field    := TImage(oComp);
                        oQuery.Fields[iField+iDec].AsString := _GetImageValue(oI_Field);
                    end else if joField.type = 'integer' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsInteger := StrToIntDef(oE_Field.text,0);
                    end else if joField.type = 'date' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Date;
                    end else if joField.type = 'time' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Time;
                    end else if joField.type = 'datetime' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.DateTime;
                    end else if joField.type = 'money' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsFloat := StrToFloatDef(oE_Field.text,0);
                    end else begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsString := oE_Field.text;
                    end;
                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iField+iDec].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oQueryTmp.Close;
                            if oQuery.Fields[iField+iDec].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iField+iDec].AsString;
                            end else begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iField+iDec].AsString+'''';
                            end;
                            oQueryTmp.Open;

                            //根据当前字段是否更改分别处理
                            if sOldValue = oQuery.Fields[iField+iDec].AsString then begin
                                if oQueryTmp.Fields[0].AsInteger > 1 then begin
                                    //
                                    dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                    oQuery.Cancel;
                                    Exit;
                                end;
                            end else begin
                                if oQueryTmp.Fields[0].AsInteger > 0 then begin
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

            //Post前事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,3,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;
            //关闭伪窗体
            oPEr.Visible  := False;

            //Post后事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,4,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;
        end;
        //从表编辑
        1..99 : begin
            iSlave  := oPEr.Tag - 1;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
            //更新数值
            oQuery.Edit;
            iDec    := 0;
            for iField := 0 to joConfig.slave._(iSlave).fields._Count - 1 do begin
                joField := joConfig.slave._(iSlave).fields._(ifield);

                //避免多选列问题
                if joField.type = 'check' then begin
                    iDec    := -1;
                    continue;
                end;

                //
                if joField.readonly = 1 then begin
                    continue;
                end;

                //保存当前字段值，以用于防重
                sOldValue   := oQuery.Fields[iField+iDec].AsString;

                //
                oComp   := oForm.FindComponent('F'+IntToStr(iSlave+1)+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    if joField.type = 'auto' then begin
                        Continue;
                    end else if joField.type = 'boolean' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);
                    end else if joField.type = 'combo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'combopair' then begin   //根据预设的二维数组list进行比对保存
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := '';
                        if oCB_Field.Text <> '' then begin
                            for iTemp := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iTemp)._(0) = oCB_Field.text then begin
                                    oQuery.Fields[iField+iDec].AsString  := joField.list._(iTemp)._(1);
                                    break;
                                end;
                            end;
                        end;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'image' then begin
                        oI_Field    := TImage(oComp);
                        oQuery.Fields[iField+iDec].AsString := _GetImageValue(oI_Field);
                    end else if joField.type = 'integer' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsInteger := StrToIntDef(oE_Field.text,0);
                    end else if joField.type = 'date' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Date;
                    end else if joField.type = 'time' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Time;
                    end else if joField.type = 'datetime' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.DateTime;
                    end else if joField.type = 'money' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsFloat := StrToFloatDef(oE_Field.text,0);
                    end else begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsString := oE_Field.text;
                    end;
                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iField+iDec].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oQueryTmp.Close;
                            if oQuery.Fields[iField+iDec].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.slave._(iSlave).table
                                        +' WHERE ('+joField.name+'='+oQuery.Fields[iField+iDec].AsString+')';
                            end else begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.slave._(iSlave).table
                                        +' WHERE ('+joField.name+'='''+oQuery.Fields[iField+iDec].AsString+''')';
                            end;
                            oQueryTmp.Open;



                            //根据当前字段是否更改分别处理
                            if sOldValue = oQuery.Fields[iField+iDec].AsString then begin
                                if oQueryTmp.Fields[0].AsInteger > 1 then begin
                                    //
                                    dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                    oQuery.Cancel;
                                    Exit;
                                end;
                            end else begin
                                if oQueryTmp.Fields[0].AsInteger > 0 then begin
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

            //Post前事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,iSlave+1,3,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //
            oQuery.UpdateOptions.CountUpdatedRecords := False;
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;

            //Post后事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,iSlave+1,4,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //关闭伪窗体
            oPEr.Visible  := False;
        end;
        100 : begin   //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            //更新数值
            for iField := 0 to joConfig.fields._Count -1 do begin
                joField := joConfig.fields._(ifield);

                //避免多选列问题
                if joField.type = 'check' then begin
                    iDec    := -1;
                    continue;
                end;
                //
                oComp   := oForm.FindComponent('F0'+IntToStr(iField));
                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    if joField.type = 'auto' then begin
                        Continue;
                    end else if joField.type = 'boolean' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);
                    end else if joField.type = 'select' then begin
                        Continue;
                    end else if joField.type = 'combo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'combopair' then begin   //根据预设的二维数组list进行比对保存
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := '';
                        if oCB_Field.Text <> '' then begin
                            for iTemp := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iTemp)._(0) = oCB_Field.text then begin
                                    oQuery.Fields[iField+iDec].AsString  := joField.list._(iTemp)._(1);
                                    break;
                                end;
                            end;
                        end;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'image' then begin
                        oI_Field    := TImage(oComp);
                        oQuery.Fields[iField+iDec].AsString := _GetImageValue(oI_Field);
                    end else if joField.type = 'integer' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsInteger := StrToIntDef(oE_Field.text,0);
                    end else if joField.type = 'date' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Date;
                    end else if joField.type = 'time' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.Time;
                    end else if joField.type = 'datetime' then begin
                        oDT_Field   := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT_Field.DateTime;
                    end else if joField.type = 'money' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsFloat := StrToFloatDef(oE_Field.text,0);
                    end else begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsString := oE_Field.text;
                    end;

                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iField+iDec].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oQueryTmp.Close;
                            if oQuery.Fields[iField+iDec].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iField+iDec].AsString;
                            end else begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iField+iDec].AsString+'''';
                            end;
                            oQueryTmp.Open;
                            if oQueryTmp.Fields[0].AsInteger > 0 then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                Exit;
                            end;
                        end;
                    end;
                end;
            end;

            //Post前事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,3,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;


            //Post后事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,0,4,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;

            //如果选中的“批量录入”，则重新append, 否则关闭退出
            if oCKB.Checked then begin
                //做标记
                oBEA.Tag  := 999;

                //自动新增
                qcAppend(oForm,
                    0,
                    oQuery,
                    joConfig.fields,
                    '',
                    '');
            end else begin
                //关闭伪窗体
                oPEr.Visible  := False;
            end;
        end;
        //从表新增
        101..199 : begin
            iSlave  := oPEr.Tag - 101;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
            //更新数值
            oQuery.Edit;

            //保存与主表关联的字段值
            oQueryTmp   := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.FieldByName(joConfig.slave._(iSlave).slavefield).Value   :=  oQueryTmp.FieldByName(joConfig.slave._(iSlave).masterfield).Value;

            //保存编辑输入框的值
            for iField := 0 to joConfig.slave._(iSlave).fields._Count - 1 do begin
                joField := joConfig.slave._(iSlave).fields._(ifield);

                //避免多选列问题
                if joField.type = 'check' then begin
                    iDec    := -1;
                    continue;
                end;
                //
                oComp   := oForm.FindComponent('F'+IntToStr(iSlave+1)+IntToStr(iField));

                //如果找到了控件（有可能因为view<>0的原因找不到）
                if oComp <> nil then begin
                    if joField.type = 'auto' then begin
                        Continue;
                    end else if joField.type = 'boolean' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsBoolean := (oCB_Field.text = oCB_Field.Items[1]);
                    end else if joField.type = 'select' then begin
                        Continue;
                    end else if joField.type = 'combo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'combopair' then begin   //根据预设的二维数组list进行比对保存
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := '';
                        if oCB_Field.Text <> '' then begin
                            for iTemp := 0 to joField.list._Count - 1 do begin
                                if joField.list._(iTemp)._(0) = oCB_Field.text then begin
                                    oQuery.Fields[iField+iDec].AsString  := joField.list._(iTemp)._(1);
                                    break;
                                end;
                            end;
                        end;
                    end else if joField.type = 'dbcombo' then begin
                        oCB_Field   := TComboBox(oComp);
                        oQuery.Fields[iField+iDec].AsString  := oCB_Field.text;
                    end else if joField.type = 'image' then begin
                        oI_Field    := TImage(oComp);
                        oQuery.Fields[iField+iDec].AsString := _GetImageValue(oI_Field);
                    end else if joField.type = 'integer' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsInteger := StrToIntDef(oE_Field.text,0);
                    end else if joField.type = 'date' then begin
                        oDT := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT.Date;
                    end else if joField.type = 'time' then begin
                        oDT := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT.Time;
                    end else if joField.type = 'datetime' then begin
                        oDT := TDateTimePicker(oComp);
                        oQuery.Fields[iField+iDec].AsDateTime    := oDT.DateTime;
                    end else if joField.type = 'money' then begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsFloat := StrToFloatDef(oE_Field.text,0);
                    end else begin
                        oE_Field := TEdit(oComp);
                        oQuery.Fields[iField+iDec].AsString := oE_Field.text;
                    end;
                    //检查是否为必填字段
                    if dwGetInt(joField,'must',0) = 1 then begin
                        if oQuery.Fields[iField+iDec].AsString = '' then begin
                            //
                            dwMessage('保存失败！字段 "'+joField.caption+'" 为必填字段！','error',oForm);
                            Exit;
                        end;
                    end;

                    //检查防重
                    if joField.Exists('unique') then begin
                        if joField.unique = 1 then begin
                            oQueryTmp.Close;
                            if oQuery.Fields[iField+iDec].DataType in [ftSmallint, ftInteger, ftWord, // 0..4
                                ftFloat, ftCurrency, ftBCD, ftLongWord, ftShortint, ftByte, ftExtended, ftSingle]
                            then begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.slave._(iSlave).table
                                        +' WHERE '+joField.name+'='+oQuery.Fields[iField+iDec].AsString;
                            end else begin
                                oQueryTmp.SQL.Text  := 'SELECT Count(*) FROM '+joConfig.slave._(iSlave).table
                                        +' WHERE '+joField.name+'='''+oQuery.Fields[iField+iDec].AsString+'''';
                            end;
                            oQueryTmp.Open;
                            if oQueryTmp.Fields[0].AsInteger > 0 then begin
                                //
                                dwMessage('保存失败！字段 "'+joField.caption+'" 为唯一字段！','error',oForm);
                                Exit;
                            end;
                        end;
                    end;
                end;
            end;

            //Post前事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,iSlave+1,3,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;
            //
            oQuery.FetchOptions.RecsSkip  := -1;
            oQuery.Post;

            //Post后事件
            bAccept := True;
            if Assigned(oForm.OnDragOver) then begin
                oForm.OnDragOver(oForm,nil,iSlave+1,4,dsDragEnter,bAccept);
                if not bAccept then begin
                    dwMessage(joConfig.teminate,'error',oForm);
                    Exit;
                end;
            end;
            //如果选中的“批量录入”，则重新append, 否则关闭退出
            if oCKB.Checked then begin
                //做标记
                oBEA.Tag  := 999;

                //自动新增
                qcAppend(oForm,
                    iSlave+1,
                    oQuery,
                    joConfig.slave._(iSlave).fields,
                    TFDQuery(oForm.FindComponent('FQ_Main')).FieldByName(joConfig.slave._(iSlave).masterfield).AsString,
                    joConfig.slave._(iSlave).slavefield);

            end else begin
                //关闭伪窗体
                oPEr.Visible  := False;
            end;
        end;
    end;
    //更新显示（仅关闭编辑/新增面板时）
    if not oPEr.Visible then begin
        //用 PEr 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oPEr.Tag of
            0,100 : begin
                qcUpdateMain(oForm,'');
            end;
        end;
        //
        qcUpdateSlaves(oForm);
    end;
end;

Procedure BEAClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oQuery      : TFDQuery;
    oPEr   : TPanel;
    //
    iSlave      : Integer;
begin
    //dwMessage('BEAClick','',TForm(TEdit(Sender).Owner));
    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEr   := TPanel(oForm.FindComponent('PEr'));
    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    case oPEr.Tag of
        0 : begin       //主表编辑
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
        1..99 : begin   //从表编辑
            iSlave  := oPEr.Tag - 1;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
            oQuery.Cancel;
        end;
        100 : begin     //主表新增
            oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
            oQuery.Cancel;
        end;
        101..199 : begin//从表新增
            iSlave  := oPEr.Tag - 101;
            oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
            oQuery.Cancel;
        end;
    end;
    //
    oPEr.Visible  := False;

    //更新显示（仅tag=999时，此时表示已批量增加）
    if oButton.Tag = 999 then begin
        oButton.Tag := 0;
        //用 PEr 的tag来标记当前状态，
        //0~99   表示编辑，其中0是主表，1~99表示从表
        //100~199表示新增，其中100是主表，101~199表示从表
        case oPEr.Tag of
            0,100 : begin
                qcUpdateMain(oForm,'');
            end;
        end;
        //
        qcUpdateSlaves(oForm);
    end;
end;

Procedure BEMClick(Self: TObject; Sender: TObject);
var
    oButton     : TButton;
    oForm       : TForm;
    oPCS        : TPageControl;
    oPEr        : TPanel;
    oFC         : TFlowPanel;
    //
    iItem       : Integer;
    //
    joConfig    : variant;
begin
    //dwMessage('BEMClick','',TForm(TEdit(Sender).Owner));

    //取得各对象
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPEr   := TPanel(oForm.FindComponent('PEr'));
    oPCS   := TPageControl(oForm.FindComponent('PCS'));

    //先设置非AutoSize
    oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(0)));
    oFC.AutoSize    := False;
    if oPCS <> nil then begin
        for iItem := 1 to oPCS.PageCount do begin
            oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(iItem)));
            oFC.AutoSize    := False;
        end;
    end;

    //
    joConfig    := qcGetConfigJson(oForm);

    //
    if oPEr.Width = Min(oForm.width-20,joConfig.editwidth) then begin
        //标志当前最大化
        oButton.Tag := 9;
        //最大化
        if oForm.Width < 500 then begin
            oPEr.Width     := oForm.Width - 20;
            oPEr.Top       := 10;
            oPEr.Height    := oForm.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPEr.Width     := oForm.Width - 100;
            oPEr.Top       := 50;
            oPEr.Height    := oForm.Height - 100;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end;
    end else begin
        //标志当前正常大小
        oButton.Tag := 0;

        //正常界面
        if oForm.Width < 500 then begin
            oPEr.Width     := oForm.Width - 20;
            oPEr.Top       := 10;
            oPEr.Height    := oForm.Height - 20;
            oButton.Hint        := '{"type":"text","icon":"el-icon-copy-document"}';
        end else begin
            oPEr.Width     := Min(oForm.width-20,joConfig.editwidth);
            oPEr.Top       := 100;
            oPEr.Height    := oForm.Height - 200;
            oButton.Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        end;
    end;

    //设置AutoSize,以配合ScrollBox滚动
    oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(0)));
    oFC.AutoSize    := True;
    if oPCS <> nil then begin
        for iItem := 1 to oPCS.PageCount do begin
            oFC := TFlowPanel(oForm.FindComponent('FC'+IntToStr(iItem)));
            oFC.AutoSize    := True;
        end;
    end;
end;

Procedure PCSChange(Self: TObject; Sender: TObject);
var
    iSlave      : Integer;
    joConfig    : variant;
    joSlave     : Variant;
    //
    oPC         : TPageControl;
    oForm       : TForm;
    oBSE        : TButton;
    oBSN        : TButton;
    oBSD        : TButton;
    oBSQ        : TButton;
begin
    //
    oPC         := TPageControl(Sender);
    oForm       := TForm(oPC.Owner);
    oBSE        := TButton(oForm.FindComponent('BSE'));
    oBSN        := TButton(oForm.FindComponent('BSN'));
    oBSD        := TButton(oForm.FindComponent('BSD'));
    oBSQ        := TButton(oForm.FindComponent('BSQ'));
    //
    joConfig    := _json(qcGetConfig(oForm));
    //根据当前从表的设置，动态显示/隐藏各功能按钮（Edit/New/Delete）
    iSlave  := oPC.ActivePageIndex;
    joSlave := joConfig.slave._(iSlave);
    //检查补齐编辑、新增、删除、打印按钮的可用性
    if not joSlave.Exists('edit') then begin
        joSlave.edit    := 1;
    end;
    if not joSlave.Exists('new') then begin
        joSlave.new     := 1;
    end;
    if not joSlave.Exists('delete') then begin
        joSlave.delete  := 1;
    end;
    if not joSlave.Exists('query') then begin
        joSlave.query   := 1;
    end;
    //
    oBSE.Visible    := (joSlave.edit = 1);
    oBSN.Visible    := (joSlave.new = 1);
    oBSD.Visible    := (joSlave.delete = 1);
    oBSQ.Visible    := (joSlave.query = 1);
end;

Procedure BEtClick(Self: TObject; Sender: TObject);     //Button Edit
var
    oForm       : TForm;
    oBEt        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oBEM        : TButton;
    oSB         : TScrollBox;
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
    iDec        : Integer;
    //用于取字段值，并清除其中的换行
    sValue      : String;
    bAccept     : Boolean;

    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //主表编辑事件
    //dwMessage('BEtClick','',TForm(TEdit(Sender).Owner));


    //取得各控件
    oBEt    := TButton(Sender); //Et : Edit
    oForm   := TForm(oBEt.Owner);
    oPEr    := TPanel(oForm.FindComponent('PEr'));
    oBEL    := TButton(oForm.FindComponent('BEL'));
    oBEM    := TButton(oForm.FindComponent('BEM'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCKB    := TCheckBox(oForm.FindComponent('CKB'));


    //主表编辑事件
    bAccept := True;
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,0,100,dsDragEnter,bAccept);
        if not bAccept then begin
            dwMessage(joConfig.teminate,'error',oForm);
            Exit;
        end;
    end;

    //
    oCKB.Visible  := False;

    //EL Edit Label
    oBEL.Caption   := '编  辑';

    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPEr.Tag   := 0;
    //隐藏PEr中其他所有ScrollBox
    TScrollBox(oForm.FindComponent('SB0')).Visible  := True;
    for iItem := 1 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;

    //得到配置JSON
    joConfig    := qcGetConfigJson(oForm);

    //更新字段值
    iDec    := 0;   //用于iItem与oQuery.Fields的差值
    for iItem := 0 to joConfig.fields._Count-1 do begin  //此处需要避免多选列问题
        //得到字段JSON
        joField := joConfig.fields._(iItem);

        //避免多选列问题
        if joField.type = 'check' then begin
            iDec    := -1;
            continue;
        end;

        //查找字段对应的编辑控件
        oComp   := oForm.FindComponent('F'+'0'+IntToStr(iItem));

        //如果找到了控件（有可能因为view<>0的原因找不到）
        if oComp <> nil then begin
            //取字段的AsString，并清除其中的特殊字符串（如换行），备用
            sValue  := oQuery.Fields[iItem+iDec].AsString;
            sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
            sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

            //更新显示
            if joField.type = 'boolean' then begin
                oCB         := TComboBox(oComp);
                if LowerCase(sValue)='true' then begin
                    oCB.ItemIndex   := 1;
                end else begin
                    oCB.ItemIndex   := 0;
                end;
            end else if joField.type = 'combo' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;
            end else if joField.type = 'combopair' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if sValue <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(1) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(0);
                            break;
                        end;
                    end;
                end;
            end else if joField.type = 'dbcombo' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;
            end else if joField.type = 'image' then begin
                oI          := TImage(oComp);
                if joField.Exists('imgdir') then begin
                    sValue  := String(joField.imgdir) + sValue;
                end;
                oI.Hint     := '{"dwstyle":"border-radius:3px;","src":"'+sValue+'"}';
            end else if joField.type = 'integer' then begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end else if joField.type = 'date' then begin
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkDate;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'time' then begin
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkTime;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Time    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'datetime' then begin
                oDT         := TDateTimePicker(oComp);
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'memo' then begin
                oM          := TMemo(oComp);
                oM.Text     := oQuery.Fields[iItem+iDec].AsString;
            end else if joField.type = 'money' then begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
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

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //
    oPEr.Visible   := True;
end;

Procedure BNwClick(Self: TObject; Sender: TObject); //BNw - Button New
var
    oForm       : TForm;
    oBNw        : TButton;
    oPEr        : TPanel;
    oBEL        : TButton;
    oBEM        : TButton;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oCKB        : TCheckBox;
    //
    iItem       : Integer;
    //
    joConfig    : Variant;
    //
    bAccept     : Boolean;
begin
    //主表新增事件
    //dwMessage('BNwClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oBNw    := TButton(Sender);
    oForm   := TForm(oBNw.Owner);
    oPEr    := TPanel(oForm.FindComponent('PEr'));
    oBEL    := TButton(oForm.FindComponent('BEL'));
    oBEM    := TButton(oForm.FindComponent('BEM'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    oCKB    := TCheckBox(oForm.FindComponent('CKB'));

    //append前事件
    bAccept := True;
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,0,1,dsDragEnter,bAccept);
        if not bAccept then begin
            dwMessage(joConfig.teminate,'error',oForm);
            Exit;
        end;
    end;

    //批量处理
    oCKB.Visible  := True;

    //
    oBEL.Caption   := '新  增';

    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPEr.Tag  := 100;

    //隐藏PEr中其他所有ScrollBox，用于只显示主表的字段编辑框，隐藏所有从表的字段编辑框
    TScrollBox(oForm.FindComponent('SB0')).Visible := True;
    for iItem := 1 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := False;
        end;
    end;

    //取得参数配置JSON对象，以便后续处理
    joConfig    := qcGetConfigJson(oForm);

    //更新字段值
    qcAppend(oForm,
            0,
            oQuery,
            joConfig.fields,
            '',
            '');

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //
    oPEr.Visible  := True;
end;

Procedure BDeClick(Self: TObject; Sender: TObject);
var
    //
    bFound      : Boolean;
    //
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oLabel      : TLabel;
    oQuery      : TFDQuery;
    oGMn        : TStringGrid;
    //
    iField      : Integer;
    iRow        : Integer;
    sInfo       : string;
    //
    joConfig    : Variant;
    joCell      : variant;
begin
    //主表的删除事件。
    //dwMessage('BDeClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('PDe'));
    oLabel  := TLabel(oForm.FindComponent('LCF'));
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    oGMn    := TStringGrid(oForm.FindComponent('GMn'));

    //得到配置JSON
    joConfig    := qcGetConfigJson(oForm);

    //得到主表表格的Hint字符串
    bFound  := False;   //用来表示是否已选择
    joCell  := joConfig.fields._(0);
    if joCell.type = 'check' then begin
        for iRow := 1 to oGMn.RowCount - 1 do begin
            if oGMn.Cells[0,iRow] = 'true' then begin
                bFound  := True;
                break;
            end;
        end;
    end;


    //标志当前是主表，用面板的tag
    oPanel.Tag  := 0;

    //根据是否多选，分别处理。如果没多选，则删除当前行；否则， 删除多选行
    if not bFound then begin
        sInfo   := '';
        for iField := 0 to Min(2,oQuery.FieldCount-1) do begin
            sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
        end;
        sInfo   := Copy(sInfo,1,Length(sInfo)-3);
    end else begin
        joCell  := joConfig.fields._(1);
        sInfo   := joCell.caption +' : ';
        for iRow := 1 to oGMn.RowCount - 1 do begin
            if oGMn.Cells[0,iRow] = 'true' then begin
                sInfo   := sInfo + ''+oGMn.Cells[1,iRow]+' | ';
            end;
        end;
        sInfo   := Copy(sInfo,1,Length(sInfo)-3);
    end;

    //
    oLabel.Caption  := '确定要删除当前记录以及关联从表记录吗？'#13#13+sInfo;
    oPanel.Visible  := True;
end;

Procedure BExClick(Self: TObject; Sender: TObject);
var
    //
    oForm       : TForm;
    oButton     : TButton;
    oQuery      : TFDQuery;
    //
    iSlave      : integer;
    sFields     : string;   //主表字段列表
    sWhere      : String;   //主表WHERE
    sDir        : string;
    sFileName   : String;
    sTitles     : string;
    //
    joConfig    : Variant;
    joSlave     : Variant;
begin
    //主表的导出事件。
    //dwMessage('BExClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oQuery  := qcGetFDQuery(oForm,-1);  //取得临时查询

    //得到配置JSON
    joConfig    := qcGetConfigJson(oForm);

    //得到主表的字段名称列表
    sFields     := _GetFields(joConfig.Fields,joConfig.exportonlyvisible=1);

    //得到主表的字段caption列表,如：["姓名","性别","年龄","地址"]
    sTitles     := _GetCaptions(joConfig.Fields,joConfig.exportonlyvisible=1);

    //得到主表的WHERE
    sWhere      := qcGetWhere(oForm,0);

    //打开数据表
    oQuery.Close;
    oQuery.SQL.Text := 'SELECT '+sFields+' FROM '+joConfig.table +' WHERE '+sWhere;
    oQuery.Open;

    //取得当前目录
    sDir    := ExtractFilePath(Application.ExeName);
    //如果无download目录，则创建
    ChDir(sDir);
    if not DirectoryExists('download') then begin
        MkDir('download');
    end;
    sDir    := sDir +'download/';
    //
    sFileName   := 'QuickCrudData'+ FormatDateTime('_YYYYMMDD_hhmmss_zzz',Now)+'.xls';

    //导出到文件
    dwExportToTitledXLS(sDir + sFileName, oQuery, sTitles);

    //
    dwOpenURL(oForm,'download/'+sFileName,'_blank');

    //导出从表
    if joConfig.exists('slave') then begin
        for iSlave := 0 to joConfig.slave._Count - 1 do begin
            //
            joSlave := joConfig.slave._(iSlave);

            //得到表的字段名称列表
            sFields     := _GetFields(joSlave.Fields,False);

            //得到表的字段caption列表,如：["姓名","性别","年龄","地址"]
            sTitles     := _GetCaptions(joSlave.Fields,False);

            //得到主表的WHERE
            sWhere      := qcGetWhere(oForm,iSlave+1);

            //打开数据表
            oQuery.Close;
            oQuery.SQL.Text := 'SELECT '+sFields+' FROM '+joSlave.table +' WHERE '+sWhere;
            oQuery.Open;

            //
            sDir    := ExtractFilePath(Application.ExeName)+'/download/';
            sFileName   := 'QuickCrudSlave'+Inttostr(iSlave)+ FormatDateTime('_YYYYMMDD_hhmmss_zzz',Now)+'.xls';

            //导出到文件
            dwExportToTitledXLS(sDir + sFileName, oQuery, sTitles);

            //
            dwOpenURL(oForm,'download/'+sFileName,'_blank');

        end;
    end;
end;

//主表隐藏/显示按钮
Procedure BHdClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oButton     : TButton;
    oBNw        : TButton;
    oBEt        : TButton;
    oBDe        : TButton;
    oBEx        : TButton;
    oBQm        : TButton;
    oBFz        : TButton;
    oBHd        : TButton;
    oFQy        : TFlowPanel;
    oPQm        : TPanel;
    oPQC        : TPanel;
    oPMn        : TPanel;
    oPMd        : TPanel;
    oPBs        : TPanel;
    oPTM        : TPanel;
    oPSv        : TPanel;
    oGMn        : TStringGrid;
    //
    sLayout     : String;
    //
    joTemp      : Variant;
    joConfig    : Variant;
begin
    //dwMessage('BHdClick','',TForm(TEdit(Sender).Owner));
    //主表的打印事件。

    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPQC    := TPanel(oForm.FindComponent('PQC'));
    oPMn    := TPanel(oForm.FindComponent('PMn'));
    oPMd    := TPanel(oForm.FindComponent('PMd'));
    oPBs    := TPanel(oForm.FindComponent('PBs'));
    oPTM    := TPanel(oForm.FindComponent('PTM'));
    oGMn    := TStringGrid(oForm.FindComponent('GMn'));
    oPSv    := TPanel(oForm.FindComponent('PSv'));
    //
    oBNw    := TButton(oForm.FindComponent('BNw'));
    oBEt    := TButton(oForm.FindComponent('BEt'));
    oBDe    := TButton(oForm.FindComponent('BDe'));
    oBEx    := TButton(oForm.FindComponent('BEx'));
    oBQm    := TButton(oForm.FindComponent('BQm'));
    oBFz    := TButton(oForm.FindComponent('BFz'));
    oBHd    := TButton(oForm.FindComponent('BHd'));
    oPQm    := TPanel(oForm.FindComponent('PQm'));
    oFQy    := TFlowPanel(oForm.FindComponent('FQy'));

    //取配置JSON : 读AForm的 qcConfig 变量值
    joConfig    := qcGetConfigJson(oForm);

    //取得总布局样式
    joTemp      := _json(oPQC.Hint);
    sLayout     := 'main';
    if joTemp <> unassigned then begin
        sLayout := joTemp.layout;
    end;

    //垂直排列时
    if sLayout = 'vert' then begin
        if oPMd.Height = 90 + joConfig.rowheight * ( 1 + joConfig.pagesize )+1 then begin  //点击后，仅显示从表，隐藏主表
            oButton.Caption         := '最大';

            //主表
            oPMd.AutoSize    := False;
            oPMd.Height      := oPBs.Height+3;
            oPMd.Align       := alTop;
            oPTM.Visible       := False;
            oPMn.Align           := alTop;
            oPMn.AutoSize        := True;

            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end else if oPMd.Height = oPBs.Height+3 then begin  //点击后，仅显示主表，隐藏从表
            //
            oButton.Caption         := '显示';

            //主表
            oPMn.Align           := alclient;
            oPMd.Align       := alClient;
            oGMn.Align          := alClient;
            oPTM.Visible       := True;

            //从表
            oPSv.Visible        := False;
        end else begin      //此时正常显示主从表
            //
            oButton.Caption         := '隐藏';

            //主表
            oPMd.Align       := alTop;
            oPMd.AutoSize    := False;
            oPMd.Height      := 90 + joConfig.rowheight * ( 1 + joConfig.pagesize )+1;  //高度
            oPTM.Visible       := True;
            oPMn.Align           := alTop;
            oPMn.AutoSize        := True;

            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end;
    end;

    //水平排列时
    if sLayout = 'horz' then begin
        if oPMn.Width = joConfig.mainwidth then begin  //点击后，仅显示从表，隐藏主表
            oButton.Caption     := '最大';

            //主表
            oPMn.Align          := alLeft;
            oPMn.Width          := oButton.Width+32;
            oBHd.Align          := alLeft;
            oBNw.Visible        := False;
            oBEt.Visible        := False;
            oBDe.Visible        := False;
            oBQm.Visible        := False;
            oBFz.Visible        := False;
            oGMn.Visible        := False;
            oPTM.Visible        := False;
            //切换到无查询模式
            oBQm.Tag            := 0;
            oFQy.Visible        := False;
            oPQm.Visible        := False;


            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end else if oPMn.Width = oButton.Width+32 then begin  //使"最大" 点击后，仅显示主表，隐藏从表
            //
            oButton.Caption     := '显示';

            //主表
            oPMn.Align          := alclient;
            oBDe.Visible        := joConfig.delete = 1;
            oBNw.Visible        := joConfig.new = 1;
            oBEt.Visible        := joConfig.edit = 1;
            oBEx.Visible        := joConfig.export = 1;
            oBQm.Visible        := True;
            oGMn.Visible        := True;
            oPTM.Visible        := True;
            oBHd.Align          := alRight;
            oBHd.Left           := 9999;
            //
            oButton.Left        := 1000;

            //从表
            oPSv.Visible        := False;
        end else begin      //此时正常显示主从表
            //
            oButton.Caption     := '隐藏';

            //主表
            oPMn.Align          := alLeft;
            oPMn.Width          := joConfig.mainwidth;
            oBDe.Visible        := joConfig.delete = 1;
            oBNw.Visible        := joConfig.new = 1;
            oBEt.Visible        := joConfig.edit = 1;
            oBEx.Visible        := joConfig.export = 1;
            oBQm.Visible        := True;
            oGMn.Visible        := True;
            oPTM.Visible        := True;
            oBHd.Align          := alRight;
            oBHd.Left           := 9999;
            //
            oButton.Left        := 1000;

            //从表
            oPSv.Visible        := True;
            oPSv.Align          := alClient;
        end;
    end;
end;

Procedure BSEClick(Self: TObject; Sender: TObject);     //Button Slave Edit
var
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oSB         : TScrollBox;
    oPC         : TPageControl;
    oQuery      : TFDQuery;
    oComp       : TComponent;
    oE          : TEdit;
    oI          : TImage;
    oM          : TMemo;
    oDT         : TDateTimePicker;
    oCB         : TComboBox;
    oCKB        : TCheckBox;
    oBEL        : TButton;
    oBEM        : TButton;
    //
    iItem       : Integer;
    iSlave      : Integer;
    iTemp       : Integer;
    iDec        : Integer;
    sValue      : String;
    bAccept     : Boolean;
    //
    joConfig    : Variant;
    joField     : Variant;
begin
    //从表编辑事件
    //dwMessage('BSEClick','',TForm(TEdit(Sender).Owner));
    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('PEr'));
    oPC         := TPageControl(oForm.FindComponent('PCS'));
    oCKB        := TCheckBox(oForm.FindComponent('CKB'));
    oBEM        := TButton(oForm.FindComponent('BEM'));
    oBEL        := TButton(oForm.FindComponent('BEL'));

    //编辑框标题
    oBEL.Caption   := '编  辑';

    //
    oCKB.Visible  := False;

    //隐藏PEr中其他所有ScrollBox
    iSlave  := oPC.ActivePageIndex;

    //从表编辑事件
    bAccept := True;
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,iSlave+1,100,dsDragEnter,bAccept);
        if not bAccept then begin
            dwMessage(joConfig.teminate,'error',oForm);
            Exit;
        end;
    end;


    for iItem := 0 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := (iItem = iSlave+1);
        end;
    end;

    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPanel.Tag  := iSlave + 1;
    //
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
    //
    joConfig    := _json(qcGetConfig(oForm));

    //更新字段值
    iDec    := 0;
    for iItem := 0 to joConfig.slave._(iSlave).fields._Count - 1 do begin
        //
        joField := joConfig.slave._(iSlave).fields._(iItem);

        //避免多选列问题
        if joField.type = 'check' then begin
            iDec    := -1;
            continue;
        end;
        //
        oComp   := oForm.FindComponent('F'+IntToStr(iSlave+1)+IntToStr(iItem));
        //如果找到了控件（有可能因为view<>0的原因找不到）
        if oComp <> nil then begin
            //取字段的AsString，并清除其中的特殊字符串（如换行），备用
            sValue  := oQuery.Fields[iItem+iDec].AsString;
            sValue  := StringReplace(sValue,#10,'',[rfReplaceAll]);
            sValue  := StringReplace(sValue,#13,'',[rfReplaceAll]);

            if joField.type = 'boolean' then begin
                oCB         := TComboBox(oComp);
                if LowerCase(sValue)='true' then begin
                    oCB.ItemIndex   := 1;
                end else begin
                    oCB.ItemIndex   := 0;
                end;
            end else if joField.type = 'combo' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;
            end else if joField.type = 'combopair' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := '';
                if oQuery.Fields[iItem+iDec].AsString <> '' then begin
                    for iTemp := 0 to joField.list._Count - 1 do begin
                        if joField.list._(iTemp)._(1) = sValue then begin
                            oCB.Text    := joField.list._(iTemp)._(0);
                            break;
                        end;
                    end;
                end;
            end else if joField.type = 'dbcombo' then begin
                oCB         := TComboBox(oComp);
                oCB.Text    := sValue;
            end else if joField.type = 'image' then begin
                oI          := TImage(oComp);
                if joField.Exists('imgdir') then begin
                    sValue  := joField.imgdir + sValue;
                end;
                oI.Hint     := '{"dwstyle":"border-radius:3px;","src":"'+sValue+'"}';
            end else if joField.type = 'integer' then begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end else if joField.type = 'date' then begin
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkDate;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'time' then begin
                oDT         := TDateTimePicker(oComp);
                oDT.Kind    := dtkTime;
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Time    := StrToTime('00:00:00');
                end else begin
                    oDT.Time    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'datetime' then begin
                oDT         := TDateTimePicker(oComp);
                if oQuery.Fields[iItem].IsNull then begin
                    oDT.Date    := StrToDate('1899-12-30');
                end else begin
                    oDT.Date    := oQuery.Fields[iItem+iDec].AsDateTime;
                end;
            end else if joField.type = 'memo' then begin
                oM          := TMemo(oComp);
                oM.Text     := oQuery.Fields[iItem+iDec].AsString;
            end else if joField.type = 'money' then begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end else begin
                oE          := TEdit(oComp);
                oE.Text     := sValue;
            end;

            //设置只读（编辑时只读，新增时可编辑）
            if joField.type <> 'auto' then begin
                if joField.readonly = 1 then begin
                    TEdit(oComp).Enabled    := false;
                end;
            end;
        end;
    end;

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //
    oPanel.Visible  := True;
end;

Procedure BSNClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oPC         : TPageControl;
    oSB         : TScrollBox;
    oQuery      : TFDQuery;
    oFQ_Main    : TFDQuery;
    oCKB        : TCheckBox;
    oBEL        : TButton;
    oBEM        : TButton;
    //
    iSlave      : Integer;
    iItem       : Integer;
    //
    joConfig    : Variant;
    joSlave     : variant;
    //
    bAccept     : Boolean;
begin
    //主表新增事件
    //dwMessage('BSNClick','',TForm(TEdit(Sender).Owner));


    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPanel      := TPanel(oForm.FindComponent('PEr'));
    oPC         := TPageControl(oForm.FindComponent('PCS'));
    oCKB        := TCheckBox(oForm.FindComponent('CKB'));
    oFQ_Main    := TFDQuery(oForm.FindComponent('FQ_Main'));
    oBEL        := TButton(oForm.FindComponent('BEL'));
    oBEM        := TButton(oForm.FindComponent('BEM'));

    //append前事件
    bAccept := True;
    if Assigned(oForm.OnDragOver) then begin
        oForm.OnDragOver(oForm,nil,iSlave+1,1,dsDragEnter,bAccept);
        if not bAccept then begin
            dwMessage(joConfig.teminate,'error',oForm);
            Exit;
        end;
    end;

    //
    oBEL.Caption   := '新  增';

    //批量新增选择
    oCKB.Visible  := True;

    //隐藏PEr中其他所有ScrollBox
    iSlave  := oPC.ActivePageIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //用 PEr 的tag来标记当前状态，
    //0~99   表示编辑，其中0是主表，1~99表示从表
    //100~199表示新增，其中100是主表，101~199表示从表
    oPanel.Tag  := 101+iSlave;
    //隐藏PEr中其他所有ScrollBox
    for iItem := 0 to 19 do begin
        oSB := TScrollBox(oForm.FindComponent('SB'+IntToStr(iItem)));
        if oSB <> nil then begin
            oSB.Visible := (iItem = iSlave+1);
        end;
    end;

    //取得配置信息
    joConfig    := _json(qcGetConfig(oForm));
    joSlave     := joConfig.slave._(iSlave);

    //更新字段值
    qcAppend(oForm,
            iSlave+1,
            oQuery,
            joSlave.fields,
            oFQ_Main.FieldByName(joConfig.slave._(iSlave).masterfield).AsString,
            joSlave.slavefield);

    //解决默认最大化的问题
    if oBEM.Tag = 9 then begin
        if oBEM.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBEM.OnClick(oBEM);
        end;;
    end;

    //
    oPanel.Visible  := True;
end;

Procedure BSDClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oButton     : TButton;
    oPanel      : TPanel;
    oLabel      : TLabel;
    oQuery      : TFDQuery;
    oPC         : TPageControl;
    oSG         : TStringgrid;
    //
    bFound      : Boolean;
    iField      : Integer;
    iSlave      : Integer;
    iRow        : Integer;
    sInfo       : string;
    //
    joConfig    : Variant;
    joCell      : Variant;
begin
    //dwMessage('BDeClick','',TForm(TEdit(Sender).Owner));
    //从表的删除事件。
    //取得各控件
    oButton := TButton(Sender);
    oForm   := TForm(oButton.Owner);
    oPanel  := TPanel(oForm.FindComponent('PDe'));
    oLabel  := TLabel(oForm.FindComponent('LCF'));
    oPC     := TPageControl(oForm.FindComponent('PCS'));
    iSlave  := oPC.ActivePageIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));

    //标志当前的从表
    oPanel.Tag  := iSlave + 1;

    //得到配置JSON
    joConfig    := qcGetConfigJson(oForm);

    //
    oSG     := TStringgrid(oForm.FindComponent('SG'+IntToStr(iSlave)));

    //得到主表表格的Hint字符串
    bFound  := False;   //用来表示是否已选择
    joCell  := joConfig.slave._(islave).fields._(0);
    if joCell.type = 'check' then begin
        for iRow := 1 to oSG.RowCount - 1 do begin
            if oSG.Cells[0,iRow] = 'true' then begin
                bFound  := True;
                break;
            end;
        end;
    end;

    //根据是否多选，分别处理。如果没多选，则删除当前行；否则， 删除多选行
    if not bFound then begin
        sInfo   := '';
        for iField := 0 to Min(2,oQuery.FieldCount-1) do begin
            sInfo   := sInfo + ''+oQuery.Fields[iField].AsString+' | ';
        end;
        sInfo   := Copy(sInfo,1,Length(sInfo)-3);
    end else begin
        joCell  := joConfig.slave._(islave).fields._(1);
        sInfo   := joCell.caption +' : ';
        for iRow := 1 to oSG.RowCount - 1 do begin
            if oSG.Cells[0,iRow] = 'true' then begin
                sInfo   := sInfo + ''+oSG.Cells[1,iRow]+' | ';
            end;
        end;
        sInfo   := Copy(sInfo,1,Length(sInfo)-3);
    end;

    //显示删除确认框
    oLabel.Caption  := '确定要删除吗？'#13#13+sInfo;
    oPanel.Visible  := True;
end;

Procedure BSQClick(Self: TObject; Sender: TObject);
var
    oForm       : TForm;
    oButton     : TButton;
    oBQX        : TButton;
    oPC         : TPageControl;
    oPQy        : TPanel;
    oSBQ        : TScrollBox;
    oFC         : TFlowPanel;
    //
    iSlave      : Integer;
    iItem       : Integer;
    //
    joConfig    : Variant;
begin
    //从表查询事件
    //dwMessage('BSQClick','',TForm(TEdit(Sender).Owner));

    //取得各控件
    oButton     := TButton(Sender);
    oForm       := TForm(oButton.Owner);
    oPQy        := TPanel(oForm.FindComponent('PQy'));
    oBQX        := TButton(oForm.FindComponent('BQX'));
    oPC         := TPageControl(oForm.FindComponent('PCS'));

    //
    joConfig    := qcGetConfigJson(oForm);

    //解决默认最大化的问题
    if oBQX.Tag = 9 then begin
        if oBQX.Hint <> '{"type":"text","icon":"el-icon-copy-document"}' then begin
            oBQX.OnClick(oBQX);
        end;;
    end;

    //显示对应的ScrollBox
    iSlave  := oPC.ActivePageIndex;
    for iItem := 0 to joConfig.slave._Count - 1 do begin
        oSBQ   := TScrollBox(oForm.FindComponent('SBQ'+IntToStr(iItem+1)));
        oSBQ.Visible   := iItem = iSlave;
    end;

    //先设置非AutoSize
    for iItem := 1 to oPC.PageCount do begin
        oFC := TFlowPanel(oForm.FindComponent('FT'+IntToStr(iItem)));
        oFC.AutoSize    := False;
        oFC.Height      := 1000;
        oFC.AutoSize    := True;
    end;

    //
    oPQy.Visible    := True;
end;

Procedure GMnClick(Self: TObject; Sender: TObject);
var
    iRow    : Integer;
    oForm   : TForm;
    oSG     : TStringGrid;
    oQuery  : TFDQuery;
    oClick  : Procedure(Sender: TObject) of Object;
begin
    //dwMessage('GMnClick','',TForm(TEdit(Sender).Owner));
    //主表的单击事件。功能：
    //1 如果主表未满行，点击空行后，自动切到最末行
    //2 根据当前主表的记录位置，自动更新从表
    //取得各控件
    oSG     := TStringGrid(Sender);
    oForm   := TForm(oSG.Owner);
    oQuery  := TFDQuery(oForm.FindComponent('FQ_Main'));
    //得到当前行
    iRow    := oSG.Row;
    //检查是否空行。如果是空行，则切到最末行
    if iRow > oQuery.RecordCount then begin
        iRow    := oQuery.RecordCount;
        //
        oClick      := oSG.OnClick;
        oSG.OnClick := nil;
        oSG.Row     := iRow;
        oSG.OnClick := oClick;
    end;
    //更新数据表记录
    oQuery.RecNo    := iRow;
    oQuery.Tag      := iRow;    //保存位置备用
    //更新从表
    qcUpdateSlaves(oForm);
    //激活窗体的OnDockDrop事件，其中：X 为 0，表示为主表，iRow为记录号
    if Assigned(oForm.OnDockDrop) then begin
        oForm.OnDockDrop(oSG,nil,0,iRow);
    end;
end;

Procedure GMnGetEditMask(Self: TObject; Sender: TObject; ACol, ARow: Integer; var Value: string);
var
    iField      : Integer;
    iSlave      : Integer;
    iItem       : Integer;
    sFilter     : String;
    //
    oForm       : TForm;
    oSG         : TStringGrid;
    //
    joValue     : Variant;
    joField     : Variant;
    joConfig    : Variant;
    joStyleName : Variant;  //将当前表格的排序和筛选信息统一放到SG的stylename中
begin
    //dwMessage('GMnGetEditMask','',TForm(TEdit(Sender).Owner));

    //先转化为JSON对象
    joValue := _json(Value);

    //异常检查
    if joValue = unassigned then begin
        dwMessage('error Value when GMnGetEditMask','',TForm(TEdit(Sender).Owner));
        Exit;
    end;
    if not joValue.Exists('type') then begin
        dwMessage('error Value.type when GMnGetEditMask','',TForm(TEdit(Sender).Owner));
        Exit;
    end;

    //
    if joValue.type = 'sort' then begin
        //主表点击排序
        //当设置了显示排序按钮时，当点击排序按钮时，StringGrid会自动激活OnGetEditMask事件。其中参数：
        //ACol : Integer ; 为所在列序号（从0开始）；
        //ARow : Integer;  为排序方向，1为升序，0为降序,9为不排序；
        //Value : string; 为标识，固定为字符串'sort'
        //取得各控件
        oSG     := TStringGrid(Sender);
        oForm   := TForm(oSG.Owner);

        //得到当前列信息
        joField := _json(oSG.Cells[ACol,0]);

        //
        joStyleName := _json(oSG.StyleName);
        if joStyleName = unassigned then begin
            joStyleName := _json('{}');
        end;

        //对排序的处理
        case ARow of
            0 : begin    //为降序,
                joStyleName.sort := 'ORDER BY ' + joField.name + ' DESC';
            end;
            1 : begin   //为升序，
                joStyleName.sort := 'ORDER BY ' + joField.name ;
            end;
            9 : begin   //为不排序；
                joStyleName.sort := '';
            end;
        end;
        oSG.StyleName   := joStyleName;

        //
        qcUpdateMain(oForm,'');
        qcUpdateSlaves(oForm);
    end else if joValue.type = 'selection' then begin
        //多选事件或过滤事件

    end else if joValue.type = 'filter' then begin
        //筛选事件
        //形如：{"type":"filter","col":3,"data":["襄阳","朝阳区"]}

        //取得各控件
        oSG     := TStringGrid(Sender);
        oForm   := TForm(oSG.Owner);

        //取得stylename的JSON
        joStyleName := _json(oSG.StyleName);
        if joStyleName = unassigned then begin
            joStyleName := _json('{}');
        end;

        //设置空值(筛选时点重置或未选择)
        if joValue.data._Count = 0 then begin
            joStyleName.filter := '';
        end else begin

            //取得配置JSON
            joConfig    := qcGetConfigJson(oForm);

            //根据列序号，得到字段JSON对象
            if oSG.Name = 'GMn' then begin
                //取得字段序号
                iField  := _GetFieldIndexFromCol(joConfig.fields,joValue.col);
                joField := joConfig.fields._(iField);

                //跳到第一页
                TTrackBar(oForm.FindComponent('TMa')).Position  := 0;
            end else begin
                //得到从表序号
                iSlave  := StrToIntDef(Copy(oSG.Name,3,1),-1);
                //异常检查
                if iSlave = -1 then begin
                    Exit;
                end;
                //取得字段序号
                iField  := _GetFieldIndexFromCol(joConfig.slave._(iSlave).fields,joValue.col);
                joField := joConfig.slave._(iSlave).fields._(iField);

                //跳到第一页
                TTrackBar(oForm.FindComponent('TB'+IntToStr(iSlave))).Position  := 0;
            end;

            //生成筛选字符串
            sFilter := '';
            for iItem := 0 to joValue.data._Count - 1 do begin
                if joField.Exists('datatype') then begin
                    if TFieldType(joField.datatype) in qcstInteger then begin
                        sFilter := sFilter  +' or ('+joField.name+'='+joValue.data._(iItem)+')';
                    end else if TFieldType(joField.datatype) in qcstFloat then begin
                        sFilter := sFilter  +' or ('+joField.name+'='+joValue.data._(iItem)+')';
                    end else begin
                        sFilter := sFilter  +' or ('+joField.name+'='''+joValue.data._(iItem)+''')';
                    end;
                end else begin
                    sFilter := sFilter  +' or ('+joField.name+'='''+joValue.data._(iItem)+''')';
                end;
            end;
            Delete(sFilter,1,4);
            sFilter := '(' + sFilter + ')';
            joStyleName.filter := sFilter;
        end;

        //回写到SG的stylename(包括排序数据和筛选数据)
        oSG.StyleName   := joStyleName;

        //
        qcUpdateMain(oForm,'');
        qcUpdateSlaves(oForm);
    end;
end;
Procedure SGSlaveClick(Self: TObject; Sender: TObject);
var
    iSlave  : Integer;
    iRow    : Integer;
    oForm   : TForm;
    oSG     : TStringGrid;
    oQuery  : TFDQuery;
    oClick  : Procedure(Sender: TObject) of Object;
begin
    //dwMessage('GMnClick','',TForm(TEdit(Sender).Owner));
    oSG     := TStringGrid(Sender);
    oForm   := TForm(oSG.Owner);
    iSlave  := TTabSheet(oSG.Parent).PageIndex;
    oQuery  := TFDQuery(oForm.FindComponent('FQ_'+IntToStr(iSlave)));
    //
    iRow    := oSG.Row;
    //
    if iRow > oQuery.RecordCount then begin
        iRow    := oQuery.RecordCount;
        //
        oClick      := oSG.OnClick;
        oSG.OnClick := nil;
        oSG.Row     := iRow;
        oSG.OnClick := oClick;
    end;
    //
    oQuery.RecNo    := iRow;
    oQuery.Tag      := iRow;    //保存位置备用

    //激活窗体的OnDockDrop事件，其中：X 为 1 + iSlave，表示为主表，iRow为记录号
    if Assigned(oForm.OnDockDrop) then begin
        oForm.OnDockDrop(oSG,nil,1 + iSlave,iRow);
    end;
end;


procedure SGSlaveGetEditMask(Self: TObject; Sender: TObject; ACol, ARow: Integer; var Value: string);
var
    iField      : Integer;
    iSlave      : Integer;
    iItem       : Integer;
    sFilter     : String;
    //
    oForm       : TForm;
    oSG         : TStringGrid;
    //
    joValue     : Variant;
    joField     : Variant;
    joConfig    : Variant;
    joStyleName : Variant;  //将当前表格的排序和筛选信息统一放到SG的stylename中
begin
    //dwMessage('SGSlaveGetEditMask','',TForm(TEdit(Sender).Owner));

    //先转化为JSON对象
    joValue := _json(Value);

    //异常检查
    if joValue = unassigned then begin
        dwMessage('error Value when SGSlaveGetEditMask','',TForm(TEdit(Sender).Owner));
        Exit;
    end;
    if not joValue.Exists('type') then begin
        dwMessage('error Value.type when SGSlaveGetEditMask','',TForm(TEdit(Sender).Owner));
        Exit;
    end;

    //
    if joValue.type = 'sort' then begin
        //主表点击排序
        //当设置了显示排序按钮时，当点击排序按钮时，StringGrid会自动激活OnGetEditMask事件。其中参数：
        //ACol : Integer ; 为所在列序号（从0开始）；
        //ARow : Integer;  为排序方向，1为升序，0为降序,9为不排序；
        //Value : string; 为标识，固定为字符串'sort'
        //取得各控件
        oSG     := TStringGrid(Sender);
        oForm   := TForm(oSG.Owner);

        //得到当前列信息
        joField := _json(oSG.Cells[ACol,0]);

        //
        joStyleName := _json(oSG.StyleName);
        if joStyleName = unassigned then begin
            joStyleName := _json('{}');
        end;

        //对排序的处理
        case ARow of
            0 : begin    //为降序,
                joStyleName.sort := 'ORDER BY ' + joField.name + ' DESC';
            end;
            1 : begin   //为升序，
                joStyleName.sort := 'ORDER BY ' + joField.name ;
            end;
            9 : begin   //为不排序；
                joStyleName.sort := '';
            end;
        end;
        oSG.StyleName   := joStyleName;

        //
        qcUpdateMain(oForm,'');
        qcUpdateSlaves(oForm);
    end else if joValue.type = 'selection' then begin
        //多选事件或过滤事件

    end else if joValue.type = 'filter' then begin
        //筛选事件
        //形如：{"type":"filter","col":3,"data":["襄阳","朝阳区"]}

        //取得各控件
        oSG     := TStringGrid(Sender);
        oForm   := TForm(oSG.Owner);

        //取得stylename的JSON
        joStyleName := _json(oSG.StyleName);
        if joStyleName = unassigned then begin
            joStyleName := _json('{}');
        end;

        //设置空值(筛选时点重置或未选择)
        if joValue.data._Count = 0 then begin
            joStyleName.filter := '';
            Exit;
        end;

        //取得配置JSON
        joConfig    := qcGetConfigJson(oForm);

        //
        if oSG.Name = 'GMn' then begin
            //取得字段序号
            iField  := _GetFieldIndexFromCol(joConfig.fields,joValue.col);
            joField := joConfig.fields._(iField);

        end else begin
            //得到从表序号
            iSlave  := StrToIntDef(Copy(oSG.Name,3,1),-1);
            //异常检查
            if iSlave = -1 then begin
                Exit;
            end;
            //取得字段序号
            iField  := _GetFieldIndexFromCol(joConfig.slave._(iSlave).fields,joValue.col);
            joField := joConfig.slave._(iSlave).fields._(iField);

        end;
        //
        sFilter := '';
        for iItem := 0 to joValue.data._Count - 1 do begin
            if TFieldType(joField.datatype) in qcstInteger then begin
                sFilter := sFilter  +' or ('+joField.name+'='+joValue.data._(iItem)+')';
            end else if TFieldType(joField.datatype) in qcstFloat then begin
                sFilter := sFilter  +' or ('+joField.name+'='+joValue.data._(iItem)+')';
            end else begin
                sFilter := sFilter  +' or ('+joField.name+'='''+joValue.data._(iItem)+''')';
            end;
        end;
        Delete(sFilter,1,4);
        sFilter := '(' + sFilter + ')';
        joStyleName.filter := sFilter;

        //回写到SG的stylename
        oSG.StyleName   := joStyleName;

        //
        qcUpdateMain(oForm,'');
        qcUpdateSlaves(oForm);
    end;
end;
Procedure TMaChange(Self: TObject; Sender: TObject);
begin
    qcUpdateMain(TForm(TEdit(Sender).Owner),'');
    qcUpdateSlaves(TForm(TEdit(Sender).Owner));
end;
Procedure TBSlaveChange(Self: TObject; Sender: TObject);
begin
    //qcUpdateMain(TForm(TEdit(Sender).Owner),'');
    qcUpdateSlaves(TForm(TEdit(Sender).Owner));
end;

//取数据字段的值
function _GetFieldValue(AField:TField;AConfig:Variant):String;
var
    iTemp   : Integer;
    joField : Variant;
begin
    //默认为空
    Result  := '';

    //异常退出
    if AConfig = unassigned then begin
        Exit;
    end;
    if AField.IsNull then begin
        Exit;
    end;

    //指定默认QuickCrud字段类型
    if not AConfig.Exists('type') then begin
        AConfig.type    := 'string';
    end;

    //
    if AConfig.type = 'integer' then begin
        Result  := IntToStr(AField.AsInteger);

    end else if AConfig.type = 'boolean' then begin   //布尔型
        //默认返回值
        Result  := AField.AsString;
        //
        if AConfig.Exists('list')  then begin
            if AConfig.list <> null then begin
                if AConfig.list._Count > 1 then begin
                    Result  := dwIIF(AField.AsBoolean,AConfig.list._(1),AConfig.list._(0));
                end;
            end;
        end;

    end else if AConfig.type = 'combopair' then begin   //“键-值”对
        joField := AConfig;
        Result  := AField.AsString;
        if AField.AsString <> '' then begin
            for iTemp := 0 to joField.list._Count - 1 do begin
                if joField.list._(iTemp)._(1) = AField.AsString then begin
                    Result  := joField.list._(iTemp)._(0);
                    break;
                end;
            end;
        end;

    end else if AConfig.type = 'date' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            if Trunc(AField.AsDateTime) = 0 then begin
                Result  := '';
            end else begin
                Result  := FormatDatetime('yyyy-MM-dd',AField.AsDateTime);
            end;
        end;
    end else if AConfig.type = 'datetime' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            if Trunc(AField.AsDateTime) = 0 then begin
                Result  := '';
            end else begin
                Result  := FormatDatetime('yyyy-MM-dd hh:mm:ss',AField.AsDateTime);
            end;
        end;
    end else if AConfig.type = 'money' then begin
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsFloat]);
        end else begin
            Result  := Format('%n',[AField.AsFloat]);
        end;
    end else if AConfig.type = 'time' then begin
        if AConfig.Exists('format') then begin
            Result  := FormatDatetime(AConfig.format,AField.AsDateTime);
        end else begin
            Result  := FormatDatetime('hh:mm:ss',AField.AsDateTime);
        end;
    end else if AConfig.type = 'image' then begin
        //
        Result  := String(AConfig.imgdir) + String(AField.AsString);
    end else begin
        if AConfig.Exists('format') then begin
            Result  := Format(AConfig.format,[AField.AsString]);
        end else begin
            Result  := AField.AsString;
        end;
    end;

    //
    Result  := StringReplace(Result,#13,'',[rfReplaceAll]);
    Result  := StringReplace(Result,#10,'',[rfReplaceAll]);
end;

//根据表名、字段名，生成选项JSON数组
function _GetItems(
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
function _GetViewFieldCount(AFields:Variant):Integer;
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

function _GetWhere(
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
procedure _GetPageData(
        AQuery:TFDQuery;        //对应的ADOQuery控件
        ATable:string;          //表名
        AFields:string;         //字段列表  = '*'或'Name,Age,job,title'
        AWhere:string;          //WHERE条件,例: 'WHERE id>10'
        AOrder:String;          //AOrder = 'ORDER BY name DESC'
        APage:Integer;          //当前页码,从1开始
        ACount:Integer;         //每页显示的记录数
        Var ARecordCount:Integer//记录总数
        );
var
    bAccept     : Boolean;  //用于触发事件中的一个变量，此处无意义
    oForm       : TForm;
    iTable      : Integer;
begin

    //----求总数------------------------------------------------------------------------------------
    AQuery.FetchOptions.RecsSkip    := 0;
    AQuery.FetchOptions.RecsMax     := -1;

    AQuery.Close;
    AQuery.SQL.Text := 'SELECT Count(*) FROM '+ATable+' '+AWhere;
    AQuery.Open;

    //<触发事件
    oForm   := TForm(AQuery.Owner);     //取得主窗体
    bAccept := True;    //无意义的必须变量
    //取表序号，0表示主表，1~n依次表示各从表
    if AQuery.Name = 'FQ_Main' then begin
        iTable  := 0;
    end else begin
        iTable  := StrToIntDef(Copy(AQuery.Name,4,1),-1);
    end;
    if iTable <> -1 then begin
        if Assigned(oForm.OnDragOver) then begin
            oForm.OnDragOver(oForm,nil,iTable,5,dsDragEnter,bAccept);
        end;
    end;
    //>

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

//从数据表中取数据，置入StringGrid中
function _GetDataToGrid(
        AQuery : TFDQuery;
        ASG : TStringGrid;
        ATrackBar : TTrackBar;
        AConfig : Variant   //包括以下信息：ATable,AFields,AWhere,AOrder:String;APage,ACount:Integer;
        ):Integer;
var
    oEvent          : Procedure(Sender:TObject) of Object;

    iRecordCount    : Integer;
    iRow,iCol       : Integer;
    iOldRecNo       : Integer;
    iItem           : Integer;
    iDec            : Integer;  //用于表示因为多选列生成的JSON字段和FDQuery字段序号之间的偏差
    iColDec         : Integer;  //用于控制Stringgrid列序号和FDQuery字段序号之间的偏差
    //
    sTable          : String;   //数据表名
    sFields         : string;   //字段列表，如：id,name,age,remark
    sWhere          : string;   //过滤条件
    sOrder          : string;   //排序条件
    iPageNo         : Integer;  //页数,从0开始
    iPageSize       : Integer;  //每页条数
    iMode           : Byte;
begin
    if AConfig = unassigned then begin
        Result  := -1;
        Exit;
    end;

    //取得对应的参数设置
    sTable      := AConfig.table;       //表名
    sWhere      := AConfig.where;       //过滤条件
    sOrder      := AConfig.order;       //排序
    iPageNo     := AConfig.pageno;      //页码，从0始
    iPageSize   := AConfig.pagesize;    //每页行数
    sFields     := _GetFields(AConfig.fields,False);  //得到字段字符串列表

    //保存事件，并清空，以防止循环处理
    oEvent  := ATrackBar.OnChange;
    ATrackBar.OnChange  := nil;

    //保存原Recno
    iOldRecNo   := AQuery.RecNo;
    AQuery.DisableControls;

    //根据条件, 得出数据. 即根据条件，OPEN对应的FDQuery
    //完成两项；1 求出总记录条数；2 打开对应的FDQuery表
    _GetPageData(
        AQuery,
        sTable,
        sFields,
        sWhere,
        sOrder,
        iPageNo,
        iPageSize,
        iRecordCount);

    //设置分页控件值
    ATrackBar.Max       := iRecordCount;
    ATrackBar.PageSize  := iPageSize;

    //清空原StringGrid数据记录(主要防止数据记录未写满页面显示错误)
    for iRow := 1 to ASG.RowCount-1 do begin
        for iCol := 0 to ASG.ColCount-1 do begin
            ASG.Cells[iCol,iRow]    := '';
        end;
    end;
    ASG.Row := 1;

    //如果超出最大页数,则为最大页数
    if iPageNo > Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize)) then begin
        iPageNo := Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize));
    end;

    //强制iPageNo 从0开始
    iPageNo := Max(0,iPageNo);

    //显示数据记录
    if not AQuery.IsEmpty then begin
        for iRow := 1 to ASG.RowCount-1 do begin
            iDec    := 0;
            iColDec := 0;
            for iItem := 0 to AConfig.fields._Count - 1 do begin
                //跳过多选列
                if AConfig.fields._(iItem).type =  'check' then begin
                    iDec    := -1;
                    continue;
                end;

                //根据是否显示（view属性）进行处理
                iMode   := dwGetInt(AConfig.fields._(iItem),'view',0);
                case iMode of
                    0 : begin
                        ASG.Cells[iItem+iColDec,iRow]    := _GetFieldValue(AQuery.Fields[iItem+iDec],AConfig.fields._(iItem));
                    end;
                else
                    //每发现一个不在主表格中显示的字段，减1
                    Dec(iColDec);
                end;
            end;
            //
            AQuery.Next;

            //如果已达末尾，则退出
            if AQuery.Eof then begin
                break;
            end;
        end;
    end;

    //默认指定第一条记录
    AQuery.First;

    //恢复事件
    ATrackBar.Position  := iPageNo;
    ATrackBar.OnChange  := oEvent;
    //FreeAndNil(oEvent);

    //恢复原Recno
    AQuery.RecNo    := iOldRecNo;
    AQuery.EnableControls;


end;


procedure qcUpdateMain(AForm:TForm;AWhere:String);
var
    iField      : Integer;
    iItem       : Integer;
    iList       : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    sText       : String;
    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    joStyleName : Variant;
    //
    oFDQuery    : TFDQuery;
    oTMa        : TTrackBar;
    oGMn        : TStringGrid;
    oEKw        : TEdit;
    oFQy        : TFlowPanel;
    oPQF        : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCBQy       : TComboBox;
    oBFz        : TButton;
    oBQy        : TButton;
begin
    //取得配置JSON
    joConfig    := qcGetConfigJson(AForm);

    //取得字段名称列表，备用，返回值为sFields, 如：id,Name,age
    sFields     := _GetFields(joConfig.fields,False);

    //取得各控件备用
    oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));    //主表数据库
    oEKw        := TEdit(AForm.FindComponent('EKw'));           //查询关键字
    oGMn        := TStringGrid(AForm.FindComponent('GMn'));     //主表显示StringGrid
    oTMa        := TTrackBar(AForm.FindComponent('TMa'));       //主表分页
    oBFz        := TButton(AForm.FindComponent('BFz'));         //模糊/精确匹配 切换按钮
    oBQy        := TButton(AForm.FindComponent('BQy'));         //查询按钮
    oFQy        := TFlowPanel(AForm.FindComponent('FQy'));      //分字段查询字段的流式布局容器面板

    //数据库类型
    if not joConfig.Exists('database') then begin
        joConfig.database   := lowerCase(oFDQuery.Connection.DriverName); //'access';
        qcSetConfig(AForm,joConfig);
    end;

    //取得WHERE, 区分“智能模糊查询”和“分字段查询”2种情况
    //结果类似:  WHERE ((model like '%ljt%') and (name like '%west%'))
    if ( oFQy <> nil ) and (oFQy.Visible) then begin
        //初始化查询 WHERE 字符串
        if joConfig.where = '' then begin
            sWhere  := 'WHERE ((1=1) and ';
        end else begin
            sWhere  := 'WHERE (('+joConfig.where+') and ';
        end;

        //逐个字段处理
        if oFQy.Visible AND (oBQy.Tag = 1) then begin
            for iItem := 0 to oFQy.ControlCount-1 do begin

                //得到每个字段的Panel
                oPQF    := TPanel(oFQy.Controls[iItem]);

                //取得字段序号
                iField  := oPQF.Tag;

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
                if sType = 'boolean' then begin
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    case oCBQy.ItemIndex of
                        0 : begin   //当前无查询
                        end;
                        1 : begin   //false
                            sWhere  := sWhere + '('+joField.name +' = 0 ) and ';
                        end;
                        2 : begin   //true
                            sWhere  := sWhere + '('+joField.name +' = 1 ) and ';
                        end;
                    end;
                end else if sType = 'date' then begin
                    //取得起始结束日期控件
                    oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[1]);
                    oDT_End     := TDateTimePicker(TPanel(oPQF.Controls[1]).Controls[2]);

                    //转为字符串以方便后面生成WHERE
                    sStart  := FormatDateTime('YYYY-MM-DD',oDT_Start.Date);
                    sEnd    := FormatDateTime('YYYY-MM-DD',oDT_End.Date+1);  //+1 以避免查询不到当天的bug
                    //根据不同数据库，生成不同的SQL
                    if lowercase(joConfig.database) = 'msacc' then begin
                        if sStart = '9999-09-09' then begin
                            if sEnd = '9999-09-10' then begin
                                //不处理
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' < #'+sEnd+'# )'+
                                        ') and ';
                            end;
                        end else begin
                            if sEnd = '9999-09-10' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' >= #'+sStart+'# )'+
                                        ') and ';
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' >= #'+sStart+'# )'+
                                            ' and '+
                                            '('+joField.name +' < #'+sEnd+'# )'+
                                        ') and ';
                            end;
                        end;
                    end else if lowercase(joConfig.database) = 'oracle' then begin
                        if sStart = '9999-09-09' then begin
                            if sEnd = '9999-09-10' then begin
                                //不处理
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '(to_char('+joField.name +',''YYYY-MM-DD'') < '''+sEnd+''' )'+
                                        ') and ';
                            end;
                        end else begin
                            if sEnd = '9999-09-10' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '(to_char('+joField.name +',''YYYY-MM-DD'') >= '''+sStart+''' )'+
                                        ') and ';
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '(to_char('+joField.name +',''YYYY-MM-DD'') >= '''+sStart+''' )'+
                                            ' and '+
                                            '(to_char('+joField.name +',''YYYY-MM-DD'') < '''+sEnd+''' )'+
                                        ') and ';
                            end;
                        end;
                    end else begin
                        if sStart = '9999-09-09' then begin
                            if sEnd = '9999-09-10' then begin
                                //不处理
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' < '''+sEnd+''' )'+
                                        ') and ';
                            end;
                        end else begin
                            if sEnd = '9999-09-10' then begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' >= '''+sStart+''' )'+
                                        ') and ';
                            end else begin
                                sWhere  := sWhere +
                                        '('+
                                            '('+joField.name +' >= '''+sStart+''' )'+
                                            ' and '+
                                            '('+joField.name +' < '''+sEnd+''' )'+
                                        ') and ';
                            end;
                        end;
                    end;
                end else if (sType = 'datetime') then begin
                    oDT_Start   := TDateTimePicker(TPanel(oPQF.Controls[1]));
                    if oDT_Start.HelpContext = 1 then begin //起始时间
                        sStart  := FormatDateTime('YYYY-MM-DD hh:mm:ss',oDT_Start.DateTime);
                        if lowercase(joConfig.database) = 'msacc' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' >= #'+sStart+'# )'+
                                    ') and ';
                        end else if lowercase(joConfig.database) = 'oracle' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '(to_char('+joField.name +',''YYYY-MM-DD hh:mm:ss'') >= '''+sStart+''' )'+
                                    ') and ';
                        end else begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' >= '''+sStart+''' )'+
                                    ') and ';
                        end;
                    end;
                    if oDT_Start.HelpContext = -1 then begin //结束时间
                        sEnd    := FormatDateTime('YYYY-MM-DD hh:mm:ss',oDT_Start.DateTime);
                        if lowercase(joConfig.database) = 'msacc' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' <= #'+sEnd+'# )'+
                                    ') and ';
                        end else if lowercase(joConfig.database) = 'oracle' then begin
                            sWhere  := sWhere +
                                    '('+
                                        '(to_char('+joField.name +',''YYYY-MM-DD hh:mm:ss'') <= '''+sEnd+''' )'+
                                    ') and ';
                        end else begin
                            sWhere  := sWhere +
                                    '('+
                                        '('+joField.name +' <= '''+sEnd+''' )'+
                                    ') and ';
                        end;
                    end;
                end else if (sType = 'combo') OR (sType = 'dbcombo') then begin
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        //
                        if oBFz.Tag = 0 then begin
                            sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCBQy.Text)+'%'' ) and ';
                        end else begin
                            sWhere  := sWhere + '('+joField.name +' = '''+Trim(oCBQy.Text)+''' ) and ';
                        end;
                    end;
                end else if (sType = 'combopair') then begin
                    //得到字段控件
                    oCBQy   := TComboBox(oPQF.Controls[1]);
                    if Trim(oCBQy.Text) <> '' then begin
                        //根据字段的list取到对应的值
                        sText   := '';
                        for iList := 0 to joField.list._Count - 1 do begin
                            if joField.list._(iList)._(0) = oCBQy.Text then begin
                                sText   := joField.list._(iList)._(1);
                                break;
                            end;
                        end;

                        //
                        if sText <> '' then begin
                            if TFieldType(joField.datatype) in qcstInteger then begin
                                sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(sText,0))+' ) and ';
                            end else if TFieldType(joField.datatype) in qcstFloat then begin
                                sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(sText,0))+' ) and ';
                            end else begin
                                if oBFz.Tag = 0 then begin
                                    sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oCBQy.Text)+'%'' ) and ';
                                end else begin
                                    sWhere  := sWhere + '('+joField.name +' = '''+sText+''' ) and ';
                                end;
                            end;
                        end;
                    end;
                end else begin  //
                    oE_Query    := TEdit(oPQF.Controls[1]);
                    if Trim(oE_Query.Text) <> '' then begin
                        //
                        if oBFz.Tag = 0 then begin
                            sWhere  := sWhere + '('+joField.name +' like ''%'+Trim(oE_Query.Text)+'%'' ) and ';
                        end else begin
                            if TFieldType(joField.datatype) in [ftInteger,ftSmallint,ftWord,ftLargeint] then begin
                                sWhere  := sWhere + '('+joField.name +' = '+IntToStr(StrToIntDef(Trim(oE_Query.Text),0))+' ) and ';
                            end else if TFieldType(joField.datatype) in [ftFloat,ftCurrency,ftBCD] then begin
                                sWhere  := sWhere + '('+joField.name +' = '+FloatToStr(StrToFloatDef(Trim(oE_Query.Text),0))+' ) and ';
                            end else begin
                                sWhere  := sWhere + '('+joField.name +' = '''+Trim(oE_Query.Text)+''' ) and ';
                            end;
                        end;
                    end;
                end

            end;
        end;
        //删除最后的 ' and '
        sWhere  := Copy(sWhere,1,Length(sWhere)-4);

        //
        sWhere  := sWhere + ')';
    end else begin
        //从智能模糊查询框的关键字中生成查询字符串
        //返回值为 ' WHERE (1=1) ' 或
        //         ' WHERE ((....) oR (...))'
        sWhere  := _GetWhere(sFields, oEKw.Text);

        //添加固定的where
        if joConfig.where <> '' then begin
            Delete(sWhere,1,Length(' WHERE'));
            sWhere  := ' WHERE (('+joConfig.where+') and ' + sWhere+')';
        end;
    end;

    //AWhere 额外的 WHERE 条件(从外部调用dwUpdateMain函数)
    if AWhere <> '' then begin
        sWhere  := sWhere + ' and '+AWhere;
    end;

    //
    joStyleName := _json(oGMn.StyleName);

    //表格筛选中的条件
    if dwGetStr(joStyleName,'filter','') <> '' then begin
        sWhere  := sWhere + ' and '+joStyleName.filter;
    end;

    //生成配置信息
    joDBConfig  := _json('{}');
    joDBConfig.table        := joConfig.table;
    joDBConfig.where        := sWhere;
    joDBConfig.order        := dwGetStr(joStyleName,'sort','');
    joDBConfig.pageno       := oTMa.Position;
    joDBConfig.pagesize     := joConfig.pagesize;
    joDBConfig.fields       := _json(joConfig.fields);

    //从数据表中取数据，置入StringGrid
    _GetDataToGrid(
            oFDQuery,           //AQuery:TFDQuery;
            oGMn,               //ASG:TStringGrid;
            oTMa,               //ATrackBar:TTrackBar
            joDBConfig
            );

    //
    oTMa.Visible    := (oTMa.Max / oTMa.PageSize) > 1;

    //
    oGMn.Row    := oFDQuery.RecNo;
    //dwRunJS('this.$refs.'+dwFullName(oGMn)+'.bodyWrapper.scrollTop = 0;',AForm);
    //UpdateSlaves;
end;


procedure qcUpdateSlaves(AForm:TForm);
var
    iSlave      : Integer;
    //
    sFields     : string;
    sMValue     : string;
    sWhere      : string;
    //
    joConfig    : variant;
    joSlave     : Variant;
    joDBConfig  : Variant;
    joTemp      : Variant;
    joStyleName : Variant;
    //
    oFQ_Main    : TFDQuery;
    oFDQuery    : TFDQuery;
    oTB         : TTrackBar;
    oSG         : TStringGrid;
    oSBQ       : TScrollBox;
begin
    //
    joConfig    := qcGetConfigJson(AForm);
    //如果没有slave,则退出
    if not joConfig.Exists('slave') then begin
        Exit;
    end;

    //得到主表
    oFQ_Main    := TFDQuery(AForm.FindComponent('FQ_Main'));

    //逐个更新slave
    for iSlave := 0 to joConfig.slave._Count-1 do begin
        //得到从表JSON
        joSlave := joConfig.slave._(iSlave);

        //主表关联字段值
        sMValue := oFQ_Main.FieldByName(joSlave.masterfield).AsString;

        //得到查询控件
        oFDQuery   := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(iSlave)));

        //得到分页组件
        oTB := TTrackBar(AForm.FindComponent('TB'+IntToStr(iSlave)));

        //得到从表的表格
        oSG := TStringGrid(AForm.FindComponent('SG'+IntToStr(iSlave)));

        //关联字段需要是整数型，如果非整数，则表示当前主表为空
        if oFQ_Main.FieldByName(joSlave.masterfield).DataType in [ftSmallint,ftInteger,ftWord,ftLargeint,ftShortint,ftByte,ftAutoInc,ftLongWord] then begin
            sWhere      := 'WHERE ('+joSlave.slavefield+'='+sMValue+')';
        end else begin
            sWhere      := 'WHERE ('+joSlave.slavefield+'='''+sMValue+''')';
        end;

        //取得从表字段名称列表，备用
        sFields := _GetFields(joSlave.fields,False);

        //添加弹出式查询的where
        oSBQ       := TScrollBox(AForm.FindComponent('SBQ'+IntToStr(iSlave+1)));
        if oSBQ <> nil then begin
            joTemp      := _json(oSBQ.Hint);
            if joTemp <> unassigned then begin
                if joTemp.Exists('where') then begin
                    if Length(joTemp.where)>5 then begin
                        sWhere  := sWhere + ' and '+joTemp.where;
                    end;
                end;
            end;
        end;

        //添加从表自己设定的where
        if joSlave.Exists('where') then begin
            sWhere  := sWhere + ' and ('+joSlave.where+')';
        end;

        //处理主表为空的情况
        if oFQ_Main.IsEmpty then begin
            sWhere  := 'WHERE (1=2)';
        end;

        //
        joStyleName := _json(oSG.StyleName);

        //表格筛选中的条件
        if dwGetStr(joStyleName,'filter','') <> '' then begin
            sWhere  := sWhere + ' and '+joStyleName.filter;
        end;

        //生成配置信息
        joDBConfig  := _json('{}');
        joDBConfig.table        := joSlave.table;
        joDBConfig.where        := sWhere;
        joDBConfig.order        := dwGetStr(joStyleName,'sort','');
        joDBConfig.pageno       := oTB.Position;
        joDBConfig.pagesize     := joConfig.slavepagesize;
        joDBConfig.fields       := _json(joSlave.fields);

        _GetDataToGrid(
                oFDQuery,           //AQuery:TFDQuery;
                oSG,                //ASG:TStringGrid;
                oTB,                //ATrackBar:TTrackBar
                joDBConfig
                );
        //
        oFDQuery.Tag    := oFDQuery.RecNo;
    end;
end;


procedure qcCreateConfirmPanel(AForm:TForm);
var
    oPDe    : TPanel;
    oLCF    : TLabel;
    oBDO    : TButton;
    oBDC    : TButton;
    //用于指定事件
    tM      : TMethod;
begin
    oPDe   := TPanel.Create(AForm);
    with oPDe do begin
        Name        := 'PDe';
        Parent      := AForm;
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
    oLCF  := TLabel.Create(AForm);
    with oLCF do begin
        Name        := 'LCF';
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
    oBDO  := TButton.Create(AForm);
    with oBDO do begin
        Name        := 'BDO';
        Parent      := oPDe;
        Top         := 140;
        Left        := 170;
        Width       := 170;
        Height      := 60;
        Caption     := '确定';
        Font.Size   := 14;
        Hint        := '{"type":"primary","dwstyle":"border-top:solid 1px #dcdfd6;border-right:0px;","radius":"0px"}';
        //
        tM.Code     := @BDOClick;
        tM.Data     := Pointer(325); // 随便取的数
        OnClick     := TNotifyEvent(tM);
    end;
    //
    oBDC  := TButton.Create(AForm);
    with oBDC do begin
        Name        := 'BDC';
        Parent      := oPDe;
        Top         := 140;
        Left        := 0;
        Width       := 170;
        Height      := 60;
        Font.Size   := 14;
        Caption     := '取消';
        Hint        := '{"dwstyle":"background:#FFF;border:solid 1px #dcdfd6;","radius":"0px"}';
        //
        tM.Code     := @BDCClick;
        tM.Data     := Pointer(325); // 随便取的数
        OnClick     := TNotifyEvent(tM);
    end;
end;

procedure qcCreateField(AForm:TForm;AWidth:Integer;ASuffix:String;AConfig,AField:Variant;AP_Content:TFlowPanel);
var
    ooP         : TPanel;
    ooL         : TLabel;
    ooE         : TEdit;
    ooI         : TImage;
    ooB         : TButton;
    ooM         : TMemo;
    ooDT        : TDateTimePicker;
    ooCB        : TComboBox;
    oQueryTmp   : TFDQuery;
    //
    iItem       : Integer;
    //
    joList      : Variant;
    joItems     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //标题默认为field.name
    if not AField.Exists('caption') then begin
        AField.caption  := String(AField.name);
    end;

    //取得Query备用
    oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

    //字段容器Panel
    ooP     := TPanel.Create(AForm);
    with ooP do begin
        Name        := 'PF'+ASuffix;
        Parent      := AP_Content;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        AutoSize    := False;
        Height      := 46;
        Width       := AWidth;
        Color       := clNone;
        Font.Size   := 11;
    end;
    //字段的标签 在容器左边
    ooL     := TLabel.Create(AForm);
    with ooL do begin
        Name            := 'LF'+ASuffix;
        Parent          := ooP;
        AutoSize        := False;
        Align           := alLeft;
        Alignment       := taRightJustify;
        Width           := 80;
        AlignWithMargins:= True;
        Margins.Top     := 0;
        Margins.Left    := 10;
        Margins.Right   := 15;
        Layout          := tlCenter;
        if dwGetInt(AField,'must',0) = 1 then begin
            Caption     := '*&nbsp;'+StringReplace(AField.caption,'\n','',[rfReplaceAll]);
            //Font.Color  := clRed;
        end else begin
            Caption     := StringReplace(AField.caption,'\n','',[rfReplaceAll]);
        end;
    end;

    //各字段编辑控件
    if AField.type = 'boolean' then begin //自带选项的类型，选项在list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"height":34}';
            //
            if AField.Exists('list') then begin
                if AField.list <> null then begin
                    joList  := AField.list;
                    //添加选项
                    for iItem := 0 to Min(1,joList._Count-1) do begin
                        Items.Add(joList._(iItem));
                    end;
                end;
            end else begin
                Items.Add('False');
                Items.Add('True');
            end;
        end;
    end else if AField.type = 'combo' then begin //自带选项的类型，选项在list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"height":34}';
            //
            if AField.Exists('list') then begin
                if AField.list <> null then begin
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
            end else begin
                Items.Add('');
            end;
        end;
    end else if AField.type = 'combopair' then begin //自带选项pair的类型，选项在二维数组list里设置
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"height":34}';
            //
            if AField.Exists('list') then begin
                if AField.list <> null then begin
                    joList  := AField.list;
                    //默认添加一个空值
                    if joList._Count > 0 then begin
                        if joList._(0)._(0) <> '' then begin
                            Items.Add('');
                        end;
                    end;
                    //添加选项
                    for iItem := 0 to joList._Count-1 do begin
                        Items.Add(joList._(iItem)._(0));
                    end;
                end else begin
                    Items.Add('');
                end;
            end else begin
                Items.Add('');
            end;
        end;
    end else if AField.type = 'dbcombo' then begin  //从数据库内读数据的选项类型，由joConfig.table表中joField.name取值
        ooCB := TComboBox.Create(AForm);
        with ooCB do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"height":34}';
            //
            Items.Add('');

            //指定table
            if not AField.Exists('table') then begin
                AField.table    := AConfig.table;
            end;

            //指定字段field
            if not AField.Exists('field') then begin
                AField.field    := AField.name;
            end;

            //添加数据库内的值
            joItems := _GetItems(oQueryTmp,AField.table,AField.field);
            for iItem := 0 to joItems._Count-1 do begin
                Items.Add(joItems._(iItem));
            end;
        end;
    end else if AField.type = 'file' then begin  //文件
        //显示文件名
        ooL := TLabel.Create(AForm);
        with ooL do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            Layout          := tlCenter;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Width           := 34;
            //Hint            := '{"dwattr":"fit=''cover''"}';
        end;

        //添加一个上传按钮
        ooB := TButton.Create(AForm);
        with ooB do begin
            Name            := 'FB'+ASuffix;
            Parent          := ooP;
            Align           := alRight;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Width           := 34;
            Cancel          := True;
            Caption         := '';
            Hint            := '{"icon":"el-icon-upload2"'
                    +',"imgdir":"'+dwGetStr(AField,'imgdir','')+'"'
                    +',"imgtype":'+dwGetStr(AField,'imgtype','')
                    +'}';
            //
            tM.Code         := @BUpClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;

    end else if AField.type = 'image' then begin  //图片
        //先显示一个图片
        ooI := TImage.Create(AForm);
        with ooI do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alLeft;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Width           := 34;
            Stretch         := True;
            Proportional    := True;
            //Hint            := '{"dwattr":"fit=''cover''"}';
        end;

        //添加一个上传按钮
        ooB := TButton.Create(AForm);
        with ooB do begin
            Name            := 'FB'+ASuffix;
            Parent          := ooP;
            Align           := alRight;
            AlignWithMargins:= True;
            Margins.Right   := 18;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Width           := 34;
            Cancel          := True;
            Caption         := '';
            Hint            := '{"icon":"el-icon-upload2"'
                    +',"imgdir":"'+dwGetStr(AField,'imgdir','')+'"'
                    +',"imgtype":'+dwGetStr(AField,'imgtype','')
                    +'}';
            //
            tM.Code         := @BUpClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;

    end else if AField.type = 'integer' then begin  //整型
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
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
    end else if AField.type = 'date' then begin //日期型
        ooDT    := TDateTimePicker.Create(AForm);
        with ooDT do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
            Align           := alClient;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"border:solid 1px #dcdfe6;border-radius:3px;"}';
        end;

    end else if AField.type = 'time' then begin
        ooDT    := TDateTimePicker.Create(AForm);
        with ooDT do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
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
    end else if AField.type = 'datetime' then begin
        ooDT    := TDateTimePicker.Create(AForm);
        with ooDT do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
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
    end else if AField.type = 'money' then begin
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
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
    end else if AField.type = 'memo' then begin
        ooM := TMemo.Create(AForm);
        with ooM do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
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
                ooP.Height  := AField.height;
            end;
        end;
    end else if AField.type = 'tree' then begin
        //
        ooP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"","options":"'+AField.options+'"}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;
    end else if AField.type = 'dbtree' then begin
        //
        ooP.Hint    := '{"dwstyle":"overflow:visible;"}';
        //
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            HelpKeyword     := 'tree';
            Parent          := ooP;
            Align           := alClient;
            //Alignment       := taRightJustify;
            AlignWithMargins:= True;
            Margins.Right   := 20;
            Margins.Bottom  := 6;
            Margins.Top     := 6;
            Text            := '';
            Color           := clNone;
            //
            Hint            := '{"dwstyle":"","options":"'+qcDbToOptions(oQueryTmp,AField,dwGetInt(AField,'treemode',0))+'"}';

            //如果是自增字段，则只读
            if AField.type = 'auto' then begin
                Enabled     := False;
            end;
        end;
    end else begin
        ooE := TEdit.Create(AForm);
        with ooE do begin
            Name            := 'F'+ASuffix;
            Parent          := ooP;
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

end;

function  qcCreateFieldQuery(AForm:TForm;AField:Variant;AIndex:Integer;ASuffix:String;AFlowPanel:TFlowPanel):Integer;
var
    oPQF        : TPanel;
    oL_Query    : TLabel;
    oCBQy       : TComboBox;
    oP_DateSE   : TPanel;
    oDT_Start   : TDateTimePicker;
    oL_Space    : TLabel;
    oDT_End     : TDateTimePicker;
    oE_Query    : TEdit;
    //
    oQueryTmp   : TFDQuery;
    //
    iItem       : Integer;
    //
    joItems     : Variant;
    joConfig    : Variant;
    //
    sTable      : String;
    sTemp       : String;
begin
    //取得配置JSON对象
    joConfig    := qcGetConfigJson(AForm);

    //取到临时查询
    oQueryTmp   := TFDQuery(AForm.FindComponent('FDQueryTmp'));

    //创建一个单字段查询面板
    oPQF := TPanel.Create(AForm);
    with oPQF do begin
        Name            := 'PQ'+ASuffix;
        Parent          := AFlowPanel;
        Color           := clNone;
        Width           := joConfig.editwidth - 15 ;
        Height          := 45;
        Tag             := AIndex;
    end;

    //创建查询字段标签
    oL_Query    := TLabel.Create(AForm);
    with oL_Query do begin
        Name            := 'LF'+ASuffix;
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
        Margins.Bottom  := 7;
    end;

    //
    if AField.type = 'boolean' then begin
        //创建查询字段combo
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            Style           := csDropDownList;
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

            //默认添加一个空值
            Items.Add('');
            Items.Add('false');
            Items.Add('true');

            //
            if AField.Exists('list') then begin
                if AField.list<> null then begin
                    if AField.list._Count > 1 then begin
                        Items.Clear;
                        Items.Add('');
                        for iItem := 0 to 1 do begin
                            Items.Add(AField.list._(iItem));
                        end;
                    end;
                end;
            end;

            //设置默认查询值
            ItemIndex   := Items.IndexOf(dwGetStr(AField,'defaultqv',''));
        end;
    end else if AField.type = 'combo' then begin
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            //Style           := csDropDownList;
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

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

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end else if AField.type = 'combopair' then begin
        //创建查询字段EDIT
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            Align           := alClient;
            //Style           := csDropDownList;
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Top     := 6;
            Margins.Bottom  := 10;

            //默认添加一个空值
            if AField.list._Count > 0 then begin
                if AField.list._(0)._(0) <> '' then begin
                    Items.Add('');
                end;
            end;
            //
            for iItem := 0 to AField.list._Count-1 do begin
                Items.Add(AField.list._(iItem)._(0));
            end;

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end else if AField.type = 'dbcombo' then begin
        //创建数据库查询ComboBox
        oCBQy   := TComboBox.Create(AForm);
        with oCBQy do begin
            Name            := 'EQ'+ASuffix;
            Parent          := oPQF;
            Tag             := AIndex;
            //Style           := csDropDownList;
            Text            := '';
            Align           := alClient;
            //
            AlignWithMargins:= True;
            Margins.Top     := 5;
            Margins.Bottom  := 9;
            //先添加一个空值
            oCBQy.Items.Add('');
            //添加数据库内的值
            joItems := _GetItems(oQueryTmp,joConfig.table,AField.name);
            for iItem := 0 to joItems._Count-1 do begin
                oCBQy.Items.Add(joItems._(iItem));
            end;

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end else if AField.type = 'date' then begin
        //创建面板存放起始结束日期
        oP_DateSE := TPanel.Create(AForm);
        with oP_DateSE do begin
            Name            := 'PDE'+ASuffix;
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
        oDT_Start   := TDateTimePicker.Create(AForm);
        with oDT_Start do begin
            Name        := 'DS'+ASuffix;
            Parent      := oP_DateSE;
            Align       := alLeft;
            Align       := alNone;
            Left        := -25;
            Tag         := AIndex;
            Top         := 1;
            Width       := 135;
            Height      := 28;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            if AField.Exists('min') then begin
                Date    := StrToDateDef(AField.min,Now);
            end else begin
                Date    := _GetQueryStartDate(dwGetStr(AField,'defaultqv',''));
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

        //起止日期间分隔符
        oL_Space    := TLabel.Create(AForm);
        with oL_Space do begin
            Name        := 'LS'+ASuffix;
            Parent      := oP_DateSE;
            Tag         := AIndex;
            AutoSize    := False;
            Alignment   := taCenter;
            Left        := 78;
            Top         := 5;
            Caption     := '—';
            Width       := 30;
            Transparent := False;
            Color       := clWhite;
            Hint        := '{"dwstyle":"z-index: 1;"}'
        end;

        //创建查询结束日期
        oDT_End   := TDateTimePicker.Create(AForm);
        with oDT_End do begin
            Parent      := oP_DateSE;
            Name        := 'DE'+ASuffix;
            Tag         := AIndex;
            Left        := 80;
            Top         := 1;
            Width       := 135;
            Height      := 28;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            if AField.Exists('max') then begin
                Date    := StrToDateDef(AField.max,Now);
            end else begin
                Date    := _GetQueryEndDate(dwGetStr(AField,'defaultqv',''));
            end;
            Hint        := '{"dwattr":":clearable=\"false\""}';
        end;

    end else if AField.type = 'datetime' then begin    //=======================

        //<-----创建起始日期时间
        //设置默认值
        if not AField.Exists('min') then begin
            AField.min := '2000-01-01 00:00:00'
        end;
        //更新标签
        oL_Query.Caption    := AField.caption + '>=';
        //创建查询起始日期
        oDT_Start   := TDateTimePicker.Create(AForm);
        with oDT_Start do begin
            Name            := 'DS'+ASuffix;
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
        oPQF := TPanel.Create(AForm);
        with oPQF do begin
            Name            := 'PDT'+ASuffix;
            Parent          := AFlowPanel;
            Color           := clNone;
            Width           := 335;
            Height          := 40;
            Tag             := AIndex;
        end;
        //创建查询字段标签
        oL_Query    := TLabel.Create(AForm);
        with oL_Query do begin
            Name                := 'LQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Align               := alLeft;
            Layout              := tlCenter;
            Caption             := AField.caption + '<=';
            Alignment           := taRightJustify;
            Width               := 80;
            //
            AlignWithMargins    := True;
            Margins.Left        := 10;
        end;
        //

        //创建查询结束日期
        oDT_End := TDateTimePicker.Create(AForm);
        with oDT_End do begin
            Name                := 'DE'+ASuffix;
            Parent              := oPQF;
            Align               := alClient;

            //针对D10.4.2以前无 dtkDateTime 的处理 ,标识为：日期+时间型
            {$IFDEF VER340}
                ShowHint    := True;
            {$ELSE}
                Kind        := dtkDateTime;
            {$ENDIF}

            Format              := 'yyyy-MM-dd HH:mm:ss';
            Tag                 := AIndex;
            Height              := 28;
            HelpContext         := -1;  //标记为结束时间
            Date                := StrToDateDef(Copy(AField.max,1,10),Now);
            Time                := StrToTimeDef(Copy(AField.max,12,8),Now);
            Hint                := '{"dwstyle":"border:solid 1px #DCDFE6;border-radius:3px;"}';
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;
        end;
        //----->
    end else begin
        //创建查询字段EDIT
        oE_Query    := TEdit.Create(AForm);
        with oE_Query do begin
            Name                := 'EQ'+ASuffix;
            Parent              := oPQF;
            Tag                 := AIndex;
            Text                := '';
            Align               := alClient;
            AlignWithMargins    := True;
            Margins.Top         := 5;
            Margins.Bottom      := 9;

            //设置默认查询值
            Text            := dwGetStr(AField,'defaultqv','');
        end;
    end;

end;


//创建查询用的Panel
procedure qcCreateQueryPanel(AForm:TForm);
var
    oPQy        : TPanel;       //编辑/新增 总Panel
    oPQT        : TPanel;       //顶部Panel, 用于放置：标题、最大化、关闭
    oBQT        : TButton;      //标题
    oBQX        : TButton;      //最大化
    oBQC        : TButton;      //关闭
    oPQB        : TPanel;       //底部按钮Panel, 放置：取消，确定
    oBQO        : TButton;      //确定按钮
    oBQR        : TButton;      //重置按钮
    oSB         : TScrollBox;   //滚动框，以放置更多字段编辑信息
    oFC         : TFlowPanel;   //多字段编辑信息的容器
    //
    iSlave      : Integer;
    iField      : Integer;
    iCount      : Integer;
    //
    joConfig    : Variant;
    joSlave     : Variant;
    joField     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //取得配置JSON
    joConfig    := qcGetConfigJson(AForm);

    //编辑/新增的总面板
    oPQy   := TPanel.Create(AForm);
    with oPQy do begin
        Name        := 'PQy';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Anchors     := [akBottom,akTop];
        Font.Size   := 11;
        Top         := 50;
        Width       := joConfig.editwidth;
        Height      := 400;     //应为自动
        Hint        := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
        Font.Color  := $323232;
        Color       := clWhite;
    end;

    //标题 Panel
    oPQT  := TPanel.Create(AForm);
    with oPQT do begin
        Name        := 'PQT';
        Parent      := oPQy;
        Align       := alTop;
        Height      := 50;
        Font.Size   := 17;
        Color       := clWhite;
        //
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //标题 Button
    oBQT  := TButton.Create(AForm);
    with oBQT do begin
        Name        := 'BQT';
        Parent      := oPQT;
        Align       := alLeft;
        Width       := 60;
        Caption     := '查询条件 ';
        Font.Size   := 15;
        Hint        := '{"dwstyle":"background:#fff;text-align:left;border:0;"}';
        //
        AlignWithMargins:= True;
        Margins.Left    := 10;
    end;

    //最大化 Button
    oBQX  := TButton.Create(AForm);
    with oBQX do begin
        Name        := 'BQX';
        Parent      := oPQT;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        //
        AlignWithMargins:= True;
        Margins.Right   := 0;
        //
        tM.Code         := @BQXClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
        //
        if joConfig.defaulteditmax = 1 then begin
            Tag := 9;
        end;
    end;

    //关闭 Button
    oBQC  := TButton.Create(AForm);
    with oBQC do begin
        Name        := 'BQC';
        Parent      := oPQT;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-close"}';
        //
        AlignWithMargins    := True;
        Margins.Right       := 10;
        //
        tM.Code     := @BQCClick;
        tM.Data     := Pointer(325); // 随便取的数
        OnClick     := TNotifyEvent(tM);
    end;

    //用于放置 OK/Cancel 的Panel
    oPQB               := TPanel.Create(AForm);
    with oPQB do begin
        Name        := 'PQB';
        Parent      := oPQy;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alBottom;
        Height      := 55;
        Color       := clNone;
    end;

    //
    oBQO  := TButton.Create(AForm);
    with oBQO do begin
        Name        := 'BQU';
        Parent      := oPQB            ;
        Align       := alRight;
        Width       := 80;
        Top         := 0;
        Left        := 0;
        Height      := 60;
        Font.Size   := 13;
        Caption     := '查询';
        Hint        := '{"type":"primary"}';
        //
        AlignWithMargins:= True;
        Margins.right   := 20;
        Margins.Bottom  := 24;
        //
        tM.Code         := @BQUClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oBQR  := TButton.Create(AForm);
    with oBQR do begin
        Name        := 'BRS';
        Parent      := oPQB;
        Align       := alRight;
        Top         := 0;
        Left        := 0;
        Width       := oBQO.Width;

        Height      := 60;
        Font.Size   := 13;
        Caption     := '重置';
        Hint        := '';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        Margins.Bottom  := 24;
        //
        tM.Code         := @BRSClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;



    //创建各从表各字段的编辑框
    if joConfig.Exists('slave') then begin
        for iSlave := 0 to joConfig.slave._Count-1 do begin
            //取得从表JSON对象
            joSlave := joConfig.slave._(iSlave);

            //从表编辑的ScrollBox
            oSB := TScrollBox.Create(AForm);
            with oSB do begin
                Name        := 'SBQ'+IntToStr(iSlave+1);
                Parent      := oPQy;
                Align       := alClient;
            end;
            //从表ScrollBox的内容Panel
            oFC   := TFlowPanel.Create(AForm);
            with oFC do begin
                Name        := 'FT'+IntToStr(iSlave+1);
                Parent      := oSB;
                BevelOuter  := bvNone;
                BorderStyle := bsNone;
                Align       := alTop;
                Color       := clWhite;
            end;



            //创建分字段查询的查询列表
            iCount  := -1;
            for iField := 0 to joSlave.fields._Count-1 do begin
                //取得当前字段JSON对象
                joField := joSlave.fields._(iField);

                //
                if dwGetInt(joField,'view',0)=0 then begin
                    Inc(iCount);
                end else begin
                    Continue;
                end;

                //如果字段加入分字段查询
                if joField.query = 1 then begin
                    //
                    qcCreateFieldQuery(
                            AForm,
                            joField,
                            iField,
                            IntToStr(iSlave)+'_'+IntToStr(iCount),
                            oFC);
                end;
            end;
            oFC.AutoSize := True;
        end;
    end;

end;


procedure qcCreateEditorPanel(AForm:TForm);
var
    oPEr        : TPanel;       //编辑/新增 总Panel
    oPET        : TPanel;       //顶部Panel, 用于放置：标题、最大化、关闭
    oBEL        : TButton;      //标题
    oBEM        : TButton;      //最大化
    oBEC        : TButton;      //关闭
    oPES        : TPanel;       //底部按钮Panel, 放置：取消，确定
    oBEK        : TButton;      //确定按钮
    oBEA        : TButton;      //取消按钮
    oSB         : TScrollBox;   //滚动框，以放置更多字段编辑信息
    oFC         : TFlowPanel;   //多字段编辑信息的容器
    oCK_Batch   : TCheckBox;    //批量新增checkbox
    //
    iSlave      : Integer;
    iField      : Integer;
    iMode       : Byte;
    //
    joConfig    : Variant;
    joSlave     : Variant;
    joField     : Variant;
    //用于指定事件
    tM          : TMethod;
begin
    //取得配置JSON
    joConfig    := qcGetConfigJson(AForm);
    //检查editwidth编辑面板宽度是否存在，默认为340
    if not joConfig.Exists('editwidth') then begin
        joConfig.editwidth  := 340;
    end;

    //检查editcolcount编辑面板中列数是否存在，默认为1
    if not joConfig.Exists('editcolcount') then begin
        joConfig.editcolcount  := 1;
    end;

    //编辑/新增的总面板
    oPEr   := TPanel.Create(AForm);
    with oPEr do begin
        Name        := 'PEr';
        Parent      := AForm;
        HelpKeyword := 'modal';
        Visible     := False;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Anchors     := [akBottom,akTop];
        Font.Size   := 14;
        Top         := 100;
        Height      := AForm.Height - 200;
        Hint        := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
        Font.Color  := $323232;
        Color       := clWhite;
        Width       := Min(AForm.width-20,joConfig.editwidth);
    end;

    //标题 Panel
    oPET  := TPanel.Create(AForm);
    with oPET do begin
        Name        := 'PET';
        Parent      := oPEr;
        Align       := alTop;
        Height      := 50;
        Font.Size   := 17;
        Color       := clWhite;
        //
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //标题 Button
    oBEL  := TButton.Create(AForm);
    with oBEL do begin
        Name        := 'BEL';
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

    //最大化 Button
    oBEM  := TButton.Create(AForm);
    with oBEM do begin
        Name        := 'BEM';
        Parent      := oPET;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-full-screen"}';
        //
        AlignWithMargins:= True;
        Margins.Right   := 0;
        //
        tM.Code         := @BEMClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);

        //
        if joConfig.defaulteditmax = 1 then begin
            Tag := 9;
        end;
    end;

    //关闭 Button
    oBEC  := TButton.Create(AForm);
    with oBEC do begin
        Name        := 'BEC';
        Parent      := oPET;
        Align       := alRight;
        Width       := 30;
        Caption     := '';
        Cancel      := True;
        Hint        := '{"type":"text","icon":"el-icon-close"}';
        //
        AlignWithMargins:= True;
        Margins.Right    := 10;
        //
        tM.Code         := @BEAClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //用于放置 OK/Cancel 的Panel
    oPES   := TPanel.Create(AForm);
    with oPES do begin
        Name        := 'PES';
        Parent      := oPEr;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alBottom;
        Height      := 50;
        Color       := clNone;
    end;

    //
    oBEK  := TButton.Create(AForm);
    with oBEK do begin
        Name        := 'BEK';
        Parent      := oPES;
        Align       := alRight;
        Width       := 80;
        Top         := 0;
        Left        := 0;
        Height      := 60;
        Font.Size   := 13;
        Caption     := '确定';
        Hint        := '{"type":"primary"}';
        //
        AlignWithMargins:= True;
        Margins.right   := 20;
        Margins.Bottom  := 19;
        //
        tM.Code         := @BEKClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //
    oBEA  := TButton.Create(AForm);
    with oBEA do begin
        Name        := 'BEA';
        Parent      := oPES;
        Align       := alRight;
        Top         := 0;
        Left        := 0;
        Width       := oBEK.Width;

        Height      := 60;
        Font.Size   := 13;
        Caption     := '取消';
        Hint        := '';
        //
        AlignWithMargins:= True;
        Margins.Right   := 10;
        Margins.Bottom  := 19;
        //
        tM.Code         := @BEAClick;
        tM.Data         := Pointer(325); // 随便取的数
        OnClick         := TNotifyEvent(tM);
    end;

    //批量新增 checkbox
    oCK_Batch   := TCheckBox.Create(AForm);
    with oCK_Batch do begin
        Name        := 'CKB';
        Parent      := oPEr;
        Align       := alBottom;
        Height      := 30;
        Caption     := '批量处理';
        AlignWithMargins:= True;
        Margins.Left    := 20;
    end;

    //主表编辑的ScrollBox
    oSB := TScrollBox.Create(AForm);
    with oSB do begin
        Name        := 'SB0';
        Parent      := oPEr;
        Align       := alClient;
    end;

    //主表ScrollBox的内容Panel
    oFC   := TFlowPanel.Create(AForm);
    with oFC do begin
        Name        := 'FC0';
        Parent      := oSB;
        BevelOuter  := bvNone;
        BorderStyle := bsNone;
        Align       := alTop;
        Color       := clWhite;
        Hint        := '{"dwstyle":"overflow:visible;"}';   //设置以显示Edit__tree下拉框
    end;

    //创建主表各字段的编辑框
    for iField := 0 to joConfig.fields._Count-1 do begin

        //取得主表字段的JSON对象
        joField := joConfig.fields._(iField);

        //不显示多选列字段
        if joField.type = 'check' then begin
            Continue;
        end;

        //创建控件
        iMode   := dwGetInt(joField,'view',0);  //显示模式，0：全部显示，1：仅新增/编辑时显示，2：全不显示
        case iMode of
            0,1 : begin
                qcCreateField(
                        AForm,
                        joConfig.editwidth,//(oPEr.Width div iEditColCnt)-20,   //width
                        '0'+IntToStr(iField),   //后缀名，用于区分多个控件
                        joConfig,
                        joField,    //字段的JSON对象
                        oFC  //父panel
                        );
            end;
        end;
    end;
    oFC.AutoSize := True;

    //创建各从表各字段的编辑框
    if joConfig.Exists('slave') then begin
        for iSlave := 0 to joConfig.slave._Count-1 do begin
            //取得从表JSON对象
            joSlave := joConfig.slave._(iSlave);
            //从表编辑的ScrollBox
            oSB := TScrollBox.Create(AForm);
            with oSB do begin
                Name        := 'SB'+IntToStr(iSlave+1);
                Parent      := oPEr;
                Align       := alClient;
            end;

            //从表ScrollBox的内容Panel
            oFC   := TFlowPanel.Create(AForm);
            with oFC do begin
                Name        := 'FC'+IntToStr(iSlave+1);
                Parent      := oSB;
                BevelOuter  := bvNone;
                BorderStyle := bsNone;
                Align       := alTop;
                Color       := clWhite;
            end;

            //从表字段
            for iField := 0 to joSlave.fields._Count-1 do begin
                //从表字段JSON对象
                joField := joSlave.fields._(iField);

                //不显示多选列字段
                if joField.type = 'check' then begin
                    Continue;
                end;

                //创建编辑控件
                iMode   := dwGetInt(joField,'view',0);  //显示模式，0：全部显示，1：仅新增/编辑时显示，2：全不显示
                case iMode of
                    0,1 : begin
                        qcCreateField(
                                AForm,
                                joConfig.editwidth,//(oPEr.Width div iEditColCnt)-20,   //width
                                IntToStr(iSlave+1)+IntToStr(iField),
                                joConfig,
                                joField,    //字段JSON对象
                                oFC  //父PANEL
                                );
                    end;
                end;
            end;
            oFC.AutoSize := True;
        end;
    end;

end;


//quickcrud布局函数
function qcLayout(AForm:TForm):Integer;
var
    joConfig    : Variant;
    joTemp      : Variant;
    //
    oBHd        : TButton;
    oBNw        : TButton;
    oBDe        : TButton;
    oBEt        : TButton;
    oBQm        : TButton;
    oBFz        : TButton;
    //
    oBSN        : TButton;
    oBSD        : TButton;
    oBSE        : TButton;
    oBSQ        : TButton;
    //
    oFQy        : TFlowPanel;
    oPQC        : TPanel;
    oPMn        : TPanel;
    oPQm        : TPanel;
    oPMd        : TPanel;
    oPSv        : TPanel;
    oTB         : TTrackBar;
    //
    iSlave      : Integer;
    //
    sLayout     : String;   //总布局结构：main/vert/horz : 仅主表/上下结构/左右结构
begin
    Result  := 0;

    //取配置JSON : 读AForm的 qcConfig 变量值
    joConfig    := qcGetConfigJson(AForm);

    //如果不是JSON格式，则退出
    if joConfig = unassigned then begin
        Exit;
    end;

    //取得各控件
    oBHd            := TButton(AForm.FindComponent('BHd'));
    oBNw            := TButton(AForm.FindComponent('BNw'));
    oBDe            := TButton(AForm.FindComponent('BDe'));
    oBEt            := TButton(AForm.FindComponent('BEt'));
    oBFz            := TButton(AForm.FindComponent('BFz'));
    oBQm            := TButton(AForm.FindComponent('BQm'));
    oBSN            := TButton(AForm.FindComponent('BSN'));
    oBSD            := TButton(AForm.FindComponent('BSD'));
    oBSE            := TButton(AForm.FindComponent('BSE'));
    oBSQ            := TButton(AForm.FindComponent('BSQ'));
    oFQy            := TFlowPanel(AForm.FindComponent('FQy'));
    oPMn            := TPanel(AForm.FindComponent('PMn'));      //主表Panel
    oPMd            := TPanel(AForm.FindComponent('PMd'));
    oPQC            := TPanel(AForm.FindComponent('PQC'));      //总Panel
    oPQm            := TPanel(AForm.FindComponent('PQm'));
    oPSv            := TPanel(AForm.FindComponent('PSv'));      //从表Panel

    //是否显示按钮标题
    case joConfig.buttoncaption of
        0 : begin   //不显示按钮caption
            oBNw.Caption    := '';
            oBNw.Cancel     := True;
            oBNw.Width      := oBNw.Height;
            oBDe.Caption    := '';
            oBDe.Cancel     := True;
            oBDe.Width      := oBNw.Width;
            oBEt.Caption    := '';
            oBEt.Cancel     := True;
            oBEt.Width      := oBNw.Width;
            oBFz.Caption    := '';
            oBFz.Cancel     := True;
            oBFz.Width      := oBNw.Width;
            oBQm.Caption    := '';
            oBQm.Cancel     := True;
            oBQm.Width      := oBNw.Width;
            oBHd.Caption    := '';
            oBHd.Cancel     := True;
            oBHd.Width      := oBNw.Width;
            //
            if oBSN <> nil then begin
                oBSN.Caption    := '';
                oBSN.Cancel     := True;
                oBSN.Width      := oBNw.Width;
                oBSD.Caption    := '';
                oBSD.Cancel     := True;
                oBSD.Width      := oBNw.Width;
                oBSE.Caption    := '';
                oBSE.Cancel     := True;
                oBSE.Width      := oBNw.Width;
                oBSQ.Caption    := '';
                oBSQ.Cancel     := True;
                oBSQ.Width      := oBNw.Width;
            end;
        end;
        2 : begin   //只显示部分按钮 caption
            oBHd.Caption         := '';
            oBHd.Cancel          := True;
            oBHd.Width           := oBHd.Height;
            //
            oBFz.Caption        := '';
            oBFz.Cancel         := True;
            oBFz.Width          := oBHd.Height;
            //
            oBQm.Caption    := '';
            oBQm.Cancel     := True;
            oBQm.Width      := oBHd.Height;
        end;
    end;

    //先确定上下结构？ 还是左右结构？
    sLayout   := 'vert';
    if joConfig.Exists('mainwidth') then begin
        if joConfig.Exists('slave') then begin
            if joConfig.slave._Count > 0 then begin
                sLayout := 'horz';
            end else begin
                sLayout := 'main';
            end;
        end else begin
            sLayout := 'main';
        end;
    end else begin
        if joConfig.Exists('slave') then begin
            if joConfig.slave._Count > 0 then begin
                sLayout := 'vert';
            end else begin
                sLayout := 'main';
            end;
        end else begin
            sLayout := 'main';
        end;
    end;

    //把总布局样式保存在PQC的Hint中
    joTemp  := _json(oPQC.Hint);
    if joTemp = unassigned then begin
        joTemp  := _json('{}');
    end;
    joTemp.layout       := sLayout;
    oPQC.Hint   := joTemp;


    //根据总布局样式进行总布局
    if sLayout = 'main' then begin  //==========================================
        oBHd.Visible    := False;       //仅主表时无需隐藏/显示
        oPMd.Align      := alClient;
        oPMn.Align      := alClient;
    end;

    if sLayout = 'horz' then begin  //==========================================
        if joConfig.mainwidth > 0 then begin
            oPMn.Align      := alLeft;
            oPMn.AutoSize   := False;
            oPMn.Width      := joConfig.mainwidth;
            oPMd.Align      := alClient;
            //
            oPSv.Align      := alClient;
        end else begin
            oPMn.Align      := alClient;
            oPMn.AutoSize   := False;
            oPMd.Align      := alClient;
            //
            oPSv.Align      := alRight;
            oPSv.Width      := abs(Integer(joConfig.mainwidth));
        end;
    end;

    if sLayout = 'vert' then begin  //==========================================
        //先全部autosize, 看是否放得下
        oPMn.Align      := alTop;
        oPMn.AutoSize   := True;
        oPSv.Align      := alTop;
        oPSv.Top        := 9999;
        oPSv.AutoSize   := True;

        //如果放得下
        if oPMn.Height + oPSv.Height < oPQC.Height then begin
            oPSv.Align      := alClient;
        end;
    end;

    //更新从表的分页
    if joConfig.Exists('slave') then begin
        if ( oPSv <> nil ) then begin
            if ( oPSv.Width <= 300 ) then begin
                if joConfig.slave._Count > 0 then begin
                    for iSlave := 0 to joConfig.slave._Count - 1 do begin
                        oTB         := TTrackBar(AForm.FindComponent('TB'+IntToStr(iSlave)));
                        //此处pager-count至少5，奇数，否则报错
                        oTB.Hint    := '{"dwattr":"background layout=''prev, next, ->, total''"}';
                    end;
                end;
            end else if ( oPSv.Width <= 400 ) then begin
                if joConfig.slave._Count > 0 then begin
                    for iSlave := 0 to joConfig.slave._Count - 1 do begin
                        oTB         := TTrackBar(AForm.FindComponent('TB'+IntToStr(iSlave)));
                        //此处pager-count至少5，奇数，否则报错
                        oTB.Hint    := '{"dwattr":":pager-count=\"5\" background layout=''prev, pager, next, ->, total''"}';
                    end;
                end;


            end;
        end;
    end;

    //如果禁止查询
    if joConfig.query = 0 then begin
        if oFQy <> nil then begin
            oFQy.Visible       := False;
        end;
        oPQm.Visible   := False;
        oBQm.Visible    := False;
        oBFz.Visible        := False;
    end;

end;

function dwCrud(AForm:TForm;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwGetEditMask  = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
    TdwEndDock      = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    joConfig    : variant;
    //
    sFields     : String;
    //
    oPDL        : TPanel;       //panel download  用于下载的控件
    //
    oPQC        : TPanel;
    oPMn        : TPanel;
    oPSv        : TPanel;
    oPQy        : TPanel;       //分字段查询面板 : PQy
    oFQy        : TFlowPanel;   //用于多字段查询的流式布局面板
    oPQF        : TPanel;       //单独字段查询面板 : PQ0, PQ1,...
    oPQm        : TPanel;       //智能模糊查询面板 : PQm
    oPMd        : TPanel;
    oPBs        : TPanel;       //功能按钮面板 : PBs
    oBQm        : TButton;      //切换查询模式的按钮 ： BQm
    oBFz        : TButton;      //切换查询模式的按钮 ： BFz 模糊/精确
    oBQy        : TButton;      //查询按钮
    oBQR        : TButton;      //重置按钮
    //
    oBNw        : TButton;      //主表新增
    oBEt        : TButton;      //主表编辑
    oBDe        : TButton;      //主表删除
    oBHd        : TButton;      //主表隐藏
    oBEx        : TButton;      //导出到Excel按钮
    //
    oEKw        : TEdit;
    oPCS        : TPageControl;
    oPTM        : TPanel;       //TMa外部加一个面板，以放置 每页行数 框
    oTMa        : TTrackBar;
    oCB_PageSize: TComboBox;    //每页显示数量

    //从表增删改查
    oPSB        : TPanel;
    oBSN        : TButton;
    oBSD        : TButton;
    oBSE        : TButton;
    oBSQ        : TButton;

    //
    oFQ_Main    : TFDQuery;
    //
    oPEr        : TPanel;
    oPES        : TPanel;
    oB_Cancel   : TButton;
    oB_OK       : TButton;
    oSBDemo     : TScrollBox;
    oP_Content  : TPanel;
    //
    oP_string   : TPanel;
    oL_String   : TLabel;
    oE_String   : TEdit;
    //
    oP_combo    : TPanel;
    oL_Combo    : TLabel;
    oCB_Combo   : TComboBox;
    //
    oP_Integer  : TPanel;
    oL_Integer  : TLabel;
    oSE_Integer : TSpinEdit;
    //
    oP_Date     : TPanel;
    oL_Date     : TLabel;
    oDT_Date    : TDateTimePicker;
    //
    oP_Boolean  : TPanel;
    oL_Boolean  : TLabel;
    oTS_Boolean : TToggleSwitch;
    //
    oP_Group    : TPanel;
    oL_Group    : TLabel;
    //
    oPET        : TPanel;
    oL_ETitle   : TLabel;
    //
    oGMn        : TStringGrid;  //主表
    //
    tM          : TMethod;      //用于指定事件
    //
    joField     : variant;
    joHint      : variant;
    joCell      : variant;
    joSlave     : variant;
    joItems     : Variant;      //用于生成combo的items
    //
    iSlave      : Integer;
    iField      : Integer;
    iCount      : Integer;
    iTop        : Integer;
    iCol        : Integer;
    iLeft       : Integer;
    iItem       : Integer;
    iDec        : Integer;
    iMode       : Byte;         //字段的模式，0：正常（默认），1：表格中不显示，新增/编辑时显示；2：仅FDQuery读取， 表格/新增/编辑均不显示
    //
    oTab        : TTabSheet;
    oFDQuery    : TFDQuery;
    oTB         : TTrackBar;
    oSG         : TStringGrid;
    oSB         : TScrollBox;
    oP          : TPanel;
    oQueryTmp   : TFDQuery;     //用于生成combo的临时性FDQuery
    //
    oL_Query    : TLabel;   //查询用标签
    oE_Query    : TEdit;    //查询用Edit
    oCBQy       : TComboBox;//查询
    oP_DateSE   : TPanel;               //存放起始结束日期框
    oDT_Start   : TDateTimePicker;      //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;      //结束日期，DateTimePicker_End
    oL_Space    : TLabel;   //起止日期间 分隔符
    //
    oPanel      : TPanel;
    oEdit       : TEdit;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oDTPicker   : TDateTimePicker;
    oSwitch     : TToggleSwitch;

    procedure _SetCaption(ALabel:TLabel);
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

    try
        //先检查PQC是否存在，防止重复创建
        if AForm.FindComponent('PQC') <> nil then begin
            Result  := -200;
            dwMessage('Error when quickcrud : '+IntToStr(Result),'error',AForm);
            Exit;
        end;

        //取配置JSON : 读AForm的 qcConfig 变量值
        joConfig    := qcGetConfigJson(AForm);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Result  := -201;
            dwMessage('Error when quickcrud : '+IntToStr(Result),'error',AForm);
            Exit;
        end;

        //为窗体赋OnEndDock事件，以解决上传图片问题
        with AForm do begin
            //
            tM.Code         := @FormEndDock;
            tM.Data         := Pointer(325); // 随便取的数
            OnEndDock       := TdwEndDock(tM);
        end;

        //得到字段名列表
        sFields := _GetFields(joConfig.fields,False);

        //打开表
        oQueryTmp       := TFDQuery(AForm.FindComponent('FDQueryTmp'));

        //生成一个临时查询
        if oQueryTmp = nil then begin
            oQueryTmp               := TFDQuery.Create(AForm);
            oQueryTmp.Name          := 'FDQueryTmp';
            oQueryTmp.Connection    := AConnection;
        end;

        oQueryTmp.Close;
        oQueryTmp.SQL.Text  := 'SELECT ' + sFields + ' FROM ' + joConfig.table + ' WHERE 1=0'; // 打开一个空查询
        oQueryTmp.Open;

        //设置每个字段的DataType
        iDec    := 0;
        for iField := 0 to joConfig.fields._Count - 1 do begin
            joField := joConfig.fields._(iField);
            if joField.type = 'check' then begin
                iDec    := -1;
                Continue;
            end;

            //
            joField.datatype := oQueryTmp.Fields[iField+iDec].DataType;
        end;

        //反写回Form1.qcConfig变量
        qcSetConfig(AForm,joConfig);

        //几个主要面板：主面板，主表面板和从表面板  ====================================================
        //总面板
        oPQC    := TPanel.Create(AForm);
        with oPQC do begin
            Parent          := AForm;
            Name            := 'PQC';
            BevelOuter      := bvNone;
            Align           := alClient;
            Color           := clNone;
            Hint            := '{"dwstyle":"overflow-y:auto;"}'
        end;
        //主表面板
        oPMn    := TPanel.Create(AForm);
        with oPMn do begin
            Parent          := oPQC;
            Name            := 'PMn';
            BevelOuter      := bvNone;
            Color           := clNone;
            //根据是否有 mainwidth 判断是水平排列还是垂直排列
            if joConfig.Exists('mainwidth') then begin
                Align       := alLeft;
                Width       := joConfig.mainwidth;
            end else begin
                if joConfig.Exists('slave') then begin
                    Align       := alTop;
                    AutoSize    := True;
                end else begin
                    Align       := alClient;
                end;
            end;
        end;
        //从表面板
        if joConfig.Exists('slave') then begin
            oPSv := TPanel.Create(AForm);
            with oPSv do begin
                Parent          := oPQC;
                Name            := 'PSv';
                BevelOuter      := bvNone;
                Color           := clNone;
                Align           := alTop;
                Top             := 9999;
                Height          := 40 + joConfig.rowheight * (joConfig.slavepagesize+1);
                HelpContext     := Height;
            end;
        end;

        //分字段查询面板 FQy ======================================================================
        oFQy   := TFlowPanel.Create(AForm);
        with oFQy do begin
            Parent          := oPMn;
            Name            := 'FQy';
            Align           := alTop;
            Color           := clWhite;
            AutoSize        := True;
            AutoWrap        := True;
            //BorderStyle     := bsSingle;
            Top             := 1000;
            Font.Size       := 11;
            Font.Color      := $646464;
            //
            AlignWithMargins:= True;
            Margins.Top     := joConfig.margin;
            Margins.Bottom  := 0;
            Margins.Left    := joConfig.margin;
            Margins.Right   := joConfig.margin;
            if joConfig.margin > 0 then begin
                Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px","dwstyle":"border:solid 1px #DCDFE6;"}';
            end else begin
                Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
            end;
            //
            tM.Code         := @FQyResize;
            tM.Data         := Pointer(325); // 随便取的数
            OnResize        := TNotifyEvent(tM);
        end;
        //创建分字段查询的查询列表
        iCount  := 0;
        for iField := 0 to joConfig.fields._Count-1 do begin
            //取得当前字段JSON对象
            joField := joConfig.fields._(iField);
            //如果字段加入分字段查询
            if joField.query = 1 then begin
                //
                qcCreateFieldQuery(AForm,joField,iField,IntToStr(iCount),oFQy);
                Inc(iCount);
            end;
        end;
        //创建一个额外的单字段查询面板，用于存放“查询”和“重置”按钮
        oPQF := TPanel.Create(AForm);
        with oPQF do begin
            Parent          := oFQy;
            Name            := 'PQ'+IntToStr(iCount);
            Color           := clNone;
            Width           := 175;
            Height          := 40;
            Tag             := -1;
        end;
        //添加“查询”和“重置”按钮
        oBQy  := TButton.Create(AForm);
        with oBQy do begin
            Parent          := oPQF;
            Name            := 'BQy';
            Align           := alLeft;
            width           := 70;
            Height          := 30;
            Caption         := '查询';
            Hint            := '{"type":"primary","icon":"el-icon-search"}';
            //
            AlignWithMargins    := True;
            Margins.Top         := 6;
            Margins.Bottom      := 8;
            Margins.Left        := 8;
            Margins.Right       := 5;
            //
            tM.Code         := @BQyClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        oBQR  := TButton.Create(AForm);
        with oBQR do begin
            Parent          := oPQF;
            Name            := 'BQR';
            Align           := alLeft;
            width           := 70;
            Height          := 30;
            Left            := 100;
            Caption         := '重置';
            Hint            := '{"icon":"el-icon-refresh"}';
            //
            AlignWithMargins    := True;
            Margins         := oBQy.Margins;
            //
            tM.Code         := @B_ResetClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        //刷新 FQy 高度
        oFQy.AutoSize  := True;
        oFQy.AutoSize  := False;
        //如果未定义多字段查询，则销毁FQy
        if iCount = 0 then begin
            oFQy.Destroy;
        end;

        //智能查询面板 PQm ====================================================================
        oPQm := TPanel.Create(AForm);
        with oPQm do begin
            Parent          := oPMn;
            Name            := 'PQm';
            Align           := alTop;
            //BorderStyle     := bsSingle;
            Height          := 50;
            Top             := 1100;
            Color           := clWhite;
            AlignWithMargins:= True;
            Margins.Top     := joConfig.margin;
            Margins.Bottom  := 0;
            Margins.Left    := joConfig.margin;
            Margins.Right   := joConfig.margin;
            if joConfig.margin > 0 then begin
                Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px","dwstyle":"border:solid 1px #DCDFE6;"}';
            end else begin
                Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
            end;
            //
            Visible         := iCount = 0;
        end;
        //智能查询EKw
        oEKw  := TEdit.Create(AForm);
        with oEKw do begin
            Parent          := oPQm;
            Name            := 'EKw';
            Align           := alLeft;
            width           := 218;     //用于和3个按钮对齐
            Text            := '';
            //
            AlignWithMargins:= True;
            Margins.Bottom  := 10;
            Margins.Left    := 12;
            Margins.Right   := 10;
            Margins.Top     := 6;
            Hint            := '{"placeholder":"请输入查询关键字","suffix-icon":"el-icon-search","dwstyle":"padding-left:10px;"}';
            //
            tM.Code         := @EKwChange;
            tM.Data         := Pointer(325); // 随便取的数
            OnChange        := TNotifyEvent(tM);
        end;
        oPMd  := TPanel.Create(AForm);
        with oPMd do begin
            Parent          := oPMn;
            Name            := 'PMd';
            Font.Size       := 11;
            //BorderStyle     := bsSingle;
            //
            Align           := alTop;
            Top             := 2000;
            Height          := 45 + joConfig.rowheight * ( 1 + joConfig.pagesize )+1 + 45;  //高度
            //
            Color           := clWhite;
            AlignWithMargins:= True;
            Margins.Top     := joConfig.margin;
            Margins.Bottom  := joConfig.margin;
            Margins.Left    := joConfig.margin;
            Margins.Right   := joConfig.margin;
            if joConfig.margin > 0 then begin
                Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px","dwstyle":"border:solid 1px #DCDFE6;"}';
            end else begin
                Hint            := '{"radius":"'+IntToStr(joConfig.radius)+'px"}';
            end;
        end;
        //功能按钮面板 ： PBs ====================================================================
        oPBs  := TPanel.Create(AForm);
        with oPBs do begin
            Parent          := oPMd;
            Name            := 'PBs';
            Align           := alTop;
            Height          := 45;
            Top             := 0;
            Font.Size       := 11;
            //
            Color           := clWhite;
            AlignWithMargins:= False;
            Margins.Top     := 10;
            Margins.Bottom  := 0;
            Margins.Left    := 10;
            Margins.Right   := 10;
        end;
        //主表导出Excel
        oBEx  := TButton.Create(AForm);
        with oBEx do begin
            Parent          := oPBs;
            Name            := 'BEx';
            Align           := alLeft;
            width           := 70;
            Caption         := '导出';
            //
            AlignWithMargins:= True;
            Margins.Top     := 8;
            Margins.Bottom  := 7;
            Margins.Left    := 10;
            Margins.Right   := 0;
            Hint            := '{"type":"success","style":"plain","icon":"el-icon-top-right"}';
            //
            tM.Code         := @BExClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        //主表删除
        oBDe  := TButton.Create(AForm);
        with oBDe do begin
            Parent          := oPBs;
            Name            := 'BDe';
            Align           := alLeft;
            width           := 70;
            Caption         := '删除';
            //
            AlignWithMargins:= True;
            Margins.Top     := 8;
            Margins.Bottom  := 7;
            Margins.Left    := 10;
            Margins.Right   := 0;
            Hint            := '{"type":"danger","style":"plain","icon":"el-icon-delete"}';
            //
            tM.Code         := @BDeClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        //主表新增
        oBNw  := TButton.Create(AForm);
        with oBNw do begin
            Parent          := oPBs;
            Name            := 'BNw';
            Align           := alLeft;
            width           := 70;
            Caption         := '新增';
            //
            AlignWithMargins:= True;
            Margins         := oBDe.Margins;
            Hint            := '{"type":"success","style":"plain","icon":"el-icon-circle-plus-outline"}';
            //
            tM.Code         := @BNwClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end ;
        //主表编辑
        oBEt  := TButton.Create(AForm);
        with oBEt do begin
            Parent          := oPBs;
            Name            := 'BEt';
            Align           := alLeft;
            width           := 70;
            Caption         := '编辑';
            //
            AlignWithMargins:= True;
            Margins         := oBDe.Margins;
            Hint            := '{"type":"primary","style":"plain","icon":"el-icon-edit-outline"}';
            //
            tM.Code         := @BEtClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        //查询模式：智能模糊 / 多字段
        oBQm  := TButton.Create(AForm);
        with oBQm do begin
            Parent          := oPBs;
            Name            := 'BQm';
            Anchors         := [akRight,akTop];
            width           := 70;
            Caption         := '模式';
            Font.Size       := 11;
            Font.Color      := $A0A0A0;
            //Caption         := '';
            //Cancel          := True;
            Hint            := '{"style":"plain","type":"info","icon":"el-icon-sort"}';
            Align           := alRight;
            Visible         := joConfig.switch = 1;
            //
            AlignWithMargins:= True;
            Margins.Top     := 8;
            Margins.Bottom  := 7;
            Margins.Left    := 0;
            Margins.Right   := 10;
            //
            tM.Code         := @BQmClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        //模糊 / 精确
        oBFz  := TButton.Create(AForm);
        with oBFz do begin
            Parent          := oPBs;
            Name            := 'BFz';
            Anchors         := [akRight,akTop];
            width           := 70;
            Caption         := '模糊';
            Font.Size       := 11;
            Font.Color      := $A0A0A0;
            //Caption         := '';
            //Cancel          := True;
            Hint            := '{"style":"plain","type":"info","icon":"el-icon-open"}';
            Align           := alRight;
            //
            AlignWithMargins:= True;
            Margins.Top     := 8;
            Margins.Bottom  := 7;
            Margins.Left    := 0;
            Margins.Right   := 10;
            //
            tM.Code         := @BFzClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
            //
            Visible         := iCount > 0;
        end;
        //隐藏
        oBHd  := TButton.Create(AForm);
        with oBHd do begin
            Parent          := oPBs;
            Name            := 'BHd';
            Align           := alRight;
            width           := 70;
            Caption         := '隐藏';
            Font.Size       := 11;
            Font.Color      := $A0A0A0;
            //
            AlignWithMargins:= True;
            Margins.Top     := 8;
            Margins.Bottom  := 7;
            Margins.Left    := 3;
            Margins.Right   := 3;
            Hint            := '{"type":"info","style":"plain","icon":"el-icon-view"}';
            //
            tM.Code         := @BHdClick;
            tM.Data         := Pointer(325); // 随便取的数
            OnClick         := TNotifyEvent(tM);
        end;
        //设置显示默认查询模式 defaultquerymode
        if joConfig.Exists('defaultquerymode') then begin
            oBQm.Tag  := joConfig.defaultquerymode + 1;
        end else begin
            if iCount > 0 then begin
                oBQm.Tag  := 0;   //-1=2, 即多字段模式
            end else begin
                oBQm.Tag  := 2;   //-1=1，即智能模糊模式
            end;
        end;
        oBQm.OnClick(oBQm);
    except
        //异常时调试使用
        Result  := -1;
    end;

    if Result = 0 then begin
        try

            //主表表格 =====================================================================================
            oGMn  := TStringGrid.Create(AForm);
            with oGMn do begin
                Parent  := oPMd;
                Name    := 'GMn';
                Top     := 3000;


                //是否竖线
                if joConfig.border = 1 then begin
                    if joConfig.Exists('headerbackground') then begin
                        Hint        := '{"dwattr":"stripe border","dwstyle":"border-radius:0;","headerbackground":"'+joConfig.headerbackground+'"}';
                    end else begin
                        Hint        := '{"dwattr":"stripe border","dwstyle":"border-radius:0;"}';
                    end;
                end else begin
                    if joConfig.Exists('headerbackground') then begin
                        Hint        := '{"dwattr":"stripe","dwstyle":"border-radius:0;","headerbackground":"'+joConfig.headerbackground+'"}';
                    end else begin
                        Hint        := '{"dwattr":"stripe","dwstyle":"border-radius:0;"}';
                    end;
                end;

                //默认排序
                if joConfig.Exists('defaultorder') then begin
                    StyleName   := '{"sort":"'+joConfig.defaultorder+'"}';
                end;

                //
                HelpKeyword     := 'multi';
                Color           := clWhite;
                AlignWithMargins:= False;
                Margins.Top     := 0;
                Margins.Bottom  := 0;
                Margins.Left    := 3;
                Margins.Right   := 2;
                //
                Align           := alTop;
                Height          := joConfig.rowheight * ( 1 + joConfig.pagesize )+1;  //高度
                HelpContext     := Height;  //将当前高度保存在helpcontext中
                //
                RowCount        := joConfig.pagesize + 1;  //行数
                DefaultRowHeight:= joConfig.rowheight;     //行高
                ColCount        := _GetViewFieldCount(joConfig.fields); //列数
                FixedCols       := 0;                       //固定列数
                //
                Font.Color      := $00969696;
                //
                AlignWithMargins:= True;
                //
                tM.Code         := @GMnClick;
                tM.Data         := Pointer(325); // 随便取的数
                OnClick         := TNotifyEvent(tM);

                //
                tM.Code         := @GMnGetEditMask;
                tM.Data         := Pointer(325); // 随便取的数
                OnGetEditMask   := TdwGetEditMask(tM);
            end;

            //主表分页(外框) ===============================================================================
            oPTM    := TPanel.Create(AForm);
            with oPTM do begin
                Parent          := oPMd;
                Name            := 'PTM';
                Color           := clWhite;
                //
                Align           := alBottom;
                Height          := 40;  //高度
                //
                AlignWithMargins:= False;
                Margins.Top     := 0;
                Margins.Bottom  := 10;
                Margins.Left    := 10;
                Margins.Right   := 10;
            end;
            //主表分页
            oTMa    := TTrackBar.Create(AForm);
            with oTMa do begin
                Parent          := oPTM;
                Name            := 'TMa';
                Align           := alClient;
                HelpKeyword     := 'page';
                Max             := 0;
                PageSize        := 10;

                //if Width >= 480 then begin
                //    Hint        := '{"dwattr":"background"}';
                //end else begin
                //    Hint        := '{"dwattr":"background layout=\"prev, pager, next, ->, total\""}';
                //end;
                //Hint        := '{"dwattr":"background :pager-count=\"3\" layout=\"total, ->, prev, pager, next\""}';

                //2025-03-19 (1) 增加了totalfirst设置支持 (2)采用了小图标, 以支持移动端
                if dwGetInt(joConfig,'totalfirst',0)=1 then begin
                    Hint            := '{"dwattr":"small :pager-count=5 background layout=\"total, ->, prev, pager, next\""}';
                end else begin
                    Hint            := '{"dwattr":"small :pager-count=5 background layout=\"prev, pager, next, ->, total\""}';
                end;

                //
                AlignWithMargins:= True;
                //
                tM.Code         := @TMaChange;
                tM.Data         := Pointer(325); // 随便取的数
                OnChange        := TNotifyEvent(tM);
            end;
            //每页行数
            if joConfig.Exists('pagesizelist') then begin
                oCB_PageSize    := TComboBox.Create(AForm);
                with oCB_PageSize do begin
                    Parent      := oPTM;
                    Name        := 'CB_PageSize';
                    Anchors     := [akRight,akTop];
                    width       := 70;
                    Top         := 5;
                    Style       := csDropDownList;
                    Left        := oPTM.Width - 20 - 100 - 70;

                    //添加每页行数的选项
                    for iItem := 0 to joConfig.pagesizelist._Count-1 do begin
                        Items.Add(IntToStr(joConfig.pagesizelist._(iItem)));
                    end;
                    //
                    ItemIndex   := Items.IndexOf(IntToStr(joConfig.pagesize));
                    //
                    tM.Code     := @CB_PageSizeChange;
                    tM.Data     := Pointer(325); // 随便取的数
                    OnChange    := TNotifyEvent(tM);
                end;
            end;
        except
            //异常时调试使用
            Result  := -2;
        end;
    end;

    if Result = 0 then begin
        try

            //从表PageControl ==============================================================================
            if joConfig.Exists('slave') then begin
                oPCS  := TPageControl.Create(AForm);    //PCS : PageControl Slave
                with oPCS do begin
                    Parent          := oPSv;
                    Name            := 'PCS';
                    Align           := alClient;
                    Hint            := '{"dwstyle":"border-top:solid 1px #dcdfe6;border-radius:'+IntToStr(joConfig.radius)+'px;overflow:hidden;"}';
                    //
                    AlignWithMargins:= True;
                    Margins.Right   := 10;
                    Margins.Bottom  := 12;
                    //根据是否水平排列
                    if joConfig.Exists('mainwidth') then begin
                        Margins.Top     := 10;
                        Margins.Left    := 1;
                    end else begin
                        Margins.Left    := 10;
                        Margins.Top     := 0;
                    end;
                    //
                    tM.Code         := @PCSChange;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnChange        := TNotifyEvent(tM);
                end;

                //创建从表的增删改打按钮------------------------------------------------------------------------
                //panel容器
                oPSB := TPanel.Create(AForm);       //PSB - Panel Slave Button
                with oPSB do begin
                    Parent          := oPSv;
                    Name            := 'PSB';
                    Anchors         := [akTop,akRight];
                    Font.Size       := 11;
                    Color           := clNone;
                    Width           := 560;
                    Left            := oPSv.Width - Width - 15;
                    Top             := oPCS.Top + 1;
                    Height          := 38;
                end;
                //
                oBSQ  := TButton.Create(AForm);     //BSQ - Button slave query
                with oBSQ do begin
                    Parent          := oPSB;
                    Name            := 'BSQ';
                    Align           := alRight;
                    width           := 70;
                    Caption         := '查询';
                    //
                    AlignWithMargins:= True;
                    Margins.Top     := 6;
                    Margins.Bottom  := 4;
                    Hint            := '{"type":"info","style":"plain","icon":"el-icon-search"}';
                    Visible         := False;
                    //
                    tM.Code         := @BSQClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                end;
                //
                oBSD  := TButton.Create(AForm);     //BSD - Button Slave Delete
                with oBSD do begin
                    Parent          := oPSB;
                    Name            := 'BSD';
                    Align           := alRight;
                    width           := 70;
                    Caption         := '删除';
                    Visible         := False;
                    //
                    AlignWithMargins:= True;
                    Margins.Top     := 6;
                    Margins.Bottom  := 4;
                    Hint            := '{"type":"danger","style":"plain","icon":"el-icon-delete"}';
                    //
                    tM.Code         := @BSDClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                end;
                //
                oBSN  := TButton.Create(AForm);     //BSN - Button Slave New
                with oBSN do begin
                    Parent          := oPSB;
                    Name            := 'BSN';
                    Align           := alRight;
                    width           := 70;
                    Caption         := '新增';
                    Visible         := False;
                    //
                    AlignWithMargins:= True;
                    Margins.Top     := 6;
                    Margins.Bottom  := 4;
                    Hint            := '{"type":"success","style":"plain","icon":"el-icon-circle-plus-outline"}';
                    //
                    tM.Code         := @BSNClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                end ;
                //
                oBSE  := TButton.Create(AForm);     //BSE - Button Slave Edit
                with oBSE do begin
                    Parent          := oPSB;
                    Name            := 'BSE';
                    Align           := alRight;
                    width           := 70;
                    Caption         := '编辑';
                    Visible         := False;
                    //
                    AlignWithMargins:= True;
                    Margins.Top     := 6;
                    Margins.Bottom  := 4;
                    Hint            := '{"type":"primary","style":"plain","icon":"el-icon-edit-outline"}';
                    //
                    tM.Code         := @BSEClick;
                    tM.Data         := Pointer(325); // 随便取的数
                    OnClick         := TNotifyEvent(tM);
                end;
            end;
        except

            //异常时调试使用
            Result  := -3;
        end;
    end;

    if Result = 0 then begin
        try

            //----------------------------------------------------------------------------------------------
            //配置 oFQ_Main 的连接
            oFQ_Main            := TFDQuery.Create(AForm);
            oFQ_Main.Name       := 'FQ_Main';
            oFQ_Main.Connection := AConnection;

            //显示/隐藏 增删改印按钮
            oBNw.Visible    := joConfig.new = 1;
            oBEt.Visible    := joConfig.edit = 1;
            oBDe.Visible    := joConfig.delete = 1;
            oBEx.Visible    := joConfig.export = 1;
            oBHd.Visible    := joConfig.hide = 1;
            oPBs.Visible    := joConfig.buttons = 1;

            //<得到Hint的JSON对象（以更新rowheight、dataset）
            joHint  := _json(oGMn.Hint);
            if joHint = unassigned then begin
                joHint  := _json('{}');
            end;
            //行高
            joHint.rowheight    := joConfig.rowheight;
            joHint.headerheight := joConfig.rowheight;
            //
            joHint.dataset      := 'FQ_Main';
            //返写到Hint中
            oGMn.Hint := joHint;
            //>
            //<-----根据配置信息更新GMn
            oGMn.Height          := joConfig.rowheight * ( 1 + joConfig.pagesize )+1;  //高度
            oGMn.RowCount        := joConfig.pagesize + 1;  //行数
            oGMn.DefaultRowHeight:= joConfig.rowheight;     //行高
            oGMn.ColCount        := _GetViewFieldCount(joConfig.fields); //列数
            oGMn.FixedCols       := 0;                       //固定列数
            //配置各列参数
            iCol    := 0;
            for iField := 0 to joConfig.fields._count - 1 do begin
                //得到字段对象
                joField := joConfig.fields._(iField);

                //字段显示模式，0；全显，1：仅新增/编辑显，2：全不显
                iMode   := dwGetInt(joField,'view',0);
                case iMode of
                    0 : begin
                        //生成各列参数配置的JSON字符串
                        joCell              := _json('{}');         //列参数写在每列的第一行中，JSON格式
                        joCell.name         := joField.name;        //保存字段名称，备用，可用于排序
                        joCell.caption      := joField.caption;     //显示标题
                        joCell.sort         := dwGetInt(joField,'sort',0);    //是否显示排序按钮
                        joCell.align        := joField.align;       //对齐方式，left/center/right. 默认center
                        if joField.Exists('dwattr') then begin
                            joCell.dwattr   := dwGetStr(joField,'dwattr','');
                        end;
                        if joField.Exists('dwstyle') then begin
                            joCell.dwstyle  := dwGetStr(joField,'dwstyle','');
                        end;
                        if joField.Exists('format') then begin
                            joCell.format   := dwGetStr(joField,'format','');
                        end;
                        if joField.Exists('preview') then begin
                            joCell.preview  := dwGetStr(joField,'preview','');
                        end;

                        //增加选择框
                        if joField.type = 'check' then begin
                            joCell.type := 'check';
                        end else if joField.type = 'image' then begin
                            joCell.type := 'image';
                            joCell.imgdir   := dwGetStr(joField,'imgdir','');
                            if joField.Exists('imgwidth') then begin
                                joCell.imgwidth     := dwGetInt(joField,'imgwidth',40);
                            end;
                            if joField.Exists('imgheight') then begin
                                joCell.imgheight    := dwGetInt(joField,'imgheight',40);
                            end;
                        end else begin
                            joCell.type := 'label';
                        end;

                        //增加筛选项
                        if dwGetInt(joField,'filter',0) = 1 then begin
                            joCell.filter := _json(dwGetStr(joField,'filterlist','[]'));
                        end else if dwGetInt(joField,'dbfilter',0) = 1 then begin
                            //此处读数据库，得到筛选项
                            joCell.filter := _GetItems(oQueryTmp,joConfig.table,joField.name);
                        end;

                        //将列配置赋给StringGrid, 具体根据配置转化为相关显示表格在dwTStringGrid.dpr中实现
                        oGMn.Cells[iCol,0]  := joCell;

                        //列宽
                        oGMn.ColWidths[iCol]:= dwGetInt(joField,'width',100);
                        //
                        Inc(iCol);
                    end;
                end;
            end;
            //>

            //更新页码
            oTMa.Position    := 0;
        except

            //异常时调试使用
            Result  := -4;
        end;
    end;

    if Result = 0 then begin
        try

            //更新从表
            if not joConfig.Exists('slave') then begin
                //更新主表元素对齐方式
                oGMn.Align      := alClient;
                oPTM.Align      := alBottom;
            end else begin
                //先删除原有的TabSheet
                for iSlave := oPCS.PageCount-1 downto 0 do begin
                    oPCS.Pages[iSlave].Destroy;
                end;

                //创建从表 以及从表的Order
                for iSlave := 0 to joConfig.slave._Count-1 do begin
                    //取得从表JSON
                    joSlave := joConfig.slave._(iSlave);

                    //检查table项
                    if not joSlave.Exists('table') then begin
                        continue;
                    end;

                    //检查主配置JSON的slavepagesize
                    if not joConfig.Exists('slavepagesize') then begin
                        joConfig.slavepagesize := 5;
                    end;

                    //
                    if not joSlave.Exists('imageindex') then begin
                        joSlave.imageindex  := 138;
                    end;
                    if not joSlave.Exists('caption') then begin
                        joSlave.caption := String(joSlave.table);
                    end;
                    //检查补齐编辑、新增、删除、打印按钮的可用性
                    if not joSlave.Exists('edit') then begin
                        joSlave.edit    := 1;
                    end;
                    if not joSlave.Exists('new') then begin
                        joSlave.new    := 1;
                    end;
                    if not joSlave.Exists('delete') then begin
                        joSlave.delete    := 1;
                    end;
                    if not joSlave.Exists('query') then begin
                        joSlave.query    := 1;
                    end;

                    //创建TabSheet
                    oTab                := TTabSheet.Create(AForm);
                    with oTab do begin
                        Name            := 'TS'+IntToStr(iSlave);   // TS - TabSheet Slave
                        PageControl     := oPCS;
                        Caption         := joSlave.caption;
                        ImageIndex      := joSlave.imageindex;
                        ImageName       := ''; //从表的Order
                    end;
                    //创建FDQuery
                    oFDQuery            := TFDQuery.Create(AForm);
                    oFDQuery.Name       := 'FQ_'+IntToStr(iSlave);  //FQ - FDQuery
                    oFDQuery.Connection := AConnection;
                    //创建从表表格
                    oSG := TStringGrid.Create(AForm);
                    with oSG do begin
                        Parent          := oTab;
                        BorderStyle     := bsNone;
                        Name            := 'SG'+IntToStr(iSlave);
                        Align           := alClient;
                        HelpKeyword     := 'multi';
                        //
                        if joConfig.border = 1 then begin
                            if joConfig.Exists('headerbackground') then begin
                                Hint        := '{"dwattr":"stripe border","dwstyle":"border-radius:0;","headerbackground":"'+joConfig.headerbackground+'"}';
                            end else begin
                                Hint        := '{"dwattr":"stripe border","dwstyle":"border-radius:0;"}';
                            end;
                        end else begin
                            if joConfig.Exists('headerbackground') then begin
                                Hint        := '{"dwattr":"stripe","dwstyle":"border-radius:0;","headerbackground":"'+joConfig.headerbackground+'"}';
                            end else begin
                                Hint        := '{"dwattr":"stripe","dwstyle":"border-radius:0;"}';
                            end;
                        end;
                        //默认排序
                        if joSlave.Exists('defaultorder') then begin
                            StyleName   := '{"sort":"'+joSlave.defaultorder+'"}';
                        end;

                        Height          := joConfig.rowheight * ( 1 + joConfig.slavepagesize )+1;  //高度
                        RowCount        := joConfig.slavepagesize + 1;  //行数
                        DefaultRowHeight:= joConfig.rowheight;     //行高
                        ColCount        := _GetViewFieldCount(joSlave.fields); //列数
                        FixedCols       := 0;                       //固定列数
                        //
                        tM.Code         := @SGSlaveClick;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnClick         := TNotifyEvent(tM);
                        //
                        //
                        tM.Code         := @GMnGetEditMask;//SGSlaveGetEditMask;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnGetEditMask   := TdwGetEditMask(tM);
                    end;
                    //oSG.OnGetEditMask       := GMnGetEditMask;
                    //oSG.OnClick             := SGSlaveClick;
                    //配置各列参数
                    iCol    := -1;
                    for iField := 0 to joSlave.fields._count - 1 do begin
                        //得到字段对象
                        joField := joSlave.fields._(iField);

                        //处理显示属性view
                        if dwGetInt(joField,'view',0) = 0 then begin
                            Inc(iCol);
                        end else begin
                            Continue;
                        end;

                        //
                        if not joField.Exists('caption') then begin     //默认显示标题为name
                            joField.caption := String(joField.name);
                        end;
                        if not joField.Exists('type') then begin        //默认显示类型为string
                            joField.type    := 'string';
                        end;
                        if not joField.Exists('width') then begin       //默认显示宽度
                            joField.width   := 100;
                        end;
                        if not joField.Exists('sort') then begin        //默认不排序
                            joField.sort    := 0;
                        end;
                        if not joField.Exists('align') then begin       //默认居中显示
                            joField.align   := 'center';
                        end;


                        //生成各列参数配置的JSON字符串
                        //生成各列参数配置的JSON字符串
                        joCell              := _json('{}');         //列参数写在每列的第一行中，JSON格式
                        joCell.name         := joField.name;        //保存字段名称，备用，可用于排序
                        joCell.caption      := joField.caption;     //显示标题
                        joCell.sort         := dwGetInt(joField,'sort',0);    //是否显示排序按钮
                        joCell.align        := joField.align;       //对齐方式，left/center/right. 默认center
                        if joField.Exists('dwattr') then begin
                            joCell.dwattr   := dwGetStr(joField,'dwattr','');
                        end;
                        if joField.Exists('dwstyle') then begin
                            joCell.dwstyle  := dwGetStr(joField,'dwstyle','');
                        end;
                        if joField.Exists('format') then begin
                            joCell.format   := dwGetStr(joField,'format','');
                        end;
                        if joField.Exists('preview') then begin
                            joCell.preview  := dwGetStr(joField,'preview','');
                        end;

                        //增加选择框
                        if joField.type = 'check' then begin
                            joCell.type := 'check';
                        end else if joField.type = 'image' then begin
                            joCell.type := 'image';
                            joCell.imgdir   := dwGetStr(joField,'imgdir','');
                            if joField.Exists('imgwidth') then begin
                                joCell.imgwidth     := dwGetInt(joField,'imgwidth',40);
                            end;
                            if joField.Exists('imgheight') then begin
                                joCell.imgheight    := dwGetInt(joField,'imgheight',40);
                            end;
                        end else begin
                            joCell.type := 'label';
                        end;

                        //增加筛选项
                        if dwGetInt(joField,'filter',0) = 1 then begin
                            joCell.filter := _json(dwGetStr(joField,'filterlist','[]'));
                        end else if dwGetInt(joField,'dbfilter',0) = 1 then begin
                            //此处读数据库，得到筛选项
                            joCell.filter := _GetItems(oQueryTmp,joConfig.table,joField.name);
                        end;

                        //将列配置赋给StringGrid, 具体根据配置转化为相关显示表格在dwTStringGrid.dpr中实现
                        oSG.Cells[iCol,0]  := joCell;

                        //列宽
                        oSG.ColWidths[iCol]:= dwGetInt(joField,'width',100);
                    end;
                    //创建分页
                    oTB             := TTrackBar.Create(AForm);
                    with oTB do begin
                        Name            := 'TB'+IntToStr(iSlave);
                        Parent          := oTab;
                        Align           := alBottom;
                        Hint            := '{"dwattr":"background"}';
                        Height          := 40;
                        PageSize        := joConfig.slavepagesize;
                        HelpKeyword     := 'page';
                        Position        := 0;
                        AlignWithMargins:= True;
                        Margins.Top     := 5;
                        Margins.Bottom  := 5;
                        //
                        tM.Code         := @TBSlaveChange;
                        tM.Data         := Pointer(325); // 随便取的数
                        OnChange        := TNotifyEvent(tM);
                    end;
                end;
                oPCS.ActivePageIndex   := 0;
                //更新从表功能按钮的位置
                //oPSB.Top  := oPCS.Top+7;
            end;
        except

            //异常时调试使用
            Result  := -5;
        end;
    end;

    if Result = 0 then begin
        try
            if joConfig.defaultempty = 0 then begin
                //更新数据
                qcUpdateMain(AForm,'');
            end;
        except

            //异常时调试使用
            Result  := -6;
        end;
    end;

    if Result = 0 then begin
        try
            if joConfig.defaultempty = 0 then begin
                //
                qcUpdateSlaves(AForm);

                //切换从表PageControl,以显示数据
                if joConfig.Exists('slave') then begin
                    if joConfig.slave._count > 0 then begin
                        oPCS.OnChange(oPCS);
                    end;
                end;
            end;
        except

            //异常时调试使用
            Result  := -7;
        end;
    end;

    if Result = 0 then begin
        try
            //创建确定面板P_Confirm
            qcCreateConfirmPanel(AForm);

        except

            //异常时调试使用
            Result  := -8;
        end;
    end;

    if Result = 0 then begin
        try
            //创建编辑面板PEr
            qcCreateEditorPanel(AForm);

        except

            //异常时调试使用
            Result  := -9;
        end;
    end;

    if Result = 0 then begin
        try
            //创建查询面板PQy
            qcCreateQueryPanel(AForm);

        except

            //异常时调试使用
            Result  := -10;
        end;
    end;

    if Result = 0 then begin
        try
            //综合布局
            qcLayout(AForm);
        except
            //异常时调试使用
            Result  := -11;
        end;
    end;

    //
    if Result <> 0 then begin
        dwMessage('Error when quickcrud : '+IntToStr(Result),'error',AForm);
    end;
end;

//销毁dwCrud，以便二次创建
function  dwCrudDestroy(AForm:TForm):Integer;
var
    iSlave      : Integer;
    joConfig    : Variant;
    oPanel      : TPanel;
    oFDQuery    : TFDQuery;
begin
    try
        //取配置JSON : 读AForm的 qcConfig 变量值
        joConfig    := qcGetConfigJson(AForm);

        //如果不是JSON格式，则退出
        if joConfig = unassigned then begin
            Exit;
        end;

        //销毁编辑面板
        oPanel  := TPanel(AForm.FindComponent('PEr'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁删除面板
        oPanel  := TPanel(AForm.FindComponent('PDe'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁Query面板
        oPanel  := TPanel(AForm.FindComponent('PQy'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁主表板
        oPanel  := TPanel(AForm.FindComponent('PQC'));
        if oPanel <> nil then begin
            FreeAndNil(oPanel);
        end;

        //销毁临时表
        oFDQuery    := TFDQuery(AForm.FindComponent('FDQueryTmp'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

        //销毁主表
        oFDQuery    := TFDQuery(AForm.FindComponent('FQ_Main'));
        if oFDQuery <> nil then begin
            FreeAndNil(oFDQuery);
        end;

        //销毁从表
        for iSlave := 0 to 9 do begin
            oFDQuery    := TFDQuery(AForm.FindComponent('FQ_'+IntToStr(iSlave)));
            if oFDQuery <> nil then begin
                FreeAndNil(oFDQuery);
            end;
        end;
    except

    end;
end;


end.
