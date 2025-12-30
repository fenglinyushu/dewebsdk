unit unit_QuickCrud;

interface

uses
    //
    dwBase,
    dwQuickCrud,

    //
    SynCommons,


    //
    Math,Variants,
    Graphics,strutils,
    ComObj,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.Buttons,  Vcl.ComCtrls, Vcl.Menus,
    Data.DB, Vcl.DBGrids, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet,
  Vcl.Imaging.pngimage;

type
  TForm_QC = class(TForm)
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    qcConfig : string;

    //当前用户使用本模块的权限，格式是JSON的数组字符串，
    //形如["模块名称",1,1,1,1,1,1,0,1,0,1],各元素分别表示：1显示/2运行/3增/4删/5改/6查/打印/预留1/预留2/预留3
	gsRights : string;
  end;

var
  Form_QC: TForm_QC;

implementation

{$R *.dfm}

uses
    Unit1;

procedure TForm_QC.FormShow(Sender: TObject);
var
    joConfig    : Variant;
    joRights    : Variant;
begin
    //取得配置信息，一般保存在窗体的StyleName中
    qcConfig    := StyleName;

    //取得权限字符串
    joRights    := _json(gsRights);

    //设置权限
    if joRights <> unassigned then begin
        joConfig    := _json(qcConfig);
        if joRights._Count > 3 then begin
            joConfig.new    := joRights._(3);
        end;
        if joRights._Count > 4 then begin
            joConfig.delete := joRights._(4);
        end;
        if joRights._Count > 5 then begin
            joConfig.edit   := joRights._(5);
        end;
        if joRights._Count > 6 then begin
            joConfig.query  := joRights._(6);
        end;
        if joRights._Count > 8 then begin
            joConfig.print  := joRights._(8);
        end;
        //返写到qcConfig字符串
        qcConfig    := joConfig;
    end;

    //
    dwCrud(self,TForm1(Self.Owner).FDConnection1,False,'');
end;

end.
