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
    procedure Pn1DblClick(Sender: TObject);
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

    //如果是移动端, 则
    if TForm1(self.Owner).gbMobile then begin
        //设置cardwidth为0, 即为跟随移动端的宽度
        dcSetNameValue(Pn1,'cardwidth',0);
    end;

    //更新所有测试分组的人数
    TForm1(self.owner).FDConnection1.ExecSQL(
        //更新总人数和已录入成绩的人数
        'UPDATE bop_Test'
        +' SET'
            +' tCount = ('
                +' SELECT COUNT(*)'
                +' FROM bop_TestRoster'
                +' WHERE bop_TestRoster.rTestId = bop_Test.tId'

            +')'
            +' ,tFinished = ('
                +' SELECT COUNT(*)'
                +' FROM bop_TestRoster'
                +' WHERE'
                    +' bop_TestRoster.rTestId = bop_Test.tId'
                    +' AND bop_TestRoster.rOnsiteScore > 0'
            +');'
        //更新人员花名册
        +'UPDATE bop_Test'
        +' SET tRoster = ('
            +' SELECT STUFF(('
                +' SELECT ''，'' + rName'
                +' FROM bop_TestRoster'
                +' WHERE rTestId = bop_Test.tId'
                +' FOR XML PATH('''')'
            +' ), 1, 1, '''')'
        +' );'

    );

    //初始化分组显示
    dcInit(Pn1,TForm1(self.owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);
end;

procedure TForm_bop_Test.Pn1DblClick(Sender: TObject);
var
    oFDQuery    : TFDQuery;
begin
    //===== 当单击卡片Panel时触发

    try
        //取得当前测试组的id
        oFDQuery    := dcGetFDQuery(Pn1);
        TForm1(self.Owner).gsTestSQL    := dcGetSQL(Pn1);
        TForm1(self.Owner).giTestId     := oFDQuery.FieldByName('tId').AsInteger;
        TForm1(self.Owner).gsItemName   := oFDQuery.FieldByName('tItemName').AsString;
        TForm1(self.Owner).gsItemUnit   := oFDQuery.FieldByName('tItemUnit').AsString;
        TForm1(self.Owner).gsLocation   := oFDQuery.FieldByName('tLocation').AsString;
        TForm1(self.Owner).gsManager    := oFDQuery.FieldByName('tManager').AsString;
        TForm1(self.Owner).gsTestName   := oFDQuery.FieldByName('tName').AsString;

        //弹出"成绩录入"窗体
        dwfShowForm(TForm1(self.owner),TForm_bop_Entry, TForm(Form_bop_Entry),nil,True);
    except
        dwMessage('Error when TForm_bop_Test.Pn1DblClick  ','error',self);
    end;
end;

end.
