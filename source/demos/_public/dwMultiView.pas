unit dwMultiView;
{
模块功能说明：
该模块用于根据数据表数据，自动生成类似ListView效果
}

interface

uses
    //用于
    SynCommons,

    //用于克隆的单元
    CloneComponents,

    //
    ADODB,DB,
    Math,
    Types, Vcl.Samples.Spin,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Grids;

//根据数据表数据，自动生成类似ListView效果
//ADataSet : 数据集控件，如ADOQuery1,ADOQTable3等
//ADemoPanel : TPanel 是用于显示单条记录的面板控件，各具体数据在其中显示，其父类也就为一个Panel
//AConfig ：为用于进行设置的JSON格式字符串,基本如下：
//{
//    "items":[
//        {"field":"name","type":"string","format":"","component":"Label_Name"},
//        {"field":"id","type":"integer","format":"%.4d","component":"Label_ID"},
//        {"field":"salary","type":"float","format":"%.2f","component":"Label_Salary"},
//        {"field":"birthday","type":"datetime","format":"YYYY-MM-DD","component":"Label_Birthday"},
//        {"field":"sex","type":"boolean","format":["男","女"],"component":"Label_Birthday"},
//        {"field":"picture","type":"image","format":"media/images/dwms/","component":"Image_Photo"}
//    ]
//}
function dwDataToViews(
        ADataSet : TDataSet;
        ADemoPanel : TPanel;
        AConfig : String):Integer;

implementation

function dwDataToViews(
        ADataSet : TDataSet;
        ADemoPanel : TPanel;
        AConfig : String):Integer;
var
    joConfig    : Variant;
    joItem      : Variant;
    //
    iItem       : Integer;
    iParentW    : Integer;
    iParentH    : Integer;
    iW,iH       : Integer;
    iL,iT       : Integer;
    iLOld       : Integer;      //用于保存原始的左边框
    iSpace      : Integer;      //水平间距
    iHCount     : Integer;      //水平个数
    iNO         : Integer;      //序号，用于控制每行个数
    //
    oParent     : TPanel;       //当前 ADemoPanel的父控件
    oForm       : TForm;        //当前窗体
    oNew        : TComponent;

    //
    sClass      : string;
    sName       : string;
    sText       : string;
    fValue      : Double;
    iValue      : Integer;

    procedure UpdateValue(AValue:Variant);
    begin
        if joItem.classname = 'TLabel' then begin
            TLabel(oNew).Caption    := String(AValue);
        end else if joItem.classname = 'TButton' then begin
            TButton(oNew).Caption   := String(AValue);
        end else if joItem.classname = 'TComboBox' then begin
            TComboBox(oNew).Text    := String(AValue);
        end else if joItem.classname = 'TEdit' then begin
            TEdit(oNew).Text        := String(AValue);
        end else if joItem.classname = 'TSpinEdit' then begin
            TSpinEdit(oNew).Value   := Integer(AValue);
        end;
    end;
