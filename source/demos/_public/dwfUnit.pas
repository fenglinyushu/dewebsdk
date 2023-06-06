unit dwfUnit;
{
本单元用于保存jxc系统用到的公用函数
}

interface

uses
    //
    Graphics, Math,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, Vcl.Buttons;


//对Panel内的控件按TabOrder顺序进行水平等分排列
//要求：
//1 全自动根据Margins属性进行控制，不管AlignWithMargins是否为真，需要先设置了Magins
//2 子控件必须有TabOrder属性，如TPanel,TButton, 不能是TSpeedButton(可以在外面包一层TPanel)
//3 控件的Margins的left/right, Top/Bottom尽量保持一致
function dwfAlignHorz(AParent:TPanel):Integer;

//对Panel内的控件按TabOrder顺序分成几行进行水平等分排列 ，ARowCount为行数，大于等于1
//要求：
//1 全自动根据Margins属性进行控制，不管AlignWithMargins是否为真，需要先设置了Magins
//2 子控件必须有TabOrder属性，如TPanel,TButton, 不能是TSpeedButton(可以在外面包一层TPanel)
//3 控件的Margins的left/right, Top/Bottom尽量保持一致
function dwfAlignHorzPro(AParent:TPanel;ARowCount:Integer):Integer;

//对Panel内的控件按TabOrder顺序进行水平等分排列 ，AColCount为每行的项目数，大于等于1
//要求：
//1 全自动根据Margins属性进行控制，不管AlignWithMargins是否为真，需要先设置了Magins
//2 子控件必须有TabOrder属性，如TPanel,TButton, 不能是TSpeedButton(可以在外面包一层TPanel)
//3 控件的Margins的left/right, Top/Bottom尽量保持一致
function dwfAlignHorzColPro(AParent:TPanel;AColCount:Integer):Integer;


//对Panel内的控件按TabOrder顺序进行垂直等分排列
//要求：
//1 全自动根据Margins属性进行控制，不管AlignWithMargins是否为真，需要先设置了Magins
//2 子控件必须有TabOrder属性，如TPanel,TButton, 不能是TSpeedButton(可以在外面包一层TPanel)
//3 控件的Margins的left/right, Top/Bottom尽量保持一致
function dwfAlignVert(AParent:TPanel):Integer;

implementation

function dwfAlignHorz(AParent:TPanel):Integer;
var
    iItem   : Integer;
    iWidth  : Integer;
begin
    //<异常检测
    //如果子控件为0，则退出
    if AParent.ControlCount = 0 then begin
        Exit;
    end;
    //>

    //对子控件进行处理
    iWidth  := (AParent.Width  - AParent.Controls[AParent.ControlCount-1].Margins.Right) div AParent.ControlCount;
    for iItem := 0 to AParent.ControlCount-1 do begin
        with TPanel(AParent.Controls[iItem]) do begin
            Align   := alNone;
            Left    := TabOrder * iWidth + Margins.Left;
            Width   := iWidth - Margins.Left;
            Top     := Margins.Top;
            Height  := AParent.Height - Margins.Top - Margins.Bottom;
        end;
    end;
end;

function dwfAlignHorzPro(AParent:TPanel;ARowCount:Integer):Integer;
var
    iItem   : Integer;
    iWidth  : Integer;
    iCount  : Integer;
    iHeight : Integer;
    iRow    : Integer;
    iCol    : Integer;
    iLeft   : Integer;
    iTop    : Integer;
