object Form_InboundOrder: TForm_InboundOrder
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = #21830#21697#20837#24211
  ClientHeight = 822
  ClientWidth = 1304
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clBtnFace
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -17
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnShow = FormShow
  TextHeight = 23
  object PaFrame: TPanel
    AlignWithMargins = True
    Left = 30
    Top = 30
    Width = 1244
    Height = 762
    Margins.Left = 30
    Margins.Top = 30
    Margins.Right = 30
    Margins.Bottom = 30
    Align = alClient
    AutoSize = True
    BevelKind = bkSoft
    BevelOuter = bvNone
    BorderWidth = 30
    Color = clWhite
    Font.Charset = ANSI_CHARSET
    Font.Color = clGray
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    object PT0: TPanel
      AlignWithMargins = True
      Left = 45
      Top = 30
      Width = 1150
      Height = 36
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      object Panel3: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 36
        Margins.Left = 15
        Margins.Top = 15
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel2'
        ParentColor = True
        TabOrder = 0
        object La1: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 90
          Height = 30
          Align = alLeft
          AutoSize = False
          Caption = #21333#25454#32534#21495#65306
          Layout = tlCenter
        end
        object EtNo: TEdit
          AlignWithMargins = True
          Left = 99
          Top = 3
          Width = 198
          Height = 30
          Hint = 
            '{"dwstyle":"border:0;border-radius:0px;border-bottom:solid 1px #' +
            'ddd;"}'
          Align = alClient
          TabOrder = 0
          Text = 'RK202501080831-02'
          ExplicitHeight = 28
        end
      end
      object Panel4: TPanel
        Left = 850
        Top = 0
        Width = 300
        Height = 36
        Margins.Left = 15
        Margins.Top = 15
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alRight
        BevelOuter = bvNone
        Caption = 'Panel2'
        ParentColor = True
        TabOrder = 1
        object La2: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 90
          Height = 30
          Align = alLeft
          Alignment = taRightJustify
          AutoSize = False
          Caption = #26085#26399#65306
          Layout = tlCenter
        end
        object dt1: TDateTimePicker
          AlignWithMargins = True
          Left = 99
          Top = 3
          Width = 198
          Height = 30
          Hint = 
            '{"dwstyle":"border:0;border-radius:0px;border-bottom:solid 1px #' +
            'ddd;"}'
          Align = alClient
          Date = 45665.000000000000000000
          Time = 0.353186215281311900
          TabOrder = 0
        end
      end
    end
    object PT1: TPanel
      AlignWithMargins = True
      Left = 45
      Top = 66
      Width = 1150
      Height = 36
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 5
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Panel5: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 36
        Margins.Left = 15
        Margins.Top = 15
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alLeft
        BevelOuter = bvNone
        Caption = 'Panel2'
        ParentColor = True
        TabOrder = 0
        object La3: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 90
          Height = 30
          Align = alLeft
          AutoSize = False
          Caption = #20379#24212#21830#65306
          Layout = tlCenter
        end
        object CbS: TComboBox
          AlignWithMargins = True
          Left = 99
          Top = 4
          Width = 198
          Height = 28
          Hint = 
            '{"dwstyle":"border:0;border-radius:0px;border-bottom:solid 1px #' +
            'ddd;"}'
          Margins.Top = 4
          Margins.Bottom = 4
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = CbSChange
        end
      end
      object Panel8: TPanel
        Left = 850
        Top = 0
        Width = 300
        Height = 36
        Margins.Left = 15
        Margins.Top = 15
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alRight
        BevelOuter = bvNone
        Caption = 'Panel2'
        ParentColor = True
        TabOrder = 1
        object La4: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 90
          Height = 30
          Align = alLeft
          Alignment = taRightJustify
          AutoSize = False
          Caption = #20179#24211#65306
          Layout = tlCenter
        end
        object CBW: TComboBox
          AlignWithMargins = True
          Left = 99
          Top = 4
          Width = 198
          Height = 28
          Hint = 
            '{"dwstyle":"border:0;border-radius:0px;border-bottom:solid 1px #' +
            'ddd;"}'
          Margins.Top = 4
          Margins.Bottom = 4
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = CBWChange
        end
      end
    end
    object PMain: TPanel
      AlignWithMargins = True
      Left = 39
      Top = 107
      Width = 1162
      Height = 370
      Hint = 
        '{"account":"dwERP","where":"tcanvasid='#39'xxxxx'#39'","table":"eInbound' +
        'OrderTemp","defaultquerymode":0,"buttons":0,"pagesize":5,"fixed"' +
        ':[1,1],"fields":[{"name":"tId","caption":"'#24207#21495'","full":1,"width":4' +
        '0,"type":"index","align":"center"},{"name":"tgName","caption":"'#21830 +
        #21697#21517#31216'","sort":1,"width":150},{"name":"tgSpecification","caption":"' +
        #35268#26684'","sort":1,"width":100},{"name":"tgUnit","caption":"'#21333#20301'","sort"' +
        ':1,"align":"center","width":80},{"name":"tQuantity","caption":"'#25968 +
        #37327'","sort":1,"query":1,"type":"integer","align":"right","width":8' +
        '0},{"name":"tgInPrice","caption":"'#21333#20215'","sort":1,"type":"money","a' +
        'lign":"right","width":80},{"name":"tAmount","caption":"'#37329#39069'","sort' +
        '":1,"type":"money","align":"right","width":80},{"name":"tgRemark' +
        '","caption":"'#22791#27880'","sort":1,"width":120,"query":1},{"name":"tgRema' +
        'rk","caption":"'#25805#20316'","type":"button","sort":1,"width":135,"list":[' +
        '{"caption":"'#21024#38500'","type":"danger","dwattr":"plain","width":60,"ima' +
        'ge":"el-icon-delete","method":"delete"},{"caption":"'#32534#36753'","type":"' +
        'primary","dwattr":"plain","width":60,"image":"el-icon-edit","met' +
        'hod":"edit"}]}]}'
      Margins.Left = 9
      Margins.Top = 0
      Margins.Right = 9
      Margins.Bottom = 0
      Align = alTop
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 2
      OnDragOver = PMainDragOver
    end
    object PB8: TPanel
      AlignWithMargins = True
      Left = 45
      Top = 477
      Width = 1150
      Height = 44
      Margins.Left = 15
      Margins.Top = 0
      Margins.Right = 15
      Margins.Bottom = 0
      Align = alTop
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 3
      object Panel10: TPanel
        Left = 0
        Top = 0
        Width = 300
        Height = 40
        Margins.Left = 15
        Margins.Top = 15
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alLeft
        BevelKind = bkSoft
        BevelOuter = bvNone
        Caption = 'Panel2'
        ParentColor = True
        TabOrder = 0
        object La5: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 90
          Height = 30
          Align = alLeft
          AutoSize = False
          Caption = #32463#25163#20154#65306
          Layout = tlCenter
        end
        object CBP: TComboBox
          AlignWithMargins = True
          Left = 99
          Top = 4
          Width = 194
          Height = 28
          Hint = 
            '{"dwstyle":"border:0;border-radius:0px;border-bottom:solid 1px #' +
            'ddd;"}'
          Margins.Top = 4
          Margins.Bottom = 4
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = CBPChange
        end
      end
      object Panel11: TPanel
        Left = 846
        Top = 0
        Width = 300
        Height = 40
        Margins.Left = 15
        Margins.Top = 15
        Margins.Right = 5
        Margins.Bottom = 0
        Align = alRight
        BevelKind = bkSoft
        BevelOuter = bvNone
        Caption = 'Panel2'
        ParentColor = True
        TabOrder = 1
        object La6: TLabel
          AlignWithMargins = True
          Left = 3
          Top = 3
          Width = 90
          Height = 30
          Align = alLeft
          AutoSize = False
          Caption = #26680#21333#20154#65306
          Layout = tlCenter
        end
        object CBC: TComboBox
          AlignWithMargins = True
          Left = 99
          Top = 4
          Width = 194
          Height = 28
          Hint = 
            '{"dwstyle":"border:0;border-radius:0px;border-bottom:solid 1px #' +
            'ddd;"}'
          Margins.Top = 4
          Margins.Bottom = 4
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -15
          Font.Name = #24494#36719#38597#40657
          Font.Style = []
          ParentFont = False
          TabOrder = 0
          OnChange = CBCChange
        end
      end
    end
    object PnB: TPanel
      AlignWithMargins = True
      Left = 51
      Top = 521
      Width = 1138
      Height = 55
      Hint = '{"dwstyle":"border-top:solid 1px #ddd;"}'
      Margins.Left = 21
      Margins.Top = 0
      Margins.Right = 21
      Margins.Bottom = 20
      Align = alTop
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 4
      object BtSubmit: TButton
        AlignWithMargins = True
        Left = 1024
        Top = 13
        Width = 100
        Height = 30
        Hint = '{"type":"success"}'
        Margins.Top = 13
        Margins.Right = 10
        Margins.Bottom = 8
        Align = alRight
        Caption = #25552#20132#20837#24211
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BtSubmitClick
      end
      object BtAdd: TButton
        AlignWithMargins = True
        Left = 3
        Top = 13
        Width = 100
        Height = 30
        Hint = '{"type":"primary"}'
        Margins.Top = 13
        Margins.Right = 10
        Margins.Bottom = 8
        Align = alLeft
        Caption = #28155#21152#21830#21697
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = BtAddClick
      end
    end
  end
  object PaAdd: TPanel
    Left = 224
    Top = 50
    Width = 780
    Height = 555
    Hint = 
      '{"radius":"5px","dwstyle":"box-shadow: rgba(0, 0, 0, 0.35) 0px 5' +
      'px 15px;"}'
    HelpType = htKeyword
    HelpKeyword = 'modal'
    BevelKind = bkSoft
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    Visible = False
    DesignSize = (
      776
      551)
    object Label8: TLabel
      AlignWithMargins = True
      Left = 20
      Top = 20
      Width = 736
      Height = 20
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Margins.Bottom = 0
      Align = alTop
      AutoSize = False
      Caption = #28155#21152#21830#21697
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -17
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      ExplicitLeft = 88
      ExplicitTop = 16
      ExplicitWidth = 48
    end
    object PaGoods: TPanel
      AlignWithMargins = True
      Left = 20
      Top = 60
      Width = 736
      Height = 416
      Hint = 
        '{"account":"dwERP","table":"eGoods","defaultquerymode":2,"prefix' +
        '":"g","pagesize":5,"buttons":0,"fields":[{"name":"gActive","capt' +
        'ion":"'#22312#29992'","sort":1,"width":"80","type":"boolean","align":"center' +
        '","query":0,"dbfilter":1,"list":["'#9675'","'#9679'"],"datatype":5},{"name":' +
        '"gName","caption":"'#21830#21697#21517#31216'","sort":1,"query":1,"width":120},{"name"' +
        ':"gCode","caption":"'#32534#30721'","sort":1,"width":"80","type":"string","q' +
        'uery":1,"fuzzy":1,"align":"left","datatype":24},{"name":"gSpecif' +
        'ication","caption":"'#35268#26684'","sort":1,"query":0,"width":80},{"name":"' +
        'gCategoryid","caption":"'#31867#21035'","sort":1,"width":"100","type":"dbtre' +
        'epair","align":"center","fuzzy":1,"query":1,"dbfilter":1,"table"' +
        ':"eCategory","datafield":"cNo","viewfield":"cName","datatype":3}' +
        ',{"name":"gSupplierId","caption":"'#20379#24212#21830'","sort":1,"width":"100","t' +
        'ype":"dbcombopair","dbfilter":1,"query":0,"table":"eSupplier","d' +
        'atafield":"sID","viewfield":"sName","datatype":3},{"name":"gUnit' +
        '","caption":"'#21333#20301'","sort":1,"align":"center","width":70},{"name":"' +
        'gInPrice","caption":"'#36827#20215'","sort":1,"align":"right","width":90},{"' +
        'name":"gId","view":2},{"name":"gCategoryId","view":2},{"name":"g' +
        'Grade","view":2},{"name":"gBrand","view":2},{"name":"gPhoto","vi' +
        'ew":2},{"name":"gOutPrice","view":2},{"name":"gAlertQuantity","v' +
        'iew":2},{"name":"gDescription","view":2},{"name":"gCreateTime","' +
        'view":2}]}'
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Margins.Bottom = 0
      Align = alClient
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
    end
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 21
      Top = 476
      Width = 734
      Height = 55
      Hint = '{"dwstyle":"border-top:solid 1px #ddd;"}'
      Margins.Left = 21
      Margins.Top = 0
      Margins.Right = 21
      Margins.Bottom = 20
      Align = alBottom
      BevelKind = bkSoft
      BevelOuter = bvNone
      Color = clWhite
      ParentBackground = False
      TabOrder = 1
      object Label7: TLabel
        AlignWithMargins = True
        Left = 10
        Top = 13
        Width = 65
        Height = 30
        Margins.Left = 10
        Margins.Top = 13
        Margins.Bottom = 8
        Align = alLeft
        AutoSize = False
        Caption = #25968#37327#65306
        Layout = tlCenter
        ExplicitLeft = 0
        ExplicitTop = 3
      end
      object BuAOK: TButton
        AlignWithMargins = True
        Left = 620
        Top = 13
        Width = 100
        Height = 30
        Hint = '{"type":"primary"}'
        Margins.Top = 13
        Margins.Right = 10
        Margins.Bottom = 8
        Align = alRight
        Caption = #28155#21152
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -15
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = BuAOKClick
      end
      object SEAQuantity: TSpinEdit
        AlignWithMargins = True
        Left = 81
        Top = 13
        Width = 89
        Height = 33
        Hint = '{"dwstyle":"border:solid 1px #ddd;border-radius:3px;"}'
        Margins.Top = 13
        Margins.Bottom = 11
        Align = alLeft
        AutoSize = False
        Font.Charset = ANSI_CHARSET
        Font.Color = clWindowText
        Font.Height = -17
        Font.Name = #24494#36719#38597#40657
        Font.Style = []
        MaxValue = 0
        MinValue = 0
        ParentFont = False
        TabOrder = 1
        Value = 0
      end
    end
    object BtACancel: TButton
      AlignWithMargins = True
      Left = 735
      Top = 5
      Width = 36
      Height = 36
      Hint = '{"type":"text","icon":"el-icon-close"}'
      Margins.Top = 13
      Margins.Right = 10
      Margins.Bottom = 8
      Anchors = [akTop, akRight]
      Cancel = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGray
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = BtACancelClick
    end
  end
  object FQ0: TFDQuery
    Connection = Form1.FDConnection1
    Left = 80
    Top = 203
  end
  object FQTemp: TFDQuery
    Connection = Form1.FDConnection1
    Left = 80
    Top = 267
  end
  object FQGoods: TFDQuery
    Connection = Form1.FDConnection1
    Left = 80
    Top = 323
  end
end
