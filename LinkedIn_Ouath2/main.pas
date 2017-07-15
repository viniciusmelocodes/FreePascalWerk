unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, constants, http_listen,
  authorization_interactive, fphttpserver, dateutils, exchange_authorization_code, deserialize_linked_response,
  linkedin_api_request, fpjson;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    BtShare: TButton;
    Memo1: TMemo;
    Memo2: TMemo;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BtShareClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure HandleHTTPRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest; var AResponse: TFPHTTPConnectionResponse);
    procedure HandleHTTPInfo;
    function StreamToString(aStream: TStream): string;

    procedure GetPeople;
    procedure POSTComment;
  end;

var
  Form1: TForm1;
  _HTTPServer: THTTPServerThread;
  _HTTPRequestInfo: array of TPOSTInfo;
  _Salt: string;
  _AuthorizeCode: string;
  _Token: string;

implementation

{$R *.lfm}

procedure TForm1.FormCreate(Sender: TObject);
begin
  _HTTPServer := THTTPServerThread.Create(PortHTTPSetting, @HandleHTTPRequest);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  _HTTPServer.Terminate;
end;

procedure TForm1.GetPeople;
var
  request: TLinkAPI;
  JSON: TJSONData;
  debug: string;
  err: string;

begin
  Memo1.Append('going for people info.');
  request := TLinkAPI.Create;

  err := request.GETPeopleInfo(_Token, JSON, debug, False);
  FreeAndNil(request);

  Memo2.Append('error: ' + err);
  Memo2.Append('debug info: ' + debug);
end;

procedure TForm1.POSTComment;
var
  request: TLinkAPI;
  debug: string;
  err: string;
  comm: string;
  distrib: integer = 1; //0 - anyone, 1 - only connections

begin
  if Length(trim(_Token)) > 0 then
  begin
    comm := 'TEST - Comment Level ' + IntToStr(DateTimeToUnix(Now));

    request := TLinkAPI.Create;
    err := request.POSTComment(_Token, comm, distrib, debug, true);
    FreeAndNil(request);

    Memo2.Append('error: ' + err);
    Memo2.Append('debug info: ' + debug);
  end
  else
    Memo2.Append('No TOKEN.');
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  t: TGetAuthorizationCode;
  err: string;

begin
  _Salt := 'T' + IntToStr(DateTimeToUnix(Now));
  Memo1.Clear;

  t := TGetAuthorizationCode.Create;
  err := t.AGet(client_id, _Salt);

  if Length(trim(err)) <> 0 then
    Memo1.Append('error: ' + err);

  t.Free;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  GetPeople;
end;

procedure TForm1.BtShareClick(Sender: TObject);
begin
  POSTComment;
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  ds: TDeSerResponse;
  token: TAccessToken;

begin
  ds := TDeSerResponse.Create;
  ds.GetToK(Memo2.Text, token);
  ds.Free;
end;

procedure TForm1.HandleHTTPRequest(Sender: TObject; var ARequest: TFPHTTPConnectionRequest; var AResponse: TFPHTTPConnectionResponse);
var
  i: integer;

begin
  Memo1.Append('------');
  Memo1.Append('starting... ' + IntToStr(DateTimeToUnix(Now)));
  Memo1.Append('request URI: ' + trim(ARequest.URI));
  Memo1.Append('request URL: ' + trim(ARequest.URL));
  Memo1.Append('request Queryfields: ' + trim(ARequest.QueryFields.Text));
  Memo1.Append('http version: ' + ARequest.HttpVersion);
  Memo1.Append('protocol version: ' + ARequest.ProtocolVersion);

  setlength(_HTTPRequestInfo, ARequest.QueryFields.Count);

  for i := 0 to ARequest.QueryFields.Count - 1 do
  begin
    _HTTPRequestInfo[i].FieldName := Copy(ARequest.QueryFields[i], 1, Pos('=', ARequest.QueryFields[i]) - 1);
    _HTTPRequestInfo[i].FieldValue := Copy(ARequest.QueryFields[i], Pos('=', ARequest.QueryFields[i]) + 1, length(ARequest.QueryFields[i]));
  end;

  Memo2.Append('request at: ' + IntToStr(DateTimeToUnix(Now)));

  if trim(_AuthorizeCode) = '' then
  begin
    _HTTPServer.Synchronize(nil, @HandleHTTPInfo);
  end;
end;

procedure TForm1.HandleHTTPInfo;
var
  i: integer;
  e: TExchangeAuthCode;
  serz_token: string; //serialized token
  ds: TDeSerResponse;
  token: TAccessToken;

begin
  for i := Length(_HTTPRequestInfo) - 1 downto 0 do
  begin
    Memo1.Append('field name:' + _HTTPRequestInfo[i].FieldName + ' value:' + _HTTPRequestInfo[i].FieldValue);
    if _HTTPRequestInfo[i].FieldName = 'state' then
    begin
      if _HTTPRequestInfo[i].FieldValue = _Salt then
      begin
        if (i - 1) >= 0 then
        begin
          if _HTTPRequestInfo[i - 1].FieldName = 'code' then
          begin
            _AuthorizeCode := _HTTPRequestInfo[i - 1].FieldValue;

            Memo1.Append('*');
            Memo1.Append('authorize code: ' + _AuthorizeCode);
            Memo1.Append('*');

            if trim(_AuthorizeCode) <> '' then
            begin
              {stopping listening socket}

              Memo1.Append('Going for Token.');

              e := TExchangeAuthCode.Create;
              e.AGet(client_id, client_secret, _AuthorizeCode, serz_token);
              FreeAndNil(e);

              Memo1.Append('LinkedIn answer: ' + serz_token);

              ds := TDeSerResponse.Create;
              ds.GetToK(serz_token, token);
              ds.Free;

              _Token := token.ToKValue;

              if trim(_Token) <> '' then
              begin
                Memo1.Append('token: Bearer ' + token.ToKValue);
                Memo1.Append('time to live: ' + IntToStr(token.TimeToLive));
                //GetPeople;
              end;
            end;

            break;
          end;
        end;
      end;
    end;
  end;
end;

function TForm1.StreamToString(aStream: TStream): string;
var
  SS: TStringStream;
begin
  if aStream <> nil then
  begin
    SS := TStringStream.Create('');
    try
      SS.CopyFrom(aStream, 0);  // No need to position at 0 nor provide size
      Result := SS.DataString;
    finally
      SS.Free;
    end;
  end
  else
  begin
    Result := '';
  end;
end;

end.
