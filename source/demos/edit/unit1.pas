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
    Button_Enabled: TButton;
    Button5: TButton;
    Button6: TButton;
    Panel_03_Control: TPanel;
    Panel_01_Tile: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Label2: TLabel;
    Button_Visible: TButton;
    Label_Event: TLabel;
    Edit1: TEdit;
    Edit2: TEdit;
    Label3: TLabel;
    Label4: TLabel;
    Edit3: TEdit;
    Label5: TLabel;
    Edit4: TEdit;
    Label6: TLabel;
    Edit5: TEdit;
    Label7: TLabel;
    Label8: TLabel;
    Edit6: TEdit;
    procedure Button6Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button_EnabledClick(Sender: TObject);
    procedure Button_VisibleClick(Sender: TObject);
    procedure Edit5Change(Sender: TObject);
    procedure Edit5Enter(Sender: TObject);
    procedure Edit5Exit(Sender: TObject);
    procedure Edit5MouseEnter(Sender: TObject);
    procedure Edit5MouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Button_EnabledClick(Sender: TObject);
begin
     with Edit5 do begin
          Enabled   := not Enabled;
     end;
end;

procedure TForm1.Button_VisibleClick(Sender: TObject);
begin
     with Edit5 do begin
          Visible   := not Visible;
     end;

end;

procedure TForm1.Edit5Change(Sender: TObject);
begin
     Label_Event.Caption := 'OnChange';
end;

procedure TForm1.Edit5Enter(Sender: TObject);
begin
     Label_Event.Caption := 'OnEnter';

end;

procedure TForm1.Edit5Exit(Sender: TObject);
begin
     Label_Event.Caption := 'OnExit';

end;

procedure TForm1.Edit5MouseEnter(Sender: TObject);
begin
     Label_Event.Caption := 'OnMouseEnter';

end;

procedure TForm1.Edit5MouseLeave(Sender: TObject);
begin
     Label_Event.Caption := 'OnMouseLeave';

end;

procedure TForm1.Button5Click(Sender: TObject);
begin
     with Edit5 do begin
          Width  := Width + 5;
          Height := Height + 5;
     end;
end;

procedure TForm1.Button6Click(Sender: TObject);
begin
     with Edit5 do begin
          Left := Left + 5;
          Top  := Top  + 5;
     end;
end;

end.
