unit model_generator;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
   TGeneratorTypes = (GenericIPv4, GenericNumber);

   TGenerator = record
     GeneratorType: TGeneratorTypes;
     Name: string;
     GeneratorMask: string;
     GeneratedLength: byte;
     FromValue: string;
     ToValue: string;
     UIPosition: byte;
   end;

   TGenerators = array of TGenerator;

implementation

end.

