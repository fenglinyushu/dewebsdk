unit unit_bop_Ranking;

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
  TForm_bop_Ranking = class(TForm)
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
     Form_bop_Ranking             : TForm_bop_Ranking;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_Ranking.FormShow(Sender: TObject);
var
    iCurUserId  : Integer;
begin
    //取得当前用户的id
    iCurUserId  := TForm1(self.Owner).gjoUserInfo.id;

(*
    //sqlserver2008 更新各用户的出题数量
    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        UPDATE u
        SET
            uSelectCount = ISNULL(select_stats.select_count, 0),
            uJudgeCount = ISNULL(judge_stats.judge_count, 0),
            uShortCount = ISNULL(short_stats.short_count, 0),
            uCount = ISNULL(total_stats.total_count, 0),
            uSelectedCount = ISNULL(selected_stats.selected_count, 0)
        FROM sys_User u
        LEFT JOIN (
            SELECT qCreatorId, COUNT(* ) as select_count
            FROM bop_Question
            WHERE qType = '选择题'
            GROUP BY qCreatorId
        ) select_stats ON u.uId = select_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(* ) as judge_count
            FROM bop_Question
            WHERE qType = '判断题'
            GROUP BY qCreatorId
        ) judge_stats ON u.uId = judge_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(* ) as short_count
            FROM bop_Question
            WHERE qType = '简答题'
            GROUP BY qCreatorId
        ) short_stats ON u.uId = short_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(* ) as total_count
            FROM bop_Question
            GROUP BY qCreatorId
        ) total_stats ON u.uId = total_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(* ) as selected_count
            FROM bop_Question
            WHERE qStatus = 1
            GROUP BY qCreatorId
        ) selected_stats ON u.uId = selected_stats.qCreatorId;
        WITH UserRanking AS (
            SELECT
                uId,
                ROW_NUMBER() OVER (ORDER BY uCount DESC, uSelectedCount DESC) as user_rank
            FROM sys_User
            WHERE uName NOT LIKE '%admin%'
        )
        UPDATE u
        SET uIndex = ur.user_rank
        FROM sys_User u
        INNER JOIN UserRanking ur ON u.uId = ur.uId;
        '''
    );
*)

    TForm1(self.Owner).FDConnection1.ExecSQL(
        '''
        -- 第一部分：更新用户统计信息
        UPDATE sys_User
        SET
            uSelectCount = COALESCE(select_stats.select_count, 0),
            uJudgeCount = COALESCE(judge_stats.judge_count, 0),
            uShortCount = COALESCE(short_stats.short_count, 0),
            uCount = COALESCE(total_stats.total_count, 0),
            uSelectedCount = COALESCE(selected_stats.selected_count, 0)
        FROM (
            SELECT qCreatorId, COUNT(*) as select_count
            FROM bop_Question
            WHERE qType = '选择题'
            GROUP BY qCreatorId
        ) select_stats
        LEFT JOIN (
            SELECT qCreatorId, COUNT(*) as judge_count
            FROM bop_Question
            WHERE qType = '判断题'
            GROUP BY qCreatorId
        ) judge_stats ON select_stats.qCreatorId = judge_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(*) as short_count
            FROM bop_Question
            WHERE qType = '简答题'
            GROUP BY qCreatorId
        ) short_stats ON select_stats.qCreatorId = short_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(*) as total_count
            FROM bop_Question
            GROUP BY qCreatorId
        ) total_stats ON select_stats.qCreatorId = total_stats.qCreatorId
        LEFT JOIN (
            SELECT qCreatorId, COUNT(*) as selected_count
            FROM bop_Question
            WHERE qStatus = 1
            GROUP BY qCreatorId
        ) selected_stats ON select_stats.qCreatorId = selected_stats.qCreatorId
        WHERE sys_User.uId = select_stats.qCreatorId;

        -- 第二部分：更新用户排名
        WITH UserRanking AS (
            SELECT
                uId,
                ROW_NUMBER() OVER (ORDER BY uCount DESC, uSelectedCount DESC) as user_rank
            FROM sys_User
            WHERE uName NOT LIKE '%admin%'
        )
        UPDATE sys_User
        SET uIndex = ur.user_rank
        FROM UserRanking ur
        WHERE sys_User.uId = ur.uId;
        '''
    );

    //初始化CRUD模块
    cpInit(Pn1,TForm1(self.Owner).FDConnection1,TForm1(self.Owner).gbMobile,gsRights);
end;

end.
