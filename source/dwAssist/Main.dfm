object MainForm: TMainForm
  Left = 400
  Top = 250
  Caption = 'dwAssist'
  ClientHeight = 601
  ClientWidth = 1064
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Courier New'
  Font.Style = []
  Position = poMainFormCenter
  StyleName = 'Windows'
  OnCreate = FormCreate
  TextHeight = 16
  object Panel_Buttons: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 558
    Width = 1058
    Height = 40
    Hint = '{"type":"primary","radius":"5px 5px 0px 10px"}'
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 0
    object Shape_JSON: TShape
      AlignWithMargins = True
      Left = 10
      Top = 12
      Width = 20
      Height = 16
      Margins.Left = 10
      Margins.Top = 12
      Margins.Bottom = 12
      Align = alLeft
      Brush.Color = clLime
      Shape = stCircle
      ExplicitTop = 10
      ExplicitHeight = 20
    end
    object Label_JSON: TLabel
      Left = 33
      Top = 0
      Width = 94
      Height = 40
      Align = alLeft
      AutoSize = False
      Caption = 'not JSON'
      Layout = tlCenter
      ExplicitLeft = 30
    end
    object Button_SaveJson: TButton
      AlignWithMargins = True
      Left = 811
      Top = 5
      Width = 75
      Height = 30
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'OK'
      ModalResult = 1
      TabOrder = 0
      OnClick = Button_SaveJsonClick
    end
    object Button_Cancel: TButton
      AlignWithMargins = True
      Left = 973
      Top = 5
      Width = 75
      Height = 30
      Margins.Top = 5
      Margins.Right = 10
      Margins.Bottom = 5
      Align = alRight
      Caption = '&Cancel'
      ModalResult = 2
      TabOrder = 1
    end
    object Button_SaveText: TButton
      AlignWithMargins = True
      Left = 892
      Top = 5
      Width = 75
      Height = 30
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alRight
      Caption = 'Save'
      ModalResult = 1
      TabOrder = 2
    end
    object Button_Format: TButton
      AlignWithMargins = True
      Left = 130
      Top = 5
      Width = 75
      Height = 30
      Hint = 
        '{"backgroundcolor":"#FE5E08","radius":"5px","style":"plain","ico' +
        'n":"el-icon-delete-solid","type":"primary"}'
      Margins.Top = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = 'Format'
      TabOrder = 3
      OnClick = Button_FormatClick
    end
  end
  object Panel_Client: TPanel
    Left = 0
    Top = 0
    Width = 1064
    Height = 555
    Align = alClient
    BevelOuter = bvNone
    Caption = 'Panel_Client'
    Color = clWhite
    ParentBackground = False
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 529
      Top = 0
      Width = 8
      Height = 555
      Align = alRight
      ExplicitLeft = 372
      ExplicitHeight = 455
    end
    object PageControl1: TPageControl
      AlignWithMargins = True
      Left = 537
      Top = 3
      Width = 524
      Height = 549
      Margins.Left = 0
      Align = alRight
      MultiLine = True
      TabHeight = 30
      TabOrder = 0
    end
    object ListView1: TListView
      Left = 712
      Top = 145
      Width = 250
      Height = 150
      HelpType = htKeyword
      HelpKeyword = 'card'
      Columns = <
        item
        end>
      TabOrder = 1
      Visible = False
    end
    object RichEdit: TRichEdit
      Left = 0
      Top = 0
      Width = 529
      Height = 555
      Align = alClient
      Font.Charset = GB2312_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Courier New'
      Font.Style = []
      Lines.Strings = (
        '['
        '   {'
        '      "class" : "TBitBtn",'
        '      "items" : ['
        '         {'
        '            "name" : "type",'
        '            "type" : "type",'
        '            "hint" : "'#25353#38062#30340#26174#31034#26679#24335'"'
        '         },'
        '         {'
        '            "name" : "style",'
        '            "type" : "concat",'
        '            "items" : ['
        '               [ " plain", "'#26420#32032'" ],'
        '               [ " round", "'#22278#35282'" ],'
        '               [ " circle", "'#22278#24418'" ]'
        '            ]'
        '         },')
      ParentFont = False
      ScrollBars = ssBoth
      TabOrder = 2
      WantTabs = True
      WordWrap = False
      OnKeyPress = RichEditKeyPress
    end
  end
end
