unit unit_Questions;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},
    CloneComponents,{用于克隆控件}

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Questions = class(TForm)
    FDQuery_Paper: TFDQuery;
    FDQuery_Topic: TFDQuery;
    FDQuery_Question: TFDQuery;
    P_Bottom: TPanel;
    Button5: TButton;
    FDQuery_Tmp: TFDQuery;
    B_Import: TButton;
    P_DeleteConfirm: TPanel;
    L_DeleteName: TLabel;
    B_DeleteOK: TButton;
    B_DeleteCance: TButton;
    SC: TScrollBox;
    P_Left: TPanel;
    Button1: TButton;
    Label_Data: TLabel;
    procedure B_ImportClick(Sender: TObject);
    procedure FormEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure B_DeleteCanceClick(Sender: TObject);
    procedure B_DeleteOKClick(Sender: TObject);
  private
  public
		gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
        procedure UpdateData;

        procedure FDQueryPrepare;                   //打开3个库，准备导入
        function  NewPaper(AText:String;AData:String):Integer;   //新增试题，返回试题AOrder
        function  NewTopic(APaperID: Integer; AText: String;Var AType:String;Var AScore:Integer): Integer;
        function  NewQuestion(APName,ATName:String;APaperID,ATopicID,AScore:Integer; AType:String;AData:TStringList;ARow:Integer):Integer; //新增小题，返回小题AOrder
  end;


implementation

uses
    Unit1;




{$R *.dfm}

//从大题题目取得：题目类型AType，内部每小题分数AScore， 总分数ATotal等
function GetTopicInfo(AText:String;var AType:String; Var AScore:integer;var ATotal:Integer):Integer;
var
    iPos    : Integer;
    sTmp    : string;
begin
    Result  := 0;

    //题目类型AType
    AType   := '未知';
    if Pos('单选',AText)>0 then begin
        AType   := '单选';
    end else if Pos('单项选择',AText)>0 then begin
        AType   := '单选';
    end else if Pos('多选',AText)>0 then begin
        AType   := '多选';
    end else if Pos('填空',AText)>0 then begin
        AType   := '填空';
    end else if Pos('多项选择',AText)>0 then begin
        AType   := '多选';
    end else if Pos('判断',AText)>0 then begin
        AType   := '判断';
    end else if Pos('简答',AText)>0 then begin
        AType   := '简答';
    end else if Pos('计算',AText)>0 then begin
        AType   := '计算';
    end else if Pos('论述',AText)>0 then begin
        AType   := '论述';
    end;

    //内部每小题分数AScore  源格式："每题2分"
    AScore  := 0;
    sTmp    := AText;
    iPos    := Pos('每小题',sTmp);
    Delete(sTmp,1,iPos+1);
    iPos    := Pos('每题',sTmp);
    Delete(sTmp,1,iPos+1);
    iPos    := Pos('分',sTmp);
    sTmp    := Trim(Copy(sTmp,1,iPos-1));
    AScore  := StrToIntDef(sTmp,0);


    //总分数ATotal  源格式："共30分"
    ATotal  := 0;
    sTmp    := AText;
    iPos    := Pos('（',sTmp);  //删除（以前的部分，以防止错误
    Delete(sTmp,1,iPos);
    iPos    := Pos('共',sTmp);
    Delete(sTmp,1,iPos+1);
    iPos    := Pos('分',sTmp);
    sTmp    := Trim(Copy(sTmp,1,iPos-1));
    ATotal  := StrToIntDef(sTmp,0);

    //
    if (AScore = 0) and (ATotal > 0) then begin
        AScore  := ATotal;
    end;
end;



procedure TForm_Questions.Button1Click(Sender: TObject);
var
    iItem       : Integer;
    oButton     : TButton;
