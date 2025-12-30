unit unit1;

interface

uses
    dwBase,
    gLogin,         //通用登录程序单元
    //
    Unit_CarNo,     //车牌输入
    Unit_Embed,     //嵌入式窗体，显示时嵌入在Form1中
    Unit_Embed2,    //另一个嵌入式窗体，显示时嵌入在Form1中，主要用于演示一个子Form调用另一个子Form
    Unit_Modal,     //弹出式窗体，显示时弹出在Form1之上，类似ShowModal
    Unit_Phone,     //拨打电话
    Unit_qrcode,    //扫一扫
    Unit_QuickCard, //移动端crud
    Unit_wechatqr,

    //
    SynCommons,
    CloneComponents,

    Rtti,
    Math,
    Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Vcl.ExtCtrls,
    Vcl.StdCtrls, Vcl.Grids, Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient, IdHTTP,
    Vcl.WinXPanels, Vcl.Menus, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf,
  FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait, Data.DB,
  FireDAC.Comp.Client, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt, FireDAC.Comp.DataSet;
type
    TForm1 = class(TForm)
    P1: TPanel;
    P0: TPanel;
    ImQ: TImage;
    LLogin: TLabel;
    EKeyword: TEdit;
    L00: TLabel;
    L01: TLabel;
    L02: TLabel;
    P2: TImage;
    P3: TPanel;
    FP0: TFlowPanel;
    P9: TFlowPanel;
    P90: TPanel;
    P91: TPanel;
    P92: TPanel;
    P93: TPanel;
    PUrl: TPanel;
    PForm: TPanel;
    PCard: TPanel;
    PModalForm: TPanel;
    P4: TPanel;
    L30: TLabel;
    I30: TImage;
    L31: TLabel;
    P5: TPanel;
    CP0: TCardPanel;
    Cd00: TCard;
    CP1: TCardPanel;
    Cd10: TCard;
    Cd11: TCard;
    B1: TButton;
    PModal: TPanel;
    P510: TPanel;
    P511: TPanel;
    P512: TPanel;
    P513: TPanel;
    IAvatar: TImage;
    Memo1: TMemo;
    Label1: TLabel;
    FDConnection1: TFDConnection;
    FDQuery1: TFDQuery;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure P90Click(Sender: TObject);
    procedure PUrlClick(Sender: TObject);
    procedure PFormClick(Sender: TObject);
    procedure P513Click(Sender: TObject);
    procedure FormUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
    procedure B1Click(Sender: TObject);
    procedure PCardClick(Sender: TObject);
    procedure P91Click(Sender: TObject);
    procedure PModalFormClick(Sender: TObject);
    procedure P92Click(Sender: TObject);
    procedure P93Click(Sender: TObject);
    procedure LLoginClick(Sender: TObject);
    procedure P510Click(Sender: TObject);
    procedure P511Click(Sender: TObject);
    procedure P512Click(Sender: TObject);
    procedure ImQClick(Sender: TObject);
    procedure Panel1Click(Sender: TObject);
  private
  public
        //变量---------------
        gsUserInfo      : string;
        gjoUserInfo     : Variant;
        gjoRights       : Variant;          //当前用户的权限
        gjoHistory      : Variant;          //用于标记当前待返回的记录，为JSON字符串数组类型，如["form_embed","form_embed2"]

        //子窗体-------------
        Form_CarNo      : TForm_CarNo;      //车牌输入
        Form_Embed      : TForm_Embed;      //嵌入式Form示例
        Form_Embed2     : TForm_Embed2;     //另一个嵌入式Form示例
        Form_Modal      : TForm_Modal;      //弹出式窗体示例
        Form_Phone      : TForm_Phone;      //拨打电话
        Form_qrcode     : TForm_qrcode;     //扫一扫
        Form_quickcard  : TForm_quickcard;  //移动端crud
        Form_wechatqr   : TForm_wechatqr;   //微信扫一扫

        //函数---------------
        //
        function dmSetButtonsDefault:Integer; //设置底部所有按钮的默认状态
        function dmSetButtonSelect(APanel:TPanel):Integer;
        //
        function dmShowForm(AClass: TFormClass; var AForm:TForm): Integer;
        //
        function dmShowFormModal(AClass: TFormClass; var AForm:TForm;AWidth,AHeight,ATop,ARadius:Integer): Integer;
  end;

var
    Form1   : TForm1;

