(*--------------------------------------------------------------------------*]
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
[*--------------------------------------------------------------------------*)

{$I Options.inc}

unit RegexAdapter;

interface

uses
  RegExpr, SysUtils;

type
  TStringArray = array of string;

type
  // Based on TRegExpr; https://github.com/andgineer/TRegExpr
  TRegexAdapter = class
  public
    constructor Create(Expression: string);
    destructor Destroy; override;
    function GetMatches(value: string): TStringArray;
  private
    FRE: TRegExpr;
  end;

implementation

constructor TRegexAdapter.Create(Expression: string);
begin
  FRE := TRegExpr.Create(Expression);
end;

destructor TRegexAdapter.Destroy;
begin
  FreeAndNil(FRE);
end;

function TRegexAdapter.GetMatches(Value: string): TStringArray;
var
  I: integer;
begin
  Result := nil;
  if FRE.Exec(Value) then
  begin
    I := 0;
    repeat
      SetLength(Result, I + 1);
      Result[I] := FRE.Match[0];
      Inc(I);
    until not FRE.ExecNext;
  end;
end;

end.
