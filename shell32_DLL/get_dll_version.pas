unit get_dll_version;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF UNIX}cthreads,{$ENDIF}
  Classes,
  SysUtils,
  dynlibs
  {$IFDEF MSWINDOWS}, Windows{$ENDIF};

function GetDLLVersion(const AFileName: string; out AResult: string): boolean;

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
  TLibVersion = function(APointer: PVersionInfoRecord): HRESULT; stdcall;

implementation

{$IFDEF MSWINDOWS}
function GetDLLVersion(const AFileName: string; out AResult: string): boolean;
var
  DLLInstance: THandle;
  v: TLibVersion;
  {pointer instance}
  PVIR: PVersionInfoRecord;

begin
  Result := False;

  try
    try
      DLLInstance := SafeLoadLibrary(AFileName);

      if DLLInstance <> NilHandle then
      begin
        v := TLibVersion(GetProcedureAddress(DLLInstance, 'DllGetVersion'));

        if @v <> nil then
        begin
          New(PVIR);
          try
            ZeroMemory(PVIR, SizeOf(PVIR^));
            PVIR^.cbSize := SizeOf(PVIR^);

            if v(PVIR) = S_OK then
            begin
              AResult := IntToStr(PVIR^.dwMajorVersion) + '|' + IntToStr(PVIR^.dwMinorVersion) + '|' + IntToStr(PVIR^.DdwBuildNumber);
              Result := True;
            end
            else
              AResult := SysErrorMessage(GetLastOSError);
          finally
            Dispose(PVIR);
          end;
        end;
      end
      else
        AResult := SysErrorMessage(GetLastOSError);

    finally
      FreeLibrary(DLLInstance);
    end;
  except
    on E: Exception do
    begin
      AResult := SysErrorMessage(GetLastOSError);
    end;
  end;
end;

{$ENDIF}


end.
