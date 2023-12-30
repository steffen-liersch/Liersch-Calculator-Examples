(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

unit Token;

interface

uses
  SysUtils,
  DefaultFormat;

type
  TToken = object
  private
    FHasNumber: boolean;
    FAsNumber: double;
    FAsString: string;
  public
    property HasNumber: boolean read FHasNumber;
    property AsNumber: double read FAsNumber;
    property AsString: string read FAsString;

    constructor Create(Value: double); overload;
    constructor Create(Value: string); overload;
  end;

implementation

constructor TToken.Create(Value: double);
begin
  FHasNumber := true;
  FAsNumber := Value;
  FAsString := FloatToStr(Value, InvariantFormatSettings);
end;

constructor TToken.Create(Value: string);
var
  S: string;
begin
  try
    FAsNumber := StrToFloat(Value, InvariantFormatSettings);
    FAsString := Value;
    FHasNumber := true;
  except
    on EConvertError do
    begin
      S := UpperCase(Value);
      if S = 'E' then
      begin
        FHasNumber := true;
        FAsNumber := Exp(1);
        FAsString := Value;
      end
      else if S = 'PI' then
      begin
        FHasNumber := true;
        FAsNumber := Pi;
        FAsString := Value;
      end
      else
        FAsString := Value;
    end;
  end;
end;

end.
