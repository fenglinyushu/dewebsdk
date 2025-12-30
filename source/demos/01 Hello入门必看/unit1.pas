unit unit1;

interface

uses
     dwBase,
     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    gsParams    : String;
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    dwMessage('Hello, DeWeb!','success',self);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //dwMessage('mousedown','',self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置为移动端模式。 如果不是移动端，则设置分辨率为360x740
    dwSetMobileMode(Self,360,740);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //取得url中?后面的参数
    gsParams    := dwGetProp(Self,'params');

    //对参数进行escape解码。
    gsParams    := dwUnescape(gsParams);

    //赋值（仅用于测试）
    if gsParams <> '' then begin
        Button1.Caption := gsParams;
    end;

end;

end.
