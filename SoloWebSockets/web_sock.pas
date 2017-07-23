unit web_sock;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Sockets;

type
  TWeb = class(TThread)
  private
    _MainSocket: word;
    _IAddr: TINetSockAddr; //internet address
    _ASocket: integer;
    _RequestBody: string;
    {connects and populates the connected socket}
    function Connect: string;
    function sRead: string;
    function sWrite(AMsg: string): string;
  protected
    procedure Execute; override;
  public
    constructor Create();
    destructor Destroy; override;
  end;

implementation

const
  packet_size = 56000;

constructor TWeb.Create();
begin
  FreeOnTerminate := True;
  inherited Create(False);

  _MainSocket := fpsocket(AF_INET, SOCK_STREAM, 0);
  _IAddr.sin_family := AF_INET;
  _IAddr.sin_port := htons(81);
  _IAddr.sin_addr.s_addr := longword(StrToNetAddr('127.0.0.1'));

  fpbind(_MainSocket, @_IAddr, SizeOf(_IAddr));
  fplisten(_MainSocket, 1);
  writeln('server created');
end;

destructor TWeb.Destroy;
begin
  writeln('freeing resources');
  fpshutdown(_MainSocket, 2);
  CloseSocket(_MainSocket);
  writeln('resources fred');
  inherited Destroy;
end;

function TWeb.Connect: string;
var
  sAddrSize: longint;
begin
  Result := 'nil';
  try
    writeln('connecting');
    sAddrSize := SizeOf(_IAddr);
    _ASocket := fpaccept(_MainSocket, @_IAddr, @sAddrSize);
    if _ASocket > 0 then
      writeln('socket: ' + IntToStr(_ASocket));
  except
    on E: Exception do
    begin
      Result := E.Message;
    end;
  end;
end;

function TWeb.sRead: string;
var
  buf: string;
  c: integer;
begin
  Result := 'nil';
  try
    writeln('listening');
    setLength(buf, packet_size);

    c := fprecv(_ASocket, PChar(buf), packet_size, 0);
    writeln('c:' + IntToStr(c));
    setLength(buf, c);
    _RequestBody := buf;

    if Length(trim(_RequestBody)) > 0 then
      writeln(_RequestBody);
  except
    on E: Exception do
    begin
      Result := E.Message;
    end;
  end;
end;

function TWeb.sWrite(AMsg: string): string;
begin
  try
    writeln('start write');
    fpsend(_ASocket, PChar(AMsg), Length(AMsg), 0);
    writeln('finish write');
  except
    on E: Exception do
    begin
      writeln('error write: ' + E.Message);
      Result := E.Message;
    end;
  end;
end;

procedure TWeb.Execute;
begin
  writeln('server started');
  while not Terminated do
  begin
    writeln('-----work------');
    writeln('connect:' + Connect);
    writeln('read:' + sRead);
    writeln('-----------');

    if Length(trim(_RequestBody)) > 0 then
    begin
      writeln('write response');
      sWrite('Thank you.');
      writeln('response written');
    end;

    sleep(100);
    {closing socket}
    if _ASocket > 0 then
    begin
      writeln('closing socket');
      writeln(IntToStr(CloseSocket(_ASocket)));
    end
    else
      writeln(IntToStr(_ASocket));
  end;
end;

end.
