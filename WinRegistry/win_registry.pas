unit win_registry;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, registry;

type
  TWinRegistry = class
  public
    function DelRegValue(AppName: string; out err: string): boolean;
    function RdKey(ARootKey: qword; AKey, AEntry: string; out err: string; out TheValue: string): boolean;
    function EnStartUp(AppName, APath: string; out err: string): boolean;
  end;

const
  HIVE = 'Software\Microsoft\Windows\CurrentVersion\Run';
  ROOT = HKEY_CURRENT_USER;  //this registry ROOT key allows writes from apps

implementation

function TWinRegistry.DelRegValue(AppName: string; out err: string): boolean;
var
  r: TRegistry;

begin
  err := 'nil';
  Result := False;

  try
    r := TRegistry.Create;
    r.RootKey := ROOT;

    if r.OpenKey(HIVE, False) then
    begin
      if r.DeleteValue(AppName) then
      begin
        Result := True;
      end
      else
      begin
        err := 'Registry value was not deleted';
      end;
    end else err := 'HIVE could not be open';

    r.CloseKey;
    FreeAndNil(r);
  except
    on E: Exception do
    begin
      err := E.Message;
    end;
  end;
end;

function TWinRegistry.RdKey(ARootKey: qword; AKey, AEntry: string; out err: string; out TheValue: string): boolean;
var
  r: TRegistry;

begin
  try
    r := TRegistry.Create;
    r.RootKey := ARootKey;

    err := 'nil';
    Result := False;

    if r.OpenKeyReadOnly(AKey) then
    begin
      if r.ValueExists(AEntry) then
      begin
        TheValue := r.ReadString(AEntry);
        Result := True;
      end
      else
      begin
        err := 'Key Value does not exist';
      end;
    end
    else
      err := 'Registry Key does not exist';
  finally
    FreeAndNil(r);
  end;
end;

function TWinRegistry.EnStartUp(AppName, APath: string; out err: string): boolean;
var
  r: TRegistry;
  e, v: string;

begin
  {understand if key value already written}
  if RdKey(ROOT, HIVE, AppName, e, v) and (v = APath) then
  begin
    writeln('value: ' + v);
    {key already exists and value like the one we want to write}
    Result := False;
    err := 'Value already exists';
    exit;
  end
  else
  begin
    try
      try
        r := TRegistry.Create(KEY_WRITE);   //enables write operations on the hive
        r.RootKey := ROOT;

        if r.OpenKey(HIVE, False) then
        begin
          r.WriteString(AppName, APath);
          {reading again to check if value was correctly written}
          if RdKey(ROOT, HIVE, AppName, e, v) and (v = APath) then
            Result := True
          else
          begin
            err := 'Rewrite did not work';
            Result := False;
          end;
        end
        else
        begin
          err := 'HIVE could not be open';
          Result := False;
        end;
      except
        on E: Exception do
        begin
          err := E.Message;
          Result := False;
        end;
      end;
    finally
      r.CloseKey;
      r.Free;
    end;
  end;
end;

end.
