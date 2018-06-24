unit postgres_connect;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  Uni, pqconnection, PostgreSQLUniProvider;

type
  TPostgresConnInfo = record
    ServerIP: string;
    ListenPort: word;
    Username: string;
    Password: string;
    Database: string;
  end;

  TCreateDBHandler = class
  private
    _conn: TUniConnection;
    _transact: TUniTransaction;
    _connected: boolean;
    _error: string;

    procedure Connect();
  public
    constructor Create(ADBConnInfo: TPostgresConnInfo); reintroduce;
    destructor Destroy(); override;

    property IsConnected: boolean read _connected;
    property Errors: string read _error;
    property DBConnection: TUniConnection read _conn;
    property DBTransaction: TUniTransaction read _transact;
  end;

implementation

constructor TCreateDBHandler.Create(ADBConnInfo: TPostgresConnInfo);
begin
  _conn := TUniConnection.Create(nil);
  _conn.Server := ADBConnInfo.ServerIP;
  _conn.Port := ADBConnInfo.ListenPort;
  _conn.Username := ADBConnInfo.Username;
  _conn.Password := ADBConnInfo.Password;
  _conn.ProviderName := 'PostgreSQL';
  _conn.Database := ADBConnInfo.Database;

  self.Connect();
end;

procedure TCreateDBHandler.Connect();
begin
  try
    _conn.Connect;
  except
    on  E: Exception do
    begin
      _error := E.Message;
      writeln('TCreateDBHandler.Connect:' + _error);
    end;
  end;

  if _conn.Connected then
  begin
    _connected := True;

    _transact := TUniTransaction.Create(nil);
    _transact.DefaultConnection := _conn;
    writeln('Connected to:' + _conn.Server);
  end;
end;

destructor TCreateDBHandler.Destroy();
begin
  inherited Destroy;
end;

end.
