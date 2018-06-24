unit compress_folder;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Zipper;

type
  TPassError = procedure(AError: string) of object;
  TPassZipped = procedure(AFolder: string) of object;

  TTCompressFolder = class(TThread)
  private
    _Error: TPassError;
    _Zipped: TPassZipped;
    _FolderPath: string;
    _ZipName: string;

    procedure TriggerError(AError: string);
    procedure TriggerZipped(AFolder: string);
  protected
    procedure Execute; override;

  public
    constructor Create(AFolderPath, AZipName: string); reintroduce;
    destructor Destroy(); override;

    property OnPassError: TPassError read _Error write _Error;
    property OnPassZipped: TPassZipped read _Zipped write _Zipped;
  end;

implementation

constructor TTCompressFolder.Create(AFolderPath, AZipName: string);
begin
  _FolderPath := AFolderPath;
  _ZipName := AZipName;

  inherited Create(False);
  self.FreeOnTerminate := True;
end;

procedure TTCompressFolder.Execute;
var
  z: TZipper;
  TheFileList: TStringList;

begin
  if DirectoryExists(_FolderPath) then
  begin
    try
      try
        z := TZipper.Create();
        z.FileName := _ZipName;
        TheFileList := TStringList.Create;

        FindAllFiles(TheFileList, _FolderPath);
        z.Entries.AddFileEntries(TheFileList);
        z.ZipAllFiles;
      except
        on E: Exception do
        begin
          WriteLn('TTZipper.Execute: ' + E.Message);
        end;
      end;

      TriggerError('Zipped: ' + _FolderPath);
    finally
      FreeAndNil(TheFileList);
      FreeAndNil(z);

      DeleteDirectory(_FolderPath, false);
      TriggerZipped(_FolderPath);
    end;
  end
  else
    TriggerError('Folder not found');
end;

procedure TTCompressFolder.TriggerError(AError: string);
begin
  if Assigned(_Error) then
    _Error(AError);
end;

procedure TTCompressFolder.TriggerZipped(AFolder: string);
begin
  if Assigned(_Zipped) then
    _Zipped(AFolder);
end;

destructor TTCompressFolder.Destroy();
begin
  inherited Destroy;
end;

end.