begin
    //先清空所有试题的选中状态
    for iItem := 0 to P_Left.ControlCount - 1 do begin
        oButton := TButton(P_Left.Controls[iItem]);
        //
        oButton.Hint    := '';
    end;

    //
    oButton := TButton(Sender);
    oButton.Hint    := '{"type":"primary","icon":"el-icon-paperclip"}';

    //
    FDQuery_Tmp.Close;
    FDQuery_Tmp.SQL.Text    := 'SELECT * FROM zh_Paper WHERE AOrder = '+IntToStr(oButton.Tag);
    FDQuery_Tmp.Open;

    //
    //Memo_Data.Lines.Text    := FDQuery_Tmp.FieldByName('AData').AsString;
    Label_Data.Caption      := FDQuery_Tmp.FieldByName('AData').AsString;
end;

procedure TForm_Questions.Button5Click(Sender: TObject);
var
    iItem   : Integer;
    iOrder  : Integer;
    //
    oButton : TButton;
begin
    iOrder  := -1;
    for iItem := 0 to P_Left.ControlCount - 1 do begin
        oButton := TButton(P_Left.Controls[iItem]);
        if oButton.Visible and (oButton.Hint = '{"type":"primary","icon":"el-icon-paperclip"}') then begin
            iOrder  := oButton.Tag;
            break;
        end;
    end;

    //
    if iOrder = -1 then begin
        dwMessage('请先选择一个试题！','error',TForm1(self.Owner));
        Exit;
    end;

    //
    L_DeleteName.Caption    := '确定要删除试题 “'+oButton.Caption+'”吗？';
    L_DeleteName.Tag        := iOrder;

    //显示
    P_DeleteConfirm.Visible := True;

end;

procedure TForm_Questions.B_DeleteCanceClick(Sender: TObject);
begin
    P_DeleteConfirm.Visible := false;
end;

procedure TForm_Questions.B_DeleteOKClick(Sender: TObject);
var
    sOrder  : String;
begin
    sOrder  := IntToStr(L_DeleteName.Tag);
    //删除
    FDQuery_Tmp.Close;
    FDQuery_Tmp.SQL.Text    := 'DELETE FROM zh_Question WHERE PaperID = '+sOrder;
    FDQuery_Tmp.ExecSQL;
    //删除
    FDQuery_Tmp.Close;
    FDQuery_Tmp.SQL.Text    := 'DELETE FROM zh_Topic WHERE PaperID = '+sOrder;
    FDQuery_Tmp.ExecSQL;
    //删除
    FDQuery_Tmp.Close;
    FDQuery_Tmp.SQL.Text    := 'DELETE FROM zh_Paper WHERE AOrder = '+sOrder;
    FDQuery_Tmp.ExecSQL;

    //
    UpdateData;

    //
    TForm1(self.Owner).DockSite    := True;
    //
    P_DeleteConfirm.Visible := false;
end;

procedure TForm_Questions.B_ImportClick(Sender: TObject);
begin
    //
    dwUpload(self,'text/plain','media/doc/zheart');
end;

procedure TForm_Questions.FDQueryPrepare;
begin
    FDQuery_Paper.Close;
    FDQuery_Paper.SQL.Text  := 'SELECT * FROM zh_Paper WHERE AOrder < 0';
    FDQuery_Paper.Open;

    FDQuery_Topic.Close;
    FDQuery_Topic.SQL.Text  := 'SELECT * FROM zh_Topic WHERE AOrder < 0';
    FDQuery_Topic.Open;
    //
    FDQuery_Question.Close;
    FDQuery_Question.SQL.Text  := 'SELECT * FROM zh_Question WHERE AOrder < 0';
    FDQuery_Question.Open;

end;

procedure TForm_Questions.FormCreate(Sender: TObject);
begin
    //
    FDQuery_Paper.Connection    := TForm1(Self.Owner).FDConnection1;
    FDQuery_Topic.Connection    := FDQuery_Paper.Connection;
    FDQuery_Question.Connection := FDQuery_Paper.Connection;
    FDQuery_Tmp.Connection      := FDQuery_Paper.Connection;

    //
    UpdateData;

end;

