unit tlogger;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, LCLIntf;

type
  TInfos = array of string;
  CannotAppendException = class(Exception);

  TQLogger = class(TThread)
  private
    _Infos: TInfos;
    _FName: string;
    _CanAppend: boolean;  //wait to write current
    _ToAppend: string;

    procedure ReceiveToApend(AToAppend: string);

  protected
    procedure Execute(); override;

  public
    constructor Create(AFileName: string); reintroduce;
    destructor Destroy(); override;

    property PCurrentLogFile: string read _FName;
    property PCanAppend: boolean read _CanAppend;
    property PToAppend: string read _ToAppend write ReceiveToApend;
  end;


implementation

constructor TQLogger.Create(AFileName: string);
begin
  _FName := AFileName;
  SetLength(_Infos, 0);

  inherited Create(False);
end;

procedure TQLogger.Execute();
var
  f: TextFile;
  i: word;

begin
  {Create new file}
  AssignFile(f, _FName);
  ReWrite(f);
  CloseFile(f);

  _CanAppend := True;

  while not Terminated do
  begin

    if Length(_Infos) > 0 then
    begin
      try
        _CanAppend := False;
        Append(f);

        repeat
          WriteLn(f, _Infos[0]);

          for i := 1 to Length(_Infos) - 1 do
          begin
            _Infos[i - 1] := _Infos[i];
          end;
          SetLength(_Infos, Length(_Infos) - 1);     //delete element that was just written
        until Length(_Infos) = 0;

        CloseFile(f);
        _CanAppend := True;

      except
        on E: Exception do
        begin
          writeln('exception: ' + E.Message);
        end;
      end;
    end;

    sleep(50);
  end;
end;

procedure TQLogger.ReceiveToApend(AToAppend: string);
begin
    if not _CanAppend then
      raise CannotAppendException.Create('Cannot append: ' + AToAppend);

    if Length(trim(AToAppend)) > 0 then
    begin
      SetLength(_Infos, Length(_Infos) + 1);
      _Infos[Length(_Infos) - 1] := FormatDateTime('hh:nn:ss.zzz', Now()) + '|' + AToAppend;
    end;
end;

destructor TQLogger.Destroy();
begin
  inherited Destroy;
end;

end.
