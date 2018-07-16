unit frame_upd_trainings;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  strutils,
  node_class;

type
  TAttributeTraining = (available, selected);

  TForSelectionTraining = record
    TrainingName: string;
    TrainingAttribute: TAttributeTraining;
  end;

  TForSelectionTrainings = array of TForSelectionTraining;

type

  { TUpdateTrainings }

  TUpdateTrainings = class(TForm)
    EdtSearchFrom: TEdit;
    EdtSearchTo: TEdit;
    ImgDeleteSelected: TImage;
    ImgAddSelected: TImage;
    ImgAddAll: TImage;
    ImgDeleteAll: TImage;
    ImgUpdate: TImage;
    LstAvailableTrainings: TListBox;
    LstSelectedTrainings: TListBox;
    procedure EdtSearchFromChange(Sender: TObject);
    procedure EdtSearchFromDblClick(Sender: TObject);
    procedure EdtSearchFromEnter(Sender: TObject);
    procedure EdtSearchToChange(Sender: TObject);
    procedure EdtSearchToDblClick(Sender: TObject);
    procedure EdtSearchToEnter(Sender: TObject);
    procedure ImgDeleteSelectedClick(Sender: TObject);
    procedure ImgAddSelectedClick(Sender: TObject);
    procedure ImgDeleteAllClick(Sender: TObject);
    procedure ImgAddAllClick(Sender: TObject);
    procedure ImgUpdateClick(Sender: TObject);

  private
    _CurrentTrainings: TForSelectionTrainings;
    procedure FilterByTokens(ASearch: string; ToSearch: TForSelectionTrainings; var AResult: TStringList; ATrainingAttribute: TAttributeTraining);
    procedure FillBoxes;

  public
    constructor Create(AOwner: TWinControl; ANode: TInfrastructureNode); reintroduce;
  end;

var
  UpdateTrainings: TUpdateTrainings;

implementation

{$R *.lfm}

constructor TUpdateTrainings.Create(AOwner: TWinControl; ANode: TInfrastructureNode);
var
  i: word;

begin
  inherited Create(AOwner);

  LstAvailableTrainings.MultiSelect := True;
  LstSelectedTrainings.MultiSelect := True;

  if Length(ANode.NodeInstance.AvailableTrainings) > 0 then
  begin
    for i := Low(ANode.NodeInstance.AvailableTrainings) to High(ANode.NodeInstance.AvailableTrainings) do
    begin
      SetLength(_CurrentTrainings, Length(_CurrentTrainings) + 1);
      _CurrentTrainings[Length(_CurrentTrainings) - 1].TrainingName := ANode.NodeInstance.AvailableTrainings[i];
      _CurrentTrainings[Length(_CurrentTrainings) - 1].TrainingAttribute := available;
    end;

    FillBoxes;
  end;
end;

procedure TUpdateTrainings.FillBoxes;
var
  i: word;
  s: word = 0;
  a: word = 0;

begin
  LstAvailableTrainings.Clear;
  LstSelectedTrainings.Clear;

  for i := Low(_CurrentTrainings) to High(_CurrentTrainings) do
  begin
    case _CurrentTrainings[i].TrainingAttribute of
      available:
      begin
        a := a + 1;
        LstAvailableTrainings.Items.Add(_CurrentTrainings[i].TrainingName);
      end;
      selected:
      begin
        s := s + 1;
        LstSelectedTrainings.Items.Add(_CurrentTrainings[i].TrainingName);
      end;
    end;
  end;

  self.Caption := IntToStr(a) + '|' + IntToStr(s);
end;

procedure TUpdateTrainings.EdtSearchFromChange(Sender: TObject);
var
  info: TStringList;

begin
  try
    info := TStringList.Create;

    FilterByTokens(EdtSearchFrom.Text, _CurrentTrainings, info, available);
    LstAvailableTrainings.Items.Assign(info);

  finally
    FreeAndNil(info);
  end;
end;

procedure TUpdateTrainings.EdtSearchFromDblClick(Sender: TObject);
begin
  EdtSearchFrom.Clear;
  EdtSearchFromChange(nil);
end;

procedure TUpdateTrainings.EdtSearchFromEnter(Sender: TObject);
begin
  EdtSearchFrom.Clear;
end;

procedure TUpdateTrainings.EdtSearchToChange(Sender: TObject);
var
  info: TStringList;

