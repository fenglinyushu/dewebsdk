unit unit1;

interface

uses
    //
    dwBase,
    cnDes,
    dwAccess,

    //
    SynCommons,         //JSON解析单元
    CloneComponents,    //克隆控件的单元

    //
    HttpApp,Math,
    System.Zip,
    Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
    Vcl.Imaging.pngimage, Vcl.Buttons, Data.DB, Data.Win.ADODB, Vcl.Imaging.jpeg, System.ImageList,
  Vcl.ImgList, Vcl.FileCtrl,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf, FireDAC.Stan.Async,
  FireDAC.DApt, FireDAC.UI.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Phys.ODBCDef, FireDAC.Phys.MSAccDef, FireDAC.Phys.MSAcc,
  FireDAC.Phys.ODBCBase, FireDAC.Phys.ODBC, FireDAC.Comp.Client, FireDAC.Comp.DataSet;

type
  TForm1 = class(TForm)
    PC_Frame: TPageControl;
    TabSheet_Base: TTabSheet;
    TS_Module: TTabSheet;
    TS_Create: TTabSheet;
    P_Banner: TPanel;
    Label9: TLabel;
    Panel_Title: TPanel;
    Label8: TLabel;
    Panel1: TPanel;
    Label1: TLabel;
    E_SystemTitle: TEdit;
    Panel2: TPanel;
    Label2: TLabel;
    CheckBox1: TCheckBox;
    Panel3: TPanel;
    Label3: TLabel;
    RG_Expand: TRadioGroup;
    Panel4: TPanel;
    Label4: TLabel;
    Edit2: TEdit;
    TabSheet_Home: TTabSheet;
    Memo1: TMemo;
    Panel7: TPanel;
    Panel8: TPanel;
    B_AddTo: TButton;
    Panel6: TPanel;
    Label7: TLabel;
    E_Caption: TEdit;
    Panel9: TPanel;
    Label6: TLabel;
    E_Name: TEdit;
    Panel11: TPanel;
    Label11: TLabel;
    E_Memo: TEdit;
    P_Page: TPanel;
    Button_PageNext: TButton;
    ImageList_dw: TImageList;
    Button_PagePrev: TButton;
    Label12: TLabel;
    P_Selected: TPanel;
    Label13: TLabel;
    LV_Modules: TListView;
    Panel5: TPanel;
    Label5: TLabel;
    CB_View: TComboBox;
    Panel15: TPanel;
    Label15: TLabel;
    CB_Icon: TComboBox;
    B_IconDemo: TButton;
    Button1: TButton;
    FDQuery1: TFDQuery;
    FDConnection1: TFDConnection;
    FDPhysODBCDriverLink1: TFDPhysODBCDriverLink;
    FDPhysMSAccessDriverLink1: TFDPhysMSAccessDriverLink;
    B_Replace: TButton;
    P_Modules: TPanel;
    Label10: TLabel;
    LV_Source: TListView;
    FB_Modules: TFileListBox;
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure B_AddToClick(Sender: TObject);
    procedure Button_PagePrevClick(Sender: TObject);
    procedure Button_PageNextClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure CB_IconChange(Sender: TObject);
    procedure CB_ModulesChange(Sender: TObject);
    procedure B_ReplaceClick(Sender: TObject);
    procedure LV_ModulesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
    procedure Button1Click(Sender: TObject);
    procedure LV_SourceChange(Sender: TObject; Item: TListItem; Change: TItemChange);
  private
  public
        gsMainDir   : string;   //服务器目录
        gsCanvasId  : String;   //用户的浏览器id
        gsOutputDir : string;   //用户输出目录
        //
        gjoSource   : variant;  //待选源功能模块
        gjoSystem   : variant;  //已选功能模块

        //
        function GetSource:Variant;                 //取得源模块
        function GetModule(AItem:Integer):Variant;  //取第Aitem模块的JSON对象
        function GetIconIndex(AText:String):Integer;
