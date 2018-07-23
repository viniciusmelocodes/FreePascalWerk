unit class_marshal;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  fpjson, jsonparser;

type
  TExRecord = record
    property1: string;
    property2: string;
  end;

  TArrayRecords = array of TExRecord;

type
  TJSONUtils = class
  public
    constructor Create();
    function RecordArrayToJSON(pRecordsArray: TArrayRecords): string;
  end;

implementation

constructor TJSONUtils.Create();
begin

end;

function TJSONUtils.RecordArrayToJSON(pRecordsArray: TArrayRecords): string;
var
  J: TJSONData;
  content: string;
  i: integer;

begin
  for i := Low(pRecordsArray) to High(pRecordsArray) do
  begin

  end;
end;

end.
