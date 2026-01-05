unit unit_dem_CrudStyle;

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
    FireDAC.Phys.SQLite, FireDAC.Phys.MySQL, Vcl.Samples.Spin;

type
  TForm_dem_CrudStyle = class(TForm)
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
  end;

var
  Form_dem_CrudStyle: TForm_dem_CrudStyle;

implementation

{$R *.dfm}

uses
    unit1;

procedure TForm_dem_CrudStyle.Bt10Click(Sender: TObject);
begin
    cpSetCellButtonEnabled(Panel1,6,4,0,False);

end;

procedure TForm_dem_CrudStyle.Bt11Click(Sender: TObject);
begin
    cpSetCellMerge(Panel1,2,4,3,2);
end;

procedure TForm_dem_CrudStyle.Bt12Click(Sender: TObject);
begin
    //cpSetCellHtml(Panel1,1,9,'<a style="color:red;font-weight:bold;">粗红</a><a style="color:blue;font-size:22px;">蓝色</a>');
    cpSetCellHtml(Panel1,1,9,'<a style="background:red;color:#fff;font-weight:bold;border-radius:10px;">粗红</a><a style="color:blue;font-size:22px;">蓝色</a>');
end;

procedure TForm_dem_CrudStyle.Bt13Click(Sender: TObject);
begin
    cpSetCellBackColor(Panel1,1,0,cllime);
    cpSetCellBackColor(Panel1,2,0,cllime);
    cpSetCellBackColor(Panel1,4,0,cllime);

end;

procedure TForm_dem_CrudStyle.Bt1Click(Sender: TObject);
begin
    cpSetCellBackColor(Panel1,2,4,cllime);
end;

procedure TForm_dem_CrudStyle.Bt2Click(Sender: TObject);
begin
    cpSetCellFontSize(Panel1,3,5,24);

end;

procedure TForm_dem_CrudStyle.Bt3Click(Sender: TObject);
begin
    cpSetCellFontColor(Panel1,1,1,clBlue);

end;

procedure TForm_dem_CrudStyle.Bt4Click(Sender: TObject);
begin
    cpSetCellFontBold(Panel1,1,2,True);

end;

procedure TForm_dem_CrudStyle.Bt5Click(Sender: TObject);
begin
    cpSetCellFontItalic(Panel1,1,3,True);
end;

procedure TForm_dem_CrudStyle.Bt6Click(Sender: TObject);
begin
    cpSetCellFontUnderline(Panel1,1,4,True);

end;

procedure TForm_dem_CrudStyle.Bt7Click(Sender: TObject);
begin
    cpSetCellFontStrikeout(Panel1,1,5,True);

end;

procedure TForm_dem_CrudStyle.Bt8Click(Sender: TObject);
begin
    cpSetCellVisible(Panel1,1,6,False);

end;

procedure TForm_dem_CrudStyle.Bt9Click(Sender: TObject);
begin
    cpSetCellButtonVisible(Panel1,6,2,1,False);

end;

procedure TForm_dem_CrudStyle.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前为PC(电脑端)模式
    dwSetPCMode(Self);
end;

procedure TForm_dem_CrudStyle.FormShow(Sender: TObject);
begin
    try
        //自动创建CRUD模块
        cpInit(Panel1,TForm1(self.Owner).FDConnection1,False,'');
    except

    end;
end;

end.
