unit unit_bop_ExamSyn;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},

    //
    CloneComponents,

    //
    IdHTTP, IdSSLOpenSSL, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
    IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
    FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
    FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
    Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.Imaging.pngimage;

type
  TForm_bop_ExamSyn = class(TForm)
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
    PnS: TPanel;
    LaS: TLabel;
    MeS: TMemo;
    procedure FormShow(Sender: TObject);
    procedure B0Click(Sender: TObject);
    procedure BtSubmitClick(Sender: TObject);
    procedure RbAClick(Sender: TObject);
    procedure MeSChange(Sender: TObject);
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





procedure TForm_bop_ExamSyn.B0Click(Sender: TObject);
begin
    try
    except
        dwMessage('Error when TForm_bop_Exam.B0Click!','error',self);
    end;

end;

procedure TForm_bop_ExamSyn.BtSubmitClick(Sender: TObject);
var
    iItem       : Integer;
    iCount      : Integer;
    iRes        : Integer;
    iError      : Integer;
    //
    oPanel      : TPanel;
    oPAnswer    : TPanel;
    oRbA        : TRadioButton;
    oRbB        : TRadioButton;
    oRbC        : TRadioButton;
    oRbD        : TRadioButton;
    oMeS        : TMemo;
    oLaH        : TLabel;
    iScore      : Integer;
    sSQL        : string;
    sTmp        : String;
    //
    HTTP        : TIdHTTP;
    SSLHandler  : TIdSSLIOHandlerSocketOpenSSL;
    ReqStream   : TStringStream;
    RespStream  : TMemoryStream;
    RespBytes   : TBytes;
    sResp       : string;
    sCookie     : String;
    //
    joRes       : Variant;
    joQuestion  : variant;
