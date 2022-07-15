import Epsilon

defmodule Legendre do
  import Epsilon.Polynomial
  import Epsilon.Integrate

  def p(0), do: new([1])
  def p(1), do: new([0,1])
  def p(n) do
    p(n-1)
    |> mul( new([0,2*n-1]) )
    |> sub( p(n-2) |> mul(n-1) )
    |> mul(1/n)
  end

  def expand(func) do
    0..5 |> Enum.map(&(expand(func,&1)))
  end
  def expand(func, n) do
    x = -100..100 |> Enum.map(&(&1/100))
    x |> Enum.map(&( func.(&1)*(&1 ~> p(n)) )) |> trapezoidal(x) |> :erlang./(2/(2*n+1))
  end
end

f = Epsilon.Polynomial.new([-1,0,3])
dfdx = f |> Epsilon.Polynomial.derivative()
integralf = f |> Epsilon.Polynomial.integrate()

dfdx |> IO.inspect()
integralf |> IO.inspect()

area = f |> Epsilon.Polynomial.integrate(0,2)
area |> IO.puts()
