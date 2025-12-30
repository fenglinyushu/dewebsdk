unit unit0;

interface

uses
    //
    dwBase,

    //
    CloneComponents,


    //
    Math,
    Graphics,strutils,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus, Data.DB, Vcl.DBGrids, Vcl.WinXCtrls;

type
  TForm_Item = class(TForm)
    Panel_Full: TPanel;
    Panel_Inner: TPanel;
    Panel_L: TPanel;
    Panel7: TPanel;
    Panel1: TPanel;
    Panel_R: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel_C: TPanel;
    ToggleSwitch1: TToggleSwitch;
    ToggleSwitch2: TToggleSwitch;
    ToggleSwitch3: TToggleSwitch;
    ToggleSwitch4: TToggleSwitch;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label6: TLabel;
    Label5: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Memo1: TMemo;
    ProgressBar2: TProgressBar;
    Memo2: TMemo;
    Memo3: TMemo;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    gsMainDir   : String;
  end;

var
  Form_Item: TForm_Item;

implementation

{$R *.dfm}


procedure TForm_Item.Button1Click(Sender: TObject);
begin
    dwEcharts(Memo2);
end;

procedure TForm_Item.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    I       : Integer;
const
    _SS1    : array[0..9] of String=('一月','二月','三月','四月','五月','六月','七月','八月','九月','十月');
begin
    //
    //dwSetPCMode(Self);

    Randomize;
    Label6.Caption      := Format('%d',[200 ]);   //+Random(200)
    Label10.Caption     := Format('%d',[300 ]);   //+Random(300)
    Label11.Caption     := Format('%d',[400 ]);   //+Random(50)
    Label12.Caption     := Format('%d',[500 ]);    //+Random(200)
    //
    ProgressBar2.Position   := 50+Random(50);
    //
    ToggleSwitch1.State     := TToggleSwitchState(Random(10)>2);
    ToggleSwitch2.State     := TToggleSwitchState(Random(10)>4);
    ToggleSwitch3.State     := TToggleSwitchState(Random(10)>6);
    ToggleSwitch4.State     := TToggleSwitchState(Random(10)>7);
    //
    dwEcharts(Memo2);
    dwEcharts(Memo3);
end;

procedure TForm_Item.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    iW,iH   : Integer;
    sCode   : String;
begin
    iW      := StrToIntDef(dwGetProp(self,'innerwidth'),0);
    iH      := StrToIntDef(dwGetProp(self,'innerheight'),0);
    //
    if iW<=Width then begin
        sCode   :='document.body.parentNode.style.overflow = "hidden";'
                +'document.getElementById(''app'').style.transformOrigin ="0 0";'
                +'document.getElementById(''app'').style.transform = ''scale('+FloatToStr(iW/Width)+','+FloatToStr(iH/Height)+')'';';
    end else begin
        sCode   :='document.body.parentNode.style.overflow = "hidden";'
                +'document.getElementById(''app'').style.transformOrigin ="50% 0";'
                +'document.getElementById(''app'').style.transform = ''scale('+FloatToStr(iW/Width)+','+FloatToStr(iH/Height)+')'';';
    end;
    dwRunJS(sCode,self);

end;

end.
