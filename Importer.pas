unit Importer;

{$Include Direktiven.inc}

interface

uses
  Classes, Contnrs, Windows, GlobalObjectHolder;

type
  TLoadType = (ltFile, ltSVN, ltGit);

  TVCSEintragObj = class(TObject)
  private
    FOwnsStringList: Boolean;
    FUID: String;
    FSequence: string;
    FValues: TStringList;
  public
    constructor Create(const AUID, ASequence: string; AValues: TStringList; AOwnsStringList: Boolean);
    destructor Destroy; override;
  end;

  TImportHelper = class(TObject)
  public
    class function GetPathToAlreadyImportedFiles(): string; deprecated; //Bitte die Daten aus der Konfiguration bzw. den Parametern bzw. der Oberfläche benutzen.
    class function GetTimedFileName(const AFileExt: string = '.ics'): string;
  end;

  TImporter = class(TObject)
  private
    FUidList: TStringList;
    FNoUidEntryList: TObjectList;
    procedure FillAlreadyUsedEntries(AData: TStringList);
    procedure SaveData(AList: TObjectList; const APath, AStartSequenz, AEndSequenz: string);
    procedure SaveAlreadyImportedICSData(ANewData: TObjectList; const APath: string; AKeepOldValues: Boolean);
    procedure WriteMaintenanceFile(const APathOfNewFile: string);
    procedure ExecutePendingDeletions();
    procedure ExecuteEx(const AFile, AParams: string);
    function CheckRequiredFields(ALoadType: TLoadType; const APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
      ARepoName, APathToSubfolder: string; ARaiseExceptionOnFail, AShowFaildialogue: Boolean): Boolean;
    function IsExecutionSuccessful(AExitCode: DWORD; out AErrorMsg: string): Boolean;
    function IsAlreadyImported(AValues: TStringList): Boolean; overload;
    function IsAlreadyImported(const AUID, ASequence: string): Boolean; overload;
  public
    constructor Create;
    destructor Destroy; override;
    procedure DoImport(ALoadType: TLoadType; const APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
      ARepoName, APathToSubfolder: string; AKeepOldValues, AWaitOnFinishIcsImport: Boolean);
    procedure SvnCheckout(const ASourceDest, ASinkDest: string);
    procedure SetupCheckoutDir(const APath: string);
    procedure GitSparseCheckout(const ASourceDest, ASinkDest, ARepoName, APathToSubfolder: string);
  end;

const
  cBeginnEntry = 'BEGIN:VEVENT';
  cStoppEntry = 'END:VEVENT';
  cTrennsymbole = '$$$***$$$';
  cNameMaintenanceFile = 'IcsAutoImporter_Maintenance.pending';
  cNameAlreadyImportedIcsFile = 'IcsAutoImporter_AlreadyImportedIcsData.file';

implementation

uses
  StrUtils, SysUtils, ShellAPI, IOUtils, Vcl.Dialogs, System.UITypes;

{ TImporter }

function TImporter.CheckRequiredFields(ALoadType: TLoadType;
  const APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath,
  AVcsDestPath, ARepoName, APathToSubfolder: string; ARaiseExceptionOnFail, AShowFaildialogue: Boolean): Boolean;
const
  cMandatoryFieldCheckFailedText = 'Pflichtfeldprüfung fehlgeschlagen:';
var
  FailSummary: string;
begin
  Result := True;
  FailSummary := cMandatoryFieldCheckFailedText;
  if APathToICSFile = '' then
    FailSummary := FailSummary + sLineBreak + ' - Der Dateiname der ICS-Quelldatei fehlt.';
  if APathToAlreadyImportedFiles = '' then
    FailSummary := FailSummary + sLineBreak + ' - Der Pfad zu den bereits importierten Daten fehlt.';
  if ALoadType in [ltSVN, ltGit] then
  begin
    if AVcsSourcePath = '' then
      FailSummary := FailSummary + sLineBreak + ' - Der Quellpfad des Versionierungssystems fehlt.';
    if ALoadType = ltGit then
    begin
      if ARepoName = '' then
        FailSummary := FailSummary + sLineBreak + ' - Der Reponame fehlt.';
      if APathToSubfolder = '' then
        FailSummary := FailSummary + sLineBreak + ' - Der Pfad zum Unterordner fehlt.';
    end;
  end;
  if FailSummary <> cMandatoryFieldCheckFailedText then
  begin
    Result := False;
    if AShowFaildialogue then
      MessageDlg(FailSummary, TMsgDlgType.mtError, [mbCancel], 0);
    if ARaiseExceptionOnFail then
      raise Exception.Create(FailSummary);
  end;