begin
    //默认返回值
    Result  := 0;

    //取得当前一些对象备用
    oParent := TPanel(ADemoPanel.Parent);
    oForm   := TForm(ADemoPanel.Owner);

    //<---先检查Aconfig字符串的合法性
    //主要包括：
    //1 是不是合法的JSON字符串
    //2 是不是包括相应的属性：items,field,component,其中： type默认为string,format默认为空,

    //1 是不是合法的JSON字符串
    joConfig    := _JSON(AConfig);
    if joConfig = unassigned then begin
        Result  := -1;
        Exit;
    end;

    //2 是不是包括相应的属性：items,field,component,其中： type默认为string,format默认为空,
    if not joConfig.Exists('items') then begin
        Result  := -2;
        Exit;
    end;
    for iItem := 0 to joConfig.items._Count-1 do begin
        joItem  := joConfig.items._(iItem);
        if not (joItem.Exists('field') and joItem.Exists('component')) then begin
            Result  := -3;
            Exit;
        end;

        //取得克隆源控件的类型,备用
        joItem.classname    := oForm.FindComponent(joItem.component).ClassName;

        //设置默认值
        if not joItem.Exists('type')  then begin
            joItem.type := '';
        end;
        if not joItem.Exists('format')  then begin
            joItem.format   := '';
        end;
    end;
    //>---

    //<---先清空可能存在的以前克隆的控件
    for iItem := oParent.ControlCount-1 downto 0 do begin
        if oParent.Controls[iItem] <> ADemoPanel then begin
            oParent.Controls[iItem].Destroy;
        end;
    end;
    //>

    //取得一些初始化位置相关参数
    iT  := ADemoPanel.Margins.Top + ADemoPanel.Margins.Bottom;
    iW  := ADemoPanel.Width  + ADemoPanel.Margins.Left + ADemoPanel.Margins.Right;
    iH  := ADemoPanel.Height + ADemoPanel.Margins.Top  + ADemoPanel.Margins.Bottom;
    iHCount := Max(1,oParent.Width div iW);    //水平可放置的个数
    if joConfig.align = 1 then begin
        iSpace  := (oParent.Width - ADemoPanel.Margins.Left - iHCount * ADemoPanel.Width) div iHCount;
        iL      := ADemoPanel.Margins.Left;
    end else begin
        if oParent.Width >= iHCount * iW + ADemoPanel.Margins.Left + ADemoPanel.Margins.Right then begin
            iSpace  := (oParent.Width - iHCount * ADemoPanel.Width) div (iHCount + 1);
            iL      := iSpace;
        end else begin
            iSpace  := (oParent.Width - iHCount * ADemoPanel.Width) div iHCount;
            iL      := iSpace div 2;
        end;
    end;
    iLOld   := iL;


    //<---根据数据表记录创建控件
    //先置母版控件不可视
    ADemoPanel.Visible  := False;
    //
    ADataSet.First;
    iNo := 1;
    while not ADataSet.Eof do begin
        //克隆面板
        with TPanel(CloneComponent(ADemoPanel)) do begin
            Visible     := True;
            //Align       := alNone;
            Parent      := oParent;
            //
            if Align = alNone then begin
                Left        := iL;
                Top         := iT;
            end else if Align = alTop then begin
                Top         := iNO * 9999;;
            end;
        end;

        //克隆每个子控件
        for iItem := 0 to joConfig.items._Count-1 do begin
            joItem  := joConfig.items._(iItem);
            //新创建的控件名称
            sName   := joItem.Component+IntToStr(iNo);
            oNew    := oForm.FindComponent(sName);
            oNew.Tag    := iNo; //保留记录号以备用
            //
            if (joItem.type='') or (joItem.type='string') then begin
                //得到数据库字段值
                sText   := ADataSet.FieldByName(joItem.field).AsString;
                //进行format变换
                if joItem.format <> '' then begin
                    sText   := Format(joItem.format,[sText]);
                end;
                //为新控件赋值
                UpdateValue(sText);
            end else if (joItem.type='image') then begin
                //得到数据库字段值
                sText   := ADataSet.FieldByName(joItem.field).AsString;
                //进行format变换
                if joItem.format <> '' then begin
                    sText   := Format(joItem.format,[sText]);
                end;
                //
                TImage(oNew).Hint   := '{"src":"'+sText+'"}';
            end else if (joItem.type='boolean') then begin
                //得到数据库字段值
                if ADataSet.FieldByName(joItem.field).AsBoolean then begin
                    sText   := joItem.format._(0);
                end else begin
                    sText   := joItem.format._(1);
                end;

                //为新控件赋值
                UpdateValue(sText);
            end else if (joItem.type='float') then begin
                //得到数据库字段值
                fValue  := ADataSet.FieldByName(joItem.field).AsFloat;
                //进行format变换
                sText   := FloatToStr(fValue);
                if joItem.format <> '' then begin
                    sText   := Format(joItem.format,[fValue]);
                end;
                //为新控件赋值
                UpdateValue(sText);
            end else if (joItem.type='integer') then begin
                //得到数据库字段值
                iValue  := ADataSet.FieldByName(joItem.field).AsInteger;
                //进行format变换
                sText   := IntToStr(iValue);
                if joItem.format <> '' then begin
                    sText   := Format(joItem.format,[iValue]);
                end;
                //为新控件赋值
                UpdateValue(sText);
            end;
        end;

        //
        Inc(iNo);
        //计算下一个控件的位置
        if (iNO-1) mod iHCount = 0 then begin
            iL      := iLOld;
            iT      := iT + iH;
        end else begin
            iL      := iL + iSpace+ADemoPanel.Width;
        end;
        //
        ADataSet.Next;
    end;
    //>---

    //
    oParent.Height  := iT + iH - ADemoPanel.Margins.Top;
end;
end.
