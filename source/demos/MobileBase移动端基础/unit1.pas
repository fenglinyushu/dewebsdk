unit unit1;

interface

uses
     //
     dwBase,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TForm1 = class(TForm)
    Panel_0_Header: TPanel;
    Panel_1_Content: TPanel;
    Panel_2_Footer: TPanel;
    Label1: TLabel;
    Label3: TLabel;
    Button1: TButton;
    Panel1: TPanel;
    Button2: TButton;
    Button3: TButton;
    Label2: TLabel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    gsMainDir   : string;
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button1Click(Sender: TObject);
begin
    dwHistoryPush(self);
    Panel1.Visible  := True;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    Panel1.Visible  := True;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    dwHistoryBack(self);
    Panel1.Visible  := True;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置当前为移动终端模式,默认分辨率为414,736
    dwSetMobileMode(self,414,736);
end;

procedure TForm1.FormUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
begin
    //
    if Panel1.Visible then begin
        Panel1.Visible  := False;
    end;
end;

end.
