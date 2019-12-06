defmodule Day5 do


  def start(filename) do

    {:ok, numbers} = File.read(filename)
    
    list = numbers
    |> String.split(",", trim: true)
    |> Enum.map(fn x -> String.to_integer(String.trim(x)) end)
    start_index = 0

   result =  run({start_index,list}) 
   IO.puts("Finished")
  end

  def getOpCode(val) do
     rem(val,100)
  end

  def determineOperation(val)do
    case getOpCode(val) do
      1 -> :add
      2 -> :multiply
      3 -> :input
      4 -> :output
      5 -> :jump_if_true
      6 -> :jump_if_false
      7 -> :less_than
      8 -> :equals
      99 -> :halt
    end
  end

  def run({:halt, list}) do
    list
  end

  def run({start_index, list}) do
    start_operation = Enum.at(list, start_index)
    run(process(start_index, determineOperation(start_operation), list, build_modes(start_operation)))
  end


  def build_modes(value) do
    new_value = 100000 + value
    [_|result] = Integer.digits(new_value)
    result
  end

  def mode_result(list, position, mode) do
    case mode do
     0 -> Enum.at(list, position) 
     1 -> position
    end
  end

  def process(current_position, :add, list, modes) do
      first_number = Enum.at(list, current_position + 1)
      second_number = Enum.at(list, current_position + 2)
      store_location = Enum.at(list, current_position + 3)

    new_value = mode_result(list, first_number, Enum.at(modes, 2)) + mode_result(list, second_number, Enum.at(modes, 1))
    storage_parameter = mode_result(list, store_location, Enum.at(modes, 0))
    new_list = List.update_at(list, store_location, fn x -> new_value end)  #this would be modes[0], but you couldn't store in immediate mode
    {current_position + 4, new_list}
  end

  def process(current_position, :multiply, list, modes) do
    first_number = Enum.at(list, current_position + 1)
    second_number = Enum.at(list, current_position + 2)
    store_location = Enum.at(list, current_position + 3)

    IO.puts("take #{first_number} *  #{second_number}, store in position #{}")
    new_value = mode_result(list, first_number, Enum.at(modes, 2)) * mode_result(list, second_number, Enum.at(modes, 1))
    new_list = List.update_at(list, store_location, fn x -> new_value end)
    {current_position + 4, new_list}
  end

  def process(current_position, :input, list, modes) do
    #opcode 3 takes an integer as input
    {input, _} = IO.gets("Input: ") |> Integer.parse


    #store it at a value
    store_position = Enum.at(list, current_position + 1)
    new_list = List.update_at(list, store_position, fn x -> input end) 

    {current_position + 2, new_list}
  end

  def process(current_position, :output, list, modes) do
    value_position = Enum.at(list, current_position + 1)
    value = mode_result(list, value_position, Enum.at(modes, 2))

    IO.puts("Output: #{value}")    
    {current_position + 2, list}
  end

  def process(current_position, :jump_if_true, list, modes) do
    next_instruction = current_position + 3
    first_number = Enum.at(list, current_position + 1)
    first_parameter = mode_result(list, first_number, Enum.at(modes,2))
    if first_parameter > 0 do
      #set current instruction to second_parameter
      sp = mode_result(list, Enum.at(list,current_position + 2), Enum.at(modes, 1))
      {sp, list}
    else
      {next_instruction, list}
    end
  end

  def process(current_position, :jump_if_false, list, modes) do
    next_instruction = current_position + 3

    first_number = Enum.at(list, current_position + 1)
    first_parameter = mode_result(list, first_number, Enum.at(modes,2))
    if first_parameter ==  0 do
      #set current instruction to second_parameter
      sp = mode_result(list, Enum.at(list, current_position + 2), Enum.at(modes, 1))
      {sp, list}
    else
      {next_instruction, list}
    end
  end

  def process(current_position, :less_than, list, modes) do

    first_number = Enum.at(list, current_position + 1)
    second_number = Enum.at(list, current_position + 2)
    store_location = Enum.at(list, current_position + 3)

    first_parameter = mode_result(list, first_number, Enum.at(modes,2))
    second_parameter = mode_result(list,second_number , Enum.at(modes,1))

    if first_parameter < second_parameter  do
      #set current instruction to second_parameter
      new_list = List.update_at(list, store_location, fn x -> 1 end)
      {current_position + 4, new_list}
    else
      new_list = List.update_at(list, store_location, fn x -> 0 end)
      {current_position + 4, new_list}
    end
  end

  def process(current_position, :equals, list, modes) do

    first_number = Enum.at(list, current_position + 1)
    second_number = Enum.at(list, current_position + 2)
    store_location = Enum.at(list, current_position + 3)

    first_parameter = mode_result(list, first_number, Enum.at(modes,2))
    second_parameter = mode_result(list,second_number , Enum.at(modes,1))

    if first_parameter == second_parameter  do
      #set current instruction to second_parameter
      new_list = List.replace_at(list, store_location, 1)
      {current_position + 4, new_list}
    else
      new_list = List.replace_at(list, store_location, 0)
      {current_position + 4, new_list}
    end
  end

  def process(_, :halt, list,_) do
    #no op
    {:halt, list}
  end

end
