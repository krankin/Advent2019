defmodule Day4 do

  @spread  256310..732736

  #note, range is 6 digits, no need to check it right now

  def run() do

  @spread
  |> Enum.filter( fn x -> process(x) end) 
  |> length
  end

  def process(number) do
    has_double?(number)
    && never_decreases?(number)
  end

  def has_double?(number) do
     process_dbl(Integer.digits(number), 0, 1, [])
     |> Enum.any?(fn x -> x == 2 end)
  end

  def never_decreases?(number) do
    process_decrease(Integer.digits(number), 0, true)
  end
  
  def process_decrease([], last_dig, result) do
    result
  end

  def process_decrease([head | tail], last_dig, result) do
    if head < last_dig do
      process_decrease(tail, head, false)
    else
      process_decrease(tail,head,result)
    end
  end

  def process_dbl([], last_dig, recurrance_cnt,  result) do
    result ++ [recurrance_cnt]
  end

  def process_dbl([head|tail], last_dig, recurrance_cnt, result) do

    if head == last_dig do
      process_dbl(tail, head, recurrance_cnt + 1, result)
    else
      process_dbl(tail, head, 1, result ++ [recurrance_cnt])
    end
  end
end
