program learn_dlls;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  CustApp,
  CTypes,
  Windows,
  dynlibs,
  get_dll_version;

type
  TWorkDLL = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

  procedure TWorkDLL.DoRun;
  var
    Res: string;

  begin
    {$IFDEF MSWINDOWS}
    if GetDLLVersion('C:\Windows\system32\shell32.dll', Res) then
      Writeln(Res)
    else
      Writeln('Error: ' + Res);
    {$ENDIF}
    Terminate;
  end;

  constructor TWorkDLL.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  destructor TWorkDLL.Destroy;
  begin
    inherited Destroy;
  end;

var
  Application: TWorkDLL;
begin
  Application := TWorkDLL.Create(nil);
  Application.Title := 'Test_DLL';
  Application.Run;
  Application.Free;
end.
