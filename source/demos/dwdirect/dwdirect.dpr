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
begin
     Result    := PWideChar('Direct DeWeb Interaction  '+ IntToStr(GetTickCount));
end;




exports
     dwDirectInteraction;

end.
