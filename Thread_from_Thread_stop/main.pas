unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,interim_class,
  StdCtrls;

type
  TForm1 = class(TForm)
    stop: TButton;
    start: TButton;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure startClick(Sender: TObject);
    procedure stopClick(Sender: TObject);
    procedure UpDateMemo();
  end;

var
  Form1: TForm1;
  _s: TServer;

implementation

{$R *.lfm}
procedure TForm1.startClick(Sender: TObject);
begin
  start.Enabled := False;
  _s:= TServer.Create(8001);
  _s.OnHTTPRequest := @UpDateMemo;
  stop.Enabled := True;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  stop.Enabled := False;
end;

procedure TForm1.stopClick(Sender: TObject);
begin
  Application.ProcessMessages;
  stop.Enabled := False;
  _s.Destroy();
  start.Enabled := True;
end;

procedure TForm1.UpDateMemo();
begin
  Memo1.Append('HTTP request');
end;


end.