implementation

{$R *.dfm}

function TForm1.dmShowForm(AClass: TFormClass; var AForm:TForm): Integer;
var
    iCard   : Integer;
    oCard   : TCard;
    iForm   : Integer;
    //
    bFound  : Boolean;
	//
    sRights : string;       //当前权限
    iRight  : Integer;
    iItem   : Integer;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
    //
    bIsNil  : Boolean;
begin
    try
        //压入一条浏览器历史记录，以响应手机返回键返回
        dwHistoryPush(self);

        //先检查当前模块是否打开，如果打开，则直接切换到当前模块
        if AForm <> nil then begin
            for iCard := 0 to CP0.CardCount-1 do begin
                oCard   := CP0.Cards[iCard];
                if (oCard.CardVisible) and (oCard.Name = 'CD_'+AClass.ClassName) then begin
                    CP0.ActiveCard      := oCard;
                    oCard.CardVisible   := True;
                    Exit;
                end;
            end;
        end;

        //限制同时打开模块数量不大于8个
        if CP0.CardCount>7 then begin
            //
            FreeAndNil(TForm(CP0.Cards[1].Controls[0]));
            //
            CP0.Cards[1].Destroy;
        end;


        //创建FORM，参数必须为Form1, 在unit1中用self， 其他子窗体中用TForm1(self.owner)
        AForm   := AClass.Create(self);

        //给当前Form赋一个较短的Name, 以减少网页重量
        for iItem := 0 to 9999 do begin
            bFound  := False;
            for iForm := 0 to Screen.FormCount - 1 do begin
                if Screen.Forms[iForm].Name = 'F_'+IntToStr(iItem) then begin
                    bFound  := True;
                    break;
                end;
            end;
            if not bFound then begin
                AForm.Name  := 'F_'+IntToStr(iItem);
                break;
            end;
        end;


        //设置嵌入标识,必须
        AForm.HelpKeyword := 'embed';

        //创建一个TabSheet，以嵌入当前FORM
        oCard   := TCard.Create(self);

        //设置PageControl
        oCard.Parent    := CP0;

        //显示
        CP0.ActiveCard      := oCard;
        oCard.CardVisible   := True;

        //生成oCard的Name,必须!!！
        for iCard := 1 to CP0.CardCount do begin
            if FindComponent('Cd'+IntToStr(iCard)) = nil then begin
                oCard.Name   := 'Cd'+IntToStr(iCard);
                break;
            end;
        end;


        //嵌入到TabSheet中
        AForm.Width     := oCard.Width;
        AForm.Height    := oCard.Height;
        AForm.Parent    := oCard;

        //<根据登录时取得的gjoRights，取得当前模块的权限
        //gjoRights : [{"caption":"入门模块","rights":[1,1,1,1,1,1,1,1,1,1]},...,{"caption":"角色权限","rights":[1,1,1,1,1,1,1,1,1,1]}]
        //取得权限
        if gjoRights = unassigned then begin
            gjoRights   := _Json('[]');
        end;
        sRights := '';

        for iRight := 0 to gjoRights._Count-1 do begin
            if gjoRights._(iRight)._(0) = AForm.Caption then begin
                sRights := VariantSaveJSON(gjoRights._(iRight));
                break;
            end;
        end;
        //>

        //<将当前模块的权限赋于AForm的gsRights属性
        if sRights <> '' then begin;
            t   := ctx.GetType(AClass);
            for f in t.GetFields do begin
                if f.Name = 'gsRights' then begin
                    f.SetValue(AForm,sRights);
                    break;
                end;
            end;
        end;
        //>

        //显示
        AForm.Show;

        //Caption 来设置嵌入式窗体的对应TabSheet的Caption
        oCard.Caption   := AForm.ClassName;


        //控制界面刷新（新增/删除控件后需要）
        DockSite    := True;
    except
    end;
end;



function TForm1.dmShowFormModal(AClass: TFormClass; var AForm: TForm;AWidth,AHeight,ATop,ARadius:Integer): Integer;
var
    iForm   : Integer;
    //
    bFound  : Boolean;
	//
    sRights : string;       //当前权限
    iRight  : Integer;
    iItem   : Integer;
    //
    ctx     : TRttiContext;
    t       : TRttiType;
    f       : TRttiField;