end;

constructor TImporter.Create;
begin
  FUidList := TStringList.Create;
  FNoUidEntryList := TObjectList.Create(True);
end;

destructor TImporter.Destroy;
begin
  FNoUidEntryList.Free;
  FUidList.Free;
  inherited Destroy;
end;

procedure TImporter.ExecuteEx(const AFile, AParams: string);
var
  Sei: TShellExecuteInfo;
  ExitCode: DWORD;
  ErrorMsg: string;
begin
  Sei.cbSize := SizeOf(Sei);
  Sei.fMask := SEE_MASK_NOCLOSEPROCESS;
  Sei.Wnd := 0;
  Sei.lpVerb := nil;
  Sei.lpFile := PChar(AFile);
  Sei.lpParameters := PChar(AParams);
  Sei.lpDirectory := nil;
  Sei.nShow := SW_HIDE;
  if ShellExecuteEx(@Sei) then
  try
    WaitForSingleObject(Sei.hProcess, INFINITE);
    GetExitCodeProcess(Sei.hProcess, ExitCode);
    if not IsExecutionSuccessful(ExitCode, ErrorMsg) then
      MessageDlg(ErrorMsg, mtError, [mbClose], 0);
  finally
    CloseHandle(Sei.hProcess);
  end
end;

procedure TImporter.ExecutePendingDeletions;
var
  FileContent: TStringList;
  MaintenancePath: string;
  I: Integer;
begin
  MaintenancePath := TPath.GetTempPath + cNameMaintenanceFile;
  if FileExists(MaintenancePath) then
  begin
    FileContent := TStringList.Create;
    try
      FileContent.LoadFromFile(MaintenancePath);
      for I := 0 to FileContent.Count - 1 do
      begin
        if FileExists(PChar(FileContent[I])) then
          DeleteFile(PChar(FileContent[I]));
      end;
    finally
      FileContent.Free;
    end;
    DeleteFile(PChar(MaintenancePath));
  end;
end;

procedure TImporter.FillAlreadyUsedEntries(AData: TStringList);
var
  LastEntryWasUid: Boolean;
  I: Integer;
  SubList, SingleList: TStringList;
begin
  LastEntryWasUid := False;
  SubList := TStringList.Create;
  try
    for I := 0 to AData.Count - 1 do
    begin
      if StartsText('UID', AData[I]) then
      begin
        FUidList.Add(AData[I]);
        LastEntryWasUid := True;
      end
      else if LastEntryWasUid then
      begin
        if StartsText('SEQUENCE', AData[I]) then
          FUidList.Add(AData[I])
        else
        begin
          FUidList.Add('SEQUENCE:0');
          SubList.Add(AData[I]);
        end;
        LastEntryWasUid := False;
      end
      else if AData[I] = cTrennsymbole then
      begin
        if SubList.Count > 0 then
        begin
          SingleList := TStringList.Create;
          FNoUidEntryList.Add(SingleList);
          SingleList.Assign(SubList);
        end;
        SubList.Clear;
      end
      else
        SubList.Add(AData[I]);
    end;
    if SubList.Count > 0 then
    begin
      SingleList := TStringList.Create;
      FNoUidEntryList.Add(SingleList);
      SingleList.Assign(SubList);
    end;
  finally
    SubList.Free;
  end;
end;

class function TImportHelper.GetTimedFileName(const AFileExt: string {Default '.ics'}): string;
var
  CurrentTimestamp: TTimeStamp;
begin
  CurrentTimestamp := DateTimeToTimeStamp(Now);
  Result := IntToStr(CurrentTimestamp.Date) + IntToStr(CurrentTimestamp.Time) + AFileExt;
end;

procedure TImporter.GitSparseCheckout(const ASourceDest, ASinkDest, ARepoName, APathToSubfolder: string);
var
  BatchFileContent: TStringList;
  FileName: string;
