unit unit_Review;

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
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, Vcl.WinXPanels,
  Vcl.Samples.Spin;

type
  TForm_Review = class(TForm)
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
    L_NameDU: TLabel;
    L_NameTK: TLabel;
    L_NamePD: TLabel;
    L_NameJS: TLabel;
    M_JS: TMemo;
    L_NameJD: TLabel;
    M_JD: TMemo;
    L_NameLS: TLabel;
    M_LS: TMemo;
    P_Buttons: TPanel;
    B_Prior: TButton;
    B_Submit: TButton;
    B_Next: TButton;
    P_Confirm: TPanel;
    L_ConfirmTitle: TLabel;
    B_SubmitOK: TButton;
    B_SubmitCance: TButton;
    FDQuery_Tmp: TFDQuery;
    Label1: TLabel;
    L_AnswerDX: TLabel;
    L_AnswerDU: TLabel;
    L_AnswerTK: TLabel;
    L_AnswerPD: TLabel;
    Panel2: TPanel;
    B_JD100: TButton;
    B_JD0: TButton;
    SE_JD: TSpinEdit;
    Panel1: TPanel;
    B_JS100: TButton;
    B_JS0: TButton;
    SE_JS: TSpinEdit;
    Panel3: TPanel;
    B_LS100: TButton;
    B_LS0: TButton;
    SE_LS: TSpinEdit;
    B_Close: TButton;
    Panel4: TPanel;
    procedure FormShow(Sender: TObject);
    procedure B_TestClick(Sender: TObject);
    procedure B_NextClick(Sender: TObject);
    procedure B_PriorClick(Sender: TObject);
    procedure B_SubmitClick(Sender: TObject);
    procedure B_SubmitCanceClick(Sender: TObject);
    procedure B_SubmitOKClick(Sender: TObject);
    procedure B_LS0Click(Sender: TObject);
    procedure B_LS100Click(Sender: TObject);
    procedure B_CloseClick(Sender: TObject);
    procedure B_JS0Click(Sender: TObject);
    procedure B_JD0Click(Sender: TObject);
    procedure B_JD100Click(Sender: TObject);
    procedure SE_LSChange(Sender: TObject);
    procedure B_JS100Click(Sender: TObject);
  private
  public
		gsRights    : string;	    //当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
        gjoData     : Variant;      //用于保存当前考生的考试信息
        giIndex     : Integer;      //当前评阅的题序号
        procedure UpdateData;       //更新试卷列表
        procedure UpdateQuestion;   //更新当前待答题的内容
  end;


implementation

uses
    Unit1;




{$R *.dfm}





procedure TForm_Review.B_PriorClick(Sender: TObject);
begin
    //切换记录
    if giIndex > 0 then begin
        Dec(giIndex);
    end;
    //更新显示
    UpdateQuestion;
end;

procedure TForm_Review.B_SubmitCanceClick(Sender: TObject);
begin
    if P_Confirm.Caption = '取消评阅' then begin
        P_Confirm.Visible   := false;
        P_Test.Visible      := false;
        gjoData := _json('{}');
    end else begin
        //
        P_Test.Visible      := True;
        P_Confirm.Visible   := False;
    end;

end;

procedure TForm_Review.B_SubmitClick(Sender: TObject);
var
    iItem       : Integer;
    iUntest     : Integer;
begin
    //取得未写答案的题数
    iUntest     := 0;
    for iItem := 0 to gjoData.data._Count - 1 do begin
        if gjoData.data._(iItem).score = -1 then begin
            Inc(iUntest);
        end;
    end;

    //
    if iUntest = 0 then begin
        L_ConfirmTitle.Caption  := '试题已全部评阅完成，确定要提交吗？';
    end else begin
        L_ConfirmTitle.Caption  := '试题还有 '+IntToStr(iUntest)+' / '+IntToStr(gjoData.data._Count)+' 未完成评阅，确定要提交吗？';
    end;

    //
    P_Test.Visible      := False;
    P_Confirm.Caption   := '提交评阅';
    P_Confirm.Visible   := True;
end;

procedure TForm_Review.B_SubmitOKClick(Sender: TObject);
var
    iTotal  : Integer;
    iItem   : Integer;
