unit Main;
(*
更新记录
----------------------
### 2025-05-16
1. 增加了换行自动缩进
2. 更新了format按钮功能, 不是JSON时不再清空, 而是保留
3. 使用长字符串, 去除了Memo
*)

interface

uses
    //
    dwaConsts,

    //第三方单元
    SynCommons,     //JSON解析单元

    //
    Variants,
    Winapi.Windows, Winapi.Messages, System.SysUtils,  System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DesignIntf, DesignEditors, Vcl.ExtCtrls,
    Vcl.ComCtrls,Vcl.DBGrids, Vcl.Grids, Vcl.Mask, Vcl.Buttons, Vcl.Samples.Calendar, Vcl.Menus,
    Vcl.MPlayer, Vcl.Samples.Spin, Vcl.WinXCtrls,Vcl.ButtonGroup,Vcl.WinXPanels;

type
  TMainForm = class(TForm)
    Panel_Buttons: TPanel;
    Button_SaveJson: TButton;
    Button_Cancel: TButton;
    Button_SaveText: TButton;
    Shape_JSON: TShape;
    Label_JSON: TLabel;
    Panel_Client: TPanel;
    PageControl1: TPageControl;
    Splitter1: TSplitter;
    Button_Format: TButton;
    ListView1: TListView;
    RichEdit: TRichEdit;
    procedure Memo_ValueChange(Sender: TObject);
    procedure Button_SaveJsonClick(Sender: TObject);
    procedure Button_PropertyClick(Sender: TObject);
    procedure Button_RemovePropertyClick(Sender: TObject);
    procedure Button_CatPropertyClick(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint; var Handled: Boolean);
    procedure Button_FormatClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RichEditKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure RichEditKeyPress(Sender: TObject; var Key: Char);
  private
  public
    { Public declarations }
  end;

    TDeWebJsonProperty = class(TPropertyEditor)
        procedure Edit; override;
        function  GetAttributes: TPropertyAttributes; override;
        function  GetValue: string; override;
        procedure SetValue (const Value: string); override;
    private

        MainForm    : TMainForm;
    public
        procedure PrepareProperty(AProperty,AHelpKeyword:String;AForm:TMainForm);
    end;


procedure Register; //注册构件

implementation

{$R *.dfm}


procedure Register;

begin

    //前提是组件面板中已经存在TMyDataBaseEdit自定义控件，它存在XAbout这个属性，属性类型为String型；

    //将TDWPropertyEdit与属性XAbout关联起来

    RegisterPropertyEditor(TypeInfo(string),nil,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TButton,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TButtonGroup,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TForm,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),nil,'StyleName',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TBitBtn,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TCalendar,'Hint',TDeWebJsonProperty);

    //不加该行，以避免部分未安装TeeChart报错
    //RegisterPropertyEditor(TypeInfo(string),TChart,'Hint',TDeWebJsonProperty);

    RegisterPropertyEditor(TypeInfo(string),TCardPanel,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TCheckBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TComboBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TDateTimePicker,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TDBGrid,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TEdit,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TGroupBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),THeaderControl,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TImage,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TLabel,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TListBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TListView,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMainMenu,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMediaPlayer,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMemo,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMenuItem,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TPageControl,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TPanel,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TProgressBar,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TRadioButton,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TRadioGroup,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TScrollBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TShape,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TSpeedButton,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TSpinEdit,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TSplitter,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TStaticText,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TStringGrid,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTabSheet,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTimer,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TToggleSwitch,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTrackBar,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTreeView,'Hint',TDeWebJsonProperty);
    //
    RegisterPropertyEditor(TypeInfo(string),TColumnTitle,'Caption',TDeWebJsonProperty);
    //
    RegisterPropertyEditor(TypeInfo(string),TForm,'StyleName',TDeWebJsonProperty);

end;

function dwIIF(ABool:Boolean;AYes,ANo:string):string;
begin
     if ABool then begin
          Result    := AYes;
     end else begin
          Result    := ANo;
     end;
end;




