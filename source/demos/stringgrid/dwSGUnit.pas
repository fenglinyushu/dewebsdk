unit dwSGUnit;

interface

uses
     //
     dwBase,


     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
     Dialogs, StdCtrls, jpeg, ExtCtrls,Vcl.Grids;

//��������һ��
function dwSGAddRow(ASG:TStringGrid):Integer;
//ɾ�����һ��
function dwSGDelRow(ASG:TStringGrid):Integer;

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

end.
