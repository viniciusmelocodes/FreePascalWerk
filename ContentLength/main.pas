unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  md5;

type

  { TForm1 }

  TForm1 = class(TForm)
    Memo1: TMemo;
    procedure FormShow(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Memo1Change(Sender: TObject);
var
  log_md: TStringList;
  scheck: string;

begin
  log_md := TStringList.Create;

  scheck := MD5Print(MD5String(trim(Memo1.Text)));
  log_md.Append(scheck);
  Form1.Caption := 'Text Length = ' + IntToStr(Length(trim(Memo1.Text))) + '|' + scheck;

  log_md.SaveToFile('md5.txt');
  FreeAndNil(log_md);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  Form1.Caption := 'Paste text to get length.';
end;

end.

