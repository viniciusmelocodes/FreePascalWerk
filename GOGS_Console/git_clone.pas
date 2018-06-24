unit git_clone;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Process;

type
  TPassError = procedure(AError: string) of object;
  TPassClonedRepoName = procedure(ARepoName: string) of object;

  TTGit = class(TThread)
  private
    _Error: TPassError;
    _ClonedRepo: TPassClonedRepoName;
    _RepoURL: string;

    function PerformOSClone(AURL: string): boolean;
    procedure TriggerError(AError: string);
    procedure TriggerCloned(ARepoURL: string);
  protected
    procedure Execute; override;
  public
    constructor Create(ARepoURL: string); reintroduce;
    destructor Destroy(); override;

    property OnPassError: TPassError read _Error write _Error;
    property OnPassClonedRepoName: TPassClonedRepoName read _ClonedRepo write _ClonedRepo;
  end;

implementation

constructor TTGit.Create(ARepoURL: string);
begin
  _RepoURL := ARepoURL;

  inherited Create(False);
  self.FreeOnTerminate := True;
end;

procedure TTGit.Execute;
begin
  if PerformOSClone(_RepoURL) then
    TriggerCloned(_RepoURL);
end;

function TTGit.PerformOSClone(AURL: string): boolean;
var
  p: TProcess;

begin
  try
    try
      p := TProcess.Create(nil);
      p.Executable := 'git';
      p.Parameters.Add('clone');
      p.Parameters.Add(AURL);
      p.ShowWindow := swoHIDE;
      p.Options := p.Options + [poWaitOnExit];

      p.Execute;
    except
      on E: Exception do
      begin
        Result := False;
        TriggerError('PerformOSClone: ' + E.Message);
        exit;
      end;
    end;
  finally
    FreeAndNil(p);
  end;

  Result := True;
end;

procedure TTGit.TriggerError(AError: string);
begin
  if Assigned(_Error) then
    _Error(AError);
end;

procedure TTGit.TriggerCloned(ARepoURL: string);
var
  repo_name: string;

begin
  repo_name := Copy(ARepoURL, LastDelimiter('/', ARepoURL) + 1, Length(ARepoURL));
  repo_name := Copy(repo_name, 1, LastDelimiter('.', repo_name) - 1);

  if Assigned(_ClonedRepo) then
    _ClonedRepo(repo_name);
end;

destructor TTGit.Destroy();
begin
  inherited Destroy;
end;

end.
