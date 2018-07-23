unit gen_to_json;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  model_generator;

type
  TGeneratorJSON = class
  public
    constructor Create();
    function GeneratorsToJSON(pGenerators: TGenerators): string;
    function JSONToGenerators(pJSON: string): TGenerators;
  end;

implementation

constructor TGeneratorJSON.Create();
begin

end;

function GeneratorsToJSON(pGenerators: TGenerators): string;
begin

end;

function JSONToGenerators(pJSON: string): TGenerators;
begin

end;

end.
