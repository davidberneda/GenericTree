object QuickSortCompare: TQuickSortCompare
  Left = 0
  Top = 0
  Caption = 'QuickSort Algorithm Comparison'
  ClientHeight = 366
  ClientWidth = 418
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 128
    Top = 29
    Width = 82
    Height = 13
    Caption = 'Number of items:'
  end
  object Button1: TButton
    Left = 24
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ECount: TEdit
    Left = 216
    Top = 26
    Width = 81
    Height = 21
    TabOrder = 1
    Text = '1000000'
  end
  object Memo1: TMemo
    Left = 25
    Top = 72
    Width = 360
    Height = 265
    ScrollBars = ssBoth
    TabOrder = 2
    WordWrap = False
  end
end
