unit unit_dic_Item;

interface

uses
    dwBase,

    //浏览器历史记录控制单元
    dwHistory,


    dwfBase,
    dwCrudPanel,


    //
    synCommons,

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
  TForm_dic_Item = class(TForm)
    Pn1: TPanel;
    Pn2: TPanel;
    BtStd: TButton;
    procedure FormShow(Sender: TObject);
    procedure BtStdClick(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串 '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_dic_Item             : TForm_dic_Item;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_dic_Item.BtStdClick(Sender: TObject);
var
    joHistory   : Variant;
begin

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin
        //显示学生信息表格
        Pn2.Visible     := True;
        Pn2.Align       := alClient;

        //隐藏分组列表
        Pn1.Visible     := False;

        //
        with TForm1(self.Owner) do begin
            //显示标题
            LT.Caption   := '标准数值';

            //为当前操作添加记录
            dwAddShowHistory(Self,[Pn1],[Pn2],'项目标准');
        end;
    end;
end;

procedure TForm_dic_Item.FormShow(Sender: TObject);
begin

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin
        //隐藏从表
        Pn2.Visible     := False;

        //分组列表全屏
        Pn1.Align       := alClient;

        //置CrudPanel的按钮只显示图标
        //cpSetButtonCaption(Pn1,0);
    end else begin
        BtStd.Visible   := False;
    end;

    //
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);
    //
    cpInit(Pn2,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //插入自定义的按钮
    cpAddInButtons(Pn1,BtStd);
    BtStd.Left  := 999;
end;

end.
