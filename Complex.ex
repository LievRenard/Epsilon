defmodule Epsilon.Complex do
  @moduledoc """
  Module "Complex" provides complex type and elementary arithmetic and functions of complex numbers. It has Vector_Behaviour.
  """
  @behaviour Epsilon.Behaviour.Vector_Behaviour

  @typedoc """
  Complex number in cartesian coordinate.

  ### Properties

  - real: Real part of complex number

  - imag: Imaginary part of complex number
  """
  @type complex :: [real: number, imag: number]
  @typedoc """
  Complex number in polar coordinate.

  ### Properties

  - abs: Absolute value of complex number

  - arg: Argument of complex number
  """
  @type polarcomplex :: [abs: number, arg: number]

  @doc """
  Constructor of complex. Both of list and numbers can be parameter of constructor. The atom parameter "form" decides type of complex. :carte provides cartesian form, and :polar provides polar form.
  """
  @spec new(list, atom) :: complex | polarcomplex
  @spec new(number, number, atom) :: complex | polarcomplex
  def new(arr), do: new(arr, :carte)
  def new(arr = [a, b], _form = :carte) when length(arr) == 2, do: [real: a, imag: b]
  def new(arr = [a, b], _form = :polar) when length(arr) == 2, do: [abs: a, arg: b]
  def new(a, b, form \\ :carte), do: new([a,b],form)

  @doc """
  Imaginary unit i = sqrt(-1) in cartesian form.
  """
  @spec i() :: complex
  def i(), do: new(0,1)

  @doc """
  Convert polar form complex to cartesian form.

  ### Parameters

  - _z: A polar form complex number.
  """
  @spec to_carte(polarcomplex) :: complex
  def to_carte(_z = [abs: r, arg: theta]), do: new(:math.cos(theta)*r,:math.sin(theta)*r)

  @doc """
  Convert cartesian form complex to polar form.

  ### Parameters

  - z: A cartesian form complex number.
  """
  @spec to_polar(complex) :: polarcomplex
  def to_polar(z = [real: re, imag: im]), do: new(norm(z),:math.atan2(im,re),:polar)

  @doc """
  Return form of given complex or real number as atom.

  ### Parameters

  - z: A complex or real number.

  ### Returns

  - :carte : Means z is cartesian form complex number.

  - :polar : Means z is polar form complex number.

  - :realnumber : Means z is integer or float type.

  - :other : Means z is not a number.
  """
  @spec form_of(Epsilon.extended_number) :: atom
  def form_of(z) do
    case z do
      [real: _, imag: _] -> :carte
      [abs: _, arg: _] -> :polar
      _ -> if is_number(z), do: :realnumber, else: :other
    end
  end

  defp unify(z) do
    case form_of(z) do
      :carte -> z
      :polar -> to_carte(z)
      :realnumber -> new(z,0)
    end
  end
  defp unify(z1, z2), do: [unify(z1),unify(z2)]

  @doc """
  Addition of two complex number. Returns cartesian form complex.

  ### Parameters

  - z1: A complex number

  - z2: Another complex number
  """
  @spec add(Epsilon.extended_number, Epsilon.extended_number) :: complex
  def add(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> new(re1+re2,im1+im2) end)
  end

  @doc """
  Subtraction of two complex number. Returns cartesian form complex.

  ### Parameters

  - z1: A complex number

  - z2: Another complex number
  """
  @spec sub(Epsilon.extended_number, Epsilon.extended_number) :: complex
  def sub(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> new(re1-re2,im1-im2) end)
  end

  @doc """
  Multiplication of two complex number. Returns cartesian form complex.

  ### Parameters

  - z1: A complex number

  - z2: Another complex number
  """
  @spec mul(Epsilon.extended_number, Epsilon.extended_number) :: complex
  def mul(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> new(re1*re2-im1*im2,re1*im2+re2*im1) end)
  end

  @doc """
  Division of two complex number. Returns cartesian form complex.

  ### Parameters

  - z1: A complex number

  - z2: Another complex number
  """
  @spec div(Epsilon.extended_number, Epsilon.extended_number) :: complex
  def div(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> (new(re1*re2+im1*im2,-re1*im2+re2*im1) |> mul(1/(re2**2+im2**2))) end)
  end

  @doc """
  Complex conjugate of given complex number.

  ### Parameters

  - _z: A complex number
  """
  @spec conj(complex | polarcomplex) :: complex | polarcomplex
  def conj(_z = [real: re, imag: im]), do: new(re,-im)
  def conj(_z = [abs: r, arg: theta]), do: new(r,-theta,:polar)

  @doc """
  Norm(absolute value) of two complex number. Returns cartesian form complex. For efficiency, it is not recommended to put polarcomplex type to this function. abs/1 and norm/1 are same functions.

  ### Parameters

  - z: A complex number
  """
  @spec abs(Epsilon.extended_number) :: number
  @spec norm(Epsilon.extended_number) :: number
  @spec abs(Epsilon.extended_number, :square) :: number
  @spec norm(Epsilon.extended_number, :square) :: number
  def abs(z), do: :math.sqrt(Epsilon.Complex.abs(z, :square))
  def abs(z,:square), do: unify(z) |> then(fn ([real: re, imag: im]) -> re**2+im**2 end)
  def norm(z), do: Epsilon.Complex.abs(z)
  def norm(z, :square), do: Epsilon.Complex.abs(z, :sqaure)

  @doc """
  Print the complex number as "a+bi"(cartesian) or "aexp(bi)"(polar) form. If parameter is not a complex number, it print parameter itself.

  ### Parameters

  - z: A complex number
  """
  @spec express(any) :: atom
  def express(z) do
    cond do
      form_of(z) == :carte and z[:imag] >= 0 -> "#{z[:real]}+#{z[:imag]}i" |> IO.puts
      form_of(z) == :carte and z[:imag] < 0 -> "#{z[:real]}#{z[:imag]}i" |> IO.puts
      form_of(z) == :polar -> "#{z[:abs]}exp(#{z[:arg]}i)" |> IO.puts
      true -> z |> IO.puts
    end
  end

  @doc """
  Complex exponential function. Return cartesian form.
  """
  @spec exp(Epsilon.extended_number) :: complex
  def exp(z), do: unify(z) |> then(fn ([real: re, imag: im]) -> new(:math.exp(re),im,:polar) end) |> to_carte

  @doc """
  Power of complex number. Return cartesian form.

  ### Parameters

  - z: Base. A complex number.

  - x: Exponent. A real number of float or integer type.
  """
  @spec pow(Epsilon.extended_number, number) :: complex
  def pow(z,x) when is_number(x), do: [unify(z) |> to_polar,x]
  |> then(fn ([[abs: r, arg: theta],x]) -> new(:math.pow(r,x),theta*x,:polar) end) |> to_carte

  @doc """
  Square root of given complex number. Return cartesian form.
  """
  @spec sqrt(Epsilon.extended_number) :: complex
  def sqrt(z), do: pow(z,0.5)

  @doc """
  Complex cosine function. Return cartesian form.
  """
  @spec cos(Epsilon.extended_number) :: complex
  def cos(z), do: exp(mul(i(),z)) |> add(exp(mul(new(0,-1),z))) |> Epsilon.Complex.div(2)

  @doc """
  Complex sine function. Return cartesian form.
  """
  @spec sin(Epsilon.extended_number) :: complex
  def sin(z), do: exp(mul(i(),z)) |> sub(exp(mul(new(0,-1),z))) |> Epsilon.Complex.div(new(0,2))

  @doc """
  Complex tangent function. Return cartesian form.
  """
  @spec tan(Epsilon.extended_number) :: complex
  def tan(z), do: sin(z) |> Epsilon.Complex.div(cos(z))

  @doc """
  Complex cotangent function. Return cartesian form.
  """
  @spec cot(Epsilon.extended_number) :: complex
  def cot(z), do: cos(z) |> Epsilon.Complex.div(sin(z))

  @doc """
  Complex secant function. Return cartesian form.
  """
  @spec sec(Epsilon.extended_number) :: complex
  def sec(z), do: 1 |> Epsilon.Complex.div(cos(z))

  @doc """
  Complex cosecant function. Return cartesian form.
  """
  @spec csc(Epsilon.extended_number) :: complex
  def csc(z), do: 1 |> Epsilon.Complex.div(sin(z))

  @doc """
  Complex hyperbolic cosine function. Return cartesian form.
  """
  @spec cosh(Epsilon.extended_number) :: complex
  def cosh(z), do: mul(i(),z) |> cos

  @doc """
  Complex hyperbolic sine function. Return cartesian form.
  """
  @spec sinh(Epsilon.extended_number) :: complex
  def sinh(z), do: mul(i(),z) |> sin |> mul(new(0,-1))

  @doc """
  Complex hyperbolic tangent function. Return cartesian form.
  """
  @spec tanh(Epsilon.extended_number) :: complex
  def tanh(z), do: sinh(z) |> Epsilon.Complex.div(cosh(z))

  @doc """
  Complex hyperbolic cotangent function. Return cartesian form.
  """
  @spec coth(Epsilon.extended_number) :: complex
  def coth(z), do: cosh(z) |> Epsilon.Complex.div(sinh(z))

  @doc """
  Complex hyperbolic secant function. Return cartesian form.
  """
  @spec sech(Epsilon.extended_number) :: complex
  def sech(z), do: 1 |> Epsilon.Complex.div(cosh(z))

  @doc """
  Complex hyperbolic cosecant function. Return cartesian form.
  """
  @spec csch(Epsilon.extended_number) :: complex
  def csch(z), do: 1 |> Epsilon.Complex.div(sinh(z))

end
