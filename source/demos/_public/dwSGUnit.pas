unit dwSGUnit;

interface

uses
     //
     dwBase,
     SynCommons,


     //
     GraphUtil,
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, vcl.Imaging.jpeg, ExtCtrls,Vcl.Grids;

//在最后添加一行
function dwSGAddRow(ASG:TStringGrid):Integer;

//删除最后一行
function dwSGDelRow(ASG:TStringGrid):Integer;

//设置单元格样式
function dwSGSetCellStyle(
        ASG:TStringGrid;
        ARow,ACol:Integer;
        BackGroundColor:TColor;
        FontName : String;
        FontSize : Integer;
        FontBold : Boolean;
        FontItalic : Boolean;
        FontColor : TColor
        ):Integer;

//设置行颜色
function dwSGSetRow(
        ASG:TStringGrid;
        ARow:Integer;
        BackGroundColor:TColor;
        FontColor:TColor
        ):Integer;

//设置列颜色
function dwSGSetCol(
        ASG:TStringGrid;
        ACol:Integer;
        BackGroundColor:TColor;
        FontColor:TColor
        ):Integer;

//选中某行
function dwSGSetRowChecked(
        ASG:TStringGrid;
        ARow:Integer;
        Checked:Boolean
        ):Integer;

//取得某行选中状态
function dwSGGetRowChecked(
        ASG:TStringGrid;
        ARow:Integer):Boolean;

implementation

function _GetForm(ASG:TStringGrid):TForm;
begin
    Result  := TForm(ASG.Owner);
    if Result.Owner <> nil then begin
        if lowerCase(Result.Owner.ClassName) = 'tform1' then begin
            Result  := TForm(Result.Owner);
        end;
    end;
end;

//取得某行选中状态
function dwSGGetRowChecked(
        ASG:TStringGrid;
        ARow:Integer):Boolean;
var
    iArray  : Integer;
    joHint  : Variant;
begin
    Result  := False;
    //更新选中信息
    joHint  := _json(ASG.Hint); //取得原信息
    if joHint.Exists('__selection') then begin
        //依次检查选中的项
        for iArray := 0 to joHint.__selection._Count-1 do begin
            if joHint.__selection._(iArray) = IntToStr(AROw) then begin
                Result  := True;
                break;
            end;;
        end;
    end;
end;



//选中某行
function dwSGSetRowChecked(
        ASG:TStringGrid;
        ARow:Integer;
        Checked:Boolean
        ):Integer;
var
    iArray  : Integer;
    joHint  : Variant;
begin
    //更新选中信息
    joHint  := _json(ASG.Hint); //取得原信息
    //异常处理
    if joHint = unassigned then begin
        joHint  := _json('{}');
    end;
    //先清除原可能存在的项
    if joHint.Exists('__selection') then begin
        for iArray := 0 to joHint.__selection._Count-1 do begin
            if joHint.__selection._(iArray) = IntToStr(AROw) then begin
                joHint.__selection.Delete(iArray);
                break;
            end;;
        end;
    end else begin
        joHint.__selection  := _json('[]');
    end;
    //如果当前操作为选中，则添加
    if Checked then begin
        joHint.__selection.Add(IntToStr(ARow));
        ASG.Hint    := joHint;
    end;

    //在界面是选中/取消选中
    dwRunJS('this.$refs.'+dwFullName(ASG)+'.toggleRowSelection'
            +'(this.'+dwFullName(ASG)+'__ces['+(ARow-1).ToString+'],'+dwBoolToStr(Checked)+');'
            ,_GetForm(ASG));
end;


function dwSGAddRow(ASG:TStringGrid):Integer;
begin
     ASG.RowCount   := ASG.RowCount + 1;
     dwRunJS('var list = {};this.'+dwFullName(ASG)+'__ces.push(list);',_GetForm(ASG));
     //
     Result    := 0;
end;

function dwSGDelRow(ASG:TStringGrid):Integer;
begin
     if ASG.RowCount>1 then begin
          ASG.RowCount   := ASG.RowCount - 1;
          dwRunJS('this.'+dwFullName(ASG)+'__ces.splice('+IntToStr(ASG.RowCount-1)+', 1);',_GetForm(ASG));
          //
          Result    := 0;
     end else begin
          //
          Result    := -1;
     end;
end;

//设置单元格样式
function dwSGSetCellStyle(
          ASG : TStringGrid;
          ARow,ACol : Integer;
          BackGroundColor : TColor;
          FontName : String;
          FontSize : Integer;
          FontBold : Boolean;
          FontItalic : Boolean;
          FontColor : TColor
          ):Integer;
var
     sJS       : String;
begin
     sJS  := 'dwSGSetStyle('
          +''''+dwFullName(ASG)+''','
          +IntToStr(ARow)+','
          +IntToStr(ACol)+','
          +'{'
               +'backgroundColor:'''+dwColorAlpha(BackGroundColor)+' !important'','
               +'fontFamily:'''+FontName+''','
               +'fontSize: '''+IntToStr(FontSize)+'px'','
               +'fontWeight: '''+dwIIF(FontBold,'bold','')+''','
               +'fontStyle: '''+dwIIF(FontItalic,'italic','')+''','
               +'color: '''+dwColorAlpha(FontColor)+''''
          +'});';
     dwRunJS(sJS,_GetForm(ASG));
     //
     Result    := 0;
end;

//设置行颜色
function dwSGSetRow(
          ASG:TStringGrid;
          ARow:Integer;
          BackGroundColor:TColor;
          FontColor:TColor
          ):Integer;
var
     sJS  : String;
begin
     sJS  := 'dwSGSetRow('
          +''''+dwFullName(ASG)+''','
          +IntToStr(ARow)+','
          +'{'
               +'backgroundColor:'''+dwColorAlpha(BackGroundColor)+''','
               +'color: '''+dwColorAlpha(FontColor)+''''
          +'});';
     dwRunJS(sJS,_GetForm(ASG));
     //
     Result    := 0;
end;

//设置列颜色
function dwSGSetCol(
          ASG:TStringGrid;
          ACol:Integer;
          BackGroundColor:TColor;
          FontColor:TColor
          ):Integer;

var
     sJS  : String;
begin
     sJS  := 'dwSGSetCol('
          +''''+dwFullName(ASG)+''','
          +IntToStr(ACol)+','
          +'{'
               +'backgroundColor:'''+dwColorAlpha(BackGroundColor)+''','
               +'color: '''+dwColorAlpha(FontColor)+''''
          +'});';
     dwRunJS(sJS,_GetForm(ASG));
     //
     Result    := 0;
end;

end.
