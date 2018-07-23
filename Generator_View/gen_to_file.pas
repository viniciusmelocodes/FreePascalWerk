unit gen_to_file;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, strutils, typinfo,
  model_generator;

type
  TGeneratorUtils = class
  private
    _FileName: string;
  public
    constructor Create(pFileName: string = '');
    procedure GeneratorsSave(pGenerators: TGenerators);
    function GeneratorsLoad(): TGenerators;
  end;

implementation

constructor TGeneratorUtils.Create(pFileName: string = '');
begin
  _FileName := pFileName;
end;

procedure TGeneratorUtils.GeneratorsSave(pGenerators: TGenerators);
var
  content: TStringList;
  i: byte;
  sep: string = ',';

begin
  content := TStringList.Create;

  for i := Low(pGenerators) to High(pGenerators) do
  begin
    content.Append(Ord(pGenerators[i].GeneratorType).ToString + sep + pGenerators[i].Name + sep + pGenerators[i].GeneratorMask + sep +
      pGenerators[i].GeneratedLength.ToString + sep + pGenerators[i].FromValue + sep + pGenerators[i].ToValue + pGenerators[i].UIPosition.ToString);
  end;

  content.SaveToFile(_FileName);
  FreeAndNil(content);
end;

function TGeneratorUtils.GeneratorsLoad(): TGenerators;
var
  content: TStringList;
  i: byte;

begin
  content := TStringList.Create;
  content.LoadFromFile(_FileName);

  {
  format: gen type, name, mask, length, from value, to value, UI position
  }

  for i := 0 to content.Count - 1 do
  begin
    SetLength(Result, Length(Result) + 1);

    Result[High(Result)].GeneratorType := TGeneratorTypes(ExtractDelimited(0, content[i], [',']).ToInteger);
    Result[High(Result)].Name := ExtractDelimited(1, content[i], [',']);
    Result[High(Result)].GeneratorMask := ExtractDelimited(2, content[i], [',']);
    Result[High(Result)].GeneratedLength := ExtractDelimited(3, content[i], [',']).ToInteger;
    Result[High(Result)].FromValue := ExtractDelimited(4, content[i], [',']);
    Result[High(Result)].ToValue := ExtractDelimited(1, content[i], [',']);
    Result[High(Result)].UIPosition := ExtractDelimited(1, content[i], [',']).ToInteger;
  end;

  FreeAndNil(content);
end;

end.
