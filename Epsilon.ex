defmodule Epsilon do
  import Epsilon.Const
  import Epsilon.Derivative
  import Epsilon.Integrate
  import Epsilon.Vector
  import Epsilon.Complex
  import Epsilon.Polynomial

  @type extended_number :: number | Epsilon.Complex.complex | Epsilon.Complex.polarcomplex
end