const
     dwIcons : array[1..280] of string = (
          'el-icon-platform-eleme'
          ,'el-icon-eleme'
          ,'el-icon-delete-solid'
          ,'el-icon-delete'
          ,'el-icon-s-tools'
          ,'el-icon-setting'
          ,'el-icon-user-solid'
          ,'el-icon-user'
          ,'el-icon-phone'
          ,'el-icon-phone-outline'
          ,'el-icon-more'
          ,'el-icon-more-outline'
          ,'el-icon-star-on'
          ,'el-icon-star-off'
          ,'el-icon-s-goods'
          ,'el-icon-goods'
          ,'el-icon-warning'
          ,'el-icon-warning-outline'
          ,'el-icon-question'
          ,'el-icon-info'
          ,'el-icon-remove'
          ,'el-icon-circle-plus'
          ,'el-icon-success'
          ,'el-icon-error'
          ,'el-icon-zoom-in'
          ,'el-icon-zoom-out'
          ,'el-icon-remove-outline'
          ,'el-icon-circle-plus-outline'
          ,'el-icon-circle-check'
          ,'el-icon-circle-close'
          ,'el-icon-s-help'
          ,'el-icon-help'
          ,'el-icon-minus'
          ,'el-icon-plus'
          ,'el-icon-check'
          ,'el-icon-close'
          ,'el-icon-picture'
          ,'el-icon-picture-outline'
          ,'el-icon-picture-outline-round'
          ,'el-icon-upload'
          ,'el-icon-upload2'
          ,'el-icon-download'
          ,'el-icon-camera-solid'
          ,'el-icon-camera'
          ,'el-icon-video-camera-solid'
          ,'el-icon-video-camera'
          ,'el-icon-message-solid'
          ,'el-icon-bell'
          ,'el-icon-s-cooperation'
          ,'el-icon-s-order'
          ,'el-icon-s-platform'
          ,'el-icon-s-fold'
          ,'el-icon-s-unfold'
          ,'el-icon-s-operation'
          ,'el-icon-s-promotion'
          ,'el-icon-s-home'
          ,'el-icon-s-release'
          ,'el-icon-s-ticket'
          ,'el-icon-s-management'
          ,'el-icon-s-open'
          ,'el-icon-s-shop'
          ,'el-icon-s-marketing'
          ,'el-icon-s-flag'
          ,'el-icon-s-comment'
          ,'el-icon-s-finance'
          ,'el-icon-s-claim'
          ,'el-icon-s-custom'
          ,'el-icon-s-opportunity'
          ,'el-icon-s-data'
          ,'el-icon-s-check'
          ,'el-icon-s-grid'
          ,'el-icon-menu'
          ,'el-icon-share'
          ,'el-icon-d-caret'
          ,'el-icon-caret-left'
          ,'el-icon-caret-right'
          ,'el-icon-caret-bottom'
          ,'el-icon-caret-top'
          ,'el-icon-bottom-left'
          ,'el-icon-bottom-right'
          ,'el-icon-back'
          ,'el-icon-right'
          ,'el-icon-bottom'
          ,'el-icon-top'
          ,'el-icon-top-left'
          ,'el-icon-top-right'
          ,'el-icon-arrow-left'
          ,'el-icon-arrow-right'
          ,'el-icon-arrow-down'
          ,'el-icon-arrow-up'
          ,'el-icon-d-arrow-left'
          ,'el-icon-d-arrow-right'
          ,'el-icon-video-pause'
          ,'el-icon-video-play'
          ,'el-icon-refresh'
          ,'el-icon-refresh-right'
          ,'el-icon-refresh-left'
          ,'el-icon-finished'
          ,'el-icon-sort'
          ,'el-icon-sort-up'
          ,'el-icon-sort-down'
          ,'el-icon-rank'
          ,'el-icon-loading'
          ,'el-icon-view'
          ,'el-icon-c-scale-to-original'
          ,'el-icon-date'
          ,'el-icon-edit'
          ,'el-icon-edit-outline'
          ,'el-icon-folder'
          ,'el-icon-folder-opened'
          ,'el-icon-folder-add'
          ,'el-icon-folder-remove'
          ,'el-icon-folder-delete'
          ,'el-icon-folder-checked'
          ,'el-icon-tickets'
          ,'el-icon-document-remove'
          ,'el-icon-document-delete'
          ,'el-icon-document-copy'
          ,'el-icon-document-checked'
          ,'el-icon-document'
          ,'el-icon-document-add'
          ,'el-icon-printer'
          ,'el-icon-paperclip'
          ,'el-icon-takeaway-box'
          ,'el-icon-search'
          ,'el-icon-monitor'
          ,'el-icon-attract'
          ,'el-icon-mobile'
          ,'el-icon-scissors'
          ,'el-icon-umbrella'
          ,'el-icon-headset'
          ,'el-icon-brush'
          ,'el-icon-mouse'
          ,'el-icon-coordinate'
          ,'el-icon-magic-stick'
          ,'el-icon-reading'
          ,'el-icon-data-line'
          ,'el-icon-data-board'
          ,'el-icon-pie-chart'
          ,'el-icon-data-analysis'
          ,'el-icon-collection-tag'
          ,'el-icon-film'
          ,'el-icon-suitcase'
          ,'el-icon-suitcase-1'
          ,'el-icon-receiving'
          ,'el-icon-collection'
          ,'el-icon-files'
          ,'el-icon-notebook-1'
          ,'el-icon-notebook-2'
          ,'el-icon-toilet-paper'
          ,'el-icon-office-building'
          ,'el-icon-school'
          ,'el-icon-table-lamp'
          ,'el-icon-house'
          ,'el-icon-no-smoking'
          ,'el-icon-smoking'
          ,'el-icon-shopping-cart-full'
          ,'el-icon-shopping-cart-1'
          ,'el-icon-shopping-cart-2'
          ,'el-icon-shopping-bag-1'
          ,'el-icon-shopping-bag-2'
          ,'el-icon-sold-out'
          ,'el-icon-sell'
          ,'el-icon-present'
          ,'el-icon-box'
          ,'el-icon-bank-card'
          ,'el-icon-money'
          ,'el-icon-coin'
          ,'el-icon-wallet'
          ,'el-icon-discount'
          ,'el-icon-price-tag'
          ,'el-icon-news'
          ,'el-icon-guide'
          ,'el-icon-male'
          ,'el-icon-female'
          ,'el-icon-thumb'
          ,'el-icon-cpu'
          ,'el-icon-link'
          ,'el-icon-connection'
          ,'el-icon-open'
          ,'el-icon-turn-off'
          ,'el-icon-set-up'
          ,'el-icon-chat-round'
          ,'el-icon-chat-line-round'
          ,'el-icon-chat-square'
          ,'el-icon-chat-dot-round'
          ,'el-icon-chat-dot-square'
          ,'el-icon-chat-line-square'
          ,'el-icon-message'
          ,'el-icon-postcard'
          ,'el-icon-position'
          ,'el-icon-turn-off-microphone'
          ,'el-icon-microphone'
          ,'el-icon-close-notification'
          ,'el-icon-bangzhu'
          ,'el-icon-time'
          ,'el-icon-odometer'
          ,'el-icon-crop'
          ,'el-icon-aim'
          ,'el-icon-switch-button'
          ,'el-icon-full-screen'
          ,'el-icon-copy-document'
          ,'el-icon-mic'
          ,'el-icon-stopwatch'
          ,'el-icon-medal-1'
          ,'el-icon-medal'
          ,'el-icon-trophy'
          ,'el-icon-trophy-1'
          ,'el-icon-first-aid-kit'
          ,'el-icon-discover'
          ,'el-icon-place'
          ,'el-icon-location'
          ,'el-icon-location-outline'
          ,'el-icon-location-information'
          ,'el-icon-add-location'
          ,'el-icon-delete-location'
          ,'el-icon-map-location'
          ,'el-icon-alarm-clock'
          ,'el-icon-timer'
          ,'el-icon-watch-1'
          ,'el-icon-watch'
          ,'el-icon-lock'
          ,'el-icon-unlock'
          ,'el-icon-key'
          ,'el-icon-service'
          ,'el-icon-mobile-phone'
          ,'el-icon-bicycle'
          ,'el-icon-truck'
          ,'el-icon-ship'
          ,'el-icon-basketball'
          ,'el-icon-football'
          ,'el-icon-soccer'
          ,'el-icon-baseball'
          ,'el-icon-wind-power'
          ,'el-icon-light-rain'
          ,'el-icon-lightning'
          ,'el-icon-heavy-rain'
          ,'el-icon-sunrise'
          ,'el-icon-sunrise-1'
          ,'el-icon-sunset'
          ,'el-icon-sunny'
          ,'el-icon-cloudy'
          ,'el-icon-partly-cloudy'
          ,'el-icon-cloudy-and-sunny'
          ,'el-icon-moon'
          ,'el-icon-moon-night'
          ,'el-icon-dish'
          ,'el-icon-dish-1'
          ,'el-icon-food'
          ,'el-icon-chicken'
          ,'el-icon-fork-spoon'
          ,'el-icon-knife-fork'
          ,'el-icon-burger'
          ,'el-icon-tableware'
          ,'el-icon-sugar'
          ,'el-icon-dessert'
          ,'el-icon-ice-cream'
          ,'el-icon-hot-water'
          ,'el-icon-water-cup'
          ,'el-icon-coffee-cup'
          ,'el-icon-cold-drink'
          ,'el-icon-goblet'
          ,'el-icon-goblet-full'
          ,'el-icon-goblet-square'
          ,'el-icon-goblet-square-full'
          ,'el-icon-refrigerator'
          ,'el-icon-grape'
          ,'el-icon-watermelon'
          ,'el-icon-cherry'
          ,'el-icon-apple'
          ,'el-icon-pear'
          ,'el-icon-orange'
          ,'el-icon-coffee'
          ,'el-icon-ice-tea'
          ,'el-icon-ice-drink'
          ,'el-icon-milk-tea'
          ,'el-icon-potato-strips'
          ,'el-icon-lollipop'
          ,'el-icon-ice-cream-square'
          ,'el-icon-ice-cream-round'
          );
  end;

