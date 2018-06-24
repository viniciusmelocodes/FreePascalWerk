unit get_repos_urls;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dateutils,
  Uni;

type
  TPassRepoURLs = procedure(ARepoList: array of string) of object;

  TTGogsRepos = class(TThread)
  private
    _q: TUniQuery;
    _PassResults: TPassRepoURLs;

    procedure TriggerResults(ARepoList: array of string);

  protected
    procedure Execute; override;

  public
    constructor Create(ADBConnection: TUniConnection; ADBTransaction: TUniTransaction; AMinutesFromLastUpdate: word = 10); reintroduce;
    destructor Destroy(); override;

    property OnPassResults: TPassRepoURLs read _PassResults write _PassResults;
  end;

implementation

constructor TTGogsRepos.Create(ADBConnection: TUniConnection; ADBTransaction: TUniTransaction; AMinutesFromLastUpdate: word = 10);
var
  last_update: string;

begin
  last_update := (DateTimeToUnix(Now()) - 60 * AMinutesFromLastUpdate).ToString;

  _q := TUniQuery.Create(nil);
  _q.Transaction := ADBTransaction;
  _q.Connection := ADBConnection;
  _q.SQL.Text := 'select r.name, u.name, r.updated_unix from repository r, public.user u where r.owner_id = u.id and r.updated_unix > ' + last_update;

  inherited Create(False);
  self.FreeOnTerminate := True;
end;

procedure TTGogsRepos.Execute;
var
  repolist: array of string;

begin
  _q.ExecSQL;
  writeln('Repo''s:' + _q.RecordCount.ToString);

  _q.First;
  while not _q.EOF do
  begin
    SetLength(repolist, Length(repolist) + 1);
    repolist[High(repolist)] := 'http://' + _q.Connection.Server + ':4000/' + _q.Fields[1].AsString + '/' + _q.Fields[0].AsString + '.git';
    _q.Next;
  end;

  FreeAndNil(_q);
  TriggerResults(repolist);
end;

procedure TTGogsRepos.TriggerResults(ARepoList: array of string);
begin
  if Assigned(_PassResults) then
    _PassResults(ARepoList);
end;

destructor TTGogsRepos.Destroy();
begin
  inherited Destroy;
end;

end.
