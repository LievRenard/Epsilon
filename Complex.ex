defmodule Epsilon.Complex do
  import Epsilon.Behaviour.Vector_Behaviour
  @behaviour Epsilon.Behaviour.Vector_Behaviour

  @type complex :: [real: number, imag: number]
  @type polarcomplex :: [abs: number, arg: number]

  @spec new(list, atom) :: complex | polarcomplex
  @spec new(number, number, atom) :: complex | polarcomplex
  def new(arr), do: new(arr, :carte)
  def new(arr = [a, b], _form = :carte) when length(arr) == 2, do: [real: a, imag: b]
  def new(arr = [a, b], _form = :polar) when length(arr) == 2, do: [abs: a, arg: b]
  def new(a, b, form \\ :carte), do: new([a,b],form)

  @spec i() :: complex
  def i(), do: new(0,1)

  @spec to_carte(polarcomplex) :: complex
  def to_carte(_z = [abs: r, arg: theta]), do: new(:math.cos(theta)*r,:math.sin(theta)*r)

  @spec to_polar(complex) :: polarcomplex
  def to_polar(z = [real: re, imag: im]), do: new(norm(z),:math.atan2(im,re),:polar)

  @spec form_of(number | complex | polarcomplex) :: atom
  def form_of(z) do
    case z do
      [real: _, imag: _] -> :carte
      [abs: _, arg: _] -> :polar
      _ -> if is_number(z), do: :realnumber, else: :error
    end
  end

  @spec unify(number | complex | polarcomplex) :: complex
  @spec unify(number | complex | polarcomplex, number | complex | polarcomplex) :: complex
  defp unify(z) do
    case form_of(z) do
      :carte -> z
      :polar -> to_carte(z)
      :realnumber -> new(z,0)
    end
  end
  defp unify(z1, z2), do: [unify(z1),unify(z2)]

  @spec add(number | complex | polarcomplex, number | complex | polarcomplex) :: complex
  def add(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> new(re1+re2,im1+im2) end)
  end

  @spec sub(number | complex | polarcomplex, number | complex | polarcomplex) :: complex
  def sub(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> new(re1-re2,im1-im2) end)
  end

  @spec mul(number | complex | polarcomplex, number | complex | polarcomplex) :: complex
  def mul(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> new(re1*re2-im1*im2,re1*im2+re2*im1) end)
  end

  @spec div(number | complex | polarcomplex, number | complex | polarcomplex) :: complex
  def div(z1, z2) do
    unify(z1,z2) |> then(fn ([[real: re1, imag: im1],[real: re2, imag: im2]]) -> (new(re1*re2+im1*im2,-re1*im2+re2*im1) |> mul(1/(re2**2+im2**2))) end)
  end

  @spec conj(number | complex | polarcomplex) :: complex
  def conj(z), do: unify(z) |> then(fn ([real: re, imag: im]) -> new(re,-im) end)

  @spec abs(number | complex | polarcomplex) :: number
  @spec norm(number | complex | polarcomplex) :: number
  @spec abs(number | complex | polarcomplex, :square) :: number
  @spec norm(number | complex | polarcomplex, :square) :: number
  def abs(z), do: :math.sqrt(Epsilon.Complex.abs(z, :square))
  def abs(z,:square), do: unify(z) |> then(fn ([real: re, imag: im]) -> re**2+im**2 end)
  def norm(z), do: Epsilon.Complex.abs(z)
  def norm(z, :square), do: Epsilon.Complex.abs(z, :sqaure)

  @spec express(any) :: atom
  def express(z) do
    cond do
      form_of(z) == :carte and z[:imag] >= 0 -> "#{z[:real]}+#{z[:imag]}i" |> IO.puts
      form_of(z) == :carte and z[:imag] < 0 -> "#{z[:real]}#{z[:imag]}i" |> IO.puts
      form_of(z) == :polar -> "#{z[:abs]}exp(#{z[:arg]}i)" |> IO.puts
      true -> z |> IO.puts
    end
  end

  @spec exp(number | complex | polarcomplex) :: complex
  def exp(z), do: unify(z) |> then(fn ([real: re, imag: im]) -> new(:math.exp(re),im,:polar) end) |> to_carte

  @spec pow(number | complex | polarcomplex, number) :: complex
  def pow(z,x) when is_number(x), do: [unify(z) |> to_polar,x]
  |> then(fn ([[abs: r, arg: theta],x]) -> new(:math.pow(r,x),theta*x,:polar) end) |> to_carte

  @spec sqrt(number | complex | polarcomplex) :: complex
  def sqrt(z), do: pow(z,0.5)

  @spec cos(number | complex | polarcomplex) :: complex
  def cos(z), do: exp(mul(i(),z)) |> add(exp(mul(new(0,-1),z))) |> Epsilon.Complex.div(2)

  @spec sin(number | complex | polarcomplex) :: complex
  def sin(z), do: exp(mul(i(),z)) |> sub(exp(mul(new(0,-1),z))) |> Epsilon.Complex.div(new(0,2))

  @spec tan(number | complex | polarcomplex) :: complex
  def tan(z), do: sin(z) |> Epsilon.Complex.div(cos(z))

  @spec cot(number | complex | polarcomplex) :: complex
  def cot(z), do: cos(z) |> Epsilon.Complex.div(sin(z))

  @spec sec(number | complex | polarcomplex) :: complex
  def sec(z), do: 1 |> Epsilon.Complex.div(cos(z))

  @spec csc(number | complex | polarcomplex) :: complex
  def csc(z), do: 1 |> Epsilon.Complex.div(sin(z))

  @spec cosh(number | complex | polarcomplex) :: complex
  def cosh(z), do: mul(i(),z) |> cos

  @spec sinh(number | complex | polarcomplex) :: complex
  def sinh(z), do: mul(i(),z) |> sin |> mul(new(0,-1))

  @spec tanh(number | complex | polarcomplex) :: complex
  def tanh(z), do: sinh(z) |> Epsilon.Complex.div(cosh(z))

  @spec coth(number | complex | polarcomplex) :: complex
  def coth(z), do: cosh(z) |> Epsilon.Complex.div(sinh(z))

  @spec sech(number | complex | polarcomplex) :: complex
  def sech(z), do: 1 |> Epsilon.Complex.div(cosh(z))

  @spec csch(number | complex | polarcomplex) :: complex
  def csch(z), do: 1 |> Epsilon.Complex.div(sinh(z))

end
