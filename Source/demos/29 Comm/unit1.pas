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
    Data.DB,
    Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.WinXCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.MSSQLDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
    FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Vcl.Menus;

type
  TForm1 = class(TForm)
    BtOpen: TButton;
    BtComm: TButton;
    LaReceive: TLabel;
    btSend: TButton;
    etSend: TEdit;
    Pn0: TPanel;
    L_Title: TLabel;
    LaState: TLabel;
    BtClose: TButton;
procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure BtOpenClick(Sender: TObject);
    procedure BtCommEnter(Sender: TObject);
    procedure btSendClick(Sender: TObject);
    procedure BtCommKeyPress(Sender: TObject; var Key: Char);
    procedure BtCloseClick(Sender: TObject);
  private
    { Private declarations }
  public

    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.BtCommKeyPress(Sender: TObject; var Key: Char);
begin
    //Button__Comm的OnKeyPress为打开串口的返回消息的事件
    //如果key='t', 则为成功
    //否则为失败


    if Key ='t' then begin
        BtSend.Enabled  := True;
        BtClose.Enabled := True;
        LaState.Caption := '端口状态：已打开';
        dwMessage('打开串口成功！','success',self);
    end else if Key ='f' then begin
        BtSend.Enabled  := False;
        BtClose.Enabled := False;
        LaState.Caption := '端口状态：已关闭';
        dwMessage('打开串口失败！','error',self);
    end else if Key ='1' then begin
        BtSend.Enabled  := False;
        BtClose.Enabled := False;
        LaState.Caption := '端口状态：已关闭';
        dwMessage('关闭串口成功！','error',self);
    end else begin
        BtSend.Enabled  := False;
        BtClose.Enabled := False;
        LaState.Caption := '端口状态：已关闭';
        dwMessage('关闭串口失败！','error',self);
    end;
end;

procedure TForm1.BtOpenClick(Sender: TObject);
begin
    //
    dwRunJS('this.'+dwFullName(BtComm)+'__OpenComm();',self);
end;

procedure TForm1.btSendClick(Sender: TObject);
begin
    //发送字符串

    //
    dwRunJS('this.'+dwFullName(BtComm)+'__WriteComm("'+EtSend.Text+'");',self);

end;

procedure TForm1.BtCloseClick(Sender: TObject);
begin
    //
    dwRunJS('this.'+dwFullName(BtComm)+'__CloseComm();',self);

end;

procedure TForm1.BtCommEnter(Sender: TObject);
begin
    //Button__Comm的OnEnter为串口接收到消息的事件


    //
    LaReceive.Caption  := (BtComm.Caption);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetMobileMode(self,400,900);
end;

end.