begin
  SetupCheckoutDir(ASinkDest);
  BatchFileContent := TStringList.Create;
  try
    BatchFileContent.Add(Format('cd "%s"', [ASinkDest]));
    BatchFileContent.Add(Format('git clone --no-checkout --depth=1 --filter=tree:0 "%s"', [ASourceDest]));
    BatchFileContent.Add(Format('cd "%s"', [ARepoName]));
    BatchFileContent.Add(Format('git sparse-checkout set --no-cone "%s"', [APathToSubfolder]));
    BatchFileContent.Add('git checkout');
    FileName :=TImportHelper.GetTimedFileName('.bat');
    BatchFileContent.SaveToFile(FileName);
    ExecuteEx(FileName, '');
    DeleteFile(FileName);
  finally
    BatchFileContent.Free;
  end;
end;

procedure TImporter.DoImport(ALoadType: TLoadType;
  const APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
  ARepoName, APathToSubfolder: string; AKeepOldValues, AWaitOnFinishIcsImport: Boolean);
var
  AlreadyImportedData: TStringList;
  ICSData: TStringList;
  //NewIcsData: TStringList;
  CurrIcsEntry: TStringList;
  LData: TObjectList;
  StartMarkRead: Boolean;
  CurrIcsEntryRequiresFree: Boolean;
  I: Integer;
  StartSequenz, EndSequenz: string;
  LVcsDestPath: string;
  TempFilePath: string;
  LUID: string;
  LSequence: string;
begin
  if not CheckRequiredFields(ALoadType, APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
    ARepoName, APathToSubfolder, not GlobalObjectHolder.AppIsInteractive, GlobalObjectHolder.AppIsInteractive) then
  begin
    Exit;
  end;
  ExecutePendingDeletions();
  LVcsDestPath := AVcsDestPath;
  if LVcsDestPath = '' then
    LVcsDestPath := TPath.GetTempPath + TImportHelper.GetTimedFileName('');
  case ALoadType of
    ltFile: ;
    ltSVN: SvnCheckout(AVcsSourcePath, LVcsDestPath);
    ltGit: GitSparseCheckout(AVcsSourcePath, LVcsDestPath, ARepoName, APathToSubfolder);
  end;
  StartMarkRead := False;
  StartSequenz := '';
  EndSequenz := '';
  LUID := '';
  LSequence := '';
  LData := TObjectList.Create(True);
  CurrIcsEntry := nil;
  AlreadyImportedData := TStringList.Create;
  ICSData := TStringList.Create;
  try
    if FileExists(APathToAlreadyImportedFiles) then
      AlreadyImportedData.LoadFromFile(APathToAlreadyImportedFiles);
    FillAlreadyUsedEntries(AlreadyImportedData);
    ICSData.LoadFromFile(APathToICSFile);
    for I := 0 to ICSData.Count - 1 do
    begin
      if SameText(cBeginnEntry, ICSData[I]) then
      begin
        CurrIcsEntry.Free;
        CurrIcsEntry := TStringList.Create;
        StartMarkRead:= True;
        CurrIcsEntry.Add(ICSData[I]);
      end
      else if SameText(cStoppEntry, ICSData[I]) {or (I = (ICSData.Count - 1))} then
      begin
        CurrIcsEntry.Add(ICSData[I]);
        CurrIcsEntryRequiresFree := True;
        if LSequence = '' then
          LSequence := 'SEQUENCE:0';
        if (LUID <> '') and not IsAlreadyImported(LUID, LSequence) then
        begin
          LData.Add(TVCSEintragObj.Create(LUID, LSequence, CurrIcsEntry, True));
          CurrIcsEntryRequiresFree := False;
        end;
        if (LUID = '') and not IsAlreadyImported(CurrIcsEntry) then
        begin
          LData.Add(TVCSEintragObj.Create(LUID, LSequence, CurrIcsEntry, True));
          CurrIcsEntryRequiresFree := False;
        end;
        if CurrIcsEntryRequiresFree then
          CurrIcsEntry.Free;
        LUID := '';
        LSequence := '';
        CurrIcsEntry := nil;
      end
      else
      begin
        if CurrIcsEntry = nil then
        begin
          if StartMarkRead then
          begin
            if EndSequenz = '' then
              EndSequenz := ICSData[I]
            else
              EndSequenz := EndSequenz + sLineBreak + ICSData[I];
          end
          else
          begin
            if StartSequenz = '' then
              StartSequenz := ICSData[I]
            else
              StartSequenz := StartSequenz + sLineBreak + ICSData[I];
          end;
        end
        else if StartsText('UID', ICSData[I]) then
          LUID := ICSData[I]
        else if StartsText('SEQUENCE', ICSData[I]) then
          LSequence := ICSData[I];
        if CurrIcsEntry <> nil then
          CurrIcsEntry.Add(ICSData[I]);
      end;
    end;
    if LData.Count > 0 then
    begin
      TempFilePath := TPath.GetTempPath + TImportHelper.GetTimedFileName();
      SaveData(LData, TempFilePath, StartSequenz, EndSequenz);
      {$IFNDEF NOOPENOFCREATEDICS}
      if AWaitOnFinishIcsImport then
        ExecuteEx(TempFilePath, '')
      else
        ShellExecute(0, PChar('open'), PChar(TempFilePath), nil, nil, SW_HIDE);
      {$ENDIF}
      if not MoveFileEx(PChar(TempFilePath), nil, MOVEFILE_DELAY_UNTIL_REBOOT) then //Erfordert Administrator-Berechtigungen, die man dem Programm vielleicht gar nicht geben möchte.
        WriteMaintenanceFile(TempFilePath);
      SaveAlreadyImportedICSData(LData, APathToAlreadyImportedFiles, AKeepOldValues);
    end;
  finally
    ICSData.Free;
    AlreadyImportedData.Free;
    LData.Free;
  end;