procedure TForm_Questions.FormEndDock(Sender, Target: TObject; X, Y: Integer);
var
    sFile       : String;
    sDir        : String;
    sRow        : String;       //行文本
    sHead       : String;
    sHed3       : String;
    sType       : String;
    sPaperName  : String;
    sTopicName  : String;
    //
    slData      : TStringList;
    //
    iPaperID    : Integer;      //试题序号,从0开始
    iTopicID    : Integer;      //大题序号,从0开始
    iQuestionID : Integer;      //小题序号，从0开始
    iRow        : Integer;      //用于行循环
    iScore      : Integer;      //每小题分数
    //
    oButton     : TButton;
begin
    sDir    := ExtractFilePath(Application.ExeName)+'media/doc/ZHeart/';
    sFile   := dwGetProp(TForm1(self.Owner),'__upload');
    if FileExists(sDir + sFile) then begin
        slData  := TStringList.Create;
        slData.LoadFromFile(sDir + sFile,TEncoding.UTF8);
        if slData.Count = 0 then begin
            dwMessage('导入失败！试题数据文件为空！','error',TForm1(self.Owner));
            //
            slData.Destroy;
            //
            Exit;
        end else begin
            if LowerCase(slData[0]) <> LowerCase('//*****这是试卷*****//') then begin
                dwMessage('导入失败！试题数据格式不正确！','error',TForm1(self.Owner));
                //
                slData.Destroy;
                //
                Exit;
            end else begin
                //
                FDQueryPrepare;

                //创建新试题
                sPaperName  := slData[1];
                iPaperID    := NewPaper(slData[1],slData.Text);

                //
                for iRow := 1 to slData.Count-1 do begin
                    sRow    := Trim(slData[iRow]);
                    sHead   := Copy(sRow,1,2);
                    sHed3   := Copy(sRow,1,3);

                    //
                    if  (sHead = '一、') or (sHead = '二、') or (sHead = '三、') or
                        (sHead = '四、') or (sHead = '五、') or (sHead = '六、') or
                        (sHead = '七、') or (sHead = '八、') or (sHead = '九、') or
                        (sHead = '十、') then
                    begin
                        sTopicName  := sRow;
                        //创建大题
                        iTopicId    := NewTopic(iPaperID,sRow,sType,iScore);
                        //
                        if (sType = '计算') or (sType = '论述') then begin
                            iQuestionId := NewQuestion(sPaperName,sTopicName,iPaperID,iTopicID,iScore,sType,slData,iRow+1);
                        end;

                        //
                        continue;
                    end;

                    //
                    if  (sHead = '1、') or (sHead = '2、') or (sHead = '3、') or
                        (sHead = '4、') or (sHead = '5、') or (sHead = '6、') or
                        (sHead = '7、') or (sHead = '8、') or (sHead = '9、') or
                        (sHed3 = '10、') or
                        (sHed3 = '11、') or (sHed3 = '12、') or (sHed3 = '13、') or
                        (sHed3 = '14、') or (sHed3 = '15、') or (sHed3 = '16、') or
                        (sHed3 = '17、') or (sHed3 = '18、') or (sHed3 = '19、') or
                        (sHed3 = '20、') then
                    begin
                        //创建小题
                        iQuestionId := NewQuestion(sPaperName,sTopicName,iPaperID,iTopicID,iScore,sType,slData,iRow);

                        //
                        continue;
                    end;


                end;
            end;
        end;
        //
        slData.Destroy;
        //
        dwMessage('导入成功！','',TForm1(self.Owner));

        //添加一个按钮
        oButton     := TButton(CloneComponent(Button1));
        //
        oButton.Visible := True;
        oButton.Tag     := iPaperId;
        oButton.Caption := sPaperName;
        oButton.Top     := 9000;
        oButton.OnClick(oButton);

        //
        TForm1(self.Owner).DockSite    := True;

    end else begin
        dwMessage('导入失败！','',TForm1(self.Owner));
    end;

end;

function TForm_Questions.NewPaper(AText: String;AData:String): Integer;
var
    iMax    : Integer;
