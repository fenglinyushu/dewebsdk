unit unit1;

interface

uses
    //
    Unit2,
    //
    dwBase,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
    Vcl.Imaging.pngimage, Vcl.Buttons, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Panel_All: TPanel;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel7: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    Panel8: TPanel;
    Panel4: TPanel;
    Panel6: TPanel;
    Panel3: TPanel;
    Panel5: TPanel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Image11: TImage;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Label1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
      Y: Integer);
    procedure Button1Click(Sender: TObject);
  private
  public
    Form2   : TForm2;
    iTime   : Integer;
    function IsEmpty(AX,AY:Integer):boolean;
  end;

var
     Form1          : TForm1;



implementation

{$R *.dfm}




procedure TForm1.Button1Click(Sender: TObject);
begin
    dwOpenURL(self,'https://jingyan.baidu.com/article/359911f59556b857fe0306a5.html','_blank');
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置为移动模式. 自动设置为移动设备的宽高. 如果采用电脑访问,则自动设置为 iPhone6/7/8 plus分辨率:414x736
    dwSetMobileMode(self,414,736);

end;

//判断当前位置是否已有人
function TForm1.IsEmpty(AX,AY:Integer):boolean;
var
    I       : Integer;
    oPanel  : TPanel;
begin
    Result  := True;
    for I := 1 to 10 do begin
        oPanel  := TPanel(self.FindComponent('Panel'+IntToStr(I)));
        with oPanel do begin
            if (Left<AX) and (Left+Width>AX) and (Top<AY) and (Top+Height>AY) then begin
                Result  := False;
                break;
            end;
        end;
    end;

end;

procedure TForm1.Label1MouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,Y: Integer);
var
    iW,iH   : Integer;
    iL,iT   : Integer;
    bL,bR   : Boolean;  //可向左,向右移动的可能性
    bU,bD   : Boolean;  //可向上,向下移动的可能性
    //
    oPanel  : TPanel;   //父模块
    //
    I       : Integer;
begin
    //得到父模块
    oPanel  := TPanel(TLabel(Sender).Parent);

    //得到当前人物的LTWH
    iL  := oPanel.Left;
    iT  := oPanel.Top;
    iW  := oPanel.Width;
    iH  := oPanel.Height;

    //检查向左可能性
    bL  := False;
    if iL > 0 then begin
        if iH>100 then begin
            bL  := IsEmpty(iL-40,iT +40) and IsEmpty(iL-40,iT +120);
        end else begin
            bL  := IsEmpty(iL-40,iT +40);
        end;
    end;

    //检查向右可能性
    bR   := False;
    if iL + iW < 310 then begin
        if iH>100 then begin
            bR  := IsEmpty(iL+iW+40,iT +40) and IsEmpty(iL+iW+40,iT +120);
        end else begin
            bR  := IsEmpty(iL+iW+40,iT +40);
        end;
    end;

    //检查向上可能性
    bU  := False;
    if iT > 0 then begin
        if iW>100 then begin
            bU  := IsEmpty(iL+40,iT - 40) and IsEmpty(iL+120,iT-40);
        end else begin
            bU  := IsEmpty(iL+40,iT - 40);
        end;
    end;

    //检查向下可能性
    bD   := False;
    if iT + iH < 390 then begin
        if iW>100 then begin
            bD  := IsEmpty(iL+40,iT+iH+40) and IsEmpty(iL+120,iT +iH+40);
        end else begin
            bD  := IsEmpty(iL+40,iT+iH+40)
        end;
    end;

    //根据可移动及鼠标点击位置移动
    if bL and bR then begin
        if X<40 then begin
            oPanel.Left := oPanel.Left - 80;
        end else begin
            oPanel.Left := oPanel.Left + 80;
        end;
    end else if bL and bU then begin
        if X<Y then begin
            oPanel.Left := oPanel.Left - 80;
        end else begin
            oPanel.Top  := oPanel.Top - 80;
        end;
    end else if bL and bD then begin
        if X<80-Y then begin
            oPanel.Left := oPanel.Left - 80;
        end else begin
            oPanel.Top  := oPanel.Top + 80;
        end;
    end else if bR and bU then begin
        if X>80-Y then begin
            oPanel.Left := oPanel.Left + 80;
        end else begin
            oPanel.Top  := oPanel.Top - 80;
        end;
    end else if bR and bD then begin
        if X>Y then begin
            oPanel.Left := oPanel.Left + 80;
        end else begin
            oPanel.Top  := oPanel.Top + 80;
        end;
    end else if bU and bD then begin
        if Y>40 then begin
            oPanel.Top := oPanel.Top + 80;
        end else begin
            oPanel.Top  := oPanel.Top - 80;
        end;
    end else begin

        if bL then begin
            oPanel.Left := oPanel.Left - 80;
        end else if bR then begin
            oPanel.Left := oPanel.Left + 80;
        end else if bU then begin
            oPanel.Top := oPanel.Top - 80;
        end else if bD then begin
            oPanel.Top := oPanel.Top + 80;
        end;
    end;
    //
    if (Panel5.Left = 80) and (Panel5.Top = 240) then begin
        //
        Randomize;
        Form2.Image1.Hint   := '{"src":"media/images/hrd/'+IntToStr(Random(6)+1)+'.jpg"}';
        dwShowModal(self,Form2);
    end;
end;

end.
