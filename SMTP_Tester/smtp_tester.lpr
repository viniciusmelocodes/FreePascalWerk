program smtp_tester;

{$mode objfpc}{$H+}

uses {$IFDEF UNIX}
  cthreads, {$ENDIF}
  Interfaces,
  Forms,
  main, email_sending,
  laz_synapse;

{$R *.res}

begin
  Application.Scaled:=True;
  Application.Title:='SMTP Tester';
  RequireDerivedFormResource := True;

  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
