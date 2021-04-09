unit unit1;

interface

uses

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage;

type
  TForm1 = class(TForm)
    Panel_1: TPanel;
    Panel_2: TPanel;
    Panel_3: TPanel;
    Panel_4: TPanel;
    Panel_5: TPanel;
    Panel_2_1: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Panel_Thread: TPanel;
    Image_Poster: TImage;
    Panel_LineH: TPanel;
    Panel_T_Client: TPanel;
    Panel_T_C_Top: TPanel;
    StaticText_Thread: TStaticText;
    StaticText_Forum: TStaticText;
    Panel_T_C_Client: TPanel;
    Label_Goods: TLabel;
    Image_Good: TImage;
    Image_Msg: TImage;
    Label_Msgs: TLabel;
    Image_View: TImage;
    Label_Views: TLabel;
    StaticText_UperInfo: TStaticText;
    StaticText_Replyer: TStaticText;
    Label7: TLabel;
    Edit_Keyword: TEdit;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

end.
