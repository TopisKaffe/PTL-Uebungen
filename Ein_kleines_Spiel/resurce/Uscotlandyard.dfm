object scotlandyard: Tscotlandyard
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = 'Scotlandyard'
  ClientHeight = 393
  ClientWidth = 645
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object board: TImage
    Left = 0
    Top = -1
    Width = 105
    Height = 105
    OnMouseDown = boardMouseDown
  end
  object black: TImage
    Left = 496
    Top = 48
    Width = 105
    Height = 105
  end
  object Itaxi: TImage
    Left = 504
    Top = 56
    Width = 105
    Height = 105
  end
  object Ibus: TImage
    Left = 512
    Top = 64
    Width = 105
    Height = 105
  end
  object Iunderground: TImage
    Left = 522
    Top = 72
    Width = 105
    Height = 105
  end
  object CurrentPlayer: TLabel
    Left = 496
    Top = 8
    Width = 67
    Height = 13
    Caption = 'CurrentPlayer'
  end
  object blackcount: TLabel
    Left = 423
    Top = 72
    Width = 67
    Height = 13
    Caption = 'CurrentPlayer'
  end
  object Itaxicount: TLabel
    Left = 423
    Top = 91
    Width = 67
    Height = 13
    Caption = 'CurrentPlayer'
  end
  object Ibuscount: TLabel
    Left = 423
    Top = 110
    Width = 67
    Height = 13
    Caption = 'CurrentPlayer'
  end
  object Iundergroundcount: TLabel
    Left = 423
    Top = 129
    Width = 67
    Height = 13
    Caption = 'CurrentPlayer'
  end
  object MoveTableIm: TImage
    Left = 504
    Top = 226
    Width = 105
    Height = 105
  end
  object LPosTargets: TLabel
    Left = 8
    Top = 376
    Width = 59
    Height = 13
    Caption = 'LPosTargets'
  end
  object MainMenu1: TMainMenu
    object Game: TMenuItem
      Caption = 'Spiel'
      object NewGame: TMenuItem
        Caption = 'Neu'
        OnClick = NewGameClick
      end
      object Open: TMenuItem
        Caption = #214'ffnen'
        OnClick = OpenClick
      end
      object Save: TMenuItem
        Caption = 'Speichern'
        OnClick = SaveClick
      end
      object Quit: TMenuItem
        Caption = 'Beenden'
        OnClick = QuitClick
      end
    end
    object Settings: TMenuItem
      Caption = 'Einstellungen'
      object showboard: TMenuItem
        Caption = 'Karte anzeigen'
        OnClick = showboardClick
      end
      object Stationmarker: TMenuItem
        Caption = 'Stationen markieren'
        OnClick = StationmarkerClick
      end
      object showMrx: TMenuItem
        Caption = 'Miter X anzeigen (Cheatmodus)'
        OnClick = showMrxClick
      end
      object showPosibleTargets: TMenuItem
        Caption = 'M'#246'gliche Zielpositionen anzeigen (Cheatmodus)'
        OnClick = showPosibleTargetsClick
      end
    end
  end
  object PopupVehicle: TPopupMenu
    Left = 240
    Top = 192
  end
  object SaveDialog: TSaveDialog
    Left = 312
    Top = 208
  end
  object OpenDialog: TOpenDialog
    Left = 376
    Top = 216
  end
end
