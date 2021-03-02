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
  VCLTee.TeeProcs, VCLTee.Chart, Vcl.WinXCtrls;

type
  TForm1 = class(TForm)
    Image_Logo: TImage;
    Panel_User: TPanel;
    Label_User: TLabel;
    Edit_User: TEdit;
    Panel_psd: TPanel;
    Label_Psd: TLabel;
    Edit_Psd: TEdit;
    Panel_Login: TPanel;
    Button_Login: TButton;
    CheckBox_Remember: TCheckBox;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_LoginClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button_LoginClick(Sender: TObject);
begin
     if Trim(Edit_User.Text)='' then begin
          dwShowMessage('请输入用户名。默认:admin',self);
          Exit;
     end;
     if Length(Trim(Edit_Psd.Text))<6 then begin
          dwShowMessage('密码至少6位。默认:123456',self);
          Exit;
     end;

     //
     if (Edit_User.Text = 'admin') and (Edit_Psd.Text = '123456') then begin
          dwOpenUrl(self,'/xfkq0.dw?user='+Edit_User.Text,'_self');
     end else begin
          dwShowMessage('请输入正确的用户名/密码。默认:admin/123456',self);
     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := Min(400,X);
     Height    := Y-80;
end;

end.
