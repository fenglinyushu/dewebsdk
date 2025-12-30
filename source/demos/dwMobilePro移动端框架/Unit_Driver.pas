unit Unit_Driver;

interface

uses
     //
     dwBase,
     //
     CloneComponents,
     //
     Types,
     Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TForm_Driver = class(TForm)
    PC: TPanel;
    PD: TPanel;
    LT: TLabel;
    PS: TPanel;
    RBA: TRadioButton;
    RBB: TRadioButton;
    RBC: TRadioButton;
    RBD: TRadioButton;
    FDQuery1: TFDQuery;
    PTitle: TPanel;
    LTitle: TLabel;
    B0: TButton;
    Button_OK: TButton;
    procedure RBAClick(Sender: TObject);
    procedure Button_OKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  end;


implementation

{$R *.dfm}

uses
    Unit1;



procedure TForm_Driver.Button_OKClick(Sender: TObject);
var
    oPanel      : TPanel;
    oPanelAll   : TPanel;
    //
    iScore      : Integer;
    iCtrl       : Integer;
    iRight      : Integer;
begin
    iScore    := 0;

    //
    for iCtrl := 0 to PC.ControlCount-1 do begin
        oPanel    := TPanel(PC.Controls[iCtrl]);
        if not oPanel.Visible then begin
            Continue;
        end;

        oPanelAll := TPanel(oPanel.Controls[1]);

        //
        iRight    := oPanel.Tag;
        //
        if TRadioButton(oPanelAll.Controls[iRight]).Checked then begin
            Inc(iScore,10);
        end;

    end;

    //
    if iScore>=90 then begin
        dwShowMessage('优秀！分数为 '+IntToStr(iScore)+',你真棒!',Self);
    end else if iScore >= 80 then begin
        dwShowMessage('良好!,分数为 '+IntToStr(iScore)+',继续努力!',Self);
    end else if iScore >= 60 then begin
        dwShowMessage('及格！分数为 '+IntToStr(iScore)+',加油!',Self);
    end else begin
        dwShowMessage('未及格！分数为 '+IntToStr(iScore)+', 不要偷懒哟!',Self);
    end;
end;

procedure TForm_Driver.RBAClick(Sender: TObject);
var
    oPanel  : TPanel;
begin
    oPanel  := TPanel(TRadioButton(Sender).Parent);

    //先禁止事件
    TRadioButton(oPanel.Controls[0]).OnClick   := nil;
    TRadioButton(oPanel.Controls[1]).OnClick   := nil;
    TRadioButton(oPanel.Controls[2]).OnClick   := nil;
    TRadioButton(oPanel.Controls[3]).OnClick   := nil;

    //
    TRadioButton(oPanel.Controls[0]).Checked   := False;
    TRadioButton(oPanel.Controls[1]).Checked   := False;
    TRadioButton(oPanel.Controls[2]).Checked   := False;
    TRadioButton(oPanel.Controls[3]).Checked   := False;

    //
    TRadioButton(Sender).Checked  := True;

    //恢复事件
    TRadioButton(oPanel.Controls[0]).OnClick   := RBAClick;
    TRadioButton(oPanel.Controls[1]).OnClick   := RBAClick;
    TRadioButton(oPanel.Controls[2]).OnClick   := RBAClick;
    TRadioButton(oPanel.Controls[3]).OnClick   := RBAClick;
end;



procedure TForm_Driver.FormCreate(Sender: TObject);
var
    iIDs        : array[0..9] of Integer;
    iRecCount   : integer;  //总记录数
    iPart       : Integer;  //每份个数=总记录数 div 200
    iRec        : Integer;
    I,J,K       : Integer;
    //
    iItem       : Integer;
    iA,iB       : Integer;
    iC,iD       : Integer;
    iRandom     : Integer;
    iDll        : Integer;
    //
    oPanel      : TPanel;
    oTitle      : TLabel;
    oPanelALL   : TPanel;
    oCheckA     : TCheckBox;
    oCheckB     : TCheckBox;
    oCheckC     : TCheckBox;
    oCheckD     : TCheckBox;

    //
    sContent    : String;
    sTitle      : string;
    sRight      : string;
begin
    //设置数据库连接
    FDQuery1.Connection := TForm1(self.Owner).FDConnection1;

    //打开数据表
    FDQuery1.SQL.Text   := 'SELECT * FROM dmDriver WHERE dQuestionTypeID=1';
    FDQuery1.Open;

    //
    iRecCount   := FDQuery1.RecordCount;    //总记录数
    iPart       := iRecCount div 10;        //每份个数=总记录数 div 10

    //随机生成25道题目序号。将总记录数分成20份，在每份中随机。这样不会重复
    randomize;
    for I := 0 to High(iIDs)-1 do begin
        iIDs[i] := 1 + I*iPart + random(iPart);
    end;
    iIDs[9]    := 1 + 9*iPart + random(iRecCount - 9*iPart);

    //生成20个选择题
    for iItem := 0 to High(iIDs) do  begin
        //转到相应记录
        FDQuery1.RecNo  := iIDs[iItem];

        //克隆控件
        oPanel          := TPanel(CloneComponent(PD));
        oPanel.Visible  := True;
        oPanel.Top      := iItem * 1000;  //置最底

        //取得题干
        sContent    := FDQuery1.FieldByName('dContent').AsString;

        //保存答案
        sRight      := UpperCase((FDQuery1.FieldByName('dRightSolution').AsString));
        oPanel.Tag  := Ord(sRight[1]) - 65;    //Ord('A') = 65 。

        //得到各对象
        oTitle      := TLabel(oPanel.Controls[0]);        //题干
        oPanelAll   := TPanel(oPanel.Controls[1]);        //选项的外框面板
        oCheckA     := TCheckBox(oPanelAll.Controls[0]);  //选项A
        oCheckB     := TCheckBox(oPanelAll.Controls[1]);  //选项B
        oCheckC     := TCheckBox(oPanelAll.Controls[2]);  //选项C
        oCheckD     := TCheckBox(oPanelAll.Controls[3]);  //选项D

        //题目
        sTitle      := IntToStr(iItem+1)+'、 '+Copy(sContent,1,Pos('A、',sContent)-1);
        sTitle      := StringReplace(sTitle,#13,'',[rfReplaceAll]);
        sTitle      := StringReplace(sTitle,#10,'',[rfReplaceAll]);
        oTitle.Caption  := Trim(sTitle);


        //得到ABCD选项
        iA   := Pos('A、',sContent);
        iB   := Pos('B、',sContent);
        iC   := Pos('C、',sContent);
        iD   := Pos('D、',sContent);
        oCheckA.Caption     := Trim(Copy(sContent,iA,iB-iA));
        oCheckB.Caption     := Trim(Copy(sContent,iB,iC-iB));
        oCheckC.Caption     := Trim(Copy(sContent,iC,iD-iC));
        oCheckD.Caption     := Trim(Copy(sContent,iD,Length(sContent)-iD));
    end;

    //释放PD - panel demo
    PD.Destroy;

end;

end.
