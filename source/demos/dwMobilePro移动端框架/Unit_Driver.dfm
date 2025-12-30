object Form_Driver: TForm_Driver
  Left = 471
  Top = 157
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = #39550#26657#32771#35797
  ClientHeight = 690
  ClientWidth = 617
  Color = clBtnFace
  Font.Charset = GB2312_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 21
  object PC: TPanel
    Left = 0
    Top = 50
    Width = 617
    Height = 588
    Hint = '{"dwstyle":"overflow-y:auto;"}'
    Align = alClient
    BevelOuter = bvNone
    BorderWidth = 10
    Color = clWhite
    Font.Charset = GB2312_CHARSET
    Font.Color = clWindowText
    Font.Height = -20
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitHeight = 580
    object PD: TPanel
      Left = 10
      Top = 10
      Width = 597
      Height = 240
      Align = alTop
      BevelOuter = bvNone
      BorderWidth = 10
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      Visible = False
      object LT: TLabel
        Left = 10
        Top = 10
        Width = 577
        Height = 80
        Align = alTop
        AutoSize = False
        Caption = 
          #22823#23500#32705#35770#22363#26159#30001#23385#20197#20041#21338#22763#21019#21150#30340#20197'Delphi'#20026#20027#30340#32534#31243#25216#26415#35770#22363#12290#33258'1998'#24180#24314#31435#20197#26469#65292#24191#22823#31243#24207#21592#21644#32534#31243#29233#22909#32773#22312#36825#37324#35752#35770#25216#26415#12289#20132#27969 +
          #32463#39564#65292#19968#26102#38388#39640#25163#36744#20986#65292#31934#21697#36148#23618#20986#19981#31351#12290#21518#26469#65292#32463#36807'soul'#22823#20384#30340#25913#29256#65292#20351#35770#22363#30028#38754#26356#38739#12289#36895#24230#26356#24555#65292#36825#37324#20456#28982#25104#20102#31243#24207#21592#30340#8220#22825#22530#8221#12290
        Font.Charset = GB2312_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        WordWrap = True
      end
      object PS: TPanel
        Left = 10
        Top = 90
        Width = 577
        Height = 140
        Align = alTop
        BevelKind = bkSoft
        BevelOuter = bvNone
        BorderWidth = 5
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object RBA: TRadioButton
          AlignWithMargins = True
          Left = 8
          Top = 8
          Width = 557
          Height = 25
          Align = alTop
          Caption = 'A'
          TabOrder = 0
          OnClick = RBAClick
          ExplicitLeft = 3
          ExplicitTop = 13
          ExplicitWidth = 547
        end
        object RBB: TRadioButton
          AlignWithMargins = True
          Left = 8
          Top = 39
          Width = 557
          Height = 25
          Align = alTop
          Caption = 'B'
          TabOrder = 1
          OnClick = RBAClick
          ExplicitLeft = 3
          ExplicitTop = 44
          ExplicitWidth = 547
        end
        object RBC: TRadioButton
          AlignWithMargins = True
          Left = 8
          Top = 70
          Width = 557
          Height = 25
          Align = alTop
          Caption = 'C'
          TabOrder = 2
          OnClick = RBAClick
          ExplicitLeft = 3
          ExplicitTop = 75
          ExplicitWidth = 547
        end
        object RBD: TRadioButton
          AlignWithMargins = True
          Left = 8
          Top = 101
          Width = 557
          Height = 25
          Align = alTop
          Caption = 'D'
          TabOrder = 3
          OnClick = RBAClick
          ExplicitLeft = 3
          ExplicitTop = 106
          ExplicitWidth = 547
        end
      end
    end
  end
  object PTitle: TPanel
    Left = 0
    Top = 0
    Width = 617
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 16359209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 1
    object LTitle: TLabel
      AlignWithMargins = True
      Left = 50
      Top = 3
      Width = 517
      Height = 44
      Margins.Left = 0
      Margins.Right = 50
      Align = alClient
      Alignment = taCenter
      Caption = #39550#32771#31185#30446#19968#27979#35797
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 140
      ExplicitHeight = 27
    end
    object B0: TButton
      Left = 0
      Top = 0
      Width = 50
      Height = 50
      Hint = 
        '{"type":"text","icon":"el-icon-arrow-left","onclick":"try{histor' +
        'y.back()}finally{};"}'
      Align = alLeft
      Cancel = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
  object Button_OK: TButton
    Left = 0
    Top = 638
    Width = 617
    Height = 52
    Hint = 
      '{"icon":"el-icon-check","radius":"0px","dwstyle":"border:0;","ty' +
      'pe":"success"}'
    Margins.Left = 1
    Margins.Top = 0
    Margins.Right = 1
    Margins.Bottom = 0
    Align = alBottom
    Caption = #20132#21367
    TabOrder = 2
    OnClick = Button_OKClick
    ExplicitLeft = -6
    ExplicitTop = 641
  end
  object FDQuery1: TFDQuery
    Left = 282
    Top = 305
  end
end
