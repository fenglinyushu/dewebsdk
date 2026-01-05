unit unit1;

interface

uses
     //
     dwBase,
     syncommons,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.StdCtrls, Vcl.Grids, Vcl.ExtCtrls, Vcl.ComCtrls, Vcl.Menus,
  Vcl.Buttons, Data.DB, Data.Win.ADODB, Vcl.Samples.Spin;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Edit_Dir: TEdit;
    Panel_Title: TPanel;
    Label3: TLabel;
    ComboBox_Accept: TComboBox;
    Button2: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Button3: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
    procedure Button2Click(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button3Click(Sender: TObject);
    procedure Panel1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Panel1StartDock(Sender: TObject; var DragObject: TDragDockObject);
  private
    { Private declarations }
  public
    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.Button1Click(Sender: TObject);
var
    sJS : String;
begin
    //恢复当前upload设置事件
    dwSetUploadTarget(Self,nil);


    //
    dwUpload(self,ComboBox_Accept.Text,Edit_Dir.Text);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    //dwUploadMultiple(self,ComboBox_Accept.Text,Edit_Dir.Text);
    dwUploadMultiple(self,'*.*',Edit_Dir.Text);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    //为当前upload设置事件转移。 转移到Panel1上
    dwSetUploadTarget(Self,Panel1);
    //
    dwUpload(self,ComboBox_Accept.Text,Edit_Dir.Text);
end;

procedure TForm1.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sSource : string;
    sLast   : string;
begin
    //上传完成时激活事件

    Memo1.Lines.Text    := self.Hint;
    dwMessage('end!!!','success',self);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.FormStartDock(Sender: TObject; var DragObject: TDragDockObject);
begin
    dwMessage('start....','success',self);
end;

procedure TForm1.Panel1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //上传完成时激活事件
    dwMessage('***** END of Panel1 *****','info',self);
end;

procedure TForm1.Panel1StartDock(Sender: TObject; var DragObject: TDragDockObject);
begin
    //上传完成时激活事件
    dwMessage('***** START of Panel1 *****','info',self);

end;

end.
