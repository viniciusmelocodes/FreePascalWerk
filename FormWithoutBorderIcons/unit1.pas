UNIT Unit1;

{$mode objfpc}{$H+}

INTERFACE

USES
Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
Buttons, ActnList, StdCtrls;

TYPE
TForm1 = CLASS(TForm)
  bkgImage: TImage;
  pnlTitle: TPanel;
  btnMaximize: TSpeedButton;
  btnClose: TSpeedButton;
  btnMinimize: TSpeedButton;
  PROCEDURE btnCloseClick(Sender: TObject);
  PROCEDURE btnMinimizeClick(Sender: TObject);
  PROCEDURE FormCreate(Sender: TObject);
  PROCEDURE FormDestroy(Sender: TObject);
  PROCEDURE FormPaint(Sender: TObject);

  PROCEDURE pnlTitleClick(Sender: TObject);

  PROCEDURE pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: INTEGER);
  PROCEDURE pnlTitleMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: INTEGER);
  PROCEDURE pnlTitleMouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: INTEGER);
  PROCEDURE pnlTitlePaint(Sender: TObject);
private
  _Dragging : BOOLEAN;
  _DragStartPoint : TPoint;
public

END;

VAR
Form1: TForm1;

IMPLEMENTATION

{$R *.lfm}

PROCEDURE TForm1.pnlTitleMouseDown(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: INTEGER);
BEGIN
  _DragStartPoint:=Point(Mouse.CursorPos.x-Left,Mouse.CursorPos.y-Top);
  Mouse.Capture:=Handle;
  _Dragging:=True;
END;

PROCEDURE TForm1.pnlTitleMouseMove(Sender: TObject; Shift: TShiftState; X,  Y: INTEGER);
BEGIN
  IF _Dragging THEN
  BEGIN
    Left:=Mouse.CursorPos.x-_DragStartPoint.x;
    Top:=Mouse.CursorPos.y-_DragStartPoint.y;
  END;
END;

PROCEDURE TForm1.pnlTitleMouseUp(Sender: TObject; Button: TMouseButton;  Shift: TShiftState; X, Y: INTEGER);
BEGIN
  Mouse.Capture:=0;
  _Dragging:=False;
END;

PROCEDURE TForm1.pnlTitlePaint(Sender: TObject);
BEGIN
  pnlTitle.Canvas.Draw(0,0,nil);
END;

PROCEDURE TForm1.FormPaint(Sender: TObject);
BEGIN
  Canvas.Draw(0,0,nil);
END;

PROCEDURE TForm1.pnlTitleClick(Sender: TObject);
BEGIN
END;

PROCEDURE TForm1.FormCreate(Sender: TObject);
BEGIN
  BorderIcons:=[];
  BorderStyle:=bsNone;
END;

PROCEDURE TForm1.btnCloseClick(Sender: TObject);
BEGIN
  Close;
END;

PROCEDURE TForm1.btnMinimizeClick(Sender: TObject);
BEGIN
  Application.Minimize;
END;

PROCEDURE TForm1.FormDestroy(Sender: TObject);
BEGIN
  //FBkgImg.Free;
END;

END.

