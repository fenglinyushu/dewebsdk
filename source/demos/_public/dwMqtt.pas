unit dwMqtt;
(*
    DeWeb mqtt单元

*)


interface

uses
    dwBase,
    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls;


//连接服务器
//AMqtt:TMemo 为Mqtt控件（TMemo,设置HelpKeyword=mqtt）,AUrl为服务器URL
procedure dwMqttConnect(AMqtt:TMemo;AUrl:String);

//订阅消息
//AMqtt:TMemo 为Mqtt控件（TMemo,设置HelpKeyword=mqtt）,ATopic 为消息主题, AQos为服务质量
procedure dwMqttSubscribe(AMqtt:TMemo;ATopic:String;AQos:Integer);

//取消订阅消息
//AMqtt:TMemo 为Mqtt控件（TMemo,设置HelpKeyword=mqtt）,ATopic 为消息主题
procedure dwMqttUnsubscribe(AMqtt:TMemo;ATopic:String);

//发布消息
//AMqtt:TMemo 为Mqtt控件（TMemo,设置HelpKeyword=mqtt）,ATopic 为消息主题，AText为消息内容
procedure dwMqttPublish(AMqtt:TMemo;ATopic,AText:String);

//停止
//AMqtt:TMemo 为Mqtt控件（TMemo,设置HelpKeyword=mqtt）
procedure dwMqttEnd(AMqtt:TMemo);

implementation

procedure dwMqttConnect(AMqtt:TMemo;AUrl:String);
begin
    dwRunJS('this.'+dwFullName(AMqtt)+'__mqttconnect("'+AUrl+'");',TForm(AMqtt.Owner));
end;

procedure dwMqttSubscribe(AMqtt:TMemo;ATopic:String;AQos:Integer);
begin
    dwRunJS('this.'+dwFullName(AMqtt)+'__mqttsubscribe("'+ATopic+'",'+IntToStr(AQos)+');',TForm(AMqtt.Owner));
end;

procedure dwMqttUnsubscribe(AMqtt:TMemo;ATopic:String);
begin
    dwRunJS('this.'+dwFullName(AMqtt)+'__mqttUnsubscribe("'+ATopic+'");',TForm(AMqtt.Owner));
end;

procedure dwMqttPublish(AMqtt:TMemo;ATopic,AText:String);
begin
    dwRunJS('this.'+dwFullName(AMqtt)+'__mqttpublish("'+ATopic+'","'+AText+'");',TForm(AMqtt.Owner));
end;

procedure dwMqttEnd(AMqtt:TMemo);
begin
    dwRunJS('this.'+dwFullName(AMqtt)+'__mqttend();',TForm(AMqtt.Owner));
end;


end.
