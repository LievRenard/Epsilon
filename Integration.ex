defmodule Epsilon.Integration do
  @moduledoc """
  Module "Integration" provides numerical integral.
  """

  @doc """
  Numerical integral of given list by trapezoidal method.

  ## Parameters

  - f: A list for integration. There must be at least 2 elements in the list.

  - h*(optional)*: Interval of domain of f.
  """
  @spec trapezoidal(list,number) :: number
  def trapezoidal(_f = [head|tail],h \\ 1) when is_number(h) and tail != [] do
    ret = (head+hd(tail))/2*h
    trapezoidal(tail, h, ret)
  end
  defp trapezoidal(_f = [head | tail], h, ret) when is_number(h) and tail != [] do
    ret = ret + (head+hd(tail))/2*h
    trapezoidal(tail, h, ret)
  end

  @spec trapezoidal(list, list) :: number
  def trapezoidal(_f = [head | tail], _h =[h_head | h_tail]) when tail != [] do
    ret = (head+hd(tail))/2*(hd(h_tail) - h_head)
    trapezoidal(tail, h_tail, ret)
  end
  defp trapezoidal(_f = [head | tail], _h =[h_head | h_tail], ret) when tail != [] do
    ret = ret + (head+hd(tail))/2*(hd(h_tail) - h_head)
    trapezoidal(tail, h_tail, ret)
  end
  defp trapezoidal(_f = [_head | []], _h, ret) do
    ret
  end
end
