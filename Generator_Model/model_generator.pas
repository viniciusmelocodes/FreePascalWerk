unit model_generator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
   TGeneratorTypes = (GenericIPv4, GenericNumber);

   TGenerator = record
     GeneratorType: TGeneratorTypes;
     GeneratorTemplate: string;
     GeneratedLength: byte;
     UIPosition: byte;
   end;

   TGenerators = array of TGenerator;

implementation

end.

