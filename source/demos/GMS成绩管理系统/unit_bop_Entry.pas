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
    PnOK: TPanel;
    BtSave: TButton;
    Fp: TFlowPanel;
    PnDemo: TPanel;
    LaName: TLabel;
    EtScore: TEdit;
    FDQuery1: TFDQuery;
    FDQuery2: TFDQuery;
    LaScore: TLabel;
    procedure FormShow(Sender: TObject);
    procedure BtSaveClick(Sender: TObject);
    procedure EtScoreChange(Sender: TObject);
  private
    { Private declarations }
  public
        gsRights    : String;
        giItemId    : Integer;  //当前测试项目的id
        gsUnit      : String;   //当前测试项目的单位
  end;

var
     Form_bop_Entry             : TForm_bop_Entry;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_bop_Entry.BtSaveClick(Sender: TObject);
var
    iTestId     : Integer;
    iStudentId  : Integer;
    iItem       : Integer;
    fData       : Double;   //现场体测数据
    fScore      : Double;   //体测成绩
    sSQL        : string;
    sSName      : string;
    oPnDemo     : TPanel;
    oLaName     : TLabel;
    oEtScore    : TEdit;
    oLaScore    : TLabel;
begin
    //取得用户id
    iTestId    := TForm1(self.owner).giTestId;

    //写入每名学生的成绩
    for iItem := 1 to FP.ControlCount do begin
        //取得成绩控件
        oPnDemo     := TPanel(FindComponent('PnDemo'+IntToStr(iItem)));
        oLaName     := TLabel(FindComponent('LaName'+IntToStr(iItem)));
        oEtScore    := TEdit(FindComponent('EtScore'+IntToStr(iItem)));
        oLaScore    := TLabel(FindComponent('LaScore'+IntToStr(iItem)));

        //录入成绩
        if oEtScore <> nil then begin
            iStudentId  := oPnDemo.Tag;

            //学生姓名
            sSName  := oLaName.Caption;
            Delete(sSName,1,Pos('.',sSName));

            //
            fData       := oEtScore.Tag/100;    //现场体测数据
            fScore      := oLaScore.Tag/100;    //体测成绩

            //
            sSQL    := 'DELETE bop_Score WHERE sTestId='+IntToStr(iTestId)+' AND sStudentId='+IntToStr(iStudentId)+';'
                    +' INSERT INTO bop_Score (sTestId,sStudentId,sOnsiteScore,sScore,sTestName,sTestDate,sStudentName,sStudentRegisterNum)'
                    +' VALUES('+IntToStr(iTestId)+','+IntToStr(iStudentId)
                            +','+FloatToStr(fData)      //现场体测数据
                            +','+FloatToStr(fScore)     //体测成绩
                            +',:TestName,:TestDate,:StudentName,:StudentRegisterNum)';
            //
            FDQuery1.Close;
            FDQuery1.SQL.Text   := sSQL;
            FDQUery1.Params.ParamByName('TestName').AsString            := Caption;
            FDQUery1.Params.ParamByName('TestDate').AsDateTime          := Now;
            FDQUery1.Params.ParamByName('StudentName').AsString         := sSName;
            FDQUery1.Params.ParamByName('StudentRegisterNum').AsString  := oPnDemo.Caption;
            //
            FDQuery1.ExecSQL;

            //更新sys_Student的中体测数值
            FDQuery1.Open('SELECT * FROM sys_Student WHERE sId='+IntToStr(iStudentId));
            if Pos('1000米',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('s1000mRun').IsNull) or (fData < FDQuery1.FieldbyName('s1000mRun').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('s1000mRun').AsFloat   := fData;
                    FDQuery1.Post;
                end;
            end else if Pos('50米',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('s50mRun').IsNull) or (fData < FDQuery1.FieldbyName('s50mRun').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('s50mRun').AsFloat   := fData;
                    FDQuery1.Post;
                end;
            end else if Pos('800米',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('s800mRun').IsNull) or (fData < FDQuery1.FieldbyName('s800mRun').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('s800mRun').AsFloat   := fData;
                    FDQuery1.Post;
                end;

            //以上体测数值是越小越好, 以下是越大越好

            end else if Pos('肺',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('sVitalCapacity').IsNull) or (fData > FDQuery1.FieldbyName('sVitalCapacity').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('sVitalCapacity').AsFloat   := fData;
                    FDQuery1.Post;
                end;
            end else if Pos('立定跳远',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('sStandingLongJump').IsNull) or (fData > FDQuery1.FieldbyName('sStandingLongJump').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('sStandingLongJump').AsFloat   := fData;
                    FDQuery1.Post;
                end;
            end else if Pos('仰卧起坐',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('sOneminSitups').IsNull) or (fData > FDQuery1.FieldbyName('sOneminSitups').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('sOneminSitups').AsFloat   := fData;
                    FDQuery1.Post;
                end;
            end else if Pos('引体向上',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('sPullup').IsNull) or (fData > FDQuery1.FieldbyName('sPullup').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('sPullup').AsFloat   := fData;
                    FDQuery1.Post;
                end;
            end else if Pos('坐位体前屈',Caption) > 0 then begin
                if (FDQuery1.FieldbyName('sSeatedForwardBend').IsNull) or (fData > FDQuery1.FieldbyName('sSeatedForwardBend').AsFloat) then begin
                    FDQuery1.Edit;
                    FDQUery1.FieldbyName('sSeatedForwardBend').AsFloat   := fData;
                    FDQuery1.Post;
                end;

            //身高/体重取最新的测试值

            end else if Pos('身高',Caption) > 0 then begin
                FDQuery1.Edit;
                FDQUery1.FieldbyName('sHeight').AsFloat   := fData;
                FDQuery1.Post;
            end else if Pos('体重',Caption) > 0 then begin
                FDQuery1.Edit;
                FDQUery1.FieldbyName('sWeight').AsFloat   := fData;
                FDQuery1.Post;
            end;
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
    //
    iItem       : Integer;          //循环变量
    //
    fScore      : Double;           //成绩
    fValue      : Double;           //现场测试数据
    //
    sIndex      : string;           //序号
    sName       : String;           //控件名称, 用来取得序号
    //
    oLaScore    : TLabel;           //实时计算和显示成绩的控件
begin
    //从名称中取得序号, 以取得对应的LaScore
    sName       := TEdit(Sender).Name;
    sIndex      := Copy(sName,8,Length(sName)-7);

    //
    oLaScore    := TLabel(FindComponent('LaScore'+sIndex));

    //取得当前现场成绩值
    fValue      := StrToFloatDef(TEdit(Sender).Text,-9999);

    //
    if fValue < -1000 then begin
        oLaScore.Caption    := gsUnit;
    end else begin

        if gsUnit = '分·秒' then begin //如果单位是"分·秒", 则是数字越大, 分数越低, 且需要进行小数点转换
            //根据当前成绩自动计算成绩
            FDQuery1.Open('SELECT * FROM dic_ItemStandard WHERE sItemId='+IntToStr(giItemId)+' ORDER BY sValue DESC');

            //将以3.54表示的时间转换为秒, 即3*60+54,注意: 3'5"应写成3.05 ; 3.5表示为3'50"
            fValue  := Trunc(fValue)*60 + (fValue - Trunc(fValue))*100;

            //将现场体测数据保存在Edit的Tag中
            TEdit(Sender).Tag   := Floor(fValue*100);

            //逐行取得成绩
            fScore  := 0;
            for iItem := 0 to FDQuery1.RecordCount - 1 do begin
                if fValue <= FDQuery1.FieldByName('sValue').AsFloat then begin
                    fScore  := FDQuery1.FieldByName('sScore').AsFloat
                end else begin
                    break;
                end;
                //
                FDQuery1.Next;
            end;

        end else if gsUnit = '秒' then begin //如果单位是秒, 则是数字越大, 分数越低

            //将现场体测数据保存在Edit的Tag中
            TEdit(Sender).Tag   := Floor(fValue*100);

            //根据当前成绩自动计算成绩
            FDQuery1.Open('SELECT * FROM dic_ItemStandard WHERE sItemId='+IntToStr(giItemId)+' ORDER BY sValue DESC');

            //逐行取得成绩
            fScore  := 0;
            for iItem := 0 to FDQuery1.RecordCount - 1 do begin
                if fValue <= FDQuery1.FieldByName('sValue').AsFloat then begin
                    fScore  := FDQuery1.FieldByName('sScore').AsFloat
                end else begin
                    break;
                end;
                //
                FDQuery1.Next;
            end;
        end else begin

            //将现场体测数据保存在Edit的Tag中
            TEdit(Sender).Tag   := Floor(fValue*100);

            //根据当前成绩自动计算成绩
            FDQuery1.Open('SELECT * FROM dic_ItemStandard WHERE sItemId='+IntToStr(giItemId)+' ORDER BY sValue');

            //逐行取得成绩
            fScore  := 0;
            for iItem := 0 to FDQuery1.RecordCount - 1 do begin
                if fValue >= FDQuery1.FieldByName('sValue').AsFloat then begin
                    fScore  := FDQuery1.FieldByName('sScore').AsFloat
                end else begin
                    break;
                end;
                //
                FDQuery1.Next;
            end;
        end;

        //
        oLaScore.Caption    := gsUnit+'，成绩：'+Format('%.1f',[fScore]);

        //将成绩保存在Label的Tag中
        oLaScore.Tag        := Floor(fScore*100);
    end;

    //
    FDQuery1.Open('')
end;

procedure TForm_bop_Entry.FormShow(Sender: TObject);
var
    iTestId     : Integer;
    iItem       : Integer;
    iStatus     : Integer;
    iSeconds    : Integer;
    //
    sGender     : String;
    sItemName   : String;

    //
    oLaName     : TLabel;
    oEtScore    : TEdit;
    oLaScore    : TLabel;
    oPnDemo     : TPanel;
begin
    //取得测试id
    iTestId    := TForm1(self.owner).giTestId;

    //指定数据连接
    FDQuery1.Connection := TForm1(self.owner).FDConnection1;
    FDQuery2.Connection := TForm1(self.owner).FDConnection1;

    //显示当前测试名称
    FDQuery1.Open('SELECT * FROM bop_Test WHERE tId='+IntToStr(iTestId));
    Caption     := FDQuery1.FieldByName('tName').AsString;      //测试名称, 用于显示标题
    iStatus     := FDQuery1.FieldByName('tStatus').AsInteger;   //测试状态, 1表示已完成. 0默认
    //取得性别和项目名称, 以后面取得"单位"和giItemId
    sGender     := FDQuery1.FieldByName('tGender').AsString;    //
    sItemName   := FDQuery1.FieldByName('tItemName').AsString;  //

    //根据性别和项目名称, 取得取得"单位"和giItemId
    FDQuery1.Open('SELECT * FROM dic_Item WHERE iGender='''+sGender+''' AND iName='''+sItemName+'''');
    giItemId    := FDQuery1.FieldByName('iId').AsInteger;       //项目的id
    gsUnit      := FDQuery1.FieldByName('iUnit').AsString;      //项目的单位

    //<以为列出待录入成绩的学生名单
    FDQuery1.Open('SELECT * FROM bop_TestRoster WHERE rTestId='+IntToStr(iTestId));

    //创建控件
    for iItem := 1 to FDQuery1.RecordCount do begin
        CloneComponent(PnDemo);
    end;
    PnDemo.Destroy;

    //为控件赋值
    for iItem := 1 to FDQuery1.RecordCount do begin
        //取得姓名和成绩控件
        oLaName     := TLabel(FindComponent('LaName'+IntToStr(iItem)));
        oEtScore    := TEdit(FindComponent('EtScore'+IntToStr(iItem)));
        oLaScore    := TLabel(FindComponent('LaScore'+IntToStr(iItem)));
        oPnDemo     := TPanel(FindComponent('PnDemo'+IntToStr(iItem)));

        //显示姓名
        if (oLaName <> nil) and (oEtScore <> nil) and  (oLaScore <> nil)  then begin
            //跳到相应记录
            FDQuery1.RecNo  := iItem;

            //将学籍号和学生id保存的PnDemo中
            oPnDemo.Caption := FDQuery1.FieldByName('rRegisterNum').AsString;
            oPnDemo.Tag     := FDQuery1.FieldByName('rStudentId').AsInteger;

            //学生姓名
            oLaName.Caption  := IntToStr(iItem)+'. '+FDQuery1.FieldByName('rName').AsString;

            //如果已经录入, 则显示录入的成绩
            if iStatus = 1 then begin
                oEtScore.Enabled    := False;
                FDQuery2.Open('SELECT sOnsiteScore,sScore FROM bop_Score WHERE sTestId='+IntToStr(iTestId)+' AND sStudentId='+IntToStr(FDQuery1.FieldByName('rStudentId').AsInteger));
                oEtScore.OnChange   := nil;
                if gsUnit = '分·秒' then begin
                    //将秒数转变为分秒格式
                    iSeconds    := Round(FDQuery2.FieldByName('sOnsiteScore').AsFloat);
                    oEtScore.Text   := Format('%d''%.2d"',[iSeconds div 60, iSeconds mod 60]);
                end else begin
                    oEtScore.Text       := Format('%.2f',[FDQuery2.FieldByName('sOnsiteScore').AsFloat]);
                end;
                oEtScore.OnChange   := EtScoreChange;
                oLaScore.Caption    := gsUnit+'，成绩：'+Format('%.1f',[FDQuery2.FieldByName('sScore').AsFloat]);
                //
                BtSave.Enabled      := False;
            end else begin
                oLaScore.Caption    := gsUnit;
            end;

            //
        end;
    end;
    //>
end;

end.
