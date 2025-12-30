unit unit_bop_Star1;

interface

uses
    dwBase,
    dwDB,
    dwCrudPanel,
    dwfBase,

    //浏览器历史记录控制单元
    dwHistory,

    //
    SynCommons,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.Grids, Vcl.Samples.Spin;

type
  TForm_bop_Star1 = class(TForm)
    Pn1: TPanel;
    Pn2: TPanel;
    SlR: TSplitter;
    Bt1: TButton;
    Bt2: TButton;
    Bt3: TButton;
    Bt4: TButton;
    procedure FormShow(Sender: TObject);
    procedure Bt1Click(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串, 如:'["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_bop_Star1             : TForm_bop_Star1;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_Star1.Bt1Click(Sender: TObject);
begin
    //刷新表一
    cpUpdate(Pn1);

    //刷新表二
    cpUpdate(Pn2);

    //
    dwMessage('数据已刷新!','success',self);
end;

procedure TForm_bop_Star1.FormShow(Sender: TObject);
begin

    //移动端处理
    if TForm1(self.Owner).gbMobile then begin

        //置CrudPanel的按钮只显示图标
        //cpSetButtonCaption(Pn1,0);
    end;

    //初始化测试分组表
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //初始化测试分组的明细表
    cpInit(Pn2,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,'');

    //插入自定义的按钮
    cpAddInButtons(Pn1,Bt4);
    Bt4.Left    := 999;
    cpAddInButtons(Pn1,Bt3);
    Bt3.Left    := 999;
    cpAddInButtons(Pn1,Bt2);
    Bt2.Left    := 999;
    cpAddInButtons(Pn1,Bt1);
    Bt1.Left    := 999;
end;

end.
