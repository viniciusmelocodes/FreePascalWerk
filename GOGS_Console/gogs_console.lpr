program gogs_console;

{
Backup solution for GOGS. In Free Pascal using Devart. Cross platform.
}

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}
  cthreads, {$ENDIF}
  Classes,
  SysUtils,
  unidac10,
  pgprovider10,
  CustApp,
  postgres_connect,
  git_clone,
  get_repos_urls,
  Uni,
  compress_folder;

type
  TGogsConsole = class(TCustomApplication)
  protected
    _hasRun: boolean;
    _dbHandler: TCreateDBHandler;
    _noRepos: word;
    _currentRepo: word;
    _Simultan: word;
    _CurrentNumThreads: word;
    procedure DoRun; override;

  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;

    procedure CatchRepoURLs(ARepoList: array of string);
    procedure CatchClonedRepoName(ARepoName: string);
    procedure CatchZippedRepoName(ARepoName: string);
    procedure CatchError(AError: string);
    procedure CatchException(AException: string);
  end;

  procedure TGogsConsole.DoRun;
  var
    c: TPostgresConnInfo;
    r: TTGogsRepos;

  begin
    if not _hasRun then
    begin
      _Simultan := 2;
      _CurrentNumThreads := 0;

      c.ServerIP := '192.168.1.46';
      c.ListenPort := 5432;
      c.Username := 'gogs';
      c.Password := 'gogs';
      c.Database := 'gogs';

      _dbHandler := TCreateDBHandler.Create(c);

      if ParamCount > 0 then
      begin
        r := TTGogsRepos.Create(_dbHandler.DBConnection, _dbHandler.DBTransaction, ParamStr(1).ToInt64);
      end
      else
        r := TTGogsRepos.Create(_dbHandler.DBConnection, _dbHandler.DBTransaction);

      r.OnPassResults := @CatchRepoURLs;

      _hasRun := True;
    end;
  end;

  constructor TGogsConsole.Create(TheOwner: TComponent);
  begin
    _hasRun := False;

    inherited Create(TheOwner);
    StopOnException := True;
  end;

  procedure TGogsConsole.CatchRepoURLs(ARepoList: array of string);
  var
    i: word;
    g: TTGit;

  begin
     FreeAndNil(_dbHandler);
    _noRepos := Length(ARepoList);

    if _noRepos > 0 then
    begin
      _currentRepo := 0;

      for i := Low(ARepoList) to High(ARepoList) do
      begin
        WriteLn('TGogsConsole.CatchRepoURLs:' + ARepoList[i]);
        g := TTGit.Create(ARepoList[i]);
        g.OnPassClonedRepoName := @CatchClonedRepoName;

        _CurrentNumThreads := _CurrentNumThreads + 1;
        while _CurrentNumThreads >= _Simultan do
        begin
          sleep(500);
          WriteLn('waiting');
        end;
      end;
    end
    else
    begin
      WriteLn('Exiting. No Repos.');
      Terminate(2);
    end;
  end;

  procedure TGogsConsole.CatchClonedRepoName(ARepoName: string);
  var
    z: TTCompressFolder;

  begin
    z := TTCompressFolder.Create(ARepoName, ARepoName + '.zip');
    z.OnPassZipped := @CatchZippedRepoName;
    z.OnPassError := @CatchError;
  end;

  procedure TGogsConsole.CatchZippedRepoName(ARepoName: string);
  begin
    _currentRepo := _currentRepo + 1;
    if _currentRepo = _noRepos then
      Terminate(1);

    _CurrentNumThreads := _CurrentNumThreads - 1;
  end;

  procedure TGogsConsole.CatchError(AError: string);
  begin
    WriteLn(AError);
  end;

  procedure TGogsConsole.CatchException(AException: string);
  begin
    WriteLn('exception:' + AException);
    Terminate();
  end;

  destructor TGogsConsole.Destroy;
  begin
    inherited Destroy;
  end;

var
  Application: TGogsConsole;

begin
  Application := TGogsConsole.Create(nil);
  Application.Title := 'GOGS Console';
  Application.Run;
  Application.Free;
end.
