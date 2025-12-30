unit unit_Hello;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls;

type
  TForm_Hello = class(TForm)
    Label1: TLabel;
    procedure FormShow(Sender: TObject);
  private
  public
	gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
  end;


implementation

uses
    Unit1;
{$R *.dfm}



procedure TForm_Hello.FormShow(Sender: TObject);
begin
    //各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
    Label1.Caption  := 'Hello, DeWeb '#13'权限：'+gsRights;
end;


end.
