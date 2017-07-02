unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, md5;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    procedure Button1Click(Sender: TObject);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.Button1Click(Sender: TObject);
var
  dialog: TOpenDialog;
  filePath: string;

begin
  Memo1.Clear;
  dialog := TOpenDialog.Create(nil);
  dialog.InitialDir := ExtractFilePath(Application.ExeName);
  if dialog.Execute then
  begin
    if Length(dialog.FileName) > 0 then
      filePath := dialog.FileName;
  end;
  dialog.Free;

  Memo1.Append(filePath);
  Memo1.Append(MD5Print(MD5File(filePath)));
end;

end.
