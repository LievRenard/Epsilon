defmodule Epsilon.Derivative do
  @moduledoc """
  Module "Derivative" provides numerical derivation.
  """

  @doc """
  First order derivative of given list.

  ### Parameters

  - f: A list for derivation. There must be at least 2 elements in the list.

  - h*(optional)*: Interval of domain of f.
  """
  @spec first_derivative(list, number | list) :: list
  def first_derivative(_f = [head | tail], h \\ 1) when is_number(h) and tail != [] do
    ret = [(hd(tail) - head) / h]
    first_derivative(tail, h, ret)
  end
  defp first_derivative(_f = [head | tail], h, ret) when is_number(h) and tail != [] do
    ret = ret ++ [(hd(tail) - head) / h]
    first_derivative(tail, h, ret)
  end
  def first_derivative(_f = [head | tail], _h =[h_head | h_tail]) when tail != [] do
    ret = [(hd(tail) - head) / (hd(h_tail) - h_head)]
    first_derivative(tail, h_tail, ret)
  end
  defp first_derivative(_f = [head | tail], _h =[h_head | h_tail], ret) when tail != [] do
    ret = ret ++ [(hd(tail) - head) / (hd(h_tail) - h_head)]
    first_derivative(tail, h_tail, ret)
  end
  defp first_derivative(_f = [_head | []], _h, ret) do
    ret
  end
end
