object Form1: TForm1
  Left = 0
  Top = 0
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  Caption = 'DeWeb - History'
  ClientHeight = 720
  ClientWidth = 762
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = 16448250
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 20
  object PC: TPageControl
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 722
    Height = 680
    HelpType = htKeyword
    HelpKeyword = 'timeline'
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Margins.Bottom = 20
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 0
    ExplicitLeft = 25
    ExplicitTop = 40
    ExplicitWidth = 289
    ExplicitHeight = 321
    object TabSheet1: TTabSheet
      Caption = 'TabSheet1'
      object Label1: TLabel
        Left = 64
        Top = 48
        Width = 48
        Height = 20
        Caption = 'Label1'
      end
      object Edit1: TEdit
        Left = 80
        Top = 112
        Width = 121
        Height = 28
        TabOrder = 0
        Text = 'Edit1'
      end
    end
    object TabSheet2: TTabSheet
      Hint = '{"height":300}'
      Caption = 'TabSheet2'
      object Button1: TButton
        Left = 38
        Top = 64
        Width = 50
        Height = 50
        Hint = '{"type":"primary","style":"circle"}'
        Caption = 'Button1'
        TabOrder = 0
        OnClick = Button1Click
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'TabSheet3'
      ImageIndex = 2
    end
    object TabSheet4: TTabSheet
      Caption = 'TabSheet4'
      ImageIndex = 3
    end
  end
end
