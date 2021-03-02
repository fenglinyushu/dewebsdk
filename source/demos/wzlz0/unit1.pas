unit unit1;

interface

uses
     //
     dwBase,

     //
     CloneComponents,    //非常好用的克隆控件单元
     JsonDataObjects,    //JSON解析单元

     //
     Math,
     SysUtils,
     Vcl.Controls, Vcl.Forms, Data.DB, Data.Win.ADODB, Vcl.StdCtrls,
     Vcl.ExtCtrls, Vcl.Imaging.pngimage, System.Classes, Vcl.Buttons;

type
  TForm1 = class(TForm)
    ADOQuery: TADOQuery;
    Panel_99_Buttons: TPanel;
    ScrollBox1: TScrollBox;
    Panel_98_Line: TPanel;
    SpeedButton4: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton1: TSpeedButton;
    Image_Logo: TImage;
    Button_Search: TButton;
    Panel_Demo: TPanel;
    Panel10: TPanel;
    Label_ProductName: TLabel;
    Label_DateName: TLabel;
    Button_Detail: TButton;
    Panel18: TPanel;
    Panel_ScollAll: TPanel;
    Panel_Image: TPanel;
    Image_Product: TImage;
    Panel_ImageInner: TPanel;
    Button_Process: TButton;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Button_LoginClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button_LoginClick(Sender: TObject);
begin
     ADOQuery.Close;
     //ADOQuery.SQL.Text   := 'SELECT UserName FROM wzUsers ' +'WHERE UserName='''+Edit_User.Text+''' AND Password='''+Edit_Psd.Text+'''';
     ADOQuery.Open;

     if ADOQuery.IsEmpty then begin
          dwShowMessage('请输入正确的用户名/密码。默认:admin/123456',self);
     end else begin

          //
          dwOpenUrl(self,'/wzlz0.dw','_self');
     end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
     oPanel    : TPanel;
     joData    : TJsonObject;
     iRec      : Integer;
begin
     //
     ADOQuery.Close;
     ADOQuery.SQL.Text   := 'SELECT * FROM wzCirculations';
     ADOQuery.Open;

     //
     for iRec := 1 to ADOQuery.RecordCount do begin
          //
          joData    := TJsonObject(TJsonObject.Parse(ADOQuery.FieldByName('data').AsString));

          oPanel    := TPanel(CloneComponent(Panel_Demo));

          //
          oPanel.Visible      := True;
          oPanel.Top          := 9999;

          //
          with joData.A['items'][0] do begin
               TImage(FindComponent('Image_Product'+IntToStr(iRec))).Hint     := '{"src":"/media/images/'+S['productpicture']+'"}';
               //
               TLabel(FindComponent('Label_ProductName'+IntToStr(iRec))).Caption   :=  S['productname']+'   '+S['productmodel'];
               //
               TLabel(FindComponent('Label_DateName'+IntToStr(iRec))).Caption      :=  FormatDateTime('YYYY-MM-DD ',ADOQuery.FieldByName('lastdate').AsDateTime)+'   '+ADOQuery.FieldByName('lastuser').AsString;
          end;
          //
          ADOQuery.Next;
     end;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
     Width     := Min(480,X);
     if X>480 then begin
          Height    := Y-160;
     end else begin
          Height    := Y;
     end;
     //
     SpeedButton1.Width  := Width div 4;
     SpeedButton2.Width  := SpeedButton1.Width;
     SpeedButton3.Width  := SpeedButton1.Width;
     SpeedButton4.Width  := SpeedButton1.Width;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
     dwOpenUrl(self,'/wzlz1.dw','_self');
end;

end.
