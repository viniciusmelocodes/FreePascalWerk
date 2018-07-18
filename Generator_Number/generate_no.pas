unit generate_no;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Math;

type
  TGenerateNumber = class
  private
    _Number_Template: string;
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

  Randomize; //just in case needed. so it is not called to often

  for i := 1 to pLength do
  begin
    rune := copy(_Number_Template, i, 1);

    if not TryStrToInt(rune, b) then
    begin
      case rune of
        '*':
        begin
          legal_length := pLength - i;
          theNumber := theNumber + RandomRange(0, 10 * legal_length).ToString;
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
end;

end.
