defmodule EpsilonTest do
  use ExUnit.Case
  doctest Epsilon

  test "Epsilon Test" do
    assert Testbed.main() == :ok
  end
end
