unit Unit_CarNo;

interface

uses
    //
    dwBase,

    //
    SynCommons,


    //
    Math,Variants,
    Graphics,strutils,
    ComObj,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
    FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
    Vcl.Imaging.pngimage, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, Vcl.WinXPanels;

type
  TForm_CarNo = class(TForm)
    P0: TPanel;
    L_Title: TLabel;
    B_Back: TButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    Im: TImage;
    FlowPanel1: TFlowPanel;
    B0: TButton;
    B1: TButton;
    B2: TButton;
    B3: TButton;
    B4: TButton;
    B5: TButton;
    B6: TButton;
    B7: TButton;
    Panel1: TPanel;
    CP: TCardPanel;
    Card1: TCard;
    Fp1: TFlowPanel;
    Button9: TButton;
    Button10: TButton;
    Button11: TButton;
    Button12: TButton;
    Button13: TButton;
    Button14: TButton;
    Button15: TButton;
    Button16: TButton;
    Button17: TButton;
    Button18: TButton;
    Button19: TButton;
    Button20: TButton;
    Button21: TButton;
    Button22: TButton;
    Button23: TButton;
    Button24: TButton;
    Button25: TButton;
    Button26: TButton;
    Button27: TButton;
    Button28: TButton;
    Button29: TButton;
    Button30: TButton;
    Button31: TButton;
    Button32: TButton;
    Button33: TButton;
    Button34: TButton;
    Button35: TButton;
    Button36: TButton;
    Button37: TButton;
    Button38: TButton;
    Button39: TButton;
    Button41: TButton;
    Card2: TCard;
    Fp2: TFlowPanel;
    B_A: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Button43: TButton;
    Button44: TButton;
    Button45: TButton;
    Button46: TButton;
    Button47: TButton;
    Button48: TButton;
    Button49: TButton;
    Button50: TButton;
    Button51: TButton;
    Button52: TButton;
    Button53: TButton;
    Button54: TButton;
    Button55: TButton;
    Button56: TButton;
    Button57: TButton;
    Button58: TButton;
    Button59: TButton;
    Button60: TButton;
    Button61: TButton;
    Card3: TCard;
    Fp3: TFlowPanel;
    B_0: TButton;
    Button63: TButton;
    Button64: TButton;
    Button65: TButton;
    Button66: TButton;
    Button67: TButton;
    Button68: TButton;
    Button69: TButton;
    Button70: TButton;
    Button71: TButton;
    Button72: TButton;
    Button73: TButton;
    Button74: TButton;
    Button75: TButton;
    Button76: TButton;
    Button77: TButton;
    Button78: TButton;
    Button79: TButton;
    Button80: TButton;
    Button81: TButton;
    Button82: TButton;
    Button83: TButton;
    Button84: TButton;
    Button85: TButton;
    Button86: TButton;
    Button87: TButton;
    Button88: TButton;
    Button89: TButton;
    Button90: TButton;
    Button91: TButton;
    Button92: TButton;
    Button93: TButton;
    Button94: TButton;
    Button95: TButton;
    Button96: TButton;
    Button97: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure B_BackClick(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure B_AClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure B_0Click(Sender: TObject);
    procedure Button41Click(Sender: TObject);
  private
    { Private declarations }
  public
    giIndex : Integer;
  end;

var
  Form_CarNo: TForm_CarNo;

implementation

{$R *.dfm}

uses
    Unit1;

procedure TForm_CarNo.Button41Click(Sender: TObject);
begin
    if giIndex > 0 then begin
        Dec(giIndex);
    end else begin
        Exit;
    end;
    TButton(FindComponent('B'+IntToStr(giIndex))).Caption  := '';
    case giIndex of
        0 : begin
            CP.ActiveCard   := Card1;
        end;
        1 : begin
            CP.ActiveCard   := Card2;
        end;
    else
        CP.ActiveCard   := Card3;
    end;

end;

procedure TForm_CarNo.Button9Click(Sender: TObject);
begin
    B0.Caption  := TButton(Sender).Caption;
    CP.ActiveCard   := Card2;
    Inc(giIndex);
end;

procedure TForm_CarNo.B_0Click(Sender: TObject);
begin
    if giIndex < 8 then begin
        TButton(FindComponent('B'+IntToStr(giIndex))).Caption  := TButton(Sender).Caption;
        Inc(giIndex);
    end else begin
        dwMessage('当前车牌号为：'+B0.Caption +B1.Caption +B2.Caption +B3.Caption +B4.Caption
                +B5.Caption +B6.Caption +B7.Caption,'success',self);
    end;

end;

procedure TForm_CarNo.B_AClick(Sender: TObject);
begin
    B1.Caption  := TButton(Sender).Caption;
    CP.ActiveCard   := Card3;
    Inc(giIndex);

end;

procedure TForm_CarNo.B_BackClick(Sender: TObject);
begin
    //通过浏览器发送一个返回消息（需要前面显示该模块/界面时使用dwHistoryPush）
    dwhistoryBack(TForm1(self.Owner));
end;

procedure TForm_CarNo.FormCreate(Sender: TObject);
var
    iItem   : Integer;
begin
    giIndex := 0;
    CP.ActiveCard   := Card1;
    //
    for iItem := 0 to 6 do begin
        TButton(FindComponent('B'+IntToStr(iItem))).Hint    := '{"dwstyle":"padding-left:0px;padding-right:0px;"}';
    end;
    for iItem := 0 to Fp1.ControlCount - 1 do begin
        TButton(Fp1.Controls[iItem]).Hint    := '{"dwstyle":"padding-left:0px;padding-right:0px;"}';
    end;
    for iItem := 0 to Fp2.ControlCount - 1 do begin
        TButton(Fp2.Controls[iItem]).Hint    := '{"dwstyle":"padding-left:0px;padding-right:0px;"}';
    end;
    for iItem := 0 to Fp3.ControlCount - 1 do begin
        TButton(Fp3.Controls[iItem]).Hint    := '{"dwstyle":"padding-left:0px;padding-right:0px;"}';
    end;
end;

procedure TForm_CarNo.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,  Y: Integer);
begin
    //设置当前为移动模式
    dwSetMObileMode(Self,400,900);
end;


end.
