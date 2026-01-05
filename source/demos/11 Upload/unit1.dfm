object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb Upload'
  ClientHeight = 558
  ClientWidth = 917
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnEndDock = FormEndDock
  OnMouseUp = FormMouseUp
  OnStartDock = FormStartDock
  TextHeight = 21
  object Label1: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 233
    Width = 897
    Height = 21
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alBottom
    Caption = 'Accept ('#25991#20214#19978#20256#36827#34892#25552#20132#30340#25991#20214#31867#22411')'
    ExplicitWidth = 275
  end
  object Label3: TLabel
    AlignWithMargins = True
    Left = 10
    Top = 323
    Width = 897
    Height = 21
    Margins.Left = 10
    Margins.Top = 20
    Margins.Right = 10
    Margins.Bottom = 0
    Align = alBottom
    Caption = #19978#20256#25991#20214#30446#24405
    ExplicitWidth = 96
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 10
    Top = 403
    Width = 897
    Height = 35
    Hint = '{"type":"success"}'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    Caption = 'Upload'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
  end
  object Edit_Dir: TEdit
    AlignWithMargins = True
    Left = 10
    Top = 354
    Width = 897
    Height = 29
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    TabOrder = 1
    Text = 'MyDir'
  end
  object Panel_Title: TPanel
    Left = 0
    Top = 0
    Width = 917
    Height = 213
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
    object Memo1: TMemo
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 897
      Height = 207
      HelpType = htKeyword
      HelpKeyword = 'html'
      Margins.Left = 10
      Margins.Right = 10
      Align = alClient
      Lines.Strings = (
        '<b>dwUpload'#20989#25968'</b><hr>'
        #21442#25968':'
        '<li>AForm : '#31383#20307#26412#36523#65292#19968#33324#29992'self</li>'
        '<li>AAccept : '#25991#20214#19978#20256#31867#22411#25511#21046#65292#31867#20284'"image/gif, image/jpeg"</li>'
        '<li>ADestDir : '#19978#20256#30446#24405#65292#20026#31354#26102#19978#20256#21040#26381#21153#22120'upload'#30446#24405#65292#26377#20540#26102#19978#20256#21040#25351#23450#30446#24405#65292#25903#25345#23376#30446#24405'</li>'
        #20107#20214':<br>'
        #24320#22987#19978#20256#26102#65292#33258#21160#35302#21457#31383#20307#30340'OnStartDock'#20107#20214'<br>'
        #19978#20256#23436#25104#21518#65292#33258#21160#35302#21457#31383#20307#30340'OnEndDock'#20107#20214'<br>'
        #20107#20214':<br>'
        
          #21487#20197#36890#36807'dwGetProp(self,'#39'__upload'#39')'#24471#21040#19978#20256#25104#21151#30340#30495#23454#25991#20214#21517#65288#22914#26524#21516#21517#25991#20214#23384#22312#65292#21017#20250#33258#21160#37325#21629#21517#65289#65292#19981#24102#36335 +
          #24452
        #22914#26524#22312#24377#20986#24335#31383#20307#20013#65292#21017#20351#29992#31867#20284#20197#19979#30340#20195#30721'<br>'
        'dwGetProp(TForm(self.Parent),'#39'__upload'#39');<br>'
        #21487#20197#36890#36807'dwGetProp(self,'#39'__uploadsource'#39')'#24471#21040#19978#20256#26102#21407#22987#25991#20214#21517#65292#19981#24102#36335#24452)
      ScrollBars = ssBoth
      TabOrder = 0
    end
  end
  object ComboBox_Accept: TComboBox
    AlignWithMargins = True
    Left = 10
    Top = 264
    Width = 897
    Height = 29
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    Style = csDropDownList
    ItemIndex = 0
    TabOrder = 3
    Text = 'image/*'
    Items.Strings = (
      'image/*'
      'video/*'
      'image/gif, image/jpeg'
      '.doc,.docx,.xls,.xlsx,.pdf'
      'application/msword'
      'application/pdf'
      'application/poscript'
      'application/rtf'
      'application/x-zip-compressed'
      'audio/basic'
      'audio/x-aiff'
      'audio/x-mpeg'
      'audio/x-pn/realaudio'
      'audio/x-waw'
      'image/gif'
      'image/jpeg'
      'image/tiff'
      'image/x-ms-bmp'
      'image/x-photo-cd'
      '.dll')
  end
  object Button2: TButton
    AlignWithMargins = True
    Left = 10
    Top = 458
    Width = 897
    Height = 35
    Hint = '{"type":"success"}'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    Caption = 'Upload multiple'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 4
    OnClick = Button2Click
  end
  object Panel1: TPanel
    Left = 552
    Top = 355
    Width = 73
    Height = 41
    Caption = 'Panel1'
    TabOrder = 5
    OnEndDock = Panel1EndDock
    OnStartDock = Panel1StartDock
  end
  object Button3: TButton
    AlignWithMargins = True
    Left = 10
    Top = 513
    Width = 897
    Height = 35
    Hint = '{"type":"success"}'
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alBottom
    Caption = 'Upload Customize trigger'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindow
    Font.Height = -16
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 6
    OnClick = Button3Click
  end
end
