library dwTMemo__mqtt;

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

    //
    joRes.Add('<script src="https://unpkg.com/mqtt/dist/mqtt.min.js"></script>');

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

    with TMemo(ACtrl) do begin
        if joData.e = 'onmessage' then begin    //收到消息事件
            //消息内容保存在caption中
            Text := dwUnescape(joData.v);
            //激活OnEnter事件
            if Assigned(OnEnter) then begin
                OnEnter(TMemo(ACtrl));
            end;
        end else if joData.e = 'onconnect' then begin  //打开时状态事件
            if 'success' = dwUnescape(joData.v) then begin
                //状态保存在cancel中
                WantTabs  := True;
                cValue  := 'c';
            end else begin
                //状态保存在cancel中
                WantTabs  := True;
                cValue  := 'C';
            end;
            //激活OnKeypress事件，参数分别为
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TMemo(ACtrl),cValue);
            end;
        end else if joData.e = 'onsubscribe' then begin  //断开事件
            if 'success' = dwUnescape(joData.v) then begin
                cValue  := 's';
            end else begin
                cValue  := 'S';
            end;
            //激活OnKeypress事件，参数分别为
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TMemo(ACtrl),cValue);
            end;
        end else if joData.e = 'onunsubscribe' then begin  //断开事件
            if 'success' = dwUnescape(joData.v) then begin
                cValue  := 'u';
            end else begin
                cValue  := 'U';
            end;
            //激活OnKeypress事件，参数分别为
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TMemo(ACtrl),cValue);
            end;
        end else if joData.e = 'onpublish' then begin  //断开事件
            if 'success' = dwUnescape(joData.v) then begin
                cValue  := 'p';
            end else begin
                cValue  := 'P';
            end;
            //激活OnKeypress事件，参数分别为
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TMemo(ACtrl),cValue);
            end;
        end else if joData.e = 'onend' then begin  //断开事件
            if 'success' = dwUnescape(joData.v) then begin
                //状态保存在cancel中
                WantTabs  := false;
                cValue  := 'e';
            end else begin
                //状态保存在cancel中
                WantTabs  := True;
                cValue  := 'E';
            end;
            //激活OnKeypress事件，参数分别为
            if Assigned(OnKeyPress) then begin
                OnKeyPress(TMemo(ACtrl),cValue);
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
    joRes.Add(sFull+'__client : null,');

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
    iClean      : Integer;  //Clean session，默认为true/1
    iTimeOut    : Integer;  //
    sClientId   : String;   //认证信息
    sUserName   : String;   //
    sPassword   : string;   //
begin
    //返回值 JSON对象，可以直接转换为字符串
    joRes   := _json('[]');

    //
    sFull   := dwFullName(Actrl);

    //取得HINT对象JSON
    joHint    := dwGetHintJson(TControl(ACtrl));

    //取设置
    iClean      := dwGetInt(joHint,'clean',1);
    iTimeOut    := dwGetInt(joHint,'timeout',30000);
    sClientId   := dwGetStr(joHint,'clientid','emqx_test');
    sUserName   := dwGetStr(joHint,'username','emqx_test');
    sPassword   := dwGetStr(joHint,'password','emqx_test');

    with TMemo(ACtrl) do begin
        //连接mqtt------------------------------------------------------------------------------------------------------
        sCode   :=
        sFull+'__mqttconnect(url) {'
            +#13'let _this = this;'

            //+#13'console.log("start Connect")'
            +#13'const options = {'
                +#13'clean: '+dwIIF(iClean=1,'true,','false,')
                //+#13'reconnectPeriod:0,'
                +#13'connectTimeout: '+IntToStr(iTimeOut)+','
                +#13'clientId: "'+sClientid+'",'
                +#13'username: "'+sUserName+'",'
                +#13'password: "'+sPassword+'",'
            +#13'}'
            +#13+sFull+'__client = mqtt.connect(url, options,)'
            +#13+sFull+'__client.on("connect", function () {'

                //激活delphi中控件事件
                +#13'let jo = {};'
                +#13'jo.m = "event";'
                +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                +#13'jo.c = "'+sFull+'";'
                +#13'jo.v = "success";'
                +#13'jo.e = "onconnect";'
                +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                +#13'.then(resp =>{'
                    +#13'_this.procResp(resp.data); '
                +#13'});'

                //监听消息
                +#13+sFull+'__client.on("message", function (topic, message) {'
                    //+#13'console.log("recv",message.toString())'
                    //激活delphi中控件事件
                    +#13'jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = message.toString();'
                    +#13'jo.e = "onmessage";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        //+#13'console.log("resp:",resp.data); '
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'})'
            +#13'})'
        +#13'},';

        joRes.Add(sCode);

        //订阅mqtt消息--------------------------------------------------------------------------------------------------
        sCode   :=
        sFull+'__mqttsubscribe(topic, iqos) {'
            //+#13'console.log("mqttsubscribe");'
            +#13'let _this = this;'

            +#13+sFull+'__client.subscribe(topic,{ qos: iqos}, function (error) {'
                +#13'if (error) {'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "false";'
                    +#13'jo.e = "onsubscribe";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'} else {'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "success";'
                    +#13'jo.e = "onsubscribe";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'}'
            +#13'})'
        +#13'},';
        joRes.Add(sCode);

        //取消订阅mqtt消息--------------------------------------------------------------------------------------------------
        sCode   :=
        sFull+'__mqttunsubscribe(topic) {'
            +#13'let _this = this;'

            //+#13'console.log("mqttsubscribe");'
            +#13+sFull+'__client.unsubscribe(topic, function (error) {'
                +#13'if (error) {'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "false";'
                    +#13'jo.e = "onunsubscribe";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'} else {'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "success";'
                    +#13'jo.e = "onunsubscribe";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'}'
            +#13'})'
        +#13'},';
        joRes.Add(sCode);

        //发布mqtt消息--------------------------------------------------------------------------------------------------
        sCode   :=
        sFull+'__mqttpublish(topic, message) {'
            //+#13'console.log("publish");'
            +#13'let _this = this;'

            +#13+sFull+'__client.publish(topic,message, { qos: 0, retain: false }, function (error) {'
                +#13'if (error) {'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "false";'
                    +#13'jo.e = "onpublish";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'} else {'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "success";'
                    +#13'jo.e = "onpublish";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'}'
            +#13'})'
        +#13'},';
        joRes.Add(sCode);

        //断开mqtt------------------------------------------------------------------------------------------------------
        sCode   :=
        sFull+'__mqttend(force) {'
            //+#13'console.log("end");'
            +#13'let _this = this;'

            +#13+sFull+'__client.end(force, function (error) {'
                +#13'if (error) {'
                    //+#13'console.log(error)'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "false";'
                    +#13'jo.e = "onend";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'} else {'
                    //
                    //+#13'console.log("Ended")'

                    //激活delphi中控件事件
                    +#13'let jo = {};'
                    +#13'jo.m = "event";'
                    +#13'jo.i = '+IntToStr(TForm(TMemo(ACtrl).Owner).Handle)+';'
                    +#13'jo.c = "'+sFull+'";'
                    +#13'jo.v = "success";'
                    +#13'jo.e = "onend";'
                    +#13'axios.post(''/deweb/post'',escape(JSON.stringify(jo)),{headers:{shuntflag:0}})'
                    +#13'.then(resp =>{'
                        +#13'_this.procResp(resp.data); '
                    +#13'});'
                +#13'}'
            +#13'})'
        +#13'},';
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
 
