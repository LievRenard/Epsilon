defmodule Epsilon.Matrix do
  @type matrix :: [:matrix | list(list)]

  def new(lst) do
    sublen = hd(lst) |> length
    if Enum.all?(lst, fn sublst -> length(sublst) == sublen end) do
      [:matrix | lst]
    else
      raise ArgumentError, message: "All matrix rows must be same length"
    end
  end


end
