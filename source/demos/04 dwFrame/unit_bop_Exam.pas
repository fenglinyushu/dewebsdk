unit unit_bop_Exam;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    CloneComponents,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TForm_bop_Exam = class(TForm)
    FDQuery1: TFDQuery;
    Pn1: TPanel;
    BtSubmit: TButton;
    LaT: TLabel;
    RbC: TRadioButton;
    RbA: TRadioButton;
    RbD: TRadioButton;
    RbB: TRadioButton;
    Pn2: TPanel;
    PnQ: TPanel;
    PnA: TPanel;
    LaH: TLabel;
    BtQ: TButton;
    PnScore: TPanel;
    procedure FormShow(Sender: TObject);
    procedure B0Click(Sender: TObject);
    procedure BtSubmitClick(Sender: TObject);
    procedure RbAClick(Sender: TObject);
  private
  public
		gsRights    : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
        //
        gjoData     : Variant;
  end;


implementation

uses
    Unit1;




{$R *.dfm}





procedure TForm_bop_Exam.B0Click(Sender: TObject);
begin
    try
    except
        dwMessage('Error when TForm_bop_Exam.B0Click!','error',self);
    end;

end;

procedure TForm_bop_Exam.BtSubmitClick(Sender: TObject);
var
    iItem       : Integer;
    oPanel      : TPanel;
    oPAnswer    : TPanel;
    oRbA        : TRadioButton;
    oRbB        : TRadioButton;
    oRbC        : TRadioButton;
    oRbD        : TRadioButton;
    oLaH        : TLabel;
    iScore      : Integer;
    sSQL        : string;
