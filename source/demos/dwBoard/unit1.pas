unit unit1;

interface

uses
    dwBase,
    dwBoard,
    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, FireDAC.Stan.Intf, FireDAC.Stan.Option,
    FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB, FireDAC.Comp.Client;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    FDConnection1: TFDConnection;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置为PC模式
    dwSetPCMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    //初始化panel
    bdInit(Panel1,FDConnection1,False,'');
end;

end.
