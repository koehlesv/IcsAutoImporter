unit SaveFileHelper;

interface

uses Importer;

type
  TSaveFileHelper = class(TObject)
  public
    class function FileExistsGuessPath(const AFileName: string; out AFilePath: string): Boolean;
    class function AlwaysShowFileExists(out AFilePath: string): Boolean;
    class function LoadCfgFile(const APath: string; out ALoadType: TLoadType;
      out APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
      ARepoName, APathToSubfolder: string; out AKeepOldValues, AHideUI, AWaitForIcsImportTermination: Boolean): Boolean;
    class procedure WriteCfgFile(const APath: string;
      ALoadType: TLoadType; const APathToICSFile, APathToAlreadyImportedFiles,
      AVcsSourcePath, AVcsDestPath, ARepoName, APathToSubfolder: string;
      AKeepOldValues, AHideUI, AWaitForIcsImportTermination: Boolean);
  end;

const
  cLoadType = 'LoadType=';
  cPathToIcsFile = 'IcsPath=';
  cPathToAlreadyImportedFiles = 'AlreadyImportedFilesPath=';
  cVcsSourcePat = 'VcsSourcePath=';
  cVcsDestPath = 'VcsDestPath=';
  cRepoName = 'RepoName=';
  cPathToSubfolder = 'PathToSubfolder=';
  cKeepOldValues = 'KeepOldValues=';
  cHideUI = 'HideUI=';
  cWaitForIcsImportTermination = 'cWaitForIcsImportTermination=';
  cFilenameAlwyasShowUi = 'IcsAutoImporter.alwaysshow';

implementation

uses
  System.SysUtils, Classes, StrUtils, System.IOUtils;

{ TSaveFileHelper }

class function TSaveFileHelper.AlwaysShowFileExists(out AFilePath: string): Boolean;
begin
  AFilePath := '';
  Result := True;
  if FileExists(cFilenameAlwyasShowUi) then
    AFilePath := cFilenameAlwyasShowUi
  else if FileExists(TPath.GetTempPath + cFilenameAlwyasShowUi) then
    AFilePath := TPath.GetTempPath + cFilenameAlwyasShowUi
  else if FileExists(TPath.GetHomePath + TPath.DirectorySeparatorChar + cFilenameAlwyasShowUi) then
    AFilePath := TPath.GetHomePath + TPath.DirectorySeparatorChar + cFilenameAlwyasShowUi
  else
    Result := False;
end;

class function TSaveFileHelper.FileExistsGuessPath(const AFileName: string;
  out AFilePath: string): Boolean;
begin
  AFilePath := '';
  Result := True;
  if FileExists(AFileName) then
    AFilePath := AFileName
  else if FileExists(TPath.GetTempPath + AFileName) then
    AFilePath := TPath.GetTempPath + AFileName
  else if FileExists(TPath.GetHomePath + TPath.DirectorySeparatorChar + AFileName) then
    AFilePath := TPath.GetHomePath + TPath.DirectorySeparatorChar + AFileName
  else
    Result := False;
end;

class function TSaveFileHelper.LoadCfgFile(const APath: string; out ALoadType: TLoadType;
      out APathToICSFile, APathToAlreadyImportedFiles, AVcsSourcePath, AVcsDestPath,
      ARepoName, APathToSubfolder: string; out AKeepOldValues, AHideUI, AWaitForIcsImportTermination: Boolean): Boolean;
var
  CfgFile: TStringList;
  I: Integer;
  CommentPos: Integer;
  StartPos: Integer;
  TmpIntVal: Integer;
  CurrLine: string;
