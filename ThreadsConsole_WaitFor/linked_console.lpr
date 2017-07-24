program linked_console;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX} {$IFDEF UseCThreads}
  cthreads, {$ENDIF} {$ENDIF}
  Classes,
  dateutils,
  SysUtils,
  CustApp,
  rest_api;

type
  TLinkApp = class(TCustomApplication)
  private
    t: TTest;
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure TheSignal(AMsg: string);
  end;

  procedure TLinkApp.DoRun;
  begin
    writeln('main thread');

    t := TTest.Create(True);
    t.OnFinish := @TheSignal;
    t.Start;        //start thread
    sleep(100);
    writeln('terminating thread: ' + IntToStr(MilliSecondOfTheSecond(now)));
    sleep(1);
    t.Terminate;
    t.WaitFor;  //waits for thread wrap up
    sleep(1);
    writeln('thread terminated: ' + IntToStr(MilliSecondOfTheSecond(now)));
    sleep(1);
    writeln('destroying thread: ' + IntToStr(MilliSecondOfTheSecond(now)));
    FreeAndNil(t);
    sleep(1);
    writeln('thread fred:' + IntToStr(MilliSecondOfTheSecond(now)));
    sleep(100);

    writeln('    ');
    Terminate;
  end;

  constructor TLinkApp.Create(TheOwner: TComponent);
  begin
    inherited Create(TheOwner);
    StopOnException := True;
  end;

  procedure TLinkApp.TheSignal(AMsg: string);
  begin
    writeln('MAIN: ' + AMsg + ': ' + IntToStr(MilliSecondOfTheSecond(now)));
  end;

  destructor TLinkApp.Destroy;
  begin
    inherited Destroy;
  end;

var
  Application: TLinkApp;
begin
  Application := TLinkApp.Create(nil);
  Application.Title := 'LinkedIn App';
  Application.Run;
  Application.Free;
end.
