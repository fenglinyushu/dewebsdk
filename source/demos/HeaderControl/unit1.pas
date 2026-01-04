unit unit1;

interface

uses
    //
    dwBase,

    //
    Math,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
    Data.DB,Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons;

type
  TForm1 = class(TForm)
    HeaderControl1: THeaderControl;
    HeaderControl2: THeaderControl;
    HeaderControl3: THeaderControl;
    procedure Button1Click(Sender: TObject);
    procedure HeaderControl2SectionClick(HeaderControl: THeaderControl; Section: THeaderSection);
  private
    { Private declarations }
  public

    gsMainDir   : String;
    goConnection    : TADOConnection;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);
begin
    dwMessageDlg('are you sure?','DEWEB','确定','取消','query_delete',self);
end;

procedure TForm1.HeaderControl2SectionClick(HeaderControl: THeaderControl; Section: THeaderSection);
begin
    dwMessage(Section.Text,'',self);
end;

end.
