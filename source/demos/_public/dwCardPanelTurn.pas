unit dwCardPanelTurn;

interface

uses
    dwBase,
    //dwCtrlBase,
    //第三方单元
    SynCommons,     //JSON解析单元，来自mormot
    //
    SysUtils,
    Variants,
    Forms,
    vcl.WinXPanels;

function dwctInit(APanel:TCardpanel):Integer;

implementation

//从JSON中读属性，如果不存在的话，取默认值
function dwGetInt(AJson:Variant;AName:String;ADefault:Integer):Integer;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            Result  := AJson._(AName);
        end;
    end;
end;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetDouble(AJson:Variant;AName:String;ADefault:Double):Double;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            Result  := AJson._(AName);
        end;
    end;
end;

//从JSON中读属性，如果不存在的话，取默认值
function dwGetStr(AJson:Variant;AName:String;ADefault:String):String;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            Result  := AJson._(AName);
        end;
    end;
end;

//从JSON中读以0/1表示的boolean属性，1返回true,否则返回false，取默认值
function dwGet01Bool(AJson:Variant;AName:String;ADefault:String):String;
begin
    Result  := ADefault;
    if AJson <> unassigned then begin
        if AJson.Exists(AName) then begin
            if AJson._(AName) = 1 then begin
                Result  := 'true';
            end else begin
                Result  := 'false';
            end;
        end;
    end;
end;


function dwctInit(APanel:TCardpanel):Integer;
var
    sJS     : String;
    oForm   : TForm;
    joHint  : Variant;
begin
    Result  := 0;
    try
        //取得HINT对象JSON
        joHint    := _Json(APanel.Hint);
        if joHint = unassigned then begin
            joHint  := _json('{}');
        end;

        sJS     :=
                '$("#'+dwFullName(APanel)+'").turn({'
                    +'width: '+IntToStr(APanel.Width)+','
                    +'height: '+IntToStr(APanel.Height)+','
                    +'acceleration: '+dwGet01Bool(joHint,'acceleration','true')+','
                    +'autoCenter: '+dwGet01Bool(joHint,'autocenter','false')+','
                    +'direction: "'+dwGetStr(joHint,'direction','ltr')+'",'
                    +'display: "'+dwGetStr(joHint,'display','double')+'",'
                    +'gradients: '+dwGet01Bool(joHint,'gradients','true')+','
                    +'pages: '+IntToStr(APanel.CardCount)+','
                    +'disable: '+dwGet01Bool(joHint,'disable','false')
                +'});';
        dwRunJS(sJS,TForm(APanel.owner));
    except
        Result  := -1;
    end;
end;


end.