//点击保存按钮事件。 保存前先检查是否为JSON格式
procedure TMainForm.Button_SaveJsonClick(Sender: TObject);
var
    sText   : string;
    joData  : Variant;
begin
    sText   := Trim(RichEdit.Text);
    joData  := _json(sText);
    //
    if joData <> unassigned then begin
        RichEdit.OnChange   := nil;
        RichEdit.Text       := joData;
        ModalResult         := mrOK;
    end else begin
        if sText <> '' then begin
            ShowMessage('必须为JSON格式，请检查！');
        end;
    end;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
    iTabWidth   : Integer;
    iItem       : Integer;
begin
    //调Tab缩进为4个字符
    iTabWidth   := 20;

    // 设置RichEdit的TabStop
    RichEdit.Paragraph.TabCount := 20;
    for iItem := 1 to RichEdit.Paragraph.TabCount do begin
        RichEdit.Paragraph.Tab[iItem-1] := iTabWidth*iItem;
    end;

    //
    RichEdit.Font.Name              := 'Courier New';   // 设置字体名称
    RichEdit.SelAttributes.Name     := RichEdit.Font.Name;

    RichEdit.DefAttributes.Name     := RichEdit.Font.Name;
    RichEdit.DefAttributes.Size     := RichEdit.Font.Size;
    RichEdit.DefAttributes.Style    := RichEdit.Font.Style;
end;

procedure TMainForm.ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
  MousePos: TPoint; var Handled: Boolean);
begin
    if WheelDelta < 0 then
        TScrollBox(Sender).Perform(WM_VSCROLL,SB_LINEDOWN,0)
    else
        TScrollBox(Sender).Perform(WM_VSCROLL,SB_LINEUP,0);
end;


//格式化
procedure TMainForm.Button_FormatClick(Sender: TObject);
var
    joData  : Variant;
begin
    try
        joData      := _json(Trim(RichEdit.Text));
        //
        if joData <> unassigned then begin
            //此处需要格式化
            RichEdit.Lines.Text := JSONReformat(joData);
            //刷新
            RichEdit.Update;
            RichEdit.Refresh;
        end else begin
            if Trim(RichEdit.Text) <> '' then begin
                ShowMessage('一般需要是JSON格式!');
            end;
        end;
    except
    end;
end;

procedure TMainForm.Button_PropertyClick(Sender: TObject);
var
    joData  : Variant;
    oButton : TButton;
    //
    sProp   : string;
    sValue  : string;
begin
    //取得当前按钮对象
    oButton := TButton(Sender);

    //取得属性名称和属性值
    sProp   := TTabSheet(oButton.Parent.Parent).Caption;
    sValue  := oButton.Caption;

    //
    joData      := _json(Trim(RichEdit.Text));

    if joData = unassigned then begin
        joData  := _json('{}');
    end;

    //先清除可能存在的属性
    if joData.Exists(sProp) then begin
        joData.Delete(sProp);
    end;

    //
    if LowerCase(oButton.Hint) = 'integer' then begin
        joData.Add(sProp,StrToIntDef(sValue,0));
    end else if LowerCase(oButton.Hint) = 'boolean' then begin
        joData.Add(sProp,(LowerCase(sValue)='true'));
    end else begin
        joData.Add(sProp,sValue);
    end;

    //
    RichEdit.Lines.Text := JSONReformat(joData);

    //
    Label_Json.Caption       := 'Is JSON';
    Shape_Json.Brush.Color   := clLime;
end;

//主要处理类似concat多子项拼接的情况
procedure TMainForm.Button_CatPropertyClick(Sender: TObject);
var
    joData  : Variant;
    oButton : TButton;
    //
    sProp   : string;
    sValue  : string;
