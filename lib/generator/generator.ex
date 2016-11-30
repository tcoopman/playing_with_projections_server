defmodule Quizzy.Generator do
  alias Quizzy.Events.{PlayerHasRegistered, Meta}

  @player_names [
      "Yasmin Rearick",
      "Carmelita Gangemi",
      "Jenniffer Truehart",
      "Jerrold Ver",
      "Leonore Curry",
      "Rocky Stackpole",
      "Twanna Hadfield",
      "Beula Burt",
      "Alta Oakes",
      "Nicki Bodkin",
      "Junie Manigo",
      "Manual Martell",
      "Roxanne Sharrock",
      "Bunny Ruge",
      "Sylvie Hatton",
      "Rolanda Beavers",
      "Jacalyn Oxley",
      "Matha Nuckles",
      "Barney Keough",
      "Reiko Cadieux",
      "Arthur Manney",
      "Era Longmore",
      "Charise Peterka",
      "Dung Abbot",
      "Pamelia Hausner",
      "Fransisca Moscoso",
      "Karyn Gerson",
      "Zoila Corella",
      "Taren Despres",
      "Kendrick Eley",
      "Shela Lynes",
      "Hoa Martyn",
      "Lakisha Towles",
      "Shauna Rappaport",
      "Myrle Dunham",
      "Leandra Pires",
      "Charlyn Scardina",
      "Jefferey Kealey",
      "Ivey Cespedes",
      "Bree Tison",
      "Damion Wagener",
      "Elicia Abrahamson",
      "Kendall Kibby",
      "Humberto Aumick",
      "Laurena Davey",
      "Delana Kamin",
      "Chaya Treloar",
      "Dale Mealy",
      "Chae Stogner",
      "Mitchell Haun",
    ]


  def distribution do
    %{
      {2014, 1}  => 10,
      {2014, 2}  => 10,
      {2014, 3}  => 10,
      {2014, 4}  => 10,
      {2014, 5}  => 10,
      {2014, 6}  => 10,
      {2014, 7}  => 10,
      {2014, 8}  => 10,
      {2014, 9}  => 10,
      {2014, 10} => 10,
      {2014, 11} => 10,
      {2014, 12} => 10,
      {2015, 1}  => 10,
      {2015, 2}  => 10,
      {2015, 3}  => 10,
      {2015, 4}  => 10,
      {2015, 5}  => 10,
      {2015, 6}  => 10,
      {2015, 7}  => 10,
      {2015, 8}  => 10,
      {2015, 9}  => 10,
      {2015, 10} => 10,
      {2015, 11} => 10,
      {2015, 12} => 10,
      {2016, 1}  => 10,
      {2016, 2}  => 10,
      {2016, 3}  => 10,
      {2016, 4}  => 10,
      {2016, 5}  => 10,
      {2016, 6}  => 10,
      {2016, 7}  => 10,
      {2016, 8}  => 10,
      {2016, 9}  => 10,
      {2016, 10} => 10,
      {2016, 11} => 10,
      {2016, 12} => 10,
      {2017, 1}  => 10,
    }
  end

  def generate_players({year, month}) do
    distribution
    |> Map.keys
    |> Enum.filter(fn
         {y, m} -> Timex.compare({y, m, 1}, {year, month, 1}) >= 0 end
    )
    |> Enum.flat_map(&(generate_days(&1, number_to_generate_for_date(distribution, &1))))
    |> Enum.map(&generate_player/1)
  end

  defp generate_days({year, month}, number_to_generate) do
    end_of_month = Timex.days_in_month(year, month)
    for n <- 1..number_to_generate do
      day = :rand.uniform(end_of_month)
      hours = Kernel.trunc(:rand.uniform()*24)
      minutes = Kernel.trunc(:rand.uniform()*60)
      seconds = Kernel.trunc(:rand.uniform()*60)
      Timex.to_datetime({{year, month, day}, {hours, minutes, seconds}}, "Europe/Brussels")
    end
  end

  defp generate_player(timestamp) do
    meta = generate_meta(timestamp)
    player_id = UUID.uuid4()

    [first_name, last_name] = Enum.at(@player_names, (:rand.uniform(50) - 1)) |> String.split

    %PlayerHasRegistered{meta: meta, player_id: player_id, first_name: first_name, last_name: last_name}
  end

  defp generate_meta(%DateTime{} = timestamp) do
    id = UUID.uuid4()

    %Meta{id: id, timestamp: timestamp}
  end

  defp number_to_generate_for_date(distribution, year_month) do
    nb = Map.get(distribution, year_month, 0)

    normalized_number = Kernel.trunc(nb + (:rand.normal * (nb/2)))

    if normalized_number < 0, do: 0, else: normalized_number
  end
end
