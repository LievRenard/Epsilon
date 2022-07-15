# Epsilon



The numerical calculation module for elixir.

(Work in progress...)



### Currently contained



**Const**

- Some mathematical & scientific constants

**Derivative**

- Numerical first derivative

**Integration**

- Numerical integration - trapezoidal method

**Vector**

- 2, 3-dimension vectors and 4-dimension spacetime vector
- Vector arithmetics like add, inner product, etc.

**Complex**

- Complex number type in cartesian & polar coordinate
- Elemetary arithmetics & functions for complex number

**Polynomial**

- Polynomials expressed with coefficients list
- Polynomial arithmetics, derivative and integration
- Can act like function with substitution(~>/2) operator



Installation(Cannot install yet)

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `epsilon_mix` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:epsilon_mix, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/epsilon_mix>.
