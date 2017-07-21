unit rest_api;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, dateutils;

type
  TThreadFinished = procedure(AMsg: string) of object;

type
  TTest = class(TThread)
  private
    Event_Finish: TThreadFinished;
    procedure Ready1();
    procedure Ready2();
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
  public
    constructor Create(CreateSuspended: boolean);
    destructor Destroy(); override;
    property OnFinish: TThreadFinished read Event_Finish write Event_Finish;
  end;

implementation

constructor TTest.Create(CreateSuspended: boolean);
begin
  //self.FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

procedure TTest.Execute;
begin
  sleep(1);
  writeln('execute: ' + IntToStr(MilliSecondOfTheSecond(now)));
  sleep(1);
  //Synchronize(@Ready1);   //if taken out Synchronize(@Ready2) does not execute. because not enough time in main thread. use waitfor!
end;

procedure TTest.DoTerminate;
begin
  sleep(1);
  Synchronize(@Ready2);
  sleep(1);
  writeln('do terminate: ' + IntToStr(MilliSecondOfTheSecond(now)));

  inherited DoTerminate;
end;

procedure TTest.Ready1();
begin
  sleep(1);
  writeln('ready: ' + IntToStr(MilliSecondOfTheSecond(now)));
  sleep(1);
  if Assigned(Event_Finish) then
    Event_Finish('thread ready 1');
  sleep(1);
end;

procedure TTest.Ready2();
begin
  sleep(1);
  writeln('ready: ' + IntToStr(MilliSecondOfTheSecond(now)));
  sleep(1);
  if Assigned(Event_Finish) then
    Event_Finish('thread ready 2');
  sleep(1);
end;

destructor TTest.Destroy();
begin
  sleep(1);
  writeln('destroy: ' + IntToStr(MilliSecondOfTheSecond(now)));
  inherited Destroy;
  sleep(1);
  writeln('destroyed: ' + IntToStr(MilliSecondOfTheSecond(now)));
  sleep(1);
end;

end.
