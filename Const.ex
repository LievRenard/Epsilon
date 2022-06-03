defmodule Epsilon.Const do
  @moduledoc """
  Module "Const" provides several mathematics and science constants. All constants have 8 significants digit.
  """

  @doc """
  Constant "pi(π)", the ratio of a circle's circumference to its diameter.
  """
  def pi, do: 3.1415927

  @doc """
  Constant "e", the base of the natural logarithm.
  """
  def e, do: 2.7182818

  @doc """
  Constant "epsilon(ε) 0", the electric permittivity of the vacuum. Its unit is F/m(farad per metre).
  """
  def ep0, do: 8.8541878

  @doc """
  Constant "mu(μ) 0", the magnetic permeability of the vacuum. Its unit is H/m(Henry per metre).
  """
  def mu0, do: 1.2566371

  @doc """
  Constant "c", the speed of the light. Its unit is m/s(metre per second).
  """
  def c, do: 2.9979246e8

  @doc """
  Constant "q_e" or "e", the elementary charge. Its unit is C(Coulomb).
  """
  def q, do: 1.6021766e-19

  @doc """
  Constant "h", Plank constant. Its unit is J·s(Joule second).
  """
  def h, do: 6.6260702e-34

  @doc """
  Constant "ℏ", ℏ = h/(2π), Dirac constant. Its unit is J·s(Joule second).
  """
  def h_, do: 1.0545718e-34

  @doc """
  Constant "g", the standard gravity. Its unit is m/s²(metre per second square).
  """
  def g, do: 9.80665
end
