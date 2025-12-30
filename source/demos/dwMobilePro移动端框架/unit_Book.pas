unit unit_Book;

interface

uses
     //
     dwBase,

     //
     Forms,
     DateUtils,
     Winapi.Windows, Winapi.Messages, System.SysUtils,Graphics,
  Data.Win.ADODB, Vcl.StdCtrls, Vcl.Controls, Vcl.ExtCtrls, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_book = class(TForm)
    Panel_0: TPanel;
    CBRoom: TComboBox;
    Panel_Z9: TPanel;
    Panel1: TPanel;
    Panel11: TPanel;
    Label50: TLabel;
    Panel3: TPanel;
    Label44: TLabel;
    Label0: TLabel;
    PTitle: TPanel;
    LTitle: TLabel;
    B0: TButton;
    Button2: TButton;
    FP0: TFlowPanel;
    Label_Z7: TLabel;
    FPWeek: TFlowPanel;
    Label_Z1: TLabel;
    Label_Z2: TLabel;
    Label_Z3: TLabel;
    Label_Z4: TLabel;
    Label_Z5: TLabel;
    Label_Z6: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label24: TLabel;
    Label25: TLabel;
    Label26: TLabel;
    Label27: TLabel;
    Label28: TLabel;
    Label29: TLabel;
    Label30: TLabel;
    Label31: TLabel;
    Label32: TLabel;
    Label33: TLabel;
    Label34: TLabel;
    Label35: TLabel;
    Label36: TLabel;
    Label37: TLabel;
    Label38: TLabel;
    Label39: TLabel;
    Label40: TLabel;
    Label41: TLabel;
    Label42: TLabel;
    Panel2: TPanel;
    BPrevM: TButton;
    BNextM: TButton;
    LMon: TLabel;
    FDQuery1: TFDQuery;
    procedure BPrevMClick(Sender: TObject);
    procedure BNextMClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure CBRoomChange(Sender: TObject);
  private
    { Private declarations }
  public
    gdtDate : TDateTime;
    Procedure UpdateDateView(ADate:TDate);
  end;

var
  Form_book: TForm_book;

implementation

{$R *.dfm}

uses
    unit1;


procedure TForm_book.BNextMClick(Sender: TObject);
begin
    gdtDate := IncMonth(gdtDate,1);
    UpdateDateView(gdtDate);
end;

procedure TForm_book.BPrevMClick(Sender: TObject);
begin
    gdtDate := IncMonth(gdtDate,-1);
    UpdateDateView(gdtDate);
end;

procedure TForm_book.CBRoomChange(Sender: TObject);
begin
    UpdateDateView(gdtDate);
end;

procedure TForm_book.FormShow(Sender: TObject);
var
    sError  : String;   //用于调试错误的变量

begin
    try
        //设置数据库连接
        FDQuery1.Connection := TForm1(self.Owner).FDConnection1;

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 0';

        //<设置会议室下拉列表
        FDQuery1.Close;
        FDQuery1.Open('SELECT rName,rRemark FROM dmRoom');

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 1';

        //
        CBRoom.OnChange     := nil;

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 2';

        //
        CBRoom.Items.Clear;
        while not FDQuery1.Eof do begin
            CBRoom.Items.Add('['+FDQuery1.Fields[0].AsString+'] '+FDQuery1.Fields[1].AsString);
            //
            FDQuery1.Next;
        end;

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 3';


        //
        if CBRoom.Items.Count > 0 then begin
            CBRoom.ItemIndex    := 0;
        end;

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 4';

        CBRoom.OnChange     := CBRoomChange;

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 5';

        //>

        gdtDate := Now;

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 6';

        UpdateDateView(gdtDate);

        //设置调试错误的变量为不同的值，以排查错误
        sError  := 'error at 7';

    except
        LTitle.Caption  := sError;
    end;
end;

procedure TForm_book.UpdateDateView(ADate:TDate);
var
    iYear   : Word;
    iMonth  : Word;
    iCurMon : Word;
    iDay    : Word;
    iCurDay : Word;
    iWeek   : Integer;
    oLabel  : TLabel;
    iItem   : Integer;
    iCur    : Integer;
    sCur    : String;
    sRoom   : String;
begin
    try
        //取得当前年，月，日
        DecodeDate(ADate, iYear, iCurMon, iCurDay);

        //
        LMon.Caption    := IntToStr(iYear)+' 年 '+IntToStr(iCurMon)+' 月';

        //取当前月第1天
        iCur    := Trunc(EncodeDate(iYear, iCurMon, 1));

        //
        iWeek   := DayOfWeek(iCur);    //作用：得到指定日期的星期值，返回1～7，代表周日到周六。

        //取当前显示的第1天iCur
        Dec(iCur,iWeek-1);

        //取得会议室名称
        sRoom   := CBRoom.Text;
        Delete(sRoom,1,1);
        sRoom   := Copy(sRoom,1,Pos('] ',sRoom)-1);
        //
        FDQuery1.Close;
        FDQUery1.Open('SELECT * FROM dmBook WHERE bRoom='''+sRoom+'''');


        //显示所有日历
        for iItem := 1 to 42 do begin
            oLabel  := TLabel(FindComponent('Label'+IntToStr(iItem)));

            //取得当前年，月，日
            DecodeDate(iCur, iYear, iMonth, iDay);

            //默认背景色
            oLabel.Color    := clWhite;

            //标题
            oLabel.Caption      := IntToStr(iDay);
            oLabel.Font.Size    := 13;

            //
            if iMonth = iCurMon then begin
                //如果位于当前月内，则字体为黑色；否则为灰色
                oLabel.Font.Color   := clBlack;
                //如果正好是当天，则显示红底白字
                if iCur = Trunc(Now) then begin
                    oLabel.Color        := clRed;
                    oLabel.Font.Color   := clWhite;
                end;
            end else begin
                //如果位于当前月内，则字体为黑色；否则为灰色
                oLabel.Font.Color   := clGray;
            end;

            //检查是否已预订
            sCur    := FormatDateTime('YYYY-MM-DD',iCur);
            if FDQuery1.Locate('bDate',sCur,[]) then begin
                oLabel.Color        := $00F99F29;
                oLabel.Font.Color   := clWhite;
                oLabel.Caption      := IntToStr(iDay)+#13+FDQuery1.FieldByName('bUser').AsString;
                oLabel.Font.Size    := 9;
            end;

            //
            Inc(iCur);
        end;
    except
        dwMessage('error when UpdateDateView!','error',self);
    end;
end;

end.