begin
    try
        //压入一条浏览器历史记录，以响应手机返回键返回
        dwHistoryPush(self);

        //先检查当前模块是否打开，如果打开，则直接切换到当前模块
        if AForm <> nil then begin
            if (PModal.Caption = AClass.ClassName) then begin
                PModal.Visible  := True;
                Exit;
            end;
        end;

        //先释放以前可能存在的弹出式窗体
        if PModal.ControlCount > 0 then begin
            //
            FreeAndNil(TForm(PModal.Controls[0]));
        end;

        //创建FORM，参数必须为Form1, 在unit1中用self， 其他子窗体中用TForm1(self.owner)
        AForm   := AClass.Create(self);

        //给当前Form赋一个较短的Name, 以减少网页重量
        for iItem := 0 to 9999 do begin
            bFound  := False;
            for iForm := 0 to Screen.FormCount - 1 do begin
                if Screen.Forms[iForm].Name = 'F_'+IntToStr(iItem) then begin
                    bFound  := True;
                    break;
                end;
            end;
            if not bFound then begin
                AForm.Name  := 'F_'+IntToStr(iItem);
                break;
            end;
        end;


        //设置嵌入标识,必须
        AForm.HelpKeyword := 'embed';

        //嵌入到TabSheet中
        AForm.Width     := Max(300,Min(AWidth,Width));
        AForm.Height    := Max(100,Min(AHeight,Height));
        AForm.Parent    := PModal;
        AForm.Left      := 0;
        AForm.Top       := 0;
        //
        PModal.Width    := AForm.Width;
        PModal.Height   := AForm.Height;
        PModal.Top      := ATop;
        PModal.Hint     := '{"radius":"10px","dwstyle":"box-shadow: rgba(60, 64, 67, 0.3) 0px 1px 2px 0px, rgba(60, 64, 67, 0.15) 0px 2px 6px 2px;"}';

        //<根据登录时取得的gjoRights，取得当前模块的权限
        //gjoRights : [{"caption":"入门模块","rights":[1,1,1,1,1,1,1,1,1,1]},...,{"caption":"角色权限","rights":[1,1,1,1,1,1,1,1,1,1]}]
        //取得权限
        if gjoRights = unassigned then begin
            gjoRights   := _Json('[]');
        end;
        sRights := '';

        for iRight := 0 to gjoRights._Count-1 do begin
            if gjoRights._(iRight)._(0) = AForm.Caption then begin
                sRights := VariantSaveJSON(gjoRights._(iRight));
                break;
            end;
        end;
        //>

        //<将当前模块的权限赋于AForm的gsRights属性
        if sRights <> '' then begin;
            t   := ctx.GetType(AClass);
            for f in t.GetFields do begin
                if f.Name = 'gsRights' then begin
                    f.SetValue(AForm,sRights);
                    break;
                end;
            end;
        end;
        //>

        //显示
        AForm.Show;

        //Caption 来设置嵌入式窗体的ClassName
        PModal.Caption  := AForm.ClassName;

        //
        PModal.Visible  := True;

        //控制界面刷新（新增/删除控件后需要）
        DockSite    := True;
    except
    end;
end;

procedure TForm1.B1Click(Sender: TObject);
begin
    //通过浏览器发送一个返回消息（需要前面显示该模块/界面时使用dwHistoryPush）
    dwhistoryBack(self);
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
    //设置当前显示模式为移动端模式，默认分辨率为400x900
    dwSetMobileMode(Self,400,900);

    //设置L02（标签"128笔" ）的左右边距，以更好显示
    L02.Margins.Left    := (Width - 80) div 2;
    L02.Margins.Right   := L02.Margins.Left;
end;

procedure TForm1.FormShow(Sender: TObject);
var
    iItem   : Integer;
    oPanel  : TPanel;
