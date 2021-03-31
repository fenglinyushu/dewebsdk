object Form1: TForm1
  Left = 0
  Top = 0
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 548
  ClientWidth = 998
  Color = clWhite
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OldCreateOrder = False
  Position = poDesigned
  PixelsPerInch = 96
  TextHeight = 20
  object PageControl1: TPageControl
    Left = 32
    Top = 16
    Width = 289
    Height = 153
    ActivePage = TabSheet1
    TabOrder = 0
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet2: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object PageControl2: TPageControl
    Left = 32
    Top = 376
    Width = 289
    Height = 153
    ActivePage = TabSheet3
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    TabOrder = 1
    object TabSheet3: TTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object PageControl3: TPageControl
    Left = 32
    Top = 200
    Width = 289
    Height = 153
    ActivePage = TabSheet5
    BiDiMode = bdLeftToRight
    MultiLine = True
    ParentBiDiMode = False
    TabOrder = 2
    TabPosition = tpLeft
    object TabSheet5: TTabSheet
      Caption = #25511#21046#31995#32479
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet6: TTabSheet
      Caption = #31070#32463#32593#32476
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object PageControl4: TPageControl
    Left = 352
    Top = 8
    Width = 289
    Height = 521
    ActivePage = TabSheet7
    BiDiMode = bdLeftToRight
    MultiLine = True
    ParentBiDiMode = False
    TabOrder = 3
    TabPosition = tpLeft
    object TabSheet7: TTabSheet
      Caption = 'TabSheet1'
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
    object TabSheet8: TTabSheet
      Caption = 'TabSheet2'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
    end
  end
  object Timer1: TTimer
    Interval = 100
    OnTimer = Timer1Timer
    Left = 328
    Top = 360
  end
end
