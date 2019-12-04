defmodule Day1 do

  @moduledoc """
  Documentation for Fuel.
  """



  def start() do
    "input.txt"
    |> read_input()
    |> process()
  
  end

  def start2() do
    "input.txt"
    |> read_input()
    |> process2()
   
  end

  def read_input(filename) do

    {:ok, file} = File.read(filename)
    file
  
  end

  def process2(file) do
    file
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end )
    |> Enum.map(fn x -> required_fuel(x, :nested) end )
    |> Enum.reduce(fn x, acc -> x + acc end)
  
  end
 
  def process(file) do
    # read file and get required fuel
    file
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.to_integer(x) end )
    |> Enum.map(fn x -> required_fuel(x) end )
    |> Enum.reduce(fn x, acc -> x + acc end)
  
  end


  def required_fuel(mass, :nested) when mass <= 0 do
      0  
  end

  def required_fuel(mass, :nested) do
    # recursive, when it gets to zero, we add it back up
    initial_total = required_fuel(mass)
    result =  max(initial_total, 0) + required_fuel(max(initial_total, 0), :nested)
    result
  end

  

  @doc """
  Hello world.

  ## Examples

      iex> Fuel.required_fuel(12)
      2

  """

  def required_fuel(mass) do
    mass
    |> divide
    |> floor
    |> subtract
  end
  
  def divide(mass) do
    mass / 3
  end

  def subtract(value) do
    value - 2
  end
end
