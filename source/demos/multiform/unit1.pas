﻿unit unit1;

interface

uses
    dwSGUnit,      //StringGrid控制单元
    Unit2,
    Unit3,
    Unit4,
    //
    dwBase,

    //
    Winapi.Windows, Winapi.Messages, Vcl.Forms, Vcl.Controls, Vcl.StdCtrls, System.Classes,
    DateUtils,SysUtils,Vcl.ExtCtrls, Vcl.Grids, Vcl.ComCtrls, Vcl.Imaging.pngimage,
  VclTee.TeeGDIPlus, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart, VCLTee.Series, Data.DB,
  Data.Win.ADODB, Vcl.DBGrids, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
  FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Comp.Client, FireDAC.Phys.MSAccDef,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, FireDAC.Phys.ODBCDef, FireDAC.Phys.ODBC;

type
  TForm1 = class(TForm)
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    Panel_0_Banner: TPanel;
    Panel_Title: TPanel;
    Label_Title: TLabel;
    Image1: TImage;
    Button_Dynamic: TButton;
    Button4: TButton;
    Label1: TLabel;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDConnection1: TFDConnection;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure Button_DynamicClick(Sender: TObject);
    procedure PageControl1EndDock(Sender, Target: TObject; X, Y: Integer);
    procedure Button4Click(Sender: TObject);
  private
    { Private declarations }
  public
    Form2: TForm2;
    Form3: TForm3;
    Form4: TForm4;

    gsMainDir   : String;
    goConnection    : TADOConnection;
        function dwfShowForm(AClass: TFormClass; var AForm:TForm; AClosable: Boolean): Integer;

  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}


procedure TForm1.Button4Click(Sender: TObject);
begin
    dwShowModalPro(self,self.Form4);
end;

function TForm1.dwfShowForm(AClass: TFormClass; var AForm:TForm; AClosable: Boolean): Integer;
var
    iTab    : Integer;
    oTab    : TTabSheet;
	//
    sRights : string;       //当前权限
    iRight  : Integer;
    iItem   : Integer;
begin
    if AForm = nil then begin
        //==如果当前窗体未创建，则创建该窗体，并创建一个标签页来嵌入窗体

        //创建FORM
        AForm   := AClass.Create(self);

        //设置嵌入标识,必须
        AForm.HelpKeyword := 'embed';

        //创建一个TabSheet，以嵌入当前FORM
        oTab    := TTabSheet.Create(self);

        //设置PageControl
        oTab.PageControl    := PageControl1;

        //用窗体的HelpContext 来设置嵌入式窗体的对应TabSheet的图标，图标序号见文档
        oTab.ImageIndex     := AForm.HelpContext;

        //如果可以关闭
        if AClosable then begin
            oTab.Hint       := '{"dwattr":"closable"}';
        end;

        //显示
        PageControl1.ActivePage := oTab;
        oTab.TabVisible     := True;

        //生成oTab的Name,必须!!！
        for iTab := 1 to PageControl1.PageCount do begin
            if FindComponent('TabSheet'+IntToStr(iTab)) = nil then begin
                oTab.Name   := 'TabSheet'+IntToStr(iTab);
                break;
            end;
        end;


        //嵌入到TabSheet中
        AForm.Width     := oTab.Width;
        AForm.Height    := oTab.Height;
        AForm.Parent    := oTab;


        //显示
        AForm.Show;

        //Caption 来设置嵌入式窗体的对应TabSheet的Caption
        oTab.Caption        := AForm.Caption;


        //控制界面刷新（新增/删除控件后需要）
        DockSite    := True;
    end else begin
        //==如果当前窗体已创建，则切换到该窗体对应的标签页

        for iTab := 0 to PageControl1.PageCount-1 do begin
            if (PageControl1.Pages[iTab].Caption = AForm.Caption) and (PageControl1.Pages[iTab].ImageIndex = AForm.HelpContext) then begin
                PageControl1.ActivePageIndex        := iTab;
                PageControl1.Pages[iTab].TabVisible := True;
                break;
            end;
        end;
    end;

    //如果有进度条， 关闭载入中进度条
    dwRunJS('this.dwloading=false;',self);
end;

procedure TForm1.Button_DynamicClick(Sender: TObject);
begin
    dwfShowForm(TForm3,TForm(Form3),True);
    Exit;

    //----------Form1----------------------------------------------------------------------------
    if Form3 = nil then begin
        //创建FORM
        Form3   := TForm3.Create(self);
        //嵌入到TabSheet中
        Form3.Parent  := self.TabSheet3;
        //设置嵌入标识,必须
        Form3.HelpKeyword := 'embed';
        //self.Form3.ADOQuery2.Connection := goConnection;
        Form3.Show;
        //
        Form3.Width        := self.PageControl1.Pages[0].Width;
        Form3.Height       := self.PageControl1.Pages[0].Height-10;
        //self.Form3.ADOQuery2.SQL.Text  := 'SELECT * FROM dw_member';
        //self.Form3.ADOQuery2.Open;
    end;

    //
    self.PageControl1.Pages[2].TabVisible  := True;
    self.PageControl1.ActivePageIndex  := 2;

    //
    DockSite  := True;

end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
var
    iW,iH   : Integer;
begin
    dwSetPCMode(self);
    //
    iW  := self.PageControl1.Pages[0].Width;
    iH  := self.PageControl1.Pages[0].Height-10;
    //
    //
    self.Form2.Width        := iW;
    self.Form2.Height       := iH;
    //
    if Self.Form3 <> nil then begin
        self.Form3.Width        := iW;
        self.Form3.Height       := iH;
    end;



end;

procedure TForm1.PageControl1EndDock(Sender, Target: TObject; X, Y: Integer);
begin
    if X = 0 then begin
        PageControl1.Pages[Y].TabVisible    := False;
    end;
end;

end.
