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
    Sl1: TSplitter;
    procedure FormShow(Sender: TObject);
    procedure BtStdClick(Sender: TObject);
    procedure Pn1DragOver(Sender, Source: TObject; X, Y: Integer;
      State: TDragState; var Accept: Boolean);
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
    //:::::  主要用于移动端时, 切换面板



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
    //根据   小学一年级..六年级,初中一年级..三年级,高中一年级..三年级, 大学一年级..四年级,
    //写入11..16,21..23,31..33,41..44
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        UPDATE dic_item
        SET iGradeNum = CASE
            WHEN iGrade = '小学一年级' THEN 11
            WHEN iGrade = '小学二年级' THEN 12
            WHEN iGrade = '小学三年级' THEN 13
            WHEN iGrade = '小学四年级' THEN 14
            WHEN iGrade = '小学五年级' THEN 15
            WHEN iGrade = '小学六年级' THEN 16
            WHEN iGrade = '初中一年级' THEN 21
            WHEN iGrade = '初中二年级' THEN 22
            WHEN iGrade = '初中三年级' THEN 23
            WHEN iGrade = '高中一年级' THEN 31
            WHEN iGrade = '高中二年级' THEN 32
            WHEN iGrade = '高中三年级' THEN 33
            WHEN iGrade = '大学一年级' THEN 41
            WHEN iGrade = '大学二年级' THEN 42
            WHEN iGrade = '大学三年级' THEN 43
            WHEN iGrade = '大学四年级' THEN 44
            ELSE iGradeNum -- 如果不符合上述条件，保持原值不变
        END
        WHERE iGrade IN (
            '小学一年级', '小学二年级', '小学三年级', '小学四年级', '小学五年级', '小学六年级',
            '初中一年级', '初中二年级', '初中三年级',
            '高中一年级', '高中二年级', '高中三年级',
            '大学一年级', '大学二年级', '大学三年级', '大学四年级'
        );
        '''
    );


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

    //初始化主表
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //初始化从表
    cpInit(Pn2,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //插入自定义的按钮
    cpAddInButtons(Pn1,BtStd);
    BtStd.Left  := 999;

    //
    Sl1.Left    := 0;
end;

procedure TForm_dic_Item.Pn1DragOver(Sender, Source: TObject; X, Y: Integer;
  State: TDragState; var Accept: Boolean);
begin
    //更新每条记录iItemDirection
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        UPDATE di
        SET di.iItemDirection = dic.cDirection
        FROM dic_Item di
        INNER JOIN dic_ItemCode dic ON di.iItemCode = dic.cCode
        WHERE dic.cDirection IS NOT NULL;
        '''
    );
end;

end.
