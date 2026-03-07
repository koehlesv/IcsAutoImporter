unit MainFrm;

{$Include Direktiven.inc}

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Importer,
  GlobalObjectHolder, System.Actions, Vcl.ActnList, LizenzdialogFrm;

type
  TfrmMain = class(TForm)
    cbxSourceType: TComboBox;
    edtFileName: TEdit;
    btnChoosFilePath: TButton;
    edtVcsSourcePath: TEdit;
    edtVcsDestPath: TEdit;
    edtRepoPath: TEdit;
    edtRepoName: TEdit;
    cbxSaveDataAt: TComboBox;
    cbDialogNichtMehrAnzeigen: TCheckBox;
    cbNurAktuelleDatenBehalten: TCheckBox;
    lblSourceType: TLabel;
    pnlSourceType: TPanel;
    pnlDateinamUndPfad: TPanel;
    lblDateinameUndPfad: TLabel;
    pnlVcsSourcePath: TPanel;
    lblVcsSourcePath: TLabel;
    pnlVcsDestPath: TPanel;
    lblVcsDestPath: TLabel;
    pnlRepoPath: TPanel;
    lblRepoPath: TLabel;
    pnlRepoName: TPanel;
    lblRepoName: TLabel;
    pnlSaveDataAt: TPanel;
    lblSpeicherortAlreadyImportedFiles: TLabel;
    pnlButttons: TPanel;
    btnDoImport: TButton;
    pnlPfadKonfigOrdner: TPanel;
    lblPfadKonfigOrdner: TLabel;
    cbxKfgDatSpeicherort: TComboBox;
    Panel2: TPanel;
    Panel1: TPanel;
    Panel3: TPanel;
    cbWarteAufFertigstellungIcsImport: TCheckBox;
    pnlHelp: TPanel;
    btnClose: TButton;
    btnHelp: TButton;
    ActionList1: TActionList;
    actShowHelpDlg: TAction;
    procedure cbxSourceTypeChange(Sender: TObject);
    procedure btnChoosFilePathClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnDoImportClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edtRepoPathExit(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnHelpClick(Sender: TObject);
    procedure actShowHelpDlgExecute(Sender: TObject);
  private
    { Private-Deklarationen }
    FRealPath: string;
    procedure UpdateVisibility();
    procedure ShowHelpDlg();
    function GetSaveCfgPath(): string;
    function GetSaveIcsFilePath(): string;
  public
    { Public-Deklarationen }
    procedure PresetValues(ALoadType: TLoadType;
      const APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
      ARepoName, APathToSubfolder: string; AKeepOldValues, AWaitForIcsImportTermination: Boolean);
  end;

const
  cNameKfgFile = 'IcsAutoImporter.cfg';
  cCurrentDir = 0;
  cHomeDir = 1;
  cTempDir = 2;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses Vcl.FileCtrl, System.IOUtils, LoadHomeDirectory, StrUtils,
  SaveFileHelper, System.UITypes;

procedure TfrmMain.actShowHelpDlgExecute(Sender: TObject);
begin
  ShowHelpDlg();
end;

procedure TfrmMain.btnChoosFilePathClick(Sender: TObject);
//const
//  cHelpCtx = 1000;
var
  OpenDlg: TOpenDialog;
//  ResultDir: string;
begin
  if cbxSourceType.ItemIndex = Ord(ltFile) then
  begin
    OpenDlg := TOpenDialog.Create(nil);
    try
      OpenDlg.Filter := 'ICS-Dateien (*.ics)|*.ics|Alle Dateien (*.*)|*.*';
      if OpenDlg.Execute(0) then
        edtFileName.Text := OpenDlg.FileName;
    finally
      OpenDlg.Free;
    end;
  end;
  {else
  begin
    ResultDir := GetCurrentDir();
    if SelectDirectory(ResultDir, [sdAllowCreate, sdPerformCreate], cHelpCtx) then
      edtFileName.Text := ResultDir;
  end;}
end;

procedure TfrmMain.btnCloseClick(Sender: TObject);
begin
  Self.Close;
end;

procedure TfrmMain.btnDoImportClick(Sender: TObject);
var
  Importer: TImporter;
  VcsDestPath: string;
begin
  VcsDestPath := edtVcsDestPath.Text;
  if VcsDestPath = '' then
  begin
    VcsDestPath := TPath.GetTempPath + TImportHelper.GetTimedFileName('');
  end;
  Importer := TImporter.Create;
  try
    Importer.DoImport(TLoadType(cbxSourceType.ItemIndex), edtFileName.Text, GetSaveIcsFilePath(), edtVcsSourcePath.Text,
      VcsDestPath, edtRepoName.Text, edtRepoPath.Text, not cbNurAktuelleDatenBehalten.Checked, cbWarteAufFertigstellungIcsImport.Checked);
  finally
    Importer.Free;
  end;
  {$IFNDEF NOOPENOFCREATEDICS}
  MessageDlg('Die Aktion war erfolgreich!', TMsgDlgType.mtInformation, [mbClose], 0);
  {$ELSE}
  MessageDlg('Da eine entsprechende Compilerdirektive aktiv ist, wurde die ics-Datei nicht geöffnet.', TMsgDlgType.mtInformation, [mbClose], 0);
  {$ENDIF}
end;

procedure TfrmMain.btnHelpClick(Sender: TObject);
begin
  ShowHelpDlg();
end;

procedure TfrmMain.cbxSourceTypeChange(Sender: TObject);
begin
  if cbxSourceType.ItemIndex = Ord(ltFile) then
  begin
    edtFileName.TextHint := 'Dateiname und -pfad';
    btnChoosFilePath.Enabled := True;
  end
  else
  begin
    edtFileName.TextHint := 'Dateiname';
    btnChoosFilePath.Enabled := False;
  end;
  UpdateVisibility();
end;

procedure TfrmMain.edtRepoPathExit(Sender: TObject);
var
 Position: Integer;
begin
  if edtRepoName.Text = '' then
  begin
    Position := LastDelimiter('/', edtRepoPath.Text);
    if Position > 0 then
      edtRepoName.Text := Copy(edtRepoPath.Text, Position + 1, Integer.MaxValue)
    else
    begin
      Position := LastDelimiter('\', edtRepoPath.Text);
      if Position > 0 then
        edtRepoName.Text := Copy(edtRepoPath.Text, Position + 1, Integer.MaxValue);
    end;
    if EndsText('.git', edtRepoName.Text) then
      edtRepoName.Text := Copy(edtRepoName.Text, 1, Length(edtRepoName.Text) - 4);
  end;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  TSaveFileHelper.WriteCfgFile(GetSaveCfgPath(), TLoadType(cbxSourceType.ItemIndex), edtFileName.Text, GetSaveIcsFilePath(), edtVcsSourcePath.Text,
    edtVcsDestPath.Text, edtRepoName.Text, edtRepoPath.Text, not cbNurAktuelleDatenBehalten.Checked, cbDialogNichtMehrAnzeigen.Checked,
    cbWarteAufFertigstellungIcsImport.Checked);
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  TfrmLizenzdialog.LizenzAkzeptierenAllInclusive();
  UpdateVisibility();
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
  if GlobalObjectHolder.FilepathAlwaysOpenFile <> '' then
  begin
    if MessageDlg('Obwohl ExecuteDirect in der Konfigurationsdatei steht oder als Parameter mitgegeben wurde, wurde unter dem Pfad ' +
      GlobalObjectHolder.FilepathAlwaysOpenFile + ' eine Datei gefunden, die das anzeigen der Oberfläche erzwingt. Soll diese ' +
      'gelöscht werden?', TMsgDlgType.mtWarning, [mbYes, mbNo], 0, mbNo) = mrOk then
    begin
      DeleteFile(GlobalObjectHolder.FilepathAlwaysOpenFile);
    end;
  end;
end;

function TfrmMain.GetSaveCfgPath: string;
begin
  case cbxKfgDatSpeicherort.ItemIndex of
    cCurrentDir: Result := GetCurrentDir();
    cHomeDir: Result := TPath.GetHomePath;
    cTempDir: Result := TPath.GetTempPath;
    else
      Result := TPath.GetHomePath;
  end;
  if EndsText('/', Result) or EndsText('\', Result) then
    Result := Result + cNameKfgFile
  else if ContainsText(Result, '/') then
    Result := Result + '/' + cNameKfgFile
  else
    Result := Result + '\' + cNameKfgFile;
end;

function TfrmMain.GetSaveIcsFilePath: string;
begin
  if (cbxSaveDataAt.ItemIndex = -1) and (FRealPath <> '') then
    Exit(FRealPath);
  case cbxSaveDataAt.ItemIndex of
    cCurrentDir: Result := GetCurrentDir() + cNameAlreadyImportedIcsFile;
    cHomeDir: Result := TPath.GetHomePath + TPath.DirectorySeparatorChar + cNameAlreadyImportedIcsFile;
    cTempDir: Result := TPath.GetTempPath + cNameAlreadyImportedIcsFile;
    else
      Result := TPath.GetHomePath + TPath.DirectorySeparatorChar + cNameAlreadyImportedIcsFile;
  end;
end;

procedure TfrmMain.PresetValues(ALoadType: TLoadType; const APathToICSFile,
  APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath, ARepoName,
  APathToSubfolder: string; AKeepOldValues, AWaitForIcsImportTermination: Boolean);
begin
  FRealPath := '';
  if StartsText(TPath.GetTempPath, APathToAlreadyImportedFiles) then
    cbxSaveDataAt.ItemIndex := 2
  else if StartsText(TPath.GetHomePath, APathToAlreadyImportedFiles) then
    cbxSaveDataAt.ItemIndex := 1
  else if (not ContainsText(APathToAlreadyImportedFiles, '/') and not ContainsText(APathToAlreadyImportedFiles, '\')) or
    ContainsText(TDirectory.GetCurrentDirectory, APathToAlreadyImportedFiles) then
    cbxSaveDataAt.ItemIndex := 0
  else
  begin
    FRealPath := APathToAlreadyImportedFiles;
    cbxSaveDataAt.ItemIndex := -1;
  end;
  cbxSourceType.ItemIndex := Ord(ALoadType);
  if cbxSourceType.ItemIndex = Ord(ltFile) then
  begin
    edtFileName.TextHint := 'Dateiname und -pfad';
    btnChoosFilePath.Enabled := True;
  end
  else
  begin
    edtFileName.TextHint := 'Dateiname';
    btnChoosFilePath.Enabled := False;
  end;
  UpdateVisibility();
  edtFileName.Text := APathToICSFile;
  edtVcsSourcePath.Text := AVcsSourcePath;
  edtVcsDestPath.Text := AVcsDestPath;
  edtRepoName.Text := ARepoName;
  edtRepoPath.Text := APathToSubfolder;
  cbNurAktuelleDatenBehalten.Checked := not AKeepOldValues;
  cbDialogNichtMehrAnzeigen.Checked := False;
  cbWarteAufFertigstellungIcsImport.Checked := AWaitForIcsImportTermination;
end;

procedure TfrmMain.ShowHelpDlg;
begin
  MessageDlg('ICS-Autoimporter' + sLineBreak +
    sLineBreak +
    'Die Exe-Datei in den Autostart-Ordner legen (Win-Taste drücken, shell:startup eingeben und Eingabetaste drücken) oder eine Aufgabe in der ' +
    'Aufgabenplanung einrichten, welche die Datei regelmäßig ausführt.' + sLineBreak +
    'Unterstützte Modi: Datei vom Dateisystem, Svn, Git.' + sLineBreak +
    'Dateisystem:' + sLineBreak +
    'Unter "Dateiname" den Dateipfad zur ics-Datei angeben (ein Auswahldialog öffnet sich bei Klick auf "..."). Ändern sich die ics-Dateien häufig, ' +
    'das Kontrollfeld "Nur ICS-Daten aus der aktuellen Datei zum Vergleich abspeichern." aktivieren. Soll nicht jedes Mal ein Dialogfenster angezeigt ' +
    'werden, außerdem das Kontrollfeld "Dialogfenster beim nächsten Start unterdrücken." aktivieren. Anschließend auf "Importieren" klicken.' + sLineBreak +
    'Svn:' + sLineBreak +
    'Unter "Dateiname" den Namen der ics-Datei angeben. ' +
    'Außerdem den Quellpfad des Svn (Sub-)Repos bei "Quellpfad VCS" eintragen. Optional kann ein leerer Ordner auf dem Computer bei "Zielpfad VCS" eingetragen werden. Ändern sich die ics-Dateien häufig, ' +
    'das Kontrollfeld "Nur ICS-Daten aus der aktuellen Datei zum Vergleich abspeichern." aktivieren. Soll nicht jedes Mal ein Dialogfenster angezeigt ' +
    'werden, außerdem das Kontrollfeld "Dialogfenster beim nächsten Start unterdrücken." aktivieren. Anschließend auf "Importieren" klicken.' + sLineBreak +
    'Git:' + sLineBreak +
    'Unter "Dateiname" den Namen der ics-Datei angeben. ' +
    'Außerdem den Pfad zum Git-Repo bei "Quellpfad VCS" eintragen. Optional kann ein leerer Ordner auf dem Computer bei "Zielpfad VCS" eingetragen werden. ' +
    'Den Pfad zum Zielordner (z.B. Unterordner1/IcsOrdner/) im Feld "Pfad zum Zielordner" eintragen. Den Name des Repos selbst in der darauffolgenden Zeile eintragen.' +
    'Ändern sich die ics-Dateien häufig, ' +
    'das Kontrollfeld "Nur ICS-Daten aus der aktuellen Datei zum Vergleich abspeichern." aktivieren. Soll nicht jedes Mal ein Dialogfenster angezeigt ' +
    'werden, außerdem das Kontrollfeld "Dialogfenster beim nächsten Start unterdrücken." aktivieren. Anschließend auf "Importieren" klicken.', TMsgDlgType.mtInformation, [mbClose], 0);
end;

procedure TfrmMain.UpdateVisibility;
begin
  case cbxSourceType.ItemIndex of
    Ord(ltFile):
      begin
        pnlVcsSourcePath.Visible := False;
        pnlVcsDestPath.Visible := False;
        pnlRepoPath.Visible := False;
        pnlRepoName.Visible := False;
      end;
    Ord(ltSVN):
      begin
        pnlVcsSourcePath.Visible := True;
        pnlVcsDestPath.Visible := True;
        pnlRepoPath.Visible := False;
        pnlRepoName.Visible := False;
        pnlVcsSourcePath.Top := 99;
        pnlVcsDestPath.Top := 132;
      end;
    Ord(ltGit):
      begin
        pnlVcsSourcePath.Visible := True;
        pnlVcsDestPath.Visible := True;
        pnlRepoPath.Visible := True;
        pnlRepoName.Visible := True;
        pnlVcsSourcePath.Top := 99;
        pnlVcsDestPath.Top := 132;
        pnlRepoPath.Top := 165;
        pnlRepoName.Top := 198;
      end;
  end;
end;

end.
