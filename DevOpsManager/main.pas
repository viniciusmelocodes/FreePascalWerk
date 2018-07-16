unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ComCtrls, ExtCtrls, Menus, StdCtrls, strutils,
  node_class, update_node,
  settings,
  u_login,
  frame_upd_trainings,
  populate_infra,
  selected_infra;

type

  { TForm1 }

  TForm1 = class(TForm)
    EdtHost: TEdit;
    EdtIP: TEdit;
    EdtSearchContainers: TEdit;
    EdtSearcServices: TEdit;
    Image1: TImage;
    ImgTree: TImageList;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Memo1: TMemo;
    MnConfiguration: TMenuItem;
    MnTrainings: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MnItemExpand: TMenuItem;
    MnItemCollapse: TMenuItem;
    MnFullExpand: TMenuItem;
    MnFullCollapse: TMenuItem;
    Panel1: TPanel;
    Panel2: TPanel;
    PopTreeInfra: TPopupMenu;
    Splitter1: TSplitter;
    StatusBar1: TStatusBar;
    TreeInfrastructure: TTreeView;
    procedure Button1Click(Sender: TObject);
    procedure EdtHostChange(Sender: TObject);
    procedure EdtIPChange(Sender: TObject);
    procedure EdtSearchContainersChange(Sender: TObject);
    procedure EdtSearcServicesChange(Sender: TObject);

    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormShow(Sender: TObject);

    procedure MnConfigurationClick(Sender: TObject);
    procedure MnFullCollapseClick(Sender: TObject);
    procedure MnFullExpandClick(Sender: TObject);
    procedure MnItemCollapseClick(Sender: TObject);
    procedure MnItemExpandClick(Sender: TObject);
    procedure MnTrainingsClick(Sender: TObject);
    procedure TreeInfrastructureAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
      var PaintImages, DefaultDraw: boolean);
    procedure TreeInfrastructureMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);

  private
    _Authenticated: boolean;
    _Infrastructure: TInfrastructure;  //contains information on all nodes
    _PresentedInfrastructure: TInfrastructure;
    _SelectedInfrastucture: TSelectedInfrastructure;
    _IDsSelectedNodes: TStringList;

    procedure PopulateInfrastructure;
    procedure PopulateTree(ASelectedInfrastructure: TInfrastructure);
    function GetIndexByName(AName: string): word;

    {Catchers}
    procedure CatchInfrastructure(AInfrastructure: TInfrastructure; AError: string);
    procedure CatchSelectedInfrastructure(AInfrastructure: TInfrastructure);
    procedure CatchIsAuthenticated(IsAuthenticated: boolean);

    procedure ExportPresentedInfrastructure;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
var
  modalLogin: TLoginForm;

begin
  _Authenticated := False;

  modalLogin := TLoginForm.Create(self);
  modalLogin.OnAuthenticated := @CatchIsAuthenticated;
  modalLogin.ShowModal;

  if not _Authenticated then
    Application.Terminate;
end;

procedure TForm1.CatchIsAuthenticated(IsAuthenticated: boolean);
begin
  _Authenticated := IsAuthenticated;
end;

procedure TForm1.FormShow(Sender: TObject);
begin
  _IDsSelectedNodes := TStringList.Create;

  if FileExists(RAWJSONFile) then
    PopulateInfrastructure;
end;

procedure TForm1.MnFullCollapseClick(Sender: TObject);
begin
  TreeInfrastructure.FullCollapse;
end;

procedure TForm1.MnFullExpandClick(Sender: TObject);
begin
  TreeInfrastructure.FullExpand;
end;

procedure TForm1.MnItemCollapseClick(Sender: TObject);
var
  i: word;

begin
  for i := 0 to TreeInfrastructure.Items.Count - 1 do
  begin
    if TreeInfrastructure.Items.Item[i].Selected and (TreeInfrastructure.Items.Item[i].Level = 0) then
    begin
      TreeInfrastructure.Items.Item[i].Collapse(True);
    end;
  end;
end;

procedure TForm1.MnItemExpandClick(Sender: TObject);
var
  i: word;

begin
  for i := 0 to TreeInfrastructure.Items.Count - 1 do
  begin
    if TreeInfrastructure.Items.Item[i].Selected and (TreeInfrastructure.Items.Item[i].Level = 0) then
    begin
      TreeInfrastructure.Items.Item[i].Expand(True);
    end;
  end;
end;