begin
    //取得当前按钮对象
    oButton := TButton(Sender);

    //取得属性名称和属性值
    sProp   := TTabSheet(oButton.Parent.Parent).Caption;
    sValue  := oButton.Caption;

    //
    joData      := _json(Trim(RichEdit.Text));

    if joData = unassigned then begin
        joData  := _json('{}');
    end;

    //先清除可能存在的属性
    if joData.Exists(sProp) then begin
        sValue  := joData._(sProp)+sValue;
        joData.Delete(sProp);
    end;

    //最后如果不是;,则增加分号
    sValue  := Trim(sValue);

    //取得值
    joData.Add(sProp,sValue);

    //显示
    RichEdit.Lines.Text := JSONReformat(joData);

    //
    Label_Json.Caption       := 'Is JSON';
    Shape_Json.Brush.Color   := clLime;
end;


procedure TMainForm.Button_RemovePropertyClick(Sender: TObject);
var
    joData  : Variant;
    oButton : TButton;
    //
    sProp   : string;
    sValue  : string;
begin
    //取得当前按钮对象
    oButton := TButton(Sender);

    //取得属性名称和属性值
    sProp   := TTabSheet(oButton.Parent.Parent).Caption;

    //
    joData      := _json(Trim(RichEdit.Text));

    if joData = unassigned then begin
        joData  := _json('{}');
    end;

    //先清除可能存在的属性
    if joData.Exists(sProp) then begin
        joData.Delete(sProp);
    end;

    //
    RichEdit.Lines.Text := JSONReformat(joData);

    //
    Label_Json.Caption       := 'Is JSON';
    Shape_Json.Brush.Color   := clLime;
end;



procedure TMainForm.Memo_ValueChange(Sender: TObject);
var
    joData  : Variant;
begin
    try
        joData      := _json(Trim(RichEdit.Text)) ;
        //
        Label_Json.Caption       := 'Is JSON';
        Shape_Json.Brush.Color   := clLime;
    except
        Label_Json.Caption       := 'Not JSON';
        Shape_Json.Brush.Color   := clRed;
    end;
end;

procedure TMainForm.RichEditKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
    RichEdit.SelAttributes.Name     := RichEdit.Font.Name;
    RichEdit.SelAttributes.Size     := RichEdit.Font.Size;
    RichEdit.SelAttributes.Style    := RichEdit.Font.Style;
end;

procedure TMainForm.RichEditKeyPress(Sender: TObject; var Key: Char);
var
    iLineIndex  : Integer;
    sCurText    : string;
    iTabs       : Integer;
    sIndent     : string;
    iItem       : Integer;
begin
    if Key = #13 then begin
        Key := #0; // 阻止默认回车处理

        // 获取当前行信息
        iLineIndex  := RichEdit.Perform(EM_LINEFROMCHAR, RichEdit.SelStart, 0);
        //ShowMessage(Inttostr(iLineindex));
        //
        sCurText    := Richedit.Lines[iLineIndex-1];

        //
        iTabs   := 0;
        for iItem := 1 to Length(sCurText) do begin
            if sCurText[iItem]=' ' then begin
                Inc(iTabs);
            end else if sCurText[iItem]= #9 then begin
                Inc(iTabs,5);
            end else begin
                break;
            end;
        end;

        // 计算缩进（空格或Tab）
        sIndent     := '';
        for iItem := 1 to iTabs do begin
            sIndent := sIndent + ' ';
        end;

        // 插入换行符和缩进
        RichEdit.SelText := sIndent;
    end;
end;

{ TDeWebJsonProperty }

//开发者在点击属性右边的...时激活
procedure TDeWebJsonProperty.Edit;
var
    sClass  : string;
    sText   : string;
    sHelpKey    : String;
    joData  : Variant;
