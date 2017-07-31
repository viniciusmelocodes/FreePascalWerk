program project1;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  CustApp,
  registry,
  win_registry;

type
  TRegs = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

  procedure TRegs.DoRun;
  var
    a, p: string;
    r: TWinRegistry;
    err: string;

  begin
    a := GetOptionValue('a');
    p := GetOptionValue('p');

    try
      r := TWinRegistry.Create;

      if r.EnStartUp(a, p, err) then
        writeln('Registry entry created.')
      else
        writeln('Error: ' + err);

      if r.DelRegValue(a, err) then
        writeln('Entry ' + a + ' deleted.')
      else
        writeln('Error: ' + err);

    finally
      FreeAndNil(r);
    end;

    writeln(' ');
    Terminate;
  end;

  constructor TRegs.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor TRegs.Destroy;
  begin
    inherited Destroy;
  end;

var
  Application: TRegs;
begin
  Application := TRegs.Create(nil);
  Application.Title := 'RegistryTest';
  Application.Run;
  Application.Free;
end.
