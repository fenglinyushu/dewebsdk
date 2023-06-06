unit Unit_Card;

interface

uses
    //deweb基础函数
    dwBase,
    //deweb操作Access函数
    dwAccess,

    //
    CloneComponents,

    //
    Math,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask,
    Vcl.Samples.Spin, Vcl.ComCtrls, Vcl.Grids, Data.DB, Data.Win.ADODB, Vcl.ExtCtrls,
  Vcl.Imaging.pngimage, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client;

type
  TForm_Card = class(TForm)
    TrackBar1: TTrackBar;
    Panel1: TPanel;
    Edit_Search: TEdit;
    Button_Search: TButton;
    ScrollBox1: TScrollBox;
    Panel2: TPanel;
    Panel_Card: TPanel;
    Label_name: TLabel;
    Label_Addr: TLabel;
    Label3: TLabel;
    Label_Title: TLabel;
    Label_Phone: TLabel;
    Label_Department: TLabel;
    Image_avatar: TImage;
    FDQuery1: TFDQuery;
    procedure Button_SearchClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure TrackBar1Change(Sender: TObject);
  private
    { Private declarations }
  public
        procedure UpdateData(APage:Integer);
        procedure UpdateInfos;
  end;


implementation

uses
    Unit1;

{$R *.dfm}

procedure TForm_Card.Button_SearchClick(Sender: TObject);
begin
    //
    UpdateData(1);
end;

procedure TForm_Card.FormCreate(Sender: TObject);
var
    I   : Integer;
begin
    //
    for I := 0 to 9 do begin
        with TPanel(CloneComponent(Panel_Card)) do begin
            Top     := 10 + 250*(I div 2);
            Left    := 10 + 450*(I mod 2);
            Visible := True;
        end;
    end;
end;

procedure TForm_Card.TrackBar1Change(Sender: TObject);
begin
    UpdateData(TrackBar1.Position);

end;

procedure TForm_Card.UpdateData(APage: Integer);
var
    oEvent      : Procedure(Sender:TObject) of Object;
    AQuery      : TFDQuery;
    AFields     : string;
    ATrackBar   : TTrackBar;
    ATable      : string;
    AWhere      : string;
    ACount      : Integer;
    AOrder      : String;
    S0          : String;
    iRow        : Integer;
    oPanel      : TPanel;
    sPhoto      : String;
begin
    FDQuery1.Connection := TForm1(Self.Owner).FDConnection1;
    //
    AQuery      := FDQuery1;
    AFields     := '用户名,部门,职务,地址,电话,相片';
    ATable      := 'wms_User';
    AWhere      := dwaGetWhere(AQuery,ATable,Edit_Search.Text);
    ATrackBar   := TrackBar1;
    ACount      := 10;
    AOrder      := ' ORDER BY ID';

    //保存事件，并清空，以防止循环处理
    oEvent  := ATrackBar.OnChange;
    ATrackBar.OnChange  := nil;

    //----求总数------------------------------------------------------------------------------------
    AQuery.Close;
    AQuery.SQL.Text   := 'SELECT Count(id) FROM '+ATable+' '+AWhere;
    AQuery.Open;
    ATrackBar.Max     := AQuery.Fields[0].AsInteger;
    ATrackBar.PageSize  := 10;

    //如果超出最大页数,则为最大页数
    if APage>Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize)) then begin
        APage   := Ceil(ATrackBar.Max /Math.Max(1,ATrackBar.PageSize));
    end;

    //强制APage 从1开始
    APage   := Max(1,APage);

    //----更新当前页--------------------------------------------------------------------------------

    AQuery.Close;
    if APage = 1 then begin
        AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' ID,'+AFields+' FROM '+ATable+' '+AWhere+' '+AOrder;
    end else begin
        S0 := 'SELECT TOP '+((APage-1)*ACount).ToString+' id FROM '+ATable+' '+AWhere+' '+AOrder;
        if Trim(AWhere) = '' then begin
            AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' ID,'+AFields+' FROM '+ATable+' WHERE id NOT IN ('+S0+') '+AOrder;
        end else begin
            AQuery.SQL.Text   := 'SELECT TOP '+ACount.ToString+' ID,'+AFields+' FROM '+ATable+' '+AWhere+' AND id NOT IN ('+S0+') '+AOrder;
        end;
    end;
    AQuery.Open;


     //显示数据记录
    for iRow := 1 to 10 do begin
        oPanel  := TPanel(FindComponent('Panel_Card'+iRow.ToString));
        if AQuery.Eof then begin
            oPanel.Visible  := False;
        end else begin
            oPanel.Visible  := True;
            //
            TLabel(FindComponent('Label_Name'+iRow.ToString)).Caption       := AQuery.FieldByName('用户名').AsString;
            TLabel(FindComponent('Label_Title'+iRow.ToString)).Caption      := AQuery.FieldByName('职务').AsString;
            TLabel(FindComponent('Label_Department'+iRow.ToString)).Caption := '部门 : '+AQuery.FieldByName('部门').AsString;
            TLabel(FindComponent('Label_Phone'+iRow.ToString)).Caption      := '电话 : '+AQuery.FieldByName('电话').AsString;
            TLabel(FindComponent('Label_Addr'+iRow.ToString)).Caption       := '地址 : '+AQuery.FieldByName('地址').AsString;
            sPhoto  := AQuery.FieldByName('相片').AsString;
            if FileExists(ExtractFilePath(Application.ExeName)+'media\images\dwms\'+sPhoto) then begin
                TImage(FindComponent('Image_avatar'+iRow.ToString)).Hint        := '{"src":"media/images/dwms/'+sPhoto+'"}';
            end else begin
                TImage(FindComponent('Image_avatar'+iRow.ToString)).Hint        := '{"src":"media/images/dwms/u0.png"}';
            end;
            //
            AQuery.Next;

        end;
    end;

    //恢复事件
    ATrackBar.Position  := APage;
    ATrackBar.OnChange  := oEvent;
    //FreeAndNil(oEvent);

end;

procedure TForm_Card.UpdateInfos;
begin
    //
    UpdateData(1);
end;

end.
