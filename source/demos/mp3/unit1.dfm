object Form1: TForm1
  Left = 0
  Top = 30
  Hint = '{"type":"primary"}'
  BorderStyle = bsNone
  BorderWidth = 5
  Caption = 'DeWeb - Mp3 player'
  ClientHeight = 558
  ClientWidth = 350
  Color = clWhite
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
  object Panel_Full: TPanel
    Left = 0
    Top = 0
    Width = 350
    Height = 558
    Align = alClient
    BevelOuter = bvNone
    Color = clWhite
    ParentBackground = False
    TabOrder = 0
    DesignSize = (
      350
      558)
    object Label_Name: TLabel
      Left = 0
      Top = 0
      Width = 350
      Height = 65
      Align = alTop
      Alignment = taCenter
      AutoSize = False
      Caption = #22812#30340#38050#29748#26354
      Font.Charset = ANSI_CHARSET
      Font.Color = 6579300
      Font.Height = -19
      Font.Name = #24494#36719#38597#40657
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitTop = -6
    end
    object MediaPlayer1: TMediaPlayer
      Left = 0
      Top = 65
      Width = 350
      Height = 47
      HelpType = htKeyword
      HelpKeyword = 'mp3'
      Align = alTop
      EnabledButtons = []
      AutoRewind = False
      DoubleBuffered = True
      FileName = 'media/audio/'#22812#30340#38050#29748#26354'.mp3'
      ParentDoubleBuffered = False
      TabOrder = 0
      ExplicitWidth = 343
    end
    object ScrollBox1: TScrollBox
      Left = 0
      Top = 112
      Width = 350
      Height = 446
      VertScrollBar.Visible = False
      Align = alClient
      TabOrder = 1
      object Panel_Buttons: TPanel
        AlignWithMargins = True
        Left = 3
        Top = 3
        Width = 340
        Height = 257
        Align = alTop
        AutoSize = True
        BevelOuter = bvNone
        Color = clWhite
        ParentBackground = False
        TabOrder = 0
        object Button_Audio: TButton
          AlignWithMargins = True
          Left = 10
          Top = 3
          Width = 320
          Height = 34
          Hint = '{"type":"primary"}'
          Margins.Left = 10
          Margins.Right = 10
          Align = alTop
          Caption = '2021.WAV'
          TabOrder = 0
          OnClick = Button_AudioClick
          ExplicitLeft = 14
          ExplicitTop = 1
        end
        object FileListBox_Audio: TFileListBox
          Left = 80
          Top = 112
          Width = 217
          Height = 145
          ItemHeight = 20
          Mask = '*.mp3;*.wav'
          TabOrder = 1
        end
      end
    end
    object BitBtn_Upload: TBitBtn
      Left = 303
      Top = 13
      Width = 36
      Height = 36
      Hint = 
        '{"icon":"el-icon-upload","fontsize":"18px","style":"circle","acc' +
        'ept":".mp3,.wav","auto":1}'
      Anchors = [akTop, akRight]
      TabOrder = 2
      OnEndDock = BitBtn_UploadEndDock
    end
  end
end
