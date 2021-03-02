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
    Button_Register: TButton;
    FDQuery: TFDQuery;
    FDConnection: TFDConnection;
    Image_logo: TImage;
    Label_PsdConfirm: TLabel;
    Edit_PsdConfirm: TEdit;
    Label_Email: TLabel;
    Edit_Email: TEdit;
    procedure Button_RegisterClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
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
     gsEmailFld     : string='email';        //salt�ֶ���
     gsInvalid      : string='�û��������벻��ȷ��';   //���������ʾ
     giRememberDays : Integer = 30;          //��ס��������
     gsSuccessHref  : string='/bbs.dw';      //��¼�ɹ���򿪵Ľ���


implementation

{$R *.dfm}




procedure TForm1.Button_RegisterClick(Sender: TObject);
var
     sSalt     : string;
     iTicks    : Integer;
     sEmail    : string;
     sName     : string;
     sPassword : string;
     sConfirm  : string;
     sDBPsd    : string;
     sCode     : string;
begin
     //ȡ��ֵ
     sEmail    := Trim(Edit_Email.Text);
     sName     := Trim(Edit_User.Text);
     sPassword := Trim(Edit_Psd.Text);
     sConfirm  := Trim(Edit_PsdConfirm.Text);

     //<�쳣���
     if (sEmail='') or (sName='') or (sPassword='') then begin
          dwShowMessage('���䡢�û��������벻��Ϊ�գ�',self);
          Exit;
     end;
     if (Pos('@',sEmail)<=0) or (Pos('.',sEmail)<=0) then begin
          dwShowMessage('��������ȷ�����ַ��',self);
          Exit;
     end;
     if (sPassword <> sConfirm) then begin
          dwShowMessage('������������벻һ�£�',self);
          Exit;
     end;
     if (Length(sPassword) < 8) then begin
          dwShowMessage('��������8λ��',self);
          Exit;
     end;
     //>

     //<�ظ����
     //�����ݱ�
     FDQuery.Close;
     FDQuery.SQL.Text   := 'SELECT * FROM '+gsTableName
          +' WHERE '+gsEmailFld+'='''+sEmail+'''';
     FDQuery.Open;
     if not FDQuery.IsEmpty then begin
          dwShowMessage('������ע�ᣡ',self);
          Exit;
     end;
     FDQuery.Close;
     FDQuery.SQL.Text   := 'SELECT * FROM '+gsTableName
          +' WHERE '+gsUserNameFld+'='''+sName+'''';
     FDQuery.Open;
     if not FDQuery.IsEmpty then begin
          dwShowMessage('�û�����ע�ᣡ',self);
          Exit;
     end;
     //>




     //��ʼע��
     sSalt     := FormatDateTime('YYYYMMDDhhmmss',now)+IntToStr(GetTickCount);
     sDBPsd    := dwGetMD5(dwGetMD5(sPassword)+sSalt);

     //�û��������䣬salt,password,create_date
     FDQuery.Close;
     FDQuery.SQL.Text   := 'INSERT INTO bbs_user (username,email,salt,password,create_date)'
               +Format(' VALUES(''%s'',''%s'',''%s'',''%s'',%d)',[sName,sEmail,sSalt,sDBPsd,dwDateToPHPDate(Now)]);
     FDQuery.ExecSQL;

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
               Edit_User.Hint           := '{"suffix-icon":"el-icon-user","placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';     //�û����������ʾ
               Edit_Psd.Hint            := '{"placeholder":"'+gjoConfig.O['captions'].S['usernameplaceholder']+'"}';    //�����������ʾ
               Button_Register.Caption  := gjoConfig.O['captions'].S['login'];       //��¼��ť
               gsInvalid                := gjoConfig.O['captions'].S['invalid'];     //���������ʾ

               //
               giRememberDays           := gjoConfig.I['rememberdays'];    //��ס����
               gsSuccessHref            := gjoConfig.S['successhref'];     //��¼�ɹ���򿪵���ַ

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

end.
