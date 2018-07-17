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
  ip.a := ExtractDelimited(1, _IP_Template, ['.']);
  ip.b := ExtractDelimited(2, _IP_Template, ['.']);
  ip.c := ExtractDelimited(3, _IP_Template, ['.']);
  ip.d := ExtractDelimited(4, _IP_Template, ['.']);

  Randomize;
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

    3:  //can be 111 1?1 ?1? . accept * as ?
    begin
      if (not AnsiContainsText(pIPSubGroup, '?') and not AnsiContainsText(pIPSubGroup, '*')) then
      begin
        Result := pIPSubGroup;
        exit;
      end;

      if (AnsiStartsStr('?', pIPSubGroup) or AnsiStartsStr('*', pIPSubGroup)) and (AnsiEndsStr('?', pIPSubGroup) or AnsiEndsStr('*', pIPSubGroup)) then
      begin
        Result := RandomRange(1, 3).ToString + Copy(pIPSubGroup, 1, 1) + RandomRange(0, 10).ToString;
        exit;
      end;

      if (AnsiStartsStr('?', pIPSubGroup) or AnsiStartsStr('*', pIPSubGroup)) then
      begin
        Result := RandomRange(1, 3).ToString + Copy(pIPSubGroup, 2, Length(pIPSubGroup));
        exit;
      end;

      if (AnsiEndsStr('?', pIPSubGroup) or AnsiEndsStr('*', pIPSubGroup)) then
      begin
        Result := Copy(pIPSubGroup, 0, 2) + RandomRange(0, 10).ToString;
        exit;
      end;

      Result := Copy(pIPSubGroup, 0, 1) + RandomRange(0, 10).ToString + Copy(pIPSubGroup, 0, 1);
    end;
  end;
end;

end.
