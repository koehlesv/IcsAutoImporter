object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'ICS-Datei automatisch importieren'
  ClientHeight = 445
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object pnlSourceType: TPanel
    Left = 0
    Top = 33
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lblSourceType: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 9
      Width = 56
      Height = 21
      Margins.Left = 10
      Margins.Top = 9
      Align = alLeft
      Caption = 'Importtyp:'
      ExplicitHeight = 15
    end
    object cbxSourceType: TComboBox
      AlignWithMargins = True
      Left = 159
      Top = 3
      Width = 423
      Height = 23
      Margins.Right = 10
      Align = alRight
      ItemIndex = 0
      TabOrder = 0
      Text = 'Dateisystem'
      OnChange = cbxSourceTypeChange
      Items.Strings = (
        'Dateisystem'
        'SVN'
        'Git')
    end
  end
  object pnlDateinamUndPfad: TPanel
    Left = 0
    Top = 66
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 1
    object lblDateinameUndPfad: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 60
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Dateiname:'
      ExplicitHeight = 15
    end
    object edtFileName: TEdit
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 399
      Height = 23
      Margins.Top = 7
      Align = alRight
      TabOrder = 0
      TextHint = 'Dateiname und -pfad'
    end
    object btnChoosFilePath: TButton
      AlignWithMargins = True
      Left = 564
      Top = 7
      Width = 18
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      Caption = '&...'
      TabOrder = 1
      OnClick = btnChoosFilePathClick
    end
  end
  object pnlVcsSourcePath: TPanel
    Left = 0
    Top = 99
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 2
    object lblVcsSourcePath: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 79
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Quellpfad VCS:'
      ExplicitHeight = 15
    end
    object edtVcsSourcePath: TEdit
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 423
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      TabOrder = 0
      TextHint = 'Quellpfad Versionierungssystem'
    end
  end
  object pnlVcsDestPath: TPanel
    Left = 0
    Top = 132
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 3
    object lblVcsDestPath: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 127
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Zielpfad VCS (Optional):'
      ExplicitHeight = 15
    end
    object edtVcsDestPath: TEdit
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 423
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      TabOrder = 0
      TextHint = 'Zielpfad auf dem Dateisystem (leerer Ordner, Optional)'
    end
  end
  object pnlRepoPath: TPanel
    Left = 0
    Top = 165
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 4
    object lblRepoPath: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 110
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Pfad zum Zielordner:'
      ExplicitHeight = 15
    end
    object edtRepoPath: TEdit
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 423
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      TabOrder = 0
      TextHint = 'Pfad im Versionierungssystem, z. B.: /Unterordner1/IcsOrdner'
      OnExit = edtRepoPathExit
    end
  end
  object pnlRepoName: TPanel
    Left = 0
    Top = 198
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 5
    object lblRepoName: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 91
      Height = 20
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Name des Repos:'
      ExplicitHeight = 15
    end
    object edtRepoName: TEdit
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 423
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      TabOrder = 0
    end
  end
  object pnlSaveDataAt: TPanel
    Left = 0
    Top = 231
    Width = 592
    Height = 35
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 6
    object lblSpeicherortAlreadyImportedFiles: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 136
      Height = 22
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Persistenter Speicherpfad:'
      ExplicitHeight = 15
    end
    object cbxSaveDataAt: TComboBox
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 423
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      ItemIndex = 1
      TabOrder = 0
      Text = 'Bernutzerdefinierter Ordner (AppData/Roaming)'
      Items.Strings = (
        'Ausf'#252'hrungsverzeichnis des Programmes'
        'Bernutzerdefinierter Ordner (AppData/Roaming)'
        'Tempor'#228'res Verzeichnis')
    end
  end
  object pnlButttons: TPanel
    Left = 0
    Top = 405
    Width = 592
    Height = 40
    Align = alBottom
    BevelOuter = bvNone
    TabOrder = 11
    ExplicitTop = 376
    object btnDoImport: TButton
      AlignWithMargins = True
      Left = 10
      Top = 7
      Width = 127
      Height = 26
      Margins.Left = 10
      Margins.Top = 7
      Margins.Right = 10
      Margins.Bottom = 7
      Align = alLeft
      Caption = 'ICS-Datei &importieren'
      Default = True
      TabOrder = 0
      OnClick = btnDoImportClick
    end
    object btnClose: TButton
      AlignWithMargins = True
      Left = 507
      Top = 7
      Width = 75
      Height = 26
      Margins.Left = 10
      Margins.Top = 7
      Margins.Right = 10
      Margins.Bottom = 7
      Align = alRight
      Cancel = True
      Caption = '&Schlie'#223'en'
      TabOrder = 1
      OnClick = btnCloseClick
    end
  end
  object pnlPfadKonfigOrdner: TPanel
    Left = 0
    Top = 266
    Width = 592
    Height = 35
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 7
    object lblPfadKonfigOrdner: TLabel
      AlignWithMargins = True
      Left = 10
      Top = 10
      Width = 140
      Height = 22
      Margins.Left = 10
      Margins.Top = 10
      Align = alLeft
      Caption = 'Konfigurationsspeicherort:'
      ExplicitHeight = 15
    end
    object cbxKfgDatSpeicherort: TComboBox
      AlignWithMargins = True
      Left = 159
      Top = 7
      Width = 423
      Height = 23
      Margins.Top = 7
      Margins.Right = 10
      Align = alRight
      TabOrder = 0
      Text = 'Bernutzerdefinierter Ordner (AppData/Roaming)'
      Items.Strings = (
        'Ausf'#252'hrungsverzeichnis des Programmes'
        'Bernutzerdefinierter Ordner (AppData/Roaming)'
        'Tempor'#228'res Verzeichnis (nicht empfohlen)')
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 336
    Width = 592
    Height = 35
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 9
    object cbDialogNichtMehrAnzeigen: TCheckBox
      Left = 159
      Top = 0
      Width = 433
      Height = 35
      Align = alRight
      Caption = 'Dialogfenster beim n'#228'chsten Start unterdr'#252'cken.'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
  end
  object Panel1: TPanel
    Left = 0
    Top = 301
    Width = 592
    Height = 35
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 8
    object cbNurAktuelleDatenBehalten: TCheckBox
      Left = 159
      Top = 0
      Width = 433
      Height = 35
      Align = alRight
      Caption = 'Nur ICS-Daten aus der aktuellen Datei zum Vergleich abspeichern.'
      TabOrder = 0
    end
  end
  object Panel3: TPanel
    Left = 0
    Top = 371
    Width = 592
    Height = 35
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 10
    object cbWarteAufFertigstellungIcsImport: TCheckBox
      Left = 159
      Top = 0
      Width = 433
      Height = 35
      Align = alRight
      Caption = 'Auf Fertigstellung des ICS-Imports warten (nicht empfohlen).'
      TabOrder = 0
    end
  end
  object pnlHelp: TPanel
    Left = 0
    Top = 0
    Width = 592
    Height = 33
    Margins.Top = 7
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 12
    object btnHelp: TButton
      AlignWithMargins = True
      Left = 5
      Top = 5
      Width = 15
      Height = 23
      Margins.Left = 5
      Margins.Top = 5
      Margins.Right = 5
      Margins.Bottom = 5
      Align = alLeft
      Caption = '&?'
      TabOrder = 0
      OnClick = btnHelpClick
    end
  end
  object ActionList1: TActionList
    Left = 32
    Top = 320
    object actShowHelpDlg: TAction
      Caption = 'Hilfedialog anzeigen'
      ShortCut = 112
      OnExecute = actShowHelpDlgExecute
    end
  end
end