begin
  Result := False;
  //Initialisierung mit Standardwerten:
  ALoadType := ltFile;
  APathToICSFile := '';
  APathToAlreadyImportedFiles := TPath.GetHomePath;
  AVcsSourcePath := '';
  AVcsDestPath := '';
  ARepoName := '';
  APathToSubfolder := '';
  AKeepOldValues := False;
  AHideUI := True;
  if not FileExists(APath) then
    Exit;
  CfgFile := TStringList.Create;
  try
    CfgFile.LoadFromFile(APath);
    for I := CfgFile.Count - 1 downto 0 do
    begin
      if CfgFile[I].StartsWith('#') then
      begin
        CfgFile.Delete(I);
        Continue;
      end;
      CurrLine := CfgFile[I];
      CommentPos := Pos('#', CurrLine);
      if CommentPos > 0 then
        CurrLine := Copy(CurrLine, 1, Length(CurrLine) - CommentPos);
      StartPos := Pos('=', CurrLine) + 1;
      if StartsText(cLoadType, CurrLine) then
      begin
        if TryStrToInt(Copy(CurrLine, StartPos, Integer.MaxValue), TmpIntVal) and (TmpIntVal <= Ord(High(TLoadType))) then
          ALoadType := TLoadType(TmpIntVal);
      end
      else if StartsText(cPathToIcsFile, CurrLine) then
      begin
        APathToICSFile := Copy(CurrLine, StartPos, Integer.MaxValue);
      end
      else if StartsText(cPathToAlreadyImportedFiles, CurrLine) then
      begin
        APathToAlreadyImportedFiles := Copy(CurrLine, StartPos, Integer.MaxValue);
      end
      else if StartsText(cVcsSourcePat, CurrLine) then
      begin
        AVcsSourcePath := Copy(CurrLine, StartPos, Integer.MaxValue);
      end
      else if StartsText(cVcsDestPath, CurrLine) then
      begin
        AVcsDestPath := Copy(CurrLine, StartPos, Integer.MaxValue);
      end
      else if StartsText(cRepoName, CurrLine) then
      begin
        ARepoName := Copy(CurrLine, StartPos, Integer.MaxValue);
      end
      else if StartsText(cPathToSubfolder, CurrLine) then
      begin
        APathToSubfolder := Copy(CurrLine, StartPos, Integer.MaxValue);
      end
      else if StartsText(cKeepOldValues, CurrLine) then
      begin
        AKeepOldValues := StrToBool(Copy(CurrLine, StartPos, Integer.MaxValue));
      end
      else if StartsText(cHideUI, CurrLine) then
      begin
        AHideUI := StrToBool(Copy(CurrLine, StartPos, Integer.MaxValue));
      end
      else if StartsText(cWaitForIcsImportTermination, CurrLine) then
      begin
        AWaitForIcsImportTermination := StrToBool(Copy(CurrLine, StartPos, Integer.MaxValue));
      end;
    end;
  finally
    CfgFile.Free;
  end;
end;

class procedure TSaveFileHelper.WriteCfgFile(const APath: string;
  ALoadType: TLoadType; const APathToICSFile, APathToAlreadyImportedFiles,
  AVcsSourcePath, AVcsDestPath, ARepoName, APathToSubfolder: string;
  AKeepOldValues, AHideUI, AWaitForIcsImportTermination: Boolean);
var
  CfgFile: TStringList;
begin
  CfgFile := TStringList.Create;
  try
    CfgFile.Add(cLoadType + IntToStr(Ord(ALoadType)));
    CfgFile.Add(cPathToIcsFile + APathToICSFile);
    CfgFile.Add(cPathToAlreadyImportedFiles + APathToAlreadyImportedFiles);
    CfgFile.Add(cVcsSourcePat + AVcsSourcePath);
    CfgFile.Add(cVcsDestPath + AVcsDestPath);
    CfgFile.Add(cRepoName + ARepoName);
    CfgFile.Add(cPathToSubfolder + APathToSubfolder);
    CfgFile.Add(cKeepOldValues + BoolToStr(AKeepOldValues));
    CfgFile.Add(cHideUI + BoolToStr(AHideUI));
    CfgFile.Add(cWaitForIcsImportTermination + BoolToStr(AWaitForIcsImportTermination));
    CfgFile.SaveToFile(APath);
  finally
    CfgFile.Free;
  end;
end;

end.
