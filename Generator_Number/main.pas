unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, Math, generate_ip;

type
  TArrayIntegers64 = array of int64;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    procedure GenerateRandomNumbers(pNo: word; pFrom, pTo: int64; var pArrayInt64: TArrayIntegers64);
    function GenerateRandomIP(pTemplate: string = ''): string;
  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  i: word;

begin
  Randomize;

  for i := 0 to 10 do
  begin
    Memo1.Append(RandomRange(1, 100).ToString);
  end;

  Memo1.Append('--------');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  memo1.Append(GenerateRandomIP('*.*.*.*'));
  memo1.Append(GenerateRandomIP('*.1?.?1.?'));
  memo1.Append(GenerateRandomIP('*.1?1.1*1.2*'));
  memo1.Append(GenerateRandomIP('*11.111.*11.?11'));

  Memo1.Append('--------');
end;

procedure TForm1.GenerateRandomNumbers(pNo: word; pFrom, pTo: int64; var pArrayInt64: TArrayIntegers64);
var
  i: word;

begin
  SetLength(pArrayInt64, pNo);

  Randomize;
  for i := Low(pArrayInt64) to High(pArrayInt64) do
  begin
    pArrayInt64[i] := RandomRange(pFrom, pTo);
  end;
end;

function TForm1.GenerateRandomIP(pTemplate: string = ''): string;
var
  ip: TGenerateIP;
  theIPv4: IPv4;

begin
  if Length(pTemplate) = 0 then
  begin
    Randomize;
    theIPv4.a := RandomRange(0, 256).ToString;
    theIPv4.b := RandomRange(0, 256).ToString;
    theIPv4.c := RandomRange(0, 256).ToString;
    theIPv4.d := RandomRange(0, 256).ToString;

    Result := theIPv4.a + '.' + theIPv4.b + '.' + theIPv4.c + '.' + theIPv4.d;
    exit;
  end;

  //*.1*2.??1.1?1
  ip := TGenerateIP.Create(pTemplate);
  Result := ip.GetIP();
  FreeAndNil(ip);
end;

end.
