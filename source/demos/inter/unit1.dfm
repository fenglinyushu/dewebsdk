object Form1: TForm1
  Left = 370
  Top = 190
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  Caption = 'DeWeb DataBase'
  ClientHeight = 640
  ClientWidth = 1000
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 15790320
  Font.Charset = DEFAULT_CHARSET
  Font.Color = 6579300
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnShow = FormShow
  OnStartDock = FormStartDock
  PixelsPerInch = 96
  TextHeight = 20
  object Panel_All: TPanel
    Left = 0
    Top = 60
    Width = 1000
    Height = 580
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    object Panel_StringGrid: TPanel
      Left = 250
      Top = 0
      Width = 750
      Height = 580
      Align = alClient
      AutoSize = True
      BevelOuter = bvNone
      BorderWidth = 1
      Color = clWhite
      ParentBackground = False
      TabOrder = 0
      DesignSize = (
        750
        580)
      object SG: TStringGrid
        AlignWithMargins = True
        Left = 4
        Top = 104
        Width = 742
        Height = 351
        Hint = '{"dwstyle":"border stripe"}'
        Align = alTop
        ColCount = 6
        DefaultColWidth = 100
        DefaultRowHeight = 35
        RowCount = 10
        TabOrder = 0
        OnClick = SGClick
      end
      object Panel3: TPanel
        AlignWithMargins = True
        Left = 4
        Top = 523
        Width = 742
        Height = 55
        Margins.Top = 10
        Align = alTop
        BevelOuter = bvNone
        BorderWidth = 2
        Color = clWhite
        ParentBackground = False
        TabOrder = 1
        object Button_NextPage: TButton
          AlignWithMargins = True
          Left = 564
          Top = 10
          Width = 60
          Height = 35
          Hint = '{"borderradius":"0 3px 3px 0","type":"primary"}'
          Margins.Left = 1
          Margins.Top = 8
          Margins.Bottom = 8
          Align = alRight
          Caption = #19979#19968#39029
          TabOrder = 0
          OnClick = Button_NextPageClick
        end
        object Button_PrevPage: TButton
          AlignWithMargins = True
          Left = 503
          Top = 10
          Width = 60
          Height = 35
          Hint = '{"borderradius":"3px 0 0 3px","type":"primary"}'
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 8
          Align = alRight
          Caption = #19978#19968#39029
          TabOrder = 1
          OnClick = Button_PrevPageClick
        end
        object Edit_Page: TEdit
          AlignWithMargins = True
          Left = 630
          Top = 10
          Width = 50
          Height = 33
          Hint = '{"borderradius":"3px 0 0 3px"}'
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alRight
          Alignment = taCenter
          AutoSize = False
          TabOrder = 2
          Text = '1'
        end
        object Button_Go: TButton
          AlignWithMargins = True
          Left = 680
          Top = 10
          Width = 40
          Height = 35
          Hint = '{"type":"primary","borderradius":"0 3px 3px 0"}'
          Margins.Left = 0
          Margins.Top = 8
          Margins.Right = 20
          Margins.Bottom = 8
          Align = alRight
          Caption = 'GO'
          TabOrder = 3
          OnClick = Button_GoClick
        end
        object Button_Append: TButton
          AlignWithMargins = True
          Left = 5
          Top = 10
          Width = 90
          Height = 35
          Hint = '{"borderradius":"3px 0 0 3px","type":"primary"}'
          Margins.Top = 8
          Margins.Right = 0
          Margins.Bottom = 8
          Align = alLeft
          Caption = 'Append'
          TabOrder = 4
          OnClick = Button_AppendClick
        end
        object Button_Delete: TButton
          AlignWithMargins = True
          Left = 96
          Top = 10
          Width = 90
          Height = 35
          Hint = '{"borderradius":"0","type":"primary"}'
          Margins.Left = 1
          Margins.Top = 8
          Margins.Right = 1
          Margins.Bottom = 8
          Align = alLeft
          Caption = 'Delete'
          TabOrder = 5
          OnClick = Button_DeleteClick
        end
        object Button_Edit: TButton
          AlignWithMargins = True
          Left = 187
          Top = 10
          Width = 90
          Height = 35
          Hint = '{"borderradius":"0 3px 3px 0","type":"primary"}'
          Margins.Left = 0
          Margins.Top = 8
          Margins.Bottom = 8
          Align = alLeft
          Caption = 'Save Edit'
          TabOrder = 6
          OnClick = Button_EditClick
        end
      end
      object Panel_Info: TPanel
        Left = 1
        Top = 458
        Width = 748
        Height = 55
        Align = alTop
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 2
        object Edit_Item0: TEdit
          AlignWithMargins = True
          Left = 3
          Top = 10
          Width = 100
          Height = 35
          Hint = '{"borderradius":"0"}'
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alLeft
          AutoSize = False
          TabOrder = 0
          OnChange = Edit_Item0Change
        end
        object Edit_Item1: TEdit
          AlignWithMargins = True
          Left = 103
          Top = 10
          Width = 100
          Height = 35
          Hint = '{"borderradius":"0"}'
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alLeft
          AutoSize = False
          TabOrder = 1
        end
        object Edit_Item2: TEdit
          AlignWithMargins = True
          Left = 203
          Top = 10
          Width = 100
          Height = 35
          Hint = '{"borderradius":"0"}'
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alLeft
          AutoSize = False
          TabOrder = 2
        end
        object Edit_Item3: TEdit
          AlignWithMargins = True
          Left = 303
          Top = 10
          Width = 100
          Height = 35
          Hint = '{"borderradius":"0"}'
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alLeft
          AutoSize = False
          TabOrder = 3
        end
        object Edit_Item4: TEdit
          AlignWithMargins = True
          Left = 403
          Top = 10
          Width = 433
          Height = 35
          Hint = '{"borderradius":"0"}'
          Margins.Left = 0
          Margins.Top = 10
          Margins.Right = 0
          Margins.Bottom = 10
          Align = alLeft
          AutoSize = False
          TabOrder = 4
        end
      end
      object Panel4: TPanel
        Left = 1
        Top = 1
        Width = 748
        Height = 100
        Align = alTop
        BevelKind = bkFlat
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 3
        DesignSize = (
          744
          96)
        object Label2: TLabel
          Left = 16
          Top = 14
          Width = 60
          Height = 20
          Caption = #36523#20221#35777#21495
        end
        object Label3: TLabel
          Left = 16
          Top = 58
          Width = 60
          Height = 20
          Caption = #20225#19994#21517#31216
        end
        object Label4: TLabel
          Left = 297
          Top = 14
          Width = 30
          Height = 20
          Caption = #24615#21035
        end
        object Label5: TLabel
          Left = 448
          Top = 14
          Width = 30
          Height = 20
          Caption = #24037#31181
        end
        object Edit1: TEdit
          Left = 80
          Top = 12
          Width = 209
          Height = 28
          Hint = '{"placeholder":"'#31934#30830#21305#37197'"}'
          TabOrder = 0
        end
        object Edit2: TEdit
          Left = 82
          Top = 56
          Width = 210
          Height = 28
          Hint = '{"placeholder":"'#31934#30830#21305#37197'"}'
          TabOrder = 1
        end
        object Edit4: TEdit
          Left = 498
          Top = 12
          Width = 207
          Height = 28
          Hint = '{"placeholder":"'#31934#30830#21305#37197'"}'
          TabOrder = 2
        end
        object ComboBox1: TComboBox
          Left = 342
          Top = 12
          Width = 84
          Height = 28
          TabOrder = 3
          Text = #35831#36873#25321
          Items.Strings = (
            #30007
            #22899)
        end
        object Button1: TButton
          Left = 637
          Top = 53
          Width = 90
          Height = 35
          Hint = '{"type":"primary"}'
          Anchors = [akTop, akRight]
          Caption = #26597#35810
          TabOrder = 4
        end
      end
      object Button2: TButton
        Left = 632
        Top = 139
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 4
      end
      object Button3: TButton
        Left = 682
        Top = 139
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 5
      end
      object Button4: TButton
        Left = 682
        Top = 173
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 6
      end
      object Button5: TButton
        Left = 632
        Top = 173
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 7
      end
      object Button6: TButton
        Left = 682
        Top = 208
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 8
      end
      object Button7: TButton
        Left = 632
        Top = 208
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 9
      end
      object Button8: TButton
        Left = 632
        Top = 242
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 10
      end
      object Button9: TButton
        Left = 682
        Top = 242
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 11
      end
      object Button10: TButton
        Left = 682
        Top = 277
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 12
      end
      object Button11: TButton
        Left = 632
        Top = 277
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 13
      end
      object Button12: TButton
        Left = 682
        Top = 311
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 14
      end
      object Button13: TButton
        Left = 632
        Top = 311
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 15
      end
      object Button14: TButton
        Left = 632
        Top = 346
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 16
      end
      object Button15: TButton
        Left = 682
        Top = 346
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 17
      end
      object Button16: TButton
        Left = 682
        Top = 380
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 18
      end
      object Button17: TButton
        Left = 632
        Top = 380
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 19
      end
      object Button18: TButton
        Left = 682
        Top = 415
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #32534#36753
        TabOrder = 20
      end
      object Button19: TButton
        Left = 632
        Top = 415
        Width = 50
        Height = 35
        Hint = '{"type":"text"}'
        Anchors = [akTop, akRight]
        Caption = #21024#38500
        TabOrder = 21
      end
    end
    object Panel_MenuBack: TPanel
      Left = 0
      Top = 0
      Width = 250
      Height = 580
      Align = alLeft
      BevelOuter = bvNone
      Color = 3484198
      ParentBackground = False
      TabOrder = 1
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1000
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Image2: TImage
      AlignWithMargins = True
      Left = 15
      Top = 3
      Width = 58
      Height = 54
      Hint = '{"src":"media/images/internet/1.jpg"}'
      Margins.Left = 15
      Align = alLeft
    end
    object Label1: TLabel
      AlignWithMargins = True
      Left = 91
      Top = 3
      Width = 534
      Height = 54
      Margins.Left = 15
      Align = alLeft
      AutoSize = False
      Caption = #21335#23433#30465#20114#32852#32593'+'#32844#19994#30149#38450#27835#19982#32844#19994#20581#24247#31649#29702#31995#32479
      Font.Charset = ANSI_CHARSET
      Font.Color = 6321236
      Font.Height = -24
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
    end
    object Button_Reset: TButton
      AlignWithMargins = True
      Left = 706
      Top = 13
      Width = 90
      Height = 35
      Hint = '{"type":"primary"}'
      Margins.Left = 0
      Margins.Top = 13
      Margins.Right = 20
      Margins.Bottom = 12
      Align = alRight
      Caption = #37325#32622
      TabOrder = 0
      OnClick = Button_ResetClick
    end
    object Edit_Keyword: TEdit
      AlignWithMargins = True
      Left = 819
      Top = 13
      Width = 121
      Height = 35
      Hint = '{"placeholder":"'#35831#36755#20837#20851#38190#23383'","borderradius":"3px 0 0 3px"}'
      Margins.Top = 13
      Margins.Right = 0
      Margins.Bottom = 12
      Align = alRight
      AutoSize = False
      TabOrder = 1
      Visible = False
    end
    object Button_Search: TButton
      AlignWithMargins = True
      Left = 940
      Top = 13
      Width = 40
      Height = 35
      Hint = 
        '{"type":"primary","icon":"el-icon-search","borderradius":"0 3px ' +
        '3px 0"}'
      Margins.Left = 0
      Margins.Top = 13
      Margins.Right = 20
      Margins.Bottom = 12
      Align = alRight
      TabOrder = 2
      Visible = False
      OnClick = Button_SearchClick
    end
  end
  object ADOQuery: TADOQuery
    Parameters = <>
    Left = 392
    Top = 128
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 85
    Top = 117
    object MenuItem2: TMenuItem
      Caption = #26426#26500#20449#24687#31649#29702
      Hint = '{"background-color":"rgb(38,42,53)"}'
      ImageIndex = 56
    end
    object MenuItem1: TMenuItem
      Caption = #20307#26816#25253#21578#31649#29702
      ImageIndex = 139
      object N2: TMenuItem
        Caption = #25253#21578#26597#35810
      end
      object N4: TMenuItem
        Caption = #25253#21578#23548#20986
      end
    end
    object MenuItem3: TMenuItem
      Caption = #26426#26500#22791#26696#31649#29702
      ImageIndex = 146
    end
    object N1: TMenuItem
      Caption = #32844#19994#30149#38450#27835#35843#26597#31649#29702
      ImageIndex = 187
    end
    object N3: TMenuItem
      Caption = #31995#32479#31649#29702
      ImageIndex = 6
      object N5: TMenuItem
        Caption = #25968#25454#22791#20221
      end
      object N6: TMenuItem
        Caption = #25968#25454#24674#22797
      end
    end
  end
end
