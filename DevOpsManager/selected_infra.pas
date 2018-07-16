unit selected_infra;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  strutils,
  node_class;

type
  TSelectionType = (containers, services, hosts, ipaddress);
  TPassSelectedInfrastructure = procedure(ASelectedInfrastructure: TInfrastructure) of object;

  TSelectedInfrastructure = class
  private
    _Infrastructure: TInfrastructure;
    _SelectedInfrastructure: TInfrastructure;
    _PassSelectedInfrastructure: TPassSelectedInfrastructure;

    procedure TriggerPassSelectedInfrastructure(AInfrastructure: TInfrastructure);
  public
    constructor Create(AInfrastructure: TInfrastructure);
    destructor Destroy;

    procedure UpdateSelection(ASelectionType: TSelectionType; ASelectionString: string);
    property Infrastructure: TInfrastructure read _SelectedInfrastructure;
    property OnPassSelectedInfrastructure: TPassSelectedInfrastructure read _PassSelectedInfrastructure write _PassSelectedInfrastructure;
  end;

implementation

constructor TSelectedInfrastructure.Create(AInfrastructure: TInfrastructure);
begin
  _Infrastructure := AInfrastructure;
end;

procedure TSelectedInfrastructure.UpdateSelection(ASelectionType: TSelectionType; ASelectionString: string);
var
  i, j, k: word;
  t: TStringList;
  contains: boolean = False;
  containsContainer: boolean = False;
  containsHost: boolean = False;
  containsScheduler: boolean = False;
  containsService: boolean = False;

begin
  if Length(trim(ASelectionString)) = 0 then
    _SelectedInfrastructure := _Infrastructure
  else
  begin
    try
      t := TStringList.Create;
      t.StrictDelimiter := True;
      t.Delimiter := ' ';
      t.DelimitedText := ASelectionString;

      SetLength(_SelectedInfrastructure, 0);

      if t.Count > 0 then
      begin

        if Length(_Infrastructure) > 0 then
        begin
          for i := Low(_Infrastructure) to High(_Infrastructure) do
          begin
            if Length(trim(_Infrastructure[i].NodeInstance.NodeName)) > 0 then
            begin
              for j := 0 to t.Count - 1 do
              begin
                case ASelectionType of
                  containers:
                  begin
                    contains := True;

                    if not AnsiContainsText(_Infrastructure[i].NodeInstance.NodeName, trim(t.Strings[j])) then
                    begin
                      contains := False;
                      break;
                    end;
                  end;

                  services:
                  begin
                    contains := False;

                    for k := Low(_Infrastructure[i].NodeInstance.ServicesInfo) to High(_Infrastructure[i].NodeInstance.ServicesInfo) do
                    begin
                      if AnsiContainsText(_Infrastructure[i].NodeInstance.ServicesInfo[k].ServiceName, trim(t.Strings[j])) then
                      begin
                        contains := True;
                        break;
                      end;
                    end;
                  end;

                  hosts:
                  begin
                    contains := True;

                    if not AnsiContainsText(_Infrastructure[i].NodeInstance.HostInfo.HostName, trim(t.Strings[j])) then
                    begin
                      contains := False;
                      break;
                    end;
                  end;

                  ipaddress:
                  begin

                    containsContainer := True;

                    if not AnsiContainsText(_Infrastructure[i].NodeInstance.NodeIPv4, trim(t.Strings[j])) then
                    begin
                      containsContainer := False;
                    end;

                    containsHost := True;

                    if not AnsiContainsText(_Infrastructure[i].NodeInstance.HostInfo.HostSocket.SocketIP, trim(t.Strings[j])) then
                    begin
                      containsHost := False;
                    end;

                    containsScheduler := True;

                    if not AnsiContainsText(_Infrastructure[i].NodeInstance.SchedulerInfo.SchedulerSocket.SocketIP, trim(t.Strings[j])) then
                    begin
                      containsScheduler := False;
                    end;

                    containsService := False;

                    for k := Low(_Infrastructure[i].NodeInstance.ServicesInfo) to High(_Infrastructure[i].NodeInstance.ServicesInfo) do
                    begin
                      if AnsiContainsText(_Infrastructure[i].NodeInstance.ServicesInfo[k].ServiceSocket.SocketIP, trim(t.Strings[j])) then
                      begin
                        containsService := True;
                        break;
                      end;
                    end;

                  end;
                end;

              end;

              if contains then
              begin
                SetLength(_SelectedInfrastructure, Length(_SelectedInfrastructure) + 1);
                _SelectedInfrastructure[Length(_SelectedInfrastructure) - 1] := _Infrastructure[i];
              end;

              if containsContainer or containsHost or containsScheduler or containsService then
              begin
                SetLength(_SelectedInfrastructure, Length(_SelectedInfrastructure) + 1);
                _SelectedInfrastructure[Length(_SelectedInfrastructure) - 1] := _Infrastructure[i];
              end;
            end;
          end;
        end;
      end;

    finally
      FreeAndNil(t);
    end;
  end;

  TriggerPassSelectedInfrastructure(_SelectedInfrastructure);
end;

procedure TSelectedInfrastructure.TriggerPassSelectedInfrastructure(AInfrastructure: TInfrastructure);
begin
  if Assigned(_PassSelectedInfrastructure) then
    _PassSelectedInfrastructure(AInfrastructure);
end;

destructor TSelectedInfrastructure.Destroy;
begin
  inherited Destroy;
end;

end.
