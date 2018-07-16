unit update_node;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  node_class;

type
  TNodeUpdateForm = class(TForm)
    BtnSubmit: TButton;
    CxType: TComboBox;
    CxVersion: TComboBox;
    EdtIP: TEdit;
    EdtName: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    procedure BtnSubmitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);

  private
    _NodeInfo: TNode;
  public
    property NodeInfo: TNode write _NodeInfo;
  end;

var
  NodeUpdateForm: TNodeUpdateForm;

implementation

{$R *.lfm}

procedure TNodeUpdateForm.FormCreate(Sender: TObject);
begin
  CxType.AddItem('1', nil);
  CxType.AddItem('2', nil);

  CxVersion.AddItem('v 1.00', nil);
  CxVersion.AddItem('v 2.00', nil);
end;

procedure TNodeUpdateForm.FormShow(Sender: TObject);
begin
  EdtIP.Text := _NodeInfo.NodeIPv4;
  EdtName.Text := _NodeInfo.NodeName;
end;

procedure TNodeUpdateForm.BtnSubmitClick(Sender: TObject);
begin
  self.Close;
end;

end.

