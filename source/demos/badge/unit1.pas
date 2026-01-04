unit unit1;

interface

uses
    //
    dwBase,

    //
    CloneComponents,


    //
    Math,
    Graphics,strutils,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,  Data.DB, Vcl.DBGrids,
    Vcl.Samples.Gauges, Vcl.Samples.Spin;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Button1: TButton;
    Panel2: TPanel;
    Button2: TButton;
    Panel3: TPanel;
    Button3: TButton;
    Panel4: TPanel;
    Button4: TButton;
    Panel5: TPanel;
    Label1: TLabel;
    Panel6: TPanel;
    Button5: TButton;
    Panel7: TPanel;
    Edit1: TEdit;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public
    gsMainDir   : String;
    sNew        : string;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetMobileMode(Self,360,720);
end;

end.
