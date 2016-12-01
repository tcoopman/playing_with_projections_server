defmodule Quizzy.Generator.Util do
  alias Quizzy.Events.Meta

  def filter_from_distribution(distribution, {year, month}) do
    Enum.filter(distribution, fn
         {y, m} -> Timex.compare({y, m, 1}, {year, month, 1}) >= 0 end
     )
  end

  def generate_days({year, month}, number_to_generate) do
    end_of_month = Timex.days_in_month(year, month)

    for n <- 1..number_to_generate do
      day = :rand.uniform(end_of_month)
      hours = Kernel.trunc(:rand.uniform()*24)
      minutes = Kernel.trunc(:rand.uniform()*60)
      seconds = Kernel.trunc(:rand.uniform()*60)
      Timex.to_datetime({{year, month, day}, {hours, minutes, seconds}}, "Europe/Brussels")
    end

  end

  def generate_meta(%DateTime{} = timestamp) do
    id = UUID.uuid4()

    %Meta{id: id, timestamp: timestamp}
  end

  def number_to_generate_for_date(distribution, year_month) do
    nb = Map.get(distribution, year_month, 0)

    normalized_number = Kernel.trunc(nb + (:rand.normal * (nb/2)))

    if normalized_number < 0, do: 0, else: normalized_number
  end
end
