unit unit_Score;

interface

uses

    //
    dwBase,
    dwQuickCrud,
    dwExportToXlsUnit,

    //
    SynCommons{用于解析JSON},

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async, FireDAC.DApt, FireDAC.Phys.ODBCDef,
  FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc, FireDAC.Phys, FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Score = class(TForm)
    B_ToXls: TButton;
    B_Detail: TButton;
    P_Detail: TPanel;
    L_PaperName: TLabel;
    P_DButtons: TPanel;
    B_Close: TButton;
    M_Detail: TMemo;
    procedure FormShow(Sender: TObject);
    procedure B_ToXlsClick(Sender: TObject);
    procedure B_DetailClick(Sender: TObject);
    procedure B_CloseClick(Sender: TObject);
  private
  public
	gsRights : string;	//当前用户使用本模块的权限，格式是JSON的数组字符串，形如[1,1,1,1,1,1,0,1,0,1],各元素分别表示：显示/运行/增/删/改/查/打印/预留1/预留2/预留3
    qcConfig : String;
  end;


implementation

uses
    Unit1;




{$R *.dfm}





procedure TForm_Score.B_CloseClick(Sender: TObject);
begin
    P_Detail.Visible    := False;
end;

procedure TForm_Score.B_DetailClick(Sender: TObject);
var
    oFQ_Main    : TFDQuery;
    sDetail     : String;
begin
    oFQ_Main    := TFDQuery(FindComponent('FQ_Main'));

    //
    L_PaperName.Caption := oFQ_Main.FieldByName('APaperName').AsString + '<br/>'
            + oFQ_Main.FieldByName('AUser').AsString;
    //
    sDetail := oFQ_Main.FieldByName('ADetail').AsString;
    sDetail := StringReplace(sDetail,'"pid"',   '试卷序号',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"tid"',   '大题序号',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"qid"',   '小题序号',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"name"',  '题目名称',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"type"',  '题目类型',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"total"', '题目分数',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"answer"','参考答案',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"score"', '当前得分',[rfReplaceAll]);
    sDetail := StringReplace(sDetail,'"data"',  '答题数据',[rfReplaceAll]);
    M_Detail.Text   := sDetail;
    //
    P_Detail.Width      := TForm1(Self.Owner).Width - 100;
    P_Detail.Top        := 50;
    P_Detail.Height     := TForm1(Self.Owner).Height - 100;
    P_Detail.Visible    := True;
end;

procedure TForm_Score.B_ToXlsClick(Sender: TObject);
var
    iItem   : Integer;
    sSQL    : string;
    oQuery  : TFDQuery;
    sDir    : String;
    sFile   : String;
    //
    joConfig    : Variant;
    joField     : Variant;
    joTitle     : Variant;
begin
    //取主表的SQL语句
    sSQL    := qcGetSQL(Self,0);

    //打开Query
    oQuery  := TFDQuery.Create(self);
    oQuery.Connection   := TForm1(self.Owner).FDConnection1;
    oQuery.SQL.Text     := sSQL;
    oQuery.FetchOptions.RecsMax := 999999;
    oQuery.Open;

    //生成字段标题字符串
    joConfig    := _Json(qcConfig);
    joTitle := _json('[]');
    for iItem := 0 to joConfig.fields._Count - 1 do begin
        joField := joConfig.fields._(iItem);
        if joField.Exists('caption') then begin
            joTitle.Add(joField.caption);
        end else begin
            joTitle.Add(joField.name);
        end;
    end;

    //转成EXCEl
    sDir    := ExtractFilePath(Application.ExeName);
    sFile   := 'download/'+FormatDateTime('MMDD_hhmmsszzz_',Now)+IntToStr(Random(1000))+'.xls';
    dwExportToTitledXls(sDir+sFile,oQuery,joTitle);

    //打开下载
    dwOpenUrl(self,'/'+sFile,'_blank');

end;

procedure TForm_Score.FormShow(Sender: TObject);
var
    oForm1      : TForm1;
    joConfig    : Variant;
begin
    //取得Crud的配置信息
    joConfig    := _json(StyleName);

    //取得主窗体，以取得当前角色gsRole和当前工号gsJobNumber
    oForm1      := TForm1(self.Owner);

    //根据角色和工号更新 Crud的配置信息
    if oForm1.gsRole = '管理员' then begin
        //管理员可以删除成绩
        joConfig.delete := 1;
    end else if oForm1.gsRole = '出题人' then begin
        //出题人仅能查看本人评阅的试卷
        joConfig.where  := 'AReviewerNo='''+oForm1.gsJobNumber+'''';
    end else if oForm1.gsRole = '答题人' then begin
        //答题人仅能查看本人的试卷
        joConfig.where  := 'AUserNo='''+oForm1.gsJobNumber+'''';
    end;
    qcConfig    := joConfig;

    //创建 Crud 界面
    dwCrud(self,TForm1(self.Owner).FDConnection1,False,'');

    //额外添加按钮
    B_ToXls.Parent  := TPanel(FindComponent('P_Buttons'));
    with B_ToXls do begin
        Align           := alLeft;
        width           := 70;
        Left            := 1000;
        //
        AlignWithMargins:= True;
        Margins.Top     := 8;
        Margins.Bottom  := 7;
        Margins.Left    := 10;
        Margins.Right   := 0;
        Hint            := '{"type":"success","style":"plain","icon":"el-icon-top-right"}';
    end;
    //
    B_Detail.Parent  := TPanel(FindComponent('P_Buttons'));
    with B_Detail do begin
        Align           := alLeft;
        width           := 70;
        Left            := 1200;
        //
        AlignWithMargins:= True;
        Margins.Top     := 8;
        Margins.Bottom  := 7;
        Margins.Left    := 10;
        Margins.Right   := 0;
        Hint            := '{"type":"primary","style":"plain","icon":"el-icon-tickets"}';
    end;
end;

end.
