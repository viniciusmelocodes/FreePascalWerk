program learn_dlls;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  CustApp,
  dynlibs;

type
  TWorkDLL = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

type
  TUserAdmin = function: boolean; stdcall;

  procedure TWorkDLL.DoRun;
  var
    DLLInstance: THandle;
    isAdmin: TUserAdmin;

  begin
    try
      DLLInstance := LoadLibrary('C:\Windows\System32\shell32.dll');

      if DLLInstance > 0 then
      begin
         isAdmin:= TUserAdmin(GetProcAddress(DLLInstance, 'IsUserAnAdmin'));
         writeln(isAdmin);
      end else writeln('there was an error');

    except
      on E: Exception do
      begin
        writeln('error: ' + E.Message);
      end;
    end;

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
