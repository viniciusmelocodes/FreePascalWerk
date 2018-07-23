unit gen_to_file;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  model_generator;

type
  TGeneratorUtils = class
  private
    _FileName: string;
  public
    constructor Create(pFileName: string = '');
    procedure GeneratorsSave(pGenerators: TGenerators);
    function GeneratorsLoad(pData: string): TGenerators;
  end;

implementation

constructor TGeneratorUtils.Create(pFileName: string = '');
begin
  _FileName := pFileName;
end;

procedure GeneratorsSave(pGenerators: TGenerators);
begin

end;

function GeneratorsLoad(pData: string): TGenerators;
begin

end;

end.
