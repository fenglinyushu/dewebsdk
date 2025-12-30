unit unit_Test;

interface

uses

    //
    dwBase,

    //
    SynCommons{用于解析JSON},
    CloneComponents{用于克隆控件},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.WinXPanels;

type
  TForm_Test = class(TForm)
    FDQuery1: TFDQuery;
    SP: TStackPanel;
    B_Test: TButton;
    SC: TScrollBox;
    P_Test: TPanel;
    L_PaperName: TLabel;
    PC: TPageControl;
    TS_DX: TTabSheet;
    TS_DU: TTabSheet;
    TS_TK: TTabSheet;
    TS_PD: TTabSheet;
    TS_JS: TTabSheet;
    TS_JD: TTabSheet;
    TS_LS: TTabSheet;
    L_NameDX: TLabel;
    RB_A: TRadioButton;
    RB_B: TRadioButton;
    RB_C: TRadioButton;
    RB_D: TRadioButton;
    L_NameDU: TLabel;
    CK_A: TCheckBox;
    RB_E: TRadioButton;
    RB_F: TRadioButton;
    CK_B: TCheckBox;
    CK_C: TCheckBox;
    CK_D: TCheckBox;
    CK_E: TCheckBox;
    CK_F: TCheckBox;
    L_NameTK: TLabel;
    E_TK: TEdit;
    L_NamePD: TLabel;
    L_NameJS: TLabel;
    M_JS: TMemo;
    L_NameJD: TLabel;
    M_JD: TMemo;
    L_NameLS: TLabel;
    M_LS: TMemo;
    Panel2: TPanel;
    B_Prior: TButton;
    B_Submit: TButton;
    B_Next: TButton;
    RB_True: TRadioButton;
    RB_False: TRadioButton;
    P_SubmitConfirm: TPanel;
    L_SubmitTitle: TLabel;
    B_SubmitOK: TButton;
    B_SubmitCance: TButton;
    FDQuery_Tmp: TFDQuery;
    Label1: TLabel;
    B_Close: TButton;
    procedure FormShow(Sender: TObject);
    procedure B_TestClick(Sender: TObject);
    procedure B_NextClick(Sender: TObject);
    procedure B_PriorClick(Sender: TObject);
    procedure B_SubmitClick(Sender: TObject);
    procedure B_SubmitCanceClick(Sender: TObject);
    procedure B_SubmitOKClick(Sender: TObject);
  private
  public
		gsRights    : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
        gjoData     : Variant;  //用于保存当前考生的考试信息
        procedure UpdateData;       //更新试卷列表
        procedure SaveTestData;     //保存当前答题的答案内容
        procedure UpdateQuestion;   //更新当前待答题的内容
  end;


implementation

uses
    Unit1;




{$R *.dfm}





procedure TForm_Test.B_PriorClick(Sender: TObject);
begin
    //保存当前选择到JSON中
    SaveTestData;
    //切换记录
    FDQuery1.Prior;
    //更新显示
    UpdateQuestion;
end;

procedure TForm_Test.B_SubmitCanceClick(Sender: TObject);
begin
    //
    P_Test.Visible          := True;
    P_SubmitConfirm.Visible := False;

end;

procedure TForm_Test.B_SubmitClick(Sender: TObject);
var
    iItem       : Integer;
    iUntest     : Integer;
begin
    //取得未写答案的题数
    iUntest     := 0;
    for iItem := 0 to gjoData.data._Count - 1 do begin
        if gjoData.data._(iItem).data = '' then begin
            Inc(iUntest);
        end;
    end;

    //
    if iUntest = 0 then begin
        L_SubmitTitle.Caption   := '试题已全部完成，确定要交卷吗？';
    end else begin
        L_SubmitTitle.Caption   := '试题还有 '+IntToStr(iUntest)+' / '+IntToStr(gjoData.data._Count)+' 未完成，确定要交卷吗？';
    end;

    //
    P_Test.Visible          := False;
    P_SubmitConfirm.Visible := True;
end;

