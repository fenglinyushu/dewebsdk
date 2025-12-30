unit unit_bop_ScoreEvery;

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
  TForm_bop_ScoreEvery = class(TForm)
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
     Form_bop_ScoreEvery             : TForm_bop_ScoreEvery;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_ScoreEvery.FormShow(Sender: TObject);
var
    sSQL        : String;
begin
    //先更新bop_Score, 主要是写入关联数据到本表
    sSQL    :=
            '''
            UPDATE bop_Score
            SET
                sItemName = bt.tItemName,
                sItemUnit = bt.tItemUnit,
                sTestName = bt.tName,
                sTestDate = bt.tDate,
                sGradeNum = ss.sGradeNum,
                sClassNum = ss.sClassNum,
                sClassName = ss.sClassName,
                sStudentName = ss.sName,
                sStudentGender = bt.tGender,
                sStudentRegisterNum = ss.sRegisterNum,
                sLocation = bt.tLocation,
                sManager = su.uName
            FROM bop_Score bs
            INNER JOIN bop_Test bt ON bs.sTestId = bt.tId
            INNER JOIN sys_Student ss ON bs.sStudentId = ss.sId
            LEFT JOIN sys_User su ON bt.tManagerId = su.uId;
            ''';
    TForm1(self.Owner).FDConnection1.ExecSQL(sSQl);

    //根据 bop_Score表的 sGradeNum, sStudentGender 和 sItemName 写入 sItemId
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        UPDATE b
        SET b.sItemId = d.iId
        FROM bop_Score b
        INNER JOIN dic_Item d ON
            b.sItemName = d.iItemName
            AND b.sGradeNum = d.iGradeNum
            AND (b.sStudentGender = d.iGender OR (b.sStudentGender IS NULL AND d.iGender IS NULL))
        WHERE b.sItemId IS NULL OR b.sItemId = 0; -- 可选条件：只更新空值或0的记录
        '''
    );

    //根据对应sOnsiteScore, 计算成绩, 写入bop_Score表的sScore
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        UPDATE b
        SET b.sScore = ISNULL((
            SELECT TOP 1 std.sScore
            FROM dic_ItemStandard std
            WHERE std.sItemId = b.sItemId
            AND b.sOnsiteScore >= std.sValue  -- 假设sValue是分数线
            ORDER BY std.sValue DESC  -- 取满足条件的最高分数线
        ), 0)
        FROM bop_Score b
        '''
    );

    //角色"老师"只能查看自己负责的测试成绩, 且不能编辑
    if TForm1(self.Owner).gjoUserInfo.rolename = '老师' then begin
        //设置where 为仅看自己
        cpSetWhere(Pn1,'sManager='''+TForm1(self.Owner).gjoUserInfo.username+'''');

        //不能编辑
        cpSetNameValue(Pn1,'buttons',0);
    end;

    //移动端, 只显示:姓名,现场成绩,成绩和备注
    if TForm1(self.Owner).gbMobile then begin
        //功能按钮标题显示样式	整数	1	0:全不显示,1:全显示,2:居左按钮显标题，居右按钮不显示
        //cpSetNameValue(Pn1,'buttoncaption',0);
        //
        cpSetNameValue(Pn1,'oneline',0);
        cpSetNameValue(Pn1,'select',30);
        //
        cpSetFieldByName(Pn1,'sItemName','width',80);
        cpSetFieldByName(Pn1,'sOnsiteScore','width',65);
        cpSetFieldByName(Pn1,'sScore','width',65);
        cpSetFieldByName(Pn1,'sRemark','width',40);

        //
        cpSetFieldByName(Pn1,'sId','view',4);
        //cpSetFieldByName(Pn1,'sItemName','view',4);
        cpSetFieldByName(Pn1,'sTestName','view',4);
        cpSetFieldByName(Pn1,'sTestDate','view',4);
        cpSetFieldByName(Pn1,'sLocation','view',4);
        cpSetFieldByName(Pn1,'sManager','view',4);
        cpSetFieldByName(Pn1,'sGradeNum','view',4);
        cpSetFieldByName(Pn1,'sClassNum','view',4);
        cpSetFieldByName(Pn1,'sClassName','view',4);
        cpSetFieldByName(Pn1,'sStudentGender','view',4);
        cpSetFieldByName(Pn1,'sStudentRegisterNum','view',4);
        cpSetFieldByName(Pn1,'sItemUnit','view',4);
    end;



    //初始化主成绩表
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

end;


end.
