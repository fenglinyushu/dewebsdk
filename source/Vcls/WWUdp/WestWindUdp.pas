unit WestWindUdp;

(*
应该在主程序中添加以下代码, 替换

function ProcessMsg(AIP,AText :string):Integer;

implementation

{$R *.dfm}

function ProcessMsg(AIP,AText: string): Integer;
begin
     try

     except
          //
     end;

end;


//----- OnShow

     //
     wwuInit(3027,3028, ProcessMsg);

//-----------
*)

interface

uses
     //第三方
     OverbyteIcsUtils, OverbyteIcsWinSock, OverbyteIcsWSocket, OverbyteIcsWndControl,OverbyteIcsTypes,

     //系统
     Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs;

type
  TUDPProcessFunction = function(AIP:string; AText : string) : Integer;

  TForm_WWUdp = class(TForm)
    procedure WSocket_RecvDataAvailable(Sender: TObject; ErrCode: Word);
  private
    FSenderAddr    : TSockAddrIn6;
    DataProcess : TUDPProcessFunction;
    { Private declarations }
  public
  published
  end;

var
     Form_WWUdp   : TForm_WWUdp;
     WSocket_Recv   : TWSocket;
     WSocket_Send   : TWSocket;

function wwuInit(ASendPort,ARecvPort:Integer;AProcess:TUDPProcessFunction):Integer;
function wwuStop:Integer;
function wwuSend(AText:string):Integer;


implementation

{$R *.dfm}


function wwuSend(AText:string):Integer;
begin
    Result  := 0;
    try
        with Form_WWUdp do begin
            if WSocket_Send <> nil then begin
                WSocket_Send.SendStr(AText);
            end else begin
                Result  := -1;
            end;
        end;
    except

    end;
end;


function wwuInit(ASendPort,ARecvPort:Integer;AProcess:TUDPProcessFunction):Integer;

begin
     //
     if Form_WWUdp = nil  then  begin
          Form_WWUdp     := TForm_WWUdp.Create(Application);
          WSocket_Recv   := TWSocket.Create(Form_WWUdp);
          with WSocket_Recv do begin
               ExclusiveAddr       := False;
               ReuseAddr           := True;
               OnDataAvailable     := Form_WWUdp.WSocket_RecvDataAvailable;
          end;


          WSocket_Send   := TWSocket.Create(Form_WWUdp);
          with WSocket_Send do begin
               ExclusiveAddr       := False;
               ReuseAddr           := True;
          end;
     end;

     if WSocket_Recv=nil then begin
          WSocket_Recv   := TWSocket.Create(Form_WWUdp);
          with WSocket_Recv do begin
               ExclusiveAddr       := False;
               ReuseAddr           := True;
               OnDataAvailable     := Form_WWUdp.WSocket_RecvDataAvailable;
          end;


          WSocket_Send   := TWSocket.Create(Form_WWUdp);
          with WSocket_Send do begin
               ExclusiveAddr       := False;
               ReuseAddr           := True;
          end;
     end;

     with Form_WWUdp do begin
          //给接收事件赋值
          DataProcess         := AProcess;

          //打开接收端口
          if ARecvPort > 0 then begin
               WSocket_Recv.SocketFamily      := sfIPv4;
               WSocket_Recv.Addr              := ICS_ANY_HOST_V4;
               WSocket_Recv.MultiCast         := FALSE;
               WSocket_Recv.MultiCastAddrStr  := '';
               WSocket_Recv.Proto             := 'udp';
               WSocket_Recv.Port              := IntToStr(ARecvPort);
               WSocket_Recv.Listen;
          end;

          //打开发送端口
          if ASendPort > 0 then begin
               WSocket_Send.Proto            := 'udp';
               WSocket_Send.Addr             := '255.255.255.255';
               WSocket_Send.LocalAddr        := '0.0.0.0';
               WSocket_Send.LocalPort        := '0';
               WSocket_Send.Port             := IntToStr(ASendPort);
               WSocket_Send.Connect;
          end;
     end;
     //
end;

function wwuStop:Integer;
begin
     with Form_WWUdp do begin
          WSocket_Recv.Close;
          WSocket_Send.Close;
     end;

end;


procedure TForm_WWUdp.WSocket_RecvDataAvailable(Sender: TObject; ErrCode: Word);
var
     sData     : string;
     Buffer     : array [0..2017] of AnsiChar;
     iLen       : Integer;
     oSrc       : TSockAddrIn6;
     //
     iSrcLen    : Integer;
     iItem      : Integer;
     iObject    : Integer;
begin
     try
          //接收数据
          sData     := '';
          iSrcLen   := SizeOf(oSrc);
          iLen      := WSocket_Recv.ReceiveFrom(@Buffer, SizeOf(Buffer), PSockAddr(@oSrc)^, iSrcLen);
          if iLen >= 0 then begin
               Buffer[iLen] := #0;
               sData     := String(Buffer);
          end;

          //调用主程序的数据处理函数
          DataProcess( String(WSocket_inet_ntoa(PSockAddr(@oSrc).sin_addr)),sData);


     except
          //ShowMessage('Error when WSocket_UDPDataAvailable!');
     end;

end;

end.
