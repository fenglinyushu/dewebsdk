unit dwApp;

interface

uses
    dwBase,
    //
    HttpApp,Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
    Vcl.Buttons;

//
function dwaGetQrCodeJS(AEdit:TEdit;ACancel:String):String;

implementation

function dwaGetQrCodeJS(AEdit:TEdit;ACancel:String):String;
begin
    if ACancel = '' then begin
        Result  := ''
                +'let that=this;'
                +'jsBridge.scan({'
                    +'needResult: true'
                +'}, function(code) {'
                    +'if (code) {'
                        +'that.%s__txt=code;'
                        +'cccode=code;'
                        +'that.dwevent('''',''%s'',''cccode'',''onchange'',that.clientid);'
                    +'} else {'
                        //+'alert("扫码失败或取消了扫码");'
                    +'}'
                +'});';
    end else begin
        Result  := ''
                +'let that=this;'
                +'jsBridge.scan({'
                    +'needResult: true'
                +'}, function(code) {'
                    +'if (code) {'
                        +'that.%s__txt=code;'
                        +'cccode=code;'
                        +'that.dwevent('''',''%s'',''cccode'',''onchange'',that.clientid);'
                    +'} else {'
                        +'alert("'+ACancel+'");'
                    +'}'
                +'});';
    end;
    //
    Result  := Format(Result,[dwFullName(AEdit),dwFullName(AEdit)]);
end;

end.
