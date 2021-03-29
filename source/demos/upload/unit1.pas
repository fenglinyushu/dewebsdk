unit unit1;

interface

uses
     //
     Unit2,


     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
  Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Button1: TButton;
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    Button2: TButton;
    BitBtn3: TBitBtn;
    Button3: TButton;
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Panel_bottomline: TPanel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BitBtn1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
    procedure BitBtn3EndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.BitBtn1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
     BitBtn1.Caption     := 'Uploaded!';
end;

procedure TForm1.BitBtn3EndDock(Sender, Target: TObject; X, Y: Integer);
begin
     dwRunJS('this.'+Form2.Name+'__vis=false;',self);

end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     dwRunJS('this.dwInputSubmit("BitBtn1");',self);

end;

procedure TForm1.Button2Click(Sender: TObject);
begin
     dwRunJS('this.dwInputSubmit("BitBtn2");',self);
end;

procedure TForm1.Button3Click(Sender: TObject);
begin

     dwRunJS('this.'+Form2.Name+'__vis=true;this.dwInputSubmit("BitBtn3");',self);
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
     dwShowMessage(BitBtn1.Caption,self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     if X>700 then begin
          Width     := 480;
     end else begin
          Width     := X;
     end;
     //Height    := Y;
end;

end.
