unit unit_qr;

interface

uses
     dwBase,

     //生成二维码的单元
     DelphiZXingQRCode,

     //
     Vcl.Imaging.jpeg,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls;

type
  TForm_qr = class(TForm)
    Button1: TButton;
    Image_qrcode: TImage;
    Memo1: TMemo;
    PTitle: TPanel;
    LTitle: TLabel;
    B0: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
  end;

var
     Form_qr             : TForm_qr;


implementation


{$R *.dfm}

//根据URL生成图片文件
procedure UrlToQrCode(AUrl:String;ASize:Integer;AFileName:String);
var
    QRCode: TDelphiZXingQRCode;
    Row, Column: Integer;
    QRCodeBitmap: TBitmap;
    oImage  : TImage;
    var  Scale: Double;
begin
    QRCodeBitmap := TBitmap.Create;
    QRCode := TDelphiZXingQRCode.Create;
    try
        QRCode.Data := AUrl;
        QRCode.Encoding := TQRCodeEncoding(0);
        QRCode.QuietZone := 4;//StrToIntDef(, 4);
        QRCodeBitmap.SetSize(QRCode.Rows, QRCode.Columns);
        for Row := 0 to QRCode.Rows - 1 do begin
            for Column := 0 to QRCode.Columns - 1 do begin
                if (QRCode.IsBlack[Row, Column]) then  begin
                    QRCodeBitmap.Canvas.Pixels[Column, Row] := clBlack;
                end else begin
                    QRCodeBitmap.Canvas.Pixels[Column, Row] := clWhite;
                end;
            end;
        end;
    finally
        QRCode.Free;
    end;
    //
    oImage  := TImage.Create(nil);
    oImage.Width    := ASize;
    oImage.Height   := ASize;
    oImage.Canvas.Brush.Color := clWhite;
    oImage.Canvas.FillRect(Rect(0, 0, oImage.Width, oImage.Height));
    if ((QRCodeBitmap.Width > 0) and (QRCodeBitmap.Height > 0)) then begin
        if (oImage.Width < oImage.Height) then begin
            Scale := oImage.Width / QRCodeBitmap.Width;
        end else begin
            Scale := oImage.Height / QRCodeBitmap.Height;
        end;
        oImage.Canvas.StretchDraw(Rect(0, 0, Trunc(Scale * QRCodeBitmap.Width), Trunc(Scale * QRCodeBitmap.Height)), QRCodeBitmap);
    end;
    QRCodeBitmap.Free;
    //
    var oJpg := TJPEGImage.Create;
    oJpg.Assign(oImage.Picture.Graphic);
    oJpg.SaveToFile(AFileName);
    oImage.Destroy;
    FreeAndNil(oJpg);
end;


procedure TForm_qr.Button1Click(Sender: TObject);
var
    sName       : string;
    sDir        : string;
begin
    Randomize;
    sName := FormatDateTime('YYYYMMDDhhmmsszzz',Now)+IntToStr(Random(10000));
    //
    sDir    := ExtractFilePath(Application.ExeName);
    //
    ChDir(sDir + '\Media\Images\');
    if Not DirectoryExists('temp') then begin
        MkDir('temp');
    end;
    ChDir(sDir);

    //
    UrlToQrCode(Memo1.Text,300,sDir+'\Media\Images\temp\'+sName+'.jpg');
    //>

    //
    Image_qrcode.Hint   := '{"src":"media/images/temp/'+sName+'.jpg"}';
end;

procedure TForm_qr.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置当前屏幕显示模式为移动应用模式.如果电脑访问，则按414x726（iPhone6/7/8 plus）显示
    //dwBase.dwSetMobileMode(self,414,736);
end;

procedure TForm_qr.FormShow(Sender: TObject);
begin
    Button1.OnClick(self);
end;

end.
