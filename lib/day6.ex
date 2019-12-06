defmodule Day6 do

  @com "COM"
  @me "YOU"
  @santa "SAN"

  def start(filename) do

    {:ok, orbits} = File.read(filename)


    
    list = orbits
    |> String.split("\n", trim: true)
    |> Enum.map(fn x -> String.split(x, ")", trim: true) end)
    |> Enum.map(fn x -> to_map(x) end)

    IO.puts "Part: 1"
    result = list
    |> Enum.map(fn x -> find_orbits(x, list, 1) end)
    |> Enum.sum
 
    IO.inspect result

    IO.puts "Part: 2"
    find_santa(list)

  end

  def find_orbits(planet, solar_system, value) do
    if(planet.orbits  == @com) do
      value
    else
      immediate_parent = Enum.find(solar_system, fn p -> p.name == planet.orbits end)
      find_orbits(immediate_parent, solar_system, value + 1)
    end
  end

  def find_santa(list) do
   me = Enum.find(list, fn x -> x.name == @me end)
   santa = Enum.find(list, fn x -> x.name == @santa end)
   me_journey = calc_hops(me, list, []) 
   santa_journey = calc_hops(santa, list, [])
   find_meeting_point(me_journey, santa_journey)
  end

  def find_meeting_point(me, santa) do
    me
    |> Enum.with_index
    |> Enum.map(fn {orbit, distance}  -> 
          case Enum.find_index(santa, fn planet -> planet.name == orbit.name end) do
            nil -> nil
            idx ->   
            idx + distance - 2
          end
       end) 
    |> Enum.min
  end

  def calc_hops(orbit, system, moves) do
    if(orbit.orbits == @com) do
      moves
    else
      immediate_parent = Enum.find(system, fn p -> p.name == orbit.orbits end)
      new_moves = moves ++ [orbit]
      calc_hops(immediate_parent, system, new_moves)
    end
  end
 
  def to_map(list) do
   %{name: Enum.at(list, 1), orbits: Enum.at(list,0)}
  end

end
