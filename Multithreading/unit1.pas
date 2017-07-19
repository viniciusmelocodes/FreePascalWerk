unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type
  TMyThread1 = class(TThread)
  private
    fStatusText: string;
    _TerminateT1: boolean;
    procedure ShowStatus;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    property Terminate : boolean read _TerminateT1 write _TerminateT1;
  end;


  TMyThread2 = class(TThread)
  private
    fStatusText: string;
    _TerminateT2: boolean;
    procedure ShowStatus;
  protected
    procedure Execute; override;
  public
    constructor Create(CreateSuspended: boolean);
    property Terminate : boolean read _TerminateT2 write _TerminateT2;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  end;

var
  Form1: TForm1;
   _MyThread1: TMyThread1;
   _MyThread2: TMyThread2;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
begin
  _MyThread1 := TMyThread1.Create(True);
  if Assigned(_MyThread1.FatalException) then
    raise _MyThread1.FatalException;
  _MyThread1.Start;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  _MyThread2 := TMyThread2.Create(True);
  if Assigned(_MyThread2.FatalException) then
    raise _MyThread2.FatalException;
  _MyThread2.Start;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  _MyThread1.Terminate:= false;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  _MyThread2.Terminate:= false;
end;

procedure TMyThread1.ShowStatus;
begin
  Form1.Memo1.Text := fStatusText;
end;

procedure TMyThread2.ShowStatus;
begin
  Form1.Memo2.Text := fStatusText;
end;

procedure TMyThread1.Execute;
begin
  while (not Terminated) and _TerminateT1 do
  begin
    fStatusText := FormatDateTime('YYYY-MM-DD HH:NN:SS', Now - 100000);
    Synchronize(@Showstatus);

    sleep(200);
  end;
end;

procedure TMyThread2.Execute;
begin
  while (not Terminated) and _TerminateT2 do
  begin
    fStatusText := FormatDateTime('YYYY-MM-DD HH:NN:SS', Now + 100000);
    Synchronize(@Showstatus);

    sleep(200);
  end;
end;

constructor TMyThread1.Create(CreateSuspended: boolean);
begin
  _TerminateT1:= true;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

constructor TMyThread2.Create(CreateSuspended: boolean);
begin
  _TerminateT2:= true;
  FreeOnTerminate := True;
  inherited Create(CreateSuspended);
end;

end.
