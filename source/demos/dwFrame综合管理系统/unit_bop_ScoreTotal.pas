unit unit_bop_ScoreTotal;

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
  TForm_bop_ScoreTotal = class(TForm)
    Pn1: TPanel;
    Bt1: TButton;
    FDQuery1: TFDQuery;
    procedure FormShow(Sender: TObject);
    procedure Bt1Click(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串 '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
  end;

var
     Form_bop_ScoreTotal             : TForm_bop_ScoreTotal;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_ScoreTotal.Bt1Click(Sender: TObject);
var
    sSQL        : String;
begin
    (*
    需要更新bop_score表的以下字段
    sItemCode
    sItemId
    sItemName
    sItemUnit
    sTestName
    sGradeNum
    sClassNum
    sClassName
    sStudentName
    sStudentGender
    sStudentRegisterNum
    sLocation
    sManager
    *)

    //先更新bop_Score, 主要是写入关联数据到本表
    sSQL    :=
            '''
            UPDATE bop_Score
            SET
                sItemCode = ic.cCode
            FROM bop_Score bs
            INNER JOIN dic_ItemCode ic ON bs.sItemName = ic.cName
            ''';
    TForm1(self.Owner).FDConnection1.ExecSQL(sSQl);

    //根据 bop_Score表的 sGradeNum, sStudentGender 和 sItemName 写入 sItemId
    (*
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
    *)
    //自动将bop_score中的测试数据, 汇总到sys_Student表中
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        -- 方法：使用动态SQL（推荐，更灵活）
        DECLARE @sql NVARCHAR(MAX) = ''

        -- 构建更新sValue字段的SQL
        SELECT @sql = @sql +
            'UPDATE s SET ' +
            's.sValue' + CAST(sItemCode AS VARCHAR(3)) + ' = latest.sOnsiteScore ' +
            'FROM sys_Student s ' +
            'INNER JOIN ( ' +
            '    SELECT sStudentId, sOnsiteScore, sScore ' +
            '    FROM ( ' +
            '        SELECT sStudentId, sOnsiteScore, sScore, sItemCode, ' +
            '               ROW_NUMBER() OVER (PARTITION BY sStudentId, sItemCode ORDER BY sTestDate DESC) as rn ' +
            '        FROM bop_Score ' +
            '        WHERE sItemCode = ' + CAST(sItemCode AS VARCHAR(3)) + ' ' +
            '    ) ranked ' +
            '    WHERE rn = 1 ' +
            ') latest ON s.sId = latest.sStudentId; ' + CHAR(13)
        FROM (SELECT DISTINCT sItemCode FROM bop_Score WHERE sItemCode BETWEEN 100 AND 115) t

        -- 构建更新sScore字段的SQL
        SELECT @sql = @sql +
            'UPDATE s SET ' +
            's.sScore' + CAST(sItemCode AS VARCHAR(3)) + ' = latest.sScore ' +
            'FROM sys_Student s ' +
            'INNER JOIN ( ' +
            '    SELECT sStudentId, sOnsiteScore, sScore ' +
            '    FROM ( ' +
            '        SELECT sStudentId, sOnsiteScore, sScore, sItemCode, ' +
            '               ROW_NUMBER() OVER (PARTITION BY sStudentId, sItemCode ORDER BY sTestDate DESC) as rn ' +
            '        FROM bop_Score ' +
            '        WHERE sItemCode = ' + CAST(sItemCode AS VARCHAR(3)) + ' ' +
            '    ) ranked ' +
            '    WHERE rn = 1 ' +
            ') latest ON s.sId = latest.sStudentId; ' + CHAR(13)
        FROM (SELECT DISTINCT sItemCode FROM bop_Score WHERE sItemCode BETWEEN 100 AND 115) t

        -- 执行动态SQL
        EXEC sp_executesql @sql
        '''
    );

    //计算 BMI
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        --- 计算BMI值
        UPDATE sys_Student
        SET sValue112 = sValue101 / (sValue100/100)  / (sValue100/100)
        WHERE NOT (sValue100 IS NULL OR sValue100 = 0);
        --- 根据标准计算得分
        UPDATE sys_Student
        SET sScore112 = ISNULL((
            SELECT TOP 1 dis.sScore
            FROM dic_Item di
            INNER JOIN dic_ItemStandard dis ON di.iId = dis.sItemId
            WHERE di.iItemCode = 112
              AND di.iGradeNum = sys_Student.sGradeNum
              AND di.iGender = sys_Student.sGender
              AND sys_Student.sValue112 >= dis.sValue
            ORDER BY dis.sValue DESC
        ), 0)

        --- 计算总分
        UPDATE sys_Student
        SET sScore =
            CASE
                WHEN
                    CASE
                        -- 小学一、二年级 (11,12)
                        WHEN sGradeNum IN (11, 12) THEN
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.30 +
                             CASE WHEN COALESCE(sScore111, 0) > 100 THEN 100 ELSE COALESCE(sScore111, 0) END * 0.20) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore111, 0) > 100 THEN COALESCE(sScore111, 0) - 100 ELSE 0 END)

                        -- 小学三、四年级 (13,14)
                        WHEN sGradeNum IN (13, 14) THEN
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore111, 0) > 100 THEN 100 ELSE COALESCE(sScore111, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore109, 0) > 100 THEN 100 ELSE COALESCE(sScore109, 0) END * 0.10) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore111, 0) > 100 THEN COALESCE(sScore111, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore109, 0) > 100 THEN COALESCE(sScore109, 0) - 100 ELSE 0 END)

                        -- 小学五、六年级 (15,16)
                        WHEN sGradeNum IN (15, 16) THEN
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.10 +
                             CASE WHEN COALESCE(sScore111, 0) > 100 THEN 100 ELSE COALESCE(sScore111, 0) END * 0.10 +
                             CASE WHEN COALESCE(sScore109, 0) > 100 THEN 100 ELSE COALESCE(sScore109, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore110, 0) > 100 THEN 100 ELSE COALESCE(sScore110, 0) END * 0.10) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore111, 0) > 100 THEN COALESCE(sScore111, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore109, 0) > 100 THEN COALESCE(sScore109, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore110, 0) > 100 THEN COALESCE(sScore110, 0) - 100 ELSE 0 END)

                        -- 初中、高中、大学各年级 (>=17)
                        ELSE
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.10 +
                             CASE WHEN COALESCE(sScore105, 0) > 100 THEN 100 ELSE COALESCE(sScore105, 0) END * 0.10 +
                             -- 根据性别选择引体向上（男）或1分钟仰卧起坐（女）
                             CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore108, 0) > 100 THEN 100 ELSE COALESCE(sScore108, 0) END * 0.10
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore109, 0) > 100 THEN 100 ELSE COALESCE(sScore109, 0) END * 0.10
                                 ELSE 0
                             END +
                             -- 根据性别选择1000米跑（男）或800米跑（女）
                             CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore107, 0) > 100 THEN 100 ELSE COALESCE(sScore107, 0) END * 0.20
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore106, 0) > 100 THEN 100 ELSE COALESCE(sScore106, 0) END * 0.20
                                 ELSE 0
                             END) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore105, 0) > 100 THEN COALESCE(sScore105, 0) - 100 ELSE 0 END) +
                            -- 根据性别选择加分项目
                            CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore108, 0) > 100 THEN COALESCE(sScore108, 0) - 100 ELSE 0 END
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore109, 0) > 100 THEN COALESCE(sScore109, 0) - 100 ELSE 0 END
                                 ELSE 0
                            END +
                            CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore107, 0) > 100 THEN COALESCE(sScore107, 0) - 100 ELSE 0 END
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore106, 0) > 100 THEN COALESCE(sScore106, 0) - 100 ELSE 0 END
                                 ELSE 0
                            END
                    END > 120
                THEN 120
                ELSE
                    CASE
                        -- 小学一、二年级 (11,12)
                        WHEN sGradeNum IN (11, 12) THEN
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.30 +
                             CASE WHEN COALESCE(sScore111, 0) > 100 THEN 100 ELSE COALESCE(sScore111, 0) END * 0.20) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore111, 0) > 100 THEN COALESCE(sScore111, 0) - 100 ELSE 0 END)

                        -- 小学三、四年级 (13,14)
                        WHEN sGradeNum IN (13, 14) THEN
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore111, 0) > 100 THEN 100 ELSE COALESCE(sScore111, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore109, 0) > 100 THEN 100 ELSE COALESCE(sScore109, 0) END * 0.10) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore111, 0) > 100 THEN COALESCE(sScore111, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore109, 0) > 100 THEN COALESCE(sScore109, 0) - 100 ELSE 0 END)

                        -- 小学五、六年级 (15,16)
                        WHEN sGradeNum IN (15, 16) THEN
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.10 +
                             CASE WHEN COALESCE(sScore111, 0) > 100 THEN 100 ELSE COALESCE(sScore111, 0) END * 0.10 +
                             CASE WHEN COALESCE(sScore109, 0) > 100 THEN 100 ELSE COALESCE(sScore109, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore110, 0) > 100 THEN 100 ELSE COALESCE(sScore110, 0) END * 0.10) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore111, 0) > 100 THEN COALESCE(sScore111, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore109, 0) > 100 THEN COALESCE(sScore109, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore110, 0) > 100 THEN COALESCE(sScore110, 0) - 100 ELSE 0 END)

                        -- 初中、高中、大学各年级 (>=17)
                        ELSE
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN 100 ELSE COALESCE(sScore112, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore102, 0) > 100 THEN 100 ELSE COALESCE(sScore102, 0) END * 0.15 +
                             CASE WHEN COALESCE(sScore103, 0) > 100 THEN 100 ELSE COALESCE(sScore103, 0) END * 0.20 +
                             CASE WHEN COALESCE(sScore104, 0) > 100 THEN 100 ELSE COALESCE(sScore104, 0) END * 0.10 +
                             CASE WHEN COALESCE(sScore105, 0) > 100 THEN 100 ELSE COALESCE(sScore105, 0) END * 0.10 +
                             -- 根据性别选择引体向上（男）或1分钟仰卧起坐（女）
                             CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore108, 0) > 100 THEN 100 ELSE COALESCE(sScore108, 0) END * 0.10
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore109, 0) > 100 THEN 100 ELSE COALESCE(sScore109, 0) END * 0.10
                                 ELSE 0
                             END +
                             -- 根据性别选择1000米跑（男）或800米跑（女）
                             CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore107, 0) > 100 THEN 100 ELSE COALESCE(sScore107, 0) END * 0.20
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore106, 0) > 100 THEN 100 ELSE COALESCE(sScore106, 0) END * 0.20
                                 ELSE 0
                             END) +
                            (CASE WHEN COALESCE(sScore112, 0) > 100 THEN COALESCE(sScore112, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore102, 0) > 100 THEN COALESCE(sScore102, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore103, 0) > 100 THEN COALESCE(sScore103, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore104, 0) > 100 THEN COALESCE(sScore104, 0) - 100 ELSE 0 END) +
                            (CASE WHEN COALESCE(sScore105, 0) > 100 THEN COALESCE(sScore105, 0) - 100 ELSE 0 END) +
                            -- 根据性别选择加分项目
                            CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore108, 0) > 100 THEN COALESCE(sScore108, 0) - 100 ELSE 0 END
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore109, 0) > 100 THEN COALESCE(sScore109, 0) - 100 ELSE 0 END
                                 ELSE 0
                            END +
                            CASE
                                 WHEN sGender = 1 THEN  -- 男生
                                     CASE WHEN COALESCE(sScore107, 0) > 100 THEN COALESCE(sScore107, 0) - 100 ELSE 0 END
                                 WHEN sGender = 2 THEN  -- 女生
                                     CASE WHEN COALESCE(sScore106, 0) > 100 THEN COALESCE(sScore106, 0) - 100 ELSE 0 END
                                 ELSE 0
                            END
                    END
            END;
        '''
    );


    //
    cpUpdate(Pn1);

    //
    dwMessage('----- 数据更新完成! -----','success',self);