end;

function TImporter.IsAlreadyImported(const AUID, ASequence: string): Boolean;
var
  I: Integer;
begin
  Result := False;
  for I := 0 to FUidList.Count - 1 do
  begin
    if FUidList[I] = AUid then
    begin
      if I < FUidList.Count - 1 then
      begin
        if (FUidList[I + 1] = ASequence) then
          Exit(True);
      end;
    end;
  end;
end;

function TImporter.IsExecutionSuccessful(AExitCode: DWORD;
  out AErrorMsg: string): Boolean;
begin
  Result := False;
  AErrorMsg := '';
  case AExitCode of
    ERROR_SUCCESS: Result := True;
    ERROR_FILE_NOT_FOUND: AErrorMsg := 'Die Datei konnte nicht gefunden werden. ' + IntToStr(AExitCode);
    ERROR_PATH_NOT_FOUND: AErrorMsg := 'Der Pfad konnte nicht gefunden werden. ' + IntToStr(AExitCode);
    ERROR_DDE_FAIL: AErrorMsg := 'Der Dynamic Data Exchange war nicht erfolgreich. ' + IntToStr(AExitCode);
    ERROR_NO_ASSOCIATION: AErrorMsg := 'Mit der übergebenen Dateiendung ist kein Standardprogramm verknüpft. ' + IntToStr(AExitCode);
    ERROR_ACCESS_DENIED: AErrorMsg := 'Zugriffsverletzung: ACCESS_DENIED. ' + IntToStr(AExitCode);
    ERROR_DLL_NOT_FOUND: AErrorMsg := 'Es fehlt eine notwendige Bibliothek: DLL_NOT_FOUND. ' + IntToStr(AExitCode);
    ERROR_CANCELLED: AErrorMsg := 'Abgebrochen. ' + IntToStr(AExitCode);
    ERROR_NOT_ENOUGH_MEMORY: AErrorMsg := 'Es steht nicht genügend Speicher zur Verfügung. ' + IntToStr(AExitCode);
    ERROR_SHARING_VIOLATION: AErrorMsg := 'Sharing-Violation. ' + IntToStr(AExitCode);
  end;
end;

procedure TImporter.SaveAlreadyImportedICSData(ANewData: TObjectList;
  const APath: string; AKeepOldValues: Boolean);
var
  SaveList: TStringList;
  SubList: TStringList;
  EinzeleintragObj: TVCSEintragObj;
  UidFound: Boolean;
  I: Integer;
  J: Integer;
