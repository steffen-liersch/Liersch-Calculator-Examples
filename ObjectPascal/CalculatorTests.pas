(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

unit CalculatorTests;

interface

uses
  fpjson,
  SysUtils,
  Calculator, FloatFormatter;

function PerformTests(Tests: TJSONArray): boolean;

implementation

function AssertEqual(Expected: TJSONArray; const Actual: TCalculatorStrings): boolean;
var
  C1, C2, I: integer;
begin
  C1 := Expected.Count;
  C2 := Length(Actual);
  if C1 <> C2 then
  begin
    WriteLn('Assertion failed: Arrays with different lengths');
    Exit(false);
  end;

  for I := 0 to C1 - 1 do
  begin
    if Expected.Strings[I] <> Actual[I] then
    begin
      WriteLn('Assertion failed', Expected.Strings[I], Actual[I]);
      Exit(false);
    end;
  end;

  Exit(true);
end;

function PerformTests(Tests: TJSONArray): boolean;
var
  Calculator: TCalculator;
  Formatter: TFloatFormatter;
  TestCount, ErrorCount, I, J: integer;
  Test: TJSONObject;
  Output, Expr: TJSONArray;
  Lines: TCalculatorStrings;
begin
  TestCount := 0;
  ErrorCount := 0;
  Formatter.Create(16);
  Calculator := TCalculator.Create(Formatter);
  try
    for I := 0 to Tests.Count - 1 do
    begin
      Test := Tests[I] as TJSONObject;
      WriteLn('Test: ' + Test.Strings['name']);
      Output := Test.Arrays['output'];
      Expr := Test.Arrays['expression'];
      for J := 0 to Expr.Count - 1 do
      begin
        Lines := calculator.CalculateAndFormat(Expr.Strings[J], '');
        if not AssertEqual(Output, Lines) then
          Inc(ErrorCount);
        Inc(TestCount);
      end;
    end;
  finally
    Calculator.Free;
  end;
  WriteLn(Format('=> %d tests completed with %d errors', [TestCount, ErrorCount]));
  Result := ErrorCount <= 0;
end;

end.
