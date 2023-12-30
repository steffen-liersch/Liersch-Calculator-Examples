(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

unit DefaultFormat;

interface

uses
  SysUtils;

var
  // Only the fields required for floating point numbers are initialized.
  InvariantFormatSettings: TFormatSettings;

implementation

begin
  FillChar(InvariantFormatSettings, SizeOf(InvariantFormatSettings), 0);
  InvariantFormatSettings.DecimalSeparator := '.';
  InvariantFormatSettings.ThousandSeparator := ',';
end.
