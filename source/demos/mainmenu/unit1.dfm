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
  end
end
