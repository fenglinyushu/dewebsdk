unit Main;

interface

uses
    //第三方单元
    SynCommons,     //JSON解析单元

    //
    Variants,
    Winapi.Windows, Winapi.Messages, System.SysUtils,  System.Classes, Vcl.Graphics,
    Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, DesignIntf, DesignEditors, Vcl.ExtCtrls,
    Vcl.ComCtrls,Vcl.DBGrids, Vcl.Grids, Vcl.Mask, Vcl.Buttons, Vcl.Samples.Calendar, Vcl.Menus,
    Vcl.MPlayer, Vcl.Samples.Spin, Vcl.WinXCtrls,Vcl.ButtonGroup;

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
    Memo1: TMemo;
    procedure Memo_ValueChange(Sender: TObject);
    procedure Button_SaveJsonClick(Sender: TObject);
    procedure Button_PropertyClick(Sender: TObject);
    procedure ScrollBoxMouseWheel(Sender: TObject; Shift: TShiftState; WheelDelta: Integer;
      MousePos: TPoint; var Handled: Boolean);
    procedure Button_FormatClick(Sender: TObject);
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
        procedure PrepareProperty(AProperty:String;AForm:TMainForm);
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

    RegisterPropertyEditor(TypeInfo(string),TCheckBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TComboBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TDateTimePicker,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TDBGrid,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TEdit,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TGroupBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TImage,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TLabel,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TListBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TListView,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMainMenu,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMediaPlayer,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TMemo,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TPageControl,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TPanel,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TProgressBar,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TRadioButton,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TRadioGroup,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TScrollBox,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TShape,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TSpeedButton,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TSpinEdit,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TStaticText,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TStringGrid,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTabSheet,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTimer,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TToggleSwitch,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTrackBar,'Hint',TDeWebJsonProperty);
    RegisterPropertyEditor(TypeInfo(string),TTreeView,'Hint',TDeWebJsonProperty);
    //
    RegisterPropertyEditor(TypeInfo(string),TColumnTitle,'Caption',TDeWebJsonProperty);

end;



//点击保存按钮事件。 保存前先检查是否为JSON格式
procedure TMainForm.Button_SaveJsonClick(Sender: TObject);
var
    sText   : string;
    joData  : Variant;
begin
    sText   := Trim(Memo1.Text);
    joData  := _json(sText);
    //
    if joData <> unassigned then begin
        Memo1.OnChange    := nil;
        Memo1.Text        := joData;
        ModalResult         := mrOK;
    end else begin
        if sText <> '' then begin
            ShowMessage('必须为JSON格式，请检查！');
        end;
    end;
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
        joData      := _json(Trim(Memo1.Text));
        //
        //此处需要格式化
        Memo1.Lines.Text := JSONReformat(joData);
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
    joData      := _json(Trim(Memo1.Text));

    if joData = unassigned then begin
        joData  := _json('{}');
    end;

    //先清除可能存在的属性
    if joData.Exists(sProp) then begin
        joData.Delete(sProp);
    end;

    //
    if LowerCase(oButton.Hint) = 'string' then begin
        joData.Add(sProp,sValue);
    end else if LowerCase(oButton.Hint) = 'integer' then begin
        joData.Add(sProp,StrToIntDef(sValue,0));
    end;

    //
    Memo1.Lines.Text := JSONReformat(joData);

    //
    Label_Json.Caption       := 'Is JSON';
    Shape_Json.Brush.Color   := clLime;
end;

procedure TMainForm.Memo_ValueChange(Sender: TObject);
var
    joData  : Variant;
begin
    try
        joData      := _json(Trim(Memo1.Text)) ;
        //
        Label_Json.Caption       := 'Is JSON';
        Shape_Json.Brush.Color   := clLime;
    except
        Label_Json.Caption       := 'Not JSON';
        Shape_Json.Brush.Color   := clRed;
    end;
end;

{ TDeWebJsonProperty }

//开发者在点击属性右边的...时激活
procedure TDeWebJsonProperty.Edit;
var
    sClass  : string;
    sText   : string;
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
                Memo1.Text    := JSONReformat(joData);
            end else begin
                Memo1.Text    := sText;
            end;

            //取得控件类
            sClass  := GetComponent(0).ClassName;

            //准备属性
            PrepareProperty(sClass,MainForm);


            if ShowModal = mroK then begin
                setStrvalue(Memo1.Text);
            end;
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

procedure TDeWebJsonProperty.PrepareProperty(AProperty: String; AForm: TMainForm);
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
begin
    //
    joData      := _json(MainForm.StyleName);
    //
    if joData <> unassigned then begin
        //循环检查每个控件是否为当前控件
        for iComp := 0 to joData._Count-1 do begin
            //取得当前控件名称
            joComp  := joData._(iComp);

            //检查是否对应
            if (LowerCase(joComp.class) = LowerCase(AProperty))
                or ( (LowerCase(joComp.class) = 'tform') and (Copy(LowerCase(AProperty),1,6)='tform_'))
            then begin

                //找到当前控件，则循环处理该控件的全部属性
                for iItem := 0 to joComp.items._Count-1 do begin
                    //取得当前控件属性JSON对象
                    joItem  := joComp.items._(iItem);

                    //检查完整性
                    if not joItem.Exists('hint') then begin
                        joItem.hint := '';
                    end;

                    //为该属性创建一个Tas
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

                    //处理当前属性的多个选项
                    for iDemo := 0 to joItem.items._Count-1 do begin
                        //为每个选项创建一个按钮，点击直接添加到属性中
                        oButton         := TButton.Create(nil);

                        //根据内容显示标题
                        if LowerCase(joItem.type) = 'string' then begin
                            oButton.Caption := joItem.items._(iDemo)._(0);
                        end else if LowerCase(joItem.type) = 'integer' then begin
                            oButton.Caption := IntToStr(joItem.items._(iDemo)._(0));
                        end;
                        oButton.Parent  := oScroll;
                        oButton.Left    := 10;
                        oButton.Width   := 150;
                        oButton.Top     := 10+iDemo*30;
                        oButton.Hint    := joItem.type;
                        oButton.OnClick := AForm.Button_PropertyClick;
                        //
                        if joItem.items._(iDemo)._Count>1 then begin
                            //
                            oHint           := TLabel.Create(nil);
                            oHint.Caption   := joItem.items._(iDemo)._(1);
                            oHint.Parent    := oScroll;
                            oHint.Left      := 180;
                            oHint.Top       := 10+iDemo*30;
                            oHint.Height    := oButton.Height;
                            oHint.AutoSize  := False;
                            oHint.Layout    := tlCenter;
                        end;
                    end;

                end;
            end;
        end;
    end;
end;

procedure TDeWebJsonProperty.SetValue(const Value: string);
begin
    SetStrValue(Value);
end;

end.