begin
    //<异常检测
    //如果子控件为0，则退出
    if AParent.ControlCount = 0 then begin
        Exit;
    end;
    //>

    //控制行数
    if ARowCount<1 then begin
        ARowCount   := 1;
    end;

    //取得每行个数
    iCount  := AParent.ControlCount;
    iCount  := Ceil(iCount / ARowCount);

    //取得每个控件的宽度(此处要求每个子控件的Margins.Left和right相同)
    iWidth  := (AParent.Width  - AParent.Controls[0].Margins.Right) div iCount;

    //取得每个控件的高度(含上下margins)
    iHeight := (AParent.Height  - AParent.Controls[0].Margins.Bottom) div ARowCount;
    //iHeight := iHeight - AParent.Controls[0].Margins.Top - AParent.Controls[0].Margins.Bottom

    //对子控件进行处理
    for iItem := 0 to AParent.ControlCount-1 do begin
        with TPanel(AParent.Controls[iItem]) do begin
            //得出行和列
            iRow    := TabOrder div iCount;
            iCol    := TabOrder mod iCount;
            //设置LTWH
            Align   := alNone;
            Left    := iCol * iWidth + Margins.Left;
            Width   := iWidth - Margins.Left - Margins.Right;
            Top     := iRow * iHeight + Margins.Top;
            Height  := iHeight - Margins.Top - Margins.Bottom;
        end;
    end;
end;

function dwfAlignHorzColPro(AParent:TPanel;AColCount:Integer):Integer;
var
    iItem   : Integer;
    iWidth  : Integer;
    iRCount : Integer;
    iHeight : Integer;
    iRow    : Integer;
    iCol    : Integer;
    iLeft   : Integer;
    iTop    : Integer;

    iMLeft      : Integer;
    iMTop       : Integer;
    iMRight     : Integer;
    iMBottom    : Integer;
begin
    //<异常检测
    //如果子控件为0，则退出
    if AParent.ControlCount = 0 then begin
        Exit;
    end;
    //>

    //控制行数
    if AColCount<1 then begin
        AColCount   := 1;
    end;

    //取得总行数
    iRCount  := AParent.ControlCount;
    iRCount  := Ceil(iRCount / AColCount);

    //
    iMLeft      := AParent.Controls[0].Margins.Left;
    iMTop       := AParent.Controls[0].Margins.Top;
    iMRight     := AParent.Controls[0].Margins.Right;
    iMBottom    := AParent.Controls[0].Margins.Bottom;

    //取得每个控件的宽度(此处要求每个子控件的Margins.Left和right相同)
    iWidth  := (AParent.Width  - AParent.Controls[0].Margins.Right) div AColCount;

    //取得每个控件的高度(含上下margins)
    iHeight :=  AParent.Controls[0].Margins.Top + AParent.Controls[0].Height + AParent.Controls[0].Margins.Bottom;
    //iHeight := iHeight - AParent.Controls[0].Margins.Top - AParent.Controls[0].Margins.Bottom

    //对子控件进行处理
    for iItem := 0 to AParent.ControlCount-1 do begin
        with TPanel(AParent.Controls[iItem]) do begin
            //得出行和列
            iRow    := TabOrder div AColCount;
            iCol    := TabOrder mod AColCount;
            //设置LTWH
            Align   := alNone;
            Left    := iCol * iWidth + iMLeft;
            Width   := iWidth - iMLeft - iMRight;
            Top     := iRow * iHeight + iMTop;
            Height  := iHeight - iMTop - iMBottom;
        end;
    end;
end;

function dwfAlignVert(AParent:TPanel):Integer;
var
    iItem   : Integer;
    iHeight : Integer;
begin
    //<异常检测
    //如果子控件为0，则退出
    if AParent.ControlCount = 0 then begin
        Exit;
    end;
    //>

    //对子控件进行处理
    iHeight := (AParent.Height - AParent.Controls[AParent.ControlCount-1].Margins.Bottom) div AParent.ControlCount;
    for iItem := 0 to AParent.ControlCount-1 do begin
        with TPanel(AParent.Controls[iItem]) do begin
            Align   := alNone;
            Top     := TabOrder * iHeight + Margins.Top;
            Width   := AParent.Width - Margins.Left - Margins.Right;
            Left    := Margins.Left;
            Height  := iHeight - Margins.Top;
        end;
    end;
end;

end.
