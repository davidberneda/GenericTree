object GenericTree_Example: TGenericTree_Example
  Left = 0
  Top = 0
  Caption = 'GenericTree VCL Example'
  ClientHeight = 421
  ClientWidth = 501
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poOwnerFormCenter
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 360
    Top = 200
    Width = 43
    Height = 13
    Caption = 'Children:'
  end
  object LChildren: TLabel
    Left = 362
    Top = 219
    Width = 6
    Height = 13
    Caption = '0'
  end
  object TreeView1: TTreeView
    Left = 24
    Top = 40
    Width = 297
    Height = 329
    HideSelection = False
    Indent = 19
    TabOrder = 0
    OnChange = TreeView1Change
    OnEdited = TreeView1Edited
  end
  object BRemove: TButton
    Left = 360
    Top = 40
    Width = 75
    Height = 25
    Caption = '&Remove'
    Enabled = False
    TabOrder = 1
    OnClick = BRemoveClick
  end
  object EData: TEdit
    Left = 360
    Top = 88
    Width = 121
    Height = 21
    Enabled = False
    TabOrder = 2
    OnChange = EDataChange
  end
  object BUp: TButton
    Left = 360
    Top = 144
    Width = 33
    Height = 25
    Caption = '^'
    Enabled = False
    TabOrder = 3
    OnClick = BUpClick
  end
  object BDown: TButton
    Left = 399
    Top = 144
    Width = 33
    Height = 25
    Caption = 'v'
    Enabled = False
    TabOrder = 4
    OnClick = BDownClick
  end
  object BAdd: TButton
    Left = 357
    Top = 256
    Width = 78
    Height = 25
    Caption = '&Add New...'
    Enabled = False
    TabOrder = 5
    OnClick = BAddClick
  end
end
