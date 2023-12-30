{$IFDEF FPC}

  // https://www.freepascal.org/docs-html/user/userse33.html
  {$Mode OBJFPC}          // FPC mode with Object Pascal support
  //{$Mode DELPHI}        // Delphi 7 compatibility mode
  //{$Mode DELPHIUNICODE} // Delphi 2009 and later compatibility mode

  // https://www.freepascal.org/docs-html/prog/progsu25.html
  {$LongStrings ON}

{$ELSE}

  {$DEFINE IS_DELPHI}
  {$HIGHCHARUNICODE ON}

{$ENDIF}
