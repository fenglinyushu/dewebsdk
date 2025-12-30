unit unit_bop_Entry;

interface

uses
    dwBase,

    //
    dwDBCard,

    //
    CloneComponents,


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
    FireDAC.Comp.Client;

type
  TForm_bop_Entry = class(TForm)
    Fp: TFlowPanel;
    PnDemo: TPanel;
    LaName: TLabel;
    EtScore: TEdit;
    FDQuery2: TFDQuery;
    LaUnit: TLabel;
    CbRemark: TComboBox;
    Panel1: TPanel;
    BtNext: TButton;
    BtPrev: TButton;
    FDQuery_Standard: TFDQuery;
    FDQuery1: TFDQuery;
    procedure FormShow(Sender: TObject);
    procedure BtSaveClick(Sender: TObject);
    procedure EtScoreChange(Sender: TObject);
    procedure BtPrevClick(Sender: TObject);
    procedure BtNextClick(Sender: TObject);
  private
    { Private declarations }
  public
        gsRights    : String;

        gfItemMin   : Double;
        gfItemMax   : Double;
        giDirection : Integer;
        function UpdateView:Integer;
  end;

var
     Form_bop_Entry             : TForm_bop_Entry;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_Entry.BtNextClick(Sender: TObject);
begin
    FDQuery1.Next;
    UpdateView;

end;

procedure TForm_bop_Entry.BtPrevClick(Sender: TObject);
begin
    FDQuery1.Prior;
    UpdateView;
end;

procedure TForm_bop_Entry.BtSaveClick(Sender: TObject);
var
    iTestId     : Integer;
    iStudentId  : Integer;
    iItem       : Integer;
    oEdit       : TEdit;
    sSQL        : string;
begin
    //取得测试 id
    iTestId    := TForm1(self.owner).giTestId;

    //写入每名学生的成绩
    for iItem := 1 to FP.ControlCount do begin
        //取得成绩控件
        oEdit   := TEdit(FindComponent('EtScore'+IntToStr(iItem)));

        //录入成绩
        if oEdit <> nil then begin
            iStudentId  := oEdit.Tag;
            //
            sSQL    := 'DELETE bop_Score WHERE sTestId='+IntToStr(iTestId)+' AND sStudentId='+IntToStr(iStudentId)+';'
                    +' INSERT INTO bop_Score (sTestId,sStudentId,sOnsiteScore)'
                    +' VALUES('+IntToStr(iTestId)+','+IntToStr(iStudentId)+','+FloatToStr(StrToFloatDef(oEdit.Text,0))+')';
            TForm1(self.owner).FDConnection1.ExecSQL(sSQL);
        end;
    end;

    //置当前测试组的状态rStatus为1, 即已完成
    sSQL    := 'UPDATE bop_Test SET tStatus=1 WHERE tId='+IntToStr(iTestId);
    TForm1(self.owner).FDConnection1.ExecSQL(sSQL);

    //
    dwMessage('保存成功!','success',self);

    //
    TForm1(self.owner).BE.OnClick(nil);
end;

procedure TForm_bop_Entry.EtScoreChange(Sender: TObject);
var
    iTestId     : Integer;
    iStudentId  : Integer;
    iItem       : Integer;
    sSQL        : string;
    oPanel      : TPanel;
    oEtScore    : TEdit;
    oLaUnit     : TLabel;
    oCbRemark   : TComboBox;
    //
    fOnsite     : single;
    fScore      : single;
