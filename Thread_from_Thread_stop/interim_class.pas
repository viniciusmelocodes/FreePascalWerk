unit interim_class;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, http_listen, fphttpserver;

type
  TPushRequestNotif = procedure() of object;

type
  TServer = class
  private
    _t: THTTPServerThread;
    _EvRequest: TPushRequestNotif;
  public
    constructor Create(APort: word);
    destructor Destroy(); override;
    procedure onRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest;
      var AResponse: TFPHTTPConnectionResponse);
    property OnHTTPRequest: TPushRequestNotif read _EvRequest write _EvRequest;
  end;

implementation

constructor TServer.Create(APort: word);
begin
  _t := THTTPServerThread.Create(8001);
  _t.Server.OnRequest := @self.onRequest;
end;

destructor TServer.Destroy();
begin
  _t.Server.Active := False;
  inherited Destroy;
end;

procedure TServer.onRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest;
  var AResponse: TFPHTTPConnectionResponse);
begin
  if Assigned(_EvRequest) then
  begin
    _EvRequest;
  end;
end;

end.
