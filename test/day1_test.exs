defmodule Day1Test do
  use ExUnit.Case

  test "Calculates fuel requiredd" do
    assert Day1.required_fuel(12) == 2
    assert Day1.required_fuel(14) == 2
    assert Day1.required_fuel(1969) == 654
    assert Day1.required_fuel(100756) == 33583
  end

  test "Calculates nested fuel requirements" do 
    assert Day1.required_fuel(14,:nested) == 2
  end
end
