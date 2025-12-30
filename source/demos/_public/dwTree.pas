unit dwTree;

interface

uses
    SynCommons,

    //
    Variants,
    Vcl.ComCtrls,Vcl.ExtCtrls,Windows;

function dtGetCurrJsonNode(ATV:TTreeView;AJson:Variant;ARes : Variant):Integer;

function dtGetCurrTreeNode(ATV:TTreeView):TTreeNode;

implementation

function dtGetCurrTreeNode(ATV:TTreeView):TTreeNode;
begin
    try
        Result  := nil;

        //异常处理
        if ATV.Items.Count = 0 then begin
            Exit;
        end;

        //预处理
        if ATV.Selected = nil then begin
            ATV.Items[0].Selected   := True;
        end;

        //
        Result  := ATV.Selected;
    except

    end;
end;

function dtGetCurrJsonNode(ATV:TTreeView;AJson:Variant;ARes : Variant):Integer;
var
    joIndexs    : Variant;
    tnCurr      : TTreeNode;
    iItem       : Integer;
    iIndex      : Integer;
begin
    try
        Result  := 0;
        ARes    := unassigned;

        //异常处理
        if ATV.Items.Count = 0 then begin
            Exit;
        end;
        if AJson = unassigned then begin
            Exit;
        end;

        //预处理
        if ATV.Selected = nil then begin
            ATV.Items[0].Selected   := True;
        end;
        if not AJson.Exists('items') then begin
            AJson.items := _json('[]');
        end;

        //
        tnCurr  := ATV.Selected;
        joIndexs    := _json('[]');
        while tnCurr.Level > 0 do begin
            joIndexs.Add(tnCurr.Index);
            tnCurr  := tnCurr.Parent;
        end;

        //先取第一层
        iIndex  := joIndexs._(joIndexs._Count - 1);
        ARes    := AJson.items._(iIndex);

        //
        for iItem := joIndexs._Count - 2 downto 0 do begin
            iIndex  := joIndexs._(iItem);
            ARes    := ARes.items._(iIndex);
        end;
    except
        Result  := -1;
    end;
end;

end.
