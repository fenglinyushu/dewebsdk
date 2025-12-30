unit dwHistory;

interface

uses
    dwBase,

    //第三方单元
    SynCommons,     //JSON解析单元，来自mormot


    //系统单元
    Variants,
    //
    Vcl.WinXPanels, //TCarPanel
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup;

//移动端开发时, 当需要弹出面板时, 执行当前操作
//AForm     为当前窗体,一般用self即可
//AVisible  为弹出面板前可见,弹出面板后不可见的控件, 用于返回时, 自动显示该控件
//AHidden   为弹出面板前不可见,弹出面板后可见的控件, 用于返回时, 自动隐藏该控件, 与 AVisible 正好相反
//ACaption  为弹出面板前的标题, 弹出面板前后标题不改变, 则可以不填该项
//注:  AVisible / AHidden 中不填入 弹出面板前后 可见性不变的控件
function  dwAddShowHistory(AForm:TForm;AVisible : array  of TControl;AHidden:array  of TControl; const ACaption : String = '_none_'):Integer;

//移动端开发时, 当需要打开功能模块(新建一个页面)时, 执行当前操作
//AForm     为当前窗体,一般用self即可
function  dwAddFormHistory(AForm:TForm):Integer;

//移除最后一条记录(在非回退操作, 隐藏面板后, 必须操作)
function  dwRemoveLastHistory(AForm:TForm):Integer;

implementation  //======================================================================================================

uses
    Unit1;

//移除最后一条记录
function  dwRemoveLastHistory(AForm:TForm):Integer;
begin
    //浏览器中的历史记录
    dwhistoryBack(dwGetForm1(AForm));
    with TForm1(dwGetForm1(AForm)) do begin
        //标记最后一条记录为空记录
        if gjoHistory._Count > 0 then begin
            gjoHistory._(gjoHistory._Count - 1).isnull  := 1;
        end;
    end;
end;


function  dwAddFormHistory(AForm:TForm):Integer;
var
    oForm1      : TForm1;
    joHistory   : Variant;
    iCtrl       : Integer;
begin
    Result  := 0;

    try
        //取得主窗体Form1备用
        oForm1      := TForm1(dwGetForm1(AForm));

        //浏览器中的历史记录
        dwHistoryPush(oForm1);

        //生成当前浏览器历史记录JSON变量
        joHistory           := _json('{}');
        joHistory.type      := 'page';
        if oForm1.FindComponent('CP') <> nil then begin
            joHistory.oldindex  := TCardPanel(oForm1.FindComponent('CP')).ActiveCardIndex;
        end;

        //检查gjoHistory数组是否创建
        if oForm1.gjoHistory = unassigned then begin
            oForm1.gjoHistory  := _json('[]');
        end;

        //添加到记录中
        oForm1.gjoHistory.Add(joHistory);
    except
        Result  := -1;
    end;

end;


function  dwAddShowHistory(AForm:TForm;AVisible : array  of TControl;AHidden:array  of TControl; const ACaption : String = '_none_'):Integer;
var
    oForm1      : TForm1;
    joHistory   : Variant;
    iCtrl       : Integer;
begin
    Result  := 0;

    try
        //取得主窗体Form1备用
        oForm1      := TForm1(dwGetForm1(AForm));

        //浏览器中的历史记录
        dwHistoryPush(oForm1);

        //生成当前浏览器历史记录JSON变量
        joHistory           := _json('{}');

        //设置类型
        joHistory.type      := 'control';

        //设置窗体名称
        joHistory.form      := AForm.Name;

        //设置  弹出面板前可见,弹出面板后不可见的控件
        if Length(AVisible) > 0 then begin
            joHistory.visible   := _json('[]');
            for iCtrl := 0 to Length(AVisible) - 1 do begin
                joHistory.visible.Add(AVisible[iCtrl].Name);
            end;
        end;
        //设置  弹出面板前不可见,弹出面板后可见的控件
        if Length(Ahidden) > 0 then begin
            joHistory.hidden   := _json('[]');
            for iCtrl := 0 to Length(Ahidden) - 1 do begin
                joHistory.hidden.Add(Ahidden[iCtrl].Name);
            end;
        end;

        //弹出面板前的标题
        if ACaption <> '_none_' then begin
            joHistory.caption   := ACaption;
        end;


        //检查gjoHistory数组是否创建
        if oForm1.gjoHistory = unassigned then begin
            oForm1.gjoHistory  := _json('[]');
        end;

        //添加到记录中
        oForm1.gjoHistory.Add(joHistory);
    except
        Result  := -1;
    end;
end;

end.