end;

procedure TForm_bop_ScoreTotal.FormShow(Sender: TObject);
begin
    FDQuery1.Connection     := TForm1(self.Owner).FDConnection1;
(*
    //角色"老师"只能查看自己负责的测试成绩, 且不能编辑
    if TForm1(self.Owner).gjoUserInfo.rolename = '老师' then begin
        //设置where 为仅看自己
        cpSetWhere(Pn1,'sManager='''+TForm1(self.Owner).gjoUserInfo.username+'''');

        //不能编辑
        cpSetNameValue(Pn1,'buttons',0);
    end;
*)

    //移动端, 只显示:姓名,现场成绩,成绩和备注
    if TForm1(self.Owner).gbMobile then begin
        cpSetFieldByName(Pn1,'sId','view',4);
        cpSetFieldByName(Pn1,'sItemName','view',4);
        cpSetFieldByName(Pn1,'sTestName','view',4);
        cpSetFieldByName(Pn1,'sLocation','view',4);
        cpSetFieldByName(Pn1,'sManager','view',4);
        cpSetFieldByName(Pn1,'sGradeNum','view',4);
        cpSetFieldByName(Pn1,'sClassNum','view',4);
        cpSetFieldByName(Pn1,'sClassName','view',4);
        cpSetFieldByName(Pn1,'sStudentGender','view',4);
        cpSetFieldByName(Pn1,'sStudentRegisterNum','view',4);
    end;

    //根据dic_Itemcode表更新配置
    FDQuery1.Open('SELECT cCode,cName FROM dic_ItemCode WHERE cCode<200 ORDER BY cCode');
    while not FDQuery1.Eof do begin
        cpSetFieldByName(Pn1,'sValue'+FDQuery1.FieldByName('cCode').AsString,'caption',FDQuery1.FieldByName('cName').AsString);
        //
        FDQuery1.Next;
    end;


    //初始化主成绩表
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);

    //
    cpAddInButtons(Pn1,Bt1);
    Bt1.Left    := 999;
end;


end.
