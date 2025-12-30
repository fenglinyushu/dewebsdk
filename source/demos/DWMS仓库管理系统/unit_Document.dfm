object Form_Document: TForm_Document
  Left = 0
  Top = 0
  HelpType = htKeyword
  HelpKeyword = 'embed'
  BorderStyle = bsNone
  Caption = #36164#26009#31649#29702
  ClientHeight = 657
  ClientWidth = 1063
  Color = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -15
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnEndDock = FormEndDock
  OnShow = FormShow
  TextHeight = 20
  object Pn1: TPanel
    Left = 0
    Top = 0
    Width = 1063
    Height = 657
    Hint = 
      '{"table":"eDocument","border":0,"new":0,"pagesize":10,"defaultqu' +
      'erymode":1,"fields":[{"name":"dFileName","caption":"'#25991#20214#21517'","query"' +
      ':1,"sort":1,"width":300},{"name":"dUserName","caption":"'#19978#20256#29992#25143'","q' +
      'uery":1,"sort":1,"dbfilter":1,"width":120},{"name":"dMode","type' +
      '":"combo","caption":"'#26435#38480'","query":1,"sort":1,"dbfilter":1,"list":' +
      '["'#20844#24320'","'#31169#23494'"],"width":100},{"name":"dFileType","type":"combo","cap' +
      'tion":"'#25991#20214#31867#22411'","query":1,"sort":1,"dbfilter":1,"list":["normal","d' +
      'oc/docx","xls/xlsx","ppt/pptx","pdf","jpg","txt","mp3","mp4"],"w' +
      'idth":120},{"name":"dDate","type":"datetime","caption":"'#19978#20256#26102#38388'","s' +
      'ort":1,"width":180},{"name":"dRemark","caption":"'#22791#27880'","query":1,"' +
      'sort":1,"width":100}]}'
    Align = alClient
    Color = clWhite
    ParentBackground = False
    TabOrder = 2
  end
  object BUd: TButton
    AlignWithMargins = True
    Left = 558
    Top = 172
    Width = 75
    Height = 32
    Hint = '{"type":"primary","icon":"el-icon-upload"}'
    Margins.Left = 1
    Margins.Top = 11
    Margins.Right = 0
    Margins.Bottom = 10
    Caption = #19978#20256
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    OnClick = BUdClick
  end
  object BPr: TButton
    AlignWithMargins = True
    Left = 646
    Top = 172
    Width = 75
    Height = 32
    Hint = '{"type":"info","icon":"el-icon-picture"}'
    Margins.Left = 1
    Margins.Top = 11
    Margins.Right = 0
    Margins.Bottom = 10
    Caption = #39044#35272
    Font.Charset = ANSI_CHARSET
    Font.Color = clWhite
    Font.Height = -15
    Font.Name = #24494#36719#38597#40657
    Font.Style = []
    ParentFont = False
    TabOrder = 1
    OnClick = BPrClick
  end
  object FDQuery1: TFDQuery
    Left = 344
    Top = 72
  end
end
