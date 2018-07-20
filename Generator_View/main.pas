unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, BCTrackbarUpdown, BCLabel, BGRACustomDrawn;

type

  { TForm1 }

  TForm1 = class(TForm)
    BCDButton1: TBCDButton;
    BCDEdit1: TBCDEdit;
    BCDEdit2: TBCDEdit;
    BCTrackbarUpdown1: TBCTrackbarUpdown;
    ComboBox1: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    ListBox1: TListBox;
    procedure BCDEdit1Change(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure Label1Click(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
begin

end;

procedure TForm1.BCDEdit1Change(Sender: TObject);
begin

end;

procedure TForm1.FormResize(Sender: TObject);
begin

end;

procedure TForm1.Label1Click(Sender: TObject);
begin

end;

end.

