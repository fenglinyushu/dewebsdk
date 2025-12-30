object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 660
  ClientWidth = 650
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  TextHeight = 21
  object HeaderControl1: THeaderControl
    AlignWithMargins = True
    Left = 3
    Top = 20
    Width = 644
    Height = 40
    Margins.Top = 20
    Sections = <
      item
        ImageIndex = 55
        Text = #39318#39029
        Width = 100
      end
      item
        ImageIndex = 70
        Text = #25968#25454
        Width = 100
      end
      item
        ImageIndex = 71
        Text = #28040#24687
        Width = 100
      end
      item
        ImageIndex = 72
        Text = #35774#32622
        Width = 100
      end>
  end
  object HeaderControl2: THeaderControl
    AlignWithMargins = True
    Left = 3
    Top = 83
    Width = 644
    Height = 40
    Hint = 
      '{"activebold":1,"radius":"5px 5px 0 0","margin":5,"activecolor":' +
      '"#fff","activebk":"#88f","hotsize":0}'
    Margins.Top = 20
    Sections = <
      item
        ImageIndex = 55
        Text = #39318#39029
        Width = 100
      end
      item
        ImageIndex = 70
        Text = #25968#25454
        Width = 150
      end
      item
        ImageIndex = 71
        Text = #28040#24687
        Width = 100
      end
      item
        ImageIndex = 72
        Text = #35774#32622
        Width = 100
      end>
  end
  object HeaderControl3: THeaderControl
    AlignWithMargins = True
    Left = 3
    Top = 146
    Width = 644
    Height = 40
    Hint = 
      '{"mode":1,"activebold":1,"radius":"5px 5px 0 0","margin":5,"acti' +
      'vecolor":"#f00","hot":"#f00","activebk":"#fff","hotsize":2,"norm' +
      'albk":"#fff"}'
    Margins.Top = 20
    Sections = <
      item
        ImageIndex = 55
        Text = #39318#39029
        Width = 100
      end
      item
        ImageIndex = 70
        Text = #25968#25454
        Width = 150
      end
      item
        ImageIndex = 71
        Text = #28040#24687
        Width = 100
      end
      item
        ImageIndex = 72
        Text = #35774#32622
        Width = 100
      end>
    OnSectionClick = HeaderControl2SectionClick
  end
end
