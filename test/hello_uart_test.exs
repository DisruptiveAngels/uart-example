defmodule HelloUartTest do
  use ExUnit.Case
  doctest HelloUart

  test "greets the world" do
    assert HelloUart.hello() == :world
  end
end