procedure TForm1.EdtSearchContainersChange(Sender: TObject);
begin
  if not AnsiEndsStr(' ', EdtSearchContainers.Caption) then
    _SelectedInfrastucture.UpdateSelection(containers, EdtSearchContainers.Caption);
end;

procedure TForm1.EdtHostChange(Sender: TObject);
begin
  if not AnsiEndsStr(' ', EdtHost.Caption) then
    _SelectedInfrastucture.UpdateSelection(hosts, EdtHost.Caption);
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  ExportPresentedInfrastructure;
end;

procedure TForm1.EdtIPChange(Sender: TObject);
begin
  if not AnsiEndsStr(' ', EdtIP.Caption) then
    _SelectedInfrastucture.UpdateSelection(ipaddress, EdtIP.Caption);
end;

procedure TForm1.EdtSearcServicesChange(Sender: TObject);
begin
  if not AnsiEndsStr(' ', EdtSearcServices.Caption) then
    _SelectedInfrastucture.UpdateSelection(services, EdtSearcServices.Caption);
end;

procedure TForm1.TreeInfrastructureAdvancedCustomDrawItem(Sender: TCustomTreeView; Node: TTreeNode; State: TCustomDrawState; Stage: TCustomDrawStage;
  var PaintImages, DefaultDraw: boolean);
begin
  with TreeInfrastructure.Canvas do
  begin
    if Node.Level = 0 then
    begin
      Font.Style := [fsBold];
    end
    else
      Font.Style := [];

    DefaultDraw := True;
  end;
end;

procedure TForm1.TreeInfrastructureMouseDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: integer);
var
  i: word;

begin
  if (Button = mbRight) and (TreeInfrastructure.SelectionCount > 0) and (TreeInfrastructure.Selected.Level = 0) then
  begin
    MenuItem4.Caption := 'To All Selected (' + TreeInfrastructure.SelectionCount.ToString + ')';
    MnItemExpand.Caption := 'Expand Selected (' + TreeInfrastructure.SelectionCount.ToString + ')';
    MnItemCollapse.Caption := 'Collapse Selected (' + TreeInfrastructure.SelectionCount.ToString + ')';

    if Length(_SelectedInfrastucture.Infrastructure) > 0 then
      MnFullExpand.Caption := 'Full Expand (' + Length(_SelectedInfrastucture.Infrastructure).ToString + ')'
    else
      MnFullExpand.Caption := 'Full Expand (' + Length(_Infrastructure).ToString + ')';

    PopTreeInfra.PopUp;

    _IDsSelectedNodes.Clear;
    for i := 0 to TreeInfrastructure.Items.Count - 1 do
    begin
      if TreeInfrastructure.Items.Item[i].Selected and (TreeInfrastructure.Items.Item[i].Level = 0) then
      begin
        _IDsSelectedNodes.Append(TreeInfrastructure.Items.Item[i].Text);
      end;
    end;
  end;
end;

procedure TForm1.PopulateInfrastructure;
var
  infra: TPopulateInfrastructure;

begin
  infra := TPopulateInfrastructure.CreateFile(RAWJSONFile);
  infra.OnPassInfrastructure := @CatchInfrastructure;
end;

procedure TForm1.CatchInfrastructure(AInfrastructure: TInfrastructure; AError: string);
begin
  _Infrastructure := AInfrastructure;

  {create singleton selected infrastructure}
  _SelectedInfrastucture := TSelectedInfrastructure.Create(_Infrastructure);
  _SelectedInfrastucture.OnPassSelectedInfrastructure := @CatchSelectedInfrastructure;

  _PresentedInfrastructure := _Infrastructure;

  PopulateTree(AInfrastructure);
end;

procedure TForm1.CatchSelectedInfrastructure(AInfrastructure: TInfrastructure);
begin
  _PresentedInfrastructure := AInfrastructure;

  PopulateTree(AInfrastructure);
end;

procedure TForm1.PopulateTree(ASelectedInfrastructure: TInfrastructure);
var
  treeRoot: array of TTreeNode;
  HostItem: TTreeNode;
  SchedulerItem: TTreeNode;
  ServiceItem: TTreeNode;
  i, j: word;

