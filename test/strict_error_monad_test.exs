import Monad
require StrictErrorM

defmodule StrictErrorMonadTest do
  require ExUnit.DocTest
  use ExUnit.Case

  doctest StrictErrorM

  # Error Monad
  def error_start() do
    {:ok, :a_value}
  end
  def error_good() do
    {:ok, :another_value}
  end
  def error_bad() do
    {:error, :some_failure}
  end
  def error_worse() do
    {:error, :some_failure, :more_description}
  end

  test "error monad basics" do
    assert (monad StrictErrorM do
      StrictErrorMonadTest.error_start()
    end) == {:ok, :a_value}
  end

  test "error monad bind" do
    assert (monad StrictErrorM do
      something <- StrictErrorMonadTest.error_start()
    end) == {:ok, :a_value}
  end

  test "error multi-step bind" do
    assert (monad StrictErrorM do
      _a_value <- StrictErrorMonadTest.error_start()
      b_value <- StrictErrorMonadTest.error_good()
      return b_value
    end) == {:ok, :another_value}
  end

  test "error monad return" do
    assert (monad StrictErrorM do
      return :a_value
    end) == {:ok, :a_value}
  end

  test "error monad fail" do
    assert (monad StrictErrorM do
      a_value <- StrictErrorMonadTest.error_start()
      _b_value <- StrictErrorMonadTest.error_bad()
      return a_value
    end) == {:error, :some_failure}
  end

  test "error monad fail for larger error tuple" do
    assert (monad StrictErrorM do
      a_value <- StrictErrorMonadTest.error_start()
      _b_value <- StrictErrorMonadTest.error_worse()
      return a_value
    end) == {:error, :some_failure, :more_description}
  end

  test "error monad fail for tuples other than {:ok, _} and {:error, ...}" do
    assert (monad StrictErrorM do
              a_value <- StrictErrorMonadTest.error_start()
              _b_value <- {:incomplete, [], "foo"}
              return a_value
            end) == {:error, {:incomplete, [], "foo"}}
  end
end
