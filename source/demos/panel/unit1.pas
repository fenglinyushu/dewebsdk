unit unit1;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_02_Buttons: TPanel;
    Button2: TButton;
    Button5: TButton;
    Button6: TButton;
    Panel_03_Control: TPanel;
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Panel1: TPanel;
    Label_Event: TLabel;
    Panel2: TPanel;
    Panel3: TPanel;
    Label3: TLabel;
    Label4: TLabel;
    Panel4: TPanel;
    Label5: TLabel;
    Panel5: TPanel;
    Panel6: TPanel;
    Panel7: TPanel;
    Panel8: TPanel;
    Panel9: TPanel;
    Panel10: TPanel;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
    procedure Panel1Enter(Sender: TObject);
    procedure Panel1Exit(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button2Click(Sender: TObject);
begin
     with Panel1 do begin
          Visible   := not Visible;
     end;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     with Panel1 do begin
          Width  := Width + 5;
          Height := Height + 5;
     end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     with Panel1 do begin
          Left := Left + 5;
          Top  := Top  + 5;
     end;
end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
     Label_Event.Caption := 'OnClick';
     dwShowMessage('OnClick',self);
end;

procedure TForm1.Panel1Enter(Sender: TObject);
begin
     Label_Event.Caption := 'OnEnter';

end;

procedure TForm1.Panel1Exit(Sender: TObject);
begin
     Label_Event.Caption := 'OnExit';

end;

end.
