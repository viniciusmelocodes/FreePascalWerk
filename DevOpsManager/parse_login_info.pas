unit parse_login_info;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  fpjson, jsonparser,
  TypInfo;

type
  TLoginInfo = record
    Status: string;
    StatusCode: word;
    Failed: boolean;
    Message: string;
    UserID: word;
    UserEmail: string;
    UserName: string;
    UserCode: string;
    Authenticated: boolean;
  end;

  TPassLoginInfo = procedure(AInfo: TLoginInfo) of object;
  TMessage = procedure(AMsg: string) of object;

type
  TLoginResponse = class
  private
    _Message: TMessage;
    _LoginInfo: TLoginInfo;
    _PassLoginInfo: TPassLoginInfo;

    procedure ConvertJSON(ARawJSON: string);
    procedure TriggerMessage(AMsg: string);
    procedure TriggerLoginInfo(AInfo: TLoginInfo);

  public
    constructor Create();
    destructor Destroy; override;
    property PRawJSON: string write ConvertJSON;
    property OnMessage: TMessage read _Message write _Message;
    property OnLoginInfo: TPassLoginInfo read _PassLoginInfo write _PassLoginInfo;
  end;

implementation

constructor TLoginResponse.Create();
begin

end;

procedure TLoginResponse.ConvertJSON(ARawJSON: string);
var
  jsData: TJSONData;
  statusCode: word;

begin
  try
    try
      jsData := GetJSON(ARawJSON);
      statusCode := jsData.FindPath('Response.StatusCode').AsInt64;

      case statusCode of
        200:
        begin
          _LoginInfo.Status := jsData.FindPath('Response.Status').AsString;
          _LoginInfo.StatusCode := statusCode;
          _LoginInfo.Failed := jsData.FindPath('Response.Failed').AsBoolean;
          _LoginInfo.Message := '';
          _LoginInfo.UserID := jsData.FindPath('Response.Message.ID').AsInt64;
          _LoginInfo.UserEmail := jsData.FindPath('Response.Message.Email').AsString;
          _LoginInfo.UserName := jsData.FindPath('Response.Message.FirstName').AsString + ' ' + jsData.FindPath('Response.Message.LastName').AsString;
          _LoginInfo.UserCode := jsData.FindPath('Response.Message.UserName').AsString;

          _LoginInfo.Authenticated := True;

        end;
        401:
        begin
          _LoginInfo.StatusCode := statusCode;
          _LoginInfo.Message := jsData.FindPath('Response.Message').AsString;
          _LoginInfo.Authenticated := False;
        end;
      end;

    except
      on E: Exception do
      begin
        TriggerMessage(E.Message);
      end;
    end;

  finally
    TriggerLoginInfo(_LoginInfo);
    FreeAndNil(jsData);
  end;
end;

procedure TLoginResponse.TriggerMessage(AMsg: string);
begin
  if Assigned(_Message) then
    _Message(AMsg);
end;

procedure TLoginResponse.TriggerLoginInfo(AInfo: TLoginInfo);
begin
  if Assigned(_PassLoginInfo) then
    _PassLoginInfo(AInfo);
end;

destructor TLoginResponse.Destroy;
begin

end;

end.
