unit Unit1;

interface

uses
  Winapi.Windows,
  Vcl.Forms, Vcl.StdCtrls, Vcl.Controls, Vcl.ComCtrls, System.Classes,System.SysUtils,System.DateUtils,idhttp;

type
  TForm1 = class(TForm)
    Memo1: TMemo;
    Button2: TButton;
    Button4: TButton;
    Memo2: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  ExeEnName,ExeCnName:string;
implementation

{$R *.dfm}


uses uUserAgent,System.JSON,System.Net.URLClient, System.Net.HttpClientComponent,System.RegularExpressions,System.NetEncoding;







function GetPageCode(const AURL: string; const AIndex: Integer): string;
var
  HttpClient_: TNetHTTPClient;
  PageContent: string;
  URI: TURI;
begin
  HttpClient_ := TNetHTTPClient.Create(nil);
  try
    HttpClient_.ConnectionTimeout := 5000;
    HttpClient_.ResponseTimeout := 5000;
    HttpClient_.UserAgent :=TUserAgent.GetRandomUA;;
    HttpClient_.AllowCookies := True;
    HttpClient_.HandleRedirects := True;
    HttpClient_.MaxRedirects := AIndex;
    HttpClient_.CustomHeaders['Referer']:='https://hk.finance.ifeng.com/qc_ifr.php?part=1';
    PageContent :=HttpClient_.Get(AURL).ContentAsString();
    Result :=PageContent;
   // PageContent := TRegEx.Match(PageContent, '<title\b[^>]*>(.*?)</title>',[roIgnoreCase, roMultiLine]).Value;
   // Result := TRegEx.Replace(PageContent, '</?[a-z][a-z0-9]*[^<>]*>|<!--.*?-->', '',[roIgnoreCase, roMultiLine]);
  finally
  end;
end;



procedure TForm1.Button2Click(Sender: TObject);
var
     jsonstr:string;
begin
     Memo1.Clear;
     jsonstr := GetPageCode('https://ifeng.szfuit.com:883/ifeng/index_ifr.php?part=8&jsonp=show_ssk_conn&_='+datetimetounix(now).tostring,2);
     //jsonstr:=StringReplace (jsonstr, '"', '\"', [rfReplaceAll]);
     memo1.Lines.Add(jsonstr);

end;

procedure TForm1.Button4Click(Sender: TObject);
var
     I: Integer;
     m_JsonStr: string;
     m_SubArray: TJSONArray;
     m_JsonObject: TJSONObject;
     m_SubJsonObj: TJSONObject;
begin
     m_JsonStr := Trim(Memo1.Text);
     //m_JsonStr:=StringReplace (m_JsonStr, '"', '''', [rfReplaceAll]);
     //m_JsonStr:=StringReplace (m_JsonStr, '''', '\''', [rfReplaceAll]);
     Memo1.Text:=m_JsonStr;

     m_JsonObject := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(m_JsonStr), 0) as TJSONObject;

     // 取最外层
     for I := 0 to m_JsonObject.count - 1 do
     begin
          Memo2.Lines.Add(m_JsonObject.Get(I).JsonString.toString + ' = ' + m_JsonObject.Get(I).JsonValue.ToString);
     end;


end;

procedure TForm1.FormCreate(Sender: TObject);
begin
     Exit;

     //
     ExeEnName:='DomainHistory';
     ExeCnName:='域名历史速查器';
     //form1.Caption:=ExeCnName+Edit_SoftVer.Text;
     //PageControl1.Pages[0].Caption:=ExeCnName;
end;

end.
