program threads_web;

{$mode objfpc}{$H+}
uses
  Classes, SysUtils, CustApp, web_sock;

type
  TSockets = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

procedure TSockets.DoRun;
var
  s: string;
  t: TWeb;

begin
  t:= TWeb.Create();
  t.Start;

  repeat
    readln(s);
  until s = 'x';
  writeln('stopping');

  t.Terminate;
  {need to do a get to stop the read}
  t.WaitFor;
  Terminate;
end;

constructor TSockets.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TSockets.Destroy;
begin
  inherited Destroy;
end;

var
  Application: TSockets;
begin
  Application:=TSockets.Create(nil);
  Application.Title:='My_Sockets';
  Application.Run;
  Application.Free;
end.

