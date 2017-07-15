unit http_listen;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils, fphttpapp, fphttpserver;

type
  TPOSTInfo = record
    FieldName: string;
    FieldValue: string;
  end;

type
  THTTPServerThread = class(TThread)
  private
    Server: TFPHTTPServer;
    _Error: string;
  public
    constructor Create(APort: word; const OnRequest: THTTPServerRequestHandler);
    procedure Execute; override;
    procedure DoTerminate; override;
    property Error: string read _Error;
  end;

implementation

constructor THTTPServerThread.Create(APort: word; const OnRequest: THTTPServerRequestHandler);
begin
  Server := TFPHTTPServer.Create(nil);
  Server.Port := APort;
  Server.OnRequest := OnRequest;
  _Error:= 'nil';
  inherited Create(False);
end;

procedure THTTPServerThread.Execute;
begin
  try
    try
      Server.Active := True;
    except
      on E: Exception do
      begin
        _Error:= E.Message;
      end;
    end;
  finally
    FreeAndNil(Server);
  end;
end;

procedure THTTPServerThread.DoTerminate;
begin
  inherited DoTerminate;
  Server.Active := False;
end;

end.
