unit unit1;

interface

uses
     dwBase,
     dwfUnit,
     CloneComponents,
     //
     Math,
     Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
     Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Vcl.Imaging.jpeg, Data.DB, Data.Win.ADODB, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Stan.Async, FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    Image_banner: TImage;
    Label_Recommend: TLabel;
    Panel_Recommend: TPanel;
    Panel_R1: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Panel1: TPanel;
    Image2: TImage;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Panel2: TPanel;
    Image3: TImage;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Panel_Foods: TPanel;
    Panel4: TPanel;
    Panel_t1: TPanel;
    Image4: TImage;
    Label13: TLabel;
    Panel_t0: TPanel;
    Image5: TImage;
    Label14: TLabel;
    Panel_t2: TPanel;
    Image6: TImage;
    Label15: TLabel;
    Panel_t3: TPanel;
    Image7: TImage;
    Label16: TLabel;
    Panel_Search: TPanel;
    Edit_Keyword: TEdit;
    ScrollBox: TScrollBox;
    Panel_Content: TPanel;
    Panel_Food: TPanel;
    Image_demo: TImage;
    Panel12: TPanel;
    Label_Introduce: TLabel;
    Label_Price: TLabel;
    Button_Add: TButton;
    Panel13: TPanel;
    Label_Title: TLabel;
    Panel_t4: TPanel;
    Label22: TLabel;
    Panel_t5: TPanel;
    Label23: TLabel;
    Panel_t6: TPanel;
    Label24: TLabel;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure Button_AddClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ScrollBoxEndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Panel_t0Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    procedure SetType(AType:Integer);
  end;

var
     Form1             : TForm1;


implementation


{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
    //
    dwMessage('已添加 嫩牛明星四件套','success',self);
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
    dwMessage('已添加 鸡牛双享餐','success',self);

end;

procedure TForm1.Button3Click(Sender: TObject);
begin
    dwMessage('已添加 堡堡丰盛双人餐','success',self);

end;

procedure TForm1.Button_AddClick(Sender: TObject);
var
    sName   : string;
    oLabel  : TLabel;
begin
    sName   := TButton(Sender).Name;
    //
    Delete(sName,1,10);
    //
    oLabel  := TLabel(FindComponent('Label_Title'+sName));
    //
    dwMessage('已添加 '+oLabel.Caption,'success',self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetMobileMode(Self,400,900);
    //
    Image_Banner.Height := Round( Image_Banner.Width * 150/400);

    //
    dwfAlignHorzColPro(Panel_Recommend,3);
end;

procedure TForm1.FormShow(Sender: TObject);
var
    iFood   : Integer;
begin
    //
    FDQuery1.Close;
    FDQuery1.SQL.Text  := 'SELECT * FROM k_food ORDER BY id';
    FDQuery1.Open;

    //

    //
    for iFood := 1 to FDQuery1.RecordCount do begin
        with TPanel(CloneComponent(Panel_Food)) do begin
            Visible := True;
            Top     := iFood * 200;
        end;

        //
        with TImage(FindComponent('image_demo'+IntToStr(iFood))) do begin
            Hint    := Format('{"src":"media/images/kfc/%s.jpg","radius":"10px","dwstyle":"border:solid 1px #fdfdfd;"}',[FDQuery1.FieldByName('photo').AsString]);
        end;

        //
        with TLabel(FindComponent('label_title'+IntToStr(iFood))) do begin
            caption := FDQuery1.FieldByName('title').AsString;  //FDQuery1.FieldByName('id').AsString+'-'+
        end;

        //
        with TLabel(FindComponent('label_introduce'+IntToStr(iFood))) do begin
            caption := FDQuery1.FieldByName('introduce').AsString;
        end;

        //
        with TLabel(FindComponent('label_price'+IntToStr(iFood))) do begin
            caption := Format('￥%.1f',[FDQuery1.FieldByName('price').AsInteger/10]);
        end;
        //
        FDQuery1.Next;
    end;
    Panel_Content.AutoSize  := True;
end;

procedure TForm1.Panel_t0Click(Sender: TObject);
var
    sName   : string;
    iType   : Integer;
begin
    if Sender.ClassType = TPanel then begin
        sName   := TPanel(Sender).Name;
    end else begin
        sName   := TPanel(TControl(Sender).Parent).Name;
    end;
    //
    Delete(sName,1,7);  //删除前面的'panel_t',共7个字符
    iType   := StrToIntDef(sName,0);
    //
    SetType(iType);

    //
    dwRunJS('this.$refs['''+dwFullName(ScrollBox)+'''].wrap.scrollTop ='+IntToStr(iType*7*140-5)+';',self);
end;

procedure TForm1.ScrollBoxEndDock(Sender, Target: TObject; X, Y: Integer);
begin
    //Caption := IntToStr(X);
    //
    SetType(Ceil((X+10) / (140*7))-1);
end;

procedure TForm1.SetType(AType: Integer);
var
    iType   : Integer;
    oPanel  : TPanel;
begin
    AType   := Min(AType,6);
    //
    for iType := 0 to 6 do begin
        oPanel  := TPanel(FindComponent('panel_t'+IntToStr(iType)));
        if iType = AType then begin
            oPanel.Color    := clWhite;
        end else begin
            oPanel.Color    := clBtnFace;
        end;
    end;
end;

end.
