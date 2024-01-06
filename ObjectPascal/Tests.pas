(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

program Tests;

uses
  fpjson, jsonparser,
  Classes, Math, SysUtils,
  CalculatorTests;

function LoadTests: string;
var
  FS: TFileStream;
  I: integer;
  N: string;
begin
  N := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + '../Unit-Testing/tests.json';
  FS := TFileStream.Create(N, fmOpenRead);
  try
    SetLength(Result, FS.Size);
    I := FS.Read(Result[1], Length(Result));
    if I < Length(Result) then
      raise Exception.Create('Unexpected end of stream');
  finally
    FS.Free;
  end;
end;

function RunTests: boolean;
var
  Tests: TJSONArray;
  JSON: string;
begin
  JSON := LoadTests;
  Tests := GetJSON(JSON) as TJSONArray;
  try
    Result := PerformTests(Tests);
  finally
    Tests.Free;
  end;
end;

begin
  Halt(IfThen(RunTests, 0, 1));
end.
