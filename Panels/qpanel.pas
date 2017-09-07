unit qpanel;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls;

type
  TQPanel = class(TPanel)
  private
    _PosType: integer;          //0 top, 1 interim, 2 bottom
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TWinControl); reintroduce;
    {BordLeft - border spacing left, PosType - 0 top, 1 interim, 2 bottom}
    constructor Create(AOwner: TWinControl; AlignLeft: TControl = nil; AlignTop: TControl = nil; BordLeft: integer = 0; BordTop: integer = 0; PosType: integer = 1); reintroduce;
  end;

type
  TQPanels = array of TQPanel;

implementation

constructor TQPanel.Create(AOwner: TWinControl);
begin
  inherited Create(AOwner);

  self.Parent := AOwner;
end;

constructor TQPanel.Create(AOwner: TWinControl; AlignLeft: TControl = nil; AlignTop: TControl = nil; BordLeft: integer = 0; BordTop: integer = 0; PosType: integer = 1);
begin
  inherited Create(AOwner);
  self.Parent := AOwner;
  self.Font.Style := [fsBold];

  if AlignLeft <> nil then
  begin
    self.AnchorSideLeft.Control := AlignLeft;
    {forms might not know of left / asrRight. let us not use it}
    if AlignLeft <> AOwner then
      self.AnchorSideLeft.Side := asrRight;
    self.BorderSpacing.Left := BordLeft;
  end;

  if AlignTop <> nil then
  begin
    self.AnchorSideTop.Control := AlignTop;
    {forms might not know of bottom / asrBottom. let us not use it}
    if AlignTop <> AOwner then
      self.AnchorSideTop.Side := asrBottom;
    self.BorderSpacing.Top := BordTop;
  end;

  _PosType := PosType;
end;

procedure TQPanel.Paint;
begin
  inherited;

  case _PosType of
    1, 2:
    begin
      self.Canvas.MoveTo(0, 0);
      self.Canvas.LineTo(self.Width, 0);
    end;
  end;
end;

end.
