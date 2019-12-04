defmodule Day2 do


  def start(filename) do

    {:ok, numbers} = File.read(filename)
    
    list = numbers
    |> String.split(",", trim: true)
    |> Enum.map(fn x -> String.to_integer(String.trim(x)) end)
    |> List.update_at(1,fn x -> 12 end)
    |> List.update_at(2,fn x -> 2 end)
    start_index = 0

    #case process
    #{:halt, list} -> list
    #{new_pos, list} -> process
    run({start_index,list}) 
  end

  def start2(filename, desired_value) do
   {:ok, numbers} = File.read(filename)
    
    list = numbers
    |> String.split(",", trim: true)
    |> Enum.map(fn x -> String.to_integer(String.trim(x)) end)


    find_value(0,0,list,desired_value)

    #update noun
  #   List.update_at(list,1,fn x -> noun end)
    #update_verb
    #   List.update_at(list,2,fn x -> verb end)
    #   start_index = 0

    
    # result = run({start_index, list})
  
  end

  def find_value(noun, verb, original_list, desired_value) do
     
    attemp = original_list 
             |>  List.update_at(1, fn x -> noun end)
             |>  List.update_at(2, fn x -> verb end)

    result = Enum.at(run({0, attemp}),0)

    IO.puts(result)
   
    if result == desired_value do
      100 * noun + verb
    else
      {updated_noun, updated_verb} = next_iteration(noun, verb)
      find_value(updated_noun, updated_verb, original_list, desired_value)
    end
  end

  def next_iteration(noun,verb) do

   if verb == 99 do
     { noun + 1, 0}
   else
     { noun, verb + 1}
   end

  end

  def run({:halt, list}) do
    list
  end

  def run({start_index, list}) do
    start_operation = Enum.at(list, start_index)
    run(process(start_index, start_operation, list))

  end

  
  def process(current_position, 1, list) do
    # this is the one where we add two numbers
    first_number = Enum.at(list, current_position + 1)
    second_number = Enum.at(list, current_position + 2)
    store_location = Enum.at(list, current_position + 3)

    new_value = Enum.at(list, first_number) + Enum.at(list, second_number)
    new_list = List.update_at(list, store_location, fn x -> new_value end)
    {current_position + 4, new_list}
  end

  def process(current_position, 2, list) do
    # this is the one where we add two numbers
    first_number = Enum.at(list, current_position + 1)
    second_number = Enum.at(list, current_position + 2)
    store_location = Enum.at(list, current_position + 3)

    new_value = Enum.at(list, first_number)  * Enum.at(list,  second_number)
    new_list = List.update_at(list, store_location, fn x -> new_value end)
    {current_position + 4, new_list}
  end

  def process(current_position, 99, list) do
    #no op
    {:halt, list}
  end

end
