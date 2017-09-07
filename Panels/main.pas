unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  qpanel, form_text;

type
  TForm1 = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    procedure FormActivate(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
  private
    _ID: integer; //id of current panel in the array
    _Panels: TQPanels;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormActivate(Sender: TObject);
var

  i: integer = 5;

begin
  SetLength(_Panels, i);

  for i := Low(_Panels) to High(_Panels) do
  begin
    if i = Low(_Panels) then
    begin
      _Panels[i] := TQPanel.Create(self, Panel2, Panel1, 0);
      _Panels[i].Font.Color := DarkGreen;   //create method focus / unfocus
      _Panels[i].Color := colorWhite;
    end
    else
    begin
      _Panels[i] := TQPanel.Create(self, Panel2, _Panels[i - 1], 0);
      _Panels[i].Font.Color := DarkGrey;
      _Panels[i].Color := LightGrey;
    end;

    _Panels[i].Name := 'P' + IntToStr(i);
    _Panels[i].Caption := IntToStr(i);
  end;

  _ID := 0;
end;

procedure TForm1.SpeedButton1Click(Sender: TObject);
begin
  {return to original colors current panel}
  _Panels[_ID].Font.Color := DarkGrey;
  _Panels[_ID].Color := LightGrey;

  _ID := _ID + 1;

  if _ID > high(_Panels) then
    _ID := low(_Panels);

  {change to focus colors new current panel}
  _Panels[_ID].Font.Color := DarkGreen;
  _Panels[_ID].Color := colorWhite;
end;

procedure TForm1.SpeedButton2Click(Sender: TObject);
begin
  {return to original colors current panel}
  _Panels[_ID].Font.Color := DarkGrey;
  _Panels[_ID].Color := LightGrey;

  _ID := _ID - 1;

  if _ID < low(_Panels) then
    _ID := high(_Panels);

  {change to focus colors new current panel}
  _Panels[_ID].Font.Color := DarkGreen;
  _Panels[_ID].Color := colorWhite;
end;

end.
