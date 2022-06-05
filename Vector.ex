defmodule Epsilon.Behaviour.Vector_Behaviour do
  @callback new(arg :: term) :: vector :: term
  @callback add(vector1 :: term, vector2 :: term) :: vector :: term
  @callback sub(vector1 :: term, vector2 :: term) :: vector :: term
  @callback mul(vector1 :: term, vector2 :: term) :: vector :: term
  @callback norm(vector :: term) :: output_vector :: term
end

defmodule Epsilon.Vector do
  @behaviour Epsilon.Behaviour.Vector_Behaviour
  @type vector2 :: [x: number, y: number]
  @type vector3 :: [x: number, y: number, z: number]
  @type vector4 :: [t: number, x: number, y: number, z: number]

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

  @spec zero(integer) :: vector2 | vector3 | vector4
  def zero(dim \\ 2) when dim >= 2 and dim <= 4 do
    Enum.map((1..dim), &(&1*0)) |> new
  end

  @spec unit(integer, integer) :: vector2 | vector3 | vector4
  def unit(i, dim \\ 2) when dim >= 2 and dim <= 4 do
    cond do
      is_atom(i) -> zero(dim) |> Keyword.replace!(i,1)
      is_integer(i) -> zero(dim) |> Keyword.replace!(Enum.at([:t, :x, :y, :z], i), 1)
      true -> :error
    end
  end

  @spec add(vector2 | vector3 | vector4, vector2 | vector3 | vector4) :: vector2 | vector3 | vector4
  def add([x: x1,y: y1],[x: x2,y: y2]), do: [x: x1+x2, y: y1+y2]
  def add([x: x1,y: y1,z: z1],[x: x2,y: y2,z: z2]), do: [x: x1+x2, y: y1+y2, z: z1+z2]
  def add([t: t1,x: x1,y: y1,z: z1],[t: t2,x: x2,y: y2,z: z2]), do: [t: t1+t2, x: x1+x2, y: y1+y2, z: z1+z2]

  @spec sub(vector2 | vector3 | vector4, vector2 | vector3 | vector4) :: vector2 | vector3 | vector4
  def sub([x: x1,y: y1],[x: x2,y: y2]), do: [x: x1-x2, y: y1-y2]
  def sub([x: x1,y: y1,z: z1],[x: x2,y: y2,z: z2]), do: [x: x1-x2, y: y1-y2, z: z1-z2]
  def sub([t: t1,x: x1,y: y1,z: z1],[t: t2,x: x2,y: y2,z: z2]), do: [t: t1-t2, x: x1-x2, y: y1-y2, z: z1-z2]

  @spec dot(vector2 | vector3 | vector4, vector2 | vector3 | vector4) :: number
  def dot([x: x1,y: y1],[x: x2,y: y2]), do: x1*x2+y1*y2
  def dot([x: x1,y: y1,z: z1],[x: x2,y: y2,z: z2]), do: x1*x2+y1*y2+z1*z2
  def dot([t: t1,x: x1,y: y1,z: z1],[t: t2,x: x2,y: y2,z: z2]), do: -t1*t2+x1*x2+y1*y2+z1*z2

  @spec inv(vector2 | vector3 | vector4) :: vector2 | vector3 | vector4
  def inv([x: x,y: y]), do: [x: -x, y: -y]
  def inv([x: x,y: y,z: z]), do: [x: -x, y: -y, z: -z]
  def inv([t: t,x: x,y: y,z: z]), do: [t: -t, x: -x, y: -y, z: -z]

  @spec cross(vector3, vector3) :: vector3
  def cross([x: x1,y: y1,z: z1],[x: x2,y: y2,z: z2]), do: [x: y1*z2-z1*y2, y: -x1*z2+z1*x2, z: x1*y2-y1*z2]

  @spec mul(vector2 | vector3 | vector4, number) :: vector2 | vector3 | vector4
  def mul([x: x,y: y], a), do: [x: a*x,y: a*y]
  def mul([x: x,y: y,z: z], a), do: [x: a*x,y: a*y,z: a*z]
  def mul([t: t,x: x,y: y,z: z], a), do: [t: a*t,x: a*x,y: a*y,z: a*z]

  @spec norm(vector2 | vector3) :: number
  def norm([x: x,y: y]), do: :math.sqrt(x**2+y**2)
  def norm([x: x,y: y,z: z]), do: :math.sqrt(x**2+y**2+z**2)

  @spec angle_between(vector2 | vector3, vector2 | vector3) :: number
  @spec angle_between(vector2 | vector3, vector2 | vector3, atom) :: number
  def angle_between(v,w), do: angle_between(v,w,:cos) |> :math.acos
  def angle_between(v,w,:cos), do: dot(v,w)/norm(v)/norm(w)
end
