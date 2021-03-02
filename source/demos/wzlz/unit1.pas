unit unit1;

interface

uses
     //
     dwBase,

     //
     Math,
     Vcl.Controls, Vcl.Forms, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
     Vcl.ExtCtrls, Vcl.Imaging.pngimage, System.Classes;

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
    ADOQuery: TADOQuery;
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
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT UserName FROM wzUsers '
               +'WHERE UserName='''+Edit_User.Text+''' AND Password='''+Edit_Psd.Text+'''';
     ADOQuery.Open;

     if ADOQuery.IsEmpty then begin
          dwShowMessage('请输入正确的用户名/密码。默认:admin/123456',self);
     end else begin
          //记住密码
          if CheckBox_Remember.Checked then begin
               //写入cookie
               dwSetCookie(self,'dwwzlz_user',Edit_User.Text,240);
          end;


          //
          dwOpenUrl(self,'/wzlz0.dw','_self');
     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := Min(480,X);
     Height    := Y;
end;

end.
