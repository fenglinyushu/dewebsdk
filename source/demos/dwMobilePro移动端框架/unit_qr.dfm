object Form_qr: TForm_qr
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'QRcode Creator'
  ClientHeight = 674
  ClientWidth = 360
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 20
  object Image_qrcode: TImage
    Left = 0
    Top = 50
    Width = 360
    Height = 352
    Align = alTop
    ExplicitLeft = 2
    ExplicitTop = -6
    ExplicitWidth = 358
  end
  object Button1: TButton
    AlignWithMargins = True
    Left = 30
    Top = 521
    Width = 300
    Height = 45
    Hint = '{"type":"success"}'
    Margins.Left = 30
    Margins.Top = 30
    Margins.Right = 30
    Align = alTop
    Caption = 'Create'
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = Button1Click
    ExplicitTop = 536
  end
  object Memo1: TMemo
    Left = 0
    Top = 402
    Width = 360
    Height = 89
    Align = alTop
    Lines.Strings = (
      'https://delphibbs.com/dwMobilePro')
    TabOrder = 1
    ExplicitTop = 417
  end
  object PTitle: TPanel
    Left = 0
    Top = 0
    Width = 360
    Height = 50
    Align = alTop
    BevelOuter = bvNone
    Color = 16359209
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = #23435#20307
    Font.Style = []
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    ExplicitLeft = -40
    ExplicitWidth = 400
    object LTitle: TLabel
      AlignWithMargins = True
      Left = 50
      Top = 3
      Width = 260
      Height = 44
      Margins.Left = 0
      Margins.Right = 50
      Align = alClient
      Alignment = taCenter
      Caption = 'QRcode Creator '
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -20
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 159
      ExplicitHeight = 27
    end
    object B0: TButton
      Left = 0
      Top = 0
      Width = 50
      Height = 50
      Hint = 
        '{"type":"text","icon":"el-icon-arrow-left","onclick":"try{histor' +
        'y.back()}finally{};"}'
      Align = alLeft
      Cancel = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clWhite
      Font.Height = -23
      Font.Name = #24494#36719#38597#40657
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
  end
end
