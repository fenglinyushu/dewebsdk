unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage, VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.Series,
  VCLTee.TeeProcs, VCLTee.Chart;

type
  TForm1 = class(TForm)
    Panel_02_Content: TPanel;
    Chart1: TChart;
    Chart2: TChart;
    Series5: TBarSeries;
    Series6: TBarSeries;
    Chart4: TChart;
    Series7: TPieSeries;
    Series1: TLineSeries;
    Series2: TLineSeries;
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Button_Update: TButton;
    Chart3: TChart;
    Series3: THorizBarSeries;
    Series4: THorizBarSeries;
    Chart5: TChart;
    Series8: TAreaSeries;
    Series9: TAreaSeries;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Button_UpdateClick(Sender: TObject);
    procedure Button_LegendClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button_LegendClick(Sender: TObject);
begin
     Chart1.Legend.Visible   := not Chart1.Legend.Visible;
     Chart2.Legend.Visible   := not Chart2.Legend.Visible;
     Chart3.Legend.Visible   := not Chart3.Legend.Visible;
     Chart4.Legend.Visible   := not Chart4.Legend.Visible;
     Chart5.Legend.Visible   := not Chart5.Legend.Visible;

end;

procedure TForm1.Button_UpdateClick(Sender: TObject);
var
     I    : Integer;
const
     _SS  : array[0..9] of String=('��','��','��','��','��','��','��','��','��','����');
     _SS1 : array[0..9] of String=('һ��','����','����','����','����','����','����','����','����','ʮ��');
begin

     //
     Randomize;
     Series1.Clear;
     Series2.Clear;
     Series3.Clear;
     Series4.Clear;
     Series5.Clear;
     Series6.Clear;
     Series7.Clear;
     Series8.Clear;
     Series9.Clear;
     for I:= 0 to 9 do begin
          Series1.AddY(Random(100),_SS[I]);
          Series2.AddY(Random(110));
          Series3.AddY(Random(100));
          Series4.AddY(Random(100));
          Series5.AddY(Random(100));
          Series6.AddY(Random(100));
          Series8.AddY(Random(100),_SS1[I]);
          Series9.AddY(Random(100),_SS1[I]);
          //
          if I<4 then begin
               Series7.AddPie(Random(100),'����'+IntToStr(I+1)+'��');
          end;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Button_Update.OnClick(self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
     bMobile   : Boolean;     //�Ƿ�Ϊ�ֻ�
     bVert     : Boolean;     //�Ƿ�Ϊ����
     iWidth    : Integer;     //���
     iHeight   : Integer;     //�߶�
begin
     //<ȡ�ÿͻ�������
     //�Ƿ��ֻ�
     bMobile   := (ssCtrl in Shift) or (ssLeft in Shift);

     //�Ƿ�Ϊ����
     bVert     := Button = mbLeft;

     //�õ���Ⱥ͸߶ȣ���Ϊiphone�Ŀ�Ȳ�������/����仯��
     iWidth    := X;
     iHeight   := Y;
     if  (ssLeft in Shift) and (not bVert) then begin
          iWidth    := Y;
          iHeight   := X;
     end;
     //>

     //�ֻ�/�����Զ���Ӧ
     //������ֻ���������������ã�
     //1 ���Panel�ޱ߿�
     //2 ����ɫΪ��ɫ

     Width     := Min(1000,iWidth);

     if bMobile then begin
          //
          TransparentColorValue    := clWhite;
     end else begin
          //
          TransparentColorValue    := clBtnFace;
     end;

end;

procedure TForm1.FormShow(Sender: TObject);
begin
     //
     dwSetHeight(self,1800);

end;

end.