begin
    iError  := 0;

    try
        if BtSubmit.Caption = '退出' then begin
            iError  := 1000;
            with TForm1(self.Owner) do begin
                if gbMobile then begin
                    Inc(iError);
                    //调用主窗体的回退按钮
                    BE.Click;
                end else begin
                    Inc(iError,2);
                    CP.ActiveCard.CardVisible   := False;
                end;
            end;

        end else begin
            Inc(iError);    //1
            //
            iScore      := 0;
            //
            for iItem := 1 to 10 do begin
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

            Inc(iError);    //2
            //
            for iItem := 11 to 20 do begin
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


            Inc(iError);    //3
            //<------------AI批阅---------------------------------------------------
            HTTP        := TIdHTTP.Create(nil);
            SSLHandler  := TIdSSLIOHandlerSocketOpenSSL.Create(nil);

            //
            //
            joQuestion              := _json(
                '''
                {
                  "model": "qwen3-max",
                  "input": {
                    "messages": [
                      {
                        "role": "system",
                        "content": "请用最简洁的语言直接回答，不要解释。结果返回json整型数组"
                      },
                      {
                        "role": "user",
                        "content": ""
                      }
                    ]
                  },
                  "parameters": {
                    "max_tokens": 300,
                    "temperature": 0.01,
                    "top_p": 0.1,
                    "top_k": 10,
                    "repetition_penalty": 1.0,
                    "enable_search": false,
                    "result_format": "message"
                  }
                }
                '''
            );


            Inc(iError);    //4
            //
            sTmp    := '请比较以下标准答案和模拟答案的相似度, 以百分比给出。';
            for iItem := 1 to 5 do begin
                oPanel  := TPanel(FindComponent('PnS'+IntToStr(iItem)));
                oMeS    := TMemo(oPanel.Controls[1]);
                //
                sTmp    := sTmp + '标准答案'+IntToStr(iItem)+'：'+oPanel.Caption+'。模拟答案'+IntToStr(iItem)+'：'+oMes.Text+'。'
            end;


            Inc(iError);    //5
            //
            joQuestion.input.messages._(1).content   := sTmp;


            Inc(iError);    //6
            ///
            ReqStream := TStringStream.Create(String(joQuestion), TEncoding.UTF8);

            //
    (*
            ReqStream := TStringStream.Create(String(
                '''
                {
                  "model": "qwen3-max",
                  "input": {
                    "messages": [
                      {
                        "role": "system",
                        "content": "请用简洁的语言直接回答，不要过多解释。结果返回json整型数组"
                      },
                      {
                        "role": "user",
                        "content": "请比较以下标准答案和模拟答案的相似度, 以百分比给出。标准答案1：飞行器、地面控制站、通信系统、任务载荷。模拟答案1：飞行器、控制站、通信、载荷。标准答案2：传感器反馈调整飞行，地面控制指令控制飞行。模拟答案2：传感器反馈，控制指令调整飞行。标准答案3：农业、测绘、环境监测、军事、物流、影视。模拟答案3：农业、测绘、监测、军事、物流、影视。标准答案4：传感器、飞控系统、GPS、自动平衡算法。模拟答案4：传感器、飞控、GPS、平衡算法。标准答案5：处理传感器数据，控制飞行器稳定。模拟答案5：处理数据，控制飞行稳定。"
                      }
                    ]
                  },
                  "parameters": {
                    "max_tokens": 300,
                    "temperature": 0.01,
                    "top_p": 0.1,
                    "top_k": 10,
                    "repetition_penalty": 1.0,
                    "enable_search": false,
                    "result_format": "message"
                  }
                }
                '''
            ), TEncoding.UTF8);
    *)

            Inc(iError);    //7
            //
            RespStream := TMemoryStream.Create;

            try

                Inc(iError);    //8
                // 设置 SSL
                SSLHandler.SSLOptions.Method := sslvTLSv1_2;
                SSLHandler.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
                HTTP.IOHandler := SSLHandler;


                Inc(iError);    //9
                // 设置请求头
                HTTP.Request.ContentType := 'application/json';
                HTTP.Request.CustomHeaders.AddValue('Authorization','sk-05430ed982484bd2b98a442a62f18333');//此处为阿里云百炼平台注册的账号, 有免费额度
                // 发送 POST 请求并将响应保存到内存流
                HTTP.Post('https://dashscope.aliyuncs.com/api/v1/services/aigc/text-generation/generation', ReqStream, RespStream);


                Inc(iError);
                // 将内存流转换为字节数组
                RespStream.Position := 0;
                SetLength(RespBytes, RespStream.Size);
                RespStream.Read(RespBytes[0], RespStream.Size);


                Inc(iError);
                // 将字节数组转换为 UTF-8 字符串
                sResp   := TEncoding.UTF8.GetString(RespBytes);


                Inc(iError);
                //转化为JSON
                joRes   := _json(sResp);


                Inc(iError);
                //
                if joRes <> unassigned then begin
                    //取得答案相似度 [90, 85, 95, 90, 85]
                    sTmp    := joRes.output.choices._(0).message.content;
                    //转化为JSON数组
                    joRes   := _json(sTmp);
                    //
                    for iRes := 0 to joRes._Count - 1 do begin
                        Inc(iScore,Round(joRes._(iRes)/10));
                    end;

                end;

            finally
                RespStream.Free;
                ReqStream.Free;
                SSLHandler.Free;
                HTTP.Free;
            end;
            //>---------------------------------------------------------------------

            Inc(iError);

            //弹出成绩显示框
            PnScore.Caption := '本次考试成绩为：'+IntToStr(iScore);
            PnScore.Visible := True;

            //
            BtSubmit.Caption    := '退出';

            Inc(iError);

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

            Inc(iError);


            //清空数据表中的未完成测试信息
            FDQuery1.ExecSQL('UPDATE sys_User SET uDataSyn ='''' WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));
        end;
    except
        dwMessage('error when code = '+IntToStr(iError),'error',self);

    end;
end;

procedure TForm_bop_ExamSyn.FormShow(Sender: TObject);
var
    iItem       : Integer;
    iError      : Integer;
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
        iError  := 0;
        //设置数据库连接
        FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;

        //:::::先检查sys_User的 uData字段中 是否有 exam 信息, 如果有, 则恢复;否则重新创建测试

        //1
        Inc(iError);

        //
        FDQuery1.Open('SELECT uDataSyn FROM sys_User WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));

        //2
        Inc(iError);

        //检查是否有上次未完成的 测试信息
        bFound      := False;
        gjoData     := _json(FDQuery1.FieldByName('uDataSyn').AsString);
        if gjoData <> unassigned then begin
            if gjoData.Exists('exam') then begin
                bFound  := True;
            end;
        end;

        //3
        Inc(iError);

        if bFound then begin    // =====有上次未完成的 测试信息 ================

            //4
            Inc(iError);
            //
            FDQuery1.Open('SELECT * FROM bop_Question');

            //5
            Inc(iError);

            //-----单选题-------------------------------------------------------
            for iItem := 1 to 10 do begin
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

            //
            Inc(iError);

            //去除C/D选项, 为判断题做准备
            RbC.Destroy;
            RbD.Destroy;
            PnQ.Height  := 150;

            //
            Inc(iError);

            //-----判断题-------------------------------------------------------
            for iItem := 11 to 20 do begin
                //定位到记录
                FDQuery1.Locate('qId', gjoData.exam._(iItem-1).qid, []);

                with TPanel(CloneComponent(PnQ)) do begin
                    Parent      := Pn2;
                    Top         := 10*205 + (iItem-11) * 155;
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
            Inc(iError);

            //
            PnQ.Destroy;

            //
            Inc(iError);


            //-----简答题-------------------------------------------------------
            for iItem := 1 to 5 do begin
                //定位到记录
                FDQuery1.Locate('qId', gjoData.exam._(20+iItem-1).qid, []);

                with TPanel(CloneComponent(PnS)) do begin
                    Parent      := Pn2;
                    Top         := 10*205 + 10 * 155 + (iItem-1) * 205;
                    Tag         := FDQuery1.FieldByName('qId').AsInteger;
                    //保存当前答案
                    Caption     := FDQuery1.FieldByName('qAnswer').AsString;
                end;

                TLabel(FindComponent('LaS'+IntToStr(iItem))).Caption        := IntToStr(20+iItem)+'. '+'(简答题,10分) '+FDQuery1.FieldByName('qTitle').AsString;

                //
                if gjoData.exam._(20+iItem-1).answer <> '' then begin
                    with TMemo(FindComponent('Mes'+IntToStr(iItem))) do begin
                        OnChange    := nil;
                        Lines.Text  := gjoData.exam._(20+iItem-1).answer;
                        OnChange    := MeSChange;
                    end;
                end;
            end;

            //
            Inc(iError);

            //
            PnS.Destroy;

        end else begin  // ===== 没有上次未完成的 测试信息, 重新生成 ===========

            //
            Inc(iError,20);

            //创建
            if gjoData = unassigned then begin
                gjoData     := _json('{"exam":[]}');
            end;
            if not gjoData.Exists('exam') then begin
                gjoData.exam    := _json('[]');
            end;

            //
            Inc(iError);

            //选择10道选择题----------------------------------------------------
            // pg 的写法
            FDQuery1.Open('SELECT * FROM bop_Question WHERE qType=''选择题'' ORDER BY RANDOM() LIMIT 10;');

            //
            Inc(iError);

            //
            for iItem := 1 to 10 do begin
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

            //
            Inc(iError);

            //去除C/D选项, 为判断题做准备
            RbC.Destroy;
            RbD.Destroy;
            PnQ.Height  := 150;

            //
            Inc(iError);

            //选择10道判断题----------------------------------------------------
                // pg 的写法
                FDQuery1.Open('SELECT * FROM bop_Question WHERE qType=''判断题'' ORDER BY RANDOM() LIMIT 10;');

            //
            Inc(iError);

            //
            for iItem := 11 to 20 do begin
                with TPanel(CloneComponent(PnQ)) do begin
                    Parent      := Pn2;
                    Top         := 10*205 + (iItem-11) * 155;
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
            Inc(iError);

            //
            PnQ.Destroy;

            //
            Inc(iError);

            //选择 5 道简答题---------------------------------------------------
                // pg 的写法
                FDQuery1.Open('SELECT * FROM bop_Question WHERE qType=''简答题'' ORDER BY RANDOM() LIMIT 5;');

            //
            Inc(iError);

            //
            for iItem := 1 to 5 do begin
                with TPanel(CloneComponent(PnS)) do begin
                    Parent      := Pn2;
                    Top         := 10*205 + 10*155 + iItem * 205;
                    Tag         := FDQuery1.FieldByName('qId').AsInteger;
                    //保存当前答案
                    Caption     := FDQuery1.FieldByName('qAnswer').AsString;
                end;

                TLabel(FindComponent('LaS'+IntToStr(iItem))).Caption        := IntToStr(iItem)+'. '+'(简答题,10分) '+FDQuery1.FieldByName('qTitle').AsString;

                //保存到json
                joQuestion          := _json('{}');
                joQuestion.qid      := FDQuery1.FieldByName('qId').AsInteger;   //试题id
                joQuestion.answer   := '';  //未答题状态
                gjoData.exam.Add(joQuestion);

                //
                FDQuery1.Next;
            end;

            //
            Inc(iError);

            //
            PnS.Destroy;

            //
            Inc(iError);

            //将当前试卷信息保存到数据表
            FDQuery1.ExecSQL('UPDATE sys_User SET uDataSyn ='''+String(gjoData)+'''WHERE uId='+IntToStr(TForm1(self.Owner).gjoUserInfo.id));

            //
            Inc(iError);
        end;
    except
        dwMessage('Error when TForm_bop_ExamSyn.FormShow! code = '+IntToStr(iError),'error',self);
    end;
end;

procedure TForm_bop_ExamSyn.MeSChange(Sender: TObject);
begin
    //
end;

procedure TForm_bop_ExamSyn.RbAClick(Sender: TObject);
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