begin
    if not Assigned(MainForm) then begin
        MainForm := TMainForm.Create(nil);
    end;

    //
    try
        with MainForm do begin

            //取得原属性值
            sText       := GetStrValue;
            joData      := _json(sText);
            if joData <> unassigned then begin
                RichEdit.Lines.Text    := JSONReformat(joData);
            end else begin
                RichEdit.Lines.Text    := sText;
            end;

            // 设置字体
            RichEdit.SelectAll;
            RichEdit.SelAttributes.Name := 'Courier New';
            RichEdit.SelStart := 0;
            RichEdit.SelLength := 0;

            //取得控件类
            sClass  := GetComponent(0).ClassName;


            //处理类似TListView-TListColumn之类的情况
            if sClass = 'TListColumn' then begin
                //取得控件的HelpKeyword,备用
                sHelpKey    := '';
                try
                    sHelpKey    := TControl(TListColumn(GetComponent(0)).Collection.Owner).HelpKeyword;
                except
                end;


                //准备属性
                PrepareProperty(sClass,sHelpKey,MainForm);

            end else begin

                //取得控件的HelpKeyword,备用
                sHelpKey    := '';
                try
                    if GetComponent(0) is TControl then begin
                        sHelpKey    := TControl(GetComponent(0)).HelpKeyword;
                    end;
                except
                end;

                //准备属性
                PrepareProperty(sClass,sHelpKey,MainForm);
            end;


            if ShowModal = mroK then begin
                setStrvalue(RichEdit.Text);
            end;

            // 清空当前选择并将光标置于文本的开头
            RichEdit.SelStart := 0;
            RichEdit.SelLength := 0;

        end;
    finally
        FreeAndNil (MainForm) ;
    end;
end;

function TDeWebJsonProperty.GetAttributes: TPropertyAttributes;
begin
    Result := [paDialog]
end;

function TDeWebJsonProperty.GetValue: string;
begin
    Result := GetStrValue;

end;

procedure TDeWebJsonProperty.PrepareProperty(AProperty,AHelpKeyword: String; AForm: TMainForm);
var
    joData      : Variant;
    joComp      : Variant;
    joItem      : Variant;
    sClass      : String;
    //
    iComp       : Integer;
    iItem       : Integer;
    iDemo       : Integer;
    //
    oTab        : TTabSheet;
    oLabel      : TLabel;
    oButton     : TButton;
    oScroll     : TScrollBox;
    oHint       : TLabel;
    //
    joAttr      : Variant;
    joStyle     : Variant;
