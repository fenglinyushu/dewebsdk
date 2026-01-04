object Form1: TForm1
  Left = 191
  Top = 60
  HelpType = htKeyword
  BorderStyle = bsNone
  ClientHeight = 583
  ClientWidth = 1157
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnContextPopup = FormContextPopup
  TextHeight = 20
  object Label1: TLabel
    Left = 8
    Top = 90
    Width = 321
    Height = 175
    AutoSize = False
    Caption = 
      '<input  id="data" style="position:absolute;left:60px;top:20px;wi' +
      'dth:180px;height:35px;" type='#8221'text'#8221'   value=My'#20013'123%'#65509'Value />'#13'<bu' +
      'tton style="position:absolute;left:60px;top:100px;width:188px;he' +
      'ight:40px;" onclick="dwSetVar(document.getElementById('#39'data'#39').va' +
      'lue);">Set Var</button>'
    Color = clAqua
    ParentColor = False
    Transparent = False
    WordWrap = True
  end
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 1157
    Height = 50
    HelpType = htKeyword
    HelpKeyword = 'simple'
    Align = alTop
    BevelOuter = bvNone
    Color = 16742167
    ParentBackground = False
    TabOrder = 0
    object Label2: TLabel
      AlignWithMargins = True
      Left = 71
      Top = 3
      Width = 310
      Height = 42
      Margins.Left = 10
      Margins.Bottom = 5
      Align = alLeft
      AutoSize = False
      Caption = 'Set Var By Javascript'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindow
      Font.Height = -27
      Font.Name = 'Verdana'
      Font.Style = [fsBold, fsItalic]
      ParentFont = False
      Layout = tlCenter
      ExplicitLeft = 3
      ExplicitHeight = 44
    end
    object Im: TImage
      AlignWithMargins = True
      Left = 10
      Top = 3
      Width = 48
      Height = 44
      Hint = '{"src":"media/images/s2c/logo1.png"}'
      Margins.Left = 10
      Align = alLeft
    end
  end
end
