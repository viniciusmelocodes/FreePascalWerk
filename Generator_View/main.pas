unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, BCTrackbarUpdown, BCLabel, BGRACustomDrawn, BCListBox,
  ECEditBtns;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnAddField: TBCDButton;
    BtnRenderRows: TBCDButton;
    BtnSaveConfig: TBCDButton;
    BtnLoadConfig: TBCDButton;
    EditRows: TBCDEdit;
    GenType: TComboBox;
    EditMask: TBCDEdit;
    EditFrom: TBCDEdit;
    EditTo: TBCDEdit;
    EditName: TBCDEdit;
    BCListBox1: TBCListBox;
    BCTrackbarUpdown1: TBCTrackbarUpdown;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;

    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  font_size: integer = 13;

begin
  EditMask.Font.Size := font_size;
  EditName.Font.Size := font_size;
  EditFrom.Font.Size := font_size;
  EditTo.Font.Size := font_size;
  EditRows.Font.Size := font_size;

  GenType.Font.Size := font_size - 1;

  BtnAddField.Font.Size := font_size;
  BtnRenderRows.Font.Size := font_size;
  BtnSaveConfig.Font.Size := font_size;
  BtnLoadConfig.Font.Size := font_size;
end;

end.

