object Startmenue: TStartmenue
  Left = 0
  Top = 0
  Caption = 'Startmenue'
  ClientHeight = 174
  ClientWidth = 292
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object KISelect: TLabel
    Left = 56
    Top = 24
    Width = 39
    Height = 13
    Caption = 'KISelect'
  end
  object Detectiveanzahl: TLabel
    Left = 190
    Top = 24
    Width = 77
    Height = 13
    Caption = 'Detectiveanzahl'
  end
  object PlayerCount: TComboBox
    Left = 208
    Top = 72
    Width = 49
    Height = 21
    ItemIndex = 0
    TabOrder = 0
    Text = '3'
    Items.Strings = (
      '3'
      '4'
      '5')
  end
  object Abbrechen: TButton
    Left = 182
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Abbrechen'
    ModalResult = 3
    TabOrder = 1
  end
  object Start: TButton
    Left = 56
    Top = 120
    Width = 75
    Height = 25
    Caption = 'Start'
    ModalResult = 1
    TabOrder = 2
  end
  object MisterX: TCheckBox
    Left = 56
    Top = 56
    Width = 89
    Height = 17
    Caption = 'MisterX'
    TabOrder = 3
  end
  object Detective: TCheckBox
    Left = 56
    Top = 92
    Width = 89
    Height = 17
    Caption = 'Detective'
    TabOrder = 4
  end
end