begin
    //showmessage('0');
    //将变量转换为JSON对象
    joData      := _json(_HINTS);
    //showmessage(joData);

    //
    AForm.Caption   := 'dwAssist V2025-09-20';

    //生成dwattr和dwstyle对象备用
    joAttr      := _json('{"name": "dwattr", "type": "string", "hint": "直接设置HTML元素attribute","items":[[" "]]}');
    joStyle     := _json('{"name": "dwstyle","type": "concat","hint": "直接设置HTML元素style"}');

    //
    if joData <> unassigned then begin
        //showmessage('1');
        //循环检查每个控件是否为当前控件
        for iComp := 0 to joData._Count-1 do begin
            //showmessage('2');
            //取得当前控件名称
            joComp  := joData._(iComp);

            //
            if not joComp.Exists('helpkeyword') then begin
                joComp.helpkeyword := '';
            end;

            //检查AProperty,AHelpKeyword是否对应当前joComp
            if ( ( LowerCase(joComp.class) = LowerCase(AProperty) ) and (LowerCase(joComp.helpkeyword) = LowerCase(AHelpKeyword)))
                 or ( (LowerCase(joComp.class) = 'tform') and (Copy(LowerCase(AProperty),1,6)='tform_'))
            then begin
                //防止无items
                if not joComp.Exists('items') then begin
                    joComp.items    := _json('[]');
                end;

                //添加每个控件必备的dwattr和dwstyle
                joComp.items.add(joAttr);
                joComp.items.add(joStyle);

                //找到当前控件，则循环处理该控件的全部属性
                for iItem := 0 to joComp.items._Count-1 do begin
                    //取得当前控件属性JSON对象
                    joItem  := joComp.items._(iItem);

                    //检查完整性
                    if not joItem.Exists('hint') then begin
                        joItem.hint := '';
                    end;

                    //
                    if joItem.type = 'icon' then begin
                        if not joItem.Exists('items') then begin
                            joItem.items    := _json(_ICONS);
                        end;
                    end else if joItem.type = 'color' then begin
                        if not joItem.Exists('items') then begin
                            joItem.items    := _json(_COLORS);
                        end;
                    end else if joItem.type = 'radius' then begin
                        if not joItem.Exists('items') then begin
                            joItem.items    := _json(_RADIUSS);
                        end;
                    end else if joItem.type = 'type' then begin
                        if not joItem.Exists('items') then begin
                            joItem.items    := _json(_TYPES);
                        end;
                    end else if joItem.type = 'concat' then begin
                        if not joItem.Exists('items') then begin
                            joItem.items    := _json(_DWSTYLES);
                        end;
                    end;

                    //为该属性创建一个Tab
                    oTab                := TTabSheet.Create(AForm.PageControl1);
                    oTab.PageControl    := AForm.PageControl1;
                    oTab.Caption        := joItem.name;

                    //创建属性名称Label
                    oLabel  := TLabel.Create(nil);
                    oLabel.Caption  := '    类型：'+joItem.type+',    说明：'+joItem.hint;
                    oLabel.Parent   := oTab;
                    oLabel.Left     := 10;
                    oLabel.Top      := 10;
                    oLabel.Height   := 30;
                    oLabel.AutoSize := False;
                    oLabel.Layout   := tlCenter;
                    oLabel.Align    := alTop;

                    //创建一个ScrollBox以容纳更多的属性列表
                    oScroll             := TScrollBox.Create(nil);
                    oScroll.Parent      := oTab;
                    oScroll.Align       := alClient;
                    oScroll.BorderStyle := bsNone;
                    oScroll.Color       := clWhite;
                    oScroll.OnMouseWheel:= AForm.ScrollBoxMouseWheel;

                    //<为每个选项创建一个清除按钮，点击直接删除该属性
                    oButton         := TButton.Create(nil);
                    oButton.Caption := ' --- Remove --- ';
                    oButton.Parent  := oScroll;
                    oButton.Left    := 10;
                    oButton.Width   := 250;
                    oButton.Top     := 10;
                    oButton.Hint    := joItem.name;
                    oButton.OnClick := AForm.Button_RemovePropertyClick;
                    //>

                    //防止无items
                    if not joItem.Exists('items') then begin
                        joItem.items    := _json('[[""]]');
                    end;


                    //处理当前属性的多个选项
                    for iDemo := 0 to joItem.items._Count-1 do begin
                        //为每个选项创建一个按钮，点击直接添加到属性中
                        oButton         := TButton.Create(nil);

                        //根据内容显示标题
                        if LowerCase(joItem.type) = 'integer' then begin
                            oButton.Caption := IntToStr(joItem.items._(iDemo)._(0));
                        end else if LowerCase(joItem.type) = 'boolean' then begin
                            oButton.Caption := dwIIF(joItem.items._(iDemo)._(0),'true','false');
                        end else begin
                            oButton.Caption := joItem.items._(iDemo)._(0);
                        end;

                        oButton.Parent  := oScroll;
                        oButton.Left    := 10;
                        oButton.Width   := 250;
                        oButton.Top     := 10+(iDemo+1)*30;
                        oButton.Hint    := joItem.type;

                        //特殊类型（如concat）的采用拼接模式，其他采用替换
                        if (joItem.type = 'concat')  then begin
                            oButton.OnClick := AForm.Button_CatPropertyClick;
                        end else begin
                            oButton.OnClick := AForm.Button_PropertyClick;
                        end;

                        //
                        if joItem.items._(iDemo)._Count>1 then begin
                            //
                            oHint           := TLabel.Create(nil);
                            oHint.Caption   := joItem.items._(iDemo)._(1);
                            oHint.Parent    := oScroll;
                            oHint.Left      := 280;
                            oHint.Top       := 10+(iDemo+1)*30;
                            oHint.Height    := oButton.Height;
                            oHint.AutoSize  := False;
                            oHint.Layout    := tlCenter;
                        end;
                    end;

                end;
                break;
            end;
        end;
    end;

end;

procedure TDeWebJsonProperty.SetValue(const Value: string);
begin
    SetStrValue(Value);
end;

end.
