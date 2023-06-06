library dwdirect;

uses
  SysUtils,
  Forms,
  Messages,
  StdCtrls,
  Variants,
  Windows,
  Classes;

{$R *.res}


function dwDirectInteraction(AData:PWideChar):PWideChar;stdcall;
     function _Get(AParaName:String):String;
     var
          iPos      : Integer;     //位置,类似:name=
     begin
          Result    := AData;
          //删除以前的
          iPos      := Pos(AParaName+'=',Result);
          Delete(Result,1,iPos+Length(AParaName));
          //删除&后面的内容
          iPos      := Pos('&',Result);
          if iPos>0 then begin
               Result    := Copy(Result,1,iPos-1);
          end;
     end;
begin
     //name%3Dww%26age%3D18
     //Result := 'i love U forever!';

     Result    := PWideChar(Format('You Name is %s Age is %s',[_Get('name'),_Get('age')]));
end;




exports
     dwDirectInteraction;

end.
