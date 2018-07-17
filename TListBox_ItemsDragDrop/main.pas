unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls;

type

  { TForm1 }

  TForm1 = class(TForm)
    ListBox1: TListBox;
    Memo1: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure ListBox1DragDrop(Sender, Source: TObject; X, Y: integer);
    procedure ListBox1DragOver(Sender, Source: TObject; X, Y: integer; State: TDragState; var Accept: boolean);
    procedure ListBox1SelectionChange(Sender: TObject; User: boolean);
    procedure ListBox1StartDrag(Sender: TObject; var DragObject: TDragObject);
  private
    _SelectedIndex: word;
    procedure PopulateListBox(pListBox: TListBox; pNoItems: word);
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  ListBox1.DragMode := dmAutomatic;
  PopulateListBox(ListBox1, 5);
end;

procedure TForm1.ListBox1DragDrop(Sender, Source: TObject; X, Y: integer);
var
  dropPosition: integer;
  dropPoint: TPoint;

begin
  Form1.Caption := 'dropped';

  dropPoint.x := X;
  dropPoint.y := Y;

  with Source as TListBox do
  begin
    dropPosition := ItemAtPos(dropPoint, True);
    Items.Move(_SelectedIndex, dropPosition);
  end;
end;

procedure TForm1.ListBox1DragOver(Sender, Source: TObject; X, Y: integer; State: TDragState; var Accept: boolean);
begin
  //sillently accepts the drag over. needed!
end;

procedure TForm1.ListBox1SelectionChange(Sender: TObject; User: boolean);
var
  i: word;

begin
  with Sender as TListBox do
  begin
    if (Sender as TListBox).SelCount > 0 then
    begin
      for i := 0 to (Sender as TListBox).Items.Count - 1 do
      begin

        if (Sender as TListBox).Selected[i] then
        begin
          _SelectedIndex := i;
          Memo1.Append(_SelectedIndex.ToString);
          exit;
        end;
      end;
    end;
  end;
end;

procedure TForm1.ListBox1StartDrag(Sender: TObject; var DragObject: TDragObject);
begin
  Form1.Caption := 'start drag';
end;

procedure TForm1.PopulateListBox(pListBox: TListBox; pNoItems: word);
var
  i: word;

begin
  for i := 0 to pNoItems do
  begin
    pListBox.Items.AddText('x' + i.ToString);
  end;
end;


end.
