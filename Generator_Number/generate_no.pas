unit generate_no;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TArrayIntegers64 = array of int64;

type
  { have a Randomize; before instantiating the class. number template uses wildcards * or ? like in shell}
  TGenerateNumber = class
  private
    _Number_Template: string;
    function GenerateRunes(pLength: byte): string;
  public
    constructor Create(pTemplate: string = '');   //ex. '00*?11? length 10
    function GetNumber(pLength: byte): string;
    procedure GetNumbers(pHowMany: word; pFrom, pTo: int64; var pArrayInt64: TArrayIntegers64);
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

  for i := 0 to Length(_Number_Template) - 1 do
  begin
    rune := copy(_Number_Template, i + 1, 1);

    if not TryStrToInt(rune, b) then
    begin
      case rune of
        '*':
        begin
          legal_length := pLength - (Length(_Number_Template) - i - 1) - Length(theNumber);

          if legal_length > 0 then
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

procedure TGenerateNumber.GetNumbers(pHowMany: word; pFrom, pTo: int64; var pArrayInt64: TArrayIntegers64);
var
  i: word;

begin
  SetLength(pArrayInt64, pHowMany);

  for i := Low(pArrayInt64) to High(pArrayInt64) do
  begin
    pArrayInt64[i] := RandomRange(pFrom, pTo);
  end;
end;

function TGenerateNumber.GenerateRunes(pLength: byte): string;
var
  i: byte;

begin
  Result := '';

  for i := 0 to pLength - 1 do
  begin
    Result := Result + RandomRange(0, 10).ToString;
  end;
end;

end.
