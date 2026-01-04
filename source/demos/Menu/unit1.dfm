object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 800
  ClientWidth = 939
  Color = clAppWorkSpace
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  TextHeight = 20
  object Shape1: TShape
    Left = 0
    Top = 40
    Width = 200
    Height = 760
    Hint = 
      '{"menu":"MainMenu1","activetextcolor":"#fff","hovercolor":"#C4C4' +
      'C2","activebkcolor":"#348986"}'
    HelpType = htKeyword
    HelpKeyword = 'menu'
    Align = alLeft
    Brush.Color = 12239944
    Pen.Color = clWhite
    Pen.Width = 0
    ExplicitLeft = -6
    ExplicitTop = 53
    ExplicitHeight = 750
  end
  object Panel3: TPanel
    Left = 200
    Top = 40
    Width = 739
    Height = 760
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel2'
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Button1: TButton
      Left = 40
      Top = 40
      Width = 120
      Height = 41
      Caption = #25240#21472'/'#23637#24320
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 40
      Top = 87
      Width = 120
      Height = 41
      Caption = #26174#31034'/'#38544#34255
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button4: TButton
      Left = 40
      Top = 134
      Width = 120
      Height = 43
      Caption = #22686#21152#33756#21333#39033
      TabOrder = 2
      OnClick = Button4Click
    end
    object Button5: TButton
      Left = 40
      Top = 183
      Width = 120
      Height = 43
      Caption = #21024#38500#33756#21333#39033
      TabOrder = 3
      OnClick = Button5Click
    end
    object Button6: TButton
      Left = 40
      Top = 232
      Width = 120
      Height = 40
      Caption = #25442#32932
      TabOrder = 4
      OnClick = Button6Click
    end
    object Button7: TButton
      Left = 40
      Top = 279
      Width = 120
      Height = 41
      Caption = #25171#24320#25351#23450#33756#21333#39033
      TabOrder = 5
      OnClick = Button7Click
    end
  end
  object Panel_0_Banner: TPanel
    Left = 0
    Top = 0
    Width = 939
    Height = 40
    Align = alTop
    BevelOuter = bvNone
    Color = 4271650
    ParentBackground = False
    TabOrder = 1
    object Label3: TLabel
      AlignWithMargins = True
      Left = 256
      Top = 3
      Width = 411
      Height = 34
      Margins.Left = 10
      Align = alClient
      Caption = ' DeWeb Warehouse Manage System'
      Color = 4210752
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -16
      Font.Name = 'Verdana'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 319
      ExplicitHeight = 18
    end
    object Label_User: TLabel
      AlignWithMargins = True
      Left = 673
      Top = 3
      Width = 76
      Height = 32
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Alignment = taRightJustify
      Caption = 'UserName'
      Font.Charset = ANSI_CHARSET
      Font.Color = 13158600
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      Visible = False
      ExplicitHeight = 20
    end
    object Panel_Title: TPanel
      Left = 0
      Top = 0
      Width = 200
      Height = 40
      Align = alLeft
      BevelOuter = bvNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -29
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentBackground = False
      ParentColor = True
      ParentFont = False
      TabOrder = 0
      object Label_Title: TLabel
        Left = 0
        Top = 0
        Width = 200
        Height = 40
        HelpType = htKeyword
        Align = alClient
        Alignment = taCenter
        Caption = 'D.W.M.S'
        Font.Charset = ANSI_CHARSET
        Font.Color = clWhite
        Font.Height = -24
        Font.Name = 'Verdana'
        Font.Style = [fsBold, fsItalic]
        ParentFont = False
        Layout = tlCenter
        WordWrap = True
        ExplicitWidth = 114
        ExplicitHeight = 29
      end
    end
    object Button_Collapse: TButton
      AlignWithMargins = True
      Left = 200
      Top = 0
      Width = 46
      Height = 40
      Hint = '{"icon":"el-icon-s-fold","type":"text","color":"#EEE"}'
      Margins.Left = 0
      Margins.Top = 0
      Margins.Right = 0
      Margins.Bottom = 0
      Align = alLeft
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -19
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = Button1Click
    end
    object Button_Logout: TButton
      AlignWithMargins = True
      Left = 879
      Top = 8
      Width = 50
      Height = 24
      Hint = 
        '{"type":"text","fontsize":"14px","icon":"el-icon-close","color":' +
        '"#C8C8C8"}'
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = #36864#20986
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      Visible = False
    end
    object Button_Register: TButton
      AlignWithMargins = True
      Left = 759
      Top = 8
      Width = 50
      Height = 24
      Hint = 
        '{"type":"text","icon":"el-icon-user","fontsize":"14px","color":"' +
        '#C8C8C8"}'
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = #27880#20876
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object Button_Login: TButton
      AlignWithMargins = True
      Left = 819
      Top = 8
      Width = 50
      Height = 24
      Hint = 
        '{"type":"text","icon":"el-icon-user","fontsize":"14px","color":"' +
        '#C8C8C8"}'
      Margins.Left = 0
      Margins.Top = 8
      Margins.Right = 10
      Margins.Bottom = 8
      Align = alRight
      Caption = #30331#24405
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -15
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 85
    Top = 117
    object M0: TMenuItem
      Caption = #31995#32479#21442#25968
      ImageIndex = 56
      object M00: TMenuItem
        Caption = #25171#24320
        ImageIndex = 32
      end
      object M01: TMenuItem
        Caption = #20851#38381
        ImageIndex = 66
      end
    end
    object M1: TMenuItem
      Caption = #24179#21488#25509#21475
      ImageIndex = 57
      object M10: TMenuItem
        Caption = #25903#20184#23453#25509#21475
        ImageIndex = 31
        OnClick = M10Click
      end
      object M11: TMenuItem
        Caption = #24494#20449#25903#20184
        ImageIndex = 44
      end
      object M12: TMenuItem
        Caption = #24494#20449#25903#20184
        ImageIndex = 36
      end
    end
    object M2: TMenuItem
      Caption = #19994#21153#27169#22359
      ImageIndex = 76
    end
    object M3: TMenuItem
      Caption = #31995#32479#31649#29702
      ImageIndex = 88
      object M30: TMenuItem
        Caption = #31995#32479#31649#29702
      end
    end
    object M4: TMenuItem
      Caption = #24110#21161
      ImageIndex = 33
    end
  end
end
