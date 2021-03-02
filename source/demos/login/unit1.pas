unit unit1;

interface

uses
     //
     dwBase,
     cnDes,

     //
     JsonDataObjects,

     //
     HttpApp,Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option,
     FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
     FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf,
     FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
     FireDAC.Comp.Client, FireDAC.Comp.DataSet, Data.DB, FireDAC.Phys.SQLite,
     FireDAC.Phys.SQLiteDef, FireDAC.Stan.ExprFuncs;

type
  TForm1 = class(TForm)
    Panel_Full: TPanel;
    Label_User: TLabel;
    Edit_User: TEdit;
    Label_Psd: TLabel;
    Edit_Psd: TEdit;
    Button_Login: TButton;
    CheckBox_Remember: TCheckBox;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    Image_logo: TImage;
    Timer_GetCookie: TTimer;
    procedure Button_LoginClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure Timer_GetCookieTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1          : TForm1;
     //
     gjoConfig      : TJsonObject;           //�����ļ�
     //
     gsConfigFile   : string='bbs_login.json';
     gsTableName    : String='bbs_user';     //�û�����
     gsUserNameFld  : string='username';     //�û����ֶ���
     gsPasswordFld  : string='password';     //�����ֶ���
     gsSaltFld      : string='salt';         //salt�ֶ���
     gsInvalid      : string='�û��������벻��ȷ��';   //���������ʾ
     giRememberDays : Integer = 30;          //��ס��������
     gsSuccessHref  : string='/bbs.dw';      //��¼�ɹ���򿪵Ľ���


implementation

{$R *.dfm}




procedure TForm1.Button_LoginClick(Sender: TObject);
var
     sSalt     : string;
     sPassword : string;
     iTicks    : Integer;
     sName     : string;
     sCode     : string;
begin
     //�����ݱ�
     FDQuery.Close;
     FDQuery.SQL.Text   := 'SELECT * FROM '+gsTableName+' WHERE '+gsUserNameFld+'='''+Edit_User.Text+'''';
     FDQuery.Open;

     //
     if FDQuery.IsEmpty then begin
          dwShowMessage(gsInvalid,self);
     end else begin
          //ȡ�����ݱ���salt������
          sSalt     := FDQuery.FieldByName(gsSaltFld).AsString;
          sPassword := FDQuery.FieldByName(gsPasswordFld).AsString;
          sName     := Edit_User.Text;

          //�����ȷ��
          if sPassword = dwGetMD5(dwGetMD5(Edit_Psd.Text)+sSalt) then begin
               //
               dwSetCookie(self,'dw_user',Edit_User.Text,24*giRememberDays);      //

               //����ǰ��¼�û���Ϣд��cookie��ʵ��ʹ��ʱ�����ȼ��ܣ���д�룩
               if CheckBox_Remember.Checked then begin
                    dwSetCookie(self,'dw_loginuser',Edit_User.Text,24*giRememberDays);  //һ����
                    dwSetCookie(self,'dw_loginpassword', Edit_Psd.Text,24*giRememberDays);  //һ����
               end else begin
                    dwSetCookie(self,'dw_loginuser','',1);  //
                    dwSetCookie(self,'dw_password', '',1);  //
               end;

               //������ҳ
               dwOpenUrl(self,gsSuccessHref,'_self');
          end else begin
               dwShowMessage(gsInvalid,self);
          end;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     //
     try
          if FileExists(gsConfigFile) then begin
               gjoConfig := TJsonObject.Create;
               gjoConfig.LoadFromFile(gsConfigFile);
               //���ݿ�
               FDConnection.ConnectionString := gjoConfig.O['database'].S['connectionstring'];
               FDConnection.Open();

               //Caption/PlaceHolder
               Caption                  := gjoConfig.O['captions'].S['form'];        //ҳ�����
               Label_User.Caption       := gjoConfig.O['captions'].S['username'];    //�û���
               Label_Psd.Caption        := gjoConfig.O['captions'].S['password'];    //����
               CheckBox_Remember.Caption:= gjoConfig.O['captions'].S['rememberme'];  //��ס����
               Edit_User.Hint           := '{"suffix-icon":"el-icon-user","placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';     //�û����������ʾ
               Edit_Psd.Hint            := '{"placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';    //�����������ʾ
               Button_Login.Caption     := gjoConfig.O['captions'].S['login'];       //��¼��ť
               gsInvalid                := gjoConfig.O['captions'].S['invalid'];     //���������ʾ

               //
               giRememberDays           := gjoConfig.I['rememberdays'];    //��ס����
               gsSuccessHref            := gjoConfig.S['successhref'];     //��¼�ɹ���򿪵���ַ
               CheckBox_Remember.Checked:= gjoConfig.B['remember'];

               //logo
               if gjoConfig.S['logo']<>'' then begin
                    Image_Logo.Hint     := '{"src":"'+gjoConfig.S['logo']+'"}';
               end;

               //
               gsTableName    := gjoConfig.O['database'].S['tablename'];
               gsUserNameFld  := gjoConfig.O['database'].S['usernamefield'];
               gsPasswordFld  := gjoConfig.O['database'].S['passwordfield'];
               gsSaltFld      := gjoConfig.O['database'].S['saltfield'];
          end;
     except

     end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
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

     if bMobile then begin
          //����ʱΪ�ȿ��������ƿ��Ϊ���360
          if bVert then begin
               Width     := iWidth;
          end else begin
               Width     := Min(480,iWidth);
          end;
          //
          Panel_Full.BorderStyle   := bsNone;
          TransparentColorValue    := clWhite;
     end else begin
          //
          Width     := Min(360,iWidth);

          //
          Panel_Full.BorderStyle   := bsSingle;
          TransparentColorValue    := clBtnFace;
     end;

end;

procedure TForm1.Timer_GetCookieTimer(Sender: TObject);
var
     sUser     : string;
begin
     //
     if Timer_GetCookie.Tag=0 then begin
          //Ԥ��ȡ
          dwPreGetCookie(self,'dw_loginuser','');
          dwPreGetCookie(self,'dw_loginpassword','');
     end else if Timer_GetCookie.Tag < 30 then begin
          sUser     := dwGetCookie(self,'dw_loginuser');
          //
          if sUser <>'' then begin
               //��ʾ�û���
               Edit_User.Text      := sUser;
               Edit_Psd.Text       := dwGetCookie(self,'dw_loginpassword');
               //ֹͣTimer
               Timer_GetCookie.DesignInfo        := 0;
          end;
     end else begin
          //ֹͣTimer
          Timer_GetCookie.DesignInfo   := 0;
     end;

     //
     Timer_GetCookie.Tag := Timer_GetCookie.Tag +1;

end;

end.
