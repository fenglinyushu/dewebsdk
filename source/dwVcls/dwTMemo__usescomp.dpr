library dwTMemo__usescomp;
{
功能说明：
    该控件仅用于增加控件必须引用的JS/css
用法：
    在设计阶段把需要引用的控件类名(包括Helpkeyword,注意是2个下划线)分行写入到Memo的Lines中
    如：
    TStringGrid
    TMemo__echarts

}
uses
     ShareMem,

     //
     dwCtrlBase,

     //
     SynCommons,


     //
     SysUtils,
     Classes,
     Dialogs,
     Windows,
     Controls,
     Variants,
     Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Forms;

//==================================================================================================

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
type
    PdwGetExtra = function (ACtrl:TComponent):string;stdcall;
var
    joRes       : Variant;
    joArray     : Variant;
    //
    I           : Integer;
    iHandle     : THandle;
    iArray      : Integer;
    //
    sComp       : string;
    sDll        : string;
    sDir        : string;
    sExtra      : string;
    //
    oGetExtra   : PdwGetExtra;
begin
    sDir        := ExtractFilePath(Application.ExeName)+'vcls\';
    with TMemo(Actrl) do begin
        //生成返回值数组
        joRes    := _Json('[]');

        //需要额外引的代码
        for I := 0 to Lines.Count-1 do begin
            //得到控件的DeWeb类名，如TMemo__Echarts
            sComp   := Lines[I];

            //转换为DLL名，加上路径
            sDll    := sDir + 'dw' + sComp+'.dll';

            //如果文件存在
            if FileExists(sDll) then begin
                //载入
                iHandle := LoadLibrary(PWideChar(sDll));

                //
                if iHandle > 0 then begin
                    //取得函数
                    oGetExtra   := GetProcAddress(iHandle,'dwGetExtra');

                    if Assigned(oGetExtra) then begin
                        //得到额外的字符串
                        sExtra      := oGetExtra(ACtrl);

                        //将字符串转为JSON数组
                        joArray     := _json(sExtra);

                        //异常处理
                        if joArray = unassigned then begin
                            joArray   := _json('[]');
                        end;

                        //复制到slExtr
                        for iArray := 0 to joArray._Count-1 do begin
                            joRes.Add(joArray._(iArray));
                        end;
                    end;
                end;

                FreeLibrary(iHandle);
            end;
        end;
        //
        Result    := joRes;

    end;
end;

function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
begin
end;

function dwGetHead(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

function dwGetTail(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

function dwGetData(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

function dwGetAction(ACtrl:TComponent):String;StdCall;
begin
    Result  := '[]';
end;

exports
    dwGetExtra,
    dwGetEvent,
    dwGetHead,
    dwGetTail,
    dwGetAction,
    dwGetData;

begin
end.
 
