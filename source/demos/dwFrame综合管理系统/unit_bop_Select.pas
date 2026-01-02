unit unit_bop_Select;

interface

uses
    dwBase,
    dwCrudPanel,

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
  TForm_bop_Select = class(TForm)
    Pn1: TPanel;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串 '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_bop_Select             : TForm_bop_Select;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_Select.FormShow(Sender: TObject);
var
    iCurUserId  : Integer;
begin

    //取得当前用户的id
    iCurUserId  := TForm1(self.Owner).gjoUserInfo.id;

    //设置当前只显示选择题和当前用户提供的试题
    cpSetWhere(Pn1,'qType=''选择题'' AND qCreatorId='+IntToStr(iCurUserId));

    //设置当前新增的试题记录的默认qCreatorId默认为当前用户id
    //cpSetFieldByName(Pn1,'qCreatorId','default',iCurUserId);
    Pn1.Hint    := StringReplace(Pn1.Hint,'99999',IntToStr(iCurUserId),[]);

    //设置当前新增的试题类型为判断题
    //cpSetFieldByName(Pn1,'qType','default','选择题');

    //初始化CRUD模块
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);
end;

end.