procedure TForm_Test.B_SubmitOKClick(Sender: TObject);
begin

    //打开数据表
    FDQuery_Tmp.Close;
    FDQUery_Tmp.SQL.Text    := 'SELECT * FROM zh_Testdata WHERE ID < 0 ';
    FDQuery_Tmp.Open;

    //写入数据
    FDQuery_Tmp.Append;
    FDQUery_Tmp.FieldByName('pid').AsInteger        := gjoData.id;
    FDQUery_Tmp.FieldByName('pname').AsString       := gjoData.name;
    FDQUery_Tmp.FieldByName('adatetime').AsDateTime := Now;
    FDQUery_Tmp.FieldByName('auser').AsString       := TForm1(self.Owner).gsUserName;
    FDQUery_Tmp.FieldByName('auserno').AsString       := TForm1(self.Owner).gsJobNumber;
    FDQUery_Tmp.FieldByName('adata').AsString       := gjoData;
    FDQUery_Tmp.FieldByName('ascore').AsInteger     := -1;
    FDQuery_Tmp.Post;

    //关闭当前确认框
    P_SubmitConfirm.Visible := False;

    //显示成功消息
    dwMessage('交卷完成！','success',TForm1(self.Owner));

end;

procedure TForm_Test.B_NextClick(Sender: TObject);
begin
    //保存当前选择到JSON中
    SaveTestData;
    //切换记录
    FDQuery1.Next;
    //更新显示
    UpdateQuestion;
end;

procedure TForm_Test.B_TestClick(Sender: TObject);
var
    joData      : variant;
begin
    //
    P_Test.Tag          := TButton(Sender).Tag;     //当前试题的AOrder
    L_PaperName.Caption := TButton(Sender).Caption; //当前试题的名称

    //打开数据表
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM zh_Question '+
            ' WHERE PaperId = '+IntToStr(P_Test.Tag)+
            ' ORDER BY PaperID,TopicId,AOrder';
    FDQuery1.Open;

    //创建考试信息
    gjoData         := _json('{}');
    gjoData.name    := TButton(Sender).Caption;             //试卷名称
    gjoData.id      := TButton(Sender).PressedImageIndex;   //id
    gjoData.aorder  := TButton(Sender).tag;                 //AOrder
    gjoData.data    := _json('[]');
    while not FDQuery1.Eof do begin
        joData          := _json('{}');
        joData.pid      := FDQuery1.FieldByName('paperid').AsInteger;   //试卷aorder
        joData.tid      := FDQuery1.FieldByName('topicid').AsInteger;   //大题aorder
        joData.qid      := FDQuery1.FieldByName('aorder').AsInteger;    //小题aorder
        joData.name     := FDQuery1.FieldByName('aname').AsString;      //题干
        joData.type     := FDQuery1.FieldByName('atype').AsString;      //题型
        joData.total    := FDQuery1.FieldByName('ascore').AsInteger;    //小题分数
        joData.answer   := FDQuery1.FieldByName('answer').AsString;     //标准答案
        joData.score    := -1;                                          //小题得分.默认-1，表示未评阅
        joData.data     := '';                                          //答题内容，选择题：A/B/C/D, 其他直接内容
        //joData.detail   := '';                                          //仅选择题时有效，记录选择题的具体内容
        //
        gjoData.data.Add(joData);
        //
        FDQuery1.Next;
    end;

    //赋值第一题
    FDQuery1.First;
    UpdateQuestion;

    //弹出框
    P_Test.Visible  := True;
end;

procedure TForm_Test.FormShow(Sender: TObject);
begin
    //
    FDQuery1.Connection     := TForm1(Self.Owner).FDConnection1;
    FDQuery_Tmp.Connection  := FDQuery1.Connection;

    //
    UpdateData;

    //
    with P_Test do begin
        Top     := 50;
        Height  := TForm1(Self.Owner).Height - 100;
    end;
end;

procedure TForm_Test.SaveTestData;
var
    joData      : Variant;
    sType       : String;
