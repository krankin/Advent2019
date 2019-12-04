defmodule Day3 do


  def start(filename) do

    lines = File.read!(filename)
    positions = lines |> String.split |> Enum.map(&(String.split(&1,",", trim: true)))

    wire_1 = Enum.at(positions, 0)
    wire_2 = Enum.at(positions, 1)

    wire_1_coordinates = map_to_coordinates(wire_1, %{x: 0, y: 0})
    wire_2_coordinates = map_to_coordinates(wire_2, %{x: 0, y: 0})


    common_points = MapSet.intersection(MapSet.new(wire_1_coordinates),MapSet.new(wire_2_coordinates))


    IO.puts "part 1:"

    common_points
    |> Enum.map(&(abs(&1.x) + abs(&1.y)))
    |> Enum.min

    IO.puts "part 2"
    common_points
    |> Enum.map(fn x -> get_distance(x, wire_1_coordinates, wire_2_coordinates) end)
    |> Enum.min
  end

 def get_distance(point, w1, w2) do
   w1_index = Enum.find_index(w1, fn x -> x.x == point.x && x.y == point.y end)
   w2_index = Enum.find_index(w2, fn x -> x.x == point.x && x.y == point.y end)

   w1_index + w2_index + 2  #zero_based_indexing
   
 end


  def compare([],wire_2, results) do
    results
  end

  def compare([point| tail], wire_2, results) do
    if Enum.any?(wire_2, &( point.x == &1.x && point.y == &1.y )) do
      compare(tail, wire_2, results ++ [point])
    else
      compare(tail, wire_2, results)
    end
  end

  def map_to_coordinates(moves, current_position) do

    steps =Enum.map(moves,&(String.split_at(&1,1)))

    #[["U", "15"], []..]
    trace_wire(steps, current_position, [])
  
  end

  def trace_wire([], current_position, results) do
    results 
  end
  
  def trace_wire([{direction, amount} | tail] , current_position, results) do
    result = move(String.to_atom(direction), String.to_integer(amount), current_position, [])
    trace_wire(tail, List.last(result), results ++ result )
  end

  

  def move(direction, 0, point, results) do
    results
  end
  def move(:U, amount, point, results) do
    new_spot = Map.update!(point, :y, &(&1 + 1))
    move(:U, amount - 1, new_spot, results ++ [new_spot]) 
  end
  def move(:D, amount, point, results) do
    new_spot = Map.update!(point, :y, &(&1 - 1))
    move(:D, amount - 1, new_spot, results ++ [new_spot])
  end
  def move(:L, amount, point, results) do
    new_spot = Map.update!(point, :x, &(&1 - 1))
    move(:L, amount - 1, new_spot, results ++ [new_spot]) 
  end
  def move(:R, amount, point, results) do
    new_spot = Map.update!(point, :x, &(&1 + 1))
    move(:R, amount - 1, new_spot, results ++ [new_spot])
  end

end