begin
    FDQuery_Tmp.Close;
    FDQuery_Tmp.SQL.Text    := 'SELECT Max(AOrder) FROM zh_Paper';
    FDQuery_Tmp.Open;
    //
    if FDQuery_Tmp.IsEmpty then begin
        iMax    := -1;
    end else begin
        iMax    := FDQuery_Tmp.Fields[0].AsInteger;
    end;

    //
    FDQuery_Paper.Append;
    FDQuery_Paper.FieldByName('AName').AsString         := AText;
    FDQuery_Paper.FieldByName('Birthday').AsDateTime    := Now;
    FDQuery_Paper.FieldByName('AOrder').AsInteger       := iMax+1;
    FDQuery_Paper.FieldByName('AData').AsString         := AData;
    FDQuery_Paper.Post;

    //
    Result  := iMax + 1;

end;

function TForm_Questions.NewTopic(APaperID: Integer; AText: String;Var AType:String;Var AScore:Integer): Integer;
var
    iMax    : Integer;
    //
    iTotal  : Integer;  //总分
begin
    FDQuery_Tmp.Close;
    FDQuery_Tmp.SQL.Text    := 'SELECT Max(AOrder) FROM zh_Topic WHERE PaperID = '+IntToStr(APaperID);
    FDQuery_Tmp.Open;
    //
    if FDQuery_Tmp.IsEmpty then begin
        iMax    := -1;
    end else begin
        iMax    := FDQuery_Tmp.Fields[0].AsInteger;
    end;

    //取得当前大题信息
    GetTopicInfo(AText,AType,AScore,iTotal);

    //添加新试卷
    FDQuery_Topic.Append;
    FDQuery_Topic.FieldByName('PaperID').AsInteger      := APaperID;
    FDQuery_Topic.FieldByName('AName').AsString         := AText;
    FDQuery_Topic.FieldByName('AType').AsString         := AType;
    FDQuery_Topic.FieldByName('AOrder').AsInteger       := iMax+1;
    FDQuery_Topic.FieldByName('AScore').AsInteger       := AScore;
    FDQuery_Topic.FieldByName('ATotal').AsInteger       := iTotal;
    FDQuery_Topic.Post;

    //
    Result  := iMax + 1;
end;

function TForm_Questions.NewQuestion(APName,ATName:String;APaperID, ATopicID,AScore: Integer; AType:String;  AData: TStringList; ARow: Integer): Integer;
var
    sA,sB,sC,sD : String;
    sE,sF       : string;
    sTmp        : String;
    sHead       : string;
    sValue      : string;
    //
    slTmp       : TStringList;
    //
    iPos        : Integer;
    iRight      : Integer;
    iOrder      : Integer;
    iRow        : Integer;
    iEnd        : Integer;