begin
  SaveList := TStringList.Create;
  try
    if AKeepOldValues and FileExists(APath) then
      SaveList.LoadFromFile(APath);
    for I := 0 to ANewData.Count - 1 do
    begin
      EinzeleintragObj := ANewData[I] as TVCSEintragObj;
      SubList := EinzeleintragObj.FValues;
      UidFound := False;
      if EinzeleintragObj.FUID <> '' then
      begin
        UidFound := True;
        SaveList.Insert(0, EinzeleintragObj.FUID);
        SaveList.Insert(1, EinzeleintragObj.FSequence);
      end;
      if not UidFound then
      begin
        if SaveList.Count > 0 then
          SaveList.Add(cTrennsymbole);
        for J := 0 to SubList.Count - 1 do
        begin
          SaveList.Add(SubList[J]);
        end;
      end;
    end;
    SaveList.SaveToFile(APath);
  finally
    SaveList.Free;
  end;
end;

procedure TImporter.SaveData(AList: TObjectList; const APath, AStartSequenz,
  AEndSequenz: string);
var
  SaveList, SubList: TStringList;
  Einzeleintrag: TVCSEintragObj;
  I: Integer;
  J: Integer;
begin
  SaveList := TStringList.Create;
  try
    SaveList.Add(AStartSequenz);
    for I := 0 to AList.Count - 1 do
    begin
      Einzeleintrag := AList[I] as TVCSEintragObj;
      SubList := Einzeleintrag.FValues;
      for J := 0 to SubList.Count - 1 do
      begin
        SaveList.Add(SubList[J]);
      end;
    end;
    SaveList.Add(AEndSequenz);
    SaveList.SaveToFile(APath);
  finally
    SaveList.Free;
  end;
end;

procedure TImporter.SetupCheckoutDir(const APath: string);
begin
  if DirectoryExists(APath) then
    TDirectory.Delete(APath, True);
  TDirectory.CreateDirectory(APath);
end;

procedure TImporter.SvnCheckout(const ASourceDest, ASinkDest: string);
begin
  SetupCheckoutDir(ASinkDest);
  ExecuteEx('cmd.exe', Format('/C svn checkout --non-interactive "%s" "%s"', [ASourceDest, ASinkDest]));
  //ShellExecute(0, nil, 'cmd.exe', PChar(Format('/C svn checkout "%s" "%s"', [ASourceDest, ASinkDest])), nil, SW_HIDE);
end;

procedure TImporter.WriteMaintenanceFile(const APathOfNewFile: string);
var
  MaintenancePath: string;
  FileContent: TStringList;
begin
  MaintenancePath := TPath.GetTempPath + cNameMaintenanceFile;
  FileContent := TStringList.Create;
  try
    FileContent.Add(APathOfNewFile);
    FileContent.SaveToFile(MaintenancePath);
  finally
    FileContent.Free;
  end;
end;

function TImporter.IsAlreadyImported(AValues: TStringList): Boolean;
var
  I: Integer;
  CurrStrList: TStringList;
  J: Integer;
begin
  Result := False;
  for I := 0 to FNoUidEntryList.Count - 1 do
  begin
    CurrStrList := (FNoUidEntryList[I] as TStringList);
    for J := 0 to AValues.Count - 1 do
    begin
      if not CurrStrList.Contains(AValues[J]) then
        Break;
      if J = AValues.Count - 1 then
        Exit(True);
    end;
  end;
end;

{ TVCSEintragObj }

constructor TVCSEintragObj.Create(const AUID, ASequence: string; AValues: TStringList;
  AOwnsStringList: Boolean);
begin
  inherited Create;
  FUID := AUID;
  FSequence := ASequence;
  FValues := AValues;
  FOwnsStringList := AOwnsStringList;
end;

destructor TVCSEintragObj.Destroy;
begin
  if FOwnsStringList then
    FValues.Free;
  inherited Destroy;
end;

{ TImportHelper }

class function TImportHelper.GetPathToAlreadyImportedFiles: string;
begin
  if FileExists(cNameAlreadyImportedIcsFile) then
    Result := cNameAlreadyImportedIcsFile
  else if FileExists(TPath.GetTempPath + cNameMaintenanceFile) then
    Result := TPath.GetTempPath + cNameAlreadyImportedIcsFile
  else
    Result := TPath.GetHomePath + TPath.DirectorySeparatorChar + cNameAlreadyImportedIcsFile;
end;

end.
