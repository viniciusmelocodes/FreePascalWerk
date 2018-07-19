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
   end;



implementation

end.