begin
  try
    info := TStringList.Create;

    FilterByTokens(EdtSearchTo.Text, _CurrentTrainings, info, selected);
    LstSelectedTrainings.Items.Assign(info);

  finally
    FreeAndNil(info);
  end;
end;

procedure TUpdateTrainings.EdtSearchToDblClick(Sender: TObject);
begin
  EdtSearchTo.Clear;
  EdtSearchToChange(nil);
end;

procedure TUpdateTrainings.EdtSearchToEnter(Sender: TObject);
begin
  EdtSearchTo.Clear;
end;

procedure TUpdateTrainings.ImgDeleteSelectedClick(Sender: TObject);
var
  i, j: word;

begin
  if LstSelectedTrainings.SelCount > 0 then
  begin
    for i := 0 to LstSelectedTrainings.Count - 1 do
    begin
      if LstSelectedTrainings.Selected[i] then
      begin

        for j := Low(_CurrentTrainings) to High(_CurrentTrainings) do
        begin
          if LstSelectedTrainings.Items[i] = _CurrentTrainings[j].TrainingName then
          begin
            _CurrentTrainings[j].TrainingAttribute := available;
            break;
          end;
        end;

      end;
    end;

    FillBoxes;
  end;
end;

procedure TUpdateTrainings.ImgAddSelectedClick(Sender: TObject);
var
  i, j: word;

begin
  if LstAvailableTrainings.SelCount > 0 then
  begin
    for i := 0 to LstAvailableTrainings.Count - 1 do
    begin
      if LstAvailableTrainings.Selected[i] then
      begin

        for j := Low(_CurrentTrainings) to High(_CurrentTrainings) do
        begin
          if LstAvailableTrainings.Items[i] = _CurrentTrainings[j].TrainingName then
          begin
            _CurrentTrainings[j].TrainingAttribute := selected;
            break;
          end;
        end;

      end;
    end;

    FillBoxes;
  end;
end;

procedure TUpdateTrainings.ImgDeleteAllClick(Sender: TObject);
var
  i, j: word;

begin
  if LstSelectedTrainings.Count > 0 then
  begin

    for i := 0 to LstSelectedTrainings.Count - 1 do
    begin
      for j := Low(_CurrentTrainings) to High(_CurrentTrainings) do
      begin
        if LstSelectedTrainings.Items[i] = _CurrentTrainings[j].TrainingName then
        begin
          _CurrentTrainings[j].TrainingAttribute := available;
          break;
        end;
      end;
    end;

    FillBoxes;
  end;
end;

procedure TUpdateTrainings.ImgAddAllClick(Sender: TObject);
var
  i, j: word;

begin
  if LstAvailableTrainings.Count > 0 then
  begin

    for i := 0 to LstAvailableTrainings.Count - 1 do
    begin
      for j := Low(_CurrentTrainings) to High(_CurrentTrainings) do
      begin
        if LstAvailableTrainings.Items[i] = _CurrentTrainings[j].TrainingName then
        begin
          _CurrentTrainings[j].TrainingAttribute := selected;
          break;
        end;
      end;
    end;

    FillBoxes;
  end;
end;

procedure TUpdateTrainings.ImgUpdateClick(Sender: TObject);
begin
  self.Close;
end;

procedure TUpdateTrainings.FilterByTokens(ASearch: string; ToSearch: TForSelectionTrainings; var AResult: TStringList; ATrainingAttribute: TAttributeTraining);
var
  i, j: word;
  t: TStringList;
  contains: boolean;

begin
  try
    t := TStringList.Create;
    t.StrictDelimiter := True;
    t.Delimiter := ' ';
    t.DelimitedText := ASearch;

    if Length(ToSearch) > 0 then
    begin

      for i := Low(ToSearch) to High(ToSearch) do
      begin

        if (Length(trim(ToSearch[i].TrainingName)) > 0) and (ToSearch[i].TrainingAttribute = ATrainingAttribute) then
        begin

          contains := True;

          if t.Count > 0 then
          begin
            for j := 0 to t.Count - 1 do
            begin
              if not AnsiContainsText(ToSearch[i].TrainingName, trim(t.Strings[j])) then
              begin
                contains := False;
                break;
              end;
            end;
          end;

          if contains then
            AResult.Append(trim(ToSearch[i].TrainingName));
        end;
      end;
    end;
  finally
    FreeAndNil(t);
  end;
end;

end.
