unit unit_sys_QuickBtn;

interface

uses
    dwBase,
    dwfBase,
    SynCommons,
    //
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
    FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
    FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async,
    FireDAC.Phys, FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS,
    FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSSQLDef,
    FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL, FireDAC.Phys.MSSQL,
    FireDAC.Phys.ODBCBase, FireDAC.Phys.MSAcc, Data.DB, FireDAC.Comp.DataSet,
    FireDAC.Comp.Client, Vcl.Samples.Spin;

type
  TForm_sys_QuickBtn = class(TForm)
    FDQuery1: TFDQuery;
    FP: TFlowPanel;
    P0: TPanel;
    P00: TPanel;
    C0: TComboBox;
    L00: TLabel;
    L01: TLabel;
    P1: TPanel;
    L10: TLabel;
    L11: TLabel;
    P10: TPanel;
    C1: TComboBox;
    P2: TPanel;
    L20: TLabel;
    L21: TLabel;
    P20: TPanel;
    C2: TComboBox;
    P3: TPanel;
    L30: TLabel;
    L31: TLabel;
    P30: TPanel;
    C3: TComboBox;
    P4: TPanel;
    L40: TLabel;
    L41: TLabel;
    P40: TPanel;
    C4: TComboBox;
    P5: TPanel;
    L50: TLabel;
    L51: TLabel;
    P50: TPanel;
    C5: TComboBox;
    P6: TPanel;
    L60: TLabel;
    L61: TLabel;
    P60: TPanel;
    C6: TComboBox;
    P7: TPanel;
    L70: TLabel;
    L71: TLabel;
    P70: TPanel;
    C7: TComboBox;
    S0: TSpinEdit;
    S1: TSpinEdit;
    S2: TSpinEdit;
    S3: TSpinEdit;
    S4: TSpinEdit;
    S5: TSpinEdit;
    S6: TSpinEdit;
    S7: TSpinEdit;
    PB: TPanel;
    BS: TButton;
    BC: TButton;
    procedure FormShow(Sender: TObject);
    procedure C0Change(Sender: TObject);
    procedure S0Change(Sender: TObject);
    procedure BSClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
     Form_sys_QuickBtn             : TForm_sys_QuickBtn;


implementation

uses
    unit1;


{$R *.dfm}

procedure TForm_sys_QuickBtn.BSClick(Sender: TObject);
var
    joQuickBtn  : Variant;
    iItem       : Integer;
    iIndex      : Integer;
    oForm1      : TForm1;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    oPanel      : TPanel;
