unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, IniFiles;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  end;

var
  Form1: TForm1;

const
  fname = 'settings.ini';

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
var
  n: TIniFile;
begin
  if not FileExists(fname) then
  begin
    n := TIniFile.Create(fname);
    n.WriteString('x', 'y', 'z');
    n.Free;
  end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  n: TIniFile;

begin
  if  FileExists(fname) then
  begin
    n := TIniFile.Create(fname);
    memo1.Append(n.ReadString('x', 'y', ''));
    n.Free;
  end;
end;

end.
