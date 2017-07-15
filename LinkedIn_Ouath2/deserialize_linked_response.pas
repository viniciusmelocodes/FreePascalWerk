unit deserialize_linked_response;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, constants, fpjson, jsonparser, json_pull;

type
  TDeSerResponse = class
  public
    function GetToK(ALinkResponse: string; var AToken: TAccessToken): string;
  end;

implementation

function TDeSerResponse.GetToK(ALinkResponse: string; var AToken: TAccessToken): string;
var
  JSON: TJSONData;
  i: integer;

begin
  JSON := GetJSON(ALinkResponse);

  for i := 0 to JSON.Count - 1 do
  begin
    AToken.ToKValue := JSON.FindPath('access_token').AsString;
    AToken.TimeToLive := StrToInt(JSON.FindPath('expires_in').AsString);
  end;
end;

end.