begin
    //::::: 该事件响应成绩和备注输入

    //取得测试 id
    iTestId     := TForm1(self.owner).giTestId;

    //取得各控件
    oPanel      := TPanel(TEdit(Sender).Parent);    // 父面板
    oLaUnit     := TLabel(oPanel.Controls[1]);      // 单位 label
    oEtScore    := TEdit(oPanel.Controls[2]);       // 现场成绩 edit
    oCbRemark   := TComboBox(oPanel.Controls[3]);   // 备注 combobox

    //取得学生 id
    iStudentId  := oEtScore.Tag;

    //如果单位是"分.秒", 需要转换为 秒数   -> fOnsite
    if (Pos('分',oLaUnit.Caption) > 0) and (Pos('秒',oLaUnit.Caption) > 0) then begin
        //类似: 5.24
        fOnsite := StrToFloatDef(oEtScore.Text,0);

        //转换为秒数
        fOnsite := Floor(fOnsite)*60 + Floor(Frac(fOnsite)*100);
    end else begin
        fOnsite := StrToFloatDef(oEtScore.Text,0);
    end;

    //检查最大最小值限制
    if gfItemMin <> gfItemMax then begin
        if fOnsite < gfItemMin then begin
            //
            //dwMessage('数值不能小于最小值!','error',self);
            Exit;
        end;
        if fOnsite > gfItemMax then begin
            //
            //dwMessage('数值不能大于最大值!','error',self);
            Exit;
        end;
    end;

    //计算得分, giDirection 为 项目的标准计算方向,
    //0为正方向, 即成绩戛大, 得分越大; 1为反向, 即成绩越大, 分数越小, 比如1000米跑
    fScore := 0;
    if not FDQuery_Standard.IsEmpty then begin
        if giDirection > 0 then begin
            FDQuery_Standard.Last;
            while not FDQuery_Standard.Bof do begin
                //
                if fOnsite > FDQuery_Standard.FieldByName('sValue').AsFloat then begin
                    break;
                end else begin
                    fScore  := FDQuery_Standard.FieldByName('sScore').AsFloat;
                end;
                //
                FDQuery_Standard.Prior;
            end;
        end else begin
            FDQuery_Standard.First;
            while not FDQuery_Standard.Eof do begin
                //
                if fOnsite < FDQuery_Standard.FieldByName('sValue').AsFloat then begin
                    break;
                end else begin
                    fScore  := FDQuery_Standard.FieldByName('sScore').AsFloat;
                end;
                //
                FDQuery_Standard.Next;
            end;
        end;
    end;
    if fScore = 0 then begin
        oLaUnit.Caption := TForm1(self.Owner).gsItemUnit + ' = '+Format('%.1f',[fScore]);
    end else begin
        oLaUnit.Caption := TForm1(self.Owner).gsItemUnit ;
    end;

    //生成SQL , 将当前成绩和备注 写入 bop_Score; 同时更新 bop_TestRoster
    sSQL    :=
            //先清除当前学生和当前测试的记录
            'DELETE bop_Score WHERE sTestId='+IntToStr(iTestId)+' AND sStudentId='+IntToStr(iStudentId)+';'

            //插入新记录
            +' INSERT INTO bop_Score (sTestId,sStudentId,sOnsiteScore,sScore,sTestDate,sRemark,sItemName,sItemUnit,sLocation,sManager,sTestName)'
            +' VALUES('
                +IntToStr(iTestId)
                +','+IntToStr(iStudentId)
                +','+FloatToStr(fOnsite)
                +','+FloatToStr(fScore)
                +','''+FormatDateTime('YYYY-MM-DD hh:mm:ss',Now)+''''
                +','''+oCbRemark.Text+''''
                +','''+TForm1(self.Owner).gsItemName+''''
                +','''+TForm1(self.Owner).gsItemUnit+''''
                +','''+TForm1(self.Owner).gsLocation+''''
                +','''+TForm1(self.Owner).gsManager+''''
                +','''+TForm1(self.Owner).gsTestName+''''
            +')'

            //更新 bop_TestRoster
            +' UPDATE bop_TestRoster '
            +' SET '
                +' rOnsiteScore = '+ FloatToStr(fOnsite)
                +' ,rScore = '+ FloatToStr(fScore)
                +' ,rRemark = '''+ oCbRemark.Text + ''''
            +' WHERE '
                +' rTestId = '+ IntToStr(iTestId)
                +' AND rStudentId = '+IntToStr(iStudentId)
            ;
    TForm1(self.owner).FDConnection1.ExecSQL(sSQL);

    //
    //dwMessage('录入成功!','success',self);
end;

procedure TForm_bop_Entry.FormShow(Sender: TObject);
var
    iItem       : Integer;
    sSQL        : String;
begin
    //指定数据连接
    FDQuery1.Connection         := TForm1(self.owner).FDConnection1;
    FDQuery2.Connection         := TForm1(self.owner).FDConnection1;
    FDQuery_Standard.Connection := TForm1(self.owner).FDConnection1;

    //跳转到当前记录
    FDQuery1.Open(TForm1(self.Owner).gsTestSQL);    //select xxx,yyy FROM bop_Test
    FDQuery1.Locate('tId',TForm1(self.Owner).giTestId);

    //根据 ItemName 取得最大值 最小值
    FDQuery2.Open('SELECT cMin,cMax,cDirection FROM dic_ItemCode WHERE cName = ''' + TForm1(self.Owner).gsItemName + '''');
    gfItemMin   := FDQuery2.FieldByName('cMin').AsFloat;
    gfItemMax   := FDQuery2.FieldByName('cMax').AsFloat;
    giDirection := FDQuery2.FieldByName('cMax').AsInteger;

    //根据 tItemName,tFender,tGradeNum 取得标准值
    sSQL    :=
            '''
            SELECT dis.sValue, dis.sScore
            FROM bop_Test bt
            INNER JOIN dic_Item di ON bt.tItemName = di.iItemName
                                  AND bt.tGradeNum = di.iGradeNum
                                  AND bt.tGender = di.iGender
            INNER JOIN dic_ItemStandard dis ON di.iId = dis.sItemId
            WHERE bt.tId = xxxxx
            ORDER BY dis.sValue
            ''';
    sSQL    := StringReplace(sSQL,'xxxxx',IntToStr(TForm1(self.owner).giTestId),[]);
    FDQuery_Standard.Open(sSQL);

    //创建控件
    for iItem := 1 to 10 do begin
        TPanel(CloneComponent(PnDemo)).Visible  := True;;
    end;
    PnDemo.Destroy;

    //更新显示
    UpdateView;

end;

function TForm_bop_Entry.UpdateView: Integer;
var
    iTestId     : Integer;
    iItem       : Integer;
    //iStatus     : Integer;
    iMin,iSec   : Integer;

    //
    sItemName   : String;
    sItemUnit   : string;
    //
    oPanel      : TPanel;
    oLaName     : TLabel;
    oEtScore    : TEdit;
    oLaUnit     : TLabel;
    oCbRemark   : TComboBox;
begin
    //::::: 更新当前界面的显示

    Caption     := FDQuery1.FieldByName('tName').AsString;      //测试名称, 用于显示标题
    sItemName   := FDQuery1.FieldByName('tItemName').AsString;
    sItemUnit   := FDQuery1.FieldByName('tItemUnit').AsString;    //当前测试的单位

    //
    TForm1(self.Owner).cp.ActiveCard.Caption   := FDQuery1.FieldByName('tName').AsString;      //测试名称, 用于显示标题

    //取得待录入成绩的学生名单
    FDQuery2.Open('SELECT rName,rStudentId,rOnsiteScore,rScore,rRemark FROM bop_TestRoster WHERE rTestId='+IntToStr(FDQuery1.FieldByName('tId').AsInteger));

    //先隐藏所有
    for iItem := 1 to FP.ControlCount do begin
        oPanel          := TPanel(FindComponent('PnDemo'+IntToStr(iItem)));
        oPanel.Visible  := False;
    end;

    //为控件赋值
    for iItem := 1 to FDQuery2.RecordCount do begin
        oPanel          := TPanel(FindComponent('PnDemo'+IntToStr(iItem)));
        oPanel.Visible  := True;
        oPanel.Top      := (iItem - 1)* oPanel.Height;

        //取得姓名和成绩控件
        oLaName     := TLabel(FindComponent('LaName'+IntToStr(iItem)));
        oEtScore    := TEdit(FindComponent('EtScore'+IntToStr(iItem)));
        oLaUnit     := TLabel(FindComponent('LaUnit'+IntToStr(iItem)));
        oCbRemark   := TComboBox(FindComponent('CbRemark'+IntToStr(iItem)));

        //显示姓名
        if (oLaName <> nil) and (oLaUnit <> nil) and (oEtScore <> nil) then begin
            FDQuery2.RecNo  := iItem;
            oLaName.Caption := IntToStr(iItem)+'. '+FDQuery2.FieldByName('rName').AsString;

            //设置控件的tag, 以便后面记录数据
            oEtScore.Tag    := FDQuery2.FieldByName('rStudentId').AsInteger;

            //显示:测量单位和成绩
            oLaUnit.Caption    := sItemUnit+' = '+Format('%.1f',[FDQuery2.FieldByName('rScore').AsFloat]);

            //先暂时屏蔽 OnChange 事件
            oEtScore.OnChange   := nil;
            oCbRemark.OnChange  := nil;

            //
            oCbRemark.ItemIndex := oCbRemark.Items.IndexOf(FDQuery2.FieldByName('rRemark').AsString);

            //根据是否有值, 显示现场成绩
            if FDQuery2.FieldByName('rOnsiteScore').AsFloat = 0 then begin
                oEtScore.Text   := '';
            end else begin
                if (Pos('分',oLaUnit.Caption) > 0) and (Pos('秒',oLaUnit.Caption) > 0) then begin
                    //2025-11-11后数据库采用 秒 存储, 此处需要转化为"分.秒"格式
                    //取得总秒数
                    iSec    := Round(FDQuery2.FieldByName('rOnsiteScore').AsFloat);

                    //取得分和秒
                    iMin    := iSec div 60;
                    iSec    := iSec mod 60;

                    //组合显示
                    oEtScore.Text   := Format('%d.%.2d',[iMin,iSec]);

                    //
                    if oEtScore.Text = '0.00' then begin
                        oEtScore.Text   := '';
                    end;
                end else begin
                    oEtScore.Text   := Format('%.2f',[FDQuery2.FieldByName('rOnsiteScore').AsFloat]);
                end;
            end;



            //恢复 OnChange 事件
            oCbRemark.OnChange  := EtScoreChange;
            oEtScore.OnChange   := EtScoreChange;
        end;
    end;

    //
    BtPrev.Enabled  := FDQuery1.RecNo>1;
    BtNext.Enabled  := FDQuery1.RecNo<FDQuery1.RecordCount;
end;

end.