begin
    if BtSubmit.Caption = '退出' then begin
        with TForm1(self.Owner) do begin
            if gbMobile then begin
                //调用主窗体的回退按钮
                BE.Click;
            end else begin
                CP.ActiveCard.CardVisible   := False;
            end;
        end;

    end else begin
        //
        iScore      := 0;
        //
        for iItem := 1 to 20 do begin
            oPanel      := TPanel(FindComponent('PnQ'+IntToStr(iItem)));
            oPAnswer    := TPanel(FindComponent('PnA'+IntToStr(iItem)));
            oRbA        := TRadioButton(FindComponent('RbA'+IntToStr(iItem)));
            oRbB        := TRadioButton(FindComponent('RbB'+IntToStr(iItem)));
            oRbC        := TRadioButton(FindComponent('RbC'+IntToStr(iItem)));
            oRbD        := TRadioButton(FindComponent('RbD'+IntToStr(iItem)));
            oLaH        := TLabel(FindComponent('LaH'+IntToStr(iItem)));
            //
            if ((oPanel.Caption ='A') and oRbA.Checked) or ((oPanel.Caption ='B') and oRbB.Checked)
                or ((oPanel.Caption ='C') and oRbC.Checked) or ((oPanel.Caption ='D') and oRbD.Checked) then
            begin
                oPAnswer.Visible    := False;
                Inc(iScore,3);
            end else begin
                oPAnswer.Visible    := True;
                oLaH.Caption        := '错误！答案为：'+oPanel.Caption;
            end;
        end;

        //
        for iItem := 21 to 40 do begin
            oPanel      := TPanel(FindComponent('PnQ'+IntToStr(iItem)));
            oPAnswer    := TPanel(FindComponent('PnA'+IntToStr(iItem)));
            oRbA        := TRadioButton(FindComponent('RbA'+IntToStr(iItem)));
            oRbB        := TRadioButton(FindComponent('RbB'+IntToStr(iItem)));
            oLaH        := TLabel(FindComponent('LaH'+IntToStr(iItem)));
            //
            if ((oPanel.Caption ='正确') and oRbA.Checked) or ((oPanel.Caption ='错误') and oRbB.Checked) then
            begin
                oPAnswer.Visible    := False;
                Inc(iScore,2);
            end else begin
                oPAnswer.Visible    := True;
                oLaH.Caption        := '错误！答案为：'+oPanel.Caption;
            end;
        end;

        //显示成绩
        PnScore.Caption := '本次考试成绩为：'+IntToStr(iScore);
        PnScore.Visible := True;

        //
        BtSubmit.Caption    := '退出';

        //将当前考试数据保存到数据表中
        sSQL    := 'INSERT INTO bop_Score (sUserId,sUserName,sDateTime,sScore) VALUES(:UserId,:UserName,:DateTime,:Score);';
        FDQuery1.Close;
        FDQuery1.Disconnect;
        FDQuery1.SQL.Text   := sSQL;
        FDQUery1.Params.ParamByName('UserId').AsInteger     := TForm1(self.Owner).gjoUserInfo.id;
        FDQUery1.Params.ParamByName('UserName').AsString    := TForm1(self.Owner).gjoUserInfo.username;
        FDQUery1.Params.ParamByName('DateTime').AsDateTime  := Now;
        FDQUery1.Params.ParamByName('Score').AsInteger      := iScore;
        FDQUery1.ExecSQL;

        //清空数据表中的未完成测试信息
        FDQuery1.ExecSQL('UPDATE sys_User SET uData ='''' WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));
    end;
end;

procedure TForm_bop_Exam.FormShow(Sender: TObject);
var
    iItem       : Integer;
    bFound      : Boolean;
    //
    oLaT        : TLabel;
    oRbA        : TRadioButton;
    oRbB        : TRadioButton;
    oRbC        : TRadioButton;
    oRbD        : TRadioButton;
    //
    joQuestion  : variant;
begin
    try

        //设置数据库连接
        FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

        //:::::先检查sys_User的 uData字段中 是否有 exam 信息, 如果有, 则恢复;否则重新创建测试

        //
        FDQuery1.Open('SELECT uData FROM sys_User WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));

        //检查是否有上次未完成的 测试信息
        bFound      := False;
        gjoData     := _json(FDQuery1.FieldByName('uData').AsString);
        if gjoData <> unassigned then begin
            if gjoData.Exists('exam') then begin
                bFound  := True;
            end;
        end;

        if bFound then begin    // ----------有上次未完成的 测试信息------------
            //
            FDQuery1.Open('SELECT * FROM bop_Question');

            //
            for iItem := 1 to 20 do begin
                //定位到记录
                FDQuery1.Locate('qId', gjoData.exam._(iItem-1).qid, []);

                //
                with TPanel(CloneComponent(PnQ)) do begin
                    Parent      := Pn2;
                    Top         := (iItem-1) * 205;
                    //记住当前id
                    Tag         := FDQuery1.FieldByName('qId').AsInteger;
                    //保存当前答案
                    Caption     := FDQuery1.FieldByName('qAnswer').AsString;
                end;

                TLabel(FindComponent('LaT'+IntToStr(iItem))).Caption        := IntToStr(iItem)+'. '+'(单选题,3分) '+FDQuery1.FieldByName('qTitle').AsString;
                TRadioButton(FindComponent('RbA'+IntToStr(iItem))).Caption  := 'A. '+FDQuery1.FieldByName('qItemA').AsString;
                TRadioButton(FindComponent('RbB'+IntToStr(iItem))).Caption  := 'B. '+FDQuery1.FieldByName('qItemB').AsString;
                TRadioButton(FindComponent('RbC'+IntToStr(iItem))).Caption  := 'C. '+FDQuery1.FieldByName('qItemC').AsString;
                TRadioButton(FindComponent('RbD'+IntToStr(iItem))).Caption  := 'D. '+FDQuery1.FieldByName('qItemD').AsString;

                //
                case Integer(gjoData.exam._(iItem-1).answer) of
                    1 : begin
                        with TRadioButton(FindComponent('RbA'+IntToStr(iItem))) do begin
                            OnClick     := nil;
                            Checked     := True;
                            OnClick     := RbAClick;
                        end;
                    end;
                    2 : begin
                        with TRadioButton(FindComponent('RbB'+IntToStr(iItem))) do begin
                            OnClick     := nil;
                            Checked     := True;
                            OnClick     := RbAClick;
                        end;
                    end;
                    3 : begin
                        with TRadioButton(FindComponent('RbC'+IntToStr(iItem))) do begin
                            OnClick     := nil;
                            Checked     := True;
                            OnClick     := RbAClick;
                        end;
                    end;
                    4 : begin
                        with TRadioButton(FindComponent('RbD'+IntToStr(iItem))) do begin
                            OnClick     := nil;
                            Checked     := True;
                            OnClick     := RbAClick;
                        end;
                    end;
                end;

            end;

            //去除C/D选项, 为判断题做准备
            RbC.Destroy;
            RbD.Destroy;
            PnQ.Height  := 150;

            //
            for iItem := 21 to 40 do begin
                //定位到记录
                FDQuery1.Locate('qId', gjoData.exam._(iItem-1).qid, []);

                with TPanel(CloneComponent(PnQ)) do begin
                    Parent      := Pn2;
                    Top         := 20*205 + (iItem-21) * 155;
                    Tag         := FDQuery1.FieldByName('qId').AsInteger;
                    //保存当前答案
                    Caption     := FDQuery1.FieldByName('qAnswer').AsString;
                end;

                TLabel(FindComponent('LaT'+IntToStr(iItem))).Caption        := IntToStr(iItem)+'. '+'(判断题,2分) '+FDQuery1.FieldByName('qTitle').AsString;
                TRadioButton(FindComponent('RbA'+IntToStr(iItem))).Caption  := 'A. 正确';
                TRadioButton(FindComponent('RbB'+IntToStr(iItem))).Caption  := 'B. 错误';

                //
                case Integer(gjoData.exam._(iItem-1).answer) of
                    1 : begin
                        with TRadioButton(FindComponent('RbA'+IntToStr(iItem))) do begin
                            OnClick     := nil;
                            Checked     := True;
                            OnClick     := RbAClick;
                        end;
                    end;
                    2 : begin
                        with TRadioButton(FindComponent('RbB'+IntToStr(iItem))) do begin
                            OnClick     := nil;
                            Checked     := True;
                            OnClick     := RbAClick;
                        end;
                    end;
                end;
            end;

            //
            PnQ.Destroy;

        end else begin          // ----没有上次未完成的 测试信息, 重新生成------

            //创建
            if gjoData = unassigned then begin
                gjoData     := _json('{"exam":[]}');
            end;
            if not gjoData.Exists('exam') then begin
                gjoData.exam    := _json('[]');
            end;

            //选择20道选择题----------
            // pg 的写法
            FDQuery1.Open('SELECT * FROM bop_Question WHERE qType=''选择题'' ORDER BY RANDOM() LIMIT 20;');

            //
            for iItem := 1 to 20 do begin
                with TPanel(CloneComponent(PnQ)) do begin
                    Parent      := Pn2;
                    Top         := (iItem-1) * 205;
                    //记住当前id
                    Tag         := FDQuery1.FieldByName('qId').AsInteger;
                    //保存当前答案
                    Caption     := FDQuery1.FieldByName('qAnswer').AsString;
                end;

                TLabel(FindComponent('LaT'+IntToStr(iItem))).Caption        := IntToStr(iItem)+'. '+'(单选题,3分) '+FDQuery1.FieldByName('qTitle').AsString;
                TRadioButton(FindComponent('RbA'+IntToStr(iItem))).Caption  := 'A. '+FDQuery1.FieldByName('qItemA').AsString;
                TRadioButton(FindComponent('RbB'+IntToStr(iItem))).Caption  := 'B. '+FDQuery1.FieldByName('qItemB').AsString;
                TRadioButton(FindComponent('RbC'+IntToStr(iItem))).Caption  := 'C. '+FDQuery1.FieldByName('qItemC').AsString;
                TRadioButton(FindComponent('RbD'+IntToStr(iItem))).Caption  := 'D. '+FDQuery1.FieldByName('qItemD').AsString;

                //保存到json
                joQuestion  := _json('{}');
                joQuestion.qid      := FDQuery1.FieldByName('qId').AsInteger;   //试题id
                joQuestion.answer   := -1;  //未答题状态
                gjoData.exam.Add(joQuestion);

                //
                FDQuery1.Next;
            end;

            //去除C/D选项, 为判断题做准备
            RbC.Destroy;
            RbD.Destroy;
            PnQ.Height  := 150;

            //选择20道判断题----------
                // pg 的写法
                FDQuery1.Open('SELECT * FROM bop_Question WHERE qType=''判断题'' ORDER BY RANDOM() LIMIT 20;');

            //
            for iItem := 21 to 40 do begin
                with TPanel(CloneComponent(PnQ)) do begin
                    Parent      := Pn2;
                    Top         := 20*205 + (iItem-21) * 155;
                    Tag         := FDQuery1.FieldByName('qId').AsInteger;
                    //保存当前答案
                    Caption     := FDQuery1.FieldByName('qAnswer').AsString;
                end;

                TLabel(FindComponent('LaT'+IntToStr(iItem))).Caption        := IntToStr(iItem)+'. '+'(判断题,2分) '+FDQuery1.FieldByName('qTitle').AsString;
                TRadioButton(FindComponent('RbA'+IntToStr(iItem))).Caption  := 'A. 正确';
                TRadioButton(FindComponent('RbB'+IntToStr(iItem))).Caption  := 'B. 错误';

                //保存到json
                joQuestion  := _json('{}');
                joQuestion.qid      := FDQuery1.FieldByName('qId').AsInteger;   //试题id
                joQuestion.answer   := -1;  //未答题状态
                gjoData.exam.Add(joQuestion);

                //
                FDQuery1.Next;
            end;

            //
            PnQ.Destroy;

            //将当前试卷信息保存到数据表
            FDQuery1.ExecSQL('UPDATE sys_User SET uData ='''+String(gjoData)+'''WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));
        end;
    except
        //如出现异常, 将uData字段清空, 以重新考试
        FDQuery1.ExecSQL('UPDATE sys_User SET uData ='''+''+'''WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));

        //
        dwMessage('Error when TForm_bop_Exam.FormShow!','error',self);
    end;
end;

procedure TForm_bop_Exam.RbAClick(Sender: TObject);
var
    iIndex      : Integer;
    iItem       : Integer;
    //
    sName       : String;
begin
    //===== 将当前选择信息保存到 sys_user对应记录的 uData 中

    //取得序号, 一般从其父对象的name中取, 类似 PnQ16
    sName   := TPanel(TRadioButton(Sender).Parent).Name;
    iIndex  := StrToIntDef(Copy(sName,4,2),-1);

    //
    if iIndex < 0  then begin
        dwMessage('error when RbAClick : '+sName,'error',self);
    end else begin
        Dec(iIndex);
        //
        if gjoData.exam._Count <= iIndex  then begin
            dwMessage('error when RbAClick get iIndex: '+IntToStr(iIndex),'error',self);
        end else begin
            //取得当前控件Name, 一般类似 RbA12
            sName   := TRadioButton(Sender).Name;
            //
            gjoData.exam._(iIndex).answer := Ord(sName[3]) - 64; //A/B/C/D, 对应1/2/3/4

            //将当前试卷信息保存到数据表
            FDQuery1.ExecSQL('UPDATE sys_User SET uData ='''+String(gjoData)+'''WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));
        end;
    end;

end;

end.
