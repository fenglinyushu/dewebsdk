unit dwTimers;

interface

uses
     //
     dwCtrlBase,

     //
     SynCommons,
     
     //
     Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
     Spin, Grids,
     Math,typinfo,
     DateUtils, StdCtrls, Menus,
     Windows,Types;




//取得Data消息, ASeparator为分隔符, 一般为:或=
function dwGetData(ACtrl:TComponent;ASeparator:String):Variant;

implementation




//取得Data消息, ASeparator为分隔符, 一般为:或=
function dwGetData(ACtrl:TComponent;ASeparator:String):Variant;
begin
     //生成返回值数组
     Result    := _Json('[]');
     //
     with TTimer(ACtrl) do begin
          Result.Add(Name+'__itv'+ASeparator+''+IntToStr(InterVal)+'');
          Result.Add(Name+'__dis'+ASeparator+''+dwIIF(Enabled,'false','true'));
     end;
end;



end.
