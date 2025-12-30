object Form1: TForm1
  Left = 0
  Top = 0
  VertScrollBar.Visible = False
  AlphaBlend = True
  BorderStyle = bsNone
  Caption = 'DeWeb'
  ClientHeight = 640
  ClientWidth = 1000
  Color = clWhite
  TransparentColor = True
  TransparentColorValue = clWhite
  Font.Charset = ANSI_CHARSET
  Font.Color = clWindowText
  Font.Height = -16
  Font.Name = #24494#36719#38597#40657
  Font.Style = []
  Position = poDesigned
  OnMouseUp = FormMouseUp
  OnShow = FormShow
  TextHeight = 21
  object Me1: TMemo
    Left = 0
    Top = 0
    Width = 1000
    Height = 640
    HelpType = htKeyword
    HelpKeyword = 'markdown'
    Align = alClient
    BiDiMode = bdLeftToRight
    Lines.Strings = (
      '[TOC]'
      '#### Disabled options'
      ''
      '- TeX (Based on KaTeX);'
      '- Emoji;'
      '- Task lists;'
      '- HTML tags decode;'
      '- Flowchart and Sequence Diagram;'
      ''
      '#### Editor.md directory'
      ''
      '    editor.md/'
      '            lib/'
      '            css/'
      '            scss/'
      '            tests/'
      '            fonts/'
      '            images/'
      '            plugins/'
      '            examples/'
      '            languages/     '
      '            editormd.js'
      '            ...'
      ''
      '```html'
      '&lt;!-- English --&gt;'
      '&lt;script src="../dist/js/languages/en.js"&gt;&lt;/script&gt;'
      ''
      '&lt;!-- '#32321#39636#20013#25991' --&gt;'
      
        '&lt;script src="../dist/js/languages/zh-tw.js"&gt;&lt;/script&gt' +
        ';'
      '```')
    ParentBiDiMode = False
    ParentShowHint = False
    ShowHint = True
    TabOrder = 0
  end
end
