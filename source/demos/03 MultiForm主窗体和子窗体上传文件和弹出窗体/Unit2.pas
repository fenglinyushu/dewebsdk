unit Unit2;

interface

uses
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.Grids, Data.DB, Vcl.DBGrids;

type
  TForm2 = class(TForm)
    Label1: TLabel;
    Timer1: TTimer;
    Button3: TButton;
    Button1: TButton;
    Button2: TButton;
    B_Upload: TButton;
    procedure Timer1Timer(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure B_UploadClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses
    Unit1,Unit3,Unit4;

procedure TForm2.Button1Click(Sender: TObject);
begin
    Timer1.DesignInfo   := 0;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin
    dwShowModalPro(TForm1(self.Owner),TForm1(self.Owner).Form4);
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
    Timer1.DesignInfo   := 1;

end;

procedure TForm2.B_UploadClick(Sender: TObject);
begin
    dwUpload(self,'image/*','mydir');
end;

procedure TForm2.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sSource,sLast   : string;
begin
    //取得上传后的文件名称
    sLast   := dwGetProp(TForm1(self.Owner),'__upload');
    //取得上传文件的原始名称
    sSource := dwGetProp(TForm1(self.Owner),'__uploadsource');
    //更新
    B_Upload.Caption    := 'Uploaded at '+IntToStr(GetTickCount);
    //提示信息
    dwMessage(Format('Form2上传！源：%s, 上传:%s',[sSource,sLast]),'success',TForm1(self.Owner));
end;

procedure TForm2.Timer1Timer(Sender: TObject);
begin
    Label1.Caption  := FormatDateTime('MM-DD hh:mm:ss zzz',Now);
end;

end.
