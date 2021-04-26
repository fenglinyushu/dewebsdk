unit unit1;

interface

uses
     //
     dwBase,
     CloneComponents,

     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
     Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
     Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_Header: TPanel;
    Label_Header: TLabel;
    Panel_Footer: TPanel;
    Panel_FooterTopLine: TPanel;
    Button_Return: TButton;
    Button_Menu: TButton;
    Panel_Content: TPanel;
    Panel_Query: TPanel;
    Panel3: TPanel;
    Label1: TLabel;
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    Panel4: TPanel;
    Label2: TLabel;
    CheckBox_Proc: TCheckBox;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Panel1: TPanel;
    CheckBox3: TCheckBox;
    Label10: TLabel;
    Button3: TButton;
    Label11: TLabel;
    Label12: TLabel;
    Panel6: TPanel;
    Label13: TLabel;
    Label14: TLabel;
    Panel7: TPanel;
    Label15: TLabel;
    Label16: TLabel;
    Panel8: TPanel;
    Label17: TLabel;
    Label18: TLabel;
    Panel9: TPanel;
    ScrollBox1: TScrollBox;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button2Click(Sender: TObject);
var
     I,J       : Integer;
     oPanel    : TPanel;
begin
     //
     for I := 0 to 19 do begin

          //<添加礼物页
          oPanel    := TPanel(CloneComponent(Panel4));
          //
          oPanel.Top     := 9999;
          oPanel.Visible := True;
          //
          //{TImage(FindComponent('Image_dm2'+IntToStr(I+1))).Hint   := '{"radius":"10px","src":"/media/images/app0/20'+IntToStr(I mod 3)+'.jpg"}';
          TStaticText(FindComponent('Label4'+IntToStr(I+1))).Caption   := '¥'+Format('%.1f',[20+Random(5000)/10]);
          //TStaticText(FindComponent('StaticText_DM2_Heart'+IntToStr(I+1))).Caption   := Format('%d',[20+Random(500)]); }
          //>
     end;
     //
     Panel_Content.AutoSize   := False;
     Panel_Content.AutoSize   := True;
     Panel_Content.AutoSize   := False;
     //
     self.ParentFont := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
var
     I         : Integer;
     oCheck    : TCheckBox;
     sCheck    : string;
begin
     sCheck    := 'Checked : ';
     for I := 0 to 19 do begin
          oCheck    := TCheckBox(FindComponent('CheckBox_Proc'+IntToStr(I+1)));
          //
          if oCheck.Checked then begin
               sCheck    := sCheck + IntToStr(I)+',';
          end;
     end;
     dwShowMessage(sCheck,self);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     I,J       : Integer;
     oPanel    : TPanel;
begin
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
     iTrueH    : Integer;
     iInnerH   : Integer;
     iTrueW    : Integer;
     iInnerW   : Integer;
begin
     //
     Width     := Min(480,X);

     //
     iTrueW    := StrToIntDef(dwGetProp(Self,'truewidth'),X);
     iTrueH    := StrToIntDef(dwGetProp(Self,'trueheight'),Y);
     iInnerW   := StrToIntDef(dwGetProp(Self,'innerwidth'),X);
     iInnerH   := StrToIntDef(dwGetProp(Self,'innerheight'),Y);

     //
     Height    := Ceil(iInnerH*Y/iTrueH*iTrueW/iInnerW);
     //
     Panel_Footer.Top    := Height - Panel_Footer.Height;
     Panel_Footer.Left   := 0;
     Panel_Footer.Width  := Width;

     //
     ScrollBox1.Height := Panel_Footer.Top - ScrollBox1.Top;
end;

end.
