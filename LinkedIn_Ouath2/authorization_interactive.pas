unit authorization_interactive;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, ssl_openssl, synacode, synautil, constants, LCLIntf;

type
  TGetAuthorizationCode = class
  public
    function AGet(AClientID, TheSalt: string): string;
  end;

implementation

function TGetAuthorizationCode.AGet(AClientID, TheSalt: string): string;
var
  params: string = '';

begin
    begin
      params := params + 'response_type=' + EncodeURLElement('code');
      params := params + '&client_id=' + EncodeURLElement(AClientID);
      params := params + '&state=' + EncodeURLElement(TheSalt);
      params := params + '&redirect_uri=' + EncodeURLElement(RedirectURI + ':' + IntToStr(PortHTTPSetting));
    end;

  OpenURL(AuthorizationURL + '?' + params);
end;

end.
