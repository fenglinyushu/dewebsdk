unit dwBoard;
(*
功能说明：
------------------------------------------------------------------------------------------------------------------------
用于通过一个panel完成看板模块


##更新说明：
------------------------------------------------------------------------------------------------------------------------
### 2025-03-27
1. 开始本模块
*)


interface

uses
    //
    dwBase,

    //
    dwJSONs, //deweb的JSON处理单元

    //
    SynCommons{用于解析JSON},

    //
    System.RegularExpressions,//正则表达式函数

    //
    FireDAC.DApt,
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
    Math,
    StrUtils,
    Data.DB,
    Vcl.WinXPanels,
    Rtti,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Samples.Spin,
    Vcl.WinXCtrls,Vcl.Grids;



//一键生成Board模块
function  bdInit(APanel:TPanel;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

//取当前配置，可能与原来的hint有所区别，主要是增加了默认值和自动生成的配置
function  bdGetConfig(APanel:TPanel):Variant;

//销毁dwBoard，以便二次创建
function  bdDestroy(APanel:TPanel):Integer;

//更新数据
procedure bdUpdate(APanel:TPanel;AWhere:String);

implementation

function bdGetBoardPanel(ACtrl:TControl):TPanel;
var
    oCtrl   : TControl;
begin
    /////////////////////////
    ///原理是查找当前控件的父控件，如果是TPanel且HelpContext为 31030，则停止
    /////////////////////////

    Result  := nil;
    if (ACtrl <> nil) and (ACtrl.Parent<>nil) then begin
        if (ACtrl.ClassType = TPanel) and (ACtrl.HelpContext = 31030) then begin
            Result  := TPanel(ACtrl);
        end else begin
            oCtrl   := ACtrl;
            while True do begin
                oCtrl   := oCtrl.Parent;
                if oCtrl = nil then begin
                    break;
                end;
                if (oCtrl.ClassType = TPanel) and (oCtrl.HelpContext = 31030) then begin
                    Result  := TPanel(oCtrl);
                    break;
                end;
            end;
        end;
    end;
end;


function  bdUpdateItems(AFQUpdate:TFDQuery; APrefix:String; AParent:TPanel;AItems:Variant;var ACount:Integer):Integer;
var
    iItem           : Integer;
    iStart,iEnd     : Integer;      //更新标志
    iRow,iCol       : Integer;
    //
    sType           : String;       //元素的类型
    sTemp           : String;
    sPrefix         : String;       //子控件前缀
    sName           : string;

    //
    joConfig        : Variant;
    joItem          : Variant;
    joHint          : Variant;
    joTemp          : Variant;
    //
    oForm           : TForm;
    oPanel          : TPanel;
    oLabel          : TLabel;
    oImage          : TImage;
    oMemo           : TMemo;
    oShape          : TShape;
    oProgress       : TProgressBar;
    oSTMap          : TStaticText;
    //
    oSGrid          : TStringGrid;
    sDatas          : array of array of string;
    iRowNum         : Integer;
    sheaderBGC	    : String;   //表头背景色	String	---	'#00BAFF'
    soddRowBGC	    : String;   //奇数行背景色	String	---	'#003B51'
    sevenRowBGC	    : string;   //偶数行背景色	String	---	#0A2732
    iwaitTime       : Integer;  //轮播时间间隔(ms)	Number	---	2000
    iheaderHeight   : Integer;  //表头高度	Number	---	35
    icolumnWidths   : array of integer; //列宽度	Array<Number>	[1]	[]
    saligns	        : array of string;  //列对齐方式	Array<String>	[2]	[]
    bindex	        : Boolean;  //显示行号	Boolean	true|false	false
    sindexHeader	: String;   //行号表头	String	-	'#'
    scarousel	    : string;   //轮播方式	String	'single'|'page'	'single'
    bhoverPause     : Boolean;  //悬浮暂停轮播	Boolean	---	true
begin

    //如果为空, 则嫁出
    if AItems = null then begin
        Exit;
    end;

    //取得父窗体
    oForm       := TForm(AParent.Owner);

    //循环检查更新节点
    for iItem := 0 to AItems._Count - 1 do begin
        //取得当前节点的JSON
        joItem  := AItems._(iItem);

        //更新变量, 以取得控件
        Inc(ACount);

        //可见性
        if dwGetBoolean(joItem,'visible',true) = false then begin
            Continue;
        end;

        //取得节点type
        sType   := dwGetStr(joItem,'type','panel');

        //如果不需要更新,则跳过. 只更新panel以及带有sql的元素
        if sType <> 'panel' then begin
            if dwGetStr(joItem,'sql') = '' then begin
                Continue;
            end;
        end;

        //控件名称. 如果有name属性, 则采用; 否则自动编号
        if dwGetStr(joItem,'name') = '' then begin
            sName   := APrefix+'BD'+IntToStr(ACount);
        end else begin
            sName   := joItem.name;
        end;

        //
        if sType = 'bar' then begin
            //------------ bar   ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin

                //找到更新标志
                iStart  := -1;
                iEnd    := -1;
                for iRow := 0 to Lines.Count - 1 do begin
                    if Trim(Lines[iRow]) = '//dw__start' then begin
                        iStart  := iRow;
                    end;
                    if Trim(Lines[iRow]) = '//dw__end' then begin
                        iEnd    := iRow;
                    end;
                    //
                    if (iStart < -1) and (iEnd > -1) then begin
                        break;
                    end;
                end;

                //异常检测
                if (iStart = -1) or (iEnd = -1) then begin
                    Exit;
                end;

                //清除原数据
                for iRow := iEnd - 1  downto iStart + 1 do begin
                    Lines.Delete(iRow);
                end;

                //打开查询
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                (*  示例   第一行:除第一个字段的字段名列表,  第二行:第一个字段的值,即横坐标 后续行: 后续字段的数值列有
                var dwdata = [
                //dw__start
                  ['OpenAI', 'Sora'],
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  [320, 332, 301, 334, 390, 330, 320],
                  [120, 232, 201, 234, 290, 230, 280]
                //dw__end
                ];
                ....
                *)


                //先写入字段名列表
                sTemp   := '[';
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[iCol].FieldName +''','
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 1,sTemp);

                //写第一个字段的值,即横坐标
                sTemp   := '[';
                AFQUpdate.First;
                while not AFQUpdate.Eof do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[0].AsString +''',';
                    AFQUpdate.Next;
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 2,sTemp);


                //写入新数据
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := '[';
                    AFQUpdate.First;
                    while not AFQUpdate.Eof do begin
                        sTemp   := sTemp + FloatToStr(AFQUpdate.Fields[iCol].AsFloat) +',';
                        AFQUpdate.Next;
                    end;
                    Delete(sTemp, Length(sTemp), 1);
                    sTemp   := sTemp + ']';
                    if iCol < AFQUpdate.FieldCount - 1 then begin
                        sTemp   := sTemp + ',';
                    end;
                    //
                    Lines.Insert(iStart + 2 + iCol ,sTemp);
                end;

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'bar_horz' then begin
            //------------ bar_horz  -----------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin

                //找到更新标志
                iStart  := -1;
                iEnd    := -1;
                for iRow := 0 to Lines.Count - 1 do begin
                    if Trim(Lines[iRow]) = '//dw__start' then begin
                        iStart  := iRow;
                    end;
                    if Trim(Lines[iRow]) = '//dw__end' then begin
                        iEnd    := iRow;
                    end;
                    //
                    if (iStart < -1) and (iEnd > -1) then begin
                        break;
                    end;
                end;

                //异常检测
                if (iStart = -1) or (iEnd = -1) then begin
                    Exit;
                end;

                //清除原数据
                for iRow := iEnd - 1  downto iStart + 1 do begin
                    Lines.Delete(iRow);
                end;

                //打开查询
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                (*  示例   第一行:除第一个字段的字段名列表,  第二行:第一个字段的值,即横坐标 后续行: 后续字段的数值列有
                var dwdata = [
                //dw__start
                  ['OpenAI', 'Sora'],
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  [320, 332, 301, 334, 390, 330, 320],
                  [120, 232, 201, 234, 290, 230, 280]
                //dw__end
                ];
                ....
                *)


                //先写入字段名列表
                sTemp   := '[';
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[iCol].FieldName +''','
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 1,sTemp);

                //写第一个字段的值,即横坐标
                sTemp   := '[';
                AFQUpdate.First;
                while not AFQUpdate.Eof do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[0].AsString +''',';
                    AFQUpdate.Next;
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 2,sTemp);


                //写入新数据
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := '[';
                    AFQUpdate.First;
                    while not AFQUpdate.Eof do begin
                        sTemp   := sTemp + FloatToStr(AFQUpdate.Fields[iCol].AsFloat) +',';
                        AFQUpdate.Next;
                    end;
                    Delete(sTemp, Length(sTemp), 1);
                    sTemp   := sTemp + ']';
                    if iCol < AFQUpdate.FieldCount - 1 then begin
                        sTemp   := sTemp + ',';
                    end;
                    //
                    Lines.Insert(iStart + 2 + iCol ,sTemp);
                end;

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'datav_water' then begin
            //------------ bar   ---------------------------------------------------------------------------------------
            oShape  := TShape(oForm.FindComponent(sName));
            with oShape do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //caption
                sTemp   := '[';
                for iCol := 0 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := sTemp + FloatToStr(AFQUpdate.Fields[iCol].AsFloat) +','
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + ']';
                //
                dwSetProp(oShape,'data',sTemp);

            end;
        end else if sType = 'echarts' then begin
            //------------ echarts  ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin
                AFQUpdate.Open(dwGetStr(joItem.update,'data'));

            end;
        end else if sType = 'horzbar' then begin
            //------------ bar   ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //先清除原数据
                joItem.option.yAxis.data        := _json('[]');
                joItem.option.series._(0).data  := _json('[]');

                //读取新数据, 字段0为横轴值, 字段1为纵轴值
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    AFQUpdate.RecNo := iRow;
                    //
                    joItem.option.yAxis.data.Add(AFQUpdate.Fields[0].AsString);
                    joItem.option.series._(0).data.Add(AFQUpdate.Fields[1].AsFloat);
                end;
                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'image' then begin
            //------------ Image ---------------------------------------------------------------------------------------
            oImage  := TImage(oForm.FindComponent(sName));
            with oImage do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //
                if joItem.update.Exists('format') then begin
                    sTemp   := Format(dwGetStr(joItem.update,'format'),[AFQUpdate.Fields[0].AsString]);
                end else begin
                    sTemp   := AFQUpdate.Fields[0].AsString;
                end;

                //
                dwSetProp(oImage,'src',sTemp);
            end;
        end else if sType = 'label' then begin
            //------------ Label ---------------------------------------------------------------------------------------
            oLabel  := TLabel(oForm.FindComponent(sName));
            with oLabel do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                if not AFQUpdate.IsEmpty then begin
                    Caption := AFQUpdate.Fields[0].AsString;
                end;
            end;
        end else if sType = 'line' then begin
            //------------ line  ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin

                //找到更新标志
                iStart  := -1;
                iEnd    := -1;
                for iRow := 0 to Lines.Count - 1 do begin
                    if Trim(Lines[iRow]) = '//dw__start' then begin
                        iStart  := iRow;
                    end;
                    if Trim(Lines[iRow]) = '//dw__end' then begin
                        iEnd    := iRow;
                    end;
                    //
                    if (iStart < -1) and (iEnd > -1) then begin
                        break;
                    end;
                end;

                //异常检测
                if (iStart = -1) or (iEnd = -1) then begin
                    Exit;
                end;

                //清除原数据
                for iRow := iEnd - 1  downto iStart + 1 do begin
                    Lines.Delete(iRow);
                end;

                //打开查询
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                (*  示例   第一行:除第一个字段的字段名列表,  第二行:第一个字段的值,即横坐标 后续行: 后续字段的数值列有
                var dwdata = [
                //dw__start
                  ['OpenAI', 'Sora'],
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  [320, 332, 301, 334, 390, 330, 320],
                  [120, 232, 201, 234, 290, 230, 280]
                //dw__end
                ];
                ....
                *)


                //先写入字段名列表,  第一行为曲线名称, 从数据表中读取字段名, 从序号1(非0)开始. 第0个字段用于横坐标
                sTemp   := '[';
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[iCol].FieldName +''','
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 1,sTemp);

                //写第0个字段的值,一般为横坐标(horz时为纵坐标)
                sTemp   := '[';
                AFQUpdate.First;
                while not AFQUpdate.Eof do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[0].AsString +''',';
                    AFQUpdate.Next;
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 2,sTemp);


                //写入新数据, 依次为其他字段的值
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := '[';
                    AFQUpdate.First;
                    while not AFQUpdate.Eof do begin
                        sTemp   := sTemp + FloatToStr(AFQUpdate.Fields[iCol].AsFloat) +',';
                        AFQUpdate.Next;
                    end;
                    Delete(sTemp, Length(sTemp), 1);
                    sTemp   := sTemp + ']';
                    if iCol < AFQUpdate.FieldCount - 1 then begin
                        sTemp   := sTemp + ',';
                    end;
                    //
                    Lines.Insert(iStart + 2 + iCol ,sTemp);
                end;

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'map' then begin
            //------------ map   ---------------------------------------------------------------------------------------
            //oSTMap  := TStaticText.Create(oForm);
        end else if sType = 'panel' then begin
            //------------ panel ---------------------------------------------------------------------------------------
            oPanel  := TPanel(oForm.FindComponent(sName));
            if dwGetStr(joItem,'sql') <> '' then begin
                with oPanel do begin
                    AFQUpdate.Open(dwGetStr(joItem,'sql'));

                    if not AFQUpdate.IsEmpty then begin
                        Caption := AFQUpdate.Fields[0].AsString;
                    end;
                end;
            end;

            //
            if joItem.Exists('items') then begin
                bdUpdateItems(AFQUpdate, sPrefix, oPanel, joItem.items, ACount);
            end;

        end else if sType = 'pie' then begin
            //------------ pie -----------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin

                //找到更新标志
                iStart  := -1;
                iEnd    := -1;
                for iRow := 0 to Lines.Count - 1 do begin
                    if Trim(Lines[iRow]) = '//dw__start' then begin
                        iStart  := iRow;
                    end;
                    if Trim(Lines[iRow]) = '//dw__end' then begin
                        iEnd    := iRow;
                    end;
                    //
                    if (iStart < -1) and (iEnd > -1) then begin
                        break;
                    end;
                end;

                //异常检测
                if (iStart = -1) or (iEnd = -1) then begin
                    Exit;
                end;

                //清除原数据
                for iRow := iEnd - 1  downto iStart + 1 do begin
                    Lines.Delete(iRow);
                end;

                //打开查询
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //写入新数据
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    sTemp   := '{value:'+IntToStr(AFQUpdate.Fields[0].AsInteger)+', name: '''+AFQUpdate.Fields[1].AsString+''' }';
                    if iRow = AFQUpdate.RecordCount then begin
                        Lines.Insert(iStart+iRow,sTemp);
                    end else begin
                        Lines.Insert(iStart+iRow,sTemp+',');
                    end;
                    AFQUpdate.Next;
                end;

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'progress' then begin
            //------------ progress   ----------------------------------------------------------------------------------
            oProgress   := TProgressBar(oForm.FindComponent(sName));
            with oProgress do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //position
                Position    := Round(AFQUpdate.Fields[0].AsFloat);
            end;
        end else if sType = 'radar' then begin
            //------------ radar ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //先清除原数据
                joItem.option.series._(0).data._(0).value   := _json('[]');
                //
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    AFQUpdate.RecNo := iRow;
                    //
                    if joItem.option.radar.indicator._Count > iRow - 1 then begin
                        joItem.option.radar.indicator._(iRow-1).name := AFQUpdate.Fields[0].AsString;
                    end else begin
                        joTemp  := _json('{}');
                        joTemp.name     := AFQUpdate.Fields[0].AsString;
                        joTemp.max      := 100;
                        //
                        joItem.option.radar.indicator.Add(joTemp);
                    end;
                    joItem.option.series._(0).data._(0).value.Add(AFQUpdate.Fields[1].AsInteger);
                end;
                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'ring' then begin
            //------------ ring  ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin

                //找到更新标志
                iStart  := -1;
                iEnd    := -1;
                for iRow := 0 to Lines.Count - 1 do begin
                    if Trim(Lines[iRow]) = '//dw__start' then begin
                        iStart  := iRow;
                    end;
                    if Trim(Lines[iRow]) = '//dw__end' then begin
                        iEnd    := iRow;
                    end;
                    //
                    if (iStart < -1) and (iEnd > -1) then begin
                        break;
                    end;
                end;

                //异常检测
                if (iStart = -1) or (iEnd = -1) then begin
                    Exit;
                end;

                //清除原数据
                for iRow := iEnd - 1  downto iStart + 1 do begin
                    Lines.Delete(iRow);
                end;

                //打开查询
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                //写入新数据
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    sTemp   := '{value:'+IntToStr(AFQUpdate.Fields[0].AsInteger)+', name: '''+AFQUpdate.Fields[1].AsString+''' }';
                    if iRow = AFQUpdate.RecordCount then begin
                        Lines.Insert(iStart+iRow,sTemp);
                    end else begin
                        Lines.Insert(iStart+iRow,sTemp+',');
                    end;
                    AFQUpdate.Next;
                end;

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'stringgrid' then begin
            //------------ stringgrid ---------------------------------------------------------------------------------------
            oSGrid  := TStringGrid(oForm.FindComponent(sName));
            with oSGrid do begin
                AFQUpdate.Open(dwGetStr(joItem,'sql'));


                //重新设置表格的行列数
                RowCount    := AFQUpdate.RecordCount + 1;
                ColCount    := AFQUpdate.FieldCount;

                //重写标题
                for iCol := 0 to AFQUpdate.FieldCount - 1 do begin
                    Cells[iCol,0]   := AFQUpdate.Fields[iCol].FieldName;
                end;

                //更新数据
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    AFQUpdate.RecNo := iRow;
                    for iCol := 0 to ColCount-1 do begin
                        Cells[iCol,iRow]    := AFQUpdate.Fields[iCol].AsString;
                    end;
                end;
            end;
        end else if Copy(sType,Length(sType)-6,7) = 'echarts' then begin
            oMemo   := TMemo(oForm.FindComponent(sName));
            with oMemo do begin

                //找到更新标志
                iStart  := -1;
                iEnd    := -1;
                for iRow := 0 to Lines.Count - 1 do begin
                    if Trim(Lines[iRow]) = '//dw__start' then begin
                        iStart  := iRow;
                    end;
                    if Trim(Lines[iRow]) = '//dw__end' then begin
                        iEnd    := iRow;
                    end;
                    //
                    if (iStart < -1) and (iEnd > -1) then begin
                        break;
                    end;
                end;

                //异常检测
                if (iStart = -1) or (iEnd = -1) then begin
                    Exit;
                end;

                //清除原数据
                for iRow := iEnd - 1  downto iStart + 1 do begin
                    Lines.Delete(iRow);
                end;

                //打开查询
                AFQUpdate.Open(dwGetStr(joItem,'sql'));

                (*  示例   第一行:除第一个字段的字段名列表,  第二行:第一个字段的值,即横坐标 后续行: 后续字段的数值列有
                var dwdata = [
                //dw__start
                  ['OpenAI', 'Sora'],
                  ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
                  [320, 332, 301, 334, 390, 330, 320],
                  [120, 232, 201, 234, 290, 230, 280]
                //dw__end
                ];
                ....
                *)


                //先写入字段名列表
                sTemp   := '[';
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[iCol].FieldName +''','
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 1,sTemp);

                //写第一个字段的值,即横坐标
                sTemp   := '[';
                AFQUpdate.First;
                while not AFQUpdate.Eof do begin
                    sTemp   := sTemp + '''' + AFQUpdate.Fields[0].AsString +''',';
                    AFQUpdate.Next;
                end;
                Delete(sTemp, Length(sTemp), 1);
                sTemp   := sTemp + '],';
                Lines.Insert(iStart + 2,sTemp);


                //写入新数据
                for iCol := 1 to AFQUpdate.FieldCount - 1 do begin
                    sTemp   := '[';
                    AFQUpdate.First;
                    while not AFQUpdate.Eof do begin
                        sTemp   := sTemp + FloatToStr(AFQUpdate.Fields[iCol].AsFloat) +',';
                        AFQUpdate.Next;
                    end;
                    Delete(sTemp, Length(sTemp), 1);
                    sTemp   := sTemp + ']';
                    if iCol < AFQUpdate.FieldCount - 1 then begin
                        sTemp   := sTemp + ',';
                    end;
                    //
                    Lines.Insert(iStart + 2 + iCol ,sTemp);
                end;

                //设置重绘
                ShowHint    := True;
            end;
        end else begin
        end;
    end;

