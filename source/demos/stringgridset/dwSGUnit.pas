unit dwSGUnit;

interface

uses
     //
     dwBase,


     //
     GraphUtil,
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, jpeg, ExtCtrls,Vcl.Grids;

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

implementation

function dwSGAddRow(ASG:TStringGrid):Integer;
begin
     ASG.RowCount   := ASG.RowCount + 1;
     dwRunJS('var list = {};this.'+ASG.Name+'__ces.push(list);',TForm(ASG.Owner));
     //
     Result    := 0;
end;

function dwSGDelRow(ASG:TStringGrid):Integer;
begin
     if ASG.RowCount>1 then begin
          ASG.RowCount   := ASG.RowCount - 1;
          dwRunJS('this.'+ASG.Name+'__ces.splice('+IntToStr(ASG.RowCount-1)+', 1);',TForm(ASG.Owner));
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
          +''''+ASG.Name+''','
          +IntToStr(ARow)+','
          +IntToStr(ACol)+','
          +'{'
               +'backgroundColor:'''+ColorToWebColorStr(BackGroundColor)+''','
               +'fontFamily:'''+FontName+''','
               +'fontSize: '''+IntToStr(FontSize)+'px'','
               +'fontWeight: '''+dwIIF(FontBold,'bold','')+''','
               +'fontStyle: '''+dwIIF(FontItalic,'italic','')+''','
               +'color: '''+ColorToWebColorStr(FontColor)+''''
          +'});';
     dwRunJS(sJS,TForm(ASG.Owner));
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
          +''''+ASG.Name+''','
          +IntToStr(ARow)+','
          +'{'
               +'backgroundColor:'''+ColorToWebColorStr(BackGroundColor)+''','
               +'color: '''+ColorToWebColorStr(FontColor)+''''
          +'});';
     dwRunJS(sJS,TForm(ASG.Owner));
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
          +''''+ASG.Name+''','
          +IntToStr(ACol)+','
          +'{'
               +'backgroundColor:'''+ColorToWebColorStr(BackGroundColor)+''','
               +'color: '''+ColorToWebColorStr(FontColor)+''''
          +'});';
     dwRunJS(sJS,TForm(ASG.Owner));
     //
     Result    := 0;
end;

end.