begin


    //
    iOrder      := 0;
    sTmp        := AData[ARow];
    iPos        := Pos('、',sTmp);
    sTmp        := Copy(sTmp,1,iPos-1);
    iOrder      := StrToIntDef(sTmp,0);


    //添加记录，并写入基本字段
    FDQuery_Question.Append;
    FDQuery_Question.FieldByName('PaperName').AsString      := APName;
    FDQuery_Question.FieldByName('TopicName').AsString      := ATName;
    FDQuery_Question.FieldByName('PaperID').AsInteger       := APaperID;
    FDQuery_Question.FieldByName('TopicID').AsInteger       := ATopicID;
    FDQuery_Question.FieldByName('AOrder').AsInteger        := iOrder;
    FDQuery_Question.FieldByName('AType').AsString          := AType;
    FDQuery_Question.FieldByName('AScore').AsInteger        := AScore;


    if (AType = '单选')OR(AType = '多选') then begin
        //写入正确记录 "1、《存款保险条例》是( C    )施行。"
        sTmp    := AData[ARow];
        sTmp    := StringReplace(sTmp,'(','（',[rfReplaceAll]);
        sTmp    := StringReplace(sTmp,')','）',[rfReplaceAll]);
        iPos    := Pos('（',sTmp);
        Delete(sTmp,1,iPos);
        iPos    := Pos('）',sTmp);
        Delete(sTmp,iPos,10000);
        sTmp    := StringReplace(sTmp,' ','',[rfReplaceAll]);
        FDQuery_Question.FieldByName('Answer').AsString    := Trim(sTmp);

        //写入题干，主要是去除（）中部分
        sTmp    := AData[ARow];
        sTmp    := StringReplace(sTmp,'(','（',[rfReplaceAll]);
        sTmp    := StringReplace(sTmp,')','）',[rfReplaceAll]);
        iPos    := Pos('（',sTmp);
        iRight  := Pos('）',sTmp);
        sHead   := Copy(sTmp,iPos,iRight-iPos+1);
        sTmp    := StringReplace(sTmp,sHead,'（     ）',[]);
        FDQuery_Question.FieldByName('AName').AsString  := sTmp;

        //删除以前的行，以便处理
        slTmp   := TStringList.Create;
        slTmp.AddStrings(AData);
        for iRow := 0 to ARow do begin
            slTmp.Delete(0);
        end;

        //删除以后的行，以便处理
        for iEnd := 1 to slTmp.Count-1 do begin
            sHead   := Copy(Trim(slTmp[iEnd]),1,2);
            if  ( sHead <> 'A、' ) and ( sHead <> 'B、' ) and ( sHead <> 'C、' ) and
                ( sHead <> 'D、' ) and ( sHead <> 'E、' ) and ( sHead <> 'E、' ) then
            begin
                break;
            end;
        end;
        for iRow := iEnd to slTmp.Count-1 do begin
            slTmp.Delete(iEnd);
        end;

        sTmp    := Trim(slTmp.Text);
        while True do begin
            sHead   := Copy(sTmp,1,2);
            if  (sHead = 'A、') then begin
                iPos    := Pos('B、',sTmp);
                if iPos > 0 then begin
                    sValue  := Trim(Copy(sTmp,1,iPos-1));
                    Delete(sTmp,1,iPos-1);
                end else begin
                    sValue  := Trim(sTmp);
                    sTmp    := '';
                end;
                FDQuery_Question.FieldByName('AnswerA').AsString   := sValue;
            end else if  (sHead = 'B、') then begin
                iPos    := Pos('C、',sTmp);
                if iPos > 0 then begin
                    sValue  := Trim(Copy(sTmp,1,iPos-1));
                    Delete(sTmp,1,iPos-1);
                end else begin
                    sValue  := Trim(sTmp);
                    sTmp    := '';
                end;
                FDQuery_Question.FieldByName('AnswerB').AsString   := sValue;
            end else if  (sHead = 'C、') then begin
                iPos    := Pos('D、',sTmp);
                if iPos > 0 then begin
                    sValue  := Trim(Copy(sTmp,1,iPos-1));
                    Delete(sTmp,1,iPos-1);
                end else begin
                    sValue  := Trim(sTmp);
                    sTmp    := '';
                end;
                FDQuery_Question.FieldByName('AnswerC').AsString   := sValue;
            end else if  (sHead = 'D、') then begin
                iPos    := Pos('E、',sTmp);
                if iPos > 0 then begin
                    sValue  := Trim(Copy(sTmp,1,iPos-1));
                    Delete(sTmp,1,iPos-1);
                end else begin
                    sValue  := Trim(sTmp);
                    sTmp    := '';
                end;
                FDQuery_Question.FieldByName('AnswerD').AsString   := sValue;
            end else if  (sHead = 'E、') then begin
                iPos    := Pos('F、',sTmp);
                if iPos > 0 then begin
                    sValue  := Trim(Copy(sTmp,1,iPos-1));
                    Delete(sTmp,1,iPos-1);
                end else begin
                    sValue  := Trim(sTmp);
                    sTmp    := '';
                end;
                FDQuery_Question.FieldByName('AnswerE').AsString   := sValue;
            end else if  (sHead = 'F、') then begin
                iPos    := Pos('G、',sTmp);
                if iPos > 0 then begin
                    sValue  := Trim(Copy(sTmp,1,iPos-1));
                    Delete(sTmp,1,iPos-1);
                end else begin
                    sValue  := Trim(sTmp);
                    sTmp    := '';
                end;
                FDQuery_Question.FieldByName('AnswerF').AsString   := sValue;
            end;
            //
            if Length(sTmp)<3 then begin
                Break;
            end;
        end;
    end else if (AType = '判断')OR(AType = '填空') then begin
        //写入正确记录 "1、国际商业信用的主要形式是商业性借款和直接投资。（T ）。"
        sTmp    := AData[ARow];
        sTmp    := StringReplace(sTmp,'(','（',[rfReplaceAll]);
        sTmp    := StringReplace(sTmp,')','）',[rfReplaceAll]);
        iPos    := Pos('（',sTmp);
        Delete(sTmp,1,iPos);
        iPos    := Pos('）',sTmp);
        Delete(sTmp,iPos,10000);
        sTmp    := StringReplace(sTmp,' ','',[rfReplaceAll]);
        FDQuery_Question.FieldByName('Answer').AsString    := Trim(sTmp);

        //写入题干，主要是去除（）中部分
        sTmp    := AData[ARow];
        sTmp    := StringReplace(sTmp,'(','（',[rfReplaceAll]);
        sTmp    := StringReplace(sTmp,')','）',[rfReplaceAll]);
        iPos    := Pos('（',sTmp);
        iRight  := Pos('）',sTmp);
        sHead   := Copy(sTmp,iPos,iRight-iPos+1);
        sTmp    := StringReplace(sTmp,sHead,'（     ）',[]);
        FDQuery_Question.FieldByName('AName').AsString  := sTmp;
    end else if (AType = '简答') or (AType = '计算') OR (AType = '论述') then begin
        //写入题干
        FDQuery_Question.FieldByName('AName').AsString  := AData[ARow];

        //写入参考答案。 如果下一行的内容为大题或小题的开头，则无参考答案，否则下一行为参考答案
        if AData.Count > ARow + 1 then begin
            sHead   := Copy(Trim(AData[ARow+1]),1,2);
            if  ( sHead <> '1、' ) and ( sHead <> '2、' ) and ( sHead <> '3、' ) and
                ( sHead <> '4、' ) and ( sHead <> '5、' ) and ( sHead <> '6、' ) and
                ( sHead <> '7、' ) and ( sHead <> '8、' ) and ( sHead <> '9、' ) and
                ( sHead <> '一、') and ( sHead <> '二、') and ( sHead <> '三、') and
                ( sHead <> '四、') and ( sHead <> '五、') and ( sHead <> '六、') and
                ( sHead <> '七、') and ( sHead <> '八、') and ( sHead <> '九、') and
                ( sHead <> '十、') then
            begin
                FDQuery_Question.FieldByName('Answer').AsString    := Trim(AData[ARow+1]);
            end else begin
                FDQuery_Question.FieldByName('Answer').AsString    := '';
            end;
        end;
    end;
    //
    FDQuery_Question.Post;
    //
    if slTmp <> nil then begin
        slTmp.Destroy;
    end;
end;

procedure TForm_Questions.UpdateData;
var
    iItem   : integer;
    iPID    : Integer;
    iTID    : Integer;
    iQID    : Integer;
    //
    oButton : TButton;
begin
    FDQuery_Paper.Close;
    FDQuery_Paper.SQL.Text  := 'SELECT * FROM zh_Paper ORDER BY AOrder';
    FDQuery_Paper.Open;

    //清除除Button1以外的按钮
    for iItem := P_Left.ControlCount - 1 downto 1 do begin
        P_Left.Controls[1].Destroy;
    end;

    //
    while not FDQuery_Paper.Eof do begin
        oButton     := TButton(CloneComponent(Button1));
        //
        oButton.Visible := True;
        oButton.Tag     := FDQuery_Paper.FieldByName('AOrder').AsInteger;
        oButton.Caption := FDQuery_Paper.FieldByName('AName').AsString;
        oButton.Top     := 9000;

        //
        FDQuery_Paper.Next;
    end;

end;

end.
