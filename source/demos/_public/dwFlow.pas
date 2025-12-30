unit dwFlow;
(*
功能说明：
------------------------------------------------------------------------------------------------------------------------
用于通过一个panel完成工作流模块


##更新说明：
------------------------------------------------------------------------------------------------------------------------
### 2025-05-09
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



//一键生成Flow模块
function  flInit(APanel:TPanel;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;

//取当前配置，可能与原来的hint有所区别，主要是增加了默认值和自动生成的配置
function  flGetConfig(APanel:TPanel):Variant;

//销毁dwFlow，以便二次创建
function  flDestroy(APanel:TPanel):Integer;

//更新数据
function  flUpdate(APanel:TPanel):Integer;

implementation

function flGetFlowPanel(ACtrl:TControl):TPanel;
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

function flUpdate(APanel:TPanel):Integer;
var
    iItem       : Integer;
    iTop        : Integer;

    //
    sImg        : String;

    //
    sHtml       : String;
    sLineH      : String;
    sType       : String;
    sFull       : string;
    sStatus     : string;   //pending / approved / rejected / none
    sIcon       : string;
    sDefaultClr : string;   //默认背景色, 根据节点状态的不同
    sExt        : String;

    //
    joConfig    : Variant;
    joItem      : Variant;
const
    _Node   = ''
        +' <div style="position:absolute;left:0px;top:%dpx;height:180px;width:100%%;font-family: Inter, system-ui, sans-serif">'
        //    <!-- 进度线 ! -->
        +'     <div style="position:absolute;left:34px;top:0px;height:%s;width:2px;background-color:rgb(229, 230, 235);"></div>'

        +'     <div style="position:absolute;left:23px;top:0px;height:25px;width:25px;background-color:%s;border-radius:50%%;color:#fff">'
        +'         <i class="%s" style="margin: 4px 4px;font-size: 16px;"></i>'
        +'     </div>'

        //    <!-- 第一行 ! -->
        +'     <div style="position:absolute;left:64px;right:10px;top:0px;height:20px;font-size: 16px;color: rgb(29, 33, 41);"><b>%s</b></div>'

        //    <!-- 第二行 ! -->
        +'     <div style="position:absolute;left:64px;right:10px;top:30px;height:20px;font-size: 14px;color:rgb(78, 89, 105);">%s</div> '

        //    <!-- 第三行 ! -->
        +'     <div style="position:absolute;left:64px;right:10px;top:70px;height:20px;font-size: 12px;color:rgb(134, 144, 156);">%s</div> '

        //    <!-- 图片 ! -->
        +'     <img style="%sobject-fit:cover;position:absolute;left:64px;right:10px;top:105px;height:60px;width:80px;" src="%s"></img>'
        +' </div>';
begin

    //取得配置
    joConfig    := flGetConfig(APanel);

    //
    sFull       := dwFullName(APanel);

    //
    sHTML       := '';

    //
    iTop    := 30;
    for iItem := 0 to joConfig.items._Count - 1 do begin
        //
        joItem  := joConfig.items._(iItem);

        //取得类型
        sType   := dwGetStr(joItem,'type','node');

        if sType = 'end' then begin
        end else if sType = 'node' then begin   //审批节点 =============================================================
            //取得当前状态
            sStatus     := dwGetStr(joItem,'status','none');

            //设置颜色和图标
            if sStatus = 'approved' then begin              //已通过
                sDefaultClr := 'rgb(0, 180, 42)';
                sIcon       := 'el-icon-check';
            end else if sStatus = 'approving' then begin    //审批中
                sDefaultClr := 'rgb(22, 93, 255)';
                sIcon       := 'el-icon-user-solid';
            end else if sStatus = 'pending' then begin      //待审批
                sDefaultClr := 'rgb(201, 205, 212)';
                sIcon       := 'el-icon-more';
            end else if sStatus = 'rejected' then begin
                sDefaultClr := 'rgb(255, 0, 0)';
                sIcon       := 'el-icon-close';
            end;

            //如果是图片, 则显示
            sImg    := '';
            if dwGetStr(joItem,'attach') <> '' then begin
                //取得扩展名
                sExt    := Lowercase(ExtractFileExt(joItem.attach));

                //
                if (sExt='.jpg') or (sExt='.png') then begin
                    sImg    := joItem.attach;
                end;
            end;

            //最后一个节点后, 不绘制下接线
            if iItem < joConfig.items._Count - 1 then begin
                if sImg = '' then begin
                    sLineH  := '100px';
                end else begin
                    sLineH  := '180px';
                end;
            end else begin
                sLineH  := '0';
            end;


            //L/T/W/H/line-height/radius
            if sImg = '' then begin
                sHtml   := sHtml + Format(_NODE,[
                        iTop
                        ,sLineH
                        ,sDefaultClr    //图标背景色
                        ,sIcon
                        ,dwGetStr(joItem,'title')
                        ,dwGetStr(joItem,'text')
                        ,dwGetStr(joItem,'datetime')
                        ,'display:none;'
                        ,''
                        ]);
                iTop        := iTop + 100 ;
            end else begin
                sHtml   := sHtml + Format(_NODE,[
                        iTop
                        ,sLineH
                        ,sDefaultClr    //图标背景色
                        ,sIcon
                        ,dwGetStr(joItem,'title')
                        ,dwGetStr(joItem,'text')
                        ,dwGetStr(joItem,'datetime')
                        ,''
                        ,'media/images/dwERPtim/'+joItem.file
                        ]);
                iTop        := iTop + 180;
            end;
        end;
    end;

    //
    dwRunJS('document.getElementById("'+sFull+'").innerHTML  = `'+sHtml+'`;',TForm(APanel.Owner));

end;


function flUpdate1(APanel:TPanel):Integer;
var
    iItem       : Integer;
    iCenter     : Integer;
    iW,iH,iR    : Integer;
    iTop        : Integer;
    iMV         : Integer;  //水平和垂直间隔
    iFontSize   : Integer;

    //
    sHtml       : String;
    sType       : String;
    sFull       : string;
    sBkColor    : string;
    sFontColor  : string;
    sCaption    : string;
    sStatus     : string;   //pending / approved / rejected / none
    sIcon       : string;
    cDefaultClr : TColor;   //默认背景色, 根据节点状态的不同

    //
    joConfig    : Variant;
    joItem      : Variant;
const
    _START  = '<div style="position:absolute;text-align:center;'
            +'background-color:%s;color:%s;font-size:%dpx;'
            +'left:%dpx;top:%dpx;width:%dpx;height:%dpx;line-height:%dpx;border-radius:%dpx;">%s</div>';
    _LINE   = '<div style="position:absolute;text-align:center;background-color:#2196F3;'
            +'left:%dpx;top:%dpx;width:2px;height:%dpx;"></div>';
    _NODE   = '<div style="position:absolute;'
            +'background-color:%s;color:%s;font-size:%dpx;'
            +'left:%dpx;top:%dpx;width:%dpx;height:%dpx;line-height:%dpx;border-radius:%dpx;">%s</div>';
    _END    = '<div style="position:absolute;text-align:center;'
            +'background-color:%s;color:%s;font-size:%dpx;'
            +'left:%dpx;top:%dpx;width:%dpx;height:%dpx;line-height:%dpx;border-radius:%dpx;">%s</div>';
    _ICON   = '<div style="position:absolute;left:10px;top:15px;width:30px;height:30px;width;30px;'
            +'border:solid 2px #fff;border-radius:50%;font-size: 22px;text-align: center;line-height: 30px;">';
begin
    //取得配置
    joConfig    := flGetConfig(APanel);

    //
    sFull       := dwFullName(APanel);

    //
    iCenter     := APanel.Width div 2;
    iTop        := dwGetInt(joConfig,'top',50);
    //
    iMv         := dwGetInt(joConfig,'marginvert',40);

    //
    sHTML       := '';

    for iItem := 0 to joConfig.items._Count - 1 do begin
        joItem  := joConfig.items._(iItem);

        //取得类型
        sType   := dwGetStr(joItem,'type','node');

        //
        if sType = 'end' then begin
            //取得基本外观值
            iW          := dwGetInt(joItem,'width',50);
            iH          := dwGetInt(joItem,'height',85);
            iR          := dwGetInt(joItem,'radius',iH div 2);
            sBkColor    := dwColorAlpha(dwGetColorFromJson(joItem.color,RGB(244,67,54)));           //背景色
            if joItem.Exists('font') then begin
                sFontColor  := dwColorAlpha(dwGetColorFromJson(joItem.font.color,RGB(255,255,255)));    //字体颜色
                iFontSize   := dwGetInt(joItem.font,'size',14);     //字号
            end else begin
                sFontColor  := '#FFF';
                iFontSize   := 14;
            end;
            sCaption    := dwGetStr(joItem,'caption','END');

            //L/T/W/H/line-height/radius
            sHtml   := sHtml + Format(_END,[
                    sBkColor,   //背景色
                    sFontColor, //字体颜色
                    iFontsize,  //字号
                    iCenter - iW div 2,iTop,iW,iH,iH,iR, sCaption]);

        end else if sType = 'node' then begin   //审批节点 =============================================================
            //取得当前状态
            sStatus     := dwGetStr(joItem,'status','none');

            //
            if sStatus = 'approved' then begin
                cDefaultClr := RGB(76, 175, 80);
                sIcon       := _ICON+'<i class="el-icon-check"></i></div>';
            end else if sStatus = 'pending' then begin
                cDefaultClr := RGB(144, 188, 245);   //RGB(255, 235, 59);
                sIcon       := _ICON+'<i class="el-icon-more"></i></div>';
            end else if sStatus = 'rejected' then begin
                cDefaultClr := RGB(244, 67, 54);
                sIcon       := _ICON+'<i class="el-icon-close"></i></div>';
            end else begin
                cDefaultClr := RGB(176, 190, 197);
                sIcon       := _ICON+'<i class="el-icon-full-screen"></i></div>';
                sIcon       := _ICON+'</div>';
            end;

            //取得基本外观值
            iW          := dwGetInt(joItem,'width',200);
            iH          := dwGetInt(joItem,'height',50);
            iR          := dwGetInt(joItem,'radius',5);
            sBkColor    := dwColorAlpha(dwGetColorFromJson(joItem.color,cDefaultClr));           //背景色
            if joItem.Exists('font') then begin
                sFontColor  := dwColorAlpha(dwGetColorFromJson(joItem.font.color,RGB(255,255,255)));    //字体颜色
                iFontSize   := dwGetInt(joItem.font,'size',14);     //字号
            end else begin
                sFontColor  := '#FFF';
                iFontSize   := 14;
            end;

            //

            sCaption    := sIcon + '<div style="position:absolute;left:60px;top:10px;right:10px;bottom:10px;">'+dwGetStr(joItem,'caption','')+'</div>';

            //L/T/W/H/line-height/radius
            sHtml   := sHtml + Format(_NODE,[
                    sBkColor,   //背景色
                    sFontColor, //字体颜色
                    iFontsize,  //字号
                    iCenter - iW div 2,iTop,iW,iH,Round(iFontSize * 1.5),iR, sCaption]);
            Inc(iTop,iH);

            //绘制 start 下接线
            sHtml   := sHtml  + Format(_LINE,[iCenter - 1,iTop,iMv]);
            Inc(iTop,iMv);
        end else if sType = 'start' then begin
            //取得基本外观值
            iW          := dwGetInt(joItem,'width',50);
            iH          := dwGetInt(joItem,'height',50);
            iR          := dwGetInt(joItem,'radius',iH div 2);
            sBkColor    := dwColorAlpha(dwGetColorFromJson(joItem.color,RGB(76,175,80)));           //背景色
            if joItem.Exists('font') then begin
                sFontColor  := dwColorAlpha(dwGetColorFromJson(joItem.font.color,RGB(255,255,255)));    //字体颜色
                iFontSize   := dwGetInt(joItem.font,'size',14);     //字号
            end else begin
                sFontColor  := '#FFF';
                iFontSize   := 14;
            end;
            sCaption    := dwGetStr(joItem,'caption','START');

            //L/T/W/H/line-height/radius
            sHtml   := Format(_START,[
                    sBkColor,   //背景色
                    sFontColor, //字体颜色
                    iFontsize,  //字号
                    iCenter - iW div 2,iTop,iW,iH,iH,iR, sCaption]);
            Inc(iTop,iH);

            //绘制 start 下接线
            sHtml   := sHtml  + Format(_LINE,[iCenter - 1,iTop,iMv]);
            Inc(iTop,iMv);

        end;
    end;

    //
    dwRunJS('document.getElementById("'+sFull+'").innerHTML  = `'+sHtml+'`;',TForm(APanel.Owner));

end;

function  flUpdateItems(AFQUpdate:TFDQuery; APrefix:String; AParent:TPanel;AItems:Variant;var ACount:Integer):Integer;
var
    iItem           : Integer;
    //
    sType           : String;       //元素的类型
    sTemp           : String;
    sPrefix         : String;       //子控件前缀
    //
    joItem          : Variant;
    joTemp          : Variant;
    //
    oForm           : TForm;
    oPanel          : TPanel;
    oLabel          : TLabel;
    oImage          : TImage;
    oMemo           : TMemo;
    //
    iRow            : Integer;
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
        if dwGetInt(joItem,'visible',1)<>1 then begin
            Continue;
        end;

        //取得节点type
        sType   := dwGetStr(joItem,'type','panel');

        //如果不需要更新,则跳过
        if sType <> 'panel' then begin
            if not joItem.Exists('update') then begin
                Continue;
            end else if not joItem.update.Exists('sql') then begin
                Continue;
            end;
        end;

        //
        if sType = 'bar' then begin
        end else if sType = 'start' then begin
            //------------ Image ---------------------------------------------------------------------------------------
            oImage  := TImage(oForm.FindComponent(APrefix+'BD'+IntToStr(ACount)));
            with oImage do begin
                AFQUpdate.Open(dwGetStr(joItem.update,'sql'));

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
            oLabel  := TLabel(oForm.FindComponent(APrefix+'BD'+IntToStr(ACount)));
            with oLabel do begin
                AFQUpdate.Open(dwGetStr(joItem.update,'sql'));

                if joItem.update.Exists('format') then begin
                    Caption := Format(dwGetStr(joItem.update,'format'),[AFQUpdate.Fields[0].AsString]);
                end else begin
                    Caption := AFQUpdate.Fields[0].AsString;
                end;
            end;
        end else if sType = 'line' then begin
            //------------ line ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(APrefix+'BD'+IntToStr(ACount)));
            with oMemo do begin
                AFQUpdate.Open(dwGetStr(joItem.update,'sql'));

                //先清除原数据
                joItem.option.xAxis.data        := _json('[]');
                joItem.option.series._(0).data  := _json('[]');
                //
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    AFQUpdate.RecNo := iRow;
                    //
                    joItem.option.xAxis.data.Add(AFQUpdate.Fields[0].AsString);
                    joItem.option.series._(0).data.Add(AFQUpdate.Fields[1].AsInteger);
                end;
                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'pie' then begin
            //------------ pie ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(APrefix+'BD'+IntToStr(ACount)));
            with oMemo do begin
                AFQUpdate.Open(dwGetStr(joItem.update,'sql'));

                //先清除原数据
                joItem.option.series._(0).data := _json('[]');
                //
                for iRow := 1 to AFQUpdate.RecordCount do begin
                    AFQUpdate.RecNo := iRow;
                    //
                    joTemp  := _json('{}');
                    joTemp.name     := AFQUpdate.Fields[0].AsString;
                    joTemp.value    := AFQUpdate.Fields[1].AsInteger;
                    //
                    joItem.option.series._(0).data.Add(joTemp);
                end;
                //
                Text    := 'option = '+dwJSONToJSObject(joItem.option)+';';

                //设置重绘
                ShowHint    := True;
            end;
        end else if sType = 'radar' then begin
            //------------ radar ---------------------------------------------------------------------------------------
            oMemo   := TMemo(oForm.FindComponent(APrefix+'BD'+IntToStr(ACount)));
            with oMemo do begin
                AFQUpdate.Open(dwGetStr(joItem.update,'sql'));

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
        end else begin
            //------------ Panel ---------------------------------------------------------------------------------------
            oPanel  := TPanel(oForm.FindComponent(APrefix+'BD'+IntToStr(ACount)));
            //
            if joItem.Exists('items') then begin
                flUpdateItems(AFQUpdate, sPrefix, oPanel, joItem.items, ACount);
            end;
        end;
    end;

end;


Procedure flTimer(Self: TObject; Sender: TObject); //OnTimer
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

    //
    sName       := TTimer(Sender).Name;
    sName       := StringReplace(sName,'__Timer','',[]);

    //取得当前面板控件
    oPanel      := TPanel(oForm.FindComponent(sName));

    //
    joConfig    := flGetConfig(oPanel);

	//取得前缀备用,默认为空
	sPrefix     := dwGetStr(joConfig,'prefix','');

    //找到查询表
    oFQUpdate   := TFDQuery(oPanel.FindComponent(sPrefix+'FQUpdate'));

    //
    iCount  := 0;
    flUpdateItems(oFQUpdate, sPrefix, oPanel, joConfig.items, iCount);
end;


function flGetConfig(APanel:TPanel):Variant;
begin
    try
        //取配置JSON : 读AForm的 flConfig 变量值
        Result  := dwJson(APanel.Hint);

        //流程top
        if not Result.Exists('top') then begin
            Result.top  := 50;
        end;

        //检查配置JSON对象是否有必须的子节点，如果没有，则补齐
        if not Result.Exists('items') then begin
            Result.items   := _json('[]');
        end;
    except

    end;
end;

function  flSetAlign(ACtrl:TControl;AItem:Variant):Integer;
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

function  flSetAlignment(ACtrl:TControl;AItem:Variant):Integer;
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

function  flSetBorder(ACtrl:TControl;AItem:Variant):Integer;
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


function  flSetFont(ACtrl:TControl;AItem:Variant):Integer;
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

function  flSetLTWH(ACtrl:TControl;AItem:Variant):Integer;
begin
    with TPanel(ACtrl) do begin
        if AItem.Exists('left') then begin
            Left    := dwGetInt(AItem,'left',0);
        end;
        if AItem.Exists('top') then begin
            Top     := dwGetInt(AItem,'top',0);
        end;
        if AItem.Exists('width') then begin
            Width   := dwGetInt(AItem,'width',200);
        end;
        if AItem.Exists('height') then begin
            Height  := dwGetInt(AItem,'height',100);
        end;
    end;
end;

function  flSetMargins(ACtrl:TControl;AItem:Variant):Integer;
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

function  flInitItems(AParent:TPanel;AItems:Variant;var ACount:Integer):Integer;
var
    iItem           : Integer;
    iStyle          : Integer;
    //
    sType           : String;       //元素的类型
    //
    joItem          : Variant;
    //
    oForm           : TForm;
    oPanel          : TPanel;
    oLabel          : TLabel;
begin
    //取得当前父窗体
    oForm       := TForm(AParent.Owner);

    //异常检查
    if AItems = null then begin
        Exit;
    end;

    //循环处理所有节点
    for iItem := 0 to AItems._Count - 1 do begin
        //取得当前节点JSON
        joItem  := AItems._(iItem);

        //如果为空, 则退出
        if joItem = null then begin
            Exit;
        end;

        //写
        Inc(ACount);

        //可见性
        if dwGetInt(joItem,'visible',1)<>1 then begin
            Continue;
        end;

        //
        sType   := dwGetStr(joItem,'type','panel');

        //
        if sType = 'arrowdown' then begin
            //------------ Panel ---------------------------------------------------------------------------------------
            oPanel  := TPanel.Create(oForm);
            with oPanel do begin
                Parent      := AParent;
                Name        := 'FL'+IntToStr(ACount);
                BevelOuter  := bvNone;
                HelpKeyword := 'div';   //表示为万能组件

                //
                dwSetProp(oPanel,'type','svg');

                //
                if joItem.Exists('dwchild') then begin
                    dwSetProp(oPanel,'dwchild',joItem.dwchild);
                end;

                //
                flSetAlign(oPanel,joItem);

                //
                flSetLTWH(oPanel,joItem);

                //
                flSetAlignment(oPanel,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oPanel,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                flSetBorder(oPanel,joItem);

                //
                flSetFont(oPanel,joItem);

                //
                flSetMargins(oPanel,joItem);

                //
                Color       := dwGetColorFromJson(joItem.color,clNone);

                //
                Caption     := dwGetStr(joItem,'caption','');

                //设置样式, http://datav.jiaminghi.com/guide/borderBox.html#dv-border-box-1
                iStyle      := dwGetInt(joItem,'style',0);
                if iStyle <> 0 then begin
                    HelpKeyword := 'dvBox';
                    helpContext := iStyle;
                end;

                if joItem.Exists('image') then begin
                    dwSetProp(oPanel,'dwchild','<img src="'+dwGetStr(joItem,'image','')+'" style="position:absolute;left:0;top:0;width:100%%;height:100%%;"/>');
                end;

                //
                if joItem.Exists('items') then begin
                    if joItem.items._kind = 2 then begin    //是数组
                        flInitItems(oPanel,joItem.items,ACount);
                    end;
                end;
            end;
        end else if sType = 'label' then begin
            //------------ Label ---------------------------------------------------------------------------------------
            oLabel  := TLabel.Create(oForm);
            with oLabel do begin
                Parent      := AParent;
                Name        := 'BD'+IntToStr(ACount);
                //
                AutoSize    := False;

                //
                flSetAlign(oLabel,joItem);

                //设置ltwm
                flSetLTWH(oLabel,joItem);

                //
                flSetAlignment(oLabel,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oLabel,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                flSetBorder(oLabel,joItem);

                //
                flSetFont(oLabel,joItem);

                //
                flSetMargins(oLabel,joItem);

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
        end else if sType = 'panel' then begin
            //------------ Panel ---------------------------------------------------------------------------------------
            oPanel  := TPanel.Create(oForm);
            with oPanel do begin
                Parent      := AParent;
                Name        := 'FL'+IntToStr(ACount);
                BevelOuter  := bvNone;

                //
                flSetAlign(oPanel,joItem);

                //
                flSetLTWH(oPanel,joItem);

                //
                flSetAlignment(oPanel,joItem);

                //额外的样式
                if joItem.Exists('dwstyle') then begin
                    dwSetProp(oPanel,'dwstyle',dwGetStr(joItem,'dwstyle',''));
                end;

                //
                flSetBorder(oPanel,joItem);

                //
                flSetFont(oPanel,joItem);

                //
                flSetMargins(oPanel,joItem);

                //
                Color       := dwGetColorFromJson(joItem.color,clNone);

                //
                Caption     := dwGetStr(joItem,'caption','');

                //设置样式, http://datav.jiaminghi.com/guide/borderBox.html#dv-border-box-1
                iStyle      := dwGetInt(joItem,'style',0);
                if iStyle <> 0 then begin
                    HelpKeyword := 'dvBox';
                    helpContext := iStyle;
                end;

                if joItem.Exists('image') then begin
                    dwSetProp(oPanel,'dwchild','<img src="'+dwGetStr(joItem,'image','')+'" style="position:absolute;left:0;top:0;width:100%%;height:100%%;"/>');
                end;

                //
                if joItem.Exists('items') then begin
                    if joItem.items._kind = 2 then begin    //是数组
                        flInitItems(oPanel,joItem.items,ACount);
                    end;
                end;
            end;
        end;
    end;
end;


function flInit(APanel:TPanel;AConnection:TFDConnection;AMobile:Boolean;AReserved:String):Integer;
type
    TdwGetEditMask  = procedure (Sender: TObject; ACol, ARow: Integer; var Value: string) of object;
    TdwEndDock      = procedure (Sender, Target: TObject; X, Y: Integer) of object;
var
    //
    joConfig    : variant;
    //
    sMainDir    : String;
    sPrefix     : String;
    //
    oForm       : TForm;

begin
    //默认返回值
    Result  := 0;

    try
        //为当前Panel赋一个特殊的数值，以方便各控件查找到该panel控件
        APanel.HelpContext  := 31031;

        //取得form备用
        oForm   := TForm(APanel.Owner);

        //取得配置json
        joConfig    := flGetConfig(APanel);

        //取得前缀备用,用以区分多个通用化工作流控件，默认为空
        sPrefix     := dwGetStr(joConfig,'prefix','');

        //取得当前目录备用
        sMainDir    := ExtractFilePath(Application.ExeName);

        //
        if joConfig.Exists('color') then begin
            APanel.Color    := dwGetColorFromJson(joConfig.color,clNone);
        end;

        //初始化工作流
        //flInitItems(APanel,joConfig.items,iCount);
        flUpdate(APanel);


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

    //
    if Result <> 0 then begin
        dwMessage('Error when FlowPanel at '+IntToStr(Result)+', gle = '+ IntToStr(GetLastError),'error',oForm);
    end;

end;

//销毁dwFlow，以便二次创建
function  flDestroy(APanel:TPanel):Integer;
var
    //
    iItem       : Integer;
begin
    try

        //
        for iItem := APanel.ControlCount - 1 downto 0 do begin
            APanel.Controls[iItem].Destroy;
        end;
    except

    end;
end;


end.
