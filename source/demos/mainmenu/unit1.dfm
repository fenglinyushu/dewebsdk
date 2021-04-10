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
    OwnerDraw = True
    Left = 397
    Top = 205
    object MenuItem1: TMenuItem
      Caption = #25991#20214
      ImageIndex = 1
      object N1: TMenuItem
        Caption = #26032#24314
        ImageIndex = 10
      end
      object N2: TMenuItem
        Caption = #25171#24320
        ImageIndex = 11
      end
      object N4: TMenuItem
        Caption = #21382#21490#35760#24405
        ImageIndex = 12
        object N5: TMenuItem
          Caption = #25968#25454#19968
          ImageIndex = 20
        end
        object N6: TMenuItem
          Caption = #25968#25454#20108
          ImageIndex = 21
        end
      end
    end
    object MenuItem2: TMenuItem
      Caption = #32534#36753
      ImageIndex = 2
    end
    object MenuItem3: TMenuItem
      Caption = #21024#38500
      ImageIndex = 3
    end
    object MenuItem4: TMenuItem
      Caption = #20445#23384
      ImageIndex = 4
    end
    object MenuItem5: TMenuItem
      Caption = #21462#28040
      ImageIndex = 5
    end
  end
end
