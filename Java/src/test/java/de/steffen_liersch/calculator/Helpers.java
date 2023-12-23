/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;

final class Helpers
{
  public static String loadTests()
  {
    try
    {
      String fn = new File("../Unit-Testing/tests.json").getAbsolutePath();
      byte[] buf = Files.readAllBytes(Paths.get(fn));
      return new String(buf, StandardCharsets.UTF_8);
    }
    catch(IOException e)
    {
      throw new RuntimeException(e);
    }
  }

  private Helpers()
  {
  }
}
