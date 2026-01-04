unit unit1;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client,CloneComponents;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    ScrollBox: TScrollBox;
    fp_background: TFlowPanel;
    p_Card: TPanel;
    lb_ShiJian: TLabel;
    lb_ZhiWu: TLabel;
    lb_XingMing: TLabel;
    L_Detail: TLabel;
    btn_ZhuangTai: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;
     recCnt:Integer;


implementation


{$R *.dfm}


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(self);

end;

procedure TForm1.FormShow(Sender: TObject);
var
    i       : integer;
    pCard   : TPanel;
    iRow    : Integer;
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM Demo_FlowCard';
    FDQuery1.Open;
    recCnt:=FDQuery1.RecordCount;
    //dwMessage(IntToStr(recCnt),'success',self) ;

    FDQuery1.First;

    for i := 1 to recCnt do begin
        pCard:= TPanel(CloneComponent(p_Card)) ;

        TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))).Caption:= FDQuery1.FieldByName('ZhuangTai').AsString;
        if FDQuery1.FieldByName('ZhuangTai').AsString='预约中' then begin
            TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))).Hint:='{"type":"primary"}';
        end;

        if FDQuery1.FieldByName('ZhuangTai').AsString='等待召唤' then begin
            TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))).Hint:='{"type":"success"}';
        end;

        if FDQuery1.FieldByName('ZhuangTai').AsString='待接见' then begin
            TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))).Hint:='{"type":"info"}';
        end;

        if FDQuery1.FieldByName('ZhuangTai').AsString='约见中' then begin
            TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))).Hint:='{"type":"warning"}';
        end;

        if FDQuery1.FieldByName('ZhuangTai').AsString='取消约见' then begin
            TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))).Hint:='{"type":"danger"}';
        end;

        if FDQuery1.FieldByName('ZhuangTai').AsString='待预约' then begin
            with TButton(FindComponent('btn_ZhuangTai'+IntToStr(i))) do begin
                Hint    :='{"backgroundcolor":"#7E79E7"}';
                Font.Color  := clWhite;
            end;
        end;

        //
        TLabel(FindComponent('lb_ShiJian'+IntToStr(i))).Caption  := FDQuery1.FieldByName('ShiJian').AsString;
        TLabel(FindComponent('lb_ZhiWu'+IntToStr(i))).Caption    := FDQuery1.FieldByName('ZhiWu').AsString;
        TLabel(FindComponent('lb_XingMing'+IntToStr(i))).Caption := FDQuery1.FieldByName('XingMing').AsString;
        TLabel(FindComponent('L_Detail'+IntToStr(i))).Caption    := FDQuery1.FieldByName('DaiBan').AsString;

        FDQuery1.Next;

        pcard.Visible:=true;
    end;



end;

end.
