import Monad
require ListM

defmodule ListMonadTest do
  require ExUnit.DocTest
  use ExUnit.Case, async: true
  doctest ListM
end
