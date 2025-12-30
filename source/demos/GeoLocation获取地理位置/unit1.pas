unit unit1;

interface

uses
    //
    dwBase,

    //
    Math,
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
    Vcl.Samples.Calendar, Vcl.Buttons,Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    P_Header: TPanel;
    Label_Header: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public

    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}




procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    dwSetMobileMode(Self,400,900);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    sJS     : String;
    sHd     : string;
begin
    sHd     := IntToStr(Handle);
    sJS     :=
            'var that = this;                                                   '#13#10+
            'if (navigator.geolocation) {                                       '#13#10+
                'navigator.geolocation.getCurrentPosition(showmap, error);      '#13#10+    //取位置
            '}else {                                                            '#13#10+
                'alert("该浏览器不支持获取地理位置");                           '#13#10+
            '};                                                                 '#13#10+
            'function showmap(position) {                                       '#13#10+
            '    var cords = position.coords;                                   '#13#10+
            '    that.label1__cap = cords.latitude + '' , '' + cords.longitude; '#13#10+    //将位置信息赋给label1（前端）
            '    console.log(that.label1__cap);                                 '#13#10+    //
            '    me.dwevent("","label1","this.label1__cap","_update",'+sHd+');'#13#10+    //更新Label1服务端的值，并激活Onclick事件
            '}                                                                  '#13#10+
            'function error(error) {                                            '#13#10+
            '    var err = error.code;                                          '#13#10+
            '    switch (err) {                                                 '#13#10+
            '        case 1: alert("用户拒绝了位置服务"); break;                '#13#10+
            '        case 2: alert("获取不到位置信息"); break;                  '#13#10+
            '        case 3: alert("获取信息超时");                             '#13#10+
            '    }                                                              '#13#10+
            '};';

    dwRunJS(sJS,self);
end;

procedure TForm1.Label1Click(Sender: TObject);
begin
    dwMessage(Label1.Caption,'',self);
    Label2.Caption := 'Clicked';
end;

end.
