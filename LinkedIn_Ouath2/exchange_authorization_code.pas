unit exchange_authorization_code;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, synacode, constants, httpsend;

type
  TExchangeAuthCode = class
  private
    function StreamToString(aStream: TStream): string;
  public
    function AGet(AClientID, AClientSecret, TheAuthorizationCode: string; var AccessToken: string): string;
  end;

implementation

function TExchangeAuthCode.AGet(AClientID, AClientSecret, TheAuthorizationCode: string; var AccessToken: string): string;
var
  params: string = '';
  response: TStream;

begin
  params := params + 'grant_type=' + EncodeURLElement('authorization_code');
  params := params + '&code=' + EncodeURLElement(TheAuthorizationCode);
  params := params + '&redirect_uri=' + EncodeURLElement(RedirectURI + ':' + IntToStr(PortHTTPSetting));
  params := params + '&client_id=' + EncodeURLElement(AClientID);
  params := params + '&client_secret=' + EncodeURLElement(AClientSecret);

  try
    response := TMemoryStream.Create;
    if HttpPostURL(Exchange4TokenURL, params, response) then
    begin
      AccessToken := string(PansiChar(StreamToString(response)));
    end;
  finally
    if Assigned(response) then
      FreeAndNil(response);
  end;
end;

function TExchangeAuthCode.StreamToString(aStream: TStream): string;
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

end.
