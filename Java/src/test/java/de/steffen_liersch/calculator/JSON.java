/*--------------------------------------------------------------------------*\
::
::  Copyright © 2023 Steffen Liersch
::  https://www.steffen-liersch.de/
::
\*--------------------------------------------------------------------------*/

package de.steffen_liersch.calculator;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

final class JSON
{
  private JSON()
  {
  }

  public static synchronized JsonNode parse(String json)
  {
    try
    {
      return _objectMapper.readTree(json);
    }
    catch(JsonProcessingException e)
    {
      throw new RuntimeException(e);
    }
  }

  private static final ObjectMapper _objectMapper = new ObjectMapper();
}
