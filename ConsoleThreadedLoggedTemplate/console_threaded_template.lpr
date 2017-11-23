program console_threaded_template;

{$mode objfpc}{$H+}

uses
  Classes,
  SysUtils,
  CustApp,
  tlogger, threaded_template;

type
  TTemplate = class(TCustomApplication)
  private
    _G: TQLogger;
    procedure CatchMessage(AMessage: string);
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

const
  FName = 'x.log';

  procedure TTemplate.DoRun;
  var
    t: TQTemplate;

  begin
    _G := TQLogger.Create(FName);

    CatchMessage('started');

    t:= TQTemplate.Create(false);
    t.OnPassMessage:=@CatchMessage;

    sleep(100);
    _G.Terminate;
    _G.WaitFor;
    _G.Destroy();

    Terminate;
  end;

  constructor TTemplate.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  procedure TTemplate.CatchMessage(AMessage: string);
  begin
    repeat
      sleep(1);
    until _G.PCanAppend;

    _G.PToAppend := AMessage;
  end;

  destructor TTemplate.Destroy;
  begin
    inherited Destroy;
  end;

var
  Application: TTemplate;
begin
  Application := TTemplate.Create(nil);
  Application.Title := 'TheadedTemplate';
  Application.Run;
  Application.Free;
end.
