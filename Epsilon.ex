defmodule Epsilon do
  defmodule Const do
    def pi, do: 3.1415927
    def e, do: 2.7182818
    def ep0, do: 8.8541878
    def mu0, do: 1.2566371
    def c, do: 2.9979246e8
    def charge_e, do: 1.6021766e-19
    def h, do: 6.6260702e-34
    def h_, do: 1.0545718e-34
    def g, do: 9.80665
  end

  defmodule Derivative do

    def first_derivative([head|tail],h \\ 1) when tail != [] do
      ret = [(hd(tail)-head)/h]
      first_derivative(tail,h,ret)
    end
    defp first_derivative([head|tail],h,ret) when tail != [] do
      ret = ret ++ [(hd(tail)-head)/h]
      first_derivative(tail,h,ret)
    end
    defp first_derivative([_head|[]],_h,ret) do
      ret
    end

  end

end
