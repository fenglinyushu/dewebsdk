library dwTButton__comm;

uses
    ShareMem,

    //
    dwCtrlBase,

    //
    SynCommons,

    //
    Messages, SysUtils, Variants, Classes, Graphics,
    Controls, Forms, Dialogs, ComCtrls, ExtCtrls,
    StdCtrls, Windows;


//--------------------------------------------------------------------------------------------------


//--------------------------------------------------------------------------------------------------

//当前控件需要引入的第三方JS/CSS
function dwGetExtra(ACtrl:TComponent):String;stdCall;
var
    sCode   : String;
    sFull   : string;

    //
    joHint  : Variant;
    joRes   : Variant;
begin

    //生成返回值数组
    joRes   := _Json('[]');

    //取得HINT对象JSON
    joHint  := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);


    Result  := (joRes);
end;

//根据JSON对象AData执行当前控件的事件, 并返回结果字符串
function dwGetEvent(ACtrl:TComponent;AData:String):String;StdCall;
var
    joData  : Variant;
    cValue  : char;
begin

    //
    joData  := _Json(AData);

    with TButton(ACtrl) do begin
        if joData.e = 'onrecv' then begin
            Caption := dwUnescape(joData.v);
            if Assigned(OnEnter) then begin
                OnEnter(TButton(ACtrl));
            end;
        end else if joData.e = 'onopen' then begin  //打开时状态事件
            if 'success' = dwUnescape(joData.v) then begin
                Cancel  := True;
                cValue  := 't';
            end else begin
                Cancel  := False;
                cValue  := 'f';
            end;
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TButton(ACtrl),cValue);
            end;
        end else if joData.e = 'onclose' then begin  //打开时状态事件
            if 'success' = dwUnescape(joData.v) then begin
                Cancel  := True;
                cValue  := '1';
            end else begin
                Cancel  := False;
                cValue  := '0';
            end;
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TButton(ACtrl),cValue);
            end;
        end;
    end;
end;


//取得HTML头部消息
function dwGetHead(ACtrl:TComponent):String;StdCall;
var
    sCode   : String;
    sRIcon  : string;
    sFull   : string;

    //
    joHint  : Variant;
    joRes   : Variant;
    sEnter  : String;
    sExit   : String;
    sClick  : string;
begin

    //生成返回值数组
    joRes    := _Json('[]');

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //
    sFull   := dwFullName(ACtrl);


    Result    := (joRes);
end;

//取得HTML尾部消息
function dwGetTail(ACtrl:TComponent):String;StdCall;
var
     joRes     : Variant;
begin

     //生成返回值数组
     joRes    := _Json('[]');
     //生成返回值数组
     //joRes.Add('</el-button>');
     //
     Result    := (joRes);
end;

//取得Data消息
function dwGetData(ACtrl:TComponent):String;StdCall;
var
    sFull   : String;
    joRes   : Variant;
    joHint  : Variant;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');

    //
    sFull   := dwFullName(ACtrl);

    //
    joRes.Add(sFull+'__port : 0,');
    joRes.Add(sFull+'__reader : 0,');

    //
    Result    := (joRes);
end;

//取得事件
function dwGetAction(ACtrl:TComponent):String;StdCall;
var
    joRes   : Variant;
    joHint  : Variant;
    sRes    : String;
    sFull   : string;
    pRes    : PWideChar;
begin
    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //生成返回值数组
    joRes    := _Json('[]');


    //
    sFull   := dwFullName(ACtrl);


    //
    Result    := joRes;
end;

