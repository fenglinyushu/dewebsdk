unit Unit_Embed2;

interface

uses
    dwBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.WinXPanels;

type
  TForm_Embed2 = class(TForm)
    P0: TPanel;
    L0: TLabel;
    B0: TButton;
    B1: TButton;
    Label1: TLabel;
    procedure B0Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Embed2: TForm_Embed2;

implementation

{$R *.dfm}

uses
    Unit1;

procedure TForm_Embed2.B0Click(Sender: TObject);
begin
    //通过浏览器发送一个返回消息（需要前面显示该模块/界面时使用dwHistoryPush）
    dwhistoryBack(TForm1(self.Owner));
end;

end.