begin
    //===== 保存 事件

    try
        oForm1  := TForm1(self.Owner);

        //<先将当前配置保存到gjoUserInfo.quickbutton
        //清空原来的
        oForm1.gjoUserInfo.quickbutton := _json('[]');
        //添加到配置
        for iItem := 0 to 7 do begin
            //取得各控件
            oComboBox   := TComboBox(FindComponent('C'+IntToStr(iItem)));
            oSpinEdit   := TSpinEdit(FindComponent('S'+IntToStr(iItem)));
            //
            joQuickBtn  := _json('[]');
            joQuickBtn.Add(oComboBox.Text);
            joQuickBtn.Add(oSpinEdit.Value);
            //
            oForm1.gjoUserInfo.quickbutton.Add(joQuickBtn);
        end;
        //>

        //<保存到数据表
        //查看用户表数据 ，保存gjoUserInfo.rolename
        FDQuery1.Close;
        FDQuery1.SQL.Text   := 'UPDATE sys_User'
                +' SET uQuickButton='''+VariantSaveJson(oForm1.gjoUserInfo.quickbutton)+''''
                +' WHERE uId = '+oForm1.gjoUserInfo.id;
        FDQuery1.ExecSQL;
        //>

        //<更新首页快捷按钮
        for iItem := 0 to 7 do begin
            //找到当前panel
            oPanel          := TPanel(oForm1.Form_sys_Home.FindComponent('PnM'+IntToStr(iItem)));
            if  oForm1.gjoUserInfo.quickbutton._Count > iItem then begin
                //设置标题
                oPanel.Caption  := oForm1.gjoUserInfo.quickbutton._(iItem)._(0);
                //设置图标
                iIndex          := oForm1.gjoUserInfo.quickbutton._(iItem)._(1);
                oPanel.Hint     := '{"radius":"5px","src":"media/images/32/a ('+IntToStr(iIndex)+').png","dwstyle":"border:solid 1px #eee;"}';
            end else begin
                //设置标题
                oPanel.Caption  := '';
                //设置图标
                iIndex          := iItem+1;
                oPanel.Hint     := '{"radius":"5px","src":"media/images/32/a ('+IntToStr(iIndex)+').png","dwstyle":"border:solid 1px #eee;"}';
            end;
            //如果标题为空, 则不可见
            oPanel.Visible  := oPanel.Caption <> '';
        end;
        //>

        //
        dwMessage('保存成功！','',self);
    except

    end;

end;

procedure TForm_sys_QuickBtn.C0Change(Sender: TObject);
var
    iItem   : Integer;
begin
    //
    iItem   := StrToIntDef(Copy(TComboBox(Sender).Name,2,1),-1);
    if iItem > -1 then begin
        TPanel(FindComponent('P'+IntToStr(iItem)+'0')).Caption  := TComboBox(Sender).Text;
    end;
end;

procedure TForm_sys_QuickBtn.FormShow(Sender: TObject);
var
    iItem       : Integer;
    slMenu      : TStringList;
    oPanel      : TPanel;
    oComboBox   : TComboBox;
    oSpinEdit   : TSpinEdit;
    //
    iDebug      : Integer;
begin
    try
        //异常监测标识
        iDebug  := 0;

        //取得菜单项所有叶节点
        dwfGetMenuLeafs(TForm1(self.Owner).MainMenu1,slMenu);

        //异常监测标识
        iDebug  := 1;

        //更新快捷按钮
        for iItem := 0 to 7 do begin
            //异常监测标识
            iDebug  := 2 + iItem;

            //取得各控件
            oComboBox   := TComboBox(FindComponent('C'+IntToStr(iItem)));
            oSpinEdit   := TSpinEdit(FindComponent('S'+IntToStr(iItem)));
            oPanel      := TPanel(FindComponent('P'+IntToStr(iItem)+'0'));

            //
            with TForm1(self.Owner) do begin
                if gjoUserInfo.quickbutton._Count > iItem then begin
                    oPanel.Caption  := gjoUserInfo.quickbutton._(iItem)._(0);
                    oPanel.Hint     := '{"radius":"5px","src":"media/images/32/a ('+IntToStr(gjoUserInfo.quickbutton._(iItem)._(1))+').png","dwstyle":"border:solid 1px #eee;"}';
                    oComboBox.Items.Clear;
                    oComboBox.Items.Add('');
                    oComboBox.Items.AddStrings(slMenu);
                    oComboBox.Text      := oPanel.Caption;
                    oSpinEdit.Value     := gjoUserInfo.quickbutton._(iItem)._(1);
                end else begin
                    oPanel.Caption  := '';
                    oPanel.Hint     := '{"radius":"5px","src":"media/images/32/a ('+IntToStr(iItem+1)+').png","dwstyle":"border:solid 1px #eee;"}';
                    oComboBox.Items.Clear;
                    oComboBox.Items.Add('');
                    oComboBox.Items.AddStrings(slMenu);
                    oComboBox.Text      := oPanel.Caption;
                    oSpinEdit.Value     := iItem+1;
                end;
            end;
        end;
    except
        dwRunJS('console.log("error when TForm_QuickBtn.FormShow" at '+IntToStr(iDebug)+');',TForm1(self.Owner));
    end;
end;

procedure TForm_sys_QuickBtn.S0Change(Sender: TObject);
var
    iItem   : Integer;
begin
    //
    iItem   := StrToIntDef(Copy(TSpinEdit(Sender).Name,2,1),-1);
    if iItem > -1 then begin
        TPanel(FindComponent('P'+IntToStr(iItem)+'0')).Hint  :=
                '{"radius":"5px","src":"media/images/32/a ('+IntToStr(TSpinEdit(Sender).Value)+').png","dwstyle":"border:solid 1px #eee;"}';
    end;
end;

end.