end;


Procedure bdTimer(Self: TObject; Sender: TObject); //OnTimer
var
    //
    iCount      : Integer;
    //
    sName       : String;
    sPrefix     : String;
    //
    oForm       : TForm;
    oPanel      : TPanel;
    oFQUpdate   : TFDQuery;
    //
    joConfig    : variant;
begin
    oForm       := TForm(TTimer(Sender).Owner);

    //取得当前时钟的 name
    sName       := TTimer(Sender).Name;

    //删除后面的 __Timer
    sName       := StringReplace(sName,'__Timer','',[]);

    //根据 sName 取得当前面板控件
    oPanel      := TPanel(oForm.FindComponent(sName));

    //取得配置 JSON
    joConfig    := bdGetConfig(oPanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //找到查询表
    oFQUpdate   := TFDQuery(oPanel.FindComponent(sPrefix+'FQUpdate'));

    //
    iCount  := 0;
    bdUpdateItems(oFQUpdate, sPrefix, oPanel, joConfig.items, iCount);
end;


function bdGetConfig(APanel:TPanel):Variant;
var
    iField      : Integer;
    //
    joField     : Variant;
begin
    try
        //取配置JSON : 读AForm的 bdConfig 变量值
        Result  := dwJson(APanel.Hint);

        //<检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        if not Result.Exists('items') then begin    //默认表格显示竖线
            Result.items   := _json('[]');
        end;
    except

    end;
end;


procedure bdUpdate(APanel:TPanel;AWhere:String);
var
    iField      : Integer;
    iItem       : Integer;
    iList       : Integer;
    iSlave      : Integer;
    //
    sFields     : string;
    sWhere      : string;
    sStart,sEnd : String;
    sType       : string;
    sText       : String;
    sTmp        : String;

    //
    joConfig    : variant;
    joField     : Variant;
    joDBConfig  : Variant;
    joMaster    : variant;
    joStyleName : Variant;
    joList      : Variant;
    joSlave     : Variant;
    //
    oForm       : TForm;
    oFDQuery    : TFDQuery;
    oTbP        : TTrackBar;
    oSgD        : TStringGrid;
    oEKw        : TEdit;
    oFQy        : TFlowPanel;
    oPQF        : TPanel;
    oE_Query    : TEdit;
    oDT_Start   : TDateTimePicker;    //起始日期，DateTimePicker_Start
    oDT_End     : TDateTimePicker;    //结束日期，DateTimePicker_End
    oCBQy       : TComboBox;
    oBFz        : TButton;
    oBQy        : TButton;
    oMasterPanel: TPanel;
    oFQMaster   : TFDQuery;
    oSlavePanel : TPanel;
    //
    sPrefix     : String;
	bAccept		: boolean;
    oClick      : Procedure(Sender:TObject) of Object;

begin
    try
    except

    end;
end;

function  bdSetAlign(ACtrl:TControl;AItem:Variant):Integer;
begin
    with ACtrl do begin
        //
        if AItem.Exists('align') then begin
            if AItem.align = 'left' then begin
                Align   := alLeft;
            end else if AItem.align = 'client' then begin
                Align   := alClient;
            end else if AItem.align = 'right' then begin
                Align   := alRight;
            end else if AItem.align = 'top' then begin
                Align   := alTop;
            end else if AItem.align = 'bottom' then begin
                Align   := alBottom;
            end else begin
                Align   := alnone;
            end;
        end;

    end;
end;

function  bdSetAlignment(ACtrl:TControl;AItem:Variant):Integer;
begin
    with TLabel(ACtrl) do begin
        //
        if AItem.Exists('alignment') then begin
            if AItem.alignment = 'right' then begin
                Alignment   := taRightJustify;
            end else if AItem.alignment = 'center' then begin
                Alignment   := taCenter;
            end;
        end;

    end;
end;

function  bdSetBorder(ACtrl:TControl;AItem:Variant):Integer;
var
    iSize       : Integer;
    sRadius     : String;
    sStyle      : string;
    sBorder     : string;
    sColor      : String;
    //
    joBorder    : Variant;
    joHint      : Variant;
begin
    if AItem.Exists('border') then begin
        joBorder    := AItem.border;
        //
        with TLabel(ACtrl) do begin
            //圆角设置
            sRadius := dwGetStr(joBorder,'radius','');
            if sRadius <> '' then begin
                sRadius := 'border-radius:'+sRadius+';';
            end;

            //
            sBorder := sRadius;

            //边框
            iSize   := dwGetInt(joBorder,'size',0);
            if iSize > 0 then begin
                sStyle  := dwGetStr(joBorder,'style','solid');
                sColor  := dwColorAlpha(dwGetColorFromJson(joBorder.color,clWhite));
                if joBorder.Exists('side') then begin
                   //数组 按bottom/left/right/top顺序
                   if joBorder.side._Count>0 then begin //
                       if joBorder.side._(0) = 1 then begin
                           sBorder  := sBorder + 'border-bottom:' + sStyle + ' ' + IntToStr(iSize) + 'px ' + sColor + ';';
                       end;
                   end;
                   if joBorder.side._Count>1 then begin //
                       if joBorder.side._(1) = 1 then begin
                           sBorder  := sBorder + 'border-left:' + sStyle + ' ' + IntToStr(iSize) + 'px ' + sColor + ';';
                       end;
                   end;
                   if joBorder.side._Count>2 then begin //
                       if joBorder.side._(2) = 1 then begin
                           sBorder  := sBorder + 'border-right:' + sStyle + ' ' + IntToStr(iSize) + 'px ' + sColor + ';';
                       end;
                   end;
                   if joBorder.side._Count>3 then begin //
                       if joBorder.side._(3) = 1 then begin
                           sBorder  := sBorder + 'border-top:' + sStyle + ' ' + IntToStr(iSize) + 'px ' + sColor +';';
                       end;
                   end;
                end else begin
                    sBorder := sRadius + 'border:' + sStyle + ' ' + IntToStr(iSize) + 'px ' + sColor +';';
                end;
            end;


            //写入Hint中
            joHint  := dwJson(Hint);
            joHint.dwstyle := dwGetStr(joHint,'dwstyle','')+sBorder;
            Hint    := joHint;
        end;
    end;
end;


function  bdSetFont(ACtrl:TControl;AItem:Variant):Integer;
var
    joFont      : Variant;
begin
    if AItem.Exists('font') then begin
        joFont  := AItem.font;
        with TLabel(ACtrl) do begin
            if joFont.exists('size') then begin
                Font.Size   := dwGetInt(joFont,'size',Font.Size);
            end;
            if joFont.exists('color') then begin
                Font.Color  := dwGetColorFromJson(joFont.color,Font.Color);
            end;
            if joFont.exists('bold') then begin
                if dwGetInt(joFont,'bold',0)=1 then begin
                    Font.Style  := Font.Style + [fsBold];
                end else begin
                    Font.Style  := Font.Style - [fsBold];
                end;
            end;
            if joFont.exists('italic') then begin
                if dwGetInt(joFont,'italic',0)=1 then begin
                    Font.Style  := Font.Style + [fsitalic];
                end else begin
                    Font.Style  := Font.Style - [fsitalic];
                end;
            end;
            if joFont.exists('strikeout') then begin
                if dwGetInt(joFont,'strikeout',0)=1 then begin
                    Font.Style  := Font.Style + [fsstrikeout];
                end else begin
                    Font.Style  := Font.Style - [fsstrikeout];
                end;
            end;
            if joFont.exists('underline') then begin
                if dwGetInt(joFont,'underline',0)=1 then begin
                    Font.Style  := Font.Style + [fsunderline];
                end else begin
                    Font.Style  := Font.Style - [fsunderline];
                end;
            end;

        end;
    end;
end;

function  bdSetBase(ACtrl:TControl;AItem:Variant):Integer;
begin
    with TPanel(ACtrl) do begin
        if AItem.Exists('name') then begin
            if dwGetStr(AItem,'name') <> '' then begin
                Name    := dwGetStr(AItem,'name');
            end;
        end;

        //设置Anchors
        Anchors := [akLeft,akTop];
        if AItem.Exists('akleft') then begin
            if AItem.akleft then begin
                Anchors := Anchors + [akleft];
            end else begin
                Anchors := Anchors - [akleft];
            end;
        end;
        if AItem.Exists('akright') then begin
            if AItem.akright then begin
                Anchors := Anchors + [akright];
            end;
        end;
        if AItem.Exists('aktop') then begin
            if AItem.aktop then begin
                Anchors := Anchors + [aktop];
            end else begin
                Anchors := Anchors - [aktop];
            end;
        end;
        if AItem.Exists('akbottom') then begin
            if AItem.akbottom then begin
                Anchors := Anchors + [akbottom];
            end;
        end;

        //设置宽度和高度
        if AItem.Exists('width') then begin
            Width   := dwGetInt(AItem,'width',200);
        end;
        if AItem.Exists('height') then begin
            Height  := dwGetInt(AItem,'height',100);
        end;

        //
        if AItem.Exists('left') then begin
            Left    := dwGetInt(AItem,'left',0);
        end else begin
            if AItem.Exists('right') then begin
                Left    := TPanel(Parent).Width - Width - dwGetInt(AItem,'right',0);
            end;
        end;
        if AItem.Exists('top') then begin
            Top     := dwGetInt(AItem,'top',0);
        end else begin
            if AItem.Exists('bottom') then begin
                Top := TPanel(Parent).Height - Height - dwGetInt(AItem,'bottom',0);
            end;
        end;

        //设置 Alignwithmargins
        AlignWithMargins    := False;
        if AItem.Exists('alignwithmargins') then begin
            if AItem.alignwithmargins = True then begin
                AlignWithMargins    := True;
                //
                Margins.Left    := dwGetInt(AItem,'margins-left');
                Margins.top     := dwGetInt(AItem,'margins-top');
                Margins.right   := dwGetInt(AItem,'margins-right');
                Margins.bottom  := dwGetInt(AItem,'margins-bottom');
            end;
        end;
    end;
end;

function  bdSetMargins(ACtrl:TControl;AItem:Variant):Integer;
begin
    if AItem.Exists('margins') then begin
        if AItem.margins._Count >= 4 then begin
            with ACtrl do begin
                AlignWithMargins:= True;
                Margins.Bottom  := AItem.margins._(0);
                Margins.Left    := AItem.margins._(1);
                Margins.Right   := AItem.margins._(2);
                Margins.Top     := AItem.margins._(3);
            end;
        end;
    end;
end;

function  bdInitItems(AParent:TPanel;AItems:Variant;var ACount:Integer):Integer;
var
    iItem           : Integer;
    iStyle          : Integer;
    //
    sType           : String;       //元素的类型
    sTemp           : String;
    //
    joItem          : Variant;
    joTemp          : Variant;
    joHint          : Variant;
    //
    oForm           : TForm;
    oPanel          : TPanel;
    oLabel          : TLabel;
    oImage          : TImage;
    oMemo           : TMemo;
    oProgress       : TProgressBar;
    oShape          : TShape;
    oSTMap          : TStaticText;
    //
    oSGrid          : TStringGrid;
    sDatas          : array of array of string;
    iRowNum         : Integer;
    sheaderBGC	    : String;   //表头背景色	String	---	'#00BAFF'
    soddRowBGC	    : String;   //奇数行背景色	String	---	'#003B51'
    sevenRowBGC	    : string;   //偶数行背景色	String	---	#0A2732
    iwaitTime       : Integer;  //轮播时间间隔(ms)	Number	---	2000
    iheaderHeight   : Integer;  //表头高度	Number	---	35
    icolumnWidths   : array of integer; //列宽度	Array<Number>	[1]	[]
    saligns	        : array of string;  //列对齐方式	Array<String>	[2]	[]
    bindex	        : Boolean;  //显示行号	Boolean	true|false	false
    sindexHeader	: String;   //行号表头	String	-	'#'
    scarousel	    : string;   //轮播方式	String	'single'|'page'	'single'
    bhoverPause     : Boolean;  //悬浮暂停轮播	Boolean	---	true
    iRow,iCol       : Integer;
begin
    //
    oForm       := TForm(AParent.Owner);

    //
    if AItems = null then begin
        Exit;
    end;

    for iItem := 0 to AItems._Count - 1 do begin
        joItem  := AItems._(iItem);

        //
        if joItem = null then begin
            Exit;
        end;

        //
        Inc(ACount);

        //可见性
        if dwGetBoolean(joItem,'visible',true) = false then begin
            Continue;
        end;

        //
        sType   := dwGetStr(joItem,'type','panel');

        //
        if sType = 'bar' then begin
            //------------ line echarts --------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                //
                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';
            end;
        end else if sType = 'amap' then begin
            //------------ map   ---------------------------------------------------------------------------------------
            oShape  := TShape.Create(oForm);
            with oShape do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'amap';

                //
                bdSetAlign(oShape,joItem);

                //设置ltwm
                bdSetBase(oShape,joItem);

                //
                bdSetFont(oShape,joItem);

                //
                bdSetBorder(oShape,joItem);

                //
                bdSetMargins(oShape,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oShape,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                if dwGetDouble(joItem,'lon') <> 0 then begin
                    dwSetProp(oShape,'lon', dwGetDouble(joItem,'lon'));
                end;
                if dwGetDouble(joItem,'lat') <> 0 then begin
                    dwSetProp(oShape,'lat', dwGetDouble(joItem,'lat'));
                end;
                if dwGetInt(joItem,'zoom') <> 0 then begin
                    dwSetProp(oShape,'zoom', dwGetInt(joItem,'zoom'));
                end;
                if dwGetStr(joItem,'style') <> '' then begin
                    dwSetProp(oShape,'style', dwGetStr(joItem,'style'));
                end;

            end;
        end else if sType = 'bar_horz' then begin
            //------------ bar_horz ------------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+joItem.option+';';
            end;
        end else if sType = 'bmap' then begin
            //------------ map   ---------------------------------------------------------------------------------------
            oShape  := TShape.Create(oForm);
            with oShape do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'bmap';

                //
                bdSetAlign(oShape,joItem);

                //设置ltwm
                bdSetBase(oShape,joItem);

                //
                bdSetFont(oShape,joItem);

                //
                bdSetBorder(oShape,joItem);

                //
                bdSetMargins(oShape,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oShape,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

            end;
        end else if sType = 'datav_water' then begin
            //------------ datav_water ---------------------------------------------------------------------------------
            oShape  := TShape.Create(oForm);
            with oShape do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'dvwater';

                //
                bdSetAlign(oShape,joItem);

                //设置ltwm, margins
                bdSetBase(oShape,joItem);

                //
                bdSetBorder(oShape,joItem);

                //
                bdSetMargins(oShape,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oShape,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Hint    := '{"data":[' + dwGetStr(joItem,'caption','') +']}';

                //额外的样式
                sTemp   := dwGetStr(joItem,'shape');
                if sTemp = 'rect' then begin
                    Shape   := stRectangle;
                end else if sTemp = 'round' then begin
                    Shape   := stRoundRect;
                end else begin
                    Shape   := stCircle;
                end;

            end;
        end else if sType = 'datetime' then begin
            //------------ Label__dateime ------------------------------------------------------------------------------
            oLabel  := TLabel.Create(oForm);
            with oLabel do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'datetime';
                //
                AutoSize    := False;

                //
                bdSetAlign(oLabel,joItem);

                //设置ltwh
                bdSetBase(oLabel,joItem);

                //
                bdSetAlignment(oLabel,joItem);

                //
                bdSetBorder(oLabel,joItem);

                //
                bdSetFont(oLabel,joItem);

                //
                bdSetMargins(oLabel,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oLabel,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                if joItem.Exists('color') then begin
                    Color       := dwGetColorFromJson(joItem.color,clNone);
                    Transparent := False;
                end;
                //
                Caption     := dwGetStr(joItem,'caption','');
                //
                WordWrap    := dwGetInt(joItem,'wrap',0)=1;

                //
                if joItem.Exists('layout') then begin
                    if joItem.layout = 'center' then begin
                        layout  := tlCenter;
                    end;
                end;

                //设置样式, http://datav.jiaminghi.com/guide/borderBox.html#dv-border-box-1
                iStyle      := dwGetInt(joItem,'style',0);
                if iStyle <> 0 then begin
                    HelpKeyword := 'cool';
                    helpContext := iStyle-1;
                end;
            end;
        end else if sType = 'echarts' then begin
            //------------ echarts  ------------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetAlign(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';
            end;
        end else if sType = 'image' then begin
            //------------ Image ---------------------------------------------------------------------------------------
            oImage  := TImage.Create(oForm);
            with oImage do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                //
                AutoSize    := False;

                //
                bdSetAlign(oImage,joItem);

                //设置ltwm
                bdSetBase(oImage,joItem);

                //
                bdSetBorder(oImage,joItem);

                //
                bdSetMargins(oImage,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oImage,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                if joItem.Exists('image') then begin
                    dwSetProp(oImage,'src',dwGetStr(joItem,'image',''));
                end;

                //设置fit
                sTemp   := dwGetStr(joItem,'fit','');
                if sTemp = 'cover' then begin
                    Proportional    := True;
                    Stretch         := True;
                end else if sTemp = 'contain' then begin
                    Proportional    := True;
                    Stretch         := False;
                end else if sTemp = 'fill' then begin
                    Proportional    := False;
                    Stretch         := True;
                end else if sTemp = 'none' then begin
                    Proportional    := False;
                    Stretch         := False;
                end else begin
                    Proportional    := True;
                    Stretch         := True;
                end;
            end;
        end else if sType = 'label' then begin
            //------------ Label ---------------------------------------------------------------------------------------
            oLabel  := TLabel.Create(oForm);
            with oLabel do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                //
                AutoSize    := False;

                //
                bdSetAlign(oLabel,joItem);

                //设置ltwm
                bdSetBase(oLabel,joItem);

                //
                bdSetAlignment(oLabel,joItem);

                //
                bdSetBorder(oLabel,joItem);

                //
                bdSetFont(oLabel,joItem);

                //
                bdSetMargins(oLabel,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oLabel,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                if joItem.Exists('color') then begin
                    Color       := dwGetColorFromJson(joItem.color,clNone);
                    Transparent := False;
                end;
                //
                Caption     := dwGetStr(joItem,'caption','');
                //
                WordWrap    := dwGetInt(joItem,'wrap',0)=1;

                //
                if joItem.Exists('layout') then begin
                    if joItem.layout = 'center' then begin
                        layout  := tlCenter;
                    end;
                end;

                //设置样式, http://datav.jiaminghi.com/guide/borderBox.html#dv-border-box-1
                iStyle      := dwGetInt(joItem,'style',0);
                if iStyle <> 0 then begin
                    HelpKeyword := 'cool';
                    helpContext := iStyle-1;
                end;
            end;
        end else if sType = 'line' then begin
            //------------ line echarts --------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+joItem.option+';';
            end;
        end else if sType = 'map' then begin
            //------------ map   ---------------------------------------------------------------------------------------
            oSTMap  := TStaticText.Create(oForm);
            with oSTMap do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'map';
                AutoSize    := False;

                //
                bdSetAlign(oSTMap,joItem);

                //设置ltwm
                bdSetBase(oSTMap,joItem);

                //
                bdSetFont(oSTMap,joItem);

                //
                bdSetBorder(oSTMap,joItem);

                //
                bdSetMargins(oSTMap,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oSTMap,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                if joItem.Exists('dir') then begin
                    dwSetProp(oSTMap,'dir',dwGetStr(joItem,'dir',''));
                end;

                if joItem.Exists('data') then begin
                    dwSetProp(oSTMap,'data',dwGetStr(joItem,'data',''));
                end;
            end;
        end else if sType = 'panel' then begin
            //------------ Panel ---------------------------------------------------------------------------------------
            oPanel  := TPanel.Create(oForm);
            with oPanel do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                BevelOuter  := bvNone;

                //
                bdSetAlign(oPanel,joItem);

                //
                bdSetBase(oPanel,joItem);

                //
                bdSetAlignment(oPanel,joItem);

                //
                bdSetBorder(oPanel,joItem);

                //
                bdSetFont(oPanel,joItem);

                //
                bdSetMargins(oPanel,joItem);

                //

                if joItem.Exists('color') then begin
                    Color       := dwGetColorFromJson(joItem.color,clNone);
                end else begin
                    Color       := clNone;
                end;

                //
                Caption     := dwGetStr(joItem,'caption','');

                //设置样式, http://datav.jiaminghi.com/guide/borderBox.html#dv-border-box-1
                iStyle      := dwGetInt(joItem,'style',0);
                if iStyle <> 0 then begin
                    HelpKeyword := 'dvBox';
                    helpContext := iStyle;
                end;

                if dwGetStr(joItem,'image') <> '' then begin
                    dwSetProp(oPanel,'dwchild','<img src="'+dwGetStr(joItem,'image','')+'" style="position:absolute;left:0;top:0;width:100%;height:100%;"/>');
                end;

                //额外的样式
                if dwGetStr(joItem,'dwstyle') <> '' then begin
                    dwSetProp(oPanel,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                if iStyle in [11,14] then begin
                    //11/14样式显隐左右小方块
                    if joItem.Exists('hidden') then begin
                        dwSetProp(oPanel,'hidden',joItem.hidden);
                    end;

                    //11/14样式的titlewidth
                    if joItem.Exists('titlewidth') then begin
                        dwSetProp(oPanel,'titlewidth',joItem.titlewidth);
                    end;

                    //14样式显隐边框
                    if joItem.Exists('borderhidden') then begin
                        dwSetProp(oPanel,'borderhidden',joItem.borderhidden);
                    end;

                    //14样式的标题栏底色
                    if dwGetStr(joItem,'background') <> '' then begin
                        dwSetProp(oPanel,'background',joItem.background);
                    end;
                end;

                //
                if joItem.Exists('items') then begin
                    if joItem.items._kind = 2 then begin    //是数组
                        bdInitItems(oPanel,joItem.items,ACount);
                    end;
                end;
            end;
        end else if sType = 'pie' then begin
            //------------ pie   ---------------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';
            end;
        end else if sType = 'progress' then begin
            //------------ progress   ----------------------------------------------------------------------------------
            oProgress   := TProgressBar.Create(oForm);
            with oProgress do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := '';

                //
                bdSetAlign(oProgress,joItem);

                //设置ltwm
                bdSetBase(oProgress,joItem);

                //
                //bdSetFont(oProgress,joItem);

                //
                //bdSetBorder(oProgress,joItem);

                //
                bdSetMargins(oProgress,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oProgress,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //位置
                Position    := dwGetInt(joItem,'value');

                //颜色
                if joItem.Exists('barcolor') then begin
                    BarColor    := dwGetColorFromJson(joItem.barcolor,rgb(64,158,255));
                end;
                if joItem.Exists('background') then begin
                    BackGroundColor := dwGetColorFromJson(joItem.background,clNone);
                end;
                if joItem.Exists('textcolor') then begin
                    Hint    := '{"textcolor":"' + dwColorAlpha(dwGetColorFromJson(joItem.textcolor,clWhite)) +'"}';
                end;

                //样式
                if joItem.Exists('style') then begin
                    if joItem.style = 'line' then begin
                        State   := pbsNormal;
                    end else if joItem.style = 'circle' then begin
                        State   := pbsError;
                    end else begin
                        State   := pbsPaused;
                    end;
                end;

                //显示文字
                if joItem.Exists('showtext') then begin
                    ShowHint    := joItem.showtext;
                end;

                //线宽
                dwSetProp(oProgress,'strokewidth',dwGetInt(joItem,'strokewidth',6));

                //在内部显示
                if joItem.Exists('textinside') then begin
                    SmoothReverse   := joItem.textinside;
                end;
            end;
        end else if sType = 'radar' then begin
            //------------ radar ---------------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';
            end;
        end else if sType = 'ring' then begin
            //------------ ring  ---------------------------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+joItem.option+';';
            end;
        end else if sType = 'stringgrid' then begin
            //------------ stringgrid ---------------------------------------------------------------------------------------
            oSGrid  := TStringGrid.Create(oForm);
            with oSGrid do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'dvscroll';
                Color       := clNone;

                //
                bdSetAlign(oSGrid,joItem);

                //设置ltwm
                bdSetBase(oSGrid,joItem);

                //
                bdSetFont(oSGrid,joItem);

                //
                bdSetBorder(oSGrid,joItem);

                //
                bdSetMargins(oSGrid,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oSGrid,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //colwidths
                if joItem.Exists('colwidths') then begin
                    joTemp  := _json(joItem.colwidths);
                    if joTemp <> unassigned then begin
                        for iCol := 0 to joTemp._Count - 1 do begin
                            ColWidths[iCol] := joTemp._(iCol);
                        end;
                    end;
                end;

                //
                joHint  := dwJson(Hint);

                //
                joHint.rowNum       := dwGetInt(joItem,'rownum',5);
                joHint.headerBGC	:= dwColorAlpha(dwGetColorFromJSON(joItem.headerbgc,TColor($FF00BA)));    //表头背景色	String	---	'#00BAFF'
                joHint.oddRowBGC	:= dwColorAlpha(dwGetColorFromJSON(joItem.oddrowbgc,TColor($513b00)));    //奇数行背景色	String	---	'#003B51'
                joHint.evenRowBGC	:= dwColorAlpha(dwGetColorFromJSON(joItem.evenrowbgc,TColor($32270A)));   //偶数行背景色	String	---	#0A2732
                joHint.waitTime     := dwGetInt(joItem,'waittime',2000);                        //轮播时间间隔(ms)	Number	---	2000
                joHint.headerHeight := dwGetInt(joItem,'headerheight',35);                      //表头高度	Number	---	35
                if joItem.Exists('colaligns') then begin
                    joHint.align	:= _json(joItem.colaligns);                         //列对齐方式	Array<String>	[2]	[]
                end;
                if joItem.Exists('index') then begin                                            //显示行号	Boolean	true|false	false
                    joHint.index    := dwIIFi(joItem.index,1,0);
                end;
                joHint.indexHeader	:= dwGetStr(joItem,'indexheader','#') ;                 //行号表头	String	-	'#'

                joHint.carousel	    := dwGetStr(joItem,'carousel','single');                    //轮播方式	String	'single'|'page'	'single'
                if joItem.Exists('hoverpause') then begin                                       //悬浮暂停轮播	Boolean	---	true
                    joHint.hoverPause   := 1;
                end;

                //
                if joItem.exists('cells') then begin
                    RowCount    := joItem.cells._Count;
                    ColCount    := joItem.cells._(0)._Count;

                    //写数据
                    for iRow := 0 to RowCount - 1 do begin
                        for iCol := 0 to ColCount - 1 do begin
                            Cells[iCol,iRow]    := joItem.cells._(iRow)._(iCol);
                        end;
                    end;


                end;
                //
                Hint    := joHint;

            end;
        end else if Copy(sType,Length(sType)-6,7) = 'echarts' then begin
            //------------ 统一的echarts图表处理  ----------------------------------------------------------------------
            oMemo   := TMemo.Create(oForm);
            with oMemo do begin
                Parent      := AParent;

                //如果指定了名称,则按指定名称;否则自动生成名称
                if dwGetStr(joItem,'name') = '' then begin
                    Name    := 'BD'+IntToStr(ACount);
                end else begin
                    Name    := dwGetStr(joItem,'name');
                end;

                HelpKeyword := 'echarts';
                ScrollBars  := ssBoth;

                //
                bdSetAlign(oMemo,joItem);

                //设置ltwm
                bdSetBase(oMemo,joItem);

                //
                bdSetFont(oMemo,joItem);

                //
                bdSetBorder(oMemo,joItem);

                //
                bdSetMargins(oMemo,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oMemo,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                Text    := 'option = '+joItem.option+';';

            end;
        end;
    end;

end;


function bdInit(APanel:TPanel;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwGetEditMask  = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
    TdwEndDock      = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    joConfig    : variant;
    //
    sMainDir    : String;
    sFields     : String;
    sPrefix     : String;
    sText       : string;
    sValue      : String;
    //
    oForm       : TForm;
    oTimer      : TTimer;

    //
    oFQUpdate   : TFDQuery;     //查询表

    //
    iDec        : Integer;
    iField      : Integer;
    iCount      : Integer;
    iCol        : Integer;
    iList       : Integer;
    iMode       : Byte;         //字段的模式，0：正常（默认），1：表格中不显示，新增/编辑时显示；2：仅FDQuery读取， 表格/新增/编辑均不显示
    iFieldId    : Integer;  //每个字段JSON对应的数据表字段index
    //
    joField     : variant;
    joHint      : variant;
    joCell      : variant;
    joPair      : Variant;
    joList      : Variant;
    joSGHint    : Variant;

    //
    tM          : TMethod;      //用于指定事件
	bAccept		: boolean;
begin
    //默认返回值
    Result  := 0;

    try
        //为当前Panel赋一个特殊的数值，以方便各控件查找到该panel控件
        APanel.HelpContext  := 31030;

        //取得form备用
        oForm   := TForm(APanel.Owner);

        //取得配置json
        joConfig    := bdGetConfig(APanel);

        //取得前缀备用,用以区分多个通用化大屏控件，默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得当前目录备用
        sMainDir    := ExtractFilePath(Application.ExeName);

        //页面标题
        oForm.Caption   := dwGetStr(joConfig,'caption','MaxxBoard System');

        //连接数据库
        sText   := dwGetStr(joConfig,'connectionstring');
        if sText<>'' then begin
            try
                AConnection.ConnectionString    := sText;
                AConnection.Connected           := True;
            except
                dwMessage('无效的connectionstring : '+sText,'error',oForm);
                Exit;
            end;
        end;


        //配置 oFQUpdate 的连接
        oFQUpdate   := TFDQuery(APanel.FindComponent(sPrefix+'FQUpdate'));

        //生成一个主查询
        if oFQUpdate = nil then begin
            oFQUpdate             := TFDQuery.Create(APanel);
            oFQUpdate.Name        := sPrefix + 'FQUpdate';
            oFQUpdate.Connection  := AConnection;
        end;

        //背景图片
        if joConfig.Exists('image') then begin
            sText   := dwGetStr(joConfig,'image');
            if FileExists(sMainDir+sText) then begin
                dwSetProp(APanel,'dwchild','<img src="'+sText+'" style="position:absolute;left:0;top:0;width:100%;height:100%;"/>');
            end;
        end;

        //颜色
        if joConfig.Exists('color') then begin
            APanel.Color    := dwGetColorFromJSON(joConfig.color,$00562B1D);
        end;

        //用于生成id的变量
        iCount  := 0;

        //初始化大屏
        bdInitItems(APanel,joConfig.items,iCount);

        //
        oTimer  := TTimer.Create(oForm);
        with oTimer do begin
            Name        := APanel.Name + '__Timer';
            Interval    := dwGetInt(joConfig,'interval',5)*1000;    //默认5秒更新一次
            //
            tM.Code         := @bdTimer;
            tM.Data         := Pointer(325); // 随便取的数
            OnTimer         := TNotifyEvent(tM);
        end;
    except
        //异常时调试使用
        Result  := -1;
    end;

    if Result = 0 then begin
        try

        except
            //异常时调试使用
            Result  := -5;
        end;
    end;




    // bdInited 事件
    bAccept := True;
    if Assigned(APanel.OnDragOver) then begin
        //APanel.OnDragOver(APanel,nil,bdInited,0,dsDragEnter,bAccept);
        if not bAccept then begin
            Exit;
        end;
    end;

    //
    if Result <> 0 then begin
        dwMessage('Error when BoardPanel at '+IntToStr(Result)+', gle = '+ IntToStr(GetLastError),'error',oForm);
    end;

    //
    //dwSimple(oForm);
end;

//销毁dwBoard，以便二次创建
function  bdDestroy(APanel:TPanel):Integer;
var
    //
    iItem       : Integer;
    //
    oForm       : TForm;
    oTimer      : TTimer;
    oFDQuery    : TFDQuery;
    //
    joConfig    : Variant;
    //
    sPrefix     : string;
begin
    try
        //取得form备用
        oForm   := TForm(APanel.Owner);

        //取得配置json
        joConfig    := bdGetConfig(APanel);

        //取得前缀备用,用以区分多个通用化大屏控件，默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //
        oTimer  := TTimer(oForm.FindComponent(APanel.Name+'__Timer'));
        if oTimer <> nil then begin
            oTimer.Destroy;
        end;

        oTimer  := TTimer(oForm.FindComponent(APanel.Name+'__Timer'));
        if oTimer <> nil then begin
            oTimer.Destroy;
        end;

        //oFQUpdate
        oFDQuery    := TFDQuery(APanel.FindComponent(sPrefix+'FQUpdate'));
        if oFDQuery <> nil then begin
            oFDQuery.Destroy;
        end;

        //
        for iItem := APanel.ControlCount - 1 downto 0 do begin
            APanel.Controls[iItem].Destroy;
        end;
    except

    end;
end;


end.
