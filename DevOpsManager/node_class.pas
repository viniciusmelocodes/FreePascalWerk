unit node_class;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TEnumNodeStatus = (stop, online, maintenance);

type
  TTrainings = array of string;
  TDatabases = array of string;

  TNodeSocket = record
    SocketIP: string;
    SocketPort: string;
  end;

  THost = record
    HostName: string;
    HostSocket: TNodeSocket;
  end;

  TScheduler = record
    URL: string;
    SchedulerSocket: TNodeSocket;
  end;

  TService = record
    ServiceName: string;
    ServiceDescription: string;
    ServiceSocket: TNodeSocket;
  end;

  TServices = array of TService;

  TNode = record     //generic, mostly refers to containers
    NodeID: word;    //should be unique
    NodeName: string;
    NodeIPv4: string;
    NodeStatus: TEnumNodeStatus;
    Created: string;
    LastUpdate: string;
    AvailableTrainings: TTrainings;
    TargetDatabases: TDatabases;
    HostInfo: THost;
    SchedulerInfo: TScheduler;
    ServicesInfo: TServices;
  end;

  TNodes = array of TNode;

type
  TInfrastructureNode = class
  private
    _Node: TNode;

  public
    constructor Create(ANode: TNode);
    destructor Destroy; override;

    procedure AddTraining(ATrainingTitle: string);
    property NodeInstance: TNode read _Node write _Node;
  end;

type
  TInfrastructure = array of TInfrastructureNode;

implementation

constructor TInfrastructureNode.Create(ANode: TNode);
begin
  _Node := ANode;
end;

procedure TInfrastructureNode.AddTraining(ATrainingTitle: string);
begin
  SetLength(_Node.AvailableTrainings, Length(_Node.AvailableTrainings) + 1);
  _Node.AvailableTrainings[Length(_Node.AvailableTrainings) - 1] := ATrainingTitle;
end;

destructor TInfrastructureNode.Destroy;
begin
  inherited Destroy;
end;

end.
