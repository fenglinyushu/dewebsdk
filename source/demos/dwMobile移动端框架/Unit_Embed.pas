unit Unit_Embed;

interface

uses
    dwBase,
    //
    Unit_Modal,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm_Embed = class(TForm)
    P0: TPanel;
    L0: TLabel;
    B0: TButton;
    B1: TButton;
    Label1: TLabel;
    B2: TButton;
    B3: TButton;
    procedure B0Click(Sender: TObject);
    procedure B3Click(Sender: TObject);
    procedure B2Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form_Embed: TForm_Embed;

implementation

{$R *.dfm}

uses
    Unit1,Unit_Embed2;

procedure TForm_Embed.B0Click(Sender: TObject);
begin
    //通过浏览器发送一个返回消息（需要前面显示该模块/界面时使用dwHistoryPush）
    dwhistoryBack(TForm1(self.Owner));
end;

procedure TForm_Embed.B2Click(Sender: TObject);
var
    oForm1  : TForm1;
begin
    oForm1  := TForm1(self.Owner);

    //在子窗体A中打开另一个子窗体B（子窗体B仍然是Form1的子窗体）
    oForm1.dmShowFormModal(TForm_Modal,TForm(Form_Modal),320,500,100,10);

    //为浏览器记录变量添加一条记录
    oForm1.gjoHistory.Add('showform_modal2');
end;

procedure TForm_Embed.B3Click(Sender: TObject);
var
    oForm1  : TForm1;
begin
    oForm1  := TForm1(self.Owner);

    //在子窗体A中打开另一个子窗体B（子窗体B仍然是Form1的子窗体）
    oForm1.dmShowForm(TForm_Embed2,TForm(oForm1.Form_Embed2));

    //为浏览器记录变量添加一条记录
    oForm1.gjoHistory.Add('showform_embed2');
end;

end.
