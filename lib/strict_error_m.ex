defmodule StrictErrorM do
  @moduledoc """
  The error monad.

  All successful actions are expected to return `{:ok, value}`. Any other value
  will be regarded as an error.
  If an error value is passed to bind it will be returned immediately, the
  function passed will not be executed (in other words as soon as an error is
  detected further computation is aborted).

  Return puts the value inside an `{:ok, value}` tuple.

  ## Examples

      iex> require Monad
      iex> monad StrictErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :ok, 3 }
      ...>   return a * b
      ...> end
      { :ok, 6 }

      iex> monad StrictErrorM do
      ...>   a <- { :error, "boom" }
      ...>   b <- { :ok, 3 }
      ...>   return a * b
      ...> end
      { :error, "boom" }

      iex> monad StrictErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :error, "boom" }
      ...>   return a * b
      ...> end
      { :error, "boom" }

      iex> monad StrictErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :error, "boom" }
      ...>   return a * b
      ...> end
      { :error, "boom" }

      iex> monad StrictErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :error, "boom", "bang" }
      ...>   return a * b
      ...> end
      { :error, "boom", "bang" }

      iex> monad StrictErrorM do
      ...>   a <- { :ok, 2 }
      ...>   b <- { :incomplete, [], "foo" }
      ...>   return a * b
      ...> end
      {:error, { :incomplete, [], "foo" }}
  """

  def bind(x, f)
  def bind({:ok, a}, f) do
    f.(a)
  end
  def bind(error_tuple, _f) when is_tuple(error_tuple) and elem(error_tuple, 0) == :error do
    error_tuple
  end
  def bind(error, _f) do
    fail(error)
  end

  def return(a) do
    {:ok, a}
  end

  def fail(reason) do
    {:error, reason}
  end
end
