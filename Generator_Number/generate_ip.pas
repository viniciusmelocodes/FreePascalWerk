unit generate_ip;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, strutils, Math;

type
  IPv4 = record
    a: string;
    b: string;
    c: string;
    d: string;
  end;

type
  { have a Randomize; before instantiating the class. IP template uses wildcards * or ? like in shell}
  TGenerateIP = class
  private
    _IP_Template: string;
    function ReturnSubGroup(pIPSubGroup: string): string;
  public
    constructor Create(pTemplate: string = '');   //*.1*2.?1?.1?1
    function GetIP: string;
  end;

implementation

constructor TGenerateIP.Create(pTemplate: string = '');
begin
  _IP_Template := pTemplate;
end;

function TGenerateIP.GetIP: string;
var
  ip: IPv4;

begin
  if Length(_IP_Template) = 0 then
  begin
    ip.a := RandomRange(0, 256).ToString;
    ip.b := RandomRange(0, 256).ToString;
    ip.c := RandomRange(0, 256).ToString;
    ip.d := RandomRange(0, 256).ToString;

    Result := ip.a + '.' + ip.b + '.' + ip.c + '.' + ip.d;
    exit;
  end;

  ip.a := ExtractDelimited(1, _IP_Template, ['.']);
  ip.b := ExtractDelimited(2, _IP_Template, ['.']);
  ip.c := ExtractDelimited(3, _IP_Template, ['.']);
  ip.d := ExtractDelimited(4, _IP_Template, ['.']);

  Result := ReturnSubGroup(ip.a) + '.' + ReturnSubGroup(ip.b) + '.' + ReturnSubGroup(ip.c) + '.' + ReturnSubGroup(ip.d);
end;

function TGenerateIP.ReturnSubGroup(pIPSubGroup: string): string;
var
  i: integer;

begin
  case Length(pIPSubGroup) of
    0: exit;
    1:
    begin
      if not TryStrToInt(pIPSubGroup, i) then
      begin
        case pIPSubGroup of
          '*':
          begin
            Result := RandomRange(0, 256).ToString;
          end;
          '?':
          begin
            Result := RandomRange(0, 10).ToString;
          end;
        end;
      end;
    end;

    2:  //can be *1 or ?? or ?1
    begin
      if AnsiStartsStr('*', pIPSubGroup) then
      begin
        Result := RandomRange(1, 3).ToString + RandomRange(1, 10).ToString + Copy(pIPSubGroup, 1, 1);
      end;
      if AnsiEndsStr('*', pIPSubGroup) then
      begin
        Result := Copy(pIPSubGroup, 0, 1) + RandomRange(0, 100).ToString;
      end;

      if (AnsiStartsStr('?', pIPSubGroup) and AnsiEndsStr('?', pIPSubGroup)) then
      begin
        Result := RandomRange(1, 3).ToString + RandomRange(0, 10).ToString;
        exit;
      end;

      if AnsiStartsStr('?', pIPSubGroup) then
      begin
        Result := RandomRange(1, 10).ToString + Copy(pIPSubGroup, 2, 1);
      end;
      if AnsiEndsStr('?', pIPSubGroup) then
      begin
        Result := Copy(pIPSubGroup, 0, 1) + RandomRange(0, 10).ToString;
      end;
    end;

    3:  // accept * as ?
    begin
      // like 111
      if (not AnsiContainsText(pIPSubGroup, '?') and not AnsiContainsText(pIPSubGroup, '*')) then
      begin
        Result := pIPSubGroup;
        exit;
      end;

      // like ?1?
      if (AnsiStartsStr('?', pIPSubGroup) or AnsiStartsStr('*', pIPSubGroup)) and (AnsiEndsStr('?', pIPSubGroup) or AnsiEndsStr('*', pIPSubGroup)) then
      begin
        Result := RandomRange(1, 3).ToString + Copy(pIPSubGroup, 1, 1) + RandomRange(0, 10).ToString;
        exit;
      end;

      // like ?11
      if (AnsiStartsStr('?', pIPSubGroup) or AnsiStartsStr('*', pIPSubGroup)) then
      begin
        Result := RandomRange(1, 3).ToString + Copy(pIPSubGroup, 2, Length(pIPSubGroup));
        exit;
      end;

      // like 11?
      if (AnsiEndsStr('?', pIPSubGroup) or AnsiEndsStr('*', pIPSubGroup)) then
      begin
        Result := Copy(pIPSubGroup, 0, 2) + RandomRange(0, 10).ToString;
        exit;
      end;

      // like 1?1 , 1*1
      Result := Copy(pIPSubGroup, 0, 1) + RandomRange(0, 10).ToString + Copy(pIPSubGroup, 3, 1);
    end;
  end;
end;

end.
