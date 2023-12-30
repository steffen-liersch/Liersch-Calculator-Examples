(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

unit Calculator;

interface

uses
  Math, SysUtils,
  CalculatorException, FloatFormatter, RegexAdapter, Token;

type
  PCalculatorValue = ^double;
  TCalculatorStrings = array of string;
  TCalculatorTokens = array of TToken;
  TCalculatorSteps = array of TCalculatorTokens;

  // "... of object" is required if not marked as static!
  TCalculatorFunction = function(Op: char; X, Y: double): double;

type
  TCalculator = class
  public
    constructor Create; overload;
    constructor Create(Formatter: TFloatFormatter); overload;
    destructor Destroy; override;

    function Format(Token: TToken): string;
    function CalculateAndFormat(Expression: string; StepPrefix: string = '= '): TCalculatorStrings;
    function Calculate(Expression: string): PCalculatorValue;

  private
    FRegex: TRegexAdapter; // This field is not static, because instances of TRegExpr are not stateless (see RegexAdapter_FPC).
    FFormatter: TFloatFormatter;
    FMatches: TCalculatorTokens;
    FSteps: TCalculatorSteps;
    FIsFirstStep: boolean;
    FResult: double;

    function CalculateFrom(Index: integer): integer;
    function Resolve(Index: integer; Operators: string; Fn: TCalculatorFunction): integer;
    function TryGetSign(Index: integer): integer; // Returns -2 if there is no sign
    function GetOperator(Index: integer): char;
    function GetValue(Index: integer): double;
    procedure SaveResult;
    procedure Initialize;

    class function PerformPowerCalculation(Op: char; X, Y: double): double; static;
    class function PerformPointCalculation(Op: char; X, Y: double): double; static;
    class function PerformLineCalculation(Op: char; X, Y: double): double; static;
  end;

implementation

procedure SpliceTokens(var List: TCalculatorTokens; Index, DeleteCount: integer; var Replacement: TToken); forward;

constructor TCalculator.Create;
begin
  Initialize;
  FFormatter.Create;
end;

constructor TCalculator.Create(Formatter: TFloatFormatter);
begin
  Initialize;
  FFormatter := Formatter;
end;

procedure TCalculator.Initialize;
begin
  FRegex := TRegexAdapter.Create('\d+(\.\d+)?|[A-Za-z]+|[+\-*/%^()]|[^\dA-Za-z+\-*/%^()\s]+');
  FIsFirstStep := true;
end;

destructor TCalculator.Destroy;
begin
  // The destructor is also called if an exception occurred during the constructor.
  FreeAndNil(FRegex);
end;

function TCalculator.Format(Token: TToken): string;
var
  V: double;
  S: string;
begin
  if not Token.HasNumber then
    Exit(token.AsString);

  V := Token.AsNumber;
  S := FFormatter.Format(V);
  if v < 0 then
    Exit('(' + S + ')');
  Exit(S);
end;

function TCalculator.CalculateAndFormat(Expression: string; StepPrefix: string = '= '): TCalculatorStrings;
var
  SB: TStringBuilder;
  V: PCalculatorValue;
  E: string;
  C, D, I, J: integer;
begin
  V := nil;
  E := '';
  try
    V := Calculate(Expression);
  except
    on X: ECalculatorException do // Don't handle unexpected errors!
      E := X.Message;
  end;

  Result := nil;

  SB := TStringBuilder.Create;
  try
    C := Length(FSteps);
    SetLength(Result, C);
    for I := 0 to C - 1 do
    begin
      D := Length(FSteps[I]);
      for J := 0 to D - 1 do
        SB.Append(Format(FSteps[I][J]));
      Result[I] := SB.ToString;
      SB.Clear;
    end;
  finally
    SB.Free;
  end;

  if V <> nil then
  begin
    Inc(C);
    SetLength(Result, C);
    Result[C - 1] := FFormatter.Format(V^);
  end;

  if Length(E) > 0 then
  begin
    Inc(C);
    SetLength(Result, C);
    Result[C - 1] := E;
  end;
end;

function TCalculator.Calculate(Expression: string): PCalculatorValue;
var
  Temp: TStringArray;
  C, I: integer;
begin
  FIsFirstStep := true;
  SetLength(FSteps, 0);

  Temp := FRegex.GetMatches(Expression);
  C := Length(Temp);
  SetLength(FMatches, C);
  if C <= 0 then
    Exit(nil);

  for I := 0 to C - 1 do
    FMatches[I].Create(Temp[I]);

  CalculateFrom(0);

  if Length(FMatches) <= 0 then
    raise Exception.Create('Unexpected');

  if Length(FMatches) > 1 then
    raise ECalculatorException.Create('Operator expected instead of ' +
      FMatches[1].AsString);

  if not FMatches[0].HasNumber then
    raise Exception.Create('Unexpected');

  FResult := FMatches[0].AsNumber;
  Result := @FResult;
end;

function TCalculator.CalculateFrom(Index: integer): integer;
begin
  Resolve(Index, '^', @PerformPowerCalculation);
  Resolve(Index, '*/%', @PerformPointCalculation);
  Result := Resolve(Index, '+-', @PerformLineCalculation);
end;

function TCalculator.Resolve(Index: integer; Operators: string; Fn: TCalculatorFunction): integer;
var
  T: TToken;
  Saved: boolean;
  Sgn, I, Z: integer;
  V1, V2: double;
  Op: char;
begin
  I := Index;
  Sgn := TryGetSign(I);
  if Sgn <> -2 then
  begin
    Inc(I);

    // Power operator has priority over sign
    if operators = '^' then
      Sgn := -2;
  end;

  V1 := GetValue(I);
  Inc(I);
  if Sgn <> -2 then
    V1 := V1 * Sgn;

  Saved := false;

  while (I < Length(FMatches)) and (FMatches[I].AsString <> ')') do
  begin
    Op := GetOperator(I);
    V2 := GetValue(I + 1);
    I := I + 2;

    if Pos(Op, Operators) > 0 then
    begin
      V2 := Fn(Op, V1, V2);

      if not Saved then
      begin
        Saved := true;
        SaveResult;
      end;

      T.Create(V2);
      Z := IfThen(Sgn <> -2, 4, 3);
      SpliceTokens(FMatches, I - Z, Z, T);
      I := I - Z + 1;
    end;

    V1 := V2;
    Sgn := -2;
  end;

  if Sgn <> -2 then
  begin
    T.Create(V1);
    SpliceTokens(FMatches, Index, 2, T);
  end;

  Result := I;
end;

// Returns -2 if there is no sign
function TCalculator.TryGetSign(Index: integer): integer;
var
  S: string;
begin
  if index < Length(FMatches) then
  begin
    S := FMatches[Index].AsString;
    if S = '+' then
      Exit(+1);
    if S = '-' then
      Exit(-1);
  end;
  Exit(-2);
end;

function TCalculator.GetOperator(Index: integer): char;
var
  S: string;
  Op: char;
begin
  if Index >= Length(FMatches) then
    raise ECalculatorException.Create('Operator expected');

  S := FMatches[index].AsString;
  if Length(S) = 1 then
  begin
    Op := S[1];
    if Pos(Op, '+-*/%^') > 0 then
      Exit(Op);
  end;

  raise ECalculatorException.Create('Operator expected instead of ' + s);
end;

function TCalculator.GetValue(Index: integer): double;
var
  M: TToken;
  I: integer;
begin
  if Index >= Length(FMatches) then
    raise ECalculatorException.Create('Number expected');

  M := FMatches[Index];

  if M.AsString = '(' then
  begin
    I := CalculateFrom(Index + 1);

    if I <> Index + 2 then
      raise Exception.Create('Unexpected');

    if (I >= Length(FMatches)) or (FMatches[I].AsString <> ')') then
      raise ECalculatorException.Create('Missing closing brace');

    M := FMatches[Index + 1];
    SpliceTokens(FMatches, Index, 3, M);
  end;

  if not M.HasNumber then
    raise ECalculatorException.Create('Number expected instead of ' + M.AsString);

  Result := M.AsNumber;
end;

procedure TCalculator.SaveResult;
var
  I: integer;
begin
  if FIsFirstStep then
    FIsFirstStep := false
  else
  begin
    I := Length(FSteps);
    SetLength(FSteps, I + 1);
    FSteps[I] := Copy(FMatches, 0, Length(FMatches));
  end;
end;

class function TCalculator.PerformPowerCalculation(Op: char; X, Y: double): double;
begin
  Result := Power(X, Y);
end;

class function TCalculator.PerformPointCalculation(Op: char; X, Y: double): double;
begin
  case Op of
    '*': Result := X * Y;
    '/': Result := X / Y;
    '%': Result := FMod(X, Y);
    else raise Exception.Create('Unexpected');
  end;
end;

class function TCalculator.PerformLineCalculation(Op: char; X, Y: double): double;
begin
  case Op of
    '+': Result := X + Y;
    '-': Result := X - Y;
    else raise Exception.Create('Unexpected');
  end;
end;

// Modifies the given array
procedure SpliceTokens(var List: TCalculatorTokens; Index, DeleteCount: integer; var Replacement: TToken);
var
  C, I, J: integer;
begin
  if DeleteCount > 1 then
  begin
    I := Index + 1;
    J := Index + DeleteCount;
    C := Length(List);
    while J < C do
    begin
      List[I] := List[J];
      Inc(I);
      Inc(J);
    end;
    SetLength(List, C - DeleteCount + 1);
  end;
  List[Index] := Replacement;
end;

end.
