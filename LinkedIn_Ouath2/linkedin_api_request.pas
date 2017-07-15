unit linkedin_api_request;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, fpjson, constants, ssl_openssl, fphttpclient;

type
  TLinkAPI = class
  private
    {the information would return in json. the url is variable}
    function GETInfo(AToken, AURL: string; var AResponse: string): string;
  public
    function GETPeopleInfo(AToken: string; var AJSON: TJSONData; var DebugMsg: string; IsDebug: boolean = False): string;
    function POSTComment(AToken, AComment: string; ACommentDistribution: integer; var DebugMsg: string; IsDebug: boolean = False): string;
  end;

implementation

function TLinkAPI.POSTComment(AToken, AComment: string; ACommentDistribution: integer; var DebugMsg: string; IsDebug: boolean = False): string;
var
  HTTPS: TFPHTTPClient;
  body: string = '';

begin
  try
    HTTPS := TFPHTTPClient.Create(nil);

    body := '<share>';
    body := body + '<comment>' + AComment + '</comment>';
    body := body + '<visibility>';

    case ACommentDistribution of
      0: body := body + '<code>anyone</code>';
      1: body := body + '<code>connections-only</code>';
    end;

    body := body + '</visibility>';
    body := body + '</share>';

    HTTPS.requestBody := TStringStream.Create(body);

    HTTPS.AddHeader('Authorization', 'Bearer ' + AToken);
    HTTPS.AddHeader('Content-Type', 'text/plain');

    try
      if IsDebug then
        DebugMsg := HTTPS.Post(DebugURL)
      else
        DebugMsg := HTTPS.Post(POSTCommentURL);

      DebugMsg := DebugMsg + '|' + body + '|';

    except
      on E: Exception do
      begin
        Result := E.ClassName + '|' + E.Message;
      end;
    end;

  finally
    FreeAndNil(HTTPS);
  end;
end;

function TLinkAPI.GETPeopleInfo(AToken: string; var AJSON: TJSONData; var DebugMsg: string; IsDebug: boolean = False): string;
var
  info: string;
  params: string = '';

begin
  params := params + 'format=' + EncodeURLElement('json');

  if IsDebug then
  begin
    Result := GETInfo(AToken, DebugURL + '?' + params, info);
    DebugMsg := Result + '|' + info;
  end
  else
    Result := GETInfo(AToken, PeopleInfoURL + '?' + params, info);

  DebugMsg := info;
  AJSON := GetJSON(info);
end;

function TLinkAPI.GETInfo(AToken, AURL: string; var AResponse: string): string;
var
  HTTPS: TFPHTTPClient;

begin
  try
    HTTPS := TFPHTTPClient.Create(nil);

    try
      HTTPS.AddHeader('Authorization', 'Bearer ' + AToken);
      HTTPS.AddHeader('x-li-format', 'json');
      HTTPS.AddHeader('Content-Type', 'application/json');

      AResponse := HTTPS.Get(AURL);
    except
      on E: Exception do
      begin
        Result := E.ClassName + '|' + E.Message;
      end;
    end;

  finally
    FreeAndNil(HTTPS);
  end;
end;

end.
