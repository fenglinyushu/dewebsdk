unit unit1;

interface

uses
    //
    dwBase,
    dwMqtt,

    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    BtC: TButton;
    BtP: TButton;
    Edit_Topic: TEdit;
    Pn0: TPanel;
    L_Title: TLabel;
    BtE: TButton;
    EtM: TEdit;
    BtS: TButton;
    Edit_Server: TEdit;
    BtU: TButton;
    MmMqtt: TMemo;
    MMg: TMemo;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    Memo9: TMemo;
procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtCClick(Sender: TObject);
    procedure BtPClick(Sender: TObject);
    procedure BtEClick(Sender: TObject);
    procedure BtSClick(Sender: TObject);
    procedure BtUClick(Sender: TObject);
    procedure MmMqttKeyPress(Sender: TObject; var Key: Char);
    procedure MmMqttEnter(Sender: TObject);
  private
    { Private declarations }
  public

    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.BtCClick(Sender: TObject);
begin
    //连接服务器
    //dwRunJS('this.'+dwFullName(MmMqtt)+'__mqttconnect("'+Edit_Server.Text+'");',self);
    dwMqttConnect(MmMqtt,Edit_Server.Text);
end;

procedure TForm1.BtPClick(Sender: TObject);
begin
    //发布消息

    //
    //dwRunJS('this.'+dwFullName(MmMqtt)+'__mqttpublish("'+Edit_Topic.Text+'","'+EtM.Text+'");',self);

    dwMqttPublish(MmMqtt,Edit_Topic.Text,EtM.Text);
end;

procedure TForm1.BtSClick(Sender: TObject);
begin
    //订阅主题

    //
    //dwRunJS('this.'+dwFullName(MmMqtt)+'__mqttsubscribe("'+Edit_Topic.Text+'",0);',self);

    dwMqttSubscribe(MmMqtt,Edit_Topic.Text,0);
end;

procedure TForm1.BtUClick(Sender: TObject);
begin
    //取消订阅主题

    //
    //dwRunJS('this.'+dwFullName(MmMqtt)+'__mqttunsubscribe("'+Edit_Topic.Text+'");',self);

    dwMqttUnsubscribe(MmMqtt,Edit_Topic.Text);

end;

procedure TForm1.BtEClick(Sender: TObject);
begin
    //
    //dwRunJS('this.'+dwFullName(MmMqtt)+'__mqttend();',self);
    dwMqttEnd(MmMqtt);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(self);
end;

procedure TForm1.MmMqttEnter(Sender: TObject);
begin
    //的OnEnter为接收到消息的事件


    //
    if Mmg.Lines.Count>20 then begin
        MMg.Lines.Clear;
    end;
    MMg.Lines.Add(Formatdatetime('yyyy-MM-dd hh:mm:ss zzz',now)+' :');
    MMg.Lines.Add(MmMqtt.Text);

end;

procedure TForm1.MmMqttKeyPress(Sender: TObject; var Key: Char);
begin
    //Memo__Comm的OnKeyPress为各种消息的事件
    //如果key='t', 则为成功
    //否则为失败

    if key = 'c' then begin     //连接成功消息

        BtS.Enabled := True;
        BtU.Enabled := BtS.Enabled;
        BtP.Enabled := BtS.Enabled;
        BtE.Enabled := BtS.Enabled;
        BtC.Enabled := not BtS.Enabled;
        Mmg.Lines.Add('connect success') ;
    end else if key = 'e' then begin    //断开连接成功消息

        BtS.Enabled := False;
        BtU.Enabled := BtS.Enabled;
        BtP.Enabled := BtS.Enabled;
        BtE.Enabled := BtS.Enabled;
        BtC.Enabled := not BtS.Enabled;
        Mmg.Lines.Add('ended') ;
    end else if key = 's' then begin
        Mmg.Lines.Add('subscribe success') ;
    end else if key = 'p' then begin
        Mmg.Lines.Add('publish success') ;
    end else if key = 'u' then begin
        Mmg.Lines.Add('unsubscribe success') ;
    end;

end;

end.
