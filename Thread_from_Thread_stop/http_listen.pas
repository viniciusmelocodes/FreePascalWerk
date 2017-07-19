unit http_listen;

{$mode objfpc}{$H+}
interface
uses
  Classes, SysUtils, fphttpapp, fphttpserver;

type
  THTTPServerThread = class(TThread)
  private
    _Error: string;
  public
    Server: TFPHTTPServer;
    constructor Create(APort: word);
    destructor Destroy; override;
    procedure Execute; override;
    property Error: string read _Error;
  end;

implementation
constructor THTTPServerThread.Create(APort: word);
begin
  Server := TFPHTTPServer.Create(nil);
  Server.Port := APort;
  _Error := 'nil';

  Self.FreeOnTerminate := True;
  inherited Create(False);
end;

destructor THTTPServerThread.Destroy;
begin
  Server.Free;
end;

procedure THTTPServerThread.Execute;
begin
  try
    try
      Server.Active := True;
    except
      on E: Exception do
      begin
        _Error := E.Message;
      end;
    end;
  finally
    FreeAndNil(Server);
  end;
end;

end.
