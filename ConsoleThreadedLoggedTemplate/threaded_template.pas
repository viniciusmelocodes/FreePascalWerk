unit threaded_template;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TPassMessage = procedure(AMsg: string) of object;

type
  TQTemplate = class(TThread)
  private
    _PassMessage: TPassMessage;

  protected
    procedure Execute; override;
    procedure TriggerMessage(AMsg: string);

  public
    constructor Create(CreateSuspended: boolean);
    destructor Destroy(); override;

    property OnPassMessage: TPassMessage read _PassMessage write _PassMessage;
  end;

implementation

constructor TQTemplate.Create(CreateSuspended: boolean);
begin
  inherited Create(CreateSuspended);
  self.FreeOnTerminate := True;
end;

procedure TQTemplate.Execute;
begin
  TriggerMessage('execute');
end;

procedure TQTemplate.TriggerMessage(AMsg: string);
begin
  if Assigned(_PassMessage) then
    _PassMessage(AMsg);
end;

destructor TQTemplate.Destroy();
begin
  TriggerMessage('destroy');
  inherited Destroy;
end;

end.
