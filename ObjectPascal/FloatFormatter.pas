(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

unit FloatFormatter;

interface

uses
  StrUtils, SysUtils,
  DefaultFormat;

type
  TFloatFormatter = object
  public
    constructor Create(precision: integer = 6);
    function Format(Value: double): string;
  private
    FPrecision: integer;
  end;

implementation

constructor TFloatFormatter.Create(precision: integer = 6);
begin
  FPrecision := precision;
end;

function TFloatFormatter.Format(Value: double): string;
begin
  Result := FormatFloat('0.' + DupeString('#', FPrecision - 1), Value, InvariantFormatSettings);
end;

end.
