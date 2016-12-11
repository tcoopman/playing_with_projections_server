defmodule Quizzy.Generator.Util do
  alias Quizzy.Events.Meta
  alias Quizzy.Generator.IdGenerator

  def filter_from_distribution(distribution, {year, month}) do
    Enum.filter(distribution, fn
         {y, m} -> Timex.compare({y, m, 1}, {year, month, 1}) >= 0 end
     )
  end

  def generate_days({year, month}, number_to_generate) do
    end_of_month = Timex.days_in_month(year, month)

    case number_to_generate do
      0 -> []
      _ ->
        for _ <- 0..number_to_generate do
          day = :rand.uniform(end_of_month)
          hours = Kernel.trunc(:rand.uniform()*24)
          minutes = Kernel.trunc(:rand.uniform()*60)
          seconds = Kernel.trunc(:rand.uniform()*60)
          Timex.to_datetime({{year, month, day}, {hours, minutes, seconds}}, "Europe/Brussels")
        end
    end
  end

  def generate_id do
    IdGenerator.new_id
  end

  def generate_meta(%DateTime{} = timestamp) do
    id = generate_id

    %Meta{id: id, timestamp: timestamp}
  end
  def generate_meta(%Timex.AmbiguousDateTime{before: before}) do
    generate_meta(before)
  end

  def number_to_generate_for_date(distribution, year_month) do
    nb = Map.get(distribution, year_month, 0)

    normalized_number = Kernel.trunc(nb + (:rand.normal * (nb/2)))

    if normalized_number < 0, do: 0, else: normalized_number
  end

  def rand_from_list(list) do
    length = Enum.count list
    index = :rand.uniform(length) -1
    Enum.at(list, index)
  end

  def numbers_to_date_map(%{} = already_distribution, _, _) do
    already_distribution
  end
  def numbers_to_date_map(numbers,{year, month} = start, {year2, month2} = until, result \\ %{}) do
    cond do
      year >= year2 && month >= month2 -> result
      true ->
        {current_number, remaining_numbers} =
          case numbers do
            [] -> {0, []}
            [hd|tail] -> {hd, tail}
          end

        result = Map.put(result, start, current_number)
        new_start_date = Timex.add({year, month, 1}, Timex.Duration.from_days(31)) |> Timex.to_date
        numbers_to_date_map(remaining_numbers, {new_start_date.year, new_start_date.month}, until, result)
    end
  end

  def random_timestamp_after_minutes(timestamp, max_minutes) do
      minutes_to_add = :rand.uniform(max_minutes)
      Timex.add(timestamp, Timex.Duration.from_minutes(minutes_to_add))
  end

  def year_month(timestamp) do
   date = Timex.to_date(timestamp)
   year = date.year
   month = date.month

   {year, month}
  end

end
