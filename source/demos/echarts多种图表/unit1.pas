unit unit1;

interface

uses
    //
    dwBase,

    //
    CloneComponents,


    //
    Math,
    Graphics,SysUtils,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
  Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Memo1: TMemo;
    Memo2: TMemo;
    Panel2: TPanel;
    Label1: TLabel;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    Memo3: TMemo;
    Memo4: TMemo;
    Memo5: TMemo;
    Memo6: TMemo;
    Memo7: TMemo;
    TabSheet8: TTabSheet;
    Memo8: TMemo;
    Button1: TButton;
    TabSheet9: TTabSheet;
    Memo9: TMemo;
    ScrollBox1: TScrollBox;
    Panel1: TPanel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Memo1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
  Form1: TForm1;

implementation
{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
    sJS     : string;
begin
    Randomize();
    //
    sJS     := Format('this.value0 = [%d, %d, %d, %d, %d, %d, %d];',
            [Random(500),Random(500),Random(500),Random(500),Random(500),Random(500),Random(500)]);
    //
    dwRunJS(sJS,self);
    //
    dwEcharts(Memo8);
    //Memo8.ShowHint  := True;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //浏览器尺寸变化事件


    //指定为PC模式
    dwSetPCMode(Self);
end;


procedure TForm1.Memo1MouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwEcharts(memo1);
    dwEcharts(memo2);
    dwEcharts(memo3);
    dwEcharts(memo4);
    dwEcharts(memo5);
    dwEcharts(memo6);
    dwEcharts(memo7);
    dwEcharts(memo8);
end;

end.
