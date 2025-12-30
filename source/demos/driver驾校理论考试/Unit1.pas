unit Unit1;

interface

uses
     //
     dwBase,
     //
     CloneComponents,
     //
     Windows, Messages, SysUtils, Variants, Classes, Graphics,
     Controls, Forms, Dialogs, StdCtrls, ExtCtrls, Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client,
  FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    P0: TPanel;
    Panel1: TPanel;
    Img: TImage;
    Label_Title: TLabel;
    Panel2: TPanel;
    PDemo: TPanel;
    LTitle: TLabel;
    PRs: TPanel;
    RC: TRadioButton;
    RD: TRadioButton;
    RA: TRadioButton;
    RB: TRadioButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    P1: TPanel;
    BOK: TButton;
    procedure RCClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure BOKClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  end;

var
     Form1: TForm1;

implementation

{$R *.dfm}



procedure TForm1.BOKClick(Sender: TObject);
var
    oPanel    : TPanel;
    oPanelAll : TPanel;
    //
    iScore    : Integer;
    iCtrl     : Integer;
    iRight    : Integer;
begin
    iScore    := 0;

    //
    for iCtrl := 0 to P1.ControlCount-1 do begin
        oPanel    := TPanel(P1.Controls[iCtrl]);

        if not oPanel.Visible then begin
            Continue;
        end;

        oPanelAll := TPanel(oPanel.Controls[1]);

        //
        iRight    := oPanel.Tag;
        //
        if TRadioButton(oPanelAll.Controls[iRight]).Checked then begin
            Inc(iScore,5);
        end;

    end;

    //
    if iScore<60 then begin
        dwShowMessage('成绩很差,分数为 '+IntToStr(iScore)+', 不要偷懒哟!',Self);
    end else if iScore < 70 then begin
        dwShowMessage('成绩勉强及格,分数为 '+IntToStr(iScore)+',加油!',Self);
    end else if iScore < 80 then begin
        dwShowMessage('成绩还可以!,分数为 '+IntToStr(iScore)+',继续努力!',Self);
    end else begin
        dwShowMessage('成绩很好! 分数为 '+IntToStr(iScore)+',你真棒!',Self);
    end;
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: Integer);
begin
    dwSetPCMode(Self);
end;

procedure TForm1.RCClick(Sender: TObject);
var
     oPanel    : TPanel;
begin
     oPanel    := TPanel(TRadioButton(Sender).Parent);

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
     TRadioButton(oPanel.Controls[0]).OnClick   := RCClick;
     TRadioButton(oPanel.Controls[1]).OnClick   := RCClick;
     TRadioButton(oPanel.Controls[2]).OnClick   := RCClick;
     TRadioButton(oPanel.Controls[3]).OnClick   := RCClick;
end;



procedure TForm1.FormCreate(Sender: TObject);
var
     iIDs      : array[0..19] of 0..255;
     iRec      : Integer;
     I,J,K     : Integer;
     //
     iItem     : Integer;
     iA,iB     : Integer;
     iC,iD     : Integer;
     iRandom   : Integer;
     iDll      : Integer;
     //
     oPanel    : TPanel;
     oTitle    : TLabel;
     oPanelALL : TPanel;
     oCheckA   : TCheckBox;
     oCheckB   : TCheckBox;
     oCheckC   : TCheckBox;
     oCheckD   : TCheckBox;

     //
     sContent  : String;
     sTitle    : string;
     sRight    : string;
begin



     FDQuery1.SQL.Text     := 'SELECT * FROM Questions WHERE FQuestionTypeID=1';
     FDQuery1.Open;
     

     //
     randomize;
     for I := 0 to High(iIDs) do begin
          iIDs[i]   := random(256);
     end;
     for i:=0 to 19-1 do begin
          for j:= i+1 to 19 do begin
               if iIDs[i]>iIDs[j] then begin
                     k        := iIDs[i];
                     iIDs[i]  := iIDs[j];
                     iIDs[j]  := k;
               end;
          end;
     end;

     //生成20个选择题
     FDQuery1.First;
     for iItem := 0 to iIDs[0]-1 do begin
          FDQuery1.Next;
     end;
     for iItem := 0 to 19 do  begin
          //
          sContent  := (FDQuery1.FieldByName('FContent').AsString);

          //克隆控件
          oPanel    := TPanel(CloneComponent(PDemo));
          oPanel.Visible      := True;
          oPanel.Top          := 9999;  //置最底

          //保存答案
          sRight    := UpperCase((FDQuery1.FieldByName('FRightSolution').AsString));
          if sRight = 'A' then begin
               oPanel.Tag     := 0;
          end else if sRight = 'B' then begin
               oPanel.Tag     := 1;
          end else if sRight = 'C' then begin
               oPanel.Tag     := 2;
          end else if sRight = 'D' then begin
               oPanel.Tag     := 3;
          end;

          //得到各对象
          oTitle    := TLabel(oPanel.Controls[0]);
          oPanelAll := TPanel(oPanel.Controls[1]);
          oCheckA   := TCheckBox(oPanelAll.Controls[0]);
          oCheckB   := TCheckBox(oPanelAll.Controls[1]);
          oCheckC   := TCheckBox(oPanelAll.Controls[2]);
          oCheckD   := TCheckBox(oPanelAll.Controls[3]);

          //题目
          sTitle    := IntToStr(iItem+1)+'、 '+Copy(sContent,1,Pos('A、',sContent)-1);
          sTitle    := StringReplace(sTitle,#13#10,'',[rfReplaceAll]);
          sTitle    := StringReplace(sTitle,#13,'',[rfReplaceAll]);
          sTitle    := StringReplace(sTitle,#10,'',[rfReplaceAll]);
          oTitle.Caption      := Trim(sTitle);
          //以下两行是为了刷新oTitle自动高度
          oTitle.AutoSize     := False;
          oTitle.AutoSize     := True;
          //以下两行是为了解决网页显示不全的问题
          oTitle.AutoSize     := False;
          oTitle.Height       := oTitle.Height+5;


          //得到ABCD选项
          iA   := Pos('A、',sContent);
          iB   := Pos('B、',sContent);
          iC   := Pos('C、',sContent);
          iD   := Pos('D、',sContent);
          oCheckA.Caption     := Trim(Copy(sContent,iA,iB-iA));
          oCheckB.Caption     := Trim(Copy(sContent,iB,iC-iB));
          oCheckC.Caption     := Trim(Copy(sContent,iC,iD-iC));
          oCheckD.Caption     := Trim(Copy(sContent,iD,Length(sContent)-iD));

          //
          oPanelAll.Top  := 40;
          dwRealignChildren(oPanelAll,False,0);
          //
          oPanelAll.AutoSize     := False;
          oPanelAll.AutoSize     := True;
          //
          oPanel.AutoSize     := False;
          oPanel.AutoSize     := True;

          //
          if iItem < 19 then begin
               for iRec := 0 to iIDs[iItem+1]-iIDs[iItem] do begin
                    FDQuery1.Next;
               end;
          end;

     end;

end;

end.