var
     Form1          : TForm1;


implementation

{$R *.dfm}


function StrToDfmCode(sStr: string): string;     //字符串（含汉字）转dfm 字符串
var
    iOrd    : Word;
    hz  : WideString;
    i   : Integer;
    s   : string;
    bHz : Boolean;
begin
    Result  := '';
    hz      := sStr;
    bHz     := True;
    for i:= 1 to Length(hz) do begin
        iOrd    := Ord(hz[i]);
        //
        if iOrd < 256 then begin
            if bHz then begin
                Result := Result +''''+ hz[i];
            end else begin
                Result := Result + hz[i];
            end;
            bHz := False;
        end else begin
            if not bHz then begin
                Result := Result +'''';
            end;
            Result := Result +'#'+ IntToStr(iOrd);
            bHz := True;
        end;
    end;
    if not bHz then begin
        Result := Result +'''';
    end;
end;


function TForm1.GetIconIndex(AText:String):Integer;
var
    iIcon   : Integer;
begin
    Result  := 1;
    for iIcon := 1 to High(dwIcons) do begin
        if dwIcons[iIcon] = AText then begin
            Result  := iIcon;
            break;
        end;
    end;
end;


procedure TForm1.B_AddToClick(Sender: TObject);
var
    joModule    : Variant;
    joSource    : Variant;
    joItem      : Variant;
    sItem       : string;
    iItem       : Integer;
begin
    //检查是否完整
    if ( Trim(E_Caption.Text) = '' ) or ( Trim(E_Name.Text) = '' ) then begin
        dwMessage('请输入“显示标题”和“单元名称”!','primary',self);
        Exit;
    end;

    //
    for iItem := 0 to  LV_Modules.Items.Count-1 do begin
        joItem  := GetModule(iItem);
        //
        if joItem = unassigned then begin
            dwmessage('第'+IntToStr(iItem)+'个模块信息有误','error',self);
            Exit;
        end;
        //
        if (E_Name.Text = joItem.name) then begin
            dwmessage('当前名称与第'+IntToStr(iItem)+'个模块名称重复，请重新输入','error',self);
            Exit;
        end;
        //
        if (E_Caption.Text = joItem.caption) then begin
            dwmessage('当前标题与第'+IntToStr(iItem)+'个模块标题重复，请重新输入','error',self);
            Exit;
        end;
    end;

    //添加到列表
    with LV_Modules.Items.Add do begin
        //取得源模块
        joSource    := gjoSource._(LV_Source.ItemIndex);

        //标题
        Caption := E_Caption.Text;

        //
        sItem   := String(joSource.name)+' , '+E_Name.Text +' , '+CB_View.Text +' , '+ CB_Icon.Text;
        Subitems.Add(sItem);
        //
        Subitems.Add(E_Memo.Text);
    end;

    //清除
    E_Caption.Text  := '';
    E_Name.Text     := '';
    E_Memo.Text     := '';
end;


procedure TForm1.B_ReplaceClick(Sender: TObject);
var
    joModule    : Variant;
    joItem      : Variant;
    iItem       : Integer;
    sModule     : string;
begin
    //检查是否完整
    if ( Trim(E_Caption.Text) = '' ) or ( Trim(E_Name.Text) = '' ) then begin
        dwMessage('请输入“显示标题”和“单元名称”!','primary',self);
        Exit;
    end;

    //如果已选模块的itemindex未选中项
    if LV_Modules.ItemIndex<0 then begin
        B_AddTo.OnClick(B_AddTo);
        Exit;
    end;

    //检查是否重复
    for iItem := 0 to  LV_Modules.Items.Count-1 do begin
        if (iItem = LV_Modules.ItemIndex) then begin
            Continue;
        end;

        //
        joItem  := GetModule(iItem);
        //
        if joItem = unassigned then begin
            dwmessage('第'+IntToStr(iItem)+'个模块信息有误','error',self);
            Exit;
        end;
        //
        if (E_Name.Text = joItem.name) then begin
            dwmessage('当前名称与第'+IntToStr(iItem)+'个模块名称重复，请重新输入','error',self);
            Exit;
        end;
        //
        if (E_Caption.Text = joItem.caption) then begin
            dwmessage('当前标题与第'+IntToStr(iItem)+'个模块标题重复，请重新输入','error',self);
            Exit;
        end;
    end;

    //添加到列表
    with LV_Modules.Items[LV_Modules.ItemIndex] do begin
        Caption := E_Caption.Text;

        //需要保留原模块名
        sModule     := Subitems[0];
        sModule     := Copy(sModule,1,Pos(' , ',sModule)-1);

        //
        Subitems[0] := Trim(sModule)+' , '+E_Name.Text +' , '+CB_View.Text +' , '+ CB_Icon.Text;
        //
        Subitems[1] := E_Memo.Text;
    end;

end;

procedure DelAllFilesInPath(path:string);     //删除目录下*.*
var
    sr  : tsearchrec;
begin
    if findfirst(path+'*.*',faanyfile,sr)=0 then begin
        deletefile(path+''+sr.name);
    end ;
    while findnext(sr)=0 do begin
        deletefile(path+''+sr.name);
    end;
    FindClose(sr);  //释放FindFirst（）时分配的内存
end;


procedure TForm1.Button1Click(Sender: TObject);
begin
    dwOpenUrl(self,'download/'+gsCanvasId+'.zip','_blank');
end;

procedure TForm1.Button_PageNextClick(Sender: TObject);
var
    iItem       : Integer;
    iRow        : Integer;
    iStart      : Integer;
    iUsesStart  : Integer;
    iPubStart   : Integer;
    iClickStart : Integer;
    //
    slCode      : TStringList;
    sText       : String;
    sModule     : string;
    sName       : string;
    sCaption    : string;
    //
    joModule    : Variant;
    joNext      : Variant;
    joItem      : Variant;
    joRole      : Variant;
begin
    //
    case PC_Frame.ActivePageIndex of
        0 : begin
            //取得用户的浏览器标识
            gsCanvasID  := dwGetProp(self,'canvasid');

            //创建输出文件夹
            ChDir(gsMainDir);
            if not DirectoryExists(gsMainDir+'modules') then begin
                MkDir('modules');
            end;
            ChDir(gsMainDir+'modules');
            if not DirectoryExists(gsMainDir+'modules\output') then begin
                MkDir('output');
            end;
            ChDir(gsMainDir+'modules\output');
            if not DirectoryExists(gsMainDir+'modules\output\'+gsCanvasID) then begin
                MkDir(gsCanvasID);
            end;
            gsOutputDir := gsMainDir+'modules\output\'+gsCanvasID+'\';

            //载入上次的配置
            if FileExists(gsOutputDir+'dwframe.json') then begin
                dwLoadFromJson(gjoSystem,gsOutputDir+'dwframe.json');

                //恢复标题和菜单设置
                E_SystemTitle.Text  := gjoSystem.title;     //标题
                RG_Expand.ItemIndex := gjoSystem.expand;    //左侧菜单是否展开

                //恢复功能设置
                LV_Modules.Items.Clear;
                for iItem := 0 to gjoSystem.modules._Count-1 do begin
                    joModule    := gjoSystem.modules._(iItem);
                    //
                    with LV_Modules.Items.Add do begin
                        Caption := joModule.caption;
                        SubItems.Add(joModule.module+' , '+joModule.name+' , '+joModule.view+' , '+joModule.icon);
                        SubItems.Add(joModule.memo);
                    end;
                    //
                    if iItem = 0 then begin
                        E_Caption.Text      := joModule.caption;
                        E_Name.Text         := joModule.name;
                        CB_View.Text        := joModule.view;
                        CB_Icon.ItemIndex   := GetIconIndex(joModule.icon);
                        E_Memo.Text         := joModule.memo;
                    end;
                end;

            end;

        end;

        1 : begin   //基本设置
            gjoSystem.title     := E_SystemTitle.Text;  //标题
            gjoSystem.expand    := RG_Expand.ItemIndex; //左侧菜单是否展开
        end;

        2 : begin   //功能
            //删除gsOutputDir目录的所有文件
            DelAllFilesInPath(gsOutputDir);

            //清空拟构建系统的模块对象
            gjoSystem.modules   := _json('[]');
            gjoSystem.menus     := _json('[]');
            gjoSystem.shorts    := _json('[]');
            for iItem := 0 to LV_Modules.Items.Count-1 do begin
                joItem  := GetModule(iItem);
                //
                gjoSystem.modules.Add(joItem);
            end;

            //保存到本地，以便下次启动时自动加载
            dwSaveToJson(gjoSystem,gsOutputDir+'dwframe.json',False);


            //复制工程文件 dwFrame files
            CopyFile(PWideChar(gsMainDir+'modules\base\dwFrame.dpr'),PWideChar(gsOutputDir+'dwFrame.dpr'),false);
            CopyFile(PWideChar(gsMainDir+'modules\base\dwFrame.res'),PWideChar(gsOutputDir+'dwFrame.res'),false);
            CopyFile(PWideChar(gsMainDir+'modules\base\dwFrame.dproj'),PWideChar(gsOutputDir+'dwFrame.dproj'),false);
            CopyFile(PWideChar(gsMainDir+'modules\base\dwFrame.dproj.local'),PWideChar(gsOutputDir+'dwFrame.dproj.local'),false);
            CopyFile(PWideChar(gsMainDir+'modules\base\dwFrame.identcache'),PWideChar(gsOutputDir+'dwFrame.identcache'),false);

            //复制主窗体文件 unit1.* files
            CopyFile(PWideChar(gsMainDir+'modules\base\unit1.pas'),PWideChar(gsOutputDir+'unit1.pas'),false);
            CopyFile(PWideChar(gsMainDir+'modules\base\unit1.dfm'),PWideChar(gsOutputDir+'unit1.dfm'),false);

            //复制首页文件 Unit_Home.* files
            CopyFile(PWideChar(gsMainDir+'modules\base\Unit_Home.pas'),PWideChar(gsOutputDir+'Unit_Home.pas'),false);
            CopyFile(PWideChar(gsMainDir+'modules\base\Unit_Home.dfm'),PWideChar(gsOutputDir+'Unit_Home.dfm'),false);

            //<处理工程文件 dwFrame.dpr ------------------------------------------------------------
            //导入文件
            slCode  := TStringList.Create;
            slCode.LoadFromFile(gsOutputDir+'dwFrame.dpr', TEncoding.UTF8);
            //找到{__uses__}标志位置，以uses已选中的模块
            for iRow := 0 to slCode.Count-1 do begin
                if Trim(slCode[iRow])  = '{__uses__}' then begin
                    iStart  := iRow;
                    break;
                end;
            end;
            //添加已选中的模块
            Inc(iStart);
            for iItem := 0 to gjoSystem.modules._Count-1 do begin
                joModule    := gjoSystem.modules._(iItem);

                //如果当前为一级菜单，而下一项为二级菜单，则跳过
                if iItem < gjoSystem.modules._Count-1 then begin
                    joNext  := gjoSystem.modules._(iItem+1);
                    if (Pos('一级菜单',joModule.view) > 0) and (Pos('二级菜单',joNext.view) > 0) then begin
                        Continue;
                    end;
                end;

                slCode.Insert(iStart,'  unit_'+joModule.name +' in ''unit_'+joModule.name+'.pas'' {Form_'+joModule.name+'},');     Inc(iStart);
            end;
            //保存到 dwFrame.dpr
            slCode.SaveToFile(gsOutputDir+'dwFrame.dpr', TEncoding.UTF8);
            //释放
            slCode.Destroy;
            //>


            //<处理主窗体dfm文件 unit1.dfm ---------------------------------------------------------
            //导入文件
            slCode  := TStringList.Create;
            slCode.LoadFromFile(gsOutputDir+'unit1.dfm', TEncoding.UTF8);
            //找到 'Items = <>' 标识 位置，以添加菜单项
            for iRow := 0 to slCode.Count-1 do begin
                if Trim(slCode[iRow])  = 'Items = <>' then begin
                    iStart  := iRow;
                    break;
                end;
            end;
            //
            slCode.Delete(iStart);
            slCode.Insert(iStart,'    Items = <');      Inc(iStart);
            //<添加首页菜单项
            slCode.Insert(iStart,'        item');       Inc(iStart);
            slCode.Insert(iStart,'          caption = '+StrToDfmCode('首页'));  Inc(iStart);
            slCode.Insert(iStart,'          imageindex = 56');  Inc(iStart);
            slCode.Insert(iStart,'        end');       Inc(iStart);
            //>
            //添加其他菜单项
            for iItem := 0 to gjoSystem.modules._Count-1 do begin
                joModule    := gjoSystem.modules._(iItem);
                //
                if (joModule.view = '一级菜单项+首页') or (joModule.view = '一级菜单项') then begin
                    slCode.Insert(iStart,'        item');       Inc(iStart);
                    slCode.Insert(iStart,'          caption = '+StrToDfmCode(joModule.caption));  Inc(iStart);
                end else if (joModule.view = '二级菜单项+首页') or (joModule.view = '二级菜单项') then begin
                    slCode.Insert(iStart,'        item');       Inc(iStart);
                    slCode.Insert(iStart,'          caption = '+StrToDfmCode('+'+joModule.caption));  Inc(iStart);
                end else begin
                    continue;
                end;
                //
                slCode.Insert(iStart,'          imageindex = '+IntToStr(GetIconIndex(joModule.icon)));  Inc(iStart);
                if iItem < gjoSystem.modules._Count-1 then begin
                    slCode.Insert(iStart,'        end');       Inc(iStart);
                end else begin
                    slCode.Insert(iStart,'        end>');       Inc(iStart);
                end;
            end;
            //替换一些标志信息
            sText   := slCode.Text;
            sText   := StringReplace(sText,'[*caption*]',gjoSystem.title,[rfReplaceAll]);
            sText   := StringReplace(sText,'[*title*]',gjoSystem.title,[rfReplaceAll]);
            sText   := StringReplace(sText,'[*menu_start*]','',[rfReplaceAll]);
            sText   := StringReplace(sText,'[*menu_end*]','',[rfReplaceAll]);
            slCode.Text := sText;
            //保存，并释放
            slCode.SaveToFile(gsOutputDir+'unit1.dfm', TEncoding.UTF8);
            slCode.Destroy;
            //>


            //<处理主窗体pas文件 unit1.pas ---------------------------------------------------------
            //导入
            slCode  := TStringList.Create;
            slCode.LoadFromFile(gsOutputDir+'unit1.pas', TEncoding.UTF8);
            //找到关键标识位置
            for iRow := 0 to slCode.Count-1 do begin
                if Trim(slCode[iRow])  = '//[*uses_start*]' then begin
                    iUsesStart  := iRow;
                end;
                if Trim(slCode[iRow])  = '//[*public_start*]' then begin
                    iPubStart   := iRow;
                end;
                if Trim(slCode[iRow])  = '//[*menuitemclick_start*]' then begin
                    iClickStart := iRow;
                    break;
                end;
            end;

            //<添加首页菜单项
            slCode.Insert(iClickStart,'    if Index = 0 then begin');  Inc(iClickStart);
            slCode.Insert(iClickStart,'        dwfShowForm(TForm_Home,TForm(Form_Home),True);');  Inc(iClickStart);
            slCode.Insert(iClickStart,'        Exit;');  Inc(iClickStart);
            slCode.Insert(iClickStart,'    end;');  Inc(iClickStart);
            //>

            //添加其他菜单项
            for iItem := 0 to gjoSystem.modules._Count-1 do begin
                joModule    := gjoSystem.modules._(iItem);

                //如果当前为一级菜单，而下一项为二级菜单，则跳过
                if iItem < gjoSystem.modules._Count-1 then begin
                    joNext  := gjoSystem.modules._(iItem+1);
                    if (Pos('一级菜单',joModule.view) > 0) and (Pos('二级菜单',joNext.view) > 0) then begin
                        Continue;
                    end;
                end;

                //uses引用文件
                slCode.Insert(iUsesStart,'    unit_'+joModule.name+',');  Inc(iUsesStart); Inc(iPubStart); Inc(iClickStart);

                //窗体声明
                slCode.Insert(iPubStart,'    Form_'+joModule.name+' : TForm_'+joModule.name+';');  Inc(iPubStart); Inc(iClickStart);

                //窗体声明
                slCode.Insert(iClickStart,'    if sCaption = '''+joModule.caption+''' then begin');  Inc(iClickStart);
                slCode.Insert(iClickStart,'        '+Format('dwfShowForm(TForm_%s,TForm(Form_%s),True);',[joModule.Name,joModule.Name]));  Inc(iClickStart);
                slCode.Insert(iClickStart,'        Exit;');  Inc(iClickStart);
                slCode.Insert(iClickStart,'    end;');  Inc(iClickStart);
            end;
            //替换信息
            sText   := slCode.Text;
            sText   := StringReplace(sText,'//[*uses_start*]','',[rfReplaceAll]);
            sText   := StringReplace(sText,'//[*public_start*]','',[rfReplaceAll]);
            sText   := StringReplace(sText,'//[*menuitemclick_start*]','',[rfReplaceAll]);
            //菜单合拢/展开
            if gjoSystem.expand = 0 then begin
                sText   := StringReplace(sText,'dwfSetMenuExpand(True);','dwfSetMenuExpand(False);',[rfReplaceAll]);
            end;
            //保存，并释放
            slCode.Text := sText;
            slCode.SaveToFile(gsOutputDir+'unit1.pas', TEncoding.UTF8);
            slCode.Destroy;
            //>

            //复制各模块
            for iItem := 0 to gjoSystem.modules._Count-1 do begin
                //取得模块对象
                joModule    := gjoSystem.modules._(iItem);

                //如果当前为一级菜单，而下一项为二级菜单，则跳过
                if iItem < gjoSystem.modules._Count-1 then begin
                    joNext  := gjoSystem.modules._(iItem+1);
                    if (Pos('一级菜单',joModule.view) > 0) and (Pos('二级菜单',joNext.view) > 0) then begin
                        Continue;
                    end;
                end;

                //
                sModule     := joModule.module;     //模块的原始名称
                sName       := joModule.name;       //模块的新名称
                sCaption    := joModule.caption;    //模块的新标题
                //
                CopyFile(PWideChar(gsMainDir+'modules\items\'+sModule+'\unit0.pas'),PWideChar(gsOutputDir+'unit_'+sName+'.pas'),false);
                CopyFile(PWideChar(gsMainDir+'modules\items\'+sModule+'\unit0.dfm'),PWideChar(gsOutputDir+'unit_'+sName+'.dfm'),false);

                //< .dfm ---------------------------------------------------------------------------
                slCode  := TStringList.Create;
                slCode.LoadFromFile(gsOutputDir+'unit_'+sName+'.dfm', TEncoding.UTF8);
                //
                sText   := slCode.Text;
                //修改Caption
                sText   := StringReplace(sText,'''[*caption*]''',StrToDfmCode(sCaption),[rfReplaceAll,rfIgnoreCase]);
                //修改类型和对象名
                sText   := StringReplace(sText,'Form_Item','Form_'+sName,[rfReplaceAll,rfIgnoreCase]);
                //
                slCode.Text := sText;
                slCode.SaveToFile(gsOutputDir+'unit_'+joModule.name+'.dfm', TEncoding.UTF8);
                slCode.Destroy;
                //>

                //< .pas ---------------------------------------------------------------------------
                slCode  := TStringList.Create;
                slCode.LoadFromFile(gsOutputDir+'unit_'+sName+'.pas', TEncoding.UTF8);
                //
                sText   := slCode.Text;
                //修改类型
                sText   := StringReplace(sText,'Form_Item','Form_'+sName,[rfReplaceAll]);
                slCode.Text := sText;
                //更改头部的unit信息
                slCode.Delete(0);
                slCode.Insert(0,'unit unit_'+sName+';');
                //
                slCode.SaveToFile(gsOutputDir+'unit_'+sName+'.pas', TEncoding.UTF8);
                slCode.Destroy;
                //>
            end;

(* 这部分在本机运行时有效
            //<更新df2_role, 写入各模块信息
            joRole  := _json('[{"caption":"首页","rights":[1,1,1,1,1,1,1,1,1,1]}]');
            for iItem := 0 to gjoSystem.modules._Count-1 do begin
                //得到模块JSON对象
                joModule    := gjoSystem.modules._(iItem);
                //
                sModule     := joModule.module;     //模块的原始名称
                sName       := joModule.name;       //模块的新名称
                sCaption    := joModule.caption;    //模块的新标题
                //生成角色对象
                joItem          := _json('{}');
                joItem.caption  :=  sCaption;
                joItem.rights   := _json('[1,1,1,1,1,1,1,1,1,1]');//显示/运行/增/删/改/查/打印/预留1/预留2/预留3
                //
                joRole.Add(joItem);
            end;
            //
            sText   := joRole;
            FDQuery1.Close;
            FDQuery1.SQL.Text   := 'SELECT * FROM df2_Role';
            FDQuery1.Open;
            while not FDQuery1.Eof do begin
                //
                FDQuery1.Edit;
                FDQuery1.FieldByName('rights').AsString := sText;
                FDQuery1.Post;
                //
                FDQuery1.Next;
            end;
            //>
*)

            //
            if not DirectoryExists(gsMainDir+'download') then begin
                ChDir(gsMainDir);
                MkDir('download');
            end;

            //将生成的源代码文件保存到zip
            TZipFile.ZipDirectoryContents(gsMainDir+'download\'+gsCanvasId+'.zip', gsOutputDir);
        end;
        3 : begin

        end;
    end;
    //下一页
    PC_Frame.ActivePageIndex    := Min(PC_Frame.PageCount-1,PC_Frame.ActivePageIndex+1);
    Button_PageNext.Visible     := PC_Frame.ActivePageIndex <= PC_Frame.PageCount-1;
    Button_PagePrev.Visible     := PC_Frame.ActivePageIndex > 0;
    //
    for var i := PC_Frame.PageCount-1 downto 0 do begin
        PC_Frame.Pages[i].TabVisible    := (i = PC_Frame.ActivePageIndex);
    end;

end;

procedure TForm1.Button_PagePrevClick(Sender: TObject);
begin
    //上一页
    PC_Frame.ActivePageIndex    := Max(0,PC_Frame.ActivePageIndex-1);
    Button_PageNext.Visible     := PC_Frame.ActivePageIndex < PC_Frame.PageCount-1;
    Button_PagePrev.Visible     := PC_Frame.ActivePageIndex > 0;
    //
    for var i := 0 to PC_Frame.PageCount-1 do begin
        PC_Frame.Pages[i].TabVisible    := (i = PC_Frame.ActivePageIndex);
    end;
end;

procedure TForm1.CB_IconChange(Sender: TObject);
begin
    B_IconDemo.Hint := '{"type":"primary","icon":"'+CB_Icon.Text+'"}';
end;

procedure TForm1.CB_ModulesChange(Sender: TObject);
begin
    if E_Caption.Text = '' then begin
        //E_Caption.Text  := Trim(Copy(CB_Modules.Text,6,100));
    end;
    if E_Name.Text = '' then begin
        //E_Name.Text  := Trim(Copy(CB_Modules.Text,6,100));
    end;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
    iItem       : Integer;
    iIcon       : Integer;
    sIcon       : String;
    sIconView   : String;
    joSource    : Variant;
begin
    //
    gsMainDir   := ExtractFilePath(Application.ExeName);

    //
    if not DirectoryExists('download') then begin
        MkDir('download');
    end;

    //默认显示第一页
    PC_Frame.ActivePageIndex    := 0;

    //隐藏其他页
    for iItem := PC_Frame.PageCount-1 downto 0 do begin
        PC_Frame.Pages[iItem].TabVisible    := (iItem = 0);
    end;

    //<添加模块到LV_Source
    //将模块信息转化为JSON对象gjoSource
    gjoSource   := GetSource;

    //
    LV_Source.Items.Clear;
    for iItem := 0 to gjoSource._Count-1 do begin
        //
        joSource    := gjoSource._(iItem);
        //
        with LV_Source.Items.Add do begin
            Caption := joSource.name + ' - ' + joSource.caption;
            SubItems.Add(joSource.memo);

            //
            sIconView   := Format('image/element/%.4d.ico',[GetIconIndex(joSource.icon)]);
            SubItems.Add(sIconView);
        end;
    end;
    //>

    //
    gjoSystem   := _Json('{}');
    gjoSystem.modules   := _json('[]');
end;

procedure TForm1.FormMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X,
  Y: Integer);
begin
    dwSetPCMode(self);

end;

function TForm1.GetModule(AItem:Integer): Variant;
var
    oItem   : TListItem;
    sInfo   : String;
    joInfo  : Variant;
begin
    Result  := unassigned;
    if (AItem >=0 ) and (AItem < LV_Modules.Items.Count) then begin
        //
        oItem   := LV_Modules.Items[AItem];
        //
        if (oItem <> nil) and (oItem.SubItems.Count>1) then begin
            Result  := _Json('{}');
            //
            sInfo   := '["'+oItem.SubItems[0]+'"]';
            sInfo   := StringReplace(sInfo,' , ','","',[rfReplaceAll]);
            joInfo  := _json(sInfo);
            //
            Result.caption  := oItem.Caption;   //模块标题
            Result.module   := joInfo._(0);     //模块模板名称
            Result.name     := joInfo._(1);     //模块名称
            Result.view     := joInfo._(2);     //显示位置
            Result.icon     := joInfo._(3);     //图标
            Result.memo     := E_memo.Text;     //备注
        end;
    end;
end;

function TForm1.GetSource: Variant;
var
    iItem   : Integer;
    sName   : string;
    joItem  : Variant;
    joInfo  : Variant;
begin
    //更新FileListBox目录
    FB_Modules.Directory    := gsMainDir+'modules\items\';
    FB_Modules.Update;

    //
    Result  := _json('[]');
    for iItem := 2 to FB_Modules.Count-1 do begin
        //得到当前文件夹名称，类型[base]
        sName   := FB_Modules.Items[iItem];

        //去除前后的方括号
        Delete(sName,1,1);
        Delete(sName,Length(sName),1);

        //跳过以下划线开始的目录。 注：以下划线开始的目录为备用模块
        if sName[1] = '_' then begin
            Continue;
        end;

        //跳过没有unit0.pas或unit0.dfm的模块,以避免不必要的错误
        if not FileExists(gsMaindir+'modules\items\'+sName+'\unit0.pas') then begin
            Continue;
        end;
        if not FileExists(gsMaindir+'modules\items\'+sName+'\unit0.dfm') then begin
            Continue;
        end;

        //生成模块的JSON对象
        if FileExists(gsMaindir+'modules\items\'+sName+'\info.json') then begin
            dwLoadFromJson(joItem, gsMaindir+'modules\items\'+sName+'\info.json');
        end else begin
            joItem  := _json('{}');
        end;
        if joitem = unassigned then begin
            joItem  := _json('{}');
        end;
        joItem.name := sName;

        //检查必要的属性
        if not joItem.Exists('caption') then begin  //显示标题，如“用户管理”等
            joItem.caption  := sName;
        end;
        if not joItem.Exists('icon') then begin     //显示图标，位于菜单左侧
            joItem.icon     := 'el-icon-data-board';
        end;
        if not joItem.Exists('memo') then begin     //模块说明，默认为空
            joItem.memo     := '';
        end;

        //添加到返回值JSON数组对象中
        Result.Add(joItem);
    end;
end;

procedure TForm1.LV_ModulesChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
    joModule    : Variant;
begin
    if Item <> nil then begin
        //
        joModule    := GetModule(Item.Index);
        //
        if joModule <> unassigned then begin
            //标题
            E_Caption.Text      := joModule.caption;
            //单元名称
            E_Name.Text         := joModule.name;
            //显示位置
            CB_View.ItemIndex   := CB_View.Items.IndexOf(String(joModule.view));
            //菜单图标
            CB_Icon.ItemIndex   := GetIconIndex(joModule.icon);
            //备注
            E_Memo.Text         := joModule.memo;
        end;
    end;

end;

procedure TForm1.LV_SourceChange(Sender: TObject; Item: TListItem; Change: TItemChange);
var
    joModule    : Variant;
begin
    //::当点击源模块时，中间显示当前模块的信息

    if Item <> nil then begin
        //取得模块节点JSON子对象
        joModule    := gjoSource._(Item.Index);
        //
        if joModule <> unassigned then begin
            E_Caption.Text      := joModule.caption;    //标题
            E_Name.Text         := joModule.name;       //模块名称（文件夹名称）
            CB_Icon.ItemIndex   := GetIconIndex(joModule.icon)-1;   //图标
            CB_Icon.OnChange(nil);                      //主动触发OnChange事件以显示图标
            E_Memo.Text         := joModule.memo;       //显示备注信息
        end;
    end;
end;

end.
