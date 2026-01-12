unit unit1;

interface

uses
    //
    dwBase,
    dwCrudPanel,

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
    Vcl.Imaging.pngimage, FireDAC.Phys.MSSQLDef, FireDAC.Phys.MSSQL, FireDAC.Phys.MySQLDef, FireDAC.Stan.ExprFuncs,
    FireDAC.Phys.SQLiteWrapper.Stat, FireDAC.Phys.SQLiteDef, FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle,
    FireDAC.Phys.SQLite, FireDAC.Phys.MySQL, Vcl.Samples.Spin,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG;

type
  TForm1 = class(TForm)
    FDConnection1: TFDConnection;
    Panel1: TPanel;
    Pn1: TPanel;
    Bt1: TButton;
    Bt2: TButton;
    Bt3: TButton;
    Bt4: TButton;
    Bt5: TButton;
    Bt6: TButton;
    Bt7: TButton;
    Bt8: TButton;
    Bt9: TButton;
    Bt10: TButton;
    Bt11: TButton;
    Bt12: TButton;
    Bt13: TButton;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Bt1Click(Sender: TObject);
    procedure Bt2Click(Sender: TObject);
    procedure Bt3Click(Sender: TObject);
    procedure Bt4Click(Sender: TObject);
    procedure Bt5Click(Sender: TObject);
    procedure Bt6Click(Sender: TObject);
    procedure Bt7Click(Sender: TObject);
    procedure Bt8Click(Sender: TObject);
    procedure Bt9Click(Sender: TObject);
    procedure Bt10Click(Sender: TObject);
    procedure Bt11Click(Sender: TObject);
    procedure Bt12Click(Sender: TObject);
    procedure Bt13Click(Sender: TObject);
  private
    { Private declarations }
  public
    //浏览器历史控制变量, 类型为json数组
    gjoHistory  : Variant;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.Bt10Click(Sender: TObject);
begin
    cpSetCellButtonEnabled(Panel1,6,4,0,False);

end;

procedure TForm1.Bt11Click(Sender: TObject);
begin
    cpSetCellMerge(Panel1,2,4,3,2);
end;

procedure TForm1.Bt12Click(Sender: TObject);
begin
    //cpSetCellHtml(Panel1,1,9,'<a style="color:red;font-weight:bold;">粗红</a><a style="color:blue;font-size:22px;">蓝色</a>');
    cpSetCellHtml(Panel1,1,9,'<a style="background:red;color:#fff;font-weight:bold;border-radius:10px;">粗红</a><a style="color:blue;font-size:22px;">蓝色</a>');
end;

procedure TForm1.Bt13Click(Sender: TObject);
begin
    cpSetCellBackColor(Panel1,1,0,cllime);
    cpSetCellBackColor(Panel1,2,0,cllime);
    cpSetCellBackColor(Panel1,4,0,cllime);

end;

procedure TForm1.Bt1Click(Sender: TObject);
begin
    cpSetCellBackColor(Panel1,2,4,cllime);
end;

procedure TForm1.Bt2Click(Sender: TObject);
begin
    cpSetCellFontSize(Panel1,3,5,24);

end;

procedure TForm1.Bt3Click(Sender: TObject);
begin
    cpSetCellFontColor(Panel1,1,1,clBlue);

end;

procedure TForm1.Bt4Click(Sender: TObject);
begin
    cpSetCellFontBold(Panel1,1,2,True);

end;

procedure TForm1.Bt5Click(Sender: TObject);
begin
    cpSetCellFontItalic(Panel1,1,3,True);
end;

procedure TForm1.Bt6Click(Sender: TObject);
begin
    cpSetCellFontUnderline(Panel1,1,4,True);

end;

procedure TForm1.Bt7Click(Sender: TObject);
begin
    cpSetCellFontStrikeout(Panel1,1,5,True);

end;

procedure TForm1.Bt8Click(Sender: TObject);
begin
    cpSetCellVisible(Panel1,1,6,False);

end;

procedure TForm1.Bt9Click(Sender: TObject);
begin
    cpSetCellButtonVisible(Panel1,6,2,1,False);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
    try

        //自动创建CRUD模块
        cpInit(Panel1,FDConnection1,False,'');
    except

    end;
end;

end.