begin
  SetLength(treeRoot, Length(ASelectedInfrastructure));

  TreeInfrastructure.Items.Clear;

  if Length(ASelectedInfrastructure) > 0 then
  begin
    try
      for i := Low(ASelectedInfrastructure) to High(ASelectedInfrastructure) do
      begin
        treeRoot[i] := TreeInfrastructure.Items.Add(nil, ASelectedInfrastructure[i].NodeInstance.NodeName);
        treeRoot[i].ImageIndex := 0;

        HostItem := TreeInfrastructure.Items.AddChild(treeRoot[i], 'Host:' + ASelectedInfrastructure[i].NodeInstance.HostInfo.HostName);
        HostItem.ImageIndex := 1;
        TreeInfrastructure.Items.AddChild(HostItem, 'IP:' + ASelectedInfrastructure[i].NodeInstance.HostInfo.HostSocket.SocketIP);
        TreeInfrastructure.Items.AddChild(HostItem, 'LXD Port:' + ASelectedInfrastructure[i].NodeInstance.HostInfo.HostSocket.SocketPort);

        SchedulerItem := TreeInfrastructure.Items.AddChild(treeRoot[i], 'Scheduler:' + ASelectedInfrastructure[i].NodeInstance.SchedulerInfo.URL);
        SchedulerItem.ImageIndex := 2;
        TreeInfrastructure.Items.AddChild(SchedulerItem, 'IP:' + ASelectedInfrastructure[i].NodeInstance.SchedulerInfo.SchedulerSocket.SocketIP);
        TreeInfrastructure.Items.AddChild(SchedulerItem, 'Port:' + ASelectedInfrastructure[i].NodeInstance.SchedulerInfo.SchedulerSocket.SocketPort);

        for j := Low(ASelectedInfrastructure[i].NodeInstance.ServicesInfo) to High(ASelectedInfrastructure[i].NodeInstance.ServicesInfo) do
        begin
          ServiceItem := TreeInfrastructure.Items.AddChild(treeRoot[i], 'Service:' + ASelectedInfrastructure[i].NodeInstance.ServicesInfo[j].ServiceName);
          ServiceItem.ImageIndex := 3;
          TreeInfrastructure.Items.AddChild(ServiceItem, 'IP:' + ASelectedInfrastructure[i].NodeInstance.ServicesInfo[j].ServiceSocket.SocketIP);
          TreeInfrastructure.Items.AddChild(ServiceItem, 'Port:' + ASelectedInfrastructure[i].NodeInstance.ServicesInfo[j].ServiceSocket.SocketPort);
        end;
      end;
    finally
    end;
  end;
end;

procedure TForm1.ExportPresentedInfrastructure;
var
  i: word;

begin
  Memo1.Clear;

  for i := 0 to TreeInfrastructure.Items.Count - 1 do
  begin
    if TreeInfrastructure.Items[i].Level = 0 then
      Memo1.Append('--------------');

    Memo1.Append(TreeInfrastructure.Items[i].Text);
  end;

  Memo1.Append('------end------');
end;

procedure TForm1.FormDestroy(Sender: TObject);
var
  i: word;

begin
  TreeInfrastructure.Items.Clear;
  FreeAndNil(_IDsSelectedNodes);
  _SelectedInfrastucture.Destroy;

  if Length(_Infrastructure) > 0 then
  begin
    for i := Low(_Infrastructure) to High(_Infrastructure) do
    begin
      _Infrastructure[i].Destroy;
    end;
  end;
end;

procedure TForm1.MnConfigurationClick(Sender: TObject);
var
  modalForm: TNodeUpdateForm;
  i: word;
  indexNode: word;

begin
  for i := 0 to _IDsSelectedNodes.Count - 1 do
  begin
    modalForm := TNodeUpdateForm.Create(self);

    self.Caption := Length(_SelectedInfrastucture.Infrastructure).ToString;
    indexNode := GetIndexByName(_IDsSelectedNodes.Strings[i]);

    modalForm.NodeInfo := _PresentedInfrastructure[indexNode].NodeInstance;
    modalForm.Caption := 'Update files: ' + (indexNode + 1).ToString;
    modalForm.ShowModal;
  end;
end;

procedure TForm1.MnTrainingsClick(Sender: TObject);
var
  modalForm: TUpdateTrainings;
  i: word;
  indexNode: word;

begin
  for i := 0 to _IDsSelectedNodes.Count - 1 do
  begin
    indexNode := GetIndexByName(_IDsSelectedNodes.Strings[i]);

    modalForm := TUpdateTrainings.Create(self, _PresentedInfrastructure[indexNode]);
    modalForm.ShowModal;
  end;
end;

function TForm1.GetIndexByName(AName: string): word;
var
  i: word;

begin
  for i := Low(_PresentedInfrastructure) to High(_PresentedInfrastructure) do
  begin
    if _PresentedInfrastructure[i].NodeInstance.NodeName = AName then
    begin
      Result := i;
      break;
    end;
  end;
end;

end.
