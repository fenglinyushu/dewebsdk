library dwdirect;

uses
  SysUtils,
  SynCommons,
  IdURI,
  dwBase,
  Forms,
  Messages,
  StdCtrls,
  Variants,
  Windows,
  Classes;

{$R *.res}
function dwDirectInteraction(AData:PWideChar):PWideChar;stdcall;
var
    sData   : string;
    joRes   : Variant;
begin
    //此处用于取得post或get发送的数据
    sData   := TIdURI.URLDecode(String(AData));

    //此处用于返回数据值，一般根据传入的数据进行适当运算。此处直接返回原值
    Result  := PWideChar(sData);

    //
    joRes   := _json('{}');
    joRes.platform  := 'deweb';
    joRes.website   := 'www.delphibbs.com';
    joRes.time      := FormatDateTime('YYYY-MM-DD hh:mm:ss',Now);
    joRes.data      := sData;

    Result  := PWideChar(String(joRes));

end;




exports
     dwDirectInteraction;

end.
