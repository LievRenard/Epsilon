defmodule Epsilon.Polynomial do
  @behaviour Epsilon.Behaviour.Vector_Behaviour

  @type polynomial :: [:polynomial | list(Epsilon.extended_number)]

  @spec new(list(Epsilon.extended_number)) :: polynomial
  def new(arr), do: [:polynomial | arr]

  @spec coeff(polynomial, integer) :: Epsilon.extended_number
  def coeff(f = [:polynomial | p],n) do
    if order(f) >= n, do: Enum.at(p,n), else: 0
  end

  @spec order(polynomial) :: integer
  def order(_f = [:polynomial | p]), do: length(p)-1

  @spec add(polynomial,polynomial) :: polynomial
  def add(f1=[:polynomial | _p1], f2=[:polynomial | _p2]) do
    max_order = max(order(f1), order(f2))
    0..max_order |> Enum.map( &(coeff(f1,&1)+coeff(f2,&1)) ) |> new
  end

  @spec sub(polynomial,polynomial) :: polynomial
  def sub(f1=[:polynomial | _p1], f2=[:polynomial | _p2]) do
    max_order = max(order(f1), order(f2))
    0..max_order |> Enum.map( &(coeff(f1,&1)-coeff(f2,&1)) ) |> new
  end

  @spec mul(polynomial, polynomial) :: polynomial
  def mul(f1=[:polynomial | _p1], f2=[:polynomial | _p2]) do
    ret = 0..(order(f1)+order(f2)) |> Enum.map(&(&1*0))
    [o1, o2] = [0,0]
    mul(f1,f2,o1,o2,ret)
  end
  @spec mul(polynomial, Epsilon.extended_number) :: polynomial
  def mul(f = [:polynomial | _p], a), do: f |> mul([a] |> new)
  defp mul(f1=[:polynomial | _p1], f2=[:polynomial | _p2], o1,o2, ret) do
    cond do
      o2 < order(f2) ->
        ret = ret |> List.update_at(o1+o2,&(&1+coeff(f1,o1)*coeff(f2,o2)))
        mul(f1, f2, o1, o2+1, ret)
      o2 == order(f2) and o1 < order(f1) ->
        ret = ret |> List.update_at(o1+o2,&(&1+coeff(f1,o1)*coeff(f2,o2)))
        mul(f1, f2, o1+1, 0, ret)
      o2 == order(f2) and o1 == order(f1) ->
        ret |> List.update_at(o1+o2,&(&1+coeff(f1,o1)*coeff(f2,o2))) |> new
    end
  end

  @spec pow(polynomial, integer) :: polynomial
  def pow(f = [:polynomial | _p], n) when is_integer(n), do: mul(f, f) |> pow(f, n-1)
  defp pow(pf = [:polynomial | _pp], _f = [:polynomial | _p], 1), do: pf
  defp pow(pf = [:polynomial | _pp], f = [:polynomial | _p], n) when n > 1, do: mul(pf, f) |> pow(f, n-1)

  def norm(_f = [:polynomial | _p]), do: :not_implemented_yet

  @spec Epsilon.extended_number ~> polynomial :: Epsilon.extended_number
  def x ~> (_f = [:polynomial | p]) do
    p |> Enum.with_index |> Enum.map(fn {c, i} -> c*(x**i) end) |> Enum.sum
  end
  @spec substitute(Epsilon.extended_number, polynomial) :: Epsilon.extended_number
  def substitute(x,f = [:polynomial | _p]), do: x ~> f
end