begin
    joData          := gjoData.data._(FDQuery1.RecNo-1);
    sType           := joData.type;
    //joData.detail   := '';
    if sType = '单选' then begin
        if RB_A.Checked then begin
            joData.data     := 'A';
            //joData.detail   := FDQuery1.FieldByName('AnswerA').AsString;
        end else if RB_B.Checked then begin
            joData.data := 'B';
            //joData.detail   := FDQuery1.FieldByName('AnswerB').AsString;
        end else if RB_C.Checked then begin
            joData.data := 'C';
            //joData.detail   := FDQuery1.FieldByName('AnswerC').AsString;
        end else if RB_D.Checked then begin
            joData.data := 'D';
            //joData.detail   := FDQuery1.FieldByName('AnswerD').AsString;
        end else if RB_E.Checked then begin
            joData.data := 'E';
            //joData.detail   := FDQuery1.FieldByName('AnswerE').AsString;
        end else if RB_F.Checked then begin
            joData.data := 'F';
            //joData.detail   := FDQuery1.FieldByName('AnswerF').AsString;
        end;
        //设置得分
        if joData.data = joData.answer then begin
            joData.score    := joData.total;
        end else begin
            joData.score    := 0;
        end;
    end else if sType = '多选' then begin
        joData.data     := '';
        //joData.detail   := '';
        if CK_A.Checked then begin
            joData.data     := joData.data+'A';
            //joData.detail   := FDQuery1.FieldByName('AnswerA').AsString;
        end;
        if CK_B.Checked then begin
            joData.data     := joData.data+'B';
            //joData.detail   := joData.detail+'； '+FDQuery1.FieldByName('AnswerB').AsString;
        end;
        if CK_C.Checked then begin
            joData.data     := joData.data+'C';
            //joData.detail   := joData.detail+'；'+FDQuery1.FieldByName('AnswerC').AsString;
        end;
        if CK_D.Checked then begin
            joData.data     := joData.data+'D';
            //joData.detail   := joData.detail+'； '+FDQuery1.FieldByName('AnswerD').AsString;
        end;
        if CK_E.Checked then begin
            joData.data     := joData.data+'E';
            //joData.detail   := joData.detail+'； '+FDQuery1.FieldByName('AnswerE').AsString;
        end;
        if CK_F.Checked then begin
            joData.data     := joData.data+'F';
            //joData.detail   := joData.detail+'； '+FDQuery1.FieldByName('AnswerF').AsString;
        end;
        //设置得分
        if joData.data = joData.answer then begin
            joData.score    := joData.total;
        end else begin
            joData.score    := 0;
        end;
    end else if sType = '填空' then begin
        L_NameTK.Caption    := FDQuery1.FieldByName('AName').AsString;
        joData.data         := Trim(E_TK.Text);
        //设置得分
        if joData.data = joData.answer then begin
            joData.score    := joData.total;
        end else begin
            joData.score    := 0;
        end;
    end else if sType = '判断' then begin
        if RB_True.Checked then begin
            joData.data := 'T';
        end else if RB_False.Checked then begin
            joData.data := 'F';
        end;
        //设置得分
        if joData.data = joData.answer then begin
            joData.score    := joData.total;
        end else begin
            joData.score    := 0;
        end;
    end else if sType = '计算' then begin
        L_NameJS.Caption    := FDQuery1.FieldByName('AName').AsString;
        joData.data         := M_JS.Text;
    end else if sType = '简答' then begin
        L_NameJD.Caption    := FDQuery1.FieldByName('AName').AsString;
        joData.data         := M_JD.Text;
    end else if sType = '论述' then begin
        L_NameLS.Caption    := FDQuery1.FieldByName('AName').AsString;
        joData.data         := M_LS.Text;
    end;

end;

procedure TForm_Test.UpdateData;
var
    iItem   : integer;
    iPID    : Integer;
    iTID    : Integer;
    iQID    : Integer;
    //
    oButton : TButton;
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM zh_Paper ORDER BY AOrder';
    FDQuery1.Open;

    //清除除Button1以外的按钮
    for iItem := SP.ControlCount - 1 downto 1 do begin
        SP.Controls[1].Destroy;
    end;

    //
    while not FDQuery1.Eof do begin
        oButton     := TButton(CloneComponent(B_Test));

        //
        oButton.Visible             := True;
        oButton.Tag                 := FDQuery1.FieldByName('AOrder').AsInteger;
        oButton.PressedImageIndex   := FDQuery1.FieldByName('id').AsInteger;
        oButton.Caption             := FDQuery1.FieldByName('AName').AsString;
        oButton.Top                 := 9000;

        //
        FDQuery1.Next;
    end;

end;


procedure TForm_Test.UpdateQuestion;
var
    iPaperID    : Integer;
    iTopicID    : Integer;
    iOrder      : Integer;
    iItem       : Integer;
    //
    sType       : String;
    sName       : String;
    sA,sB,sC    : String;
    sD,sE,sF    : String;
    sData       : String;
    //
    joData      : Variant;
