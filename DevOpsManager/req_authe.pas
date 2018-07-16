unit req_authe;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  synacode, httpsend;

type
  TPassMessage = procedure(AMsg: string) of object;
  TPassJSON = procedure(AJSON: string) of object;

type
  TReqAuthentication = class(TThread)
  private
    _User: string;
    _Password: string;
    _URL: string;
    _PassMessage: TPassMessage;
    _PassJSON: TPassJSON;

    function StreamToString(aStream: TStream): string;
    procedure TriggerMessage(AMsg: string);
    procedure TriggerJSON(AJSON: string);

  protected
    procedure Execute; override;

  public
    constructor Create(AUser, APassword, AURL: string);
    destructor Destroy(); override;

    property OnPassMessage: TPassMessage read _PassMessage write _PassMessage;
    property OnPassJSON: TPassJSON read _PassJSON write _PassJSON;
  end;

implementation

constructor TReqAuthentication.Create(AUser, APassword, AURL: string);
begin
  inherited Create(False);
  self.FreeOnTerminate := True;

  _User := AUser;
  _Password := APassword;
  _URL := AURL;
end;

procedure TReqAuthentication.Execute;
var
  params: string = '';
  response: TStream;

begin
  try
    try
      response := TMemoryStream.Create;

      params := 'user=' + EncodeURLElement(_User);
      params := params + '&passwd=' + EncodeURLElement(_Password);

      TriggerMessage('HTTP Post: ' + params);

      if HttpPostURL(_URL, params, response) then
      begin
        TriggerJSON(StreamToString(response));
      end;

    except
      on E: Exception do
      begin
        TriggerMessage('TRequestAuthentication.Execute: ' + E.Message);
      end;
    end;

  finally
    FreeAndNil(response);
  end;
end;

procedure TReqAuthentication.TriggerMessage(AMsg: string);
begin
  if Assigned(_PassMessage) then
    _PassMessage(AMsg);
end;

procedure TReqAuthentication.TriggerJSON(AJSON: string);
begin
  if Assigned(_PassJSON) then
    _PassJSON(AJSON);
end;

function TReqAuthentication.StreamToString(aStream: TStream): string;
var
  SS: TStringStream;

begin
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      SS.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end
  else
  begin
    Result := '';
  end;
end;

destructor TReqAuthentication.Destroy;
begin
  inherited Destroy;
end;

end.
