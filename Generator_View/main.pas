unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, BCTrackbarUpdown, BGRACustomDrawn, BCListBox,
  typinfo,
  model_generator;

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
    UpDownLength: TBCTrackbarUpdown;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListGenerators: TListBox;

    procedure BtnAddFieldClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    _Generators: TGenerators;
    procedure AddGenerator(pType: TGeneratorTypes; pName, pMask: string; pLength: byte; pFromValue, pToValue, pRows: string; pUIPosition: byte);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.FormCreate(Sender: TObject);
var
  font_size: integer = 13;
  i: byte;

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

  for i := Ord(Low(TGeneratorTypes)) to Ord(High(TGeneratorTypes)) do
  begin
    GenType.Items.Add(GetEnumName(TypeInfo(TGeneratorTypes), Ord(i)));
  end;
end;

procedure TForm1.BtnAddFieldClick(Sender: TObject);
begin
  ListGenerators.Items.Add('x');

  AddGenerator(TGeneratorTypes(GenType.ItemIndex), EditName.Text, EditMask.Text, UpDownLength.Text.ToInteger, EditFrom.Text, EditTo.Text, EditRows.Text, ListGenerators.Count);
end;

procedure TForm1.AddGenerator(pType: TGeneratorTypes; pName, pMask: string; pLength: byte; pFromValue, pToValue, pRows: string; pUIPosition: byte);
begin
  SetLength(_Generators, Length(_Generators) + 1);

  _Generators[High(_Generators)].GeneratorType := pType;
  _Generators[High(_Generators)].Name := pName;
  _Generators[High(_Generators)].GeneratorMask := pMask;
  _Generators[High(_Generators)].FromValue := pFromValue;
  _Generators[High(_Generators)].ToValue := pToValue;
  _Generators[High(_Generators)].NoRows := pRows;
  _Generators[High(_Generators)].UIPosition := pUIPosition;
end;

end.
