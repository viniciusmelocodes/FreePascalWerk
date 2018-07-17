unit generate_ip;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

type
  TGenerateIP = class
  private
    _IP_Template: string;
    function ReturnSubGroup(pIPSubGroup: string): integer;
  public
    constructor Create(pTemplate: string = '');   //*.1*2.?1?.1?1
  end;

implementation

constructor TGenerateIP.Create(pTemplate: string = '');
begin
  _IP_Template := pTemplate;
end;

function TGenerateIP.ReturnSubGroup(pIPSubGroup: string): integer;
var
  i: integer;

begin
  case Length(pIPSubGroup) of
    0: exit;
    1:
    begin
      if not TryStrToInt(pIPSubGroup, i) then
      begin
        Randomize;
        case pIPSubGroup of
          '*':
          begin
            Result := RandomRange(0, 256);
          end;
          '?':
          begin
            Result := RandomRange(0, 10);
          end;
        end;

      end;
    end;
    2:  //can be *1 or ?? or ?1
    begin

    end;
    3:
    begin

    end;
  end;
end;

end.
