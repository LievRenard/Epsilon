defmodule Epsilon.Polynomial do
  @moduledoc """
  Module "Polynomial" provides polynomial type and arithmetics. Polynomials can act like functions by ~>/2 operator or substitute/2 function. It has Vector_Behaviour. (But not support norm/1 yet.)
  """
  @behaviour Epsilon.Behaviour.Vector_Behaviour

  @typedoc """
  Polynomial coefficient list with :polynomial head. Indices of tail list means order of each terms, *i.e.* polynomial type consists of [:polynomial, :zeroth_order, :first_order, ...].

  ### Properties

  - :polynomial : Means this list is polynomial type.

  - coefficients: A list contains coefficients of polynomial.
  """
  @type polynomial :: [:polynomial | list(Epsilon.extended_number)]

  @doc """
  Constructor of polynomial. The parameter is a list of coefficients.
  """
  @spec new(list(Epsilon.extended_number)) :: polynomial
  def new(arr), do: [:polynomial | arr]

  @doc """
  Coefficient of given order-th term of polynomial. If the order of polynomial is small than given order, 0 is returned.

  ### Parameters

  - f: A polynomial

  - n: Order of the term
  """
  @spec coeff(polynomial, integer) :: Epsilon.extended_number
  def coeff(f = [:polynomial | p],n) do
    if order(f) >= n, do: Enum.at(p,n), else: 0
  end

  @doc """
  The highest order of given polynomial. Even if the highest order term is 0, order/1 regards as this zero term is the highest order of the polynomial.

  ### Parameters

  - f: A polynomial
  """
  @spec order(polynomial) :: integer
  def order(_f = [:polynomial | p]), do: length(p)-1

  @doc """
  Addition of two polynomials.

  ### Parameters

  - f1: A polynomial

  - f2: Another polynomial
  """
  @spec add(polynomial,polynomial) :: polynomial
  def add(f1=[:polynomial | _p1], f2=[:polynomial | _p2]) do
    max_order = max(order(f1), order(f2))
    0..max_order |> Enum.map( &(coeff(f1,&1)+coeff(f2,&1)) ) |> new
  end

  @doc """
  Subtraction of two polynomials.

  ### Parameters

  - f1: A polynomial

  - f2: Another polynomial
  """
  @spec sub(polynomial,polynomial) :: polynomial
  def sub(f1=[:polynomial | _p1], f2=[:polynomial | _p2]) do
    max_order = max(order(f1), order(f2))
    0..max_order |> Enum.map( &(coeff(f1,&1)-coeff(f2,&1)) ) |> new
  end

  @doc """
  Multiplication of two polynomials, or a polynomial and a number.

  ### Parameters

  - f1: A polynomial

  - f2: Another polynomial

  - a: A number multiplying the polynomial
  """
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

  @doc """
  Power of a polynomial. The exponent must be non-negative integer.

  ### Parameters

  - f: A polynomial

  - n: An exponent
  """
  @spec pow(polynomial, integer) :: polynomial
  def pow(_f = [:polynomial | _p], 0), do: new([1])
  def pow(f = [:polynomial | _p], 1), do: f
  def pow(f = [:polynomial | _p], n) when is_integer(n), do: mul(f, f) |> pow(f, n-1)
  defp pow(pf = [:polynomial | _pp], _f = [:polynomial | _p], 1), do: pf
  defp pow(pf = [:polynomial | _pp], f = [:polynomial | _p], n) when n > 1, do: mul(pf, f) |> pow(f, n-1)

  def norm(_f = [:polynomial | _p]), do: :not_implemented_yet

  @spec Epsilon.extended_number ~> polynomial :: Epsilon.extended_number
  def x ~> (_f = [:polynomial | p]) do
    p |> Enum.with_index |> Enum.map(fn {c, i} -> c*(x**i) end) |> Enum.sum
  end
  @doc """
  Substitute the number into given polynomial. Equal to the operator ~>/2. Return f(x) = (:zeroth_order) + (:first_order)x + (:second_order)x^2 + ...

  ### Parameters

  - x: A number substituted to the function

  - f: A polynomial
  """
  @spec substitute(Epsilon.extended_number, polynomial) :: Epsilon.extended_number
  def substitute(x,f = [:polynomial | _p]), do: x ~> f

  @spec derivative(polynomial) :: polynomial
  @spec derivative(polynomial, integer) :: polynomial
  def derivative(_f = [:polynomial | p]) do
    [_head | new_p] = p
    |> Enum.with_index()
    |> Enum.map(fn
      {_a, 0} -> nil
      {a, i} -> a*i
      end)
    new_p |> new
  end
  def derivative(f = [:polynomial | _p], 1), do: derivative(f)
  def derivative(f = [:polynomial | _p], order), do: derivative(f, order-1)

  @spec integrate(polynomial, Epsilon.extended_number) :: polynomial
  def integrate(_f = [:polynomial | p], c \\ 0) do
    new_p = p
    |> Enum.with_index()
    |> Enum.map(fn {a, i} -> a/(i+1) end)
    [c | new_p] |> new
  end
end
