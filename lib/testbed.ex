defmodule Testbed do
  import Epsilon
  import Epsilon.Matrix

  def main do
    a = [[1, 2, 3], [4, 5, 6], [7, 8, 9]]
    b = a |> new()

    IO.inspect(b)
    :ok
  end
end
