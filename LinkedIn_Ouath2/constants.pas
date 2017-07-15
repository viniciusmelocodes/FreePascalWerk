unit constants;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TAccessToken = record
    ToKValue: string;
    TimeToLive: integer;
  end;

const
  PortHTTPSetting = 8001;

  //https://developer.linkedin.com/docs/oauth2
  //https://stackoverflow.com/questions/26105135/linkedin-oauth-2-0-redirect-url

  client_id = 'xxxx';
  client_secret = 'xxxx';

  AuthorizationURL = 'https://www.linkedin.com/oauth/v2/authorization';  //GET method
  Exchange4TokenURL = 'https://www.linkedin.com/oauth/v2/accessToken'; //POST method
  {redirect URL value on LinkedIn site: http://127.0.0.1:8001}
  RedirectURI = 'http://127.0.0.1';
  {online debugging site}
  //RedirectURI = 'https://requestb.in';
  DebugURL = 'https://requestb.in/1bqcc6f1';
  DebugHost = 'requestb.in';

  {API Request URLs}
  PeopleInfoURL = 'https://api.linkedin.com/v1/people/~';
  POSTCommentURL = 'https://api.linkedin.com/v1/people/~/shares';
  LinkedInHost = 'api.linkedin.com';



implementation

end.
