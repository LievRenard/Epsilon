defmodule Epsilon.Behaviour.Vector_Behaviour do
  @moduledoc """
  Module "Behaviour.Vector_Behaviour" defines behaviours of vector-like custom types. All vector-like types has to contain constructor, addition, subtraction, multiplication and norm operation.
  """
  @callback new(arg :: term) :: vector :: term
  @callback add(vector1 :: term, vector2 :: term) :: vector :: term
  @callback sub(vector1 :: term, vector2 :: term) :: vector :: term
  @callback mul(vector1 :: term, vector2 :: term) :: vector :: term
  @callback norm(vector :: term) :: output_vector :: term
end

defmodule Epsilon.Vector do
  @moduledoc """
  Module "Vector" provides 2, 3, 4-dimension vector types and elementary vector arithmetics. It has "Vector_Behaviour".
  """

  @behaviour Epsilon.Behaviour.Vector_Behaviour

  @typedoc """
  2-dimension vector type.

  ### Properties

  - x: x component of vectors.

  - y: y component of vectors.
  """
  @type vector2 :: [x: number, y: number]

  @typedoc """
  3-dimension vector type.

  ### Properties

  - x: x component of vectors.

  - y: y component of vectors.

  - z: z component of vectors.
  """
  @type vector3 :: [x: number, y: number, z: number]

  @typedoc """
  4-dimension spacetime vector type. Using (-,+,+,+) signature. "vector4" type does not have norm/1 and angle_between/2 functions.

  ### Properties
  - t: time component of vectors.

  - x: x component of vectors.

  - y: y component of vectors.

  - z: z component of vectors.
  """
  @type vector4 :: [t: number, x: number, y: number, z: number]

  @doc """
  Constructor of vector. Both of list and numbers can be parameter of constructor.
  """
  @spec new(list) :: vector2 | vector3 | vector4
  @spec new(number, number) :: vector2
  @spec new(number, number, number) :: vector3
  @spec new(number, number, number, number) :: vector4
  def new(arr) when length(arr) >= 2 and length(arr) <= 4 do
    if length(arr) == 4, do: [[:t,:x,:y,:z]] ++ [arr] |> Enum.zip, else: [[:x,:y,:z]] ++ [arr] |> Enum.zip
  end
  def new(x, y), do: [x: x, y: y]
  def new(x, y, z), do: [x: x, y: y, z: z]
  def new(t, x, y, z), do: [t: t, x: x, y: y, z: z]

  @doc """
  Zero vector of given dimension.

  ### Parameters

  - dim: Dimension of vector. Default dimension is 2.
  """
  @spec zero(integer) :: vector2 | vector3 | vector4
  def zero(dim \\ 2) when dim >= 2 and dim <= 4 do
    Enum.map((1..dim), &(&1*0)) |> new
  end

  @doc """
  Unit vector of given dimension and component.

  ### Parameters

  - i: Component of unit vector. It can be atom(:t, :x, :y, :z) or corresponding integer(0, 1, 2, 3).

  - dim: Dimension of vector. Default dimension is 2.
  """
  @spec unit(integer | atom, integer) :: vector2 | vector3 | vector4
  def unit(i, dim \\ 2) when dim >= 2 and dim <= 4 do
    cond do
      is_atom(i) -> zero(dim) |> Keyword.replace!(i,1)
      is_integer(i) -> zero(dim) |> Keyword.replace!(Enum.at([:t, :x, :y, :z], i), 1)
      true -> :error
    end
  end

  @doc """
  Addition of two vectors.

  ### Parameters

  - _v: A vector.

  - _w: Another vector.
  """
  @spec add(vector2 | vector3 | vector4, vector2 | vector3 | vector4) :: vector2 | vector3 | vector4
  def add(_v=[x: x1,y: y1],_w=[x: x2,y: y2]), do: [x: x1+x2, y: y1+y2]
  def add(_v=[x: x1,y: y1,z: z1],_w=[x: x2,y: y2,z: z2]), do: [x: x1+x2, y: y1+y2, z: z1+z2]
  def add(_v=[t: t1,x: x1,y: y1,z: z1],_w=[t: t2,x: x2,y: y2,z: z2]), do: [t: t1+t2, x: x1+x2, y: y1+y2, z: z1+z2]

  @doc """
  Subtraction of two vectors.

  ### Parameters

  - _v: A vector.

  - _w: Another vector.
  """
  @spec sub(vector2 | vector3 | vector4, vector2 | vector3 | vector4) :: vector2 | vector3 | vector4
  def sub(_v=[x: x1,y: y1],_w=[x: x2,y: y2]), do: [x: x1-x2, y: y1-y2]
  def sub(_v=[x: x1,y: y1,z: z1],_w=[x: x2,y: y2,z: z2]), do: [x: x1-x2, y: y1-y2, z: z1-z2]
  def sub(_v=[t: t1,x: x1,y: y1,z: z1],_w=[t: t2,x: x2,y: y2,z: z2]), do: [t: t1-t2, x: x1-x2, y: y1-y2, z: z1-z2]

  @doc """
  Dot product(inner product) of two vectors.

  ### Parameters

  - _v: A vector.

  - _w: Another vector.
  """
  @spec dot(vector2 | vector3 | vector4, vector2 | vector3 | vector4) :: number
  def dot(_v=[x: x1,y: y1],_w=[x: x2,y: y2]), do: x1*x2+y1*y2
  def dot(_v=[x: x1,y: y1,z: z1],_w=[x: x2,y: y2,z: z2]), do: x1*x2+y1*y2+z1*z2
  def dot(_v=[t: t1,x: x1,y: y1,z: z1],_w=[t: t2,x: x2,y: y2,z: z2]), do: -t1*t2+x1*x2+y1*y2+z1*z2

  @doc """
  Opposite of a vector.

  ### Parameters

  - _v: A vector.
  """
  @spec inv(vector2 | vector3 | vector4) :: vector2 | vector3 | vector4
  def inv(_v=[x: x,y: y]), do: [x: -x, y: -y]
  def inv(_v=[x: x,y: y,z: z]), do: [x: -x, y: -y, z: -z]
  def inv(_v=[t: t,x: x,y: y,z: z]), do: [t: -t, x: -x, y: -y, z: -z]

  @doc """
  Cross product(outer product) of two 3-dimension vectors.

  ### Parameters

  - _v: A 3-dimension vector.

  - _w: Another 3-dimension vector.
  """
  @spec cross(vector3, vector3) :: vector3
  def cross(_v=[x: x1,y: y1,z: z1],_w=[x: x2,y: y2,z: z2]), do: [x: y1*z2-z1*y2, y: -x1*z2+z1*x2, z: x1*y2-y1*z2]

  @doc """
  scalar multiplication of two vectors.

  ### Parameters

  - _v: A vector.

  - a: A number.
  """
  @spec mul(vector2 | vector3 | vector4, number) :: vector2 | vector3 | vector4
  def mul(_v=[x: x,y: y], a), do: [x: a*x,y: a*y]
  def mul(_v=[x: x,y: y,z: z], a), do: [x: a*x,y: a*y,z: a*z]
  def mul(_v=[t: t,x: x,y: y,z: z], a), do: [t: a*t,x: a*x,y: a*y,z: a*z]

  @doc """
  Norm of a vector. It can be complex value if the vector is 4-dimensional.

  ### Parameters

  - _v: A vector.
  """
  @spec norm(vector2 | vector3) :: number | Epsilon.Complex.complex
  def norm(_v=[x: x,y: y]), do: :math.sqrt(x**2+y**2)
  def norm(_v=[x: x,y: y,z: z]), do: :math.sqrt(x**2+y**2+z**2)
  def norm(_v=[t: t,x: x,y: y,z: z]) do
    import Epsilon.Complex, only: [sqrt: 1]
    sqrt(-t**2+x**2+y**2+z**2)
  end

  @doc """
  Obtain the angle between two 2 or 3-dimension vectors.

  ### Parameters

  - _v: A vector.

  - _w: Another vector.

  - :cos : If this atom exists, angle_between/3 returns cosine of the angle between two vectors.
  """
  @spec angle_between(vector2 | vector3, vector2 | vector3) :: number
  @spec angle_between(vector2 | vector3, vector2 | vector3, atom) :: number
  def angle_between(v,w), do: angle_between(v,w,:cos) |> :math.acos
  def angle_between(v,w,:cos), do: dot(v,w)/norm(v)/norm(w)
end
