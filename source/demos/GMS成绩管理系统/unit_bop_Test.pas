unit unit_bop_Test;

interface

uses
    dwBase,

    //基本单元
    dwfBase,

    //DBCard通用单元
    dwDBCard,


    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client;

type
  TForm_bop_Test = class(TForm)
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
  private
    { Private declarations }
  public
    gsRights : String;
  end;

var
     Form_bop_Test             : TForm_bop_Test;


implementation

uses
    unit1,unit_bop_Entry;


{$R *.dfm}

procedure TForm_bop_Test.FormShow(Sender: TObject);
var
    iUserId     : Integer;
begin
    //取得用户id
    iUserId     := TForm1(self.owner).gjoUserInfo.id;

    //设置当前条件为只看当前用户为组织人的
    dcSetWhere(Pn1,'tManagerId='+IntToStr(iUserId));

    //更新所有测试分组的人数
    TForm1(self.owner).FDConnection1.ExecSQL(
        'UPDATE bop_Test'#13#10
        +'SET tCount = ('#13#10
        +'    SELECT COUNT(*)'#13#10
        +'    FROM bop_TestRoster'#13#10
        +'    WHERE bop_TestRoster.rTestId = bop_Test.tId'#13#10
        +');'
    );

    //
    dcInit(Pn1,TForm1(self.owner).FDConnection1,True,gsRights);
end;

procedure TForm_bop_Test.Pn1DragOver(Sender, Source: TObject; X, Y: Integer; State: TDragState; var Accept: Boolean);
var
    oFDQuery    : TFDQuery;
begin
    //
    case X of
        dcItemClick : begin
            // Y = 其中的tag = field序号 + RecNo * 1000

            //取得当前测试组的id
            oFDQuery    := dcGetFDQuery(Pn1);
            oFDQuery.RecNo :=  Y div 1000;
            TForm1(self.Owner).giTestId := oFDQuery.FieldByName('tId').AsInteger;

            //弹出"成绩录入"窗体
            dwfShowForm(TForm1(self.owner),TForm_bop_Entry, TForm(Form_bop_Entry),nil);
        end;
    end;
end;

end.
