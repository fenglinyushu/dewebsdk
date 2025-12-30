unit unit1;

interface

uses
    //
    dwBase,

    //
    Math,
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
    Data.DB,Data.Win.ADODB, Vcl.DBGrids, Vcl.Samples.Spin, Vcl.Samples.Calendar, Vcl.Buttons,
    //
    FireDAC.Comp.Client,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Comp.DataSet,
    //
    Vcl.WinXCtrls, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC;

type
  TForm1 = class(TForm)
    PTitle: TPanel;
    LTitle: TLabel;
    Im: TImage;
    SG: TStringGrid;
    BWrite: TButton;
    BRead: TButton;
    ADOConnection1: TADOConnection;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormCreate(Sender: TObject);
    procedure BReadClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
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



procedure TForm1.BReadClick(Sender: TObject);
begin
    //
    dwUpload(Self,'.xls,.xlsx','MyDir');
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    iRow    : Integer;
    iCol    : Integer;
begin
    with SG do begin
        iCol    := 0;
        Cells[iCol,0]  :=
               '{'
                   +'"type":"edit",'
                   +'"align":"left",'
                   +'"dwstyle":"border:0;",'
                   +'"caption":"职务"'
               +'}';
    end;
end;

procedure TForm1.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFile       : string;
    Query       : TADOQuery;
begin
    //
    sFile       := dwGetProp(Self,'__upload');

    if sFile <> '' then begin
        // 创建连接和查询对象
        //Query := TADOQuery.Create(nil);
        try
            ADOConnection1.Close;
            // 配置连接参数
            ADOConnection1.ConnectionString :=
                'Provider=Microsoft.ACE.OLEDB.12.0;Data Source=D://dmBook.xlsx;Extended Properties="Excel 12.0;HDR=Yes;IMEX=1";';
                //'Provider=Microsoft.ACE.OLEDB.12.0;'
                //+'Data Source='+ gsMainDir+'MyDir/'+sFile+';'
                //+'Extended Properties="Excel 12.0;HDR=Yes;IMEX=1"';
            ADOConnection1.Open;

            // 配置查询
            Query.Connection := ADOConnection1;
            Query.SQL.Text := 'SELECT * FROM [Sheet1$]'; // Sheet1 是工作表名称，末尾加 $ 符号
            Query.Open;

        finally
            Query.Free;
        end;
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    //设置为PC模式
    dwSetPCMode(Self);
end;

end.
