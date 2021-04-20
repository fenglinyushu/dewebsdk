object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb'
  ClientHeight = 770
  ClientWidth = 590
  Color = clWhite
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  Position = poDesigned
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 20
  object Button1: TButton
    Left = 192
    Top = 104
    Width = 97
    Height = 41
    Caption = #25240#21472'/'#23637#24320
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 192
    Top = 151
    Width = 97
    Height = 41
    Caption = #26174#31034
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 192
    Top = 198
    Width = 97
    Height = 43
    Caption = #38544#34255
    TabOrder = 2
    OnClick = Button3Click
  end
  object MainMenu: TMainMenu
    AutoHotkeys = maManual
    Left = 501
    Top = 125
    object MenuItem_Add: TMenuItem
      Caption = #22686#21152
      ImageIndex = 100
    end
    object MenuItem_Edit: TMenuItem
      Caption = #32534#36753
      ImageIndex = 111
    end
    object MenuItem_Delete: TMenuItem
      Caption = #21024#38500
      ImageIndex = 112
    end
    object MenuItem_Save: TMenuItem
      Caption = #20445#23384
      ImageIndex = 113
    end
    object MenuItem_Cancel: TMenuItem
      Caption = #21462#28040
      ImageIndex = 114
    end
  end
  object MainMenu1: TMainMenu
    AutoHotkeys = maManual
    BiDiMode = bdLeftToRight
    ParentBiDiMode = False
    Left = 85
    Top = 117
    object MenuItem2: TMenuItem
      Caption = #31995#32479#21442#25968
      ImageIndex = 2
      object N3: TMenuItem
        Caption = #25171#24320
      end
    end
    object MenuItem1: TMenuItem
      Caption = #24179#21488#25509#21475
      ImageIndex = 1
      object N2: TMenuItem
        Caption = #25903#20184#23453#25509#21475
        ImageIndex = 31
      end
      object N4: TMenuItem
        Caption = #24494#20449#25509#21475
        ImageIndex = 32
      end
      object N1: TMenuItem
        Caption = #38134#34892#25509#21475
        ImageIndex = 33
      end
    end
    object MenuItem3: TMenuItem
      Caption = #25968#25454#31649#29702
      ImageIndex = 34
    end
    object N5: TMenuItem
      Caption = #25968#25454#32500#25252
      ImageIndex = 121
      object N6: TMenuItem
        Caption = #23548#20837
        ImageIndex = 122
      end
      object N7: TMenuItem
        Caption = #23548#20986
        ImageIndex = 123
      end
    end
    object N8: TMenuItem
      Caption = #31995#32479#35774#32622
      ImageIndex = 130
      object N9: TMenuItem
        Caption = #25968#25454#38480#21046
      end
    end
  end
end