begin
    if P_Confirm.Caption = '取消评阅' then begin
        P_Confirm.Visible   := false;
        P_Test.Visible      := false;
        gjoData := _json('{}');
    end else if P_Confirm.Caption = '提交评阅' then begin
        //计算总分
        iTotal  := 0;
        for iItem := 0 to gjoData.data._Count - 1 do begin
            if gjoData.data._(iItem).Exists('score') then begin
                iTotal  := iTotal + Max(0,gjoData.data._(iItem).score);
            end;
        end;

        //打开数据表
        FDQuery_Tmp.Close;
        FDQUery_Tmp.SQL.Text    := 'SELECT * FROM zh_Score WHERE ID < 0';
        FDQuery_Tmp.Open;


        //写入数据
        FDQuery_Tmp.Append;
        FDQUery_Tmp.FieldByName('AUser').AsString               := gjoData.auser;
        FDQUery_Tmp.FieldByName('AUserNo').AsString             := gjoData.auserno;
        FDQUery_Tmp.FieldByName('AReviewer').AsString           := TForm1(self.Owner).gsUserName;
        FDQUery_Tmp.FieldByName('AReviewerNo').AsString         := TForm1(self.Owner).gsJobNumber;
        FDQUery_Tmp.FieldByName('ADateTime').AsDateTime         := gjoData.adatetime;
        FDQUery_Tmp.FieldByName('AReviewDateTime').AsDateTime   := Now;
        FDQUery_Tmp.FieldByName('APaperName').AsString          := gjoData.name;
        FDQUery_Tmp.FieldByName('ATotal').AsInteger             := iTotal;
        FDQUery_Tmp.FieldByName('ADetail').AsString             := DocVariantData(gjoData).ToJSON('','',jsonHumanReadable);
        FDQuery_Tmp.Post;

        //保存当前评分到试卷库中
        FDQuery1.Edit;
        FDQuery1.FieldByName('AScore').AsInteger    := iTotal;
        FDQuery1.Post;

        //关闭当前确认框
        P_Confirm.Visible := False;

        //显示成功消息
        dwShowMessage('评阅提交完成！<br/>总分: '+IntToStr(iTotal),TForm1(self.Owner));

        //关闭当前页面
        TTabSheet(Self.Parent).TabVisible   := False;
    end;

end;

procedure TForm_Review.B_CloseClick(Sender: TObject);
begin
    //
    P_Confirm.Caption   := '取消评阅';
    L_ConfirmTitle.Caption  := '确定要取消评阅吗？';
    P_Confirm.Visible   := True;
    P_Test.Visible      := False;
end;

procedure TForm_Review.B_JD0Click(Sender: TObject);
begin
    //置当前得分为0
    SE_JD.Value := 0;
    gjoData.data._(giIndex).score   := 0;
end;

procedure TForm_Review.B_JD100Click(Sender: TObject);
begin
    //置当前得分为满分
    SE_JD.Value := gjoData.data._(giIndex).total;
    gjoData.data._(giIndex).score   := gjoData.data._(giIndex).total;

end;

procedure TForm_Review.B_JS0Click(Sender: TObject);
begin
    //置当前得分为0
    SE_JS.Value := 0;
    gjoData.data._(giIndex).score   := 0;
end;

procedure TForm_Review.B_JS100Click(Sender: TObject);
begin
    //置当前得分为满分
    SE_JS.Value := gjoData.data._(giIndex).total;
    gjoData.data._(giIndex).score   := gjoData.data._(giIndex).total;
end;

procedure TForm_Review.B_LS0Click(Sender: TObject);
begin
    //置当前得分为0
    SE_LS.Value := 0;
    gjoData.data._(giIndex).score   := 0;
end;

procedure TForm_Review.B_LS100Click(Sender: TObject);
begin
    //置当前得分为满分
    SE_LS.Value := gjoData.data._(giIndex).total;
    gjoData.data._(giIndex).score   := gjoData.data._(giIndex).total;
end;

procedure TForm_Review.B_NextClick(Sender: TObject);
begin
    //切换记录
    if giIndex < gjoData.data._Count-1 then begin
        Inc(giIndex);
    end;
    //更新显示
    UpdateQuestion;
end;

procedure TForm_Review.B_TestClick(Sender: TObject);
var
    joData      : variant;
    sData       : String;
