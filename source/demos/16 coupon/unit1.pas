unit unit1;
interface
uses
     dwBase,
     CloneComponents,

     //
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls, Data.DB,
  Data.Win.ADODB, Vcl.Menus, Vcl.Grids, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
  FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Phys.PGDef, FireDAC.Phys.PG, FireDAC.Phys.MSSQLDef,
  FireDAC.Phys.MSSQL;
type
  TForm1 = class(TForm)
    SC: TScrollBox;
    P_Content: TPanel;
    P_Demo: TPanel;
    PC: TPanel;
    P_T: TPanel;
    P_TL: TPanel;
    L_Amount: TLabel;
    L_RMB: TLabel;
    P_TC: TPanel;
    L_Name: TLabel;
    L_Date: TLabel;
    B_Use: TButton;
    P_C: TPanel;
    P_CL: TPanel;
    L_Limit: TLabel;
    PCircle0: TPanel;
    PCircle1: TPanel;
    TB: TTrackBar;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Panel1: TPanel;
    CB_Amount: TComboBox;
    Label1: TLabel;
    FDPhysMSSQLDriverLink1: TFDPhysMSSQLDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure B_UseClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TBChange(Sender: TObject);
    procedure CB_AmountChange(Sender: TObject);
  private
    { Private declarations }
  public
        procedure UpdateView;
  end;
var
     Form1             : TForm1;

implementation

{$R *.dfm}
procedure TForm1.B_UseClick(Sender: TObject);
var
    sName   : string;
    iID     : Integer;
    oLabel  : TLabel;
begin
    //根据当前控件的名称取得序号。
    //原始的按钮控件名称为Button_Use
    //第1个克隆的按钮控件名称为Button_Use1
    //第2个克隆的按钮控件名称为Button_Use2
    //...
    //第N个克隆的按钮控件名称为Button_UseN

    //先取得当前控件名称
    sName   := TButton(Sender).Name;

    //得到序号
    Delete(sName,1,5);
    iID := StrToIntDef(sName,0);

    //
    oLabel  := TLabel(FindComponent('L_Amount'+IntToStr(iID)));

    //提示当前优惠
    dwMessage('您选择的是 '+oLabel.Caption+' 元优惠券','success',self);
end;

procedure TForm1.CB_AmountChange(Sender: TObject);
begin
    UpdateView;

end;

procedure TForm1.FormCreate(Sender: TObject);
var
    iItem       : Integer;
begin
    //创建10个优惠券面板
    for iItem := 1 to 10 do begin
        with TPanel(CloneComponent(P_Demo)) do begin
            Top := iItem * 200;
        end;
        //
        P_Content.AutoSize  := True;
    end;

    //释放源面板
    FreeAndNil(P_Demo);

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
    //
    dwSetMobileMode(self,400,900);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    iPanel  : Integer;
begin
    //
    UpdateView;
end;

procedure TForm1.TBChange(Sender: TObject);
begin
    UpdateView;
end;

procedure TForm1.UpdateView;
var
    iPage       : Integer;
    iItem       : Integer;
    iMinAmount   : Integer;
begin
    //取得最小金额
    iMinAmount   := StrToIntDef(CB_Amount.Text,0);

    //设置分页
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT count(cid) FROM dwCoupon WHERE camount>='+IntTostr(iMinAmount);
    FDQuery1.FetchOptions.RecsSkip  := 0;
    FDQuery1.FetchOptions.RecsMax   := 99999;
    FDQuery1.Open;
    TB.Max  := FDQuery1.fields[0].AsInteger;

    //取得页号，从0开始
    iPage   := TB.Position;

    //
    FDQuery1.Close;
    FDQuery1.SQL.Text   := 'SELECT * FROM dwCoupon WHERE camount>='+IntTostr(iMinAmount);
    FDQuery1.FetchOptions.RecsSkip  := iPage*10;
    FDQuery1.FetchOptions.RecsMax   := 10;
    FDQuery1.Open;

    //显示所有记录
    for iItem := 1 to FDQuery1.RecordCount do begin
        //
        with TPanel(FindComponent('P_Demo'+IntToStr(iItem))) do begin
            Visible := True;
            Top     := (iItem - 1) * 131;
        end;

        //金额
        TLabel(FindComponent('L_Amount'+IntToStr(iItem))).Caption    := FDQuery1.FieldByName('cAmount').AsString;
        //限制
        TLabel(FindComponent('L_Limit'+IntToStr(iItem))).Caption    := '满'+FDQuery1.FieldByName('cLimit').AsString+'元可用';
        //名称
        TLabel(FindComponent('L_Name'+IntToStr(iItem))).Caption     := FDQuery1.FieldByName('cName').AsString;
        //名称
        TLabel(FindComponent('L_Date'+IntToStr(iItem))).Caption     :=
            FormatDateTime('YYYY-MM-DD',FDQuery1.FieldByName('cStartDate').AsDateTime)
            +FormatDateTime('<br/> - YYYY-MM-DD',FDQuery1.FieldByName('cEndDate').AsDateTime);

        //
        FDQuery1.Next;
    end;

    //隐藏可能多余的Panel
    for iItem := FDQuery1.RecordCount + 1 to 10 do begin
        //
        with TPanel(FindComponent('P_Demo'+IntToStr(iItem))) do begin
            Visible := False;
        end;
    end;
end;

end.
