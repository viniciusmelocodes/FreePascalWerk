unit populate_infra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  parse_node_info,
  node_class;

type
  TPassInfrastructure = procedure(AInfrastructure: TInfrastructure; AError: string) of object;

  TPopulateInfrastructure = class(TThread)
  private
    _JSONRAW: string;
    _Error: string;
    _PassInfrastructure: TPassInfrastructure;
    procedure TriggerPassInfrastructure(AInfrastructure: TInfrastructure; AError: string);
  protected
    procedure Execute; override;
  public
    constructor CreateFile(AJSONFile: string);
    constructor CreateURL(AJSONURL: string);
    destructor Destroy(); override;

    property OnPassInfrastructure: TPassInfrastructure read _PassInfrastructure write _PassInfrastructure;
  end;

implementation

constructor TPopulateInfrastructure.CreateFile(AJSONFile: string);
var
  info: TStringList;

begin
  inherited Create(False);
  self.FreeOnTerminate := True;

  if FileExists(AJSONFile) then
  begin
    try
      info := TStringList.Create;
      info.LoadFromFile(AJSONFile);

      _JSONRAW := info.Text;
    finally
      FreeAndNil(info);
    end;
  end
  else
    _Error := 'JSON Raw file not found';
end;

constructor TPopulateInfrastructure.CreateURL(AJSONURL: string);
begin
  inherited Create(False);
  self.FreeOnTerminate := True;
end;

procedure TPopulateInfrastructure.Execute;
var
  infoJSON: TParseJSON;
  err: string;
  i: word;
  nodesInfo: TNodes;
  infrastructureInfo: TInfrastructure;

begin
  try
    infoJSON := TParseJSON.Create();
    nodesInfo := infoJSON.ConvertJSON(_JSONRAW, err);

    SetLength(infrastructureInfo, Length(nodesInfo));

    if Length(infrastructureInfo) > 0 then
    begin

      for i := Low(infrastructureInfo) to High(infrastructureInfo) do
      begin
        infrastructureInfo[i] := TInfrastructureNode.Create(nodesInfo[i]);

        infrastructureInfo[i].AddTraining('Training Switch from Angular');
        infrastructureInfo[i].AddTraining('Training Systems programming with Golang');
        infrastructureInfo[i].AddTraining('Training Infrastructure as a Service');
        infrastructureInfo[i].AddTraining('Training Ansible');
      end;

    end;

    TriggerPassInfrastructure(infrastructureInfo, err);
  finally
    infoJSON.Destroy;
  end;
end;

procedure TPopulateInfrastructure.TriggerPassInfrastructure(AInfrastructure: TInfrastructure; AError: string);
begin
  if Assigned(_PassInfrastructure) then
    _PassInfrastructure(AInfrastructure, AError);
end;

destructor TPopulateInfrastructure.Destroy();
begin
  inherited Destroy;
end;

end.
