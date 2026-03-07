object frmLizenzdialog: TfrmLizenzdialog
  Left = 0
  Top = 0
  Caption = 'Lizenzdialog'
  ClientHeight = 521
  ClientWidth = 837
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poMainFormCenter
  OnShow = FormShow
  TextHeight = 15
  object Memo1: TMemo
    AlignWithMargins = True
    Left = 20
    Top = 20
    Width = 797
    Height = 405
    Margins.Left = 20
    Margins.Top = 20
    Margins.Right = 20
    Align = alClient
    ReadOnly = True
    ScrollBars = ssVertical
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 0
    Top = 428
    Width = 837
    Height = 93
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 1
    object cbLizenzGelesenUndAkzeptiert: TCheckBox
      AlignWithMargins = True
      Left = 20
      Top = 20
      Width = 797
      Height = 17
      Margins.Left = 20
      Margins.Top = 20
      Margins.Right = 20
      Align = alTop
      Caption = 
        'Ich habe die Lizenzbedingungen gelesen, verstanden und akzeptier' +
        'e diese.'
      TabOrder = 0
      OnClick = cbLizenzGelesenUndAkzeptiertClick
    end
    object btnLizenzDrucken: TButton
      AlignWithMargins = True
      Left = 358
      Top = 55
      Width = 108
      Height = 23
      Margins.Left = 10
      Margins.Top = 15
      Margins.Right = 5
      Margins.Bottom = 15
      Align = alLeft
      Caption = 'Lizenz &drucken...'
      TabOrder = 1
      WordWrap = True
      OnClick = btnLizenzDruckenClick
    end
    object btnLIzenzSpeichern: TButton
      AlignWithMargins = True
      Left = 226
      Top = 55
      Width = 119
      Height = 23
      Margins.Left = 10
      Margins.Top = 15
      Margins.Bottom = 15
      Align = alLeft
      Caption = 'Lizenz &speichern...'
      TabOrder = 2
      OnClick = btnLIzenzSpeichernClick
    end
    object btnBeenden: TButton
      AlignWithMargins = True
      Left = 20
      Top = 55
      Width = 193
      Height = 23
      Margins.Left = 20
      Margins.Top = 15
      Margins.Bottom = 15
      Align = alLeft
      Cancel = True
      Caption = '&Programm beenden'
      TabOrder = 3
      OnClick = btnBeendenClick
    end
    object btnLizenzAkzeptieren: TButton
      AlignWithMargins = True
      Left = 624
      Top = 55
      Width = 193
      Height = 23
      Margins.Left = 20
      Margins.Top = 15
      Margins.Right = 20
      Margins.Bottom = 15
      Align = alRight
      Caption = '&Lizenzbestimmungen akzeptieren'
      Default = True
      Enabled = False
      ModalResult = 1
      TabOrder = 4
    end
  end
  object ActionList1: TActionList
    Left = 8
    Top = 264
    object actLizenzSpeichern: TAction
      Caption = 'Lizenz speichern'
      ShortCut = 16467
      OnExecute = actLizenzSpeichernExecute
    end
    object actLizenzDrucken: TAction
      Caption = 'Lizenz drucken'
      ShortCut = 16464
      OnExecute = actLizenzDruckenExecute
    end
  end
end
