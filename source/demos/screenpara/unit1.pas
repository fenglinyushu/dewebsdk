unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Panel_00_Title: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Panel_01_Line: TPanel;
    Label13: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
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

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //
     {
     X,Y分别表示当前设备的Width/Height；
     Button : mbLeft : 屏幕纵向, mbRight:屏幕横向；
     Shift：ssShift, ssAlt, ssCtrl,ssLeft, ssRight,
     分别对应0:未知/1:PC/2:Android/3:iPhone/4:Tablet
     另外，浏览窗体的
     screenWidth可以通过dwGetProp(Self,'screenwidth')得到；
     screenHeight可以通过dwGetProp(Self,'screenheight')得到；
     innerWidth可以通过dwGetProp(Self,'innerwidth')得到；
     innerHeight可以通过dwGetProp(Self,'innerheight')得到；
     clientWidth可以通过dwGetProp(Self,'clientwidth')得到；
     clientHeight可以通过dwGetProp(Self,'clientheight')得到；

     }
     Label2.Caption := 'Width          : '+IntToStr(X);
     Label3.Caption := 'Height         : '+IntToStr(Y);
     Label4.Caption := 'Orientation    : '+dwIIF(Button=mbLeft,'Vert','Horz');
     if ssShift in Shift then begin
          Label5.Caption := 'Device         : unknown';
     end else if ssAlt in Shift then begin
          Label5.Caption := 'Device         : PC';
     end else if ssCtrl in Shift then begin
          Label5.Caption := 'Device         : Android';
     end else if ssLeft in Shift then begin
          Label5.Caption := 'Device         : iPhone';
     end else if ssRight in Shift then begin
          Label5.Caption := 'Device         : Tablet';
     end;
     Label6.Caption      := 'ScreenWidth    : '+dwGetProp(Self,'screenwidth');
     Label7.Caption      := 'ScreenHeight   : '+dwGetProp(Self,'screenheight');
     Label8.Caption      := 'InnerWidth     : '+dwGetProp(Self,'innerwidth');
     Label9.Caption      := 'InnerHeight    : '+dwGetProp(Self,'innerheight');
     Label10.Caption     := 'ClientWidth    : '+dwGetProp(Self,'clientwidth');
     Label11.Caption     := 'ClientHeight   : '+dwGetProp(Self,'clientheight');
     Label12.Caption     := 'AvailWidth     : '+dwGetProp(Self,'availwidth');
     Label13.Caption     := 'AvailHeight    : '+dwGetProp(Self,'availheight');
     Label14.Caption     := 'BodyWidth     : '+dwGetProp(Self,'bodywidth');
     Label15.Caption     := 'BodyHeight    : '+dwGetProp(Self,'bodyheight');

end;

end.
