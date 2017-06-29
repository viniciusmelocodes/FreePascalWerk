unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef mswindows}Windows, Messages,{$endif}
  LCLProc,
  LMessages,
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TEdit }

  TEdit = class(StdCtrls.TEdit)
  protected
    procedure WMPaint(var Msg: TLMPaint); message LM_PAINT;
    procedure TextChanged; override;
  public
    bmp : TBitmap;
    hintText: string;
    hintAlign : TAlignment;
    destructor Destroy; override;
  end;

  { TForm1 }

  TForm1 = class(TForm)
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    ImageList1: TImageList;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin
  Edit2.bmp:=TBitmap.Create;
  ImageList1.GetBitmap(0, Edit2.bmp);
  Edit3.bmp:=TBitmap.Create;
  ImageList1.GetBitmap(1, Edit3.bmp);

  {$ifdef mswindows}
  Edit2.HandleNeeded;
  SendMessage(Edit2.Handle, EM_SETMARGINS, EC_LEFTMARGIN, Edit2.bmp.width+2);

  Edit3.HandleNeeded;
  SendMessage(Edit3.Handle, EM_SETMARGINS, EC_LEFTMARGIN, Edit3.bmp.width+2);
  {$endif}
end;

{ TEdit }

procedure TEdit.WMPaint(var Msg: TLMPaint);
var
  cnv : TCanvas;
  x   : integer;
  tl  : TTextStyle;
  xx  : integer;
begin
  cnv := TCanvas.Create;
  try
    cnv.Handle:=Msg.DC;

    x:=2;
    inherited;

    if Assigned(bmp) then begin
      cnv.Draw(x, 3, bmp);
      inc(x, bmp.width+2);
    end else
      x:=4;

    if (text='') then begin
      cnv.Font.Color:=clGray;
      tl.Alignment:=hintAlign;
      tl:=cnv.TextStyle;
      tl.SingleLine:=true;
      tl.Clipping:=true;
      tl.EndEllipsis:=true;
      tl.Opaque:=false;
      if hintAlign = taCenter then begin
        xx:=ClientWidth - x;
        xx:=(xx div 2) - cnv.TextWidth(hintText) div 2;
        x:=x+xx;
      end;
      cnv.TextRect(Bounds(x, 2, ClientWidth , cLientHeight), x, 1, hintText);
    end;
  finally
    cnv.Free;
  end;
end;

procedure TEdit.TextChanged;
begin
  invalidate;
  inherited TextChanged;
end;

destructor TEdit.Destroy;
begin
  bmp.Free;
  inherited Destroy;
end;

end.

