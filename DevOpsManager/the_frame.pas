unit the_frame;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, ExtCtrls, StdCtrls, Graphics,
  node_class;

type
  TMessage = procedure(AMsg: string) of object;
  TPassUpdateFiles = procedure(ANodeID: word) of object;
  TPassUpdateTrainings = procedure(ANodeID: word) of object;

type
  TNodeFrame = class(TFrame)
    Image1: TImage;
    ImgUpdateFiles: TImage;
    ImgUpdateTrainings: TImage;
    ImgUpdateDatabases: TImage;
    Label1: TLabel;
    Label2: TLabel;

    procedure ImgUpdateFilesClick(Sender: TObject);
    procedure ImgUpdateTrainingsClick(Sender: TObject);

  private
    _Message: TMessage;
    _UpdateFiles: TPassUpdateFiles;
    _UpdateTrainings: TPassUpdateTrainings;
    _NodeID: word;

    procedure TriggerMessage(AMsg: string);
    procedure TriggerUpdateFiles(ANodeID: word);
    procedure TriggerUpdateTrainings(ANodeID: word);

  public
    constructor Create(AOwner: TWinControl; APaintedID: word; ANode: TInfrastructureNode; AImageList: TImageList); reintroduce;
    property OnMessage: TMessage read _Message write _Message;
    property OnUpdateFiles: TPassUpdateFiles read _UpdateFiles write _UpdateFiles;
    property OnUpdateTrainings: TPassUpdateTrainings read _UpdateTrainings write _UpdateTrainings;
    property NodeID: word write _NodeID;
  end;

implementation

{$R *.lfm}

constructor TNodeFrame.Create(AOwner: TWinControl; APaintedID: word; ANode: TInfrastructureNode; AImageList: TImageList);
begin
  inherited Create(AOwner);

  self.Name := 'Node_' + IntToStr(ANode.NodeInstance.ID);
  self.Align := alTop;
  self.AutoSize := True;
  self.Top := ANode.NodeInstance.ID + 1;

  self.Label1.Caption := 'Name: ' + ANode.NodeInstance.NodeName;
  self.Label2.Caption := 'IP: ' + ANode.NodeInstance.IPv4;

  if APaintedID mod 2 = 0 then
  begin
    self.Color := RGBToColor(209, 227, 248);
  end;

  self.NodeID := ANode.NodeInstance.ID;
  AImageList.GetBitmap(ANode.NodeInstance.ID mod AImageList.Count, self.Image1.Picture.Bitmap);
  self.Parent := AOwner;
end;

procedure TNodeFrame.ImgUpdateFilesClick(Sender: TObject);
begin
  TriggerUpdateFiles(_NodeID);
end;

procedure TNodeFrame.ImgUpdateTrainingsClick(Sender: TObject);
begin
  TriggerUpdateTrainings(_NodeID);
end;

procedure TNodeFrame.TriggerMessage(AMsg: string);
begin
  if Assigned(_Message) then
    _Message(AMsg);
end;

procedure TNodeFrame.TriggerUpdateFiles(ANodeID: word);
begin
  if Assigned(_UpdateFiles) then
    _UpdateFiles(ANodeID);
end;

procedure TNodeFrame.TriggerUpdateTrainings(ANodeID: word);
begin
  if Assigned(_UpdateTrainings) then
    _UpdateTrainings(ANodeID);
end;

end.