begin
    //自动设置图标（根据当前Panel.tag，在media/images/48中）
    for iItem := 0 to FP0.ControlCount - 1 do begin
        oPanel  := TPanel(FP0.Controls[iItem]);
        opanel.Hint := '{"src":"media/images/48/m ('+IntToStr(oPanel.Tag)+').png"}';
    end;

    //自动设置图标
    for iItem := 0 to P9.ControlCount - 1 do begin
        oPanel  := TPanel(P9.Controls[iItem]);
        if iItem = 0 then begin
            opanel.Hint := '{"src":"media/images/dwMobile/b'+IntToStr(iItem)+'b.png"}';
        end else begin
            opanel.Hint := '{"src":"media/images/dwMobile/b'+IntToStr(iItem)+'.png"}';
        end;
    end;

    //创建对应浏览器历史记录的变量
    gjoHistory  := _json('[]');

    //默认到第一card界面
    CP0.ActiveCardIndex := 0;
    CP1.ActiveCardIndex := 0;

    //
    gsUserInfo  := glCheckLoginInfo('dwMobile',FDConnection1);
    //
    if gsUserInfo <> '' then begin
        gjoUserInfo := _Json(gsUserInfo);
        FDQuery1.Close;
        FDQuery1.Open('SELECT * FROM dmUser WHERE uId='+String(gjoUserInfo.id));
        LLogin.Visible  := False;
        IAvatar.Visible := True;
        IAvatar.Hint    := '{"src":"media/images/mm/'+FDQuery1.FieldByName('uPhoto').AsString+'",'
                +'"radius":"50%",'
                +'"dwstyle":"border:solid 1px #bbb;"'
                +'}';
    end;
end;

procedure TForm1.FormUnDock(Sender: TObject; Client: TControl; NewTarget: TWinControl; var Allow: Boolean);
var
    oCard   : TCard;
    oCP     : TCardPanel;
    iCard   : Integer;
begin
    //=====当浏览器有历史记录时， 响应返回事件

    //
    if gjoHistory._Count = 0 then begin
        Exit;
    end;


    //关闭 切换的界面
    if gjoHistory._(gjoHistory._Count-1) = 'changeview' then begin

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP1.ActiveCardIndex := 0;

        //
        Exit;
    end;

    //关闭打开的Form
    if gjoHistory._(gjoHistory._Count-1) = 'showform_carno' then begin
        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP0.ActiveCardIndex := 0;

        //
        Exit;
    end;

    //关闭打开的Form
    if gjoHistory._(gjoHistory._Count-1) = 'showform_embed' then begin
        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP0.ActiveCardIndex := 0;

        //
        Exit;
    end;


    //关闭打开的form_embed2， 返回到form_embed所在的界面，也就是显示form_embed所有的card
    if gjoHistory._(gjoHistory._Count-1) = 'showform_embed2' then begin
        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        for iCard := CP0.CardCount - 1 downto 1 do begin
            oCard   := CP0.Cards[iCard];

            //
            if LowerCase(oCard.Caption) = 'tform_embed' then begin
                CP0.ActiveCardIndex := iCard;
                Break;
            end;
        end;

        //
        Exit;
    end;


    //关闭 切换的界面
    if gjoHistory._(gjoHistory._Count-1) = 'showform_modal' then begin

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        PModal.Visible  := False;

        //
        Exit;
    end;


    //关闭 弹出式窗体 ,返回到form_embed所在的界面，也就是显示form_embed所有的card
    if gjoHistory._(gjoHistory._Count-1) = 'showform_modal2' then begin

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        PModal.Visible  := False;

        //
        Exit;
    end;


    //关闭打开的Form
    if gjoHistory._(gjoHistory._Count-1) = 'showform_phone' then begin

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP0.ActiveCardIndex := 0;

        //
        Exit;
    end;


    //关闭打开的Form
    if gjoHistory._(gjoHistory._Count-1) = 'showform_qrcode' then begin
        //
        TForm_qrcode(CP0.ActiveCard.Controls[0]).Button_Stop.OnClick(Self);

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP0.ActiveCardIndex := 0;

        //
        Exit;
    end;


    //关闭打开的Form
    if gjoHistory._(gjoHistory._Count-1) = 'showform_quickcard' then begin

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP0.ActiveCardIndex := 0;

        //
        Exit;
    end;

    //关闭打开的Form
    if gjoHistory._(gjoHistory._Count-1) = 'showform_wechatqr' then begin

        //删除最后一条历史记录
        gjoHistory.delete(gjoHistory._Count-1);

        //
        CP0.ActiveCardIndex := 0;

        //
        Exit;
    end;
end;

procedure TForm1.ImQClick(Sender: TObject);
begin
    //
end;

procedure TForm1.LLoginClick(Sender: TObject);
begin
    //在当前页面打开通用登录程序gLogin
    dwOpenUrl(Self,'gLogin?dwMobile','_self');
end;

