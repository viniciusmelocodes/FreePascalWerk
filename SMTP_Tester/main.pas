unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls,
  email_sending;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    SMTP_IP: TLabeledEdit;
    Memo1: TMemo;
    Recipient: TLabeledEdit;

    procedure BitBtn1Click(Sender: TObject);
  private
    function SecondsFromMidnight(time: TDateTime; aOption: integer = -1): integer;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
var
  a: TAlert;
  t1, t2: TDateTime;
  r: boolean;

begin
  try
    try
      a := TAlert.Create(trim(SMTP_IP.Text));
      t1 := now();
      r := a.EmailNoAttachment('Test of SMTP', Recipient.Text, 'Test of SMTP', 'x@x.com');
      t2 := now();

      Memo1.Text := 'Email sent: ' + BoolToStr(r, True);
      Memo1.Append('Duration In Seconds: ' + IntToStr(SecondsFromMidnight(t2, -1) - SecondsFromMidnight(t1, -1)));
      Memo1.Append('Duration In Miliseconds: ' + IntToStr(SecondsFromMidnight(t2, 1) - SecondsFromMidnight(t1, 1)));

    except
      on E: Exception do
      begin
        Memo1.Append(E.Message);
      end;
    end;

  finally
    a.Free;
  end;

end;

function TForm1.SecondsFromMidnight(time: TDateTime; aOption: integer = -1): integer;
var
  seconds: integer;
  miliseconds: integer;
  myHour, myMin, mySec, myMilli: word;

begin
  DecodeTime(time, myHour, myMin, mySec, myMilli);
  seconds := myHour * 3600 + myMin * 60 + mySec;
  miliseconds := seconds * 1000 + myMilli;

  if aOption = -1 then
    Result := seconds
  else
    Result := miliseconds;
end;

end.
