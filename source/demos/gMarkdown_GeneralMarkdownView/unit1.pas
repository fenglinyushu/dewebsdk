unit unit1;

interface

uses
    //
    dwBase,

    //json解析单元, 优点是使用后不用释放
    Syncommons,

    //用于还原编码后的中文为原中文字符
    IdURI,

    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls;

type
  TForm1 = class(TForm)
    Me1: TMemo;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    gsParams    : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);

end;

procedure TForm1.FormShow(Sender: TObject);
var
    sDir        : String;       //当前路径
    sName       : String;       //应用名称，默认为qcDefault, 建议以qc开始
    //
    joparams    : Variant;      //dwLoad参数对应的JSON对象
begin
    try
        //取得当前路径
        sDir        := ExtractFilePath(Application.ExeName);

        //将AParams转换为JSON对象，以便后续处理
        joParams    := _json(gsParams);

        //从joParams中取得配置文件名称
        sName     := joParams.app.params;
        if sName = '' then begin
            sName   := 'mdDefault';     //mdDefault.json
        end;

        //读取配置文件
        Me1.Lines.LoadFromFile(sDir+'Data/'+TIdURI.URLDecode(sName)+'.md',TEncoding.UTF8);

    except

    end;
end;


end.
