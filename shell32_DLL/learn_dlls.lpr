program learn_dlls;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  CustApp,
  CTypes,windows,
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
  {pointer to record structure}
  PVersionInfoRecord = ^TVersionInfoRecord;

  TVersionInfoRecord = record
    cbSize: DWord;
    dwMajorVersion: DWord;
    dwMinorVersion: DWord;
    DdwBuildNumber: DWord;
    dwPlatformID: DWord;
  end;

type
  TLibVersion = function(APointer: PVersionInfoRecord): PVersionInfoRecord; stdcall;

  procedure TWorkDLL.DoRun;
  var
    DLLInstance: THandle;
    v: TLibVersion;
    {pointer instance}
    PVIR: PVersionInfoRecord;

  begin
    try
      try
        DLLInstance := SafeLoadLibrary('C:\Windows\System32\shell32.dll');

        if DLLInstance <> NilHandle then
        begin
          {dynamic loading of function}
          v := TLibVersion(GetProcedureAddress(DLLInstance, 'DllGetVersion'));
          if @v <> nil then
          begin

            New(PVIR);
            try
              ZeroMemory(PVIR, SizeOf(PVIR^));
              PVIR^.cbSize := SizeOf(PVIR^);  //'Microsoft: The cbSize member must be filled in before you call this function.'

              {calling the function}
              v(PVIR);

              writeln(IntToSTr(PVIR^.dwMajorVersion));
              writeln(IntToSTr(PVIR^.dwMinorVersion));
            finally
              Dispose(PVIR);
            end;

          end;
        end
        else
          writeln('there was an error');

      finally
        FreeLibrary(DLLInstance);
      end;

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
