unit u_login;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons, StdCtrls,
  req_authe,
  parse_login_info,
  BGRACustomDrawn, BCLabel;

type
  TMessage = procedure(AMsg: string) of object;
  TIsAuthenticated = procedure(IsAuthenticated: boolean) of object;

type
  TLoginForm = class(TForm)
    BCLabel1: TBCLabel;
    BCLabel2: TBCLabel;
    btnSubmit: TBitBtn;
    EdtUser: TEdit;
    EdtPassword: TEdit;
    Image1: TImage;
    Label1: TLabel;

    procedure btnSubmitClick(Sender: TObject);

  private
    _Message: TMessage;
    _IsAuthenticated: TIsAuthenticated;

    {Triggers}
    procedure TriggerMessage(AMsg: string);
    procedure TriggerIsAuthenticated(IsAuthenticated: boolean);

    {Catchers}
    procedure CatchJSON(AJSON: string);
    procedure CatchLoginInfo(AInfo: TLoginInfo);

  public
    property OnMessage: TMessage read _Message write _Message;
    property OnAuthenticated: TIsAuthenticated read _IsAuthenticated write _IsAuthenticated;
  end;

var
  LoginForm: TLoginForm;

implementation

{$R *.lfm}

procedure TLoginForm.btnSubmitClick(Sender: TObject);
var
  r: TReqAuthentication;

begin
  btnSubmit.Enabled := False;
  btnSubmit.Caption := 'Wait...';

  r := TReqAuthentication.Create(EdtUser.Text, EdtPassword.Text, 'http://127.0.0.1:8000/user');
  r.OnPassJSON := @CatchJSON;
end;

procedure TLoginForm.CatchJSON(AJSON: string);
var
  login_info: TLoginResponse;

begin
  try
    login_info := TLoginResponse.Create();
    login_info.OnLoginInfo := @CatchLoginInfo;
    login_info.PRawJSON := AJSON;

  finally
    FreeAndNil(login_info);
  end;
end;

procedure TLoginForm.CatchLoginInfo(AInfo: TLoginInfo);
begin

  if AInfo.Authenticated then
  begin
    TriggerIsAuthenticated(True);
    self.Close;
  end
  else
  begin
    EdtUser.Clear;
    EdtPassword.Clear;
    btnSubmit.Caption := 'Submit';
    btnSubmit.Enabled := True;
  end;

end;

procedure TLoginForm.TriggerMessage(AMsg: string);
begin
  if Assigned(_Message) then
    _Message(AMsg);
end;

procedure TLoginForm.TriggerIsAuthenticated(IsAuthenticated: boolean);
begin
  if Assigned(_IsAuthenticated) then
    _IsAuthenticated(IsAuthenticated);
end;

end.