function dwGetMethods(ACtrl:TControl):String;stdCall;
var
    //
    sCode       : string;
    sFull       : string;
    //
    joHint      : Variant;
    joRes       : Variant;
    //
    iBaudRate   : Integer;  //波特率 115200
    iDataBits   : Integer;  //数据位，8
    iStopBits   : Integer;  //停止位，1
    sParity     : String;   //校验，none/odd/even/mark/space
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取串口设置
    iBaudRate   := dwGetInt(joHint,'baudrate',115200);
    iDataBits   := dwGetInt(joHint,'databits',8);
    iStopBits   := dwGetInt(joHint,'stopbits',1);
    sParity     := dwGetStr(joHint,'parity','none');

    with TButton(ACtrl) do begin
        //函数头部
        sCode   := sFull+'__click(event) {'#13;
        //
        if joHint.Exists('onclick') then begin
            sCode   := sCode +joHint.onclick+#13;
        end;

        //
        sCode   := sCode + 'this.dwevent("",'''+Name+''',''0'',''onclick'','''+IntToStr(TForm(Owner).Handle)+''');'
                +'},';

        //
        joRes.Add(sCode);

        //
        sCode   :=
                sFull+'__OpenComm(event) {'#13#10+

                    'let _this = this;'#13#10+


                    // Request serial port
                    'async function dwOpenComm() {'#13#10+
                        'try {'#13#10+

                            'const portOptions = {'#13#10+
                                'baudRate: '+IntToStr(iBaudRate)+','#13#10+
                                'dataBits: '+IntToStr(iDataBits)+','#13#10+
                                'stopBits: '+IntToStr(iStopBits)+','#13#10+
                                'parity: "'+sParity+'"'#13#10+
                            '};'#13#10+

                            'var sRecv = [];'#13#10+

                            '_this.'+sFull+'__port = await navigator.serial.requestPort();'#13#10+
                            'const port = _this.'+sFull+'__port;'#13#10+

                            // Open serial port
                            'await port.open(portOptions)'#13#10+
                            '.then(port => {'#13#10+
                                'console.log("串口已成功打开"); '#13#10+
                                //
                                'let jo = {};'#13#10+
                                'jo.m = "event";'#13#10+
                                'jo.i = '+IntToStr(TForm(TButton(ACtrl).Owner).Handle)+';'#13#10+
                                'jo.c = "'+sFull+'";'#13#10+
                                'jo.v = "success";'#13#10+
                                'jo.e = "onopen";'#13#10+
                                'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'#13#10+
                                '.then(resp =>{'#13#10+
                                    '_this.procResp(resp.data); '#13#10+
                                '});'#13#10+
                              // 在此可以进行其他操作，如发送数据等
                            '})'#13#10+
                            '.catch(error => {'#13#10+
                                'console.error("无法打开串口:", error);'#13#10+
                                //
                                'let jo = {};'#13#10+
                                'jo.m = "event";'#13#10+
                                'jo.i = '+IntToStr(TForm(TButton(ACtrl).Owner).Handle)+';'#13#10+
                                'jo.c = "'+sFull+'";'#13#10+
                                'jo.v = "false";'#13#10+
                                'jo.e = "onopen";'#13#10+
                                'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'#13#10+
                                '.then(resp =>{'#13#10+
                                    '_this.procResp(resp.data); '#13#10+
                                '});'#13#10+
                            '});'#13#10+

                            // Create a reader
                            '_this.'+sFull+'__reader = _this.'+sFull+'__port.readable.getReader();'#13#10+

                            // Read data
                            'while (true) { '#13#10+
                                'const { value, done } = await _this.'+sFull+'__reader.read(); '#13#10+
                                'if (done) break;'#13#10+
                                'sRecv = new TextDecoder("gb2312").decode(value);'#13#10+

                                'let jo = {};'#13#10+
                                'jo.m = "event";'#13#10+
                                'jo.i = '+IntToStr(TForm(TButton(ACtrl).Owner).Handle)+';'#13#10+
                                'jo.c = "'+sFull+'";'#13#10+
                                'jo.v = escape(sRecv);'#13#10+
                                'jo.e = "onrecv";'#13#10+
                                'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'#13#10+
                                '.then(resp =>{'#13#10+
                                    '_this.procResp(resp.data); '#13#10+
                                '});'#13#10+
                            '}'#13#10+
                        '} catch (error) {'#13#10+
                            'console.error(error);'#13#10+
                        '}'#13#10+
                    '};'#13#10+
                    'dwOpenComm();'#13#10+
                '},';
        joRes.Add(sCode);

        //WriteComm
        sCode   :=
                sFull+'__WriteComm(text) {'#13#10+
                    'const encoder = new TextEncoder();'#13+
                    'let wdata = encoder.encode(text);'#13+
                    'const writer = this.'+sFull+'__port.writable.getWriter();'#13+
                    'writer.write(wdata);'#13+
                    'writer.releaseLock();'#13+
                '},';
        joRes.Add(sCode);

        //CloseComm
        sCode   :=
                sFull+'__CloseComm() {'#13#10+

                    'let _this = this;'#13#10+
                    'async function dwCloseComm() {'#13#10+
                        'console.log(_this.'+sFull+'__reader);'#13+
                        '_this.'+sFull+'__reader.releaseLock();'#13+
                        'console.log(_this.'+sFull+'__reader);'#13+
                        '_this.'+sFull+'__port.readable.cancel();'#13+
                        'console.log(_this.'+sFull+'__reader);'#13+

                            // Open serial port
                            'const port = _this.'+sFull+'__port;'#13#10+
                            'await port.close()'#13#10+
                            '.then(port => {'#13#10+
                                'console.log("串口已成功关闭"); '#13#10+
                                //
                                'let jo = {};'#13#10+
                                'jo.m = "event";'#13#10+
                                'jo.i = '+IntToStr(TForm(TButton(ACtrl).Owner).Handle)+';'#13#10+
                                'jo.c = "'+sFull+'";'#13#10+
                                'jo.v = "success";'#13#10+
                                'jo.e = "onclose";'#13#10+
                                'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'#13#10+
                                '.then(resp =>{'#13#10+
                                    '_this.procResp(resp.data); '#13#10+
                                '});'#13#10+
                              // 在此可以进行其他操作，如发送数据等
                            '})'#13#10+
                            '.catch(error => {'#13#10+
                                'console.error("无法打开关闭:", error);'#13#10+
                                //
                                'let jo = {};'#13#10+
                                'jo.m = "event";'#13#10+
                                'jo.i = '+IntToStr(TForm(TButton(ACtrl).Owner).Handle)+';'#13#10+
                                'jo.c = "'+sFull+'";'#13#10+
                                'jo.v = "false";'#13#10+
                                'jo.e = "onclose";'#13#10+
                                'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'#13#10+
                                '.then(resp =>{'#13#10+
                                    '_this.procResp(resp.data); '#13#10+
                                '});'#13#10+
                            '});'#13#10+
                    '};'#13#10+
                    'dwCloseComm();'#13#10+

                '},';
        joRes.Add(sCode);
    end;

    //
    Result   := joRes;
end;


exports
     dwGetExtra,
     dwGetEvent,
     dwGetHead,
     dwGetTail,
     dwGetAction,
     dwGetMethods,
     dwGetData;

begin
end.
 