begin
    //说明：
    //根据当前数据表记录，显示对应的数据

    //当前试题的名称 + 大题名称
    L_PaperName.Caption := FDQuery1.FieldByName('PaperName').AsString+'<br/>'+
            FDQuery1.FieldByName('TopicName').AsString;

    //取得试题类型:单选DX/多选DU/填空TK/判断PD/简答JD/计算JS/论述LS
    sType       := FDQuery1.FieldByName('AType').AsString;

    //仅显示对应TabSheet
    for iItem := 0 to PC.PageCount - 1 do begin
        PC.Pages[iItem].TabVisible  := (PC.Pages[iItem].Caption = sType);
    end;

    //定位gjoData
    joData  := gjoData.data._(FDQuery1.RecNo - 1);
    sData   := joData;

    if sType = '单选' then begin
        L_NameDX.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        //
        RB_A.Visible    := FDQuery1.FieldByName('AnswerA').AsString <> '';
        RB_A.Caption    := FDQuery1.FieldByName('AnswerA').AsString;
        RB_A.Checked    := joData.data = 'A';
        //
        RB_B.Visible    := FDQuery1.FieldByName('AnswerB').AsString <> '';
        RB_B.Caption    := FDQuery1.FieldByName('AnswerB').AsString;
        RB_B.Checked    := joData.data = 'B';
        //
        RB_C.Visible    := FDQuery1.FieldByName('AnswerC').AsString <> '';
        RB_C.Caption    := FDQuery1.FieldByName('AnswerC').AsString;
        RB_C.Checked    := joData.data = 'C';
        //
        RB_D.Visible    := FDQuery1.FieldByName('AnswerD').AsString <> '';
        RB_D.Caption    := FDQuery1.FieldByName('AnswerD').AsString;
        RB_D.Checked    := joData.data = 'D';
        //
        RB_E.Visible    := FDQuery1.FieldByName('AnswerE').AsString <> '';
        RB_E.Caption    := FDQuery1.FieldByName('AnswerE').AsString;
        RB_E.Checked    := joData.data = 'E';
        //
        RB_F.Visible    := FDQuery1.FieldByName('AnswerF').AsString <> '';
        RB_F.Caption    := FDQuery1.FieldByName('AnswerF').AsString;
        RB_F.Checked    := joData.data = 'F';
    end else if sType = '多选' then begin
        L_NameDU.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        //
        CK_A.Visible    := FDQuery1.FieldByName('AnswerA').AsString <> '';
        CK_A.Caption    := FDQuery1.FieldByName('AnswerA').AsString;
        CK_A.Checked    := Pos('A',_J2S(joData.data))>0;
        //
        CK_B.Visible    := FDQuery1.FieldByName('AnswerB').AsString <> '';
        CK_B.Caption    := FDQuery1.FieldByName('AnswerB').AsString;
        CK_B.Checked    := Pos('B',_J2S(joData.data))>0;
        //
        CK_C.Visible    := FDQuery1.FieldByName('AnswerC').AsString <> '';
        CK_C.Caption    := FDQuery1.FieldByName('AnswerC').AsString;
        CK_C.Checked    := Pos('C',_J2S(joData.data))>0;
        //
        CK_D.Visible    := FDQuery1.FieldByName('AnswerD').AsString <> '';
        CK_D.Caption    := FDQuery1.FieldByName('AnswerD').AsString;
        CK_D.Checked    := Pos('D',_J2S(joData.data))>0;
        //
        CK_E.Visible    := FDQuery1.FieldByName('AnswerE').AsString <> '';
        CK_E.Caption    := FDQuery1.FieldByName('AnswerE').AsString;
        CK_E.Checked    := Pos('E',_J2S(joData.data))>0;
        //
        CK_F.Visible    := FDQuery1.FieldByName('AnswerF').AsString <> '';
        CK_F.Caption    := FDQuery1.FieldByName('AnswerF').AsString;
        CK_F.Checked    := Pos('F',_J2S(joData.data))>0;
    end else if sType = '填空' then begin
        L_NameTK.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        E_TK.Text           := joData.data;
    end else if sType = '判断' then begin
        L_NamePD.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        RB_True.Checked     := joData.data = 'T';
        RB_False.Checked    := joData.data = 'F';
    end else if sType = '计算' then begin
        L_NameJS.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        M_JS.Text           := joData.data;
    end else if sType = '简答' then begin
        L_NameJD.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        M_JD.Text           := joData.data;
    end else if sType = '论述' then begin
        L_NameLS.Caption    := StringReplace(FDQuery1.FieldByName('AName').AsString,' ','&ensp;',[rfReplaceAll]);
        M_LS.Text           := joData.data;
    end;
end;

end.
