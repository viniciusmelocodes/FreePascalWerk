unit email_sending;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,
  mimemess, mimepart, smtpsend;

type
  TAlert = class
  private
    _SMTP_IP, _SMTP_user, _SMTP_pwd: string;
  public
    constructor Create(pIP: string; pUser: string = ''; pPassword: string = '');
    function EmailNoAttachment(pEmailBody, pEmailTo, pSubject, pEmailFrom: string): boolean;
    function EmailWithAttachment(pEmailBody, pAttachmentPath, pEmailTo, pSubject, pEmailFrom: string): boolean;
  end;

implementation

constructor TAlert.Create(pIP: string; pUser: string = ''; pPassword: string = '');
begin
  _SMTP_IP := pIP;
  _SMTP_user := pUser;
  _SMTP_pwd := pPassword;
end;

function TAlert.EmailNoAttachment(pEmailBody, pEmailTo, pSubject, pEmailFrom: string): boolean;
var
  message: TMimemess;
  content: TStringList;
  part: TMimepart;

begin
  message := TMimemess.Create;
  content := TStringList.Create;

  try
    part := message.AddPartMultipart('mixed', nil);
    content.Add(pEmailBody);
    message.AddPartText(content, part);

    message.header.from := pEmailFrom;
    message.header.tolist.add(pEmailTo);
    message.header.subject := pSubject;

    message.EncodeMessage;
    Result := SendToRaw(pEmailFrom, message.Header.ToList.Text, _SMTP_IP, message.Lines, _SMTP_user, _SMTP_pwd);

  finally
    message.Free;
    content.Free;
  end;
end;

function TAlert.EmailWithAttachment(pEmailBody, pAttachmentPath, pEmailTo, pSubject, pEmailFrom: string): boolean;
var
  message: TMimemess;
  content: TStringList;
  part: TMimepart;

begin
  message := TMimemess.Create;
  content := TStringList.Create;

  try
    part := message.AddPartMultipart('mixed', nil);
    content.Add(pEmailBody);
    message.AddPartText(content, part);
    message.AddPartBinaryFromFile(pAttachmentPath, part);
    message.header.from := pEmailFrom;
    message.header.tolist.add(pEmailTo);
    message.header.subject := pSubject;

    message.EncodeMessage;
    Result := SendToRaw(pEmailFrom, message.Header.ToList.Text, _SMTP_IP, message.Lines, _SMTP_user, _SMTP_pwd);

  finally
    message.Free;
    content.Free;
  end;
end;

end.
