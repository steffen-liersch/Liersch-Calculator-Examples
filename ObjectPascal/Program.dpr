(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023-2024 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

program App;

uses
  SysUtils,
  Calculator;

procedure RunUI;
var
  Calculator: TCalculator;
  Lines: TCalculatorStrings;
  ExitState, I: integer;
  S: string;
begin
  WriteLn;
  WriteLn('Liersch Calculator (Object Pascal)');
  WriteLn('==================');
  WriteLn;

  WriteLn('Copyright '#$00A9' 2023-2024 Steffen Liersch');
  WriteLn('https://www.steffen-liersch.de/');
  WriteLn;

  Calculator := TCalculator.Create;
  try
    ExitState := 0;
    while true do
    begin
      Write('? ');

      ReadLn(S);
      S := Trim(S);

      if Length(S) > 0 then
      begin
        Lines := Calculator.CalculateAndFormat(S);
        for I := 0 to Length(Lines) - 1 do
          WriteLn(Lines[I]);
        ExitState := 0;
      end
      else
      begin
        if ExitState > 0 then
          break;

        WriteLn('Press [Enter] again to exit.');
        Inc(ExitState);
      end;

      WriteLn;
    end;
  finally
    Calculator.Free;
  end;
end;

procedure RunWithArgs(const Args: array of string);
var
  Calculator: TCalculator;
  X: TCalculatorStrings;
  I: integer;
begin
  Calculator := TCalculator.Create;
  try
    for I := Low(Args) to High(Args) do
    begin
      X := Calculator.CalculateAndFormat(Args[I], '');
      if Length(X) > 0 then
        WriteLn(X[High(X)])
      else WriteLn;
    end;
  finally
    Calculator.Free;
  end;
end;

var
  Args: array of string;
  C, I: integer;
begin
  C := ParamCount;
  if C < 1 then
    RunUI
  else
  begin
    SetLength(Args, C);
    for I := 1 to C do
      Args[I - 1] := ParamStr(I);
    RunWithArgs(Args);
  end;
end.
