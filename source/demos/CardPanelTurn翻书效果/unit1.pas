unit unit1;
{
说明：本窗体为应用主窗体，仅提供菜单，PageControl等基础框架服务
}

interface

uses
    //deweb基本单元
    dwBase,

    //
    dwCardPanelTurn,



//[*uses_end*]


    //第三方单元
    SynCommons,     //JSON解析单元，来自mormot


    //系统单元
    Graphics,
    Data.Win.ADODB,
    Variants,
	Rtti,
    Math,
    //
    FireDAC.Stan.Intf,
    FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
    FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
    FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
    FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
    FireDAC.Comp.DataSet,
    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage, Vcl.Menus,
    Vcl.Buttons, Data.DB, System.ImageList, Vcl.ImgList, Vcl.ButtonGroup, Vcl.WinXPanels;

type
  TForm1 = class(TForm)
    P_Banner: TPanel;
    Label1: TLabel;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    CardPanel1: TCardPanel;
    Card1: TCard;
    Card2: TCard;
    Card3: TCard;
    Card4: TCard;
    Card5: TCard;
    Card6: TCard;
    Image6: TImage;
    Card7: TCard;
    Image7: TImage;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    { Private declarations }
  public

    //------功能模块--------------------------------------------------------------------------------


//[*public_end*]

    //

    //------公用变量--------------------------------------------------------------------------------

    //---字符串型变量
    gsMainDir           : string;           //系统工作目录，以 \ 结束

    //布尔型变量
    gbMobile            : Boolean;          //是否移动端

    //用户信息
    gjoUserInfo         : Variant;          //用户信息
    gsRole              : string;           //角色
    gjoRights           : Variant;

    //
    gslModules          : TStringList;      //系统模块，包括隐藏和禁用模块，主要用于权限控制


  end;

var
    Form1   : TForm1;

implementation

{$R *.dfm}




procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var
    I       : Integer;
    oImage  : TImage;
    sJS     : string;
begin
    if Width>500 then begin
        CardPanel1.Hint := '{"display": "double","acceleration": 1}';
        for I := 1 to CardPanel1.CardCount do begin
            oImage  := TImage(FindComponent('Image'+IntToStr(I)));
            oImage.Align   := alLeft;
            oImage.Width   := CardPanel1.Width div 2;
        end;

    end else begin
        CardPanel1.Hint := '{"display": "single","acceleration": 1}';
        for I := 1 to CardPanel1.CardCount do begin
            oImage  := TImage(FindComponent('Image'+IntToStr(I)));
            with oImage do begin
                Align   := alClient;
            end;
        end;
    end;
    dwctInit(CardPanel1);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    I   : Integer;
begin
    for I := 0 to CardPanel1.CardCount - 1 do begin
        CardPanel1.ActiveCardIndex  := I;
    end;

end;

end.
