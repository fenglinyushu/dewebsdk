unit unit1;

interface

uses
     //
     dwBase,

     //��SQLite��Ԫ
     ZAbstractRODataset, ZDataset,ZConnection,

     //��MD5
     IdHashMessageDigest,IdGlobal, IdHash,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Vcl.Imaging.pngimage, Vcl.Buttons;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label3: TLabel;
    Edit_User: TEdit;
    Label4: TLabel;
    Edit_Psd: TEdit;
    Button4: TButton;
    Image_dfwlogo: TImage;
    CheckBox_Remember: TCheckBox;
    Button_QQ: TButton;
    procedure Button4Click(Sender: TObject);
    procedure Button_QQClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
     ZQuery    : TZReadOnlyQuery;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function dfwGetMD5(AStr:String):string;
var
     oMD5      : TIdHashMessageDigest5;
begin
     oMD5      := TIdHashMessageDigest5.Create;
     Result    := LowerCase(oMD5.HashStringAsHex(AStr));
     oMD5.Free;
end;


procedure TForm1.Button4Click(Sender: TObject);
var
     bRight    : Boolean;
     sSalt     : String;
     sPsd      : string;
begin
     bRight    := False;

     //
     ZQuery.Close;
     ZQuery.SQL.Text     := 'SELECT * FROM bbs_user WHERE username='''+Edit_User.Text+'''';
     ZQuery.Open;

     if not ZQuery.IsEmpty then begin
          sSalt     := ZQuery.FieldByName('salt').AsString;
          sPsd      := ZQuery.FieldByName('password').AsString;
          //
          if dfwGetMD5(dfwGetMD5(Edit_Psd.Text)+sSalt)=sPsd then begin
               bRight    := True;
          end;
     end;

     //
     if bRight then begin
          //����ǰ��¼�û���Ϣд��cookie��ʵ��ʹ��ʱ�����ȼ��ܣ���д�룩
          dwSetCookie(self,'dfw_user',Edit_User.Text,24*30);

          //������ҳ
          dwOpenUrl(self,'/dfw.dw','');
     end else begin
          dwShowMessage('�û��������벻��ȷ��',self);
     end;
end;

procedure TForm1.Button_QQClick(Sender: TObject);
begin
     dwOpenUrl(self,'https://graph.qq.com/oauth2.0/authorize?response_type=code&client_id=101559562&redirect_uri=http://delphibbs.com/qq_login-return.htm&scope=scope&display=display','_self');
end;

procedure TForm1.FormCreate(Sender: TObject);
type
     PdwGetConn   = function ():TZConnection;StdCall;
var
     iDll      : Integer;
     //
     fGetConn  : PdwGetConn;
begin
     //����TOP, �������༭ʱ�ĸ���
     Top  := 0;

     //
     ZQuery    := TZReadOnlyQuery.Create(self);

     //�õ�ZConnection
     if FileExists('dwZConnection.dll') then begin
          iDll      := LoadLibrary('dwZConnection.dll');
          fGetConn  := GetProcAddress(iDll,'dwGetConnection');

          ZQuery.Connection   := fGetConn;
     end;

end;

end.
