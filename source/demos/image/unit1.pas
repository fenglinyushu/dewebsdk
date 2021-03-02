unit unit1;

interface

uses
     //
     dwBase,

     //
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.MPlayer,
  Vcl.Menus, Vcl.Buttons, Vcl.Samples.Spin, Vcl.Imaging.jpeg;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Image_image_mm: TImage;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image_image_mmClick(Sender: TObject);
    procedure Image_image_mmMouseEnter(Sender: TObject);
    procedure Image_image_mmMouseLeave(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}
function GetDllPath: string;
var
     ModuleName: string;
begin
     SetLength(ModuleName, 255);
     //取得Dll自身路径
     GetModuleFileName(HInstance, PChar(ModuleName), Length(ModuleName));
     Result := PChar(ModuleName);
end;
function dwGetDllName: string;
var
     sModule   : string;
begin
     SetLength(sModule, 255);
     //取得Dll自身路径
     GetModuleFileName(HInstance, PChar(sModule), Length(sModule));
     //去除路径
     while Pos('\',sModule)>0 do begin
          Delete(sModule,1,Pos('\',sModule));
     end;
     //去除.dll
     if Pos('.',sModule)>0 then begin
          sModule     := Copy(sModule,1,Pos('.',sModule)-1);
     end;

     //
     Result := PChar(sModule);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
     //
     dwShowMessage('Hello,DeWeb!',self);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     //Width     := X-30;
     //Height    := Y-30;
end;

procedure TForm1.Image_image_mmClick(Sender: TObject);
begin
     Label1.Caption := 'OnClick';
     if Button1.Tag <3 then begin
          Button1.Tag    := Button1.Tag + 1;
     end else begin
          Button1.Tag    := 0;
     end;
     //
     case Button1.Tag of
          0 : begin
               Button1.Hint   := '{"type":"default"}';
          end;
          1 : begin
               Button1.Hint   := '{"type":"success"}';
          end;
          2 : begin
               Button1.Hint   := '{"type":"primary"}';
          end;
          3 : begin
               Button1.Hint   := '{"type":"danger"}';
          end;
     end;
end;

procedure TForm1.Image_image_mmMouseEnter(Sender: TObject);
begin
     Label1.Caption := 'OnEnter';

end;

procedure TForm1.Image_image_mmMouseLeave(Sender: TObject);
begin
     Label1.Caption := 'OnLeave';

end;

end.
