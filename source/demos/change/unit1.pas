unit unit1;

interface

uses
     //
     dwBase,
     cndes,

     //
     HttpApp,
     EncdDecd,
     ADODB,DB,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
     Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Label_Title: TLabel;
    Label_User: TLabel;
    Edit_Psd: TEdit;
    Label_Psd: TLabel;
    Edit_Confirm: TEdit;
    Button_OK: TButton;
    Img_course: TImage;
    Panel_line: TPanel;
    ADOQuery: TADOQuery;
    procedure Button_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;



implementation

{$R *.dfm}


function _GetADOConnection:TADOConnection;
type
     PdwGetConn   = function ():TADOConnection;StdCall;
var
     iDll      : Integer;
     //
     fGetConn  : PdwGetConn;
begin
     Result    := nil;

     //得到ADOConnection
     if FileExists('dwADOConnection.dll') then begin
          iDll      := LoadLibrary('dwADOConnection.dll');
          fGetConn  := GetProcAddress(iDll,'dwGetConnection');

          Result    := fGetConn;
     end;

end;


procedure TForm1.Button_OKClick(Sender: TObject);
var
     sSalt     : string;
     sPassword : string;
begin
     if Length(Edit_Psd.Text) <8 then begin
          dwShowMessage('密码至少8位，请重新输入！',self);
     end else if Edit_Psd.Text <> Edit_Confirm.Text then begin
          dwShowMessage('两次密码不一致，请重新输入！',self);
          Edit_psd.Text       := '';
          Edit_Confirm.Text   := '';
     end else begin
          //写新密码
          ADOQuery.Close;
          ADOQuery.SQL.Text   := 'SELECT * FROM member WHERE username='''+Label_Title.Caption+'''';
          ADOQuery.Open;

          //dwGetMD5(dwGetMD5(APassword)+sSalt)=sPsd

          //
          if ADOQuery.IsEmpty then begin
               dwShowMessage('未找到用户名，请联系管理员！',self);
          end else begin
               sSalt     := IntToStr(GetTickCount);
               sPassword := dwGetMD5(dwGetMD5(Edit_Psd.Text)+sSalt);
               //
               ADOQuery.Edit;
               ADOQuery.FieldByName('salt').AsString        := sSalt;
               ADOQuery.FieldByName('password').AsString    := sPassword;
               //
               ADOQuery.Post;
               //
               dwOpenUrl(self,'/login.dw','');
          end;
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     ADOQuery.Connection := _GetADOConnection;
end;

procedure TForm1.FormShow(Sender: TObject);
var
     sParams   : String;
     sTicks    : string;
     sName     : string;
     sCode     : string;
     sNameCode : string;
begin
     //得到参数, 形如： 张明&&124545&&EFAD123A, 分别为：姓名、毫秒数（用于加密）、校验码
     sParams   := HttpDecode(dwGetProp(self,'params'));

     //解析得到：姓名、毫秒数（用于加密）、校验码
     sName     := Copy(sParams,1,Pos('&&',sParams)-1);
     Delete(sParams,1,Pos('&&',sParams)+1);
     sTicks    := Copy(sParams,1,Pos('&&',sParams)-1);
     Delete(sParams,1,Pos('&&',sParams)+1);
     sCode     := sParams;

     if sName<>'' then begin
          //
          sNameCode := DecryptStr(sCode,StrToInt(sTicks) mod 65536);
          if sName = sNameCode then begin
               Label_Title.Caption      := sName;
          end else begin
               //
               Edit_Psd.Enabled         := False;
               Edit_Confirm.Enabled     := False;
               Button_OK.Enabled        := False;
               //
               Label_Title.Caption      := '校验错误';
          end;
     end;
end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
var
     sValue    : string;
begin
     sValue    := dwGetProp(self,'interactionvalue');
     sValue    := HttpDecode(sValue);
     //
     dwShowMessage('Value : '+sValue,self);
end;

end.