procedure TForm1.P90Click(Sender: TObject);
begin
    //设置所有底部按钮默认状态
    dmSetButtonsDefault;
    //设置当前按钮为选中状态
    dmSetButtonSelect(TPanel(Sender));
    //切换到第一card
    CP0.ActiveCardIndex := 0;
    //界机切换到第一card
    CP1.ActiveCardIndex := 0;

end;

procedure TForm1.P91Click(Sender: TObject);
begin
    //设置所有底部按钮默认状态
    dmSetButtonsDefault;
    //设置当前按钮为选中状态
    dmSetButtonSelect(TPanel(Sender));
    //
    CP1.ActiveCardIndex := 1;

end;

procedure TForm1.P92Click(Sender: TObject);
begin
    //设置所有底部按钮默认状态
    dmSetButtonsDefault;
    //设置当前按钮为选中状态
    dmSetButtonSelect(TPanel(Sender));

end;

procedure TForm1.P93Click(Sender: TObject);
begin
    //设置所有底部按钮默认状态
    dmSetButtonsDefault;
    //设置当前按钮为选中状态
    dmSetButtonSelect(TPanel(Sender));

end;

procedure TForm1.Panel1Click(Sender: TObject);
begin
    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_phone');

    //打开
    dmShowForm(TForm_Phone,TForm(Form_Phone));

end;

procedure TForm1.PUrlClick(Sender: TObject);
begin
    //通过网址调用另一个deweb应用

    //写cookie,用于应用间数据传递
    dwSetCookie(Self,'mytest','DeWeb:delphiweb',72);

    //打开另一个应用
    dwOpenURL(Self,'M00?name=westwind','_self');
end;

procedure TForm1.PFormClick(Sender: TObject);
begin
    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_embed');

    //打开
    dmShowForm(TForm_Embed,TForm(Form_Embed));
end;

procedure TForm1.PCardClick(Sender: TObject);
begin
    //压入一条浏览器历史记录，以响应手机返回键返回
    dwHistoryPush(self);

    //为浏览器记录变量添加一条记录
    gjoHistory.Add('changeview');

    //
    CP1.ActiveCardIndex := 1;

    //
    //设置所有底部按钮默认状态
    dmSetButtonsDefault;

    //设置当前按钮为选中状态
    dmSetButtonSelect(P91);
end;

procedure TForm1.PModalFormClick(Sender: TObject);
begin

    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_modal');

    //
    dmShowFormModal(TForm_Modal,TForm(Form_Modal),320,500,100,10);
end;

procedure TForm1.P510Click(Sender: TObject);
begin

    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_qrcode');

    //打开扫一扫Form
    dmShowForm(TForm_qrcode,TForm(Form_qrcode));
end;

procedure TForm1.P511Click(Sender: TObject);
begin

    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_wechatqr');

    //打开"微信扫一扫"Form
    dmShowForm(TForm_wechatqr,TForm(Form_wechatqr));

end;

procedure TForm1.P512Click(Sender: TObject);
begin
    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_quickcard');

    //打开
    dmShowForm(TForm_quickcard,TForm(Form_QuickCard));

end;

procedure TForm1.P513Click(Sender: TObject);
begin

    //为浏览器记录变量添加一条记录
    gjoHistory.Add('showform_carno');

    //打开"车牌输入"Form
    dmShowForm(TForm_CarNo,TForm(Form_CarNo));
end;

function TForm1.dmSetButtonsDefault: Integer;  //设置底部所有按钮的默认状态
var
    iItem       : Integer;
    oPanel      : TPanel;
begin
    //====该函数的功能是把底部工具栏中所有按钮的图标都设置为默认状态，即未选中状态

    for iItem := 0 to 3 do begin
        //取得当前控件
        oPanel              := TPanel(FindComponent('P9'+IntToStr(iItem)));
        //设置当前字体颜色
        oPanel.Font.Color   := self.Font.Color;
        //设置图标
        oPanel.Hint         := '{"src":"media/images/dwMobile/b'+IntToStr(iItem)+'.png"}'
    end;
end;

function TForm1.dmSetButtonSelect(APanel: TPanel): Integer;
var
    sItem       : String;
begin
    //====该函数的功能是把底部工具栏中当前按钮的图标都选中状态

    //根据名称取得序号
    sItem   := Copy(APanel.Name,3,1);
    //设置当前字体颜色
    APanel.Font.Color   := $0060C107;
    //设置图标
    APanel.Hint         := '{"src":"media/images/dwMobile/b'+sItem+'b.png"}';
end;


end.
