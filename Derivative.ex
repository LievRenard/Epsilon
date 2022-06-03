defmodule Epsilon.Derivative do
  @moduledoc """
  Module "Derivative" provides numerical derivation.
  """

  def first_derivative([head | tail], h \\ 1) when tail != [] do
    ret = [(hd(tail) - head) / h]
    first_derivative(tail, h, ret)
  end

  defp first_derivative([head | tail], h, ret) when tail != [] do
    ret = ret ++ [(hd(tail) - head) / h]
    first_derivative(tail, h, ret)
  end

  defp first_derivative([_head | []], _h, ret) do
    ret
  end
end
