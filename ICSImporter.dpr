program ICSImporter;

uses
  {$IFDEF DEBUG}
  FastMM4,
  {$ENDIF }
  Vcl.Forms,
  SysUtils,
  StrUtils,
  System.IOUtils,
  MainFrm in 'MainFrm.pas' {frmMain},
  Importer in 'Importer.pas',
  SaveFileHelper in 'SaveFileHelper.pas',
  GlobalObjectHolder in 'GlobalObjectHolder.pas',
  LizenzdialogFrm in 'LizenzdialogFrm.pas' {frmLizenzdialog};

const
  cParamExecuteDirect = '--ExecuteDirect';
  cParamAlwaysShow = '--AlwaysShow';
  cParamMode = '--Mode:';
  cParamPathVcsFile = '--FileName:';
  cParamPathToAlreadyImportedFiles = '--AlreadyImportedFilesPath:';
  cParamVcsSourcePat = '--VcsSourcePath:';
  cParamVcsDestPath = '--VcsDestPath:';
  cParamRepoName = '--RepoName:';
  cParamPathToSubfolder = '--PathToSubfolder:';
  cParamDiscardOldValues = '--DiscardOldValues';
  cParamWaitForIcsImportTermination = '--WaitForIcsImportTermination';
  cParamLizenzAkzeptiert = '--AcceptLicenseTerms';

var
  ExecuteDirect: Boolean = False;
  KeepOldValues: Boolean = True;
  ExecDirectAlreadySet: Boolean = False;
  AlwaysShowAlreadySet: Boolean = False;
  ParamModeAlreadySet: Boolean = False;
  WaitForIcsImportTermination: Boolean = False;
  LizenzPerParameterAkzeptiert: Boolean = False;
  I: Integer;
  LoadType: TLoadType = ltFile;
  KfgFilePath: string = '';
  PathToICSFile: string = '';
  PathToAlreadyImportedFiles: string = '';
  VcsSourcePath: string = '';
  VcsDestPath: string = '';
  RepoName: string = '';
  PathToSubfolder: string = '';
  TmpVal: string;
  Importer: TImporter;

{$R *.res}

begin
  PathToAlreadyImportedFiles := TPath.GetHomePath;
  if TSaveFileHelper.FileExistsGuessPath(cNameKfgFile, KfgFilePath) then
    TSaveFileHelper.LoadCfgFile(KfgFilePath, LoadType, PathToICSFile, PathToAlreadyImportedFiles,
      VcsSourcePath, VcsDestPath, RepoName, PathToSubfolder, KeepOldValues, ExecuteDirect, WaitForIcsImportTermination);
  for I := 1 to ParamCount do
  begin
    if SameText(ParamStr(I), cParamExecuteDirect) then
    begin
      if AlwaysShowAlreadySet then
        raise Exception.Create('Es darf nur ExecuteDirect oder AlwaysShow gesetzt sein, nicht beide.');
      ExecuteDirect := True;
      ExecDirectAlreadySet := True;
    end
    else if SameText(ParamStr(I), cParamAlwaysShow) then
    begin
      if ExecDirectAlreadySet then
        raise Exception.Create('Es darf nur ExecuteDirect oder AlwaysShow gesetzt sein, nicht beide.');
      ExecuteDirect := False;
      AlwaysShowAlreadySet := True;
    end
    else if StartsText(cParamMode, ParamStr(I)) then
    begin
      TmpVal := Copy(Trim(ParamStr(I)), 8, Integer.MaxValue);
      if SameText(TmpVal, 'SVN') then
        LoadType := ltSvn
      else if SameText(TmpVal, 'Git') then
        LoadType := ltGit
      else
        LoadType := ltFile;
    end
    else if StartsText(cParamPathVcsFile, ParamStr(I)) then
    begin
      PathToICSFile := Copy(Trim(ParamStr(I)), 12, Integer.MaxValue);
    end
    else if StartsText(cParamPathToAlreadyImportedFiles, ParamStr(I)) then
    begin
      PathToAlreadyImportedFiles := Copy(Trim(ParamStr(I)), 28, Integer.MaxValue);
    end
    else if StartsText(cParamVcsSourcePat, ParamStr(I)) then
    begin
      VcsSourcePath := Copy(Trim(ParamStr(I)), 16, Integer.MaxValue);
    end
    else if StartsText(cParamVcsDestPath, ParamStr(I)) then
    begin
      VcsDestPath := Copy(Trim(ParamStr(I)), 15, Integer.MaxValue);
    end
    else if StartsText(cParamRepoName, ParamStr(I)) then
    begin
      RepoName := Copy(Trim(ParamStr(I)), 12, Integer.MaxValue);
    end
    else if StartsText(cParamPathToSubfolder, ParamStr(I)) then
    begin
      PathToSubfolder := Copy(Trim(ParamStr(I)), 19, Integer.MaxValue);
    end
    else if StartsText(cParamDiscardOldValues, ParamStr(I)) then
    begin
      KeepOldValues := False;
    end
    else if StartsText(cParamWaitForIcsImportTermination, ParamStr(I)) then
    begin
      WaitForIcsImportTermination := True;
    end
    else if SameText(cParamLizenzAkzeptiert, ParamStr(I)) then
    begin
      LizenzPerParameterAkzeptiert := True;
    end;
  end;

  if ExecuteDirect then
  begin
    if TSaveFileHelper.AlwaysShowFileExists(TmpVal) then
      GlobalObjectHolder.FilepathAlwaysOpenFile := TmpVal
    else
    begin
      if not LizenzPerParameterAkzeptiert then
        TfrmLizenzdialog.LizenzAkzeptierenAllInclusive();
      GlobalObjectHolder.AppIsInteractive := False;
      Importer := TImporter.Create;
      try
        Importer.DoImport(LoadType, PathToICSFile, PathToAlreadyImportedFiles, VcsSourcePath, VcsDestPath, RepoName, PathToSubfolder, KeepOldValues, WaitForIcsImportTermination);
      finally
        Importer.Free;
      end;
      Exit;
    end;
  end;


  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMain, frmMain);
  frmMain.PresetValues(LoadType, PathToICSFile, PathToAlreadyImportedFiles, VcsSourcePath, VcsDestPath, RepoName, PathToSubfolder, KeepOldValues, WaitForIcsImportTermination);
  Application.Run;
end.
