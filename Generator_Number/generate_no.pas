unit generate_no;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TGenerateNumber = class
  private
    _Number_Template: string;
    function GenerateRunes(pLength: byte): string;
  public
    constructor Create(pTemplate: string = '');   //ex. '00*?11? length 10
    function GetNumber(pLength: byte): string;
  end;

implementation

constructor TGenerateNumber.Create(pTemplate: string = '');
begin
  _Number_Template := pTemplate;
end;

function TGenerateNumber.GetNumber(pLength: byte): string;
var
  i: byte;
  b: integer;
  theNumber: string;
  rune: string;
  legal_length: byte;

begin
  if Length(_Number_Template) > pLength then
    exit;

  if Length(_Number_Template) = 0 then
  begin
    Result := GenerateRunes(pLength);
    exit;
  end;

  Randomize; //just in case needed. so it is not called to often

  for i := 0 to pLength - 1 do
  begin
    rune := copy(_Number_Template, i + 1, 1);

    if not TryStrToInt(rune, b) then
    begin
      case rune of
        '*':
        begin
          legal_length := pLength - Length(theNumber) - i;
          theNumber := theNumber + GenerateRunes(legal_length);
        end;
        '?':
        begin
          theNumber := theNumber + RandomRange(0, 10).ToString;
        end;
      end;
      continue;
    end;

    theNumber := theNumber + rune;
  end;

  Result := theNumber;
end;

function TGenerateNumber.GenerateRunes(pLength: byte): string;
var
  i: byte;

begin
  Randomize;

  Result := '';

  for i := 0 to pLength - 1 do
  begin
    Result := Result + RandomRange(0, 10).ToString;
  end;
end;

end.