begin
    //
    P_Test.Tag          := TButton(Sender).Tag;     //当前试题的id, 非aorder

    //打开数据表
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM zh_Testdata '+
            ' WHERE Id = '+IntToStr(P_Test.Tag);
    FDQuery1.Open;

    //取得考试信息
    sData   := FDQuery1.FieldByName('AData').AsString;
    gjoData := _json(sData);
    gjoData.auser       := FDQuery1.FieldByName('AUser').AsString;
    gjoData.auserno     := FDQuery1.FieldByName('AUserNo').AsString;
    gjoData.adatetime   := FDQuery1.FieldByName('ADateTime').AsFloat;

    //当前考生用户名和试题的名称
    L_PaperName.Caption := FDQuery1.FieldByName('AUser').AsString+' : '+gjoData.name;

    //赋值第一题
    giIndex := 0;
    UpdateQuestion;

    //弹出框
    P_Test.Visible  := True;
end;

procedure TForm_Review.FormShow(Sender: TObject);
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


procedure TForm_Review.SE_LSChange(Sender: TObject);
begin
    //置当前得分
    gjoData.data._(giIndex).score   := TSpinEdit(Sender).Value;

end;

procedure TForm_Review.UpdateData;
var
    iItem   : integer;
    iPID    : Integer;
    iTID    : Integer;
    iQID    : Integer;
    //
    oButton : TButton;
begin
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM zh_Testdata WHERE AScore < 0 ORDER BY ADateTime DESC';
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
        oButton.Tag                 := FDQuery1.FieldByName('id').AsInteger;
        oButton.PressedImageIndex   := FDQuery1.FieldByName('pid').AsInteger;
        oButton.Caption             := FDQuery1.FieldByName('AUser').AsString
                +' - '+FDQuery1.FieldByName('ADateTime').AsString
                +' : '+FDQuery1.FieldByName('PName').AsString;
        oButton.Top                 := 9000;

        //
        FDQuery1.Next;
    end;

end;


procedure TForm_Review.UpdateQuestion;
var
    iPaperID    : Integer;
    iTopicID    : Integer;
    iOrder      : Integer;
    iItem       : Integer;
    //
    sType       : String;
    sName       : string;
    //
    joData      : Variant;
begin
    //说明：
    //根据当前数据表记录，显示对应的数据

    joData          := gjoData.data._(giIndex);
    if not joData.Exists('score') then begin
        joData.score    := -1;
    end;

    //
    sType           := joData.type;

    //仅显示对应TabSheet
    for iItem := 0 to PC.PageCount - 1 do begin
        PC.Pages[iItem].TabVisible  := (PC.Pages[iItem].Caption = sType);
    end;

    //得到带答案的题干
    sName   := joData.name;
    sName   := StringReplace(sName,'（','（<span style="color:#f00;font-weight: bold;">&ensp;'+joData.answer+'</span>',[]);
    //
    if sType = '单选' then begin
        L_NameDx.Caption    := sName;
        L_AnswerDX.Caption  := '考生填写：'+joData.data;
    end else if sType = '多选' then begin
        L_NameDU.Caption    := sName;
        L_AnswerDU.Caption  := '考生填写：'+joData.data;
    end else if sType = '填空' then begin
        L_NameTK.Caption    := sName;
        L_AnswerTK.Caption  := '考生填写：'+joData.data;
    end else if sType = '判断' then begin
        L_NamePD.Caption    := sName;
        L_AnswerPD.Caption  := '考生填写：'+joData.data;
    end else if sType = '计算' then begin
        L_NameJS.Caption    := joData.name;
        M_JS.Lines.Text     := joData.data;
        SE_JS.Value         := joData.score;
        SE_JS.MaxValue      := joData.total;
    end else if sType = '简答' then begin
        L_NameJD.Caption    := joData.name;
        M_JD.Lines.Text     := joData.data;
        SE_JD.Value         := joData.score;
        SE_JD.MaxValue      := joData.total;
    end else if sType = '论述' then begin
        L_NameLS.Caption    := joData.name;
        M_LS.Lines.Text     := joData.data;
        SE_LS.Value         := joData.score;
        SE_LS.MaxValue      := joData.total;
    end;
end;

end.
