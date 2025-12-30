unit unit1;

interface

uses
    //
    dwBase,

    //
    CloneComponents,

    //
    Math,
    Graphics,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
  Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
  FireDAC.Comp.Client, Vcl.WinXCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.MSSQLDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  FireDAC.Phys.MSSQL, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Vcl.Menus,
  FireDAC.Phys.OracleDef, FireDAC.Phys.Oracle;

type
  TForm1 = class(TForm)
    TreeView1: TTreeView;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure TreeView1EndDock(Sender, Target: TObject; X, Y: Integer);
  private
    { Private declarations }
  public

    gsMainDir   : String;
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.TreeView1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //
    dwMessage(Format('Text:%s,X:%d,Y:%d',[TTreeNode(Target).Text,x,y]),'',self);
end;

end.
