unit parse_node_info;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  fpjson, jsonparser,
  TypInfo,
  node_class;

type
  TParseJSON = class
  private
    _Nodes: TNodes;
  public
    constructor Create();
    destructor Destroy; override;
    function ConvertJSON(ARawJSON: string; out AError: string): TNodes;
  end;

implementation

constructor TParseJSON.Create();
begin
  SetLength(_Nodes, 0);
end;

function TParseJSON.ConvertJSON(ARawJSON: string; out AError: string): TNodes;
var
  jsData: TJSONData;
  jsNode: TJSONData;
  jsItem: TJSONData;
  servicesData: TJSONData;
  i, j: word;
  node_name: string;

begin
  try
    try
      jsData := GetJSON(ARawJSON);
      jsNode := jsData.FindPath('Response.Message');

      for i := 0 to jsNode.Count - 1 do
      begin
        jsItem := jsNode.Items[i];

        SetLength(_Nodes, Length(_Nodes) + 1);

        node_name := jsItem.FindPath('Name').AsString;
        node_name := Copy(node_name, LastDelimiter('/', node_name) + 1, Length(node_name));

        _Nodes[Length(_Nodes) - 1].NodeName := node_name;
        _Nodes[Length(_Nodes) - 1].NodeIPv4 := jsItem.FindPath('Ip').AsString;
        _Nodes[Length(_Nodes) - 1].HostInfo.HostName := jsItem.FindPath('Host.Name').AsString;
        _Nodes[Length(_Nodes) - 1].HostInfo.HostSocket.SocketIP := jsItem.FindPath('Host.Ip').AsString;
        _Nodes[Length(_Nodes) - 1].HostInfo.HostSocket.SocketPort := jsItem.FindPath('Host.Port').AsString;
        _Nodes[Length(_Nodes) - 1].SchedulerInfo.URL := jsItem.FindPath('Scheduler.URL').AsString;
        _Nodes[Length(_Nodes) - 1].SchedulerInfo.SchedulerSocket.SocketIP := jsItem.FindPath('Scheduler.Ip').AsString;
        _Nodes[Length(_Nodes) - 1].SchedulerInfo.SchedulerSocket.SocketPort := jsItem.FindPath('Scheduler.Port').AsString;

        servicesData := jsItem.FindPath('Services');

        SetLength(_Nodes[Length(_Nodes) - 1].ServicesInfo, servicesData.Count);

        if servicesData.Count > 0 then
        begin
          for j := 0 to servicesData.Count - 1 do
          begin
            _Nodes[Length(_Nodes) - 1].ServicesInfo[j].ServiceName := servicesData.Items[j].FindPath('Name').AsString;
            _Nodes[Length(_Nodes) - 1].ServicesInfo[j].ServiceDescription := servicesData.Items[j].FindPath('Description').AsString;
            _Nodes[Length(_Nodes) - 1].ServicesInfo[j].ServiceSocket.SocketIP := servicesData.Items[j].FindPath('Ip').AsString;
            _Nodes[Length(_Nodes) - 1].ServicesInfo[j].ServiceSocket.SocketPort := servicesData.Items[j].FindPath('Port').AsString;
          end;
        end;

      end;

      Result := _Nodes;

    except
      on E: Exception do
      begin
        AError := E.Message;
      end;
    end;

  finally
    FreeAndNil(jsData);
  end;
end;

destructor TParseJSON.Destroy;
begin
  inherited Destroy;
end;

end.
