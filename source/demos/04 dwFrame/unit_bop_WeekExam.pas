unit unit_bop_WeekExam;

interface

uses
    dwBase,
    CloneComponents,

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
  TForm_bop_WeekExam = class(TForm)
    Panel1: TPanel;
    EtKey: TEdit;
    Button1: TButton;
    Button2: TButton;
    Fp1: TFlowPanel;
    BtTimes: TButton;
    FDQuery1: TFDQuery;
    LaDate: TLabel;
    procedure FormShow(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure EtKeyChange(Sender: TObject);
  private
    { Private declarations }
  public
        //权限数据字符串 '["单选题库",1,1,1,1,1,1,1,1,1,1,1,1,1,1]'
        //一般可转换为JSON数组的字符串,0元素为字符串型,模块名称;1元素为可见;2元素为可用; 3~7个元素为:增/删/改/查/导出,1为可用,0为禁用; 后面的为自定义权限
        gsRights : String;
        //
        gdtDate     : TDateTime;
        procedure UpdateView;
  end;

var
     Form_bop_WeekExam             : TForm_bop_WeekExam;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_WeekExam.Button1Click(Sender: TObject);
begin
    gdtDate := gdtDate - 7;

    //
    UpdateView;

end;

procedure TForm_bop_WeekExam.Button2Click(Sender: TObject);
begin
    gdtDate := gdtDate + 7;

    //
    UpdateView;

end;

procedure TForm_bop_WeekExam.EtKeyChange(Sender: TObject);
begin
    //
    UpdateView;

end;

procedure TForm_bop_WeekExam.FormShow(Sender: TObject);
begin
    //
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;
    gdtDate := Trunc(now);

    //
    UpdateView;
end;

procedure TForm_bop_WeekExam.UpdateView;
var
    iItem       : Integer;
    dtStart     : TDateTime;
    dtEnd       : TDateTIme;
    skey        : String;
begin
    // 计算当前时间所在一周的起止日期
    // 假设一周从星期一开始
    dtStart := gdtDate - (DayOfWeek(gdtDate) - 2);
    if DayOfWeek(gdtDate) = 1 then begin
        // 如果是星期日，特殊处理
        dtStart := gdtDate - 6;
    end else begin
        dtStart := gdtDate - (DayOfWeek(gdtDate) - 2);
    end;
    dtEnd := dtStart + 7; // 一周结束日期
    //
    LaDate.Caption  := '日期：'+FormatdateTime('YYYY-MM-DD',dtStart)+' —— '+ FormatdateTime('YYYY-MM-DD',dtEnd-1);

    //
    sKey    := Trim(EtKey.Text);
    if sKey <> '' then begin
        sKey    := 'AND u.uName LIKE ''%' + sKey + '%''';

    end;

    with FDQuery1 do begin
        SQL.Clear;
        SQL.Text :=
            'SELECT u.uId, u.uName, ' +
            'COALESCE(COUNT(b.sId), 0) AS ScoreCount ' +
            'FROM sys_user u ' +
            'LEFT JOIN bop_Score b ON u.uId = b.sUserId ' +
            'AND b.sDateTime BETWEEN :StartDate AND :EndDate ' +
            'AND b.sScore > 0 ' +
            ' WHERE not (u.uName LIKE ''%admin%'') '+
            skey +
            'GROUP BY u.uId, u.uName';

        Params.ParamByName('StartDate').AsDateTime := dtStart;
        Params.ParamByName('EndDate').AsDateTime := dtEnd;
        Open;
    end;

    //第一次时, 克隆控件
    if FP1.ControlCount = 1 then begin
        for iItem := 0 to FDQuery1.RecordCount - 1 do begin
            CloneComponent(BtTimes);
        end;
    end;

    //先隐藏所有按钮
    for iItem := Fp1.ControlCount - 1 downto 1 do begin
        FP1.Controls[iItem].Visible := False;
    end;

    //显示数据
    while not FDQuery1.Eof do begin
        with TButton(FP1.Controls[FDQuery1.RecNo]) do begin
            Visible     := True;
            Caption     := FDQuery1.FieldByName('uName').AsString + ' ['+IntToStr(FDQuery1.FieldByName('ScoreCount').AsInteger)+']';
            if FDQuery1.FieldByName('ScoreCount').AsInteger = 0 then begin
                Hint    := '{"type":"primary"}';
            end else begin
                Hint    := '{"type":"default"}';
            end;
        end;
        //
        FDQuery1.Next;
    end;
end;

end.
