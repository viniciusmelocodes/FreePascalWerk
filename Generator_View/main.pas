unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls, BCTrackbarUpdown, BGRACustomDrawn, BCListBox,
  typinfo,
  model_generator, generate_no, generate_ip, gen_to_file;

type

  { TForm1 }

  TForm1 = class(TForm)
    BtnAddField: TBCDButton;
    BtnRenderRows: TBCDButton;
    BtnSaveConfig: TBCDButton;
    BtnLoadConfig: TBCDButton;
    UpDownLength: TBCDEdit;
    EditRows: TBCDEdit;
    GenType: TComboBox;
    EditMask: TBCDEdit;
    EditFrom: TBCDEdit;
    EditTo: TBCDEdit;
    EditName: TBCDEdit;
    UpDown1: TUpDown;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    ListGenerators: TListBox;

    procedure BtnAddFieldClick(Sender: TObject);
    procedure BtnLoadConfigClick(Sender: TObject);
    procedure BtnRenderRowsClick(Sender: TObject);
    procedure BtnSaveConfigClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);

  private
    _Generators: TGenerators;
    procedure AddGenerator(pGenerator: TGenerator);
    procedure RenderGeneratorList(pGenerators: TGenerators; pTarget: TListBox);
    procedure RenderFile(pGenerators: TGenerators; pRows: int64; pTarget: string);
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
var
  g: TGenerator;

begin
  g.GeneratorType := TGeneratorTypes(GenType.ItemIndex);
  g.Name := EditName.Text;
  g.GeneratorMask := EditMask.Text;
  g.GeneratedLength := UpDownLength.Text.ToInteger;

  if Length(EditFrom.Text) = 0 then
    g.FromValue := ''
  else
    g.FromValue := EditFrom.Text;

    if Length(EditTo.Text) = 0 then
    g.ToValue := ''
  else
    g.ToValue := EditTo.Text;

  g.UIPosition := ListGenerators.Count;

  AddGenerator(g);
  RenderGeneratorList(_Generators, ListGenerators);
end;

procedure TForm1.BtnLoadConfigClick(Sender: TObject);
var
  u: TGeneratorUtils;

begin

  u := TGeneratorUtils.Create('generator.csv');
  _Generators := u.GeneratorsLoad();
  FreeAndNil(u);

  RenderGeneratorList(_Generators, ListGenerators);
end;

procedure TForm1.BtnRenderRowsClick(Sender: TObject);
var
  rows: int64;

begin
  if not TryStrToInt64(EditRows.Text, rows) then
    rows := 1;

  RenderFile(_Generators, rows, 'results.csv');
end;

procedure TForm1.BtnSaveConfigClick(Sender: TObject);
var
  u: TGeneratorUtils;

begin
  u := TGeneratorUtils.Create('generator.csv');
  u.GeneratorsSave(_Generators);
  FreeAndNil(u);
end;

procedure TForm1.AddGenerator(pGenerator: TGenerator);
begin
  SetLength(_Generators, Length(_Generators) + 1);

  _Generators[High(_Generators)].GeneratorType := pGenerator.GeneratorType;
  _Generators[High(_Generators)].Name := pGenerator.Name;
  _Generators[High(_Generators)].GeneratorMask := pGenerator.GeneratorMask;
  _Generators[High(_Generators)].GeneratedLength := pGenerator.GeneratedLength;
  _Generators[High(_Generators)].FromValue := pGenerator.FromValue;
  _Generators[High(_Generators)].ToValue := pGenerator.ToValue;
  _Generators[High(_Generators)].UIPosition := pGenerator.UIPosition;
end;

procedure TForm1.RenderGeneratorList(pGenerators: TGenerators; pTarget: TListBox);
var
  i: byte;
  toSort: TStringList;

begin
  toSort := TStringList.Create;
  toSort.Sorted := True;

  for i := Low(pGenerators) to High(pGenerators) do
  begin
    toSort.Append(pGenerators[i].UIPosition.ToString + ',' + i.ToString);
  end;

  pTarget.Clear;
  for i := 0 to toSort.Count - 1 do
  begin
    pTarget.Items.Append(pGenerators[Copy(toSort[i], Pos(toSort[i], ','), 1).ToInteger].Name);
  end;

  FreeAndNil(toSort);
end;

procedure TForm1.RenderFile(pGenerators: TGenerators; pRows: int64; pTarget: string);
var
  i: byte;
  j: int64;
  contentField: string;
  contentRow: string;
  contentRows: TStringList;
  gNumber: TGenerateNumber;
  sep: string;

begin
  contentRows := TStringList.Create;

  for j := 0 to pRows do
  begin
    contentRow := '';
    sep := '';

    for i := Low(pGenerators) to High(pGenerators) do
    begin
      contentField := '';

      case Ord(pGenerators[i].GeneratorType) of
        0:
        begin

        end;
        1:
        begin
          gNumber := TGenerateNumber.Create(pGenerators[i].GeneratorMask);
          contentField := gNumber.GetNumber(pGenerators[i].GeneratedLength);
          FreeAndNil(gNumber);
        end;
      end;

      if ((i > 0) and (i < High(pGenerators))) then
        sep := ',';

      contentRow := contentField + sep;
    end;

    contentRows.Append(contentRow);
  end;

  contentRows.SaveToFile(pTarget);
  FreeAndNil(contentRows);
end;

end.
